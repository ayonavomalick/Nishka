page 50004 "NIMGen Journal Lines"
{
    PageType = API;
    Caption = 'NIMJournalLines';
    APIPublisher = 'demo';
    APIGroup = 'Nisika';
    APIVersion = 'v2.0';
    EntityName = 'JournalLines';
    EntitySetName = 'JournalLines';
    SourceTable = "Gen. Journal Line";
    DelayedInsert = true;
    Extensible = true;
    // ODataKeyFields = "Journal Template Name", "Journal Batch Name";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                Caption = 'GroupName';
                field(Id; Rec.SystemId)
                {
                    Caption = 'Id';
                    Editable = false;
                }
                field(JournalBatchName; Rec."Journal Batch Name")
                {
                    Caption = 'Journal Batch Name';
                }
                field(JournalBatchId; Rec."Journal Batch Id")
                {
                    Caption = 'Journal Batch Id';
                }
                field(JournalTemplateName; Rec."Journal Template Name")
                {
                    Caption = 'Journal Template Name';
                }
                field(LineNumber; Rec."Line No.")
                {
                    Caption = 'Line No.';

                }
                field(AccountType; Rec."Account Type")
                {
                    Caption = 'Account Type';
                }
                field(AccountNo; Rec."Account No.")
                {
                    Caption = 'Account No';
                }
                field(PostingDate; Rec."Posting Date")
                {
                    Caption = 'Posting Date';
                }
                field(DocumentNumber; Rec."Document No.")
                {
                    Caption = 'Document No.';
                }
                field(DccountType; Rec."Document Type")
                {
                    Caption = 'Account Type';
                }
                field(ExternalDocumentNumber; Rec."External Document No.")
                {
                    Caption = 'External Document No.';
                }
                field(Amount; Rec.Amount)
                {
                    Caption = 'Amount';
                }
                field(BalanceAccountType; Rec."Bal. Account Type")
                {
                    Caption = 'Balance Account Type';
                }
                /*field(BalancingAccountNumber; Rec."Bal. Account No.")
                {
                    Caption = 'Balancing Account No.';
                }
                field(BalancingGeneralPostingType; Rec."Bal. Gen. Posting Type")
                {
                    Caption = 'Balancing Account No.';
                }*/
                field(VatDate; Rec."VAT Reporting Date")
                {
                    Caption = 'VAT Date';
                }
                field(VatAmount; Rec."VAT Amount")
                {
                    Caption = 'VAT Amount';
                }

            }
        }
    }

    // trigger OnNewRecord(BelowxRec: Boolean)
    // var

    //     GeneralLedgerSetup: Record "General Ledger Setup";
    //     GenJournalLine: Record "Gen. Journal Line";
    //     NextLineNo: Integer;
    // begin
    //     if GeneralLedgerSetup.Get() then begin
    //         if not GeneralLedgerSetup."API Enabled" then
    //             exit;
    //         GeneralLedgerSetup.TestField("Journal Template Name");
    //         GeneralLedgerSetup.TestField("Journal Batch Name");
    //     end;
    //     NextLineNo := 0;
    //     GenJournalLine.Reset();
    //     GenJournalLine.SetCurrentKey("Journal Template Name", "Journal Batch Name", "Line No.");
    //     GenJournalLine.SetRange("Journal Template Name", GeneralLedgerSetup."Journal Template Name");
    //     GenJournalLine.SetRange("Journal Batch Name", GeneralLedgerSetup."Journal Batch Name");
    //     if not GenJournalLine.IsEmpty then begin
    //         if GenJournalLine.FindLast() then
    //             NextLineNo := GenJournalLine."Line No." + 10000
    //     end else
    //         NextLineNo := 10000;
    //     Rec."Journal Template Name" := GeneralLedgerSetup."Journal Template Name";
    //     Rec."Journal Batch Name" := GeneralLedgerSetup."Journal Batch Name";
    //     Rec."Line No." := NextLineNo;
    // end;


    [ServiceEnabled]
    [Scope('cloud')]
    procedure GetNextLineNo() NextLineNo: Integer
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
        GenJournalLine: Record "Gen. Journal Line";

    begin
        if GeneralLedgerSetup.Get() then begin
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
        exit(NextLineNo);
    end;





    var
        myInt: Integer;


}