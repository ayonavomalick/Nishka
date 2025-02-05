page 50008 NIMPosEntryListAPI
{
    APIVersion = 'v2.0';
    APIPublisher = 'demo';
    APIGroup = 'Nisika';
    EntityCaption = 'NIMAPITable';
    EntitySetCaption = 'NIMAPITables';
    DelayedInsert = true;
    ODataKeyFields = "Entry No.";
    PageType = API;
    EntityName = 'NIMAPITable';
    EntitySetName = 'NIMAPITables';
    SourceTable = NIMPOSEntry;
    Extensible = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                Caption = 'GroupName';

                field(entryType; Rec."Entry Type")
                {
                    Caption = 'Entry Type';
                }
                field(documentType; Rec."Document Type")
                {
                    Caption = 'Document Type';
                }
                field(documentNo; Rec."Document No.")
                {
                    Caption = 'Document No.';
                }

                field(accountType; Rec."Account Type")
                {
                    Caption = 'Account Type';
                }
                field(accountNo; Rec."Account No.")
                {
                    Caption = 'Account No.';
                }
                field(postingDate; Rec."Posting Date")
                {
                    Caption = 'Posting Date';
                }
                field(amountCur; Rec.AmountCur)
                {
                    Caption = 'AmountCur';
                }
                field(amountMST; Rec.AmountMST)
                {
                    Caption = 'AmountMST';
                }
                field(currency; Rec.Currency)
                {
                    Caption = 'Currency';
                }
                field(globalDimension1; Rec."Global Dimension 1")
                {
                    Caption = 'Global Dimension 1';
                }
                field(globalDimension2; Rec."Global Dimension 2")
                {
                    Caption = 'Global Dimension 2';
                }
                field(purpose; Rec.Purpose)
                {
                    Caption = 'Purpose';
                }

                field(shortcutDimension3; Rec."Shortcut Dimension 3")
                {
                    Caption = 'Shortcut Dimension 3';
                }
                field(shortcutDimension4; Rec."Shortcut Dimension 4")
                {
                    Caption = 'Shortcut Dimension 4';
                }
                field(referenceDocumentNo; Rec."Reference Document No.")
                {
                    Caption = 'Reference Document No.';
                }
                field(referenceLineNo; Rec."Reference Line No.")
                {
                    Caption = 'Reference Line No.';
                }
                field(shortcutDimension5; Rec."Shortcut Dimension 5")
                {
                    Caption = 'Shortcut Dimension 5';
                }
                field(shortcutDimension6; Rec."Shortcut Dimension 6")
                {
                    Caption = 'Shortcut Dimension 6';
                }
                field(shortcutDimension7; Rec."Shortcut Dimension 7")
                {
                    Caption = 'Shortcut Dimension 7';
                }
                field(shortcutDimension8; Rec."Shortcut Dimension 8")
                {
                    Caption = 'Shortcut Dimension 8';
                }
                field(noOfLines; Rec."No. Of Lines")
                {
                    Caption = 'No. Of Lines';
                }
            }
        }
    }

}