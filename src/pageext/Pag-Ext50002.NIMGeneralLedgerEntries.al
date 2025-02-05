pageextension 50002 NIMGeneralLedgerEntries extends "General Ledger Entries"
{
    layout
    {
        // Add changes to page layout here
        addlast(Control1)
        {

            field(NIMPosEntry; Rec.NIMPosEntry)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the NIMPosEntry field.', Comment = '%';
            }
            field("Reference Document No."; Rec."Reference Document No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Reference Document No. field.', Comment = '%';
            }
            field("Reference Line No."; Rec."Reference Line No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Reference Line No. field.', Comment = '%';
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var

}