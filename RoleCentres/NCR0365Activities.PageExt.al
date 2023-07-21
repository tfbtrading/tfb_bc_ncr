pageextension 50814 "NCR 0365 Activities" extends "O365 Activities"
{
    layout
    {
        addafter("Ongoing Purchases")
        {
            cuegroup(Quality)
            {
                Caption = 'Ongoing Quality Documents';

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
                    DrillDownPageID = "TFB Non Conformance Reports";
                    ToolTip = 'Open Non Conformances past when correct action due indicated';
                }
            }
        }


    }

    actions
    {
        // Add changes to page actions here
    }


}