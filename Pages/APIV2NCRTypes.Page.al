/// <summary>
/// Page TFB APIV2 - NCR Types (ID 50808).
/// </summary>
page 50808 "TFB APIV2 - NCR Types"
{
    PageType = API;
    Caption = 'APIV2 - NCR Types';
    APIPublisher = 'tfb';
    APIGroup = 'ncr';
    APIVersion = 'v2.0';
    EntityName = 'NonConformanceType';
    EntitySetName = 'NonConformanceTypes';
    SourceTable = "TFB NCR Type Policy";
    DelayedInsert = true;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    Editable = false;
    DataAccessIntent = ReadOnly;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field(ncrType; Rec.NCRType)
                {
                    Caption = 'NCRType';
                }
                field(active; Rec.Active)
                {
                    Caption = 'Active';
                }
                field(overview; Rec.Overview)
                {
                    Caption = 'Overview';
                }
                field(instructionsURL; Rec.InstructionsURL)
                {
                    Caption = 'Instructions URL';
                }
            }
        }
    }
}