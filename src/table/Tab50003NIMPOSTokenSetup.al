table 50003 NIMPOSTokenSetup
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[50])
        {
            DataClassification = CustomerContent;
            caption = '';

        }


        field(2; "Access Token"; text[200])
        {
            DataClassification = CustomerContent;
            caption = 'Access Token';

        }
        field(3; "Token Type"; Text[20])
        {
            DataClassification = CustomerContent;
            caption = 'Token Type';

        }
        field(4; "Expired Time"; DateTime)
        {
            DataClassification = CustomerContent;
            caption = 'Expired Date Time';

        }
        field(5; "User Name"; Text[50])
        {
            DataClassification = CustomerContent;
            caption = 'User Name';

        }
        field(6; "Password"; Text[50])
        {
            DataClassification = CustomerContent;
            caption = 'Password';

        }
        field(7; "Access URL"; text[100])
        {
            DataClassification = CustomerContent;
            caption = 'Access URL';

        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var


    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}