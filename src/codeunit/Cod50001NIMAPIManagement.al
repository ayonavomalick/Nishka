codeunit 50001 "NIM API Management"
{
   

    procedure GetSalesDocumentNo()
    var
        SalesAndRecievableSetup: Record "Sales & Receivables Setup";
    begin
        SalesAndRecievableSetup.Get();
    end;

    procedure GetPurchaseDocumentNo()
    var
        PurchaseAndPayableSetup: Record "Purchases & Payables Setup";
    begin
        PurchaseAndPayableSetup.Get();
    end;

    var
        myInt: Integer;
}