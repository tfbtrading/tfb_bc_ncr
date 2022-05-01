/// <summary>
/// Table TFB NCR Type Policy (ID 50800).
/// </summary>
table 50800 "TFB NCR Type Policy"
{
    DataClassification = CustomerContent;
    Caption = 'NCR Type Policy';

    fields
    {
        field(1; "NCRType"; Enum "TFB NCR Type")
        {

        }
        field(2; Active; Boolean)
        {

        }
        field(3; Overview; Text[256])
        {

        }
        field(4; InstructionsURL; Text[80])
        {
            ExtendedDatatype = URL;
            Caption = 'Instructions URL';
        }
        field(6; "No. Of Reports"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("TFB Non-Conformance Report" where(Type = field(NCRType), Status = field("Status Filter")));
        }
        field(20; "Status Filter"; Enum "TFB NCR Status")
        {
            FieldClass = FlowFilter;
        }


    }

    keys
    {
        key(PK; NCRType)
        {
            Clustered = true;
        }
    }



    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}