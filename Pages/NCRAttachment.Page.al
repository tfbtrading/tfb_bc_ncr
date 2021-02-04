page 50803 "TFB NCR Attachment"
{
    PageType = List;
    UsageCategory = Lists;
    Caption = 'Attachments';
    ApplicationArea = All;
    SourceTable = "Document Attachment";
    SourceTableView = order(descending);
    RefreshOnActivate = true;
    Permissions = TableData "17" = IMD, Tabledata "36" = IMD, Tabledata "37" = IMD, Tabledata "38" = IMD, Tabledata "39" = IMD, Tabledata "81" = IMD, Tabledata "21" = IMD, Tabledata "25" = IMD, Tabledata "32" = IMD, Tabledata "110" = IMD, TableData "111" = IMD, TableData "112" = IMD, TableData "113" = IMD, TableData "114" = IMD, TableData "115" = IMD, TableData "120" = IMD, Tabledata "121" = IMD, Tabledata "122" = IMD, Tabledata "123" = IMD, Tabledata "124" = IMD, Tabledata "125" = IMD, Tabledata "169" = IMD, Tabledata "379" = IMD, Tabledata "380" = IMD, Tabledata "271" = IMD, Tabledata "5802" = IMD;
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("File Name"; Rec."File Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the file name';
                    Editable = false;
                    trigger OnDrillDown()
                    var
                        FileManagement: Codeunit "File Management";
                        TempBlob: Codeunit "Temp Blob";
                        FromRecRef: RecordRef;
                        FileName: Text;
                        FileDialogTxt: Label 'Attachments (%1)|%1', Comment='%1=FileName,%2=File Type';
                        FilterTxt: Label '*.jpg;*.jpeg;*.bmp;*.png;*.gif;*.tiff;*.tif;*.pdf;*.docx;*.doc;*.xlsx;*.xls;*.pptx;*.ppt;*.msg;*.xml;*.*';
                        ImportTxt: Label 'Attach a document.';


                    begin
                        IF Recs.Get(Rec."No.") then;
                        FromRecRef.GetTable(Recs);
                        IF Rec."Document Reference ID".HasValue() THEN
                            Export2(TRUE)
                        ELSE BEGIN
                            FileName := FileManagement.BLOBImportWithFilter(TempBlob, ImportTxt, FileName, STRSUBSTNO(FileDialogTxt, FilterTxt), FilterTxt);
                            SaveAttachment2(FromRecRef, FileName, TempBlob, Recs."No.");
                            CurrPage.UPDATE(FALSE);
                        END;

                    end;
                }
                field("File Type"; Rec."File Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the file type';
                }
                field("File Extension"; Rec."File Extension")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the file extension';
                }
                field(User; Rec.User)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the user';
                }
                field("Attached Date"; Rec."Attached Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the date attached';
                }
            }
        }

    }
    var
        Recs: Record "TFB Non-Conformance Report"; //Change the Table Name Here-


    /// <summary> 
    /// Download attachment
    /// </summary>
    /// <param name="ShowFileDialog">Parameter of type Boolean.</param>
    /// <returns>Return variable "Text".</returns>
    procedure Export2(ShowFileDialog: Boolean): Text
    var
        FileManagement: Codeunit "File Management";
        TempBlob: Codeunit "Temp Blob";
        DocumentStream: OutStream;
        FullFileName: Text;

    begin

        IF Rec.ID = 0 THEN
            EXIT;
        // Ensure document has value in DB
        IF NOT Rec."Document Reference ID".HasValue() THEN
            EXIT;

        FullFileName := Rec."File Name" + '.' + Rec."File Extension";
        TempBlob.CREATEOUTSTREAM(DocumentStream);
        Rec."Document Reference ID".EXPORTSTREAM(DocumentStream);
        EXIT(FileManagement.BLOBExport(TempBlob, FullFileName, ShowFileDialog));
    end;

    /// <summary> 
    /// Save attachment that was selected
    /// </summary>
    /// <param name="RecRef">Parameter of type RecordRef.</param>
    /// <param name="FileName">Parameter of type Text.</param>
    /// <param name="TempBlob">Parameter of type Codeunit "Temp Blob".</param>
    /// <param name="OpportunityNo">Parameter of type Code[30].</param>
    procedure SaveAttachment2(RecRef: RecordRef; FileName: Text; TempBlob: Codeunit "Temp Blob"; OpportunityNo: Code[30])
    var
        Rec_Attachment: Record "Document Attachment";
        Rec_Document: Record "Document Attachment";
        FileManagement: Codeunit "File Management";
        FieldRef: FieldRef;
        DocStream2: Instream;
        IncomingFileName2: Text;
        EmptyFileNameErr: Label 'No content';
        NoDocumentAttachedErr: Label 'No document attached';
    begin
        IF FileName = '' THEN
            ERROR(EmptyFileNameErr);
        // Validate file/media is not empty
        IF NOT TempBlob.HasValue() THEN
            ERROR(EmptyFileNameErr);
        IncomingFileName2 := FileName;
        Clear(Rec_Attachment);
        Rec_Attachment.Reset();
        Rec_Attachment.Init();
        Rec_Attachment.VALIDATE("File Extension", FileManagement.GetExtension(IncomingFileName2));
        Rec_Attachment.VALIDATE("File Name", COPYSTR(FileManagement.GetFileNameWithoutExtension(IncomingFileName2), 1, MAXSTRLEN(Rec."File Name")));
        Rec_Attachment.Validate("Document Type", Rec."Document Type"::Order);
        Rec_Attachment.VALIDATE("Table ID", RecRef.NUMBER());
        Rec_Attachment.Validate("No.", Recs."No.");
        TempBlob.CREATEINSTREAM(DocStream2);
        Rec_Attachment."Document Reference ID".IMPORTSTREAM(DocStream2, '', IncomingFileName2);
        IF NOT Rec_Attachment."Document Reference ID".HasValue() THEN
            ERROR(NoDocumentAttachedErr);
        CASE RecRef.Number() OF
            DATABASE::"TFB Non-Conformance Report":
                BEGIN
                    FieldRef := RecRef.FIELD(1);
                    Clear(Rec_Document);
                    Rec_Document.SetRange("Table ID", RecRef.Number());
                    Rec_Document.SetRange("No.", Recs."No.");
                    IF Rec_Document.FindLast() then
                        Rec_Attachment.Validate("Line No.", Rec_Document."Line No." + 1000)
                    else
                        Rec_Attachment.Validate("Line No.", 1000);
                END;
        END;
        Rec_Attachment.INSERT(TRUE);
    end;



}