pageextension 50001 NIMGeneralLedgerSetup extends "General Ledger Setup"
{
    layout
    {
        // Add changes to page layout here
        addafter(General)
        {

            field("Journal Template Name"; Rec."Journal Template Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Journal Template Name field.', Comment = '%';
            }
            field("Journal Batch Name"; Rec."Journal Batch Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Journal Batch Name field.', Comment = '%';
            }
            field("API Enabled"; Rec."API Enabled")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the API Enabled field.', Comment = '%';
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        GeneralLedgerSetup: page "General Ledger Setup";
}