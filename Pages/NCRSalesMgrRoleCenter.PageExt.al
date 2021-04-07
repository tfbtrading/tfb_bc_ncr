pageextension 50806 "NCR Sales Mgr. Role Center" extends "Sales Manager Role Center"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter(SalesOrders)
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

  
}