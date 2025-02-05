page 50011 "NIM G/L Master"
{
    APIVersion = 'v2.0';
    APIPublisher = 'demo';
    APIGroup = 'Nisika';
    EntityCaption = 'G/L Master';
    EntitySetCaption = 'G/L Master';
    DelayedInsert = true;
    ODataKeyFields = "No.";
    PageType = API;
    EntityName = 'GLMaster';
    EntitySetName = 'GLMaster';
    SourceTable = "G/L Account";
    Extensible = true;

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                Caption = 'GroupName';
                

                
                field(no; Rec."No.")
                {
                    Caption = 'No.';
                }
                field(name; Rec.Name)
                {
                    Caption = 'Name';
                }
                field(incomeBalance; Rec."Income/Balance")
                {
                    Caption = 'Income/Balance';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
           
        }
    }
}

   
