page 7207594 "QB Objectives Card"
{
    CaptionML = ENU = 'Cabecera ficha APM';
    SourceTable = 7207403;
    DelayedInsert = true;
    PageType = ListPlus;

    layout
    {
        area(content)
        {
            group("General")
            {

                CaptionML = ENU = 'General', ESP = 'General';
                field("Job No."; rec."Job No.")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Job Name"; rec."Job Name")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Budget Code"; rec."Budget Code")
                {

                    Editable = False;
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Budget Date"; rec."Budget Date")
                {

                }
                field("Allow Negative"; rec."Allow Negative")
                {

                }
                field("User Allow Negative"; rec."User Allow Negative")
                {

                }
                field("Date Allow"; rec."Date Allow")
                {

                }

            }
            part("Income_Lines"; 7207595)
            {

                SubPageView = SORTING("Job No.", "Budget Code", "Line Type", "Record No.", "Piecework");
                SubPageLink = "Job No." = FIELD("Job No."), "Budget Code" = FIELD("Budget Code"), "Line Type" = CONST("Sales");
                UpdatePropagation = Both;
            }
            part("Cost_Lines"; 7207595)
            {

                SubPageView = SORTING("Job No.", "Budget Code", "Line Type", "Record No.", "Piecework");
                SubPageLink = "Job No." = FIELD("Job No."), "Budget Code" = FIELD("Budget Code"), "Line Type" = FILTER('DirectCost' | 'IndirectCost');
                UpdatePropagation = Both;
            }
            group("group14")
            {

                CaptionML = ESP = 'Totales';
                group("group15")
                {

                    group("group16")
                    {

                        grid("group17")
                        {

                            GridLayout = Rows;
                            group("group18")
                            {

                                CaptionML = ESP = 'Ingresos';
                                field("Income Approved"; rec."Income Approved")
                                {

                                    CaptionML = ESP = 'Total Aprobado';
                                }
                                field("Income Improvements"; rec."Income Improvements")
                                {

                                    CaptionML = ESP = 'Total Mejoras';
                                }
                                field("Income Target"; rec."Income Target")
                                {

                                    CaptionML = ESP = 'Total Objetivo';
                                }

                            }

                        }

                    }
                    group("group22")
                    {

                        grid("group23")
                        {

                            GridLayout = Rows;
                            group("group24")
                            {

                                CaptionML = ESP = 'Costes';
                                field("Cost Approved"; rec."Cost Approved")
                                {

                                    ShowCaption = false;
                                }
                                field("Cost Improvements"; rec."Cost Improvements")
                                {

                                    ShowCaption = false;
                                }
                                field("Cost Target"; rec."Cost Target")
                                {

                                    ShowCaption = false;
                                }

                            }

                        }

                    }
                    group("group28")
                    {

                        grid("group29")
                        {

                            GridLayout = Rows;
                            group("group30")
                            {

                                CaptionML = ESP = 'Resultado';
                                field("Total Approved"; rec."Total Approved")
                                {

                                    ShowCaption = false;
                                }
                                field("Total Improvements"; rec."Total Improvements")
                                {

                                    ShowCaption = false;
                                }
                                field("Total Target"; rec."Total Target")
                                {

                                    ShowCaption = false

  ;
                                }

                            }

                        }

                    }

                }

            }

        }
    }
    actions
    {
        area(Processing)
        {

            action("Permitir Negativo")
            {

                CaptionML = ENU = 'Allow Negative', ESP = 'Permitir Negativo';
                Enabled = QBAllowNegativeTarget;
                Image = NegativeLines;
                trigger OnAction()
                VAR
                    Txtmsg01: TextConst ENU = 'You want to APPROVE the negative project goal?', ESP = 'Desea APROBAR el objetivo del proyecto negativo?';
                    Txtmsg02: TextConst ENU = 'Do you want to revoke approval of the negative project goal?', ESP = '�Desea revocar la aprobaci�n del objetivo del proyecto negativo?';
                BEGIN
                                //  {//Q13643+ En T[5,3] esta el importe objetivo
                                            // Si el registro NO tiene marcado el campo �Allow Negative�:
                                            //    Pedir� confirmaci�n �Desea APROBAR el objetivo del proyecto negativo�,
                                            //    Si se confirma marcar� el campo �Allow Negative�, informar� en el campo �User Allow Negative� del usuario y del campo �Date Allow� con la fecha del sistema.
                                            // Si el registro TIENE marcado el campo �Allow Negative�:
                                            //    Pedir� confirmaci�n �Desea revocar la aprobaci�n del objetivo del proyecto negativo�,
                                            //    Si se confirma se desmarca el campo �Allow Negative� y se limpian los campos �User Allow Negative� y �Date Allow"
                                            //    }
                                 IF (NOT rec."Allow Negative") THEN BEGIN
                        IF CONFIRM(Txtmsg01, TRUE) THEN BEGIN
                            rec."Allow Negative" := TRUE;
                            rec."User Allow Negative" := USERID;
                            rec."Date Allow" := TODAY();
                            rec.MODIFY;
                        END;
                    END ELSE BEGIN
                        IF CONFIRM(Txtmsg02, TRUE) THEN BEGIN
                            rec."Allow Negative" := FALSE;
                            rec."User Allow Negative" := '';
                            rec."Date Allow" := 0D;
                            rec.MODIFY;
                        END;
                    END;
                    //Q13643-
                END;
            }

        }
        area(Promoted)
        {
            group(Category_Category5)
            {
                actionref("Permitir Negativo_Promoted"; "Permitir Negativo")
                {
                }
            }
        }
    }

    trigger OnOpenPage()
    BEGIN
        CurrPage.Income_Lines.PAGE.SetType(0);
        CurrPage.Cost_Lines.PAGE.SetType(1);
    END;

    trigger OnAfterGetRecord()
    BEGIN
        CalculateSums;
    END;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    BEGIN
        IF (rec."Total Target" < 0) THEN
            MESSAGE('El resultado es negativo, no podr� cerrar el mes si no cambia o le aprueban expresamente la ficha.');
    END;

    trigger OnAfterGetCurrRecord()
    BEGIN
        CalculateSums;
    END;



    var
        AdditionalDataPPO: Record 7207405;
        Text001: TextConst ENU = 'Do you want to Rec.COPY slope data from the previous reestimate?', ESP = '�Desea copiar los datos de pendiente de la reestimaci�n anterior?';
        HeaderCardAPM: Record 7207403;
        LineCardAPM: Record 7207404;
        LineCardAPMActual: Record 7207404;
        AdditionalDataPPOActual: Record 7207405;
        QBAllowNegativeTarget: Boolean;

    procedure CopyReestimation();
    var
        LastEntry: Integer;
    begin
    end;

    procedure DataPPO();
    begin
    end;

    LOCAL procedure CalculateSums();
    begin
        //Calcula los totales de las l�neas
        rec."Income Approved" := 0;
        rec."Cost Approved" := 0;
        rec."Total Approved" := 0;
        rec."Income Improvements" := 0;
        rec."Cost Improvements" := 0;
        rec."Total Improvements" := 0;
        rec."Income Target" := 0;
        rec."Cost Target" := 0;
        rec."Total Target" := 0;

        //Calcular ingresos
        LineCardAPM.RESET;
        LineCardAPM.SETRANGE("Job No.", rec."Job No.");
        LineCardAPM.SETRANGE("Budget Code", rec."Budget Code");
        LineCardAPM.SETRANGE("Line Type", LineCardAPM."Line Type"::Sales);
        LineCardAPM.CALCSUMS("Improvement Amount");
        rec."Income Improvements" := LineCardAPM."Improvement Amount";

        LineCardAPM.SETFILTER(Piecework, '=%1', '');
        LineCardAPM.CALCSUMS(Approved);
        rec."Income Approved" := LineCardAPM.Approved;

        rec."Income Target" := rec."Income Approved" + rec."Income Improvements";

        //Calcular gastos
        LineCardAPM.RESET;
        LineCardAPM.SETRANGE("Job No.", rec."Job No.");
        LineCardAPM.SETRANGE("Budget Code", rec."Budget Code");
        LineCardAPM.SETRANGE("Line Type", LineCardAPM."Line Type"::DirectCost, LineCardAPM."Line Type"::IndirectCost);
        LineCardAPM.CALCSUMS("Improvement Amount");
        rec."Cost Improvements" := LineCardAPM."Improvement Amount";

        LineCardAPM.SETFILTER(Piecework, '=%1', '');
        LineCardAPM.CALCSUMS(Approved);
        rec."Cost Approved" := LineCardAPM.Approved;

        rec."Cost Target" := rec."Cost Approved" + rec."Cost Improvements";

        //Calcular Resultado
        rec."Total Approved" := rec."Income Approved" - rec."Cost Approved";
        rec."Total Improvements" := rec."Income Improvements" - rec."Cost Improvements";
        rec."Total Target" := rec."Income Target" - rec."Cost Target";
        Rec.MODIFY;  //Guardamos los c�lculos efectuados

        //Q13643+
        QBAllowNegativeTarget := UserQBAllwNegTarg();
        //Q13643-
    end;

    LOCAL procedure UserQBAllwNegTarg(): Boolean;
    var
        UserSetup: Record 91;
    begin
        //Q13643+
        if UserSetup.GET(USERID) then
            exit(FALSE)
        ELSE// EL bot�n �Permitir Negativo� solo estar� activo si el usuario tiene activo en su configuraci�n el campo �QB Allow Negative Target� y el importe final de la ficha de objetivos es negativo
            exit((UserSetup."QB Allow Negative Target") and (rec."Total Target" < 0));
        //Q13643-
    end;

    // begin
    /*{
      Q13643 MMS 13/07/21 Se a�aden campos 12 rec."Allow Negative", campo 13 rec."User Allow Negative", campo 14 rec."Date Allow"
      Q13643 MMS 13/07/21 Se a�ade  nuevo bot�n �Permitir Negativo�, estar� activo si el usuario tiene activo en su configuraci�n el campo �QB Allow Negative Target�
                          y el importe final de la ficha de objetivos es negativo. Este bot�n es un interruptor de:
                          1- Si el registro NO tiene marcado el campo �Allow Negative� pedir� confirmaci�n �Desea APROBAR el objetivo del proyecto negativo�,si se confirma:
                          marcar� el campo �Allow Negative�, informar� en el campo �User Allow Negative� del usuario, el campo �Date Allow� con la fecha del sistema.
                          2- Si el registro TIENE marcado el campo �Allow Negative� pedir� confirmaci�n �Desea revocar la aprobaci�n del objetivo del proyecto negativo�, si se confirma
      Q13643 MMS 14/07/21 Nuevo bot�n permitir negativo que se activa si el usuario tiene QBAllowNegativeTarget := true que usa la funcion UserQBAllwNegTarg(); para saberlo
                          y que sirve para desmarcar o Marcar el campo �Allow Negative� y se limpian los campos �User Allow Negative� y �Date Allow�
    }*///end
}







