tableextension 50005 NIMVendor extends Vendor
{
    fields
    {
        field(50000; "Vendor Type"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}