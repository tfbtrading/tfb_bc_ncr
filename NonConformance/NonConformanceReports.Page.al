page 50801 "TFB Non Conformance Reports"
{
    PageType = List;
    Caption = 'Non Conformance Reports';
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "TFB Non-Conformance Report";
    Editable = false;
    CardPageId = "TFB Non Conformance Report";
    SourceTableView = sorting("No.") order(descending);

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specify number sequence';
                }

                field("Date Raised"; Rec."Date Raised")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specify date report was raised by customer';
                }
                field("External Reference No."; Rec."External Reference No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specify the external reference number if provided by customer';
                }
                field("Issued By"; Rec."Issued By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specify the name of the contact who reported the issue';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specify customer number';

                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specify customer name';
                }

                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specify the item for which an issue was reported';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specify the description of the item for which the issue was reported';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specify current status of the report';
                    Style = Favorable;
                    StyleExpr = Rec.Status = Rec.Status::Complete;
                }


            }
        }
        area(Factboxes)
        {
            part("Attachments"; "TFB NCR Attachments")
            {
                ApplicationArea = All;
                SubPageLink = "No." = field("No.");
            }
            systempart(notes; Notes)
            {
                ApplicationArea = All;
            }
            part(SaleDetails; "TFB NCR Item FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "Entry No." = field("Item Ledger Entry No.");
                Caption = 'Sales Details';
            }
        }


    }
    views
    {
        view(InProgress)
        {
            Caption = 'In Progress';
            Filters = where(Closed = const(false));
            OrderBy = descending("Date Raised");
            SharedLayout = true;
        }
    }


}