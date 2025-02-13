table 50001 "NIMPostedPOSEntry"
{
    DataClassification = CustomerContent;
    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            autoincrement = true;

        }
        field(2; "Entry Type"; Enum NIMPOSEntryType)
        {
            Caption = 'Entry Type';
            DataClassification = CustomerContent;
        }
        field(3; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = CustomerContent;
        }
        field(4; "Document No."; code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(5; "Document Type"; Enum "Gen. Journal Document Type")
        {
            Caption = 'Document Type';
            DataClassification = CustomerContent;
        }
        field(6; "Account Type"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Account Type';

        }
        field(7; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            TableRelation = if ("Account Type" = const("G/L Account")) "G/L Account" where("Account Type" = const(Posting),
                                                                                          Blocked = const(false))
            else
            if ("Account Type" = const(Customer)) Customer
            else
            if ("Account Type" = const(Vendor)) Vendor
            else
            if ("Account Type" = const("Bank Account")) "Bank Account"
            else
            if ("Account Type" = const("Fixed Asset")) "Fixed Asset"
            else
            if ("Account Type" = const("IC Partner")) "IC Partner"
            else
            if ("Account Type" = const("Allocation Account")) "Allocation Account"
            else
            if ("Account Type" = const(Employee)) Employee;

            trigger OnValidate()
            var
                customer: Record customer;
                Vendor: Record Vendor;
                GLAccount: Record "G/L Account";
                BankAccount: Record "Bank Account";
                FixedAsset: Record "Fixed Asset";
                ICPartner: Record "IC Partner";
                AllocationAccount: Record "Allocation Account";
                Employee: Record Employee;

            begin

            end;

        }
        field(8; "Global Dimension 1"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1),
                                                          Blocked = const(false));

        }
        field(9; "Global Dimension 2"; code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2),
                                                          Blocked = const(false));
        }
        field(10; "Purpose"; code[10])
        {
            Caption = 'Purpose';
            DataClassification = CustomerContent;
        }
        field(11; "Currency"; code[10])
        {
            Caption = 'Currency';
            DataClassification = CustomerContent;
        }
        field(12; "AmountCur"; Decimal)
        {
            Caption = 'AmountCur';
            DataClassification = CustomerContent;
        }
        field(14; "AmountMST"; Decimal)
        {
            Caption = 'AmountMST';
            DataClassification = CustomerContent;
        }


        field(17; Description; Text[100])
        {
            Caption = 'Description';
        }

        field(18; "Shortcut Dimension 3"; code[20])
        {


            CaptionClass = '1,2,3';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3),
                                                                  "Dimension Value Type" = const(Standard),
                                                                  Blocked = const(false));
        }
        field(19; "Shortcut Dimension 4"; code[20])
        {
            CaptionClass = '1,2,4';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4),
                                                                  "Dimension Value Type" = const(Standard),
                                                                  Blocked = const(false));
        }

        field(21; "Reference Document No."; code[20])
        {
            DataClassification = CustomerContent;
            caption = 'Reference Document No.';


        }
        field(22; "Reference Line No."; integer)
        {
            DataClassification = CustomerContent;
            caption = 'Reference Line No.';


        }
        field(29; "Posted Status"; Enum "Posted Status")
        {
            DataClassification = CustomerContent;
            caption = 'Posted Status';
        }
        field(30; "Magic Status"; Text[10])
        {
            DataClassification = CustomerContent;
            caption = 'Magic Status';
        }
        field(31; "Magic Id"; Text[10])
        {
            DataClassification = CustomerContent;
            caption = 'Magic Id';
        }
        field(32; "Magic Trans Type"; Text[10])
        {
            DataClassification = CustomerContent;
            caption = 'Magic Trans Type';
        }
        field(33; "Magic Created Date"; Text[30])
        {
            DataClassification = CustomerContent;
            caption = 'Magic Created Date';
        }
        field(24; "Shortcut Dimension 5"; code[20])
        {
            CaptionClass = '1,2,5';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5),
                                                                  "Dimension Value Type" = const(Standard),
                                                                  Blocked = const(false));
        }
        field(25; "Shortcut Dimension 6"; code[20])
        {
            CaptionClass = '1,2,6';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(6),
                                                                  "Dimension Value Type" = const(Standard),
                                                                  Blocked = const(false));
        }
        field(26; "Shortcut Dimension 7"; code[20])
        {
            CaptionClass = '1,2,7';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(7),
                                                                  "Dimension Value Type" = const(Standard),
                                                                  Blocked = const(false));
        }
        field(27; "Shortcut Dimension 8"; code[20])
        {
            CaptionClass = '1,2,8';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(8),
                                                                  "Dimension Value Type" = const(Standard),
                                                                  Blocked = const(false));
        }


    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }

        key(SK1; "Reference Document No.", "Reference Line No.")
        {

        }
    }
}
