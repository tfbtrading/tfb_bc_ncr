page 50802 "TFB NCR Attachments"
{
    PageType = CardPart;
    SourceTable = "TFB Non-Conformance Report";//Change the Table Name Here----OLISTER
    Caption = 'Attachments';

    layout
    {
        area(Content)
        {

            field(Attachments; _Attachments)
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                ToolTip = 'Specifies attachments';
                Editable = false;
                trigger OnDrillDown()
                var
                    Recs: Record "Document Attachment";
                begin
                    Clear(TFBNCRAttachment);
                    Clear(Recs);
                    Recs.Reset();
                    Recs.SetRange("No.", Rec."No.");
                    IF Recs.FindFirst() then;
                    TFBNCRAttachment.SetRecord(Recs);
                    TFBNCRAttachment.SetTableView(Recs);
                    TFBNCRAttachment.RunModal();
                    Clear(DocumentAttachment);
                    Clear(_Attachments);
                    DocumentAttachment.Reset();
                    DocumentAttachment.SetRange("No.", Rec."No.");
                    IF DocumentAttachment.FindSet() then
                        _Attachments := DocumentAttachment.Count();
                end;
            }

        }
    }


    var
        DocumentAttachment: Record "Document Attachment";
        TFBNCRAttachment: Page "TFB NCR Attachment";//Change the Page Name Here----OLISTER
        _Attachments: Integer;


    trigger OnAfterGetRecord()
    begin
        Clear(_Attachments);
        Clear(DocumentAttachment);
        DocumentAttachment.Reset();
        DocumentAttachment.SetRange("No.", Rec."No.");
        _Attachments := DocumentAttachment.Count();
    end;
}