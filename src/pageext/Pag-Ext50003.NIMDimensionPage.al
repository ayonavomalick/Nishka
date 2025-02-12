pageextension 50003 NIMDimensionPage extends "Dimension Values"
{
    layout
    {
        // Add changes to page layout here
        addlast(Control1)
        {

            
            field(Description; Rec.Description)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Description field.', Comment = '%';
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var

}