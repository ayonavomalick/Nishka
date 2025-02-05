page 50002 "NIM Customer"
{
    APIVersion = 'v2.0';
    APIPublisher = 'demo';
    APIGroup = 'Nisika';
    EntityCaption = 'Customer';
    EntitySetCaption = 'Customers';
    DelayedInsert = true;
    ODataKeyFields = "No.";
    PageType = API;
    EntityName = 'customer';
    EntitySetName = 'customers';
    SourceTable = "Customer";
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
                field(customerPostingGroup; Rec."Customer Posting Group")
                {
                    Caption = 'Customer Posting Group';
                }
                field(phoneNo; Rec."Phone No.")
                {
                    Caption = 'Phone No.';
                }
                field(idProof; Rec."Id Proof")
                {
                    Caption = 'Id Proof';
                }
                field(customerType; Rec."Customer Type")
                {
                    Caption = 'Customer Type';
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