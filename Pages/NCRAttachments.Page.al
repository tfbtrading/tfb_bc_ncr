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
                    Clear(Page_DocumentAttachment);
                    Clear(Recs);
                    Recs.Reset();
                    Recs.SetRange("No.", Rec."No.");
                    IF Recs.FindFirst() then;
                    Page_DocumentAttachment.SetRecord(Recs);
                    Page_DocumentAttachment.SetTableView(Recs);
                    Page_DocumentAttachment.RunModal();
                    Clear(Rec_DocumentAttachment);
                    Clear(_Attachments);
                    Rec_DocumentAttachment.Reset();
                    Rec_DocumentAttachment.SetRange("No.", Rec."No.");
                    IF Rec_DocumentAttachment.FindSet() then
                        _Attachments := Rec_DocumentAttachment.Count();
                end;
            }

        }
    }


    var
        Rec_DocumentAttachment: Record "Document Attachment";
        Page_DocumentAttachment: Page "TFB NCR Attachment";//Change the Page Name Here----OLISTER
        _Attachments: Integer;


    trigger OnAfterGetRecord()
    begin
        Clear(_Attachments);
        Clear(Rec_DocumentAttachment);
        Rec_DocumentAttachment.Reset();
        Rec_DocumentAttachment.SetRange("No.", Rec."No.");
        IF Rec_DocumentAttachment.FindSet() then
            _Attachments := Rec_DocumentAttachment.Count();
    end;
}