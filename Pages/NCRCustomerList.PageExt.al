pageextension 50802 "TFB NCR Customer List" extends "Customer List"
{
    layout
    {

    }

    actions
    {
        addafter(Reminder)
        {
            action(NCR)
            {
                ApplicationArea = All;
                ToolTip = 'Create non conformance report for customer';
                Caption = 'Non conformance';
                Image = ErrorLog;
                RunObject = Page "TFB Non Conformance Report";
                RunPageMode = Create;
                Promoted = true;
                PromotedCategory = Category5;
            }
        }
    }


}