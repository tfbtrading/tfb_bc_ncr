pageextension 50804 "TFB NCR Sales Credit Memo" extends "Sales Credit Memo"
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