pageextension 50807 "TFB NCR Sales Invoice Subform" extends "Posted Sales Invoice Subform"
{

    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addlast("&Line")
        {
            action("CreateNonConformance")
            {
                ApplicationArea = all;
                Caption = 'Create Non-Conformance Report';
                Image = CreateDocument;
                ToolTip = 'Create a new non-conformance report based on this invoice';

                trigger OnAction()

                begin
                    AddNewNonConformance(Rec);
                end;
            }
        }
    }

    /// <summary> 
    /// Create a non conformance record related to a particular sales invice
    /// </summary>
    /// <param name="SalesInvoiceLine">Parameter of type Record "Sales Invoice Line".</param>
    local procedure AddNewNonConformance(SalesInvoiceLine: Record "Sales Invoice Line")

    var
        ValueEntry: Record "Value Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
        TFBNonConformanceReport: Record "TFB Non-Conformance Report";

    begin
        ValueEntry.SetRange("Document No.", SalesInvoiceLine."Document No.");
        ValueEntry.SetRange("Document Line No.", SalesInvoiceLine."Line No.");
        ValueEntry.SetRange("Document Type", ValueEntry."Document Type"::"Sales Invoice");

        If ValueEntry.FindFirst() then
            if ItemLedgerEntry.Get(ValueEntry."Item Ledger Entry No.") then begin

                TFBNonConformanceReport.Init();
                TFBNonConformanceReport.Validate("Customer No.", ItemLedgerEntry."Source No.");
                TFBNonConformanceReport."Date Raised" := Today;
                TFBNonConformanceReport.Validate("Item No.", ItemLedgerEntry."Item No.");
                TFBNonConformanceReport."Order Type" := TFBNonConformanceReport."Order Type"::Standard;
                TFBNonConformanceReport.Validate("Item Ledger Entry No.", ItemLedgerEntry."Entry No.");
                TFBNonConformanceReport."Non-Conformity Details" := 'Raised directly from sales invoice';
                TFBNonConformanceReport.Insert(true);

                PAGE.Run(PAGE::"TFB Non Conformance Report", TFBNonConformanceReport);

            end;
    end;

}