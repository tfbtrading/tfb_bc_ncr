page 50806 "TFB NCR Type Policies"
{
    PageType = List;
    Caption = 'Non-Conformance Type Policies';
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "TFB NCR Type Policy";
    Editable = true;
    InsertAllowed = true;
    DeleteAllowed = true;
    ModifyAllowed = true;


    layout
    {
        area(Content)
        {
            repeater(Repeater)
            {

                field(NCRType; Rec.NCRType)
                {
                    ToolTip = 'Specifies the type of non-conformance request.';
                    ApplicationArea = All;
                }
                field(Active; Rec.Active)
                {
                    ToolTip = 'Specifies whether this type of non-conformance is actively used.';
                    ApplicationArea = All;
                }
                field(Overview; Rec.Overview)
                {
                    ToolTip = 'Specifies an overview description of the NCR type.';
                    ApplicationArea = All;
                }
                field(InstructionsURL; Rec.InstructionsURL)
                {
                    ToolTip = 'Specifies the value of the Instructions URL field.';
                    ApplicationArea = All;
                }
                field("No. of Reports"; Rec."No. of Reports")
                {
                    ToolTip = 'Specifies the count of the no. of reports for this type';
                    ApplicationArea = All;
                    DrillDown = true;
                }
            }
        }
        area(Factboxes)
        {

        }
    }


}