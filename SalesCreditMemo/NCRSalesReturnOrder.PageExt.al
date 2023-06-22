pageextension 50808 "TFB NCR Sales Return Order" extends "Sales Return Order"
{
    layout
    {
        addafter("External Document No.")
        {
            field("TFB NCR No."; Rec."TFB NCR No.")
            {
                ApplicationArea = All;
                Editable = true;
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