pageextension 50810 "TFB NCR Pstd Sales Cr. Memo" extends "Posted Sales Credit Memo"
{
    layout
    {
        addlast(General)
        {
            field("TFB NCR No."; Rec."TFB NCR No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the related Non Conformance if it exists';
                TableRelation = "TFB Non-Conformance Report"."No.";
                DrillDownPageId = "TFB Non Conformance Report";
                Caption = 'Related NCR';
                Importance = Standard;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }


}