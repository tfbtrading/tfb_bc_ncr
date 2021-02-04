tableextension 50803 "TFB NCR Sales Cr.Memo Header" extends "Sales Cr.Memo Header"
{
    fields
    {
        field(50800; "TFB NCR No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'NCR No.';
            TableRelation = "TFB Non-Conformance Report";
            ValidateTableRelation = true;
            Editable = false;
        }
    }


}