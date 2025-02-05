tableextension 50002 NIMGeneralLedgerSetup extends "General Ledger Setup"
{
    fields
    {
        field(50000; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            TableRelation = "Gen. Journal Template";
        }
        field(50001; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Journal Template Name"));
        }
        field(50002; "API Enabled"; boolean)
        {
            Caption = 'API Enabled';
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }



    var

}