tableextension 50644 "MyExtension50644" extends "Acc. Schedule Name"
{

    DataCaptionFields = "Name", "Description";
    CaptionML = ENU = 'Acc. Schedule Name', ESP = 'Nombre esq. cuentas';
    LookupPageID = "Account Schedule Names";

    fields
    {

        // field(10700; "Standardized"; Boolean)
        // {
        //     CaptionML = ENU = 'Standardized', ESP = 'Normalizado';


        // }
        // field(10720; "Acc. No. Referred to old Acc."; Boolean)
        // {
        //     ObsoleteState = Removed;
        //     ObsoleteReason = 'Obsolete features';
        //     CaptionML = ENU = 'Acc. No. Referred to old Acc.', ESP = 'N� cta. con referencia a cta. antigua';
        //     ;


        // }
    }
    keys
    {

    }
    fieldgroups
    {
    }

    var
        //       AccSchedLine@1000 :
        AccSchedLine: Record 85;




    trigger OnDelete();
    begin
        AccSchedLine.SETRANGE("Schedule Name", Name);
        AccSchedLine.DELETEALL;
    end;



    procedure Print()
    var
        //       AccountSchedule@1000 :
        AccountSchedule: Report 25;
        //       IsHandled@1001 :
        IsHandled: Boolean;
    begin
        IsHandled := FALSE;
        OnBeforePrint(Rec, IsHandled);
        if IsHandled then
            exit;

        // if Standardized then
        //    // REPORT.RUN(REPORT::"Normalized Account Schedule", TRUE, FALSE, Rec)
        // else begin
        //     AccountSchedule.SetAccSchedName(Name);
        //     AccountSchedule.SetColumnLayoutName("Default Column Layout");
        //     AccountSchedule.RUN;
        // end;
    end;


    //     LOCAL procedure OnBeforePrint (var AccScheduleName@1000 : Record 50644 "MyExtension50644" extends;var IsHandled@1001 :
    LOCAL procedure OnBeforePrint(var AccScheduleName: Record 84; var IsHandled: Boolean)
    begin
    end;

    /*begin
    end.
  */
}



