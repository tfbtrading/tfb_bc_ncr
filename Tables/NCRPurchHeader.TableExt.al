tableextension 50806 "TFB NCR Purch Header" extends "Purchase Header"
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