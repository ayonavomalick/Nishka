page 50010 NIMPOSAPISetup
{
    Caption = 'POS API Setup';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = NIMPOSAPISetup;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {


                field("Primary Key"; Rec."Primary Key")
                {
                    ToolTip = 'Specifies the value of the Primary Key field.', Comment = '%';
                }
                field("Document Status Update URL"; Rec."Document Status Update URL")
                {
                    ToolTip = 'Specifies the value of the Access Token field.', Comment = '%';
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
           
        }
    }
}