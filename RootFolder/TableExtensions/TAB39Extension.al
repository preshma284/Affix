tableextension 50116 "MyExtension50116" extends "Purchase Line"
{


    CaptionML = ENU = 'Purchase Line', ESP = 'L�n. compra';
    LookupPageID = "Purchase Lines";
    DrillDownPageID = "Purchase Lines";

    fields
    {
        field(50000; "Prod. Measure Header No."; Code[20])
        {
            DataClassification = CustomerContent;
            CaptionML = ENU = 'Prob. Measure Header No.', ESP = 'N� Cab. Relaci�n Valorada';
            Description = 'BS18286';


        }
        field(50001; "Prod. Measure Line No."; Integer)
        {
            DataClassification = CustomerContent;
            CaptionML = ENU = 'Prod. Measure Line No.', ESP = 'N� l�nea Relaci�n Valorada';
            Description = 'BS18286';


        }
        field(50002; "From Measure"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Viene de la medici�n';
            Description = 'BS18286';


        }
        field(50003; "Measure Source"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Origin Measure', ESP = 'Medici�n origen';
            DecimalPlaces = 2 : 4;
            Description = 'BS18286';

            trigger OnValidate();
            VAR
                //                                                                 RelCertificationProduct@1100286004 :
                RelCertificationProduct: Record 7207397;
                //                                                                 ProcessOk@1100286000 :
                ProcessOk: Boolean;
                //                                                                 txtAux@1100286001 :
                txtAux: Text;
                //                                                                 incCost@1100286002 :
                incCost: Decimal;
                //                                                                 incSale@1100286003 :
                incSale: Decimal;
                //                                                                 recJob@1100286005 :
                recJob: Record 167;
            begin
                //{
                //                                                                //BS::18286 CSM 30/01/23 - Fri y proforma por l�neas de medici�n. -
                //                                                                recJob.GET("Job No.");
                //                                                                //GetPiecework;
                //
                //                                                                //Miro si debo aumentar coste o venta
                //                                                                incCost := "Measure Source" - DataPieceworkForProduction."Budget Measure";
                //                                                                IF (incCost < 0) THEN
                //                                                                  incCost := 0;
                //
                //                                                                incSale := 0;
                //                                                                IF (recJob."Sales Medition Type" = recJob."Sales Medition Type"::open) THEN BEGIN 
                //                                                                  incSale := "Measure Source" - DataPieceworkForProduction."Sale Quantity (base)";
                //                                                                  IF (incSale <> 0) AND (recJob."Separation Job Unit/Cert. Unit") THEN BEGIN 
                //                                                                    RelCertificationProduct.RESET;
                //                                                                    RelCertificationProduct.SETRANGE("Job No.", recJob."No.");
                //                                                                    RelCertificationProduct.SETRANGE("Production Unit Code", "Piecework No.");
                //                                                                    IF (NOT RelCertificationProduct.ISEMPTY) THEN
                //                                                                      incSale := -incSale;
                //                                                                  END;
                //                                                                  IF (incSale < 0) THEN
                //                                                                    incSale := 0;
                //                                                                END;
                //
                //                                                                //Si hay que incrementar coste o venta
                //                                                                IF (incCost <>0) OR (incSale<>0) THEN BEGIN 
                //                                                                  //Pedir confirmaci�n si no es autom�tica
                //                                                                  IF (bIncrementAuto) THEN
                //                                                                    bIncrementAuto := FALSE
                //                                                                  ELSE BEGIN 
                //                                                                    CASE recJob."Sales Medition Type" OF
                //                                                                      recJob."Sales Medition Type"::closed :
                //                                                                        txtAux := STRSUBSTNO(Text003a, incCost);          //Medici�n cerrada, solo aumentaremos coste
                //                                                                      recJob."Sales Medition Type"::open   :
                //                                                                        IF (incSale >= 0) THEN
                //                                                                          txtAux := STRSUBSTNO(Text003b, incCost, incSale)       //Medici�n abierta, aumentamos coste y venta autom�ticamente
                //                                                                        ELSE
                //                                                                          ERROR(STRSUBSTNO(Text003c, incCost, ABS(incSale)));  //Medici�n abierta, aumentamos coste autom�ticamente, pero venta manual
                //                                                                    END;
                //                                                                    IF NOT CONFIRM(txtAux, FALSE) THEN
                //                                                                      ERROR('');
                //                                                                  END;
                //
                //                                                                  //Incremento los datos
                //                                                                  IncreaseCostSale("Job No.","Piecework No.", "Measure Source", (incCost>0), (incSale>0), FALSE);
                //
                //                                                                  //Leo otra vez los datos recalculados
                //                                                                  GetPiecework;
                //                                                                  SetDataFromPiecework;
                //
                //                                                                  //Recupero la medici�n de la l�nea que he guardado
                //                                                                  "Measure Source" := oldMeasure;
                //                                                                  oldMeasure := 0;
                //                                                                END;
                //
                //                                                                CalcMeasureAmount(TRUE);
                //
                //                                                                "From Measure" := FALSE; //Si la han cambiado ya no puede estar relacionada con las mediciones detalladas
                //                                                                //BS::18286 CSM 30/01/23 - Fri y proforma por l�neas de medici�n. -
                //                                                                }
            END;


        }
        field(50004; "Cod. Contrato"; Code[20])
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Order to Cancel', ESP = 'N� contrato';
            Description = 'BS::20484';

            trigger OnLookup();
            VAR
                //                                                               ContractsControl@1100286000 :
                ContractsControl: Record 7206912;
                //                                                               ContractsControlList@1100286001 :
                ContractsControlList: Page 7206922;
            BEGIN
                //-BS::20484
                IF ("Receipt No." <> '') THEN EXIT;
                ContractsControl.SETRANGE(Proyecto, "Job No.");
                ContractsControl.SETRANGE("Tipo Movimiento", ContractsControl."Tipo Movimiento"::IniGrupo);
                ContractsControl.SETRANGE(Proveedor, "Buy-from Vendor No.");
                IF ContractsControl.FINDFIRST THEN BEGIN
                    ContractsControlList.SETTABLEVIEW(ContractsControl);
                    ContractsControlList.LOOKUPMODE(TRUE);
                    IF ACTION::LookupOK = ContractsControlList.RUNMODAL THEN BEGIN
                        ContractsControlList.GETRECORD(ContractsControl);
                        Rec."Cod. Contrato" := ContractsControl.Contrato;
                    END;
                END;
                //+BS::20484
            END;


        }
        field(50005; "Ajuste Manual Ret"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'BS::19974';


        }
        field(50006; "Activity Code"; Code[20])
        {
            TableRelation = "Activity QB";
            CaptionML = ENU = 'Activity Code', ESP = 'C�d. Actividad';
            Description = 'BS::20015';


        }
        field(7174360; "DP Apply Prorrata Type"; Option)
        {
            OptionMembers = "No","General","Especial";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Apply prorrata', ESP = 'Tipo de Prorrata Aplicable';
            OptionCaptionML = ENU = 'No,General,Special', ESP = 'No,General,Especial';

            Description = 'DP 1.00.00 PRORRATA';
            Editable = false;


        }
        field(7174361; "DP Prorrata %"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'IVA Prorrata Percentage', ESP = 'Porcentaje IVA Prorrata';
            DecimalPlaces = 0 : 0;
            MinValue = 0;
            MaxValue = 100;
            Description = 'DP 1.00.00 PRORRATA';
            Editable = false;


        }
        field(7174362; "DP VAT Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Total VAT Amount', ESP = 'Importe IVA';
            Description = 'DP 1.00.00 PRORRATA';
            Editable = false;


        }
        field(7174363; "DP Deductible VAT amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'IVA Original Base', ESP = 'IVA Deducible';
            Description = 'DP 1.00.00 JAV 21/06/22: [TT] Este campo informa del importe de IVA que es deducible de la l�nea al aplicar la regla de prorrata';
            Editable = false;


        }
        field(7174364; "DP Non Deductible VAT amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'IVA Original Percentage', ESP = 'IVA no deducible';
            Description = 'DP 1.00.00 JAV 21/06/22: [TT] Este campo informa del importe de IVA que no es deducible de la l�nea al aplicar la regla de prorrata';
            Editable = false;


        }
        field(7174365; "DP Deductible VAT Line"; Option)
        {
            OptionMembers = "NotUsed","Yes","No";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'IVA Original Percentage', ESP = 'L�nea Deducible';
            OptionCaptionML = ENU = 'Not Used,Yes,No', ESP = 'No interviene,Si,No';

            Description = 'DP 1.00.00 JAV 21/06/22: [TT] Este campo informa si la l�nea es o no deducible a efectos de la prorrata de IVA';
            Editable = false;


        }
        field(7174366; "DP Non Deductible VAT Line"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Tiene no deducible';
            Description = 'DP 1.00.04 JAV 14/07/22: [TT] Este campo indica si la l�nea tiene una parte del IVA no deducible que aumentar� el improte del gasto';


        }
        field(7174367; "DP Non Deductible VAT %"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = '% No deducible';
            MinValue = 0;
            MaxValue = 100;
            Description = 'DP 1.00.04 JAV 14/07/22: [TT] Este campo indica el % no deducible de la l�nea que aumentar� el improte del gasto';


        }
        field(7207270; "QW % Withholding by GE"; Decimal)
        {
            CaptionML = ENU = '% Withholding by G.E', ESP = '% retenci�n pago B.E.';
            Description = 'QB 1.0 - QB22111     JAV 19/09/19: - Se cambia el caption';
            Editable = false;


        }
        field(7207271; "QW Withholding Amount by GE"; Decimal)
        {
            CaptionML = ENU = 'Withholding Amount by G.E', ESP = 'Importe ret. pago B.E.';
            Description = 'QB 1.0 - QB22111     JAV 19/09/19: - Se cambia el caption';
            Editable = false;
            AutoFormatType = 1;


        }
        field(7207272; "QW % Withholding by PIT"; Decimal)
        {
            CaptionML = ENU = '% Withholding by PIT', ESP = '% retenci�n IRPF';
            Description = 'QB 1.0 - QB22111';
            Editable = false;


        }
        field(7207273; "QW Withholding Amount by PIT"; Decimal)
        {
            CaptionML = ENU = 'Withholding Amount by PIT', ESP = 'Importe retenci�n por IRPF';
            Description = 'QB 1.0 - QB22111';
            Editable = false;
            AutoFormatType = 1;


        }
        field(7207274; "Piecework No."; Text[20])
        {
            TableRelation = "Data Piecework For Production"."Piecework Code" WHERE("Job No." = FIELD("Job No."),
                                                                                                                         "Production Unit" = FILTER(true));


            CaptionML = ENU = 'Piecework No.', ESP = 'N� unidad de obra';
            Description = 'QB 1.0 - QB2514';

            trigger OnValidate();
            VAR
                //                                                                 Job@1100286000 :
                Job: Record 167;
                //                                                                 Item@1100286001 :
                Item: Record 27;
                //                                                                 txtQB000@1100286002 :
                txtQB000: TextConst ESP = 'No ha seleccionado un proyecto';
                //                                                                 txtQB001@1100286003 :
                txtQB001: TextConst ESP = 'Solo puede comprar contra almac�mn productos';
                //                                                                 txtQB002@1100286004 :
                txtQB002: TextConst ESP = 'No existe el producto';
                //                                                                 txtQB003@1100286005 :
                txtQB003: TextConst ESP = 'Solo puede comprar contra almac�n productos de tipo inventario';
                //                                                                 InventoryPostingSetup@1100286006 :
                InventoryPostingSetup: Record 5813;
                //                                                                 DataPieceworkForProduction@1100286007 :
                DataPieceworkForProduction: Record 7207386;
            BEGIN
                //JAV 29/06/22: - QB 1.10.57 No se permite cambiar algunos campos si el documento no est� abierto
                //-Q19864
                //TestStatusOpen
                IF Rec."QB Contract Qty. Original" = 0 THEN TestStatusOpen; //NO lo miramos si viene de un comparativo.
                                                                            //+Q19864

                //JAV 23/05/22: - QB 1.10.43 Solo validar si hay unidad de obra o partida presupuestaria
                IF (Rec."Piecework No." <> '') THEN BEGIN
                    IF NOT Job.GET("Job No.") THEN
                        ERROR(txtQB000);

                    //VALIDATE("Job No."); //JAV 05/03/21: - QB 1.08.21 Esto revisa las dimensiones

                    //S�lo hacer la validaci�n si est� definida la unidad de almac�n
                    IF (Job."Warehouse Cost Unit" <> '') THEN BEGIN
                        //Si es la U.O. de almac�n, verificaciones adicionales
                        IF (Rec."Piecework No." = Job."Warehouse Cost Unit") THEN BEGIN
                            IF (Rec.Type <> Rec.Type::Item) THEN
                                ERROR(txtQB001);
                            IF NOT Item.GET("No.") THEN
                                ERROR(txtQB002);
                            IF (Item.Type <> Item.Type::Inventory) THEN
                                ERROR(txtQB003);
                            //JAV 22/06/21: - QB 1.09.19 Si la UO es la de almac�n, usaremos el CA del almac�n
                            InventoryPostingSetup.GET(Job."Job Location", Item."Inventory Posting Group");

                            //JAV 23/05/22: - QB 1.10.43 Usar la nueva funci�n para el manejo de la dimensi�n
                            FunctionQB.SetDimensionIDWithGlobals(FunctionQB.ReturnDimCA, InventoryPostingSetup."Analytic Concept", Rec."Shortcut Dimension 1 Code", Rec."Shortcut Dimension 2 Code", Rec."Dimension Set ID");
                            //IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 1 THEN
                            //  VALIDATE("Shortcut Dimension 1 Code", InventoryPostingSetup."Analytic Concept")
                            //ELSE
                            //  VALIDATE("Shortcut Dimension 2 Code", InventoryPostingSetup."Analytic Concept");
                        END;
                    END;
                END;
                //AML
                IF DataPieceworkForProduction.GET("Job No.", "Piecework No.") THEN "Code Piecework PRESTO" := DataPieceworkForProduction."Code Piecework PRESTO" ELSE "Code Piecework PRESTO" := '';
                //AML
            END;


        }
        field(7207275; "QB Qty. to Receive Origin"; Decimal)
        {
            CaptionML = ENU = 'Qty. to Receive Origin', ESP = 'Cantidad a recibir a origen';
            DecimalPlaces = 0 : 5;
            Description = 'QB 1.0 - QB2517';


        }
        field(7207277; "QB Temp Type"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'QB 1.0 - Guardamos el tipo de l�nea temporalmente';


        }
        field(7207278; "Updated budget"; Boolean)
        {
            CaptionML = ENU = 'Updated budget', ESP = 'Presupuesto actualizado';
            Description = 'QB 1.0 - QB2516';


        }
        field(7207279; "Usage Document"; Code[20])
        {
            CaptionML = ENU = 'Usage Document', ESP = 'Documento Utilizaci�n';
            Description = 'QB 1.0 - QB25110';
            Editable = false;


        }
        field(7207280; "Usage Document Line"; Integer)
        {
            CaptionML = ENU = 'Usage Document Line', ESP = 'L�n. Documento Utilizaci�n';
            Description = 'QB 1.0 - QB25110';
            Editable = false;


        }
        field(7207281; "QB Proform Adjusted"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'QB 1.08.41 JAV 06/05/21 Indica si es una l�nea ajustada de facturaci�n de proforma';


        }
        field(7207282; "Code Piecework PRESTO"; Code[40])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Code Piecework PRESTO', ESP = 'C�d. U.O PRESTO';
            Description = 'QB 1.0 - QB3685';


        }
        field(7207283; "QW Not apply Withholding GE"; Boolean)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Cod. Withholding by G.E', ESP = 'No aplicar ret. B.E.';
            Description = 'QB 1.0 - JAV 11/08/19: - Si no se aplica la retenci�n por Buena Ejecuci�n a la linea';

            trigger OnValidate();
            VAR
                //                                                                 Withholdingtreating@100000000 :
                Withholdingtreating: Codeunit 7207306;
            BEGIN
                //JAV 29/06/22: - QB 1.10.57 No se permite cambiar algunos campos si el documento no est� abierto
                TestStatusOpen;

                //JAV 11/08/19: - Campo nuevo que indica si no se aplica la retenci�n de B.E.
                Withholdingtreating.CalculateWithholding_PurchaseLine(Rec, FALSE);
            END;


        }
        field(7207284; "QW Not apply Withholding PIT"; Boolean)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Cod. Withholding by PIT', ESP = 'No aplicar ret. IRPF';
            Description = 'QB 1.0 - JAV 11/08/19: - Si no se aplica la retenci�n por IRPF a la l�nea';

            trigger OnValidate();
            VAR
                //                                                                 Withholdingtreating@100000000 :
                Withholdingtreating: Codeunit 7207306;
            BEGIN
                //JAV 29/06/22: - QB 1.10.57 No se permite cambiar algunos campos si el documento no est� abierto
                TestStatusOpen;

                //JAV 11/08/19: - Campo nuevo que indica si no se aplica la retenci�n de IRPF
                Withholdingtreating.CalculateWithholding_PurchaseLine(Rec, FALSE);
            END;


        }
        field(7207285; "QW Base Withholding by GE"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = '% Withholding by G.E', ESP = 'Base ret. pago B.E.';
            Description = 'QB 1.0 - JAV 11/08/19: - Base de c�lculo de la retenci�n por B.E.                       JAV 19/09/19: - Se cambia el caption';
            Editable = false;


        }
        field(7207286; "QW Base Withholding by PIT"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = '% Withholding by PIT', ESP = 'Base ret. IRPF';
            Description = 'QB 1.0 - JAV 11/08/19: - Base de c�lculo de la retenci�n por IRPF';
            Editable = false;


        }
        field(7207287; "QW Withholding by GE Line"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Cod. Withholding by G.E', ESP = 'L�nea de retenci�n de B.E.';
            Description = 'QB 1.0 - JAV 18/08/19: - Si es la l�nea donde se calcula la retenci�n por Buena Ejecuci�n';


        }
        field(7207288; "External Worksheet Lines"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("QB External Worksheet Lines Po" WHERE("Vendor No." = FIELD("Buy-from Vendor No."),
                                                                                                             "Job No." = FIELD("Job No."),
                                                                                                             "Piecework No." = FIELD("Piecework No."),
                                                                                                             "Apply to Document No" = FILTER(''),
                                                                                                             "Quantity Pending" = FILTER(<> 0)));
            CaptionML = ENU = 'Cod. Withholding by G.E', ESP = 'L�n.Part.Ext.';
            Description = 'QB 1.6.10 - JAV 24/08/20: - Cuantas l�neas de partes de trabajadores externos pueden asociarse a esta l�nea de compra';
            Editable = false;


        }
        field(7207289; "External Worksheet Aplied"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("QB External Worksheet Lines Po" WHERE("Vendor No." = FIELD("Buy-from Vendor No."),
                                                                                                             "Job No." = FIELD("Job No."),
                                                                                                             "Piecework No." = FIELD("Piecework No."),
                                                                                                             "Apply to Document Type" = FIELD("Document Type"),
                                                                                                             "Apply to Document No" = FIELD("Document No.")));
            CaptionML = ENU = 'Cod. Withholding by G.E', ESP = 'Imp.Part.Ext.';
            Description = 'QB 1.6.10 - JAV 24/08/20: - Cuantas l�neas de partes de trabajadores externos est�n asociados asociados';
            Editable = false;


        }
        field(7207293; "QB Contract Qty. Original"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Comparative Quote Lines"."Qty. in Contract" WHERE("Quote No." = FIELD("Comparative Quote No."),
                                                                                                                          "Line No." = FIELD("Comparative Line No.")));
            CaptionML = ESP = 'Contrato. Cantidad Original';
            Description = '[QB 1.08.08 - JAV 05/02/21 Cantidad original que ha venido del contrato; BS::18294 CSM 10/02/23 - Incorporar en est�ndar QB. se cambia CalcFormula]';
            Editable = false;


        }
        field(7207296; "QB Outstanding Amount (JC)"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Job Currency Amount', ESP = 'Importe Pendiente (DC)';
            Description = 'QB 1.0 - GEN005-02 -> Es el importe pendiente de recibir en Divisa del proyecto, se usa en ta tabla Job';


        }
        field(7207297; "QB Job Curr. Exch. Rate"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Job Currency Exchange Rate', ESP = 'Tipo cambio divisa proyecto';
            Description = 'QB 1.0 - GEN005-02';


        }
        field(7207298; "QB Outstanding Amount (ACY)"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Aditional Currency Amount', ESP = 'Importe Pendiente (DR)';
            Description = 'QB 1.0 - GEN005-02 -> Es el importe pendiente de recibir en Divisa adicional, se usa en ta tabla Job';


        }
        field(7207299; "QB Aditional Curr. Exch. Rate"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Aditional Currency Exchange Rate', ESP = 'Tipo cambio divisa adicional';
            Description = 'QB 1.0 - GEN005-02';


        }
        field(7207302; "QB Contract Extension No."; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'N� Extensi�n del contrato';
            Description = 'QB 1.08.08: - JAV 09/02/21 N�mero de la extensi�n incluida en el contrato original';


        }
        field(7207303; "QB Line Proformable"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Asignable a proforma';
            Description = 'QB 1.08.41  JAV 21/04/21: - Si la l�nea es de tipo recurso de subcontrata o el producto es proformable';
            Editable = false;


        }
        field(7207304; "QB Qty. To Proform"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Qty To Proform', ESP = 'Cantidad generar proforma';
            DecimalPlaces = 0 : 5;
            Description = 'QB 1.08.41 - QDM 06/04/21: -PROFORMAS, Q13153';


        }
        field(7207305; "QB Qty. Proformed"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("QB Proform Line"."Quantity" WHERE("Order No." = FIELD("Document No."),
                                                                                                     "Order Line No." = FIELD("Line No.")));
            CaptionML = ENU = 'Proformed Qty', ESP = 'Cantidad proforma reg.';
            DecimalPlaces = 0 : 5;
            Description = 'QB 1.08.41 - QDM 06/04/21: -PROFORMAS, Q13153';
            Editable = false;


        }
        field(7207310; "Measured Last Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Ultima medici�n';
            Description = 'QB 1.0 - JAV 24/04/20: - Fecha de la �ltima medici�n, uso temporal para el c�lculo desde las Rel.Valoradas';
            Editable = false;


        }
        field(7207311; "Measured Qty."; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Medici�n a Origen';
            Description = 'QB 1.0 - JAV 24/04/20: - Cantidad en mediciones, uso temporal para el c�lculo desde las Rel.Valoradas';
            Editable = false;


        }
        field(7207312; "Measured Proposed"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Cantidad Propuesta';
            Description = 'QB 1.0 - JAV 24/04/20: - Cantidad propuesta para pedir';

            trigger OnValidate();
            BEGIN
                IF ((("Measured Proposed" < 0) XOR (Quantity < 0)) AND (Quantity <> 0) AND ("Measured Proposed" <> 0)) OR
                   (ABS("Measured Proposed") > ABS("Outstanding Quantity")) OR
                   (((Quantity < 0) XOR ("Outstanding Quantity" < 0)) AND (Quantity <> 0) AND ("Outstanding Quantity" <> 0))
                THEN
                    ERROR(Text008, "Outstanding Quantity");
            END;


        }
        field(7207313; "QB Framework Contr. No."; Code[20])
        {
            TableRelation = "QB Framework Contr. Header"."No.";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Blanket Order No.', ESP = 'N� Contrato Marco';
            Description = 'QB 1.06.20 - N� Contrato Marco';
            Editable = false;


        }
        field(7207314; "QB Framework Contr. Line"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Blanket Order No.', ESP = 'N� L�nea del Contrato Marco';
            Description = 'QB 1.08.18 - N� de l�nea del Contrato Marco';
            Editable = false;


        }
        field(7207315; "QB tmp From Comparative"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Blanket Order No.';
            Description = 'QB 1.08.23 - JAV 13/03/21: - Indica que esta l�nea se est� creando a partir del comparativo, al terminar hay que desmarcarla';
            Editable = false;


        }
        field(7207316; "QB tmp Qty to recive"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'QB 1.08.41 - JAV 07/05/21: - Guardar la cantidad a recibir para saltarse las validaciones del est�ndar';
            Editable = false;


        }
        field(7207320; "QB Prepayment Line"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Prepayment Line', ESP = 'L�nea del anticipo';
            Description = 'Q12879';


        }
        field(7207344; "QB Splitted Line Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Splitted Line', ESP = 'L�nea Dividida';
            Description = 'QB 1.12.13 JAV 04/11/22: - Indica que esta l�nea ha sido dividida en una fecha y por tanto queda bloqueada';


        }
        field(7207345; "QB Splitted Line Base"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Splitted Line', ESP = 'L�nea Dividida';
            Description = 'QB 1.12.13 JAV 04/11/22: - Indica la l�nea que se dividi� con esta';


        }
        field(7207348; "QB CA Code"; Code[20])
        {
            TableRelation = "Dimension";


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Concepto Anal�tico Dim.';
            Description = 'QB 1.10.42 JAV 21/05/22: - Campo de uso interno que Contiene el c�digo de la dimensi�n para Concepto anal�tico, se usa para filtrar el siguiente campo';

            trigger OnValidate();
            BEGIN
                "QB CA Code" := FunctionQB.ReturnDimCA;
            END;


        }
        field(7207349; "QB CA Value"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Dimension Code" = FIELD("QB CA Code"),
                                                                                               "Dimension Value Type" = CONST("Standard"));


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Concepto Anal�tico';
            Description = 'QB 1.10.42 JAV 21/05/22: - Contiene el Concepto anal�tico que se va a asociar a la l�nea. Se utiliza en lugar de la dimensi�n para independizarnos de su n�mero';

            trigger OnValidate();
            BEGIN
                //JAV 29/06/22: - QB 1.10.57 No se permite cambiar algunos campos si el documento no est� abierto
                TestStatusOpen;

                VALIDATE("QB CA Code");
                FunctionQB.SetDimensionIDWithGlobals("QB CA Code", "QB CA Value", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Dimension Set ID");
            END;


        }
        field(7207350; "QB Modification Date"; Date)
        {
            DataClassification = ToBeClassified;


        }
        field(7207351; "Comparative Quote No."; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Comparative Quote No.', ESP = 'N� comparativo';
            Description = 'BS::18294 CSM 10/02/23 - Incorporar en est�ndar QB.';


        }
        field(7207352; "Comparative Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Comparative Line No.', ESP = 'N� l�nea comparativo';
            Description = 'BS::18294 CSM 10/02/23 - Incorporar en est�ndar QB.';


        }
        field(7207360; "Qty. to Segregate"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Qty. to Segregate', ESP = 'Cantidad a segregar';
            Description = '22117';

            trigger OnValidate();
            VAR
                //                                                                 ExceededQtyErr@1100286000 :
                ExceededQtyErr: TextConst ENU = 'The %1 cannot be higher than %2 (%3).', ESP = 'La %1 no puede ser mayor que la %2 (%3).';
                //                                                                 NegativeQtyErr@1100286001 :
                NegativeQtyErr: TextConst ENU = 'No negative quantities are allowed.', ESP = 'No se permiten cantidades negativas.';
            BEGIN
                //22117 -
                CASE TRUE OF
                    "Qty. to Segregate" > "Outstanding Quantity":
                        ERROR(ExceededQtyErr, Rec.FIELDCAPTION("Qty. to Segregate"), Rec.FIELDCAPTION("Outstanding Quantity"), "Outstanding Quantity");
                    "Qty. to Segregate" < 0:
                        ERROR(NegativeQtyErr);
                END;
                //22117 +
            END;


        }
    }
    keys
    {
        // key(key1;"Document Type","Document No.","Line No.")
        //  {
        /* Clustered=true;
  */
        // }
        // key(No2;"Document No.","Line No.","Document Type")
        // {
        /* ;
  */
        // }
        // key(key3;"Document Type","Type","No.","Variant Code","Drop Shipment","Location Code","Expected Receipt Date")
        //  {
        /* SumIndexFields="Outstanding Qty. (Base)";
  */
        // }
        // key(key4;"Document Type","Blanket Order No.","Blanket Order Line No.")
        //  {
        /* ;
  */
        // }
        // key(key5;"Document Type","Type","Prod. Order No.","Prod. Order Line No.","Routing No.","Operation No.")
        //  {
        /* ;
  */
        // }
        // key(key6;"Document Type","Document No.","Location Code")
        //  {
        /* //SumIndexFields="Amount","Amount Including VAT"
                                                    MaintainSQLIndex=false;
  */
        // }
        // key(key7;"Document Type","Receipt No.","Receipt Line No.")
        //  {
        /* ;
  */
        // }
        // key(key8;"Type","No.","Variant Code","Drop Shipment","Location Code","Document Type","Expected Receipt Date")
        //  {
        /* MaintainSQLIndex=false;
  */
        // }
        // key(key9;"Document Type","Buy-from Vendor No.")
        //  {
        /* ;
  */
        // }
        // key(key10;"Document Type","Job No.","Job Task No.","Document No.")
        //  {
        /* SumIndexFields="Outstanding Amt. Ex. VAT (LCY)","A. Rcd. Not Inv. Ex. VAT (LCY)";
  */
        // }
        // key(No11;"Document Type","Document No.","Type","No.")
        // {
        /* ;
  */
        // }
        // key(No12;"Document Type","Type","No.")
        // {
        /* SumIndexFields="Outstanding Qty. (Base)";
  */
        // }
        // key(key13;"Recalculate Invoice Disc.")
        //  {
        /* ;
  */
        // }
        // key(key14;"Outstanding Quantity")
        //  {
        /* ;
  */
        // }
        // key(key15;"Location Code","Quantity Invoiced")
        //  {
        /* ;
  */
        // }
        key(Extkey16; "Document Type", "Job No.", "Order Date")
        {
            SumIndexFields = "Outstanding Amount (LCY)";
        }
        key(Extkey17; "Document Type", "Location Code", "Order Date", "Job No.")
        {
            SumIndexFields = "Outstanding Amount (LCY)";
        }
    }
    fieldgroups
    {
    }

    var
        //       Text000@1000 :
        Text000: TextConst ENU = 'You cannot rename a %1.', ESP = 'No se puede cambiar el nombre a %1.';
        //       Text001@1001 :
        Text001: TextConst ENU = 'You cannot change %1 because the order line is associated with sales order %2.', ESP = 'No se puede cambiar %1 porque la l�nea de pedido est� asociada con el pedido de venta %2.';
        //       Text002@1002 :
        Text002: TextConst ENU = 'Prices including VAT cannot be calculated when %1 is %2.', ESP = 'No se pueden calcular precios IVA incluido cuando %1 es %2.';
        //       Text003@1003 :
        Text003: TextConst ENU = 'You cannot purchase resources.', ESP = 'No se pueden comprar recursos.';
        //       Text004@1004 :
        Text004: TextConst ENU = 'must not be less than %1', ESP = 'No puede ser inferior a %1.';
        //       Text006@1005 :
        Text006: TextConst ENU = 'You cannot invoice more than %1 units.', ESP = 'No se pueden facturar m�s de %1 unidades.';
        //       Text007@1006 :
        Text007: TextConst ENU = 'You cannot invoice more than %1 base units.', ESP = 'No se pueden facturar m�s de %1 unidades base.';
        //       Text008@1007 :
        Text008: TextConst ENU = 'You cannot receive more than %1 units.', ESP = 'No se pueden recibir m�s de %1 unidades.';
        //       Text009@1008 :
        Text009: TextConst ENU = 'You cannot receive more than %1 base units.', ESP = 'No se pueden recibir m�s de %1 unidades base.';
        //       Text010@1009 :
        Text010: TextConst ENU = 'You cannot change %1 when %2 is %3.', ESP = 'No se puede cambiar %1 cuando %2 es %3.';
        //       Text011@1010 :
        Text011: TextConst ENU = ' must be 0 when %1 is %2', ESP = ' debe ser 0 cuando %1 es %2';
        //       Text012@1011 :
        Text012: TextConst ENU = 'must not be specified when %1 = %2', ESP = 'no se puede indicar cuando %1 = %2';
        //       Text016@1014 :
        Text016: TextConst ENU = '%1 is required for %2 = %3.', ESP = 'Se requiere %1 para %2 = %3.';
        //       WhseRequirementMsg@1015 :
        WhseRequirementMsg:
// "%1=Document"
TextConst ENU = '%1 is required for this line. The entered information may be disregarded by warehouse activities.', ESP = '%1 se requiere para esta l�nea. La informaci�n introducida puede ser ignorada por las actividades de almac�n.';
        //       Text018@1016 :
        Text018: TextConst ENU = '%1 %2 is earlier than the work date %3.', ESP = '%1 %2 es anterior a la fecha trabajo %3.';
        //       Text020@1018 :
        Text020: TextConst ENU = 'You cannot return more than %1 units.', ESP = 'No puede devolver m�s de %1 unidades.';
        //       Text021@1019 :
        Text021: TextConst ENU = 'You cannot return more than %1 base units.', ESP = 'No puede dev. m�s del %1 unidades base.';
        //       Text022@1020 :
        Text022: TextConst ENU = 'You cannot change %1, if item charge is already posted.', ESP = 'No puede cambiar %1, si los cargos. prod. est�n ya regis.';
        //       Text023@1072 :
        Text023: TextConst ENU = 'You cannot change the %1 when the %2 has been filled in.', ESP = 'No puede cambiar %1 despu�s de introducir datos en %2.';
        //       Text029@1077 :
        Text029: TextConst ENU = 'must be positive.', ESP = 'debe ser positivo.';
        //       Text030@1076 :
        Text030: TextConst ENU = 'must be negative.', ESP = 'debe ser negativo.';
        //       Text031@1056 :
        Text031: TextConst ENU = 'You cannot define item tracking on this line because it is linked to production order %1.', ESP = 'No puede definir seguim. prod. en esta l�n. porque est� unido a la orden de producc. %1.';
        //       Text032@1017 :
        Text032: TextConst ENU = '%1 must not be greater than the sum of %2 and %3.', ESP = '%1 no debe ser superior a la suma de %2 y %3.';
        //       Text033@1078 :
        Text033: TextConst ENU = 'Warehouse ', ESP = 'Almac�n ';
        //       Text034@1079 :
        Text034: TextConst ENU = 'Inventory ', ESP = 'Inventario ';
        //       Text035@1048 :
        Text035: TextConst ENU = '%1 units for %2 %3 have already been returned or transferred. Therefore, only %4 units can be returned.', ESP = '%1 unidades para el %2 %3 ya se han devuelto o transferido. Por lo tanto, s�lo se pueden devolver %4 unidades.';
        //       Text037@1082 :
        Text037: TextConst ENU = 'cannot be %1.', ESP = 'no puede ser %1.';
        //       Text038@1083 :
        Text038: TextConst ENU = 'cannot be less than %1.', ESP = 'no puede ser inferior a %1.';
        //       Text039@1084 :
        Text039: TextConst ENU = 'cannot be more than %1.', ESP = 'no puede ser superior a %1.';
        //       Text040@1090 :
        Text040: TextConst ENU = 'You must use form %1 to enter %2, if item tracking is used.', ESP = 'Utilice el formulario %1 para insertar %2, si se utiliza el seguimiento de productos.';
        //       ItemChargeAssignmentErr@1097 :
        ItemChargeAssignmentErr: TextConst ENU = 'You can only assign Item Charges for Line Types of Charge (Item).', ESP = 'Solo puede asignar cargos de producto a los tipos de cargo de l�nea (producto).';
        //       Text99000000@1021 :
        Text99000000: TextConst ENU = 'You cannot change %1 when the purchase order is associated to a production order.', ESP = 'No puede cambiar %1 cuando el pedido de compra est� asociado a una O.P.';
        //       PurchHeader@1022 :
        PurchHeader: Record 38;
        //       PurchLine2@1023 :
        PurchLine2: Record 39;
        //       GLAcc@1025 :
        GLAcc: Record 15;
        //       Currency@1027 :
        Currency: Record 4;
        //       CurrExchRate@1028 :
        CurrExchRate: Record 330;
        //       VATPostingSetup@1034 :
        VATPostingSetup: Record 325;
        //       GenBusPostingGrp@1039 :
        GenBusPostingGrp: Record 250;
        //       GenProdPostingGrp@1040 :
        GenProdPostingGrp: Record 251;
        //       UnitOfMeasure@1043 :
        UnitOfMeasure: Record 204;
        //       ItemCharge@1044 :
        ItemCharge: Record 5800;
        //       SKU@1046 :
        SKU: Record 5700;
        //       WorkCenter@1047 :
        WorkCenter: Record 99000754;
        //       InvtSetup@1050 :
        InvtSetup: Record 313;
        //       Location@1051 :
        Location: Record 14;
        //       GLSetup@1074 :
        GLSetup: Record 98;
        //       CalChange@1062 :
        CalChange: Record 7602;
        //       TempJobJnlLine@1071 :
        TempJobJnlLine: Record 210 TEMPORARY;
        //       PurchSetup@1095 :
        PurchSetup: Record 312;
        //       SalesTaxCalculate@1057 :
        SalesTaxCalculate: Codeunit 398;
        //       ReservEngineMgt@1058 :
        ReservEngineMgt: Codeunit 99000831;
        //       ReservePurchLine@1059 :
        ReservePurchLine: Codeunit 99000834;
        //       UOMMgt@1060 :
        UOMMgt: Codeunit 5402;
        //       AddOnIntegrMgt@1061 :
        AddOnIntegrMgt: Codeunit 5403;
        //       DimMgt@1064 :
        DimMgt: Codeunit 408;
        //       DistIntegration@1065 :
        DistIntegration: Codeunit 5702;
        //       CatalogItemMgt@1066 :
        CatalogItemMgt: Codeunit 5703;
        //       WhseValidateSourceLine@1067 :
        WhseValidateSourceLine: Codeunit 5777;
        //       LeadTimeMgt@1069 :
        LeadTimeMgt: Codeunit 5404;
        //       PurchPriceCalcMgt@1030 :
        PurchPriceCalcMgt: Codeunit 7010;
        //       CalendarMgmt@1032 :
        CalendarMgmt: Codeunit 7600;
        //       CheckDateConflict@1013 :
        CheckDateConflict: Codeunit 99000815;
        //       DeferralUtilities@1081 :
        DeferralUtilities: Codeunit 1720;
        //       PostingSetupMgt@1031 :
        PostingSetupMgt: Codeunit 48;
        //       TrackingBlocked@1070 :
        TrackingBlocked: Boolean;
        //       StatusCheckSuspended@1073 :
        StatusCheckSuspended: Boolean;
        //       GLSetupRead@1075 :
        GLSetupRead: Boolean;
        //       UnitCostCurrency@1063 :
        UnitCostCurrency: Decimal;
        //       UpdateFromVAT@1087 :
        UpdateFromVAT: Boolean;
        //       Text042@1088 :
        Text042: TextConst ENU = 'You cannot return more than the %1 units that you have received for %2 %3.', ESP = 'No puede devolver m�s de las %1 unidades recibidas para el %2 %3.';
        //       Text043@1089 :
        Text043: TextConst ENU = 'must be positive when %1 is not 0.', ESP = 'debe ser positivo cuando %1 no es 0.';
        //       Text044@1080 :
        Text044: TextConst ENU = 'You cannot change %1 because this purchase order is associated with %2 %3.', ESP = 'No se puede modificar %1 porque este pedido de compra est� asociado con %2 %3.';
        //       Text046@1091 :
        Text046:
// %1 - product name
TextConst ENU = '%3 will not update %1 when changing %2 because a prepayment invoice has been posted. Do you want to continue?', ESP = '%3 no actualizar� %1 al cambiar %2 porque se ha registrado una factura de prepago. �Desea continuar?';
        //       Text047@1092 :
        Text047: TextConst ENU = '%1 can only be set when %2 is set.', ESP = 'Solo se puede establecer %1 cuando se establece %2.';
        //       Text048@1093 :
        Text048: TextConst ENU = '%1 cannot be changed when %2 is set.', ESP = '%1 no se puede cambiar cuando se establece %2.';
        //       PrePaymentLineAmountEntered@1042 :
        PrePaymentLineAmountEntered: Boolean;
        //       Text049@1085 :
        Text049: TextConst ENU = 'You have changed one or more dimensions on the %1, which is already shipped. When you post the line with the changed dimension to General Ledger, amounts on the Inventory Interim account will be out of balance when reported per dimension.\\Do you want to keep the changed dimension?', ESP = 'Ha modificado una o varias dimensiones de %1, que ya se ha enviado. Al registrar la l�nea con la dimensi�n modificada en la contabilidad, los importes de la cuenta provisional de inventario no cuadrar�n cuando se notifiquen por dimensi�n.\\�Desea conservar la dimensi�n modificada?';
        //       Text050@1086 :
        Text050: TextConst ENU = 'Cancelled.', ESP = 'Cancelado.';
        //       Text051@1012 :
        Text051: TextConst ENU = 'must have the same sign as the receipt', ESP = 'debe tener el mismo signo que el albar�n de compra';
        //       Text052@1053 :
        Text052: TextConst ENU = 'The quantity that you are trying to invoice is greater than the quantity in receipt %1.', ESP = 'La cantidad que est� intentando facturar es mayor que la del recibo %1.';
        //       Text053@1054 :
        Text053: TextConst ENU = 'must have the same sign as the return shipment', ESP = 'debe tener el mismo signo que el env�o devoluci�n';
        //       Text054@1055 :
        Text054: TextConst ENU = 'The quantity that you are trying to invoice is greater than the quantity in return shipment %1.', ESP = 'La cantidad que est� intentando facturar es mayor que la cantidad del env�o de devoluci�n %1.';
        //       PurchSetupRead@1096 :
        PurchSetupRead: Boolean;
        //       CannotFindDescErr@1035 :
        CannotFindDescErr:
// "%1 = Type caption %2 = Description"
TextConst ENU = 'Cannot find %1 with Description %2.\\Make sure to use the correct type.', ESP = 'No se encuentra %1 con la descripci�n %2.\\Aseg�rese de usar el tipo correcto.';
        //       CommentLbl@1024 :
        CommentLbl: TextConst ENU = 'Comment', ESP = 'Comentario';
        //       LineDiscountPctErr@1036 :
        LineDiscountPctErr: TextConst ENU = 'The value in the Line Discount % field must be between 0 and 100.', ESP = 'El valor en el campo % Descuento l�nea debe ser entre 0 y 100.';
        //       PurchasingBlockedErr@1037 :
        PurchasingBlockedErr: TextConst ENU = 'You cannot purchase this item because the Purchasing Blocked check box is selected on the item card.', ESP = 'No puede comprar este producto porque la casilla Compras bloqueadas est� seleccionada en la ficha de producto.';
        //       CannotChangePrepaidServiceChargeErr@1038 :
        CannotChangePrepaidServiceChargeErr: TextConst ENU = 'You cannot change the line because it will affect service charges that are already invoiced as part of a prepayment.', ESP = 'No puede cambiar la l�nea porque afectar� a los cargos por servicios que ya se han facturado como parte de un prepago.';
        //       LineInvoiceDiscountAmountResetTok@1026 :
        LineInvoiceDiscountAmountResetTok:
// %1 - Record ID
TextConst ENU = 'The value in the Inv. Discount Amount field in %1 has been cleared.', ESP = 'Se ha borrado el valor del campo Importe dto. factura de %1.';
        //       "--------------------------------------------- QB"@1100286000 :
        "--------------------------------------------- QB": Integer;
        //       FunctionQB@1100286001 :
        FunctionQB: Codeunit 7207272;





    /*
    trigger OnInsert();    begin
                   TestStatusOpen;
                   if Quantity <> 0 then begin
                     OnBeforeVerifyReservedQty(Rec,xRec,0);
                     ReservePurchLine.VerifyQuantity(Rec,xRec);
                   end;
                   LOCKTABLE;
                   PurchHeader."No." := '';
                   if ("Deferral Code" <> '') and (GetDeferralAmount <> 0) then
                     UpdateDeferralAmounts;
                 end;


    */

    /*
    trigger OnModify();    begin
                   if ("Document Type" = "Document Type"::"Blanket Order") and
                      ((Type <> xRec.Type) or ("No." <> xRec."No."))
                   then begin
                     PurchLine2.RESET;
                     PurchLine2.SETCURRENTKEY("Document Type","Blanket Order No.","Blanket Order Line No.");
                     PurchLine2.SETRANGE("Blanket Order No.","Document No.");
                     PurchLine2.SETRANGE("Blanket Order Line No.","Line No.");
                     if PurchLine2.FINDSET then
                       repeat
                         PurchLine2.TESTFIELD(Type,Type);
                         PurchLine2.TESTFIELD("No.","No.");
                       until PurchLine2.NEXT = 0;
                   end;

                   if ((Quantity <> 0) or (xRec.Quantity <> 0)) and ItemExists(xRec."No.") then
                     ReservePurchLine.VerifyChange(Rec,xRec);
                 end;


    */

    /*
    trigger OnDelete();    var
    //                PurchCommentLine@1001 :
                   PurchCommentLine: Record 43;
    //                SalesOrderLine@1000 :
                   SalesOrderLine: Record 37;
    //                QBExternalWorksheetLinesPo@1100286000 :
                   QBExternalWorksheetLinesPo: Record 7206936;
                 begin
                   TestStatusOpen;
                   if (Quantity <> 0) and ItemExists("No.") then begin
                     ReservePurchLine.DeleteLine(Rec);
                     if "Receipt No." = '' then
                       TESTFIELD("Qty. Rcd. not Invoiced",0);
                     if "Return Shipment No." = '' then
                       TESTFIELD("Return Qty. Shipped not Invd.",0);

                     CALCFIELDS("Reserved Qty. (Base)");
                     TESTFIELD("Reserved Qty. (Base)",0);
                     WhseValidateSourceLine.PurchaseLineDelete(Rec);
                   end;

                   if ("Document Type" = "Document Type"::Order) and (Quantity <> "Quantity Invoiced") then
                     TESTFIELD("Prepmt. Amt. Inv.","Prepmt Amt Deducted");

                   if "Sales Order Line No." <> 0 then begin
                     LOCKTABLE;
                     SalesOrderLine.LOCKTABLE;
                     SalesOrderLine.GET(SalesOrderLine."Document Type"::Order,"Sales Order No.","Sales Order Line No.");
                     SalesOrderLine."Purchase Order No." := '';
                     SalesOrderLine."Purch. Order Line No." := 0;
                     SalesOrderLine.MODIFY;
                   end;

                   if ("Special Order Sales Line No." <> 0) and ("Quantity Invoiced" = 0) then begin
                     LOCKTABLE;
                     SalesOrderLine.LOCKTABLE;
                     if SalesOrderLine.GET(
                          SalesOrderLine."Document Type"::Order,"Special Order Sales No.","Special Order Sales Line No.")
                     then begin
                       SalesOrderLine."Special Order Purchase No." := '';
                       SalesOrderLine."Special Order Purch. Line No." := 0;
                       SalesOrderLine.MODIFY;
                     end;
                   end;

                   CatalogItemMgt.DelNonStockPurch(Rec);

                   if "Document Type" = "Document Type"::"Blanket Order" then begin
                     PurchLine2.RESET;
                     PurchLine2.SETCURRENTKEY("Document Type","Blanket Order No.","Blanket Order Line No.");
                     PurchLine2.SETRANGE("Blanket Order No.","Document No.");
                     PurchLine2.SETRANGE("Blanket Order Line No.","Line No.");
                     if PurchLine2.FINDFIRST then
                       PurchLine2.TESTFIELD("Blanket Order Line No.",0);
                   end;

                   if Type = Type::Item then
                     DeleteItemChargeAssgnt("Document Type","Document No.","Line No.");

                   if Type = Type::"Charge (Item)" then
                     DeleteChargeChargeAssgnt("Document Type","Document No.","Line No.");

                   if "Line No." <> 0 then begin
                     PurchLine2.RESET;
                     PurchLine2.SETRANGE("Document Type","Document Type");
                     PurchLine2.SETRANGE("Document No.","Document No.");
                     PurchLine2.SETRANGE("Attached to Line No.","Line No.");
                     PurchLine2.SETFILTER("Line No.",'<>%1',"Line No.");
                     PurchLine2.DELETEALL(TRUE);
                   end;

                   PurchCommentLine.SETRANGE("Document Type","Document Type");
                   PurchCommentLine.SETRANGE("No.","Document No.");
                   PurchCommentLine.SETRANGE("Document Line No.","Line No.");
                   if not PurchCommentLine.ISEMPTY then
                     PurchCommentLine.DELETEALL;

                   // In case we have roundings on VAT or Sales Tax, we should update some other line
                   if (Type <> Type::" ") and ("Line No." <> 0) and ("Attached to Line No." = 0) and
                      (Quantity <> 0) and (Amount <> 0) and (Amount <> "Amount Including VAT") and not StatusCheckSuspended
                   then begin
                     Quantity := 0;
                     "Quantity (Base)" := 0;
                     "Line Discount Amount" := 0;
                     "Inv. Discount Amount" := 0;
                     "Inv. Disc. Amount to Invoice" := 0;
                     UpdateAmounts;
                   end;

                   if "Deferral Code" <> '' then
                     DeferralUtilities.DeferralCodeOnDelete(
                       DeferralUtilities.GetPurchDeferralDocType,'','',
                       "Document Type","Document No.","Line No.");


                   //Eliminar las marcas de los partes de trabajadroes externos
                   QBExternalWorksheetLinesPo.RESET;
                   QBExternalWorksheetLinesPo.SETRANGE("Vendor No.", Rec."Buy-from Vendor No.");
                   QBExternalWorksheetLinesPo.SETRANGE("Job No.", Rec."Job No.");
                   QBExternalWorksheetLinesPo.SETRANGE("Piecework No.", Rec."Piecework No.");
                   QBExternalWorksheetLinesPo.SETRANGE("Apply to Document Type", "Document Type");
                   QBExternalWorksheetLinesPo.SETRANGE("Apply to Document No", "Document No.");
                   if (QBExternalWorksheetLinesPo.FINDSET(TRUE)) then
                     repeat
                       QBExternalWorksheetLinesPo.VALIDATE(Invoice, FALSE);
                       CLEAR(QBExternalWorksheetLinesPo."Apply to Document Type");
                       QBExternalWorksheetLinesPo."Apply to Document No" := '';
                       QBExternalWorksheetLinesPo.MODIFY;
                     until (QBExternalWorksheetLinesPo.NEXT = 0);
                 end;


    */

    /*
    trigger OnRename();    begin
                   ERROR(Text000,TABLECAPTION);
                 end;

    */




    /*
    procedure InitOutstanding ()
        begin
          if IsCreditDocType then begin
            "Outstanding Quantity" := Quantity - "Return Qty. Shipped";
            "Outstanding Qty. (Base)" := "Quantity (Base)" - "Return Qty. Shipped (Base)";
            "Return Qty. Shipped not Invd." := "Return Qty. Shipped" - "Quantity Invoiced";
            "Ret. Qty. Shpd not Invd.(Base)" := "Return Qty. Shipped (Base)" - "Qty. Invoiced (Base)";
          end else begin
            "Outstanding Quantity" := Quantity - "Quantity Received";
            "Outstanding Qty. (Base)" := "Quantity (Base)" - "Qty. Received (Base)";
            "Qty. Rcd. not Invoiced" := "Quantity Received" - "Quantity Invoiced";
            "Qty. Rcd. not Invoiced (Base)" := "Qty. Received (Base)" - "Qty. Invoiced (Base)";
          end;

          OnAfterInitOutstandingQty(Rec);
          "Completely Received" := (Quantity <> 0) and ("Outstanding Quantity" = 0);
          InitOutstandingAmount;
        end;
    */




    /*
    procedure InitOutstandingAmount ()
        var
    //       AmountInclVAT@1000 :
          AmountInclVAT: Decimal;
        begin
          if Quantity = 0 then begin
            "Outstanding Amount" := 0;
            "Outstanding Amount (LCY)" := 0;
            "Outstanding Amt. Ex. VAT (LCY)" := 0;
            "Amt. Rcd. not Invoiced" := 0;
            "Amt. Rcd. not Invoiced (LCY)" := 0;
            "Return Shpd. not Invd." := 0;
            "Return Shpd. not Invd. (LCY)" := 0;
          end else begin
            GetPurchHeader;
            AmountInclVAT := "Amount Including VAT";
            VALIDATE(
              "Outstanding Amount",
              ROUND(
                AmountInclVAT * "Outstanding Quantity" / Quantity,
                Currency."Amount Rounding Precision"));
            if IsCreditDocType then
              VALIDATE(
                "Return Shpd. not Invd.",
                ROUND(
                  AmountInclVAT * "Return Qty. Shipped not Invd." / Quantity,
                  Currency."Amount Rounding Precision"))
            else
              VALIDATE(
                "Amt. Rcd. not Invoiced",
                ROUND(
                  AmountInclVAT * "Qty. Rcd. not Invoiced" / Quantity,
                  Currency."Amount Rounding Precision"));
          end;

          OnAfterInitOutstandingAmount(Rec,xRec,PurchHeader,Currency);
        end;
    */




    /*
    procedure InitQtyToReceive ()
        begin
          GetPurchSetup;
          if (PurchSetup."Default Qty. to Receive" = PurchSetup."Default Qty. to Receive"::Remainder) or
             ("Document Type" = "Document Type"::Invoice)
          then begin
            "Qty. to Receive" := "Outstanding Quantity";
            "Qty. to Receive (Base)" := "Outstanding Qty. (Base)";
          end else
            if "Qty. to Receive" <> 0 then
              "Qty. to Receive (Base)" := CalcBaseQty("Qty. to Receive");

          OnAfterInitQtyToReceive(Rec,CurrFieldNo);

          InitQtyToInvoice;
        end;
    */




    /*
    procedure InitQtyToShip ()
        begin
          GetPurchSetup;
          if (PurchSetup."Default Qty. to Receive" = PurchSetup."Default Qty. to Receive"::Remainder) or
             ("Document Type" = "Document Type"::"Credit Memo")
          then begin
            "Return Qty. to Ship" := "Outstanding Quantity";
            "Return Qty. to Ship (Base)" := "Outstanding Qty. (Base)";
          end else
            if "Return Qty. to Ship" <> 0 then
              "Return Qty. to Ship (Base)" := CalcBaseQty("Return Qty. to Ship");

          OnAfterInitQtyToShip(Rec,CurrFieldNo);

          InitQtyToInvoice;
        end;
    */




    /*
    procedure InitQtyToInvoice ()
        begin
          "Qty. to Invoice" := MaxQtyToInvoice;
          "Qty. to Invoice (Base)" := MaxQtyToInvoiceBase;
          "VAT Difference" := 0;
          CalcInvDiscToInvoice;
          if PurchHeader."Document Type" <> PurchHeader."Document Type"::Invoice then
            CalcPrepaymentToDeduct;

          OnAfterInitQtyToInvoice(Rec,CurrFieldNo);
        end;
    */



    /*
    LOCAL procedure InitItemAppl ()
        begin
          "Appl.-to Item Entry" := 0;
        end;
    */


    //     LOCAL procedure InitHeaderDefaults (PurchHeader@1000 :

    /*
    LOCAL procedure InitHeaderDefaults (PurchHeader: Record 38)
        begin
          PurchHeader.TESTFIELD("Buy-from Vendor No.");

          "Buy-from Vendor No." := PurchHeader."Buy-from Vendor No.";
          "Currency Code" := PurchHeader."Currency Code";
          "Expected Receipt Date" := PurchHeader."Expected Receipt Date";
          "Shortcut Dimension 1 Code" := PurchHeader."Shortcut Dimension 1 Code";
          "Shortcut Dimension 2 Code" := PurchHeader."Shortcut Dimension 2 Code";
          if not IsNonInventoriableItem then
            "Location Code" := PurchHeader."Location Code";
          "Transaction Type" := PurchHeader."Transaction Type";
          "Transport Method" := PurchHeader."Transport Method";
          "Pay-to Vendor No." := PurchHeader."Pay-to Vendor No.";
          "Gen. Bus. Posting Group" := PurchHeader."Gen. Bus. Posting Group";
          "VAT Bus. Posting Group" := PurchHeader."VAT Bus. Posting Group";
          "Entry Point" := PurchHeader."Entry Point";
          Area := PurchHeader.Area;
          "Transaction Specification" := PurchHeader."Transaction Specification";
          "Tax Area Code" := PurchHeader."Tax Area Code";
          "Tax Liable" := PurchHeader."Tax Liable";
          if not "System-Created Entry" and ("Document Type" = "Document Type"::Order) and HasTypeToFillMandatoryFields or
             IsServiceCharge
          then
            "Prepayment %" := PurchHeader."Prepayment %";
          "Prepayment Tax Area Code" := PurchHeader."Tax Area Code";
          "Prepayment Tax Liable" := PurchHeader."Tax Liable";
          "Responsibility Center" := PurchHeader."Responsibility Center";
          "Requested Receipt Date" := PurchHeader."Requested Receipt Date";
          "Promised Receipt Date" := PurchHeader."Promised Receipt Date";
          "Inbound Whse. Handling Time" := PurchHeader."Inbound Whse. Handling Time";
          "Order Date" := PurchHeader."Order Date";

          OnAfterInitHeaderDefaults(Rec,PurchHeader);
        end;
    */




    /*
    procedure MaxQtyToInvoice () : Decimal;
        begin
          if "Prepayment Line" then
            exit(1);
          if IsCreditDocType then
            exit("Return Qty. Shipped" + "Return Qty. to Ship" - "Quantity Invoiced");

          exit("Quantity Received" + "Qty. to Receive" - "Quantity Invoiced");
        end;
    */




    /*
    procedure MaxQtyToInvoiceBase () : Decimal;
        begin
          if IsCreditDocType then
            exit("Return Qty. Shipped (Base)" + "Return Qty. to Ship (Base)" - "Qty. Invoiced (Base)");

          exit("Qty. Received (Base)" + "Qty. to Receive (Base)" - "Qty. Invoiced (Base)");
        end;
    */




    /*
    procedure CalcInvDiscToInvoice ()
        var
    //       OldInvDiscAmtToInv@1000 :
          OldInvDiscAmtToInv: Decimal;
        begin
          GetPurchHeader;
          OldInvDiscAmtToInv := "Inv. Disc. Amount to Invoice";
          if Quantity = 0 then
            VALIDATE("Inv. Disc. Amount to Invoice",0)
          else
            VALIDATE(
              "Inv. Disc. Amount to Invoice",
              ROUND(
                "Inv. Discount Amount" * "Qty. to Invoice" / Quantity,
                Currency."Amount Rounding Precision"));

          if OldInvDiscAmtToInv <> "Inv. Disc. Amount to Invoice" then begin
            "Amount Including VAT" := "Amount Including VAT" - "VAT Difference";
            "EC Difference" := 0;
            "VAT Difference" := 0;
          end;
        end;
    */


    //     LOCAL procedure CalcBaseQty (Qty@1000 :

    /*
    LOCAL procedure CalcBaseQty (Qty: Decimal) : Decimal;
        begin
          if "Prod. Order No." = '' then
            TESTFIELD("Qty. per Unit of Measure");
          exit(ROUND(Qty * "Qty. per Unit of Measure",0.00001));
        end;
    */




    /*
    procedure CalcLineAmount () : Decimal;
        begin
          exit("Line Amount" - "Inv. Discount Amount");
        end;
    */



    /*
    LOCAL procedure CopyFromStandardText ()
        var
    //       StandardText@1000 :
          StandardText: Record 7;
        begin
          StandardText.GET("No.");
          Description := StandardText.Description;
          "Allow Item Charge Assignment" := FALSE;
          OnAfterAssignStdTxtValues(Rec,StandardText);
        end;
    */



    /*
    LOCAL procedure CopyFromGLAccount ()
        begin
          GLAcc.GET("No.");
          GLAcc.CheckGLAcc;
          if not "System-Created Entry" then
            GLAcc.TESTFIELD("Direct Posting",TRUE);
          Description := GLAcc.Name;
          "Gen. Prod. Posting Group" := GLAcc."Gen. Prod. Posting Group";
          "VAT Prod. Posting Group" := GLAcc."VAT Prod. Posting Group";
          "Tax Group Code" := GLAcc."Tax Group Code";
          "Allow Invoice Disc." := not GLAcc.InvoiceDiscountAllowed("No.");
          "Allow Item Charge Assignment" := FALSE;
          InitDeferralCode;
          OnAfterAssignGLAccountValues(Rec,GLAcc);
        end;
    */



    /*
    LOCAL procedure CopyFromItem ()
        var
    //       Item@1001 :
          Item: Record 27;
    //       PrepaymentMgt@1000 :
          PrepaymentMgt: Codeunit 441;
        begin
          GetItem(Item);
          GetGLSetup;
          OnBeforeCopyFromItem(Rec,Item);
          Item.TESTFIELD(Blocked,FALSE);
          Item.TESTFIELD("Gen. Prod. Posting Group");
          if Item."Purchasing Blocked" and not IsCreditDocType then
            ERROR(PurchasingBlockedErr);
          if Item.Type = Item.Type::Inventory then begin
            Item.TESTFIELD("Inventory Posting Group");
            "Posting Group" := Item."Inventory Posting Group";
          end;
          Description := Item.Description;
          "Description 2" := Item."Description 2";
          "Unit Price (LCY)" := Item."Unit Price";
          "Units per Parcel" := Item."Units per Parcel";
          "Indirect Cost %" := Item."Indirect Cost %";
          "Overhead Rate" := Item."Overhead Rate";
          "Allow Invoice Disc." := Item."Allow Invoice Disc.";
          "Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";
          "VAT Prod. Posting Group" := Item."VAT Prod. Posting Group";
          "Tax Group Code" := Item."Tax Group Code";
          Nonstock := Item."Created From Nonstock Item";
          "Item Category Code" := Item."Item Category Code";
          "Allow Item Charge Assignment" := TRUE;
          PrepaymentMgt.SetPurchPrepaymentPct(Rec,PurchHeader."Posting Date");
          if Item.Type = Item.Type::Inventory then
            PostingSetupMgt.CheckInvtPostingSetupInventoryAccount("Location Code","Posting Group");

          if Item."Price Includes VAT" then begin
            if not VATPostingSetup.GET(Item."VAT Bus. Posting Gr. (Price)",Item."VAT Prod. Posting Group") then
              VATPostingSetup.INIT;
            CASE VATPostingSetup."VAT Calculation Type" OF
              VATPostingSetup."VAT Calculation Type"::"Reverse Charge VAT":
                VATPostingSetup."VAT %" := 0;
              VATPostingSetup."VAT Calculation Type"::"Sales Tax":
                ERROR(
                  Text002,
                  VATPostingSetup.FIELDCAPTION("VAT Calculation Type"),
                  VATPostingSetup."VAT Calculation Type");
            end;
            "Unit Price (LCY)" :=
              ROUND("Unit Price (LCY)" / (1 + VATPostingSetup."VAT %" / 100),
                GLSetup."Unit-Amount Rounding Precision");
          end;

          if PurchHeader."Language Code" <> '' then
            GetItemTranslation;

          "Unit of Measure Code" := Item."Purch. Unit of Measure";
          InitDeferralCode;
          OnAfterAssignItemValues(Rec,Item);
        end;
    */



    /*
    LOCAL procedure CopyFromFixedAsset ()
        var
    //       FixedAsset@1000 :
          FixedAsset: Record 5600;
        begin
          FixedAsset.GET("No.");
          FixedAsset.TESTFIELD(Inactive,FALSE);
          FixedAsset.TESTFIELD(Blocked,FALSE);
          GetFAPostingGroup;
          Description := FixedAsset.Description;
          "Description 2" := FixedAsset."Description 2";
          "Allow Invoice Disc." := FALSE;
          "Allow Item Charge Assignment" := FALSE;
          OnAfterAssignFixedAssetValues(Rec,FixedAsset);
        end;
    */



    /*
    LOCAL procedure CopyFromItemCharge ()
        begin
          ItemCharge.GET("No.");
          Description := ItemCharge.Description;
          "Gen. Prod. Posting Group" := ItemCharge."Gen. Prod. Posting Group";
          "VAT Prod. Posting Group" := ItemCharge."VAT Prod. Posting Group";
          "Tax Group Code" := ItemCharge."Tax Group Code";
          "Allow Invoice Disc." := FALSE;
          "Allow Item Charge Assignment" := FALSE;
          "Indirect Cost %" := 0;
          "Overhead Rate" := 0;
          OnAfterAssignItemChargeValues(Rec,ItemCharge);
        end;
    */



    /*
    LOCAL procedure SelectItemEntry ()
        var
    //       ItemLedgEntry@1001 :
          ItemLedgEntry: Record 32;
        begin
          TESTFIELD("Prod. Order No.",'');
          ItemLedgEntry.SETCURRENTKEY("Item No.",Open);
          ItemLedgEntry.SETRANGE("Item No.","No.");
          ItemLedgEntry.SETRANGE(Open,TRUE);
          ItemLedgEntry.SETRANGE(Positive,TRUE);
          if "Location Code" <> '' then
            ItemLedgEntry.SETRANGE("Location Code","Location Code");
          ItemLedgEntry.SETRANGE("Variant Code","Variant Code");

          if PAGE.RUNMODAL(PAGE::"Item Ledger Entries",ItemLedgEntry) = ACTION::LookupOK then
            VALIDATE("Appl.-to Item Entry",ItemLedgEntry."Entry No.");
        end;
    */



    //     procedure SetPurchHeader (NewPurchHeader@1000 :

    /*
    procedure SetPurchHeader (NewPurchHeader: Record 38)
        begin
          PurchHeader := NewPurchHeader;

          if PurchHeader."Currency Code" = '' then
            Currency.InitRoundingPrecision
          else begin
            PurchHeader.TESTFIELD("Currency Factor");
            Currency.GET(PurchHeader."Currency Code");
            Currency.TESTFIELD("Amount Rounding Precision");
          end;
        end;
    */



    /*
    LOCAL procedure GetPurchHeader ()
        begin
          TESTFIELD("Document No.");
          if ("Document Type" <> PurchHeader."Document Type") or ("Document No." <> PurchHeader."No.") then begin
            PurchHeader.GET("Document Type","Document No.");
            if PurchHeader."Currency Code" = '' then
              Currency.InitRoundingPrecision
            else begin
              PurchHeader.TESTFIELD("Currency Factor");
              Currency.GET(PurchHeader."Currency Code");
              Currency.TESTFIELD("Amount Rounding Precision");
            end;
          end;

          OnAfterGetPurchHeader(Rec,PurchHeader);
        end;
    */


    //     LOCAL procedure GetItem (var Item@1000 :

    /*
    LOCAL procedure GetItem (var Item: Record 27)
        begin
          TESTFIELD("No.");
          Item.GET("No.");

          OnAfterGetItem(Item,Rec);
        end;
    */



    //     procedure UpdateDirectUnitCost (CalledByFieldNo@1000 :

    /*
    procedure UpdateDirectUnitCost (CalledByFieldNo: Integer)
        var
    //       IsHandled@1001 :
          IsHandled: Boolean;
        begin
          IsHandled := FALSE;
          OnBeforeUpdateDirectUnitCost(Rec,xRec,CalledByFieldNo,CurrFieldNo,IsHandled);
          if IsHandled then
            exit;

          if (CurrFieldNo <> 0) and ("Prod. Order No." <> '') then
            UpdateAmounts;

          if ((CalledByFieldNo <> CurrFieldNo) and (CurrFieldNo <> 0)) or
             ("Prod. Order No." <> '')
          then
            exit;

          if Type = Type::Item then begin
            GetPurchHeader;
            IsHandled := FALSE;
            OnUpdateDirectUnitCostOnBeforeFindPrice(PurchHeader,Rec,CalledByFieldNo,CurrFieldNo,IsHandled);
            if not IsHandled then
              PurchPriceCalcMgt.FindPurchLinePrice(PurchHeader,Rec,CalledByFieldNo);
            if not ("Copied From Posted Doc." and IsCreditDocType) then
              PurchPriceCalcMgt.FindPurchLineLineDisc(PurchHeader,Rec);
            VALIDATE("Direct Unit Cost");

            if CalledByFieldNo IN [FIELDNO("No."),FIELDNO("Variant Code"),FIELDNO("Location Code")] then
              UpdateItemReference;
          end;

          OnAfterUpdateDirectUnitCost(Rec,xRec,CalledByFieldNo,CurrFieldNo);
        end;
    */




    /*
    procedure UpdateUnitCost ()
        var
    //       Item@1001 :
          Item: Record 27;
    //       DiscountAmountPerQty@1000 :
          DiscountAmountPerQty: Decimal;
        begin
          GetPurchHeader;
          GetGLSetup;
          if Quantity = 0 then
            DiscountAmountPerQty := 0
          else
            DiscountAmountPerQty :=
              ROUND(("Line Discount Amount" + "Inv. Discount Amount") / Quantity,
                GLSetup."Unit-Amount Rounding Precision");

          if "VAT Calculation Type" = "VAT Calculation Type"::"Full VAT" then
            "Unit Cost" := 0
          else
            if PurchHeader."Prices Including VAT" then
              "Unit Cost" :=
                ("Direct Unit Cost" - DiscountAmountPerQty) * (1 + "Indirect Cost %" / 100) / (1 + ("VAT %" + "EC %") / 100) +
                GetOverheadRateFCY - "VAT Difference"
            else
              "Unit Cost" :=
                ("Direct Unit Cost" - DiscountAmountPerQty) * (1 + "Indirect Cost %" / 100) +
                GetOverheadRateFCY;

          if PurchHeader."Currency Code" <> '' then begin
            PurchHeader.TESTFIELD("Currency Factor");
            "Unit Cost (LCY)" :=
              CurrExchRate.ExchangeAmtFCYToLCY(
                GetDate,"Currency Code",
                "Unit Cost",PurchHeader."Currency Factor");
          end else
            "Unit Cost (LCY)" := "Unit Cost";

          if (Type = Type::Item) and ("Prod. Order No." = '') then begin
            GetItem(Item);
            if Item."Costing Method" = Item."Costing Method"::Standard then begin
              if GetSKU then
                "Unit Cost (LCY)" := SKU."Unit Cost" * "Qty. per Unit of Measure"
              else
                "Unit Cost (LCY)" := Item."Unit Cost" * "Qty. per Unit of Measure";
            end;
          end;

          "Unit Cost (LCY)" := ROUND("Unit Cost (LCY)",GLSetup."Unit-Amount Rounding Precision");
          if PurchHeader."Currency Code" <> '' then
            Currency.TESTFIELD("Unit-Amount Rounding Precision");
          "Unit Cost" := ROUND("Unit Cost",Currency."Unit-Amount Rounding Precision");

          OnAfterUpdateUnitCost(Rec,xRec,PurchHeader,Item,SKU,Currency,GLSetup);

          UpdateSalesCost;

          if JobTaskIsSet and not UpdateFromVAT and not "Prepayment Line" then begin
            CreateTempJobJnlLine(FALSE);
            TempJobJnlLine.VALIDATE("Unit Cost (LCY)","Unit Cost (LCY)");
            UpdateJobPrices;
          end;
        end;
    */




    /*
    procedure UpdateAmounts ()
        var
    //       VATBaseAmount@1003 :
          VATBaseAmount: Decimal;
    //       LineAmountChanged@1002 :
          LineAmountChanged: Boolean;
        begin
          if Type = Type::" " then
            exit;
          GetPurchHeader;

          VATBaseAmount := "VAT Base Amount";
          "Recalculate Invoice Disc." := TRUE;

          if "Line Amount" <> xRec."Line Amount" then begin
            "VAT Difference" := 0;
            LineAmountChanged := TRUE;
          end;
          if "Line Amount" <> ROUND(Quantity * "Direct Unit Cost",Currency."Amount Rounding Precision") - "Line Discount Amount" then begin
            "Line Amount" :=
              ROUND(Quantity * "Direct Unit Cost",Currency."Amount Rounding Precision") - "Line Discount Amount";
            "VAT Difference" := 0;
            LineAmountChanged := TRUE;
            "EC Difference" := 0;
          end;

          if not "Prepayment Line" then
            UpdatePrepmtAmounts;

          OnAfterUpdateAmounts(Rec,xRec,CurrFieldNo);

          UpdateVATAmounts;
          if VATBaseAmount <> "VAT Base Amount" then
            LineAmountChanged := TRUE;

          if LineAmountChanged then begin
            UpdateDeferralAmounts;
            LineAmountChanged := FALSE;
          end;

          InitOutstandingAmount;

          if Type = Type::"Charge (Item)" then
            UpdateItemChargeAssgnt;

          CalcPrepaymentToDeduct;

          OnAfterUpdateAmountsDone(Rec,xRec,CurrFieldNo);
        end;
    */



    //     procedure UpdateVATAmounts ()
    //     var
    // //       PurchLine2@1000 :
    //       PurchLine2: Record 39;
    // //       TotalLineAmount@1005 :
    //       TotalLineAmount: Decimal;
    // //       TotalInvDiscAmount@1004 :
    //       TotalInvDiscAmount: Decimal;
    // //       TotalAmount@1001 :
    //       TotalAmount: Decimal;
    // //       TotalAmountInclVAT@1002 :
    //       TotalAmountInclVAT: Decimal;
    // //       TotalQuantityBase@1003 :
    //       TotalQuantityBase: Decimal;
    //     begin
    //       OnBeforeUpdateVATAmounts(Rec);

    //       GetPurchHeader;
    //       PurchLine2.SETRANGE("Document Type","Document Type");
    //       PurchLine2.SETRANGE("Document No.","Document No.");
    //       PurchLine2.SETFILTER("Line No.",'<>%1',"Line No.");
    //       PurchLine2.SETRANGE("VAT Identifier","VAT Identifier");
    //       PurchLine2.SETRANGE("Tax Group Code","Tax Group Code");

    //       if "Line Amount" = "Inv. Discount Amount" then begin
    //         Amount := 0;
    //         "VAT Base Amount" := 0;
    //         "Amount Including VAT" := 0;
    //         if (Quantity = 0) and (xRec.Quantity <> 0) and (xRec.Amount <> 0) then begin
    //           if "Line No." <> 0 then
    //             MODIFY;
    //           PurchLine2.SETFILTER(Amount,'<>0');
    //           if PurchLine2.FIND('<>') then begin
    //             PurchLine2.ValidateLineDiscountPercent(FALSE);
    //            PurchLine2.MODIFY;
    //           end;
    //         end;
    //       end else begin
    //         TotalLineAmount := 0;
    //         TotalInvDiscAmount := 0;
    //         TotalAmount := 0;
    //         TotalAmountInclVAT := 0;
    //         TotalQuantityBase := 0;
    //         if ("VAT Calculation Type" = "VAT Calculation Type"::"Sales Tax") or
    //            (("VAT Calculation Type" IN
    //              ["VAT Calculation Type"::"Normal VAT",
    //               "VAT Calculation Type"::"Reverse Charge VAT",
    //               "VAT Calculation Type"::"No Taxable VAT"]) and ("VAT %" <> 0))
    //         then begin
    //           PurchLine2.SETFILTER("VAT %",'<>0');
    //           if not PurchLine2.ISEMPTY then begin
    //             PurchLine2.CALCSUMS("Line Amount","Inv. Discount Amount",Amount,"Amount Including VAT","Quantity (Base)");
    //             TotalLineAmount := PurchLine2."Line Amount";
    //             TotalInvDiscAmount := PurchLine2."Inv. Discount Amount";
    //             TotalAmount := PurchLine2.Amount;
    //             TotalAmountInclVAT := PurchLine2."Amount Including VAT";
    //             TotalQuantityBase := PurchLine2."Quantity (Base)";
    //             OnAfterUpdateTotalAmounts(Rec,PurchLine2,TotalAmount,TotalAmountInclVAT,TotalLineAmount,TotalInvDiscAmount);
    //           end;
    //         end;

    //         if PurchHeader."Prices Including VAT" then
    //           CASE "VAT Calculation Type" OF
    //             "VAT Calculation Type"::"Normal VAT",
    //             "VAT Calculation Type"::"Reverse Charge VAT",
    //             "VAT Calculation Type"::"No Taxable VAT":
    //               begin
    //                 Amount :=
    //                   ROUND(
    //                     (TotalLineAmount - TotalInvDiscAmount + CalcLineAmount) / (1 + ("VAT %" + "EC %") / 100),
    //                     Currency."Amount Rounding Precision") -
    //                   TotalAmount;
    //                 "VAT Base Amount" :=
    //                   ROUND(
    //                     Amount * (1 - PurchHeader."VAT Base Discount %" / 100),
    //                     Currency."Amount Rounding Precision");
    //                 "Amount Including VAT" :=
    //                   TotalLineAmount + "Line Amount" -
    //                   ROUND(
    //                     (TotalAmount + Amount) * (PurchHeader."VAT Base Discount %" / 100) * ("VAT %" + "EC %") / 100,
    //                     Currency."Amount Rounding Precision",Currency.VATRoundingDirection) -
    //                   TotalAmountInclVAT - TotalInvDiscAmount - "Inv. Discount Amount";
    //               end;
    //             "VAT Calculation Type"::"Full VAT":
    //               begin
    //                 Amount := 0;
    //                 "VAT Base Amount" := 0;
    //               end;
    //             "VAT Calculation Type"::"Sales Tax":
    //               begin
    //                 PurchHeader.TESTFIELD("VAT Base Discount %",0);
    //                 "Amount Including VAT" :=
    //                   ROUND(CalcLineAmount,Currency."Amount Rounding Precision");
    //                 if "Use Tax" then
    //                   Amount := "Amount Including VAT"
    //                 else
    //                   Amount :=
    //                     ROUND(
    //                       SalesTaxCalculate.ReverseCalculateTax(
    //                         "Tax Area Code","Tax Group Code","Tax Liable",PurchHeader."Posting Date",
    //                         TotalAmountInclVAT + "Amount Including VAT",TotalQuantityBase + "Quantity (Base)",
    //                         PurchHeader."Currency Factor"),
    //                       Currency."Amount Rounding Precision") -
    //                     TotalAmount;
    //                 "VAT Base Amount" := Amount;
    //                 if "VAT Base Amount" <> 0 then
    //                   "VAT %" :=
    //                     ROUND(100 * ("Amount Including VAT" - "VAT Base Amount") / "VAT Base Amount",0.00001)
    //                 else begin
    //                   "VAT %" := 0;
    //                   "EC %" := 0
    //                 end;
    //               end;
    //           end
    //         else
    //           CASE "VAT Calculation Type" OF
    //             "VAT Calculation Type"::"Normal VAT",
    //             "VAT Calculation Type"::"Reverse Charge VAT",
    //             "VAT Calculation Type"::"No Taxable VAT":
    //               begin
    //                 Amount := ROUND(CalcLineAmount,Currency."Amount Rounding Precision");
    //                 "VAT Base Amount" :=
    //                   ROUND(Amount * (1 - PurchHeader."VAT Base Discount %" / 100),Currency."Amount Rounding Precision");
    //                 "Amount Including VAT" :=
    //                   TotalAmount + Amount +
    //                   ROUND(
    //                     (TotalAmount + Amount) * (1 - PurchHeader."VAT Base Discount %" / 100) * ("VAT %" + "EC %") / 100,
    //                     Currency."Amount Rounding Precision",Currency.VATRoundingDirection) -
    //                   TotalAmountInclVAT;
    //               end;
    //             "VAT Calculation Type"::"Full VAT":
    //               begin
    //                 Amount := 0;
    //                 "VAT Base Amount" := 0;
    //                 "Amount Including VAT" := CalcLineAmount;
    //               end;
    //             "VAT Calculation Type"::"Sales Tax":
    //               begin
    //                 Amount := ROUND(CalcLineAmount,Currency."Amount Rounding Precision");
    //                 "VAT Base Amount" := Amount;
    //                 if "Use Tax" then
    //                   "Amount Including VAT" := Amount
    //                 else
    //                   "Amount Including VAT" :=
    //                     TotalAmount + Amount +
    //                     ROUND(
    //                       SalesTaxCalculate.CalculateTax(
    //                         "Tax Area Code","Tax Group Code","Tax Liable",PurchHeader."Posting Date",
    //                         TotalAmount + Amount,TotalQuantityBase + "Quantity (Base)",
    //                         PurchHeader."Currency Factor"),
    //                       Currency."Amount Rounding Precision") -
    //                     TotalAmountInclVAT;
    //                 if "VAT Base Amount" <> 0 then
    //                   "VAT %" :=
    //                     ROUND(100 * ("Amount Including VAT" - "VAT Base Amount") / "VAT Base Amount",0.00001)
    //                 else begin
    //                   "VAT %" := 0;
    //                   "EC %" := 0
    //                 end;
    //               end;
    //           end;
    //       end;

    //       OnAfterUpdateVATAmounts(Rec);
    //     end;



    /*
    procedure UpdatePrepmtSetupFields ()
        var
    //       GenPostingSetup@1001 :
          GenPostingSetup: Record 252;
    //       GLAcc@1000 :
          GLAcc: Record 15;
        begin
          if ("Prepayment %" <> 0) and HasTypeToFillMandatoryFields then begin
            TESTFIELD("Document Type","Document Type"::Order);
            TESTFIELD("No.");
            GenPostingSetup.GET("Gen. Bus. Posting Group","Gen. Prod. Posting Group");
            if GenPostingSetup."Purch. Prepayments Account" <> '' then begin
              GLAcc.GET(GenPostingSetup."Purch. Prepayments Account");
              VATPostingSetup.GET("VAT Bus. Posting Group",GLAcc."VAT Prod. Posting Group");
              VATPostingSetup.TESTFIELD("VAT Calculation Type","VAT Calculation Type");
            end else
              CLEAR(VATPostingSetup);
            "Prepayment VAT %" := VATPostingSetup."VAT %";
            "Prepayment EC %" := VATPostingSetup."EC %";
            "Prepmt. VAT Calc. Type" := VATPostingSetup."VAT Calculation Type";
            "Prepayment VAT Identifier" := VATPostingSetup."VAT Identifier";
            if "Prepmt. VAT Calc. Type" IN
               ["Prepmt. VAT Calc. Type"::"Reverse Charge VAT","Prepmt. VAT Calc. Type"::"Sales Tax"]
            then begin
              "Prepayment VAT %" := 0;
              "Prepayment EC %" := 0;
            end;
            "Prepayment Tax Group Code" := GLAcc."Tax Group Code";
          end;
        end;
    */



    /*
    LOCAL procedure UpdateSalesCost ()
        var
    //       SalesOrderLine@1000 :
          SalesOrderLine: Record 37;
        begin
          CASE TRUE OF
            "Sales Order Line No." <> 0:
              // Drop Shipment
              SalesOrderLine.GET(SalesOrderLine."Document Type"::Order,"Sales Order No.","Sales Order Line No.");
            "Special Order Sales Line No." <> 0:
              // Special Order
              begin
                if not
                   SalesOrderLine.GET(SalesOrderLine."Document Type"::Order,"Special Order Sales No.","Special Order Sales Line No.")
                then
                  exit;
              end;
            else
              exit;
          end;
          SalesOrderLine."Unit Cost (LCY)" := "Unit Cost (LCY)" * SalesOrderLine."Qty. per Unit of Measure" / "Qty. per Unit of Measure";
          SalesOrderLine."Unit Cost" := "Unit Cost" * SalesOrderLine."Qty. per Unit of Measure" / "Qty. per Unit of Measure";
          SalesOrderLine.VALIDATE("Unit Cost (LCY)");
          SalesOrderLine.MODIFY;
        end;
    */



    /*
    LOCAL procedure GetFAPostingGroup ()
        var
    //       LocalGLAcc@1000 :
          LocalGLAcc: Record 15;
    //       FAPostingGr@1001 :
          FAPostingGr: Record 5606;
    //       FADeprBook@1003 :
          FADeprBook: Record 5612;
    //       FASetup@1002 :
          FASetup: Record 5603;
        begin
          if (Type <> Type::"Fixed Asset") or ("No." = '') then
            exit;
          if "Depreciation Book Code" = '' then begin
            FASetup.GET;
            "Depreciation Book Code" := FASetup."Default Depr. Book";
            if not FADeprBook.GET("No.","Depreciation Book Code") then
              "Depreciation Book Code" := '';
            if "Depreciation Book Code" = '' then
              exit;
          end;
          if "FA Posting Type" = "FA Posting Type"::" " then
            "FA Posting Type" := "FA Posting Type"::"Acquisition Cost";
          FADeprBook.GET("No.","Depreciation Book Code");
          FADeprBook.TESTFIELD("FA Posting Group");
          FAPostingGr.GET(FADeprBook."FA Posting Group");
          CASE "FA Posting Type" OF
            "FA Posting Type"::"Acquisition Cost":
              LocalGLAcc.GET(FAPostingGr.GetAcquisitionCostAccount);
            "FA Posting Type"::Appreciation:
              LocalGLAcc.GET(FAPostingGr.GetAppreciationAccount);
            "FA Posting Type"::Maintenance:
              LocalGLAcc.GET(FAPostingGr.GetMaintenanceExpenseAccount);
          end;
          LocalGLAcc.CheckGLAcc;
          LocalGLAcc.TESTFIELD("Gen. Prod. Posting Group");
          "Posting Group" := FADeprBook."FA Posting Group";
          "Gen. Prod. Posting Group" := LocalGLAcc."Gen. Prod. Posting Group";
          "Tax Group Code" := LocalGLAcc."Tax Group Code";
          VALIDATE("VAT Prod. Posting Group",LocalGLAcc."VAT Prod. Posting Group");
        end;
    */




    /*
    procedure UpdateUOMQtyPerStockQty ()
        var
    //       Item@1000 :
          Item: Record 27;
        begin
          GetItem(Item);
          "Unit Cost (LCY)" := Item."Unit Cost" * "Qty. per Unit of Measure";
          "Unit Price (LCY)" := Item."Unit Price" * "Qty. per Unit of Measure";
          GetPurchHeader;
          if PurchHeader."Currency Code" <> '' then
            "Unit Cost" :=
              CurrExchRate.ExchangeAmtLCYToFCY(
                GetDate,PurchHeader."Currency Code",
                "Unit Cost (LCY)",PurchHeader."Currency Factor")
          else
            "Unit Cost" := "Unit Cost (LCY)";
          UpdateDirectUnitCost(FIELDNO("Unit of Measure Code"));
        end;
    */




    /*
    procedure SelectMultipleItems ()
        var
    //       ItemListPage@1000 :
          ItemListPage: Page 31;
    //       SelectionFilter@1001 :
          SelectionFilter: Text;
        begin
          if IsCreditDocType then
            SelectionFilter := ItemListPage.SelectActiveItems
          else
            SelectionFilter := ItemListPage.SelectActiveItemsForPurchase;
          if SelectionFilter <> '' then
            AddItems(SelectionFilter);
        end;
    */


    //     LOCAL procedure AddItems (SelectionFilter@1000 :

    /*
    LOCAL procedure AddItems (SelectionFilter: Text)
        var
    //       Item@1001 :
          Item: Record 27;
    //       DummyPurchLine@1005 :
          DummyPurchLine: Record 39;
    //       PurchLine@1002 :
          PurchLine: Record 39;
    //       LastPurchLine@1003 :
          LastPurchLine: Record 39;
    //       TransferExtendedText@1004 :
          TransferExtendedText: Codeunit 378;
        begin
          InitNewLine(PurchLine);
          Item.SETFILTER("No.",SelectionFilter);
          if Item.FINDSET then
            repeat
              PurchLine.INIT;
              PurchLine."Line No." += 10000;
              PurchLine.VALIDATE(Type,Type::Item);
              PurchLine.VALIDATE("No.",Item."No.");
              PurchLine.INSERT(TRUE);
              if TransferExtendedText.PurchCheckIfAnyExtText(PurchLine,FALSE) then begin
                TransferExtendedText.InsertPurchExtTextRetLast(PurchLine,DummyPurchLine);
                PurchLine."Line No." := LastPurchLine."Line No."
              end;
            until Item.NEXT = 0;
        end;
    */


    //     LOCAL procedure InitNewLine (var NewPurchLine@1001 :

    /*
    LOCAL procedure InitNewLine (var NewPurchLine: Record 39)
        var
    //       PurchLine@1000 :
          PurchLine: Record 39;
        begin
          NewPurchLine.COPY(Rec);
          PurchLine.SETRANGE("Document Type",NewPurchLine."Document Type");
          PurchLine.SETRANGE("Document No.",NewPurchLine."Document No.");
          if PurchLine.FINDLAST then
            NewPurchLine."Line No." := PurchLine."Line No."
          else
            NewPurchLine."Line No." := 0;
        end;
    */




    /*
    procedure ShowReservation ()
        var
    //       Reservation@1000 :
          Reservation: Page 498;
        begin
          TESTFIELD(Type,Type::Item);
          TESTFIELD("Prod. Order No.",'');
          TESTFIELD("No.");
          CLEAR(Reservation);
          Reservation.SetPurchLine(Rec);
          Reservation.RUNMODAL;
        end;
    */



    //     procedure ShowReservationEntries (Modal@1000 :

    /*
    procedure ShowReservationEntries (Modal: Boolean)
        var
    //       ReservEntry@1001 :
          ReservEntry: Record 337;
        begin
          TESTFIELD(Type,Type::Item);
          TESTFIELD("No.");
          ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry,TRUE);
          ReservePurchLine.FilterReservFor(ReservEntry,Rec);
          if Modal then
            PAGE.RUNMODAL(PAGE::"Reservation Entries",ReservEntry)
          else
            PAGE.RUN(PAGE::"Reservation Entries",ReservEntry);
        end;
    */




    /*
    procedure GetDate () : Date;
        begin
          if PurchHeader."Posting Date" <> 0D then
            exit(PurchHeader."Posting Date");
          exit(WORKDATE);
        end;
    */



    //     procedure Signed (Value@1000 :

    /*
    procedure Signed (Value: Decimal) : Decimal;
        begin
          CASE "Document Type" OF
            "Document Type"::Quote,
            "Document Type"::Order,
            "Document Type"::Invoice,
            "Document Type"::"Blanket Order":
              exit(Value);
            "Document Type"::"Return Order",
            "Document Type"::"Credit Memo":
              exit(-Value);
          end;
        end;
    */




    /*
    procedure BlanketOrderLookup ()
        var
    //       IsHandled@1000 :
          IsHandled: Boolean;
        begin
          IsHandled := FALSE;
          OnBeforeBlanketOrderLookup(Rec,CurrFieldNo,IsHandled);
          if IsHandled then
            exit;

          PurchLine2.RESET;
          PurchLine2.SETCURRENTKEY("Document Type",Type,"No.");
          PurchLine2.SETRANGE("Document Type","Document Type"::"Blanket Order");
          PurchLine2.SETRANGE(Type,Type);
          PurchLine2.SETRANGE("No.","No.");
          PurchLine2.SETRANGE("Pay-to Vendor No.","Pay-to Vendor No.");
          PurchLine2.SETRANGE("Buy-from Vendor No.","Buy-from Vendor No.");
          if PAGE.RUNMODAL(PAGE::"Purchase Lines",PurchLine2) = ACTION::LookupOK then begin
            PurchLine2.TESTFIELD("Document Type","Document Type"::"Blanket Order");
            "Blanket Order No." := PurchLine2."Document No.";
            VALIDATE("Blanket Order Line No.",PurchLine2."Line No.");
          end;
        end;
    */



    //     procedure BlockDynamicTracking (SetBlock@1000 :

    /*
    procedure BlockDynamicTracking (SetBlock: Boolean)
        begin
          TrackingBlocked := SetBlock;
          ReservePurchLine.Block(SetBlock);
        end;
    */




    /*
    procedure ShowDimensions ()
        begin
          "Dimension Set ID" :=
            DimMgt.EditDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2 %3',"Document Type","Document No.","Line No."));
          VerifyItemLineDim;
          DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
        end;
    */




    /*
    procedure OpenItemTrackingLines ()
        var
    //       IsHandled@1000 :
          IsHandled: Boolean;
        begin
          IsHandled := FALSE;
          OnBeforeOpenItemTrackingLines(Rec,IsHandled);
          if IsHandled then
            exit;

          TESTFIELD(Type,Type::Item);
          TESTFIELD("No.");
          if "Prod. Order No." <> '' then
            ERROR(Text031,"Prod. Order No.");

          TESTFIELD("Quantity (Base)");

          ReservePurchLine.CallItemTracking(Rec);
        end;
    */



    //     procedure CreateDim (Type1@1000 : Integer;No1@1001 : Code[20];Type2@1002 : Integer;No2@1003 : Code[20];Type3@1004 : Integer;No3@1005 : Code[20];Type4@1006 : Integer;No4@1007 :

    /*
    procedure CreateDim (Type1: Integer;No1: Code[20];Type2: Integer;No2: Code[20];Type3: Integer;No3: Code[20];Type4: Integer;No4: Code[20])
        var
    //       SourceCodeSetup@1008 :
          SourceCodeSetup: Record 242;
    //       TableID@1009 :
          TableID: ARRAY [10] OF Integer;
    //       No@1010 :
          No: ARRAY [10] OF Code[20];
        begin
          SourceCodeSetup.GET;
          TableID[1] := Type1;
          No[1] := No1;
          TableID[2] := Type2;
          No[2] := No2;
          TableID[3] := Type3;
          No[3] := No3;
          TableID[4] := Type4;
          No[4] := No4;
          OnAfterCreateDimTableIDs(Rec,CurrFieldNo,TableID,No);

          "Shortcut Dimension 1 Code" := '';
          "Shortcut Dimension 2 Code" := '';
          GetPurchHeader;
          "Dimension Set ID" :=
            DimMgt.GetRecDefaultDimID(
              Rec,CurrFieldNo,TableID,No,SourceCodeSetup.Purchases,
              "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code",PurchHeader."Dimension Set ID",DATABASE::Vendor);
          DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
        end;
    */



    //     procedure ValidateShortcutDimCode (FieldNumber@1000 : Integer;var ShortcutDimCode@1001 :

    /*
    procedure ValidateShortcutDimCode (FieldNumber: Integer;var ShortcutDimCode: Code[20])
        begin
          DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");
          VerifyItemLineDim;
        end;
    */



    //     procedure LookupShortcutDimCode (FieldNumber@1000 : Integer;var ShortcutDimCode@1001 :

    /*
    procedure LookupShortcutDimCode (FieldNumber: Integer;var ShortcutDimCode: Code[20])
        begin
          DimMgt.LookupDimValueCode(FieldNumber,ShortcutDimCode);
          ValidateShortcutDimCode(FieldNumber,ShortcutDimCode);
        end;
    */



    //     procedure ShowShortcutDimCode (var ShortcutDimCode@1000 :

    /*
    procedure ShowShortcutDimCode (var ShortcutDimCode: ARRAY [8] OF Code[20])
        begin
          DimMgt.GetShortcutDimensions("Dimension Set ID",ShortcutDimCode);
        end;
    */



    /*
    LOCAL procedure GetSKU () : Boolean;
        begin
          TESTFIELD("No.");
          if (SKU."Location Code" = "Location Code") and
             (SKU."Item No." = "No.") and
             (SKU."Variant Code" = "Variant Code")
          then
            exit(TRUE);
          if SKU.GET("Location Code","No.","Variant Code") then
            exit(TRUE);

          exit(FALSE);
        end;
    */




    /*
    procedure ShowItemChargeAssgnt ()
        var
    //       ItemChargeAssgntPurch@1003 :
          ItemChargeAssgntPurch: Record 5805;
    //       AssignItemChargePurch@1001 :
          AssignItemChargePurch: Codeunit 5805;
    //       ItemChargeAssgnts@1000 :
          ItemChargeAssgnts: Page 5805;
    //       ItemChargeAssgntLineAmt@1002 :
          ItemChargeAssgntLineAmt: Decimal;
        begin
          GET("Document Type","Document No.","Line No.");
          TESTFIELD("No.");
          TESTFIELD(Quantity);

          if Type <> Type::"Charge (Item)" then
            ERROR(ItemChargeAssignmentErr);

          GetPurchHeader;
          if PurchHeader."Currency Code" = '' then
            Currency.InitRoundingPrecision
          else
            Currency.GET(PurchHeader."Currency Code");
          if ("Inv. Discount Amount" = 0) and
             ("Line Discount Amount" = 0) and
             (not PurchHeader."Prices Including VAT")
          then
            ItemChargeAssgntLineAmt := "Line Amount"
          else
            if PurchHeader."Prices Including VAT" then
              ItemChargeAssgntLineAmt :=
                ROUND(CalcLineAmount / (1 + ("VAT %" + "EC %") / 100),Currency."Amount Rounding Precision")
            else
              ItemChargeAssgntLineAmt := CalcLineAmount;

          ItemChargeAssgntPurch.RESET;
          ItemChargeAssgntPurch.SETRANGE("Document Type","Document Type");
          ItemChargeAssgntPurch.SETRANGE("Document No.","Document No.");
          ItemChargeAssgntPurch.SETRANGE("Document Line No.","Line No.");
          ItemChargeAssgntPurch.SETRANGE("Item Charge No.","No.");
          if not ItemChargeAssgntPurch.FINDLAST then begin
            ItemChargeAssgntPurch."Document Type" := "Document Type";
            ItemChargeAssgntPurch."Document No." := "Document No.";
            ItemChargeAssgntPurch."Document Line No." := "Line No.";
            ItemChargeAssgntPurch."Item Charge No." := "No.";
            ItemChargeAssgntPurch."Unit Cost" :=
              ROUND(ItemChargeAssgntLineAmt / Quantity,
                Currency."Unit-Amount Rounding Precision");
          end;

          ItemChargeAssgntLineAmt :=
            ROUND(
              ItemChargeAssgntLineAmt * ("Qty. to Invoice" / Quantity),
              Currency."Amount Rounding Precision");

          if IsCreditDocType then
            AssignItemChargePurch.CreateDocChargeAssgnt(ItemChargeAssgntPurch,"Return Shipment No.")
          else
            AssignItemChargePurch.CreateDocChargeAssgnt(ItemChargeAssgntPurch,"Receipt No.");
          CLEAR(AssignItemChargePurch);
          COMMIT;

          ItemChargeAssgnts.Initialize(Rec,ItemChargeAssgntLineAmt);
          ItemChargeAssgnts.RUNMODAL;

          CALCFIELDS("Qty. to Assign");
        end;
    */




    /*
    procedure UpdateItemChargeAssgnt ()
        var
    //       ItemChargeAssgntPurch@1003 :
          ItemChargeAssgntPurch: Record 5805;
    //       ShareOfVAT@1000 :
          ShareOfVAT: Decimal;
    //       TotalQtyToAssign@1001 :
          TotalQtyToAssign: Decimal;
    //       TotalAmtToAssign@1002 :
          TotalAmtToAssign: Decimal;
        begin
          if "Document Type" = "Document Type"::"Blanket Order" then
            exit;

          CALCFIELDS("Qty. Assigned","Qty. to Assign");
          if ABS("Quantity Invoiced") > ABS(("Qty. Assigned" + "Qty. to Assign")) then
            ERROR(Text032,FIELDCAPTION("Quantity Invoiced"),FIELDCAPTION("Qty. Assigned"),FIELDCAPTION("Qty. to Assign"));

          ItemChargeAssgntPurch.SETRANGE("Document Type","Document Type");
          ItemChargeAssgntPurch.SETRANGE("Document No.","Document No.");
          ItemChargeAssgntPurch.SETRANGE("Document Line No.","Line No.");
          ItemChargeAssgntPurch.CALCSUMS("Qty. to Assign");
          TotalQtyToAssign := ItemChargeAssgntPurch."Qty. to Assign";
          if (CurrFieldNo <> 0) and ("Unit Cost" <> xRec."Unit Cost") then begin
            ItemChargeAssgntPurch.SETFILTER("Qty. Assigned",'<>0');
            if not ItemChargeAssgntPurch.ISEMPTY then
              ERROR(Text022,
                FIELDCAPTION("Unit Cost"));
            ItemChargeAssgntPurch.SETRANGE("Qty. Assigned");
          end;

          if (CurrFieldNo <> 0) and (Quantity <> xRec.Quantity) then begin
            ItemChargeAssgntPurch.SETFILTER("Qty. Assigned",'<>0');
            if not ItemChargeAssgntPurch.ISEMPTY then
              ERROR(Text022,
                FIELDCAPTION(Quantity));
            ItemChargeAssgntPurch.SETRANGE("Qty. Assigned");
          end;

          if ItemChargeAssgntPurch.FINDSET(TRUE) and (Quantity <> 0) then begin
            GetPurchHeader;
            TotalAmtToAssign := CalcTotalAmtToAssign(TotalQtyToAssign);
            repeat
              ShareOfVAT := 1;
              if PurchHeader."Prices Including VAT" then
                ShareOfVAT := 1 + "VAT %" / 100;
              if ItemChargeAssgntPurch."Unit Cost" <>
                 ROUND(CalcLineAmount / Quantity / ShareOfVAT,Currency."Unit-Amount Rounding Precision")
              then
                ItemChargeAssgntPurch."Unit Cost" :=
                  ROUND(CalcLineAmount / Quantity / ShareOfVAT,Currency."Unit-Amount Rounding Precision");
              if TotalQtyToAssign <> 0 then begin
                ItemChargeAssgntPurch."Amount to Assign" :=
                  ROUND(ItemChargeAssgntPurch."Qty. to Assign" / TotalQtyToAssign * TotalAmtToAssign,
                    Currency."Amount Rounding Precision");
                TotalQtyToAssign -= ItemChargeAssgntPurch."Qty. to Assign";
                TotalAmtToAssign -= ItemChargeAssgntPurch."Amount to Assign";
              end;
              ItemChargeAssgntPurch.MODIFY;
            until ItemChargeAssgntPurch.NEXT = 0;
            CALCFIELDS("Qty. to Assign");
          end;
        end;
    */


    //     LOCAL procedure DeleteItemChargeAssgnt (DocType@1000 : Option;DocNo@1001 : Code[20];DocLineNo@1002 :

    /*
    LOCAL procedure DeleteItemChargeAssgnt (DocType: Option;DocNo: Code[20];DocLineNo: Integer)
        var
    //       ItemChargeAssgntPurch@1003 :
          ItemChargeAssgntPurch: Record 5805;
        begin
          ItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Type",DocType);
          ItemChargeAssgntPurch.SETRANGE("Applies-to Doc. No.",DocNo);
          ItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Line No.",DocLineNo);
          if not ItemChargeAssgntPurch.ISEMPTY then
            ItemChargeAssgntPurch.DELETEALL(TRUE);
        end;
    */


    //     LOCAL procedure DeleteChargeChargeAssgnt (DocType@1000 : Option;DocNo@1001 : Code[20];DocLineNo@1002 :

    /*
    LOCAL procedure DeleteChargeChargeAssgnt (DocType: Option;DocNo: Code[20];DocLineNo: Integer)
        var
    //       ItemChargeAssgntPurch@1003 :
          ItemChargeAssgntPurch: Record 5805;
        begin
          if DocType <> "Document Type"::"Blanket Order" then
            if "Quantity Invoiced" <> 0 then begin
              CALCFIELDS("Qty. Assigned");
              TESTFIELD("Qty. Assigned","Quantity Invoiced");
            end;

          ItemChargeAssgntPurch.RESET;
          ItemChargeAssgntPurch.SETRANGE("Document Type",DocType);
          ItemChargeAssgntPurch.SETRANGE("Document No.",DocNo);
          ItemChargeAssgntPurch.SETRANGE("Document Line No.",DocLineNo);
          if not ItemChargeAssgntPurch.ISEMPTY then
            ItemChargeAssgntPurch.DELETEALL;
        end;
    */




    /*
    procedure CheckItemChargeAssgnt ()
        var
    //       ItemChargeAssgntPurch@1000 :
          ItemChargeAssgntPurch: Record 5805;
        begin
          ItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Type","Document Type");
          ItemChargeAssgntPurch.SETRANGE("Applies-to Doc. No.","Document No.");
          ItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Line No.","Line No.");
          ItemChargeAssgntPurch.SETRANGE("Document Type","Document Type");
          ItemChargeAssgntPurch.SETRANGE("Document No.","Document No.");
          if ItemChargeAssgntPurch.FINDSET then begin
            TESTFIELD("Allow Item Charge Assignment");
            repeat
              ItemChargeAssgntPurch.TESTFIELD("Qty. to Assign",0);
            until ItemChargeAssgntPurch.NEXT = 0;
          end;
        end;
    */



    //     procedure GetCaptionClass (FieldNumber@1000 :

    /*
    procedure GetCaptionClass (FieldNumber: Integer) : Text[80];
        var
    //       CaptionManagement@1001 :
          CaptionManagement: Codeunit 42;
        begin
          exit(CaptionManagement.GetPurchaseLineCaptionClass(Rec,FieldNumber));
        end;
    */




    /*
    procedure TestStatusOpen ()
        begin
          OnBeforeTestStatusOpen(Rec,PurchHeader);

          if StatusCheckSuspended then
            exit;
          GetPurchHeader;
          if not "System-Created Entry" then
            if HasTypeToFillMandatoryFields then
              PurchHeader.TESTFIELD(Status,PurchHeader.Status::Open);

          OnAfterTestStatusOpen(Rec,PurchHeader);
        end;
    */



    //     procedure SuspendStatusCheck (Suspend@1000 :

    /*
    procedure SuspendStatusCheck (Suspend: Boolean)
        begin
          StatusCheckSuspended := Suspend;
        end;
    */




    /*
    procedure UpdateLeadTimeFields ()
        begin
          if Type = Type::Item then begin
            GetPurchHeader;

            EVALUATE("Lead Time Calculation",
              LeadTimeMgt.PurchaseLeadTime(
                "No.","Location Code","Variant Code",
                "Buy-from Vendor No."));
            if FORMAT("Lead Time Calculation") = '' then
              "Lead Time Calculation" := PurchHeader."Lead Time Calculation";
            EVALUATE("Safety Lead Time",LeadTimeMgt.SafetyLeadTime("No.","Location Code","Variant Code"));
          end;
        end;
    */




    /*
    procedure GetUpdateBasicDates ()
        begin
          GetPurchHeader;
          if PurchHeader."Expected Receipt Date" <> 0D then
            VALIDATE("Expected Receipt Date",PurchHeader."Expected Receipt Date")
          else
            VALIDATE("Order Date",PurchHeader."Order Date");
        end;
    */




    /*
    procedure UpdateDates ()
        begin
          if "Promised Receipt Date" <> 0D then
            VALIDATE("Promised Receipt Date")
          else
            if "Requested Receipt Date" <> 0D then
              VALIDATE("Requested Receipt Date")
            else
              GetUpdateBasicDates;
        end;
    */



    //     procedure InternalLeadTimeDays (PurchDate@1002 :

    /*
    procedure InternalLeadTimeDays (PurchDate: Date) : Text[30];
        var
    //       TotalDays@1001 :
          TotalDays: DateFormula;
        begin
          EVALUATE(
            TotalDays,'<' + FORMAT(CALCDATE("Safety Lead Time",CALCDATE("Inbound Whse. Handling Time",PurchDate)) - PurchDate) + 'D>');
          exit(FORMAT(TotalDays));
        end;
    */


    //     LOCAL procedure ReversedInternalLeadTimeDays (PurchDate@1002 :

    /*
    LOCAL procedure ReversedInternalLeadTimeDays (PurchDate: Date) : Text[30];
        var
    //       TotalDays@1001 :
          TotalDays: DateFormula;
    //       ReversedSafetyLeadTime@1000 :
          ReversedSafetyLeadTime: DateFormula;
    //       ReversedWhseHandlingTime@1003 :
          ReversedWhseHandlingTime: DateFormula;
        begin
          CalendarMgmt.ReverseDateFormula(ReversedSafetyLeadTime,"Safety Lead Time");
          CalendarMgmt.ReverseDateFormula(ReversedWhseHandlingTime,"Inbound Whse. Handling Time");
          EVALUATE(
            TotalDays,'<' + FORMAT(PurchDate - CALCDATE(ReversedWhseHandlingTime,CALCDATE(ReversedSafetyLeadTime,PurchDate))) + 'D>');
          exit(FORMAT(TotalDays));
        end;
    */



    //     procedure UpdateVATOnLines (QtyType@1000 : 'General,Invoicing,Shipping';var PurchHeader@1001 : Record 38;var PurchLine@1002 : Record 39;var VATAmountLine@1003 :

    /*
    procedure UpdateVATOnLines (QtyType: Option "General","Invoicing","Shipping";var PurchHeader: Record 38;var PurchLine: Record 39;var VATAmountLine: Record 290) LineWasModified : Boolean;
        var
    //       TempVATAmountLineRemainder@1004 :
          TempVATAmountLineRemainder: Record 290 TEMPORARY;
    //       Currency@1005 :
          Currency: Record 4;
    //       NewAmount@1006 :
          NewAmount: Decimal;
    //       NewAmountIncludingVAT@1007 :
          NewAmountIncludingVAT: Decimal;
    //       NewVATBaseAmount@1008 :
          NewVATBaseAmount: Decimal;
    //       VATAmount@1009 :
          VATAmount: Decimal;
    //       VATDifference@1010 :
          VATDifference: Decimal;
    //       InvDiscAmount@1011 :
          InvDiscAmount: Decimal;
    //       LineAmountToInvoice@1012 :
          LineAmountToInvoice: Decimal;
    //       ECDifference@1100103 :
          ECDifference: Decimal;
    //       LineAmountToInvoiceDiscounted@1013 :
          LineAmountToInvoiceDiscounted: Decimal;
    //       DeferralAmount@1014 :
          DeferralAmount: Decimal;
        begin
          LineWasModified := FALSE;
          if QtyType = QtyType::Shipping then
            exit;
          if PurchHeader."Currency Code" = '' then
            Currency.InitRoundingPrecision
          else
            Currency.GET(PurchHeader."Currency Code");

          TempVATAmountLineRemainder.DELETEALL;

          WITH PurchLine DO begin
            SETRANGE("Document Type",PurchHeader."Document Type");
            SETRANGE("Document No.",PurchHeader."No.");
            LOCKTABLE;
            if FINDSET then
              repeat
                if not ZeroAmountLine(QtyType) then begin
                  DeferralAmount := GetDeferralAmount;
                  VATAmountLine.GET("VAT Identifier","VAT Calculation Type","Tax Group Code","Use Tax","Line Amount" >= 0);
                  if VATAmountLine.Modified then begin
                    if not TempVATAmountLineRemainder.GET(
                         "VAT Identifier","VAT Calculation Type","Tax Group Code","Use Tax","Line Amount" >= 0)
                    then begin
                      TempVATAmountLineRemainder := VATAmountLine;
                      TempVATAmountLineRemainder.INIT;
                      TempVATAmountLineRemainder.INSERT;
                    end;

                    if QtyType = QtyType::General then
                      LineAmountToInvoice := "Line Amount"
                    else
                      LineAmountToInvoice :=
                        ROUND("Line Amount" * "Qty. to Invoice" / Quantity,Currency."Amount Rounding Precision");

                    if "Allow Invoice Disc." then begin
                      if (VATAmountLine."Inv. Disc. Base Amount" = 0) or (LineAmountToInvoice = 0) then
                        InvDiscAmount := 0
                      else begin
                        if QtyType = QtyType::General then
                          LineAmountToInvoice := "Line Amount"
                        else
                          LineAmountToInvoice :=
                            ROUND("Line Amount" * "Qty. to Invoice" / Quantity,Currency."Amount Rounding Precision");
                        LineAmountToInvoiceDiscounted :=
                          VATAmountLine."Invoice Discount Amount" * LineAmountToInvoice /
                          VATAmountLine."Inv. Disc. Base Amount";
                        TempVATAmountLineRemainder."Invoice Discount Amount" :=
                          TempVATAmountLineRemainder."Invoice Discount Amount" + LineAmountToInvoiceDiscounted;
                        InvDiscAmount :=
                          ROUND(
                            TempVATAmountLineRemainder."Invoice Discount Amount",Currency."Amount Rounding Precision");
                        TempVATAmountLineRemainder."Invoice Discount Amount" :=
                          TempVATAmountLineRemainder."Invoice Discount Amount" - InvDiscAmount;
                      end;
                      if QtyType = QtyType::General then begin
                        "Inv. Discount Amount" := InvDiscAmount;
                        CalcInvDiscToInvoice;
                      end else
                        "Inv. Disc. Amount to Invoice" := InvDiscAmount;
                    end else
                      InvDiscAmount := 0;
                    if QtyType = QtyType::General then
                      if PurchHeader."Prices Including VAT" then begin
                        if (VATAmountLine.CalcLineAmount = 0) or ("Line Amount" = 0) then begin
                          VATAmount := 0;
                          NewAmountIncludingVAT := 0;
                        end else begin
                          VATAmount :=
                            TempVATAmountLineRemainder."VAT Amount" +
                            VATAmountLine."VAT Amount" * CalcLineAmount / VATAmountLine.CalcLineAmount +
                            VATAmountLine."EC Amount" * CalcLineAmount / VATAmountLine.CalcLineAmount;
                          NewAmountIncludingVAT :=
                            TempVATAmountLineRemainder."Amount Including VAT" +
                            VATAmountLine."Amount Including VAT" * CalcLineAmount / VATAmountLine.CalcLineAmount;
                        end;
                        NewAmount :=
                          ROUND(NewAmountIncludingVAT,Currency."Amount Rounding Precision") -
                          ROUND(VATAmount,Currency."Amount Rounding Precision");
                        NewVATBaseAmount :=
                          ROUND(
                            NewAmount * (1 - PurchHeader."VAT Base Discount %" / 100),
                            Currency."Amount Rounding Precision");
                      end else begin
                        if "VAT Calculation Type" = "VAT Calculation Type"::"Full VAT" then begin
                          VATAmount := CalcLineAmount - "Pmt. Discount Amount";
                          NewAmount := 0;
                          NewVATBaseAmount := 0;
                        end else begin
                          NewAmount := CalcLineAmount - "Pmt. Discount Amount";
                          NewVATBaseAmount :=
                            ROUND(
                              NewAmount * (1 - PurchHeader."VAT Base Discount %" / 100),
                              Currency."Amount Rounding Precision");
                          if VATAmountLine."VAT Base" = 0 then
                            VATAmount := 0
                          else
                            VATAmount :=
                              TempVATAmountLineRemainder."VAT Amount" +
                              VATAmountLine."VAT Amount" * NewAmount / VATAmountLine."VAT Base" +
                              VATAmountLine."EC Amount" * NewAmount / VATAmountLine."VAT Base";
                        end;
                        NewAmountIncludingVAT := NewAmount + ROUND(VATAmount,Currency."Amount Rounding Precision");
                      end
                    else begin
                      if VATAmountLine.CalcLineAmount = 0 then begin
                        VATDifference := 0;
                        ECDifference := 0;
                      end else begin
                        VATDifference :=
                          TempVATAmountLineRemainder."VAT Difference" +
                          VATAmountLine."VAT Difference" * (LineAmountToInvoice - InvDiscAmount) / VATAmountLine.CalcLineAmount;
                        ECDifference :=
                          TempVATAmountLineRemainder."EC Difference" +
                          VATAmountLine."EC Difference" * (LineAmountToInvoice - InvDiscAmount) / VATAmountLine.CalcLineAmount;
                      end;

                      if LineAmountToInvoice = 0 then begin
                        "VAT Difference" := 0;
                        "EC Difference" := 0;
                      end else begin
                        "VAT Difference" := ROUND(VATDifference,Currency."Amount Rounding Precision");
                        "EC Difference" := ROUND(ECDifference,Currency."Amount Rounding Precision");
                      end;
                    end;

                    if QtyType = QtyType::General then begin
                      if not "Prepayment Line" then
                        UpdatePrepmtAmounts;
                      UpdateBaseAmounts(NewAmount,ROUND(NewAmountIncludingVAT,Currency."Amount Rounding Precision"),NewVATBaseAmount);
                    end;
                    InitOutstanding;
                    if not ((Type = Type::"Charge (Item)") and ("Quantity Invoiced" <> "Qty. Assigned")) then begin
                      SetUpdateFromVAT(TRUE);
                      UpdateUnitCost;
                    end;
                    if Type = Type::"Charge (Item)" then
                      UpdateItemChargeAssgnt;
                    MODIFY;
                    LineWasModified := TRUE;

                    if ("Deferral Code" <> '') and (DeferralAmount <> GetDeferralAmount) then
                      UpdateDeferralAmounts;

                    TempVATAmountLineRemainder."Amount Including VAT" :=
                      NewAmountIncludingVAT - ROUND(NewAmountIncludingVAT,Currency."Amount Rounding Precision");
                    TempVATAmountLineRemainder."VAT Amount" := VATAmount - NewAmountIncludingVAT + NewAmount;
                    TempVATAmountLineRemainder."VAT Difference" := VATDifference - "VAT Difference";
                    TempVATAmountLineRemainder."EC Difference" := ECDifference - "EC Difference";
                    TempVATAmountLineRemainder.MODIFY;
                  end;
                end;
              until NEXT = 0;
          end;

          OnAfterUpdateVATOnLines(PurchHeader,PurchLine,VATAmountLine,QtyType);
        end;
    */



    //     procedure CalcVATAmountLines (QtyType@1000 : 'General,Invoicing,Shipping';var PurchHeader@1001 : Record 38;var PurchLine@1002 : Record 39;var VATAmountLine@1003 :

    /*
    procedure CalcVATAmountLines (QtyType: Option "General","Invoicing","Shipping";var PurchHeader: Record 38;var PurchLine: Record 39;var VATAmountLine: Record 290)
        var
    //       Currency@1004 :
          Currency: Record 4;
    //       TotalVATAmount@1008 :
          TotalVATAmount: Decimal;
    //       QtyToHandle@1006 :
          QtyToHandle: Decimal;
    //       AmtToHandle@1005 :
          AmtToHandle: Decimal;
    //       RoundingLineInserted@1010 :
          RoundingLineInserted: Boolean;
        begin
          if IsCalcVATAmountLinesHandled(PurchHeader,PurchLine,VATAmountLine) then
            exit;

          Currency.Initialize(PurchHeader."Currency Code");

          VATAmountLine.DELETEALL;

          WITH PurchLine DO begin
            SETRANGE("Document Type",PurchHeader."Document Type");
            SETRANGE("Document No.",PurchHeader."No.");
            if FINDSET then
              repeat
                if not ZeroAmountLine(QtyType) then begin
                  if (Type = Type::"G/L Account") and not "Prepayment Line" then
                    RoundingLineInserted := (("No." = GetVPGInvRoundAcc(PurchHeader)) and "System-Created Entry") or RoundingLineInserted;
                  if "VAT Calculation Type" IN
                     ["VAT Calculation Type"::"Reverse Charge VAT","VAT Calculation Type"::"Sales Tax"]
                  then begin
                    "VAT %" := 0;
                    "EC %" := 0
                  end;
                  if not VATAmountLine.GET(
                       "VAT Identifier","VAT Calculation Type","Tax Group Code","Use Tax","Line Amount" >= 0)
                  then begin
                    if VATPostingSetup.GET("VAT Bus. Posting Group","VAT Prod. Posting Group") and
                       (VATPostingSetup."VAT Calculation Type" <> VATPostingSetup."VAT Calculation Type"::"Reverse Charge VAT")
                    then
                      VATAmountLine.InsertNewLine(
                        "VAT Identifier","VAT Calculation Type","Tax Group Code","Use Tax",VATPostingSetup."VAT %",
                        "Line Amount" >= 0,FALSE,VATPostingSetup."EC %")
                    else
                      VATAmountLine.InsertNewLine(
                        "VAT Identifier","VAT Calculation Type","Tax Group Code","Use Tax",0,"Line Amount" >= 0,FALSE,0);
                  end;
                  CASE QtyType OF
                    QtyType::General:
                      begin
                        VATAmountLine.Quantity += "Quantity (Base)";
                        VATAmountLine.SumLine(
                          "Line Amount","Inv. Discount Amount","Pmt. Discount Amount","VAT Difference","EC Difference",
                          "Allow Invoice Disc.","Prepayment Line");
                      end;
                    QtyType::Invoicing:
                      begin
                        CASE TRUE OF
                          ("Document Type" IN ["Document Type"::Order,"Document Type"::Invoice]) and
                          (not PurchHeader.Receive) and PurchHeader.Invoice and (not "Prepayment Line"):
                            if "Receipt No." = '' then begin
                              QtyToHandle := GetAbsMin("Qty. to Invoice","Qty. Rcd. not Invoiced");
                              VATAmountLine.Quantity += GetAbsMin("Qty. to Invoice (Base)","Qty. Rcd. not Invoiced (Base)");
                            end else begin
                              QtyToHandle := "Qty. to Invoice";
                              VATAmountLine.Quantity += "Qty. to Invoice (Base)";
                            end;
                          IsCreditDocType and (not PurchHeader.Ship) and PurchHeader.Invoice:
                            if "Return Shipment No." = '' then begin
                              QtyToHandle := GetAbsMin("Qty. to Invoice","Return Qty. Shipped not Invd.");
                              VATAmountLine.Quantity += GetAbsMin("Qty. to Invoice (Base)","Ret. Qty. Shpd not Invd.(Base)");
                            end else begin
                              QtyToHandle := "Qty. to Invoice";
                              VATAmountLine.Quantity += "Qty. to Invoice (Base)";
                            end;
                          else begin
                            QtyToHandle := "Qty. to Invoice";
                            VATAmountLine.Quantity += "Qty. to Invoice (Base)";
                          end;
                        end;
                        AmtToHandle := GetLineAmountToHandleInclPrepmt(QtyToHandle);
                        if PurchHeader."Invoice Discount Calculation" <> PurchHeader."Invoice Discount Calculation"::Amount then
                          VATAmountLine.SumLine(
                            AmtToHandle,ROUND("Inv. Discount Amount" * QtyToHandle / Quantity,Currency."Amount Rounding Precision"),
                            ROUND("Pmt. Discount Amount" * QtyToHandle / Quantity,Currency."Amount Rounding Precision"),
                            "VAT Difference","EC Difference","Allow Invoice Disc.","Prepayment Line")
                        else
                          VATAmountLine.SumLine(
                            AmtToHandle,"Inv. Disc. Amount to Invoice",
                            ROUND("Pmt. Discount Amount" * QtyToHandle / Quantity,Currency."Amount Rounding Precision"),
                            "VAT Difference","EC Difference","Allow Invoice Disc.","Prepayment Line");
                      end;
                    QtyType::Shipping:
                      begin
                        if "Document Type" IN
                           ["Document Type"::"Return Order","Document Type"::"Credit Memo"]
                        then begin
                          QtyToHandle := "Return Qty. to Ship";
                          VATAmountLine.Quantity += "Return Qty. to Ship (Base)";
                        end else begin
                          QtyToHandle := "Qty. to Receive";
                          VATAmountLine.Quantity += "Qty. to Receive (Base)";
                        end;
                        AmtToHandle := GetLineAmountToHandleInclPrepmt(QtyToHandle);
                        VATAmountLine.SumLine(
                          AmtToHandle,ROUND("Inv. Discount Amount" * QtyToHandle / Quantity,Currency."Amount Rounding Precision"),
                          ROUND("Pmt. Discount Amount" * QtyToHandle / Quantity,Currency."Amount Rounding Precision"),
                          "VAT Difference","EC Difference","Allow Invoice Disc.","Prepayment Line");
                      end;
                  end;
                  TotalVATAmount += "Amount Including VAT" - Amount;
                end;
              until NEXT = 0;
          end;

          VATAmountLine.UpdateLines(
            TotalVATAmount,Currency,PurchHeader."Currency Factor",PurchHeader."Prices Including VAT",
            PurchHeader."VAT Base Discount %",PurchHeader."Tax Area Code",PurchHeader."Tax Liable",PurchHeader."Posting Date");

          if RoundingLineInserted and (TotalVATAmount <> 0) then
            if GetVATAmountLineOfMaxAmt(VATAmountLine,PurchLine) then begin
              VATAmountLine."VAT Amount" += TotalVATAmount;
              VATAmountLine."Amount Including VAT" += TotalVATAmount;
              VATAmountLine."Calculated VAT Amount" += TotalVATAmount;
              VATAmountLine.MODIFY;
            end;

          OnAfterCalcVATAmountLines(PurchHeader,PurchLine,VATAmountLine,QtyType);
        end;
    */


    //     LOCAL procedure GetVATAmountLineOfMaxAmt (var VATAmountLine@1001 : Record 290;PurchaseLine@1000 :

    /*
    LOCAL procedure GetVATAmountLineOfMaxAmt (var VATAmountLine: Record 290;PurchaseLine: Record 39) : Boolean;
        var
    //       VATAmount1@1002 :
          VATAmount1: Decimal;
    //       VATAmount2@1003 :
          VATAmount2: Decimal;
    //       IsPositive1@1004 :
          IsPositive1: Boolean;
    //       IsPositive2@1005 :
          IsPositive2: Boolean;
        begin
          if VATAmountLine.GET(
               PurchaseLine."VAT Identifier",PurchaseLine."VAT Calculation Type",PurchaseLine."Tax Group Code",FALSE,FALSE)
          then begin
            VATAmount1 := VATAmountLine."VAT Amount";
            IsPositive1 := VATAmountLine.Positive;
          end;
          if VATAmountLine.GET(
               PurchaseLine."VAT Identifier",PurchaseLine."VAT Calculation Type",PurchaseLine."Tax Group Code",FALSE,TRUE)
          then begin
            VATAmount2 := VATAmountLine."VAT Amount";
            IsPositive2 := VATAmountLine.Positive;
          end;
          if ABS(VATAmount1) >= ABS(VATAmount2) then
            exit(
              VATAmountLine.GET(
                PurchaseLine."VAT Identifier",PurchaseLine."VAT Calculation Type",PurchaseLine."Tax Group Code",FALSE,IsPositive1));
          exit(
            VATAmountLine.GET(
              PurchaseLine."VAT Identifier",PurchaseLine."VAT Calculation Type",PurchaseLine."Tax Group Code",FALSE,IsPositive2));
        end;
    */




    /*
    procedure UpdateWithWarehouseReceive ()
        begin
          if Type = Type::Item then
            CASE TRUE OF
              ("Document Type" IN ["Document Type"::Quote,"Document Type"::Order]) and (Quantity >= 0):
                if Location.RequireReceive("Location Code") then
                  VALIDATE("Qty. to Receive",0)
                else
                  VALIDATE("Qty. to Receive","Outstanding Quantity");
              ("Document Type" IN ["Document Type"::Quote,"Document Type"::Order]) and (Quantity < 0):
                if Location.RequireShipment("Location Code") then
                  VALIDATE("Qty. to Receive",0)
                else
                  VALIDATE("Qty. to Receive","Outstanding Quantity");
              ("Document Type" = "Document Type"::"Return Order") and (Quantity >= 0):
                if Location.RequireShipment("Location Code") then
                  VALIDATE("Return Qty. to Ship",0)
                else
                  VALIDATE("Return Qty. to Ship","Outstanding Quantity");
              ("Document Type" = "Document Type"::"Return Order") and (Quantity < 0):
                if Location.RequireReceive("Location Code") then
                  VALIDATE("Return Qty. to Ship",0)
                else
                  VALIDATE("Return Qty. to Ship","Outstanding Quantity");
            end;

          GetPurchHeader;
          OnAfterUpdateWithWarehouseReceive(PurchHeader,Rec);

          SetDefaultQuantity;
        end;
    */



    /*
    LOCAL procedure CheckWarehouse ()
        var
    //       Location2@1002 :
          Location2: Record 14;
    //       WhseSetup@1000 :
          WhseSetup: Record 5769;
    //       ShowDialog@1001 :
          ShowDialog: Option " ","Message","Error";
    //       DialogText@1003 :
          DialogText: Text[50];
        begin
          if "Prod. Order No." <> '' then
            exit;
          GetLocation("Location Code");
          if "Location Code" = '' then begin
            WhseSetup.GET;
            Location2."Require Shipment" := WhseSetup."Require Shipment";
            Location2."Require Pick" := WhseSetup."Require Pick";
            Location2."Require Receive" := WhseSetup."Require Receive";
            Location2."Require Put-away" := WhseSetup."Require Put-away";
          end else
            Location2 := Location;

          DialogText := Text033;
          if ("Document Type" IN ["Document Type"::Order,"Document Type"::"Return Order"]) and
             Location2."Directed Put-away and Pick"
          then begin
            ShowDialog := ShowDialog::Error;
            if (("Document Type" = "Document Type"::Order) and (Quantity >= 0)) or
               (("Document Type" = "Document Type"::"Return Order") and (Quantity < 0))
            then
              DialogText :=
                DialogText + Location2.GetRequirementText(Location2.FIELDNO("Require Receive"))
            else
              DialogText :=
                DialogText + Location2.GetRequirementText(Location2.FIELDNO("Require Shipment"));
          end else begin
            if (("Document Type" = "Document Type"::Order) and (Quantity >= 0) and
                (Location2."Require Receive" or Location2."Require Put-away")) or
               (("Document Type" = "Document Type"::"Return Order") and (Quantity < 0) and
                (Location2."Require Receive" or Location2."Require Put-away"))
            then begin
              if WhseValidateSourceLine.WhseLinesExist(
                   DATABASE::"Purchase Line",
                   "Document Type",
                   "Document No.",
                   "Line No.",
                   0,
                   Quantity)
              then
                ShowDialog := ShowDialog::Error
              else
                if Location2."Require Receive" then
                  ShowDialog := ShowDialog::Message;
              if Location2."Require Receive" then
                DialogText :=
                  DialogText + Location2.GetRequirementText(Location2.FIELDNO("Require Receive"))
              else begin
                DialogText := Text034;
                DialogText :=
                  DialogText + Location2.GetRequirementText(Location2.FIELDNO("Require Put-away"));
              end;
            end;

            if (("Document Type" = "Document Type"::Order) and (Quantity < 0) and
                (Location2."Require Shipment" or Location2."Require Pick")) or
               (("Document Type" = "Document Type"::"Return Order") and (Quantity >= 0) and
                (Location2."Require Shipment" or Location2."Require Pick"))
            then begin
              if WhseValidateSourceLine.WhseLinesExist(
                   DATABASE::"Purchase Line",
                   "Document Type",
                   "Document No.",
                   "Line No.",
                   0,
                   Quantity)
              then
                ShowDialog := ShowDialog::Error
              else
                if Location2."Require Shipment" then
                  ShowDialog := ShowDialog::Message;
              if Location2."Require Shipment" then
                DialogText :=
                  DialogText + Location2.GetRequirementText(Location2.FIELDNO("Require Shipment"))
              else begin
                DialogText := Text034;
                DialogText :=
                  DialogText + Location2.GetRequirementText(Location2.FIELDNO("Require Pick"));
              end;
            end;
          end;

          CASE ShowDialog OF
            ShowDialog::Message:
              MESSAGE(WhseRequirementMsg,DialogText);
            ShowDialog::Error:
              ERROR(Text016,DialogText,FIELDCAPTION("Line No."),"Line No.")
          end;

          HandleDedicatedBin(TRUE);
        end;
    */



    /*
    LOCAL procedure GetOverheadRateFCY () : Decimal;
        var
    //       Item@1001 :
          Item: Record 27;
    //       QtyPerUOM@1000 :
          QtyPerUOM: Decimal;
        begin
          if "Prod. Order No." = '' then
            QtyPerUOM := "Qty. per Unit of Measure"
          else begin
            GetItem(Item);
            QtyPerUOM := UOMMgt.GetQtyPerUnitOfMeasure(Item,"Unit of Measure Code");
          end;

          exit(
            CurrExchRate.ExchangeAmtLCYToFCY(
              GetDate,"Currency Code","Overhead Rate" * QtyPerUOM,PurchHeader."Currency Factor"));
        end;
    */




    /*
    procedure GetItemTranslation ()
        var
    //       ItemTranslation@1000 :
          ItemTranslation: Record 30;
        begin
          GetPurchHeader;
          if ItemTranslation.GET("No.","Variant Code",PurchHeader."Language Code") then begin
            Description := ItemTranslation.Description;
            "Description 2" := ItemTranslation."Description 2";
          end;
        end;
    */



    /*
    LOCAL procedure GetGLSetup ()
        begin
          if not GLSetupRead then
            GLSetup.GET;
          GLSetupRead := TRUE;
        end;
    */



    /*
    LOCAL procedure GetPurchSetup ()
        begin
          if not PurchSetupRead then
            PurchSetup.GET;
          PurchSetupRead := TRUE;
        end;
    */



    //     procedure AdjustDateFormula (DateFormulatoAdjust@1000 :

    /*
    procedure AdjustDateFormula (DateFormulatoAdjust: DateFormula) : Text[30];
        begin
          if FORMAT(DateFormulatoAdjust) <> '' then
            exit(FORMAT(DateFormulatoAdjust));
          EVALUATE(DateFormulatoAdjust,'<0D>');
          exit(FORMAT(DateFormulatoAdjust));
        end;
    */


    //     LOCAL procedure GetLocation (LocationCode@1000 :

    /*
    LOCAL procedure GetLocation (LocationCode: Code[10])
        begin
          if LocationCode = '' then
            CLEAR(Location)
          else
            if Location.Code <> LocationCode then
              Location.GET(LocationCode);
        end;
    */




    /*
    procedure RowID1 () : Text[250];
        var
    //       ItemTrackingMgt@1000 :
          ItemTrackingMgt: Codeunit 6500;
        begin
          exit(ItemTrackingMgt.ComposeRowID(DATABASE::"Purchase Line","Document Type",
              "Document No.",'',0,"Line No."));
        end;
    */



    /*
    LOCAL procedure GetDefaultBin ()
        var
    //       WMSManagement@1000 :
          WMSManagement: Codeunit 7302;
        begin
          if Type <> Type::Item then
            exit;

          "Bin Code" := '';
          if "Drop Shipment" then
            exit;

          if ("Location Code" <> '') and ("No." <> '') then begin
            GetLocation("Location Code");
            if Location."Bin Mandatory" and not Location."Directed Put-away and Pick" then begin
              WMSManagement.GetDefaultBin("No.","Variant Code","Location Code","Bin Code");
              HandleDedicatedBin(FALSE);
            end;
          end;
        end;
    */




    /*
    procedure IsInbound () : Boolean;
        begin
          CASE "Document Type" OF
            "Document Type"::Order,"Document Type"::Invoice,"Document Type"::Quote,"Document Type"::"Blanket Order":
              exit("Quantity (Base)" > 0);
            "Document Type"::"Return Order","Document Type"::"Credit Memo":
              exit("Quantity (Base)" < 0);
          end;

          exit(FALSE);
        end;
    */


    //     LOCAL procedure HandleDedicatedBin (IssueWarning@1000 :

    /*
    LOCAL procedure HandleDedicatedBin (IssueWarning: Boolean)
        var
    //       WhseIntegrationMgt@1001 :
          WhseIntegrationMgt: Codeunit 7317;
        begin
          if not IsInbound and ("Quantity (Base)" <> 0) then
            WhseIntegrationMgt.CheckIfBinDedicatedOnSrcDoc("Location Code","Bin Code",IssueWarning);
        end;
    */




    /*
    procedure CrossReferenceNoLookUp ()
        var
    //       ItemCrossReference@1000 :
          ItemCrossReference: Record 5717;
        begin
          if Type = Type::Item then begin
            GetPurchHeader;
            ItemCrossReference.RESET;
            ItemCrossReference.SETCURRENTKEY("Cross-Reference Type","Cross-Reference Type No.");
            ItemCrossReference.SETFILTER(
              "Cross-Reference Type",'%1|%2',
              ItemCrossReference."Cross-Reference Type"::Vendor,
              ItemCrossReference."Cross-Reference Type"::" ");
            ItemCrossReference.SETFILTER("Cross-Reference Type No.",'%1|%2',PurchHeader."Buy-from Vendor No.",'');
            if PAGE.RUNMODAL(PAGE::"Cross Reference List",ItemCrossReference) = ACTION::LookupOK then begin
              "Cross-Reference No." := ItemCrossReference."Cross-Reference No.";
              ValidateCrossReferenceNo(ItemCrossReference,FALSE);
              VALIDATE("Cross-Reference No.",ItemCrossReference."Cross-Reference No.");
              PurchPriceCalcMgt.FindPurchLinePrice(PurchHeader,Rec,FIELDNO("Cross-Reference No."));
              PurchPriceCalcMgt.FindPurchLineLineDisc(PurchHeader,Rec);
              VALIDATE("Direct Unit Cost");
            end;
          end;
        end;
    */


    //     LOCAL procedure ValidateCrossReferenceNo (ItemCrossReference@1000 : Record 5717;SearchItem@1001 :

    /*
    LOCAL procedure ValidateCrossReferenceNo (ItemCrossReference: Record 5717;SearchItem: Boolean)
        var
    //       ReturnedItemCrossReference@1002 :
          ReturnedItemCrossReference: Record 5717;
        begin
          ReturnedItemCrossReference.INIT;
          if "Cross-Reference No." <> '' then begin
            if SearchItem then
              DistIntegration.ICRLookupPurchaseItem(Rec,ReturnedItemCrossReference,CurrFieldNo <> 0)
            else
              ReturnedItemCrossReference := ItemCrossReference;

            OnValidateCrossReferenceNoOnBeforeAssignNo(Rec,ReturnedItemCrossReference);

            VALIDATE("No.",ReturnedItemCrossReference."Item No.");
            SetVendorItemNo;
            if ReturnedItemCrossReference."Variant Code" <> '' then
              VALIDATE("Variant Code",ReturnedItemCrossReference."Variant Code");
            if ReturnedItemCrossReference."Unit of Measure" <> '' then
              VALIDATE("Unit of Measure Code",ReturnedItemCrossReference."Unit of Measure");
            UpdateDirectUnitCost(FIELDNO("Cross-Reference No."));
          end;

          "Unit of Measure (Cross Ref.)" := ReturnedItemCrossReference."Unit of Measure";
          "Cross-Reference Type" := ReturnedItemCrossReference."Cross-Reference Type";
          "Cross-Reference Type No." := ReturnedItemCrossReference."Cross-Reference Type No.";
          "Cross-Reference No." := ReturnedItemCrossReference."Cross-Reference No.";

          if (ReturnedItemCrossReference.Description <> '') or (ReturnedItemCrossReference."Description 2" <> '') then begin
            Description := ReturnedItemCrossReference.Description;
            "Description 2" := ReturnedItemCrossReference."Description 2";
          end;

          UpdateICPartner;
        end;
    */



    //     procedure ItemExists (ItemNo@1000 :

    /*
    procedure ItemExists (ItemNo: Code[20]) : Boolean;
        var
    //       Item2@1001 :
          Item2: Record 27;
        begin
          if Type = Type::Item then
            if not Item2.GET(ItemNo) then
              exit(FALSE);
          exit(TRUE);
        end;
    */


    //     LOCAL procedure GetAbsMin (QtyToHandle@1000 : Decimal;QtyHandled@1001 :

    /*
    LOCAL procedure GetAbsMin (QtyToHandle: Decimal;QtyHandled: Decimal) : Decimal;
        begin
          if ABS(QtyHandled) < ABS(QtyToHandle) then
            exit(QtyHandled);

          exit(QtyToHandle);
        end;
    */



    /*
    LOCAL procedure CheckApplToItemLedgEntry () : Code[10];
        var
    //       ItemLedgEntry@1000 :
          ItemLedgEntry: Record 32;
    //       ApplyRec@1005 :
          ApplyRec: Record 339;
    //       ItemTrackingLines@1006 :
          ItemTrackingLines: Page 6510;
    //       ReturnedQty@1003 :
          ReturnedQty: Decimal;
    //       RemainingtobeReturnedQty@1004 :
          RemainingtobeReturnedQty: Decimal;
        begin
          if "Appl.-to Item Entry" = 0 then
            exit;

          if "Receipt No." <> '' then
            exit;

          TESTFIELD(Type,Type::Item);
          TESTFIELD(Quantity);
          if Signed(Quantity) > 0 then
            TESTFIELD("Prod. Order No.",'');
          if IsCreditDocType then begin
            if Quantity < 0 then
              FIELDERROR(Quantity,Text029);
          end else begin
            if Quantity > 0 then
              FIELDERROR(Quantity,Text030);
          end;
          ItemLedgEntry.GET("Appl.-to Item Entry");
          ItemLedgEntry.TESTFIELD(Positive,TRUE);
          if ItemLedgEntry.TrackingExists then
            ERROR(Text040,ItemTrackingLines.CAPTION,FIELDCAPTION("Appl.-to Item Entry"));

          ItemLedgEntry.TESTFIELD("Item No.","No.");
          ItemLedgEntry.TESTFIELD("Variant Code","Variant Code");

          // Track qty in both alternative and base UOM for better error checking and reporting
          if ABS("Quantity (Base)") > ItemLedgEntry.Quantity then
            ERROR(
              Text042,
              ItemLedgEntry.Quantity,ItemLedgEntry.FIELDCAPTION("Document No."),
              ItemLedgEntry."Document No.");

          if IsCreditDocType then
            if ABS("Outstanding Qty. (Base)") > ItemLedgEntry."Remaining Quantity" then begin
              ReturnedQty := ApplyRec.Returned(ItemLedgEntry."Entry No.");
              RemainingtobeReturnedQty := ItemLedgEntry.Quantity - ReturnedQty;
              if not ("Qty. per Unit of Measure" = 0) then begin
                ReturnedQty := ROUND(ReturnedQty / "Qty. per Unit of Measure",0.00001);
                RemainingtobeReturnedQty := ROUND(RemainingtobeReturnedQty / "Qty. per Unit of Measure",0.00001);
              end;

              if ((("Qty. per Unit of Measure" = 0) and (RemainingtobeReturnedQty < ABS("Outstanding Qty. (Base)"))) or
                  (("Qty. per Unit of Measure" <> 0) and (RemainingtobeReturnedQty < ABS("Outstanding Quantity"))))
              then
                ERROR(
                  Text035,
                  ReturnedQty,ItemLedgEntry.FIELDCAPTION("Document No."),
                  ItemLedgEntry."Document No.",RemainingtobeReturnedQty);
            end;

          exit(ItemLedgEntry."Location Code");
        end;
    */




    /*
    procedure CalcPrepaymentToDeduct ()
        begin
          if ("Qty. to Invoice" <> 0) and ("Prepmt. Amt. Inv." <> 0) then begin
            GetPurchHeader;
            if ("Prepayment %" = 100) and not IsFinalInvoice then
              "Prepmt Amt to Deduct" := GetLineAmountToHandle("Qty. to Invoice")
            else
              "Prepmt Amt to Deduct" :=
                ROUND(
                  ("Prepmt. Amt. Inv." - "Prepmt Amt Deducted") *
                  "Qty. to Invoice" / (Quantity - "Quantity Invoiced"),Currency."Amount Rounding Precision")
          end else
            "Prepmt Amt to Deduct" := 0
        end;
    */




    /*
    procedure IsFinalInvoice () : Boolean;
        begin
          exit("Qty. to Invoice" = Quantity - "Quantity Invoiced");
        end;
    */



    //     procedure GetLineAmountToHandle (QtyToHandle@1002 :

    /*
    procedure GetLineAmountToHandle (QtyToHandle: Decimal) : Decimal;
        var
    //       LineAmount@1001 :
          LineAmount: Decimal;
    //       LineDiscAmount@1000 :
          LineDiscAmount: Decimal;
        begin
          if "Line Discount %" = 100 then
            exit(0);

          GetPurchHeader;

          if "Prepmt Amt to Deduct" = 0 then
            LineAmount := ROUND(QtyToHandle * "Direct Unit Cost",Currency."Amount Rounding Precision")
          else begin
            LineAmount := ROUND(Quantity * "Direct Unit Cost",Currency."Amount Rounding Precision");
            LineAmount := ROUND(QtyToHandle * LineAmount / Quantity,Currency."Amount Rounding Precision");
          end;

          if QtyToHandle <> Quantity then
            LineDiscAmount := ROUND(LineAmount * "Line Discount %" / 100,Currency."Amount Rounding Precision")
          else
            LineDiscAmount := "Line Discount Amount";

          OnAfterGetLineAmountToHandle(Rec,QtyToHandle,LineAmount,LineDiscAmount);
          exit(LineAmount - LineDiscAmount);
        end;
    */



    //     procedure GetLineAmountToHandleInclPrepmt (QtyToHandle@1002 :

    /*
    procedure GetLineAmountToHandleInclPrepmt (QtyToHandle: Decimal) : Decimal;
        begin
          if "Line Discount %" = 100 then
            exit(0);
          if ("Prepayment %" = 100) and not "Prepayment Line" and ("Prepmt Amt to Deduct" <> 0) then
            exit("Prepmt Amt to Deduct");
          exit(GetLineAmountToHandle(QtyToHandle));
        end;
    */




    /*
    procedure JobTaskIsSet () : Boolean;
        var
    //       JobTaskSet@1000 :
          JobTaskSet: Boolean;
        begin
          JobTaskSet := FALSE;
          OnBeforeJobTaskIsSet(Rec,JobTaskSet);

          exit(
            (("Job No." <> '') and ("Job Task No." <> '') and (Type IN [Type::"G/L Account",Type::Item])) or
            JobTaskSet);
        end;
    */



    //     procedure CreateTempJobJnlLine (GetPrices@1001 :

    /*
    procedure CreateTempJobJnlLine (GetPrices: Boolean)
        begin
          OnBeforeCreateTempJobJnlLine(TempJobJnlLine,Rec,xRec,GetPrices,CurrFieldNo);

          GetPurchHeader;
          CLEAR(TempJobJnlLine);
          TempJobJnlLine.DontCheckStdCost;
          TempJobJnlLine.VALIDATE("Job No.","Job No.");
          TempJobJnlLine.VALIDATE("Job Task No.","Job Task No.");
          TempJobJnlLine.VALIDATE("Posting Date",PurchHeader."Posting Date");
          TempJobJnlLine.SetCurrencyFactor("Job Currency Factor");
          if Type = Type::"G/L Account" then
            TempJobJnlLine.VALIDATE(Type,TempJobJnlLine.Type::"G/L Account")
          else
            TempJobJnlLine.VALIDATE(Type,TempJobJnlLine.Type::Item);
          TempJobJnlLine.VALIDATE("No.","No.");
          TempJobJnlLine.VALIDATE(Quantity,Quantity);
          TempJobJnlLine.VALIDATE("Variant Code","Variant Code");
          TempJobJnlLine.VALIDATE("Unit of Measure Code","Unit of Measure Code");

          if not GetPrices then begin
            if xRec."Line No." <> 0 then begin
              TempJobJnlLine."Unit Cost" := xRec."Unit Cost";
              TempJobJnlLine."Unit Cost (LCY)" := xRec."Unit Cost (LCY)";
              TempJobJnlLine."Unit Price" := xRec."Job Unit Price";
              TempJobJnlLine."Line Amount" := xRec."Job Line Amount";
              TempJobJnlLine."Line Discount %" := xRec."Job Line Discount %";
              TempJobJnlLine."Line Discount Amount" := xRec."Job Line Discount Amount";
            end else begin
              TempJobJnlLine."Unit Cost" := "Unit Cost";
              TempJobJnlLine."Unit Cost (LCY)" := "Unit Cost (LCY)";
              TempJobJnlLine."Unit Price" := "Job Unit Price";
              TempJobJnlLine."Line Amount" := "Job Line Amount";
              TempJobJnlLine."Line Discount %" := "Job Line Discount %";
              TempJobJnlLine."Line Discount Amount" := "Job Line Discount Amount";
            end;
            TempJobJnlLine.VALIDATE("Unit Price");
          end else
            TempJobJnlLine.VALIDATE("Unit Cost (LCY)","Unit Cost (LCY)");

          OnAfterCreateTempJobJnlLine(TempJobJnlLine,Rec,xRec,GetPrices,CurrFieldNo);
        end;
    */




    /*
    procedure UpdateJobPrices ()
        var
    //       PurchRcptLine@1000 :
          PurchRcptLine: Record 121;
        begin
          if "Receipt No." = '' then begin
            "Job Unit Price" := TempJobJnlLine."Unit Price";
            "Job Total Price" := TempJobJnlLine."Total Price";
            "Job Unit Price (LCY)" := TempJobJnlLine."Unit Price (LCY)";
            "Job Total Price (LCY)" := TempJobJnlLine."Total Price (LCY)";
            "Job Line Amount (LCY)" := TempJobJnlLine."Line Amount (LCY)";
            "Job Line Disc. Amount (LCY)" := TempJobJnlLine."Line Discount Amount (LCY)";
            "Job Line Amount" := TempJobJnlLine."Line Amount";
            "Job Line Discount %" := TempJobJnlLine."Line Discount %";
            "Job Line Discount Amount" := TempJobJnlLine."Line Discount Amount";
          end else begin
            PurchRcptLine.GET("Receipt No.","Receipt Line No.");
            "Job Unit Price" := PurchRcptLine."Job Unit Price";
            "Job Total Price" := PurchRcptLine."Job Total Price";
            "Job Unit Price (LCY)" := PurchRcptLine."Job Unit Price (LCY)";
            "Job Total Price (LCY)" := PurchRcptLine."Job Total Price (LCY)";
            "Job Line Amount (LCY)" := PurchRcptLine."Job Line Amount (LCY)";
            "Job Line Disc. Amount (LCY)" := PurchRcptLine."Job Line Disc. Amount (LCY)";
            "Job Line Amount" := PurchRcptLine."Job Line Amount";
            "Job Line Discount %" := PurchRcptLine."Job Line Discount %";
            "Job Line Discount Amount" := PurchRcptLine."Job Line Discount Amount";
          end;

          OnAfterUpdateJobPrices(Rec,TempJobJnlLine,PurchRcptLine);
        end;
    */




    /*
    procedure JobSetCurrencyFactor ()
        begin
          GetPurchHeader;
          CLEAR(TempJobJnlLine);
          TempJobJnlLine.VALIDATE("Job No.","Job No.");
          TempJobJnlLine.VALIDATE("Job Task No.","Job Task No.");
          TempJobJnlLine.VALIDATE("Posting Date",PurchHeader."Posting Date");
          "Job Currency Factor" := TempJobJnlLine."Currency Factor";
        end;
    */



    //     procedure SetUpdateFromVAT (UpdateFromVAT2@1000 :

    /*
    procedure SetUpdateFromVAT (UpdateFromVAT2: Boolean)
        begin
          UpdateFromVAT := UpdateFromVAT2;
        end;
    */




    /*
    procedure InitQtyToReceive2 ()
        begin
          "Qty. to Receive" := "Outstanding Quantity";
          "Qty. to Receive (Base)" := "Outstanding Qty. (Base)";

          "Qty. to Invoice" := MaxQtyToInvoice;
          "Qty. to Invoice (Base)" := MaxQtyToInvoiceBase;
          "VAT Difference" := 0;

          CalcInvDiscToInvoice;

          CalcPrepaymentToDeduct;

          if "Job Planning Line No." <> 0 then
            VALIDATE("Job Planning Line No.");
        end;
    */




    /*
    procedure ClearQtyIfBlank ()
        begin
          if "Document Type" = "Document Type"::Order then begin
            GetPurchSetup;
            if PurchSetup."Default Qty. to Receive" = PurchSetup."Default Qty. to Receive"::Blank then begin
              "Qty. to Receive" := 0;
              "Qty. to Receive (Base)" := 0;
            end;
          end;
        end;
    */




    /*
    procedure ShowLineComments ()
        var
    //       PurchCommentLine@1000 :
          PurchCommentLine: Record 43;
        begin
          TESTFIELD("Document No.");
          TESTFIELD("Line No.");
          PurchCommentLine.ShowComments("Document Type","Document No.","Line No.");
        end;
    */




    /*
    procedure SetDefaultQuantity ()
        begin
          GetPurchSetup;
          if PurchSetup."Default Qty. to Receive" = PurchSetup."Default Qty. to Receive"::Blank then begin
            if ("Document Type" = "Document Type"::Order) or ("Document Type" = "Document Type"::Quote) then begin
              "Qty. to Receive" := 0;
              "Qty. to Receive (Base)" := 0;
              "Qty. to Invoice" := 0;
              "Qty. to Invoice (Base)" := 0;
            end;
            if "Document Type" = "Document Type"::"Return Order" then begin
              "Return Qty. to Ship" := 0;
              "Return Qty. to Ship (Base)" := 0;
              "Qty. to Invoice" := 0;
              "Qty. to Invoice (Base)" := 0;
            end;
          end;

          OnAfterSetDefaultQuantity(Rec,xRec);
        end;
    */




    /*
    procedure UpdatePrePaymentAmounts ()
        var
    //       ReceiptLine@1000 :
          ReceiptLine: Record 121;
    //       PurchOrderLine@1001 :
          PurchOrderLine: Record 39;
    //       PurchOrderHeader@1002 :
          PurchOrderHeader: Record 38;
        begin
          if ("Document Type" <> "Document Type"::Invoice) or ("Prepayment %" = 0) then
            exit;

          if not ReceiptLine.GET("Receipt No.","Receipt Line No.") then begin
            "Prepmt Amt to Deduct" := 0;
            "Prepmt VAT Diff. to Deduct" := 0;
          end else
            if PurchOrderLine.GET(PurchOrderLine."Document Type"::Order,ReceiptLine."Order No.",ReceiptLine."Order Line No.") then begin
              if ("Prepayment %" = 100) and (Quantity <> PurchOrderLine.Quantity - PurchOrderLine."Quantity Invoiced") then
                "Prepmt Amt to Deduct" := "Line Amount"
              else
                "Prepmt Amt to Deduct" :=
                  ROUND((PurchOrderLine."Prepmt. Amt. Inv." - PurchOrderLine."Prepmt Amt Deducted") *
                    Quantity / (PurchOrderLine.Quantity - PurchOrderLine."Quantity Invoiced"),Currency."Amount Rounding Precision");
              "Prepmt VAT Diff. to Deduct" := "Prepayment VAT Difference" - "Prepmt VAT Diff. Deducted";
              PurchOrderHeader.GET(PurchOrderHeader."Document Type"::Order,PurchOrderLine."Document No.");
            end else begin
              "Prepmt Amt to Deduct" := 0;
              "Prepmt VAT Diff. to Deduct" := 0;
            end;

          GetPurchHeader;
          PurchHeader.TESTFIELD("Prices Including VAT",PurchOrderHeader."Prices Including VAT");
          if PurchHeader."Prices Including VAT" then begin
            "Prepmt. Amt. Incl. VAT" := "Prepmt Amt to Deduct";
            "Prepayment Amount" :=
              ROUND(
                "Prepmt Amt to Deduct" / (1 + ("Prepayment VAT %" / 100)),
                Currency."Amount Rounding Precision");
          end else begin
            "Prepmt. Amt. Incl. VAT" :=
              ROUND(
                "Prepmt Amt to Deduct" * (1 + ("Prepayment VAT %" / 100)),
                Currency."Amount Rounding Precision");
            "Prepayment Amount" := "Prepmt Amt to Deduct";
          end;
          "Prepmt. Line Amount" := "Prepmt Amt to Deduct";
          "Prepmt. Amt. Inv." := "Prepmt. Line Amount";
          "Prepmt. VAT Base Amt." := "Prepayment Amount";
          "Prepmt. Amount Inv. Incl. VAT" := "Prepmt. Amt. Incl. VAT";
          "Prepmt Amt Deducted" := 0;
        end;
    */




    /*
    procedure SetVendorItemNo ()
        var
    //       Item@1001 :
          Item: Record 27;
    //       ItemVend@1000 :
          ItemVend: Record 99;
        begin
          GetItem(Item);
          ItemVend.INIT;
          ItemVend."Vendor No." := "Buy-from Vendor No.";
          ItemVend."Variant Code" := "Variant Code";
          Item.FindItemVend(ItemVend,"Location Code");
          VALIDATE("Vendor Item No.",ItemVend."Vendor Item No.");
        end;
    */



    //     procedure ZeroAmountLine (QtyType@1000 :

    /*
    procedure ZeroAmountLine (QtyType: Option "General","Invoicing","Shippin") : Boolean;
        begin
          if Type = Type::" " then
            exit(TRUE);
          if Quantity = 0 then
            exit(TRUE);
          if "Direct Unit Cost" = 0 then
            exit(TRUE);
          if QtyType = QtyType::Invoicing then
            if "Qty. to Invoice" = 0 then
              exit(TRUE);
          exit(FALSE);
        end;
    */



    //     procedure FilterLinesWithItemToPlan (var Item@1000 : Record 27;DocumentType@1001 :

    /*
    procedure FilterLinesWithItemToPlan (var Item: Record 27;DocumentType: Option)
        begin
          RESET;
          SETCURRENTKEY("Document Type",Type,"No.","Variant Code","Drop Shipment","Location Code","Expected Receipt Date");
          SETRANGE("Document Type",DocumentType);
          SETRANGE(Type,Type::Item);
          SETRANGE("No.",Item."No.");
          SETFILTER("Variant Code",Item.GETFILTER("Variant Filter"));
          SETFILTER("Location Code",Item.GETFILTER("Location Filter"));
          SETFILTER("Drop Shipment",Item.GETFILTER("Drop Shipment Filter"));
          SETFILTER("Expected Receipt Date",Item.GETFILTER("Date Filter"));
          SETFILTER("Shortcut Dimension 1 Code",Item.GETFILTER("Global Dimension 1 Filter"));
          SETFILTER("Shortcut Dimension 2 Code",Item.GETFILTER("Global Dimension 2 Filter"));
          SETFILTER("Outstanding Qty. (Base)",'<>0');

          OnAfterFilterLinesWithItemToPlan(Rec,Item);
        end;
    */



    //     procedure FindLinesWithItemToPlan (var Item@1000 : Record 27;DocumentType@1001 :

    /*
    procedure FindLinesWithItemToPlan (var Item: Record 27;DocumentType: Option) : Boolean;
        begin
          FilterLinesWithItemToPlan(Item,DocumentType);
          exit(FIND('-'));
        end;
    */



    //     procedure LinesWithItemToPlanExist (var Item@1000 : Record 27;DocumentType@1001 :

    /*
    procedure LinesWithItemToPlanExist (var Item: Record 27;DocumentType: Option) : Boolean;
        begin
          FilterLinesWithItemToPlan(Item,DocumentType);
          exit(not ISEMPTY);
        end;
    */



    //     procedure GetVPGInvRoundAcc (var PurchHeader@1002 :

    /*
    procedure GetVPGInvRoundAcc (var PurchHeader: Record 38) : Code[20];
        var
    //       Vendor@1000 :
          Vendor: Record 23;
    //       VendorPostingGroup@1001 :
          VendorPostingGroup: Record 93;
        begin
          GetPurchSetup;
          if PurchSetup."Invoice Rounding" then
            if Vendor.GET(PurchHeader."Pay-to Vendor No.") then
              VendorPostingGroup.GET(Vendor."Vendor Posting Group");

          exit(VendorPostingGroup."Invoice Rounding Account");
        end;
    */



    /*
    LOCAL procedure CheckReceiptRelation ()
        var
    //       PurchRcptLine@1001 :
          PurchRcptLine: Record 121;
        begin
          PurchRcptLine.GET("Receipt No.","Receipt Line No.");
          if (Quantity * PurchRcptLine."Qty. Rcd. not Invoiced") < 0 then
            FIELDERROR("Qty. to Invoice",Text051);
          if ABS(Quantity) > ABS(PurchRcptLine."Qty. Rcd. not Invoiced") then
            ERROR(Text052,PurchRcptLine."Document No.");
        end;
    */



    /*
    LOCAL procedure CheckRetShptRelation ()
        var
    //       ReturnShptLine@1000 :
          ReturnShptLine: Record 6651;
        begin
          ReturnShptLine.GET("Return Shipment No.","Return Shipment Line No.");
          if (Quantity * (ReturnShptLine.Quantity - ReturnShptLine."Quantity Invoiced")) < 0 then
            FIELDERROR("Qty. to Invoice",Text053);
          if ABS(Quantity) > ABS(ReturnShptLine.Quantity - ReturnShptLine."Quantity Invoiced") then
            ERROR(Text054,ReturnShptLine."Document No.");
        end;
    */



    /*
    LOCAL procedure VerifyItemLineDim ()
        begin
          if IsReceivedShippedItemDimChanged then
            ConfirmReceivedShippedItemDimChange;
        end;
    */




    /*
    procedure IsReceivedShippedItemDimChanged () : Boolean;
        begin
          exit(("Dimension Set ID" <> xRec."Dimension Set ID") and (Type = Type::Item) and
            (("Qty. Rcd. not Invoiced" <> 0) or ("Return Qty. Shipped not Invd." <> 0)));
        end;
    */



    /*
    LOCAL procedure IsServiceCharge () : Boolean;
        var
    //       VendorPostingGroup@1001 :
          VendorPostingGroup: Record 93;
        begin
          if Type <> Type::"G/L Account" then
            exit(FALSE);

          GetPurchHeader;
          VendorPostingGroup.GET(PurchHeader."Vendor Posting Group");
          exit(VendorPostingGroup."Service Charge Acc." = "No.");
        end;
    */




    /*
    procedure ConfirmReceivedShippedItemDimChange () : Boolean;
        var
    //       ConfirmManagement@1000 :
          ConfirmManagement: Codeunit 27;
        begin
          if not ConfirmManagement.ConfirmProcess(STRSUBSTNO(Text049,TABLECAPTION),TRUE) then
            ERROR(Text050);

          exit(TRUE);
        end;
    */




    /*
    procedure InitType ()
        begin
          if "Document No." <> '' then begin
            if not PurchHeader.GET("Document Type","Document No.") then
              exit;
            if (PurchHeader.Status = PurchHeader.Status::Released) and
               (xRec.Type IN [xRec.Type::Item,xRec.Type::"Fixed Asset"])
            then
              Type := Type::" "
            else
              Type := xRec.Type;
          end;
        end;
    */



    /*
    LOCAL procedure CheckWMS ()
        begin
          if CurrFieldNo <> 0 then
            CheckLocationOnWMS;
        end;
    */




    /*
    procedure CheckLocationOnWMS ()
        var
    //       DialogText@1001 :
          DialogText: Text;
        begin
          if Type = Type::Item then begin
            DialogText := Text033;
            if "Quantity (Base)" <> 0 then
              CASE "Document Type" OF
                "Document Type"::Invoice:
                  if "Receipt No." = '' then
                    if Location.GET("Location Code") and Location."Directed Put-away and Pick" then begin
                      DialogText += Location.GetRequirementText(Location.FIELDNO("Require Receive"));
                      ERROR(Text016,DialogText,FIELDCAPTION("Line No."),"Line No.");
                    end;
                "Document Type"::"Credit Memo":
                  if "Return Shipment No." = '' then
                    if Location.GET("Location Code") and Location."Directed Put-away and Pick" then begin
                      DialogText += Location.GetRequirementText(Location.FIELDNO("Require Shipment"));
                      ERROR(Text016,DialogText,FIELDCAPTION("Line No."),"Line No.");
                    end;
              end;
          end;
        end;
    */




    /*
    procedure IsNonInventoriableItem () : Boolean;
        var
    //       Item@1000 :
          Item: Record 27;
        begin
          if Type <> Type::Item then
            exit(FALSE);
          if "No." = '' then
            exit(FALSE);
          GetItem(Item);
          exit(Item.IsNonInventoriableType);
        end;
    */




    /*
    procedure IsInventoriableItem () : Boolean;
        var
    //       Item@1000 :
          Item: Record 27;
        begin
          if Type <> Type::Item then
            exit(FALSE);
          if "No." = '' then
            exit(FALSE);
          GetItem(Item);
          exit(Item.IsInventoriableType);
        end;
    */



    /*
    LOCAL procedure ReservEntryExist () : Boolean;
        var
    //       NewReservEntry@1000 :
          NewReservEntry: Record 337;
        begin
          ReservePurchLine.FilterReservFor(NewReservEntry,Rec);
          NewReservEntry.SETRANGE("Reservation Status",NewReservEntry."Reservation Status"::Reservation,
            NewReservEntry."Reservation Status"::Tracking);

          exit(not NewReservEntry.ISEMPTY);
        end;
    */


    //     LOCAL procedure ValidateReturnReasonCode (CallingFieldNo@1000 :

    /*
    LOCAL procedure ValidateReturnReasonCode (CallingFieldNo: Integer)
        var
    //       ReturnReason@1001 :
          ReturnReason: Record 6635;
        begin
          if CallingFieldNo = 0 then
            exit;
          if "Return Reason Code" = '' then
            UpdateDirectUnitCost(CallingFieldNo);

          if ReturnReason.GET("Return Reason Code") then begin
            if (CallingFieldNo <> FIELDNO("Location Code")) and (ReturnReason."Default Location Code" <> '') then
              VALIDATE("Location Code",ReturnReason."Default Location Code");
            if ReturnReason."Inventory Value Zero" then
              VALIDATE("Direct Unit Cost",0)
            else
              UpdateDirectUnitCost(CallingFieldNo);
          end;
        end;
    */



    //     procedure ValidateLineDiscountPercent (DropInvoiceDiscountAmount@1000 :

    /*
    procedure ValidateLineDiscountPercent (DropInvoiceDiscountAmount: Boolean)
        begin
          TestStatusOpen;
          GetPurchHeader;
          "Line Discount Amount" :=
            ROUND(
              ROUND(Quantity * "Direct Unit Cost",Currency."Amount Rounding Precision") *
              "Line Discount %" / 100,
              Currency."Amount Rounding Precision");
          if DropInvoiceDiscountAmount then begin
            "Inv. Discount Amount" := 0;
            "Inv. Disc. Amount to Invoice" := 0;
            "Pmt. Discount Amount" := 0;
          end;
          UpdateAmounts;
          UpdateUnitCost;
        end;
    */



    /*
    LOCAL procedure UpdateDimensionsFromJobTask ()
        var
    //       SourceCodeSetup@1003 :
          SourceCodeSetup: Record 242;
    //       DimSetArrID@1000 :
          DimSetArrID: ARRAY [10] OF Integer;
    //       DimValue1@1001 :
          DimValue1: Code[20];
    //       DimValue2@1002 :
          DimValue2: Code[20];
        begin
          SourceCodeSetup.GET;
          DimSetArrID[1] := "Dimension Set ID";
          DimSetArrID[2] :=
            DimMgt.CreateDimSetFromJobTaskDim("Job No.",
              "Job Task No.",DimValue1,DimValue2);
          DimMgt.CreateDimForPurchLineWithHigherPriorities(
            Rec,CurrFieldNo,DimSetArrID[3],DimValue1,DimValue2,SourceCodeSetup.Purchases,DATABASE::Job);

          "Dimension Set ID" :=
            DimMgt.GetCombinedDimensionSetID(
              DimSetArrID,DimValue1,DimValue2);

          "Shortcut Dimension 1 Code" := DimValue1;
          "Shortcut Dimension 2 Code" := DimValue2;
        end;
    */



    /*
    LOCAL procedure UpdateItemCrossRef ()
        begin
          DistIntegration.EnterPurchaseItemCrossRef(Rec);
          UpdateICPartner;
        end;
    */



    /*
    LOCAL procedure UpdateItemReference ()
        begin
          UpdateItemCrossRef;
          if Type <> Type::Item then
            exit;

          if "Cross-Reference No." = '' then
            SetVendorItemNo
          else
            VALIDATE("Vendor Item No.","Cross-Reference No.");
        end;
    */



    /*
    LOCAL procedure UpdateICPartner ()
        var
    //       ICPartner@1000 :
          ICPartner: Record 413;
    //       ItemCrossReference@1001 :
          ItemCrossReference: Record 5717;
        begin
          if PurchHeader."Send IC Document" and
             (PurchHeader."IC Direction" = PurchHeader."IC Direction"::Outgoing)
          then
            CASE Type OF
              Type::" ",Type::"Charge (Item)":
                begin
                  "IC Partner Ref. Type" := Type;
                  "IC Partner Reference" := "No.";
                end;
              Type::"G/L Account":
                begin
                  "IC Partner Ref. Type" := Type;
                  "IC Partner Reference" := GLAcc."Default IC Partner G/L Acc. No";
                end;
              Type::Item:
                begin
                  ICPartner.GET(PurchHeader."Buy-from IC Partner Code");
                  CASE ICPartner."Outbound Purch. Item No. Type" OF
                    ICPartner."Outbound Purch. Item No. Type"::"Common Item No.":
                      VALIDATE("IC Partner Ref. Type","IC Partner Ref. Type"::"Common Item No.");
                    ICPartner."Outbound Purch. Item No. Type"::"Internal No.",
                    ICPartner."Outbound Purch. Item No. Type"::"Cross Reference":
                      begin
                        if ICPartner."Outbound Purch. Item No. Type" = ICPartner."Outbound Purch. Item No. Type"::"Internal No." then
                          VALIDATE("IC Partner Ref. Type","IC Partner Ref. Type"::Item)
                        else
                          VALIDATE("IC Partner Ref. Type","IC Partner Ref. Type"::"Cross Reference");
                        ItemCrossReference.SETRANGE("Cross-Reference Type",ItemCrossReference."Cross-Reference Type"::Vendor);
                        ItemCrossReference.SETRANGE("Cross-Reference Type No.","Buy-from Vendor No.");
                        ItemCrossReference.SETRANGE("Item No.","No.");
                        ItemCrossReference.SETRANGE("Variant Code","Variant Code");
                        ItemCrossReference.SETRANGE("Unit of Measure","Unit of Measure Code");
                        if ItemCrossReference.FINDFIRST then
                          "IC Partner Reference" := ItemCrossReference."Cross-Reference No."
                        else
                          "IC Partner Reference" := "No.";
                      end;
                    ICPartner."Outbound Purch. Item No. Type"::"Vendor Item No.":
                      begin
                        "IC Partner Ref. Type" := "IC Partner Ref. Type"::"Vendor Item No.";
                        "IC Partner Reference" := "Vendor Item No.";
                      end;
                  end;
                end;
              Type::"Fixed Asset":
                begin
                  "IC Partner Ref. Type" := "IC Partner Ref. Type"::" ";
                  "IC Partner Reference" := '';
                end;
            end;
        end;
    */


    //     LOCAL procedure CalcTotalAmtToAssign (TotalQtyToAssign@1000 :

    /*
    LOCAL procedure CalcTotalAmtToAssign (TotalQtyToAssign: Decimal) TotalAmtToAssign : Decimal;
        begin
          TotalAmtToAssign := CalcLineAmount * TotalQtyToAssign / Quantity;

          if PurchHeader."Prices Including VAT" then
            TotalAmtToAssign := TotalAmtToAssign / (1 + "VAT %" / 100) - "VAT Difference";

          TotalAmtToAssign := ROUND(TotalAmtToAssign,Currency."Amount Rounding Precision");
        end;
    */




    /*
    procedure HasTypeToFillMandatoryFields () : Boolean;
        begin
          exit(Type <> Type::" ");
        end;
    */




    /*
    procedure GetDeferralAmount () DeferralAmount : Decimal;
        begin
          if "VAT Base Amount" <> 0 then
            DeferralAmount := "VAT Base Amount"
          else
            DeferralAmount := CalcLineAmount;
        end;
    */



    /*
    LOCAL procedure UpdateDeferralAmounts ()
        var
    //       DeferralPostDate@1000 :
          DeferralPostDate: Date;
    //       AdjustStartDate@1001 :
          AdjustStartDate: Boolean;
        begin
          GetPurchHeader;
          DeferralPostDate := PurchHeader."Posting Date";
          AdjustStartDate := TRUE;
          if "Document Type" = "Document Type"::"Return Order" then begin
            if "Returns Deferral Start Date" = 0D then
              "Returns Deferral Start Date" := PurchHeader."Posting Date";
            DeferralPostDate := "Returns Deferral Start Date";
            AdjustStartDate := FALSE;
          end;

          DeferralUtilities.RemoveOrSetDeferralSchedule(
            "Deferral Code",DeferralUtilities.GetPurchDeferralDocType,'','',
            "Document Type","Document No.","Line No.",
            GetDeferralAmount,DeferralPostDate,Description,PurchHeader."Currency Code",AdjustStartDate);
        end;
    */


    //     procedure ShowDeferrals (PostingDate@1000 : Date;CurrencyCode@1001 :

    /*
    procedure ShowDeferrals (PostingDate: Date;CurrencyCode: Code[10]) : Boolean;
        begin
          exit(DeferralUtilities.OpenLineScheduleEdit(
              "Deferral Code",DeferralUtilities.GetPurchDeferralDocType,'','',
              "Document Type","Document No.","Line No.",
              GetDeferralAmount,PostingDate,Description,CurrencyCode));
        end;
    */



    /*
    LOCAL procedure InitDeferralCode ()
        var
    //       Item@1000 :
          Item: Record 27;
        begin
          if "Document Type" IN
             ["Document Type"::Order,"Document Type"::Invoice,"Document Type"::"Credit Memo","Document Type"::"Return Order"]
          then
            CASE Type OF
              Type::"G/L Account":
                VALIDATE("Deferral Code",GLAcc."Default Deferral Template Code");
              Type::Item:
                begin
                  GetItem(Item);
                  VALIDATE("Deferral Code",Item."Default Deferral Template Code");
                end;
            end;
        end;
    */




    /*
    procedure DefaultDeferralCode ()
        var
    //       Item@1000 :
          Item: Record 27;
        begin
          CASE Type OF
            Type::"G/L Account":
              begin
                GLAcc.GET("No.");
                InitDeferralCode;
              end;
            Type::Item:
              begin
                GetItem(Item);
                InitDeferralCode;
              end;
          end;
        end;
    */




    /*
    procedure IsCreditDocType () : Boolean;
        begin
          exit("Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"]);
        end;
    */




    /*
    procedure IsInvoiceDocType () : Boolean;
        begin
          exit("Document Type" IN ["Document Type"::Order,"Document Type"::Invoice]);
        end;
    */



    /*
    LOCAL procedure IsReceivedFromOcr () : Boolean;
        var
    //       IncomingDocument@1002 :
          IncomingDocument: Record 130;
        begin
          GetPurchHeader;
          if not IncomingDocument.GET(PurchHeader."Incoming Document Entry No.") then
            exit(FALSE);
          exit(IncomingDocument."OCR Status" = IncomingDocument."OCR Status"::Success);
        end;
    */



    /*
    LOCAL procedure TestReturnFieldsZero ()
        begin
          TESTFIELD("Return Qty. Shipped not Invd.",0);
          TESTFIELD("Return Qty. Shipped",0);
          TESTFIELD("Return Shipment No.",'');
        end;
    */




    /*
    procedure CanEditUnitOfMeasureCode () : Boolean;
        var
    //       ItemUnitOfMeasure@1000 :
          ItemUnitOfMeasure: Record 5404;
        begin
          if (Type = Type::Item) and ("No." <> '') then begin
            ItemUnitOfMeasure.SETRANGE("Item No.","No.");
            exit(ItemUnitOfMeasure.COUNT > 1);
          end;
          exit(TRUE);
        end;
    */



    //     procedure TestItemFields (ItemNo@1000 : Code[20];VariantCode@1001 : Code[10];LocationCode@1002 :

    /*
    procedure TestItemFields (ItemNo: Code[20];VariantCode: Code[10];LocationCode: Code[10])
        begin
          TESTFIELD(Type,Type::Item);
          TESTFIELD("No.",ItemNo);
          TESTFIELD("Variant Code",VariantCode);
          TESTFIELD("Location Code",LocationCode);
        end;
    */




    /*
    procedure ClearPurchaseHeader ()
        begin
          CLEAR(PurchHeader);
        end;
    */




    /*
    procedure SendLineInvoiceDiscountResetNotification ()
        var
    //       NotificationLifecycleMgt@1003 :
          NotificationLifecycleMgt: Codeunit 1511;
    //       NotificationToSend@1000 :
          NotificationToSend: Notification;
        begin
          if ("Inv. Discount Amount" = 0) and (xRec."Inv. Discount Amount" <> 0) and ("Line Amount" <> 0) then begin
            NotificationToSend.ID := PurchHeader.GetLineInvoiceDiscountResetNotificationId;
            NotificationToSend.MESSAGE := STRSUBSTNO(LineInvoiceDiscountAmountResetTok,RECORDID);

            NotificationLifecycleMgt.SendNotification(NotificationToSend,RECORDID);
          end;
        end;
    */




    /*
    procedure FormatType () : Text[20];
        begin
          if Type = Type::" " then
            exit(CommentLbl);

          exit(FORMAT(Type));
        end;
    */



    //     procedure RenameNo (LineType@1000 : Option;OldNo@1001 : Code[20];NewNo@1002 :

    /*
    procedure RenameNo (LineType: Option;OldNo: Code[20];NewNo: Code[20])
        begin
          RESET;
          SETRANGE(Type,LineType);
          SETRANGE("No.",OldNo);
          MODIFYALL("No.",NewNo,TRUE);
        end;
    */



    /*
    LOCAL procedure UpdateLineDiscPct ()
        var
    //       LineDiscountPct@1000 :
          LineDiscountPct: Decimal;
        begin
          if ROUND(Quantity * "Direct Unit Cost",Currency."Amount Rounding Precision") <> 0 then begin
            LineDiscountPct := ROUND(
                "Line Discount Amount" / ROUND(Quantity * "Direct Unit Cost",Currency."Amount Rounding Precision") * 100,
                0.00001);
            if not (LineDiscountPct IN [0..100]) then
              ERROR(LineDiscountPctErr);
            "Line Discount %" := LineDiscountPct;
          end else
            "Line Discount %" := 0;
        end;
    */


    //     LOCAL procedure UpdateBaseAmounts (NewAmount@1000 : Decimal;NewAmountIncludingVAT@1001 : Decimal;NewVATBaseAmount@1002 :

    /*
    LOCAL procedure UpdateBaseAmounts (NewAmount: Decimal;NewAmountIncludingVAT: Decimal;NewVATBaseAmount: Decimal)
        begin
          Amount := NewAmount;
          "Amount Including VAT" := NewAmountIncludingVAT;
          "VAT Base Amount" := NewVATBaseAmount;
          if not PurchHeader."Prices Including VAT" and (Amount > 0) and (Amount < "Prepmt. Line Amount") then
            "Prepmt. Line Amount" := Amount;
          if PurchHeader."Prices Including VAT" and ("Amount Including VAT" > 0) and ("Amount Including VAT" < "Prepmt. Line Amount") then
            "Prepmt. Line Amount" := "Amount Including VAT";
        end;
    */



    /*
    LOCAL procedure UpdatePrepmtAmounts ()
        var
    //       RemLineAmountToInvoice@1001 :
          RemLineAmountToInvoice: Decimal;
        begin
          if "Prepayment %" <> 0 then begin
            if Quantity < 0 then
              FIELDERROR(Quantity,STRSUBSTNO(Text043,FIELDCAPTION("Prepayment %")));
            if "Direct Unit Cost" < 0 then
              FIELDERROR("Direct Unit Cost",STRSUBSTNO(Text043,FIELDCAPTION("Prepayment %")));
          end;
          if PurchHeader."Document Type" <> PurchHeader."Document Type"::Invoice then begin
            "Prepayment VAT Difference" := 0;
            if not PrePaymentLineAmountEntered then
              "Prepmt. Line Amount" := ROUND("Line Amount" * "Prepayment %" / 100,Currency."Amount Rounding Precision");
            if "Prepmt. Line Amount" < "Prepmt. Amt. Inv." then begin
              if IsServiceCharge then
                ERROR(CannotChangePrepaidServiceChargeErr);
              FIELDERROR("Prepmt. Line Amount",STRSUBSTNO(Text037,"Prepmt. Amt. Inv."));
            end;
            PrePaymentLineAmountEntered := FALSE;
            if "Prepmt. Line Amount" <> 0 then begin
              RemLineAmountToInvoice :=
                ROUND("Line Amount" * (Quantity - "Quantity Invoiced") / Quantity,Currency."Amount Rounding Precision");
              if RemLineAmountToInvoice < ("Prepmt. Line Amount" - "Prepmt Amt Deducted") then
                FIELDERROR("Prepmt. Line Amount",STRSUBSTNO(Text039,RemLineAmountToInvoice + "Prepmt Amt Deducted"));
            end;
          end else
            if (CurrFieldNo <> 0) and ("Line Amount" <> xRec."Line Amount") and
               ("Prepmt. Amt. Inv." <> 0) and ("Prepayment %" = 100)
            then begin
              if "Line Amount" < xRec."Line Amount" then
                FIELDERROR("Line Amount",STRSUBSTNO(Text038,xRec."Line Amount"));
              FIELDERROR("Line Amount",STRSUBSTNO(Text039,xRec."Line Amount"));
            end;
        end;
    */


    //     LOCAL procedure IsCalcVATAmountLinesHandled (PurchHeader@1001 : Record 38;var PurchLine@1002 : Record 39;var VATAmountLine@1003 :

    /*
    LOCAL procedure IsCalcVATAmountLinesHandled (PurchHeader: Record 38;var PurchLine: Record 39;var VATAmountLine: Record 290) IsHandled : Boolean;
        begin
          IsHandled := FALSE;
          OnBeforeCalcVATAmountLines(PurchHeader,PurchLine,VATAmountLine,IsHandled);
          exit(IsHandled);
        end;
    */



    //     LOCAL procedure OnAfterAssignFieldsForNo (var PurchLine@1000 : Record 39;var xPurchLine@1001 : Record 39;PurchHeader@1002 :

    /*
    LOCAL procedure OnAfterAssignFieldsForNo (var PurchLine: Record 39;var xPurchLine: Record 39;PurchHeader: Record 38)
        begin
        end;
    */



    //     LOCAL procedure OnAfterAssignHeaderValues (var PurchLine@1000 : Record 39;PurchHeader@1001 :

    /*
    LOCAL procedure OnAfterAssignHeaderValues (var PurchLine: Record 39;PurchHeader: Record 38)
        begin
        end;
    */



    //     LOCAL procedure OnAfterAssignStdTxtValues (var PurchLine@1000 : Record 39;StandardText@1001 :

    /*
    LOCAL procedure OnAfterAssignStdTxtValues (var PurchLine: Record 39;StandardText: Record 7)
        begin
        end;
    */



    //     LOCAL procedure OnAfterAssignGLAccountValues (var PurchLine@1000 : Record 39;GLAccount@1001 :

    /*
    LOCAL procedure OnAfterAssignGLAccountValues (var PurchLine: Record 39;GLAccount: Record 15)
        begin
        end;
    */



    //     LOCAL procedure OnAfterAssignItemValues (var PurchLine@1000 : Record 39;Item@1001 :

    /*
    LOCAL procedure OnAfterAssignItemValues (var PurchLine: Record 39;Item: Record 27)
        begin
        end;
    */



    //     LOCAL procedure OnAfterAssignItemChargeValues (var PurchLine@1000 : Record 39;ItemCharge@1001 :

    /*
    LOCAL procedure OnAfterAssignItemChargeValues (var PurchLine: Record 39;ItemCharge: Record 5800)
        begin
        end;
    */



    //     LOCAL procedure OnAfterAssignFixedAssetValues (var PurchLine@1000 : Record 39;FixedAsset@1001 :

    /*
    LOCAL procedure OnAfterAssignFixedAssetValues (var PurchLine: Record 39;FixedAsset: Record 5600)
        begin
        end;
    */



    //     LOCAL procedure OnAfterAssignItemUOM (var PurchLine@1000 : Record 39;Item@1001 :

    /*
    LOCAL procedure OnAfterAssignItemUOM (var PurchLine: Record 39;Item: Record 27)
        begin
        end;
    */



    //     LOCAL procedure OnAfterGetItem (var Item@1000 : Record 27;var PurchaseLine@1001 :

    /*
    LOCAL procedure OnAfterGetItem (var Item: Record 27;var PurchaseLine: Record 39)
        begin
        end;
    */



    //     LOCAL procedure OnAfterGetPurchHeader (var PurchaseLine@1000 : Record 39;var PurchaseHeader@1001 :

    /*
    LOCAL procedure OnAfterGetPurchHeader (var PurchaseLine: Record 39;var PurchaseHeader: Record 38)
        begin
        end;
    */



    //     LOCAL procedure OnAfterFilterLinesWithItemToPlan (var PurchaseLine@1000 : Record 39;var Item@1001 :

    /*
    LOCAL procedure OnAfterFilterLinesWithItemToPlan (var PurchaseLine: Record 39;var Item: Record 27)
        begin
        end;
    */



    //     LOCAL procedure OnAfterUpdateDirectUnitCost (var PurchLine@1000 : Record 39;xPurchLine@1001 : Record 39;CalledByFieldNo@1002 : Integer;CurrFieldNo@1003 :

    /*
    LOCAL procedure OnAfterUpdateDirectUnitCost (var PurchLine: Record 39;xPurchLine: Record 39;CalledByFieldNo: Integer;CurrFieldNo: Integer)
        begin
        end;
    */



    //     LOCAL procedure OnBeforeUpdateDirectUnitCost (var PurchLine@1003 : Record 39;xPurchLine@1002 : Record 39;CalledByFieldNo@1001 : Integer;CurrFieldNo@1000 : Integer;var Handled@1004 :

    /*
    LOCAL procedure OnBeforeUpdateDirectUnitCost (var PurchLine: Record 39;xPurchLine: Record 39;CalledByFieldNo: Integer;CurrFieldNo: Integer;var Handled: Boolean)
        begin
        end;
    */



    //     LOCAL procedure OnBeforeVerifyReservedQty (var PurchLine@1000 : Record 39;xPurchLine@1001 : Record 39;CalledByFieldNo@1002 :

    /*
    LOCAL procedure OnBeforeVerifyReservedQty (var PurchLine: Record 39;xPurchLine: Record 39;CalledByFieldNo: Integer)
        begin
        end;
    */



    //     LOCAL procedure OnAfterInitHeaderDefaults (var PurchLine@1000 : Record 39;PurchHeader@1001 :

    /*
    LOCAL procedure OnAfterInitHeaderDefaults (var PurchLine: Record 39;PurchHeader: Record 38)
        begin
        end;
    */



    //     LOCAL procedure OnAfterInitOutstandingQty (var PurchaseLine@1000 :

    /*
    LOCAL procedure OnAfterInitOutstandingQty (var PurchaseLine: Record 39)
        begin
        end;
    */



    //     LOCAL procedure OnAfterInitOutstandingAmount (var PurchLine@1000 : Record 39;xPurchLine@1003 : Record 39;PurchHeader@1001 : Record 38;Currency@1002 :

    /*
    LOCAL procedure OnAfterInitOutstandingAmount (var PurchLine: Record 39;xPurchLine: Record 39;PurchHeader: Record 38;Currency: Record 4)
        begin
        end;
    */



    //     LOCAL procedure OnAfterInitQtyToInvoice (var PurchLine@1000 : Record 39;CurrFieldNo@1001 :

    /*
    LOCAL procedure OnAfterInitQtyToInvoice (var PurchLine: Record 39;CurrFieldNo: Integer)
        begin
        end;
    */



    //     LOCAL procedure OnAfterInitQtyToShip (var PurchLine@1000 : Record 39;CurrFieldNo@1001 :

    /*
    LOCAL procedure OnAfterInitQtyToShip (var PurchLine: Record 39;CurrFieldNo: Integer)
        begin
        end;
    */



    //     LOCAL procedure OnAfterInitQtyToReceive (var PurchLine@1000 : Record 39;CurrFieldNo@1001 :

    /*
    LOCAL procedure OnAfterInitQtyToReceive (var PurchLine: Record 39;CurrFieldNo: Integer)
        begin
        end;
    */



    //     LOCAL procedure OnAfterSetDefaultQuantity (var PurchLine@1000 : Record 39;var xPurchLine@1001 :

    /*
    LOCAL procedure OnAfterSetDefaultQuantity (var PurchLine: Record 39;var xPurchLine: Record 39)
        begin
        end;
    */



    //     LOCAL procedure OnAfterCalcVATAmountLines (var PurchHeader@1003 : Record 38;var PurchLine@1002 : Record 39;var VATAmountLine@1001 : Record 290;QtyType@1000 :

    /*
    LOCAL procedure OnAfterCalcVATAmountLines (var PurchHeader: Record 38;var PurchLine: Record 39;var VATAmountLine: Record 290;QtyType: Option "General","Invoicing","Shippin")
        begin
        end;
    */



    //     LOCAL procedure OnAfterCreateDimTableIDs (var PurchLine@1000 : Record 39;FieldNo@1001 : Integer;var TableID@1003 : ARRAY [10] OF Integer;var No@1002 :

    /*
    LOCAL procedure OnAfterCreateDimTableIDs (var PurchLine: Record 39;FieldNo: Integer;var TableID: ARRAY [10] OF Integer;var No: ARRAY [10] OF Code[20])
        begin
        end;
    */



    //     LOCAL procedure OnAfterGetLineAmountToHandle (PurchLine@1000 : Record 39;QtyToHandle@1001 : Decimal;var LineAmount@1002 : Decimal;var LineDiscAmount@1003 :

    /*
    LOCAL procedure OnAfterGetLineAmountToHandle (PurchLine: Record 39;QtyToHandle: Decimal;var LineAmount: Decimal;var LineDiscAmount: Decimal)
        begin
        end;
    */



    //     LOCAL procedure OnAfterTestStatusOpen (var PurchaseLine@1000 : Record 39;PurchaseHeader@1001 :

    /*
    LOCAL procedure OnAfterTestStatusOpen (var PurchaseLine: Record 39;PurchaseHeader: Record 38)
        begin
        end;
    */



    //     LOCAL procedure OnAfterUpdateAmounts (var PurchLine@1000 : Record 39;var xPurchLine@1001 : Record 39;CurrFieldNo@1002 :

    /*
    LOCAL procedure OnAfterUpdateAmounts (var PurchLine: Record 39;var xPurchLine: Record 39;CurrFieldNo: Integer)
        begin
        end;
    */



    //     LOCAL procedure OnAfterUpdateAmountsDone (var PurchLine@1000 : Record 39;var xPurchLine@1001 : Record 39;CurrFieldNo@1002 :

    /*
    LOCAL procedure OnAfterUpdateAmountsDone (var PurchLine: Record 39;var xPurchLine: Record 39;CurrFieldNo: Integer)
        begin
        end;
    */



    //     LOCAL procedure OnAfterUpdateUnitCost (var PurchLine@1000 : Record 39;xPurchLine@1001 : Record 39;PurchHeader@1002 : Record 38;Item@1003 : Record 27;StockkeepingUnit@1004 : Record 5700;Currency@1005 : Record 4;GLSetup@1006 :

    /*
    LOCAL procedure OnAfterUpdateUnitCost (var PurchLine: Record 39;xPurchLine: Record 39;PurchHeader: Record 38;Item: Record 27;StockkeepingUnit: Record 5700;Currency: Record 4;GLSetup: Record 98)
        begin
        end;
    */



    //     LOCAL procedure OnAfterUpdateJobPrices (var PurchLine@1000 : Record 39;JobJnlLine@1001 : Record 210;PurchRcptLine@1002 :

    /*
    LOCAL procedure OnAfterUpdateJobPrices (var PurchLine: Record 39;JobJnlLine: Record 210;PurchRcptLine: Record 121)
        begin
        end;
    */



    //     LOCAL procedure OnAfterUpdateWithWarehouseReceive (PurchaseHeader@1000 : Record 38;var PurchaseLine@1001 :

    /*
    LOCAL procedure OnAfterUpdateWithWarehouseReceive (PurchaseHeader: Record 38;var PurchaseLine: Record 39)
        begin
        end;
    */



    //     LOCAL procedure OnAfterUpdateVATAmounts (var PurchaseLine@1000 :

    /*
    LOCAL procedure OnAfterUpdateVATAmounts (var PurchaseLine: Record 39)
        begin
        end;
    */



    //     LOCAL procedure OnAfterUpdateVATOnLines (var PurchHeader@1002 : Record 38;var PurchLine@1001 : Record 39;var VATAmountLine@1000 : Record 290;QtyType@1003 :

    /*
    LOCAL procedure OnAfterUpdateVATOnLines (var PurchHeader: Record 38;var PurchLine: Record 39;var VATAmountLine: Record 290;QtyType: Option "General","Invoicing","Shippin")
        begin
        end;
    */



    //     LOCAL procedure OnAfterUpdateTotalAmounts (var PurchaseLine@1000 : Record 39;PurchaseLine2@1001 : Record 39;var TotalAmount@1003 : Decimal;var TotalAmountInclVAT@1002 : Decimal;var TotalLineAmount@1005 : Decimal;var TotalInvDiscAmount@1004 :

    /*
    LOCAL procedure OnAfterUpdateTotalAmounts (var PurchaseLine: Record 39;PurchaseLine2: Record 39;var TotalAmount: Decimal;var TotalAmountInclVAT: Decimal;var TotalLineAmount: Decimal;var TotalInvDiscAmount: Decimal)
        begin
        end;
    */



    //     LOCAL procedure OnBeforeCopyFromItem (var PurchaseLine@1000 : Record 39;var Item@1001 :

    /*
    LOCAL procedure OnBeforeCopyFromItem (var PurchaseLine: Record 39;var Item: Record 27)
        begin
        end;
    */



    //     LOCAL procedure OnBeforeBlanketOrderLookup (var PurchaseLine@1000 : Record 39;FieldNo@1001 : Integer;var IsHandled@1002 :

    /*
    LOCAL procedure OnBeforeBlanketOrderLookup (var PurchaseLine: Record 39;FieldNo: Integer;var IsHandled: Boolean)
        begin
        end;
    */



    //     LOCAL procedure OnBeforeCalcVATAmountLines (PurchHeader@1002 : Record 38;var PurchLine@1001 : Record 39;var VATAmountLine@1000 : Record 290;var IsHandled@1003 :

    /*
    LOCAL procedure OnBeforeCalcVATAmountLines (PurchHeader: Record 38;var PurchLine: Record 39;var VATAmountLine: Record 290;var IsHandled: Boolean)
        begin
        end;
    */



    //     LOCAL procedure OnBeforeCreateTempJobJnlLine (var TempJobJournalLine@1000 : TEMPORARY Record 210;PurchaseLine@1001 : Record 39;xPurchaseLine@1002 : Record 39;GetPrices@1003 : Boolean;CallingFieldNo@1004 :

    /*
    LOCAL procedure OnBeforeCreateTempJobJnlLine (var TempJobJournalLine: Record 210 TEMPORARY;PurchaseLine: Record 39;xPurchaseLine: Record 39;GetPrices: Boolean;CallingFieldNo: Integer)
        begin
        end;
    */



    //     LOCAL procedure OnBeforeJobTaskIsSet (PurchLine@1000 : Record 39;var IsJobLine@1001 :

    /*
    LOCAL procedure OnBeforeJobTaskIsSet (PurchLine: Record 39;var IsJobLine: Boolean)
        begin
        end;
    */



    //     LOCAL procedure OnBeforeOpenItemTrackingLines (PurchaseLine@1000 : Record 39;var IsHandled@1001 :

    /*
    LOCAL procedure OnBeforeOpenItemTrackingLines (PurchaseLine: Record 39;var IsHandled: Boolean)
        begin
        end;
    */



    //     LOCAL procedure OnBeforeTestStatusOpen (var PurchaseLine@1000 : Record 39;PurchaseHeader@1001 :

    /*
    LOCAL procedure OnBeforeTestStatusOpen (var PurchaseLine: Record 39;PurchaseHeader: Record 38)
        begin
        end;
    */



    //     LOCAL procedure OnBeforeUpdateVATAmounts (var PurchaseLine@1000 :

    /*
    LOCAL procedure OnBeforeUpdateVATAmounts (var PurchaseLine: Record 39)
        begin
        end;
    */



    //     LOCAL procedure OnAfterCreateTempJobJnlLine (var JobJournalLine@1000 : Record 210;PurchLine@1001 : Record 39;xPurchLine@1002 : Record 39;GetPrices@1004 : Boolean;CurrFieldNo@1003 :

    /*
    LOCAL procedure OnAfterCreateTempJobJnlLine (var JobJournalLine: Record 210;PurchLine: Record 39;xPurchLine: Record 39;GetPrices: Boolean;CurrFieldNo: Integer)
        begin
        end;
    */



    //     LOCAL procedure OnUpdateDirectUnitCostOnBeforeFindPrice (PurchaseHeader@1000 : Record 38;var PurchaseLine@1001 : Record 39;CalledByFieldNo@1002 : Integer;FieldNo@1003 : Integer;var IsHandled@1004 :

    /*
    LOCAL procedure OnUpdateDirectUnitCostOnBeforeFindPrice (PurchaseHeader: Record 38;var PurchaseLine: Record 39;CalledByFieldNo: Integer;FieldNo: Integer;var IsHandled: Boolean)
        begin
        end;
    */



    //     LOCAL procedure OnValidateCrossReferenceNoOnBeforeAssignNo (var PurchaseLine@1000 : Record 39;var ItemCrossReference@1001 :

    /*
    LOCAL procedure OnValidateCrossReferenceNoOnBeforeAssignNo (var PurchaseLine: Record 39;var ItemCrossReference: Record 5717)
        begin
        end;
    */



    //     LOCAL procedure OnValidateTypeOnCopyFromTempPurchLine (var PurchLine@1000 : Record 39;TempPurchaseLine@1001 :

    /*
    LOCAL procedure OnValidateTypeOnCopyFromTempPurchLine (var PurchLine: Record 39;TempPurchaseLine: Record 39 TEMPORARY)
        begin
        end;
    */



    //     LOCAL procedure OnValidateNoOnCopyFromTempPurchLine (var PurchLine@1000 : Record 39;TempPurchaseLine@1001 :

    /*
    LOCAL procedure OnValidateNoOnCopyFromTempPurchLine (var PurchLine: Record 39;TempPurchaseLine: Record 39 TEMPORARY)
        begin
        end;
    */



    //     LOCAL procedure OnValidateNoOnAfterAssignQtyFromXRec (var PurchaseLine@1000 : Record 39;TempPurchaseLine@1001 :

    /*
    LOCAL procedure OnValidateNoOnAfterAssignQtyFromXRec (var PurchaseLine: Record 39;TempPurchaseLine: Record 39 TEMPORARY)
        begin
        end;
    */



    //     LOCAL procedure OnValidateNoOnAfterChecks (var PurchaseLine@1000 : Record 39;xPurchaseLine@1001 : Record 39;FieldNo@1002 :

    /*
    LOCAL procedure OnValidateNoOnAfterChecks (var PurchaseLine: Record 39;xPurchaseLine: Record 39;FieldNo: Integer)
        begin
        end;
    */



    //     LOCAL procedure OnValidateNoOnAfterVerifyChange (var PurchaseLine@1000 : Record 39;xPurchaseLine@1001 :

    /*
    LOCAL procedure OnValidateNoOnAfterVerifyChange (var PurchaseLine: Record 39;xPurchaseLine: Record 39)
        begin
        end;
    */



    //     LOCAL procedure OnValidateNoOnBeforeInitRec (var PurchaseLine@1000 : Record 39;xPurchaseLine@1001 : Record 39;FieldNo@1002 :

    /*
    LOCAL procedure OnValidateNoOnBeforeInitRec (var PurchaseLine: Record 39;xPurchaseLine: Record 39;FieldNo: Integer)
        begin
        end;
    */



    //     LOCAL procedure OnValidateQtyToReceiveOnAfterCheck (var PurchaseLine@1000 : Record 39;FieldNo@1001 :

    /*
    LOCAL procedure OnValidateQtyToReceiveOnAfterCheck (var PurchaseLine: Record 39;FieldNo: Integer)
        begin
        end;
    */



    //     LOCAL procedure OnValidateQuantityOnBeforeDropShptCheck (var PurchaseLine@1000 : Record 39;xPurchaseLine@1001 : Record 39;FieldNo@1002 : Integer;var IsHandled@1003 :

    /*
    LOCAL procedure OnValidateQuantityOnBeforeDropShptCheck (var PurchaseLine: Record 39;xPurchaseLine: Record 39;FieldNo: Integer;var IsHandled: Boolean)
        begin
        end;
    */




    /*
    procedure AssignedItemCharge () : Boolean;
        begin
          exit((Type = Type::"Charge (Item)") and ("No." <> '') and ("Qty. to Assign" < Quantity));
        end;
    */

    [IntegrationEvent(false, false)]
    local procedure OnBeforeUpdateVATAmounts2(var PurchaseLine: Record "Purchase Line"; var IsHandled: Boolean)
    begin
    end;

    /*
    procedure ShowDeferralSchedule ()
        var
    //       PurchaseHeader@1000 :
          PurchaseHeader: Record 38;
        begin
          PurchaseHeader.GET("Document Type","Document No.");
          ShowDeferrals(PurchaseHeader."Posting Date",PurchaseHeader."Currency Code");
        end;

        /*begin
        //{
    //      JAV 01/07/19: - Se a�aden los campos "Withholding Amount by G.E" y "Withholding Amount by PIT" al sumindexfields de la primera clave
    //      JAV 06/07/19: - Se a�ade el campo 7207291"Canceled" que indica si se ha cancelado la l�nea del FRI
    //      JAV 11/08/19: - Nuevos campos para el manejo de las retenciones 7207283 "not apply Withholding by G.E", 7207284 "not apply Withholding by PIT",
    //                      7207285 "Base Withholding by G.E", 7207286 "Base Withholding by PIT", 7207287 "Withholding by G.E Line"
    //                    - Se llama al recalculo de retenciones al modificar el importe de la l�nea
    //      JAV 15/09/19: - Se cambia el caption de los campos 7207270 "% Withholding by G.E", 7207271 "Withholding Amount by G.E", 7207284 "not apply Withholding by PIT" para que
    //                      indique que son para la retenci�n de PAGO.
    //      JAV 20/09/19: - Se elimina la llamada a la funci�n de recalculo de retenciones ya que se hace por eventos ahora
    //      JAV 23/10/19: - Eliminamos llamadas a eventos de Retenciones que ya no se utilizan
    //      PGM 15/10/20: - Creado el campo "QB Blanket Order No."
    //      JDC 26/02/21: - Q12879 Added field 7207320 "QB Prepayment Line"
    //      QMD 06/04/21: - Q13153 Nuevos campos para proformas "QB Qty To Proform", "QB Proform to Invoice", "QB Proformed Qty", "QB Proformed Invoice"
    //      CPA 29/03/22: - Q16867 - Mejora de rendimiento. Nuevas Claves "Document Type,Job No.,Order Date", "Document Type,Location Code,Order Date,Job No."
    //      EPV 11/05/22: - Se a�ade campo "QB Modification Date" para control.
    //      JAV 21/06/22: - DP 1.00.00 Se a�aden los campos para el manejo de la prorrata. Modificado a partir de MercaBarna DP04a, Q12228, CEI14253, Q13668, CEI14117
    //                                    7174360 "DP Apply Prorrata Type"
    //                                    7174361 "DP Prorrata %"
    //                                    7174362 "DP VAT Amount"
    //                                    7174363 "DP Deductible VAT amount"
    //                                    7174364 "DP Non Deductible VAT amount"
    //                                    7174365 "DP Deductible VAT Line"
    //      JAV 29/06/22: - QB 1.10.57 No se permite cambiar algunos campos si el documento no est� abierto
    //      JAV 14/07/22: - DP 1.00.04 Se a�aden campos para el manejo del IVA no deducible 7174366 "DP Non Deductible VAT Line" y 7174367 "DP Non Deductible VAT %"
    //      18294 CSM 10/02/23 � Incorporar en est�ndar QB.  Modificada CALCFORMULA in Field: 7207293.   New Fields:
    //                                50090Comparative Quote No.(N� comparativo)
    //                                50091Comparative Line No.(N� l�nea comparativo)
    //      OJO EN MERGE QB. --------- BS::18286 CSM 30/01/23 - Fri y proforma por l�neas de medici�n.  Nuevos campos Bonif.Sol.:
    //                                            50000 Prod. Measure Header No.      (N� Cab. Relaci�n Valorada)
    //                                            50001 Prod. Measure Header Line No. (N� l�nea Relaci�n Valorada)
    //                                            50002From Measure(Viene de la medici�n)
    //                                            50003Measure Source(Medici�n origen)
    //      PAT 07/06/23: - Q19516 Correccion de Error con campos en facturas lanzadas.
    //      BS::20484 AML 15/11/23 - Contratos para facturas libres.
    //      BS::19974 AML 21/11/23 - Creado cmpo Ajuste Manual
    //      BS::20015 AML 27/11/23 - Creado campo Cod. Actividad
    //      22117 JDC 24/04/24  - Added field 7207360 "Qty. to Segregate"
    //    }
        end.
      */
}




