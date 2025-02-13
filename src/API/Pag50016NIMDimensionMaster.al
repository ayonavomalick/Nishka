page 50016 "NIM Dimension Master"
{
    APIVersion = 'v2.0';
    APIPublisher = 'demo';
    APIGroup = 'Nisika';
    EntityCaption = 'DimensionMaster';
    EntitySetCaption = 'DimensionMasters';
    DelayedInsert = true;
    ODataKeyFields = Code;
    PageType = API;
    EntityName = 'DimensionMaster';
    EntitySetName = 'DimensionMasters';
    SourceTable = Dimension;
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

   
