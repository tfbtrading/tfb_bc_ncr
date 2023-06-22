pageextension 50809 "TFB NCR Sales Admin Activities" extends "TFB Sales Admin Activities"
{
    layout
    {
        addlast(Quality)
        {
            field("No. Open NCR"; Rec."No. Open NCR")
            {
                ApplicationArea = Suite;
                Caption = 'Open NCRs';
                DrillDownPageID = "TFB Non Conformance Reports";
                ToolTip = 'Open Non Conformances.';
            }
            field("No. Open NCR Overdue"; Rec."No. Open NCR Overdue")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Open NCRs Overdue';
                DrillDownPageID = "Lot No. Information List";
                ToolTip = 'Open Non Conformances past when correct action due indicated';
            }

        }
    }

    actions
    {
        // Add changes to page actions here
    }


}