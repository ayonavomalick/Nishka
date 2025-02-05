#pragma warning disable AA0215
/// <summary>
/// Table NIMREST Log (ID 60000).
/// </summary>
table 60000 "NIMREST Log"
#pragma warning restore AA0215
{
    Access = Public;
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; BigInteger)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }

        field(2; RequestUrl; Text[250])
        {
            Caption = 'RequestUrl';
        }
        field(3; RequestMethod; Code[10])
        {
            Caption = 'RequestMethod';
        }
        field(4; RequestBody; Blob)
        {
            Caption = 'RequestBody';
        }
        field(5; RequestBodySize; BigInteger)
        {
            Caption = 'RequestBodySize';
        }
        field(6; ContentType; Text[50])
        {
            Caption = 'Content Type';
        }
        field(7; RequestHeaders; Text[1000])
        {
            Caption = 'Headers';
        }
        field(8; ResponseHttpStatusCode; Integer)
        {
            Caption = 'ResponseHttpStatusCode';
        }
        field(9; Response; Blob)
        {
            Caption = 'Response';
        }
        field(10; ResponseSize; BigInteger)
        {
            Caption = 'ResponseSize';
        }
        field(11; DateTimeCreated; DateTime)
        {
            Caption = 'Date Time Created';
        }
        field(12; Duraction; Duration)
        {
            Caption = 'Duraction';
        }
        field(20; User; Text[50])
        {
            Caption = 'User';
            DataClassification = EndUserIdentifiableInformation;
        }

    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }

    procedure ShowRequestMessage()
    var
        ShowRequestMessageMeth: Codeunit "NIMShowRequestMessage Method";
    begin
        ShowRequestMessageMeth.ShowRequestMessage(Rec);
    end;

    procedure ShowResponseMessage()
    var
        ShowResponseMessageMeth: Codeunit "NIMShowResponseMessage Method";
    begin
        ShowResponseMessageMeth.ShowResponseMessage(Rec);
    end;

}