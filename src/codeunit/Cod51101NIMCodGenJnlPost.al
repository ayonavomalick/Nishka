//Gen. Jnl.-Post
codeunit 51101 NIMCodGenJnlPost
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post", OnBeforeCode, '', false, false)]
    local procedure OnBeforeCode(var GenJournalLine: Record "Gen. Journal Line"; var HideDialog: Boolean)
    begin
        if GenJournalLine.API then
            HideDialog := true;
    end;

    var

}