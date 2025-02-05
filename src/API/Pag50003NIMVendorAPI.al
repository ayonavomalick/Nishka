page 50003 "NIM Vendor API"
{
    APIVersion = 'v2.0';
    APIPublisher = 'demo';
    APIGroup = 'Nisika';
    EntityCaption = 'Vendor';
    EntitySetCaption = 'Vendors';
    DelayedInsert = true;
    ODataKeyFields = "No.";
    PageType = API;
    EntityName = 'vendor';
    EntitySetName = 'vendors';
    SourceTable = Vendor;
    Extensible = true;

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                Caption = 'GroupName';
                // field(No; Rec."No.")
                // {

                // }
                // field(Name; Rec.Name)
                // {

                // }
                // field(VendorPostingGroup; Rec."Vendor Posting Group")
                // {

                // }
                // field(VATRegistrationNo; Rec."VAT Registration No.")
                // {

                // }
                field(no; Rec."No.")
                {
                    Caption = 'No.';
                }
                field(vendorPostingGroup; Rec."Vendor Posting Group")
                {
                    Caption = 'Vendor Posting Group';
                }
                field(name; Rec.Name)
                {
                    Caption = 'Name';
                }
                field(vatRegistrationNo; Rec."VAT Registration No.")
                {
                    Caption = 'VAT Registration No.';
                }
                field(vendorType; Rec."Vendor Type")
                {
                    Caption = 'Vendor Type';
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