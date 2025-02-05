codeunit 51000 NIMTabGLEntry
{
    [EventSubscriber(ObjectType::Table, Database::"G/L Entry", OnAfterCopyGLEntryFromGenJnlLine, '', false, false)]
    local procedure OnAfterCopyGLEntryFromGenJnlLine(var GLEntry: Record "G/L Entry"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        if GenJournalLine.NIMPosEntry then begin
            GLEntry.NIMPosEntry := GenJournalLine.NIMPosEntry;
            GLEntry."Reference Document No." := GenJournalLine."Reference Document No.";
            GLEntry."Reference Line No." := GenJournalLine."Reference Line No.";
        end;
    end;

    var

}