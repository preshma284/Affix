page 7207588 "Relation Certification/Product"
{
    CaptionML = ENU = 'Relation Certification/Production', ESP = 'Relaci�n certificaci�n/producci�n';
    SourceTable = 7207397;
    SourceTableView = SORTING("Job No.", "Production Unit Code", "Certification Unit Code");
    PageType = ListPart;

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("Production Unit Code"; rec."Production Unit Code")
                {

                    Visible = verDatosVenta;
                    Enabled = PageEditable;
                    Style = Strong;
                    StyleExpr = TRUE;

                    ; trigger OnValidate()
                    BEGIN
                        CurrPage.UPDATE;
                    END;


                }
                field("Certification Unit Code"; rec."Certification Unit Code")
                {

                    Visible = NOT verDatosVenta;
                    Enabled = PageEditable;
                    Style = Strong;
                    StyleExpr = TRUE;

                    ; trigger OnValidate()
                    BEGIN
                        CurrPage.UPDATE;
                    END;


                }
                field("GetDescription()"; GetDescription())
                {

                    CaptionML = ENU = 'Certification Unit Description', ESP = 'Descripci�n U.O.';
                    Enabled = PageEditable;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Percentage Of Assignment"; rec."Percentage Of Assignment")
                {

                    ToolTipML = ESP = 'Porcentaje del importe de venta que se reparte a la unida de coste';
                    DecimalPlaces = 0 : 2;
                    Enabled = PageEditable;
                    Style = Strong;
                    StyleExpr = TRUE;

                    ; trigger OnValidate()
                    BEGIN
                        CheckPending;
                        CurrPage.UPDATE;
                    END;


                }
                field("Assignment Cost Percentage"; rec."Assignment Cost Percentage")
                {

                    ToolTipML = ESP = 'Porcentaje del importe de coste que se reparte a la unida de venta';
                    Enabled = PageEditable;
                    Style = Strong;
                    StyleExpr = TRUE;

                    ; trigger OnValidate()
                    BEGIN
                        CheckPending;
                        CurrPage.UPDATE;
                    END;


                }
                field("ShowSaleAmount"; rec."ShowSaleAmount")
                {

                    CaptionML = ENU = 'Assigned Sale Amount', ESP = 'Importe venta asignado';
                    Enabled = PageEditable;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("TotalLinea"; rec."Total Asigned Percentage")
                {

                    Visible = NOT verDatosVenta;
                    Style = Unfavorable;
                    StyleExpr = BoolPending;
                }
                field("PorcCoste"; rec."Total Asigned Percentage Cost")
                {

                    Visible = NOT verDatosVenta;
                    Style = Unfavorable;
                    StyleExpr = BoolPending;
                }

            }
            group("group14")
            {

                Visible = verDatosVenta;
                field("TotalCostePie"; rec."Total Asigned Percentage")
                {

                    Visible = verDatosVenta;
                    Editable = false;
                    Style = Unfavorable;
                    StyleExpr = BoolPending;
                }

            }
            group("group16")
            {

                Visible = verDatosCoste;
                field("totalVentaPie"; totalVenta)
                {

                    CaptionML = ESP = 'Importe Venta asignado';
                    Visible = verDatosCoste;
                    Editable = false

  ;
                }

            }

        }
    }
    actions
    {
        area(Processing)
        {

            action("action1")
            {
                CaptionML = ENU = 'Certification Unit Assigned', ESP = 'Asignar unidades certificaci�n';
                Visible = verDatosCoste;

                trigger OnAction()
                BEGIN
                    CLEAR(GetCertificationUnits);
                    GetCertificationUnits.SetType(Vista, rec."Job No.", UO);
                    GetCertificationUnits.LOOKUPMODE(TRUE);
                    GetCertificationUnits.RUNMODAL;
                END;


            }
            action("action2")
            {
                CaptionML = ENU = 'Production Unit Assigned', ESP = 'Asignar unidades producci�n';
                Visible = verDatosVenta;


                trigger OnAction()
                BEGIN
                    CLEAR(GetCertificationUnits);
                    GetCertificationUnits.SetType(Vista, rec."Job No.", UO);
                    GetCertificationUnits.LOOKUPMODE(TRUE);
                    GetCertificationUnits.RUNMODAL;
                END;


            }

        }
    }
    trigger OnAfterGetRecord()
    BEGIN
        CheckPending; //Q8462
    END;

    trigger OnDeleteRecord(): Boolean
    BEGIN
        CurrPage.UPDATE;
    END;

    trigger OnAfterGetCurrRecord()
    VAR
        CheckPending: Integer;
    BEGIN
        IF (Vista = Vista::desdeCoste) THEN
            totalVenta := RelCertificationProduct.CalcTotalSaleAmount(rec."Job No.", rec."Production Unit Code");
    END;



    var
        DataPieceworkForProduction: Record 7207386;
        RelCertificationProduct: Record 7207397;
        GetCertificationUnits: Page 7207589;
        BoolPending: Boolean;
        PageEditable: Boolean;
        Vista: Option "desdeCoste","desdeVenta";
        verDatosVenta: Boolean;
        verDatosCoste: Boolean;
        totalVenta: Decimal;
        UO: Code[20];

    LOCAL procedure CheckPending();
    begin
        //+Q8462
        if (rec."Total Asigned Percentage" < 100) then
            BoolPending := TRUE
        ELSE
            BoolPending := FALSE;
        //-Q8462
    end;

    procedure SetVista(pTipo: Option);
    begin
        Vista := pTipo;
        verDatosVenta := (Vista = Vista::desdeVenta);
        verDatosCoste := (Vista = Vista::desdeCoste);
        CurrPage.UPDATE(FALSE);
    end;

    procedure SetUO(pUO: Code[20]);
    begin
        UO := pUO;
        if (pUO) = '' then begin
            Rec.SETRANGE("Production Unit Code", pUO);
            Rec.SETRANGE("Certification Unit Code", pUO);
            PageEditable := FALSE;
        end ELSE begin
            CASE Vista OF
                Vista::desdeCoste:
                    begin
                        Rec.SETRANGE("Production Unit Code", pUO);
                        Rec.SETRANGE("Certification Unit Code");
                    end;
                Vista::desdeVenta:
                    begin
                        Rec.SETRANGE("Production Unit Code");
                        Rec.SETRANGE("Certification Unit Code", pUO);
                    end;
            end;
            PageEditable := TRUE;
        end;
        CurrPage.UPDATE(FALSE);
    end;

    LOCAL procedure GetDescription(): Text;
    begin
        CASE Vista OF
            Vista::desdeCoste:
                if not DataPieceworkForProduction.GET(rec."Job No.", rec."Certification Unit Code") then
                    DataPieceworkForProduction.INIT;
            Vista::desdeVenta:
                if not DataPieceworkForProduction.GET(rec."Job No.", rec."Production Unit Code") then
                    DataPieceworkForProduction.INIT;
        end;
        exit(DataPieceworkForProduction.Description);
    end;

    // begin
    /*{
      QMD 26/12/19: Q8462: GAP07 - Sacar el nuevo campo para avisos en agrupaci�n de costes "Pending Percentage"
    }*///end
}







