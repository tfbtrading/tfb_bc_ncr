tableextension 50805 "TFB NCR Purch Cr.Memo Hdr." extends "Purch. Cr. Memo Hdr."
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