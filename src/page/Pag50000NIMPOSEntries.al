page 50000 NIMPOSEntries
{

    ApplicationArea = all;
    Caption = 'POS Entries';
    PageType = List;
    SourceTable = NIMPOSEntry;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                Caption = 'GroupName';

                field("Entry Type"; Rec."Entry Type")
                {
                    ToolTip = 'Specifies the value of the Entry Type field.', Comment = '%';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ToolTip = 'Specifies the value of the Document Type field.', Comment = '%';
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
                }

                field("Account Type"; Rec."Account Type")
                {
                    ToolTip = 'Specifies the value of the Account Type field.', Comment = '%';
                }
                field("Account No."; Rec."Account No.")
                {
                    ToolTip = 'Specifies the value of the Account No. field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.', Comment = '%';
                }
                field(Purpose; Rec.Purpose)
                {
                    ToolTip = 'Specifies the value of the Purpose field.', Comment = '%';
                }
                field(AmountCur; Rec.AmountCur)
                {
                    ToolTip = 'Specifies the value of the AmountCur field.', Comment = '%';
                }
                field(AmountMST; Rec.AmountMST)
                {
                    ToolTip = 'Specifies the value of the AmountMST field.', Comment = '%';
                }
                field(Currency; Rec.Currency)
                {
                    ToolTip = 'Specifies the value of the Currency field.', Comment = '%';
                }
                field("Global Dimension 1"; Rec."Global Dimension 1")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 field.', Comment = '%';
                }
                field("Global Dimension 2"; Rec."Global Dimension 2")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 2 field.', Comment = '%';
                }
                field("Shortcut Dimension 3"; Rec."Shortcut Dimension 3")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 3 field.', Comment = '%';
                }
                field("Shortcut Dimension 4"; Rec."Shortcut Dimension 4")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 4 field.', Comment = '%';
                }
                field("Reference Document No."; Rec."Reference Document No.")
                {
                    ToolTip = 'Specifies the value of the Reference Document No. field.', Comment = '%';
                }
                field("Reference Line No."; Rec."Reference Line No.")
                {
                    ToolTip = 'Specifies the value of the Reference Line No. field.', Comment = '%';
                }
                field("Shortcut Dimension 5"; Rec."Shortcut Dimension 5")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 5 field.', Comment = '%';
                }
                field("Shortcut Dimension 6"; Rec."Shortcut Dimension 6")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 6 field.', Comment = '%';
                }
                field("Shortcut Dimension 7"; Rec."Shortcut Dimension 7")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 7 field.', Comment = '%';
                }
                field("Shortcut Dimension 8"; Rec."Shortcut Dimension 8")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 8 field.', Comment = '%';
                }
                field("No. Of Lines"; Rec."No. Of Lines")
                {
                    ToolTip = 'Specifies the value of the No. Of Lines field.', Comment = '%';
                }
                field("Error Info"; Rec."Error Info")
                {
                    ToolTip = 'Specifies the value of the Error Info field.', Comment = '%';
                }

            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(CreateGenJournalLines)
            {
                ApplicationArea = All;
                Caption = 'Create Gen.Journal Lines';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Create;

                trigger OnAction()
                var
                    ConfirmManagement: Codeunit "Confirm Management";
                    NIMCreateGenJournalLines: Codeunit NIMCreateGenJournalLines;
                    APITable: Record NIMPOSEntry;
                    ConfirmQstLbl: Label 'Do you want to create Gen.Journal Lines?';

                begin
                    if not ConfirmManagement.GetResponseOrDefault(ConfirmQstLbl) then
                        exit;

                    NIMCreateGenJournalLines.ProcessGenJournalLines();
                end;
            }
        }
    }


}