codeunit 60004 NIMPOSAPIMgmnt
{
    trigger OnRun()
    begin
        TestAPI();
    end;

    procedure TestAPI()
    var

        RESTHelper: Codeunit "NIMREST Helper";
        UserNameLbl: Label 'username';
        PasswordLbl: Label 'password';
        TypeHelper: Codeunit "Type Helper";
        IsHandled: Boolean;
    begin
        OnBeforeTestAPI(IsHandled);
        if IsHandled then
            exit;
        //
        RESTHelper.Initialize('POST', 'http://20.233.61.43:8085/journal/status/NJ/2425SOPKAR00936');
        //RESTHelper.AddRequestHeader(UserNameLbl, 'niska_bc');
        //RESTHelper.AddRequestHeader(PasswordLbl, 'nimbus@123');
        RESTHelper.AddBody('{"Status":6}');
        RESTHelper.SetContentType('application/json');
        if not RESTHelper.Send() then
            Message(RESTHelper.GetResponseContentAsText());
        //https://api.publicapis.org/entries
        // RESTHelper.Initialize('GET', 'http://20.233.61.43:8085/user_guide/');
        // RESTHelper.AddBody('username:niska_bc password:nimbus@123');
        //RESTHelper.SetContentType('application/t');
        // if RESTHelper.Send() then
        //    Message(RESTHelper.GetResponseContentAsText());




        OnAfterTestAPI();
        UpdateDocumentStatusInPOS(DocumentNo);
    end;

    local procedure UpdateDocumentStatusInPOS(DocumentNo: Code[20])
    var
        POSTokenMgmnt: Codeunit NIMPOSTokenMgmnt;
        IsHandled: Boolean;
    begin
        OnBeforeUpdateDocumentStatusInPOS(DocumentNo, IsHandled);
        if IsHandled then
            exit;

        POSTokenMgmnt.GetAccessTokenFromPOS();
        PostDocumentStatus(DocumentNo);

        OnAfterUpdateDocumentStatusInPOS(DocumentNo);
    end;

    local procedure UpdatePostedPOSEntries(DocumentNo: Code[20]; GetResponseContentAsText: Text)
    var
        PostedPOSEntry: Record NIMPostedPOSEntry;
        JSONManagement: Codeunit "JSON Management";

        StatusLbl: Label 'Status', Locked = true;
        IdLbl: Label 'Id', Locked = true;
        VoucherNoLbl: Label 'VoucherNo', Locked = true;
        TransTypeLbl: Label 'TransType', Locked = true;
        CreatedDateLbl: Label 'CreatedDate', Locked = true;
        Status: Text;
        Id: Text;
        VoucherNo: Text;
        TransType: Text;
        CreatedDate: Text;

        IsHandled: Boolean;
    begin
        OnBeforeUpdatePostedPOSEntries(DocumentNo, GetResponseContentAsText, IsHandled);
        if IsHandled then
            exit;

        Clear(Status);
        Clear(Id);
        Clear(VoucherNo);
        Clear(TransType);
        Clear(CreatedDate);
        JSONManagement.InitializeFromString(GetResponseContentAsText);
        JSONManagement.GetStringPropertyValueByName(VoucherNoLbl, VoucherNo);
        if VoucherNo <> '' then begin
            JSONManagement.GetStringPropertyValueByName(StatusLbl, Status);
            JSONManagement.GetStringPropertyValueByName(IdLbl, Id);
            JSONManagement.GetStringPropertyValueByName(TransTypeLbl, TransType);
            JSONManagement.GetStringPropertyValueByName(CreatedDateLbl, CreatedDate);
            PostedPOSEntry.Reset();
            PostedPOSEntry.SetRange("Document No.", VoucherNo);
            PostedPOSEntry.ModifyAll("Magic Status", Status);
            PostedPOSEntry.ModifyAll("Magic Id", Id);
            PostedPOSEntry.ModifyAll("Magic Trans Type", TransType);
            PostedPOSEntry.ModifyAll("Magic Created Date", CreatedDate);
        end;

        OnAfterUpdatePostedPOSEntries(DocumentNo, GetResponseContentAsText);
    end;

    procedure PostDocumentStatus(DocumentNo: Code[20])
    var
        POSTokenSetup: Record NIMPOSTokenSetup;
        POSAPISetup: Record NIMPOSAPISetup;
        RESTHelper: Codeunit "NIMREST Helper";
        AuthorizationLbl: Label 'Authorization', Locked = true;
        //TokenTypeLbl: Label 'Bearer', Locked = true;
        POSAPIAccessToken: Codeunit NIMPOSTokenMgmnt;

        IsHandled: Boolean;
    begin
        OnBeforePostDocumentStatus(DocumentNo, IsHandled);
        if IsHandled then
            exit;
        POSAPIAccessToken.GetAccessTokenFromPOS();
        if POSTokenSetup.Get() then begin
            POSTokenSetup.TestField("Access Token");
            POSTokenSetup.TestField("Token Type");
            POSTokenSetup.TestField("Expired Time");
        end;
        if POSAPISetup.Get() then
            POSAPISetup.TestField("Document Status Update URL");

        RESTHelper.Initialize('POST', POSAPISetup."Document Status Update URL" + DocumentNo);
        RESTHelper.AddRequestHeaderAuthorizationToken(AuthorizationLbl, POSTokenSetup."Token Type" + ' ' + POSTokenSetup."Access Token");
        RESTHelper.AddBody('{"Status":6}');
        RESTHelper.SetContentType('application/json');
        if RESTHelper.Send() then
            // Message(RESTHelper.GetResponseContentAsText());
            UpdatePostedPOSEntries(DocumentNo, RESTHelper.GetResponseContentAsText());

        OnAfterPostDocumentStatus(DocumentNo);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeTestAPI(var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterTestAPI()
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeUpdateDocumentStatusInPOS(DocumentNo: Code[20]; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterUpdateDocumentStatusInPOS(DocumentNo: Code[20])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePostDocumentStatus(DocumentNo: Code[20]; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPostDocumentStatus(DocumentNo: Code[20])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeUpdatePostedPOSEntries(DocumentNo: Code[20]; GetResponseContentAsText: Text; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterUpdatePostedPOSEntries(DocumentNo: Code[20]; GetResponseContentAsText: Text)
    begin
    end;




    var
        DocumentNo: Code[20];
}