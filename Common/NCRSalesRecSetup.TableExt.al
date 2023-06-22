tableextension 50800 "TFB NCR Sales & Rec. Setup" extends "Sales & Receivables Setup"
{
    fields
    {
        field(50800; "TFB Non Conf. Report Nos."; Code[20])
        {
            Caption = 'Non Conformance Report Nos.';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
            ValidateTableRelation = true;
            ObsoleteReason = 'Replaced by core setup table';
            ObsoleteState = Pending;
        }


    }

}