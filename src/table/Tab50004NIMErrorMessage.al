#pragma warning disable AA0215
table 50004 "NIMError Message"
#pragma warning restore AA0215
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; ID; Integer)
        {
            AutoIncrement = true;
            Caption = 'ID';
        }
        field(2; "Record ID"; RecordID)
        {
            Caption = 'Record ID';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                Rec."Table Number" := GetTableNo(Rec."Record ID");
            end;
        }
        field(3; "Field Number"; Integer)
        {
            Caption = 'Field Number';

            trigger OnValidate()
            begin
                if Rec."Table Number" = 0 then
                    Rec."Field Number" := 0;
            end;
        }
        field(4; "Message Type"; Option)
        {
            Caption = 'Message Type';
            Editable = false;
            OptionCaption = 'Error,Warning,Information';
            OptionMembers = Error,Warning,Information;
        }
        field(5; "Description"; Text[250])
        {
            Caption = 'Description';
            Editable = false;
            ObsoleteState = Removed;
            ObsoleteTag = '25.0';
            ObsoleteReason = 'Replaced by "Message" which has an increase in field length.';
        }
        field(6; "Additional Information"; Text[250])
        {
            Caption = 'Additional Information';
            Editable = false;
        }
        field(7; "Support Url"; Text[250])
        {
            Caption = 'Support Url';
            Editable = false;
        }
        field(8; "Table Number"; Integer)
        {
            Caption = 'Table Number';
        }
        field(10; "Context Record ID"; RecordID)
        {
            Caption = 'Context Record ID';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                Rec."Context Table Number" := GetTableNo(Rec."Context Record ID");
            end;
        }
        field(11; "Field Name"; Text[80])
        {
            CalcFormula = lookup(Field."Field Caption" where(TableNo = field("Table Number"),
                                                              "No." = field("Field Number")));
            Caption = 'Field Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(12; "Table Name"; Text[80])
        {
            CalcFormula = lookup("Table Metadata".Caption where(ID = field("Table Number")));
            Caption = 'Table Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(13; "Context Field Number"; Integer)
        {
            Caption = 'Context Field Number';
            DataClassification = SystemMetadata;

            trigger OnValidate()
            begin
                if Rec."Context Table Number" = 0 then
                    Rec."Context Field Number" := 0;
            end;
        }
        field(14; "Context Table Number"; Integer)
        {
            Caption = 'Context Table Number';
            DataClassification = SystemMetadata;
        }
        field(15; "Context Field Name"; Text[80])
        {
            CalcFormula = lookup(Field."Field Caption" where(TableNo = field("Context Table Number"),
                                                              "No." = field("Context Field Number")));
            Caption = 'Context Field Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(16; "Register ID"; Guid)
        {
            Caption = 'Register ID';
            DataClassification = SystemMetadata;
            TableRelation = "Error Message Register".ID;
        }
        field(17; "Created On"; DateTime)
        {
            Caption = 'Created On';
            DataClassification = SystemMetadata;
        }
        field(18; Context; Boolean)
        {
            Caption = 'Context';
            DataClassification = SystemMetadata;
        }
        field(20; Duplicate; Boolean)
        {
            Caption = 'Duplicate';
            DataClassification = SystemMetadata;
        }
        field(21; "Error Call Stack"; BLOB)
        {
            Caption = 'Error Call Stack';
            DataClassification = SystemMetadata;
        }
        field(22; "Message"; Text[2048])
        {
            Caption = 'Description';
            Editable = false;
        }
        field(23; "Reg. Err. Msg. System ID"; Guid) // Link temporary error message with registered (committed) error message.
        {
            DataClassification = SystemMetadata;
        }
    }

    keys
    {
        key(Key1; ID)
        {
            Clustered = true;
        }
        key(Key2; "Context Record ID", "Record ID")
        {
        }
        key(Key3; "Message Type", ID)
        {
        }
        key(Key4; "Created On")
        {
        }
        key(Key5; "Register ID", ID, Context)
        {
        }
        key(Key6; Context, "Context Record ID")
        {
        }
    }

    fieldgroups
    {
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

    local procedure GetTableNo(RecordID: RecordID): Integer
    begin
        exit(RecordID.TableNo());
    end;

    procedure GetErrorCallStack(): Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        if not Rec."Error Call Stack".HasValue() then
            exit('');
        Rec.CalcFields("Error Call Stack");
        Rec."Error Call Stack".CreateInStream(InStream, TextEncoding::Windows);
        exit(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator()));
    end;


}