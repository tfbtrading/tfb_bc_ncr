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
                        IF TFBNonConformanceReport.Get(Rec."No.") then;
                        FromRecRef.GetTable(TFBNonConformanceReport);
                        IF Rec."Document Reference ID".HasValue() THEN
                            Export2(TRUE)
                        ELSE BEGIN
                            FileName := FileManagement.BLOBImportWithFilter(TempBlob, ImportTxt, FileName, STRSUBSTNO(FileDialogTxt, FilterTxt), FilterTxt);
                            SaveAttachment2(FromRecRef, FileName, TempBlob, TFBNonConformanceReport."No.");
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
        TFBNonConformanceReport: Record "TFB Non-Conformance Report"; //Change the Table Name Here-


    /// <summary> 
    /// Download attachment
    /// </summary>
    /// <param name="ShowFileDialog">Parameter of type Boolean.</param>
    /// <returns>Return variable "Text".</returns>
    procedure Export2(ShowFileDialog: Boolean): Text
    var
        FileManagement: Codeunit "File Management";
        TempBlob: Codeunit "Temp Blob";
        OutStream: OutStream;
        FullFileName: Text;

    begin

        IF Rec.ID = 0 THEN
            EXIT;
        // Ensure document has value in DB
        IF NOT Rec."Document Reference ID".HasValue() THEN
            EXIT;

        FullFileName := Rec."File Name" + '.' + Rec."File Extension";
        TempBlob.CREATEOUTSTREAM(OutStream);
        Rec."Document Reference ID".EXPORTSTREAM(OutStream);
        EXIT(FileManagement.BLOBExport(TempBlob, FullFileName, ShowFileDialog));
    end;

    /// <summary> 
    /// Save attachment that was selected
    /// </summary>
    /// <param name="RecordRef">Parameter of type RecordRef.</param>
    /// <param name="FileName">Parameter of type Text.</param>
    /// <param name="TempBlob">Parameter of type Codeunit "Temp Blob".</param>
    /// <param name="OpportunityNo">Parameter of type Code[30].</param>
    procedure SaveAttachment2(RecordRef: RecordRef; FileName: Text; TempBlob: Codeunit "Temp Blob"; OpportunityNo: Code[30])
    var
        DocumentAttachment: Record "Document Attachment";
        RecDocumentAttachment: Record "Document Attachment";
        FileManagement: Codeunit "File Management";
        FieldRef: FieldRef;
        InStream: Instream;
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
        Clear(DocumentAttachment);
        DocumentAttachment.Reset();
        DocumentAttachment.Init();
        DocumentAttachment.VALIDATE("File Extension", FileManagement.GetExtension(IncomingFileName2));
        DocumentAttachment.VALIDATE("File Name", COPYSTR(FileManagement.GetFileNameWithoutExtension(IncomingFileName2), 1, MAXSTRLEN(Rec."File Name")));
        DocumentAttachment.Validate("Document Type", Rec."Document Type"::Order);
        DocumentAttachment.VALIDATE("Table ID", RecordRef.NUMBER());
        DocumentAttachment.Validate("No.", TFBNonConformanceReport."No.");
        TempBlob.CREATEINSTREAM(InStream);
        DocumentAttachment."Document Reference ID".IMPORTSTREAM(InStream, '', IncomingFileName2);
        IF NOT DocumentAttachment."Document Reference ID".HasValue() THEN
            ERROR(NoDocumentAttachedErr);
        CASE RecordRef.Number() OF
            DATABASE::"TFB Non-Conformance Report":
                BEGIN
                    FieldRef := RecordRef.FIELD(1);
                    Clear(RecDocumentAttachment);
                    RecDocumentAttachment.SetRange("Table ID", RecordRef.Number());
                    RecDocumentAttachment.SetRange("No.", TFBNonConformanceReport."No.");
                    IF RecDocumentAttachment.FindLast() then
                        DocumentAttachment.Validate("Line No.", RecDocumentAttachment."Line No." + 1000)
                    else
                        DocumentAttachment.Validate("Line No.", 1000);
                END;
        END;
        DocumentAttachment.INSERT(TRUE);
    end;



}