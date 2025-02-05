codeunit 50000 VendorInfo
{
    Access = Public;
    trigger OnRun()
    begin
        HttpRequestExternalDummyApi();
    end;

    procedure HttpRequestExternalDummyApi()
    begin
        if HttpClient.Get(URL, HttpResponseMessage) then begin
            HttpResponseMessage.Content.ReadAs(Response);
            Message(Response);
        end
    end;

    var
        HttpClient: HttpClient;
        HttpResponseMessage: HttpResponseMessage;
        HttpHeaders: HttpHeaders;
        HttpContent: HttpContent;
        HttpRequestMessage: HttpRequestMessage;
        URL: Label 'https://jsonplaceholder.typicode.com/users';
        Response: Text;

}