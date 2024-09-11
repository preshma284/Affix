page 7207283 "Cost Database Card"
{
    CaptionML = ENU = 'Cost Database Card', ESP = 'Ficha preciario';
    SourceTable = 7207271;
    DataCaptionFields = Code,Description;
    PageType = Card;

    layout
    {
        area(content)
        {
            group("group26")
            {

                CaptionML = ENU = 'General', ESP = 'General';
                field("Code"; rec."Code")
                {

                    Style = Strong;
                    StyleExpr = TRUE;

                    ; trigger OnAssistEdit()
                    BEGIN
                        IF Rec.AssitEdit(xRec) THEN
                            CurrPage.UPDATE;
                    END;


                }
                field("Description"; rec."Description")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Job Classification"; rec."Job Classification")
                {

                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Date Hight"; rec."Date Hight")
                {

                }
                field("Currency"; rec."Currency")
                {

                }
                field("Type JU"; rec."Type JU")
                {

                }
                field("Type Unit"; rec."Type Unit")
                {

                }
                field("Archived"; rec."Archived")
                {

                }
                field("Used for Direct cost"; rec."Used for Direct cost")
                {

                }
                field("Used for Indirect cost"; rec."Used for Indirect cost")
                {

                }
                field("Errors Header No."; rec."Errors Header No.")
                {

                }
                field("Errors Desc No."; rec."Errors Desc No.")
                {

                }

            }
            group("group39")
            {

                CaptionML = ENU = 'Other Data', ESP = 'Datos para la carga';
                group("group40")
                {

                    CaptionML = ENU = 'Precission', ESP = 'Redondeos';
                    field("UO Red. Qty"; rec."UO Red. Qty")
                    {

                    }
                    field("UO Red. Price"; rec."UO Red. Price")
                    {

                    }
                    field("UO Red. Amount"; rec."UO Red. Amount")
                    {

                    }
                    field("Des Red. Qty"; rec."Des Red. Qty")
                    {

                    }
                    field("Des Red. Price"; rec."Des Red. Price")
                    {

                    }
                    field("Des Red. Amount"; rec."Des Red. Amount")
                    {

                    }

                }
                group("group47")
                {

                    CaptionML = ENU = 'Precission', ESP = 'Coeficientes';
                    field("CI Cost"; rec."CI Cost")
                    {

                    }
                    field("CI Sales"; rec."CI Sales")
                    {

                    }

                }
                group("group50")
                {

                    CaptionML = ENU = 'Precission', ESP = 'Porcentuales';
                    field("Porcentual Cost"; rec."Porcentual Cost")
                    {

                    }
                    field("Porcentual Sales"; rec."Porcentual Sales")
                    {

                    }

                }

            }
            group("group53")
            {

                CaptionML = ESP = 'Descripci�n';
                field("ExtendedText"; ExtendedText)
                {

                    CaptionML = ESP = 'Descripci�n General';
                    MultiLine = true;

                    ; trigger OnValidate()
                    BEGIN
                        SetText;
                    END;


                }

            }
            part("part1"; 7207287)
            {

                SubPageView = SORTING("Cost Database Default", "No.");
                SubPageLink = "Cost Database Default" = FIELD("Code");
            }

        }
        area(FactBoxes)
        {
            part("part2"; 7207319)
            {
                SubPageLink = "Cost Database Default" = FIELD("Code");
            }
            systempart(Links; Links)
            {
                ;
            }
            systempart(Notes; Notes)
            {
                ;
            }

        }
    }
    actions
    {
        area(Navigation)
        {

            group("group2")
            {
                CaptionML = ENU = 'Cost Database', ESP = 'Preciario';
                action("action1")
                {
                    CaptionML = ENU = 'Cost Database Price', ESP = '"Precio preciario "';
                    RunObject = Page 7207371;
                    RunPageLink = "Cod. Cost Database" = FIELD("Code");
                    Image = Price;
                }
                action("ModifBillItemPrice")
                {

                    CaptionML = ENU = 'Price Bill of Item Rec.MODIFY', ESP = 'Modificar precio descompuesto';
                    Image = CalculateRegenerativePlan;

                    trigger OnAction()
                    VAR
                        LBillofItemData: Record 7207384;
                        // IncreaseBillofItemCost: Report 7207325;
                    BEGIN
                        CostDatabase.RESET;
                        CostDatabase.SETRANGE(Code, rec.Code);

                        // CLEAR(IncreaseBillofItemCost);
                        // IncreaseBillofItemCost.SETTABLEVIEW(CostDatabase);
                        // IncreaseBillofItemCost.RUNMODAL;

                        //JAV 25/11/22: - QB 1.12.24 Se elimina la funci�n Recalculate, se llama directamente a la funci�n en la tabla
                        QBCostDatabase.CD_CalculateAll(Rec, TRUE);
                        MESSAGE(Txt000);
                    END;


                }
                action("action3")
                {
                    CaptionML = ENU = 'Cost Database Rec.COPY', ESP = 'Copiar preciario';
                    // RunObject = Report 7207277;
                    Visible = false;
                    Image = CopyCostBudget;
                }
                group("group6")
                {
                    CaptionML = ENU = 'Import', ESP = 'BC3';
                    // ActionContainerType =NewDocumentItems;
                    Image = Import;
                    action("BC3")
                    {

                        CaptionML = ENU = 'Import BC3', ESP = 'Importar BC3';
                        Image = Import;

                        trigger OnAction()
                        BEGIN
                            // CLEAR(ImportationCostDatabaseout);
                            // ImportationCostDatabaseout.SetNoCostDatabase(rec.Code);
                            // ImportationCostDatabaseout.RUN;

                            //JAV 25/11/22: - QB 1.12.24 Se elimina la funci�n Recalculate que ya no hace falta al cargar el BC3
                        END;


                    }

                }
                group("group8")
                {
                    CaptionML = ENU = 'Import', ESP = 'Excel';
                    // ActionContainerType =NewDocumentItems;
                    Image = Import;
                    action("ExcelImport")
                    {

                        CaptionML = ESP = 'Importar Excel';
                        Image = ImportExcel;

                        trigger OnAction()
                        BEGIN
                            ExcelImport_();
                        END;


                    }
                    action("ExcelExport")
                    {

                        CaptionML = ESP = 'Exportar Excel';
                        Image = ExportToExcel;

                        trigger OnAction()
                        BEGIN
                            ExcelExport_();
                        END;


                    }

                }
                action("action7")
                {
                    CaptionML = ESP = 'Cargar de un proyecto';
                    Enabled = False;
                    Image = ImportExport;

                    trigger OnAction()
                    VAR
                        // CopyJobBudgettoCostDB: Report 7207363;
                    BEGIN
                        // CLEAR(CopyJobBudgettoCostDB);
                        // CopyJobBudgettoCostDB.SetDatos(rec.Code, '');
                        // CopyJobBudgettoCostDB.RUNMODAL;
                    END;


                }
                action("Test")
                {

                    CaptionML = ENU = 'Test', ESP = 'Test';
                    Image = TestReport;

                    trigger OnAction()
                    VAR
                        CostPieceworkJobIdent: Codeunit 7207296;
                    BEGIN
                        //JAV 05/10/19: - Se unifican las dos codeunits para preciarios y proyectos en una sola
                        CLEAR(CostPieceworkJobIdent);
                        CostPieceworkJobIdent.Process(rec.Code, '', 0);
                    END;


                }
                action("Recalcular")
                {

                    CaptionML = ENU = 'Calculate Cost JU', ESP = 'Recalcular';
                    Image = CalculatePlan;

                    trigger OnAction()
                    BEGIN
                        //JAV 25/11/22: - QB 1.12.24 Se elimina la funci�n Recalculate, se llama directamente a la funci�n en la tabla
                        QBCostDatabase.CD_CalculateAll(Rec, TRUE);
                        MESSAGE(Txt000);
                    END;


                }
                action("Repartir")
                {

                    CaptionML = ESP = 'Repartir Porc.';
                    Image = LineDiscount;

                    trigger OnAction()
                    VAR
                        BillofItemData: Record 7207384;
                        PieceworkSetup: Record 7207279;
                    BEGIN
                        //JAV 28/11/22: - QB 1.12.24 Mejoras en las carga de los BC3. Repartir los porcentuales
                        QBCostDatabase.CD_DistributePercentaje(Rec, BillofItemData.Use::Cost, PieceworkSetup."Default Porcentual Cost");
                        QBCostDatabase.CD_DistributePercentaje(Rec, BillofItemData.Use::Sales, PieceworkSetup."Default Porcentual Sales");
                    END;


                }
                action("Check")
                {

                    CaptionML = ENU = 'Check', ESP = 'Revisar';
                    Image = Check;

                    trigger OnAction()
                    BEGIN
                        //JAV 28/11/22: - QB 1.12.24 Mejoras en las carga de los BC3. Se a�ade acci�n para revisar errores
                        QBCostDatabase.CD_ReviseAll(Rec, 0.05);
                    END;


                }
                action("SeeErrors")
                {

                    CaptionML = ESP = 'Ver Errores';
                    Image = ViewDetails;

                    trigger OnAction()
                    VAR
                        QBCostDatabaseErrors: Page 7207290;
                    BEGIN
                        //JAV 28/11/22: - QB 1.12.24 Mejoras en las carga de los BC3. Se a�ade acci�n para ver los errores
                        CLEAR(QBCostDatabaseErrors);
                        QBCostDatabaseErrors.SETRECORD(Rec);
                        QBCostDatabaseErrors.RUNMODAL;
                    END;


                }

            }
            group("group17")
            {
                CaptionML = ENU = 'Cost Database', ESP = 'Uso';
                action("action13")
                {
                    CaptionML = ESP = 'En Estudios para directos';
                    RunObject = Page 7207362;
                    RunPageLink = "Import Cost Database Direct" = FIELD("Code");
                    Image = Job;
                }
                action("action14")
                {
                    CaptionML = ESP = 'En Estudios para indirectos';
                    RunObject = Page 7207362;
                    RunPageLink = "Import Cost Database Indirect" = FIELD("Code");
                    Image = Job;
                }
                action("action15")
                {
                    CaptionML = ESP = 'En Proyectos para directos';
                    RunObject = Page 7207477;
                    RunPageLink = "Import Cost Database Direct" = FIELD("Code");
                    Image = JobJournal;
                }
                action("action16")
                {
                    CaptionML = ESP = 'En Proyectos para indirectos';
                    RunObject = Page 7207477;
                    RunPageLink = "Import Cost Database Indirect" = FIELD("Code");
                    Image = JobJournal;
                }

            }
            group("group22")
            {
                CaptionML = ENU = 'Cost Database', ESP = 'Sincronizar';
                action("action17")
                {
                    CaptionML = ESP = 'Exportar';
                    Image = CopyFromChartOfAccounts;

                    trigger OnAction()
                    BEGIN
                        //JAV 23/11/20: - QB 1.07.06 Exportar preciario en XML
                        XMLExport;
                    END;


                }
                action("action18")
                {
                    CaptionML = ESP = 'Importar';
                    Image = ImportChartOfAccounts;


                    trigger OnAction()
                    BEGIN
                        //JAV 23/11/20: - QB 1.07.06 Importar preciario en XML
                        XMLImport;
                    END;


                }

            }

        }
        area(Promoted)
        {
            group(Category_New)
            {
                CaptionML = ENU = 'New', ESP = 'Nuevo';
            }
            group(Category_Process)
            {
                CaptionML = ENU = 'Process', ESP = 'Proceso';

                actionref(Test_Promoted; Test)
                {
                }
                actionref(Recalcular_Promoted; Recalcular)
                {
                }
                actionref(Repartir_Promoted; Repartir)
                {
                }
                actionref(Check_Promoted; Check)
                {
                }
                actionref(SeeErrors_Promoted; SeeErrors)
                {
                }
                actionref(ModifBillItemPrice_Promoted; ModifBillItemPrice)
                {
                }
            }
            group(Category_Report)
            {
                CaptionML = ENU = 'Reports', ESP = 'Informes';
            }
            group(Category_Category4)
            {
                CaptionML = ENU = 'Import', ESP = 'Importar';

                actionref(BC3_Promoted; BC3)
                {
                }
                actionref(ExcelImport_Promoted; ExcelImport)
                {
                }
                actionref(ExcelExport_Promoted; ExcelExport)
                {
                }
                actionref(action7_Promoted; action7)
                {
                }
            }
            group(Category_Category5)
            {
                CaptionML = ENU = 'Sync', ESP = 'Sincronizar';

                actionref(action17_Promoted; action17)
                {
                }
                actionref(action18_Promoted; action18)
                {
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    BEGIN
        //JAV 09/10/19: - Se pone la fecha de alta autom�ticamente
        rec."Date Hight" := TODAY;

        //JAV 12/12/20: - QB 1.12.24 Datos por defecto
        PieceworkSetup.GET();
        Rec."Porcentual Cost" := PieceworkSetup."Default Porcentual Cost";
        Rec."Porcentual Sales" := PieceworkSetup."Default Porcentual Sales";
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        //Rec.SETRANGE(Code);
        GetText;
        IF (Rec.Version = 0) THEN
            QBCostDatabase.CD_Update(Rec);
    END;



    var
        PieceworkSetup: Record 7207279;
        CostDatabase: Record 7207271;
        JobsUnits: Record 7207277;
        QBText: Record 7206918;
        QBCostDatabase: Codeunit 7206986;
        JobsUnitsList: Page 7207287;
        // ImportationCostDatabaseout: Report 7207275;
        Txt000: TextConst ESP = 'Proceso Finalizado';
        // XMLPreciarios: XMLport 7206901;
        ExtendedText: Text;



    LOCAL procedure XMLExport();
    begin
        //JAV 23/11/20: - QB 1.07.06 Exportar preciario en XML
        CostDatabase.RESET;
        CostDatabase.SETRANGE(Code, rec.Code);

        // CLEAR(XMLPreciarios);
        // XMLPreciarios.SETTABLEVIEW(CostDatabase);
        // XMLPreciarios.IMPORTFILE(FALSE);
        // XMLPreciarios.RUN;
    end;

    LOCAL procedure XMLImport();
    var
        text50000: TextConst ENU = 'We will look for information about the price% 1 already imported. if it exists, it will be erased. Do you wish to continue?', ESP = 'El preciario %1 ya tiene informaci�n importada, se borrar� antes de cargar la nueva. �Desea continuar?';
    begin
        //JAV 23/11/20: - QB 1.07.06 Importar preciario en XML

        //Pregunta sobre borrar si ya tiene datos
        JobsUnits.RESET();
        JobsUnits.SETCURRENTKEY("Cost Database Default");
        JobsUnits.SETRANGE("Cost Database Default", rec.Code);
        if not JobsUnits.ISEMPTY then
            if not CONFIRM(text50000, FALSE, rec.Code) then
                exit;

        //JAV 23/11/20: - QB 1.07.06 Se usa la nueva funci�n en la tabla para borrar los datos
        rec.DeleteData(rec.Code);

        // CLEAR(XMLPreciarios);
        // XMLPreciarios.SETTABLEVIEW(CostDatabase);
        // XMLPreciarios.IMPORTFILE(TRUE);
        // XMLPreciarios.SetNewCode(Rec.Code);
        // XMLPreciarios.RUN;
    end;

    LOCAL procedure GetText();
    begin
        ExtendedText := '';
        if QBText.GET(QBText.Table::Preciario, rec.Code, '', '') then
            ExtendedText := QBText.GetCostText();
    end;

    LOCAL procedure SetText();
    begin
        ExtendedText := DELCHR(ExtendedText, '>', ' ');
        if (ExtendedText <> '') then
            QBText.SetCostText(ExtendedText)
        ELSE if QBText.GET(QBText.Table::Preciario, rec.Code, '', '') then
            QBText.DELETE;

        CurrPage.UPDATE;
    end;

    LOCAL procedure ExcelExport_();
    var
        // QBExportCostDatabaseExcel: Report 7207300;
    begin
        CostDatabase.RESET;
        CostDatabase.SETRANGE(Code, rec.Code);
        // CLEAR(QBExportCostDatabaseExcel);
        // QBExportCostDatabaseExcel.SETTABLEVIEW(CostDatabase);
        // QBExportCostDatabaseExcel.RUNMODAL;
    end;

    LOCAL procedure ExcelImport_();
    var
        // ImportarBC3desdeExcel: Report 7207407;
        CostPieceworkJobIdent: Codeunit 7207296;
    begin
        // CLEAR(ImportarBC3desdeExcel);
        // ImportarBC3desdeExcel.GetNoCostDatabase(rec.Code);
        // ImportarBC3desdeExcel.RUN;
    end;

    // begin
    /*{
      JAV 01/03/19: - Se a�ade en la pantalla la lista de unidades de obra directamente
      JAV 18/03/19: - Se a�aden botones para ver los proyectos y estudios donde se ha usado y se cambia el PromotedActionCategoriesML
                    - Se a�ade un true a la acci�n LOOKUPMODE de la p�gina que le faltaba
                    - Se a�ade el campo "Used"
      JAV 02/10/19: - Se elimina el campo Use y se a�aden los de Directos e indirectos, adem�s de las acciones necesarias para ver los estudios y proyectos donde se han usado ambas
      JAV 04/10/19: - Se hace no operativo el bot�n de cargar de un proyecto pues no funciona actualmente
      JAV 09/10/19: - Se pone la fecha de alta autom�ticamente
      JAV 28/11/22: - QB 1.12.24 Mejoras en las carga de los BC3.
                                 Se a�aden campos para redondeos (20 a 25) y para errores (30 a 33).
                                 Se a�ade acci�n para revisar errores y para verlos
                                 Se a�ade acci�n para distribuir porcentuales
                                 Se a�aden datos al crear un nuevo preciario
    }*///end
}







