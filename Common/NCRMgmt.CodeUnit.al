codeunit 50800 "TFB NCR Mgmt."
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::Email, 'OnShowSource', '', false, false)]
    local procedure OnShowSource(SourceTableId: Integer; SourceSystemId: Guid; var IsHandled: Boolean);
    var
        Record: Record "TFB Non-Conformance Report";
        Page: Page "TFB Non Conformance Report";

    begin

        case SourceTableId of
            Database::"TFB Non-Conformance Report":
                begin

                    Record.GetBySystemId(SourceSystemId);
                    Page.Editable(true);
                    Page.SetRecord(Record);
                    Page.Run();
                    IsHandled := true;

                end;
        end;
    end;



}