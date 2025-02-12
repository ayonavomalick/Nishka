codeunit 50005 NIMPOSCheckGenJnlLineBackgr
{
    trigger OnRun()
    var
        TempErrorMessage: Record "NIMError Message";
        Args: Dictionary of [Text, Text];
        Results: Dictionary of [Text, Text];
    begin
        Args := Page.GetBackgroundParameters();

        RunCheck(Args, TempErrorMessage);

        PackErrorMessagesToResults(TempErrorMessage, Results);

        Page.SetBackgroundTaskResult(Results);
    end;

    var
        BackgroundErrorHandlingMgt: Codeunit "Background Error Handling Mgt.";
        DocumentOutOfBalanceErr: Label 'Document No. %1 is out of balance by %2', Comment = '%1 - document number, %2 = amount';

    procedure RunCheck(Args: Dictionary of [Text, Text]; var TempErrorMessage: Record "NIMError Message")
    var
        GenJnlLine: Record "Gen. Journal Line";
        TempGenJnlLine: Record "Gen. Journal Line" temporary;
        ErrorHandlingParameters: Record "Error Handling Parameters";
    begin
        ErrorHandlingParameters.FromArgs(Args);

        GenJnlLine.SetRange("Journal Template Name", ErrorHandlingParameters."Journal Template Name");
        GenJnlLine.SetRange("Journal Batch Name", ErrorHandlingParameters."Journal Batch Name");
        if ErrorHandlingParameters."Full Batch Check" then
            CheckGenJnlLines(GenJnlLine, TempErrorMessage)
        else
            if ErrorHandlingParameters."Line Modified" then begin
                CheckDocument(GenJnlLine, ErrorHandlingParameters."Previous Document No.", ErrorHandlingParameters."Previous Posting Date", TempErrorMessage);

                if ErrorHandlingParameters.IsGenJnlDocumentChanged() then
                    CheckDocument(GenJnlLine, ErrorHandlingParameters."Document No.", ErrorHandlingParameters."Posting Date", TempErrorMessage);
            end;

        BackgroundErrorHandlingMgt.GetDeletedDocumentsFromArgs(Args, TempGenJnlLine);
        if TempGenJnlLine.FindSet() then
            repeat
                CheckDocument(GenJnlLine, TempGenJnlLine."Document No.", TempGenJnlLine."Posting Date", TempErrorMessage);
            until TempGenJnlLine.Next() = 0;
    end;

    local procedure CheckDocument(var GenJnlLine: Record "Gen. Journal Line"; DocumentNo: Code[20]; PostingDate: Date; var TempErrorMessage: Record "NIMError Message")
    begin
        GenJnlLine.SetRange("Document No.", DocumentNo);
        GenJnlLine.SetRange("Posting Date", PostingDate);
        CheckGenJnlLines(GenJnlLine, TempErrorMessage);
    end;

    local procedure CheckGenJnlLines(var GenJnlLine: Record "Gen. Journal Line"; var TempErrorMessage: Record "NIMError Message")
    begin
        if GenJnlLine.FindSet() then
            repeat
                CheckGenJnlLine(GenJnlLine, TempErrorMessage);
            until GenJnlLine.Next() = 0;
    end;

    local procedure CheckGenJnlLine(var GenJnlLine: Record "Gen. Journal Line"; var TempErrorMessage: Record "NIMError Message")
    begin
        RunGenJnlCheckLineCodeunit(GenJnlLine, TempErrorMessage);
        CheckGenJnlLineDocBalance(GenJnlLine, TempErrorMessage);

        OnAfterCheckGenJnlLine(GenJnlLine, TempErrorMessage);
    end;

    [ErrorBehavior(ErrorBehavior::Collect)]
    local procedure RunGenJnlCheckLineCodeunit(GenJnlLine: Record "Gen. Journal Line"; var TempErrorMessage: Record "NIMError Message")
    var
        TempLineErrorMessage: Record "Error Message" temporary;
        GenJnlCheckLine: Codeunit "Gen. Jnl.-Check Line";
        ErrorMessageMgt: Codeunit "Error Message Management";
    begin
        GenJnlCheckLine.SetLogErrorMode(true);

        if GenJnlCheckLine.Run(GenJnlLine) then begin
            GenJnlCheckLine.GetErrors(TempLineErrorMessage);
            ErrorMessageMgt.CollectErrors(TempLineErrorMessage);
            CopyErrorsToPOSEntryErrorBuffer(TempLineErrorMessage, TempErrorMessage);
        end else begin
            InsertTempLineErrorMessage(
                TempLineErrorMessage,
                GenJnlLine.RecordId(),
                0,
                GetLastErrorText(),
                false);

            CopyErrorsToPOSEntryErrorBuffer(TempLineErrorMessage, TempErrorMessage);
        end;
    end;

    local procedure CheckGenJnlLineDocBalance(GenJnlLine: Record "Gen. Journal Line"; var TempErrorMessage: Record "NIMError Message")
    var
        TempLineErrorMessage: Record "Error Message" temporary;
        DocumentBalance: Decimal;
        Description: Text;
    begin
        GenJnlLine.SetRange("Journal Template Name", GenJnlLine."Journal Template Name");
        GenJnlLine.SetRange("Journal Batch Name", GenJnlLine."Journal Batch Name");
        DocumentBalance := GenJnlLine.GetDocumentBalance(GenJnlLine);
        if DocumentBalance <> 0 then begin
            Description := StrSubstNo(DocumentOutOfBalanceErr, GenJnlLine."Document No.", DocumentBalance);
            InsertTempLineErrorMessage(
                TempLineErrorMessage,
                GenJnlLine.RecordId(),
                GenJnlLine.FieldNo("Balance (LCY)"),
                Description,
                DocumentBalanceErrorExists(Description, TempErrorMessage));

            TempErrorMessage.Reset();
            CopyErrorsToPOSEntryErrorBuffer(TempLineErrorMessage, TempErrorMessage);
        end;
    end;

    local procedure DocumentBalanceErrorExists(Description: Text; var TempErrorMessage: Record "NIMError Message"): Boolean
    begin
        TempErrorMessage.SetRange("Message", Description);
        exit(not TempErrorMessage.IsEmpty());
    end;

    local procedure InsertTempLineErrorMessage(var TempLineErrorMessage: Record "Error Message" temporary; ContextRecordId: RecordId; ContextFieldNo: Integer; Description: Text; Duplicate: Boolean)
    begin
        TempLineErrorMessage."Record ID" := ContextRecordId;
        TempLineErrorMessage."Field Number" := ContextFieldNo;
        TempLineErrorMessage."Table Number" := Database::"Gen. Journal Line";
        TempLineErrorMessage."Context Record ID" := ContextRecordId;
        TempLineErrorMessage."Context Field Number" := ContextFieldNo;
        TempLineErrorMessage."Context Table Number" := Database::"Gen. Journal Line";
        TempLineErrorMessage."Message" := CopyStr(Description, 1, MaxStrLen(TempLineErrorMessage."Message"));
        TempLineErrorMessage.Duplicate := Duplicate;
        TempLineErrorMessage.Insert();
    end;

    local procedure CopyErrorsToPOSEntryErrorBuffer(var TempLineErrorMessage: Record "Error Message" temporary; var TempErrorMessage: Record "NIMError Message")
    var
        ID: Integer;
    begin
        If TempErrorMessage.FindLast() then;
        ID := TempErrorMessage.ID + 1;

        if TempLineErrorMessage.FindSet() then
            repeat
                TempErrorMessage.TransferFields(TempLineErrorMessage);
                TempErrorMessage.ID := ID;
                TempErrorMessage.Insert();
                ID += 1;
            until TempLineErrorMessage.Next() = 0;
    end;

    local procedure PackErrorMessagesToResults(var TempErrorMessage: Record "NIMError Message"; var Results: Dictionary of [Text, Text])
    var
        
        JSON: Text;
    begin
        if TempErrorMessage.FindSet() then
            repeat
                JSON := ErrorMessage2JSON(TempErrorMessage);
                Results.Add(Format(TempErrorMessage.ID), JSON);
            until TempErrorMessage.Next() = 0;
    end;


    procedure ErrorMessage2JSON(var ErrorMessage: Record "NIMError Message") JSON: Text
    var
        JObject: JsonObject;
    begin
        JObject.Add('RecordId', format(ErrorMessage."Record ID"));
        JObject.Add('FieldNumber', ErrorMessage."Field Number");
        JObject.Add('TableNumber', ErrorMessage."Table Number");
        JObject.Add('Description', ErrorMessage."Message");
        JObject.Add('ContextRecordId', format(ErrorMessage."Context Record ID"));
        JObject.Add('ContextFieldNumber', ErrorMessage."Context Field Number");
        JObject.Add('ContextTableNumber', ErrorMessage."Context Table Number");
        JObject.Add('AdditionalInfo', ErrorMessage."Additional Information");
        JObject.Add('SupportURL', ErrorMessage."Support Url");
        JObject.Add('CallStack', ErrorMessage.GetErrorCallStack());
        JObject.Add('Duplicate', ErrorMessage.Duplicate);
        JObject.WriteTo(JSON);
    end;


    [IntegrationEvent(false, false)]
    local procedure OnAfterCheckGenJnlLine(var GenJnlLine: Record "Gen. Journal Line"; var TempErrorMessage: Record "NIMError Message")
    begin
    end;
}