tableextension 50004 NIMGLEntry extends "G/L Entry"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "NIMPosEntry"; Boolean)
        {
            DataClassification = customercontent;
        }
        field(50001; "Reference Document No."; code[20])
        {
            DataClassification = CustomerContent;
            caption = 'Reference Document No.';


        }
        field(50002; "Reference Line No."; integer)
        {
            DataClassification = CustomerContent;
            caption = 'Reference Line No.';


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
        GLEntry: Record "G/L Entry";
}