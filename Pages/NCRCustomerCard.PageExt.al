pageextension 50803 "TFB NCR Customer Card" extends "Customer Card"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter(NewReminder)
        {
            action(NCR)
            {
                ApplicationArea = All;
                ToolTip = 'Create a new non conformance report';
                Caption = 'Non conformance';
                Image = ErrorLog;
                RunObject = Page "TFB Non Conformance Report";
                RunPageLink = "Customer No." = field("No.");
                RunPageMode = Create;

                Promoted = true;
                PromotedCategory = Category4;

            }
        }
    }


}