pageextension 50813 "TFB NCR Purchase Return Order" extends "Purchase Return Order"
{
    layout
    {
        addafter("Reason Code")
        {
            field("TFB NCR No."; Rec."TFB NCR No.")
            {
                ApplicationArea = All;
                Editable = true;
                Importance = Standard;
                ToolTip = 'Specify the related non conformance request';
            }
        }

        modify("Campaign No.")
        {
            Visible = false;
        }
    }



    actions
    {
        // Add changes to page actions here
    }


}