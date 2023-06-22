tableextension 50801 "TFBCustomerExt" extends Customer
{
    fields
    {
        field(50800; "TFB No. Of NCRs"; Integer)
        {
            FieldClass = FlowField;
            Caption = 'No. Of NCRs';

            CalcFormula = count ("TFB Non-Conformance Report" where("Customer No." = field("No.")));

        }


    }

}