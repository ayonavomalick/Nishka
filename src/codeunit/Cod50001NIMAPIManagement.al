codeunit 50001 "NIM API Management"
{
    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", OnBeforeInsertEvent, '', false, false)]
    procedure SetGenJournalLine(var Rec: Record "Gen. Journal Line"; RunTrigger: Boolean)
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
        GenJournalLine: Record "Gen. Journal Line";
        NextLineNo: Integer;
    begin
        if GeneralLedgerSetup.Get() then begin
            if not GeneralLedgerSetup."API Enabled" then
                exit;
            GeneralLedgerSetup.TestField("Journal Template Name");
            GeneralLedgerSetup.TestField("Journal Batch Name");
        end;
        NextLineNo := 0;
        GenJournalLine.Reset();
        GenJournalLine.SetCurrentKey("Journal Template Name", "Journal Batch Name", "Line No.");
        GenJournalLine.SetRange("Journal Template Name", GeneralLedgerSetup."Journal Template Name");
        GenJournalLine.SetRange("Journal Batch Name", GeneralLedgerSetup."Journal Batch Name");
        if not GenJournalLine.IsEmpty then begin
            if GenJournalLine.FindLast() then
                NextLineNo := GenJournalLine."Line No." + 10000
        end else
            NextLineNo := 10000;
        Rec."Journal Template Name" := GeneralLedgerSetup."Journal Template Name";
        Rec."Journal Batch Name" := GeneralLedgerSetup."Journal Batch Name";
        Rec."Line No." := NextLineNo;


    end;

    procedure GetSalesDocumentNo()
    var
        SalesAndRecievableSetup: Record "Sales & Receivables Setup";
    begin
        SalesAndRecievableSetup.Get();
    end;

    procedure GetPurchaseDocumentNo()
    var
        PurchaseAndPayableSetup: Record "Purchases & Payables Setup";
    begin
        PurchaseAndPayableSetup.Get();
    end;

    var
        myInt: Integer;
}