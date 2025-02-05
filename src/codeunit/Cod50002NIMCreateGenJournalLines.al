codeunit 50002 NIMCreateGenJournalLines

{
    Permissions =
        TableData "Gen. Journal Batch" = rimd,
        TableData "Gen. Journal Line" = rimd;

    trigger OnRun()
    begin
        ProcessGenJournalLines();
    end;

    var

        GeneralLedgerSetup: Record "General Ledger Setup";
        TempGenJournalLine: Record "Gen. Journal Line";



    /// <summary>
    /// ProcessGenJournalLines.
    /// </summary>
    /// <param name="POSEntry">VAR Record NIMPOSEntry.</param>
    /// 
    procedure ProcessGenJournalLines()
    var
        POSEntry: Record NIMPOSEntry;
        QueryPOSEntry: Query NIMQueryPOSEntry;
        POSAPIMgmnt: Codeunit NIMPOSAPIMgmnt;
        IsHandled: Boolean;
    begin
        OnBeforeProcessGenJournalLines(POSEntry, IsHandled);
        if IsHandled then
            exit;
        Clear(QueryPOSEntry);
        GetGeneralLedgerSet();
        if QueryPOSEntry.Open() then
            while QueryPOSEntry.Read() do
                case QueryPOSEntry.Entry_Type of
                    //Sale Invoice
                    QueryPOSEntry.Entry_Type::"Sale Invoice":
                        begin
                            DeleteGenJournalLines(QueryPOSEntry, GeneralLedgerSetup);
                            POSEntry.Reset();
                            POSEntry.SetRange("Entry Type", QueryPOSEntry.Entry_Type);
                            POSEntry.SetRange("Document Type", QueryPOSEntry.Document_Type);
                            POSEntry.SetRange("Document No.", QueryPOSEntry.Document_No_);
                            if not POSEntry.IsEmpty then
                                if POSEntry.FindSet() then begin

                                    CreateSalesInvoiceGenJournalLines(POSEntry, GeneralLedgerSetup);
                                    Commit();
                                    PostPOSEntries(QueryPOSEntry, POSAPIMgmnt);

                                    ClearBackgroundPostingInfo(TempGenJournalLine);
                                end;
                        end;
                    //Sale Return
                    QueryPOSEntry.Entry_Type::"Sale Return":
                        begin
                            DeleteGenJournalLines(QueryPOSEntry, GeneralLedgerSetup);
                            POSEntry.Reset();
                            POSEntry.SetRange("Entry Type", QueryPOSEntry.Entry_Type);
                            POSEntry.SetRange("Document Type", QueryPOSEntry.Document_Type);
                            POSEntry.SetRange("Document No.", QueryPOSEntry.Document_No_);
                            if not POSEntry.IsEmpty then
                                if POSEntry.FindSet() then begin

                                    CreateSalesReturnGenJournalLines(POSEntry, GeneralLedgerSetup);
                                    Commit();
                                    PostPOSEntries(QueryPOSEntry, POSAPIMgmnt);
                                    /*TempGenJournalLine.SetRange("Journal Template Name", TempGenJournalLine."Journal Template Name");
                                    TempGenJournalLine.SetRange("Journal Batch Name", TempGenJournalLine."Journal Batch Name");
                                    TempGenJournalLine.SetRange("Document No.", TempGenJournalLine."Document No.");
                                    TempGenJournalLine.FindSet();
                                    SetJobQueueStatus(TempGenJournalLine, TempGenJournalLine."Job Queue Status"::Posting);

                                    if not CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post Batch", TempGenJournalLine) then begin
                                        SetJobQueueStatus(TempGenJournalLine, TempGenJournalLine."Job Queue Status"::Error);
                                        Error(GetLastErrorText);
                                    end else
                                        POSAPIMgmnt.PostDocumentStatus(QueryPOSEntry.Document_No_);*/

                                    ClearBackgroundPostingInfo(TempGenJournalLine);
                                end;
                        end;
                    //Purchase Invoice
                    QueryPOSEntry.Entry_Type::"Purchase Invoice":
                        begin
                            DeleteGenJournalLines(QueryPOSEntry, GeneralLedgerSetup);
                            POSEntry.Reset();
                            POSEntry.SetRange("Entry Type", QueryPOSEntry.Entry_Type);
                            POSEntry.SetRange("Document Type", QueryPOSEntry.Document_Type);
                            POSEntry.SetRange("Document No.", QueryPOSEntry.Document_No_);
                            if not POSEntry.IsEmpty then
                                if POSEntry.FindSet() then begin

                                    CreatePurchaseInvoiceGenJournalLines(POSEntry, GeneralLedgerSetup);
                                    Commit();
                                    /* TempGenJournalLine.SetRange("Journal Template Name", TempGenJournalLine."Journal Template Name");
                                     TempGenJournalLine.SetRange("Journal Batch Name", TempGenJournalLine."Journal Batch Name");
                                     TempGenJournalLine.SetRange("Document No.", TempGenJournalLine."Document No.");
                                     TempGenJournalLine.FindSet();
                                     SetJobQueueStatus(TempGenJournalLine, TempGenJournalLine."Job Queue Status"::Posting);

                                     if not CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post Batch", TempGenJournalLine) then begin
                                         SetJobQueueStatus(TempGenJournalLine, TempGenJournalLine."Job Queue Status"::Error);
                                         Error(GetLastErrorText);
                                     end else
                                         POSAPIMgmnt.PostDocumentStatus(QueryPOSEntry.Document_No_);*/
                                    PostPOSEntries(QueryPOSEntry, POSAPIMgmnt);

                                    ClearBackgroundPostingInfo(TempGenJournalLine);
                                end;
                        end;
                    //Purchase Return
                    QueryPOSEntry.Entry_Type::"Purchase Return":
                        begin
                            DeleteGenJournalLines(QueryPOSEntry, GeneralLedgerSetup);
                            POSEntry.Reset();
                            POSEntry.SetRange("Entry Type", QueryPOSEntry.Entry_Type);
                            POSEntry.SetRange("Document Type", QueryPOSEntry.Document_Type);
                            POSEntry.SetRange("Document No.", QueryPOSEntry.Document_No_);
                            if not POSEntry.IsEmpty then
                                if POSEntry.FindSet() then begin

                                    CreatePurchaseReturnGenJournalLines(POSEntry, GeneralLedgerSetup);
                                    Commit();
                                    /* TempGenJournalLine.SetRange("Journal Template Name", TempGenJournalLine."Journal Template Name");
                                     TempGenJournalLine.SetRange("Journal Batch Name", TempGenJournalLine."Journal Batch Name");
                                     TempGenJournalLine.SetRange("Document No.", TempGenJournalLine."Document No.");
                                     TempGenJournalLine.FindSet();
                                     SetJobQueueStatus(TempGenJournalLine, TempGenJournalLine."Job Queue Status"::Posting);

                                     if not CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post Batch", TempGenJournalLine) then begin
                                         SetJobQueueStatus(TempGenJournalLine, TempGenJournalLine."Job Queue Status"::Error);
                                         Error(GetLastErrorText);
                                     end else
                                         POSAPIMgmnt.PostDocumentStatus(QueryPOSEntry.Document_No_);*/
                                    PostPOSEntries(QueryPOSEntry, POSAPIMgmnt);

                                    ClearBackgroundPostingInfo(TempGenJournalLine);
                                end;
                        end;
                    //Advance
                    QueryPOSEntry.Entry_Type::Advance:
                        begin
                            DeleteGenJournalLines(QueryPOSEntry, GeneralLedgerSetup);
                            POSEntry.Reset();
                            POSEntry.SetRange("Entry Type", QueryPOSEntry.Entry_Type);
                            POSEntry.SetRange("Document Type", QueryPOSEntry.Document_Type);
                            POSEntry.SetRange("Document No.", QueryPOSEntry.Document_No_);
                            if not POSEntry.IsEmpty then
                                if POSEntry.FindSet() then begin

                                    CreateAdvanceGenJournalLines(POSEntry, GeneralLedgerSetup);
                                    Commit();
                                    /*    TempGenJournalLine.SetRange("Journal Template Name", TempGenJournalLine."Journal Template Name");
                                        TempGenJournalLine.SetRange("Journal Batch Name", TempGenJournalLine."Journal Batch Name");
                                        TempGenJournalLine.SetRange("Document No.", TempGenJournalLine."Document No.");
                                        TempGenJournalLine.FindSet();
                                        SetJobQueueStatus(TempGenJournalLine, TempGenJournalLine."Job Queue Status"::Posting);

                                        if not CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post Batch", TempGenJournalLine) then begin
                                            SetJobQueueStatus(TempGenJournalLine, TempGenJournalLine."Job Queue Status"::Error);
                                            Error(GetLastErrorText);
                                        end else
                                            POSAPIMgmnt.PostDocumentStatus(QueryPOSEntry.Document_No_); */
                                    PostPOSEntries(QueryPOSEntry, POSAPIMgmnt);

                                    ClearBackgroundPostingInfo(TempGenJournalLine);
                                end;
                        end;
                    //Refund
                    QueryPOSEntry.Entry_Type::Refund:
                        begin
                            DeleteGenJournalLines(QueryPOSEntry, GeneralLedgerSetup);
                            POSEntry.Reset();
                            POSEntry.SetRange("Entry Type", QueryPOSEntry.Entry_Type);
                            POSEntry.SetRange("Document Type", QueryPOSEntry.Document_Type);
                            POSEntry.SetRange("Document No.", QueryPOSEntry.Document_No_);
                            if not POSEntry.IsEmpty then
                                if POSEntry.FindSet() then begin

                                    CreateRefundGenJournalLines(POSEntry, GeneralLedgerSetup);
                                    Commit();
                                    /*    TempGenJournalLine.SetRange("Journal Template Name", TempGenJournalLine."Journal Template Name");
                                        TempGenJournalLine.SetRange("Journal Batch Name", TempGenJournalLine."Journal Batch Name");
                                        TempGenJournalLine.SetRange("Document No.", TempGenJournalLine."Document No.");
                                        TempGenJournalLine.FindSet();
                                        SetJobQueueStatus(TempGenJournalLine, TempGenJournalLine."Job Queue Status"::Posting);

                                        if not CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post Batch", TempGenJournalLine) then begin
                                            SetJobQueueStatus(TempGenJournalLine, TempGenJournalLine."Job Queue Status"::Error);
                                            Error(GetLastErrorText);
                                        end else
                                            POSAPIMgmnt.PostDocumentStatus(QueryPOSEntry.Document_No_); */
                                    PostPOSEntries(QueryPOSEntry, POSAPIMgmnt);

                                    ClearBackgroundPostingInfo(TempGenJournalLine);
                                end;
                        end;
                    //JournalPayment
                    QueryPOSEntry.Entry_Type::JournalPayment:
                        begin
                            DeleteGenJournalLines(QueryPOSEntry, GeneralLedgerSetup);
                            POSEntry.Reset();
                            POSEntry.SetRange("Entry Type", QueryPOSEntry.Entry_Type);
                            POSEntry.SetRange("Document Type", QueryPOSEntry.Document_Type);
                            POSEntry.SetRange("Document No.", QueryPOSEntry.Document_No_);
                            if not POSEntry.IsEmpty then
                                if POSEntry.FindSet() then begin

                                    CreateJournalPaymentGenJournalLines(POSEntry, GeneralLedgerSetup);
                                    Commit();
                                    /*   TempGenJournalLine.SetRange("Journal Template Name", TempGenJournalLine."Journal Template Name");
                                       TempGenJournalLine.SetRange("Journal Batch Name", TempGenJournalLine."Journal Batch Name");
                                       TempGenJournalLine.SetRange("Document No.", TempGenJournalLine."Document No.");
                                       TempGenJournalLine.FindSet();
                                       SetJobQueueStatus(TempGenJournalLine, TempGenJournalLine."Job Queue Status"::Posting);

                                       if not CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post Batch", TempGenJournalLine) then begin
                                           SetJobQueueStatus(TempGenJournalLine, TempGenJournalLine."Job Queue Status"::Error);
                                           Error(GetLastErrorText);
                                       end else
                                           POSAPIMgmnt.PostDocumentStatus(QueryPOSEntry.Document_No_); */
                                    PostPOSEntries(QueryPOSEntry, POSAPIMgmnt);

                                    ClearBackgroundPostingInfo(TempGenJournalLine);
                                end;
                        end;
                    //EMI Receive
                    QueryPOSEntry.Entry_Type::"EMI Receive(GSS)":
                        begin
                            DeleteGenJournalLines(QueryPOSEntry, GeneralLedgerSetup);
                            POSEntry.Reset();
                            POSEntry.SetRange("Entry Type", QueryPOSEntry.Entry_Type);
                            POSEntry.SetRange("Document Type", QueryPOSEntry.Document_Type);
                            POSEntry.SetRange("Document No.", QueryPOSEntry.Document_No_);
                            if not POSEntry.IsEmpty then
                                if POSEntry.FindSet() then begin

                                    CreateEMIReceiveGenJournalLines(POSEntry, GeneralLedgerSetup);
                                    Commit();
                                    /*    TempGenJournalLine.SetRange("Journal Template Name", TempGenJournalLine."Journal Template Name");
                                        TempGenJournalLine.SetRange("Journal Batch Name", TempGenJournalLine."Journal Batch Name");
                                        TempGenJournalLine.SetRange("Document No.", TempGenJournalLine."Document No.");
                                        TempGenJournalLine.FindSet();
                                        SetJobQueueStatus(TempGenJournalLine, TempGenJournalLine."Job Queue Status"::Posting);

                                        if not CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post Batch", TempGenJournalLine) then begin
                                            SetJobQueueStatus(TempGenJournalLine, TempGenJournalLine."Job Queue Status"::Error);
                                            Error(GetLastErrorText);
                                        end else
                                            POSAPIMgmnt.PostDocumentStatus(QueryPOSEntry.Document_No_); */
                                    PostPOSEntries(QueryPOSEntry, POSAPIMgmnt);

                                    ClearBackgroundPostingInfo(TempGenJournalLine);
                                end;
                        end;
                    //Daily Expense (POS)
                    QueryPOSEntry.Entry_Type::"Daily Expense (POS)":
                        begin
                            DeleteGenJournalLines(QueryPOSEntry, GeneralLedgerSetup);
                            POSEntry.Reset();
                            POSEntry.SetRange("Entry Type", QueryPOSEntry.Entry_Type);
                            POSEntry.SetRange("Document Type", QueryPOSEntry.Document_Type);
                            POSEntry.SetRange("Document No.", QueryPOSEntry.Document_No_);
                            if not POSEntry.IsEmpty then
                                if POSEntry.FindSet() then begin

                                    CreateDailyExpenseGenJournalLines(POSEntry, GeneralLedgerSetup);
                                    Commit();
                                    /*    TempGenJournalLine.SetRange("Journal Template Name", TempGenJournalLine."Journal Template Name");
                                        TempGenJournalLine.SetRange("Journal Batch Name", TempGenJournalLine."Journal Batch Name");
                                        TempGenJournalLine.SetRange("Document No.", TempGenJournalLine."Document No.");
                                        TempGenJournalLine.FindSet();
                                        SetJobQueueStatus(TempGenJournalLine, TempGenJournalLine."Job Queue Status"::Posting);

                                        if not CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post Batch", TempGenJournalLine) then begin
                                            SetJobQueueStatus(TempGenJournalLine, TempGenJournalLine."Job Queue Status"::Error);
                                            Error(GetLastErrorText);
                                        end else
                                            POSAPIMgmnt.PostDocumentStatus(QueryPOSEntry.Document_No_); */
                                    PostPOSEntries(QueryPOSEntry, POSAPIMgmnt);

                                    ClearBackgroundPostingInfo(TempGenJournalLine);
                                end;
                        end;
                    //OGP Purchase (Old Gold)
                    QueryPOSEntry.Entry_Type::"OGP Purchase (Old Gold)":
                        begin
                            DeleteGenJournalLines(QueryPOSEntry, GeneralLedgerSetup);
                            POSEntry.Reset();
                            POSEntry.SetRange("Entry Type", QueryPOSEntry.Entry_Type);
                            POSEntry.SetRange("Document Type", QueryPOSEntry.Document_Type);
                            POSEntry.SetRange("Document No.", QueryPOSEntry.Document_No_);
                            if not POSEntry.IsEmpty then
                                if POSEntry.FindSet() then begin

                                    CreateOGPPurchaseGenJournalLines(POSEntry, GeneralLedgerSetup);
                                    Commit();
                                    /*    TempGenJournalLine.SetRange("Journal Template Name", TempGenJournalLine."Journal Template Name");
                                        TempGenJournalLine.SetRange("Journal Batch Name", TempGenJournalLine."Journal Batch Name");
                                        TempGenJournalLine.SetRange("Document No.", TempGenJournalLine."Document No.");
                                        TempGenJournalLine.FindSet();
                                        SetJobQueueStatus(TempGenJournalLine, TempGenJournalLine."Job Queue Status"::Posting);

                                        if not CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post Batch", TempGenJournalLine) then begin
                                            SetJobQueueStatus(TempGenJournalLine, TempGenJournalLine."Job Queue Status"::Error);
                                            Error(GetLastErrorText);
                                        end else
                                            POSAPIMgmnt.PostDocumentStatus(QueryPOSEntry.Document_No_); */
                                    PostPOSEntries(QueryPOSEntry, POSAPIMgmnt);

                                    ClearBackgroundPostingInfo(TempGenJournalLine);
                                end;
                        end;
                    //WO Issue
                    QueryPOSEntry.Entry_Type::"WO Issue":
                        begin
                            DeleteGenJournalLines(QueryPOSEntry, GeneralLedgerSetup);
                            POSEntry.Reset();
                            POSEntry.SetRange("Entry Type", QueryPOSEntry.Entry_Type);
                            POSEntry.SetRange("Document Type", QueryPOSEntry.Document_Type);
                            POSEntry.SetRange("Document No.", QueryPOSEntry.Document_No_);
                            if not POSEntry.IsEmpty then
                                if POSEntry.FindSet() then begin

                                    CreateWOIssueGenJournalLines(POSEntry, GeneralLedgerSetup);
                                    Commit();
                                    /*    TempGenJournalLine.SetRange("Journal Template Name", TempGenJournalLine."Journal Template Name");
                                        TempGenJournalLine.SetRange("Journal Batch Name", TempGenJournalLine."Journal Batch Name");
                                        TempGenJournalLine.SetRange("Document No.", TempGenJournalLine."Document No.");
                                        TempGenJournalLine.FindSet();
                                        SetJobQueueStatus(TempGenJournalLine, TempGenJournalLine."Job Queue Status"::Posting);

                                        if not CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post Batch", TempGenJournalLine) then begin
                                            SetJobQueueStatus(TempGenJournalLine, TempGenJournalLine."Job Queue Status"::Error);
                                            Error(GetLastErrorText);
                                        end else
                                            POSAPIMgmnt.PostDocumentStatus(QueryPOSEntry.Document_No_); */
                                    PostPOSEntries(QueryPOSEntry, POSAPIMgmnt);

                                    ClearBackgroundPostingInfo(TempGenJournalLine);
                                end;
                        end;
                    //Refinery Receive Posted
                    QueryPOSEntry.Entry_Type::"Refinery Receive Posted":
                        begin
                            DeleteGenJournalLines(QueryPOSEntry, GeneralLedgerSetup);
                            POSEntry.Reset();
                            POSEntry.SetRange("Entry Type", QueryPOSEntry.Entry_Type);
                            POSEntry.SetRange("Document Type", QueryPOSEntry.Document_Type);
                            POSEntry.SetRange("Document No.", QueryPOSEntry.Document_No_);
                            if not POSEntry.IsEmpty then
                                if POSEntry.FindSet() then begin

                                    CreateRefineryReceivePostedGenJournalLines(POSEntry, GeneralLedgerSetup);
                                    Commit();
                                    /*    TempGenJournalLine.SetRange("Journal Template Name", TempGenJournalLine."Journal Template Name");
                                        TempGenJournalLine.SetRange("Journal Batch Name", TempGenJournalLine."Journal Batch Name");
                                        TempGenJournalLine.SetRange("Document No.", TempGenJournalLine."Document No.");
                                        TempGenJournalLine.FindSet();
                                        SetJobQueueStatus(TempGenJournalLine, TempGenJournalLine."Job Queue Status"::Posting);

                                        if not CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post Batch", TempGenJournalLine) then begin
                                            SetJobQueueStatus(TempGenJournalLine, TempGenJournalLine."Job Queue Status"::Error);
                                            Error(GetLastErrorText);
                                        end else
                                            POSAPIMgmnt.PostDocumentStatus(QueryPOSEntry.Document_No_); */
                                    PostPOSEntries(QueryPOSEntry, POSAPIMgmnt);

                                    ClearBackgroundPostingInfo(TempGenJournalLine);
                                end;
                        end;
                    //Cash Transfer Posted
                    QueryPOSEntry.Entry_Type::"Cash Transfer Posted":
                        begin
                            DeleteGenJournalLines(QueryPOSEntry, GeneralLedgerSetup);
                            POSEntry.Reset();
                            POSEntry.SetRange("Entry Type", QueryPOSEntry.Entry_Type);
                            POSEntry.SetRange("Document Type", QueryPOSEntry.Document_Type);
                            POSEntry.SetRange("Document No.", QueryPOSEntry.Document_No_);
                            if not POSEntry.IsEmpty then
                                if POSEntry.FindSet() then begin

                                    CreateCashTransferPostedGenJournalLines(POSEntry, GeneralLedgerSetup);
                                    Commit();
                                    /*    TempGenJournalLine.SetRange("Journal Template Name", TempGenJournalLine."Journal Template Name");
                                        TempGenJournalLine.SetRange("Journal Batch Name", TempGenJournalLine."Journal Batch Name");
                                        TempGenJournalLine.SetRange("Document No.", TempGenJournalLine."Document No.");
                                        TempGenJournalLine.FindSet();
                                        SetJobQueueStatus(TempGenJournalLine, TempGenJournalLine."Job Queue Status"::Posting);

                                        if not CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post Batch", TempGenJournalLine) then begin
                                            SetJobQueueStatus(TempGenJournalLine, TempGenJournalLine."Job Queue Status"::Error);
                                            Error(GetLastErrorText);
                                        end else
                                            POSAPIMgmnt.PostDocumentStatus(QueryPOSEntry.Document_No_); */
                                    PostPOSEntries(QueryPOSEntry, POSAPIMgmnt);

                                    ClearBackgroundPostingInfo(TempGenJournalLine);
                                end;
                        end;
                    //Receive
                    QueryPOSEntry.Entry_Type::Receive:
                        begin
                            DeleteGenJournalLines(QueryPOSEntry, GeneralLedgerSetup);
                            POSEntry.Reset();
                            POSEntry.SetRange("Entry Type", QueryPOSEntry.Entry_Type);
                            POSEntry.SetRange("Document Type", QueryPOSEntry.Document_Type);
                            POSEntry.SetRange("Document No.", QueryPOSEntry.Document_No_);
                            if not POSEntry.IsEmpty then
                                if POSEntry.FindSet() then begin

                                    CreateReceiveGenJournalLines(POSEntry, GeneralLedgerSetup);
                                    Commit();
                                    /*    TempGenJournalLine.SetRange("Journal Template Name", TempGenJournalLine."Journal Template Name");
                                        TempGenJournalLine.SetRange("Journal Batch Name", TempGenJournalLine."Journal Batch Name");
                                        TempGenJournalLine.SetRange("Document No.", TempGenJournalLine."Document No.");
                                        TempGenJournalLine.FindSet();
                                        SetJobQueueStatus(TempGenJournalLine, TempGenJournalLine."Job Queue Status"::Posting);

                                        if not CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post Batch", TempGenJournalLine) then begin
                                            SetJobQueueStatus(TempGenJournalLine, TempGenJournalLine."Job Queue Status"::Error);
                                            Error(GetLastErrorText);
                                        end else
                                            POSAPIMgmnt.PostDocumentStatus(QueryPOSEntry.Document_No_); */
                                    PostPOSEntries(QueryPOSEntry, POSAPIMgmnt);

                                    ClearBackgroundPostingInfo(TempGenJournalLine);
                                end;
                        end;
                    //Contra
                    QueryPOSEntry.Entry_Type::Contra:
                        begin
                            DeleteGenJournalLines(QueryPOSEntry, GeneralLedgerSetup);
                            POSEntry.Reset();
                            POSEntry.SetRange("Entry Type", QueryPOSEntry.Entry_Type);
                            POSEntry.SetRange("Document Type", QueryPOSEntry.Document_Type);
                            POSEntry.SetRange("Document No.", QueryPOSEntry.Document_No_);
                            if not POSEntry.IsEmpty then
                                if POSEntry.FindSet() then begin

                                    CreateContraGenJournalLines(POSEntry, GeneralLedgerSetup);
                                    Commit();
                                    /*    TempGenJournalLine.SetRange("Journal Template Name", TempGenJournalLine."Journal Template Name");
                                        TempGenJournalLine.SetRange("Journal Batch Name", TempGenJournalLine."Journal Batch Name");
                                        TempGenJournalLine.SetRange("Document No.", TempGenJournalLine."Document No.");
                                        TempGenJournalLine.FindSet();
                                        SetJobQueueStatus(TempGenJournalLine, TempGenJournalLine."Job Queue Status"::Posting);

                                        if not CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post Batch", TempGenJournalLine) then begin
                                            SetJobQueueStatus(TempGenJournalLine, TempGenJournalLine."Job Queue Status"::Error);
                                            Error(GetLastErrorText);
                                        end else
                                            POSAPIMgmnt.PostDocumentStatus(QueryPOSEntry.Document_No_); */
                                    PostPOSEntries(QueryPOSEntry, POSAPIMgmnt);

                                    ClearBackgroundPostingInfo(TempGenJournalLine);
                                end;
                        end;
                    //General
                    QueryPOSEntry.Entry_Type::General:
                        begin
                            DeleteGenJournalLines(QueryPOSEntry, GeneralLedgerSetup);
                            POSEntry.Reset();
                            POSEntry.SetRange("Entry Type", QueryPOSEntry.Entry_Type);
                            POSEntry.SetRange("Document Type", QueryPOSEntry.Document_Type);
                            POSEntry.SetRange("Document No.", QueryPOSEntry.Document_No_);
                            if not POSEntry.IsEmpty then
                                if POSEntry.FindSet() then begin

                                    CreateGeneralGenJournalLines(POSEntry, GeneralLedgerSetup);
                                    Commit();
                                    /*    TempGenJournalLine.SetRange("Journal Template Name", TempGenJournalLine."Journal Template Name");
                                        TempGenJournalLine.SetRange("Journal Batch Name", TempGenJournalLine."Journal Batch Name");
                                        TempGenJournalLine.SetRange("Document No.", TempGenJournalLine."Document No.");
                                        TempGenJournalLine.FindSet();
                                        SetJobQueueStatus(TempGenJournalLine, TempGenJournalLine."Job Queue Status"::Posting);

                                        if not CODEUNIT.Run(CODEUNIT::"Gen. Jnl.-Post Batch", TempGenJournalLine) then begin
                                            SetJobQueueStatus(TempGenJournalLine, TempGenJournalLine."Job Queue Status"::Error);
                                            Error(GetLastErrorText);
                                        end else
                                            POSAPIMgmnt.PostDocumentStatus(QueryPOSEntry.Document_No_); */
                                    PostPOSEntries(QueryPOSEntry, POSAPIMgmnt);

                                    ClearBackgroundPostingInfo(TempGenJournalLine);
                                end;
                        end;
                //Start New Entry Type.


                end;
        OnAfterProcessGenJournalLines(POSEntry);
    end;


    local procedure CreateCashTransferPostedGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    var
        IsHandled: Boolean;
    begin
        OnBeforeCreateCashTransferPostedGenJournalLines(POSEntry, GeneralLedgerSetup, IsHandled);
        if IsHandled then
            exit;
        if POSEntry.FindSet() then
            repeat
                CashTransferPostedInitGenJournalLines(POSEntry, GeneralLedgerSetup);
            until POSEntry.Next() = 0;
        OnAfterCreateCashTransferPostedGenJournalLines(POSEntry, GeneralLedgerSetup);
    end;

    local procedure CreateGeneralGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    var
        IsHandled: Boolean;
    begin
        OnBeforeCreateGeneralGenJournalLines(POSEntry, GeneralLedgerSetup, IsHandled);
        if IsHandled then
            exit;
        if POSEntry.FindSet() then
            repeat
                GeneralInitGenJournalLines(POSEntry, GeneralLedgerSetup);
            until POSEntry.Next() = 0;
        OnAfterCreateGeneralGenJournalLines(POSEntry, GeneralLedgerSetup);
    end;


    local procedure GeneralInitGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    var
        DimensionManagement: Codeunit DimensionManagement;
        NextLines: Integer;
        IsHandled: Boolean;
    begin
        OnBeforeGeneralInitGenJournalLines(POSEntry, GeneralLedgerSetup, IsHandled);
        if IsHandled then
            exit;
        NextLines := 0;
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
        TempGenJournalLine.Insert();


        OnAfterGeneralInitGenJournalLines(POSEntry, GeneralLedgerSetup);
    end;


    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateGeneralGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateGeneralGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGeneralInitGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterGeneralInitGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    begin
    end;

    local procedure CashTransferPostedInitGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    var
        DimensionManagement: Codeunit DimensionManagement;
        NextLines: Integer;
        IsHandled: Boolean;
    begin
        OnBeforeCashTransferPostedInitGenJournalLines(POSEntry, GeneralLedgerSetup, IsHandled);
        if IsHandled then
            exit;
        NextLines := 0;
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
        TempGenJournalLine.Insert();


        OnAfterCashTransferPostedInitGenJournalLines(POSEntry, GeneralLedgerSetup);
    end;

    local procedure CreateReceiveGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    var
        IsHandled: Boolean;
    begin
        OnBeforeCreateReceiveGenJournalLines(POSEntry, GeneralLedgerSetup, IsHandled);
        if IsHandled then
            exit;
        if POSEntry.FindSet() then
            repeat
                ReceiveInitGenJournalLines(POSEntry, GeneralLedgerSetup);
            until POSEntry.Next() = 0;
        OnAfterCreateReceiveGenJournalLines(POSEntry, GeneralLedgerSetup);
    end;


    local procedure ReceiveInitGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    var
        DimensionManagement: Codeunit DimensionManagement;
        NextLines: Integer;
        IsHandled: Boolean;
    begin
        OnBeforeReceiveInitGenJournalLines(POSEntry, GeneralLedgerSetup, IsHandled);
        if IsHandled then
            exit;
        NextLines := 0;
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
        TempGenJournalLine.Insert();


        OnAfterReceiveInitGenJournalLines(POSEntry, GeneralLedgerSetup);
    end;


    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateReceiveGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateReceiveGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeReceiveInitGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterReceiveInitGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateCashTransferPostedGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateCashTransferPostedGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCashTransferPostedInitGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCashTransferPostedInitGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    begin
    end;

    local procedure CreateContraGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    var
        IsHandled: Boolean;
    begin
        OnBeforeCreateContraGenJournalLines(POSEntry, GeneralLedgerSetup, IsHandled);
        if IsHandled then
            exit;
        if POSEntry.FindSet() then
            repeat
                ContraInitGenJournalLines(POSEntry, GeneralLedgerSetup);
            until POSEntry.Next() = 0;
        OnAfterCreateContraGenJournalLines(POSEntry, GeneralLedgerSetup);
    end;


    local procedure ContraInitGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    var
        DimensionManagement: Codeunit DimensionManagement;
        NextLines: Integer;
        IsHandled: Boolean;
    begin
        OnBeforeContraInitGenJournalLines(POSEntry, GeneralLedgerSetup, IsHandled);
        if IsHandled then
            exit;
        NextLines := 0;
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
        TempGenJournalLine.Insert();


        OnAfterContraInitGenJournalLines(POSEntry, GeneralLedgerSetup);
    end;


    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateContraGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateContraGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeContraInitGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterContraInitGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    begin
    end;

    local procedure CreateRefineryReceivePostedGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    var
        IsHandled: Boolean;
    begin
        OnBeforeCreateRefineryReceivePostedGenJournalLines(POSEntry, GeneralLedgerSetup, IsHandled);
        if IsHandled then
            exit;
        if POSEntry.FindSet() then
            repeat
                RefineryReceivePostedInitGenJournalLines(POSEntry, GeneralLedgerSetup);
            until POSEntry.Next() = 0;
        OnAfterCreateRefineryReceivePostedGenJournalLines(POSEntry, GeneralLedgerSetup);
    end;


    local procedure RefineryReceivePostedInitGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    var
        DimensionManagement: Codeunit DimensionManagement;
        NextLines: Integer;
        IsHandled: Boolean;
    begin
        OnBeforeRefineryReceivePostedInitGenJournalLines(POSEntry, GeneralLedgerSetup, IsHandled);
        if IsHandled then
            exit;
        NextLines := 0;
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
        TempGenJournalLine.Insert();


        OnAfterRefineryReceivePostedInitGenJournalLines(POSEntry, GeneralLedgerSetup);
    end;


    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateRefineryReceivePostedGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateRefineryReceivePostedGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeRefineryReceivePostedInitGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterRefineryReceivePostedInitGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    begin
    end;

    local procedure CreateWOIssueGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    var
        IsHandled: Boolean;
    begin
        OnBeforeCreateWOIssueGenJournalLines(POSEntry, GeneralLedgerSetup, IsHandled);
        if IsHandled then
            exit;
        if POSEntry.FindSet() then
            repeat
                WOIssueInitGenJournalLines(POSEntry, GeneralLedgerSetup);
            until POSEntry.Next() = 0;
        OnAfterCreateWOIssueGenJournalLines(POSEntry, GeneralLedgerSetup);
    end;


    local procedure WOIssueInitGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    var
        DimensionManagement: Codeunit DimensionManagement;
        NextLines: Integer;
        IsHandled: Boolean;
    begin
        OnBeforeWOIssueInitGenJournalLines(POSEntry, GeneralLedgerSetup, IsHandled);
        if IsHandled then
            exit;
        NextLines := 0;
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
        TempGenJournalLine.Insert();


        OnAfterWOIssueInitGenJournalLines(POSEntry, GeneralLedgerSetup);
    end;


    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateWOIssueGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateWOIssueGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeWOIssueInitGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterWOIssueInitGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    begin
    end;

    local procedure CreateOGPPurchaseGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    var
        IsHandled: Boolean;
    begin
        OnBeforeCreateOGPPurchaseGenJournalLines(POSEntry, GeneralLedgerSetup, IsHandled);
        if IsHandled then
            exit;
        if POSEntry.FindSet() then
            repeat
                OGPPurchaseInitGenJournalLines(POSEntry, GeneralLedgerSetup);
            until POSEntry.Next() = 0;
        OnAfterCreateOGPPurchaseGenJournalLines(POSEntry, GeneralLedgerSetup);
    end;


    local procedure OGPPurchaseInitGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    var
        DimensionManagement: Codeunit DimensionManagement;
        NextLines: Integer;
        IsHandled: Boolean;
    begin
        OnBeforeOGPPurchaseInitGenJournalLines(POSEntry, GeneralLedgerSetup, IsHandled);
        if IsHandled then
            exit;
        NextLines := 0;
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
        TempGenJournalLine.Insert();


        OnAfterOGPPurchaseInitGenJournalLines(POSEntry, GeneralLedgerSetup);
    end;


    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateOGPPurchaseGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateOGPPurchaseGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeOGPPurchaseInitGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterOGPPurchaseInitGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    begin
    end;

    local procedure CreateDailyExpenseGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    var
        IsHandled: Boolean;
    begin
        OnBeforeCreateDailyExpenseGenJournalLines(POSEntry, GeneralLedgerSetup, IsHandled);
        if IsHandled then
            exit;
        if POSEntry.FindSet() then
            repeat
                DailyExpenseInitGenJournalLines(POSEntry, GeneralLedgerSetup);
            until POSEntry.Next() = 0;
        OnAfterCreateDailyExpenseGenJournalLines(POSEntry, GeneralLedgerSetup);
    end;

    local procedure AdvanceInitGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    var
        IsHandled: Boolean;
        DimensionManagement: Codeunit DimensionManagement;
        NextLines: Integer;
    begin
        OnBeforeAdvanceInitGenJournalLines(POSEntry, GeneralLedgerSetup, IsHandled);
        if IsHandled then
            exit;
        if IsHandled then
            exit;
        NextLines := 0;
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
        TempGenJournalLine.Insert();
        OnAfterAdvanceInitGenJournalLines(POSEntry, GeneralLedgerSetup);
    end;

    local procedure ClearBackgroundPostingInfo(var TempGenJournalLine: Record "Gen. Journal Line")
    var
        EmptyGuid: Guid;
        IsHandled: Boolean;
    begin
        OnBeforeClearBackgroundPostingInfo(TempGenJournalLine, IsHandled);
        if IsHandled then
            exit;
        TempGenJournalLine.SetRange("Journal Template Name", TempGenJournalLine."Journal Template Name");
        TempGenJournalLine.SetRange("Journal Batch Name", TempGenJournalLine."Journal Batch Name");
        TempGenJournalLine.SetRange("Document No.", TempGenJournalLine."Document No.");
        TempGenJournalLine.ModifyAll("Job Queue Status", TempGenJournalLine."Job Queue Status"::" ");
        TempGenJournalLine.ModifyAll("Job Queue Entry ID", EmptyGuid);
        TempGenJournalLine.ModifyAll("Print Posted Documents", false);

        OnAfterClearBackgroundPostingInfo(TempGenJournalLine);
    end;

    local procedure CreateAdvanceGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    var
        IsHandled: Boolean;
    begin
        OnBeforeCreateAdvanceGenJournalLines(POSEntry, GeneralLedgerSetup, IsHandled);
        if IsHandled then
            exit;
        if POSEntry.FindSet() then
            repeat
                AdvanceInitGenJournalLines(POSEntry, GeneralLedgerSetup);
            until POSEntry.Next() = 0;
        OnAfterCreateAdvanceGenJournalLines(POSEntry, GeneralLedgerSetup);
    end;


    local procedure DailyExpenseInitGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    var
        DimensionManagement: Codeunit DimensionManagement;
        NextLines: Integer;
        IsHandled: Boolean;
    begin
        OnBeforeDailyExpenseInitGenJournalLines(POSEntry, GeneralLedgerSetup, IsHandled);
        if IsHandled then
            exit;
        NextLines := 0;
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
        TempGenJournalLine.Insert();


        OnAfterDailyExpenseInitGenJournalLines(POSEntry, GeneralLedgerSetup);
    end;

    local procedure CreateEMIReceiveGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    var
        IsHandled: Boolean;
    begin
        OnBeforeCreateEMIReceiveGenJournalLines(POSEntry, GeneralLedgerSetup, IsHandled);
        if IsHandled then
            exit;
        if POSEntry.FindSet() then
            repeat
                EMIReceiveInitGenJournalLines(POSEntry, GeneralLedgerSetup);
            until POSEntry.Next() = 0;
        OnAfterCreateEMIReceiveGenJournalLines(POSEntry, GeneralLedgerSetup);
    end;

    local procedure CreateJournalPaymentGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    var
        IsHandled: Boolean;
    begin
        OnBeforeCreateJournalPaymentGenJournalLines(POSEntry, GeneralLedgerSetup, IsHandled);
        if IsHandled then
            exit;
        if POSEntry.FindSet() then
            repeat
                JournalPaymentInitGenJournalLines(POSEntry, GeneralLedgerSetup);
            until POSEntry.Next() = 0;
        OnAfterCreateJournalPaymentGenJournalLines(POSEntry, GeneralLedgerSetup);
    end;

    local procedure CreatePurchaseInvoiceGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    var
        IsHandled: Boolean;
    begin
        OnBeforeCreatePurchaseInvoiceGenJournalLines(POSEntry, GeneralLedgerSetup, IsHandled);
        if IsHandled then
            exit;
        if POSEntry.FindSet() then
            repeat
                PurchaseInvoiceInitGenJournalLines(POSEntry, GeneralLedgerSetup);
            until POSEntry.Next() = 0;

        OnAfterCreatePurchaseInvoiceGenJournalLines(POSEntry, GeneralLedgerSetup);
    end;

    local procedure CreatePurchaseReturnGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    var
        IsHandled: Boolean;
    begin
        OnBeforeCreatePurchaseReturnGenJournalLines(POSEntry, GeneralLedgerSetup, IsHandled);
        if IsHandled then
            exit;
        if POSEntry.FindSet() then
            repeat
                PurchaseReturnInitGenJournalLines(POSEntry, GeneralLedgerSetup);
            until POSEntry.Next() = 0;

        OnAfterCreatePurchaseReturnGenJournalLines(POSEntry, GeneralLedgerSetup);
    end;

    local procedure CreateRefundGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    var
        IsHandled: Boolean;
    begin
        OnBeforeCreateRefundGenJournalLines(POSEntry, GeneralLedgerSetup, IsHandled);
        if IsHandled then
            exit;

        if POSEntry.FindSet() then
            repeat
                RefundInitGenJournalLines(POSEntry, GeneralLedgerSetup);
            until POSEntry.Next() = 0;

        OnAfterCreateRefundGenJournalLines(POSEntry, GeneralLedgerSetup);
    end;


    local procedure CreateSalesInvoiceGenJournalLines(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    var
        IsHandled: Boolean;
    begin
        OnBeforeCreateSalesInvoiceGenJournalLines(POSEntry, GeneralLedgerSetup, IsHandled);
        if IsHandled then
            exit;
        if POSEntry.FindSet() then
            repeat
                SalesInvoiceInitGenJournalLines(POSEntry, GeneralLedgerSetup);
            until POSEntry.Next() = 0;


        OnAfterCreateSalesInvoiceGenJournalLines(POSEntry, GeneralLedgerSetup);
    end;

    local procedure CreateSalesReturnGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    var
        IsHandled: Boolean;
    begin
        OnBeforeCreateSalesReturnGenJournalLines(POSEntry, GeneralLedgerSetup, IsHandled);
        if IsHandled then
            exit;
        if POSEntry.FindSet() then
            repeat
                SalesReturnInitGenJournalLines(POSEntry, GeneralLedgerSetup);
            until POSEntry.Next() = 0;
        OnAfterCreateSalesReturnGenJournalLines(POSEntry, GeneralLedgerSetup);
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
        TempGenJournalLine.DeleteAll();

        TempGenJournalLine.Reset();
        TempGenJournalLine.SetRange("Journal Template Name", GeneralLedgerSetup."Journal Template Name");
        TempGenJournalLine.SetRange("Journal Batch Name", GeneralLedgerSetup."Journal Batch Name");
        TempGenJournalLine.SetRange("Document Type", QueryPOSEntry.Document_Type);
        TempGenJournalLine.SetRange("Document No.", QueryPOSEntry.Document_No_);
        TempGenJournalLine.DeleteAll();

        OnAfterDeleteGenJournalLines(QueryPOSEntry, GeneralLedgerSetup);
    end;

    local procedure EMIReceiveInitGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    var
        IsHandled: Boolean;
        DimensionManagement: Codeunit DimensionManagement;
        NextLines: Integer;
    begin
        OnBeforeEMIReceiveInitGenJournalLines(POSEntry, GeneralLedgerSetup, IsHandled);
        if IsHandled then
            exit;
        NextLines := 0;
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
        TempGenJournalLine.Insert();


        OnAfterEMIReceiveInitGenJournalLines(POSEntry, GeneralLedgerSetup);
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

    local procedure JournalPaymentInitGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    var
        DimensionManagement: Codeunit DimensionManagement;
        NextLines: Integer;
        IsHandled: Boolean;
    begin
        OnBeforeJournalPaymentInitGenJournalLines(POSEntry, GeneralLedgerSetup, IsHandled);
        if IsHandled then
            exit;
        NextLines := 0;
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
        TempGenJournalLine.Insert();


        OnAfterJournalPaymentInitGenJournalLines(POSEntry, GeneralLedgerSetup);
    end;

    local procedure PurchaseInvoiceInitGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    var
        DimensionManagement: Codeunit DimensionManagement;
        NextLines: Integer;
        IsHandled: Boolean;
    begin
        OnBeforePurchaseInvoiceInitGenJournalLines(POSEntry, GeneralLedgerSetup, IsHandled);
        if IsHandled then
            exit;
        NextLines := 0;
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
        TempGenJournalLine.Insert();
        OnAfterPurchaseInvoiceInitGenJournalLines(POSEntry, GeneralLedgerSetup);
    end;

    local procedure PurchaseReturnInitGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    var
        DimensionManagement: Codeunit DimensionManagement;
        NextLines: Integer;
        IsHandled: Boolean;
    begin
        OnBeforePurchaseReturnInitGenJournalLines(POSEntry, GeneralLedgerSetup, IsHandled);
        if IsHandled then
            exit;
        NextLines := 0;
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
        TempGenJournalLine.Insert();


        OnAfterPurchaseReturnInitGenJournalLines(POSEntry, GeneralLedgerSetup);
    end;

    local procedure RefundInitGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    var
        DimensionManagement: Codeunit DimensionManagement;
        NextLines: Integer;
        IsHandled: Boolean;
    begin
        OnBeforeRefundInitGenJournalLines(POSEntry, GeneralLedgerSetup, IsHandled);
        if IsHandled then
            exit;
        NextLines := 0;
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
        TempGenJournalLine.Insert();


        OnAfterRefundInitGenJournalLines(POSEntry, GeneralLedgerSetup);
    end;

    local procedure SalesInvoiceInitGenJournalLines(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    var

        DimensionManagement: Codeunit DimensionManagement;
        NextLines: Integer;
        IsHandled: Boolean;
    begin
        OnBeforeSalesInvoiceInitGenJournalLines(POSEntry, GeneralLedgerSetup, IsHandled);
        if IsHandled then
            exit;
        NextLines := 0;
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
        TempGenJournalLine.Insert();




        OnAfterSalesInvoiceInitGenJournalLines(POSEntry, GeneralLedgerSetup);
    end;

    local procedure SalesReturnInitGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    var
        DimensionManagement: Codeunit DimensionManagement;
        NextLines: Integer;
        IsHandled: Boolean;
    begin
        OnBeforeSalesReturnInitGenJournalLines(POSEntry, GeneralLedgerSetup, IsHandled);
        if IsHandled then
            exit;
        NextLines := 0;
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
        TempGenJournalLine.Insert();


        OnAfterSalesReturnInitGenJournalLines(POSEntry, GeneralLedgerSetup);
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

    [IntegrationEvent(false, false)]
    local procedure OnAfterAdvanceInitGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateDailyExpenseGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterClearBackgroundPostingInfo(TempGenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateAdvanceGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateEMIReceiveGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateJournalPaymentGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreatePurchaseInvoiceGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreatePurchaseReturnGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateRefundGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateSalesInvoiceGenJournalLines(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateSalesReturnGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterDeleteGenJournalLines(QueryPOSEntry: Query NIMQueryPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterEMIReceiveInitGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    begin
    end;



    [IntegrationEvent(false, false)]
    local procedure OnAfterGetGeneralLedgerSet()
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterGetNextLineNo(GeneralLedgerSetup: Record "General Ledger Setup"; var LastLineNo: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterJournalPaymentInitGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    begin
    end;



    [IntegrationEvent(false, false)]
    local procedure OnAfterProcessGenJournalLines(POSEntry: Record NIMPOSEntry)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPurchaseInvoiceInitGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPurchaseReturnInitGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterRefundInitGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterSalesInvoiceInitGenJournalLines(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterSalesReturnInitGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterSetJobQueueStatus(TempGenJournalLine: Record "Gen. Journal Line"; JobQueueStatus: Enum System.Threading."Document Job Queue Status")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeAdvanceInitGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup"; var IsHandled: Boolean)
    begin
    end;

    local procedure OnBeforeCreateDailyExpenseGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup"; var IsHandled: Boolean)
    begin
    end;

    [TryFunction]
    local procedure PostPOSEntries(var QueryPOSEntry: Query NIMQueryPOSEntry; var POSAPIMgmnt: Codeunit NIMPOSAPIMgmnt)
    var
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

    [IntegrationEvent(false, false)]
    local procedure OnBeforeClearBackgroundPostingInfo(TempGenJournalLine: Record "Gen. Journal Line"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateAdvanceGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateEMIReceiveGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateJournalPaymentGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreatePurchaseInvoiceGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreatePurchaseReturnGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateRefundGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup"; var IsHandled: Boolean)
    begin
    end;




    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateSalesInvoiceGenJournalLines(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup"; var IsHandled: Boolean)
    begin
    end;


    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateSalesReturnGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeDeleteGenJournalLines(QueryPOSEntry: Query NIMQueryPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeEMIReceiveInitGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup"; var IsHandled: Boolean)
    begin
    end;



    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetGeneralLedgerSet(var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetNextLineNo(GeneralLedgerSetup: Record "General Ledger Setup"; var LastLineNo: Integer; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeJournalPaymentInitGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup"; var IsHandled: Boolean)
    begin
    end;



    [IntegrationEvent(false, false)]
    local procedure OnBeforeProcessGenJournalLines(POSEntry: Record NIMPOSEntry; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePurchaseInvoiceInitGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePurchaseReturnInitGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeRefundInitGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeSalesInvoiceInitGenJournalLines(var POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeSalesReturnInitGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeDailyExpenseInitGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterDailyExpenseInitGenJournalLines(POSEntry: Record NIMPOSEntry; GeneralLedgerSetup: Record "General Ledger Setup")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeSetJobQueueStatus(TempGenJournalLine: Record "Gen. Journal Line"; JobQueueStatus: Enum System.Threading."Document Job Queue Status"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePostPOSEntries(var QueryPOSEntry: Query NIMQueryPOSEntry; var POSAPIMgmnt: Codeunit NIMPOSAPIMgmnt; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPostPOSEntries(var QueryPOSEntry: Query NIMQueryPOSEntry; var POSAPIMgmnt: Codeunit NIMPOSAPIMgmnt)
    begin
    end;
}