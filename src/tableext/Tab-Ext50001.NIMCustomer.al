tableextension 50001 "NIM Customer" extends Customer
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Date Of Birth"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Legal Entity Core"; Text[10])
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Customer Type"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "Id Proof"; Text[50])
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