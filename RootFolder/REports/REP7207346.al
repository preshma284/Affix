report 7207346 "Generate Blanket Order_Order"
{


    Permissions = TableData 5714 = rimd;
    CaptionML = ENU = 'Generate Blanket Order_Order', ESP = 'Generar Pedido Abierto/Pedido';
    ProcessingOnly = true;

    dataset
    {

        DataItem("Comparative Quote Header"; "Comparative Quote Header")
        {

            DataItemTableView = SORTING("No.");
            ;
            DataItem("Comparative Quote Lines"; "Comparative Quote Lines")
            {

                DataItemTableView = SORTING("Quote No.", "Line No.");
                DataItemLink = "Quote No." = FIELD("No."),
                            "Selected Vendor" = FIELD("Selected Vendor");
                trigger OnAfterGetRecord();
                VAR
                    //                                   Job2@1100251000 :
                    Job2: Record 167;
                    //                                   OptionTointeger@1100286000 :
                    OptionTointeger: Integer;
                    //                                   InventoryPostingSetup@1100286001 :
                    InventoryPostingSetup: Record 5813;
                    //                                   Locat@1100286002 :
                    Locat: Code[20];
                BEGIN
                    LineLinesNo := LineLinesNo + 1;
                    Window.UPDATE(2, LineLinesNo);

                    //Leer la l¡nea del proveedor para obtener los datos de precios, siempre tengo que tener un proveedor real, por lo qme salto el contacto de la clave
                    DataPricesVendor.RESET;
                    DataPricesVendor.SETRANGE("Quote Code", "Comparative Quote Header"."No.");
                    DataPricesVendor.SETRANGE("Vendor No.", "Comparative Quote Header"."Selected Vendor");

                    //Q13150 -
                    DataPricesVendor.SETRANGE("Contact No.", "Comparative Quote Header"."Contact Selectd No.");
                    DataPricesVendor.SETRANGE("Version No.", "Comparative Quote Header"."Selected Version No.");
                    //Q13150 +

                    DataPricesVendor.SETRANGE("Line No.", "Comparative Quote Lines"."Line No.");
                    DataPricesVendor.FINDFIRST;

                    //JAV 05/06/22: - QB 1.10.47 Se verifica que sea posible generar estas l¡neas
                    IF (DataPricesVendor.Quantity = 0) OR (DataPricesVendor."Vendor Price" = 0) THEN
                        ERROR('Tiene l¡neas con cantidad o precio a cero, no puede generar un contrato');


                    //Montar la l¡nea
                    LastNumberLine += 10000;

                    //Guardar datos en la l¡nea del comparativo
                    "Comparative Quote Lines"."Contract Document Type" := PurchaseHeader."Document Type";
                    "Comparative Quote Lines"."Contract Document No." := PurchaseHeader."No.";
                    "Comparative Quote Lines"."Contract Line No." := LastNumberLine;
                    "Comparative Quote Lines"."Qty. in Contract" := "Comparative Quote Lines".Quantity;
                    "Comparative Quote Lines".MODIFY;

                    //Crear la l¡nea
                    PurchaseLine.INIT;
                    PurchaseLine.VALIDATE("Document Type", PurchaseHeader."Document Type");
                    PurchaseLine.VALIDATE("Document No.", PurchaseHeader."No.");
                    PurchaseLine.VALIDATE("Line No.", LastNumberLine);
                    PurchaseLine.INSERT(TRUE);

                    //JAV 10/03/21: - QB 1.08.23 Pongo estos valores ya en el resgistro, as¡ los validates actuar n correctamente posteriormente
                    PurchaseLine."No." := DataPricesVendor."No.";                                    //Guardar el c¢digo del producto o recurso
                    PurchaseLine.Quantity := DataPricesVendor.Quantity;                              //Guardar la cantidad
                    PurchaseLine."Direct Unit Cost" := DataPricesVendor."Vendor Price";              //Guardar el precio
                    PurchaseLine."QB tmp From Comparative" := TRUE;
                    //18294 CSM 10/02/23 -
                    //Tener en cuenta si el comparativo Segregado, ya no es la Cantidad original del proveedor, sino la de la Segregaci¢n.
                    IF PurchaseLine.Quantity > "Comparative Quote Lines"."Qty. in Contract" THEN BEGIN
                        PurchaseLine.Quantity := "Comparative Quote Lines"."Qty. in Contract";
                        QuantityToPurchLine := PurchaseLine.Quantity;
                    END ELSE
                        QuantityToPurchLine := 0;
                    //18294 CSM 10/02/23 +
                    PurchaseLine.MODIFY;

                    //A¤adir los datos de la l¡nea validando para que haga los procesos correctos
                    PurchaseLine.VALIDATE("Buy-from Vendor No.", "Comparative Quote Header"."Selected Vendor");
                    IF "Comparative Quote Lines".Type = "Comparative Quote Lines".Type::Item THEN BEGIN
                        Item.GET("Comparative Quote Lines"."No.");
                        PurchaseLine.Type := PurchaseLine.Type::Item;
                        PurchaseLine.VALIDATE("No.", "Comparative Quote Lines"."No.");
                        PurchaseLine.VALIDATE("Gen. Prod. Posting Group", Item."Gen. Prod. Posting Group");
                        PurchaseLine.VALIDATE("VAT Prod. Posting Group", Item."VAT Prod. Posting Group");
                        PurchaseLine.VALIDATE("Tax Group Code", Item."Tax Group Code");
                    END;
                    IF "Comparative Quote Lines".Type = "Comparative Quote Lines".Type::Resource THEN BEGIN
                        Resource.GET("Comparative Quote Lines"."No.");
                        PurchaseLine.Type := PurchaseLine.Type::Resource;
                        PurchaseLine.VALIDATE("No.", "Comparative Quote Lines"."No.");
                        PurchaseLine.VALIDATE("Gen. Prod. Posting Group", Resource."Gen. Prod. Posting Group");
                        PurchaseLine.VALIDATE("VAT Prod. Posting Group", Resource."VAT Prod. Posting Group");
                        PurchaseLine.VALIDATE("Tax Group Code", Resource."Tax Group Code");
                    END;
                    PurchaseLine.Description := "Comparative Quote Lines".Description;
                    PurchaseLine."Description 2" := "Comparative Quote Lines"."Description 2";
                    PurchaseLine.VALIDATE("Code Piecework PRESTO", "Comparative Quote Lines"."Code Piecework PRESTO"); //QVE3685
                    PurchaseLine.VALIDATE("Unit of Measure Code", "Comparative Quote Lines"."Unit of measurement Code");
                    PurchaseLine.VALIDATE("Gen. Bus. Posting Group", PurchaseHeader."Gen. Bus. Posting Group");
                    //18294 CSM 10/02/23 -
                    //Tener en cuenta si el comparativo Segregado, ya no es la Cantidad original del proveedor, sino la de la Segregaci¢n.
                    IF QuantityToPurchLine <> 0 THEN
                        PurchaseLine.VALIDATE(Quantity, QuantityToPurchLine)
                    ELSE
                        //18294 CSM 10/02/23 +
                        PurchaseLine.VALIDATE(Quantity, DataPricesVendor.Quantity);  //Validamos para que haga los c lculos
                    PurchaseLine.VALIDATE("Direct Unit Cost", DataPricesVendor."Vendor Price");   //JAV 05/06/22: - Se cambia de lugar para que siempre sea lo £ltimo, si no puede usar otros precios

                    //-Q16539 Si se unidica por Cantidad = Total y Precio = 1
                    IF "Comparative Quote Header"."QB Comp Value Qty.  Purc. Line" = "Comparative Quote Header"."QB Comp Value Qty.  Purc. Line"::Amount THEN BEGIN
                        //Q19330-
                        PreviousAmount := PurchaseLine.Amount;
                        //Q19330+
                        //JAV 08/07/22: - QB 1.11.00 Se cambia el orden de los campos para que no produzca desbordamiento si el importe es muy grande al calcular cantidad*precio
                        PurchaseLine.VALIDATE("Direct Unit Cost", 1);
                        //Q19330-
                        PurchaseLine.VALIDATE(Quantity, PreviousAmount);
                        //PurchaseLine.VALIDATE(Quantity,PurchaseLine.Amount);
                        //Q19330+
                    END;
                    //+Q16539

                    IF OrderOptions = OrderOptions::"Blanket Order" THEN BEGIN
                        PurchaseLine.VALIDATE("Unit Price (LCY)", DataPricesVendor."Vendor Price");
                        PurchaseLine."Job No." := "Comparative Quote Lines"."Job No.";                     //JAV 13/03/22: - QB 1.10.24 Eliminamos el Validate para evitar que pida cambiarlo en la cabecera
                        PurchaseLine."Piecework No." := "Comparative Quote Lines"."Piecework No.";         //JAV 13/03/22: - QB 1.10.24 Eliminamos el Validate para evitar que pida cambiarlo en la cabecera
                    END;

                    IF PurchaseHeader."QB Order To" = PurchaseHeader."QB Order To"::Location THEN BEGIN
                        IF ("Comparative Quote Lines"."Location Code" <> '') AND ("Comparative Quote Lines".Type = "Comparative Quote Lines".Type::Item) THEN
                            PurchaseLine.VALIDATE("Location Code", "Comparative Quote Lines"."Location Code");
                    END ELSE BEGIN
                        PurchaseLine."Job No." := "Comparative Quote Lines"."Job No.";                     //JAV 13/03/22: - QB 1.10.24 Eliminamos el Validate para evitar que pida cambiarlo en la cabecera
                        IF ("Comparative Quote Lines"."Piecework No." = '') THEN BEGIN
                            IF (Job2.GET(PurchaseLine."Job No.")) THEN
                                IF (Job2."Warehouse Cost Unit" <> '') THEN
                                    PurchaseLine."Piecework No." := Job2."Warehouse Cost Unit";

                            //JAV 13/01/22: - QB 1.11.00 Si pongo en la l¡nea la unidad de almac‚n, debo poner el CA asociado al almac‚n en el comparativo para que lo pase bien
                            IF (Item.GET(PurchaseLine."No.")) THEN BEGIN
                                IF (InventoryPostingSetup.GET(Job."Job Location", Item."Inventory Posting Group")) THEN BEGIN
                                    IF ("Comparative Quote Lines"."QB CA Value" <> InventoryPostingSetup."Analytic Concept") THEN BEGIN
                                        "Comparative Quote Lines".VALIDATE("QB CA Value", InventoryPostingSetup."Analytic Concept");
                                        "Comparative Quote Lines".MODIFY;
                                    END;
                                END;
                            END;

                        END ELSE BEGIN
                            PurchaseLine."Piecework No." := "Comparative Quote Lines"."Piecework No."

                        END;
                    END;
                    PurchaseLine."QB Contract Extension No." := ContractExtensionNo;  //Guardo el n£mero de la extensi¢n

                    //JAV 10/03/21: - QB 1.08.23 Guardar el contrato marco
                    //JAV 02/06/22: - QB 1.10.47 Verificar que el contrato marco sigue existiendo, se puede usar y tiene cantidad suficiente
                    IF (DataPricesVendor."QB Framework Contr. No." <> '') AND (DataPricesVendor."QB Framework Contr. Line" <> 0) THEN BEGIN
                        //Verificar la cabecera
                        IF (NOT QBFrameworkContrHeader.GET(DataPricesVendor."QB Framework Contr. No.")) THEN
                            ERROR('No existe el contrato marco %1', DataPricesVendor."QB Framework Contr. No.");
                        IF (QBFrameworkContrHeader.OLD_Status = QBFrameworkContrHeader.OLD_Status::Closed) THEN
                            ERROR('El contrato marco %1 est  cerrado', DataPricesVendor."QB Framework Contr. No.");
                        IF NOT ((QBFrameworkContrHeader."Init Date" <= PurchaseHeader."Document Date") AND (QBFrameworkContrHeader."End Date" >= PurchaseHeader."Document Date")) THEN
                            ERROR('El contrato marco %1 est  fuera de fechas', DataPricesVendor."QB Framework Contr. No.");

                        //Verificar la l¡nea
                        IF (NOT QBFrameworkContrLine.GET(DataPricesVendor."QB Framework Contr. No.", DataPricesVendor."QB Framework Contr. Line")) THEN
                            ERROR('No existe la l¡nea %1 en el contrato marco %2', DataPricesVendor."QB Framework Contr. Line", DataPricesVendor."QB Framework Contr. No.");
                        IF (QBFrameworkContrLine."Quantity Max" <> 0) THEN BEGIN
                            QBFrameworkContrLine.CALCFIELDS("Quantity in Orders");
                            IF (QBFrameworkContrLine."Quantity Max" - QBFrameworkContrLine."Quantity in Orders" < PurchaseLine.Quantity) THEN
                                ERROR('El disponible en el contrato marco %1 es %2, no hay suficiente para la cantidad de %3',
                                      DataPricesVendor."QB Framework Contr. No.", QBFrameworkContrLine."Quantity Max" - QBFrameworkContrLine."Quantity in Orders", PurchaseLine.Quantity);
                        END;

                        //Se puede asociar, lo guardo en la l¡nea
                        PurchaseLine."QB Framework Contr. No." := DataPricesVendor."QB Framework Contr. No.";
                        PurchaseLine."QB Framework Contr. Line" := DataPricesVendor."QB Framework Contr. Line";
                    END;

                    //Ya hemos creado, quito la marca temporal
                    PurchaseLine."QB tmp From Comparative" := FALSE;

                    PurchaseLine.VALIDATE("Shortcut Dimension 1 Code", "Comparative Quote Lines"."Shortcut Dimension 1 Code");
                    //-Q19864
                    //PurchaseLine.VALIDATE("Shortcut Dimension 2 Code","Comparative Quote Lines"."Shortcut Dimension 2 Code");
                    IF "Comparative Quote Lines".Type = "Comparative Quote Lines".Type::Item THEN BEGIN
                        Item.GET("Comparative Quote Lines"."No.");
                        Job.GET("Comparative Quote Lines"."Job No.");
                        IF Job."Job Location" <> '' THEN Locat := Job."Job Location" ELSE Locat := Job."No.";
                        InventoryPostingSetup.GET(Locat, Item."Inventory Posting Group");
                        PurchaseLine.VALIDATE("Shortcut Dimension 2 Code", InventoryPostingSetup."Analytic Concept");

                    END
                    ELSE BEGIN
                        PurchaseLine.VALIDATE("Shortcut Dimension 2 Code", "Comparative Quote Lines"."Shortcut Dimension 2 Code");
                    END;
                    //+Q19864
                    //JAV 15/12/21: - QB 1.10.08 Se pasa a la l¡nea del pedido la fecha de recepci¢n esperada
                    IF (PurchaseLine."Expected Receipt Date" <> 0D) THEN
                        PurchaseLine.VALIDATE("Expected Receipt Date", "Comparative Quote Lines"."Requirements date");


                    //JAV 30/05/22: - QB 1.10.45 Pasar los valores correctos de proyecto, CA, UO/PP y dimensi¢n a la l¡nea
                    PurchaseLine."Job No." := "Comparative Quote Lines"."Job No.";             //JAV 21/06/22: - QB 1.10.52 No se valida pra evitar cambios que se pueden producir autom ticamente

                    //-Q20082
                    PurchaseLine."Piecework No." := "Comparative Quote Lines"."Piecework No.";  //JAV 21/06/22: - QB 1.10.52 No se valida pra evitar cambios que se pueden producir autom ticamente
                    IF ("Comparative Quote Lines"."Piecework No." = '') THEN BEGIN
                        IF (Job2.GET(PurchaseLine."Job No.")) THEN
                            IF (Job2."Warehouse Cost Unit" <> '') THEN
                                PurchaseLine."Piecework No." := Job2."Warehouse Cost Unit";
                    END;
                    //+Q20082

                    PurchaseLine.VALIDATE("QB CA Code");
                    PurchaseLine.VALIDATE("QB CA Value", "Comparative Quote Lines"."QB CA Value");
                    PurchaseLine."Shortcut Dimension 1 Code" := "Comparative Quote Lines"."Shortcut Dimension 1 Code";
                    //-Q19864
                    //PurchaseLine."Shortcut Dimension 2 Code" := "Comparative Quote Lines"."Shortcut Dimension 2 Code";
                    //+Q19864
                    PurchaseLine."Dimension Set ID" := "Comparative Quote Lines"."Dimension Set ID";
                    //18294 CSM 10/02/23 Í Incorporar en est ndar QB. -
                    //PurchaseLine."Comparative Quote No." := "Comparative Quote Lines"."Quote No.";
                    //PurchaseLine."Comparative Line No." := "Comparative Quote Lines"."Line No.";
                    //18294 CSM 10/02/23 Í Incorporar en est ndar QB. +

                    PurchaseLine.MODIFY;

                    //JAV 15/12/21: - QB 1.10.08 Si se va a generar por meses, hay que crear ahora las l¡neas
                    IF ("Comparative Quote Header"."Generate for months" <> 0) THEN BEGIN
                        FOR i := 2 TO "Comparative Quote Header"."Generate for months" DO BEGIN //La primera l¡nea ya est  generada
                            LastNumberLine += 10000;
                            PurchaseLine."Line No." := LastNumberLine;
                            PurchaseLine.VALIDATE("Expected Receipt Date", CALCDATE('+1m', PurchaseLine."Expected Receipt Date"));
                            PurchaseLine.INSERT;
                        END;
                    END;

                    //QMD 18/09/19: - VSTS-7528 GAP018 para KALAM. Pasar valores de campos al descompuesto
                    TransferVendorData;

                    //JAV 04/05/20: - QB 1.02 Textos extendidos
                    OptionTointeger := PurchaseLine."Document Type";
                    QBText.CopyTo(QBText.Table::Comparativo, "Comparative Quote Lines"."Quote No.", FORMAT("Comparative Quote Lines"."Line No."), '',
                                  QBText.Table::Contrato, FORMAT(OptionTointeger), PurchaseLine."Document No.", FORMAT(PurchaseLine."Line No."));
                END;


            }
            DataItem("Other Vendor Conditions"; "Other Vendor Conditions")
            {

                DataItemTableView = SORTING("Quote Code", "Vendor No.", "Contact No.", "Code");
                DataItemLink = "Quote Code" = FIELD("No.");
                trigger OnPreDataItem();
                BEGIN
                    PurchasesPayablesSetup.GET();
                    IF (PurchasesPayablesSetup."Vendor Conditions Type" = PurchasesPayablesSetup."Vendor Conditions Type"::" ") THEN
                        CurrReport.BREAK;
                END;

                trigger OnAfterGetRecord();
                BEGIN
                    Window.UPDATE(2, "Other Vendor Conditions".Code);

                    // {------------------------------- DE MOMENTO ESTO NO LO PUEDO ACTIVAR, esto a¤ade otras condiciones del proveedor al pedido

                    // IF (PurchasesPayablesSetup."Vendor Conditions Piecework" <> '') THEN BEGIN 
                    //   IF (NOT DataPieceworkForProduction.GET("Comparative Quote Header"."Job No.", PurchasesPayablesSetup."Vendor Conditions Piecework")) THEN BEGIN 
                    //     DataPieceworkForProduction.INIT;
                    //     DataPieceworkForProduction."Job No." := "Comparative Quote Header"."Job No.";
                    //     DataPieceworkForProduction."Piecework Code" := PurchasesPayablesSetup."Vendor Conditions Piecework";
                    //     DataPieceworkForProduction.Description := 'Otras condiciones del proveedor';
                    //     DataPieceworkForProduction.Type := DataPieceworkForProduction.Type::Piecework;
                    //     //DataPieceworkForProduction.Type := DataPieceworkForProduction.Type::"Cost Unit";
                    //     //DataPieceworkForProduction."Type Unit Cost" := DataPieceworkForProduction."Type Unit Cost"::Internal;
                    //     //DataPieceworkForProduction."Subtype Cost" := DataPieceworkForProduction."Subtype Cost"::Others;
                    //     DataPieceworkForProduction."Global Dimension 2 Code" := PurchasesPayablesSetup."Vendor Conditions CA";
                    //     DataPieceworkForProduction.INSERT;
                    //   END;
                    // END;

                    // LastNumberLine := LastNumberLine + 10000;

                    // PurchaseLine.INIT;
                    // CASE OrderOptions OF
                    //   OrderOptions::"Blanket Order" : PurchaseLine."Document Type" := PurchaseLine."Document Type"::"Blanket Order";
                    //   OrderOptions::Order           : PurchaseLine."Document Type" := PurchaseLine."Document Type"::Order;
                    // END;
                    // PurchaseLine.VALIDATE("Document No.",PurchaseHeader."No.");
                    // PurchaseLine.VALIDATE("Line No.",LastNumberLine);
                    // PurchaseLine.INSERT(TRUE);

                    // PurchaseLine.VALIDATE("Buy-from Vendor No.","Comparative Quote Header"."Selected Vendor");
                    // CASE PurchasesPayablesSetup."Vendor Conditions Type" OF
                    //   PurchasesPayablesSetup."Vendor Conditions Type"::"G/L Account" : PurchaseLine.Type := PurchaseLine.Type::"G/L Account";
                    //   PurchasesPayablesSetup."Vendor Conditions Type"::Item          : PurchaseLine.Type := PurchaseLine.Type::Item;
                    //   PurchasesPayablesSetup."Vendor Conditions Type"::Resource      : PurchaseLine.Type := PurchaseLine.Type::Resource;
                    // END;
                    // PurchaseLine.VALIDATE("No.",PurchasesPayablesSetup."Vendor Conditions No.");
                    // PurchaseLine.Description := "Other Vendor Conditions".Description;

                    // PurchaseLine.VALIDATE(Quantity,1);
                    // PurchaseLine.VALIDATE("Direct Unit Cost","Other Vendor Conditions".Amount);

                    // PurchaseLine.VALIDATE("Dimension Set ID", "Comparative Quote Header"."Dimension Set ID");

                    // PurchaseLine.VALIDATE("Job No.", "Comparative Quote Header"."Job No.");
                    // PurchaseLine."Piecework No." := PurchasesPayablesSetup."Vendor Conditions Piecework";

                    // PurchaseLine.VALIDATE("Shortcut Dimension 1 Code", "Comparative Quote Header"."Shortcut Dimension 1 Code");
                    // PurchaseLine.VALIDATE("Shortcut Dimension 2 Code", PurchasesPayablesSetup."Vendor Conditions CA");

                    // PurchaseLine.MODIFY(TRUE);
                    // ----------------------------------------------------------------------}
                END;


            }
            trigger OnPreDataItem();
            BEGIN
                "Comparative Quote Header".SETRANGE("No.", QuoteCode);

                Window.OPEN(Text000 +
                            Text001 +
                            Text002);

                HeaderLinesNo := 0;
                LineLinesNo := 0;
            END;

            trigger OnAfterGetRecord();
            BEGIN
                HeaderLinesNo := HeaderLinesNo + 1;
                Window.UPDATE(1, HeaderLinesNo);
                IF "Comparative Quote Header"."Job No." <> '' THEN BEGIN
                    Job.GET("Comparative Quote Header"."Job No.");
                    //JAV 04/12/19: - Se cambia el uso de Status por el de Cardtype para QB
                    //IF Job.Status=Job.Status::Planning THEN
                    //CPA 25/11/2021: Se inclye el tipo Presupuesto en la comprobaci¢n.
                    //JAV 27/02/22: - QB 1.10.11 Se cambia a los tipos no permitidos directamente que hay menos
                    IF (Job."Card Type" IN [Job."Card Type"::" ", Job."Card Type"::Estudio]) THEN
                        ERROR(Text007);
                END;

                IF ("Comparative Quote Header"."Generate Type" = "Comparative Quote Header"."Generate Type"::Contract) THEN BEGIN
                    //Vamos a generar un nuevo documento
                    //JAV 04/12/19: - Se unifica que sea pedido o pedido abierto en una sola funci¢n
                    PurchaseHeader.INIT;
                    IF OrderOptions = OrderOptions::"Blanket Order" THEN
                        PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::"Blanket Order"
                    ELSE
                        PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Order;
                    PurchaseHeader."No." := '';
                    PurchaseHeader."QB Contract" := TRUE;
                    PurchaseHeader.VALIDATE(PurchaseHeader."Buy-from Vendor No.", "Comparative Quote Header"."Selected Vendor");  //QB_2148
                    PurchaseHeader.INSERT(TRUE);

                    PurchaseHeader.VALIDATE(PurchaseHeader."Pay-to Vendor No.", "Comparative Quote Header"."Selected Vendor");
                    PurchaseHeader.VALIDATE(PurchaseHeader."Order Date", WORKDATE);
                    //PurchaseHeader.VALIDATE(PurchaseHeader."_QB Type of Order","Comparative Quote Header"."Comparative Type");  //JAV 21/01/22: - QB 1.10.12 Este campo ya no se utiliza
                    //JMMA DIV
                    PurchaseHeader.VALIDATE("Currency Code", "Comparative Quote Header"."Currency Code");

                    //JAV 04/12/19: - Poner todas las dimensiones de la cabecera correctamente
                    PurchaseHeader.VALIDATE("Dimension Set ID", "Comparative Quote Header"."Dimension Set ID");
                    PurchaseHeader.VALIDATE("Shortcut Dimension 1 Code", "Comparative Quote Header"."Shortcut Dimension 1 Code");
                    PurchaseHeader.VALIDATE("Shortcut Dimension 2 Code", "Comparative Quote Header"."Shortcut Dimension 2 Code");

                    //Luego montamos el proyecto para coger bien sus dimensiones
                    IF "Comparative Quote Header"."Comparative To" = "Comparative Quote Header"."Comparative To"::Job THEN BEGIN
                        PurchaseHeader."QB Order To" := PurchaseHeader."QB Order To"::Job;
                        PurchaseHeader.VALIDATE("QB Job No.", "Comparative Quote Header"."Job No.");
                        PurchaseHeader."Location Code" := '';
                    END ELSE BEGIN
                        PurchaseHeader."QB Order To" := PurchaseHeader."QB Order To"::Location;
                        PurchaseHeader."QB Job No." := '';
                        PurchaseHeader.VALIDATE("Location Code", "Comparative Quote Header"."Location Code");
                    END;

                    //JAV 04/12/19: Siempre debe usar las condiciones definidas en el comparativo
                    VendorConditionsData.SETRANGE("Quote Code", "Comparative Quote Header"."No.");
                    VendorConditionsData.SETRANGE("Vendor No.", "Comparative Quote Header"."Selected Vendor");

                    //Q13150 -
                    VendorConditionsData.SETRANGE("Contact No.", "Comparative Quote Header"."Contact Selectd No.");
                    VendorConditionsData.SETRANGE("Version No.", "Comparative Quote Header"."Selected Version No.");
                    //Q13150 +

                    VendorConditionsData.FINDFIRST;

                    IF (VendorConditionsData."Payment Phases" <> '') THEN
                        PurchaseHeader.VALIDATE("QB Payment Phases", VendorConditionsData."Payment Phases")
                    ELSE BEGIN
                        PurchaseHeader.VALIDATE("Payment Method Code", VendorConditionsData."Payment Method Code");
                        PurchaseHeader.VALIDATE("Payment Terms Code", VendorConditionsData."Payment Terms Code");
                    END;
                    PurchaseHeader.VALIDATE("QW Cod. Withholding by GE", VendorConditionsData."Withholding Code");

                    //JAV 15/12/21: - QB 1.10.08 Se pasa al pedido la menor fecha de recepci¢n esperada entre la de cabecera o de todas las l¡neas
                    auxDate := "Comparative Quote Header"."Requirements date";
                    ComparativeQuoteLines.RESET;
                    ComparativeQuoteLines.SETRANGE("Quote No.", "Comparative Quote Header"."No.");
                    ComparativeQuoteLines.SETFILTER("Requirements date", '<>%1', 0D);
                    IF (ComparativeQuoteLines.FINDSET) THEN
                        REPEAT
                            IF (auxDate = 0D) OR (auxDate > ComparativeQuoteLines."Requirements date") THEN
                                auxDate := ComparativeQuoteLines."Requirements date";
                        UNTIL ComparativeQuoteLines.NEXT = 0;
                    PurchaseHeader.VALIDATE("Expected Receipt Date", auxDate);

                    //-16468 DGG
                    PurchaseHeader."QB Budget item" := "QB Budget item";  //JAV 13/03/22 Se elimina el validate para evitar que pregunte si desea cambiarlo en todas las l¡neas
                                                                          //+16468

                    PurchaseHeader.MODIFY;

                    HeaderNo := PurchaseHeader."No.";
                    LastNumberLine := 0;
                END ELSE BEGIN
                    //Solo ampliamos uno existente, tengo que cambiar el estado a abierto para poder hacerlo
                    PurchaseHeader.GET("Comparative Quote Header"."Main Contract Doc Type", "Comparative Quote Header"."Main Contract Doc No.");
                    tmpPurchHdrStatus := PurchaseHeader.Status;
                    PurchaseHeader.Status := PurchaseHeader.Status::Open;
                    PurchaseHeader.MODIFY;

                    //Busco la £ltima l¡nea y la £ltima ampliaci¢n
                    PurchaseLine.RESET;
                    PurchaseLine.SETRANGE("Document Type", PurchaseHeader."Document Type");
                    PurchaseLine.SETRANGE("Document No.", PurchaseHeader."No.");
                    IF PurchaseLine.FINDLAST THEN
                        LastNumberLine := PurchaseLine."Line No.";

                    PurchaseLine.SETFILTER("QB Contract Extension No.", '<>0');
                    IF PurchaseLine.FINDLAST THEN
                        ContractExtensionNo := PurchaseLine."QB Contract Extension No." + 1
                    ELSE
                        ContractExtensionNo := 1;

                    //Creo las l¡neas de cabecera de la ampliaci¢n
                    LastNumberLine += 10000;
                    PurchaseLine.INIT;
                    PurchaseLine."Document Type" := PurchaseHeader."Document Type";
                    PurchaseLine."Document No." := PurchaseHeader."No.";
                    PurchaseLine."Line No." := LastNumberLine;
                    PurchaseLine.Description := '';
                    PurchaseLine."QB Contract Extension No." := ContractExtensionNo;  //Guardo el n£mero de la extensi¢n
                    PurchaseLine.INSERT;

                    LastNumberLine += 10000;
                    PurchaseLine.INIT;
                    PurchaseLine."Document Type" := PurchaseHeader."Document Type";
                    PurchaseLine."Document No." := PurchaseHeader."No.";
                    PurchaseLine."Line No." := LastNumberLine;
                    PurchaseLine.Description := STRSUBSTNO(Text008, ContractExtensionNo, "Comparative Quote Header"."No.", TODAY);
                    PurchaseLine."QB Contract Extension No." := ContractExtensionNo;  //Guardo el n£mero de la extensi¢n
                    PurchaseLine.INSERT;
                END;

                "Comparative Quote Header"."Generated Contract Doc Type" := PurchaseHeader."Document Type";
                "Comparative Quote Header"."Generated Contract Doc No." := PurchaseHeader."No.";
                "Comparative Quote Header"."Generated Contract Ext No." := ContractExtensionNo;
                "Comparative Quote Header".MODIFY;
            END;

            trigger OnPostDataItem();
            BEGIN
                //Vuelvo a poner el estado en el documento
                IF ("Comparative Quote Header"."Generate Type" = "Comparative Quote Header"."Generate Type"::Extension) THEN BEGIN
                    PurchaseHeader.Status := tmpPurchHdrStatus;
                    PurchaseHeader.MODIFY(FALSE);
                END;

                //JAV 27/02/22: - QB 1.10.22 Nos aseguramos de que calculamos el circuito de aprobaci¢n adecuado al documento recien generado
                PurchaseHeader.VALIDATE("QB Job No.");  //Con validar uno de los campos asociados es suficiente, por ejemplo Job
                PurchaseHeader.MODIFY(FALSE);

                //-16728
                IF PurchaseHeader."QW Cod. Withholding by GE" <> '' THEN BEGIN
                    WithholdingTreating.CalculateWithholding_PurchaseHeader(PurchaseHeader);
                END;
                //-16728

                //JAV 27/02/22: - QB 1.10.22 Si el comparativo est  aprobado, el pedido ya debe pasar como aprobado, lo hago ahora porque si no est  abierto no puedo insertar las l¡neas
                IF ("Comparative Quote Header"."Generate Type" = "Comparative Quote Header"."Generate Type"::Contract) THEN BEGIN
                    IF ("Comparative Quote Header"."Approval Status" = "Comparative Quote Header"."Approval Status"::Released) THEN BEGIN
                        PurchaseHeader.Status := PurchaseHeader.Status::Released;
                        PurchaseHeader.MODIFY(FALSE);
                        //JAV 04/04/22: - QB 1.10.31 Se cambia a la tabla de configuraci¢n de aprobaciones
                        IF (QBApprovalsSetup.GET) THEN
                            IF (QBApprovalsSetup."Send App. Comparative to Order") THEN
                                //-17368 26/05/22 DGG se comenta y se sustituye
                                //IF (ApprovalPurchaseOrder.IsApprovalsWorkflowEnabled(PurchaseHeader)) THEN
                                IF (ApprovalPurchaseOrder.IsApprovalsWorkflowActive) THEN
                                    //-Se comenta y se sustituye
                                    //QBApprovalManagement.CopyApprovalChain("Comparative Quote Header".RECORDID, PurchaseHeader.RECORDID, ApprovalEntry."QB Document Type"::Comparative);
                                    QBApprovalManagement.CopyApprovalChain("Comparative Quote Header".RECORDID, PurchaseHeader.RECORDID, ApprovalEntry."QB Document Type"::Purchase, PurchaseHeader."No.");
                        //+DGG
                    END;
                END;
            END;


        }
    }
    requestpage
    {

        layout
        {
            area(content)
            {
                group("group569")
                {

                    CaptionML = ENU = 'Options', ESP = 'Opciones';
                    field("OrderOptions"; "OrderOptions")
                    {

                        //OptionCaptionML = ENU = 'Generate Order,Generate Blanket Order', ESP = 'Generar Pedido,Generar Pedido Abierto';
                    }

                }

            }
        }
    }
    labels
    {
    }

    var
        //       Text000@7001104 :
        Text000: TextConst ENU = 'Order Header     #1#########', ESP = 'Cabecera Pedido     #1#########';
        //       Text001@7001103 :
        Text001: TextConst ENU = 'Order Lines     #2#########', ESP = 'Lineas de Pedido     #2#########';
        //       Text002@1100286000 :
        Text002: TextConst ESP = 'Otras Condiciones   #3#########';
        //       Text003@7001102 :
        Text003: TextConst ENU = 'Blanket Order no. %1 of Comparative Quote %2 has been created', ESP = '"A partir del comparativo de oferta %4\se ha %1 el %2 n§ %3 "';
        //       Job@7001111 :
        Job: Record 167;
        //       PurchaseHeader@7001112 :
        PurchaseHeader: Record 38;
        //       PurchaseLine@7001114 :
        PurchaseLine: Record 39;
        //       VendorConditionsData@7001115 :
        VendorConditionsData: Record 7207414;
        //       DataPricesVendor@7001116 :
        DataPricesVendor: Record 7207415;
        //       Item@7001117 :
        Item: Record 27;
        //       Resource@7001118 :
        Resource: Record 156;
        //       ComparativeQuoteHeader@1100286011 :
        ComparativeQuoteHeader: Record 7207412;
        //       ComparativeQuoteLines@1100286010 :
        ComparativeQuoteLines: Record 7207413;
        //       PurchasesPayablesSetup@1100286002 :
        PurchasesPayablesSetup: Record 312;
        //       DataPieceworkForProduction@1100286001 :
        DataPieceworkForProduction: Record 7207386;
        //       QBText@1100286003 :
        QBText: Record 7206918;
        //       ApprovalEntry@1100286016 :
        ApprovalEntry: Record 454;
        //       QBApprovalsSetup@1100286018 :
        QBApprovalsSetup: Record 7206994;
        //       QBApprovalManagement@1100286015 :
        QBApprovalManagement: Codeunit 7207354;
        //       ApprovalPurchaseOrder@1100286017 :
        ApprovalPurchaseOrder: Codeunit 7206912;
        //       QuoteCode@7001113 :
        QuoteCode: Code[20];
        //       HeaderNo@7001106 :
        HeaderNo: Code[20];
        //       HeaderLinesNo@7001109 :
        HeaderLinesNo: Integer;
        //       LineLinesNo@7001108 :
        LineLinesNo: Integer;
        //       LastNumberLine@7001105 :
        LastNumberLine: Integer;
        //       OrderOptions@7001107 :
        OrderOptions: Option "Order","Blanket Order";
        //       Window@7001110 :
        Window: Dialog;
        //       tmpPurchHdrStatus@1100286004 :
        tmpPurchHdrStatus: Option;
        //       ContractExtensionNo@1100286005 :
        ContractExtensionNo: Integer;
        //       Text004@1100286007 :
        Text004: TextConst ESP = 'creado';
        //       Text005@1100286008 :
        Text005: TextConst ESP = 'ampliado';
        //       Text007@1100286009 :
        Text007: TextConst ENU = 'Can not generate Job Contracts on Quote', ESP = 'No se pueden generar contratos para Estudios o proyectos est ndar';
        //       Text008@1100286006 :
        Text008: TextConst ESP = 'AMPLIACIàN %1 COMP. N§ %2 DEL %3';
        //       auxDate@1100286012 :
        auxDate: Date;
        //       auxQty@1100286013 :
        auxQty: Decimal;
        //       i@1100286014 :
        i: Integer;
        //       WithholdingTreating@1100286028 :
        WithholdingTreating: Codeunit 7207306;
        //       QBFrameworkContrLine@1100286019 :
        QBFrameworkContrLine: Record 7206938;
        //       QBFrameworkContrHeader@1100286020 :
        QBFrameworkContrHeader: Record 7206937;
        //       InventoryPostingSetup@1100286021 :
        InventoryPostingSetup: Record 5813;
        //       QuantityToPurchLine@1100286022 :
        QuantityToPurchLine: Decimal;
        //       PreviousAmount@1100286023 :
        PreviousAmount: Decimal;



    trigger OnPostReport();
    begin
        //JAV 05/06/22: - QB 1.10.47 Se elimina el mensaje final, se har  en el proceso que lo lanza
        // CASE "Comparative Quote Header"."Generate Type" OF
        //  "Comparative Quote Header"."Generate Type"::Contract:
        //    MESSAGE(Text003,Text004,FORMAT(PurchaseHeader."Document Type"),PurchaseHeader."No.","Comparative Quote Header"."No.");
        //  "Comparative Quote Header"."Generate Type"::Extension:
        //    MESSAGE(Text003,Text005,FORMAT(PurchaseHeader."Document Type"),PurchaseHeader."No.","Comparative Quote Header"."No.");
        // end;
    end;



    // procedure SetComparativeHeader (QuoteCodePar@1000000000 :
    procedure SetComparativeHeader(QuoteCodePar: Code[20])
    begin
        QuoteCode := QuoteCodePar;
    end;

    LOCAL procedure TransferVendorData()
    var
        //       DataCostByPiecework@1100286000 :
        DataCostByPiecework: Record 7207387;
    begin
        //JAV  18/12/19: - Se simplifica esta parte
        //{---------------------------------------------
        //      //+GAP018
        //
        //      DataCostByPiecework.SETRANGE(DataCostByPiecework."Job No.",Job."No.");
        //      DataCostByPiecework.SETRANGE(DataCostByPiecework."Piecework Code","Comparative Quote Lines"."Piecework No.");
        //      DataCostByPiecework.SETRANGE(DataCostByPiecework."Cod. Budget",Job."Current Piecework Budget");
        //
        //      DataCostByPiecework.SETRANGE(DataCostByPiecework."No.","Comparative Quote Lines"."No.");
        //      ComparativeQuoteHeader.GET("Comparative Quote Lines"."Quote No.");
        //      RecLocOferta.GET(ComparativeQuoteHeader."Job No.");
        //      if (RecLocOferta.Status=RecLocOferta.Status::Open) and
        //          (not "Comparative Quote Lines".Manual)  then
        //           CurrReport.SKIP;
        //      "Comparative Quote Lines".CALCFIELDS("Lowest Price","Vendor Amount","Selected Vendor");
        //      if DataCostByPiecework.FINDFIRST then begin
        //        DataCostByPiecework.VALIDATE(Vendor, "Comparative Quote Lines"."Selected Vendor");
        //        DataCostByPiecework.VALIDATE(DataCostByPiecework."In Quote Price","Comparative Quote Lines"."Vendor Amount");
        //        DataCostByPiecework.MODIFY(TRUE);
        //      end;
        //      //-GAP018
        //      ------------------------------------}

        //QMD 18/09/19: - VSTS-7528 GAP018 para KALAM. Pasar valores de campos al descompuesto
        Job.GET("Comparative Quote Lines"."Job No.");
        CASE "Comparative Quote Lines".Type OF
            "Comparative Quote Lines".Type::Item:
                DataCostByPiecework."Cost Type" := DataCostByPiecework."Cost Type"::Item;
            "Comparative Quote Lines".Type::Resource:
                DataCostByPiecework."Cost Type" := DataCostByPiecework."Cost Type"::Resource;
        end;
        //-Q18285,Q18970 Quitaremos el GET
        //if DataCostByPiecework.GET("Comparative Quote Lines"."Job No.", "Comparative Quote Lines"."Piecework No.", Job."Current Piecework Budget",
        //                           DataCostByPiecework."Cost Type", "Comparative Quote Lines"."No.") then begin
        //"Job No.","Piecework Code","Cod. Budget","Cost Type","No.","Order No."
        DataCostByPiecework.SETRANGE("Job No.", "Comparative Quote Lines"."Job No.");
        DataCostByPiecework.SETRANGE("Piecework Code", "Comparative Quote Lines"."Piecework No.");
        DataCostByPiecework.SETRANGE("Cod. Budget", Job."Current Piecework Budget");
        DataCostByPiecework.SETRANGE("Cost Type", DataCostByPiecework."Cost Type");
        DataCostByPiecework.SETRANGE("No.", "Comparative Quote Lines"."No.");
        if DataCostByPiecework.FINDSET then begin
            DataCostByPiecework.VALIDATE("In Quote", TRUE);
            DataCostByPiecework.VALIDATE("In Quote Price", DataPricesVendor."Vendor Price");
            DataCostByPiecework.VALIDATE(Vendor, "Comparative Quote Header"."Selected Vendor");
            DataCostByPiecework.MODIFY(TRUE);
        end;
        //-GAP018
        //-Q18285,Q18970 Quitaremos el GET
    end;

    /*begin
    //{
//      PEL 30/05/18: - QB_2148 Validar proveedor antes de insertar
//      PGM 23/01/19: - Q5232 Informar en el pedido de compra generado las condiciones y los terminos de pagos de la tabla de condiciones del proveedor.
//      QMD 18/09/19: - VSTS-7528 GAP018 para KALAM. Coeficiente de paso - Pasar valores de campos
//      JAV 26/11/19: - Se incluyen las otras condiciones del proveedor en el pedido
//      JAV 04/12/19: - Se cambia el uso de Status por el de Cardtype para QB
//                    - Se unifica crear pedido o pedido abierto, solo cambiaba una l¡nea.
//                    - Se usan siempre las condiciones que se han indicado en el comparativo, no las del proveedor o las generales
//      JDC 05/04/21: - Q13150 Modified function "Comparative Quote Header - OnAfterGetRecord", "Comparative Quote Lines - OnAfterGetRecord"
//      CPA 25/11/21: Se inclye el tipo Presupuesto en la comprobaci¢n.
//      JAV 21/01/22: - QB 1.10.11 Se eliminan campos relacionados con el contrato que no son utilizados en el programa para nada
//      JAV 27/02/22: - QB 1.10.22 Se incluyen mejoras para aprobaciones y se pasa la cadena de aprobaci¢n al pedido generado
//      DGG 02/03/22: - Q16468 Modificacion para que incluya la partida presupuestaria en la cabecera del pedido
//      DGG 07/03/22: - Q16539 Modificacion para que tenga en cuenta la opcion el tipo de valor a llevar al campo cantidad.
//      DGG 12/04/22: - Q16728 Correccion para que actualice correctamente los importes de retenciones.
//      DGG 26/05/22: - QB 1.10.45 Q17368 Correcci¢n para que traspase correctamente los movimientos de aprobacion desde el comparativo al documento de destino.
//      JAV 30/05/22: - QB 1.10.45 Pasar los valores correctos de proyecto, CA, UO/PP y dimensi¢n a la l¡nea
//      JAV 02/06/22: - QB 1.10.47 Verificar que el contrato marco sigue existiendo, se puede usar y tiene cantidad suficiente
//      JAV 21/06/22: - QB 1.10.52 No se valida para evitar cambios que se pueden producir autom ticamente en el proyecto y la unidad de obra
//      JAV 08/07/22: - QB 1.11.00 Se cambia el orden de los campos para que no produzca desbordamiento si el importe es muy grande al calcular cantidad*precio
//      JAV 13/01/22: - QB 1.11.00 Si pongo en la l¡nea la unidad de almac‚n, debo poner el CA asociado al almac‚n en el comparativo para que lo pase bien
//      18294 CSM 10/02/23 Í Incorporar en est ndar QB.
//      Q19330 PSM 19/04/23 - Modificaci¢n para generar pedido por importe
//      Q18285,Q18970 - AML 02/06/23 Modificaciones porque hemos permitido que se dupliquen Descompuestos si vienen de un BC3.
//      Q19864 AML 19/07/23 Correccion problemas con el CA.
//      Q20082 AML 05/10/23 Modificacion para acopio.
//    }
    end.
  */

}



