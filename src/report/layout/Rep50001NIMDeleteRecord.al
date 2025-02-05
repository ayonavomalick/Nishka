report 50001 "NIM Delete Record"
{
    Caption = 'Delete Record Batch Job Report';
    ProcessingOnly = true;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;
    Permissions = TableData "G/L Entry" = rmid, tabledata "Cust. Ledger Entry" = rmid, tabledata "Vendor Ledger Entry" = rmid, tabledata "Detailed Cust. Ledg. Entry" = rmid, tabledata "Detailed Vendor Ledg. Entry" = rmid,
    tabledata "Gen. Journal Line" = rmid, tabledata "VAT Entry" = rmid, tabledata "Posted Gen. Journal Line" = rmid, tabledata NIMPOSEntry = rmid, tabledata NIMPostedPOSEntry = rmid;


    dataset
    {
        dataitem(DataItem1000000000; Integer)
        {
            DataItemTableView = SORTING(Number)
                                WHERE(Number = FILTER(1 ..));
            MaxIteration = 1;

            trigger OnAfterGetRecord()

            begin
                GLEntry.Reset();
                if not GLEntry.IsEmpty then
                    GLEntry.DeleteAll(false);
                CustomerLedgerEntry.Reset();
                if not CustomerLedgerEntry.IsEmpty then
                    CustomerLedgerEntry.DeleteAll(false);
                VendorLedgerEntry.Reset();
                if not VendorLedgerEntry.IsEmpty then
                    VendorLedgerEntry.DeleteAll(false);
                DetailedCustomerLedgerEntry.Reset();
                if not DetailedCustomerLedgerEntry.IsEmpty then
                    DetailedCustomerLedgerEntry.DeleteAll(false);
                DetailedVendorLedgerEntry.Reset();
                if not DetailedVendorLedgerEntry.IsEmpty then
                    DetailedVendorLedgerEntry.DeleteAll(false);
                GeneralJournalLine.Reset();
                if not GeneralJournalLine.IsEmpty then
                    GeneralJournalLine.DeleteAll(false);

                VatEntry.Reset();
                if not VatEntry.IsEmpty then
                    VatEntry.DeleteAll(false);
                PostedGenJournalLine.Reset();
                if not PostedGenJournalLine.IsEmpty then
                    PostedGenJournalLine.DeleteAll(false);
                POSEntry.Reset();
                if not POSEntry.IsEmpty then
                    POSEntry.DeleteAll(false);
                PostedPOSEntry.Reset();
                if not PostedPOSEntry.IsEmpty then
                    PostedPOSEntry.DeleteAll(false);
            end;

            trigger OnPostDataItem()
            begin
                MESSAGE('Deleted Successfully');
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {



            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport()
    var

    begin

    end;

    var

        GLEntry: Record "G/L Entry";
        CustomerLedgerEntry: Record "Cust. Ledger Entry";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        DetailedCustomerLedgerEntry: Record "Detailed Cust. Ledg. Entry";
        DetailedVendorLedgerEntry: Record "Detailed Vendor Ledg. Entry";
        GeneralJournalLine: Record "Gen. Journal Line";
        VatEntry: Record "VAT Entry";
        PostedGenJournalLine: Record "Posted Gen. Journal Line";
        POSEntry: Record NIMPOSEntry;
        PostedPOSEntry: Record NIMPOstedposEntry;
}

