tableextension 50006 "NIM Dimension value" extends "Dimension Value"

{
    fields
    {
        // Add changes to table fields here

        field(50000; "Description"; Text[300])
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