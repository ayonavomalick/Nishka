codeunit 50003 "NIMCodNavigate"
{
    [EventSubscriber(ObjectType::Page, Page::Navigate, 'OnAfterNavigateFindRecords', '', FALSE, false)]
    local procedure ShowCustomTableEntriesInOnAfterNavigateFindRecords(var DocumentEntry: Record "Document Entry"; DocNoFilter: Text; PostingDateFilter: Text)
    begin
        FindPostedPOSEntries(DocumentEntry, DocNoFilter, PostingDateFilter);
    end;
    local procedure FindPostedPOSEntries(var DocumentEntry: Record "Document Entry" temporary; DocNoFilter: Text; PostingDateFilter: Text)
    var
        PostedPOSEntry: Record NIMPostedPOSEntry;
        Navigate: Page Navigate;
    begin
        if PostedPOSEntry.ReadPermission() then begin
            PostedPOSEntry.Reset();
            PostedPOSEntry.SetCurrentKey("Document No.");
            PostedPOSEntry.SetFilter("Document No.", DocNoFilter);
            PostedPOSEntry.SetFilter("Posting Date", PostingDateFilter);
            Navigate.InsertIntoDocEntry(DocumentEntry, DATABASE::NIMPostedPOSEntry, PostedPOSEntry.TableCaption, PostedPOSEntry.Count);
        end;
    end;
    [EventSubscriber(ObjectType::Page, Page::Navigate, 'OnAfterNavigateShowRecords', '', FALSE, FALSE)]
    local procedure ShowDetailedItemLedgerEntriesRecordsOnAfterNavigateShowRecords(TableID: Integer; DocNoFilter: Text; PostingDateFilter: Text; var TempDocumentEntry: Record "Document Entry")
    var
        NIMPostedPOSEntry: Record NIMPostedPOSEntry;
    begin
        case TempDocumentEntry."Table ID" of
            DATABASE::NIMPostedPOSEntry:
                begin
                    NIMPostedPOSEntry.Reset();
                    NIMPostedPOSEntry.SetCurrentKey("Document No.");
                    NIMPostedPOSEntry.SetFilter("Document No.", DocNoFilter);
                    NIMPostedPOSEntry.SetFilter("Posting Date", PostingDateFilter);
                    PAGE.Run(50001, NIMPostedPOSEntry)
                end;
        end;
    end;
}