codeunit 50801 "TFB NCR Upgrade"
{
    SingleInstance = true;
    Subtype = Upgrade;



    trigger OnUpgradePerCompany()
    begin

        If CheckIfUpgradeShouldExecute() then
            MigrateSetup();

        // Code to perform company related table upgrade tasks
    end;

    trigger OnValidateUpgradePerCompany()
    begin
        // Code to make sure that upgrade was successful for each company
    end;

    local procedure CheckIfUpgradeShouldExecute(): Boolean
    begin
        Exit((GetInstallingVersionNo() = '21.0.0.0'))
    end;

    local procedure GetInstallingVersionNo(): Text
    var
        AppInfo: ModuleInfo;
    begin
        NavApp.GetCurrentModuleInfo(AppInfo);
        exit(FORMAT(AppInfo.AppVersion()));
    end;

    local procedure GetCurrentlyInstalledVersionNo(): Text
    var
        AppInfo: ModuleInfo;
    begin
        NavApp.GetCurrentModuleInfo(AppInfo);
        exit(FORMAT(AppInfo.DataVersion()));
    end;

    local procedure MigrateSetup()
    var

    begin

        //No new migration

    end;


}