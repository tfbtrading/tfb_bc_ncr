page 50807 "TFB APIV2 - NCRs"
{
    PageType = API;
    Caption = 'Non Conformance Report';
    APIPublisher = 'tfb';
    APIGroup = 'custom';
    APIVersion = 'v2.0';
    EntityName = 'NonConformance';
    EntitySetName = 'NonConformances';
    SourceTable = "TFB Non-Conformance Report";
    DelayedInsert = true;
    ODataKeyFields = "No.";
    InsertAllowed = false;
    Editable = false;


    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field(id; Rec.SystemId)
                {
                    Caption = 'Id';
                    Editable = false;
                }
                field(number; Rec."No.")
                {
                    Caption = 'No.';
                }
                field(customerNo; Rec."Customer No.")
                {
                    Caption = 'Customer No.';
                }
                field(customerName; Rec."Customer Name")
                {
                    Caption = 'Customer Name';
                }
                field(contactNo; Rec."Contact No.")
                {
                    Caption = 'Contact No.';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(dateRaised; Rec."Date Raised")
                {
                    Caption = 'Date Raised';
                }
                field(dropShipment; Rec."Drop Shipment")
                {
                    Caption = 'Drop Shipment';
                }
                field(externalReferenceNo; Rec."External Reference No.")
                {
                    Caption = 'External Reference No.';
                }
                field(itemNo; Rec."Item No.")
                {
                    Caption = 'Item No.';
                }
                field(nonConformityDetails; Rec."Non-Conformity Details")
                {
                    Caption = 'Non-Conformity Details';
                }
                field(orderType; Rec."Order Type")
                {
                    Caption = 'Order Type';
                }
                field(status; Rec.Status)
                {
                    Caption = 'Status';
                }
                field("type"; Rec."Type")
                {
                    Caption = 'Type';
                }
                field(vendorNo; Rec."Vendor No.")
                {
                    Caption = 'Vendor No.';
                }
                field(vendorName; Rec."Vendor Name")
                {
                    Caption = 'Vendor Name';
                }
            }
        }
    }
}