page 50800 "TFB Non Conformance Report"
{
    PageType = Document;
    Caption = 'Non Conformance Report';
    SourceTable = "TFB Non-Conformance Report";
    DataCaptionFields = "No.", Description;
    DataCaptionExpression = Rec."No." + ' ' + Rec.Description;
    LinksAllowed = true;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {

                field("No."; Rec."No.")
                {

                    Importance = Promoted;
                    Editable = false;
                    ToolTip = 'Specify number sequence';
                }
                field(Source; Rec.Source)
                {

                    Caption = 'Source of NCR';
                    ToolTip = 'Specifies where the NCR originates from';
                    Enabled = Rec.Status = Rec.Status::Reported;
                }
                group(CustomerGroup)
                {
                    Visible = Rec.Source = Rec.Source::Customer;
                    Caption = 'Customer Details';

                    field("Customer No."; Rec."Customer No.")
                    {

                        Importance = Additional;
                        Editable = Rec."Item Ledger Entry No." = 0;
                        ToolTip = 'Specify customer number';


                    }
                    field("Customer Name"; Rec."Customer Name")
                    {

                        Importance = Promoted;
                        Editable = Rec."Item Ledger Entry No." = 0;
                        ToolTip = 'Specify customer name';
                        TableRelation = Customer."No." where("No." = field("Customer No."));
                    }

                    field("Contact No."; Rec."Contact No.")
                    {

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

                        ToolTip = 'Specify the customer email address for correspondence';
                        Enabled = not (Rec.Status = Rec.Status::Complete);
                    }
                    field("External Reference No."; Rec."External Reference No.")
                    {

                        ToolTip = 'Specify the external reference number if provided by customer';
                        Editable = not Rec.closed;
                    }

                }
                group(StatusGroup)
                {
                    Caption = 'Status Details';
                    ShowCaption = true;
                    field(Status; Rec.Status)
                    {

                        ToolTip = 'Specify current status of the report';
                        Style = Attention;
                        StyleExpr = Rec.Status <> Rec.Status::Complete;

                        trigger OnValidate()

                        begin
                            If Rec.Status.AsInteger() > Rec.Status::Reported.AsInteger() then begin
                                if Rec."Date Raised" = 0D then
                                    Rec.FieldError("Date Raised", 'Must enter a date raised');

                                If (Rec."Customer No." = '') and (Rec.Source = Rec.Source::Customer) then
                                    Rec.FieldError("Customer No.", 'Must enter a customer no');

                                If (Rec."Vendor No." = '') and (Rec.Source = Rec.Source::Warehouse) then
                                    Rec.FieldError("Vendor No.", 'Must enter a vendor no');

                                if Rec.Status = Rec.Status::Complete then
                                    If Rec."Corrective Action" = '' then
                                        Rec.FieldError("Corrective Action", 'Must enter a corrective action');


                            end;

                        end;
                    }

                    field("Date Raised"; Rec."Date Raised")
                    {

                        Importance = Standard;
                        ToolTip = 'Specify date report was raised by customer';
                        Editable = not Rec.Closed;
                    }

                    field("Corrective Action Due"; Rec."Corrective Action Due")
                    {

                        ToolTip = 'Specifies a date agreed by which corrective action is due';
                    }
                    field(Type; Rec.Type)
                    {

                        ToolTip = 'Specifies the type of report raised';
                        Editable = not Rec.Closed;
                    }

                    field("Vendor No."; Rec."Vendor No.")
                    {

                        Importance = Additional;
                        ToolTip = 'Specifies the vendor that might need to be involved. Could be original product manager or transport company';
                        Editable = not Rec.closed;
                    }
                    field("Vendor Name"; Rec."Vendor Name")
                    {

                        Importance = Promoted;
                        ToolTip = 'Specifies the vendor that might need to be involved. Could be original product manager or transport company';
                        Editable = not Rec.closed;
                    }
                    field("Parent NCR No."; Rec."Parent NCR No.")
                    {
                        DrillDown = true;
                        Caption = 'Parent NCR No.';
                        DrillDownPageId = "TFB Non Conformance Report";
                        ToolTip = 'Indicates that this NCR is a repeat or related to another NCR';
                        Enabled = not (Rec.Status = Rec.Status::Complete);
                    }

                }





                group(TransactionDetails)
                {
                    Caption = 'Transaction Details';

                    field("Item No."; Rec."Item No.")
                    {
                        ToolTip = 'Specify the item for which an issue was reported';
                        Editable = (Rec."Item Ledger Entry No." = 0) and (not Rec.closed);

                    }
                    field(Variant; Rec.Variant)
                    {
                        Importance = Additional;
                        ToolTip = 'Specify the variant if any for which the issue was reported';
                        Editable = (Rec."Item Ledger Entry No." = 0) and (not Rec.closed);
                    }
                    field(Description; Rec.Description)
                    {

                        Importance = Standard;
                        ToolTip = 'Specify the description of the item for which the issue was reported';
                        Editable = (Rec."Item Ledger Entry No." = 0) and (not Rec.Closed);
                    }
                    field("Order Type"; Rec."Order Type")
                    {

                        Importance = Promoted;
                        ToolTip = 'Specify the type of order';
                        Editable = not Rec.Closed;
                    }
                    field("Item Ledger Entry No."; Rec."Item Ledger Entry No.")
                    {

                        Editable = (((Rec."Customer No." <> '') and (Rec."Item No." <> '') and (Rec.Source = Rec.Source::Customer)) or ((Rec."Vendor No." <> '') and (Rec."Item No." <> '') and (Rec.Source = Rec.Source::Warehouse))) and (Rec."Order Type" = Rec."Order Type"::Standard) and (not Rec.Closed);
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
                        ShowCaption = true;
                        Visible = Rec."Item Ledger Entry No." > 0;
                        field("Ledger Order No."; Rec."Ledger Order No.")
                        {

                            Caption = 'Ledger Doc No.';
                            Importance = Additional;
                            ToolTip = 'Specify the document number related to the ledger entry';
                        }
                        field("Ledger External Reference No."; Rec."Ledger External Reference No.")
                        {

                            Importance = Additional;
                            ToolTip = 'Specify the customers PO ref for their related order';
                        }
                    }
                    field("Lot No."; Rec."Lot No.")
                    {

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

                        ToolTip = 'Indicates if non-conformance was related to drop shipment';
                    }
                }



            }
            group(Information)
            {
                Caption = 'Detailed Information';
                grid(Test)
                {
                    GridLayout = Columns;

                    group(OrigDetails)
                    {
                        Caption = 'Details';
                        field("Non-Conformity Details"; Rec."Non-Conformity Details")
                        {

                            MultiLine = true;
                            Width = 300;
                            ToolTip = 'Specifies details on the non-conformance';
                            Editable = Rec.Status = Rec.Status::Reported;
                        }
                        field(Questions; Rec.Questions)
                        {

                            MultiLine = true;
                            Width = 300;
                            ToolTip = 'Specifies what questions should be asked of customer/supplier';
                            Editable = (Rec.Status = Rec.Status::Reported) or (Rec.Status = Rec.Status::Assessed);
                        }
                    }
                    group(ProcessDetails)
                    {
                        Caption = 'Answers';
                        field("Invest. and Root Cause"; Rec."Invest. and Root Cause")
                        {
                            Caption = 'Investigation and Root Cause';

                            MultiLine = true;
                            Width = 300;
                            ToolTip = 'Specifies the detail, if any on investigation and root cause analysis';
                            Editable = (Rec.Status = Rec.Status::Assessed) or (Rec.Status = Rec.Status::InProgress);

                        }
                        field("Corrective Action"; Rec."Corrective Action")
                        {

                            MultiLine = true;
                            Width = 300;
                            ToolTip = 'Specifies the corrective action that has been taken';
                            Editable = (Rec.Status = Rec.Status::Assessed) or (Rec.Status = Rec.Status::InProgress);
                        }
                    }

                }

            }
            group(Result)
            {
                field("Date Closed"; Rec."Date Closed")
                {

                    ToolTip = 'Specifies the date on which the rpeort was closed';
                }

                field("No. of Sales Cr"; Rec."No. of Sales Cr")
                {

                    ToolTip = 'Specifies the related sales credit';
                }
                field("No. of Purch Cr"; Rec."No. of Purchase Cr")
                {

                    ToolTip = 'Specifies the related sales credit';
                }

                group(Metrics)
                {
                    Visible = Rec.status = Rec.status::Complete;
                    ShowCaption = false;
                    InstructionalText = 'Details for internal use to help in continuous improvement';
                    field("Time Spent"; Rec."Time Spent")
                    {
                        ToolTip = 'Indicate in minutes approximately how much time was spent on this NCR';
                        BlankZero = true;
                    }
                    field("Lesssons Learnt"; Rec."Lesssons Learnt")
                    {
                        ToolTip = 'Indicate any internal lessons learnt about this NCR as part of knowledge capture';
                        MultiLine = true;
                    }
                }
            }

        }
        area(FactBoxes)
        {
            part("Attached Documents"; "TFB NCR Attachments")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
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
            part(CustomerDetails; "Sales Hist. Sell-to FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "No." = field("Customer No.");
                Caption = 'Customer History';
                Visible = Rec."Customer No." <> '';
            }

        }


    }


    actions
    {
        area(Processing)
        {
            action(EmailCustomer)
            {
                ApplicationArea = All;

                Image = SendConfirmation;
                Caption = 'Email Customer';
                ToolTip = 'Sends confirmation for non-conformance';

                trigger OnAction()

                begin
                    SendCustomerEmail();
                end;
            }


            action(EmailVendor)
            {
                ApplicationArea = All;

                Image = SendConfirmation;
                Caption = 'Email Vendor';
                ToolTip = 'Sends notification for non-conformance';

                trigger OnAction()

                begin
                    SendVendorEmail();
                end;
            }



        }
        area(Navigation)
        {
            action(SentEmails)
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

        area(Promoted)
        {
            actionref(EmailCustomer_Promoted; EmailCustomer)
            {

            }
            actionref(EmailVendor_Promoted; EmailVendor)
            {

            }
            actionref(SentEmails_Promoted; SentEmails)
            {

            }
        }
    }

    local procedure SendCustomerEmail()

    var
        Contact: record Contact;
        Customer: record Customer;
        Recipients: List of [Text];
        SubTitleTxt: Label 'Confirmation';
        TitleTxt: Label 'Non Conformance Report';
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
        Recipients: List of [Text];
        SubTitleTxt: Label 'Notification';
        TitleTxt: Label 'Non Conformance Report';
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
        CompanyInformation: Record "Company Information";
        DocumentAttachment: record "Document Attachment";
        ReportSelections: Record "Report Selections";
        Base64Convert: CodeUnit "Base64 Convert";
        Email: CodeUnit Email;
        EmailMessage: CodeUnit "Email Message";
        TempBlob: CodeUnit "Temp Blob";
        TFBCommonLibrary: CodeUnit "TFB Common Library";
        RecordRef: RecordRef;
        Dialog: Dialog;
        InStream: InStream;
        OutStream: OutStream;
        EmailScenEnum: Enum "Email Scenario";
        FileNameTxt: Label 'Non-Conformance Report %1.pdf', comment = '%1=Unique report no.';
        ImageFileNameTxt: Label '%1 Image %2.%3', comment = '%1=Record No. %2=Attachment Line %3=file extension';
        Text001Msg: Label 'Sending Non Conformance Confirmation:\#1############################', Comment = '%1=Brokerage Shipment Number';
        HTMLBuilder: TextBuilder;


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

                If DocumentAttachment.FindSet(false) then
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