page 7207390 "Competition/Quote"
{
    CaptionML = ENU = 'List of competitors in the offer', ESP = 'Lista de competidores en la oferta';
    SourceTable = 7207307;
    DataCaptionFields = "Quote Code";
    PageType = Document;

    layout
    {
        area(content)
        {
            group("group6")
            {

                repeater("Group")
                {

                    field("Competitor Code"; rec."Competitor Code")
                    {

                        Editable = bEditable;
                        Style = Strong;
                        StyleExpr = bCompany;
                    }
                    field("Competitor Name"; rec."Competitor Name")
                    {

                        Editable = bEditable;
                        Style = Strong;
                        StyleExpr = bCompany;
                    }
                    field("Contratista Amount"; rec."Contratista Amount")
                    {

                        Editable = bEditable;
                        Style = Strong;
                        StyleExpr = bCompany;

                        ; trigger OnValidate()
                        BEGIN
                            CurrPage.UPDATE;
                            CalcTotals;
                        END;


                    }
                    field("% of Low"; rec."% of Low")
                    {

                        Editable = bEditable;
                        Style = Strong;
                        StyleExpr = bCompany;

                        ; trigger OnValidate()
                        BEGIN
                            CurrPage.UPDATE;
                            CalcTotals;
                        END;


                    }
                    field("Evaluated"; rec."Evaluated")
                    {

                    }
                    field("Score High"; rec."Score High")
                    {

                        Style = Strong;
                        StyleExpr = bCompany;
                    }
                    field("Opening Result"; rec."Opening Result")
                    {

                    }
                    field("Reason for Rejection"; rec."Reason for Rejection")
                    {

                        Style = StandardAccent;
                        StyleExpr = TRUE;
                    }

                }
                group("group16")
                {

                    part("part1"; 7207389)
                    {
                        SubPageLink = "Quote Code" = FIELD("Quote Code"), "Competitor Code" = FIELD("Competitor Code");
                        UpdatePropagation = Both;
                    }

                }

            }
            group("group18")
            {

                CaptionML = ESP = 'Datos Econ�micos Generales';
                group("group19")
                {

                    CaptionML = ESP = 'Importes';
                    field("Bidding Bases Budget"; rec."Bidding Bases Budget")
                    {

                    }
                    field("NroLicitadores"; NroLicitadores)
                    {

                        CaptionML = ESP = 'N� Licitadores';
                        Enabled = false;
                    }
                    field("OfertaMedia"; OfertaMedia)
                    {

                        CaptionML = ESP = 'Oferta Media';
                        Editable = false;
                    }

                }
                group("group23")
                {

                    CaptionML = ESP = 'Baja';
                    field("BajaMedia"; BajaMedia)
                    {

                        CaptionML = ESP = 'Baja Media';
                        DecimalPlaces = 5 : 5;
                        Editable = false;
                    }
                    field("BajaTemeraria"; BajaTemeraria)
                    {

                        CaptionML = ESP = 'Baja Temeraria (aprox)';
                        DecimalPlaces = 5 : 5;
                        Editable = false;
                    }
                    field("Job.Low Average Competition"; Job."Low Average Competition")
                    {

                        CaptionML = ESP = 'Baja Media Guardada';
                        Enabled = false;
                    }
                    field("Job.% Dangerously Low Bids"; Job."% Dangerously Low Bids")
                    {

                        CaptionML = ESP = 'Baja Temeraria Guardada';
                        Enabled = false;
                    }

                }
                group("group28")
                {

                    CaptionML = ESP = 'Puntuaciones';
                    field("My Score"; rec."My Score")
                    {

                    }
                    field("PuntMedia1"; PuntMedia1)
                    {

                        CaptionML = ESP = 'Puntuaci�n Media';
                        Editable = false;
                    }
                    field("PuntMedia2"; PuntMedia2)
                    {

                        CaptionML = ESP = 'Media sin la propia';
                        Editable = false

  ;
                    }

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
                CaptionML = ENU = 'Standards of quote', ESP = 'Criterios de la oferta';
                RunObject = Page 7207388;
                RunPageView = SORTING("Quote Code", "Standard Code")
                                  ORDER(Ascending);
                RunPageLink = "Quote Code" = FIELD("Quote Code");
                Image = ItemWorksheet;
            }
            action("action2")
            {
                CaptionML = ESP = 'Pasar % a la Oferta';
                Image = CalculateInvoiceDiscount;

                trigger OnAction()
                BEGIN
                    //Pasar los porcentajes de la pantalla a la oferta
                    Job."% Dangerously Low Bids" := BajaTemeraria;
                    Job."Low Average Competition" := BajaMedia;
                    Job."Low from Competitors" := TRUE;
                    Job.MODIFY;
                END;


            }
            action("action3")
            {
                CaptionML = ESP = 'Liberar % en la Oferta';
                Image = RefreshDiscount;


                trigger OnAction()
                BEGIN
                    Job."Low from Competitors" := FALSE;
                    Job.MODIFY;
                END;


            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action1_Promoted; action1)
                {
                }
                actionref(action2_Promoted; action2)
                {
                }
                actionref(action3_Promoted; action3)
                {
                }
            }
        }
    }

    trigger OnOpenPage()
    BEGIN
        rec.UpdateCompany(rec."Quote Code");
        CalcTotals;
    END;

    trigger OnAfterGetRecord()
    BEGIN
        SetEditable;
    END;

    trigger OnNewRecord(BelowxRec: Boolean)
    BEGIN
        bCompany := FALSE;
        bEditable := TRUE;
    END;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    BEGIN
        CalcTotals;
    END;

    trigger OnModifyRecord(): Boolean
    BEGIN
        CalcTotals;
    END;

    trigger OnDeleteRecord(): Boolean
    BEGIN
        CalcTotals;
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        CalcTotals;
    END;



    var
        CompetitionQuote: Record 7207307;
        Job: Record 167;
        bEditable: Boolean;
        bCompany: Boolean;
        OfertaMedia: Decimal;
        BajaMedia: Decimal;
        BajaTemeraria: Decimal;
        NroLicitadores: Integer;
        Total: Decimal;
        NroDatos: Integer;
        PuntMedia1: Decimal;
        PuntMedia2: Decimal;
        MaxOferta: Decimal;

    LOCAL procedure CalcTotals();
    begin
        Rec.CALCFIELDS("Bidding Bases Budget");
        if not Job.GET(rec."Quote Code") then
            Job.INIT;

        BajaMedia := 0;
        BajaTemeraria := 0;
        MaxOferta := 0;

        //Calculo la baja media
        NroLicitadores := 0;
        NroDatos := 0;
        Total := 0;
        CompetitionQuote.RESET;
        CompetitionQuote.SETRANGE("Quote Code", rec."Quote Code");
        if CompetitionQuote.FINDSET(FALSE) then
            repeat
                NroLicitadores += 1;
                if (CompetitionQuote."Contratista Amount" > MaxOferta) then
                    MaxOferta := CompetitionQuote."Contratista Amount";
                if (CompetitionQuote."Contratista Amount" <> 0) then begin
                    NroDatos += 1;
                    Total += CompetitionQuote."Contratista Amount";
                end;
            until CompetitionQuote.NEXT = 0;

        if (NroDatos <> 0) then
            OfertaMedia := ROUND(Total / NroDatos, 0.01)
        ELSE
            OfertaMedia := 0;

        if (rec."Bidding Bases Budget" <> 0) then
            BajaMedia := ROUND((rec."Bidding Bases Budget" - OfertaMedia) * 100 / rec."Bidding Bases Budget", 0.00001)
        ELSE
            BajaMedia := 0;

        //Calculo la baja temeraria
        CASE NroLicitadores OF
            1:
                BajaTemeraria := 25;
            2:
                begin
                    if (rec."Bidding Bases Budget" <> 0) then
                        BajaTemeraria := ROUND(MaxOferta * 100 * 1.2 / rec."Bidding Bases Budget", 0.00001);
                end;
            3:
                BajaTemeraria := ROUND(BajaMedia * 1.1, 0.00001);
            ELSE
                BajaTemeraria := ROUND(BajaMedia * 1.1, 0.00001);
        end;

        //Calculo de la puntuaci�n media
        PuntMedia1 := 0;
        NroDatos := 0;
        Total := 0;
        CompetitionQuote.RESET;
        CompetitionQuote.SETRANGE("Quote Code", rec."Quote Code");
        if CompetitionQuote.FINDSET(FALSE) then
            repeat
                CompetitionQuote.CALCFIELDS(Evaluated, "Score High");
                if (CompetitionQuote.Evaluated) then begin
                    NroDatos += 1;
                    Total += CompetitionQuote."Score High";
                end;
            until CompetitionQuote.NEXT = 0;

        if (NroDatos <> 0) then
            PuntMedia1 := ROUND(Total / NroDatos, 0.01);

        //Calculo de la puntuaci�n media sin incluir la propia
        PuntMedia2 := 0;
        NroDatos := 0;
        Total := 0;
        CompetitionQuote.RESET;
        CompetitionQuote.SETRANGE("Quote Code", rec."Quote Code");
        if CompetitionQuote.FINDSET(FALSE) then
            repeat
                CompetitionQuote.CALCFIELDS(Evaluated, "Score High");
                if (CompetitionQuote."Competitor Code" <> '') and (CompetitionQuote.Evaluated) then begin
                    NroDatos += 1;
                    Total += CompetitionQuote."Score High";
                end;
            until CompetitionQuote.NEXT = 0;

        if (NroDatos <> 0) then
            PuntMedia2 := ROUND(Total / NroDatos, 0.01);
    end;

    LOCAL procedure SetEditable();
    begin
        bCompany := (rec."Competitor Code" = '');
        bEditable := (not bCompany);
    end;

    // begin
    /*{
      JAV 23/09/19: - Se cambia el caption de la page para que sea mas significativo
    }*///end
}







