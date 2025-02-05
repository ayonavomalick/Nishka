tableextension 50003 NIMGenJournalLines extends "Gen. Journal Line"
{
    fields
    {

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

        field(50003; "API"; boolean)
        {
            DataClassification = CustomerContent;
            caption = 'API';


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


}