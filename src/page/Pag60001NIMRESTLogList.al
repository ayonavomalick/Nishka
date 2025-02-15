#pragma implicitwith disable
page 60001 "NIMREST Log List"
{
    PageType = List;
    SourceTable = "NIMREST Log";
    Caption = 'REST Log List';
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageId = "NIMRest Log Card";
    SourceTableView = sorting("Entry No.") order(descending);

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    Tooltip = 'Specifies the Entry No.';
                    ApplicationArea = All;
                }
                field(RequestMethod; Rec.RequestMethod)
                {
                    Tooltip = 'Specifies the RequestMethod';
                    ApplicationArea = All;
                }
                field(RequestUrl; Rec.RequestUrl)
                {
                    Tooltip = 'Specifies the RequestUrl';
                    ApplicationArea = All;
                }
                field(ContentType; Rec.ContentType)
                {
                    Tooltip = 'Specifies the ContentType';
                    ApplicationArea = All;
                }
                field(DateTimeCreated; Rec.DateTimeCreated)
                {
                    Tooltip = 'Specifies the DateTimeCreated';
                    ApplicationArea = All;
                }
                field(Duraction; Rec.Duraction)
                {
                    Tooltip = 'Specifies the Duraction';
                    ApplicationArea = All;
                }
                field(RequestBodySize; Rec.RequestBodySize)
                {
                    Tooltip = 'Specifies the RequestBodySize';
                    ApplicationArea = All;
                }
                field(RequestHeaders; Rec.RequestHeaders)
                {
                    Tooltip = 'Specifies the RequestHeaders';
                    ApplicationArea = All;
                }
                field(ResponseHttpStatusCode; Rec.ResponseHttpStatusCode)
                {
                    Tooltip = 'Specifies the ResponseHttpStatusCode';
                    ApplicationArea = All;
                }
                field(ResponseSize; Rec.ResponseSize)
                {
                    Tooltip = 'Specifies the ResponseSize';
                    ApplicationArea = All;
                }
                field(User; Rec.User)
                {
                    Tooltip = 'Specifies the User';
                    ApplicationArea = All;
                }


            }
        }
    }
    actions
    {
        area(Navigation)
        {
            action(ShowRequestMessage)
            {
                Tooltip = 'Shows the request message';
                ApplicationArea = All;
                Image = ShowSelected;
                Caption = 'Show Request Message';
                Scope = "Repeater";

                trigger OnAction()
                begin
                    Rec.ShowRequestMessage();
                end;
            }
            action(ShowResponseMessage)
            {
                Tooltip = 'Shows the response message';
                ApplicationArea = All;
                Image = ShowSelected;
                Caption = 'Show Response Message';
                Scope = "Repeater";

                trigger OnAction()
                begin
                    Rec.ShowResponseMessage();
                end;
            }
            action(Test)
            {
                Tooltip = 'Shows the response message';
                ApplicationArea = All;
                Image = ShowSelected;
                Caption = 'Test API';
                Scope = "Repeater";

                trigger OnAction()
                var
                    //POSAPIMgmnt: Codeunit NIMPOSAPIMgmnt;
                    POSTokenManagement: Codeunit NIMPOSTokenMgmnt;
                //NIMPOSTokenMgmnt: Codeunit NIMPOSTokenMgmnt;
                begin
                    // Message(FODFormDataExample.CallTextFormDataRequest());
                    //POSAPIMgmnt.PostDocumentStatus('2425SOPBAR00106');
                    POSTokenManagement.GetAccessTokenFromPOS();

                end;
            }


        }
    }

}

#pragma implicitwith restore
