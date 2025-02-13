codeunit 51100 NIMCodGenJnlPostLine
{

    local procedure UpdateTheDocumentInMagic(var POSEntry: Record NIMPOSEntry)
    var
        IsHandled: Boolean;
    begin
        OnBeforeUpdateTheDocumentInMagic(POSEntry, IsHandled);
        if IsHandled then
            exit;

        //Write the API logic to update the document in Magic pos.


        OnAfterUpdateTheDocumentInMagic(POSEntry);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", OnAfterGLFinishPosting, '', false, false)]
    local procedure OnAfterGLFinishPosting(var GenJnlLine: Record "Gen. Journal Line")
    var
        POSEntry: Record NIMPOSEntry;
        PostedPOSEntry: Record NIMPostedPOSEntry;
    begin
        //Create Posted POS entry and delete the POS entry.
        if GenJnlLine.NIMPosEntry then begin
            PostedPOSEntry.Reset();
            PostedPOSEntry.SetCurrentKey("Reference Document No.", "Reference Line No.");
            PostedPOSEntry.SetRange("Reference Document No.", GenJnlLine."Reference Document No.");
            PostedPOSEntry.SetRange("Reference Line No.", GenJnlLine."Reference Line No.");
            if PostedPOSEntry.IsEmpty then begin
                POSEntry.Reset();
                POSEntry.SetCurrentKey("Reference Document No.", "Reference Line No.");
                POSEntry.SetRange("Reference Document No.", GenJnlLine."Reference Document No.");
                POSEntry.SetRange("Reference Line No.", GenJnlLine."Reference Line No.");
                if not POSEntry.IsEmpty then
                    if POSEntry.FindFirst() then begin
                        PostedPOSEntry.Init();
                        PostedPOSEntry.TransferFields(POSEntry);
                        PostedPOSEntry."Posted Status" := PostedStatus::Posted;
                        PostedPOSEntry.Insert();
                        POSEntry.Delete();
                        UpdateTheDocumentInMagic(POSEntry);
                    end;

            end;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeUpdateTheDocumentInMagic(POSEntry: Record NIMPOSEntry; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterUpdateTheDocumentInMagic(POSEntry: Record NIMPOSEntry)
    begin
    end;

    var
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        PostedStatus: Enum "Posted Status";
}