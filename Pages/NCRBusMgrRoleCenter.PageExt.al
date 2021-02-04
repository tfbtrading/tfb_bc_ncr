pageextension 50805 "NCR Bus. Mgr. Role Center" extends "Business Manager Role Center"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter("Sales Credit Memos")
        {
            action("Non-Conformance Incident")
            {
                Caption = 'Non-Conformance Incidents';
                ToolTip = 'Opens Non-Conformance list';
                RunObject = page "TFB Non Conformance Reports";
                RunPageMode = view;
                ApplicationArea = All;
            }

        }
    }

    var
        myInt: Integer;
}