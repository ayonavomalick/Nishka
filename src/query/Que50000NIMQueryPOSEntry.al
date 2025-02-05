query 50000 "NIMQueryPOSEntry"
{
    elements
    {
        dataitem(NIMPOSEntry; NIMPOSEntry)
        {

            column(Entry_Type; "Entry Type")
            {
            }
            column(Document_Type; "Document Type")
            {
            }
            column(Document_No_; "Document No.")
            {
            }

            column(CountItem)
            {
                Method = Count;
            }

        }


    }

    var


    trigger OnBeforeOpen()
    begin

    end;
}