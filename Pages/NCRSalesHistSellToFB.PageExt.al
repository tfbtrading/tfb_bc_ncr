pageextension 50801 "TFB NCR Sales Hist. Sell-to FB" extends "Sales Hist. Sell-to FactBox"
{
    layout
    {
        addlast(content)
        {
            field("TFB No. Of NCRs"; Rec."TFB No. Of NCRs")
            {
                ApplicationArea = All;
                DrillDown = true;
                DrillDownPageId = "TFB Non Conformance Reports";
                Caption = 'Ongoing NCRs';
                Visible = true;
                ToolTip = 'Specifies number of outstanding non conformance requests';
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }


}