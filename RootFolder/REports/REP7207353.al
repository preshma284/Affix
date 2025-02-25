report 7207353 "Set Target Price Comparative"
{


    ProcessingOnly = true;

    dataset
    {

        DataItem("Comparative Quote Header"; "Comparative Quote Header")
        {

            ;
            DataItem("Comparative Quote Lines"; "Comparative Quote Lines")
            {

                DataItemTableView = SORTING("Quote No.", "Type", "No.", "Activity Code")
                                 ORDER(Ascending);


                RequestFilterFields = "Quote No.", "Job No.", "Piecework No.", "Activity Code", "Type", "No.";
                DataItemLink = "Quote No." = FIELD("No.");
                trigger OnPreDataItem();
                BEGIN
                    IF (TargetPrice = 0) AND (DecreaseFactor = 0) THEN
                        ERROR(Text001);
                    Window.OPEN(Text002);
                    CLEAR(Currency);
                    Currency.InitRoundingPrecision;
                END;

                trigger OnAfterGetRecord();
                VAR
                    //                                   margen@7001100 :
                    margen: Decimal;
                    //                                   PventaTeorico@7001101 :
                    PventaTeorico: Decimal;
                BEGIN
                    // IF TargetPrice <> 0 THEN
                    //  VALIDATE("Target Price",TargetPrice);
                    //JMMA COMENTADO, EL CµLCULO ESTµ MAL A¥ADO CàDIGO correcto

                    // {
                    // IF CalculateK THEN BEGIN 
                    //   DataPieceworkForProduction.RESET;
                    //   DataPieceworkForProduction.SETRANGE("Job No.","Comparative Quote Lines"."Job No.");
                    //   DataPieceworkForProduction.SETRANGE("Piecework Code","Comparative Quote Lines"."Piecework No.");
                    //   IF DataPieceworkForProduction.FINDFIRST THEN BEGIN 
                    //     DataPieceworkForProduction.CALCFIELDS("Aver. Cost Price Pend. Budget");
                    //     margen := (DataPieceworkForProduction."Unit Price Sale (base)" - DataPieceworkForProduction."Aver. Cost Price Pend. Budget")/100;
                    //   END;
                    //   PventaTeorico := DataPieceworkForProduction."Aver. Cost Price Pend. Budget" * (1 + margen);
                    //   VALIDATE("Target Price",(PventaTeorico * "Comparative Quote Header".K)/100);
                    // END ELSE IF DecreaseFactor <> 0 THEN
                    //   VALIDATE("Target Price",ROUND("Estimated Price"*(DecreaseFactor / 100),
                    //                               Currency."Unit-Amount Rounding Precision"));
                    // MODIFY(TRUE);
                    // }

                    TargetPrice := 0;
                    CASE CalculateK OF
                        CalculateK::"Sobre Precio de Venta":
                            begin
                                // {---
                                // rJob.GET("Comparative Quote Lines"."Job No.");
                                // DataPieceworkForProduction.RESET;
                                // DataPieceworkForProduction.SETRANGE("Job No.","Comparative Quote Lines"."Job No.");
                                // DataPieceworkForProduction.SETRANGE("Piecework Code","Comparative Quote Lines"."Piecework No.");
                                // DataPieceworkForProduction.SETFILTER("Budget Filter",rJob."Current Piecework Budget");
                                // IF DataPieceworkForProduction.FINDFIRST THEN BEGIN 
                                //   DataPieceworkForProduction.CALCFIELDS("Aver. Cost Price Pend. Budget");
                                //   margen := (DataPieceworkForProduction."Unit Price Sale (base)" / DataPieceworkForProduction."Aver. Cost Price Pend. Budget");
                                // END;
                                // PventaTeorico := "Comparative Quote Lines"."Estimated Price"*margen;
                                // TargetPrice := (PventaTeorico * "Comparative Quote Header".K)/100;
                                // ---}

                                rJob.GET("Comparative Quote Lines"."Job No.");
                                DataPieceworkForProduction.RESET;
                                DataPieceworkForProduction.SETRANGE("Job No.", "Comparative Quote Lines"."Job No.");
                                DataPieceworkForProduction.SETRANGE("Piecework Code", "Comparative Quote Lines"."Piecework No.");
                                DataPieceworkForProduction.SETFILTER("Budget Filter", rJob."Current Piecework Budget");
                                IF DataPieceworkForProduction.FINDFIRST THEN
                                    //Q13150 -
                                    //TargetPrice := (DataPieceworkForProduction."Unit Price Sale (base)" * "Comparative Quote Header".K)/100;
                                    TargetPrice := DataPieceworkForProduction."Unit Price Sale (base)" * "Comparative Quote Header".K;
                                //Q13150 +
                            END;
                        CalculateK::"Sobre Precio de Coste":
                            BEGIN
                                //Q13150 -
                                //TargetPrice := "Estimated Price"*(DecreaseFactor / 100);
                                TargetPrice := "Estimated Price" * DecreaseFactor;
                                //Q13150 +
                            END;
                    END;

                    VALIDATE("Target Price", ROUND(TargetPrice, Currency."Unit-Amount Rounding Precision"));
                    MODIFY(TRUE);
                END;


            }
            trigger OnAfterGetRecord();
            BEGIN
                //JAV 26/03/19: - Se pasa en dato de la K a la cabecrra y se inclye el nuevo campo
                "Comparative Quote Header".K := DecreaseFactor;
                CASE CalculateK OF
                    CalculateK::"Sobre Precio de Venta":
                        "Comparative Quote Header"."K sobre" := "Comparative Quote Header"."K sobre"::Venta;
                    CalculateK::"Sobre Precio de Coste":
                        "Comparative Quote Header"."K sobre" := "Comparative Quote Header"."K sobre"::Coste;
                END;
                "Comparative Quote Header".MODIFY;
            END;


        }
    }
    requestpage
    {

        layout
        {
            area(content)
            {
                field("DecreaseFactor"; "DecreaseFactor")
                {

                    CaptionML = ENU = 'K', ESP = 'K';
                }
                field("Calculate K over Sales Price"; "CalculateK")
                {

                    CaptionML = ENU = 'Calculate K over Sales Price', ESP = 'Calcular K sobre precio de venta';
                }

            }
        }
    }
    labels
    {
    }

    var
        //       PurchaseJournalLine@7001105 :
        PurchaseJournalLine: Record 7207281;
        //       Currency@7001100 :
        Currency: Record 4;
        //       TargetPrice@7001103 :
        TargetPrice: Decimal;
        //       Window@7001102 :
        Window: Dialog;
        //       Text001@7001106 :
        Text001: TextConst ESP = 'Si va a ejecutar este proceso fije un precio o asigne un % de incremento para calcular el Imp.Objetivo';
        //       Text002@7001104 :
        Text002: TextConst ENU = 'Running Process', ESP = 'Ejecutando proceso';
        //       K@7001108 :
        K: Decimal;
        //       ComparativeQuoteHeader@7001109 :
        ComparativeQuoteHeader: Record 7207412;
        //       DataPieceworkForProduction@7001110 :
        DataPieceworkForProduction: Record 7207386;
        //       rJob@7001111 :
        rJob: Record 167;
        //       "------------------------- Par metros"@7001101 :
        "------------------------- Par metros": Integer;
        //       DecreaseFactor@7001112 :
        DecreaseFactor: Decimal;
        //       CalculateK@7001107 :
        CalculateK: Option "Sobre Precio de Venta","Sobre Precio de Coste";



    trigger OnInitReport();
    begin
        CalculateK := CalculateK::"Sobre Precio de Venta";
    end;



    // procedure GetK (ComparativeQuoteHeader@7001100 :
    procedure GetK(ComparativeQuoteHeader: Record 7207412)
    begin
        DecreaseFactor := ComparativeQuoteHeader.K;
    end;

    /*begin
    //{
//      JAV 26/03/19: - Se pasa en dato de la K a la cabecera y se inclye el nuevo campo de donde sale esa K
//      Q13150 JDC 06/04/21 - Modified function "Comparative Quote Lines - OnAfterGetRecord"
//    }
    end.
  */

}



