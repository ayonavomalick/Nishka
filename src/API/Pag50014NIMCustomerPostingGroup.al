page 50014 "NIM Customer Posting Group"
{
    APIVersion = 'v2.0';
    APIPublisher = 'demo';
    APIGroup = 'Nisika';
    EntityCaption = 'CustomerPostingGroup';
    EntitySetCaption = 'CustomerPostingGroup';
    DelayedInsert = true;
    ODataKeyFields = Code;
    PageType = API;
    EntityName = 'CustomerPostingGroup';
    EntitySetName = 'CustomerPostingGroup';
    SourceTable = "Customer Posting Group";
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
                field(receivablesAccount; Rec."Receivables Account")
                {
                    Caption = 'Receivables Account';
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

   
