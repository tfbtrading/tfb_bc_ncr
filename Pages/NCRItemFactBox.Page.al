page 50804 "TFB NCR Item FactBox"
{
    PageType = CardPart;
    SourceTable = "Item Ledger Entry";
    Caption = 'Sale Details';
    Extensible = true;

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies date goods were shipped';
                }

                field("Order No."; GetOrderNo())
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies sales order number of goods';

                    DrillDown = true;
                    DrillDownPageId = "Sales Order Archives";

                    trigger OnDrillDown()
                    var
                        Archive: Record "Sales Header Archive";


                    begin

                        If not ArchiveLine.IsEmpty() then begin
                            Archive.SetRange("Document Type", ArchiveLine."Document Type");
                            Archive.SetRange("No.", ArchiveLine."Document No.");
                            Archive.SetRange("Version No.", ArchiveLine."Version No.");
                            Archive.SetRange("Doc. No. Occurrence", ArchiveLine."Doc. No. Occurrence");

                            If Archive.FindFirst() then
                                Page.RUN(Page::"Sales Order Archive", Archive);
                        end;
                    end;

                }
                field("Invoice No."; GetInvoiceNo())
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies posted invoice number of of goods';
                    DrillDown = true;
                    DrillDownPageId = "Posted Sales Invoice";

                    trigger OnDrillDown()

                    var
                        SalesInvoice: Record "Sales Invoice Header";

                    begin

                        If SalesInvoice.Get(InvoiceNo) then
                            Page.RUN(Page::"Posted Sales Invoice", SalesInvoice);

                    end;
                }
                field(Quantity; abs(Rec.Quantity))
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies posted quantity of goods sent';
                }
                field("Agent Name"; GetAgentName())
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies agent used to ship the goods';
                }
                field("Package Tracking No"; TrackingNo)

                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies tracking number';
                }

                group(Dropship)
                {
                    // Visible = "Drop Shipment";
                    field(Vendor; GetVendorName())
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies get vendor name';
                    }
                    field("Purchase Order No."; GetPurchaseOrderNo())
                    {
                        ApplicationArea = All;
                        DrillDown = true;
                        DrillDownPageId = "Purchase Order Archives";

                        trigger OnDrillDown()
                        var
                            ArchiveOrder: record "Purchase Header Archive";

                        begin
                            ArchiveOrder.SetRange("No.", GetPurchaseOrderNo());
                            ArchiveOrder.SetRange("Document Type", ArchiveOrder."Document Type"::Order);
                            ArchiveOrder.SetRange("Doc. No. Occurrence", 1);

                            If ArchiveOrder.FindLast() then
                                Page.Run(Page::"Purchase Order Archive", ArchiveOrder);

                        end;
                    }
                }

                group(Warehouse)
                {
                    //Visible = not "Drop Shipment";


                    field("Warehouse Ref"; WarehouseRef)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies Warehouse Reference No';
                        DrillDown = true;
                        DrillDownPageId = "Posted Whse. Shipment";

                        trigger OnDrillDown()

                        var
                            WhseHeader: Record "Posted Whse. Shipment Header";

                        begin
                            If not WhseLine.IsEmpty() then begin
                                If WhseHeader.Get(WhseLine."No.") then
                                    Page.Run(Page::"Posted Whse. Shipment", WhseHeader);
                            end;

                        end;
                    }
                }


            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }




    var
        OrderNo: Code[20];
        ArchiveLine: Record "Sales Line Archive";
        WhseLine: Record "Posted Whse. Shipment Line";

        InvoiceNo: Code[20];
        PurchaseOrderNo: Code[20];
        VendorName: Text;

        WarehouseRef: Code[20];

        TrackingNo: Text;

        Qty: Decimal;
        Agent: Text;


    trigger OnAfterGetRecord()


    var
        ShipmentLine: Record "Sales Shipment Line";
        Shipment: Record "Sales Shipment Header";

        ValueEntry: Record "Value Entry";

        Receipt: Record "Purch. Rcpt. Header";

    begin
        //Get Sales Shipment

        If Rec."Document Type" = Rec."Document Type"::"Sales Shipment" then begin
            ShipmentLine.SetRange("Line No.", Rec."Document Line No.");
            ShipmentLine.SetRange("Document No.", Rec."Document No.");
            if ShipmentLine.FindFirst() then begin

                //Check archive
                Shipment.Get(ShipmentLine."Document No.");
                OrderNo := ShipmentLine."Order No.";
                PurchaseOrderNo := ShipmentLine."Purchase Order No.";
                TrackingNo := Shipment."Package Tracking No.";

                ArchiveLine.SetRange("Line No.", ShipmentLine."Order Line No.");
                ArchiveLine.SetRange("Document No.", ShipmentLine."Order No.");
                ArchiveLine.SetRange("Document Type", ArchiveLine."Document Type"::Order);
                ArchiveLine.SetRange("Doc. No. Occurrence", 1);

                If ArchiveLine.FindLast() then
                    Agent := ArchiveLine."Shipping Agent Code"
                else
                    Agent := 'Error no archive';

                If Rec."Drop Shipment" then begin
                    Receipt.SetRange("Order No.");
                    If Receipt.FindFirst() then
                        VendorName := Receipt."Buy-from Vendor Name"
                    else
                        VendorName := 'Error no receipt';
                end
                else begin
                    VendorName := '';



                    WhseLine.SetRange("Posted Source No.", ShipmentLine."Document No.");
                    WhseLine.SetRange("Posted Source Document", WhseLine."Posted Source Document"::"Posted Shipment");

                    If WhseLine.FindFirst() then
                        WarehouseRef := WhseLine."Whse. Shipment No."
                    else
                        WarehouseRef := '';
                end;

                ValueEntry.SetRange("Item Ledger Entry No.", Rec."Entry No.");
                ValueEntry.SetFilter("Item Ledger Entry Quantity", '<>0');
                ValueEntry.SetRange("Document Type", ValueEntry."Document Type"::"Sales Invoice");

                If ValueEntry.FindFirst() then
                    InvoiceNo := ValueEntry."Document No.";

            end;
        end;

    end;


    /// <summary> 
    /// Returns the agents name
    /// </summary>
    /// <returns>Return variable "Text".</returns>
    local procedure GetAgentName(): Text

    var

    begin
        Exit(Agent);
    end;


    /// <summary> 
    /// Returns Customer Invoice No
    /// </summary>
    /// <returns>Return variable "Code[20]".</returns>
    local procedure GetInvoiceNo(): Code[20]
    begin
        Exit(InvoiceNo);
    end;

    /// <summary> 
    /// Returns Customer Order No
    /// </summary>
    /// <returns>Return variable "Code[20]".</returns>
    local procedure GetOrderNo(): Code[20]
    begin
        Exit(OrderNo);
    end;

    /// <summary> 
    /// Returns drop ship purchase order number
    /// </summary>
    /// <returns>Return variable "Code[20]".</returns>
    local procedure GetPurchaseOrderNo(): Code[20]
    begin
        Exit(PurchaseOrderNo);
    end;

    /// <summary> 
    /// Returns the vendors name
    /// </summary>
    /// <returns>Return variable "Text".</returns>
    local procedure GetVendorName(): Text

    begin
        Exit(VendorName);
    end;
}