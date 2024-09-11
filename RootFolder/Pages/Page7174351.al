page 7174351 "DP Prorrata Percentajes"
{
    CaptionML = ENU = 'Prorrata Percentaje Setup', ESP = 'Configuraci�n Prorrata por Ejercicios';
    InsertAllowed = false;
    SourceTable = 7174351;
    PageType = ListPart;

    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("Starting Date"; rec."Starting Date")
                {

                    Visible = FALSe;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Ending Date"; rec."Ending Date")
                {

                    Visible = FALSE;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Application Year"; rec."Application Year")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Prorrata Calc. Type"; rec."Prorrata Calc. Type")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Prorrata %"; rec."Prorrata %")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Final Prorrata Calculated"; rec."Final Prorrata Calculated")
                {

                }
                field("New Prorrata Type"; rec."New Prorrata Type")
                {

                }
                field("Final Prorrata %"; rec."Final Prorrata %")
                {

                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Final Prorrata % Manual"; rec."Final Prorrata % Manual")
                {

                }
                field("Deductible Sales"; rec."Deductible Sales")
                {

                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Total Sales"; rec."Total Sales")
                {

                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Final Prorrata"; rec."Final Prorrata")
                {

                }
                field("General prorrata Amount"; rec."General prorrata Amount")
                {

                }
                field("Special prorrata Amount"; rec."Special prorrata Amount")
                {

                }
                field("Provisional VAT deducted"; rec."Provisional VAT deducted")
                {

                }
                field("Application difference"; rec."Application difference")
                {

                }
                field("Deductible Base Purchases"; rec."Deductible Base Purchases")
                {

                }
                field("Deductible Purchases General"; rec."Deductible Purchases General")
                {

                }
                field("Deductible Purchases Special"; rec."Deductible Purchases Special")
                {

                }
                field("Non-deductible Base Purchases"; rec."Non-deductible Base Purchases")
                {

                }
                field("Non-deductible Purchases Gral."; rec."Non-deductible Purchases Gral.")
                {

                }
                field("Joint Base Purchases"; rec."Joint Base Purchases")
                {

                }
                field("Joint Purchases"; rec."Joint Purchases")
                {

                }

            }

        }
    }
    actions
    {
        area(Processing)
        {

            action("Generate")
            {

                CaptionML = ESP = 'Crear Ejercicio';

                trigger OnAction()
                BEGIN
                    //JAV 21/06/22: - DP 1.00.00 Generar un nuevo ejercicio para la prorrata
                    DPManagement.GenerateYear;
                    CurrPage.UPDATE(FALSE);
                END;


            }
            action("CalculateProrrata")
            {

                CaptionML = ENU = 'Calculate Prorate', ESP = 'Calcular Prorrata Definitiva';
                Promoted = true;
                Enabled = enCalc;
                PromotedIsBig = true;
                Image = Calculate;
                PromotedCategory = Process;

                trigger OnAction()
                BEGIN
                    DPManagement.CalculateFinalProrrataPercentage(Rec);
                    CurrPage.UPDATE(FALSE);
                END;


            }
            action("ApplyProrrata")
            {

                CaptionML = ENU = 'Aplply final prorate', ESP = 'Aplicar Prorrata definitiva';
                Promoted = true;
                Enabled = enApply;
                PromotedIsBig = true;
                Image = PostponedInteractions;
                PromotedCategory = Process;


                trigger OnAction()
                BEGIN
                    DPManagement.ApplyFinalProrrata(Rec);
                    CurrPage.UPDATE(FALSE);
                END;


            }

        }
    }
    trigger OnAfterGetCurrRecord()
    BEGIN
        //Rec."Final Prorrata Calculated" := true; Rec.MODIFY;


        enCalc := (NOT Rec."Final Prorrata");
        enApply := (NOT Rec."Final Prorrata") AND (Rec."Final Prorrata Calculated");
    END;



    var
        DPProrrataPercentajes: Record 7174351;
        TxtError02: TextConst ENU = 'The year must be indicated.', ESP = 'Debe indicarse el a�o.';
        TxtError07: TextConst ENU = 'not is possible add the year %1', ESP = 'El a�o no puede ser %1';
        DPManagement: Codeunit 7174414;
        enCalc: Boolean;
        enApply: Boolean;

    LOCAL procedure CurrentLine(): Integer;
    var
        ProrrataSetup: Record 7174351;
        LastYear: Integer;
        FirstYear: Integer;
        totalYears: Integer;
        Tyears: Integer;
    begin
        //CEI14253 +
        if ProrrataSetup.FINDFIRST then begin
            FirstYear := ProrrataSetup."Application Year";
            if FirstYear = Rec."Application Year" then exit(1);
        end;
        if ProrrataSetup.FINDLAST then begin
            LastYear := ProrrataSetup."Application Year";
            if LastYear = rec."Application Year" then exit(Rec.COUNT());
        end;
        totalYears := LastYear - FirstYear;
        if (Rec."Application Year" <> LastYear) and (Rec."Application Year" <> FirstYear) and (totalYears > 0) and (totalYears < 100) then begin
            Tyears := ABS((totalYears * LastYear) / Rec.COUNT);
            exit(Tyears);
        end;
        //CEI14253 -
    end;

    // begin
    /*{
      JAV 21/06/22: - DP 1.00.00 Nueva p�gina para el manejo de las prorratas. Modificado a partir de MercaBarna DP04a, Q12228, CEI14253, Q13668, CEI14117
    }*///end
}








