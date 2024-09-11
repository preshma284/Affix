page 7207645 "RC Payables Activities"
{
    CaptionML = ENU = 'Activities', ESP = 'Actividades';
    SourceTable = 7206916;
    PageType = CardPart;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            group("group62")
            {

                CaptionML = ENU = 'Cartera', ESP = 'Cartera';
                field("Payable Documents"; rec."Payable Documents")
                {

                    ToolTipML = ENU = 'Specifies the payables document that is associated with the bill group.', ESP = 'Especifica el documento a pagar asociado a la remesa.';
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Payables Cartera Docs";
                }
                field("Pagares por emitir"; rec."Pagares por emitir")
                {

                    ToolTipML = ENU = 'Specifies the payables documents that have been posted.', ESP = 'Especifica los documentos registrados sin emitir pagar�';
                    ApplicationArea = Basic, Suite;
                }
                field("Transferencias ptes"; rec."Transferencias ptes")
                {

                }
                field("Pagares Anulados"; rec."Pagares Anulados")
                {

                }

            }
            group("group67")
            {

                CaptionML = ENU = 'My User Tasks', ESP = 'Mis tareas de usuario';
                field("Pending Tasks"; rec."Pending Tasks")
                {

                    CaptionML = ENU = 'Pending User Tasks', ESP = 'Tareas de usuario pendientes';
                    ToolTipML = ENU = 'Specifies the number of pending tasks that are assigned to you.', ESP = 'Especifica el n�mero de tareas pendientes que tiene asignadas.';
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "User Task List";
                    Image = Checklist;
                }

            }
            group("group69")
            {

                CaptionML = ENU = 'Missing SII Entries', ESP = 'Movs. SII que faltan';
                field("Missing SII Entries"; rec."Missing SII Entries")
                {

                    CaptionML = ENU = 'Missing SII Entries', ESP = 'Movs. SII que faltan';
                    ToolTipML = ENU = 'Specifies that some posted documents were not transferred to SII.', ESP = 'Especifica que algunos documentos registrados no se transfirieron a SII.';
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Recreate Missing SII Entries";

                    ; trigger OnDrillDown()
                    VAR
                        // SIIRecreateMissingEntries: Codeunit 51304;
                        SIIRecreateMissingEntries: Codeunit 10757;
                    BEGIN
                        SIIRecreateMissingEntries.ShowRecreateMissingEntriesPage;
                    END;


                }
                field("Days Since Last SII Check"; rec."Days Since Last SII Check")
                {

                    ToolTipML = ENU = 'Specifies the number of days since the last check for missing SII entries.', ESP = 'Especifica el n�mero de d�as desde que se comprob� por �ltima vez si faltan movimientos SII.';
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Recreate Missing SII Entries";
                    Image = Calendar;
                }

            }

        }
    }

    trigger OnOpenPage()
    BEGIN
        Rec.RESET;
        IF NOT Rec.GET THEN BEGIN
            Rec.INIT;
            Rec.INSERT;
        END;

        Rec.SETFILTER("Due Date Filter", '<=%1', WORKDATE);
        Rec.SETFILTER("User ID Filter", USERID);

        //JAV 21/06/19: Poner formas de pago para las pilas
        QuoBuildingSetup.GET;
        //fields not present in table
        // rec."FP Pagares por emitir" := QuoBuildingSetup."_RP F.Pago Pagares por emitir";
        // rec."FP Transferencias ptes" := QuoBuildingSetup."_RP F.Pago Tranf. por emitir";
        // rec."FP Pagares Anulados" := QuoBuildingSetup."_RP Forma Pago Anulacion";
        Rec.MODIFY;

        //Rec.CALCFIELDS("Pagares Anulados");
    END;

    trigger OnAfterGetRecord()
    BEGIN
        CalculateCueFieldValues;
    END;



    var
        QuoBuildingSetup: Record 7207278;

    LOCAL procedure CalculateCueFieldValues();
    var
        // SIIRecreateMissingEntries: Codeunit 51304;
        SIIRecreateMissingEntries: Codeunit 10757;
    begin
        if Rec.FIELDACTIVE(rec."Missing SII Entries") then
            rec."Missing SII Entries" := SIIRecreateMissingEntries.GetMissingEntriesCount;
        if Rec.FIELDACTIVE(rec."Days Since Last SII Check") then
            rec."Days Since Last SII Check" := SIIRecreateMissingEntries.GetDaysSinceLastCheck;
    end;

    // begin
    /*{
      JAV 21/06/19: Poner formas de pago para las pilas
    }*///end
}







