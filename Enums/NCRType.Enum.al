enum 50800 "TFB NCR Type"
{
    Extensible = true;

    value(0; Unknown)
    {
    }
    value(1; Defect)
    {
        Caption = 'Physical issues - Appearance';
    }
    value(2; Contamination)
    {
        Caption = 'Physical issues - Contaminated';
    }
    value(3; Infestation)
    {

    }
    value(4; Weight)
    {
        Caption = 'Package Weight';
    }
    value(5; Docs)
    {
        Caption = 'Package Labels';
    }
    value(6; InUse)
    {
        Caption = 'Unexpected Usage Outcome';
    }
    value(10; Damage)
    {
        Caption = 'Package Damage';
    }
    value(11; Missing)
    {
        Caption = 'Order - Missing Qty';
    }
    value(12; Incorrect)
    {
        Caption = 'Order - Incorrect Product';
    }


}