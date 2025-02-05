/// <summary>
/// Page NIMPOSTokenSetup (ID 50002).
/// </summary>
page 50009 NIMPOSTokenSetup
{
    Caption = 'POS Token Setup';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = NIMPOSTokenSetup;

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


                field("Access URL"; Rec."Access URL")
                {
                    ToolTip = 'Specifies the value of the Access Token field.', Comment = '%';
                }
                field("User Name"; Rec."User Name")
                {
                    ToolTip = 'Specifies the value of the User Name field.', Comment = '%';
                }
                field(Password; Rec.Password)
                {
                    ToolTip = 'Specifies the value of the Password field.', Comment = '%';
                }
                field("Access Token"; Rec."Access Token")
                {
                    ToolTip = 'Specifies the value of the Access Token field.', Comment = '%';
                }
                field("Token Type"; Rec."Token Type")
                {
                    ToolTip = 'Specifies the value of the Token Type field.', Comment = '%';
                }
                field("Expired Time"; Rec."Expired Time")
                {
                    ToolTip = 'Specifies the value of the Expired Date Time field.', Comment = '%';
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