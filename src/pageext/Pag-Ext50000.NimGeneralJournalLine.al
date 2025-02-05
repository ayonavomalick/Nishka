pageextension 50000 NimGeneralJournalLine extends "General Journal"
{
    layout
    {
        addafter("Posting Date")
        {
            field("VAT Pertcentage"; Rec."VAT %")
            {
                //FieldPropertyName = FieldPropertyValue;
                Caption = 'VAT %';
                ApplicationArea = All;
            }
        }

    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}