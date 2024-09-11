page 7207302 "Measurement"
{
    CaptionML = ENU = 'Measurement', ESP = 'Medici�n';
    SourceTable = 7207336;
    SourceTableView = SORTING("Document Type", "No.")
                    WHERE("Document Type" = CONST("Measuring"));
    PageType = Document;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            group("General")
            {

                field("No."; rec."No.")
                {


                    ; trigger OnAssistEdit()
                    BEGIN
                        IF rec.AssistEdit() THEN
                            CurrPage.UPDATE;
                    END;


                }
                field("Job No."; rec."Job No.")
                {

                }
                field("Description"; rec."Description")
                {

                }
                group("group21")
                {

                    CaptionML = ENU = 'Customer', ESP = 'Cliente';
                    field("Expedient No."; rec."Expedient No.")
                    {

                    }
                    field("Customer No."; rec."Customer No.")
                    {


                        ; trigger OnValidate()
                        BEGIN
                            NoCustomerOnAfterValidate;
                        END;


                    }
                    field("Name"; rec."Name")
                    {

                    }
                    field("Address"; rec."Address")
                    {

                        Importance = Additional;
                    }
                    field("City"; rec."City")
                    {

                        Importance = Additional;
                    }
                    field("Post Code"; rec."Post Code")
                    {

                        Importance = Additional;
                    }
                    field("County"; rec."County")
                    {

                        Importance = Additional;
                    }

                }
                group("group29")
                {

                    CaptionML = ESP = 'Medici�n';
                    field("No. Measure"; rec."No. Measure")
                    {

                    }
                    field("Text Measure"; rec."Text Measure")
                    {

                    }
                    field("Measurement Date"; rec."Measurement Date")
                    {

                        ToolTipML = ESP = 'Hasta que fecha se ha efectuado la medici�n (la medici�n es desde el inicio de la obra hasta esta fecha)';
                    }
                    field("Send Date"; rec."Send Date")
                    {

                        ToolTipML = ESP = 'En que fecha se ha entregado al cliente';
                    }
                    field("Posting Date"; rec."Posting Date")
                    {

                        ToolTipML = ESP = 'En que fecha se cargar� en el proyecto';
                    }
                    field("Certification Date"; rec."Certification Date")
                    {

                    }
                    field("Currency Code"; rec."Currency Code")
                    {

                    }
                    field("Currency Factor"; rec."Currency Factor")
                    {

                        Importance = Additional;
                    }
                    field("Certification Type"; rec."Certification Type")
                    {

                    }
                    field("Responsibility Center"; rec."Responsibility Center")
                    {

                        Importance = Additional;
                    }
                    field("Cancel No."; rec."Cancel No.")
                    {

                    }
                    field("Shortcut Dimension 1 Code"; rec."Shortcut Dimension 1 Code")
                    {

                        Importance = Additional;

                        ; trigger OnValidate()
                        BEGIN
                            ShortcutDimension1CodeOnAfterV;
                        END;


                    }
                    field("Shortcut Dimension 2 Code"; rec."Shortcut Dimension 2 Code")
                    {

                        Importance = Additional;

                        ; trigger OnValidate()
                        BEGIN
                            ShortcutDimension2CodeOnAfterV;
                        END;


                    }

                }

            }
            part(LinDoc; 7207304)
            {
                SubPageLink = "Document No." = FIELD("No.");
                UpdatePropagation = Both;
            }

        }
        area(FactBoxes)
        {
            part("part2"; 7207498)
            {

                CaptionML = ENU = 'Measurement Statistics', ESP = 'Totales de la medici�n';
                SubPageLink = "No." = FIELD("No.");
                Visible = TRUE;
            }
            systempart(Links; Links)
            {

                Visible = TRUE;
            }
            systempart(Notes; Notes)
            {

                Visible = TRUE;
            }

        }
    }
    actions
    {
        area(Navigation)
        {

            group("group2")
            {
                CaptionML = ENU = '&Document', ESP = '&Medici�n';
                action("action1")
                {
                    ShortCutKey = 'Shift+F7';
                    CaptionML = ENU = 'Job', ESP = 'Proyecto';
                    RunObject = Page 89;
                    RunPageLink = "No." = FIELD("Job No.");
                    Image = EditLines;
                }
                action("action2")
                {
                    CaptionML = ENU = 'Co&mments', ESP = 'C&omentarios';
                    RunObject = Page 7207273;
                    RunPageLink = "Document Type" = CONST("Measure"), "No." = FIELD("No.");
                    Image = ViewComments;
                }
                action("action3")
                {
                    ShortCutKey = 'Shift+Ctrl+D';
                    CaptionML = ENU = 'Dimensions', ESP = 'Dimensiones';
                    Image = Dimensions;

                    trigger OnAction()
                    BEGIN
                        rec.ShowDocDim;
                    END;


                }

            }

        }
        area(Processing)
        {

            group("group7")
            {
                CaptionML = ENU = 'F&unctions', ESP = 'Acci&ones';
                action("action4")
                {
                    Ellipsis = true;
                    CaptionML = ENU = 'Copy Lines', ESP = 'Copiar l�neas';
                    Image = CopyToTask;

                    trigger OnAction()
                    BEGIN

                        // copyLinesMeasurement.SetDoc(Rec);
                        // copyLinesMeasurement.RUNMODAL;
                        // CLEAR(copyLinesMeasurement);
                    END;


                }
                action("action5")
                {
                    Ellipsis = true;
                    CaptionML = ENU = 'Suggest Cost Database Piecework', ESP = 'Propo&ner U.O. del preciario de venta';
                    Image = Reconcile;

                    trigger OnAction()
                    BEGIN
                        // SuggestCostDatabasePiecework.SetParameters(Rec);
                        // SuggestCostDatabasePiecework.RUNMODAL;
                        // CLEAR(SuggestCostDatabasePiecework);
                    END;


                }
                action("action6")
                {
                    CaptionML = ESP = 'Importar Excel';
                    Image = ImportExcel;

                    trigger OnAction()
                    VAR
                        // ImportExcel: Report 7207427;
                    BEGIN
                        //JAV 18/10/19: - Nueva acci�n para importar desde Excel los datos
                        // CLEAR(ImportExcel);
                        // ImportExcel.SetFilters(Rec);
                        // ImportExcel.RUN;

                        COMMIT;
                        rec.AddLines; //A�adir las l�neas certificadas anteriomente que falten
                    END;


                }

            }
            group("group11")
            {
                CaptionML = ENU = 'P&osting', ESP = '&Registro';
                action("action7")
                {
                    ShortCutKey = 'F9';
                    CaptionML = ENU = 'P&ost', ESP = 'Registrar';
                    RunObject = Codeunit 7207275;
                    Image = Post;
                }
                action("action8")
                {
                    Ellipsis = true;
                    CaptionML = ENU = 'Post &Batch', ESP = 'Registrar por &lotes';
                    Image = PostBatch;

                    trigger OnAction()
                    BEGIN
                        // REPORT.RUNMODAL(REPORT::"Post. by Measurement Batch", TRUE, TRUE, Rec);
                        CurrPage.UPDATE(FALSE);
                    END;


                }
                action("action9")
                {
                    Ellipsis = true;
                    CaptionML = ENU = 'Print', ESP = '&Imprimir';
                    Image = Print;

                    trigger OnAction()
                    VAR
                        MeasurementHeader: Record 7207336;
                        QBReportSelections: Record 7206901;
                    BEGIN
                        MeasurementHeader.SETRANGE("Document Type", MeasurementHeader."Document Type"::Measuring);
                        MeasurementHeader.SETRANGE("No.", rec."No.");
                        MeasurementHeader.SETRANGE("Job No.", rec."Job No.");
                        //JAV 03/10/19: - Se cambia la impresi�n por el nuevo selector
                        //CLEAR(rptCertification);
                        //rptCertification.SETTABLEVIEW(MeasurementHeader);
                        //rptCertification.RUNMODAL;
                        QBReportSelections.Print(QBReportSelections.Usage::J4, MeasurementHeader);
                    END;


                }
                action("action10")
                {
                    Ellipsis = true;
                    CaptionML = ENU = 'Print', ESP = 'Imprimir WS';
                    Visible = seePrintWS;
                    Image = PrintInstallment;


                    trigger OnAction()
                    VAR
                        MeasurementHeader: Record 7207336;
                        QBReportSelections: Record 7206901;
                    BEGIN
                        QBMeasurements.PrintWS(Rec."No.");
                    END;


                }

            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action4_Promoted; action4)
                {
                }
                actionref(action5_Promoted; action5)
                {
                }
                actionref(action6_Promoted; action6)
                {
                }
                actionref(action7_Promoted; action7)
                {
                }
            }
            group(Category_Report)
            {
                actionref(action9_Promoted; action9)
                {
                }
                actionref(action10_Promoted; action10)
                {
                }
            }
        }
    }
    trigger OnOpenPage()
    BEGIN
        Rec.FILTERGROUP(2);
        AuxJob := Rec.GETFILTER("Job No.");
        Rec.FILTERGROUP(0);

        IF (AuxJob = '') THEN BEGIN //Si entramos desde el proyecto no hace falta filtrar mas
            rec.FunFilterResponsibility(Rec);
            FunctionQB.SetUserJobMeasurementHeaderFilter(Rec);
        END;

        seePrintWS := FunctionQB.AccessToWSReports;
    END;

    trigger OnFindRecord(Which: Text): Boolean
    BEGIN
        IF Rec.FIND(Which) THEN
            EXIT(TRUE)
        ELSE BEGIN
            Rec.SETRANGE("No.");
            EXIT(Rec.FIND(Which));
        END;
    END;

    trigger OnAfterGetRecord()
    BEGIN
        GetRecord;
    END;

    trigger OnNewRecord(BelowxRec: Boolean)
    BEGIN
        rec."Document Type" := rec."Document Type"::Measuring;
        Rec.VALIDATE("Job No.", AuxJob);                     //JAV 02/12/21: - QB 1.05.06 No hac�a el proceso del Rec.VALIDATE
        rec."Responsibility Center" := FunctionQB.GetUserJobResponsibilityCenter;
        GetRecord;
    END;

    trigger OnDeleteRecord(): Boolean
    BEGIN
        CurrPage.SAVERECORD;
        EXIT(TRUE);
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        Rec.CalculateTotals;
    END;



    var
        FunctionQB: Codeunit 7207272;
        // copyLinesMeasurement: Report 7207278;
        // SuggestCostDatabasePiecework: Report 7207279;
        edExpediente: Boolean;
        Job: Record 167;
        seePrintWS: Boolean;
        QBMeasurements: Codeunit 7207274;
        AuxJob: Text;



    LOCAL procedure GetRecord();
    begin
        xRec := Rec;
        if (not Job.GET(rec."Job No.")) then
            Job.INIT;
    end;

    LOCAL procedure NoCustomerOnAfterValidate();
    begin
        CurrPage.UPDATE;
    end;

    LOCAL procedure ShortcutDimension2CodeOnAfterV();
    begin
        CurrPage.LinDoc.PAGE.UpdateForm(TRUE);
    end;

    LOCAL procedure ShortcutDimension1CodeOnAfterV();
    begin
        CurrPage.LinDoc.PAGE.UpdateForm(TRUE);
    end;

    // begin
    /*{
      JAV 03/10/19: - Se cambia la impresi�n por el nuevo selector
      JAV 18/10/19: - Nueva acci�n para importar desde Excel los datos
      AML 14/7/23 : - Q19892 A�adido campo rec."Certification Date"
    }*///end
}







