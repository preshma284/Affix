Codeunit 7207287 "Quobuilding-Initialize"
{


    trigger OnRun()
    BEGIN
        InitQB;
    END;

    VAR
        QuoBuildingSetup: Record 7207278;
        PurchasesPayablesSetup: Record 312;
        PieceworkSetup: Record 7207279;
        RentalElementsSetup: Record 7207346;
        Dimension: Record 348;
        "--- Dimensiones": TextConst;
        tDim00: TextConst ENU = 'Code', ESP = 'C¢digo';
        tDim01: TextConst ENU = 'Filter', ESP = 'Filtro';
        tDimDEP: TextConst ENU = 'DEPARTAMENT', ESP = 'DEPARTAMENTO';
        tDimDEPdes: TextConst ENU = 'Departament', ESP = 'Departamento';
        tDimCA: TextConst ENU = 'AC', ESP = 'CA';
        tDimCAdes: TextConst ENU = 'Analytical concept', ESP = 'Concepto anal¡tico';
        tDimPRO: TextConst ENU = 'JOB', ESP = 'PROYECTO';
        tDimPROdes: TextConst ENU = 'Job', ESP = 'Proyecto';
        tDimEST: TextConst ESP = 'ESTUDIO';
        tDimESTdes: TextConst ESP = 'Estudio';
        tDimREE: TextConst ENU = 'REESTIMATION', ESP = 'REESTIMACI�N';
        tDimREEdes: TextConst ENU = 'Reestimation', ESP = 'Reestimaci¢n';
        tDimUTE: TextConst ESP = 'UTE';
        tDimUTEdes: TextConst ESP = 'U.T.E.';
        tDimQPR: TextConst ESP = 'PRES_DEP';
        tDimQPRdes: TextConst ESP = 'Presupuestos por CECO';
        "--- Mensajes": TextConst;
        Txt000: TextConst ESP = 'Recuerde ir a Configuraci¢n de Contabilidad y establecer las dimensiones';
        SourceCodeSetup: Record 242;
        SourceCode: Record 230;
        Txt001: TextConst ESP = 'General,Reestimaci¢n,Alquiler,UTE,Reestimaci¢n + Alquiler,Reestimaci¢n + UTE,Alquiler + UTE,Reestimaci¢n + Alquiler + UTE';
        GLBudgetName: Record 95;
        AnalysisView: Record 363;
        AccScheduleName: Record 84;
        AccScheduleLine: Record 85;
        ColumnLayoutName: Record 333;
        ColumnLayout: Record 334;
        NoSeries: Record 308;
        NoSeriesLine: Record 309;
        JobPostingGroup: Record 208;
        Opcion: Integer;
        opcReestimacion: Boolean;
        opcUTE: Boolean;
        opcAlquiler: Boolean;
        "--- Varios": TextConst;
        codEXP: TextConst ESP = 'EXPEDIENTE';
        codINI: TextConst ESP = 'MASTER-00';
        codEST: TextConst ESP = 'ESTUDIO';
        codGRP: TextConst ESP = 'PROYECTOS';
        codGRPdes: TextConst ESP = 'Proyectos QuoBuilding';
        "--- Financiero": TextConst;
        finEST: TextConst ENU = 'JOB', ESP = 'ESTUDIOS';
        finESTdes: TextConst ENU = 'Job Budget', ESP = 'Presupuesto para estudios';
        finPRJ: TextConst ESP = 'PROYECTOS';
        finPRJdes: TextConst ESP = 'Presupuesto para proyectos';
        finVAJ: TextConst ESP = 'PROYECTOS';
        finVAJdes: TextConst ENU = 'Job View', ESP = 'Vista para proyectos';
        finVAE: TextConst ESP = 'ESTUDIOS';
        finVAEdes: TextConst ENU = 'Job View', ESP = 'Vista para estudios';
        finESQ: TextConst ESP = 'ANA-OBRA';
        finESQdes: TextConst ENU = 'Job Budget', ESP = 'An lisis de Obra';
        finESQCOL: TextConst ESP = 'COL_OBRA';
        finESQCOLdes: TextConst ENU = 'Job Budget', ESP = 'Columnas para Obras';
        cnt: Integer;
        "--- Contadores ----------------": TextConst;
        cntPRO: TextConst ESP = 'QB_PROYECT';
        cntPROdes: TextConst ESP = 'QB Proyectos';
        cntPROcnt: TextConst ESP = 'PRY';
        cntEST: TextConst ESP = 'QB_ESTUDIO';
        cntESTdes: TextConst ESP = 'QB Estudios';
        cntESTcnt: TextConst ESP = 'EST';
        cntPRE: TextConst ESP = 'QB_PRECIAR';
        cntPREdes: TextConst ESP = 'QB Preciarios';
        cntPREcnt: TextConst ESP = 'PRE';
        cntMED: TextConst ESP = 'QB_MEDIC';
        cntMEDdes: TextConst ESP = 'QB Mediciones';
        cntMEDcnt: TextConst ESP = 'MED';
        cntMDR: TextConst ESP = 'QB_MEDIC+';
        cntMDRdes: TextConst ESP = 'QB Mediciones Registradas';
        cntMDRcnt: TextConst ESP = 'MDR';
        cntREE: TextConst ESP = 'QB_REEST';
        cntREEdes: TextConst ESP = 'QB Reestimaciones';
        cntREEcnt: TextConst ESP = 'REE';
        cntREG: TextConst ESP = 'QB_REEST+';
        cntREGdes: TextConst ESP = 'QB Reestimaciones Registradas';
        cntREGcnt: TextConst ESP = 'REG';
        cntPIN: TextConst ESP = 'QB_PTEIND';
        cntPINdes: TextConst ESP = 'QB Parte indirectos';
        cntPINcnt: TextConst ESP = 'PIN';
        cntPIR: TextConst ESP = 'QB_PTEIND+';
        cntPIRdes: TextConst ESP = 'QB Parte indirectos Registrados';
        cntPIRcnt: TextConst ESP = 'PIR';
        cntEXP: TextConst ESP = 'QB_EXPDTE';
        cntEXPdes: TextConst ESP = 'QB Expedientes';
        cntEXPcnt: TextConst ESP = 'EXP';
        cntALS: TextConst ESP = 'QB_ALBSALI';
        cntALSdes: TextConst ESP = 'QB Albaranes de Salida';
        cntALScnt: TextConst ESP = 'ALS';
        cntRGS: TextConst ESP = 'QB_RSTOCK';
        cntRGSdes: TextConst ESP = 'QB Regularización Stock';
        cntRGScnt: TextConst ESP = 'RGS';
        cntTRS: TextConst ESP = 'QB_TRASPA';
        cntTRSdes: TextConst ESP = 'QB Traspasos entre proyectos';
        cntTRScnt: TextConst ESP = 'TRS';
        cntTRR: TextConst ESP = 'QB_TRASPA+';
        cntTRRdes: TextConst ESP = 'QB Traspasos entre proyectos registrados';
        cntTRRcnt: TextConst ESP = 'TRR';
        cntHHO: TextConst ESP = 'QB_HORAS';
        cntHHOdes: TextConst ESP = 'QB Hojas de horas de trabajadores';
        cntHHOcnt: TextConst ESP = 'HHO';
        cntHHR: TextConst ESP = 'QB_HORAS+';
        cntHHRdes: TextConst ESP = 'QB Hojas de horas de trabajadores registradas';
        cntHHRcnt: TextConst ESP = 'HHR';
        cntMEN: TextConst ESP = 'QB_MEDCER';
        cntMENdes: TextConst ESP = 'QB Mediciones';
        cntMENcnt: TextConst ESP = 'MDC';
        cntMER: TextConst ESP = 'QB_MEDCER+';
        cntMERdes: TextConst ESP = 'QB Mediciones registradas';
        cntMERcnt: TextConst ESP = 'MDR';
        cntCRT: TextConst ESP = 'QB_CERTIF';
        cntCRTdes: TextConst ESP = 'QB Certificaciones';
        cntCRTcnt: TextConst ESP = 'CRT';
        cntCRR: TextConst ESP = 'QB_CERTIF+';
        cntCRRdes: TextConst ESP = 'QB Certificaciones registradas';
        cntCRRcnt: TextConst ESP = 'CRR';
        cntQPR: TextConst ESP = 'QPR';
        cntQPRdes: TextConst ESP = 'QPR Presupuestos';
        cntQPRcnt: TextConst ESP = 'PRE';
        "--- Codigos Origen": TextConst;
        Text069: TextConst ENU = 'WORKSHEET', ESP = 'PARTES';
        Text070: TextConst ENU = 'Worksheet', ESP = 'Partes de trabajo';
        Text071: TextConst ENU = 'PRODUCTIONJOURNAL', ESP = 'DIAPRODUCC';
        Text072: TextConst ENU = 'Production Journal', ESP = 'Diario de producci¢n';
        Text073: TextConst ENU = 'REGULARIZE', ESP = 'REGULARIZA';
        Text074: TextConst ENU = 'Stock Regularization', ESP = 'Regularizaci¢n de stocks';
        Text075: TextConst ENU = 'OUTPUTSHIPMENTJOB', ESP = 'ALBSALPROY';
        Text076: TextConst ENU = 'Output Shipment to Job', ESP = 'Albaranes de salida a proyectos';
        Text077: TextConst ENU = 'MED AND CER', ESP = 'MEDYCER';
        Text078: TextConst ENU = 'Measure and certification', ESP = 'Certificaciones y mediciones';
        Text079: TextConst ENU = 'MEASUREPRODUCTION', ESP = 'MEDPRODUCC';
        Text080: TextConst ESP = 'Mediciones de producci¢n';
        Text081: TextConst ENU = 'JOURNALNEEDSPURCHASE', ESP = 'DIANECCOM';
        Text082: TextConst ENU = 'Journal needs purchase', ESP = 'Diario de necesidades de compra';
        Text083: TextConst ENU = 'WITHRELE', ESP = 'DIARET';
        Text084: TextConst ENU = 'Withholding Releasing', ESP = 'Diario de retenciones';
        Text085: TextConst ENU = 'REESTIMATION', ESP = 'REESTIMACI';
        Text086: TextConst ENU = 'Reestimations', ESP = 'Reestimaciones';
        Text087: TextConst ENU = 'EXPENSENOTE', ESP = 'NOTASGASTO';
        Text088: TextConst ENU = 'Expense Notes', ESP = 'Notas de Gasto';
        Text089: TextConst ENU = 'COMPARATIVEQUOTES', ESP = 'COMPOFERTA';
        Text090: TextConst ENU = 'Comparative Quotes', ESP = 'Comparativo de Ofertas';

    PROCEDURE InitQB();
    BEGIN
        //---------------------------------------------------------------------------------------------------------
        // Inicializamos las tablas de configuraci¢n de QB y asocio valores por defecto
        //---------------------------------------------------------------------------------------------------------

        Opcion := STRMENU(Txt001);
        IF (Opcion = 0) THEN
            EXIT;

        //1=General,  2=Reestimaci¢n,  3=Alquiler,  4=UTE,  5=Reestimaci¢n + Alquiler,  6=Reestimaci¢n + UTE,  7=Alquiler + UTE,   8=Reestimaci¢n + Alquiler + UTE
        opcReestimacion := Opcion IN [2, 5, 6, 8];
        opcAlquiler := Opcion IN [3, 5, 7, 8];
        opcUTE := Opcion IN [4, 6, 7, 8];

        //Datos de base
        IF NOT QuoBuildingSetup.GET THEN
            QuoBuildingSetup.INSERT;
        QuoBuildingSetup.Quobuilding := TRUE;
        QuoBuildingSetup.Reestimates := opcReestimacion;
        QuoBuildingSetup."QW Withholding" := TRUE;
        QuoBuildingSetup."Rental Management" := opcAlquiler;
        QuoBuildingSetup.MODIFY;

        //Ahora vamos a crear las dimensiones que necesitamos
        QuoBuildingSetup.GET;
        InsertDim(QuoBuildingSetup."Dimension for Dpto Code", tDimDEP, tDimDEPdes);   //Departamento
        InsertDim(QuoBuildingSetup."Dimension for CA Code", tDimCA, tDimCAdes);       //CA
        InsertDim(QuoBuildingSetup."Dimension for Jobs Code", tDimPRO, tDimPROdes);   //Proyecto
        InsertDim(QuoBuildingSetup."Dimension for Quotes", tDimEST, tDimESTdes);      //Estudio
        IF opcReestimacion THEN           //Reestimaci¢n
            InsertDim(QuoBuildingSetup."Dimension for Reestim. Code", tDimREE, tDimREEdes);
        IF opcUTE THEN                    //UTE
            InsertDim(QuoBuildingSetup."Dimension for JV Code", tDimUTE, tDimUTEdes);

        //Grupo registro de proyecto
        InsertGrRegPro(QuoBuildingSetup."Default Job Posting Group");

        //Otros valores importantes
        QuoBuildingSetup."Create Location Equal To Proj." := TRUE;
        IF QuoBuildingSetup."Initial Record Code" = '' THEN QuoBuildingSetup."Initial Record Code" := codEXP;
        IF QuoBuildingSetup."Initial Budget Code" = '' THEN QuoBuildingSetup."Initial Budget Code" := codINI;
        IF QuoBuildingSetup."Quote Budget Code" = '' THEN QuoBuildingSetup."Quote Budget Code" := QuoBuildingSetup."Dimension for Quotes";
        QuoBuildingSetup.MODIFY(TRUE);

        //Conf. Unidades de Obra
        IF NOT PieceworkSetup.GET THEN
            PieceworkSetup.INSERT;

        InsertSeriesOne(PieceworkSetup."Series Certification No.", cntMEN, cntMENdes, cntMENcnt);
        InsertSeriesOne(PieceworkSetup."Series Hist. Certification No.", cntMER, cntMERdes, cntMERcnt);
        InsertSeriesOne(PieceworkSetup."Series Measure No.", cntCRT, cntCRTdes, cntCRTcnt);
        InsertSeriesOne(PieceworkSetup."Series Hist. Measure No.", cntCRR, cntCRRdes, cntCRRcnt);
        PieceworkSetup.MODIFY(TRUE);

        //Conf. Alquiler
        IF NOT RentalElementsSetup.GET THEN
            RentalElementsSetup.INSERT;

        //Resto de configuraciones
        InserGL;        //Valores de financiero
        InsertSeries;   //Contadores
        InsertDiarios;  //Diarios y secciones

        //Mensaje final
        COMMIT;
        MESSAGE(Txt000);

        //Creamos los c¢d. de origen que va a usar
        IF SourceCodeSetup.GET THEN;
        InsertSourceCode(SourceCodeSetup.WorkSheet, Text069, Text070);
        InsertSourceCode(SourceCodeSetup."Production Journal", Text071, Text072);
        InsertSourceCode(SourceCodeSetup."Stock Regularization", Text073, Text074);
        InsertSourceCode(SourceCodeSetup."Output Shipment to Job", Text075, Text076);
        InsertSourceCode(SourceCodeSetup."Measurements and Certif.", Text077, Text078);
        InsertSourceCode(SourceCodeSetup."Prod. Measuring", Text079, Text080);
        InsertSourceCode(SourceCodeSetup."Purchase Needs Journal", Text081, Text082);
        InsertSourceCode(SourceCodeSetup."QW Withholding Releasing", Text083, Text084);
        IF opcReestimacion THEN
            InsertSourceCode(SourceCodeSetup.Reestimation, Text085, Text086);
        InsertSourceCode(SourceCodeSetup."Expense Notes", Text087, Text088);
        InsertSourceCode(SourceCodeSetup."Comparative Quote", Text089, Text090);
        SourceCodeSetup.MODIFY(TRUE);
    END;

    PROCEDURE InitQPR();
    BEGIN
        ///////////////////////////////////////////////////////////////////////////////////////////////////////////
        // Inicializamos las tablas de configuraci¢n de QPR y asocio valores por defecto
        ///////////////////////////////////////////////////////////////////////////////////////////////////////////

        IF (NOT CONFIRM('¨Desea inicializar Presupuestos?')) THEN
            EXIT;

        //Datos de base
        IF NOT QuoBuildingSetup.GET THEN
            QuoBuildingSetup.INSERT;
        QuoBuildingSetup."QPR Budgets" := TRUE;
        QuoBuildingSetup.MODIFY;

        //Ahora vamos a crear las dimensiones que necesitamos
        QuoBuildingSetup.GET;
        InsertDim(QuoBuildingSetup."QPR Dimension for Budget", tDimQPR, tDimQPRdes);      //Presupuestos
        QuoBuildingSetup.MODIFY(TRUE);

        //Contadores
        InsertSeriesOne(QuoBuildingSetup."QPR Serie for Budgets", cntQPR, cntQPRdes, cntQPRcnt);
        QuoBuildingSetup.MODIFY(TRUE);

        //Mensaje final
        COMMIT;
        MESSAGE(Txt000);
    END;

    LOCAL PROCEDURE InsertSourceCode(VAR Value: Code[10]; Code: Code[10]; Description: Text[50]);
    BEGIN
        IF (Value = '') THEN
            Value := Code;

        SourceCode.INIT;
        SourceCode.Code := Value;
        SourceCode.Description := Description;
        IF SourceCode.INSERT THEN;
    END;

    LOCAL PROCEDURE InsertDim(VAR Value: Code[20]; pCode: Text; pName: Text);
    BEGIN
        IF (Value = '') THEN
            Value := pCode;

        Dimension.INIT;
        Dimension.Code := Value;
        Dimension.Name := COPYSTR(pName, 1, MAXSTRLEN(Dimension.Name)); //JAV 11/04/22: - QB 1.10.35 Limitar la longitud para que no de error
        Dimension."Code Caption" := tDim00 + pName;
        Dimension."Filter Caption" := tDim01 + pName;
        Dimension.Description := pName;
        IF NOT Dimension.INSERT(TRUE) THEN
            Dimension.MODIFY(TRUE);
    END;

    LOCAL PROCEDURE InserGL();
    BEGIN
        QuoBuildingSetup.GET;
        IF QuoBuildingSetup."Budget for Jobs" = '' THEN QuoBuildingSetup."Budget for Jobs" := finPRJ;           // Presupuesto para proyectos
        IF QuoBuildingSetup."Budget for Quotes" = '' THEN QuoBuildingSetup."Budget for Quotes" := finEST;         // Presupuesto para estudios
        IF QuoBuildingSetup."Analysis View for Job" = '' THEN QuoBuildingSetup."Analysis View for Job" := finVAJ;     // Cod. vista anal¡sis
        IF QuoBuildingSetup."Analysis View for Quotes" = '' THEN QuoBuildingSetup."Analysis View for Quotes" := finVAE;  // Cod. vista anal¡sis
        IF QuoBuildingSetup."Acc. Sched. Name for Job" = '' THEN QuoBuildingSetup."Acc. Sched. Name for Job" := finESQ;  // Nombre cta. esq. ctas.
        QuoBuildingSetup.MODIFY(TRUE);

        //Nos creamos los presupuestos contables
        IF NOT GLBudgetName.GET(QuoBuildingSetup."Budget for Quotes") THEN BEGIN
            GLBudgetName.INIT;
            GLBudgetName.Name := QuoBuildingSetup."Budget for Quotes";
            GLBudgetName.Description := finESTdes;
            GLBudgetName.Blocked := FALSE;
            GLBudgetName."Budget Dimension 1 Code" := QuoBuildingSetup."Dimension for Quotes";
            IF opcReestimacion THEN
                GLBudgetName."Budget Dimension 2 Code" := QuoBuildingSetup."Dimension for Reestim. Code";
            GLBudgetName.INSERT;
        END;
        IF NOT GLBudgetName.GET(QuoBuildingSetup."Budget for Jobs") THEN BEGIN
            GLBudgetName.INIT;
            GLBudgetName.Name := QuoBuildingSetup."Budget for Jobs";
            GLBudgetName.Description := finPRJdes;
            GLBudgetName.Blocked := FALSE;
            GLBudgetName."Budget Dimension 1 Code" := QuoBuildingSetup."Dimension for Jobs Code";
            IF opcReestimacion THEN
                GLBudgetName."Budget Dimension 2 Code" := QuoBuildingSetup."Dimension for Reestim. Code";
            GLBudgetName.INSERT;
        END;

        //Nos creamos la vista de an lisis
        IF NOT AnalysisView.GET(QuoBuildingSetup."Analysis View for Job") THEN BEGIN
            AnalysisView.INIT;
            AnalysisView.Code := QuoBuildingSetup."Analysis View for Job";
            AnalysisView.Name := finVAJdes;
            AnalysisView."Include Budgets" := TRUE;
            AnalysisView."Update on Posting" := TRUE;
            AnalysisView."Dimension 1 Code" := QuoBuildingSetup."Dimension for Dpto Code";
            AnalysisView."Dimension 2 Code" := QuoBuildingSetup."Dimension for CA Code";
            AnalysisView."Dimension 3 Code" := QuoBuildingSetup."Dimension for Jobs Code";
            IF opcReestimacion THEN
                AnalysisView."Dimension 4 Code" := QuoBuildingSetup."Dimension for Reestim. Code";
            AnalysisView.INSERT(TRUE);
        END;

        IF NOT AnalysisView.GET(QuoBuildingSetup."Analysis View for Quotes") THEN BEGIN
            AnalysisView.INIT;
            AnalysisView.Code := QuoBuildingSetup."Analysis View for Quotes";
            AnalysisView.Name := finVAEdes;
            AnalysisView."Include Budgets" := TRUE;
            AnalysisView."Update on Posting" := TRUE;
            AnalysisView."Dimension 1 Code" := QuoBuildingSetup."Dimension for Dpto Code";
            AnalysisView."Dimension 2 Code" := QuoBuildingSetup."Dimension for CA Code";
            AnalysisView."Dimension 3 Code" := QuoBuildingSetup."Dimension for Quotes";
            IF opcReestimacion THEN
                AnalysisView."Dimension 4 Code" := QuoBuildingSetup."Dimension for Reestim. Code";
            AnalysisView.INSERT(TRUE);
        END;

        //Nos creamos el esquema de cuentas
        IF NOT AccScheduleName.GET(QuoBuildingSetup."Acc. Sched. Name for Job") THEN BEGIN
            AccScheduleName.INIT;
            AccScheduleName.Name := QuoBuildingSetup."Acc. Sched. Name for Job";
            AccScheduleName.Description := finESQdes;
            AccScheduleName."Default Column Layout" := finESQCOL;
            AccScheduleName."Analysis View Name" := QuoBuildingSetup."Analysis View for Job";
            AccScheduleName.INSERT(TRUE);
        END;

        IF NOT ColumnLayoutName.GET(finESQCOL) THEN BEGIN
            ColumnLayoutName.Name := finESQCOL;
            ColumnLayoutName.Description := finESQCOLdes;
        END;

        cnt := 0;
        InsertGLCol('A', 'Origen', 2, 1, '');
        InsertGLCol('B', 'Anterior', 3, 0, '');
        InsertGLCol('C', 'Periodo', 4, 0, '');
        InsertGLCol('D', 'Previsi¢n Pte.', 5, 1, '');
        InsertGLCol('F', 'Final Previsto', 6, 0, 'A+D');

        cnt := 0;
        InsertGLLin('P000', 'PRODUCCION', 0, '6..999999999');
        InsertGLLin('F010', 'COSTES DIRECTOS', 2, 'F015+F020+F025+F030');
        InsertGLLin('F015', 'Materiales', 0, '6..699999999');
        InsertGLLin('F020', 'Mano de Obra', 0, '6..699999999');
        InsertGLLin('F025', 'Subcontrataciones', 0, '6..699999999');
        InsertGLLin('F030', 'Otros', 0, '6..699999999');
        InsertGLLin('M000', 'MARGEN DIRECTO', 2, 'P000-F010');
        InsertGLLin('', '% Margen Directo', 2, '');
        InsertGLLin('I000', 'COSTES INDIRECTOS', 2, 'I010+I020+I030+I040');
        InsertGLLin('I0110', 'Personal indirecto', 0, '6..699999999');
        InsertGLLin('I020', 'Maquinaria y materiales', 0, '6..699999999');
        InsertGLLin('I030', 'Ajustes Almac�n', 0, '6..699999999');
        InsertGLLin('I040', 'Costes de Gesti¢n', 0, '6..699999999');
        InsertGLLin('', '% Sobre indirectos / producci¢n', 2, '');
        InsertGLLin('', 'TOTAL COSTES', 2, 'F010+I000');
        InsertGLLin('M100', 'MARGEN TOTAL', 2, 'P000-F010-I000');
        InsertGLLin('', '% Margen Final', 2, '');
        InsertGLLin('ALM', 'ALMACN', 0, '61');
    END;

    LOCAL PROCEDURE InsertGLCol(pCol: Text; pDes: Text; pT1: Integer; pT2: Integer; pFor: Text);
    BEGIN
        cnt += 10000;
        IF NOT ColumnLayout.GET(finESQCOL, cnt) THEN BEGIN
            ColumnLayout.INIT;
            ColumnLayout."Column Layout Name" := finESQCOL;
            ColumnLayout."Line No." := cnt;
            ColumnLayout."Column No." := pCol;
            ColumnLayout."Column Header" := pDes;
            ColumnLayout."Column Type" := Enum::"Column Layout Type".FromInteger(pT1);
            ColumnLayout."Ledger Entry Type" := Enum::"Column Layout Entry Type".FromInteger(pT2);
            ColumnLayout.Formula := pFor;
            ColumnLayout.INSERT(TRUE);
        END;
    END;

    LOCAL PROCEDURE InsertGLLin(pNro: Text; pDes: Text; pT1: Integer; pSum: Text);
    BEGIN
        cnt += 10000;
        IF NOT AccScheduleLine.GET(QuoBuildingSetup."Acc. Sched. Name for Job", cnt) THEN BEGIN
            AccScheduleLine.INIT;
            AccScheduleLine."Schedule Name" := QuoBuildingSetup."Acc. Sched. Name for Job";
            AccScheduleLine."Line No." := cnt;
            AccScheduleLine."Row No." := pNro;
            AccScheduleLine.Description := pDes;
            AccScheduleLine."Totaling Type" := Enum::"Acc. Schedule Line Totaling Type".FromInteger(pT1);
            AccScheduleLine.Totaling := pSum;
            AccScheduleLine.INSERT(TRUE);
        END;
    END;

    LOCAL PROCEDURE InsertSeries();
    BEGIN
        QuoBuildingSetup.GET;
        InsertSeriesOne(QuoBuildingSetup."Serie for Jobs", cntPRO, cntPROdes, cntPROcnt);
        InsertSeriesOne(QuoBuildingSetup."Serie for Offers", cntEST, cntESTdes, cntESTcnt);
        InsertSeriesOne(QuoBuildingSetup."Serie for Cost Database", cntPRE, cntPREdes, cntPREcnt);
        InsertSeriesOne(QuoBuildingSetup."Serie for Measurement", cntMED, cntMEDdes, cntMEDcnt);
        InsertSeriesOne(QuoBuildingSetup."Serie for Measurement Post", cntMDR, cntMDRdes, cntMDRcnt);
        InsertSeriesOne(QuoBuildingSetup."Serie for Reestimate", cntREE, cntREEdes, cntREEcnt);
        InsertSeriesOne(QuoBuildingSetup."Serie for Reestimate Post", cntREG, cntREGdes, cntREGcnt);
        InsertSeriesOne(QuoBuildingSetup."Serie for Indirect Part", cntPIN, cntPINdes, cntPINcnt);
        InsertSeriesOne(QuoBuildingSetup."Serie for Indirect Part Post", cntPIR, cntPIRdes, cntPIRcnt);
        InsertSeriesOne(QuoBuildingSetup."Serie for Record", cntEXP, cntEXPdes, cntEXPcnt);
        InsertSeriesOne(QuoBuildingSetup."Serie for Output Shipmen", cntALS, cntALSdes, cntALScnt);
        InsertSeriesOne(QuoBuildingSetup."Serie for Stock Regularization", cntRGS, cntRGSdes, cntRGScnt);
        InsertSeriesOne(QuoBuildingSetup."Serie for Transfers", cntTRS, cntTRSdes, cntTRScnt);
        InsertSeriesOne(QuoBuildingSetup."Serie for Transfers Post", cntTRR, cntTRRdes, cntTRRcnt);
        InsertSeriesOne(QuoBuildingSetup."Serie for Work Sheet", cntHHO, cntHHOdes, cntHHOcnt);
        InsertSeriesOne(QuoBuildingSetup."Serie for Work Sheet Post", cntHHR, cntHHRdes, cntHHRcnt);
        InsertSeriesOne(QuoBuildingSetup."Blanket Purchase Serie", 'QB_CONMAR', 'QB Contratos Marco', 'CM');

        //JAV 30/09/21: - QB 1.09.21 Se a�aden pedidos de servicio y almac�n central
        InsertSeriesOne(QuoBuildingSetup."Serie for Receipt/Transfer", 'QB_RECTRA', 'QB Recepciones/Transferencias', 'RT');
        InsertSeriesOne(QuoBuildingSetup."Serie for Receipt/Transfer Pos", 'QB_RECTRR', 'QB Recepciones/Transferencias reg.', 'RTR');
        InsertSeriesOne(QuoBuildingSetup."Serie for Service Order", 'QB_PSERVI', 'QB Pedidos Servicio', 'PS');
        InsertSeriesOne(QuoBuildingSetup."Serie for Service Order Post", 'QB_PSERVR', 'QB Pedidos Servicio Reg.', 'PSR');

        QuoBuildingSetup.MODIFY(TRUE);

        PurchasesPayablesSetup.GET();
        InsertSeriesOne(PurchasesPayablesSetup."QB Proforma No. Series", 'QB_PROFORM', 'QB Proformas a subcontratistas', 'PRF');
        PurchasesPayablesSetup.MODIFY;
    END;

    LOCAL PROCEDURE InsertSeriesOne(VAR Value: Code[20]; pCode: Text; pDes: Text; pCnt: Text);
    BEGIN
        IF (Value = '') THEN
            Value := pCode;

        IF NOT NoSeries.GET(Value) THEN BEGIN
            NoSeries.INIT;
            NoSeries.Code := Value;
            NoSeries.Description := pDes;
            NoSeries."Default Nos." := TRUE;
            NoSeries.INSERT(TRUE);
        END;

        IF NOT NoSeriesLine.GET(Value, 10000) THEN BEGIN
            NoSeriesLine.INIT;
            NoSeriesLine."Series Code" := Value;
            NoSeriesLine."Line No." := 10000;
            NoSeriesLine."Starting No." := pCnt + '00001';
            NoSeriesLine."Ending No." := pCnt + '99999';
            NoSeriesLine.INSERT(TRUE);
        END;
    END;

    LOCAL PROCEDURE InsertGrRegPro(VAR Value: Code[20]): Text;
    BEGIN
        IF (Value = '') THEN
            Value := codGRP;

        IF NOT JobPostingGroup.GET(Value) THEN BEGIN
            JobPostingGroup.INIT;
            JobPostingGroup.Code := Value;
            JobPostingGroup.Description := codGRPdes;
            JobPostingGroup."WIP Costs Account" := '3300021';
            JobPostingGroup."WIP Accrued Costs Account" := '3300022';
            JobPostingGroup."Job Costs Applied Account" := '6230004';
            JobPostingGroup."Job Costs Adjustment Account" := '6230005';
            JobPostingGroup."G/L Expense Acc. (Contract)" := '6230008';
            JobPostingGroup."G/L Expense Acc. (Contract)" := '7050004';
            JobPostingGroup."Job Sales Adjustment Account" := '7050005';
            JobPostingGroup."WIP Accrued Sales Account" := '3300011';
            JobPostingGroup."WIP Invoiced Sales Account" := '3300012';
            JobPostingGroup."Job Sales Applied Account" := '7050003';
            JobPostingGroup."Recognized Costs Account" := '6230006';
            JobPostingGroup."Recognized Sales Account" := '7050006';
            JobPostingGroup."Item Costs Applied Account" := '6230004';
            JobPostingGroup."Resource Costs Applied Account" := '6230008';
            JobPostingGroup."G/L Costs Applied Account" := '6230007';
            JobPostingGroup."Income Account Job in Progress" := '7050003';
            JobPostingGroup."Cont. Acc. Job in Progress(+)" := '3300011';
            JobPostingGroup."Cont. Acc. Job in Progress(-)" := '3300021';
            JobPostingGroup."Sales Analytic Concept" := 'A0090';
            JobPostingGroup."CA Income Job in Progress" := 'A0090';
            JobPostingGroup.INSERT(TRUE);
        END;
    END;

    LOCAL PROCEDURE InsertDiarios();
    VAR
        ItemJournalTemplate: Record 82;
        ItemJournalBatch: Record 233;
    BEGIN
        IF QuoBuildingSetup."Receipt Management Journal" = '' THEN QuoBuildingSetup."Receipt Management Journal" := 'CENTRAL';
        IF QuoBuildingSetup."Receipt Management Section" = '' THEN QuoBuildingSetup."Receipt Management Section" := 'GENERAL';
        QuoBuildingSetup.MODIFY(TRUE);

        ItemJournalTemplate.INIT;
        ItemJournalTemplate.Name := QuoBuildingSetup."Receipt Management Journal";
        ItemJournalTemplate.Description := 'ALMACEN CENTRAL';
        IF NOT ItemJournalTemplate.INSERT THEN;

        ItemJournalBatch.INIT;
        ItemJournalBatch."Journal Template Name" := ItemJournalTemplate.Name;
        ItemJournalBatch.Name := QuoBuildingSetup."Receipt Management Section";
        ItemJournalBatch.Description := 'ALMACEN CENTRAL';
        InsertSeriesOne(ItemJournalBatch."No. Series", 'QB_ALMCEN', 'QB Almac�n central', 'AC');
        InsertSeriesOne(ItemJournalBatch."Posting No. Series", 'QB_ALMCER', 'QB Almac�n central Registrado', 'ACR');
        IF NOT ItemJournalBatch.INSERT THEN;
    END;

    PROCEDURE UpdateJobsDimension();
    VAR
        Job: Record 167;
        DimensionValue: Record 349;
        DefaultDimension: Record 352;
        FunctionQB: Codeunit 7207272;
    BEGIN
        //---------------------------------------------------------------------------------------------------------
        // JAV 04/06/22: - QB 1.10.47 Revisar las dimensiones de la tabla de proyectos
        //---------------------------------------------------------------------------------------------------------

        IF (FunctionQB.AccessToQuobuilding) OR (FunctionQB.AccessToBudgets) OR (FunctionQB.AccessToRealEstate) THEN BEGIN
            Job.RESET;
            IF (Job.FINDSET(FALSE)) THEN
                REPEAT
                    //Crear el valor de dimensi�n
                    IF NOT DimensionValue.GET(FunctionQB.ReturnDimJobs, Job."No.") THEN BEGIN
                        DimensionValue.INIT;
                        DimensionValue."Dimension Code" := FunctionQB.ReturnDimJobs;
                        DimensionValue.Code := Job."No.";
                        DimensionValue.Name := Job.Description;
                        DimensionValue."Dimension Value Type" := DimensionValue."Dimension Value Type"::Standard;
                        DimensionValue.INSERT(TRUE);
                    END;

                    //Asociar dimensi�n por defecto
                    IF NOT DefaultDimension.GET(DATABASE::Job, Job."No.", FunctionQB.ReturnDimJobs) THEN BEGIN
                        DefaultDimension.INIT;
                        DefaultDimension.VALIDATE("Table ID", DATABASE::Job);
                        DefaultDimension.VALIDATE("No.", Job."No.");
                        DefaultDimension.VALIDATE("Dimension Code", FunctionQB.ReturnDimJobs);
                        DefaultDimension.VALIDATE("Dimension Value Code", Job."No.");
                        DefaultDimension.VALIDATE("Value Posting", DefaultDimension."Value Posting"::"Same Code");
                        DefaultDimension.INSERT;
                    END;

                UNTIL (Job.NEXT = 0);
        END;

        MESSAGE('Finalizado');
    END;

    /*BEGIN
/*{
      JAV 30/09/21: - QB 1.09.21 Se a�aden pedidos de servicio y almac�n central
      JAV 11/04/22: - QB 1.10.35 Limitar la longitud para que no de error
      JAV 04/06/22: - QB 1.10.47 Revisar las dimensiones de la tabla de proyectos
      JAV 01/07/22: - QB 1.10.58 Se acortan longitudes y se revisa que no se cambien valores existentes, solo se actualizan los no informados
    }
END.*/
}







