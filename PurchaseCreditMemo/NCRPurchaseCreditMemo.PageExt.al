pageextension 50811 "TFB NCR Purchase Credit Memo" extends "Purchase Credit Memo"
{
    layout
    {
        addafter("Reason Code")
        {
            field("TFB NCR No."; Rec."TFB NCR No.")
            {
                ApplicationArea = All;
                Editable = true;
                ToolTip = 'Specify the related non conformance request';
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }


}