// codeunit 60011 "Saral Einvoice Management"
// {

//     /// <summary>
//     /// Generate IRN from API
//     /// </summary>
//     /// <param name="SalesInvoiceHeader"></param>
//     procedure GeneratePostedSalesEinvoice(var SalesInvoiceHeader: Record "Sales Invoice Header")
//     var
//         GLSetup: Record "General Ledger Setup";
//         RelyonSetup: Record "Relyon Setup";
//         IRPSetup: Record "IRP Setup";
//         InvoiceSetup: Record "NIMEInvoice Setup";
//         RESTHelper: Codeunit "NIMREST Helper";
//         RelyonAuthentications: Codeunit "Relyon Authentications";
//         IRPAuthentications: Codeunit "IRP Authentications";
//         SalesInvoiceForEinvoice: Codeunit SalesInvoiceForEinvoice;
//         TypeHelper: Codeunit "Type Helper";
//         SubscriptionIdLbl: Label 'SubscriptionId', Locked = true;
//         GstinLbl: Label 'Gstin', Locked = true;
//         UserNameLbl: Label 'UserName', Locked = true;
//         AuthTokenLbl: Label 'AuthToken', Locked = true;
//         AuthenticationTokenLbl: Label 'AuthenticationToken', locked = true;
//         sekLbl: Label 'sek', Locked = true;
//         Error1Lbl: Label 'E-Invoice and IRN Can Not Be Generated beacuse The Length Of Posting No is Greater Than 16 Charecters', Locked = true;
//         Error2Lbl: Label 'IRN Can Not Be Generate as Posting Date Is %1 Days From Today', Locked = true;
//         EinvoiceEnabledErr: Label 'API Einvoice Not enables in %1', Locked = true;
//         IRPSetUpDoesNotExistErr: Label '%1 IRP set up does not exist', Locked = true;
//         IsHandled: Boolean;
//         RelyOnAuthenticated: Boolean;
//         IRPAuthenticated: Boolean;
//         JsonObjectSalesInvoice: JsonObject;
//         JText: Text;
//         Continue: Boolean;
//         TempDateTime: DateTime;

//         AuthenticationTokenInstream: InStream;
//     begin
//         OnBeforeGeneratePostedSalesEinvoice(SalesInvoiceHeader, IsHandled);
//         if IsHandled then
//             exit;
//         RelyOnAuthenticated := false;
//         IRPAuthenticated := false;
//         Clear(JsonObjectSalesInvoice);
//         Clear(JText);
//         Clear(TempDateTime);

//         Clear(AuthenticationTokenInstream);
//         if GLSetup.Get() then
//             if not GLSetup."Clear Tax Einvoice" then
//                 Error(EinvoiceEnabledErr, GLSetup.TableCaption);
//         if (StrLen(SalesInvoiceHeader."No.") > 16) and (SalesInvoiceHeader."No." <> '') then
//             Message(Error1Lbl);

//         if (Today - SalesInvoiceHeader."Posting Date") > 30 then
//             Error(Error2Lbl, (Today - SalesInvoiceHeader."Posting Date"));

//         RelyonSetup.Get();
//         RelyonSetup.TestField("Client Id");
//         RelyonSetup.TestField("Client Secret");

//         if IRPSetup.Get(SalesInvoiceHeader."Location GST Reg. No.") then begin
//             IRPSetup.TestField("User Name");
//             IRPSetup.TestField(Password);
//         end else
//             Error(IRPSetUpDoesNotExistErr, SalesInvoiceHeader."Location GST Reg. No.");
//         InvoiceSetup.Get();
//         InvoiceSetup.TestField("EInvoice Url");

//         // TempDateTime := CurrentDateTime;
//         // if RelyonSetup."Authentication Validity" < TempDateTime then begin
//         //     RelyonAuthentications.GetAuthenticateRelyon();
//         //     Commit();
//         //     RelyOnAuthenticated := true;
//         // end else
//         //     RelyOnAuthenticated := true;
//         // Clear(TempDateTime);
//         // TempDateTime := CurrentDateTime;
//         // if IRPSetup."Token Expiry" < TempDateTime then begin
//         //     RelyonAuthentications.GetAuthenticateRelyon();
//         //     IRPAuthentications.GetAuthenticateIRP(SalesInvoiceHeader."Location GST Reg. No.");
//         //     Commit();
//         //     IRPAuthenticated := true
//         // end else
//         //     IRPAuthenticated := true;
//         RelyonAuthentications.GetAuthenticateRelyon();
//         IRPAuthentications.GetAuthenticateIRP(SalesInvoiceHeader."Location GST Reg. No.");
//         Commit();
//         RelyOnAuthenticated := true;
//         IRPAuthenticated := true;

//         //Get Authentication token from Relyon Setup.
//         if RelyonSetup.Get() then begin
//             RelyonSetup.CalcFields("Autentication Token");
//             if RelyonSetup."Autentication Token".HasValue then
//                 RelyonSetup."Autentication Token".CreateInStream(AuthenticationTokenInstream)
//             else
//                 Error('%1 is empty', RelyonSetup.FieldCaption("Autentication Token"));
//         end;
//         IRPSetup.Get(SalesInvoiceHeader."Location GST Reg. No.");
//         if RelyOnAuthenticated and IRPAuthenticated then begin
//             RESTHelper.Initialize('POST', InvoiceSetup."EInvoice Url");
//             RESTHelper.AddRequestHeader(AuthenticationTokenLbl, TypeHelper.TryReadAsTextWithSepAndFieldErrMsg(AuthenticationTokenInstream, TypeHelper.LFSeparator(), RelyonSetup.FieldName("Autentication Token")));
//             RESTHelper.AddRequestHeader(SubscriptionIdLbl, RelyonSetup."Subscription Id");
//             RESTHelper.AddRequestHeader(GstinLbl, SalesInvoiceHeader."Location GST Reg. No.");
//             RESTHelper.AddRequestHeader(UserNameLbl, IRPSetup."User Name");
//             RESTHelper.AddRequestHeader(AuthTokenLbl, IRPSetup.authToken);
//             RESTHelper.AddRequestHeader(sekLbl, IRPSetup.sek);
//             JsonObjectSalesInvoice := SalesInvoiceForEinvoice.CreateSalesInvoiceJson(SalesInvoiceHeader);
//             JsonObjectSalesInvoice.WriteTo(JText);
//             Commit();
//             Continue := ConfirmRequestInJsonView(JText);
//             if not Continue then
//                 exit;

//             RESTHelper.AddBody(JText);
//             RESTHelper.SetContentType('application/json');
//             if RESTHelper.Send() then
//                 SalesInvoiceForEinvoice.GetResponseFromSalesEinvoice(RESTHelper.GetResponseContentAsText(), SalesInvoiceHeader);

//             Message(RESTHelper.GetResponseContentAsText());


//         end;

//         OnAfterGeneratePostedSalesEinvoice(SalesInvoiceHeader);
//     end;

//     /// <summary>
//     /// Canceled IRN from API.
//     /// </summary>
//     /// <param name="SalesInvoiceHeader"></param>
//     procedure GenerateCanceledSalesEinvoice(var SalesInvoiceHeader: Record "Sales Invoice Header")
//     var
//         GLSetup: Record "General Ledger Setup";
//         RelyonSetup: Record "Relyon Setup";
//         IRPSetup: Record "IRP Setup";
//         InvoiceSetup: Record "NIMEInvoice Setup";
//         RESTHelper: Codeunit "NIMREST Helper";
//         RelyonAuthentications: Codeunit "Relyon Authentications";
//         IRPAuthentications: Codeunit "IRP Authentications";
//         SalesInvoiceForEinvoice: Codeunit SalesInvoiceForEinvoice;
//         TypeHelper: Codeunit "Type Helper";
//         AuthenticationTokenLbl: Label 'AuthenticationToken', locked = true;
//         SubscriptionIdLbl: Label 'SubscriptionId', Locked = true;
//         GstinLbl: Label 'Gstin', Locked = true;
//         UserNameLbl: Label 'UserName', Locked = true;
//         AuthTokenLbl: Label 'AuthToken', Locked = true;
//         sekLbl: Label 'sek', Locked = true;
//         Error1Lbl: Label 'E-Invoice and IRN Can Not Be Generated beacuse The Length Of Posting No is Greater Than 16 Charecters', Locked = true;
//         Error2Lbl: Label 'IRN Can Not Be Generate as Posting Date Is %1 Days From Today', Locked = true;
//         EinvoiceEnabledErr: Label 'API Einvoice Not enables in %1', Locked = true;
//         IRPSetUpDoesNotExistErr: Label '%1 IRP set up does not exist', Locked = true;

//         IsHandled: Boolean;
//         RelyOnAuthenticated: Boolean;
//         IRPAuthenticated: Boolean;
//         JsonObjectSalesInvoice: JsonObject;
//         JText: Text;
//         TempDateTime: DateTime;
//         Continue: Boolean;
//         AuthenticationTokenInstream: InStream;
//     begin
//         OnBeforeGenerateCanceledSalesEinvoice(SalesInvoiceHeader, IsHandled);
//         if IsHandled then
//             exit;

//         RelyOnAuthenticated := false;
//         IRPAuthenticated := false;
//         Clear(JsonObjectSalesInvoice);
//         Clear(JText);
//         Clear(TempDateTime);
//         if GLSetup.Get() then
//             if not GLSetup."Clear Tax Einvoice" then
//                 Error(EinvoiceEnabledErr, GLSetup.TableCaption);
//         SalesInvoiceHeader.TestField("IRN Hash");
//         SalesInvoiceHeader.TestField("Cancel Reason");
//         SalesInvoiceHeader.TestField("Cancel Remarks");

//         if (StrLen(SalesInvoiceHeader."No.") > 16) and (SalesInvoiceHeader."No." <> '') then
//             Message(Error1Lbl);

//         if (Today - SalesInvoiceHeader."Posting Date") > 30 then
//             Error(Error2Lbl, (Today - SalesInvoiceHeader."Posting Date"));

//         RelyonSetup.Get();
//         RelyonSetup.TestField("Client Id");
//         RelyonSetup.TestField("Client Secret");
//         TempDateTime := CurrentDateTime;
//         if RelyonSetup."Authentication Validity" < TempDateTime then begin
//             RelyonAuthentications.GetAuthenticateRelyon();
//             Commit();
//             RelyOnAuthenticated := true;
//         end else
//             RelyOnAuthenticated := true;
//         Clear(TempDateTime);
//         if IRPSetup.Get(SalesInvoiceHeader."Location GST Reg. No.") then begin
//             IRPSetup.TestField("User Name");
//             IRPSetup.TestField(Password);
//         end else
//             Error(IRPSetUpDoesNotExistErr, SalesInvoiceHeader."Location GST Reg. No.");
//         TempDateTime := CurrentDateTime;
//         if IRPSetup."Token Expiry" < TempDateTime then begin
//             IRPAuthentications.GetAuthenticateIRP(SalesInvoiceHeader."Location GST Reg. No.");
//             Commit();
//             IRPAuthenticated := true
//         end else
//             IRPAuthenticated := true;
//         InvoiceSetup.Get();
//         InvoiceSetup.TestField("Cancel EInvoice Url");
//         //Get Authentication token from Relyon Setup.
//         if RelyonSetup.Get() then begin
//             RelyonSetup.CalcFields("Autentication Token");
//             if RelyonSetup."Autentication Token".HasValue then
//                 RelyonSetup."Autentication Token".CreateInStream(AuthenticationTokenInstream)
//             else
//                 Error('%1 is empty', RelyonSetup.FieldCaption("Autentication Token"));
//         end;
//         IRPSetup.Get(SalesInvoiceHeader."Location GST Reg. No.");
//         if RelyOnAuthenticated and IRPAuthenticated then begin
//             RESTHelper.Initialize('POST', InvoiceSetup."Cancel EInvoice Url");
//             RESTHelper.AddRequestHeader(AuthenticationTokenLbl, TypeHelper.TryReadAsTextWithSepAndFieldErrMsg(AuthenticationTokenInstream, TypeHelper.LFSeparator(), RelyonSetup.FieldName("Autentication Token")));
//             RESTHelper.AddRequestHeader(SubscriptionIdLbl, RelyonSetup."Subscription Id");
//             RESTHelper.AddRequestHeader(GstinLbl, SalesInvoiceHeader."Location GST Reg. No.");
//             RESTHelper.AddRequestHeader(UserNameLbl, IRPSetup."User Name");
//             RESTHelper.AddRequestHeader(AuthTokenLbl, IRPSetup.authToken);
//             RESTHelper.AddRequestHeader(sekLbl, IRPSetup.sek);
//             //RESTHelper.AddRequestHeader('action', 'CANEWB');
//             Clear(JText);
//             JsonObjectSalesInvoice := SalesInvoiceForEinvoice.CreateCancelSaleEinvoiceJSON(SalesInvoiceHeader);
//             JsonObjectSalesInvoice.WriteTo(JText);
//             Commit();
//             Continue := ConfirmRequestInJsonView(JText);
//             if not Continue then
//                 exit;
//             RESTHelper.AddBody(JText);
//             RESTHelper.SetContentType('application/json');
//             if RESTHelper.Send() then
//                 SalesInvoiceForEinvoice.GetResponseFromCanceledSalesEinvoice(RESTHelper.GetResponseContentAsText(), SalesInvoiceHeader);
//             Message(RESTHelper.GetResponseContentAsText());
//         end;
//         OnAfterGenerateCanceledSalesEinvoice(SalesInvoiceHeader);
//     end;

//     /// <summary>
//     /// Generate Eway Bill For Posted Sales Invoice.
//     /// </summary>
//     /// <param name="SalesInvoiceHeader"></param>
//     procedure GeneratePostedSalesinvoiceEwayBill(var SalesInvoiceHeader: Record "Sales Invoice Header")
//     var
//         GLSetup: Record "General Ledger Setup";
//         RelyonSetup: Record "Relyon Setup";
//         IRPSetup: Record "IRP Setup";
//         InvoiceSetup: Record "NIMEInvoice Setup";
//         RESTHelper: Codeunit "NIMREST Helper";
//         RelyonAuthentications: Codeunit "Relyon Authentications";
//         IRPAuthentications: Codeunit "IRP Authentications";
//         SalesInvoiceForEinvoice: Codeunit SalesInvoiceForEinvoice;
//         TypeHelper: Codeunit "Type Helper";
//         SubscriptionIdLbl: Label 'SubscriptionId', Locked = true;
//         GstinLbl: Label 'Gstin', Locked = true;
//         UserNameLbl: Label 'UserName', Locked = true;
//         AuthTokenLbl: Label 'AuthToken', Locked = true;
//         AuthenticationTokenLbl: Label 'AuthenticationToken', locked = true;
//         sekLbl: Label 'sek', Locked = true;
//         Error1Lbl: Label 'E-Invoice and IRN Can Not Be Generated beacuse The Length Of Posting No is Greater Than 16 Charecters', Locked = true;
//         Error2Lbl: Label 'IRN Can Not Be Generate as Posting Date Is %1 Days From Today', Locked = true;
//         EinvoiceEnabledErr: Label 'API Einvoice Not enables in %1', Locked = true;
//         IRPSetUpDoesNotExistErr: Label '%1 IRP set up does not exist', Locked = true;
//         IsHandled: Boolean;
//         RelyOnAuthenticated: Boolean;
//         IRPAuthenticated: Boolean;
//         JsonObjectSalesInvoice: JsonObject;
//         JText: Text;
//         Continue: Boolean;
//         TempDateTime: DateTime;
//         AuthenticationTokenInstream: InStream;
//     begin
//         OnBeforeGeneratePostedSalesinvoiceEwayBill(SalesInvoiceHeader, IsHandled);
//         if IsHandled then
//             exit;

//         RelyOnAuthenticated := false;
//         IRPAuthenticated := false;
//         Clear(JsonObjectSalesInvoice);
//         Clear(JText);
//         Clear(TempDateTime);
//         Clear(AuthenticationTokenInstream);
//         if GLSetup.Get() then
//             if not GLSetup."Clear Tax Einvoice" then
//                 Error(EinvoiceEnabledErr, GLSetup.TableCaption);
//         if (StrLen(SalesInvoiceHeader."No.") > 16) and (SalesInvoiceHeader."No." <> '') then
//             Message(Error1Lbl);

//         if (Today - SalesInvoiceHeader."Posting Date") > 30 then
//             Error(Error2Lbl, (Today - SalesInvoiceHeader."Posting Date"));
//         SalesInvoiceHeader.TestField("IRN Hash");

//         RelyonSetup.Get();
//         RelyonSetup.TestField("Client Id");
//         RelyonSetup.TestField("Client Secret");
//         TempDateTime := CurrentDateTime;
//         if RelyonSetup."Authentication Validity" < TempDateTime then begin
//             RelyonAuthentications.GetAuthenticateRelyon();
//             Commit();
//             RelyOnAuthenticated := true;
//         end else
//             RelyOnAuthenticated := true;
//         Clear(TempDateTime);
//         if IRPSetup.Get(SalesInvoiceHeader."Location GST Reg. No.") then begin
//             IRPSetup.TestField("User Name");
//             IRPSetup.TestField(Password);
//         end else
//             Error(IRPSetUpDoesNotExistErr, SalesInvoiceHeader."Location GST Reg. No.");
//         TempDateTime := CurrentDateTime;
//         if IRPSetup."Token Expiry" < TempDateTime then begin
//             IRPAuthentications.GetAuthenticateIRP(SalesInvoiceHeader."Location GST Reg. No.");
//             Commit();
//             IRPAuthenticated := true
//         end else
//             IRPAuthenticated := true;
//         //Get Authentication Token from Relyon Setup
//         if RelyonSetup.Get() then begin
//             RelyonSetup.CalcFields("Autentication Token");
//             if RelyonSetup."Autentication Token".HasValue then
//                 RelyonSetup."Autentication Token".CreateInStream(AuthenticationTokenInstream)
//             else
//                 Error('%1 is empty', RelyonSetup.FieldCaption("Autentication Token"));
//         end;

//         InvoiceSetup.Get();
//         InvoiceSetup.TestField("Eway Bill Url");
//         IRPSetup.Get(SalesInvoiceHeader."Location GST Reg. No.");
//         if RelyOnAuthenticated and IRPAuthenticated then begin
//             RESTHelper.Initialize('POST', InvoiceSetup."Eway Bill Url");
//             RESTHelper.AddRequestHeader(AuthenticationTokenLbl, TypeHelper.TryReadAsTextWithSepAndFieldErrMsg(AuthenticationTokenInstream, TypeHelper.LFSeparator(), RelyonSetup.FieldName("Autentication Token")));
//             RESTHelper.AddRequestHeader(SubscriptionIdLbl, RelyonSetup."Subscription Id");
//             RESTHelper.AddRequestHeader(GstinLbl, SalesInvoiceHeader."Location GST Reg. No.");
//             RESTHelper.AddRequestHeader(UserNameLbl, IRPSetup."User Name");
//             RESTHelper.AddRequestHeader(AuthTokenLbl, IRPSetup.authToken);
//             RESTHelper.AddRequestHeader(sekLbl, IRPSetup.sek);
//             JsonObjectSalesInvoice := SalesInvoiceForEinvoice.CreateSalesInvoiceEwayBillJson(SalesInvoiceHeader);
//             JsonObjectSalesInvoice.WriteTo(JText);
//             Commit();
//             Continue := ConfirmRequestInJsonView(JText);
//             if not Continue then
//                 exit;
//             RESTHelper.AddBody(JText);
//             RESTHelper.SetContentType('application/json');
//             if RESTHelper.Send() then
//                 SalesInvoiceForEinvoice.GetResponseSalesInvoiceEwayBillJson(RESTHelper.GetResponseContentAsText(), SalesInvoiceHeader);
//             Message(RESTHelper.GetResponseContentAsText());
//         end;


//         OnAfterGeneratePostedSalesinvoiceEwayBill(SalesInvoiceHeader);
//     end;


//     procedure GenerateCancelSalesinvoiceEwayBill(var SalesInvoiceHeader: Record "Sales Invoice Header")
//     var
//         GLSetup: Record "General Ledger Setup";
//         RelyonSetup: Record "Relyon Setup";
//         IRPSetup: Record "IRP Setup";
//         InvoiceSetup: Record "NIMEInvoice Setup";
//         RESTHelper: Codeunit "NIMREST Helper";
//         RelyonAuthentications: Codeunit "Relyon Authentications";
//         IRPAuthentications: Codeunit "IRP Authentications";
//         SalesInvoiceForEinvoice: Codeunit SalesInvoiceForEinvoice;
//         TypeHelper: Codeunit "Type Helper";
//         SubscriptionIdLbl: Label 'SubscriptionId', Locked = true;
//         GstinLbl: Label 'Gstin', Locked = true;
//         UserNameLbl: Label 'UserName', Locked = true;
//         AuthTokenLbl: Label 'AuthToken', Locked = true;
//         AuthenticationTokenLbl: Label 'AuthenticationToken', locked = true;
//         sekLbl: Label 'sek', Locked = true;
//         Error1Lbl: Label 'E-Invoice and IRN Can Not Be Generated beacuse The Length Of Posting No is Greater Than 16 Charecters', Locked = true;
//         Error2Lbl: Label 'IRN Can Not Be Generate as Posting Date Is %1 Days From Today', Locked = true;
//         EinvoiceEnabledErr: Label 'API Einvoice Not enables in %1', Locked = true;
//         IRPSetUpDoesNotExistErr: Label '%1 IRP set up does not exist', Locked = true;
//         EwayBillCancelReasonMandErr: Label 'Eway Bill Cancel Reason Mandatory', Locked = true;
//         EwayBillCancelRemarkMandErr: Label 'Eway Bill Cancel Remark Mandatory', Locked = true;
//         RelyOnAuthenticated: Boolean;
//         IRPAuthenticated: Boolean;
//         JsonObjectSalesInvoice: JsonObject;
//         JText: Text;
//         Continue: Boolean;
//         TempDateTime: DateTime;
//         AuthenticationTokenInstream: InStream;
//         IsHandled: Boolean;
//     begin
//         OnBeforeGenerateCancelSalesinvoiceEwayBill(SalesInvoiceHeader, IsHandled);
//         if IsHandled then
//             exit;
//         RelyOnAuthenticated := false;
//         IRPAuthenticated := false;
//         Clear(JsonObjectSalesInvoice);
//         Clear(JText);
//         Clear(TempDateTime);
//         Clear(AuthenticationTokenInstream);
//         if GLSetup.Get() then
//             if not GLSetup."Clear Tax Einvoice" then
//                 Error(EinvoiceEnabledErr, GLSetup.TableCaption);


//         if (StrLen(SalesInvoiceHeader."No.") > 16) and (SalesInvoiceHeader."No." <> '') then
//             Message(Error1Lbl);

//         if (Today - SalesInvoiceHeader."Posting Date") > 30 then
//             Error(Error2Lbl, (Today - SalesInvoiceHeader."Posting Date"));

//         IF SalesInvoiceHeader."Cancel Reason" = SalesInvoiceHeader."Cancel Reason"::" " THEN
//             ERROR(EwayBillCancelReasonMandErr);
//         IF SalesInvoiceHeader."Cancel Remarks" = '' THEN
//             ERROR(EwayBillCancelRemarkMandErr);

//         RelyonSetup.Get();
//         RelyonSetup.TestField("Client Id");
//         RelyonSetup.TestField("Client Secret");
//         TempDateTime := CurrentDateTime;
//         if RelyonSetup."Authentication Validity" < TempDateTime then begin
//             RelyonAuthentications.GetAuthenticateRelyon();
//             Commit();
//             RelyOnAuthenticated := true;
//         end else
//             RelyOnAuthenticated := true;
//         Clear(TempDateTime);
//         if IRPSetup.Get(SalesInvoiceHeader."Location GST Reg. No.") then begin
//             IRPSetup.TestField("User Name");
//             IRPSetup.TestField(Password);
//         end else
//             Error(IRPSetUpDoesNotExistErr, SalesInvoiceHeader."Location GST Reg. No.");

//         TempDateTime := CurrentDateTime;
//         if IRPSetup."Token Expiry" < TempDateTime then begin
//             IRPAuthentications.GetAuthenticateIRP(SalesInvoiceHeader."Location GST Reg. No.");
//             Commit();
//             IRPAuthenticated := true;
//         end else
//             IRPAuthenticated := true;

//         //Get Authentication Token from Relyon Setup
//         if RelyonSetup.Get() then begin
//             RelyonSetup.CalcFields("Autentication Token");
//             if RelyonSetup."Autentication Token".HasValue then
//                 RelyonSetup."Autentication Token".CreateInStream(AuthenticationTokenInstream)
//             else
//                 Error('%1 is empty', RelyonSetup.FieldCaption("Autentication Token"));
//         end;


//         InvoiceSetup.Get();
//         InvoiceSetup.TestField("Cancel Eway Bill Url");
//         IRPSetup.Get(SalesInvoiceHeader."Location GST Reg. No.");
//         if RelyOnAuthenticated and IRPAuthenticated then begin
//             RESTHelper.Initialize('POST', InvoiceSetup."Cancel Eway Bill Url");
//             RESTHelper.AddRequestHeader(AuthenticationTokenLbl, TypeHelper.TryReadAsTextWithSepAndFieldErrMsg(AuthenticationTokenInstream, TypeHelper.LFSeparator(), RelyonSetup.FieldName("Autentication Token")));
//             RESTHelper.AddRequestHeader(SubscriptionIdLbl, RelyonSetup."Subscription Id");
//             RESTHelper.AddRequestHeader(GstinLbl, SalesInvoiceHeader."Location GST Reg. No.");
//             RESTHelper.AddRequestHeader(UserNameLbl, IRPSetup."User Name");
//             RESTHelper.AddRequestHeader(AuthTokenLbl, IRPSetup.authToken);
//             RESTHelper.AddRequestHeader(sekLbl, IRPSetup.sek);
//             RESTHelper.AddRequestHeader('action', 'CANEWB');
//             JsonObjectSalesInvoice := SalesInvoiceForEinvoice.CreateCancelSalesInvoiceEwayBillJson(SalesInvoiceHeader);
//             JsonObjectSalesInvoice.WriteTo(JText);
//             Commit();
//             Continue := ConfirmRequestInJsonView(JText);
//             if not Continue then
//                 exit;
//             RESTHelper.AddBody(JText);
//             RESTHelper.SetContentType('application/json');
//             if RESTHelper.Send() then
//                 SalesInvoiceForEinvoice.GetResponseCancelSalesInvoiceEwayBillJson(RESTHelper.GetResponseContentAsText(), SalesInvoiceHeader);

//             Message(RESTHelper.GetResponseContentAsText());

//         end;


//         OnAfterGenerateCancelSalesinvoiceEwayBill(SalesInvoiceHeader);
//     end;

//     /// <summary>
//     /// Generate IRN for Sales Credit Memo
//     /// </summary>
//     /// <param name="SalesCrMemoHeader"></param>
//     procedure GeneratePostedSalesCrEinvoice(var SalesCrMemoHeader: Record "Sales Cr.Memo Header")
//     var
//         GLSetup: Record "General Ledger Setup";
//         RelyonSetup: Record "Relyon Setup";
//         IRPSetup: Record "IRP Setup";
//         InvoiceSetup: Record "NIMEInvoice Setup";
//         RESTHelper: Codeunit "NIMREST Helper";
//         RelyonAuthentications: Codeunit "Relyon Authentications";
//         IRPAuthentications: Codeunit "IRP Authentications";
//         SalesCrMemoForEinvoice: Codeunit SalesCrMemoForEinvoice;
//         TypeHelper: Codeunit "Type Helper";
//         SubscriptionIdLbl: Label 'SubscriptionId', Locked = true;
//         GstinLbl: Label 'Gstin', Locked = true;
//         UserNameLbl: Label 'UserName', Locked = true;
//         AuthTokenLbl: Label 'AuthToken', Locked = true;
//         AuthenticationTokenLbl: Label 'AuthenticationToken', locked = true;
//         sekLbl: Label 'sek', Locked = true;
//         Error1Lbl: Label 'E-Invoice and IRN Can Not Be Generated beacuse The Length Of Posting No is Greater Than 16 Charecters', Locked = true;
//         Error2Lbl: Label 'IRN Can Not Be Generate as Posting Date Is %1 Days From Today', Locked = true;
//         EinvoiceEnabledErr: Label 'API Einvoice Not enables in %1', Locked = true;
//         IRPSetUpDoesNotExistErr: Label '%1 IRP set up does not exist', Locked = true;
//         IsHandled: Boolean;
//         RelyOnAuthenticated: Boolean;
//         IRPAuthenticated: Boolean;
//         JsonObjectSalesCrMemo: JsonObject;
//         JText: Text;
//         Continue: Boolean;
//         TempDateTime: DateTime;
//         AuthenticationTokenInstream: InStream;

//     begin
//         OnBeforeGeneratePostedSalesCrEinvoice(SalesCrMemoHeader, IsHandled);
//         if IsHandled then
//             exit;
//         RelyOnAuthenticated := false;
//         IRPAuthenticated := false;
//         Clear(JsonObjectSalesCrMemo);
//         Clear(JText);
//         Clear(TempDateTime);
//         Clear(AuthenticationTokenInstream);
//         if GLSetup.Get() then
//             if not GLSetup."Clear Tax Einvoice" then
//                 Error(EinvoiceEnabledErr, GLSetup.TableCaption);
//         if (StrLen(SalesCrMemoHeader."No.") > 16) and (SalesCrMemoHeader."No." <> '') then
//             Message(Error1Lbl);

//         if (Today - SalesCrMemoHeader."Posting Date") > 30 then
//             Error(Error2Lbl, (Today - SalesCrMemoHeader."Posting Date"));
//         //Check the value from sales header.
//         SalesCrMemoHeader.TestField("Location GST Reg. No.");
//         SalesCrMemoHeader.TestField("Acknowledgement No.", '');
//         SalesCrMemoHeader.TestField("Acknowledgement Date", 0DT);
//         SalesCrMemoHeader.TestField("IRN Hash", '');

//         RelyonSetup.Get();
//         RelyonSetup.TestField("Client Id");
//         RelyonSetup.TestField("Client Secret");

//         TempDateTime := CurrentDateTime;
//         if RelyonSetup."Authentication Validity" < TempDateTime then begin
//             RelyonAuthentications.GetAuthenticateRelyon();
//             Commit();
//             RelyOnAuthenticated := true;
//         end else
//             RelyOnAuthenticated := true;
//         Clear(TempDateTime);
//         if IRPSetup.Get(SalesCrMemoHeader."Location GST Reg. No.") then begin
//             IRPSetup.TestField("User Name");
//             IRPSetup.TestField(Password);
//         end else
//             Error(IRPSetUpDoesNotExistErr, SalesCrMemoHeader."Location GST Reg. No.");
//         TempDateTime := CurrentDateTime;
//         if IRPSetup."Token Expiry" < TempDateTime then begin
//             IRPAuthentications.GetAuthenticateIRP(SalesCrMemoHeader."Location GST Reg. No.");
//             Commit();
//             IRPAuthenticated := true
//         end else
//             IRPAuthenticated := true;
//         //Get Authentication Token from Relyon Setup.
//         if RelyonSetup.Get() then begin
//             RelyonSetup.CalcFields("Autentication Token");
//             if RelyonSetup."Autentication Token".HasValue then
//                 RelyonSetup."Autentication Token".CreateInStream(AuthenticationTokenInstream)
//             else
//                 Error('%1 is empty', RelyonSetup.FieldCaption("Autentication Token"));
//         end;

//         InvoiceSetup.Get();
//         InvoiceSetup.TestField("EInvoice Url");
//         IRPSetup.Get(SalesCrMemoHeader."Location GST Reg. No.");

//         if RelyOnAuthenticated and IRPAuthenticated then begin
//             RESTHelper.Initialize('POST', InvoiceSetup."EInvoice Url");
//             RESTHelper.AddRequestHeader(AuthenticationTokenLbl, TypeHelper.TryReadAsTextWithSepAndFieldErrMsg(AuthenticationTokenInstream, TypeHelper.LFSeparator(), RelyonSetup.FieldName("Autentication Token")));
//             RESTHelper.AddRequestHeader(SubscriptionIdLbl, RelyonSetup."Subscription Id");
//             RESTHelper.AddRequestHeader(GstinLbl, SalesCrMemoHeader."Location GST Reg. No.");
//             RESTHelper.AddRequestHeader(UserNameLbl, IRPSetup."User Name");
//             RESTHelper.AddRequestHeader(AuthTokenLbl, IRPSetup.authToken);
//             RESTHelper.AddRequestHeader(sekLbl, IRPSetup.sek);
//             JsonObjectSalesCrMemo := SalesCrMemoForEinvoice.CreateSalesCreditMemoJson(SalesCrMemoHeader);
//             JsonObjectSalesCrMemo.WriteTo(JText);
//             Commit();
//             Continue := ConfirmRequestInJsonView(JText);
//             if not Continue then
//                 exit;
//             RESTHelper.AddBody(JText);
//             RESTHelper.SetContentType('application/json');
//             if RESTHelper.Send() then
//                 SalesCrMemoForEinvoice.GetResponseFromSalesCrEinvoice(RESTHelper.GetResponseContentAsText(), SalesCrMemoHeader);
//             Message(RESTHelper.GetResponseContentAsText());

//         end;
//         OnAfterGeneratePostedSalesCrEinvoice(SalesCrMemoHeader);
//     end;
//     /// <summary>
//     /// 
//     /// </summary>
//     /// <param name="SalesCrMemoHeader"></param>
//     procedure GenerateCanceledSalesCrEinvoice(var SalesCrMemoHeader: Record "Sales Cr.Memo Header")
//     var
//         GLSetup: Record "General Ledger Setup";
//         RelyonSetup: Record "Relyon Setup";
//         IRPSetup: Record "IRP Setup";
//         InvoiceSetup: Record "NIMEInvoice Setup";
//         RESTHelper: Codeunit "NIMREST Helper";
//         RelyonAuthentications: Codeunit "Relyon Authentications";
//         IRPAuthentications: Codeunit "IRP Authentications";
//         SalesCrMemoForEinvoice: Codeunit SalesCrMemoForEinvoice;
//         TypeHelper: Codeunit "Type Helper";
//         AuthenticationTokenLbl: Label 'AuthenticationToken', locked = true;
//         SubscriptionIdLbl: Label 'SubscriptionId', Locked = true;
//         GstinLbl: Label 'Gstin', Locked = true;
//         UserNameLbl: Label 'UserName', Locked = true;
//         AuthTokenLbl: Label 'AuthToken', Locked = true;
//         sekLbl: Label 'sek', Locked = true;
//         Error1Lbl: Label 'E-Invoice and IRN Can Not Be Generated beacuse The Length Of Posting No is Greater Than 16 Charecters', Locked = true;
//         Error2Lbl: Label 'IRN Can Not Be Generate as Posting Date Is %1 Days From Today', Locked = true;
//         EinvoiceEnabledErr: Label 'API Einvoice Not enables in %1', Locked = true;
//         IRPSetUpDoesNotExistErr: Label '%1 IRP set up does not exist', Locked = true;
//         IsHandled: Boolean;
//         RelyOnAuthenticated: Boolean;
//         IRPAuthenticated: Boolean;
//         JsonObjectSalesCrMemo: JsonObject;
//         JText: Text;
//         TempDateTime: DateTime;
//         Continue: Boolean;
//         AuthenticationTokenInstream: InStream;
//     begin
//         OnBeforeGenerateCanceledSalesCrEinvoice(SalesCrMemoHeader, IsHandled);
//         if IsHandled then
//             exit;
//         RelyOnAuthenticated := false;
//         IRPAuthenticated := false;
//         Clear(JsonObjectSalesCrMemo);
//         Clear(JText);
//         Clear(TempDateTime);
//         if GLSetup.Get() then
//             if not GLSetup."Clear Tax Einvoice" then
//                 Error(EinvoiceEnabledErr, GLSetup.TableCaption);

//         if (StrLen(SalesCrMemoHeader."No.") > 16) and (SalesCrMemoHeader."No." <> '') then
//             Message(Error1Lbl);

//         if (Today - SalesCrMemoHeader."Posting Date") > 30 then
//             Error(Error2Lbl, (Today - SalesCrMemoHeader."Posting Date"));
//         SalesCrMemoHeader.TestField("IRN Hash");
//         SalesCrMemoHeader.TestField("Cancel Reason");
//         SalesCrMemoHeader.TestField("Cancel Remarks");
//         RelyonSetup.Get();
//         RelyonSetup.TestField("Client Id");
//         RelyonSetup.TestField("Client Secret");
//         TempDateTime := CurrentDateTime;
//         if RelyonSetup."Authentication Validity" < TempDateTime then begin
//             RelyonAuthentications.GetAuthenticateRelyon();
//             Commit();
//             RelyOnAuthenticated := true;
//         end else
//             RelyOnAuthenticated := true;
//         Clear(TempDateTime);
//         if IRPSetup.Get(SalesCrMemoHeader."Location GST Reg. No.") then begin
//             IRPSetup.TestField("User Name");
//             IRPSetup.TestField(Password);
//         end else
//             Error(IRPSetUpDoesNotExistErr, SalesCrMemoHeader."Location GST Reg. No.");
//         TempDateTime := CurrentDateTime;
//         if IRPSetup."Token Expiry" < TempDateTime then begin
//             IRPAuthentications.GetAuthenticateIRP(SalesCrMemoHeader."Location GST Reg. No.");
//             Commit();
//             IRPAuthenticated := true
//         end else
//             IRPAuthenticated := true;

//         InvoiceSetup.Get();
//         InvoiceSetup.TestField("Cancel EInvoice Url");
//         if RelyOnAuthenticated and IRPAuthenticated then begin
//             RESTHelper.Initialize('POST', InvoiceSetup."Cancel EInvoice Url");
//             RESTHelper.AddRequestHeader(AuthenticationTokenLbl, TypeHelper.TryReadAsTextWithSepAndFieldErrMsg(AuthenticationTokenInstream, TypeHelper.LFSeparator(), RelyonSetup.FieldName("Autentication Token")));
//             RESTHelper.AddRequestHeader(SubscriptionIdLbl, RelyonSetup."Subscription Id");
//             RESTHelper.AddRequestHeader(GstinLbl, SalesCrMemoHeader."Location GST Reg. No.");
//             RESTHelper.AddRequestHeader(UserNameLbl, IRPSetup."User Name");
//             RESTHelper.AddRequestHeader(AuthTokenLbl, IRPSetup.authToken);
//             RESTHelper.AddRequestHeader(sekLbl, IRPSetup.sek);
//             Clear(JText);
//             JsonObjectSalesCrMemo := SalesCrMemoForEinvoice.CreateCancelSaleCrEinvoiceJSON(SalesCrMemoHeader);
//             JsonObjectSalesCrMemo.WriteTo(JText);
//             Commit();
//             Continue := ConfirmRequestInJsonView(JText);
//             if not Continue then
//                 exit;
//             RESTHelper.AddBody(JText);
//             RESTHelper.SetContentType('application/json');
//             if RESTHelper.Send() then
//                 SalesCrMemoForEinvoice.GetResponseFromCanceledSalesCrEinvoice(RESTHelper.GetResponseContentAsText(), SalesCrMemoHeader);
//             Message(RESTHelper.GetResponseContentAsText());


//         end;
//         OnAfterGenerateCanceledSalesCrEinvoice(SalesCrMemoHeader);
//     end;
//     /// <summary>
//     /// Generate IRN for Transfer Shipment.
//     /// </summary>
//     /// <param name="TransferShipmentHeader"></param>
//     procedure GenerateTransferShipmentEinvoice(var TransferShipmentHeader: Record "Transfer Shipment Header")
//     var
//         GLSetup: Record "General Ledger Setup";
//         RelyonSetup: Record "Relyon Setup";
//         IRPSetup: Record "IRP Setup";
//         InvoiceSetup: Record "NIMEInvoice Setup";
//         LocationBuff: Record Location;
//         RESTHelper: Codeunit "NIMREST Helper";
//         RelyonAuthentications: Codeunit "Relyon Authentications";
//         IRPAuthentications: Codeunit "IRP Authentications";
//         TransferOrderForEinvoice: Codeunit TransferOrderForEinvoice;
//         TypeHelper: Codeunit "Type Helper";
//         SubscriptionIdLbl: Label 'SubscriptionId', Locked = true;
//         GstinLbl: Label 'Gstin', Locked = true;
//         UserNameLbl: Label 'UserName', Locked = true;
//         AuthTokenLbl: Label 'AuthToken', Locked = true;
//         AuthenticationTokenLbl: Label 'AuthenticationToken', locked = true;
//         sekLbl: Label 'sek', Locked = true;
//         Error1Lbl: Label 'E-Invoice and IRN Can Not Be Generated beacuse The Length Of Posting No is Greater Than 16 Charecters', Locked = true;
//         Error2Lbl: Label 'IRN Can Not Be Generate as Posting Date Is %1 Days From Today', Locked = true;
//         EinvoiceEnabledErr: Label 'API Einvoice Not enables in %1', Locked = true;
//         IRPSetUpDoesNotExistErr: Label '%1 IRP set up does not exist', Locked = true;
//         IsHandled: Boolean;
//         RelyOnAuthenticated: Boolean;
//         IRPAuthenticated: Boolean;
//         JsonObjectTransferShipment: JsonObject;
//         JText: Text;
//         TempDateTime: DateTime;
//         Continue: Boolean;
//         AuthenticationTokenInstream: InStream;
//     begin
//         OnBeforeGenerateTransferShipmentEinvoice(TransferShipmentHeader, IsHandled);
//         if IsHandled then
//             exit;

//         RelyOnAuthenticated := false;
//         IRPAuthenticated := false;
//         //Clear Locations variables.
//         Clear(JsonObjectTransferShipment);
//         Clear(JText);
//         Clear(TempDateTime);
//         Clear(AuthenticationTokenInstream);
//         if GLSetup.Get() then
//             if not GLSetup."Clear Tax Einvoice" then
//                 Error(EinvoiceEnabledErr, GLSetup.TableCaption);
//         if (StrLen(TransferShipmentHeader."No.") > 16) and (TransferShipmentHeader."No." <> '') then
//             Message(Error1Lbl);

//         if (Today - TransferShipmentHeader."Posting Date") > 30 then
//             Error(Error2Lbl, (Today - TransferShipmentHeader."Posting Date"));
//         if LocationBuff.Get(TransferShipmentHeader."Transfer-from Code") then
//             LocationBuff.TestField("GST Registration No.");
//         TransferShipmentHeader.TestField("Acknowledgement No.", '');
//         TransferShipmentHeader.TestField("Acknowledgement Date", 0DT);
//         TransferShipmentHeader.TestField("IRN Hash", '');

//         RelyonSetup.Get();
//         RelyonSetup.TestField("Client Id");
//         RelyonSetup.TestField("Client Secret");
//         TempDateTime := CurrentDateTime;
//         if RelyonSetup."Authentication Validity" < TempDateTime then begin
//             RelyonAuthentications.GetAuthenticateRelyon();
//             Commit();
//             RelyOnAuthenticated := true;
//         end else
//             RelyOnAuthenticated := true;
//         Clear(TempDateTime);
//         if IRPSetup.Get(LocationBuff."GST Registration No.") then begin
//             IRPSetup.TestField("User Name");
//             IRPSetup.TestField(Password);
//         end else
//             Error(IRPSetUpDoesNotExistErr, LocationBuff."GST Registration No.");
//         TempDateTime := CurrentDateTime;
//         if IRPSetup."Token Expiry" < TempDateTime then begin
//             IRPAuthentications.GetAuthenticateIRP(LocationBuff."GST Registration No.");
//             Commit();
//             IRPAuthenticated := true
//         end else
//             IRPAuthenticated := true;

//         //Get Authentication Token from Relyon Setup.
//         if RelyonSetup.Get() then begin
//             RelyonSetup.CalcFields("Autentication Token");
//             if RelyonSetup."Autentication Token".HasValue then
//                 RelyonSetup."Autentication Token".CreateInStream(AuthenticationTokenInstream)
//             else
//                 Error('%1 is empty', RelyonSetup.FieldCaption("Autentication Token"));
//         end;


//         InvoiceSetup.Get();
//         InvoiceSetup.TestField("EInvoice Url");
//         IRPSetup.Get(LocationBuff."GST Registration No.");

//         if RelyOnAuthenticated and IRPAuthenticated then begin
//             RESTHelper.Initialize('POST', InvoiceSetup."EInvoice Url");
//             RESTHelper.AddRequestHeader(AuthenticationTokenLbl, TypeHelper.TryReadAsTextWithSepAndFieldErrMsg(AuthenticationTokenInstream, TypeHelper.LFSeparator(), RelyonSetup.FieldName("Autentication Token")));
//             RESTHelper.AddRequestHeader(SubscriptionIdLbl, RelyonSetup."Subscription Id");
//             RESTHelper.AddRequestHeader(GstinLbl, LocationBuff."GST Registration No.");
//             RESTHelper.AddRequestHeader(UserNameLbl, IRPSetup."User Name");
//             RESTHelper.AddRequestHeader(AuthTokenLbl, IRPSetup.authToken);
//             RESTHelper.AddRequestHeader(sekLbl, IRPSetup.sek);
//             JsonObjectTransferShipment := TransferOrderForEinvoice.CreateTransferShipmentJson(TransferShipmentHeader);
//             JsonObjectTransferShipment.WriteTo(JText);
//             Commit();
//             Continue := ConfirmRequestInJsonView(JText);
//             if not Continue then
//                 exit;
//             RESTHelper.AddBody(JText);
//             RESTHelper.SetContentType('application/json');
//             if RESTHelper.Send() then
//                 TransferOrderForEinvoice.GetResponseFromTransferShipmentEinvoice(RESTHelper.GetResponseContentAsText(), TransferShipmentHeader);
//             Message(RESTHelper.GetResponseContentAsText());


//         end;

//         OnAfterGenerateTransferShipmentEinvoice(TransferShipmentHeader);
//     end;

//     /// <summary>
//     /// Cancelled IRN for transfer Shipment.
//     /// </summary>
//     /// <param name="Rec"></param>
//     procedure GenerateCanceledTransferShipmentEinvoice(var TransferShipmentHeader: Record "Transfer Shipment Header")
//     var
//         GLSetup: Record "General Ledger Setup";
//         RelyonSetup: Record "Relyon Setup";
//         IRPSetup: Record "IRP Setup";
//         InvoiceSetup: Record "NIMEInvoice Setup";
//         LocationBuff: Record Location;
//         RESTHelper: Codeunit "NIMREST Helper";
//         RelyonAuthentications: Codeunit "Relyon Authentications";
//         IRPAuthentications: Codeunit "IRP Authentications";
//         TransferOrderForEinvoice: Codeunit TransferOrderForEinvoice;
//         TypeHelper: Codeunit "Type Helper";
//         AuthenticationTokenLbl: Label 'AuthenticationToken', locked = true;
//         SubscriptionIdLbl: Label 'SubscriptionId', Locked = true;
//         GstinLbl: Label 'Gstin', Locked = true;
//         UserNameLbl: Label 'UserName', Locked = true;
//         AuthTokenLbl: Label 'AuthToken', Locked = true;
//         sekLbl: Label 'sek', Locked = true;
//         Error1Lbl: Label 'E-Invoice and IRN Can Not Be Generated beacuse The Length Of Posting No is Greater Than 16 Charecters', Locked = true;
//         Error2Lbl: Label 'IRN Can Not Be Generate as Posting Date Is %1 Days From Today', Locked = true;
//         EinvoiceEnabledErr: Label 'API Einvoice Not enables in %1', Locked = true;
//         IRPSetUpDoesNotExistErr: Label '%1 IRP set up does not exist', Locked = true;

//         IsHandled: Boolean;
//         RelyOnAuthenticated: Boolean;
//         IRPAuthenticated: Boolean;
//         JsonObjectTransferShipment: JsonObject;
//         JText: Text;
//         TempDateTime: DateTime;
//         Continue: Boolean;
//         AuthenticationTokenInstream: InStream;
//     begin
//         OnBeforeGenerateCanceledTransferShipmentEinvoice(TransferShipmentHeader, IsHandled);
//         if IsHandled then
//             exit;

//         RelyOnAuthenticated := false;
//         IRPAuthenticated := false;
//         Clear(JsonObjectTransferShipment);
//         Clear(JText);
//         Clear(TempDateTime);
//         if GLSetup.Get() then
//             if not GLSetup."Clear Tax Einvoice" then
//                 Error(EinvoiceEnabledErr, GLSetup.TableCaption);
//         TransferShipmentHeader.TestField("IRN Hash");
//         TransferShipmentHeader.TestField("Cancel Reason");
//         TransferShipmentHeader.TestField("Cancel Remarks");

//         if (StrLen(TransferShipmentHeader."No.") > 16) and (TransferShipmentHeader."No." <> '') then
//             Message(Error1Lbl);

//         if (Today - TransferShipmentHeader."Posting Date") > 30 then
//             Error(Error2Lbl, (Today - TransferShipmentHeader."Posting Date"));
//         if LocationBuff.Get(TransferShipmentHeader."Transfer-from Code") then
//             LocationBuff.TestField("GST Registration No.");

//         RelyonSetup.Get();
//         RelyonSetup.TestField("Client Id");
//         RelyonSetup.TestField("Client Secret");
//         TempDateTime := CurrentDateTime;
//         if RelyonSetup."Authentication Validity" < TempDateTime then begin
//             RelyonAuthentications.GetAuthenticateRelyon();
//             Commit();
//             RelyOnAuthenticated := true;
//         end else
//             RelyOnAuthenticated := true;
//         Clear(TempDateTime);
//         if IRPSetup.Get(LocationBuff."GST Registration No.") then begin
//             IRPSetup.TestField("User Name");
//             IRPSetup.TestField(Password);
//         end else
//             Error(IRPSetUpDoesNotExistErr, LocationBuff."GST Registration No.");
//         TempDateTime := CurrentDateTime;
//         if IRPSetup."Token Expiry" < TempDateTime then begin
//             IRPAuthentications.GetAuthenticateIRP(LocationBuff."GST Registration No.");
//             Commit();
//             IRPAuthenticated := true
//         end else
//             IRPAuthenticated := true;
//         InvoiceSetup.Get();
//         InvoiceSetup.TestField("Cancel EInvoice Url");
//         //Get Authentication token from Relyon Setup.
//         if RelyonSetup.Get() then begin
//             RelyonSetup.CalcFields("Autentication Token");
//             if RelyonSetup."Autentication Token".HasValue then
//                 RelyonSetup."Autentication Token".CreateInStream(AuthenticationTokenInstream)
//             else
//                 Error('%1 is empty', RelyonSetup.FieldCaption("Autentication Token"));
//         end;
//         IRPSetup.Get(LocationBuff."GST Registration No.");
//         if RelyOnAuthenticated and IRPAuthenticated then begin
//             RESTHelper.Initialize('POST', InvoiceSetup."Cancel EInvoice Url");
//             RESTHelper.AddRequestHeader(AuthenticationTokenLbl, TypeHelper.TryReadAsTextWithSepAndFieldErrMsg(AuthenticationTokenInstream, TypeHelper.LFSeparator(), RelyonSetup.FieldName("Autentication Token")));
//             RESTHelper.AddRequestHeader(SubscriptionIdLbl, RelyonSetup."Subscription Id");
//             RESTHelper.AddRequestHeader(GstinLbl, LocationBuff."GST Registration No.");
//             RESTHelper.AddRequestHeader(UserNameLbl, IRPSetup."User Name");
//             RESTHelper.AddRequestHeader(AuthTokenLbl, IRPSetup.authToken);
//             RESTHelper.AddRequestHeader(sekLbl, IRPSetup.sek);
//             RESTHelper.AddRequestHeader('action', 'CANEWB');
//             Clear(JText);
//             JsonObjectTransferShipment := TransferOrderForEinvoice.CreateCancelTransferShipmentJson(TransferShipmentHeader);
//             JsonObjectTransferShipment.WriteTo(JText);
//             Commit();
//             Continue := ConfirmRequestInJsonView(JText);
//             if not Continue then
//                 exit;
//             RESTHelper.AddBody(JText);
//             RESTHelper.SetContentType('application/json');
//             if RESTHelper.Send() then
//                 TransferOrderForEinvoice.GetResponseFromCanceledTransferShipmentEinvoice(RESTHelper.GetResponseContentAsText(), TransferShipmentHeader);

//             Message(RESTHelper.GetResponseContentAsText());
//         end;

//         OnAfterGenerateCanceledTransferShipmentEinvoice(TransferShipmentHeader);
//     end;
//     /// <summary>
//     /// Generate Eway Bill By IRN in Transfer Shipment.
//     /// </summary>
//     /// <param name="TransferShipmentHeader"></param>
//     procedure GenerateTransferShipmentEwayBill(var TransferShipmentHeader: Record "Transfer Shipment Header")
//     var
//         GLSetup: Record "General Ledger Setup";
//         RelyonSetup: Record "Relyon Setup";
//         IRPSetup: Record "IRP Setup";
//         InvoiceSetup: Record "NIMEInvoice Setup";
//         LocationBuff: Record Location;
//         RESTHelper: Codeunit "NIMREST Helper";
//         RelyonAuthentications: Codeunit "Relyon Authentications";
//         IRPAuthentications: Codeunit "IRP Authentications";
//         TransferOrderForEinvoice: Codeunit TransferOrderForEinvoice;
//         TypeHelper: Codeunit "Type Helper";
//         SubscriptionIdLbl: Label 'SubscriptionId', Locked = true;
//         GstinLbl: Label 'Gstin', Locked = true;
//         UserNameLbl: Label 'UserName', Locked = true;
//         AuthTokenLbl: Label 'AuthToken', Locked = true;
//         AuthenticationTokenLbl: Label 'AuthenticationToken', locked = true;
//         sekLbl: Label 'sek', Locked = true;
//         Error1Lbl: Label 'E-Invoice and IRN Can Not Be Generated beacuse The Length Of Posting No is Greater Than 16 Charecters', Locked = true;
//         Error2Lbl: Label 'IRN Can Not Be Generate as Posting Date Is %1 Days From Today', Locked = true;
//         EinvoiceEnabledErr: Label 'API Einvoice Not enables in %1', Locked = true;
//         IRPSetUpDoesNotExistErr: Label '%1 IRP set up does not exist', Locked = true;

//         RelyOnAuthenticated: Boolean;
//         IRPAuthenticated: Boolean;
//         JsonObjectTransferShipment: JsonObject;
//         JText: Text;
//         Continue: Boolean;
//         TempDateTime: DateTime;
//         AuthenticationTokenInstream: InStream;
//         IsHandled: Boolean;
//     begin
//         OnBeforeGenerateTransferShipmentEwayBill(TransferShipmentHeader, IsHandled);
//         if IsHandled then
//             exit;

//         RelyOnAuthenticated := false;
//         IRPAuthenticated := false;
//         Clear(JsonObjectTransferShipment);
//         Clear(JText);
//         Clear(TempDateTime);
//         Clear(AuthenticationTokenInstream);
//         Clear(Continue);
//         if GLSetup.Get() then
//             if not GLSetup."Clear Tax Einvoice" then
//                 Error(EinvoiceEnabledErr, GLSetup.TableCaption);


//         if (StrLen(TransferShipmentHeader."No.") > 16) and (TransferShipmentHeader."No." <> '') then
//             Message(Error1Lbl);

//         if (Today - TransferShipmentHeader."Posting Date") > 30 then
//             Error(Error2Lbl, (Today - TransferShipmentHeader."Posting Date"));
//         TransferShipmentHeader.TestField("IRN Hash");
//         TransferShipmentHeader.TestField("Distance (Km)");
//         if LocationBuff.Get(TransferShipmentHeader."Transfer-from Code") then
//             LocationBuff.TestField("GST Registration No.");


//         RelyonSetup.Get();
//         RelyonSetup.TestField("Client Id");
//         RelyonSetup.TestField("Client Secret");
//         TempDateTime := CurrentDateTime;
//         if RelyonSetup."Authentication Validity" < TempDateTime then begin
//             RelyonAuthentications.GetAuthenticateRelyon();
//             Commit();
//             RelyOnAuthenticated := true;
//         end else
//             RelyOnAuthenticated := true;
//         Clear(TempDateTime);
//         if IRPSetup.Get(LocationBuff."GST Registration No.") then begin
//             IRPSetup.TestField("User Name");
//             IRPSetup.TestField(Password);
//         end else
//             Error(IRPSetUpDoesNotExistErr, LocationBuff."GST Registration No.");

//         TempDateTime := CurrentDateTime;
//         if IRPSetup."Token Expiry" < TempDateTime then begin
//             IRPAuthentications.GetAuthenticateIRP(LocationBuff."GST Registration No.");
//             Commit();
//             IRPAuthenticated := true;
//         end else
//             IRPAuthenticated := true;

//         //Get Authentication Token from Relyon Setup
//         if RelyonSetup.Get() then begin
//             RelyonSetup.CalcFields("Autentication Token");
//             if RelyonSetup."Autentication Token".HasValue then
//                 RelyonSetup."Autentication Token".CreateInStream(AuthenticationTokenInstream)
//             else
//                 Error('%1 is empty', RelyonSetup.FieldCaption("Autentication Token"));
//         end;

//         InvoiceSetup.Get();
//         InvoiceSetup.TestField("Eway Bill Url");
//         IRPSetup.Get(LocationBuff."GST Registration No.");
//         if RelyOnAuthenticated and IRPAuthenticated then begin
//             RESTHelper.Initialize('POST', InvoiceSetup."Eway Bill Url");
//             RESTHelper.AddRequestHeader(AuthenticationTokenLbl, TypeHelper.TryReadAsTextWithSepAndFieldErrMsg(AuthenticationTokenInstream, TypeHelper.LFSeparator(), RelyonSetup.FieldName("Autentication Token")));
//             RESTHelper.AddRequestHeader(SubscriptionIdLbl, RelyonSetup."Subscription Id");
//             RESTHelper.AddRequestHeader(GstinLbl, LocationBuff."GST Registration No.");
//             RESTHelper.AddRequestHeader(UserNameLbl, IRPSetup."User Name");
//             RESTHelper.AddRequestHeader(AuthTokenLbl, IRPSetup.authToken);
//             RESTHelper.AddRequestHeader(sekLbl, IRPSetup.sek);
//             JsonObjectTransferShipment := TransferOrderForEinvoice.CreateTransferShipmentEwayBillJson(TransferShipmentHeader);
//             JsonObjectTransferShipment.WriteTo(JText);
//             Commit();
//             Continue := ConfirmRequestInJsonView(JText);
//             if not Continue then
//                 exit;
//             RESTHelper.AddBody(JText);
//             RESTHelper.SetContentType('application/json');
//             if RESTHelper.Send() then
//                 TransferOrderForEinvoice.GetResponseTransferShipmentEwayBillJson(RESTHelper.GetResponseContentAsText(), TransferShipmentHeader);

//             Message(RESTHelper.GetResponseContentAsText());

//         end;

//         OnAfterGenerateTransferShipmentEwayBill(TransferShipmentHeader);
//     end;

//     procedure GenerateCancelTransferShipmentEwayBill(var TransferShipmentHeader: Record "Transfer Shipment Header")
//     var
//         GLSetup: Record "General Ledger Setup";
//         RelyonSetup: Record "Relyon Setup";
//         IRPSetup: Record "IRP Setup";
//         InvoiceSetup: Record "NIMEInvoice Setup";
//         LocationBuff: Record Location;
//         RESTHelper: Codeunit "NIMREST Helper";
//         RelyonAuthentications: Codeunit "Relyon Authentications";
//         IRPAuthentications: Codeunit "IRP Authentications";
//         TransferOrderForEinvoice: Codeunit TransferOrderForEinvoice;
//         TypeHelper: Codeunit "Type Helper";
//         SubscriptionIdLbl: Label 'SubscriptionId', Locked = true;
//         GstinLbl: Label 'Gstin', Locked = true;
//         UserNameLbl: Label 'UserName', Locked = true;
//         AuthTokenLbl: Label 'AuthToken', Locked = true;
//         AuthenticationTokenLbl: Label 'AuthenticationToken', locked = true;
//         sekLbl: Label 'sek', Locked = true;
//         Error1Lbl: Label 'E-Invoice and IRN Can Not Be Generated beacuse The Length Of Posting No is Greater Than 16 Charecters', Locked = true;
//         Error2Lbl: Label 'IRN Can Not Be Generate as Posting Date Is %1 Days From Today', Locked = true;
//         EinvoiceEnabledErr: Label 'API Einvoice Not enables in %1', Locked = true;
//         IRPSetUpDoesNotExistErr: Label '%1 IRP set up does not exist', Locked = true;
//         EwayBillCancelReasonMandErr: Label 'Eway Bill Cancel Reason Mandatory', Locked = true;
//         EwayBillCancelRemarkMandErr: Label 'Eway Bill Cancel Remark Mandatory', Locked = true;
//         RelyOnAuthenticated: Boolean;
//         IRPAuthenticated: Boolean;
//         JsonObjectTransferShipment: JsonObject;
//         JText: Text;
//         Continue: Boolean;
//         TempDateTime: DateTime;
//         AuthenticationTokenInstream: InStream;
//         IsHandled: Boolean;
//     begin
//         OnBeforeGenerateCancelTransferShipmentEwayBill(TransferShipmentHeader, IsHandled);
//         if IsHandled then
//             exit;

//         RelyOnAuthenticated := false;
//         IRPAuthenticated := false;
//         Clear(JsonObjectTransferShipment);
//         Clear(JText);
//         Clear(TempDateTime);
//         Clear(AuthenticationTokenInstream);
//         if GLSetup.Get() then
//             if not GLSetup."Clear Tax Einvoice" then
//                 Error(EinvoiceEnabledErr, GLSetup.TableCaption);


//         if (StrLen(TransferShipmentHeader."No.") > 16) and (TransferShipmentHeader."No." <> '') then
//             Message(Error1Lbl);

//         if (Today - TransferShipmentHeader."Posting Date") > 30 then
//             Error(Error2Lbl, (Today - TransferShipmentHeader."Posting Date"));

//         IF TransferShipmentHeader."Cancel Reason" = TransferShipmentHeader."Cancel Reason"::" " THEN
//             ERROR(EwayBillCancelReasonMandErr);
//         IF TransferShipmentHeader."Cancel Remarks" = '' THEN
//             ERROR(EwayBillCancelRemarkMandErr);
//         if LocationBuff.Get(TransferShipmentHeader."Transfer-from Code") then
//             LocationBuff.TestField("GST Registration No.");


//         RelyonSetup.Get();
//         RelyonSetup.TestField("Client Id");
//         RelyonSetup.TestField("Client Secret");
//         TempDateTime := CurrentDateTime;
//         if RelyonSetup."Authentication Validity" < TempDateTime then begin
//             RelyonAuthentications.GetAuthenticateRelyon();
//             Commit();
//             RelyOnAuthenticated := true;
//         end else
//             RelyOnAuthenticated := true;
//         Clear(TempDateTime);
//         if IRPSetup.Get(LocationBuff."GST Registration No.") then begin
//             IRPSetup.TestField("User Name");
//             IRPSetup.TestField(Password);
//         end else
//             Error(IRPSetUpDoesNotExistErr, LocationBuff."GST Registration No.");

//         TempDateTime := CurrentDateTime;
//         if IRPSetup."Token Expiry" < TempDateTime then begin
//             IRPAuthentications.GetAuthenticateIRP(LocationBuff."GST Registration No.");
//             Commit();
//             IRPAuthenticated := true;
//         end else
//             IRPAuthenticated := true;

//         //Get Authentication Token from Relyon Setup
//         if RelyonSetup.Get() then begin
//             RelyonSetup.CalcFields("Autentication Token");
//             if RelyonSetup."Autentication Token".HasValue then
//                 RelyonSetup."Autentication Token".CreateInStream(AuthenticationTokenInstream)
//             else
//                 Error('%1 is empty', RelyonSetup.FieldCaption("Autentication Token"));
//         end;


//         InvoiceSetup.Get();
//         InvoiceSetup.TestField("Cancel Eway Bill Url");
//         IRPSetup.Get(LocationBuff."GST Registration No.");
//         if RelyOnAuthenticated and IRPAuthenticated then begin
//             RESTHelper.Initialize('POST', InvoiceSetup."Cancel Eway Bill Url");
//             RESTHelper.AddRequestHeader(AuthenticationTokenLbl, TypeHelper.TryReadAsTextWithSepAndFieldErrMsg(AuthenticationTokenInstream, TypeHelper.LFSeparator(), RelyonSetup.FieldName("Autentication Token")));
//             RESTHelper.AddRequestHeader(SubscriptionIdLbl, RelyonSetup."Subscription Id");
//             RESTHelper.AddRequestHeader(GstinLbl, LocationBuff."GST Registration No.");
//             RESTHelper.AddRequestHeader(UserNameLbl, IRPSetup."User Name");
//             RESTHelper.AddRequestHeader(AuthTokenLbl, IRPSetup.authToken);
//             RESTHelper.AddRequestHeader(sekLbl, IRPSetup.sek);
//             RESTHelper.AddRequestHeader('action', 'CANEWB');
//             JsonObjectTransferShipment := TransferOrderForEinvoice.CreateCancelTransferShipmentEwayBillJson(TransferShipmentHeader);
//             JsonObjectTransferShipment.WriteTo(JText);
//             Commit();
//             Continue := ConfirmRequestInJsonView(JText);
//             if not Continue then
//                 exit;
//             RESTHelper.AddBody(JText);
//             RESTHelper.SetContentType('application/json');
//             if RESTHelper.Send() then
//                 TransferOrderForEinvoice.GetResponseCancelTransferShipmentEwayBillJson(RESTHelper.GetResponseContentAsText(), TransferShipmentHeader);

//             Message(RESTHelper.GetResponseContentAsText());

//         end;



//         OnAfterGenerateCancelTransferShipmentEwayBill(TransferShipmentHeader);
//     end;



//     [IntegrationEvent(false, false)]
//     local procedure OnBeforeGeneratePostedSalesEinvoice(var SalesInvoiceHeader: Record "Sales Invoice Header"; var IsHandled: Boolean)
//     begin
//     end;

//     [IntegrationEvent(false, false)]
//     local procedure OnAfterGeneratePostedSalesEinvoice(var SalesInvoiceHeader: Record "Sales Invoice Header")
//     begin
//     end;

//     [IntegrationEvent(false, false)]
//     local procedure OnBeforeGenerateCanceledSalesEinvoice(var SalesInvoiceHeader: Record "Sales Invoice Header"; var IsHandled: Boolean)
//     begin
//     end;

//     [IntegrationEvent(false, false)]
//     local procedure OnAfterGenerateCanceledSalesEinvoice(var SalesInvoiceHeader: Record "Sales Invoice Header")
//     begin
//     end;

//     [IntegrationEvent(false, false)]
//     local procedure OnBeforeGeneratePostedSalesCrEinvoice(var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var IsHandled: Boolean)
//     begin
//     end;

//     [IntegrationEvent(false, false)]
//     local procedure OnAfterGeneratePostedSalesCrEinvoice(var SalesCrMemoHeader: Record "Sales Cr.Memo Header")
//     begin
//     end;

//     [IntegrationEvent(false, false)]
//     local procedure OnBeforeGenerateCanceledSalesCrEinvoice(Rec: Record "Sales Cr.Memo Header"; var IsHandled: Boolean)
//     begin
//     end;

//     [IntegrationEvent(false, false)]
//     local procedure OnAfterGenerateCanceledSalesCrEinvoice(Rec: Record "Sales Cr.Memo Header")
//     begin
//     end;

//     [IntegrationEvent(false, false)]
//     local procedure OnBeforeGenerateTransferShipmentEinvoice(Rec: Record "Transfer Shipment Header"; var IsHandled: Boolean)
//     begin
//     end;

//     [IntegrationEvent(false, false)]
//     local procedure OnAfterGenerateTransferShipmentEinvoice(Rec: Record "Transfer Shipment Header")
//     begin
//     end;

//     [IntegrationEvent(false, false)]
//     local procedure OnBeforeGeneratePostedSalesinvoiceEwayBill(Rec: Record "Sales Invoice Header"; var IsHandled: Boolean)
//     begin
//     end;

//     [IntegrationEvent(false, false)]
//     local procedure OnAfterGeneratePostedSalesinvoiceEwayBill(Rec: Record "Sales Invoice Header")
//     begin
//     end;



//     [IntegrationEvent(false, false)]
//     local procedure OnBeforeGenerateCancelSalesinvoiceEwayBill(Rec: Record "Sales Invoice Header"; var IsHandled: Boolean)
//     begin
//     end;

//     [IntegrationEvent(false, false)]
//     local procedure OnAfterGenerateCancelSalesinvoiceEwayBill(Rec: Record "Sales Invoice Header")
//     begin
//     end;

//     [IntegrationEvent(false, false)]
//     local procedure OnBeforeGenerateCanceledTransferShipmentEinvoice(Rec: Record "Transfer Shipment Header"; var IsHandled: Boolean)
//     begin
//     end;

//     [IntegrationEvent(false, false)]
//     local procedure OnAfterGenerateCanceledTransferShipmentEinvoice(Rec: Record "Transfer Shipment Header")
//     begin
//     end;

//     [IntegrationEvent(false, false)]
//     local procedure OnBeforeGenerateTransferShipmentEwayBill(var TransferShipmentHeader: Record "Transfer Shipment Header"; var IsHandled: Boolean)
//     begin
//     end;

//     [IntegrationEvent(false, false)]
//     local procedure OnAfterGenerateTransferShipmentEwayBill(var TransferShipmentHeader: Record "Transfer Shipment Header")
//     begin
//     end;

//     [IntegrationEvent(false, false)]
//     local procedure OnBeforeGenerateCancelTransferShipmentEwayBill(Rec: Record "Transfer Shipment Header"; var IsHandled: Boolean)
//     begin
//     end;

//     [IntegrationEvent(false, false)]
//     local procedure OnAfterGenerateCancelTransferShipmentEwayBill(Rec: Record "Transfer Shipment Header")
//     begin
//     end;

//     /// <summary>
//     /// JSON Veiwer.
//     /// </summary>
//     /// <param name="RequestJText"></param>
//     /// <returns></returns>
//     local procedure ConfirmRequestInJsonView(var RequestJText: text): Boolean
//     var
//         TempBlob: Codeunit "Temp Blob";
//         ConfirmJsonView: page "Confirm Json View";
//         RequestInstream: InStream;
//         RequestOutStream: OutStream;
//         IAction: Action;
//     begin
//         Clear(RequestOutStream);
//         Clear(RequestInstream);
//         TempBlob.CreateOutStream(RequestOutStream, TextEncoding::Windows);
//         RequestOutStream.WriteText(RequestJText);
//         TempBlob.CreateInStream(RequestInstream, TextEncoding::Windows);
//         ConfirmJsonView.SetContent(RequestInstream);
//         IAction := ConfirmJsonView.RunModal();
//         case IAction of
//             action::OK:
//                 exit(true);
//             Action::Yes:
//                 exit(true);
//             Action::No:
//                 exit(false);
//             action::LookupOK:
//                 exit(false);
//             action::Cancel:
//                 exit(false);
//             action::LookupCancel:
//                 exit(false);

//         end;
//     end;


//     var

// }