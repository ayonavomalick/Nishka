codeunit 50004 POSEntriesValidate
{
    trigger OnRun()
    begin
        ValidatePOSEntries(NIMPOSEntry);
    end;

    local procedure ValidatePOSEntries(NIMPOSEntry: Record NIMPOSEntry)
    var
        IsHandled: Boolean;
    begin
        OnBeforeValidatePOSEntries(NIMPOSEntry, IsHandled);
        if IsHandled then
            exit;



        OnAfterValidatePOSEntries(NIMPOSEntry);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeValidatePOSEntries(NIMPOSEntry: Record NIMPOSEntry; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterValidatePOSEntries(NIMPOSEntry: Record NIMPOSEntry)
    begin
    end;


    

    var
        NIMPOSEntry: Record NIMPOSEntry;
}