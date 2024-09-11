Codeunit 7207270 "Post Worksheet"
{


    TableNo = 7207290;
    Permissions = TableData 454 = rimd,
                TableData 7207290 = m,
                TableData 7207291 = m,
                TableData 7207292 = imd,
                TableData 7207293 = imd;
    trigger OnRun()
    VAR
        Job: Record 167;
        LinComDoc: Record 7207270;
        SourceCodeSetup: Record 242;
    BEGIN
        IF opcPostingDateExists AND (opcReplacePostingDate OR (rec."Posting Date" = 0D)) THEN
            rec.VALIDATE(rec."Posting Date", opcPostingDate);
        CLEARALL;
        WorksheetHeader.COPY(Rec);

        //Comprobamos los campos obligatorios
        WITH WorksheetHeader DO BEGIN
            IF (WorksheetHeader."Sheet Type" <> WorksheetHeader."Sheet Type"::Mix) THEN
                TESTFIELD("No. Resource /Job");
            TESTFIELD("Posting Date");
            TESTFIELD("Sheet Date");
        END;

        //Comprobamos los campos que deben de ser obligatorios al registrar el documento.
        CASE rec."Sheet Type" OF
            rec."Sheet Type"::"By Resource":
                BEGIN
                    Resource.GET(rec."No. Resource /Job");
                    Resource.TESTFIELD(Blocked, FALSE);
                    IF NOT WorksheetHeader."Shop Depreciate Sheet" THEN
                        IF (MandatoryJob) THEN
                            Resource.TESTFIELD("Jobs Deviation");
                END;
            rec."Sheet Type"::"By Job":
                BEGIN
                    Job.GET(rec."No. Resource /Job");
                    Job.TESTFIELD(Blocked, Job.Blocked::" ");
                END;
        END;

        CheckDim;

        Window.OPEN(
          Text001 +
          Text002 +
          Text003 +
          Text004 +
          Text005 +
          Text006);

        Window.UPDATE(1, STRSUBSTNO('%1', rec."No."));

        //Comprobamos que el n� de serie de registro este relleno
        rec.TESTFIELD(rec."Posting No. Series");

        //Tomamos el c�d. de origen.
        SourceCodeSetup.GET;
        SrcCode := SourceCodeSetup.WorkSheet;

        CreatehistHeader;

        // Lineas
        WorkSheetLines.RESET;
        WorkSheetLines.SETRANGE("Document No.", rec."No.");
        LineCount := 0;
        IF WorkSheetLines.FINDSET(FALSE) THEN BEGIN
            REPEAT
                LineCount := LineCount + 1;
                Window.UPDATE(2, LineCount);
                Resource.GET(WorkSheetLines."Resource No.");
                Job.GET(WorkSheetLines."Job No.");

                InsertHist;
                IF (WorkSheetLines."Work Type Code" <> '') OR (WorkSheetLines.Quantity <> 0) THEN BEGIN
                    CtrlLines;
                    CreateJobMov;
                    CrearteGLEntry;
                    GenerateTransf;
                    AddToPiecework(WorkSheetLines."Job No.", WorkSheetLines."Piecework No.", WorkSheetLines.Quantity);
                END;
            UNTIL WorkSheetLines.NEXT = 0;
        END ELSE BEGIN
            ERROR(Text000);
        END;

        rec.DELETE;
        WorkSheetLines.DELETEALL;

        COMMIT;

        Window.CLOSE;

        UpdateAnalysisView.UpdateAll(0, TRUE);
        Rec := WorksheetHeader;
    END;

    VAR
        WorksheetHeader: Record 7207290;
        WorkSheetLines: Record 7207291;
        WorksheetHeaderHist: Record 7207292;
        WorksheetLinesHist: Record 7207293;
        Resource: Record 156;
        Text001: TextConst ENU = 'Posting lines              #2######\', ESP = '#1#################################\\';
        Text002: TextConst ENU = 'Posting lines              #2######\', ESP = 'Registrando l�neas         #2######\';
        Text003: TextConst ENU = 'Posting to vendors         #4######\', ESP = 'Registrando Proyecto       #3######\';
        Text004: TextConst ESP = 'Registrando Recurso        #4######\';
        Text005: TextConst ESP = 'Registrando Contabilidad   #5######\';
        Text006: TextConst ENU = 'Creating documents         #6######', ESP = 'Creando documentos         #6######';
        Text010: TextConst ENU = '%1 %2 -> Invoice %3', ESP = '%1 -> Documento %2';
        Text032: TextConst ENU = 'The combination of dimensions used in %1 %2 is blocked.', ESP = 'La combinaci�n de dimensiones utilizadas en el documento %1 est� bloqueada.';
        Text033: TextConst ENU = 'The combination of dimensions used in %1 %2, line no. %3 is blocked.', ESP = 'La combinaci�n de dimensiones utilizadas en el documento %1  n� l�nea %3 est� bloqueada.';
        Text034: TextConst ENU = 'The dimensions used in %1 %2 are invalid.', ESP = 'Las dimensiones usadas en %1 %2 son inv�lidas';
        Text035: TextConst ENU = 'The dimensions used in %1 %2, line no. %3 are invalid.', ESP = 'Las dim. usadas en %1 %2, no. l�n. %3 son inv�lidas';
        ResourceCost: Record 202;
        Text000: TextConst ENU = 'There is nothing to post.', ESP = 'No hay nada que registrar.';
        NoSeriesMgt: Codeunit 396;
        DimMgt: Codeunit 408;
        FunctionQB: Codeunit 7207272;
        cduPostJournal: Codeunit 1012;
        GenJnlPostLine: Codeunit 12;
        UpdateAnalysisView: Codeunit 410;
        Window: Dialog;
        GLSetupRead: Boolean;
        boolTransf: Boolean;
        SrcCode: Code[10];
        GenJnlLineDocNo: Code[20];
        LineCount: Integer;
        intCountJob: Integer;
        IntCountGLAccount: Integer;
        "---------------------------- Opciones para registro batch": Integer;
        opcPostingDateExists: Boolean;
        opcReplacePostingDate: Boolean;
        opcReplaceDocumentDate: Boolean;
        opcPostingDate: Date;

    LOCAL PROCEDURE "--------------------------------- Registro de partes internos"();
    BEGIN
    END;

    LOCAL PROCEDURE CheckDim();
    VAR
        WorkSheetLines2: Record 7207291;
    BEGIN
        WorkSheetLines2."Line No." := 0;
        CheckDimValuePosting(WorkSheetLines2);
        CheckDimComb(WorkSheetLines2);

        WorkSheetLines2.SETRANGE("Document No.", WorksheetHeader."No.");
        IF WorkSheetLines2.FINDSET THEN
            REPEAT
                CheckDimComb(WorkSheetLines2);
                CheckDimValuePosting(WorkSheetLines2);
            UNTIL WorkSheetLines2.NEXT = 0;
    END;

    LOCAL PROCEDURE CheckDimComb(parWorksheetLines: Record 7207291);
    BEGIN
        IF parWorksheetLines."Line No." = 0 THEN BEGIN
            IF NOT DimMgt.CheckDimIDComb(WorksheetHeader."Dimension Set ID") THEN
                ERROR(Text032, WorksheetHeader."No.", DimMgt.GetDimCombErr);
        END ELSE BEGIN
            IF NOT DimMgt.CheckDimIDComb(parWorksheetLines."Dimension Set ID") THEN
                ERROR(Text033, WorksheetHeader."No.", parWorksheetLines."Line No.", DimMgt.GetDimCombErr);
        END;
    END;

    LOCAL PROCEDURE CheckDimValuePosting(VAR parWorksheetLines: Record 7207291);
    VAR
        TableIDArr: ARRAY[10] OF Integer;
        NumberArr: ARRAY[10] OF Code[20];
    BEGIN
        IF parWorksheetLines."Line No." = 0 THEN BEGIN
            IF WorksheetHeader."Sheet Type" = WorksheetHeader."Sheet Type"::"By Resource" THEN BEGIN
                TableIDArr[1] := DATABASE::Resource;
                NumberArr[1] := WorksheetHeader."No. Resource /Job";
            END ELSE BEGIN
                TableIDArr[1] := DATABASE::Job;
                NumberArr[1] := WorksheetHeader."No. Resource /Job";
            END;
            IF NOT DimMgt.CheckDimValuePosting(TableIDArr, NumberArr, WorksheetHeader."Dimension Set ID") THEN
                ERROR(
                  Text034,
                  WorksheetHeader."No.", DimMgt.GetDimValuePostingErr);
        END ELSE BEGIN
            TableIDArr[1] := DATABASE::Job;
            NumberArr[1] := parWorksheetLines."Job No.";
            TableIDArr[2] := DATABASE::Resource;
            NumberArr[2] := parWorksheetLines."Resource No.";

            IF NOT DimMgt.CheckDimValuePosting(TableIDArr, NumberArr, parWorksheetLines."Dimension Set ID") THEN
                ERROR(
                  Text035,
                  WorksheetHeader."No.", parWorksheetLines."Line No.", DimMgt.GetDimValuePostingErr);
        END;
    END;

    LOCAL PROCEDURE CtrlLines();
    VAR
        locTransfer: Record 7207299;
    BEGIN
        //Busco el espec�fico del recurso, sino lo encuentro busco el de la familia
        IF NOT ResourceCost.GET(ResourceCost.Type::Resource, WorkSheetLines."Resource No.", WorkSheetLines."Work Type Code") THEN BEGIN
            ResourceCost.GET(ResourceCost.Type::"Group(Resource)", Resource."Resource Group No.", WorkSheetLines."Work Type Code");
        END;

        CtrlLinesCheck(ResourceCost.FIELDNO("Acc. Direct Cost Allocation"));
        CtrlLinesCheck(ResourceCost.FIELDNO("Acc. Direct Cost Appl. Account"));

        //si no hay imputaci�n por indirectos no se deben poner los datos de costes indirectos
        IF WorkSheetLines."Direct Cost Price" <> WorkSheetLines."Cost Price" THEN BEGIN
            CtrlLinesCheck(ResourceCost.FIELDNO("C.A. Indirect Cost Allocation"));
            CtrlLinesCheck(ResourceCost.FIELDNO("Acc. Indirect Cost Allocation"));
            CtrlLinesCheck(ResourceCost.FIELDNO("C.A. Ind. Cost Appl. Account"));
            CtrlLinesCheck(ResourceCost.FIELDNO("Acc. Ind. Cost Appl. Account"));
        END;

        WorkSheetLines.TESTFIELD("Direct Cost Price");
        WorkSheetLines.TESTFIELD("Cost Price");
        WorkSheetLines.TESTFIELD("Work Day Date");
        WorkSheetLines.TESTFIELD(Quantity);

        boolTransf := (FunctionQB.GetDepartment(DATABASE::Job, WorkSheetLines."Job No.") <>
                       FunctionQB.GetDepartment(DATABASE::Resource, WorkSheetLines."Resource No."));

        // Chequeo adicional de que exista precio de cesion
        IF boolTransf THEN
            boolTransf := locTransfer.GET(locTransfer.Type::Resource, WorkSheetLines."Resource No.",
                                          FunctionQB.GetDepartment(DATABASE::Job, WorkSheetLines."Job No."), WorkSheetLines."Work Type Code");
    END;

    LOCAL PROCEDURE CreateJobMov();
    VAR
        locResourceCost: Record 202;
        currency: Record 4;
        JobJournalLine: Record 210;
        rJob: Record 167;
    BEGIN
        currency.InitRoundingPrecision;

        intCountJob += 1;
        Window.UPDATE(3, intCountJob);

        Resource.GET(WorkSheetLines."Resource No.");

        //Crear la l�nea en el proyecto
        JobJournalLine.INIT;
        JobJournalLine.VALIDATE("Job No.", WorkSheetLines."Job No.");
        JobJournalLine.VALIDATE("Job Task No.", WorkSheetLines."Job Task No.");
        JobJournalLine."Posting Date" := WorksheetHeader."Posting Date";
        JobJournalLine."Document No." := GenJnlLineDocNo;
        JobJournalLine.Type := JobJournalLine.Type::Resource;
        JobJournalLine."No." := WorkSheetLines."Resource No.";
        JobJournalLine.Description := WorkSheetLines.Description;
        JobJournalLine.Quantity := WorkSheetLines.Quantity;
        JobJournalLine."Qty. per Unit of Measure" := 1;
        JobJournalLine."Quantity (Base)" := JobJournalLine.Quantity;
        //JMMA 041220 DIVISA
        rJob.GET(WorkSheetLines."Job No.");
        JobJournalLine.VALIDATE("Currency Code", rJob."Currency Code");

        JobJournalLine."Direct Unit Cost (LCY)" := WorkSheetLines."Direct Cost Price";
        JobJournalLine."Unit Cost (LCY)" := WorkSheetLines."Direct Cost Price";
        JobJournalLine."Total Cost (LCY)" := ROUND(WorkSheetLines."Direct Cost Price" * WorkSheetLines.Quantity, 0.01);
        JobJournalLine."Unit Price (LCY)" := WorkSheetLines."Sales Price";
        JobJournalLine."Total Price (LCY)" := WorkSheetLines."Sale Amount";
        JobJournalLine.Chargeable := WorkSheetLines.Invoiced;
        JobJournalLine."Post Job Entry Only" := TRUE;
        JobJournalLine."Job Deviation Entry" := FALSE;
        JobJournalLine."Compute for hours" := WorkSheetLines."Compute In Hours";
        JobJournalLine."Piecework Code" := WorkSheetLines."Piecework No.";
        JobJournalLine."Unit of Measure Code" := Resource."Base Unit of Measure";
        JobJournalLine."Work Type Code" := WorkSheetLines."Work Type Code";
        JobJournalLine."Entry Type" := JobJournalLine."Entry Type"::Usage;
        JobJournalLine."Source Code" := SrcCode;
        JobJournalLine."Document Date" := WorksheetHeader."Posting Date";
        JobJournalLine."External Document No." := GenJnlLineDocNo;
        JobJournalLine."Posting No. Series" := WorksheetHeader."Posting No. Series";
        JobJournalLine."Gen. Prod. Posting Group" := Resource."Gen. Prod. Posting Group";
        JobJournalLine."Source Currency Total Price" := ROUND(JobJournalLine."Total Price (LCY)", currency."Amount Rounding Precision");
        JobJournalLine."Plant Depreciation Sheet" := WorksheetHeader."Shop Depreciate Sheet";
        JobJournalLine."Job Posting Only" := TRUE;
        JobJournalLine."Shortcut Dimension 1 Code" := WorkSheetLines."Shortcut Dimension 1 Code";
        JobJournalLine."Shortcut Dimension 2 Code" := WorkSheetLines."Shortcut Dimension 2 Code";
        JobJournalLine."Dimension Set ID" := WorkSheetLines."Dimension Set ID";

        JobJournalLine.VALIDATE("Unit Cost (LCY)");
        JobJournalLine.VALIDATE("Direct Unit Cost (LCY)");
        JobJournalLine.VALIDATE("Unit Cost");
        JobJournalLine.VALIDATE("Total Cost");
        //JMMA 041220 a�adir tipo documento
        JobJournalLine."Source Document Type" := JobJournalLine."Source Document Type"::Worksheet;

        cduPostJournal.RunWithCheck(JobJournalLine);

        intCountJob += 1;
        Window.UPDATE(3, intCountJob);

        //Crear la l�nea en el proyecto de estructura
        JobJournalLine.INIT;
        IF WorksheetHeader."Shop Depreciate Sheet" THEN BEGIN
            JobJournalLine.VALIDATE("Job No.", WorkSheetLines."Job No.");
            JobJournalLine."Job Task No." := WorkSheetLines."Job Task No.";
        END ELSE BEGIN
            IF (MandatoryJob) THEN
                Resource.TESTFIELD("Jobs Deviation");
            JobJournalLine.VALIDATE("Job No.", Resource."Jobs Deviation");
            JobJournalLine."Job Task No." := '';
        END;
        IF JobJournalLine."Job No." <> '' THEN BEGIN
            JobJournalLine."Posting Date" := WorksheetHeader."Posting Date";
            JobJournalLine."Document No." := GenJnlLineDocNo;
            JobJournalLine.Type := JobJournalLine.Type::Resource;
            JobJournalLine."No." := WorkSheetLines."Resource No.";
            JobJournalLine.Quantity := -WorkSheetLines.Quantity;
            JobJournalLine."Qty. per Unit of Measure" := 1;
            JobJournalLine."Quantity (Base)" := JobJournalLine.Quantity;
            IF NOT boolTransf THEN BEGIN
                JobJournalLine."Direct Unit Cost (LCY)" := WorkSheetLines."Direct Cost Price";
                JobJournalLine."Unit Cost (LCY)" := WorkSheetLines."Direct Cost Price";
                JobJournalLine."Total Cost (LCY)" := -ROUND(WorkSheetLines."Direct Cost Price" * WorkSheetLines.Quantity, 0.01);
            END ELSE BEGIN
                locResourceCost.INIT;
                GetUnitCost(locResourceCost, WorkSheetLines."Resource No.", WorkSheetLines."Work Type Code", WorkSheetLines."Direct Cost Price", WorkSheetLines."Cost Price");
                JobJournalLine."Direct Unit Cost (LCY)" := locResourceCost."Direct Unit Cost";
                JobJournalLine."Unit Cost (LCY)" := locResourceCost."Direct Unit Cost";
                JobJournalLine."Total Cost (LCY)" := -ROUND(WorkSheetLines.Quantity * locResourceCost."Direct Unit Cost", 0.01);
            END;
            JobJournalLine."Unit Price (LCY)" := WorkSheetLines."Sales Price";
            JobJournalLine."Total Price (LCY)" := -WorkSheetLines."Sale Amount";
            JobJournalLine.Chargeable := WorkSheetLines.Invoiced;
            JobJournalLine."Post Job Entry Only" := TRUE;
            JobJournalLine."Job Deviation Entry" := TRUE;
            JobJournalLine."Compute for hours" := WorkSheetLines."Compute In Hours";
            IF WorksheetHeader."Shop Depreciate Sheet" THEN BEGIN
                JobJournalLine."Piecework Code" := WorksheetHeader."Shop Cost Unit Code"
            END ELSE BEGIN
                JobJournalLine."Piecework Code" := WorkSheetLines."Piecework No."
            END;

            JobJournalLine."Unit of Measure Code" := Resource."Base Unit of Measure";
            JobJournalLine."Dimension Set ID" := WorkSheetLines."Dimension Set ID";
            JobJournalLine."Work Type Code" := WorkSheetLines."Work Type Code";
            JobJournalLine."Entry Type" := JobJournalLine."Entry Type"::Usage;
            JobJournalLine."Source Code" := SrcCode;
            JobJournalLine."Document Date" := WorksheetHeader."Posting Date";
            JobJournalLine."External Document No." := GenJnlLineDocNo;
            JobJournalLine."Posting No. Series" := WorksheetHeader."Posting No. Series";
            JobJournalLine."Gen. Prod. Posting Group" := Resource."Gen. Prod. Posting Group";
            JobJournalLine."Source Currency Total Price" := ROUND(JobJournalLine."Total Price (LCY)", currency."Amount Rounding Precision");
            JobJournalLine."Plant Depreciation Sheet" := WorksheetHeader."Shop Depreciate Sheet";
            JobJournalLine."Job Posting Only" := TRUE;

            IF WorksheetHeader."Shop Depreciate Sheet" THEN BEGIN
                FunctionQB.UpdateDimSet(FunctionQB.ReturnDimJobs, WorkSheetLines."Job No.", JobJournalLine."Dimension Set ID");
                FunctionQB.UpdateDimSet(FunctionQB.ReturnDimDpto, FunctionQB.GetDepartment(DATABASE::Job, WorkSheetLines."Job No."), JobJournalLine."Dimension Set ID");
            END ELSE BEGIN
                FunctionQB.UpdateDimSet(FunctionQB.ReturnDimJobs, Resource."Jobs Deviation", JobJournalLine."Dimension Set ID");
                FunctionQB.UpdateDimSet(FunctionQB.ReturnDimDpto, FunctionQB.GetDepartment(DATABASE::Job, Resource."Jobs Deviation"), JobJournalLine."Dimension Set ID");
            END;

            FunctionQB.UpdateDimSet(FunctionQB.ReturnDimCA, ResourceCost."C.A. Direct Cost Appl. Account", JobJournalLine."Dimension Set ID");
            DimMgt.UpdateGlobalDimFromDimSetID(JobJournalLine."Dimension Set ID", JobJournalLine."Shortcut Dimension 1 Code", JobJournalLine."Shortcut Dimension 2 Code");

            JobJournalLine.VALIDATE("Unit Cost (LCY)");
            JobJournalLine.VALIDATE("Direct Unit Cost (LCY)");
            JobJournalLine.VALIDATE("Unit Cost");
            JobJournalLine.VALIDATE("Total Cost");
            //JMMA 041220 a�adir tipo documento
            JobJournalLine."Source Document Type" := JobJournalLine."Source Document Type"::Worksheet;

            cduPostJournal.RunWithCheck(JobJournalLine);
        END;

        IF (WorkSheetLines."Cost Price" - WorkSheetLines."Direct Cost Price") <> 0 THEN BEGIN
            intCountJob += 1;
            Window.UPDATE(3, intCountJob);

            JobJournalLine.INIT;
            JobJournalLine.VALIDATE("Job No.", WorkSheetLines."Job No.");
            JobJournalLine.VALIDATE("Job Task No.", WorkSheetLines."Job Task No.");
            JobJournalLine."Posting Date" := WorksheetHeader."Posting Date";
            JobJournalLine."Document No." := GenJnlLineDocNo;
            JobJournalLine.Type := JobJournalLine.Type::Resource;
            JobJournalLine."No." := WorkSheetLines."Resource No.";
            JobJournalLine.Description := WorkSheetLines.Description;
            JobJournalLine.Quantity := WorkSheetLines.Quantity;
            JobJournalLine."Qty. per Unit of Measure" := 1;
            JobJournalLine."Quantity (Base)" := JobJournalLine.Quantity;
            //JMMA 041220 DIVISAS
            rJob.GET(WorkSheetLines."Job No.");
            JobJournalLine.VALIDATE("Currency Code", rJob."Currency Code");

            JobJournalLine."Direct Unit Cost (LCY)" := WorkSheetLines."Cost Price" - WorkSheetLines."Direct Cost Price";
            JobJournalLine."Unit Cost (LCY)" := WorkSheetLines."Cost Price" - WorkSheetLines."Direct Cost Price";
            JobJournalLine."Total Cost (LCY)" := ROUND((WorkSheetLines."Cost Price" - WorkSheetLines."Direct Cost Price") * WorkSheetLines.Quantity, 0.01);
            JobJournalLine."Unit Price (LCY)" := 0;
            JobJournalLine."Total Price (LCY)" := 0;
            JobJournalLine.Chargeable := WorkSheetLines.Invoiced;
            JobJournalLine."Post Job Entry Only" := TRUE;
            JobJournalLine."Job Deviation Entry" := FALSE;
            JobJournalLine."Compute for hours" := FALSE;
            JobJournalLine."Piecework Code" := WorkSheetLines."Piecework No.";
            JobJournalLine."Unit of Measure Code" := Resource."Base Unit of Measure";
            JobJournalLine."Work Type Code" := WorkSheetLines."Work Type Code";
            JobJournalLine."Entry Type" := JobJournalLine."Entry Type"::Usage;
            JobJournalLine."Source Code" := SrcCode;
            JobJournalLine."Document Date" := WorksheetHeader."Posting Date";
            JobJournalLine."External Document No." := GenJnlLineDocNo;
            JobJournalLine."Posting No. Series" := WorksheetHeader."Posting No. Series";
            JobJournalLine."Gen. Prod. Posting Group" := Resource."Gen. Prod. Posting Group";
            JobJournalLine."Source Currency Total Price" := ROUND(JobJournalLine."Total Price (LCY)", currency."Amount Rounding Precision");
            JobJournalLine."Plant Depreciation Sheet" := WorksheetHeader."Shop Depreciate Sheet";
            JobJournalLine."Job Posting Only" := TRUE;

            JobJournalLine."Dimension Set ID" := WorkSheetLines."Dimension Set ID";
            FunctionQB.UpdateDimSet(FunctionQB.ReturnDimCA, ResourceCost."C.A. Indirect Cost Allocation", JobJournalLine."Dimension Set ID");
            DimMgt.UpdateGlobalDimFromDimSetID(JobJournalLine."Dimension Set ID", JobJournalLine."Shortcut Dimension 1 Code", JobJournalLine."Shortcut Dimension 2 Code");

            JobJournalLine.VALIDATE("Unit Cost (LCY)");
            JobJournalLine.VALIDATE("Direct Unit Cost (LCY)");
            JobJournalLine.VALIDATE("Unit Cost");
            JobJournalLine.VALIDATE("Total Cost");
            //JMMA 041220 a�adir tipo documento
            JobJournalLine."Source Document Type" := JobJournalLine."Source Document Type"::Worksheet;

            cduPostJournal.RunWithCheck(JobJournalLine);

            intCountJob += 1;
            Window.UPDATE(3, intCountJob);

            JobJournalLine.INIT;

            IF WorksheetHeader."Shop Depreciate Sheet" THEN BEGIN
                JobJournalLine.VALIDATE("Job No.", WorkSheetLines."Job No.");
                JobJournalLine."Job Task No." := WorkSheetLines."Job Task No.";
            END ELSE BEGIN
                IF (MandatoryJob) THEN
                    Resource.TESTFIELD("Jobs Deviation");
                JobJournalLine.VALIDATE("Job No.", Resource."Jobs Deviation");
                JobJournalLine."Job Task No." := '';
            END;
            IF JobJournalLine."Job No." <> '' THEN BEGIN
                JobJournalLine."Posting Date" := WorksheetHeader."Posting Date";
                JobJournalLine."Document No." := GenJnlLineDocNo;
                JobJournalLine.Type := JobJournalLine.Type::Resource;
                JobJournalLine."No." := WorkSheetLines."Resource No.";
                JobJournalLine.Quantity := -WorkSheetLines.Quantity;
                JobJournalLine."Qty. per Unit of Measure" := 1;
                JobJournalLine."Quantity (Base)" := JobJournalLine.Quantity;
                //JMMA 041220 DIVISAS
                rJob.GET(JobJournalLine."Job No.");
                JobJournalLine.VALIDATE("Currency Code", rJob."Currency Code");

                IF NOT boolTransf THEN BEGIN
                    JobJournalLine."Direct Unit Cost (LCY)" := WorkSheetLines."Cost Price" - WorkSheetLines."Direct Cost Price";
                    JobJournalLine."Unit Cost (LCY)" := WorkSheetLines."Cost Price" - WorkSheetLines."Direct Cost Price";
                    JobJournalLine."Total Cost (LCY)" := -ROUND((WorkSheetLines."Cost Price" - WorkSheetLines."Direct Cost Price")
                                                          * WorkSheetLines.Quantity, 0.01);
                END ELSE BEGIN
                    locResourceCost.INIT;
                    GetUnitCost(locResourceCost, WorkSheetLines."Resource No.", WorkSheetLines."Work Type Code", WorkSheetLines."Direct Cost Price", WorkSheetLines."Cost Price");
                    JobJournalLine."Direct Unit Cost (LCY)" := (locResourceCost."Unit Cost" - locResourceCost."Direct Unit Cost");
                    JobJournalLine."Unit Cost (LCY)" := (locResourceCost."Unit Cost" - locResourceCost."Direct Unit Cost");
                    JobJournalLine."Total Cost (LCY)" := -ROUND(WorkSheetLines.Quantity *
                                                   (locResourceCost."Unit Cost" - locResourceCost."Direct Unit Cost"), 0.01);
                END;
                JobJournalLine."Unit Price (LCY)" := 0;
                JobJournalLine."Total Price (LCY)" := 0;
                JobJournalLine.Chargeable := WorkSheetLines.Invoiced;
                JobJournalLine."Post Job Entry Only" := TRUE;
                JobJournalLine."Job Deviation Entry" := TRUE;
                JobJournalLine."Compute for hours" := FALSE;
                IF WorksheetHeader."Shop Depreciate Sheet" THEN BEGIN
                    JobJournalLine."Piecework Code" := WorksheetHeader."Shop Cost Unit Code";
                END ELSE BEGIN
                    JobJournalLine."Piecework Code" := WorkSheetLines."Piecework No.";
                END;
                JobJournalLine."Unit of Measure Code" := Resource."Base Unit of Measure";
                JobJournalLine."Work Type Code" := WorkSheetLines."Work Type Code";
                JobJournalLine."Entry Type" := JobJournalLine."Entry Type"::Usage;
                JobJournalLine."Source Code" := SrcCode;
                JobJournalLine."Document Date" := WorksheetHeader."Posting Date";
                JobJournalLine."External Document No." := GenJnlLineDocNo;
                JobJournalLine."Posting No. Series" := WorksheetHeader."Posting No. Series";
                JobJournalLine."Gen. Prod. Posting Group" := Resource."Gen. Prod. Posting Group";
                JobJournalLine."Source Currency Total Price" := ROUND(JobJournalLine."Total Price (LCY)", currency."Amount Rounding Precision");
                JobJournalLine."Plant Depreciation Sheet" := WorksheetHeader."Shop Depreciate Sheet";
                JobJournalLine."Job Posting Only" := TRUE;

                JobJournalLine."Dimension Set ID" := WorkSheetLines."Dimension Set ID";
                IF WorksheetHeader."Shop Depreciate Sheet" THEN BEGIN
                    FunctionQB.UpdateDimSet(FunctionQB.ReturnDimJobs, WorkSheetLines."Job No.", JobJournalLine."Dimension Set ID");
                    FunctionQB.UpdateDimSet(FunctionQB.ReturnDimDpto, FunctionQB.GetDepartment(DATABASE::Job, WorkSheetLines."Job No."), JobJournalLine."Dimension Set ID");
                END ELSE BEGIN
                    FunctionQB.UpdateDimSet(FunctionQB.ReturnDimJobs, Resource."Jobs Deviation", JobJournalLine."Dimension Set ID");
                    FunctionQB.UpdateDimSet(FunctionQB.ReturnDimDpto, FunctionQB.GetDepartment(DATABASE::Job, Resource."Jobs Deviation"), JobJournalLine."Dimension Set ID");
                END;
                FunctionQB.UpdateDimSet(FunctionQB.ReturnDimCA, ResourceCost."C.A. Ind. Cost Appl. Account", JobJournalLine."Dimension Set ID");
                DimMgt.UpdateGlobalDimFromDimSetID(JobJournalLine."Dimension Set ID", JobJournalLine."Shortcut Dimension 1 Code", JobJournalLine."Shortcut Dimension 2 Code");

                JobJournalLine.VALIDATE("Unit Cost (LCY)");
                JobJournalLine.VALIDATE("Direct Unit Cost (LCY)");
                JobJournalLine.VALIDATE("Unit Cost");
                JobJournalLine.VALIDATE("Total Cost");
                //JMMA 041220 a�adir tipo documento
                JobJournalLine."Source Document Type" := JobJournalLine."Source Document Type"::Worksheet;

                cduPostJournal.RunWithCheck(JobJournalLine);
            END;
        END;
    END;

    LOCAL PROCEDURE CrearteGLEntry();
    VAR
        GenJnlLine: Record 81;
        recCostRes: Record 202;
        recGLAccount: Record 15;
        Job: Record 167;
        DimDep: Code[20];
    BEGIN
        IntCountGLAccount += 1;
        Window.UPDATE(5, IntCountGLAccount);

        //coste directo
        GenJnlLine.INIT;
        GenJnlLine."Posting Date" := WorksheetHeader."Posting Date";
        GenJnlLine."Document Date" := WorksheetHeader."Posting Date";
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
        GenJnlLine."Account No." := ResourceCost."Acc. Direct Cost Allocation";

        recGLAccount.GET(ResourceCost."Acc. Direct Cost Allocation");
        GenJnlLine.Description := recGLAccount.Name;

        GenJnlLine."Shortcut Dimension 1 Code" := WorkSheetLines."Shortcut Dimension 1 Code";
        GenJnlLine."Shortcut Dimension 2 Code" := WorkSheetLines."Shortcut Dimension 2 Code";
        GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
        GenJnlLine."Document No." := GenJnlLineDocNo;
        GenJnlLine."External Document No." := GenJnlLineDocNo;
        GenJnlLine.Amount := ROUND(WorkSheetLines."Direct Cost Price" * WorkSheetLines.Quantity, 0.01);
        GenJnlLine."Amount (LCY)" := ROUND(WorkSheetLines."Direct Cost Price" * WorkSheetLines.Quantity, 0.01);
        GenJnlLine."Sales/Purch. (LCY)" := ROUND(WorkSheetLines."Direct Cost Price" * WorkSheetLines.Quantity, 0.01);
        GenJnlLine."Currency Factor" := 1;
        GenJnlLine.Correction := FALSE;
        GenJnlLine."System-Created Entry" := TRUE;
        GenJnlLine."Source Type" := GenJnlLine."Source Type"::" ";
        GenJnlLine."Source No." := WorkSheetLines."Resource No.";
        GenJnlLine."Source Code" := SrcCode;
        GenJnlLine."Already Generated Job Entry" := TRUE;
        GenJnlLine."Usage/Sale" := GenJnlLine."Usage/Sale"::Usage;
        GenJnlLine."Job No." := WorkSheetLines."Job No.";
        GenJnlLine."Job Task No." := WorkSheetLines."Job Task No.";
        GenJnlLine."Piecework Code" := WorkSheetLines."Piecework No.";
        GenJnlLine."Dimension Set ID" := WorkSheetLines."Dimension Set ID";

        GenJnlPostLine.RunWithCheck(GenJnlLine);

        //Contrapartida de coste directo
        IntCountGLAccount += 1;
        Window.UPDATE(5, IntCountGLAccount);

        GenJnlLine.INIT;
        GenJnlLine."Posting Date" := WorksheetHeader."Posting Date";
        GenJnlLine."Document Date" := WorksheetHeader."Posting Date";
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
        GenJnlLine."Account No." := ResourceCost."Acc. Direct Cost Appl. Account";

        recGLAccount.GET(ResourceCost."Acc. Direct Cost Appl. Account");
        GenJnlLine.Description := recGLAccount.Name;
        GenJnlLine."Dimension Set ID" := WorkSheetLines."Dimension Set ID";

        FunctionQB.UpdateDimSet(FunctionQB.ReturnDimCA, ResourceCost."C.A. Direct Cost Appl. Account", GenJnlLine."Dimension Set ID");
        FunctionQB.UpdateDimSet(FunctionQB.ReturnDimDpto, FunctionQB.GetDepartment(DATABASE::Job, Resource."Jobs Deviation"), GenJnlLine."Dimension Set ID");
        DimMgt.UpdateGlobalDimFromDimSetID(GenJnlLine."Dimension Set ID", GenJnlLine."Shortcut Dimension 1 Code", GenJnlLine."Shortcut Dimension 2 Code");

        //JAV 23/11/21: - QB 1.10.00 Dar un error adecuado si no hay dimensi�n asociada
        CASE FunctionQB.GetPosDimensions(FunctionQB.ReturnDimDpto) OF
            1:
                DimDep := GenJnlLine."Shortcut Dimension 1 Code";
            2:
                DimDep := GenJnlLine."Shortcut Dimension 2 Code";
        END;
        IF (DimDep = '') THEN
            ERROR('No ha definido el proyecto de desviaci�n en el recurso %1, o dicho proyecto no tiene una dimensi�n departamento', WorkSheetLines."Resource No.");



        GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
        GenJnlLine."Document No." := GenJnlLineDocNo;
        GenJnlLine."External Document No." := GenJnlLineDocNo;
        GenJnlLine."Currency Factor" := 1;

        IF NOT boolTransf THEN BEGIN
            GenJnlLine.Amount := -ROUND(WorkSheetLines."Direct Cost Price" * WorkSheetLines.Quantity, 0.01);
            GenJnlLine."Amount (LCY)" := -ROUND(WorkSheetLines."Direct Cost Price" * WorkSheetLines.Quantity, 0.01);
            GenJnlLine."Sales/Purch. (LCY)" := -ROUND(WorkSheetLines."Direct Cost Price" * WorkSheetLines.Quantity, 0.01);
        END ELSE BEGIN
            recCostRes.INIT;
            GetUnitCost(recCostRes, WorkSheetLines."Resource No.", WorkSheetLines."Work Type Code", WorkSheetLines."Direct Cost Price", WorkSheetLines."Cost Price");
            GenJnlLine.Amount := -ROUND(WorkSheetLines.Quantity * recCostRes."Direct Unit Cost", 0.01);
            GenJnlLine."Amount (LCY)" := -ROUND(WorkSheetLines.Quantity * recCostRes."Direct Unit Cost", 0.01);
            GenJnlLine."Sales/Purch. (LCY)" := -ROUND(WorkSheetLines.Quantity * recCostRes."Direct Unit Cost", 0.01);
        END;

        GenJnlLine.Correction := FALSE;
        GenJnlLine."System-Created Entry" := TRUE;
        GenJnlLine."Source Type" := GenJnlLine."Source Type"::" ";
        GenJnlLine."Source No." := WorkSheetLines."Resource No.";
        GenJnlLine."Source Code" := SrcCode;
        GenJnlLine."Already Generated Job Entry" := TRUE;
        GenJnlLine."Usage/Sale" := GenJnlLine."Usage/Sale"::Usage;
        IF WorksheetHeader."Shop Depreciate Sheet" THEN BEGIN
            GenJnlLine."Job No." := WorkSheetLines."Job No.";
            GenJnlLine."Job Task No." := WorkSheetLines."Job Task No.";
            GenJnlLine."Piecework Code" := WorksheetHeader."Shop Cost Unit Code";
        END ELSE BEGIN
            GenJnlLine."Job No." := Resource."Jobs Deviation";
            GenJnlLine."Job Task No." := '';
            GenJnlLine."Piecework Code" := WorkSheetLines."Piecework No.";
        END;

        IF WorksheetHeader."Shop Depreciate Sheet" THEN BEGIN
            FunctionQB.UpdateDimSet(FunctionQB.ReturnDimJobs, WorkSheetLines."Job No.", GenJnlLine."Dimension Set ID");
            FunctionQB.UpdateDimSet(FunctionQB.ReturnDimDpto, FunctionQB.GetDepartment(DATABASE::Job, WorkSheetLines."Job No."), GenJnlLine."Dimension Set ID");
        END ELSE BEGIN
            FunctionQB.UpdateDimSet(FunctionQB.ReturnDimJobs, Resource."Jobs Deviation", GenJnlLine."Dimension Set ID");
            FunctionQB.UpdateDimSet(FunctionQB.ReturnDimDpto, FunctionQB.GetDepartment(DATABASE::Resource, Resource."No."), GenJnlLine."Dimension Set ID");
        END;

        FunctionQB.UpdateDimSet(FunctionQB.ReturnDimCA, ResourceCost."C.A. Direct Cost Appl. Account", GenJnlLine."Dimension Set ID");
        FunctionQB.UpdateDimSet(FunctionQB.ReturnDimDpto, FunctionQB.GetDepartment(DATABASE::Job, Resource."Jobs Deviation"), GenJnlLine."Dimension Set ID");
        DimMgt.UpdateGlobalDimFromDimSetID(GenJnlLine."Dimension Set ID", GenJnlLine."Shortcut Dimension 1 Code", GenJnlLine."Shortcut Dimension 2 Code");

        GenJnlPostLine.RunWithCheck(GenJnlLine);

        //costes indirecto
        IF (WorkSheetLines."Cost Price" - WorkSheetLines."Direct Cost Price") <> 0 THEN BEGIN
            //Partida de costes indirecto
            IntCountGLAccount += 1;
            Window.UPDATE(5, IntCountGLAccount);

            GenJnlLine.INIT;
            GenJnlLine."Posting Date" := WorksheetHeader."Posting Date";
            GenJnlLine."Document Date" := WorksheetHeader."Posting Date";
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
            GenJnlLine."Account No." := ResourceCost."Acc. Indirect Cost Allocation";

            recGLAccount.GET(ResourceCost."Acc. Indirect Cost Allocation");
            GenJnlLine.Description := recGLAccount.Name;
            GenJnlLine."Dimension Set ID" := WorkSheetLines."Dimension Set ID";

            FunctionQB.UpdateDimSet(FunctionQB.ReturnDimCA, ResourceCost."C.A. Indirect Cost Allocation", GenJnlLine."Dimension Set ID");
            DimMgt.UpdateGlobalDimFromDimSetID(GenJnlLine."Dimension Set ID", GenJnlLine."Shortcut Dimension 1 Code", GenJnlLine."Shortcut Dimension 2 Code");

            GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
            GenJnlLine."Document No." := GenJnlLineDocNo;
            GenJnlLine."External Document No." := GenJnlLineDocNo;
            GenJnlLine.Amount := ROUND((WorkSheetLines."Cost Price" - WorkSheetLines."Direct Cost Price") *
                                       WorkSheetLines.Quantity, 0.01);
            GenJnlLine."Amount (LCY)" := ROUND((WorkSheetLines."Cost Price" - WorkSheetLines."Direct Cost Price") *
                                       WorkSheetLines.Quantity, 0.01);
            GenJnlLine."Sales/Purch. (LCY)" := ROUND((WorkSheetLines."Cost Price" - WorkSheetLines."Direct Cost Price") *
                                       WorkSheetLines.Quantity, 0.01);
            GenJnlLine."Currency Factor" := 1;
            GenJnlLine.Correction := FALSE;
            GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine."Source Type" := GenJnlLine."Source Type"::" ";
            GenJnlLine."Source No." := WorkSheetLines."Resource No.";
            GenJnlLine."Source Code" := SrcCode;
            GenJnlLine."Already Generated Job Entry" := TRUE;
            GenJnlLine."Usage/Sale" := GenJnlLine."Usage/Sale"::Usage;
            GenJnlLine."Job No." := WorkSheetLines."Job No.";
            GenJnlLine."Job Task No." := WorkSheetLines."Job Task No.";
            GenJnlLine."Piecework Code" := WorkSheetLines."Piecework No.";


            FunctionQB.UpdateDimSet(FunctionQB.ReturnDimCA, ResourceCost."C.A. Indirect Cost Allocation", GenJnlLine."Dimension Set ID");
            DimMgt.UpdateGlobalDimFromDimSetID(GenJnlLine."Dimension Set ID", GenJnlLine."Shortcut Dimension 1 Code", GenJnlLine."Shortcut Dimension 2 Code");
            GenJnlPostLine.RunWithCheck(GenJnlLine);

            //Contrapartida de costes indirecto
            IntCountGLAccount += 1;
            Window.UPDATE(5, IntCountGLAccount);

            GenJnlLine.INIT;
            GenJnlLine."Posting Date" := WorksheetHeader."Posting Date";
            GenJnlLine."Document Date" := WorksheetHeader."Posting Date";
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
            GenJnlLine."Account No." := ResourceCost."Acc. Ind. Cost Appl. Account";

            recGLAccount.GET(ResourceCost."Acc. Ind. Cost Appl. Account");
            GenJnlLine.Description := recGLAccount.Name;
            GenJnlLine."Dimension Set ID" := WorkSheetLines."Dimension Set ID";

            FunctionQB.UpdateDimSet(FunctionQB.ReturnDimCA, ResourceCost."C.A. Ind. Cost Appl. Account", GenJnlLine."Dimension Set ID");
            FunctionQB.UpdateDimSet(FunctionQB.ReturnDimDpto, FunctionQB.GetDepartment(DATABASE::Resource, Resource."No."), GenJnlLine."Dimension Set ID");
            DimMgt.UpdateGlobalDimFromDimSetID(GenJnlLine."Dimension Set ID", GenJnlLine."Shortcut Dimension 1 Code", GenJnlLine."Shortcut Dimension 2 Code");

            GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
            GenJnlLine."Document No." := GenJnlLineDocNo;
            GenJnlLine."External Document No." := GenJnlLineDocNo;
            GenJnlLine."Currency Factor" := 1;

            IF NOT boolTransf THEN BEGIN
                GenJnlLine.Amount := -ROUND((WorkSheetLines."Cost Price" - WorkSheetLines."Direct Cost Price") *
                                         WorkSheetLines.Quantity, 0.01);
                GenJnlLine."Amount (LCY)" := -ROUND((WorkSheetLines."Cost Price" - WorkSheetLines."Direct Cost Price") *
                                         WorkSheetLines.Quantity, 0.01);
                GenJnlLine."Sales/Purch. (LCY)" := -ROUND((WorkSheetLines."Cost Price" - WorkSheetLines."Direct Cost Price") *
                                         WorkSheetLines.Quantity, 0.01);

            END ELSE BEGIN
                recCostRes.INIT;
                GetUnitCost(recCostRes, WorkSheetLines."Resource No.", WorkSheetLines."Work Type Code", WorkSheetLines."Direct Cost Price", WorkSheetLines."Cost Price");
                GenJnlLine.Amount := -ROUND(WorkSheetLines.Quantity * (recCostRes."Unit Cost" - recCostRes."Direct Unit Cost"), 0.01);
                GenJnlLine."Amount (LCY)" := -ROUND(WorkSheetLines.Quantity * (recCostRes."Unit Cost" - recCostRes."Direct Unit Cost"), 0.01);
                GenJnlLine."Sales/Purch. (LCY)" :=
                                               -ROUND(WorkSheetLines.Quantity * (recCostRes."Unit Cost" - recCostRes."Direct Unit Cost"), 0.01);
            END;

            GenJnlLine.Correction := FALSE;
            GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine."Source Type" := GenJnlLine."Source Type"::" ";
            GenJnlLine."Source No." := WorkSheetLines."Resource No.";
            GenJnlLine."Source Code" := SrcCode;
            GenJnlLine."Already Generated Job Entry" := TRUE;
            GenJnlLine."Usage/Sale" := GenJnlLine."Usage/Sale"::Usage;
            IF WorksheetHeader."Shop Depreciate Sheet" THEN BEGIN
                GenJnlLine."Job No." := WorkSheetLines."Job No.";
                GenJnlLine."Job Task No." := WorkSheetLines."Job Task No.";
                GenJnlLine."Piecework Code" := WorksheetHeader."Shop Cost Unit Code";
            END ELSE BEGIN
                GenJnlLine."Job No." := Resource."Jobs Deviation";
                GenJnlLine."Job Task No." := '';
                GenJnlLine."Piecework Code" := WorkSheetLines."Piecework No.";
            END;

            DimMgt.UpdateGlobalDimFromDimSetID(GenJnlLine."Dimension Set ID", GenJnlLine."Shortcut Dimension 1 Code", GenJnlLine."Shortcut Dimension 2 Code");

            IF WorksheetHeader."Shop Depreciate Sheet" THEN BEGIN
                FunctionQB.UpdateDimSet(FunctionQB.ReturnDimJobs, WorkSheetLines."Job No.", GenJnlLine."Dimension Set ID");
                FunctionQB.UpdateDimSet(FunctionQB.ReturnDimDpto, FunctionQB.GetDepartment(DATABASE::Job, WorkSheetLines."Job No."), GenJnlLine."Dimension Set ID");
            END ELSE BEGIN
                //FunctionQB.UpdateDimSet(FunctionQB.ReturnDimJobs,Resource."Jobs Deviation",GenJnlLine."Dimension Set ID");
                IF NOT Job.GET(Resource."Jobs Deviation") THEN
                    ERROR('No ha indicado proyecto de desviaci�n en el recurso %1', Resource."No.");
                //JAV 16/03/22: - QB 1.10.25 Usaba dimensi�n 1 en lugar del c�digo del proyecto
                //FunctionQB.UpdateDimSet(FunctionQB.ReturnDimJobs, Job."Global Dimension 1 Code", GenJnlLine."Dimension Set ID");
                FunctionQB.UpdateDimSet(FunctionQB.ReturnDimJobs, Job."No.", GenJnlLine."Dimension Set ID");
                FunctionQB.UpdateDimSet(FunctionQB.ReturnDimDpto, FunctionQB.GetDepartment(DATABASE::Job, Resource."Jobs Deviation"), GenJnlLine."Dimension Set ID");
            END;

            FunctionQB.UpdateDimSet(FunctionQB.ReturnDimCA, ResourceCost."C.A. Ind. Cost Appl. Account", GenJnlLine."Dimension Set ID");
            DimMgt.UpdateGlobalDimFromDimSetID(GenJnlLine."Dimension Set ID", GenJnlLine."Shortcut Dimension 1 Code", GenJnlLine."Shortcut Dimension 2 Code");
            GenJnlPostLine.RunWithCheck(GenJnlLine);
        END;
    END;

    LOCAL PROCEDURE GenerateTransf();
    VAR
        recDpt: Record 349;
        recCostRes: Record 202;
        ResJnlLine: Record 207;
        ResJnlPostLine: Codeunit 212;
        GenJnlLine: Record 81;
        recJobTransf: Record 167;
        recGLAccount: Record 15;
        JobJournalLine: Record 210;
    BEGIN
        IF NOT boolTransf THEN
            EXIT;

        recDpt.GET(FunctionQB.ReturnDimDpto, FunctionQB.GetDepartment(DATABASE::Resource, WorkSheetLines."Resource No."));
        recDpt.TESTFIELD("Income by Transfer Job");
        recDpt.TESTFIELD("Transfer Analytical Concept");
        recDpt.TESTFIELD("Transfer Account");

        JobJournalLine.INIT;
        JobJournalLine.VALIDATE("Job No.", recDpt."Income by Transfer Job");
        JobJournalLine."Job Task No." := '';
        JobJournalLine."Posting Date" := WorksheetHeader."Posting Date";
        JobJournalLine."Document No." := GenJnlLineDocNo;
        JobJournalLine.Type := JobJournalLine.Type::Resource;
        JobJournalLine."No." := WorkSheetLines."Resource No.";
        JobJournalLine.Quantity := 1;
        JobJournalLine."Direct Unit Cost (LCY)" := 0;
        JobJournalLine."Unit Cost" := 0;
        JobJournalLine."Total Cost" := 0;

        recCostRes.INIT;
        recCostRes.Code := WorkSheetLines."Resource No.";
        recCostRes."Work Type Code" := WorkSheetLines."Work Type Code";

        GetUnitCost(recCostRes, WorkSheetLines."Resource No.", WorkSheetLines."Work Type Code", WorkSheetLines."Direct Cost Price", WorkSheetLines."Cost Price");
        JobJournalLine."Unit Price" := WorkSheetLines."Cost Price" - recCostRes."Unit Cost";
        JobJournalLine."Total Price" := ROUND(WorkSheetLines."Total Cost" - (WorkSheetLines.Quantity * recCostRes."Unit Cost"));

        JobJournalLine.Chargeable := WorkSheetLines.Invoiced;
        JobJournalLine."Post Job Entry Only" := TRUE;
        JobJournalLine."Job Deviation Entry" := FALSE;
        JobJournalLine."Compute for hours" := FALSE;
        JobJournalLine."Piecework Code" := WorkSheetLines."Piecework No.";
        JobJournalLine."Unit of Measure Code" := Resource."Base Unit of Measure";

        FunctionQB.UpdateDimSet(FunctionQB.ReturnDimCA, recDpt."Transfer Analytical Concept", JobJournalLine."Dimension Set ID");
        FunctionQB.UpdateDimSet(FunctionQB.ReturnDimDpto, FunctionQB.GetDepartment(DATABASE::Job, recDpt."Income by Transfer Job"), JobJournalLine."Dimension Set ID");
        DimMgt.UpdateGlobalDimFromDimSetID(JobJournalLine."Dimension Set ID", JobJournalLine."Shortcut Dimension 1 Code", JobJournalLine."Shortcut Dimension 2 Code");

        JobJournalLine."Work Type Code" := WorkSheetLines."Work Type Code";
        JobJournalLine."Entry Type" := JobJournalLine."Entry Type"::Sale;
        JobJournalLine."Source Code" := SrcCode;
        JobJournalLine."Document Date" := WorksheetHeader."Posting Date";
        JobJournalLine."External Document No." := GenJnlLineDocNo;
        JobJournalLine."Posting No. Series" := WorksheetHeader."Posting No. Series";
        JobJournalLine."Gen. Prod. Posting Group" := Resource."Gen. Prod. Posting Group";
        JobJournalLine."Job Posting Only" := TRUE;
        JobJournalLine."Dimension Set ID" := WorkSheetLines."Dimension Set ID";

        FunctionQB.UpdateDimSet(FunctionQB.ReturnDimJobs, recDpt."Income by Transfer Job", JobJournalLine."Dimension Set ID");
        FunctionQB.UpdateDimSet(FunctionQB.ReturnDimDpto, FunctionQB.GetDepartment(DATABASE::Job, recDpt."Income by Transfer Job"), JobJournalLine."Dimension Set ID");
        FunctionQB.UpdateDimSet(FunctionQB.ReturnDimCA, recDpt."Transfer Analytical Concept", JobJournalLine."Dimension Set ID");
        DimMgt.UpdateGlobalDimFromDimSetID(JobJournalLine."Dimension Set ID", JobJournalLine."Shortcut Dimension 1 Code", JobJournalLine."Shortcut Dimension 2 Code");
        //este codigo no estaba en 2016
        //jmmaJobJournalLine.VALIDATE("Unit Cost",JobJournalLine."Unit Cost");
        //jmma JobJournalLine.VALIDATE("Total Cost",JobJournalLine."Total Cost");
        JobJournalLine.VALIDATE("Unit Cost (LCY)", JobJournalLine."Unit Cost (LCY)");
        JobJournalLine.VALIDATE("Direct Unit Cost (LCY)", JobJournalLine."Direct Unit Cost (LCY)");
        JobJournalLine.VALIDATE("Unit Cost", JobJournalLine."Unit Cost");
        JobJournalLine.VALIDATE("Total Cost", JobJournalLine."Total Cost");

        cduPostJournal.RunWithCheck(JobJournalLine);

        ResJnlLine.INIT;
        ResJnlLine."Posting Date" := WorkSheetLines."Work Day Date";
        ResJnlLine."Document Date" := WorksheetHeader."Posting Date";
        ResJnlLine.VALIDATE("Resource No.", WorkSheetLines."Resource No.");
        ResJnlLine."Work Type Code" := WorkSheetLines."Work Type Code";
        ResJnlLine.VALIDATE("Job No.", recDpt."Income by Transfer Job");

        FunctionQB.UpdateDimSet(FunctionQB.ReturnDimCA, recDpt."Transfer Analytical Concept", ResJnlLine."Dimension Set ID");
        FunctionQB.UpdateDimSet(FunctionQB.ReturnDimDpto, FunctionQB.GetDepartment(DATABASE::Job, recDpt."Income by Transfer Job"), ResJnlLine."Dimension Set ID");
        DimMgt.UpdateGlobalDimFromDimSetID(ResJnlLine."Dimension Set ID", ResJnlLine."Shortcut Dimension 1 Code", ResJnlLine."Shortcut Dimension 2 Code");

        ResJnlLine."Gen. Prod. Posting Group" := Resource."Gen. Prod. Posting Group";
        ResJnlLine."Entry Type" := ResJnlLine."Entry Type"::Sale;
        ResJnlLine."Document No." := GenJnlLineDocNo;
        ResJnlLine."External Document No." := GenJnlLineDocNo;
        ResJnlLine.Quantity := -1;
        recCostRes.INIT;
        GetUnitCost(recCostRes, WorkSheetLines."Resource No.", WorkSheetLines."Work Type Code", WorkSheetLines."Direct Cost Price", WorkSheetLines."Cost Price");
        ResJnlLine."Total Cost" := 0;
        ResJnlLine."Total Price" := -(ROUND(WorkSheetLines."Total Cost" - (WorkSheetLines.Quantity * recCostRes."Unit Cost")));
        ResJnlLine."Source Code" := SrcCode;
        ResJnlLine."Dimension Set ID" := WorkSheetLines."Dimension Set ID";

        FunctionQB.UpdateDimSet(FunctionQB.ReturnDimJobs, recDpt."Income by Transfer Job", ResJnlLine."Dimension Set ID");
        FunctionQB.UpdateDimSet(FunctionQB.ReturnDimDpto, FunctionQB.GetDepartment(DATABASE::Job, recDpt."Income by Transfer Job"), ResJnlLine."Dimension Set ID");
        FunctionQB.UpdateDimSet(FunctionQB.ReturnDimCA, recDpt."Transfer Analytical Concept", ResJnlLine."Dimension Set ID");
        DimMgt.UpdateGlobalDimFromDimSetID(ResJnlLine."Dimension Set ID", ResJnlLine."Shortcut Dimension 1 Code", ResJnlLine."Shortcut Dimension 2 Code");
        ResJnlPostLine.RunWithCheck(ResJnlLine);

        GenJnlLine.INIT;
        GenJnlLine."Posting Date" := WorksheetHeader."Posting Date";
        GenJnlLine."Document Date" := WorksheetHeader."Posting Date";
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
        GenJnlLine."Account No." := recDpt."Transfer Account";

        recGLAccount.GET(recDpt."Transfer Account");
        GenJnlLine.Description := recGLAccount.Name;

        FunctionQB.UpdateDimSet(FunctionQB.ReturnDimCA, recDpt."Transfer Analytical Concept", GenJnlLine."Dimension Set ID");
        FunctionQB.UpdateDimSet(FunctionQB.ReturnDimDpto, FunctionQB.GetDepartment(DATABASE::Job, recDpt."Income by Transfer Job"), GenJnlLine."Dimension Set ID");
        DimMgt.UpdateGlobalDimFromDimSetID(GenJnlLine."Dimension Set ID", GenJnlLine."Shortcut Dimension 1 Code", GenJnlLine."Shortcut Dimension 2 Code");

        GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
        GenJnlLine."Document No." := GenJnlLineDocNo;
        GenJnlLine."External Document No." := GenJnlLineDocNo;
        GenJnlLine."Currency Factor" := 1;
        recCostRes.INIT;
        GetUnitCost(recCostRes, WorkSheetLines."Resource No.", WorkSheetLines."Work Type Code", WorkSheetLines."Direct Cost Price", WorkSheetLines."Cost Price");
        GenJnlLine.Amount := -(ROUND(WorkSheetLines."Total Cost" - (WorkSheetLines.Quantity * recCostRes."Unit Cost")));
        GenJnlLine."Amount (LCY)" := -(ROUND(WorkSheetLines."Total Cost" - (WorkSheetLines.Quantity * recCostRes."Unit Cost")));
        GenJnlLine."Sales/Purch. (LCY)" := -(ROUND(WorkSheetLines."Total Cost" - (WorkSheetLines.Quantity * recCostRes."Unit Cost")));

        GenJnlLine.Correction := FALSE;
        GenJnlLine."System-Created Entry" := TRUE;
        GenJnlLine."Source Type" := GenJnlLine."Source Type"::" ";
        GenJnlLine."Source No." := WorkSheetLines."Resource No.";
        GenJnlLine."Source Code" := SrcCode;
        GenJnlLine."Already Generated Job Entry" := TRUE;
        GenJnlLine."Usage/Sale" := GenJnlLine."Usage/Sale"::Sale;
        GenJnlLine."Job No." := recDpt."Income by Transfer Job";
        GenJnlLine."Piecework Code" := WorkSheetLines."Piecework No.";

        FunctionQB.UpdateDimSet(FunctionQB.ReturnDimJobs, recDpt."Income by Transfer Job", GenJnlLine."Dimension Set ID");
        FunctionQB.UpdateDimSet(FunctionQB.ReturnDimDpto, FunctionQB.GetDepartment(DATABASE::Job, recDpt."Income by Transfer Job"), GenJnlLine."Dimension Set ID");
        FunctionQB.UpdateDimSet(FunctionQB.ReturnDimCA, recDpt."Transfer Analytical Concept", GenJnlLine."Dimension Set ID");
        DimMgt.UpdateGlobalDimFromDimSetID(GenJnlLine."Dimension Set ID", GenJnlLine."Shortcut Dimension 1 Code", GenJnlLine."Shortcut Dimension 2 Code");
        GenJnlPostLine.RunWithCheck(GenJnlLine);
        //jmma error pasa 0 a job ledger entry este c�digo no estaba en 2016
        //JobJournalLine.VALIDATE("Unit Cost",JobJournalLine."Unit Cost");
        //JobJournalLine.VALIDATE("Total Cost",JobJournalLine."Total Cost");
    END;

    LOCAL PROCEDURE CreatehistHeader();
    VAR
        QBCommentLine: Record 7207270;
    BEGIN
        //Creo el documento que ir� al hist�rico
        WorksheetHeaderHist.INIT;
        WorksheetHeaderHist.TRANSFERFIELDS(WorksheetHeader);
        WorksheetHeaderHist."Pre-Assigned No. Series" := WorksheetHeader."Posting No. Series";
        WorksheetHeaderHist."No." := NoSeriesMgt.GetNextNo(WorksheetHeader."Posting No. Series", WorksheetHeader."Posting Date", TRUE);
        Window.UPDATE(1, STRSUBSTNO(Text010, WorksheetHeader."No.", WorksheetHeaderHist."No."));

        WorksheetHeaderHist."Source Code" := SrcCode;
        WorksheetHeaderHist."User ID" := USERID;
        WorksheetHeaderHist.INSERT(TRUE);

        CopyCommentLines(QBCommentLine."Document Type"::Sheet, WorksheetHeader."No.", QBCommentLine."Document Type"::"Sheet Hist.", WorksheetHeaderHist."No.");

        GenJnlLineDocNo := WorksheetHeaderHist."No.";
    END;

    LOCAL PROCEDURE InsertHist();
    BEGIN
        WorksheetLinesHist.INIT;
        WorksheetLinesHist.TRANSFERFIELDS(WorkSheetLines);
        WorksheetLinesHist."Document No." := WorksheetHeaderHist."No.";
        WorksheetLinesHist.INSERT;
    END;

    LOCAL PROCEDURE "--------------------------------- Registro de partes externos"();
    BEGIN
    END;

    PROCEDURE ExternalWorksheet_BatchPost();
    VAR
        QBExternalWorksheetHeader: Record 7206933;
        Window: Dialog;
        Counter1: Integer;
        Counter2: Integer;
        Counter3: Integer;
        Text000: TextConst ENU = 'Please enter the posting date.', ESP = 'Introduzca la fecha de registro.';
        Text001: TextConst ENU = 'Posting invoices   #1########## @@@@@@@@@@@@@', ESP = '"Registrando:  @@@@@@@@@@@@@/Parte: #1########## "';
        Text002: TextConst ENU = '%1 invoices out of a total of %2 have now been posted.', ESP = 'Se han registrado %1 partes de un total de %2.';
    BEGIN
        Window.OPEN(Text001);

        QBExternalWorksheetHeader.RESET;
        Counter1 := 0;
        Counter2 := QBExternalWorksheetHeader.COUNT;
        IF (QBExternalWorksheetHeader.FINDSET(FALSE)) THEN
            REPEAT
                Counter2 := Counter2 + 1;
                Window.UPDATE(1, ROUND(Counter2 / Counter1 * 10000, 1));
                Window.UPDATE(2, QBExternalWorksheetHeader."No.");

                IF (NOT ExternalWorksheet_PostWithError(QBExternalWorksheetHeader)) THEN
                    Counter3 += 1;
            UNTIL (QBExternalWorksheetHeader.NEXT = 0);

        Window.CLOSE;
        MESSAGE(Text002, Counter3, Counter1);
    END;

    [TryFunction]
    PROCEDURE ExternalWorksheet_PostWithError(QBExternalWorksheetHeader: Record 7206933);
    VAR
        Vendor: Record 23;
        QBExternalWorksheetLines: Record 7206934;
        QBExternalWorksheetHeaderP: Record 7206935;
        Job: Record 167;
        LinComDoc: Record 7207270;
        SourceCodeSetup: Record 242;
    BEGIN
        ExternalWorksheet_Post(QBExternalWorksheetHeader);
    END;

    PROCEDURE ExternalWorksheet_Post(QBExternalWorksheetHeader: Record 7206933);
    VAR
        QuoBuildingSetup: Record 7207278;
        Vendor: Record 23;
        QBExternalWorksheetLines: Record 7206934;
        QBExternalWorksheetHeaderP: Record 7206935;
        Job: Record 167;
        LinComDoc: Record 7207270;
        SourceCodeSetup: Record 242;
    BEGIN
        //TO-DO Aqui falta verificar el estado de aprobaci�n


        IF opcPostingDateExists AND (opcReplacePostingDate OR (QBExternalWorksheetHeader."Posting Date" = 0D)) THEN
            QBExternalWorksheetHeader.VALIDATE("Posting Date", opcPostingDate);
        CLEARALL;

        Window.OPEN(Text001 + Text002 + Text003 + Text004 + Text005 + Text006);
        Window.UPDATE(1, STRSUBSTNO('%1', QBExternalWorksheetHeader."No."));

        //Comprobamos los campos obligatorios
        IF (QBExternalWorksheetHeader."Posting Date" = 0D) THEN
            ERROR('No ha indicado la fecha de registro');
        IF (QBExternalWorksheetHeader."Sheet Date" = 0D) THEN
            ERROR('No ha indicado la fecha del parte');

        IF (QBExternalWorksheetHeader."Vendor No." = '') THEN
            ERROR('No ha indicado el vendedor');
        IF NOT Vendor.GET(QBExternalWorksheetHeader."Vendor No.") THEN
            ERROR('En proveedor no existe.');
        IF (Vendor.Blocked <> Vendor.Blocked::" ") THEN
            ERROR('El vendedor est� bloqueado');

        //Comprobamos las dimensiones
        ExternalWorksheet_CheckDim(QBExternalWorksheetHeader);

        //Comprobamos que el n� de serie de registro este relleno
        QBExternalWorksheetHeader.TESTFIELD("Posting No. Series");

        //Tomamos el c�d. de origen.
        SourceCodeSetup.GET;
        SrcCode := SourceCodeSetup.WorkSheet;

        ExternalWorksheet_CreatehistHeader(QBExternalWorksheetHeader, QBExternalWorksheetHeaderP);

        // Lineas
        QBExternalWorksheetLines.RESET;
        QBExternalWorksheetLines.SETRANGE("Document No.", QBExternalWorksheetHeader."No.");
        LineCount := 0;
        IF QBExternalWorksheetLines.FINDSET(FALSE) THEN BEGIN
            REPEAT
                LineCount := LineCount + 1;
                Window.UPDATE(2, LineCount);

                Resource.GET(QBExternalWorksheetLines."Resource No.");
                Job.GET(QBExternalWorksheetLines."Job No.");

                ExternalWorksheet_InsertHist(QBExternalWorksheetLines, QBExternalWorksheetHeaderP);
                QuoBuildingSetup.GET();
                IF (QuoBuildingSetup."Use External Wookshet" IN [QuoBuildingSetup."Use External Wookshet"::Job, QuoBuildingSetup."Use External Wookshet"::GL]) THEN BEGIN
                    IF (QBExternalWorksheetLines."Work Type Code" <> '') OR (QBExternalWorksheetLines.Quantity <> 0) THEN BEGIN
                        ExternalWorksheet_CtrlLines(QBExternalWorksheetLines);  //////
                        ExternalWorksheet_CreateJobMov(QBExternalWorksheetHeaderP."No.", QBExternalWorksheetHeader."Posting Date",
                                                       QBExternalWorksheetHeader."Posting No. Series", QBExternalWorksheetLines."Work Type Code",
                                                       QBExternalWorksheetLines."Resource No.", QBExternalWorksheetLines."Job No.", QBExternalWorksheetLines."Piecework No.",
                                                       QBExternalWorksheetLines.Description, QBExternalWorksheetLines.Quantity, QBExternalWorksheetLines."Cost Price",
                                                       QBExternalWorksheetLines."Shortcut Dimension 1 Code", QBExternalWorksheetLines."Shortcut Dimension 2 Code", QBExternalWorksheetLines."Dimension Set ID");
                        ExternalWorksheet_CrearteGLEntry(QBExternalWorksheetHeaderP."No.", QBExternalWorksheetHeader."Posting Date",
                                                         ResourceCost."Acc. Direct Cost Allocation", ResourceCost."Acc. Direct Cost Appl. Account",
                                                         QBExternalWorksheetLines."Resource No.", QBExternalWorksheetLines."Job No.", QBExternalWorksheetLines."Piecework No.",
                                                         ROUND(QBExternalWorksheetLines."Cost Price" * QBExternalWorksheetLines.Quantity, 0.01),
                                                         QBExternalWorksheetLines."Shortcut Dimension 1 Code", QBExternalWorksheetLines."Shortcut Dimension 2 Code", QBExternalWorksheetLines."Dimension Set ID");
                        AddToPiecework(QBExternalWorksheetLines."Job No.", QBExternalWorksheetLines."Piecework No.", QBExternalWorksheetLines.Quantity);
                    END;
                END;
            UNTIL QBExternalWorksheetLines.NEXT = 0;
        END ELSE BEGIN
            ERROR(Text000);
        END;

        QBExternalWorksheetHeader.DELETE;
        QBExternalWorksheetLines.DELETEALL;

        Window.CLOSE;
        UpdateAnalysisView.UpdateAll(0, TRUE);
    END;

    LOCAL PROCEDURE ExternalWorksheet_CheckDim(QBExternalWorksheetHeader: Record 7206933);
    VAR
        QBExternalWorksheetLines: Record 7206934;
    BEGIN
        CLEAR(QBExternalWorksheetLines);
        ExternalWorksheet_CheckDimValuePosting(QBExternalWorksheetHeader, QBExternalWorksheetLines);
        ExternalWorksheet_CheckDimComb(QBExternalWorksheetHeader, QBExternalWorksheetLines);

        QBExternalWorksheetLines.RESET;
        QBExternalWorksheetLines.SETRANGE("Document No.", QBExternalWorksheetHeader."No.");
        IF QBExternalWorksheetLines.FINDSET(FALSE) THEN
            REPEAT
                ExternalWorksheet_CheckDimComb(QBExternalWorksheetHeader, QBExternalWorksheetLines);
                ExternalWorksheet_CheckDimValuePosting(QBExternalWorksheetHeader, QBExternalWorksheetLines);
            UNTIL QBExternalWorksheetLines.NEXT = 0;
    END;

    LOCAL PROCEDURE ExternalWorksheet_CheckDimComb(QBExternalWorksheetHeader: Record 7206933; QBExternalWorksheetLines: Record 7206934);
    BEGIN
        IF QBExternalWorksheetLines."Line No." = 0 THEN BEGIN
            IF NOT DimMgt.CheckDimIDComb(QBExternalWorksheetHeader."Dimension Set ID") THEN
                ERROR(Text032, QBExternalWorksheetHeader."No.", DimMgt.GetDimCombErr);
        END ELSE BEGIN
            IF NOT DimMgt.CheckDimIDComb(QBExternalWorksheetLines."Dimension Set ID") THEN
                ERROR(Text033, QBExternalWorksheetHeader."No.", QBExternalWorksheetLines."Line No.", DimMgt.GetDimCombErr);
        END;
    END;

    LOCAL PROCEDURE ExternalWorksheet_CheckDimValuePosting(QBExternalWorksheetHeader: Record 7206933; QBExternalWorksheetLines: Record 7206934);
    VAR
        TableIDArr: ARRAY[10] OF Integer;
        NumberArr: ARRAY[10] OF Code[20];
    BEGIN
        IF QBExternalWorksheetLines."Line No." = 0 THEN BEGIN
            TableIDArr[1] := DATABASE::Vendor;
            NumberArr[1] := QBExternalWorksheetHeader."Vendor No.";

            IF NOT DimMgt.CheckDimValuePosting(TableIDArr, NumberArr, QBExternalWorksheetHeader."Dimension Set ID") THEN
                ERROR(Text034, QBExternalWorksheetHeader."No.", DimMgt.GetDimValuePostingErr);
        END ELSE BEGIN
            TableIDArr[1] := DATABASE::Job;
            NumberArr[1] := QBExternalWorksheetLines."Job No.";
            TableIDArr[2] := DATABASE::Resource;
            NumberArr[2] := QBExternalWorksheetLines."Resource No.";

            IF NOT DimMgt.CheckDimValuePosting(TableIDArr, NumberArr, QBExternalWorksheetLines."Dimension Set ID") THEN
                ERROR(Text035, QBExternalWorksheetHeader."No.", QBExternalWorksheetLines."Line No.", DimMgt.GetDimValuePostingErr);
        END;
    END;

    LOCAL PROCEDURE ExternalWorksheet_CtrlLines(QBExternalWorksheetLines: Record 7206934);
    VAR
        QuoBuildingSetup: Record 7207278;
        locTransfer: Record 7207299;
    BEGIN
        //Busco el espec�fico del recurso, sino lo encuentro busco el de la familia
        IF NOT ResourceCost.GET(ResourceCost.Type::Resource, QBExternalWorksheetLines."Resource No.", QBExternalWorksheetLines."Work Type Code") THEN
            ResourceCost.GET(ResourceCost.Type::"Group(Resource)", Resource."Resource Group No.", QBExternalWorksheetLines."Work Type Code");

        QuoBuildingSetup.GET();
        IF (QuoBuildingSetup."Use External Wookshet" = QuoBuildingSetup."Use External Wookshet"::GL) THEN BEGIN
            CtrlLinesCheck(ResourceCost.FIELDNO("Acc. Direct Cost Allocation"));
            CtrlLinesCheck(ResourceCost.FIELDNO("Acc. Direct Cost Appl. Account"));
        END;

        QBExternalWorksheetLines.TESTFIELD("Cost Price");
        QBExternalWorksheetLines.TESTFIELD(Quantity);

        boolTransf := FALSE;
    END;

    LOCAL PROCEDURE ExternalWorksheet_CreateJobMov(pDocumentNo: Code[20]; pDate: Date; pSeries: Code[20]; pWorkType: Code[20]; pResource: Code[20]; pJob: Code[20]; pPiecework: Code[20]; pDescription: Text; pQuantity: Decimal; pPrice: Decimal; pDim1: Code[20]; pDim2: Code[20]; pDimID: Integer);
    VAR
        QuoBuildingSetup: Record 7207278;
        JobJournalLine: Record 210;
        Currency: Record 4;
    BEGIN
        QuoBuildingSetup.GET();
        IF (QuoBuildingSetup."Use External Wookshet" IN [QuoBuildingSetup."Use External Wookshet"::Job, QuoBuildingSetup."Use External Wookshet"::GL]) THEN
            EXIT;

        intCountJob += 1;
        Window.UPDATE(3, intCountJob);

        Resource.GET(pResource);
        Currency.InitRoundingPrecision;

        //Crear l�nea en el proyecto
        JobJournalLine.INIT;
        JobJournalLine.VALIDATE("Job No.", pJob);
        JobJournalLine."Posting Date" := pDate;
        JobJournalLine."Document No." := pDocumentNo;
        JobJournalLine.Type := JobJournalLine.Type::Resource;
        JobJournalLine."No." := pResource;
        JobJournalLine.Description := pDescription;
        JobJournalLine.Quantity := pQuantity;
        JobJournalLine."Qty. per Unit of Measure" := 1;
        JobJournalLine."Quantity (Base)" := JobJournalLine.Quantity;
        JobJournalLine."Direct Unit Cost (LCY)" := pPrice;
        JobJournalLine."Unit Cost (LCY)" := pPrice;
        JobJournalLine."Total Cost (LCY)" := ROUND(pPrice * pQuantity, 0.01);
        JobJournalLine."Post Job Entry Only" := TRUE;
        JobJournalLine."Job Deviation Entry" := FALSE;
        JobJournalLine."Piecework Code" := pPiecework;
        JobJournalLine."Unit of Measure Code" := Resource."Base Unit of Measure";
        JobJournalLine."Work Type Code" := pWorkType;
        JobJournalLine."Entry Type" := JobJournalLine."Entry Type"::Usage;
        JobJournalLine."Source Code" := SrcCode;
        JobJournalLine."Document Date" := pDate;
        JobJournalLine."External Document No." := pDocumentNo;
        JobJournalLine."Posting No. Series" := pSeries;
        JobJournalLine."Gen. Prod. Posting Group" := Resource."Gen. Prod. Posting Group";
        JobJournalLine."Source Currency Total Price" := ROUND(JobJournalLine."Total Price (LCY)", Currency."Amount Rounding Precision");
        JobJournalLine."Job Posting Only" := TRUE;
        JobJournalLine."Shortcut Dimension 1 Code" := pDim1;
        JobJournalLine."Shortcut Dimension 2 Code" := pDim2;
        JobJournalLine."Dimension Set ID" := pDimID;

        JobJournalLine.VALIDATE("Unit Cost (LCY)");
        JobJournalLine.VALIDATE("Direct Unit Cost (LCY)");
        JobJournalLine.VALIDATE("Unit Cost");
        JobJournalLine.VALIDATE("Total Cost");

        cduPostJournal.RunWithCheck(JobJournalLine);

        //Crear la l�nea en el proyecto de estructura
        intCountJob += 1;
        Window.UPDATE(3, intCountJob);

        JobJournalLine.INIT;
        IF (MandatoryJob) THEN
            Resource.TESTFIELD("Jobs Deviation");
        JobJournalLine.VALIDATE("Job No.", Resource."Jobs Deviation");
        JobJournalLine."Job Task No." := '';

        IF JobJournalLine."Job No." <> '' THEN BEGIN
            JobJournalLine."Posting Date" := pDate;
            JobJournalLine."Document No." := pDocumentNo;
            JobJournalLine.Type := JobJournalLine.Type::Resource;
            JobJournalLine."No." := pResource;
            JobJournalLine.Quantity := -pQuantity;
            JobJournalLine."Qty. per Unit of Measure" := 1;
            JobJournalLine."Quantity (Base)" := JobJournalLine.Quantity;
            JobJournalLine."Direct Unit Cost (LCY)" := pPrice;
            JobJournalLine."Unit Cost (LCY)" := pPrice;
            JobJournalLine."Total Cost (LCY)" := -ROUND(pPrice * pQuantity, 0.01);
            JobJournalLine."Post Job Entry Only" := TRUE;
            JobJournalLine."Job Deviation Entry" := TRUE;
            JobJournalLine."Piecework Code" := pPiecework;
            JobJournalLine."Unit of Measure Code" := Resource."Base Unit of Measure";
            JobJournalLine."Work Type Code" := pWorkType;
            JobJournalLine."Entry Type" := JobJournalLine."Entry Type"::Usage;
            JobJournalLine."Source Code" := SrcCode;
            JobJournalLine."Document Date" := pDate;
            JobJournalLine."External Document No." := pDocumentNo;
            JobJournalLine."Posting No. Series" := pSeries;
            JobJournalLine."Gen. Prod. Posting Group" := Resource."Gen. Prod. Posting Group";
            JobJournalLine."Source Currency Total Price" := ROUND(JobJournalLine."Total Price (LCY)", Currency."Amount Rounding Precision");
            JobJournalLine."Job Posting Only" := TRUE;

            JobJournalLine."Dimension Set ID" := pDimID;
            FunctionQB.UpdateDimSet(FunctionQB.ReturnDimJobs, Resource."Jobs Deviation", JobJournalLine."Dimension Set ID");
            FunctionQB.UpdateDimSet(FunctionQB.ReturnDimDpto, FunctionQB.GetDepartment(DATABASE::Job, Resource."Jobs Deviation"), JobJournalLine."Dimension Set ID");
            FunctionQB.UpdateDimSet(FunctionQB.ReturnDimCA, ResourceCost."C.A. Direct Cost Appl. Account", JobJournalLine."Dimension Set ID");
            DimMgt.UpdateGlobalDimFromDimSetID(JobJournalLine."Dimension Set ID", JobJournalLine."Shortcut Dimension 1 Code", JobJournalLine."Shortcut Dimension 2 Code");

            JobJournalLine.VALIDATE("Unit Cost (LCY)");
            JobJournalLine.VALIDATE("Direct Unit Cost (LCY)");
            JobJournalLine.VALIDATE("Unit Cost");
            JobJournalLine.VALIDATE("Total Cost");

            cduPostJournal.RunWithCheck(JobJournalLine);
        END;
    END;

    LOCAL PROCEDURE ExternalWorksheet_CrearteGLEntry(pDocumentNo: Code[20]; pDate: Date; pAccount: Code[20]; pBalAccount: Code[20]; pResource: Code[20]; pJob: Code[20]; pPiecework: Code[20]; pAmount: Decimal; pDim1: Code[20]; pDim2: Code[20]; pDimID: Integer);
    VAR
        QuoBuildingSetup: Record 7207278;
        GenJnlLine: Record 81;
        recCostRes: Record 202;
        recGLAccount: Record 15;
    BEGIN
        QuoBuildingSetup.GET();
        IF (QuoBuildingSetup."Use External Wookshet" <> QuoBuildingSetup."Use External Wookshet"::GL) THEN
            EXIT;

        IntCountGLAccount += 1;
        Window.UPDATE(5, IntCountGLAccount);

        //coste directo
        recGLAccount.GET(pAccount);

        GenJnlLine.INIT;
        GenJnlLine."Posting Date" := pDate;
        GenJnlLine."Document Date" := pDate;
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
        GenJnlLine."Account No." := pAccount;
        GenJnlLine.Description := recGLAccount.Name;
        GenJnlLine."Shortcut Dimension 1 Code" := pDim1;
        GenJnlLine."Shortcut Dimension 2 Code" := pDim2;
        GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
        GenJnlLine."Document No." := pDocumentNo;
        GenJnlLine."External Document No." := pDocumentNo;
        GenJnlLine.Amount := pAmount;
        GenJnlLine."Amount (LCY)" := pAmount;
        GenJnlLine."Sales/Purch. (LCY)" := pAmount;
        GenJnlLine."Currency Factor" := 1;
        GenJnlLine.Correction := FALSE;
        GenJnlLine."System-Created Entry" := TRUE;
        GenJnlLine."Source Type" := GenJnlLine."Source Type"::" ";
        GenJnlLine."Source No." := pResource;
        GenJnlLine."Source Code" := SrcCode;
        GenJnlLine."Already Generated Job Entry" := TRUE;
        GenJnlLine."Usage/Sale" := GenJnlLine."Usage/Sale"::Usage;
        GenJnlLine."Job No." := pJob;
        GenJnlLine."Piecework Code" := pPiecework;
        GenJnlLine."Dimension Set ID" := pDimID;
        GenJnlPostLine.RunWithCheck(GenJnlLine);

        IntCountGLAccount += 1;
        Window.UPDATE(5, IntCountGLAccount);

        //Contrapartida
        recGLAccount.GET(pBalAccount);

        GenJnlLine.INIT;
        GenJnlLine."Posting Date" := pDate;
        GenJnlLine."Document Date" := pDate;
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
        GenJnlLine."Account No." := pBalAccount;
        GenJnlLine.Description := recGLAccount.Name;
        GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
        GenJnlLine."Document No." := pDocumentNo;
        GenJnlLine."External Document No." := pDocumentNo;
        GenJnlLine."Currency Factor" := 1;
        GenJnlLine.Amount := -pAmount;
        GenJnlLine."Amount (LCY)" := -pAmount;
        GenJnlLine."Sales/Purch. (LCY)" := -pAmount;
        GenJnlLine.Correction := FALSE;
        GenJnlLine."System-Created Entry" := TRUE;
        GenJnlLine."Source Type" := GenJnlLine."Source Type"::" ";
        GenJnlLine."Source No." := pResource;
        GenJnlLine."Source Code" := SrcCode;
        GenJnlLine."Already Generated Job Entry" := TRUE;
        GenJnlLine."Usage/Sale" := GenJnlLine."Usage/Sale"::Usage;
        GenJnlLine."Job No." := Resource."Jobs Deviation";
        GenJnlLine."Job Task No." := '';
        GenJnlLine."Piecework Code" := pPiecework;

        GenJnlLine."Dimension Set ID" := pDimID;
        FunctionQB.UpdateDimSet(FunctionQB.ReturnDimJobs, Resource."Jobs Deviation", GenJnlLine."Dimension Set ID");
        FunctionQB.UpdateDimSet(FunctionQB.ReturnDimDpto, FunctionQB.GetDepartment(DATABASE::Resource, Resource."No."), GenJnlLine."Dimension Set ID");
        FunctionQB.UpdateDimSet(FunctionQB.ReturnDimCA, ResourceCost."C.A. Direct Cost Appl. Account", GenJnlLine."Dimension Set ID");
        DimMgt.UpdateGlobalDimFromDimSetID(GenJnlLine."Dimension Set ID", GenJnlLine."Shortcut Dimension 1 Code", GenJnlLine."Shortcut Dimension 2 Code");

        GenJnlPostLine.RunWithCheck(GenJnlLine);
    END;

    LOCAL PROCEDURE ExternalWorksheet_CreatehistHeader(QBExternalWorksheetHeader: Record 7206933; VAR QBExternalWorksheetHeaderP: Record 7206935);
    VAR
        QBCommentLine: Record 7207270;
    BEGIN
        //Creo el documento que ir� al hist�rico
        QBExternalWorksheetHeaderP.INIT;
        QBExternalWorksheetHeaderP.TRANSFERFIELDS(QBExternalWorksheetHeader);
        QBExternalWorksheetHeaderP."Pre-Assigned No. Series" := QBExternalWorksheetHeader."Posting No. Series";
        QBExternalWorksheetHeaderP."No." := NoSeriesMgt.GetNextNo(QBExternalWorksheetHeader."Posting No. Series", QBExternalWorksheetHeader."Posting Date", TRUE);
        QBExternalWorksheetHeaderP."Source Code" := SrcCode;
        QBExternalWorksheetHeaderP."User ID" := USERID;
        QBExternalWorksheetHeaderP.INSERT(TRUE);

        Window.UPDATE(1, STRSUBSTNO(Text010, QBExternalWorksheetHeader."No.", QBExternalWorksheetHeaderP."No."));

        CopyCommentLines(QBCommentLine."Document Type"::ExternalSheet, QBExternalWorksheetHeader."No.", QBCommentLine."Document Type"::ExternalSheetHist, QBExternalWorksheetHeaderP."No.");
    END;

    LOCAL PROCEDURE ExternalWorksheet_InsertHist(QBExternalWorksheetLines: Record 7206934; QBExternalWorksheetHeaderP: Record 7206935);
    VAR
        QBExternalWorksheetLinesPo: Record 7206936;
    BEGIN
        QBExternalWorksheetLinesPo.INIT;
        QBExternalWorksheetLinesPo.TRANSFERFIELDS(QBExternalWorksheetLines);
        QBExternalWorksheetLinesPo."Document No." := QBExternalWorksheetHeaderP."No.";
        QBExternalWorksheetLinesPo.VALIDATE("Quantity Pending");  //Guardar la cantidad inicial pendiente que es la total
        QBExternalWorksheetLinesPo.INSERT;
    END;

    LOCAL PROCEDURE "--------------------------------- Paramento del registor por lotes"();
    BEGIN
    END;

    PROCEDURE SetPostingDate(NewReplacePostingDate: Boolean; NewReplaceDocumentDate: Boolean; NewPostingDate: Date);
    BEGIN
        opcPostingDateExists := TRUE;
        opcReplacePostingDate := NewReplacePostingDate;
        opcReplaceDocumentDate := NewReplaceDocumentDate;
        opcPostingDate := NewPostingDate;
    END;

    LOCAL PROCEDURE "--------------------------------- Funciones comunes"();
    BEGIN
    END;

    LOCAL PROCEDURE MandatoryJob(): Boolean;
    VAR
        QuoBuildingSetup: Record 7207278;
    BEGIN
        QuoBuildingSetup.GET;
        EXIT(NOT QuoBuildingSetup."Skip Required Project");
    END;

    LOCAL PROCEDURE CtrlLinesCheck(pCampo: Integer);
    VAR
        rRef: RecordRef;
        fRef: FieldRef;
        Valor: Code[20];
    BEGIN
        //Ver si tiene un valor un campo
        rRef.GETTABLE(ResourceCost);
        fRef := rRef.FIELD(pCampo);
        Valor := fRef.VALUE;
        IF (Valor = '') THEN
            ERROR('No ha definido el campo "%1" en la tabla "%2" para "%3" de c�digo', fRef.CAPTION, ResourceCost.TABLECAPTION, ResourceCost.Type);
    END;

    LOCAL PROCEDURE CopyCommentLines(FromType: Option; FromNumber: Code[20]; ToType: Option; ToNumber: Code[20]);
    VAR
        QBCommentLineOri: Record 7207270;
        QBCommentLineDes: Record 7207270;
    BEGIN
        QBCommentLineOri.RESET;
        QBCommentLineOri.SETRANGE("Document Type", FromType);
        QBCommentLineOri.SETRANGE("No.", FromNumber);
        IF QBCommentLineOri.FINDSET(TRUE) THEN
            REPEAT
                QBCommentLineOri.DELETE;

                QBCommentLineDes := QBCommentLineOri;
                QBCommentLineDes."Document Type" := ToType;
                QBCommentLineDes."No." := ToNumber;
                QBCommentLineDes.INSERT;

            UNTIL QBCommentLineOri.NEXT = 0;
    END;

    LOCAL PROCEDURE AddToPiecework(pJob: Code[20]; pPiecework: Code[20]; pHours: Decimal);
    VAR
        QuoBuildingSetup: Record 7207278;
        DataPieceworkForProduction: Record 7207386;
    BEGIN
        QuoBuildingSetup.GET;
        IF (QuoBuildingSetup."Hours control" = QuoBuildingSetup."Hours control"::Yes) THEN
            IF (DataPieceworkForProduction.GET(pJob, pPiecework)) THEN BEGIN
                DataPieceworkForProduction."Registered Hours" += pHours;
                DataPieceworkForProduction."Registered Work Part" += 1;
                DataPieceworkForProduction.MODIFY;
            END;
    END;

    LOCAL PROCEDURE GetUnitCost(VAR ResourceCost: Record 202; ResourceNo: Code[20]; WorkType: Code[20]; DCP: Decimal; CP: Decimal);
    VAR
        recCostRes: Record 202;
    BEGIN
        ResourceCost."Direct Unit Cost" := DCP;
        ResourceCost."Unit Cost" := CP;
        IF recCostRes.GET(recCostRes.Type::Resource, ResourceNo, WorkType) THEN BEGIN
            ResourceCost."Unit Cost" := recCostRes."Unit Cost";
            ResourceCost."Direct Unit Cost" := recCostRes."Direct Unit Cost";
        END ELSE BEGIN
            Resource.GET(ResourceNo);
            ResourceCost."Unit Cost" := Resource."Unit Cost";
            ResourceCost."Direct Unit Cost" := Resource."Direct Unit Cost";
        END;
    END;

    LOCAL PROCEDURE "--------------------------------- Respuesta a eventos"();
    BEGIN
    END;

    [EventSubscriber(ObjectType::Codeunit, 90, OnAfterPostPurchLine, '', true, true)]
    LOCAL PROCEDURE OnAfterPostPurchaseDoc_CU90(VAR PurchaseHeader: Record 38; VAR PurchaseLine: Record 39; CommitIsSupressed: Boolean);
    VAR
        QBExternalWorksheetHeaderP: Record 7206935;
        QBExternalWorksheetLinesPo: Record 7206936;
    BEGIN
        //Eliminar las marcas de las l�neas de partes de trabajadores externos asociados
        QBExternalWorksheetLinesPo.RESET;
        QBExternalWorksheetLinesPo.SETRANGE("Apply to Document Type", PurchaseHeader."Document Type");
        QBExternalWorksheetLinesPo.SETRANGE("Apply to Document No", PurchaseHeader."No.");
        IF (QBExternalWorksheetLinesPo.FINDSET(TRUE)) THEN
            REPEAT
                // Deshago la imputaci�n en el proyecto y el asiento
                QBExternalWorksheetHeaderP.GET(QBExternalWorksheetLinesPo."Document No.");

                ExternalWorksheet_CreateJobMov(QBExternalWorksheetHeaderP."No.", QBExternalWorksheetHeaderP."Posting Date",
                                               QBExternalWorksheetHeaderP."No. Series", QBExternalWorksheetLinesPo."Work Type Code",
                                               QBExternalWorksheetLinesPo."Resource No.", QBExternalWorksheetLinesPo."Job No.", QBExternalWorksheetLinesPo."Piecework No.",
                                               QBExternalWorksheetLinesPo.Description, -QBExternalWorksheetLinesPo.Quantity, QBExternalWorksheetLinesPo."Cost Price",
                                               QBExternalWorksheetLinesPo."Shortcut Dimension 1 Code", QBExternalWorksheetLinesPo."Shortcut Dimension 2 Code", QBExternalWorksheetLinesPo."Dimension Set ID");
                ExternalWorksheet_CrearteGLEntry(QBExternalWorksheetHeaderP."No.", QBExternalWorksheetHeaderP."Posting Date",
                                                 ResourceCost."Acc. Direct Cost Allocation", ResourceCost."Acc. Direct Cost Appl. Account",
                                                 QBExternalWorksheetLinesPo."Resource No.", QBExternalWorksheetLinesPo."Job No.", QBExternalWorksheetLinesPo."Piecework No.",
                                                 -ROUND(QBExternalWorksheetLinesPo."Cost Price" * QBExternalWorksheetLinesPo.Quantity, 0.01),
                                                 QBExternalWorksheetLinesPo."Shortcut Dimension 1 Code", QBExternalWorksheetLinesPo."Shortcut Dimension 2 Code", QBExternalWorksheetLinesPo."Dimension Set ID");


                //Ajusto los datos del registro
                QBExternalWorksheetLinesPo."Quantity Invoiced" += QBExternalWorksheetLinesPo."Quantity To Invoice"; //Aumento la cantidad facturada
                QBExternalWorksheetLinesPo.VALIDATE(Invoice, FALSE);          //Desmarco facturar y el documento asociado
                CLEAR(QBExternalWorksheetLinesPo."Apply to Document Type");
                QBExternalWorksheetLinesPo."Apply to Document No" := '';
                QBExternalWorksheetLinesPo.MODIFY;

            UNTIL (QBExternalWorksheetLinesPo.NEXT = 0);
    END;

    /*BEGIN
/*{
      JAV 16/03/22: - QB 1.10.25 Usaba dimensi�n 1 en lugar del c�digo del proyecto

      ver TO-DO
    }
END.*/
}









