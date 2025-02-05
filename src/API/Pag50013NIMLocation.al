page 50013 "NIM Location"
{
    APIVersion = 'v2.0';
    APIPublisher = 'demo';
    APIGroup = 'Nisika';
    EntityCaption = 'Location';
    EntitySetCaption = 'Location';
    DelayedInsert = true;
    ODataKeyFields = Code;
    PageType = API;
    EntityName = 'Location';
    EntitySetName = 'Location';
    SourceTable = Location;
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
                field(name; Rec.Name)
                {
                    Caption = 'Name';
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

   
