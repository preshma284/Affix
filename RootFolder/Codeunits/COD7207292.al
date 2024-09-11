Codeunit 7207292 "Management Line of Measure"
{


    trigger OnRun()
    BEGIN
    END;

    PROCEDURE editMeasureLinePieceworkPRESTO(pCostDatabase: Code[10]; pPiecework: Code[20]; pUse: Option);
    VAR
        MeasureLinePieceworkPRESTO: Record 7207285;
        pgMeasureLinPieceWorkPRESTO: Page 7207372;
    BEGIN
        //Esta funci�n accede a la page de mediciones para unidades del preciario
        MeasureLinePieceworkPRESTO.RESET;
        MeasureLinePieceworkPRESTO.SETRANGE("Cost Database Code", pCostDatabase);
        MeasureLinePieceworkPRESTO.SETRANGE("Cod. Jobs Unit", pPiecework);
        MeasureLinePieceworkPRESTO.SETRANGE(Use, pUse);

        CLEAR(pgMeasureLinPieceWorkPRESTO);
        pgMeasureLinPieceWorkPRESTO.SETTABLEVIEW(MeasureLinePieceworkPRESTO);
        pgMeasureLinPieceWorkPRESTO.RUNMODAL;
    END;

    PROCEDURE editMeasureLinePieceworkCertif(pJob: Code[20]; pPiecework: Code[20]);
    VAR
        MeasureLinePieceworkCertif: Record 7207343;
        pgMeasureLinePieceworkCertif: Page 7207373;
    BEGIN
        //Esta funci�n accede a la page de mediciones para unidades de certificaci�n
        MeasureLinePieceworkCertif.RESET;
        MeasureLinePieceworkCertif.SETRANGE("Job No.", pJob);
        MeasureLinePieceworkCertif.SETRANGE("Piecework Code", pPiecework);

        CLEAR(pgMeasureLinePieceworkCertif);
        pgMeasureLinePieceworkCertif.SETTABLEVIEW(MeasureLinePieceworkCertif);
        pgMeasureLinePieceworkCertif.RUNMODAL;
    END;

    PROCEDURE editMeasurementLinPiecewProd(pJob: Code[20]; pBudget: Code[20]; pPiecework: Code[20]);
    VAR
        MeasurementLinPiecewProd: Record 7207390;
        pgLinMeasurePieceworkProduct: Page 7207555;
    BEGIN
        //Esta funci�n accede a la page de mediciones para unidades de producci�n
        MeasurementLinPiecewProd.RESET;
        MeasurementLinPiecewProd.SETRANGE("Job No.", pJob);
        MeasurementLinPiecewProd.SETRANGE("Piecework Code", pPiecework);
        MeasurementLinPiecewProd.SETRANGE("Code Budget", pBudget);

        CLEAR(pgLinMeasurePieceworkProduct);
        pgLinMeasurePieceworkProduct.SETTABLEVIEW(MeasurementLinPiecewProd);
        pgLinMeasurePieceworkProduct.RUNMODAL;
    END;

    PROCEDURE CopyPRESTO_To_Production(pJob: Code[20]; pCostDatabase: Code[20]; pPiecework: Code[20]; NewPieceworkNo: Code[20]; CodeBudgetJobs: Code[20]);
    VAR
        MeasureLinePieceworkPRESTO: Record 7207285;
        MeasurementLinPiecewProd: Record 7207390;
    BEGIN
        MeasureLinePieceworkPRESTO.RESET;
        MeasureLinePieceworkPRESTO.SETRANGE("Cost Database Code", pCostDatabase);
        MeasureLinePieceworkPRESTO.SETRANGE("Cod. Jobs Unit", pPiecework);
        MeasureLinePieceworkPRESTO.SETRANGE(Use, MeasureLinePieceworkPRESTO.Use::Cost);       //Importar solo l�neas de coste
        IF MeasureLinePieceworkPRESTO.FINDSET(FALSE) THEN
            REPEAT
                MeasurementLinPiecewProd."Job No." := pJob;
                MeasurementLinPiecewProd."Piecework Code" := NewPieceworkNo;
                MeasurementLinPiecewProd."Code Budget" := CodeBudgetJobs;
                MeasurementLinPiecewProd."Line No." := MeasureLinePieceworkPRESTO."Line No.";
                MeasurementLinPiecewProd.Description := MeasureLinePieceworkPRESTO.Description;
                MeasurementLinPiecewProd.Units := MeasureLinePieceworkPRESTO.Units;
                MeasurementLinPiecewProd.Length := MeasureLinePieceworkPRESTO.Length;
                MeasurementLinPiecewProd.Width := MeasureLinePieceworkPRESTO.Width;
                MeasurementLinPiecewProd.Height := MeasureLinePieceworkPRESTO.Height;
                MeasurementLinPiecewProd.Total := MeasureLinePieceworkPRESTO.Total;
                IF NOT MeasurementLinPiecewProd.INSERT(TRUE) THEN
                    MeasurementLinPiecewProd.MODIFY(TRUE);
            UNTIL MeasureLinePieceworkPRESTO.NEXT = 0;
    END;

    PROCEDURE CopyPRESTO_To_Certification(pJob: Code[20]; pCostDatabase: Code[20]; pPiecework: Code[20]; pType: Option "Cost","Sale");
    VAR
        MeasureLinePieceworkPRESTO: Record 7207285;
        MeasureLinePieceworkCertif: Record 7207343;
    BEGIN
        //Q20442 CSM 08/11/23. -
        //Ampliado tama�o del segundo par�metro "pCostDatabase" de 10 a 20.
        //Q20442 CSM 08/11/23. +
        MeasureLinePieceworkPRESTO.RESET;
        MeasureLinePieceworkPRESTO.SETRANGE("Cost Database Code", pCostDatabase);
        MeasureLinePieceworkPRESTO.SETRANGE("Cod. Jobs Unit", pPiecework);
        MeasureLinePieceworkPRESTO.SETRANGE(Use, pType);       //Hay que importar coste o venta
        IF MeasureLinePieceworkPRESTO.FINDSET THEN
            REPEAT
                MeasureLinePieceworkCertif.INIT;
                MeasureLinePieceworkCertif."Job No." := pJob;
                MeasureLinePieceworkCertif."Piecework Code" := MeasureLinePieceworkPRESTO."Cod. Jobs Unit";
                MeasureLinePieceworkCertif."Line No." := MeasureLinePieceworkPRESTO."Line No.";
                MeasureLinePieceworkCertif.Description := MeasureLinePieceworkPRESTO.Description;
                MeasureLinePieceworkCertif.Units := MeasureLinePieceworkPRESTO.Units;
                MeasureLinePieceworkCertif.Length := MeasureLinePieceworkPRESTO.Length;
                MeasureLinePieceworkCertif.Width := MeasureLinePieceworkPRESTO.Width;
                MeasureLinePieceworkCertif.Height := MeasureLinePieceworkPRESTO.Height;
                MeasureLinePieceworkCertif.Total := MeasureLinePieceworkPRESTO.Total;
                IF NOT MeasureLinePieceworkCertif.INSERT(TRUE) THEN
                    MeasureLinePieceworkCertif.MODIFY(TRUE);
            UNTIL MeasureLinePieceworkPRESTO.NEXT = 0;
    END;

    PROCEDURE CopyProduction_To_Certification(pJob: Code[20]; pBudget: Code[20]; pPiecework: Code[20]);
    VAR
        MeasurementLinPiecewProd: Record 7207390;
        MeasureLinePieceworkCertif: Record 7207343;
    BEGIN
        //Copiar l�neas de producci�n a las de venta, siempre que no existan l�neas propias para la venta.
        MeasureLinePieceworkCertif.SETRANGE("Job No.", pJob);
        MeasureLinePieceworkCertif.SETRANGE("Piecework Code", pPiecework);
        IF (NOT MeasureLinePieceworkCertif.ISEMPTY) THEN
            EXIT;

        MeasurementLinPiecewProd.RESET;
        MeasurementLinPiecewProd.SETRANGE("Job No.", pJob);
        MeasurementLinPiecewProd.SETRANGE("Piecework Code", pPiecework);
        MeasurementLinPiecewProd.SETRANGE("Code Budget", pBudget);
        IF MeasurementLinPiecewProd.FINDSET THEN
            REPEAT
                MeasureLinePieceworkCertif.INIT;
                MeasureLinePieceworkCertif."Job No." := pJob;
                MeasureLinePieceworkCertif."Piecework Code" := MeasurementLinPiecewProd."Piecework Code";
                MeasureLinePieceworkCertif."Line No." := MeasurementLinPiecewProd."Line No.";
                MeasureLinePieceworkCertif.Description := MeasurementLinPiecewProd.Description;
                MeasureLinePieceworkCertif.Units := MeasurementLinPiecewProd.Units;
                MeasureLinePieceworkCertif.Length := MeasurementLinPiecewProd.Length;
                MeasureLinePieceworkCertif.Width := MeasurementLinPiecewProd.Width;
                MeasureLinePieceworkCertif.Height := MeasurementLinPiecewProd.Height;
                MeasureLinePieceworkCertif.Total := MeasurementLinPiecewProd.Total;
                MeasureLinePieceworkCertif.INSERT(TRUE);
            UNTIL MeasurementLinPiecewProd.NEXT = 0;
    END;

    PROCEDURE GetLineDescMeasureOrder(parCodeJobs: Code[20]; parPieceworkCode: Code[20]; paropType: Enum "Sales Line Type"; CodeNumDocument: Code[20]; IntNumLine: Integer; CodeBudgetJobs: Code[20]);
    VAR
        locMeasureLinePieceworkCertif: Record 7207343;
        locMeasureLinesBillofItem: Record 7207395;
        locMeasurementLinPiecewProd: Record 7207390;
        locPostMeasLinesBillofItem: Record 7207396;
    BEGIN
        //Carga las lineas de medici�n en un documento

        //Si es medici�n o certificaci�n
        IF (paropType = paropType::Measuring) OR (paropType = paropType::Certification) THEN BEGIN
            //Cargo las que est�n en la unidad de venta
            locMeasureLinePieceworkCertif.RESET;
            locMeasureLinePieceworkCertif.SETRANGE("Job No.", parCodeJobs);
            locMeasureLinePieceworkCertif.SETRANGE("Piecework Code", parPieceworkCode);
            IF locMeasureLinePieceworkCertif.FINDSET(FALSE) THEN
                REPEAT
                    locMeasureLinesBillofItem."Document Type" := paropType;
                    locMeasureLinesBillofItem."Document No." := CodeNumDocument;
                    locMeasureLinesBillofItem."Line No." := IntNumLine;
                    locMeasureLinesBillofItem."Piecework Code" := locMeasureLinePieceworkCertif."Piecework Code";
                    locMeasureLinesBillofItem."Bill of Item No Line" := locMeasureLinePieceworkCertif."Line No.";
                    locMeasureLinesBillofItem.Description := locMeasureLinePieceworkCertif.Description;
                    locMeasureLinesBillofItem."Budget Units" := locMeasureLinePieceworkCertif.Units;
                    locMeasureLinesBillofItem."Budget Length" := locMeasureLinePieceworkCertif.Length;
                    locMeasureLinesBillofItem."Budget Width" := locMeasureLinePieceworkCertif.Width;
                    locMeasureLinesBillofItem."Budget Height" := locMeasureLinePieceworkCertif.Height;
                    locMeasureLinesBillofItem."Budget Total" := locMeasureLinePieceworkCertif.Total;
                    locMeasureLinesBillofItem."Job No." := parCodeJobs;
                    IF NOT locMeasureLinesBillofItem.INSERT(TRUE) THEN;

                    locMeasureLinesBillofItem.CALCFIELDS("Realized Units", "Realized Total");
                    locMeasureLinesBillofItem."Measured Total" := locMeasureLinesBillofItem."Realized Total";
                    //JAV 23/09/19: - Se tratan las unidades a origen y los datos del periodo en las l�neas de medici�n
                    CalculateUnits(locMeasureLinesBillofItem."Measured Units", locMeasureLinesBillofItem."Budget Length",
                                   locMeasureLinesBillofItem."Budget Width", locMeasureLinesBillofItem."Budget Height",
                                   locMeasureLinesBillofItem."Measured Total");
                    locMeasureLinesBillofItem.VALIDATE("Measured Units");
                    //locMeasureLinesBillofItem.UpdatePeriod;
                    //JAV fin
                    locMeasureLinesBillofItem.MODIFY(TRUE);

                UNTIL (locMeasureLinePieceworkCertif.NEXT = 0);
        END;


        IF (paropType = paropType::"Valued Relationship") THEN BEGIN
            locMeasurementLinPiecewProd.RESET;
            locMeasurementLinPiecewProd.SETRANGE("Job No.", parCodeJobs);
            locMeasurementLinPiecewProd.SETRANGE("Piecework Code", parPieceworkCode);
            locMeasurementLinPiecewProd.SETRANGE("Code Budget", CodeBudgetJobs);
            IF locMeasurementLinPiecewProd.FINDSET(FALSE) THEN
                REPEAT
                    locMeasureLinesBillofItem."Document Type" := paropType;
                    locMeasureLinesBillofItem."Document No." := CodeNumDocument;
                    locMeasureLinesBillofItem."Line No." := IntNumLine;
                    locMeasureLinesBillofItem."Piecework Code" := locMeasurementLinPiecewProd."Piecework Code";
                    locMeasureLinesBillofItem."Bill of Item No Line" := locMeasurementLinPiecewProd."Line No.";
                    locMeasureLinesBillofItem.Description := locMeasurementLinPiecewProd.Description;
                    locMeasureLinesBillofItem."Budget Units" := locMeasurementLinPiecewProd.Units;
                    locMeasureLinesBillofItem."Budget Length" := locMeasurementLinPiecewProd.Length;
                    locMeasureLinesBillofItem."Budget Width" := locMeasurementLinPiecewProd.Width;
                    locMeasureLinesBillofItem."Budget Height" := locMeasurementLinPiecewProd.Height;
                    locMeasureLinesBillofItem."Budget Total" := locMeasurementLinPiecewProd.Total;
                    locMeasureLinesBillofItem."Job No." := parCodeJobs;
                    IF NOT locMeasureLinesBillofItem.INSERT(TRUE) THEN;

                    locMeasureLinesBillofItem.CALCFIELDS("Realized Units", "Realized Total");
                    locMeasureLinesBillofItem."Measured Total" := locMeasureLinesBillofItem."Realized Total";
                    //JAV 23/09/19: - Se tratan las unidades a origen y los datos del periodo en las l�neas de medici�n
                    CalculateUnits(locMeasureLinesBillofItem."Measured Units", locMeasureLinesBillofItem."Budget Length",
                                    locMeasureLinesBillofItem."Budget Width", locMeasureLinesBillofItem."Budget Height",
                                    locMeasureLinesBillofItem."Measured Total");
                    locMeasureLinesBillofItem.VALIDATE("Measured Units");
                    //locMeasureLinesBillofItem.UpdatePeriod;
                    //JAV fin
                    locMeasureLinesBillofItem.MODIFY(TRUE);
                UNTIL locMeasurementLinPiecewProd.NEXT = 0;
        END;

        IF (paropType = paropType::Reestimation) THEN BEGIN
            locMeasurementLinPiecewProd.RESET;
            locMeasurementLinPiecewProd.SETRANGE("Job No.", parCodeJobs);
            locMeasurementLinPiecewProd.SETRANGE("Piecework Code", parPieceworkCode);
            locMeasurementLinPiecewProd.SETRANGE("Code Budget", CodeBudgetJobs);
            IF locMeasurementLinPiecewProd.FINDSET(FALSE) THEN
                REPEAT
                    locMeasureLinesBillofItem."Document Type" := paropType;
                    locMeasureLinesBillofItem."Document No." := CodeNumDocument;
                    locMeasureLinesBillofItem."Line No." := IntNumLine;
                    locMeasureLinesBillofItem."Piecework Code" := locMeasurementLinPiecewProd."Piecework Code";
                    locMeasureLinesBillofItem."Bill of Item No Line" := locMeasurementLinPiecewProd."Line No.";
                    locMeasureLinesBillofItem.Description := locMeasurementLinPiecewProd.Description;
                    locMeasureLinesBillofItem."Budget Units" := locMeasurementLinPiecewProd.Units;
                    locMeasureLinesBillofItem."Budget Length" := locMeasurementLinPiecewProd.Length;
                    locMeasureLinesBillofItem."Budget Width" := locMeasurementLinPiecewProd.Width;
                    locMeasureLinesBillofItem."Budget Height" := locMeasurementLinPiecewProd.Height;
                    locMeasureLinesBillofItem."Budget Total" := locMeasurementLinPiecewProd.Total;
                    locMeasureLinesBillofItem."Job No." := parCodeJobs;
                    IF NOT locMeasureLinesBillofItem.INSERT(TRUE) THEN;

                    locMeasureLinesBillofItem.CALCFIELDS("Realized Units", "Realized Total");
                    locMeasureLinesBillofItem."Measured Units" := 0;
                    locMeasureLinesBillofItem."Measured Total" := locMeasurementLinPiecewProd.Total - locMeasureLinesBillofItem."Realized Total";
                    //JAV 23/09/19: - Se tratan las unidades a origen y los datos del periodo en las l�neas de medici�n
                    CalculateUnits(locMeasureLinesBillofItem."Measured Units", locMeasureLinesBillofItem."Budget Length",
                                   locMeasureLinesBillofItem."Budget Width", locMeasureLinesBillofItem."Budget Height",
                                   locMeasureLinesBillofItem."Measured Total");
                    locMeasureLinesBillofItem.VALIDATE("Measured Units", locMeasureLinesBillofItem."Realized Units");
                    //locMeasureLinesBillofItem.UpdatePeriod;
                    //JAV fin
                    locMeasureLinesBillofItem.MODIFY(TRUE);
                UNTIL locMeasurementLinPiecewProd.NEXT = 0;
        END;
    END;

    // PROCEDURE ConfirmBillofItemMeasure(VAR MeasureSource: Decimal; VAR MeasureTerm: Decimal; VAR Confirmed: Boolean; OptionType: Option "Measure","Certification","Values Relation","Reassessment"; CodeNumDocument: Code[20]; IntNumLine: Integer);
    PROCEDURE ConfirmBillofItemMeasure(VAR MeasureSource: Decimal; VAR MeasureTerm: Decimal; VAR Confirmed: Boolean; OptionType: Enum "Sales Line Type"; CodeNumDocument: Code[20]; IntNumLine: Integer);
    VAR
        DecMeasureMade: Decimal;
        locrecMeasureLinesBillofItem: Record 7207395;
        locdecRealizedMeasure: Decimal;
        pageReesMeasureLinesBillofItem: Page 7207382;
        pageMeasureLinesBillofItem: Page 7207374;
    BEGIN
        //JAV 17/09/19: - Se simplifica la funci�n ConfirmBillofItemMeasure

        //CLEAR(pageMeasureLinesBillofItem);
        MeasureSource := 0;
        MeasureTerm := 0;
        //Confirmed := FALSE;
        locrecMeasureLinesBillofItem.RESET;
        locrecMeasureLinesBillofItem.SETRANGE("Document Type", OptionType);
        locrecMeasureLinesBillofItem.SETRANGE("Document No.", CodeNumDocument);
        locrecMeasureLinesBillofItem.SETRANGE("Line No.", IntNumLine);

        IF OptionType <> OptionType::Reassessment THEN BEGIN
            CLEAR(pageMeasureLinesBillofItem);
            pageMeasureLinesBillofItem.LOOKUPMODE := TRUE;
            pageMeasureLinesBillofItem.SETTABLEVIEW(locrecMeasureLinesBillofItem);
            Confirmed := (pageMeasureLinesBillofItem.RUNMODAL = ACTION::LookupOK);
        END ELSE BEGIN
            CLEAR(pageReesMeasureLinesBillofItem);
            pageReesMeasureLinesBillofItem.SETTABLEVIEW(locrecMeasureLinesBillofItem);
            pageReesMeasureLinesBillofItem.LOOKUPMODE := TRUE;
            Confirmed := (pageReesMeasureLinesBillofItem.RUNMODAL = ACTION::LookupOK);
        END;
        Confirmed := Confirmed AND (locrecMeasureLinesBillofItem.FINDFIRST);
        IF (Confirmed) THEN
            locrecMeasureLinesBillofItem.CalculateData(MeasureSource, MeasureTerm, locdecRealizedMeasure, OptionType, CodeNumDocument, IntNumLine);
    END;

    PROCEDURE CopyLinMeasurePOPD(OriginJob: Code[20]; OriginJobBudget: Code[20]; OriginPiecework: Code[20]; DestinationJob: Code[20]; DestinationJobBudget: Code[20]; DestinationPiecework: Code[20]);
    VAR
        MeasurementLinPiecewProdOri: Record 7207390;
        MeasurementLinPiecewProdDes: Record 7207390;
    BEGIN
        //JAV 11/04/19: La funcion estaba mal definida. Se cambian los par�metros por unos correcto y se cambia el findset
        MeasurementLinPiecewProdOri.SETRANGE("Job No.", OriginJob); //JAV estaba mal
        MeasurementLinPiecewProdOri.SETRANGE("Piecework Code", OriginPiecework); //jmma
        MeasurementLinPiecewProdOri.SETRANGE("Code Budget", OriginJobBudget);
        IF MeasurementLinPiecewProdOri.FINDSET(FALSE) THEN
            REPEAT
                MeasurementLinPiecewProdDes := MeasurementLinPiecewProdOri;
                MeasurementLinPiecewProdDes."Job No." := DestinationJob;
                MeasurementLinPiecewProdDes."Piecework Code" := DestinationPiecework; //jmma
                MeasurementLinPiecewProdDes."Code Budget" := DestinationJobBudget; //JAV estaba mal
                MeasurementLinPiecewProdDes.INSERT(TRUE);
            UNTIL MeasurementLinPiecewProdOri.NEXT = 0;
    END;

    PROCEDURE "GetLinMeasureCertif/Prod"(CodeJobs: Code[20]; CodeJobsUnits: Code[20]; CodeJUDestination: Code[20]);
    VAR
        Job: Record 167;
    BEGIN
    END;

    PROCEDURE BringMeasuresToDetails(MeasurementLines: Record 7207337);
    VAR
        MeasureLinesBillofItem: Record 7207395;
    BEGIN
        MeasureLinesBillofItem.RESET;
        MeasureLinesBillofItem.SETRANGE("Document No.", MeasurementLines."Document No.");
        MeasureLinesBillofItem.SETRANGE("Job No.", MeasurementLines."Job No.");
        MeasureLinesBillofItem.SETRANGE("Piecework Code", MeasurementLines."Piecework No.");
        IF MeasureLinesBillofItem.FINDFIRST THEN BEGIN
            REPEAT
                MeasureLinesBillofItem.VALIDATE("Measured Units", (MeasurementLines."Med. % Measure" * MeasureLinesBillofItem."Measured Units") / 100);
                MeasureLinesBillofItem.MODIFY(TRUE);
            UNTIL MeasureLinesBillofItem.NEXT = 0;
        END;
        COMMIT;
    END;

    PROCEDURE CalculateTotal(Units: Decimal; Length: Decimal; Width: Decimal; Height: Decimal; VAR Total: Decimal);
    BEGIN
        //JAV 13/03/19: - Funci�n para calcular los totales de una medici�n
        Total := Units;
        IF (Length <> 0) THEN
            Total *= Length;
        IF (Width <> 0) THEN
            Total *= Width;
        IF (Height <> 0) THEN
            Total *= Height;

        //Q19159 CSM 04/05/23. Detalle l�neas medici�n con dato real y no �promediar�. -
        /*{
              //Q19159 CSM 04/05/23. Detalle l�neas medici�n con dato real y no �promediar�. +
              Total := ROUND(Total, 0.01);
              //Q19159 CSM 04/05/23. Detalle l�neas medici�n con dato real y no �promediar�. -
              }*/

        Total := ROUND(Total, 0.000001);
        //Q19159 CSM 04/05/23. Detalle l�neas medici�n con dato real y no �promediar�. +
    END;

    PROCEDURE CalculateUnits(VAR Units: Decimal; Length: Decimal; Width: Decimal; Height: Decimal; Total: Decimal);
    BEGIN
        //JAV 13/03/19: - Funci�n para calcular las unidades a partir del total de una medici�n
        Units := Total;
        IF (Length <> 0) THEN
            Units /= Length;
        IF (Width <> 0) THEN
            Units /= Width;
        IF (Height <> 0) THEN
            Units /= Height;

        //Q19159 CSM 04/05/23. Detalle l�neas medici�n con dato real y no �promediar�.-
        /*{
              //Q19159 CSM 04/05/23. Detalle l�neas medici�n con dato real y no �promediar�. +
              Units := ROUND(Units, 0.01);
              //Q19159 CSM 04/05/23. Detalle l�neas medici�n con dato real y no �promediar�. -
              }*/

        Units := ROUND(Units, 0.000001);
        //Q19159 CSM 04/05/23. Detalle l�neas medici�n con dato real y no �promediar�. +
    END;

    /*BEGIN
/*{
      PEL 02/11/18:  - 001
      JAV 13/03/19:  - Se cambia el proceso LinesMeasureProduction para hacer llamadas a dos funciones y se eliminan repeticiones
                     - Nueva funci�n LinesMeasureProductionInit para preparar los datos
                     - Nueva funci�n LinesMeasureProductionSave para guardar los datos
                     - Nueva funci�n LinesMeasureProductionCalc para calcular totales
      JMMA 27/03/19: - Se arreglan variales en la funci�n CopyLinMeasurePOPD
      JAV 02/04/19:  - Se elimina repetici�n en las funciones LineMeasureCertification y LinesMeasureProduction
      JAV 04/04/19:  - Se corrige un error si no hay datos anteriores al guardar la medici�n total
      JAV 11/04/19:  - La funcion CopyLinMeasurePOPD estaba mal definida. Se cambian los par�metros por unos correcto y se cambia el findset
      JAV 16/09/19:  - Se unifica en una funci�n el c�lculo del total de la medici�n
      JAV 17/09/19:  - Se simplifica la funci�n ConfirmBillofItemMeasure
      JAV 23/09/19:  - Se tratan las unidades a origen y los datos del periodo en las l�neas de medici�n
      Q19159 CSM 04/05/23. Detalle l�neas medici�n con dato real y no �promediar�.
      Q20442 CSM 08/11/23.
    }
END.*/
}







