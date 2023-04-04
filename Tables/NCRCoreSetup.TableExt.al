tableextension 50807 "TFB NCR Core Setup" extends "TFB Core Setup"
{
    fields
    {
        field(50800; "TFB Non Conf. Report Nos."; Code[20])
        {
            Caption = 'Non Conformance Report Nos.';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
            ValidateTableRelation = true;

        }


    }

}