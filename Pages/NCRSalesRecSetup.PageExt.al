pageextension 50800 "TFB NCR Sales & Rec. Setup" extends "Sales & Receivables Setup"
{
    layout
    {
        addafter("Order Nos.")
        {
            field("TFB Non Conf. Report Nos."; Rec."TFB Non Conf. Report Nos.")
            {
                ApplicationArea = All;
                LookupPageId = "No. Series";
                ToolTip = 'Specifies the number sequence for non conformance reports';
            }
        }
    }

    actions
    {
    }
}