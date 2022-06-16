permissionset 50800 "TFB NCR Admin"
{
    Assignable = true;
    Permissions =
        tabledata "TFB Non-Conformance Report" = RIMD,
        tabledata "TFB NCR Type Policy" = RIMD,
         table "TFB Non-Conformance Report" = X,
        table "TFB NCR Type Policy" = X,
        page "TFB NCR Attachment" = X,
        page "TFB NCR Attachments" = X,
        page "TFB NCR Item FactBox" = X,
        page "TFB NCR Type Policies" = X,
        page "TFB Non Conformance Report" = X,
        page "TFB Non Conformance Reports" = X,
        page "TFB Report Sel - NCR" = X;
}