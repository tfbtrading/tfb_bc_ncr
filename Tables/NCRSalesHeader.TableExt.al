tableextension 50802 "TFB NCR Sales Header" extends "Sales Header"
{
    fields
    {
        field(50800; "TFB NCR No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'NCR No.';
            TableRelation = "TFB Non-Conformance Report";
            ValidateTableRelation = true;
        }
    }


}