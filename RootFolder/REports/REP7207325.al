report 7207325 "Increase Bill of Item Cost"
{


    CaptionML = ENU = 'Increase Bill of Item Cost', ESP = 'Incrementar precios descompuesto coste';
    ProcessingOnly = true;

    dataset
    {

        DataItem("Cost Database"; "Cost Database")
        {

            DataItemTableView = SORTING("Code");

            ;
            trigger OnAfterGetRecord();
            BEGIN
                //Proceso de cambio del precio

                Coeficiente := (100 + opcPercentage) / 100;

                //Si es ajustar el total, calcular el coeficiente que le corresponde
                IF (opcTypeUpgrade = opcTypeUpgrade::AdjustCost) THEN BEGIN
                    Piecework.RESET;
                    Piecework.SETRANGE("Cost Database Default", "Cost Database".Code);
                    Piecework.SETRANGE("Account Type", Piecework."Account Type"::Unit);
                    Piecework.CALCSUMS("Total Amount Cost");
                    IF (Piecework."Total Amount Cost" = 0) THEN
                        ERROR('El importe de coste del preciario es cero, no se puede procesar');
                    Coeficiente := opcTotalAmount / Piecework."Total Amount Cost";
                END;

                IF (opcTypeUpgrade = opcTypeUpgrade::AdjustSale) THEN BEGIN
                    Piecework.RESET;
                    Piecework.SETRANGE("Cost Database Default", "Cost Database".Code);
                    Piecework.SETRANGE("Account Type", Piecework."Account Type"::Unit);
                    Piecework.CALCSUMS("Total Amount Sales");
                    TotalCost := Piecework."Total Amount Sales";
                    IF (Piecework."Total Amount Sales" = 0) THEN
                        ERROR('El importe de venta del preciario es cero, no se puede procesar');
                    Coeficiente := opcTotalAmount / Piecework."Total Amount Sales";
                END;


                BillofItemData.RESET;
                BillofItemData.SETRANGE("Cod. Cost database", "Cost Database".Code);
                IF (opcTypeUpgrade IN [opcTypeUpgrade::IncreaseCost, opcTypeUpgrade::AdjustCost, opcTypeUpgrade::AveragePriceCost, opcTypeUpgrade::LastPriceCost]) THEN
                    BillofItemData.SETRANGE(Use, BillofItemData.Use::Cost)
                ELSE
                    BillofItemData.SETRANGE(Use, BillofItemData.Use::Sales);
                IF (BillofItemData.FINDSET(TRUE)) THEN
                    REPEAT

                        CASE opcTypeUpgrade OF
                            opcTypeUpgrade::IncreaseCost, opcTypeUpgrade::AdjustCost:
                                BEGIN
                                    BillofItemData.VALIDATE("Direct Unit Cost", ROUND(BillofItemData."Direct Unit Cost" * Coeficiente, 0.0001));
                                    BillofItemData.VALIDATE("Unit Cost Indirect", ROUND(BillofItemData."Unit Cost Indirect" * Coeficiente, 0.0001));
                                END;

                            opcTypeUpgrade::IncreaseSale, opcTypeUpgrade::AdjustSale:
                                BEGIN
                                    BillofItemData.VALIDATE("Direct Unit Cost", ROUND(BillofItemData."Direct Unit Cost" * Coeficiente, 0.0001));
                                END;

                            opcTypeUpgrade::LastPriceCost:
                                BEGIN
                                    CASE BillofItemData.Type OF
                                        BillofItemData.Type::Resource:
                                            BEGIN
                                                Resource.GET(BillofItemData."No.");
                                                IF NOT ResourceCost.GET(ResourceCost.Type::Resource, BillofItemData."No.", '') THEN BEGIN
                                                    CLEAR(ResourceCost);
                                                    ResourceCost."Direct Unit Cost" := Resource."Direct Unit Cost";
                                                    ResourceCost."Unit Cost" := Resource."Unit Cost";
                                                END;
                                                BillofItemData.VALIDATE("Direct Unit Cost", ResourceCost."Direct Unit Cost");
                                                BillofItemData.VALIDATE("Unit Cost Indirect", ResourceCost."Unit Cost" - ResourceCost."Direct Unit Cost");
                                                BillofItemData.VALIDATE("Units of Measure", Resource."Base Unit of Measure");
                                            END;
                                        BillofItemData.Type::Item:
                                            BEGIN
                                                IF Item.GET(BillofItemData."No.") THEN BEGIN
                                                    BillofItemData.VALIDATE("Direct Unit Cost", Item."Last Direct Cost");
                                                    BillofItemData.VALIDATE("Units of Measure", Item."Base Unit of Measure");
                                                END;
                                            END;
                                    END;
                                END;

                            opcTypeUpgrade::AveragePriceCost:
                                BEGIN
                                    CASE BillofItemData.Type OF
                                        BillofItemData.Type::Resource:
                                            BEGIN
                                                Resource.GET(BillofItemData."No.");
                                                IF NOT ResourceCost.GET(ResourceCost.Type::Resource, BillofItemData."No.", '') THEN BEGIN
                                                    CLEAR(ResourceCost);
                                                    ResourceCost."Direct Unit Cost" := Resource."Direct Unit Cost";
                                                    ResourceCost."Unit Cost" := Resource."Unit Cost";
                                                END;
                                                BillofItemData.VALIDATE("Direct Unit Cost", ResourceCost."Direct Unit Cost");
                                                BillofItemData.VALIDATE("Unit Cost Indirect", ResourceCost."Unit Cost" - ResourceCost."Direct Unit Cost");
                                                BillofItemData.VALIDATE("Units of Measure", Resource."Base Unit of Measure");
                                            END;
                                        BillofItemData.Type::Item:
                                            BEGIN
                                                IF Item.GET(BillofItemData."No.") THEN BEGIN
                                                    BillofItemData.VALIDATE("Direct Unit Cost", Item."Unit Cost");
                                                    BillofItemData.VALIDATE("Units of Measure", Item."Base Unit of Measure");
                                                END;
                                            END;
                                    END;
                                END;
                        END;

                        BillofItemData.MODIFY;

                    UNTIL (BillofItemData.NEXT = 0);
            END;

            trigger OnPostDataItem();
            BEGIN
                // IF (opcTotalAmount <> 0) THEN BEGIN 
                //  Piecework.RESET;
                //  Piecework.SETRANGE("Cost Database Default",BillofItemData."Cod. Cost database");
                //  Piecework.SETRANGE("Account Type",Piecework."Account Type"::Unit);
                //  //Piecework.SETRANGE("No.",BillofItemData."Cod. Piecework");
                //  IF Piecework.FINDSET THEN BEGIN 
                //    REPEAT
                //      Piecework.VALIDATE("Price Cost",Piecework."Price Cost" * Coeficiente);
                //      Piecework.VALIDATE("Proposed Sale Price",Piecework."Proposed Sale Price" * Coeficiente);
                //      Piecework.MODIFY;
                //    UNTIL Piecework.NEXT = 0;
                //  END;
                // END;
                //
                //CalculateCostHeading;
                // MESSAGE(Text001);
            END;


        }
    }
    requestpage
    {

        layout
        {
            area(content)
            {
                group("group500")
                {

                    CaptionML = ENU = 'Options';
                    field("Type"; "opcTypeUpgrade")
                    {

                        CaptionML = ESP = 'Tipo de c lculo';
                        // OptionCaptionML=ESP='Tipo de c lculo';

                        ; trigger OnValidate()
                        BEGIN
                            edPercentaje := (opcTypeUpgrade = opcTypeUpgrade::IncreaseCost) OR (opcTypeUpgrade = opcTypeUpgrade::IncreaseSale);
                            edTotalAmount := (opcTypeUpgrade = opcTypeUpgrade::AdjustCost) OR (opcTypeUpgrade = opcTypeUpgrade::AdjustSale);

                            IF (opcTypeUpgrade <> opcTypeUpgrade::IncreaseCost) AND (opcTypeUpgrade <> opcTypeUpgrade::IncreaseSale) THEN
                                opcPercentage := 0;
                            IF (opcTypeUpgrade <> opcTypeUpgrade::AdjustCost) AND (opcTypeUpgrade <> opcTypeUpgrade::AdjustSale) THEN
                                opcTotalAmount := 0;
                        END;


                    }
                    field("Perc"; "opcPercentage")
                    {

                        CaptionML = ESP = '% de incremento';
                        DecimalPlaces = 0 : 8;
                        Editable = EdPercentaje;

                        ; trigger OnValidate()
                        BEGIN
                            IF opcPercentage < 0 THEN
                                ERROR(Text002);
                        END;


                    }
                    field("Tot"; "opcTotalAmount")
                    {

                        CaptionML = ENU = 'Total Amount', ESP = 'Importe Total';
                        Editable = EdTotalAmount;



                        ; trigger OnValidate()
                        BEGIN
                            IF opcTotalAmount < 0 THEN
                                ERROR(Text002);
                        END;


                    }

                }

            }
        }
        trigger OnInit()
        BEGIN
            edPercentaje := TRUE;
            edTotalAmount := FALSE;
        END;


    }
    labels
    {
    }

    var
        //       BillofItemData@1100286008 :
        BillofItemData: Record 7207384;
        //       Resource@7207270 :
        Resource: Record 156;
        //       Item@7207271 :
        Item: Record 27;
        //       ResourceCost@7207272 :
        ResourceCost: Record 202;
        //       Text001@7001100 :
        Text001: TextConst ENU = 'Modified Price Bill of Item', ESP = 'Precio de descompuesto modificado';
        //       Piecework@7001104 :
        Piecework: Record 7207277;
        //       Text002@1100286000 :
        Text002: TextConst ENU = 'You can''t enter negative numbers', ESP = 'No se puede introducir n£meros negativos';
        //       Piecework2@1100286004 :
        Piecework2: Record 7207277;
        //       TotalCost@1100286010 :
        TotalCost: Decimal;
        //       Coeficiente@1100286009 :
        Coeficiente: Decimal;
        //       "--------------------------- Opciones"@1100286003 :
        "--------------------------- Opciones": Integer;
        //       opcTypeUpgrade@1100286007 :
        opcTypeUpgrade: Option "IncreaseCost","AdjustCost","LastPriceCost","AveragePriceCost","IncreaseSale","AdjustSale";
        //       opcPercentage@1100286006 :
        opcPercentage: Decimal;
        //       opcTotalAmount@1100286005 :
        opcTotalAmount: Decimal;
        //       edPercentaje@1100286002 :
        edPercentaje: Boolean;
        //       edTotalAmount@1100286001 :
        edTotalAmount: Boolean;

    /*begin
    end.
  */

}



