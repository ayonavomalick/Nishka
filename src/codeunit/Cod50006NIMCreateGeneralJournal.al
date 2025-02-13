codeunit 50006 NIMCreateGeneralJournal
{

    trigger OnRun()
    begin
        CreateGeneralJournal();
    end;

    local procedure CreateGeneralJournal()
    var
        POSEntry: Record NIMPOSEntry;
        QueryPOSEntry: Query NIMQueryPOSEntry;

        IsHandled: Boolean;
    begin
        OnBeforeCreateGeneralJournal(IsHandled);
        if IsHandled then
            exit;
        Clear(QueryPOSEntry);
        GetGeneralLedgerSet();
        DeleteGenJournalLines(QueryPOSEntry, GeneralLedgerSetup);
        if QueryPOSEntry.Open() then
            while QueryPOSEntry.Read() do begin
                case QueryPOSEntry.Entry_Type of
                    QueryPOSEntry.Entry_Type::"Sale Invoice":
                        begin

                            POSEntry.Reset();
                            POSEntry.SetRange("Entry Type", QueryPOSEntry.Entry_Type);
                            POSEntry.SetRange("Document Type", QueryPOSEntry.Document_Type);
                            POSEntry.SetRange("Document No.", QueryPOSEntry.Document_No_);
                            if not POSEntry.IsEmpty then
                                if POSEntry.FindSet(false) then begin
                                    CreateSalesInvoiceGeneralJournal(POSEntry, GeneralLedgerSetup);
                                    Commit();
                                end;
                        end;
                    QueryPOSEntry.Entry_Type::"Sale Return":
                        begin

                            POSEntry.Reset();
                            POSEntry.SetRange("Entry Type", QueryPOSEntry.Entry_Type);
                            POSEntry.SetRange("Document Type", QueryPOSEntry.Document_Type);
                            POSEntry.SetRange("Document No.", QueryPOSEntry.Document_No_);
                            if not POSEntry.IsEmpty then begin
                                CreateSalesReturnGeneralJournal(POSEntry, GeneralLedgerSetup);
                                Commit();
                            end;
                        end;
                    QueryPOSEntry.Entry_Type::"Purchase Invoice":
                        begin

                            POSEntry.Reset();
                            POSEntry.SetRange("Entry Type", QueryPOSEntry.Entry_Type);
                            POSEntry.SetRange("Document Type", QueryPOSEntry.Document_Type);
                            POSEntry.SetRange("Document No.", QueryPOSEntry.Document_No_);
                            if not POSEntry.IsEmpty then begin
                                CreatePurchaseInvoiceGeneralJournal(POSEntry, GeneralLedgerSetup);
                                Commit();
                            end;
                        end;
                    QueryPOSEntry.Entry_Type::"Purchase Return":
                        begin

                            POSEntry.Reset();
                            POSEntry.SetRange("Entry Type", QueryPOSEntry.Entry_Type);
                            POSEntry.SetRange("Document Type", QueryPOSEntry.Document_Type);
                            POSEntry.SetRange("Document No.", QueryPOSEntry.Document_No_);
                            if not POSEntry.IsEmpty then begin
                                CreatePurchaseReturnGeneralJournal(POSEntry, GeneralLedgerSetup);
                                Commit();
                            end;
                        end;

                    QueryPOSEntry.Entry_Type::Advance:
                        begin

                            POSEntry.Reset();
                            POSEntry.SetRange("Entry Type", QueryPOSEntry.Entry_Type);
                            POSEntry.SetRange("Document Type", QueryPOSEntry.Document_Type);
                            POSEntry.SetRange("Document No.", QueryPOSEntry.Document_No_);
                            if not POSEntry.IsEmpty then begin
                                CreateAdvanceGeneralJournal(POSEntry, GeneralLedgerSetup);
                                Commit();
                            end;
                        end;

                    QueryPOSEntry.Entry_Type::Refund:
                        begin

                            POSEntry.Reset();
                            POSEntry.SetRange("Entry Type", QueryPOSEntry.Entry_Type);
                            POSEntry.SetRange("Document Type", QueryPOSEntry.Document_Type);
                            POSEntry.SetRange("Document No.", QueryPOSEntry.Document_No_);
                            if not POSEntry.IsEmpty then begin
                                CreateRefundGeneralJournal(POSEntry, GeneralLedgerSetup);
                                Commit();
                            end;
                        end;
                    QueryPOSEntry.Entry_Type::JournalPayment:
                        begin

                            POSEntry.Reset();
                            POSEntry.SetRange("Entry Type", QueryPOSEntry.Entry_Type);
                            POSEntry.SetRange("Document Type", QueryPOSEntry.Document_Type);
                            POSEntry.SetRange("Document No.", QueryPOSEntry.Document_No_);
                            if not POSEntry.IsEmpty then begin
                                CreatePaymentGeneralJournal(POSEntry, GeneralLedgerSetup);
                                Commit();

                            end;
                        end;

                    QueryPOSEntry.Entry_Type::"EMI Receive(GSS)":
                        begin

                            POSEntry.Reset();
                            POSEntry.SetRange("Entry Type", QueryPOSEntry.Entry_Type);
                            POSEntry.SetRange("Document Type", QueryPOSEntry.Document_Type);
                            POSEntry.SetRange("Document No.", QueryPOSEntry.Document_No_);
                            if not POSEntry.IsEmpty then begin
                                CreateEMIReceiveGeneralJournal(POSEntry, GeneralLedgerSetup);
                                Commit();
                            end;
                        end;
                    QueryPOSEntry.Entry_Type::"Daily Expense (POS)":
                        begin
                            POSEntry.Reset();
                            POSEntry.SetRange("Entry Type", QueryPOSEntry.Entry_Type);
                            POSEntry.SetRange("Document Type", QueryPOSEntry.Document_Type);
                            POSEntry.SetRange("Document No.", QueryPOSEntry.Document_No_);
                            if not POSEntry.IsEmpty then begin
                                CreateDailyExpenseGeneralJournal(POSEntry, GeneralLedgerSetup);
                                Commit();
                            end;
                        end;
                    QueryPOSEntry.Entry_Type::"OGP Purchase (Old Gold)":
                        begin
                            POSEntry.Reset();
                            POSEntry.SetRange("Entry Type", QueryPOSEntry.Entry_Type);
                            POSEntry.SetRange("Document Type", QueryPOSEntry.Document_Type);
                            POSEntry.SetRange("Document No.", QueryPOSEntry.Document_No_);
                            if not POSEntry.IsEmpty then begin
                                CreateOGPPurchaseGeneralJournal(POSEntry, GeneralLedgerSetup);
                                Commit();
                            end;
                        end;
                    QueryPOSEntry.Entry_Type::"WO Issue":
                        begin

                            POSEntry.Reset();
                            POSEntry.SetRange("Entry Type", QueryPOSEntry.Entry_Type);
                            POSEntry.SetRange("Document Type", QueryPOSEntry.Document_Type);
                            POSEntry.SetRange("Document No.", QueryPOSEntry.Document_No_);
                            if not POSEntry.IsEmpty then begin
                                CreateWOIssueGeneralJournal(POSEntry, GeneralLedgerSetup);
                                Commit();
                            end;
                        end;
                    QueryPOSEntry.Entry_Type::"Refinery Receive Posted":
                        begin
                            POSEntry.Reset();
                            POSEntry.SetRange("Entry Type", QueryPOSEntry.Entry_Type);
                            POSEntry.SetRange("Document Type", QueryPOSEntry.Document_Type);
                            POSEntry.SetRange("Document No.", QueryPOSEntry.Document_No_);
                            if not POSEntry.IsEmpty then begin
                                CreateRefineryReceivePostedGeneralJournal(POSEntry, GeneralLedgerSetup);
                                Commit();
                            end;
                        end;
                    QueryPOSEntry.Entry_Type::"Cash Transfer Posted":
                        begin
                            POSEntry.Reset();
                            POSEntry.SetRange("Entry Type", QueryPOSEntry.Entry_Type);
                            POSEntry.SetRange("Document Type", QueryPOSEntry.Document_Type);
                            POSEntry.SetRange("Document No.", QueryPOSEntry.Document_No_);
                            if not POSEntry.IsEmpty then begin
                                CreateCashTransferPostedGeneralJournal(POSEntry, GeneralLedgerSetup);
                                Commit();

                            end;
                        end;


                    QueryPOSEntry.Entry_Type::Receive:
                        begin
                            DeleteGenJournalLines(QueryPOSEntry, GeneralLedgerSetup);
                            POSEntry.Reset();
                            POSEntry.SetRange("Entry Type", QueryPOSEntry.Entry_Type);
                            POSEntry.SetRange("Document Type", QueryPOSEntry.Document_Type);
                            POSEntry.SetRange("Document No.", QueryPOSEntry.Document_No_);
                            if not POSEntry.IsEmpty then begin
                                CreateReceiveGeneralJournal(POSEntry, GeneralLedgerSetup);
                                Commit();
                            end;
                        end;
                    QueryPOSEntry.Entry_Type::Contra:
                        begin
                            DeleteGenJournalLines(QueryPOSEntry, GeneralLedgerSetup);
                            POSEntry.Reset();
                            POSEntry.SetRange("Entry Type", QueryPOSEntry.Entry_Type);
                            POSEntry.SetRange("Document Type", QueryPOSEntry.Document_Type);
                            POSEntry.SetRange("Document No.", QueryPOSEntry.Document_No_);
                            if not POSEntry.IsEmpty then begin
                                CreateContraGeneralJournal(POSEntry, GeneralLedgerSetup);
                                Commit();
                            end;
                        end;

                    QueryPOSEntry.Entry_Type::General:
                        begin
                            DeleteGenJournalLines(QueryPOSEntry, GeneralLedgerSetup);
                            POSEntry.Reset();
                            POSEntry.SetRange("Entry Type", QueryPOSEntry.Entry_Type);
                            POSEntry.SetRange("Document Type", QueryPOSEntry.Document_Type);
                            POSEntry.SetRange("Document No.", QueryPOSEntry.Document_No_);
                            if not POSEntry.IsEmpty then
                                if POSEntry.FindSet() then begin

                                    CreateGenGeneralJournal(POSEntry, GeneralLedgerSetup);
                                    Commit();


                                end;
                        end;

                end;
                PostPOSEntries(QueryPOSEntry);
                ClearBackgroundPostingInfo(TempGenJournalLine);
            end;


        OnAfterCreateGeneralJournal();
    end;


    [TryFunction]
    local procedure PostPOSEntries(var QueryPOSEntry: Query NIMQueryPOSEntry)
    var
        POSAPIMgmnt: Codeunit NIMPOSAPIMgmnt;
        POSEntry: Record NIMPOSEntry;
        IsHandled: Boolean;
    begin
        OnBeforePostPOSEntries(QueryPOSEntry, POSAPIMgmnt, IsHandled);
        if IsHandled then
            exit;

        TempGenJournalLine.SetRange("Journal Template Name", TempGenJournalLine."Journal Template Name");
        TempGenJournalLine.SetRange("Journal Batch Name", TempGenJournalLine."Journal Batch Name");
        TempGenJournalLine.SetRange("Document No.", QueryPOSEntry.Document_No_);
        TempGenJournalLine.FindSet();
        SetJobQueueStatus(TempGenJournalLine, TempGenJournalLine."Job Queue Status"::Posting);

        if not CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post Batch", TempGenJournalLine) then begin
            SetJobQueueStatus(TempGenJournalLine, TempGenJournalLine."Job Queue Status"::Error);
            POSEntry.Reset();
            POSEntry.SetRange("Entry Type", QueryPOSEntry.Entry_Type);
            POSEntry.SetRange("Document Type", QueryPOSEntry.Document_Type);
            POSEntry.SetRange("Document No.", QueryPOSEntry.Document_No_);
            if not POSEntry.IsEmpty then
                if POSEntry.FindSet() then begin
                    POSEntry.ModifyAll("Error Info", CopyStr(GetLastErrorText(), 1, 200));
                end;

        end else
            POSAPIMgmnt.PostDocumentStatus(QueryPOSEntry.Document_No_);

        OnAfterPostPOSEntries(QueryPOSEntry, POSAPIMgmnt);
    end;


    local procedure ClearBackgroundPostingInfo(var TempGenJrnlLine: Record "Gen. Journal Line")
    var
        EmptyGuid: Guid;
        IsHandled: Boolean;
    begin
        OnBeforeClearBackgroundPostingInfo(TempGenJournalLine, IsHandled);
        if IsHandled then
            exit;
        TempGenJrnlLine.SetRange("Journal Template Name", TempGenJrnlLine."Journal Template Name");
        TempGenJrnlLine.SetRange("Journal Batch Name", TempGenJrnlLine."Journal Batch Name");
        TempGenJrnlLine.SetRange("Document No.", TempGenJrnlLine."Document No.");
        TempGenJrnlLine.ModifyAll("Job Queue Status", TempGenJrnlLine."Job Queue Status"::" ");
        TempGenJrnlLine.ModifyAll("Job Queue Entry ID", EmptyGuid);
        TempGenJrnlLine.ModifyAll("Print Posted Documents", false);

        OnAfterClearBackgroundPostingInfo(TempGenJournalLine);
    end;

    local procedure SetJobQueueStatus(var TempGenJournalLine: Record "Gen. Journal Line"; NewStatus: Enum "Document Job Queue Status")
    var
        IsHandled: Boolean;
    begin
        OnBeforeSetJobQueueStatus(TempGenJournalLine, NewStatus, IsHandled);
        if IsHandled then
            exit;
        TempGenJournalLine.LockTable();
        if TempGenJournalLine.Find() then begin
            TempGenJournalLine.SetRange("Journal Template Name", TempGenJournalLine."Journal Template Name");
            TempGenJournalLine.SetRange("Journal Batch Name", TempGenJournalLine."Journal Batch Name");
            TempGenJournalLine.SetRange("Document No.", TempGenJournalLine."Document No.");
            TempGenJournalLine.ModifyAll("Job Queue Status", NewStatus);
            Commit();
        end;


        OnAfterSetJobQueueStatus(TempGenJournalLine, NewStatus);
    end;


    local procedure GetGeneralLedgerSet()
    var
        IsHandled: Boolean;
    begin
        OnBeforeGetGeneralLedgerSet(IsHandled);
        if IsHandled then
            exit;

        if GeneralLedgerSetup.Get() then begin
            GeneralLedgerSetup.TestField("Journal Template Name");
            GeneralLedgerSetup.TestField("Journal Batch Name");
        end;

        OnAfterGetGeneralLedgerSet();
    end;


    local procedure GetNextLineNo(var GeneralLedgerSetup: Record "General Ledger Setup") LastLineNo: Integer
    var
        LastGenJournalLine: Record "Gen. Journal Line";
        IsHandled: Boolean;
    begin
        OnBeforeGetNextLineNo(GeneralLedgerSetup, LastLineNo, IsHandled);
        if IsHandled then
            exit;
        LastGenJournalLine.Reset();
        LastGenJournalLine.SetCurrentKey("Journal Template Name", "Journal Batch Name", "Line No.");
        LastGenJournalLine.SetRange("Journal Template Name", GeneralLedgerSetup."Journal Template Name");
        LastGenJournalLine.SetRange("Journal Batch Name", GeneralLedgerSetup."Journal Batch Name");
        if not LastGenJournalLine.IsEmpty then begin
            if LastGenJournalLine.FindLast() then
                LastLineNo := LastGenJournalLine."Line No." + 10000;
        end else
            LastLineNo := 10000;


        OnAfterGetNextLineNo(GeneralLedgerSetup, LastLineNo);
    end;


    local procedure DeleteGenJournalLines(var QueryPOSEntry: Query NIMQueryPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    var
        IsHandled: Boolean;
    begin
        OnBeforeDeleteGenJournalLines(QueryPOSEntry, GeneralLedgerSetup, IsHandled);
        if IsHandled then
            exit;

        TempGenJournalLine.Reset();
        TempGenJournalLine.SetRange("Journal Template Name", GeneralLedgerSetup."Journal Template Name");
        TempGenJournalLine.SetRange("Journal Batch Name", GeneralLedgerSetup."Journal Batch Name");
        TempGenJournalLine.DeleteAll(false);



        OnAfterDeleteGenJournalLines(QueryPOSEntry, GeneralLedgerSetup);
    end;

    local procedure CreateSalesInvoiceGeneralJournal(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    var
        IsHandled: Boolean;
    begin
        OnBeforeCreateSalesInvoiceGeneralJournal(POSEntry, GeneralLedgerSetup, IsHandled);
        if IsHandled then
            exit;
        if POSEntry.FindSet() then
            repeat
                CreateSalesInvoiceGeneralJournalLines(POSEntry, GeneralLedgerSetup);
            until POSEntry.Next() = 0;



        OnAfterCreateSalesInvoiceGeneralJournal(POSEntry, GeneralLedgerSetup);
    end;

    local procedure CreateSalesInvoiceGeneralJournalLines(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    var
        DimensionManagement: Codeunit DimensionManagement;
        NextLines: Integer;
        IsHandled: Boolean;
    begin
        OnBeforeCreateSalesInvoiceGeneralJournalLines(POSEntry, GeneralLedgerSetup, IsHandled);
        if IsHandled then
            exit;
        NextLines := GetNextLineNo(GeneralLedgerSetup);
        TempGenJournalLine.init();
        TempGenJournalLine."Journal Template Name" := GeneralLedgerSetup."Journal Template Name";
        TempGenJournalLine.Validate("Journal Batch Name", GeneralLedgerSetup."Journal Batch Name");
        TempGenJournalLine."Line No." := NextLines;
        TempGenJournalLine.Validate("Posting Date", POSEntry."Posting Date");

        TempGenJournalLine.Validate("Document Type", POSEntry."Document Type");
        TempGenJournalLine.Validate("Document No.", POSEntry."Document No.");
        TempGenJournalLine.Validate("Account Type", POSEntry."Account Type");
        TempGenJournalLine.Validate("Account No.", POSEntry."Account No.");

        TempGenJournalLine.Validate(Amount, POSEntry.AmountCur);
        TempGenJournalLine.Validate("Shortcut Dimension 1 Code", POSEntry."Global Dimension 1");
        TempGenJournalLine.Validate("Shortcut Dimension 2 Code", POSEntry."Global Dimension 2");
        TempGenJournalLine.ValidateShortcutDimCode(3, POSEntry."Shortcut Dimension 3");
        TempGenJournalLine.ValidateShortcutDimCode(4, POSEntry."Shortcut Dimension 4");
        TempGenJournalLine.NIMPosEntry := true;
        TempGenJournalLine."Reference Document No." := POSEntry."Reference Document No.";
        TempGenJournalLine."Reference Line No." := POSEntry."Reference Line No.";
        TempGenJournalLine.Insert(false);


        OnAfterCreateSalesInvoiceGeneralJournalLines(POSEntry, GeneralLedgerSetup);
    end;

    local procedure CreateSalesReturnGeneralJournal(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    var
        IsHandled: Boolean;
    begin
        OnBeforeCreateSalesReturnGeneralJournal(POSEntry, GeneralLedgerSetup, IsHandled);
        if IsHandled then
            exit;

        if POSEntry.FindSet(false) then
            repeat
                CreateSalesReturnGeneralJournalLines(POSEntry, GeneralLedgerSetup);
            until POSEntry.Next() = 0;

        OnAfterCreateSalesReturnGeneralJournal(POSEntry, GeneralLedgerSetup);
    end;

    local procedure CreateSalesReturnGeneralJournalLines(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    var


        IsHandled: Boolean;
    begin
        OnBeforeCreateSalesReturnGeneralJournalLines(POSEntry, GeneralLedgerSetup, IsHandled);
        if IsHandled then
            exit;

        NextLines := GetNextLineNo(GeneralLedgerSetup);
        TempGenJournalLine.init();
        TempGenJournalLine."Journal Template Name" := GeneralLedgerSetup."Journal Template Name";
        TempGenJournalLine.Validate("Journal Batch Name", GeneralLedgerSetup."Journal Batch Name");
        TempGenJournalLine."Line No." := NextLines;
        TempGenJournalLine.Validate("Posting Date", POSEntry."Posting Date");

        TempGenJournalLine.Validate("Document Type", POSEntry."Document Type");
        TempGenJournalLine.Validate("Document No.", POSEntry."Document No.");
        TempGenJournalLine.Validate("Account Type", POSEntry."Account Type");
        TempGenJournalLine.Validate("Account No.", POSEntry."Account No.");

        TempGenJournalLine.Validate(Amount, POSEntry.AmountCur);
        TempGenJournalLine.Validate("Shortcut Dimension 1 Code", POSEntry."Global Dimension 1");
        TempGenJournalLine.Validate("Shortcut Dimension 2 Code", POSEntry."Global Dimension 2");
        TempGenJournalLine.ValidateShortcutDimCode(3, POSEntry."Shortcut Dimension 3");
        TempGenJournalLine.ValidateShortcutDimCode(4, POSEntry."Shortcut Dimension 4");
        TempGenJournalLine.NIMPosEntry := true;
        TempGenJournalLine."Reference Document No." := POSEntry."Reference Document No.";
        TempGenJournalLine."Reference Line No." := POSEntry."Reference Line No.";
        TempGenJournalLine.Insert(false);

        OnAfterCreateSalesReturnGeneralJournalLines(POSEntry, GeneralLedgerSetup);
    end;

    local procedure CreatePurchaseInvoiceGeneralJournal(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    var
        IsHandled: Boolean;
    begin
        OnBeforeCreatePurchaseInvoiceGeneralJournal(POSEntry, GeneralLedgerSetup, IsHandled);
        if IsHandled then
            exit;
        if POSEntry.FindSet() then
            repeat
                CreatePurchaseInvoiceGeneralJournalLines(POSEntry, GeneralLedgerSetup);
            until POSEntry.Next() = 0;


        OnAfterCreatePurchaseInvoiceGeneralJournal(POSEntry, GeneralLedgerSetup);
    end;

    local procedure CreatePurchaseInvoiceGeneralJournalLines(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    var
        IsHandled: Boolean;
    begin
        OnBeforeCreatePurchaseInvoiceGeneralJournalLines(POSEntry, GeneralLedgerSetup, IsHandled);
        if IsHandled then
            exit;

        NextLines := GetNextLineNo(GeneralLedgerSetup);
        TempGenJournalLine.init();
        TempGenJournalLine."Journal Template Name" := GeneralLedgerSetup."Journal Template Name";
        TempGenJournalLine.Validate("Journal Batch Name", GeneralLedgerSetup."Journal Batch Name");
        TempGenJournalLine."Line No." := NextLines;
        TempGenJournalLine.Validate("Posting Date", POSEntry."Posting Date");
        //TempGenJournalLine.SetUpNewLine();
        TempGenJournalLine.Validate("Document Type", POSEntry."Document Type");
        TempGenJournalLine.Validate("Document No.", POSEntry."Document No.");
        TempGenJournalLine.Validate("Account Type", POSEntry."Account Type");
        TempGenJournalLine.Validate("Account No.", POSEntry."Account No.");
        TempGenJournalLine.Validate(Amount, POSEntry.AmountCur);
        TempGenJournalLine.Validate("Shortcut Dimension 1 Code", POSEntry."Global Dimension 1");
        TempGenJournalLine.Validate("Shortcut Dimension 2 Code", POSEntry."Global Dimension 2");
        TempGenJournalLine.ValidateShortcutDimCode(3, POSEntry."Shortcut Dimension 3");
        TempGenJournalLine.ValidateShortcutDimCode(4, POSEntry."Shortcut Dimension 4");
        TempGenJournalLine.NIMPosEntry := true;
        TempGenJournalLine."Reference Document No." := POSEntry."Reference Document No.";
        TempGenJournalLine."Reference Line No." := POSEntry."Reference Line No.";
        TempGenJournalLine.Insert(false);

        OnAfterCreatePurchaseInvoiceGeneralJournalLines(POSEntry, GeneralLedgerSetup);
    end;

    local procedure CreatePurchaseReturnGeneralJournal(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    var
        IsHandled: Boolean;
    begin
        OnBeforeCreatePurchaseReturnGeneralJournal(POSEntry, GeneralLedgerSetup, IsHandled);
        if IsHandled then
            exit;
        if POSEntry.FindSet() then
            repeat
                CreatePurchaseReturnGeneralJournalLines(POSEntry, GeneralLedgerSetup);
            until POSEntry.Next() = 0;


        OnAfterCreatePurchaseReturnGeneralJournal(POSEntry, GeneralLedgerSetup);
    end;

    local procedure CreatePurchaseReturnGeneralJournalLines(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    var
        IsHandled: Boolean;
    begin
        OnBeforeCreatePurchaseReturnGeneralJournalLines(POSEntry, GeneralLedgerSetup, IsHandled);
        if IsHandled then
            exit;

        NextLines := GetNextLineNo(GeneralLedgerSetup);
        TempGenJournalLine.init();
        TempGenJournalLine."Journal Template Name" := GeneralLedgerSetup."Journal Template Name";
        TempGenJournalLine.Validate("Journal Batch Name", GeneralLedgerSetup."Journal Batch Name");
        TempGenJournalLine."Line No." := NextLines;
        TempGenJournalLine.Validate("Posting Date", POSEntry."Posting Date");
        //TempGenJournalLine.SetUpNewLine();
        TempGenJournalLine.Validate("Document Type", POSEntry."Document Type");
        TempGenJournalLine.Validate("Document No.", POSEntry."Document No.");
        TempGenJournalLine.Validate("Account Type", POSEntry."Account Type");
        TempGenJournalLine.Validate("Account No.", POSEntry."Account No.");

        TempGenJournalLine.Validate(Amount, POSEntry.AmountCur);
        TempGenJournalLine.Validate("Shortcut Dimension 1 Code", POSEntry."Global Dimension 1");
        TempGenJournalLine.Validate("Shortcut Dimension 2 Code", POSEntry."Global Dimension 2");
        TempGenJournalLine.ValidateShortcutDimCode(3, POSEntry."Shortcut Dimension 3");
        TempGenJournalLine.ValidateShortcutDimCode(4, POSEntry."Shortcut Dimension 4");
        TempGenJournalLine.NIMPosEntry := true;
        TempGenJournalLine."Reference Document No." := POSEntry."Reference Document No.";
        TempGenJournalLine."Reference Line No." := POSEntry."Reference Line No.";
        TempGenJournalLine.Insert(false);


        OnAfterCreatePurchaseReturnGeneralJournalLines(POSEntry, GeneralLedgerSetup);
    end;

    local procedure CreateAdvanceGeneralJournal(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    var
        IsHandled: Boolean;
    begin
        OnBeforeCreateAdvanceGeneralJournal(POSEntry, GeneralLedgerSetup, IsHandled);
        if IsHandled then
            exit;

        if POSEntry.FindSet() then
            repeat
                CreateAdvanceGeneralJournalLines(POSEntry, GeneralLedgerSetup);
            until POSEntry.Next() = 0;

        OnAfterCreateAdvanceGeneralJournal(POSEntry, GeneralLedgerSetup);
    end;

    local procedure CreateAdvanceGeneralJournalLines(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    var
        IsHandled: Boolean;
    begin
        OnBeforeCreateAdvanceGeneralJournalLines(POSEntry, GeneralLedgerSetup, IsHandled);
        if IsHandled then
            exit;

        NextLines := GetNextLineNo(GeneralLedgerSetup);
        TempGenJournalLine.init();
        TempGenJournalLine."Journal Template Name" := GeneralLedgerSetup."Journal Template Name";
        TempGenJournalLine.Validate("Journal Batch Name", GeneralLedgerSetup."Journal Batch Name");
        TempGenJournalLine."Line No." := NextLines;
        TempGenJournalLine.Validate("Posting Date", POSEntry."Posting Date");
        TempGenJournalLine.Validate("Document Type", POSEntry."Document Type");
        TempGenJournalLine.Validate("Document No.", POSEntry."Document No.");
        TempGenJournalLine.Validate("Account Type", POSEntry."Account Type");
        TempGenJournalLine.Validate("Account No.", POSEntry."Account No.");
        TempGenJournalLine.Validate(Amount, POSEntry.AmountCur);
        TempGenJournalLine.Validate("Shortcut Dimension 1 Code", POSEntry."Global Dimension 1");
        TempGenJournalLine.Validate("Shortcut Dimension 2 Code", POSEntry."Global Dimension 2");
        TempGenJournalLine.ValidateShortcutDimCode(3, POSEntry."Shortcut Dimension 3");
        TempGenJournalLine.ValidateShortcutDimCode(4, POSEntry."Shortcut Dimension 4");
        TempGenJournalLine.NIMPosEntry := true;
        TempGenJournalLine."Reference Document No." := POSEntry."Reference Document No.";
        TempGenJournalLine."Reference Line No." := POSEntry."Reference Line No.";
        TempGenJournalLine.Insert(false);

        OnAfterCreateAdvanceGeneralJournalLines(POSEntry, GeneralLedgerSetup);
    end;

    local procedure CreateRefundGeneralJournal(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    var
        IsHandled: Boolean;
    begin
        OnBeforeCreateRefundGeneralJournal(POSEntry, GeneralLedgerSetup, IsHandled);
        if IsHandled then
            exit;


        if POSEntry.FindSet() then
            repeat
                CreateRefundGeneralJournalLines(POSEntry, GeneralLedgerSetup);
            until POSEntry.Next() = 0;

        OnAfterCreateRefundGeneralJournal(POSEntry, GeneralLedgerSetup);
    end;

    local procedure CreateRefundGeneralJournalLines(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    var
        IsHandled: Boolean;
    begin
        OnBeforeCreateRefundGeneralJournalLines(POSEntry, GeneralLedgerSetup, IsHandled);
        if IsHandled then
            exit;


        NextLines := GetNextLineNo(GeneralLedgerSetup);
        TempGenJournalLine.init();
        TempGenJournalLine."Journal Template Name" := GeneralLedgerSetup."Journal Template Name";
        TempGenJournalLine.Validate("Journal Batch Name", GeneralLedgerSetup."Journal Batch Name");
        TempGenJournalLine."Line No." := NextLines;
        TempGenJournalLine.Validate("Posting Date", POSEntry."Posting Date");
        TempGenJournalLine.Validate("Document Type", POSEntry."Document Type");
        TempGenJournalLine.Validate("Document No.", POSEntry."Document No.");
        TempGenJournalLine.Validate("Account Type", POSEntry."Account Type");
        TempGenJournalLine.Validate("Account No.", POSEntry."Account No.");

        TempGenJournalLine.Validate(Amount, POSEntry.AmountCur);
        TempGenJournalLine.Validate("Shortcut Dimension 1 Code", POSEntry."Global Dimension 1");
        TempGenJournalLine.Validate("Shortcut Dimension 2 Code", POSEntry."Global Dimension 2");
        TempGenJournalLine.ValidateShortcutDimCode(3, POSEntry."Shortcut Dimension 3");
        TempGenJournalLine.ValidateShortcutDimCode(4, POSEntry."Shortcut Dimension 4");
        TempGenJournalLine.NIMPosEntry := true;
        TempGenJournalLine."Reference Document No." := POSEntry."Reference Document No.";
        TempGenJournalLine."Reference Line No." := POSEntry."Reference Line No.";
        TempGenJournalLine.Insert(false);

        OnAfterCreateRefundGeneralJournalLines(POSEntry, GeneralLedgerSetup);
    end;

    local procedure CreatePaymentGeneralJournal(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    var
        IsHandled: Boolean;
    begin
        OnBeforeCreatePaymentGeneralJournal(POSEntry, GeneralLedgerSetup, IsHandled);
        if IsHandled then
            exit;


        if POSEntry.FindSet() then
            repeat
                CreatePaymentGeneralJournalLines(POSEntry, GeneralLedgerSetup);
            until POSEntry.Next() = 0;

        OnAfterCreatePaymentGeneralJournal(POSEntry, GeneralLedgerSetup);
    end;

    local procedure CreatePaymentGeneralJournalLines(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    var
        IsHandled: Boolean;
    begin
        OnBeforeCreatePaymentGeneralJournalLines(POSEntry, GeneralLedgerSetup, IsHandled);
        if IsHandled then
            exit;

        NextLines := GetNextLineNo(GeneralLedgerSetup);
        TempGenJournalLine.init();
        TempGenJournalLine."Journal Template Name" := GeneralLedgerSetup."Journal Template Name";
        TempGenJournalLine.Validate("Journal Batch Name", GeneralLedgerSetup."Journal Batch Name");
        TempGenJournalLine."Line No." := NextLines;
        TempGenJournalLine.Validate("Posting Date", POSEntry."Posting Date");

        TempGenJournalLine.Validate("Document Type", POSEntry."Document Type");
        TempGenJournalLine.Validate("Document No.", POSEntry."Document No.");
        TempGenJournalLine.Validate("Account Type", POSEntry."Account Type");
        TempGenJournalLine.Validate("Account No.", POSEntry."Account No.");

        TempGenJournalLine.Validate(Amount, POSEntry.AmountCur);
        TempGenJournalLine.Validate("Shortcut Dimension 1 Code", POSEntry."Global Dimension 1");
        TempGenJournalLine.Validate("Shortcut Dimension 2 Code", POSEntry."Global Dimension 2");
        TempGenJournalLine.ValidateShortcutDimCode(3, POSEntry."Shortcut Dimension 3");
        TempGenJournalLine.ValidateShortcutDimCode(4, POSEntry."Shortcut Dimension 4");
        TempGenJournalLine.NIMPosEntry := true;
        TempGenJournalLine."Reference Document No." := POSEntry."Reference Document No.";
        TempGenJournalLine."Reference Line No." := POSEntry."Reference Line No.";
        TempGenJournalLine.Insert();


        OnAfterCreatePaymentGeneralJournalLines(POSEntry, GeneralLedgerSetup);
    end;

    local procedure CreateEMIReceiveGeneralJournal(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    var
        IsHandled: Boolean;
    begin
        OnBeforeCreateEMIReceiveGeneralJournal(POSEntry, GeneralLedgerSetup, IsHandled);
        if IsHandled then
            exit;

        if POSEntry.FindSet() then
            repeat
                CreateEMIReceiveGeneralJournalLines(POSEntry, GeneralLedgerSetup);
            until POSEntry.Next() = 0;

        OnAfterCreateEMIReceiveGeneralJournal(POSEntry, GeneralLedgerSetup);
    end;

    local procedure CreateEMIReceiveGeneralJournalLines(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    var
        IsHandled: Boolean;
    begin
        OnBeforeCreateEMIReceiveGeneralJournalLines(POSEntry, GeneralLedgerSetup, IsHandled);
        if IsHandled then
            exit;

        NextLines := GetNextLineNo(GeneralLedgerSetup);
        TempGenJournalLine.init();
        TempGenJournalLine."Journal Template Name" := GeneralLedgerSetup."Journal Template Name";
        TempGenJournalLine.Validate("Journal Batch Name", GeneralLedgerSetup."Journal Batch Name");
        TempGenJournalLine."Line No." := NextLines;
        TempGenJournalLine.Validate("Posting Date", POSEntry."Posting Date");
        TempGenJournalLine.Validate("Document Type", POSEntry."Document Type");
        TempGenJournalLine.Validate("Document No.", POSEntry."Document No.");
        TempGenJournalLine.Validate("Account Type", POSEntry."Account Type");
        TempGenJournalLine.Validate("Account No.", POSEntry."Account No.");

        TempGenJournalLine.Validate(Amount, POSEntry.AmountCur);
        TempGenJournalLine.Validate("Shortcut Dimension 1 Code", POSEntry."Global Dimension 1");
        TempGenJournalLine.Validate("Shortcut Dimension 2 Code", POSEntry."Global Dimension 2");
        TempGenJournalLine.ValidateShortcutDimCode(3, POSEntry."Shortcut Dimension 3");
        TempGenJournalLine.ValidateShortcutDimCode(4, POSEntry."Shortcut Dimension 4");
        TempGenJournalLine.NIMPosEntry := true;
        TempGenJournalLine."Reference Document No." := POSEntry."Reference Document No.";
        TempGenJournalLine."Reference Line No." := POSEntry."Reference Line No.";
        TempGenJournalLine.Insert(false);

        OnAfterCreateEMIReceiveGeneralJournalLines(POSEntry, GeneralLedgerSetup);
    end;

    local procedure CreateDailyExpenseGeneralJournal(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    var
        IsHandled: Boolean;
    begin
        OnBeforeCreateDailyExpenseGeneralJournal(POSEntry, GeneralLedgerSetup, IsHandled);
        if IsHandled then
            exit;

        if POSEntry.FindSet() then
            repeat
                CreateDailyExpenseGeneralJournalLines(POSEntry, GeneralLedgerSetup);
            until POSEntry.Next() = 0;

        OnAfterCreateDailyExpenseGeneralJournal(POSEntry, GeneralLedgerSetup);
    end;

    local procedure CreateDailyExpenseGeneralJournalLines(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    var
        IsHandled: Boolean;
    begin
        OnBeforeCreateDailyExpenseGeneralJournalLines(POSEntry, GeneralLedgerSetup, IsHandled);
        if IsHandled then
            exit;

        NextLines := GetNextLineNo(GeneralLedgerSetup);
        TempGenJournalLine.init();
        TempGenJournalLine."Journal Template Name" := GeneralLedgerSetup."Journal Template Name";
        TempGenJournalLine.Validate("Journal Batch Name", GeneralLedgerSetup."Journal Batch Name");
        TempGenJournalLine."Line No." := NextLines;
        TempGenJournalLine.Validate("Posting Date", POSEntry."Posting Date");
        TempGenJournalLine.Validate("Document Type", POSEntry."Document Type");
        TempGenJournalLine.Validate("Document No.", POSEntry."Document No.");
        TempGenJournalLine.Validate("Account Type", POSEntry."Account Type");
        TempGenJournalLine.Validate("Account No.", POSEntry."Account No.");

        TempGenJournalLine.Validate(Amount, POSEntry.AmountCur);
        TempGenJournalLine.Validate("Shortcut Dimension 1 Code", POSEntry."Global Dimension 1");
        TempGenJournalLine.Validate("Shortcut Dimension 2 Code", POSEntry."Global Dimension 2");
        TempGenJournalLine.ValidateShortcutDimCode(3, POSEntry."Shortcut Dimension 3");
        TempGenJournalLine.ValidateShortcutDimCode(4, POSEntry."Shortcut Dimension 4");
        TempGenJournalLine.NIMPosEntry := true;
        TempGenJournalLine."Reference Document No." := POSEntry."Reference Document No.";
        TempGenJournalLine."Reference Line No." := POSEntry."Reference Line No.";
        TempGenJournalLine.Insert(false);

        OnAfterCreateDailyExpenseGeneralJournalLines(POSEntry, GeneralLedgerSetup);
    end;

    local procedure CreateOGPPurchaseGeneralJournal(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    var
        IsHandled: Boolean;
    begin
        OnBeforeCreateOGPPurchaseGeneralJournal(POSEntry, GeneralLedgerSetup, IsHandled);
        if IsHandled then
            exit;

        if POSEntry.FindSet() then
            repeat
                CreateOGPPurchaseGeneralJournalLines(POSEntry, GeneralLedgerSetup);
            until POSEntry.Next() = 0;

        OnAfterCreateOGPPurchaseGeneralJournal(POSEntry, GeneralLedgerSetup);
    end;

    local procedure CreateOGPPurchaseGeneralJournalLines(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    var
        IsHandled: Boolean;
    begin
        OnBeforeCreateOGPPurchaseGeneralJournalLines(POSEntry, GeneralLedgerSetup, IsHandled);
        if IsHandled then
            exit;

        NextLines := GetNextLineNo(GeneralLedgerSetup);
        TempGenJournalLine.init();
        TempGenJournalLine."Journal Template Name" := GeneralLedgerSetup."Journal Template Name";
        TempGenJournalLine.Validate("Journal Batch Name", GeneralLedgerSetup."Journal Batch Name");
        TempGenJournalLine."Line No." := NextLines;
        TempGenJournalLine.Validate("Posting Date", POSEntry."Posting Date");

        TempGenJournalLine.Validate("Document Type", POSEntry."Document Type");
        TempGenJournalLine.Validate("Document No.", POSEntry."Document No.");
        TempGenJournalLine.Validate("Account Type", POSEntry."Account Type");
        TempGenJournalLine.Validate("Account No.", POSEntry."Account No.");

        TempGenJournalLine.Validate(Amount, POSEntry.AmountCur);
        TempGenJournalLine.Validate("Shortcut Dimension 1 Code", POSEntry."Global Dimension 1");
        TempGenJournalLine.Validate("Shortcut Dimension 2 Code", POSEntry."Global Dimension 2");
        TempGenJournalLine.ValidateShortcutDimCode(3, POSEntry."Shortcut Dimension 3");
        TempGenJournalLine.ValidateShortcutDimCode(4, POSEntry."Shortcut Dimension 4");
        TempGenJournalLine.NIMPosEntry := true;
        TempGenJournalLine."Reference Document No." := POSEntry."Reference Document No.";
        TempGenJournalLine."Reference Line No." := POSEntry."Reference Line No.";
        TempGenJournalLine.Insert(false);

        OnAfterCreateOGPPurchaseGeneralJournalLines(POSEntry, GeneralLedgerSetup);
    end;

    local procedure CreateWOIssueGeneralJournal(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    var
        IsHandled: Boolean;
    begin
        OnBeforeCreateWOIssueGeneralJournal(POSEntry, GeneralLedgerSetup, IsHandled);
        if IsHandled then
            exit;
        if POSEntry.FindSet() then
            repeat
                CreateWOIssueGeneralJournalLines(POSEntry, GeneralLedgerSetup);
            until POSEntry.Next() = 0;

        OnAfterCreateWOIssueGeneralJournal(POSEntry, GeneralLedgerSetup);
    end;

    local procedure CreateWOIssueGeneralJournalLines(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    var
        IsHandled: Boolean;
    begin
        OnBeforeCreateWOIssueGeneralJournalLines(POSEntry, GeneralLedgerSetup, IsHandled);
        if IsHandled then
            exit;

        NextLines := GetNextLineNo(GeneralLedgerSetup);
        TempGenJournalLine.init();
        TempGenJournalLine."Journal Template Name" := GeneralLedgerSetup."Journal Template Name";
        TempGenJournalLine.Validate("Journal Batch Name", GeneralLedgerSetup."Journal Batch Name");
        TempGenJournalLine."Line No." := NextLines;
        TempGenJournalLine.Validate("Posting Date", POSEntry."Posting Date");
        //TempGenJournalLine.SetUpNewLine();
        TempGenJournalLine.Validate("Document Type", POSEntry."Document Type");
        TempGenJournalLine.Validate("Document No.", POSEntry."Document No.");
        TempGenJournalLine.Validate("Account Type", POSEntry."Account Type");
        TempGenJournalLine.Validate("Account No.", POSEntry."Account No.");

        TempGenJournalLine.Validate(Amount, POSEntry.AmountCur);
        TempGenJournalLine.Validate("Shortcut Dimension 1 Code", POSEntry."Global Dimension 1");
        TempGenJournalLine.Validate("Shortcut Dimension 2 Code", POSEntry."Global Dimension 2");
        TempGenJournalLine.ValidateShortcutDimCode(3, POSEntry."Shortcut Dimension 3");
        TempGenJournalLine.ValidateShortcutDimCode(4, POSEntry."Shortcut Dimension 4");
        TempGenJournalLine.NIMPosEntry := true;
        TempGenJournalLine."Reference Document No." := POSEntry."Reference Document No.";
        TempGenJournalLine."Reference Line No." := POSEntry."Reference Line No.";
        TempGenJournalLine.Insert(false);

        OnAfterCreateWOIssueGeneralJournalLines(POSEntry, GeneralLedgerSetup);
    end;

    local procedure CreateRefineryReceivePostedGeneralJournal(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    var
        IsHandled: Boolean;
    begin
        OnBeforeCreateRefineryReceivePostedGeneralJournal(POSEntry, GeneralLedgerSetup, IsHandled);
        if IsHandled then
            exit;

        if POSEntry.FindSet() then
            repeat
                CreateRefineryReceivePostedGeneralJournalLines(POSEntry, GeneralLedgerSetup);
            until POSEntry.Next() = 0;

        OnAfterCreateRefineryReceivePostedGeneralJournal(POSEntry, GeneralLedgerSetup);
    end;

    local procedure CreateRefineryReceivePostedGeneralJournalLines(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    var
        IsHandled: Boolean;
    begin
        OnBeforeCreateRefineryReceivePostedGeneralJournalLines(POSEntry, GeneralLedgerSetup, IsHandled);
        if IsHandled then
            exit;

        NextLines := GetNextLineNo(GeneralLedgerSetup);
        TempGenJournalLine.init();
        TempGenJournalLine."Journal Template Name" := GeneralLedgerSetup."Journal Template Name";
        TempGenJournalLine.Validate("Journal Batch Name", GeneralLedgerSetup."Journal Batch Name");
        TempGenJournalLine."Line No." := NextLines;
        TempGenJournalLine.Validate("Posting Date", POSEntry."Posting Date");
        TempGenJournalLine.Validate("Document Type", POSEntry."Document Type");
        TempGenJournalLine.Validate("Document No.", POSEntry."Document No.");
        TempGenJournalLine.Validate("Account Type", POSEntry."Account Type");
        TempGenJournalLine.Validate("Account No.", POSEntry."Account No.");
        TempGenJournalLine.Validate(Amount, POSEntry.AmountCur);
        TempGenJournalLine.Validate("Shortcut Dimension 1 Code", POSEntry."Global Dimension 1");
        TempGenJournalLine.Validate("Shortcut Dimension 2 Code", POSEntry."Global Dimension 2");
        TempGenJournalLine.ValidateShortcutDimCode(3, POSEntry."Shortcut Dimension 3");
        TempGenJournalLine.ValidateShortcutDimCode(4, POSEntry."Shortcut Dimension 4");
        TempGenJournalLine.NIMPosEntry := true;
        TempGenJournalLine."Reference Document No." := POSEntry."Reference Document No.";
        TempGenJournalLine."Reference Line No." := POSEntry."Reference Line No.";
        TempGenJournalLine.Insert(false);

        OnAfterCreateRefineryReceivePostedGeneralJournalLines(POSEntry, GeneralLedgerSetup);
    end;

    local procedure CreateCashTransferPostedGeneralJournal(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    var
        IsHandled: Boolean;
    begin
        OnBeforeCreateCashTransferPostedGeneralJournal(POSEntry, GeneralLedgerSetup, IsHandled);
        if IsHandled then
            exit;

        if POSEntry.FindSet() then
            repeat
                CreateCashTransferPostedGeneralJournalLines(POSEntry, GeneralLedgerSetup);
            until POSEntry.Next() = 0;

        OnAfterCreateCashTransferPostedGeneralJournal(POSEntry, GeneralLedgerSetup);
    end;

    local procedure CreateCashTransferPostedGeneralJournalLines(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    var
        IsHandled: Boolean;
    begin
        OnBeforeCreateCashTransferPostedGeneralJournalLines(POSEntry, GeneralLedgerSetup, IsHandled);
        if IsHandled then
            exit;

        NextLines := GetNextLineNo(GeneralLedgerSetup);
        TempGenJournalLine.init();
        TempGenJournalLine."Journal Template Name" := GeneralLedgerSetup."Journal Template Name";
        TempGenJournalLine.Validate("Journal Batch Name", GeneralLedgerSetup."Journal Batch Name");
        TempGenJournalLine."Line No." := NextLines;
        TempGenJournalLine.Validate("Posting Date", POSEntry."Posting Date");

        TempGenJournalLine.Validate("Document Type", POSEntry."Document Type");
        TempGenJournalLine.Validate("Document No.", POSEntry."Document No.");
        TempGenJournalLine.Validate("Account Type", POSEntry."Account Type");
        TempGenJournalLine.Validate("Account No.", POSEntry."Account No.");

        TempGenJournalLine.Validate(Amount, POSEntry.AmountCur);
        TempGenJournalLine.Validate("Shortcut Dimension 1 Code", POSEntry."Global Dimension 1");
        TempGenJournalLine.Validate("Shortcut Dimension 2 Code", POSEntry."Global Dimension 2");
        TempGenJournalLine.ValidateShortcutDimCode(3, POSEntry."Shortcut Dimension 3");
        TempGenJournalLine.ValidateShortcutDimCode(4, POSEntry."Shortcut Dimension 4");
        TempGenJournalLine.NIMPosEntry := true;
        TempGenJournalLine."Reference Document No." := POSEntry."Reference Document No.";
        TempGenJournalLine."Reference Line No." := POSEntry."Reference Line No.";
        TempGenJournalLine.Insert(false);

        OnAfterCreateCashTransferPostedGeneralJournalLines(POSEntry, GeneralLedgerSetup);
    end;

    local procedure CreateReceiveGeneralJournal(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    var
        IsHandled: Boolean;
    begin
        OnBeforeCreateReceiveGeneralJournal(POSEntry, GeneralLedgerSetup, IsHandled);
        if IsHandled then
            exit;

        if POSEntry.FindSet() then
            repeat
                CreateReceiveGeneralJournalLines(POSEntry, GeneralLedgerSetup);
            until POSEntry.Next() = 0;

        OnAfterCreateReceiveGeneralJournal(POSEntry, GeneralLedgerSetup);
    end;

    local procedure CreateReceiveGeneralJournalLines(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    var
        IsHandled: Boolean;
    begin
        OnBeforeCreateReceiveGeneralJournalLines(POSEntry, GeneralLedgerSetup, IsHandled);
        if IsHandled then
            exit;

        NextLines := GetNextLineNo(GeneralLedgerSetup);
        TempGenJournalLine.init();
        TempGenJournalLine."Journal Template Name" := GeneralLedgerSetup."Journal Template Name";
        TempGenJournalLine.Validate("Journal Batch Name", GeneralLedgerSetup."Journal Batch Name");
        TempGenJournalLine."Line No." := NextLines;
        TempGenJournalLine.Validate("Posting Date", POSEntry."Posting Date");
        TempGenJournalLine.Validate("Document Type", POSEntry."Document Type");
        TempGenJournalLine.Validate("Document No.", POSEntry."Document No.");
        TempGenJournalLine.Validate("Account Type", POSEntry."Account Type");
        TempGenJournalLine.Validate("Account No.", POSEntry."Account No.");

        TempGenJournalLine.Validate(Amount, POSEntry.AmountCur);
        TempGenJournalLine.Validate("Shortcut Dimension 1 Code", POSEntry."Global Dimension 1");
        TempGenJournalLine.Validate("Shortcut Dimension 2 Code", POSEntry."Global Dimension 2");
        TempGenJournalLine.ValidateShortcutDimCode(3, POSEntry."Shortcut Dimension 3");
        TempGenJournalLine.ValidateShortcutDimCode(4, POSEntry."Shortcut Dimension 4");
        TempGenJournalLine.NIMPosEntry := true;
        TempGenJournalLine."Reference Document No." := POSEntry."Reference Document No.";
        TempGenJournalLine."Reference Line No." := POSEntry."Reference Line No.";
        TempGenJournalLine.Insert(false);

        OnAfterCreateReceiveGeneralJournalLines(POSEntry, GeneralLedgerSetup);
    end;

    local procedure CreateContraGeneralJournal(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    var
        IsHandled: Boolean;
    begin
        OnBeforeCreateContraGeneralJournal(POSEntry, GeneralLedgerSetup, IsHandled);
        if IsHandled then
            exit;

        if POSEntry.FindSet() then
            repeat
                CreateContraGeneralJournalLines(POSEntry, GeneralLedgerSetup);
            until POSEntry.Next() = 0;

        OnAfterCreateContraGeneralJournal(POSEntry, GeneralLedgerSetup);
    end;

    local procedure CreateContraGeneralJournalLines(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    var
        IsHandled: Boolean;
    begin
        OnBeforeCreateContraGeneralJournalLines(POSEntry, GeneralLedgerSetup, IsHandled);
        if IsHandled then
            exit;

        NextLines := GetNextLineNo(GeneralLedgerSetup);
        TempGenJournalLine.init();
        TempGenJournalLine."Journal Template Name" := GeneralLedgerSetup."Journal Template Name";
        TempGenJournalLine.Validate("Journal Batch Name", GeneralLedgerSetup."Journal Batch Name");
        TempGenJournalLine."Line No." := NextLines;
        TempGenJournalLine.Validate("Posting Date", POSEntry."Posting Date");
        TempGenJournalLine.Validate("Document Type", POSEntry."Document Type");
        TempGenJournalLine.Validate("Document No.", POSEntry."Document No.");
        TempGenJournalLine.Validate("Account Type", POSEntry."Account Type");
        TempGenJournalLine.Validate("Account No.", POSEntry."Account No.");

        TempGenJournalLine.Validate(Amount, POSEntry.AmountCur);
        TempGenJournalLine.Validate("Shortcut Dimension 1 Code", POSEntry."Global Dimension 1");
        TempGenJournalLine.Validate("Shortcut Dimension 2 Code", POSEntry."Global Dimension 2");
        TempGenJournalLine.ValidateShortcutDimCode(3, POSEntry."Shortcut Dimension 3");
        TempGenJournalLine.ValidateShortcutDimCode(4, POSEntry."Shortcut Dimension 4");
        TempGenJournalLine.NIMPosEntry := true;
        TempGenJournalLine."Reference Document No." := POSEntry."Reference Document No.";
        TempGenJournalLine."Reference Line No." := POSEntry."Reference Line No.";
        TempGenJournalLine.Insert(false);

        OnAfterCreateContraGeneralJournalLines(POSEntry, GeneralLedgerSetup);
    end;

    local procedure CreateGenGeneralJournal(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    var
        IsHandled: Boolean;
    begin
        OnBeforeCreateGenGeneralJournal(POSEntry, GeneralLedgerSetup, IsHandled);
        if IsHandled then
            exit;

        if POSEntry.FindSet() then
            repeat
                CreateGenGeneralJournalLines(POSEntry, GeneralLedgerSetup);
            until POSEntry.Next() = 0;

        OnAfterCreateGenGeneralJournal(POSEntry, GeneralLedgerSetup);
    end;

    local procedure CreateGenGeneralJournalLines(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    var
        IsHandled: Boolean;
    begin
        OnBeforeCreateGenGeneralJournalLines(POSEntry, GeneralLedgerSetup, IsHandled);
        if IsHandled then
            exit;
        NextLines := GetNextLineNo(GeneralLedgerSetup);
        TempGenJournalLine.init();
        TempGenJournalLine."Journal Template Name" := GeneralLedgerSetup."Journal Template Name";
        TempGenJournalLine.Validate("Journal Batch Name", GeneralLedgerSetup."Journal Batch Name");
        TempGenJournalLine."Line No." := NextLines;
        TempGenJournalLine.Validate("Posting Date", POSEntry."Posting Date");

        TempGenJournalLine.Validate("Document Type", POSEntry."Document Type");
        TempGenJournalLine.Validate("Document No.", POSEntry."Document No.");
        TempGenJournalLine.Validate("Account Type", POSEntry."Account Type");
        TempGenJournalLine.Validate("Account No.", POSEntry."Account No.");

        TempGenJournalLine.Validate(Amount, POSEntry.AmountCur);
        TempGenJournalLine.Validate("Shortcut Dimension 1 Code", POSEntry."Global Dimension 1");
        TempGenJournalLine.Validate("Shortcut Dimension 2 Code", POSEntry."Global Dimension 2");
        TempGenJournalLine.ValidateShortcutDimCode(3, POSEntry."Shortcut Dimension 3");
        TempGenJournalLine.ValidateShortcutDimCode(4, POSEntry."Shortcut Dimension 4");
        TempGenJournalLine.NIMPosEntry := true;
        TempGenJournalLine."Reference Document No." := POSEntry."Reference Document No.";
        TempGenJournalLine."Reference Line No." := POSEntry."Reference Line No.";
        TempGenJournalLine.Insert(false);

        OnAfterCreateGenGeneralJournalLines(POSEntry, GeneralLedgerSetup);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateGeneralJournal(var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateGeneralJournal()
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetGeneralLedgerSet(var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterGetGeneralLedgerSet()
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeDeleteGenJournalLines(var QueryPOSEntry: Query NIMQueryPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterDeleteGenJournalLines(var QueryPOSEntry: Query NIMQueryPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePostPOSEntries(var QueryPOSEntry: Query NIMQueryPOSEntry; var POSAPIMgmnt: Codeunit NIMPOSAPIMgmnt; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeSetJobQueueStatus(var TempGenJournalLine: Record "Gen. Journal Line"; NewStatus: Enum System.Threading."Document Job Queue Status"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterSetJobQueueStatus(var TempGenJournalLine: Record "Gen. Journal Line"; NewStatus: Enum System.Threading."Document Job Queue Status")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPostPOSEntries(var QueryPOSEntry: Query NIMQueryPOSEntry; var POSAPIMgmnt: Codeunit NIMPOSAPIMgmnt)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeClearBackgroundPostingInfo(var TempGenJournalLine: Record "Gen. Journal Line"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterClearBackgroundPostingInfo(var TempGenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateSalesInvoiceGeneralJournal(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateSalesInvoiceGeneralJournal(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateSalesInvoiceGeneralJournalLines(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateSalesInvoiceGeneralJournalLines(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetNextLineNo(var GeneralLedgerSetup: Record "General Ledger Setup"; var LastLineNo: Integer; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterGetNextLineNo(var GeneralLedgerSetup: Record "General Ledger Setup"; var LastLineNo: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateSalesReturnGeneralJournal(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateSalesReturnGeneralJournal(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateSalesReturnGeneralJournalLines(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateSalesReturnGeneralJournalLines(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreatePurchaseInvoiceGeneralJournal(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreatePurchaseInvoiceGeneralJournal(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreatePurchaseInvoiceGeneralJournalLines(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreatePurchaseInvoiceGeneralJournalLines(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreatePurchaseReturnGeneralJournal(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreatePurchaseReturnGeneralJournal(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreatePurchaseReturnGeneralJournalLines(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreatePurchaseReturnGeneralJournalLines(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateAdvanceGeneralJournal(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateAdvanceGeneralJournal(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateAdvanceGeneralJournalLines(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateAdvanceGeneralJournalLines(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateRefundGeneralJournal(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateRefundGeneralJournal(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateRefundGeneralJournalLines(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateRefundGeneralJournalLines(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreatePaymentGeneralJournal(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreatePaymentGeneralJournal(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreatePaymentGeneralJournalLines(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreatePaymentGeneralJournalLines(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateEMIReceiveGeneralJournal(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateEMIReceiveGeneralJournal(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateEMIReceiveGeneralJournalLines(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateEMIReceiveGeneralJournalLines(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateDailyExpenseGeneralJournal(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateDailyExpenseGeneralJournal(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateDailyExpenseGeneralJournalLines(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateDailyExpenseGeneralJournalLines(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateOGPPurchaseGeneralJournal(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateOGPPurchaseGeneralJournal(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateOGPPurchaseGeneralJournalLines(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateOGPPurchaseGeneralJournalLines(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateWOIssueGeneralJournal(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateWOIssueGeneralJournal(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateWOIssueGeneralJournalLines(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateWOIssueGeneralJournalLines(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateRefineryReceivePostedGeneralJournal(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateRefineryReceivePostedGeneralJournal(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateRefineryReceivePostedGeneralJournalLines(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateRefineryReceivePostedGeneralJournalLines(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateCashTransferPostedGeneralJournal(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateCashTransferPostedGeneralJournal(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateCashTransferPostedGeneralJournalLines(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateCashTransferPostedGeneralJournalLines(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateReceiveGeneralJournal(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateReceiveGeneralJournal(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateReceiveGeneralJournalLines(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateReceiveGeneralJournalLines(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateContraGeneralJournal(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateContraGeneralJournal(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateContraGeneralJournalLines(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateContraGeneralJournalLines(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateGenGeneralJournal(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateGenGeneralJournal(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateGenGeneralJournalLines(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateGenGeneralJournalLines(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    begin
    end;

    var

        GeneralLedgerSetup: Record "General Ledger Setup";
        TempGenJournalLine: Record "Gen. Journal Line";
        NextLines: Integer;

}