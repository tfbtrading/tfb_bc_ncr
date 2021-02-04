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
                        Importance = Additional;
                        ToolTip = 'Specify the order number related to the ledger entry';
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

        }
    }



}