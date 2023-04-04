pageextension 50800 "TFB NCR Core Setup" extends "TFB Core Setup"
{
    layout
    {
        addlast(NumberSeries)
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