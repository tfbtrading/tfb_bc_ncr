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
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                PromotedCategory = Category4;
                Image = CreateDocument;
                ToolTip = 'Create a new non-conformance report based on this invoice';

                trigger OnAction()

                begin
                    CreateNonConformance(Rec);
                end;
            }
        }
    }

    /// <summary> 
    /// Create a non conformance record related to a particular sales invice
    /// </summary>
    /// <param name="SalesInvoiceLine">Parameter of type Record "Sales Invoice Line".</param>
    local procedure CreateNonConformance(SalesInvoiceLine: Record "Sales Invoice Line")

    var
        ValueEntry: Record "Value Entry";
        ItemLedger: Record "Item Ledger Entry";
        NCR: Record "TFB Non-Conformance Report";

    begin
        ValueEntry.SetRange("Document No.", SalesInvoiceLine."Document No.");
        ValueEntry.SetRange("Document Line No.", SalesInvoiceLine."Line No.");
        ValueEntry.SetRange("Document Type", ValueEntry."Document Type"::"Sales Invoice");

        If ValueEntry.FindFirst() then
            if ItemLedger.Get(ValueEntry."Item Ledger Entry No.") then begin

                NCR.Init();
                NCR.Validate("Customer No.", ItemLedger."Source No.");
                NCR."Date Raised" := Today;
                NCR.Validate("Item No.", ItemLedger."Item No.");
                NCR."Order Type" := NCR."Order Type"::Standard;
                NCR.Validate("Item Ledger Entry No.", ItemLedger."Entry No.");
                NCR."Non-Conformity Details" := 'Raised directly from sales invoice';
                NCR.Insert(true);

                PAGE.Run(PAGE::"TFB Non Conformance Report", NCR);

            end;
    end;

}