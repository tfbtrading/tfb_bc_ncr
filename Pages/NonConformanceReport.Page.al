page 50800 "TFB Non Conformance Report"
{
    PageType = Document;
    Caption = 'Non Conformance Report';
    SourceTable = "TFB Non-Conformance Report";
    DataCaptionFields = "Customer Name", "No.", Description;
    DataCaptionExpression = Rec."Customer Name" + ' ' + Rec."No.";
    LinksAllowed = true;

    layout
    {
        area(Content)
        {
            group(Reporting)
            {

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    Editable = false;
                    ToolTip = 'Specify number sequence';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    Editable = Rec."Item Ledger Entry No." = 0;
                    ToolTip = 'Specify customer number';

                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    Editable = Rec."Item Ledger Entry No." = 0;
                    ToolTip = 'Specify customer name';
                    TableRelation = Customer."No." where("No." = field("Customer No."));
                }

                field("Date Raised"; Rec."Date Raised")
                {
                    ApplicationArea = All;
                    Importance = Standard;
                    ToolTip = 'Specify date report was raised by customer';
                    Editable = not Rec.Closed;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specify current status of the report';
                    Style = Attention;
                    StyleExpr = Rec.Status <> Rec.Status::Complete;

                    trigger OnValidate()

                    begin
                        If Rec.Status.AsInteger() > Rec.Status::Reported.AsInteger() then begin
                            if Rec."Date Raised" = 0D then
                                Rec.FieldError("Date Raised", 'Must enter a date raised');

                            If Rec."Customer No." = '' then
                                Rec.FieldError("Customer No.", 'Must enter a customer no');

                            if Rec.Status = Rec.Status::Complete then
                                If Rec."Corrective Action" = '' then
                                    Rec.FieldError("Corrective Action", 'Must enter a corrective action');


                        end;

                    end;
                }
                field("Contact No."; Rec."Contact No.")
                {
                    ApplicationArea = All;
                    Importance = Standard;
                    ToolTip = 'Specify the contact who reported the issue';
                    Editable = not Rec.Closed;
                }
                field("Issued By"; Rec."Issued By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specify the name of the contact who reported the issue';
                    Editable = not Rec.Closed;
                }
                field("E-mail"; Rec."E-mail")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specify the customer email address for correspondence';
                }

                field("External Reference No."; Rec."External Reference No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specify the external reference number if provided by customer';
                    Editable = not Rec.closed;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specify the item for which an issue was reported';
                    Editable = (Rec."Item Ledger Entry No." = 0) and (not Rec.closed);

                }
                field(Variant; Rec.Variant)
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    ToolTip = 'Specify the variant if any for which the issue was reported';
                    Editable = (Rec."Item Ledger Entry No." = 0) and (not Rec.closed);
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Importance = Standard;
                    ToolTip = 'Specify the description of the item for which the issue was reported';
                    Editable = (Rec."Item Ledger Entry No." = 0) and (not Rec.Closed);
                }
                field("Order Type"; Rec."Order Type")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specify the type of order';
                    Editable = not Rec.Closed;
                }
                field("Item Ledger Entry No."; Rec."Item Ledger Entry No.")
                {
                    ApplicationArea = All;
                    Editable = (Rec."Customer No." <> '') and (Rec."Item No." <> '') and (Rec."Order Type" = Rec."Order Type"::Standard) and (not Rec.Closed);
                    ToolTip = 'Specify the ledger entry related to the issue. A ledger entry represents the specific transactions';

                    trigger OnValidate()

                    var
                        Entry: Record "Item Ledger Entry";

                    begin
                        If Entry.Get(Rec."Item Ledger Entry No.") then begin
                            Rec."Lot No." := Entry."Lot No.";
                            Rec."Drop Shipment" := Entry."Drop Shipment";
                        end
                        else
                            Rec."Lot No." := '';
                    end;
                }

                group(LedgerDetails)
                {
                    Caption = 'Ledger Details';
                    Visible = Rec."Item Ledger Entry No." > 0;
                    field("Ledger Order No."; Rec."Ledger Order No.")
                    {
                        ApplicationArea = All;
                        Caption = 'Ledger Doc No.';
                        Importance = Additional;
                        ToolTip = 'Specify the document number related to the ledger entry';
                    }
                    field("Ledger External Reference No."; Rec."Ledger External Reference No.")
                    {
                        ApplicationArea = All;
                        Importance = Additional;
                        ToolTip = 'Specify the customers PO ref for their related order';
                    }
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specify the lot number related to to the ledger entry';

                    DrillDown = true;

                    trigger OnDrillDown()

                    var
                        LotInfo: Record "Lot No. Information";

                    begin

                        LotInfo.SetRange("Item No.", Rec."Item No.");
                        LotInfo.SetRange("Lot No.", Rec."Lot No.");
                        LotInfo.SetRange("Variant Code", Rec.Variant);

                        If LotInfo.FindFirst() then
                            Page.Run(Page::"Lot No. Information Card", LotInfo);


                    end;
                }
                field("Drop Shipment"; Rec."Drop Shipment")
                {
                    ApplicationArea = All;
                    ToolTip = 'Indicates if non-conformance was related to drop shipment';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of report raised';
                    Editable = not Rec.Closed;
                }

                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    ToolTip = 'Specifies the vendor that might need to be involved. Could be original product manager or transport company';
                    Editable = not Rec.closed;
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ToolTip = 'Specifies the vendor that might need to be involved. Could be original product manager or transport company';
                    Editable = not Rec.closed;
                }

                field("Corrective Action Due"; Rec."Corrective Action Due")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a date agreed by which corrective action is due';
                }
                field("Date Closed"; Rec."Date Closed")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date on which the rpeort was closed';
                }

                field("No. of Sales Cr"; Rec."No. of Sales Cr")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the related sales credit';
                }

            }
            group(Information)
            {
                Caption = 'Detailed Information';
                grid(DescriptionsGrid)
                {
                    GridLayout = Rows;

                    group(row1)
                    {
                        ShowCaption = false;


                        field("Non-Conformity Details"; Rec."Non-Conformity Details")
                        {
                            ApplicationArea = All;
                            MultiLine = true;
                            ToolTip = 'Specifies details on the non-conformance';
                            Editable = Rec.Status = Rec.Status::Reported;
                        }
                        field(Questions; Rec.Questions)
                        {
                            ApplicationArea = All;
                            MultiLine = true;
                            ToolTip = 'Specifies what questions should be asked of customer/supplier';
                            Editable = (Rec.Status = Rec.Status::Reported) or (Rec.Status = Rec.Status::Assessed);
                        }

                        field("Invest. and Root Cause"; Rec."Invest. and Root Cause")
                        {
                            Caption = 'Investigation and Root Cause';
                            ApplicationArea = All;
                            MultiLine = true;
                            ToolTip = 'Specifies the detail, if any on investigation and root cause analysis';
                            Editable = (Rec.Status = Rec.Status::Assessed) or (Rec.Status = Rec.Status::InProgress);

                        }
                        field("Corrective Action"; Rec."Corrective Action")
                        {
                            ApplicationArea = All;
                            MultiLine = true;
                            ToolTip = 'Specifies the corrective action that has been taken';
                            Editable = (Rec.Status = Rec.Status::Assessed) or (Rec.Status = Rec.Status::InProgress);
                        }

                    }
                }

            }

        }
        area(FactBoxes)
        {
            part("Attachments"; "TFB NCR Attachments")
            {
                ApplicationArea = All;
                SubPageLink = "No." = field("No.");
            }
            systempart(notes; Notes)
            {
                ApplicationArea = All;
            }
            part(SaleDetails; "TFB NCR Item FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "Entry No." = field("Item Ledger Entry No.");
                Caption = 'Sales Details';
            }

        }


    }


    actions
    {
        area(Processing)
        {
            action("TFBSendEmail")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                Image = SendConfirmation;
                Caption = 'Send to confirmation to customer';
                ToolTip = 'Sends confirmation for non-conformance';

                trigger OnAction()

                begin
                    SendCustomerEmail();
                end;
            }

            action("TFBSendVendorEmail")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                Image = SendConfirmation;
                Caption = 'Send to notification to vendor';
                ToolTip = 'Sends notification for non-conformance';

                trigger OnAction()

                begin
                    SendVendorEmail();
                end;
            }

        }
        area(Navigation)
        {
            action("Sent Emails")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Sent Emails';
                Image = ShowList;
                ToolTip = 'View a list of emails that you have sent to this customer.';
                Visible = true;

                trigger OnAction()
                var
                    Email: Codeunit Email;
                begin
                    Email.OpenSentEmails(Rec);
                end;
            }
        }
    }

    local procedure SendCustomerEmail()

    var
        Contact: record Contact;
        Customer: record Customer;
        TitleTxt: Label 'Non Conformance Report';
        SubTitleTxt: Label 'Confirmation';
        Recipients: List of [Text];
        SubjectNameBuilder: TextBuilder;

    begin

        If Not Customer.Get(Rec."Customer No.") then
            Error('No Customer Record Found');

        If contact.get(Rec."Contact No.") and (contact."E-Mail" <> '') then
            Recipients.Add(contact."E-Mail")
        else
            if Customer."E-Mail" = '' then
                Error('No Customer Email Found')
            else
                Recipients.Add(Customer."E-Mail");


        SubjectNameBuilder.Append(StrSubstNo('Non-Conformance Report %1 from TFB Trading', Rec."No."));
        SendEmail(Recipients, SubjectNameBuilder, TitleTxt, SubTitleTxt, Customer.SystemId, Database::Customer);

    end;

    local procedure SendVendorEmail()

    var
        Contact: record Contact;
        Vendor: record Vendor;
        TitleTxt: Label 'Non Conformance Report';
        SubTitleTxt: Label 'Notification';
        Recipients: List of [Text];
        SubjectNameBuilder: TextBuilder;

    begin

        If Not Vendor.Get(Rec."Vendor No.") then
            Error('No Vendor Record Found');


        If contact.get(Vendor."Primary Contact No.") and (contact."E-Mail" <> '') then
            Recipients.Add(contact."E-Mail")
        else
            if Vendor."E-Mail" = '' then
                Error('No Vendor Email Found')
            else
                Recipients.Add(Vendor."E-Mail");


        SubjectNameBuilder.Append(StrSubstNo('Non-Conformance Report %1 from TFB Trading', Rec."No."));

        SendEmail(Recipients, SubjectNameBuilder, TitleTxt, SubTitleTxt, Vendor.SystemId, Database::Vendor);

    end;

    local procedure SendEmail(Recipients: List of [Text]; SubjectNameBuilder: TextBuilder; TitleTxt: Text; SubTitleTxt: Text; EmailRelationID: Guid; EmailRelationTable: Integer)

    var
        ReportSelections: Record "Report Selections";
        CompanyInformation: Record "Company Information";
        DocumentAttachment: record "Document Attachment";

        Email: CodeUnit Email;
        EmailMessage: CodeUnit "Email Message";

        TempBlob: CodeUnit "Temp Blob";

        TFBCommonLibrary: CodeUnit "TFB Common Library";
        RecordRef: RecordRef;
        OutStream: OutStream;
        InStream: InStream;

        Dialog: Dialog;
        Text001Msg: Label 'Sending Non Conformance Confirmation:\#1############################', Comment = '%1=Brokerage Shipment Number';

        FileNameTxt: Label 'Non-Conformance Report %1.pdf', comment = '%1=Unique report no.';
        ImageFileNameTxt: Label '%1 Image %2.%3', comment = '%1=Record No. %2=Attachment Line %3=file extension';


        HTMLBuilder: TextBuilder;

        EmailScenEnum: Enum "Email Scenario";
        Base64Convert: CodeUnit "Base64 Convert";


    begin



        CompanyInformation.Get();


        Rec.SetRecFilter();
        RecordRef.GetTable(Rec);
        TempBlob.CreateOutStream(OutStream);

        ReportSelections.SetRange(Usage, ReportSelections.Usage::"S.Non.Conformance.Report");
        ReportSelections.SetRange("Use for Email Attachment", true);
        Dialog.Open(Text001Msg);
        Dialog.Update(1, STRSUBSTNO(Text001Msg, Rec."No."));
        HTMLBuilder.Append(TFBCommonLibrary.GetHTMLTemplateActive(TitleTxt, SubTitleTxt));
        If ReportSelections.FindFirst() then
            If REPORT.SaveAs(ReportSelections."Report ID", '', ReportFormat::Pdf, OutStream, RecordRef) and GenerateBrokerageContent(HTMLBuilder) then begin


                EmailMessage.Create(Recipients, SubjectNameBuilder.ToText(), HTMLBuilder.ToText(), true);

                TempBlob.CreateInStream(InStream);

                EmailMessage.AddAttachment(StrSubstNo(FileNameTxt, Rec."No."), 'application/pdf', Base64Convert.ToBase64(InStream));

                DocumentAttachment.SetRange("Table ID", Database::"TFB Non-Conformance Report");
                DocumentAttachment.SetRange("No.", Rec."No.");
                DocumentAttachment.SetRange("File Type", DocumentAttachment."File Type"::Image);

                If DocumentAttachment.FindSet(false, false) then
                    repeat
                        IF DocumentAttachment."Document Reference ID".HasValue() then begin
                            clear(TempBlob);
                            TempBlob.CREATEOUTSTREAM(OutStream);
                            DocumentAttachment."Document Reference ID".EXPORTSTREAM(OutStream);
                            If TempBlob.Length() <= (2500 * 1024) then begin
                                TempBlob.CreateInStream(InStream);

                                EmailMessage.AddAttachment(StrSubstNo(ImageFileNameTxt, Rec."No.", DocumentAttachment."Line No.", DocumentAttachment."File Extension"), '', Base64Convert.ToBase64(InStream));

                            end
                        end;
                    until DocumentAttachment.Next() = 0;

                Email.AddRelation(EmailMessage, EmailRelationTable, EmailRelationID, Enum::"Email Relation Type"::"Related Entity", Enum::"Email Relation Origin"::"Compose Context");
                Email.AddRelation(EmailMessage, Database::"TFB Non-Conformance Report", Rec.SystemId, Enum::"Email Relation Type"::"Primary Source", Enum::"Email Relation Origin"::"Compose Context");
                Email.OpenInEditorModally(EmailMessage, EmailScenEnum::Quality)


            end;

    end;

    local procedure GenerateBrokerageContent(var HTMLBuilder: TextBuilder): Boolean

    var

        BodyBuilder: TextBuilder;
        ReferenceBuilder: TextBuilder;

    begin
        HTMLBuilder.Replace('%{ExplanationCaption}', 'Notification type');
        HTMLBuilder.Replace('%{ExplanationValue}', 'Confirmation');
        HTMLBuilder.Replace('%{DateCaption}', 'Reported On');
        HTMLBuilder.Replace('%{DateValue}', Format(Rec."Date Raised", 0, 4));
        HTMLBuilder.Replace('%{ReferenceCaption}', 'References');
        ReferenceBuilder.Append(StrSubstNo('Our reference %1', Rec."No."));
        If Rec."External Reference No." <> '' then
            ReferenceBuilder.Append(StrSubstNo(' and your ref no. is %1', Rec."External Reference No."));
        HTMLBuilder.Replace('%{ReferenceValue}', ReferenceBuilder.ToText());
        HTMLBuilder.Replace('%{AlertText}', '');
        HTMLBuilder.Replace('%{EmailContent}', BodyBuilder.ToText());
        Exit(true);
    end;

}