tableextension 50804 "TFB NCR Sales Admin Act. Cue" extends "TFB Sales Admin Activities Cue"
{
    fields
    {
        field(50800; "No. Open NCR"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("TFB Non-Conformance Report" where(Closed = const(false)));
        }

        field(50801; "No. Open NCR Overdue"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("TFB Non-Conformance Report" where(Closed = const(false), "Corrective Action Due" = filter('<today')));
        }
    }



}