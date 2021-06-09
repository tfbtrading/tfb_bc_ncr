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
                    Caption = 'Posting Date';
                }

                field("Order No."; GetOrderNo())
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies sales order number of goods';

                    DrillDown = true;
                    DrillDownPageId = "Sales Order Archives";
                    Caption = 'Order No.';

                    trigger OnDrillDown()
                    var
                        Archive: Record "Sales Header Archive";


                    begin

                        If not SalesLineArchive.IsEmpty() then begin
                            Archive.SetRange("Document Type", SalesLineArchive."Document Type");
                            Archive.SetRange("No.", SalesLineArchive."Document No.");
                            Archive.SetRange("Version No.", SalesLineArchive."Version No.");
                            Archive.SetRange("Doc. No. Occurrence", SalesLineArchive."Doc. No. Occurrence");

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
                    Caption = 'Invoice No.';

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
                    Caption = 'Quantity';
                }
                field("Agent Name"; GetAgentName())
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies agent used to ship the goods';
                    Caption = 'Agent Name';
                }
                field("Package Tracking No"; TrackingNo)

                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies tracking number';
                    Caption = 'Package Tracking No.';
                }

                group(Dropship)
                {
                    // Visible = "Drop Shipment";
                    field(Vendor; GetVendorName())
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies get vendor name';
                        Caption = 'Vendor Name';
                    }
                    field("Purchase Order No."; GetPurchaseOrderNo())
                    {
                        ApplicationArea = All;
                        DrillDown = true;
                        DrillDownPageId = "Purchase Order Archives";
                        Caption = 'Purchase Order No.';
                        ToolTip = 'Specifies the purchase order number';

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
                        Caption = 'Warehouse Refence';

                        trigger OnDrillDown()

                        var
                            WhseHeader: Record "Posted Whse. Shipment Header";

                        begin
                            If not PostedWhseShipmentLine.IsEmpty() then
                                If WhseHeader.Get(PostedWhseShipmentLine."No.") then
                                    Page.Run(Page::"Posted Whse. Shipment", WhseHeader);
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

        }
    }




    var
        SalesLineArchive: Record "Sales Line Archive";
        PostedWhseShipmentLine: Record "Posted Whse. Shipment Line";
        OrderNo: Code[20];

        InvoiceNo: Code[20];
        PurchaseOrderNo: Code[20];
        VendorName: Text;

        WarehouseRef: Code[20];

        TrackingNo: Text;


        Agent: Text;


    trigger OnAfterGetRecord()


    var
        SalesShipmentLine: Record "Sales Shipment Line";
        SalesShipmentHeader: Record "Sales Shipment Header";

        ValueEntry: Record "Value Entry";

        PurchRcptHeader: Record "Purch. Rcpt. Header";

    begin
        //Get Sales Shipment

        If Rec."Document Type" = Rec."Document Type"::"Sales Shipment" then begin
            SalesShipmentLine.SetRange("Line No.", Rec."Document Line No.");
            SalesShipmentLine.SetRange("Document No.", Rec."Document No.");
            if SalesShipmentLine.FindFirst() then begin

                //Check archive
                SalesShipmentHeader.Get(SalesShipmentLine."Document No.");
                OrderNo := SalesShipmentLine."Order No.";
                PurchaseOrderNo := SalesShipmentLine."Purchase Order No.";
                TrackingNo := SalesShipmentHeader."Package Tracking No.";

                SalesLineArchive.SetRange("Line No.", SalesShipmentLine."Order Line No.");
                SalesLineArchive.SetRange("Document No.", SalesShipmentLine."Order No.");
                SalesLineArchive.SetRange("Document Type", SalesLineArchive."Document Type"::Order);
                SalesLineArchive.SetRange("Doc. No. Occurrence", 1);

                If SalesLineArchive.FindLast() then
                    Agent := SalesLineArchive."Shipping Agent Code"
                else
                    Agent := 'Error no archive';

                If Rec."Drop Shipment" then begin
                    PurchRcptHeader.SetRange("Order No.", SalesShipmentLine."Purchase Order No.");
                    If PurchRcptHeader.FindFirst() then
                        VendorName := PurchRcptHeader."Buy-from Vendor Name"
                    else
                        VendorName := 'Error no receipt';
                end
                else begin
                    VendorName := '';



                    PostedWhseShipmentLine.SetRange("Posted Source No.", SalesShipmentLine."Document No.");
                    PostedWhseShipmentLine.SetRange("Posted Source Document", PostedWhseShipmentLine."Posted Source Document"::"Posted Shipment");

                    If PostedWhseShipmentLine.FindFirst() then
                        WarehouseRef := PostedWhseShipmentLine."Whse. Shipment No."
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