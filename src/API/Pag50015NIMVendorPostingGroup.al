page 50015 "NIM Vendor Posting Group"
{
    APIVersion = 'v2.0';
    APIPublisher = 'demo';
    APIGroup = 'Nisika';
    EntityCaption = 'VendorPostingGroup';
    EntitySetCaption = 'VendorPostingGroup';
    DelayedInsert = true;
    ODataKeyFields = Code;
    PageType = API;
    EntityName = 'VendorPostingGroup';
    EntitySetName = 'VendorPostingGroup';
    SourceTable = "Vendor Posting Group";
    Extensible = true;

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                Caption = 'GroupName';
                

                field("code"; Rec."Code")
                {
                    Caption = 'Code';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(payablesAccount; Rec."Payables Account")
                {
                    Caption = 'Payables Account';
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

   
