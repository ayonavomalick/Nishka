page 50012 "NIM Dimension Value"
{
    APIVersion = 'v2.0';
    APIPublisher = 'demo';
    APIGroup = 'Nisika';
    EntityCaption = 'DimensionValue';
    EntitySetCaption = 'DimensionValues';
    DelayedInsert = true;
    ODataKeyFields = "Dimension Code", Code;
    PageType = API;
    EntityName = 'DimensionValue';
    EntitySetName = 'DimensionValues';
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
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                /*field(name; Rec.Name)
                {
                    Caption = 'Name';
                }*/
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