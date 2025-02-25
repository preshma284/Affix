report 7207282 "Sales Amount Increase"
{


    CaptionML = ENU = 'Sales Amount Increase', ESP = 'Increment. imp. venta';
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
                IF (opcType = opcType::Importe) THEN BEGIN
                    IF DataPieceworkForProduction.FINDSET(FALSE) THEN
                        REPEAT
                            SelectionTotalAmount += DataPieceworkForProduction."Sale Amount";
                            //JAV 03/02/20: - No recalcular U.O. marcadas para no hacerlo, eliminar de los importes lo que no se puede tocar
                            IF (DataPieceworkForProduction."Not Recalculate Sale") THEN
                                SelectionTotalAmount2 += DataPieceworkForProduction."Sale Amount";
                        UNTIL DataPieceworkForProduction.NEXT = 0;

                    IF (opcTotalAmount - SelectionTotalAmount2 <= 0) OR (SelectionTotalAmount - SelectionTotalAmount2 <= 0) THEN
                        ERROR(Text002);
                    opcIncrement := (opcTotalAmount - SelectionTotalAmount2) / (SelectionTotalAmount - SelectionTotalAmount2);
                END;

                IF (opcIncrement <= 0) THEN
                    ERROR(Text002);

                //Segunda pasada, modificar
                DataPieceworkForProduction.SETRANGE("Not Recalculate Sale", FALSE);
                IF DataPieceworkForProduction.FINDSET(TRUE) THEN
                    REPEAT
                        //PUESTO POR JMMA NO TOCAR, PREGUNTAR A MANUEL
                        DataPieceworkForProduction.VALIDATE("Contract Price", ROUND(DataPieceworkForProduction."Contract Price" * opcIncrement, Currency."Unit-Amount Rounding Precision"));
                        //JAV Si se aumenta con el porcentaje de gastos
                        IF (opcType = opcType::"K+Gastos") THEN
                            DataPieceworkForProduction.VALIDATE("Contract Price", ROUND(DataPieceworkForProduction."Contract Price" * (100 + opcGastos) / 100, Currency."Unit-Amount Rounding Precision"));

                        DataPieceworkForProduction.VALIDATE(DataPieceworkForProduction."Unit Price Sale (base)", ROUND(DataPieceworkForProduction."Unit Price Sale (base)", 0.01));
                        DataPieceworkForProduction.VALIDATE("Sale Amount", DataPieceworkForProduction."Contract Price" * DataPieceworkForProduction."Sale Quantity (base)"); //PGM 10/09/2019

                        //QVE2837 <<
                        IF DataPieceworkForProduction."Production Unit" THEN
                            DataPieceworkForProduction.VALIDATE("Initial Produc. Price", DataPieceworkForProduction."Unit Price Sale (base)");

                        DataPieceworkForProduction.MODIFY;
                    UNTIL DataPieceworkForProduction.NEXT = 0;
            END;


        }
    }
    requestpage
    {

        layout
        {
            area(content)
            {
                group("group397")
                {

                    CaptionML = ENU = 'Options', ESP = 'Opciones';
                    group("group398")
                    {

                        CaptionML = ENU = 'Amount Modify', ESP = 'Modificar importe';
                        field("opcType"; "opcType")
                        {

                            CaptionML = ESP = 'Tipo de c lculo';

                            ; trigger OnValidate()
                            BEGIN
                                edIncrement := (opcType <> opcType::Importe);
                                edGastos := (opcType = opcType::"K+Gastos");
                                edTotalAmount := (opcType = opcType::Importe);
                            END;


                        }
                        field("opcIncrement"; "opcIncrement")
                        {

                            CaptionML = ENU = 'Increment %', ESP = 'k de Paso (inc/dec)';
                            DecimalPlaces = 2 : 6;
                            Editable = edIncrement;

                            ; trigger OnValidate()
                            BEGIN
                                IF opcIncrement < 0 THEN
                                    ERROR(Text001);
                            END;


                        }
                        field("opcGastos"; "opcGastos")
                        {

                            CaptionML = ESP = '% Gastos';
                            Editable = edGastos;

                            ; trigger OnValidate()
                            BEGIN
                                IF opcGastos < 0 THEN
                                    ERROR(Text001);
                            END;


                        }
                        field("opcTotalAmount"; "opcTotalAmount")
                        {

                            CaptionML = ENU = 'Total Amount', ESP = 'Importe Total';
                            Editable = edTotalAmount;



                            ; trigger OnValidate()
                            BEGIN
                                IF opcTotalAmount < 0 THEN
                                    ERROR(Text001);
                            END;


                        }

                    }

                }

            }
        }
        trigger OnInit()
        BEGIN
            edIncrement := TRUE;
            edGastos := FALSE;
            edTotalAmount := FALSE;
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
        //       Currency@1100286009 :
        Currency: Record 4;
        //       Job@1100286017 :
        Job: Record 167;
        //       TotalPrice@1100286004 :
        TotalPrice: Decimal;
        //       Porc@1100286003 :
        Porc: Decimal;
        //       Text001@1100286010 :
        Text001: TextConst ENU = 'You can''t enter negative numbers', ESP = 'No se puede introducir n£meros negativos';
        //       SelectionTotalAmount@1100286012 :
        SelectionTotalAmount: Decimal;
        //       SelectionTotalAmount2@1100286011 :
        SelectionTotalAmount2: Decimal;
        //       Text002@1100286014 :
        Text002: TextConst ESP = 'No se puede realziar el c lculo propuesto';
        //       "------------------------------------ Opciones"@1100286002 :
        "------------------------------------ Opciones": Integer;
        //       opcType@1100286008 :
        opcType: Option "K","K+Gastos","Importe";
        //       opcIncrement@1100286006 :
        opcIncrement: Decimal;
        //       opcGastos@1100286015 :
        opcGastos: Decimal;
        //       opcTotalAmount@1100286005 :
        opcTotalAmount: Decimal;
        //       edIncrement@1100286001 :
        edIncrement: Boolean;
        //       edGastos@1100286016 :
        edGastos: Boolean;
        //       edTotalAmount@1100286000 :
        edTotalAmount: Boolean;

    //     procedure SetJob (pJob@1100286000 :
    procedure SetJob(pJob: Code[20])
    begin
        Job.GET(pJob);
        opcGastos := Job."General Expenses / Other";
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



