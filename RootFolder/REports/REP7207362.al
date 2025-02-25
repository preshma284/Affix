report 7207362 "Cost Amount Increase"
{


    CaptionML = ENU = 'Cost Amount Increase', ESP = 'Incrementar Importes Coste';
    ProcessingOnly = true;

    dataset
    {

        DataItem("Data Piecework For Production"; "Data Piecework For Production")
        {

            DataItemTableView = SORTING("Job No.", "Piecework Code")
                                 WHERE("Customer Certification Unit" = CONST(true));


            RequestFilterFields = "Piecework Code";
            trigger OnPreDataItem();
            BEGIN
                CLEAR(Currency);
                Currency.InitRoundingPrecision;

                DataPieceworkForProduction.RESET; //Quitamos las marcas
            END;

            trigger OnAfterGetRecord();
            BEGIN
                //Marcamos las U.O. que vamos a procesar
                IF ("Data Piecework For Production"."Account Type" = "Data Piecework For Production"."Account Type"::Unit) THEN BEGIN
                    DataPieceworkForProduction.GET("Data Piecework For Production"."Job No.", "Data Piecework For Production"."Piecework Code");
                    DataPieceworkForProduction.MARK(TRUE);
                END ELSE BEGIN
                    "Data Piecework For Production".VALIDATE(Totaling);
                    DataPieceworkForProduction1.RESET;
                    DataPieceworkForProduction1.SETRANGE("Job No.", "Data Piecework For Production"."Job No.");
                    DataPieceworkForProduction1.SETFILTER("Piecework Code", "Data Piecework For Production".Totaling);
                    DataPieceworkForProduction1.SETRANGE("Account Type", DataPieceworkForProduction."Account Type"::Unit);
                    IF (DataPieceworkForProduction1.FINDSET) THEN
                        REPEAT
                            DataPieceworkForProduction.GET(DataPieceworkForProduction1."Job No.", DataPieceworkForProduction1."Piecework Code");
                            DataPieceworkForProduction.MARK(TRUE);
                        UNTIL DataPieceworkForProduction1.NEXT = 0;
                END;
            END;

            trigger OnPostDataItem();
            BEGIN
                DataPieceworkForProduction.MARKEDONLY(TRUE);

                //Primera pasada, calcular incremento si va por totales
                IF TotalAmount <> 0 THEN BEGIN
                    IF DataPieceworkForProduction.FINDSET(FALSE) THEN
                        REPEAT
                            DataPieceworkForProduction.SETFILTER("Budget Filter", CodBudget);
                            DataPieceworkForProduction.CALCFIELDS("Amount Cost Budget (JC)");
                            SelectionTotalAmount += DataPieceworkForProduction."Amount Cost Budget (JC)";
                            IF (DataPieceworkForProduction."Not Recalculate Cost") THEN
                                SelectionTotalAmount2 += DataPieceworkForProduction."Amount Cost Budget (JC)";
                        UNTIL DataPieceworkForProduction.NEXT = 0;

                    //JAV 03/02/20: - No recalcular U.O. marcadas para no hacerlo, eliminar de los importes lo que no se puede tocar
                    IF (TotalAmount - SelectionTotalAmount2 <= 0) OR (SelectionTotalAmount - SelectionTotalAmount2 <= 0) THEN
                        ERROR(Text002);
                    Increment := (TotalAmount - SelectionTotalAmount2) / (SelectionTotalAmount - SelectionTotalAmount2);
                END;

                IF (Increment <= 0) THEN
                    ERROR(Text002);

                //Segunda pasada, modificar los descompuestos, esto suben el precio a las partidas
                DataPieceworkForProduction.SETRANGE("Not Recalculate Cost", FALSE);
                IF DataPieceworkForProduction.FINDSET(TRUE) THEN
                    REPEAT
                        n1 += 1;
                        DataCostByPiecework.RESET;
                        DataCostByPiecework.SETRANGE("Job No.", DataPieceworkForProduction."Job No.");
                        DataCostByPiecework.SETRANGE("Piecework Code", DataPieceworkForProduction."Piecework Code");
                        DataCostByPiecework.SETRANGE("Cod. Budget", CodBudget);
                        IF (DataCostByPiecework.FINDSET(TRUE)) THEN
                            REPEAT
                                DataCostByPiecework.VALIDATE("Direct Unitary Cost (JC)", ROUND(DataCostByPiecework."Direct Unitary Cost (JC)" * Increment, Currency."Unit-Amount Rounding Precision"));
                                DataCostByPiecework.MODIFY(TRUE);
                                n2 += 1;
                            UNTIL (DataCostByPiecework.NEXT = 0);
                    UNTIL DataPieceworkForProduction.NEXT = 0;

                MESSAGE(Text003, n1, n2);
            END;


        }
    }
    requestpage
    {

        layout
        {
            area(content)
            {
                group("group634")
                {

                    CaptionML = ENU = 'Options', ESP = 'Opciones';
                    group("group635")
                    {

                        CaptionML = ENU = 'Amount Modify', ESP = 'Modificar importe';
                        field("Increment"; "Increment")
                        {

                            CaptionML = ENU = 'Increment %', ESP = 'k de Paso (inc/dec)';
                            DecimalPlaces = 2 : 6;
                            Editable = EditableIncrement;

                            ; trigger OnValidate()
                            BEGIN
                                IF Increment <> 0 THEN BEGIN
                                    EditableTotalAmount := FALSE;
                                END ELSE BEGIN
                                    EditableTotalAmount := TRUE;
                                END;
                                IF Increment < 0 THEN
                                    ERROR(Text001);
                            END;


                        }
                        field("TotalAmount"; "TotalAmount")
                        {

                            CaptionML = ENU = 'Total Amount', ESP = 'Importe Total';
                            Editable = EditableTotalAmount;



                            ; trigger OnValidate()
                            BEGIN
                                IF TotalAmount <> 0 THEN BEGIN
                                    EditableIncrement := FALSE;
                                END ELSE BEGIN
                                    EditableIncrement := TRUE;
                                END;
                                IF TotalAmount < 0 THEN
                                    ERROR(Text001);
                            END;


                        }

                    }

                }

            }
        }
        trigger OnInit()
        BEGIN
            EditableIncrement := TRUE;
            EditableTotalAmount := TRUE;
        END;


    }
    labels
    {
    }

    var
        //       DataPieceworkForProduction@1100286013 :
        DataPieceworkForProduction: Record 7207386;
        //       DataPieceworkForProduction1@1100286007 :
        DataPieceworkForProduction1: Record 7207386;
        //       DataCostByPiecework@1100286002 :
        DataCostByPiecework: Record 7207387;
        //       Currency@1100286009 :
        Currency: Record 4;
        //       Increment@1100286008 :
        Increment: Decimal;
        //       TotalAmount@1100286006 :
        TotalAmount: Decimal;
        //       TotalPrice@1100286004 :
        TotalPrice: Decimal;
        //       Porc@1100286003 :
        Porc: Decimal;
        //       EditableIncrement@1100286001 :
        EditableIncrement: Boolean;
        //       EditableTotalAmount@1100286000 :
        EditableTotalAmount: Boolean;
        //       Text001@1100286010 :
        Text001: TextConst ENU = 'You can''t enter negative numbers', ESP = 'No se puede introducir n£meros negativos';
        //       SelectionTotalAmount@1100286012 :
        SelectionTotalAmount: Decimal;
        //       SelectionTotalAmount2@1100286011 :
        SelectionTotalAmount2: Decimal;
        //       Text002@1100286014 :
        Text002: TextConst ESP = 'No se puede realziar el c lculo propuesto';
        //       CodBudget@1100286005 :
        CodBudget: Code[20];
        //       Text003@1100286015 :
        Text003: TextConst ESP = 'Se han modificado %1 U.O. y %2 descompuestos';
        //       n1@1100286016 :
        n1: Integer;
        //       n2@1100286017 :
        n2: Integer;

    //     procedure SetBudget (pBudget@1100286000 :
    procedure SetBudget(pBudget: Code[20])
    begin
        CodBudget := pBudget;
    end;

    /*begin
    //{
//                    - Modificado Request Form para permitir transformaci¢n del Request Page correcta. ESN a ESP en label.
//      PGM 10/09/19: - Modificado para que calcule bien el importe de venta
//      JAV 03/02/20: - No recalcular U.O. marcadas para no hacerlo
//      JAV 04/02/20: - Se rehace para que al marcar unidades de mayor calcule todas las de menor incluidas en ellas
//    }
    end.
  */

}



