Codeunit 50011 "Job Jnl.-Check Line 1"
{


    TableNo = 210;
    trigger OnRun()
    BEGIN
        RunCheck(Rec);
    END;

    VAR
        Text000: TextConst ENU = 'cannot be a closing date.', ESP = 'no puede ser una fecha de cierre.';
        Text001: TextConst ENU = 'is not within your range of allowed posting dates.', ESP = 'no est� dentro del periodo de fechas de registro permitidas.';
        Text002: TextConst ENU = 'The combination of dimensions used in %1 %2, %3, %4 is blocked. %5', ESP = 'La combin. de dimensiones utilizada en %1 %2, %3, %4 est� bloq. %5';
        Text003: TextConst ENU = 'A dimension used in %1 %2, %3, %4 has caused an error. %5', ESP = 'Una dimensi�n usada en %1 %2, %3, %4 ha producido un error. %5.';
        Location: Record 14;
        DimMgt: Codeunit 408;
        DimMgt1: Codeunit 50361;
        TimeSheetMgt: Codeunit 950;
        Text004: TextConst ENU = '"You must post more usage of %1 %2 in %3 %4 before you can post job journal %5 %6 = %7."', ESP = '"Debe registrar m�s uso de %1 %2 en %3 %4 para poder registrar el diario del proyecto %5 %6 = %7."';
        QBCodeunitPublisher: Codeunit 7207352;
        FunctionQB: Codeunit 7207272;

    //[External]
    PROCEDURE RunCheck(VAR JobJnlLine: Record 210);
    VAR
        Job: Record 167;
        UserSetupManagement: Codeunit 5700;
        TableID: ARRAY[10] OF Integer;
        No: ARRAY[10] OF Code[20];
    BEGIN
        OnBeforeRunCheck(JobJnlLine);

        WITH JobJnlLine DO BEGIN
            IF EmptyLine THEN
                EXIT;
            TESTFIELD("Job No.");
            IF NOT FunctionQB.AccessToQuobuilding THEN BEGIN //QB
                TESTFIELD("Job Task No.");
                TESTFIELD(Quantity); //RE001
            END;
            TESTFIELD("No.");
            TESTFIELD("Posting Date");


            Job.GET("Job No.");
            Job.TESTFIELD(Status, Job.Status::Open);

            IF NORMALDATE("Posting Date") <> "Posting Date" THEN
                FIELDERROR("Posting Date", Text000);

            IF ("Document Date" <> 0D) AND ("Document Date" <> NORMALDATE("Document Date")) THEN
                FIELDERROR("Document Date", Text000);

            IF NOT UserSetupManagement.IsPostingDateValid("Posting Date") THEN
                FIELDERROR("Posting Date", Text001);

            IF "Time Sheet No." <> '' THEN
                TimeSheetMgt.CheckJobJnlLine(JobJnlLine);

            IF NOT DimMgt.CheckDimIDComb("Dimension Set ID") THEN
                ERROR(
                  Text002,
                  TABLECAPTION, "Journal Template Name", "Journal Batch Name", "Line No.",
                  DimMgt.GetDimCombErr);

            TableID[1] := DATABASE::Job;
            No[1] := "Job No.";
            TableID[2] := DimMgt1.TypeToTableID2(Type);//enum to option
            No[2] := "No.";
            TableID[3] := DATABASE::"Resource Group";
            No[3] := "Resource Group No.";
            IF NOT DimMgt.CheckDimValuePosting(TableID, No, "Dimension Set ID") THEN BEGIN
                IF "Line No." <> 0 THEN
                    ERROR(
                      Text003,
                      TABLECAPTION, "Journal Template Name", "Journal Batch Name", "Line No.",
                      DimMgt.GetDimValuePostingErr);
                ERROR(DimMgt.GetDimValuePostingErr);
            END;

            IF Type = Type::Item THEN BEGIN
                IF ("Quantity (Base)" < 0) AND ("Entry Type" = "Entry Type"::Usage) THEN
                    IF NOT FunctionQB.AccessToQuobuilding THEN //QB
                        CheckItemQuantityJobJnl(JobJnlLine);
                GetLocation("Location Code");
                IF Location."Directed Put-away and Pick" THEN
                    TESTFIELD("Bin Code", '')
                ELSE
                    IF Location."Bin Mandatory" THEN
                        TESTFIELD("Bin Code");
            END;
            IF "Line Type" IN ["Line Type"::Billable, "Line Type"::"Both Budget and Billable"] THEN
                TESTFIELD(Chargeable, TRUE);
        END;
        QBCodeunitPublisher.TestLinDiaproyCJobJnlCheckLine(JobJnlLine);

        OnAfterRunCheck(JobJnlLine);
    END;

    LOCAL PROCEDURE GetLocation(LocationCode: Code[10]);
    BEGIN
        IF LocationCode = '' THEN
            CLEAR(Location)
        ELSE
            IF Location.Code <> LocationCode THEN
                Location.GET(LocationCode);
    END;

    LOCAL PROCEDURE CheckItemQuantityJobJnl(VAR JobJnlline: Record 210);
    VAR
        Item: Record 27;
        Job: Record 167;
    BEGIN
        IF JobJnlline.IsNonInventoriableItem THEN
            EXIT;

        Job.GET(JobJnlline."Job No.");
        IF (Job.GetQuantityAvailable(JobJnlline."No.", JobJnlline."Location Code", JobJnlline."Variant Code", 0, 2) +
            JobJnlline."Quantity (Base)") < 0
        THEN
            ERROR(
              Text004, Item.TABLECAPTION, JobJnlline."No.", Job.TABLECAPTION,
              JobJnlline."Job No.", JobJnlline."Journal Batch Name",
              JobJnlline.FIELDCAPTION("Line No."), JobJnlline."Line No.");
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnAfterRunCheck(VAR JobJnlLine: Record 210);
    BEGIN
    END;

    //[IntegrationEvent]
    LOCAL PROCEDURE OnBeforeRunCheck(VAR JobJnlLine: Record 210);
    BEGIN
    END;


    
    /*BEGIN
/*{
      RE001  NZG 24/01/18  : Incluir dentro del IF el TESTFIELD(Quantity);
    }
END.*/
}









