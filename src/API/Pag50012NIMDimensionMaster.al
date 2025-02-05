page 50012 "NIM Dimension Master"
{
    APIVersion = 'v2.0';
    APIPublisher = 'demo';
    APIGroup = 'Nisika';
    EntityCaption = 'DimensionMaster';
    EntitySetCaption = 'DimensionMasters';
    DelayedInsert = true;
    ODataKeyFields = "Dimension Code", Code;
    PageType = API;
    EntityName = 'DimensionMaster';
    EntitySetName = 'DimensionMasters';
    SourceTable = "Dimension Value";
    Extensible = true;

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                Caption = 'GroupName';


                field(dimensionCode; Rec."Dimension Code")
                {
                    Caption = 'Dimension Code';
                }
                field("code"; Rec."Code")
                {
                    Caption = 'Code';
                }
                field(name; Rec.Name)
                {
                    Caption = 'Name';
                }
                field(globalDimensionNo; Rec."Global Dimension No.")
                {
                    Caption = 'Global Dimension No.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                Caption = 'ActionName';

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}