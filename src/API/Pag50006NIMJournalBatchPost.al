page 50006 "NIMJournalBatchPost"
{
    APIVersion = 'v2.0';
    PageType = API;
    APIPublisher = 'demo';
    APIGroup = 'Nisika';
    EntityCaption = 'JournalBatchPost';
    EntitySetCaption = 'JournalBatchPost';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    EntityName = 'JournalBatchPost';
    EntitySetName = 'JournalBatchPost';
    ODataKeyFields = "Journal Template Name", Name;

    SourceTable = "Gen. Journal Batch";
    Extensible = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Caption = 'Group';
                field(JournalTemplateName; Rec."Journal Template Name")
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field(JournalBatchId; Rec.SystemId)
                {
                    ApplicationArea = All;
                }


            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Journal Template Name" := GraphMgtJournal.GetDefaultJournalLinesTemplateName();
    end;

    trigger OnFindRecord(Which: Text): Boolean
    var
        TemplateNameFilter: Text[10];
        IdFilter: Text;
    begin
        TemplateNameFilter := CopyStr(Rec.GetFilter("Journal Template Name"), 1, 10);
        IdFilter := Rec.GetFilter(SystemId);
        if IdFilter <> '' then
            exit(Rec.GetBySystemId(IdFilter));

        if TemplateNameFilter = '' then
            TemplateNameFilter := GraphMgtJournal.GetDefaultJournalLinesTemplateName();
        Rec.SetRange("Journal Template Name", TemplateNameFilter);
        exit(Rec.FindSet());
    end;

    var
        GraphMgtJournal: Codeunit "Graph Mgt - Journal";
        ThereIsNothingToPostErr: Label 'There is nothing to post.';
        CannotFindBatchErr: Label 'The General Journal Batch with ID %1 cannot be found.', Comment = '%1 - the System ID of the general journal batch';

    [ServiceEnabled]
    [Scope('Cloud')]
    procedure post(var ActionContext: WebServiceActionContext)
    var
        GenJournalBatch: Record "Gen. Journal Batch";
    begin
        GetBatch(GenJournalBatch);
        PostBatch(GenJournalBatch);
        SetActionResponse(ActionContext, Rec.SystemId);
    end;

    local procedure PostBatch(var GenJournalBatch: Record "Gen. Journal Batch")
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        GenJournalLine.SetRange("Journal Template Name", GenJournalBatch."Journal Template Name");
        GenJournalLine.SetRange("Journal Batch Name", GenJournalBatch.Name);
        if not GenJournalLine.FindFirst() then
            Error(ThereIsNothingToPostErr);

        Codeunit.RUN(Codeunit::"Gen. Jnl.-Post", GenJournalLine);
    end;

    local procedure GetBatch(var GenJournalBatch: Record "Gen. Journal Batch")
    begin
        if not GenJournalBatch.GetBySystemId(Rec.SystemId) then
            Error(CannotFindBatchErr, Rec.SystemId);
    end;

    local procedure SetActionResponse(var ActionContext: WebServiceActionContext; GenJournalBatchId: Guid)
    begin
        ActionContext.SetObjectType(ObjectType::Page);
        ActionContext.SetObjectId(Page::"APIV2 - Journals");
        ActionContext.AddEntityKey(Rec.FieldNo(SystemId), GenJournalBatchId);
        ActionContext.SetResultCode(WebServiceActionResultCode::Deleted);
    end;
}
