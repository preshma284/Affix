report 7207281 "Generate Missing Parts"
{


    CaptionML = ENU = 'Generate Missing Parts', ESP = 'Generar partes que faltan';
    ProcessingOnly = true;

    dataset
    {

        DataItem("Allocation Term"; "Allocation Term")
        {

            DataItemTableView = SORTING("Code");
            RequestFilterFields = "Code";
            DataItem("Resource"; "Resource")
            {

                DataItemTableView = SORTING("No.")
                                 WHERE("Type" = FILTER("Person"), "Blocked" = CONST(false));


                RequestFilterFields = "No.";
                trigger OnPreDataItem();
                BEGIN
                    Window.OPEN(Text005 +
                                 Text004 +
                                 Text003);
                    Hours := 0;
                END;

                trigger OnAfterGetRecord();
                BEGIN
                    Resource.TESTFIELD("Jobs Not Assigned");
                    Resource.TESTFIELD("Cod. Type Jobs not Assigned");

                    IF AllocationTerm.GET("Allocation Term".Code) THEN;
                    Quantity := 0;
                    QuantityHoursRecorded := 0;
                    JobLedgerEntry.RESET;
                    JobLedgerEntry.SETCURRENTKEY("Posting Date", Type, "No.", "Entry Type", "Job Deviation Mov.", "Compute for hours");
                    JobLedgerEntry.SETRANGE("Posting Date", "Allocation Term"."Initial Date", "Allocation Term"."Final Date");
                    JobLedgerEntry.SETRANGE(Type, JobLedgerEntry.Type::Resource);
                    JobLedgerEntry.SETRANGE("No.", Resource."No.");
                    JobLedgerEntry.SETRANGE("Entry Type", JobLedgerEntry."Entry Type"::Usage);
                    JobLedgerEntry.SETRANGE("Job Deviation Mov.", FALSE);
                    JobLedgerEntry.SETRANGE("Compute for hours", TRUE);
                    IF JobLedgerEntry.FINDSET(FALSE, FALSE) THEN BEGIN
                        REPEAT
                            Quantity := Quantity + JobLedgerEntry.Quantity;
                            Hours := Hours + 1;
                            Window.UPDATE(2, Hours);
                        UNTIL JobLedgerEntry.NEXT = 0;
                    END ELSE
                        Quantity := 0;

                    IF AllocationTermDays.GET(Resource."Type Calendar", "Allocation Term".Code) THEN BEGIN
                        AllocationTermDays.CALCFIELDS("Hours to work");
                        IF Quantity < AllocationTermDays."Hours to work" THEN
                            QuantityHoursRecorded := AllocationTermDays."Hours to work" - Quantity
                    END;

                    CreatePart;
                END;


            }
        }
    }
    requestpage
    {

        layout
        {
            area(content)
            {
                group("group394")
                {

                    CaptionML = ENU = 'Options', ESP = 'Options';

                }

            }
        }
    }
    labels
    {
    }

    var
        //       Headerfilter@7001117 :
        Headerfilter: Text[250];
        //       AllocationTerm@7001116 :
        AllocationTerm: Record 7207297;
        //       QuantityHoursRecorded@7001115 :
        QuantityHoursRecorded: Decimal;
        //       AllocationTermDays@7001114 :
        AllocationTermDays: Record 7207295;
        //       Hourstoperform@7001113 :
        Hourstoperform: Record 7207298;
        //       Amounttorecord@7001112 :
        Amounttorecord: Decimal;
        //       WorksheetHeader@7001111 :
        WorksheetHeader: Record 7207290;
        //       WorkSheetLines@7001110 :
        WorkSheetLines: Record 7207291;
        //       PostWorksheet@7001109 :
        PostWorksheet: Codeunit 7207270;
        //       Window@7001108 :
        Window: Dialog;
        //       Reads@7001107 :
        Reads: Integer;
        //       total@7001106 :
        total: Integer;
        //       Record@7001105 :
        Record: Boolean;
        //       JobLedgerEntry@7001104 :
        JobLedgerEntry: Record 169;
        //       Quantity@7001103 :
        Quantity: Decimal;
        //       CounterOK@7001102 :
        CounterOK: Integer;
        //       CounterTotal@7001101 :
        CounterTotal: Integer;
        //       Hours@7001100 :
        Hours: Integer;
        //       Text000@7001122 :
        Text000: TextConst ENU = 'The resource %1 for the period %2 has all the hours completed', ESP = 'El recurso %1 para el periodo %2 tiene todas las horas completas';
        //       Text002@7001121 :
        Text002: TextConst ENU = 'Have been registered %1 part/s of %2.', ESP = 'Se han registrado %1 parte/s de %2.';
        //       Text003@7001120 :
        Text003: TextConst ENU = 'Number parts        #1######', ESP = 'N§ partes           #1######';
        //       Text004@7001119 :
        Text004: TextConst ENU = 'Checking hours   #2######\', ESP = 'Comprobando horas   #2######\';
        //       Text005@7001118 :
        Text005: TextConst ENU = 'generating parts of work   \', ESP = 'generando partes de trabajo  \';
        //       Text006@7001123 :
        Text006: TextConst ENU = 'Part ', ESP = 'Parte ';
        //       Text007@7001124 :
        Text007: TextConst ENU = ' Period ', ESP = ' Periodo ';



    trigger OnPostReport();
    begin
        if Record then begin
            COMMIT;
            WorksheetHeader.MARKEDONLY(TRUE);
            if WorksheetHeader.FIND('-') then begin
                repeat
                    CLEAR(PostWorksheet);
                    if PostWorksheet.RUN(WorksheetHeader) then begin
                        CounterOK := CounterOK + 1;
                        if WorksheetHeader.MARKEDONLY then
                            WorksheetHeader.MARK(FALSE);
                    end;
                until WorksheetHeader.NEXT = 0;
            end;
            MESSAGE(Text002, CounterOK, CounterTotal);
        end;
    end;



    procedure CreatePart()
    begin
        WorksheetHeader.INIT;
        WorkSheetLines.RESET;
        if Amounttorecord > 0 then begin
            Reads := Reads + 1;
            Window.UPDATE(1, Reads);
            WorksheetHeader."No." := '';
            WorksheetHeader.INSERT(TRUE);
            WorksheetHeader.VALIDATE("Sheet Type", WorksheetHeader."Sheet Type"::"By Resource");
            WorksheetHeader.VALIDATE("No. Resource /Job", Resource."No.");
            WorksheetHeader."Sheet Date" := "Allocation Term"."Final Date";
            WorksheetHeader."Allocation Term" := "Allocation Term".Code;
            WorksheetHeader."Posting Date" := TODAY;
            WorksheetHeader."Posting Description" := Text006 + Resource."No." + Text007 + "Allocation Term".Code;
            WorksheetHeader.MODIFY;
            WorksheetHeader.MARK(TRUE);

            WorkSheetLines.VALIDATE("Document No.", WorksheetHeader."No.");
            WorkSheetLines.VALIDATE("Line No.", 10000);
            WorkSheetLines.VALIDATE("Job No.", Resource."Jobs not Assigned");
            WorkSheetLines.VALIDATE("Resource No.", Resource."No.");
            WorkSheetLines.INSERT(TRUE);
            WorkSheetLines.VALIDATE("Work Day Date", "Allocation Term"."Final Date");
            WorkSheetLines.VALIDATE("Work Type Code", Resource."Cod. Type Jobs not Assigned");
            WorkSheetLines.Quantity := Amounttorecord;
            WorkSheetLines.CostAndSaleTotal;
            WorkSheetLines.Invoiced := TRUE;
            WorkSheetLines.MODIFY;
            CounterTotal := CounterTotal + 1;
        end;
    end;

    /*begin
    end.
  */

}



// RequestFilterFields="No.";
