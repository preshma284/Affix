page 7207591 "Certification Assigned"
{
    CaptionML = ENU = 'Certification Assigned', ESP = 'Asignaci�n de certificaci�n';
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = 7207386;
    DelayedInsert = true;
    PopulateAllFields = true;
    SourceTableView = SORTING("Job No.", "Piecework Code")
                    WHERE("Type" = FILTER("Piecework"));
    DataCaptionFields = "Job No.";
    PageType = Worksheet;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            field("Ver"; Ver)
            {

                CaptionML = ESP = 'Ver';

                ; trigger OnValidate()
                BEGIN
                    SetVista;
                END;


            }
            field("nroAsiVta"; nroAsiVta)
            {

                CaptionML = ESP = 'Ud. Venta sin Asignar';
                Editable = false;
            }
            field("nroAsiCoste"; nroAsiCoste)
            {

                CaptionML = ESP = 'Ud. Coste sin Asignar';
                Editable = false;
            }
            repeater("Group")
            {

                IndentationColumn = rec.Indentation;
                ShowAsTree = true;
                field("Piecework Code"; rec."Piecework Code")
                {

                    Editable = False;
                    Style = Strong;
                    StyleExpr = TRUE;

                    ; trigger OnValidate()
                    BEGIN
                        OnAfterValidaPieceworkCode;
                    END;


                }
                field("Indentation"; rec."Indentation")
                {

                    Visible = false;
                }
                field("PADSTR('',2*Indentation,' ') + Description"; PADSTR('', 2 * rec.Indentation, ' ') + rec.Description)
                {

                    CaptionML = ESP = 'Descripci�n';
                    Editable = False;
                    Style = Strong;
                    StyleExpr = mayor;
                }
                field("Description 2"; rec."Description 2")
                {

                    Visible = False;
                    Editable = False;
                    Style = Strong;
                    StyleExpr = Mayor;
                }
                field("Account Type"; rec."Account Type")
                {

                    Editable = False;
                    Style = Strong;
                    StyleExpr = Mayor;
                }
                field("Unit Of Measure"; rec."Unit Of Measure")
                {

                    Editable = False;
                    Style = Strong;
                    StyleExpr = mayor;
                }
                // group("group19")
                // {

                //     CaptionML = ESP = 'Datos Coste';

                // }
                field("Measure Budg. Piecework Sol"; rec."Measure Budg. Piecework Sol")
                {

                    BlankZero = true;
                    Visible = verCoste;
                    Editable = MeasureBudgetPieceworkSolEditable;

                    ; trigger OnValidate()
                    BEGIN
                        OnAfterValidaMeasureBudgetPieceworkSol;
                    END;


                }
                field("Aver. Cost Price Pend. Budget"; rec."Aver. Cost Price Pend. Budget")
                {

                    BlankZero = true;
                    Visible = verCoste;
                }
                field("Amount Cost Budget (JC)"; rec."Amount Cost Budget (JC)")
                {

                    BlankZero = true;
                    Visible = verCoste;
                    Style = Strong;
                    StyleExpr = mayor;
                }
                field("TotalVenta"; TotalVenta)
                {

                    CaptionML = ESP = 'Imp. Venta Asignada';
                    BlankZero = true;
                    Visible = verCoste;
                    Editable = false;
                }
                field("Diferencia"; Diferencia)
                {

                    CaptionML = ESP = 'Beneficio';
                    BlankZero = true;
                    Visible = verCoste;
                    Editable = false;
                }
                field("Beneficio"; Beneficio)
                {

                    CaptionML = ESP = '% Beneficio';
                    BlankZero = true;
                    Visible = verCoste;
                    Editable = false;
                }
                field("ProductionPrice"; rec."ProductionPrice")
                {

                    CaptionML = ESP = 'Precio venta';
                    BlankZero = true;
                }
                field("% Assigned To Sale"; rec."% Assigned To Sale")
                {

                    StyleExpr = stSumPorcCoste;
                }
                // group("group0")
                // {

                //     CaptionML = ESP = 'Datos Venta';

                // }
                field("Sale Quantity (base)"; rec."Sale Quantity (base)")
                {

                    BlankZero = true;
                    Visible = verVenta;
                    Editable = False;
                }
                field("Unit Price Sale (base)"; rec."Unit Price Sale (base)")
                {

                    BlankZero = true;
                    Visible = verVenta;
                }
                field("Sale Amount"; rec."Sale Amount")
                {

                    BlankZero = true;
                    Visible = verVenta;
                    Style = Strong;
                    StyleExpr = mayor;
                }
                field("Record Type"; rec."Record Type")
                {

                    Visible = verVenta;
                    Style = Strong;
                    StyleExpr = mayor;
                }
                field("% Assigned To Production"; rec."% Assigned To Production")
                {

                    Visible = verVenta;
                    StyleExpr = stSumPorcVta;
                }

            }
            part("SubPageVenta"; 7207588)
            {

                CaptionML = ENU = 'Assignment', ESP = 'Asignaci�n';
                SubPageView = SORTING("Job No.", "Production Unit Code", "Certification Unit Code");
                SubPageLink = "Job No." = FIELD("Job No.");
                UpdatePropagation = Both

  ;
            }

        }
    }
    actions
    {
        area(Processing)
        {
            ////CaptionML=ENU='Link',ESP='Asignar';
            action("Filtrar")
            {

                CaptionML = ESP = 'Filtrar no asignados';
                Image = FilterLines;

                trigger OnAction()
                BEGIN
                    FilterData;
                END;


            }
            action("Todos")
            {

                CaptionML = ESP = 'Ver todos';
                Image = RemoveFilterLines;

                trigger OnAction()
                BEGIN
                    SeeAll;
                END;


            }
            action("AutomatedDistribution")
            {

                CaptionML = ENU = 'Automated Distribution', ESP = 'Distribuci�n porcentajes autom�tica';
                Image = DistributionGroup;

                trigger OnAction()
                VAR
                    RelCertProd: Record 7207397;
                    DataPiece: Record 7207386;
                    RelCertProd2: Record 7207397;
                    rJob: Record 167;
                    TotalCost: Decimal;
                    DataPieceforCost: Record 7207386;
                    LJobBudgetActual: Record 7207407;
                    RateBudgetsbyPiecework: Codeunit 7207329;
                    Text000: TextConst ENU = 'CLOSED BUDGET', ESP = 'PRESUPUESTO CERRADO';
                    VPercentageAssigned: Decimal;
                    RelCertificationProduct: Record 7207397;
                BEGIN
                    //JAV 04/10/21: - QB 1.09.20 Pedir confirmaci�n antes de iniciar el proceso
                    IF (CONFIRM(Text002, FALSE)) THEN BEGIN
                        QBRelCertificationProduct.DistributePercentage(rec."Job No.");
                        COMMIT;
                        CurrPage.UPDATE;
                    END;
                END;


            }
            action("action4")
            {
                CaptionML = ESP = 'Asociar autom�ticamente';
                Image = CopyForecast;

                trigger OnAction()
                BEGIN
                    QBRelCertificationProduct.AutoAssociate(rec."Job No.");
                END;


            }
            action("action5")
            {
                CaptionML = ESP = 'Separar Coste/Venta';
                Image = Split;

                trigger OnAction()
                BEGIN
                    QBRelCertificationProduct.Separate(rec."Job No.");
                END;


            }
            action("Recalcular")
            {

                CaptionML = ESP = 'Recalcular %';
                Image = CalculateDiscount;


                trigger OnAction()
                BEGIN
                    QBRelCertificationProduct.RecalculatePercentage(rec."Job No.");
                END;


            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(Filtrar_Promoted; Filtrar)
                {
                }
                actionref(Todos_Promoted; Todos)
                {
                }
                actionref(AutomatedDistribution_Promoted; AutomatedDistribution)
                {
                }
            }
        }
    }
    trigger OnOpenPage()
    BEGIN
        Rec.FILTERGROUP(2);
        gJob := Rec.GETFILTER("Job No.");
        gBudget := Rec.GETFILTER("Budget Filter");
        Rec.FILTERGROUP(0);

        ContarReg;

        SetVista;
    END;

    trigger OnAfterGetRecord()
    BEGIN
        DescriptionIndent := 0;
        IF rec."Account Type" = rec."Account Type"::Heading THEN BEGIN
            MeasureBudgetPieceworkSolEditable := FALSE;
        END ELSE BEGIN
            MeasureBudgetPieceworkSolEditable := FALSE;
        END;

        Mayor := (rec."Account Type" = rec."Account Type"::Heading);
        Rec.CALCFIELDS("% Assigned To Production");

        IF (Mayor) THEN
            stSumPorcVta := 'Subordinate'
        ELSE IF (rec."% Assigned To Production" < 99.99) THEN
            stSumPorcVta := 'Unfavorable'
        ELSE IF (rec."% Assigned To Production" > 100.01) THEN
            stSumPorcVta := 'Ambiguous'
        ELSE
            stSumPorcVta := 'Favorable';

        IF (Mayor) THEN
            stSumPorcCoste := 'Subordinate'
        ELSE IF (rec."% Assigned To Sale" < 99.99) THEN
            stSumPorcCoste := 'Unfavorable'
        ELSE IF (rec."% Assigned To Sale" > 100.01) THEN
            stSumPorcCoste := 'Ambiguous'
        ELSE
            stSumPorcCoste := 'Favorable';

        CalcTotales;
    END;

    trigger OnDeleteRecord(): Boolean
    BEGIN
        CurrPage.UPDATE(FALSE);
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        xRec := Rec;
        Rec.CALCFIELDS("Amount Production Budget", "Aver. Cost Price Pend. Budget");

        //Datos de la subp�gina
        IF (rec."Account Type" = rec."Account Type"::Unit) THEN
            CurrPage.SubPageVenta.PAGE.SetUO(rec."Piecework Code")
        ELSE
            CurrPage.SubPageVenta.PAGE.SetUO(' ');

        ContarReg;
        CalcTotales;
    END;



    var
        DataPieceworkForProduction: Record 7207386;
        QBRelCertificationProduct: Codeunit 7207343;
        gJob: Code[20];
        gBudget: Code[20];
        CJobInProgress: Code[20];
        DescriptionIndent: Integer;
        MeasureBudgetPieceworkSolEditable: Boolean;
        Ver: Option "Coste","Venta";
        verVenta: Boolean;
        verCoste: Boolean;
        Mayor: Boolean;
        stSumPorcVta: Text;
        stSumPorcCoste: Text;
        nroAsiVta: Integer;
        nroAsiCoste: Integer;
        TotalVenta: Decimal;
        Diferencia: Decimal;
        Beneficio: Decimal;
        Text000: TextConst ESP = 'Confime que desea establecer el precio de venta en las unidades de coste';
        Text001: TextConst ESP = 'Debe recalcular el presupuesto para completar este proceso.';
        Text002: TextConst ESP = 'Esta funci�n reparte autom�ticamente los porcentajes en funci�n del peso de la unidad.\ATENCION: Esto cambiar� TODOS los porcentajes\�seguro que desea efectuar el proceso?';

    procedure ReceivesJob(PCJob: Code[20]);
    begin
        CJobInProgress := PCJob;
    end;

    LOCAL procedure OnAfterValidaPieceworkCode();
    begin
        CurrPage.UPDATE(TRUE);
    end;

    LOCAL procedure OnAfterValidaMeasureBudgetPieceworkSol();
    begin
        Rec.CALCFIELDS("Amount Production Budget", "Aver. Cost Price Pend. Budget");
    end;

    LOCAL procedure OnAfterValidaAmountProductionBudget();
    begin
        Rec.CALCFIELDS("Amount Production Budget", "Aver. Cost Price Pend. Budget");
    end;

    LOCAL procedure SetVista();
    begin
        SeeAll;

        CASE Ver OF
            Ver::Coste:
                begin
                    Rec.SETRANGE("Production Unit", TRUE);
                    Rec.SETRANGE("Customer Certification Unit");
                end;
            Ver::Venta:
                begin
                    Rec.SETRANGE("Production Unit");
                    Rec.SETRANGE("Customer Certification Unit", TRUE);
                end;
        end;
        CurrPage.SubPageVenta.PAGE.SetVista(Ver);
        CurrPage.UPDATE(FALSE);

        verCoste := (Ver = Ver::Coste);
        verVenta := (Ver = Ver::Venta);
    end;

    LOCAL procedure ContarReg();
    begin
        DataPieceworkForProduction.RESET;
        DataPieceworkForProduction.SETRANGE("Job No.", gJob);
        DataPieceworkForProduction.SETRANGE("Budget Filter", gBudget);
        DataPieceworkForProduction.SETRANGE("Account Type", DataPieceworkForProduction."Account Type"::Unit);
        DataPieceworkForProduction.SETRANGE("Customer Certification Unit", TRUE);
        DataPieceworkForProduction.SETFILTER("% Assigned To Production", '<%1', 99.99);
        nroAsiVta := DataPieceworkForProduction.COUNT;

        DataPieceworkForProduction.RESET;
        DataPieceworkForProduction.SETRANGE("Job No.", gJob);
        DataPieceworkForProduction.SETRANGE("Budget Filter", gBudget);
        DataPieceworkForProduction.SETRANGE("Account Type", DataPieceworkForProduction."Account Type"::Unit);
        DataPieceworkForProduction.SETRANGE("Production Unit", TRUE);
        DataPieceworkForProduction.SETFILTER("% Assigned To Sale", '<%1', 99.99);
        nroAsiCoste := DataPieceworkForProduction.COUNT;
    end;

    LOCAL procedure CalcTotalVenta(): Decimal;
    var
        RelCertificationProduct: Record 7207397;
    begin
        exit(RelCertificationProduct.CalcTotalSaleAmount(rec."Job No.", rec."Piecework Code"));
    end;

    LOCAL procedure CalcTotales();
    begin
        TotalVenta := 0;
        Diferencia := 0;
        Beneficio := 0;
        if (rec."Account Type" = rec."Account Type"::Unit) then begin
            TotalVenta := CalcTotalVenta();
            if (TotalVenta <> 0) then begin
                Diferencia := CalcTotalVenta - rec."Amount Cost Budget (JC)";
                if (Diferencia > 0) then
                    Beneficio := ROUND(Diferencia * 100 / TotalVenta, 0.01)
                ELSE
                    Beneficio := 0;
            end;
        end;
    end;

    LOCAL procedure TraslatePrices();
    var
        Window: Dialog;
    begin
        if (CONFIRM(Text000, FALSE)) then begin

            Window.OPEN('Modificando U.O. #1##############');
            DataPieceworkForProduction.RESET;
            DataPieceworkForProduction.SETRANGE("Job No.", rec."Job No.");
            DataPieceworkForProduction.SETRANGE("Account Type", DataPieceworkForProduction."Account Type"::Unit);
            DataPieceworkForProduction.SETRANGE(Type, DataPieceworkForProduction.Type::Piecework);
            DataPieceworkForProduction.SETRANGE("Production Unit", TRUE);
            if (DataPieceworkForProduction.FINDSET(TRUE)) then
                repeat
                    Window.UPDATE(1, DataPieceworkForProduction."Piecework Code");
                    DataPieceworkForProduction.VALIDATE("Contract Price", DataPieceworkForProduction.ProductionPrice);
                    DataPieceworkForProduction.MODIFY;
                until (DataPieceworkForProduction.NEXT = 0);
            Window.CLOSE;
            MESSAGE(Text001);
        end;
    end;

    LOCAL procedure FilterData();
    begin
        CASE Ver OF
            Ver::Coste:
                begin
                    if (nroAsiCoste <> 0) then begin
                        Rec.SETFILTER("% Assigned To Sale", '<%1', 99.99);
                        Rec.SETRANGE("Account Type", DataPieceworkForProduction."Account Type"::Unit);
                    end;
                end;
            Ver::Venta:
                begin
                    if (nroAsiVta <> 0) then begin
                        Rec.SETFILTER("% Assigned To Production", '<%1', 99.99);
                        Rec.SETRANGE("Account Type", DataPieceworkForProduction."Account Type"::Unit);
                    end;
                end;
        end;
    end;

    LOCAL procedure SeeAll();
    begin
        Rec.SETRANGE("% Assigned To Sale");
        Rec.SETRANGE("% Assigned To Production");
        Rec.SETRANGE("Account Type");
    end;

    // begin
    /*{
      JAV 28/09/20: - QB 1.06.16 Nueva acci�n para pasar precios de venta a las unidades de coste
      JAV 29/09/20: - QB 1.06.16 Nueva acci�n para separar coste y venta en
      JAV 30/10/20: - QB 1.07.03 Se a�aden filtros en la vista de ventas
    }*///end
}







