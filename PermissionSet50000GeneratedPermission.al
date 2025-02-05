permissionset 50000 GeneratedPermission
{
    Assignable = true;
    Permissions = tabledata NIMPOSAPISetup=RIMD,
        tabledata NIMPOSEntry=RIMD,
        tabledata NIMPostedPOSEntry=RIMD,
        tabledata NIMPOSTokenSetup=RIMD,
        tabledata "NIMREST Log"=RIMD,
        table NIMPOSAPISetup=X,
        table NIMPOSEntry=X,
        table NIMPostedPOSEntry=X,
        table NIMPOSTokenSetup=X,
        table "NIMREST Log"=X,
        codeunit "FOD API Mgt"=X,
        codeunit "FOD Form Data Example"=X,
        codeunit "NIM API Management"=X,
        codeunit NIMCodGenJnlPostLine=X,
        codeunit NIMCreateGenJournalLines=X,
        codeunit NIMJSONHelper=X,
        codeunit NIMPOSAPIMgmnt=X,
        codeunit NIMPOSTokenMgmnt=X,
        codeunit "NIMREST Helper"=X,
        codeunit "NIMShowRequestMessage Method"=X,
        codeunit "NIMShowResponseMessage Method"=X,
        codeunit NIMTabGLEntry=X,
        codeunit VendorInfo=X,
        page "NIM Customer"=X,
        page "NIM Vendor API"=X,
        page "NIMGen Journal Lines"=X,
        page NIMJournalBatchPost=X,
        page NIMPOSEntries=X,
        page NIMPosEntryListAPI=X,
        page NIMPostedPOSEntries=X,
        page "NIMREST Log Card"=X,
        page "NIMREST Log List"=X,
        page NIMPOSTokenSetup=X;
}