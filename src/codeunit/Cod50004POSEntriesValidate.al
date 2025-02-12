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


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Check Gen. Jnl. Line. Backgr.", OnAfterCheckGenJnlLine, '', false, false)]
    local procedure MyProcedure(var GenJnlLine: Record "Gen. Journal Line"; var TempErrorMessage: Record "Error Message" temporary)
    begin
        Error('Javed');
    end;

    var
        NIMPOSEntry: Record NIMPOSEntry;
}