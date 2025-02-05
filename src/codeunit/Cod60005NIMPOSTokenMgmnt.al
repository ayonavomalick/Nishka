codeunit 60005 NIMPOSTokenMgmnt
{
    trigger OnRun()
    begin
        //GetAccessTokenFromPOS();
    end;


    // procedure GetTokenFromApi();
    // var
    //     HttpClient: HttpClient;
    //     HttpContent: HttpContent;
    //     HttpHeaders: HttpHeaders;
    //     Response: HttpResponseMessage;
    //     PostData: Text;
    //     Url: Text;
    // begin
    //     // Set the URL of the API endpoint
    //     Url := 'http://20.233.27.118:8085/NJ/token';

    //     // Prepare the form data (username and password)
    //     PostData := 'username=niska_bc&password=nimbus@123'; // Form data as key-value pairs

    //     // Create HttpContent from the PostData
    //     HttpContent.WriteFrom(PostData);

    //     // Set content-type header to indicate form data
    //     HttpHeaders.Add('Content-Type', 'application/x-www-form-urlencoded');

    //     // Send the POST request
    //     if HttpClient.Post(Url, HttpContent, Response) then begin
    //         // Check if the request was successful
    //         if Response.IsSuccessStatusCode() then begin
    //             // Handle success: Retrieve response content (e.g., the token)
    //             Message('Request was successful! Response: %1', Response.Content.ReadAsString());
    //         end else begin
    //             // Handle error response
    //             Message('Error occurred: %1', Response.HttpStatusCode);
    //         end;
    //     end else begin
    //         // Handle failure to send the request
    //         Message('Failed to send the request.');
    //     end;
    // end;

    procedure GetAccessTokenFromPOS()
    var
        POSTokenSetup: Record NIMPOSTokenSetup;
        RESTHelper: Codeunit "NIMREST Helper";
        UserNameLbl: Label 'username', Locked = true;
        PasswordLbl: Label 'password', Locked = true;
        PostData: Text;

        IsHandled: Boolean;
    begin
        OnBeforeGetAccessTokenFromPOS(IsHandled);
        if IsHandled then
            exit;
        if POSTokenSetup.Get() then begin
            POSTokenSetup.TestField("Access URL");
            POSTokenSetup.TestField("User Name");
            POSTokenSetup.TestField(Password);
        end;
        Clear(PostData);
        RESTHelper.Initialize('POST', POSTokenSetup."Access URL");
        //PostData := 'username=niska_bc&password=nimbus@123';
        PostData := UserNameLbl + '=' + POSTokenSetup."User Name" + '&' + PasswordLbl + '=' + POSTokenSetup.Password;
        RESTHelper.AddBody(PostData);
        RESTHelper.SetContentType('application/x-www-form-urlencoded');
        if RESTHelper.Send() then begin
            UpdateAccessTokenSetup(RESTHelper.GetResponseContentAsText());
            //Message(RESTHelper.GetResponseContentAsText());
        end;

        OnAfterGetAccessTokenFromPOS();
    end;

    local procedure UpdateAccessTokenSetup(GetResponseContentAsText: Text)
    var
        POSTokenSetup: Record NIMPOSTokenSetup;
        JSONManagement: Codeunit "JSON Management";
        TimeZoneSelection: Codeunit "Time Zone";
        AccessTokenLbl: Label 'access_token', Locked = true;
        TokenTypeLbl: Label 'token_type', Locked = true;
        ExpiryDateTimeLbl: Label 'expires_at', Locked = true;
        AccessToken: Text;
        TokenType: Text;
        ExpiryDateTime: Text;
        TempExpiryDateTime: DateTime;
        IsHandled: Boolean;
    begin
        OnBeforeUpdateAccessTokenSetup(GetResponseContentAsText, IsHandled);
        if IsHandled then
            exit;
        Clear(AccessToken);
        Clear(TokenType);
        Clear(ExpiryDateTime);
        Clear(TempExpiryDateTime);
        JSONManagement.InitializeFromString(GetResponseContentAsText);
        JSONManagement.GetStringPropertyValueByName(AccessTokenLbl, AccessToken);
        if AccessToken <> '' then begin
            JSONManagement.GetStringPropertyValueByName(TokenTypeLbl, TokenType);
            JSONManagement.GetStringPropertyValueByName(ExpiryDateTimeLbl, ExpiryDateTime);
            POSTokenSetup.Get();
            POSTokenSetup."Access Token" := AccessToken;
            POSTokenSetup."Token Type" := TokenType;

            Evaluate(TempExpiryDateTime, ExpiryDateTime);
            POSTokenSetup."Expired Time" := TempExpiryDateTime;
            POSTokenSetup.Modify();

        end;






        OnAfterUpdateAccessTokenSetup(GetResponseContentAsText);
    end;



    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetAccessTokenFromPOS(var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterGetAccessTokenFromPOS()
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeUpdateAccessTokenSetup(GetResponseContentAsText: Text; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterUpdateAccessTokenSetup(GetResponseContentAsText: Text)
    begin
    end;


    var
        myInt: Integer;
}