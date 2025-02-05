table 50002 NIMPOSAPISetup
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[50])
        {
            DataClassification = CustomerContent;
            caption = '';

        }
        field(2; "Document Status Update URL"; text[100])
        {
            DataClassification = CustomerContent;
            caption = 'Access Token';

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
        myInt: Integer;

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