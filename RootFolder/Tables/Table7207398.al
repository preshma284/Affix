table 7207398 "QB Bill of Item Data Red"
{


    CaptionML = ENU = 'Separate data', ESP = 'Datos de descompuesto';
    LookupPageID = "Subform. Bill of Item Data Pro";
    DrillDownPageID = "Subform. Bill of Item Data Pro";

    fields
    {
        field(1; "Cod. Piecework"; Code[20])
        {
            TableRelation = "Piecework"."No.";
            CaptionML = ENU = 'Cod. Piecework', ESP = 'Cod. unidad de obra';
            Description = 'Key 2';
            Editable = false;


        }
        field(2; "Type"; Option)
        {
            OptionMembers = "Account","Resource","Resource Group","Item","Posting U.","Percentage";
            CaptionML = ENU = 'Cost Type', ESP = 'Tipo L�nea';
            OptionCaptionML = ENU = 'Account,Resource,Resource Group,Item,Posting U.,Percentage', ESP = 'Cuenta,Recurso,Familia,Producto,U. Auxiliar,Porcentual';

            Description = 'Key 5';


        }
        field(3; "No."; Code[20])
        {
            TableRelation = IF ("Type" = CONST("Account")) "G/L Account" ELSE IF ("Type" = CONST("Resource")) "Resource" ELSE IF ("Type" = CONST("Resource Group")) "Resource Group" ELSE IF ("Type" = CONST("Item")) "Item";


            CaptionML = ENU = 'Code', ESP = 'C�digo';
            Description = 'Key 6';

            trigger OnValidate();
            BEGIN
                CASE Type OF
                    Type::Resource:
                        BEGIN
                            Resource.GET("No.");
                            IF NOT ResourceCost.GET(ResourceCost.Type::Resource, "No.", '') THEN BEGIN
                                CLEAR(ResourceCost);
                                ResourceCost."Direct Unit Cost" := Resource."Direct Unit Cost";
                                ResourceCost."Unit Cost" := Resource."Unit Cost";
                                IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 1 THEN
                                    ResourceCost."C.A. Direct Cost Allocation" := Resource."Global Dimension 1 Code";
                                IF FunctionQB.GetPosDimensions(FunctionQB.ReturnDimCA) = 2 THEN
                                    ResourceCost."C.A. Direct Cost Allocation" := Resource."Global Dimension 2 Code";
                                ResourceCost."C.A. Indirect Cost Allocation" := Resource."Cod. C.A. Indirect Costs";
                            END;
                            VALIDATE("Direct Unit Cost", ResourceCost."Direct Unit Cost");
                            VALIDATE("Unit Cost Indirect", ResourceCost."Unit Cost" - ResourceCost."Direct Unit Cost");
                            VALIDATE("Units of Measure", Resource."Base Unit of Measure");
                            VALIDATE("Concep. Analytical Direct Cost", ResourceCost."C.A. Direct Cost Allocation");
                            VALIDATE("Concep. Anal. Indirect Cost", ResourceCost."C.A. Indirect Cost Allocation");
                            //JMMA 090221 Descripci�n
                            Description := COPYSTR(Resource.Name, 1, MAXSTRLEN(Description));
                        END;
                    Type::Item:
                        BEGIN
                            Item.GET("No.");
                            InventoryPostingSetup.SETRANGE("Location Code", '');
                            InventoryPostingSetup.SETRANGE("Invt. Posting Group Code", Item."Inventory Posting Group");
                            IF InventoryPostingSetup.FINDFIRST THEN
                                "Concep. Analytical Direct Cost" := InventoryPostingSetup."Analytic Concept";
                            VALIDATE("Direct Unit Cost", Item."Unit Cost");
                            VALIDATE("Units of Measure", Item."Base Unit of Measure");
                            //JMMA 090221 Descripci�n
                            Description := COPYSTR(Item.Description, 1, MAXSTRLEN(Description));
                        END;
                    Type::"Resource Group":
                        BEGIN
                            IF CostFamily.GET(CostFamily.Type::All, "No.", '') THEN BEGIN
                                VALIDATE("Direct Unit Cost", CostFamily."Direct Unit Cost");
                                VALIDATE("Concep. Analytical Direct Cost", CostFamily."C.A. Direct Cost Allocation");
                                VALIDATE("Unit Cost Indirect", CostFamily."Unit Cost" - CostFamily."Direct Unit Cost");
                                VALIDATE("Concep. Anal. Indirect Cost", CostFamily."C.A. Indirect Cost Allocation");
                            END;
                        END;
                END;
            END;


        }
        field(4; "Concep. Analytical Direct Cost"; Code[20])
        {
            TableRelation = "Dimension Value"."Code";


            CaptionML = ENU = 'Concep. Analytical Direct Cost', ESP = 'Concep. anal�tico coste directo';

            trigger OnValidate();
            BEGIN
                FunctionQB.ValidateCA("Concep. Analytical Direct Cost");
            END;

            trigger OnLookup();
            BEGIN
                FunctionQB.LookUpCA("Concep. Analytical Direct Cost", FALSE);
            END;


        }
        field(5; "Quantity By"; Decimal)
        {


            CaptionML = ENU = 'Quantity By', ESP = 'Rendimiento';
            DecimalPlaces = 0 : 6;

            trigger OnValidate();
            BEGIN
                ActCostJU;
                VALIDATE("Total Qty");
                VALIDATE("Total Cost");
            END;


        }
        field(6; "Units of Measure"; Code[10])
        {
            TableRelation = "Unit of Measure";
            CaptionML = ENU = 'Units of Measure', ESP = 'Unidad de medida';


        }
        field(7; "Direct Unit Cost"; Decimal)
        {


            CaptionML = ENU = 'Direct Unit Cost', ESP = 'Coste unitario directo';
            DecimalPlaces = 2 : 6;
            AutoFormatType = 2;

            trigger OnValidate();
            BEGIN
                ActCostJU;
                VALIDATE("Total Cost");

                CostDatabase.GET(Rec."Cod. Cost database");
                CASE Rec.Use OF
                    Rec.Use::Cost:
                        decAux1 := CostDatabase."CI Cost";
                    Rec.Use::Sales:
                        decAux1 := CostDatabase."CI Sales";
                END;

                //JAV 04/12/22: - QB 1.12.24 Calculamos el precio base en funci�n del precio de coste directo
                IF (decAux1 = 0) THEN
                    Rec."Base Unit Cost" := Rec."Direct Unit Cost"
                ELSE
                    Rec."Base Unit Cost" := ROUND((Rec."Direct Unit Cost" * 100) / (decAux1 + 100), CostDatabase.GetPrecision(4));
            END;


        }
        field(8; "Piecework Cost"; Decimal)
        {
            CaptionML = ENU = 'Piecework Cost', ESP = 'Coste por unidad de obra';
            DecimalPlaces = 2 : 6;


        }
        field(9; "Cod. Cost database"; Code[20])
        {
            TableRelation = "Cost Database";
            CaptionML = ENU = 'Cod. Cost database', ESP = 'Cod. preciario';
            Description = 'Key 1';
            Editable = false;


        }
        field(10; "Position"; Integer)
        {
            CaptionML = ENU = 'Position', ESP = 'Posici�n';


        }
        field(11; "Bill of Item Units"; Decimal)
        {


            CaptionML = ENU = 'Bill of Item Units', ESP = 'Factor';
            DecimalPlaces = 2 : 12;

            trigger OnValidate();
            BEGIN
                ActCostJU;
                VALIDATE("Total Qty");
                VALIDATE("Total Cost");
            END;


        }
        field(12; "Concep. Anal. Indirect Cost"; Code[20])
        {
            TableRelation = "Dimension Value"."Code";


            CaptionML = ENU = 'Concep. Anal. Indirect Cost', ESP = 'Concep. anal. coste indirecto';

            trigger OnValidate();
            BEGIN
                FunctionQB.ValidateCA("Concep. Anal. Indirect Cost");
            END;

            trigger OnLookup();
            BEGIN
                FunctionQB.LookUpCA("Concep. Anal. Indirect Cost", FALSE);
            END;


        }
        field(13; "Unit Cost Indirect"; Decimal)
        {


            CaptionML = ENU = 'Unit Cost Indirect', ESP = 'Coste unitario indirecto';
            AutoFormatType = 2;

            trigger OnValidate();
            BEGIN
                ActCostJU;
            END;


        }
        field(14; "Base Unit Cost"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Direct Unit Cost', ESP = 'Coste unitario Base sin CI';
            DecimalPlaces = 2 : 6;
            Description = 'QB 1.12.24 JAV 04/12/22: Precio base sin el coeficiente de CI';
            AutoFormatType = 2;

            trigger OnValidate();
            BEGIN
                //JAV 04/12/22: - QB 1.12.24 Calculamos el precio de coste directo en funci�n del precio base y actualziamos los datos

                CostDatabase.GET(Rec."Cod. Cost database");
                CASE Rec.Use OF
                    Rec.Use::Cost:
                        decAux1 := CostDatabase."CI Cost";
                    Rec.Use::Sales:
                        decAux1 := CostDatabase."CI Sales";
                END;

                IF (decAux1 = 0) THEN
                    decAux2 := Rec."Base Unit Cost"
                ELSE
                    decAux2 := ROUND(Rec."Base Unit Cost" * (decAux1 + 100) / 100, CostDatabase.GetPrecision(4));

                IF (Rec."Direct Unit Cost" <> decAux2) THEN BEGIN
                    Rec."Direct Unit Cost" := decAux2;
                    ActCostJU;
                    VALIDATE("Total Cost");
                END;
            END;


        }
        field(15; "Received from Percentajes"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Recibido de Porcentuales';
            Description = 'QB 1.12.24 JAV 25/11/22: Importe que hemos recibido de los porcentuales';

            trigger OnValidate();
            BEGIN
                VALIDATE(Rec."Total Cost");
            END;


        }
        field(16; "Total Qty"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Cantidad Total';
            DecimalPlaces = 2 : 6;
            Description = 'QB 1.12.24 JAV 21/11/22: Cantidad total necesaria (cantidad * cantidad del padre)';
            Editable = false;

            trigger OnValidate();
            BEGIN
                ActQty();
                //validate("Total Cost");
            END;


        }
        field(17; "Total Price"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Precio Total';
            DecimalPlaces = 2 : 6;
            Description = 'QB 1.12.24 JAV 21/11/22: Precio medio final (Coste Total / Cantidad Total)';
            Editable = false;


        }
        field(18; "Total Cost"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Coste Total';
            DecimalPlaces = 2 : 6;
            Description = 'QB 1.12.24 JAV 21/11/22: Coste Total [(Cantidad total * Coste unitario directo) + Recibido de indirectos]';
            Editable = false;

            trigger OnValidate();
            BEGIN
                //JAV 21/11/22: QB 1.12.24 Calcula el importe total de la l�nea
                CostDatabase.GET(Rec."Cod. Cost database");
                Rec."Total Cost" := ROUND(ROUND(Rec."Direct Unit Cost" * Rec."Total Qty", CostDatabase.GetPrecision(5)) + Rec."Received from Percentajes", CostDatabase.GetPrecision(5));
                IF (Rec."Total Qty" = 0) THEN
                    Rec."Total Price" := 0
                ELSE
                    Rec."Total Price" := ROUND(Rec."Total Cost" / Rec."Total Qty", CostDatabase.GetPrecision(4));
                IF NOT Rec.MODIFY(FALSE) THEN;

                IF (Rec."Father Code" <> '') THEN
                    ActCost(Rec."Father Code");
                ActUO;
            END;


        }
        field(19; "Reduce No."; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'N� de la reducci�n';
            Description = 'QB 1.12.24 JAV 10/12/22: C�digo de la reducci�n';


        }
        field(20; "Description"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Description', ESP = 'Descripci�n';


        }
        field(21; "Has Additional Text"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("QB Text" WHERE("Table" = CONST("Preciario"),
                                                                                      "Key1" = FIELD("Cod. Cost database"),
                                                                                      "Key2" = FIELD("Cod. Piecework"),
                                                                                      "Key3" = FIELD("No.")));


            CaptionML = ESP = 'Tiene Texto Adicional';
            Description = 'QB 1.02';
            Editable = false;

            trigger OnLookup();
            VAR
                //                                                               QBText@1100286001 :
                QBText: Record 7206918;
                //                                                               QBTextCard@1100286000 :
                QBTextCard: Page 7206929;
            BEGIN
                IF NOT QBText.GET(QBText.Table::Preciario, "Cod. Cost database", "Cod. Piecework", "No.") THEN BEGIN
                    QBText.InsertSalesText('', QBText.Table::Preciario, "Cod. Cost database", "Cod. Piecework", "No.");
                    COMMIT;
                END;
                CLEAR(QBTextCard);
                QBTextCard.SETRECORD(QBText);
                QBTextCard.RUNMODAL;
                CALCFIELDS("Has Additional Text");
            END;


        }
        field(22; "Description 2"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Descripci�n 2';


        }
        field(32; "Use"; Option)
        {
            OptionMembers = "Cost","Sales";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Uso';
            OptionCaptionML = ENU = 'Cost,Sales', ESP = 'Coste,Venta';

            Description = 'Key 4, QB 1.06.07 - JAV 24/07/20: - Si se usa en coste o en venta';


        }
        field(40; "Order No."; Code[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'N� Orden';
            Description = 'Key 3, QB 1.12.24 JAV 21/11/22: Orden de presentaci�n en la pantalla, para que coincida con el del BC3. Se a�ade a la clave maestra para que se ordenen igual que se han recibido';


        }
        field(41; "Presto Code"; Code[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'C�digo Presto';
            Description = 'QB 1.12.24 JAV 21/11/22: C�digo que ten�a en el BC3';


        }
        field(42; "Identation"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Indentaci�n';
            Description = 'QB 1.12.24 JAV 21/11/22: Nivel de indentaci�n de la unidad';


        }
        field(43; "Father Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'C�digo del padre';
            Description = 'QB 1.12.24 JAV 21/11/22: C�digo de la unidad padre de esta';


        }
        field(66; "Received Price"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Precio Recibido';
            Description = 'QB 1.12.24 JAV 25/11/22: Precio que hemos recibido en el BC3';


        }
    }
    keys
    {
    }
    fieldgroups
    {
    }

    var
        //       CostDatabase@1100286002 :
        CostDatabase: Record 7207271;
        //       InventoryPostingSetup@60000 :
        InventoryPostingSetup: Record 5813;
        //       Resource@60001 :
        Resource: Record 156;
        //       Item@60002 :
        Item: Record 27;
        //       ResourceCost@60003 :
        ResourceCost: Record 202;
        //       FunctionQB@60005 :
        FunctionQB: Codeunit 7207272;
        //       CostFamily@60007 :
        CostFamily: Record 202;
        //       BillofItemData@1100286000 :
        BillofItemData: Record 7207384;
        //       BillofItemDataFather@1100286001 :
        BillofItemDataFather: Record 7207384;
        //       decAux1@1100286003 :
        decAux1: Decimal;
        //       decAux2@1100286004 :
        decAux2: Decimal;

    procedure ActCostJU()
    begin
        CostDatabase.GET(Rec."Cod. Cost database");
        "Piecework Cost" := ROUND(("Direct Unit Cost" * "Quantity By" * "Bill of Item Units") + ("Unit Cost Indirect" * "Quantity By" * "Bill of Item Units"),
                                  CostDatabase.GetPrecision(5));
    end;

    procedure ActQty()
    begin
        //JAV 21/11/22: QB 1.12.24 Buscar la cantidad total a partir de su unidad padre y actualizo cantidad e importe total
        CostDatabase.GET(Rec."Cod. Cost database");

        //Calcular datos de la l�nea seg�n el sistema usado, el anterior o el nuevo
        if (Rec."Order No." = '') then begin
            Rec."Total Qty" := Rec."Bill of Item Units" * Rec."Quantity By";                                 //Cantidad de la l�nea al no tener padre
            Rec."Total Cost" := ROUND(Rec."Direct Unit Cost" * Rec."Total Qty" * Rec."Bill of Item Units", CostDatabase.GetPrecision(5));
            if not Rec.MODIFY(FALSE) then;
        end else begin
            BillofItemData.RESET;
            BillofItemData.SETRANGE("Cod. Cost database", Rec."Cod. Cost database");
            BillofItemData.SETRANGE("Cod. Piecework", Rec."Cod. Piecework");
            BillofItemData.SETRANGE(Use, Rec.Use);
            BillofItemData.SETRANGE("Order No.", Rec."Father Code");
            if (BillofItemData.FINDFIRST) then
                Rec."Total Qty" := BillofItemData."Total Qty" * Rec."Bill of Item Units" * Rec."Quantity By"     //Cantidad del padre por cantidad de la l�nea
            else
                Rec."Total Qty" := Rec."Bill of Item Units" * Rec."Quantity By";                                 //Cantidad de la l�nea al no tener padre

            Rec."Total Cost" := ROUND(Rec."Direct Unit Cost" * Rec."Total Qty" * Rec."Bill of Item Units", CostDatabase.GetPrecision(5));
            if not Rec.MODIFY(FALSE) then;

            //Bajo a las unidades inferiores
            BillofItemData.RESET;
            BillofItemData.SETRANGE("Cod. Cost database", Rec."Cod. Cost database");
            BillofItemData.SETRANGE("Cod. Piecework", Rec."Cod. Piecework");
            BillofItemData.SETRANGE(Use, Rec.Use);
            BillofItemData.SETRANGE("Father Code", Rec."Order No.");
            if (BillofItemData.FINDSET(TRUE)) then
                repeat
                    BillofItemData.ActQty();
                until (BillofItemData.NEXT = 0);
        end;
    end;

    //     procedure ActCost (pCode@1100286000 :
    procedure ActCost(pCode: Code[20])
    var
        //       Piecework@1100286002 :
        Piecework: Record 7207277;
        //       Price@1100286001 :
        Price: Decimal;
        //       Base@1100286003 :
        Base: Decimal;
    begin
        //JAV 21/11/22: QB 1.12.24 Calcula el importe total de una unidad de obra, a partir de las unidades inferiores
        CostDatabase.GET(Rec."Cod. Cost database");

        Base := 0;
        Price := 0;
        BillofItemData.RESET;
        BillofItemData.SETRANGE("Cod. Cost database", Rec."Cod. Cost database");
        BillofItemData.SETRANGE("Cod. Piecework", Rec."Cod. Piecework");
        BillofItemData.SETRANGE(Use, Rec.Use);
        BillofItemData.SETRANGE("Father Code", pCode);
        if (BillofItemData.FINDSET(TRUE)) then begin
            repeat
                Base += ROUND(BillofItemData."Base Unit Cost" * BillofItemData."Quantity By" * BillofItemData."Bill of Item Units", CostDatabase.GetPrecision(5));
                ;
                Price += BillofItemData."Piecework Cost";
            until (BillofItemData.NEXT = 0);

            BillofItemDataFather.RESET;
            BillofItemDataFather.SETRANGE("Cod. Cost database", Rec."Cod. Cost database");
            BillofItemDataFather.SETRANGE("Cod. Piecework", Rec."Cod. Piecework");
            BillofItemDataFather.SETRANGE("Order No.", pCode);
            BillofItemDataFather.SETRANGE(Use, Rec.Use);
            BillofItemDataFather.FINDFIRST;

            BillofItemDataFather."Base Unit Cost" := ROUND(Base, CostDatabase.GetPrecision(4));
            BillofItemDataFather."Direct Unit Cost" := ROUND(Price, CostDatabase.GetPrecision(4));
            BillofItemDataFather.ActCostJU();
            BillofItemDataFather."Total Cost" := ROUND(BillofItemDataFather."Direct Unit Cost" * BillofItemDataFather."Total Qty" * BillofItemDataFather."Bill of Item Units", CostDatabase.GetPrecision(4));
            BillofItemDataFather.MODIFY(FALSE);

            if (BillofItemDataFather."Father Code" <> '') and (BillofItemDataFather."Father Code" <> pCode) then
                ActCost(BillofItemDataFather."Father Code")
            else begin
                Piecework.GET(Rec."Cod. Cost database", BillofItemDataFather."Cod. Piecework");
                Piecework.CalculateUnit();
                Piecework.MODIFY(FALSE);
            end;
        end;
    end;

    procedure ActUO()
    var
        //       Piecework@1100286002 :
        Piecework: Record 7207277;
        //       i@1100286001 :
        i: Integer;
    begin
        //JAV 24/11/22: QB 1.12.24 Actualiza el importe de la partida y de los cap�tulos
        if (Rec.MODIFY(FALSE)) then begin    // Guardar el dato para el c�lculo siguiente
            Piecework.GET(Rec."Cod. Cost database", Rec."Cod. Piecework");
            Piecework.CalculateLine();
        end;
    end;

    /*begin
    //{
//      JAV 28/11/22: - QB 1.12.24 Mejoras en las carga de los BC3. Se a�aden los campos 40 a 45 y el 66. Se a�ade el campo 40 como tercer campo de la clave
//
//      IMPORTANTE: Esta tabla tiene una gemela en la 7207384, esta se usa para guardar datos en las agrupaciones, si se cambia algo en esta hay que hacerlo en la complementaria
//    }
    end.
  */
}







