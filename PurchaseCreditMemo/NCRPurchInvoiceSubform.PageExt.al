pageextension 50812 "TFB NCR Purch. Invoice Subform" extends "Posted Purch. Invoice Subform"
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
    /// <param name="PurchInvLine">Parameter of type Record "Sales Invoice Line".</param>
    local procedure AddNewNonConformance(PurchInvLine: Record "Purch. Inv. Line")

    var
        ValueEntry: Record "Value Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
        TFBNonConformanceReport: Record "TFB Non-Conformance Report";

    begin
        ValueEntry.SetRange("Document No.", PurchInvLine."Document No.");
        ValueEntry.SetRange("Document Line No.", PurchInvLine."Line No.");
        ValueEntry.SetRange("Document Type", ValueEntry."Document Type"::"Purchase Invoice");

        If ValueEntry.FindFirst() then
            if ItemLedgerEntry.Get(ValueEntry."Item Ledger Entry No.") then begin

                TFBNonConformanceReport.Init();
                TFBNonConformanceReport.Validate(Source,TFBNonConformanceReport.Source::Warehouse);
                TFBNonConformanceReport.Validate("Vendor No.", ItemLedgerEntry."Source No.");
                TFBNonConformanceReport."Date Raised" := Today;
                TFBNonConformanceReport.Validate("Item No.", ItemLedgerEntry."Item No.");
                TFBNonConformanceReport."Order Type" := TFBNonConformanceReport."Order Type"::Standard;
                TFBNonConformanceReport.Validate("Item Ledger Entry No.", ItemLedgerEntry."Entry No.");
                TFBNonConformanceReport."Non-Conformity Details" := 'Raised directly from purchase invoice';
                TFBNonConformanceReport.Insert(true);

                PAGE.Run(PAGE::"TFB Non Conformance Report", TFBNonConformanceReport);

            end;
    end;

}