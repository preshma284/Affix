table 7206912 "Contracts Control"
{


    LookupPageID = "Contracts Control List";
    DrillDownPageID = "Contracts Control List";

    fields
    {
        field(1; "Linea"; Integer)
        {


            DataClassification = ToBeClassified;

            trigger OnValidate();
            BEGIN
                IF (Linea = 0) THEN BEGIN
                    ControlContratos.RESET;
                    IF (ControlContratos.FINDLAST) THEN
                        Linea := ControlContratos.Linea + 1
                    ELSE
                        Linea := 1;
                END;
            END;


        }
        field(10; "Proyecto"; Code[20])
        {
            TableRelation = "Job";
            DataClassification = ToBeClassified;


        }
        field(11; "Tipo Movimiento"; Option)
        {
            OptionMembers = "IniProyecto","IniGrupo","Movimiento","TotGrupo","TotProyecto";
            DataClassification = ToBeClassified;
            OptionCaptionML = ESP = 'Inicio Proyecto,Inicio Contrato/Proveedor,Movimiento,Total Contrato/Proveedor,Total Proyecto';



        }
        field(12; "Contrato"; Code[20])
        {
            TableRelation = "Purchase Header"."No." WHERE("Document Type" = CONST("Order"));


            DataClassification = ToBeClassified;

            trigger OnValidate();
            BEGIN
                IF PurchaseHeader.GET(PurchaseHeader."Document Type"::Order, Contrato) THEN
                    Proveedor := PurchaseHeader."Buy-from Vendor No.";
            END;


        }
        field(13; "Proveedor"; Code[20])
        {
            TableRelation = "Vendor";
            DataClassification = ToBeClassified;


        }
        field(14; "User"; Code[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Usuario';


        }
        field(15; "Orden1"; Text[30])
        {


            DataClassification = ToBeClassified;
            Description = 'Q18495';

            trigger OnValidate();
            VAR
                //                                                                 c1@1100286000 :
                c1: Text;
                //                                                                 c2@1100286001 :
                c2: Text;
                //                                                                 c3@1100286002 :
                c3: Text;
                //                                                                 c4@1100286003 :
                c4: Text;
                //                                                                 c5@1100286004 :
                c5: Text;
            BEGIN
                CASE "Tipo Movimiento" OF
                    "Tipo Movimiento"::IniProyecto:
                        BEGIN
                            Orden1 := 'A0';
                            Orden2 := '';
                        END;
                    "Tipo Movimiento"::IniGrupo:
                        BEGIN
                            IF (Contrato <> '') THEN BEGIN
                                // Q18495 (EPV) 21/12/22
                                //Orden1 := 'C1'
                                //Orden2 := Contrato;
                                Orden1 := 'C-' + Contrato;
                                Orden2 := 'A';
                                //-->
                            END ELSE BEGIN
                                // Q18495 (EPV) 09/01/23
                                //Orden1 := 'P1';
                                //Orden2 := Proveedor;
                                Orden1 := 'P-' + Proveedor;
                                Orden2 := 'A';
                                //-->

                            END;
                        END;
                    "Tipo Movimiento"::Movimiento:
                        BEGIN
                            IF (Contrato <> '') THEN BEGIN
                                // Q18495 (EPV) 21/12/22
                                //Orden1 := 'C2';
                                //Orden2 := Contrato;
                                Orden1 := 'C-' + Contrato;
                                Orden2 := 'B';
                                //-->
                            END ELSE BEGIN
                                // Q18495 (EPV) 09/01/23
                                //Orden1 := 'P2';
                                //Orden2 := Proveedor;
                                Orden1 := 'P-' + Proveedor;
                                Orden2 := 'B';
                                //-->

                            END;
                        END;
                    "Tipo Movimiento"::TotGrupo:
                        BEGIN
                            IF (Contrato <> '') THEN BEGIN
                                // Q18495 (EPV) 21/12/22
                                //Orden1 := 'C3';
                                //Orden2 := Contrato;
                                Orden1 := 'C-' + Contrato;
                                Orden2 := 'C';
                                //-->
                            END ELSE BEGIN
                                // Q18495 (EPV) 09/01/23
                                //Orden1 := 'P3';
                                //Orden2 := Proveedor;
                                Orden1 := 'P-' + Proveedor;
                                Orden2 := 'C';
                                //-->

                            END;
                        END;
                    "Tipo Movimiento"::TotProyecto:
                        BEGIN
                            Orden1 := 'Z9';
                            Orden2 := '';
                        END;
                END;
            END;


        }
        field(16; "Orden2"; Text[20])
        {


            DataClassification = ToBeClassified;

            trigger OnValidate();
            VAR
                //                                                                 c1@1100286000 :
                c1: Text;
                //                                                                 c2@1100286001 :
                c2: Text;
                //                                                                 c3@1100286002 :
                c3: Text;
                //                                                                 c4@1100286003 :
                c4: Text;
                //                                                                 c5@1100286004 :
                c5: Text;
            BEGIN
            END;


        }
        field(17; "Origen"; Option)
        {
            OptionMembers = "Contrato","Proveedor","Totales";

            DataClassification = ToBeClassified;
            OptionCaptionML = ESP = 'Contrato,Proveedor,Totales';


            trigger OnValidate();
            BEGIN
                IF ("Linea de Totales") THEN
                    Origen := Origen::Totales
                ELSE IF (Contrato <> '') THEN
                    Origen := Origen::Contrato
                ELSE
                    Origen := Origen::Proveedor;
            END;


        }
        field(18; "Vendor for Search"; Code[20])
        {


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Vendor para b�squedas';
            Description = 'Si es un contrato debe estar en blanco, si no ser� el proveedor de la l�nea';

            trigger OnValidate();
            BEGIN
                IF (Contrato <> '') THEN
                    "Vendor for Search" := ''
                ELSE
                    "Vendor for Search" := Proveedor;
            END;


        }
        field(19; "Linea de Totales"; Boolean)
        {
            DataClassification = ToBeClassified;


        }
        field(20; "Tipo Documento"; Option)
        {
            OptionMembers = " ","Order","Invoice","Credit Memo","Ampliacion","Manual","MaxPro","Albaran","ARcontrato","Anulación albarán";
            DataClassification = ToBeClassified;
            OptionCaptionML = ENU = '" ,Contrato,Factura,Abono,Ampliaci�n en Factura,Manual,M�ximo Proveedor,Albar�n,Ampliar/Reducir contrato,,,,,,,,Anulación albarán"', ESP = '" ,Contrato,Factura,Abono,Ampliaci�n en Factura,Manual,M�ximo Proveedor,Albar�n,Ampliar/Reducir contrato,,,,,,,,Anulaci�n albar�n"';



        }
        field(21; "No. Documento"; Code[20])
        {
            DataClassification = ToBeClassified;


        }
        field(22; "Fecha"; Date)
        {
            DataClassification = ToBeClassified;


        }
        field(23; "Extension No."; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'N� Ampliaci�n';


        }
        field(30; "Importe Contrato"; Decimal)
        {
            DataClassification = ToBeClassified;


        }
        field(31; "Importe Maximo"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Importe M�ximo';


        }
        field(32; "Importe Albaran"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Importe FRI/Albar�n';


        }
        field(33; "Importe Factura/abono"; Decimal)
        {
            DataClassification = ToBeClassified;


        }
        field(34; "Importe Ampliaciones"; Decimal)
        {
            DataClassification = ToBeClassified;


        }
        field(35; "Importe Pendiente"; Decimal)
        {


            DataClassification = ToBeClassified;

            trigger OnValidate();
            BEGIN
                "Importe Maximo" := 0;
                IF NOT "Linea de Totales" THEN BEGIN
                    IF ("Tipo Documento" = "Tipo Documento"::Order) THEN
                        "Importe Maximo" := ImporteMaximoContrato("Importe Contrato")
                    ELSE IF ("Tipo Documento" = "Tipo Documento"::ARcontrato) THEN
                        "Importe Maximo" := "Importe Contrato"
                    ELSE IF (Contrato = '') OR NOT PurchaseHeader.GET(PurchaseHeader."Document Type"::Order, Contrato) THEN BEGIN
                        AddMaximoProveedor;
                    END;
                END;

                "Importe Pendiente" := "Importe Maximo" - "Importe Factura/abono" + "Importe Ampliaciones"
            END;


        }
        field(40; "Suma Importe Contrato"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Contracts Control"."Importe Contrato" WHERE("Proyecto" = FIELD("Proyecto"),
                                                                                                                 "Contrato" = FIELD("Contrato"),
                                                                                                                 "Vendor for Search" = FIELD("Vendor for Search"),
                                                                                                                 "Linea de Totales" = CONST(false)));


        }
        field(41; "Suma Importe Maximo"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Contracts Control"."Importe Maximo" WHERE("Proyecto" = FIELD("Proyecto"),
                                                                                                               "Contrato" = FIELD("Contrato"),
                                                                                                               "Vendor for Search" = FIELD("Vendor for Search"),
                                                                                                               "Linea de Totales" = CONST(false)));


        }
        field(42; "Suma Importe Albaran"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Contracts Control"."Importe Albaran" WHERE("Proyecto" = FIELD("Proyecto"),
                                                                                                                "Contrato" = FIELD("Contrato"),
                                                                                                                "Vendor for Search" = FIELD("Vendor for Search"),
                                                                                                                "Linea de Totales" = CONST(false)));
            CaptionML = ESP = 'Suma Importe FRI/Albar�n';


        }
        field(43; "Suma Importe Factura/abono"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Contracts Control"."Importe Factura/abono" WHERE("Proyecto" = FIELD("Proyecto"),
                                                                                                                      "Contrato" = FIELD("Contrato"),
                                                                                                                      "Vendor for Search" = FIELD("Vendor for Search"),
                                                                                                                      "Linea de Totales" = CONST(false)));


        }
        field(44; "Suma Importe Ampliaciones"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Contracts Control"."Importe Ampliaciones" WHERE("Proyecto" = FIELD("Proyecto"),
                                                                                                                     "Contrato" = FIELD("Contrato"),
                                                                                                                     "Vendor for Search" = FIELD("Vendor for Search"),
                                                                                                                     "Linea de Totales" = CONST(false)));


        }
        field(45; "Suma Importe Pendiente"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Contracts Control"."Importe Pendiente" WHERE("Proyecto" = FIELD("Proyecto"),
                                                                                                                  "Contrato" = FIELD("Contrato"),
                                                                                                                  "Vendor for Search" = FIELD("Vendor for Search"),
                                                                                                                  "Linea de Totales" = CONST(false)));


        }
        field(50; "Total Importe Contrato"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Contracts Control"."Importe Contrato" WHERE("Proyecto" = FIELD("Proyecto"),
                                                                                                                 "Linea de Totales" = CONST(false)));


        }
        field(51; "Total Importe Maximo"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Contracts Control"."Importe Maximo" WHERE("Proyecto" = FIELD("Proyecto"),
                                                                                                               "Linea de Totales" = CONST(false)));


        }
        field(52; "Total Importe Albaran"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Contracts Control"."Importe Albaran" WHERE("Proyecto" = FIELD("Proyecto"),
                                                                                                                "Linea de Totales" = CONST(false)));
            CaptionML = ESP = 'Total Importe FRI/Albar�n';


        }
        field(53; "Total Importe Factura/abono"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Contracts Control"."Importe Factura/abono" WHERE("Proyecto" = FIELD("Proyecto"),
                                                                                                                      "Linea de Totales" = CONST(false)));


        }
        field(54; "Total Importe Ampliaciones"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Contracts Control"."Importe Ampliaciones" WHERE("Proyecto" = FIELD("Proyecto"),
                                                                                                                     "Linea de Totales" = CONST(false)));


        }
        field(55; "Total Importe Pendiente"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Contracts Control"."Importe Pendiente" WHERE("Proyecto" = FIELD("Proyecto"),
                                                                                                                  "Linea de Totales" = CONST(false)));


        }
    }
    keys
    {
        key(key1; "Linea")
        {
            Clustered = true;
        }
        key(key2; "Proyecto", "Orden1", "Orden2", "Linea")
        {
        }
    }
    fieldgroups
    {
    }

    var
        //       ControlContratos@1100286000 :
        ControlContratos: Record 7206912;
        //       QuoBuildingSetup@1100286001 :
        QuoBuildingSetup: Record 7207278;
        //       PurchaseHeader@1100286002 :
        PurchaseHeader: Record 38;



    trigger OnInsert();
    begin
        User := USERID;

        VALIDATE(Linea);
        VALIDATE(Orden1);
        VALIDATE(Origen);
        VALIDATE("Vendor for Search");
        VALIDATE("Importe Pendiente");
        AddMaximos;
    end;

    trigger OnModify();
    begin
        VALIDATE(Orden1);
    end;

    trigger OnDelete();
    begin
        DeleteMaximo;
    end;



    // LOCAL procedure ImporteMaximoContrato (var parImporte@7001102 :
    LOCAL procedure ImporteMaximoContrato(var parImporte: Decimal): Decimal;
    begin
        //Calcula el importe m�ximo aplicable para un contrato
        QuoBuildingSetup.GET();
        exit(parImporte + ROUND(parImporte * QuoBuildingSetup.k / 100, 0.01) + QuoBuildingSetup."Contratos Importe");
    end;

    LOCAL procedure ImporteMaximoProveedor(): Decimal;
    begin
        //Calcula el importe m�ximo aplicable para un proveedor
        QuoBuildingSetup.GET();
        exit(QuoBuildingSetup."Sin Contrato Importe");
    end;

    LOCAL procedure AddMaximos()
    var
        //       ControlContratos@1100286001 :
        ControlContratos: Record 7206912;
        //       QuoBuildingSetup@1100286005 :
        QuoBuildingSetup: Record 7207278;
        //       nLinea@1100286003 :
        nLinea: Integer;
    begin
        QuoBuildingSetup.GET();
        nLinea := Linea;

        //Crear inicio del grupo
        ControlContratos.RESET;
        ControlContratos.SETRANGE(Proyecto, Rec.Proyecto);
        ControlContratos.SETRANGE("Tipo Movimiento", ControlContratos."Tipo Movimiento"::IniGrupo);
        if (Contrato <> '') then begin
            ControlContratos.SETRANGE(Contrato, Rec.Contrato);
        end else begin
            ControlContratos.SETFILTER(Contrato, '');
            ControlContratos.SETRANGE(Proveedor, Rec.Proveedor);
        end;
        if not ControlContratos.FINDFIRST then begin
            nLinea := nLinea + 1;
            ControlContratos.INIT;
            ControlContratos.Linea := nLinea;
            ControlContratos.Proyecto := Rec.Proyecto;
            ControlContratos."Tipo Movimiento" := ControlContratos."Tipo Movimiento"::IniGrupo;
            if (Contrato <> '') then begin
                ControlContratos.Contrato := Rec.Contrato;
                ControlContratos.Proveedor := Rec.Proveedor;
            end else begin
                ControlContratos.Proveedor := Rec.Proveedor;
            end;
            ControlContratos."Linea de Totales" := TRUE;
            ControlContratos.Origen := ControlContratos.Origen::Totales;
            ControlContratos.VALIDATE(Orden1);
            ControlContratos.VALIDATE("Vendor for Search");
            ControlContratos.INSERT(FALSE);
        end;

        //Crear totales del grupo
        ControlContratos.RESET;
        ControlContratos.SETRANGE(Proyecto, Rec.Proyecto);
        ControlContratos.SETRANGE("Tipo Movimiento", ControlContratos."Tipo Movimiento"::TotGrupo);
        if (Contrato <> '') then begin
            ControlContratos.SETRANGE(Contrato, Rec.Contrato);
        end else begin
            ControlContratos.SETFILTER(Contrato, '');
            ControlContratos.SETRANGE(Proveedor, Rec.Proveedor);
        end;
        if not ControlContratos.FINDFIRST then begin
            nLinea += 1;
            ControlContratos.INIT;
            ControlContratos.Linea := nLinea;
            ControlContratos.Proyecto := Rec.Proyecto;
            ControlContratos."Tipo Movimiento" := ControlContratos."Tipo Movimiento"::TotGrupo;
            ControlContratos."Linea de Totales" := TRUE;
            ControlContratos.Origen := ControlContratos.Origen::Totales;
            if (Contrato <> '') then begin
                ControlContratos.Contrato := Rec.Contrato;
                ControlContratos.Proveedor := Rec.Proveedor;
            end else begin
                ControlContratos.Proveedor := Rec.Proveedor;
            end;
            ControlContratos.VALIDATE(Orden1);
            ControlContratos.VALIDATE("Vendor for Search");
            ControlContratos.INSERT(FALSE);
        end;

        //Crear inicio y fin del proyecto
        ControlContratos.RESET;
        ControlContratos.SETRANGE(Proyecto, Rec.Proyecto);
        ControlContratos.SETRANGE("Tipo Movimiento", ControlContratos."Tipo Movimiento"::IniProyecto);
        if not ControlContratos.FINDFIRST then begin
            nLinea := nLinea + 1;
            ControlContratos.INIT;
            ControlContratos.Linea := nLinea;
            ControlContratos.Proyecto := Rec.Proyecto;
            ControlContratos."Tipo Movimiento" := ControlContratos."Tipo Movimiento"::IniProyecto;
            ControlContratos."Linea de Totales" := TRUE;
            ControlContratos.VALIDATE(Origen);
            ControlContratos.VALIDATE(Orden1);
            ControlContratos.VALIDATE("Vendor for Search");
            ControlContratos.INSERT(FALSE);
        end;

        ControlContratos.RESET;
        ControlContratos.SETRANGE(Proyecto, Rec.Proyecto);
        ControlContratos.SETRANGE("Tipo Movimiento", ControlContratos."Tipo Movimiento"::TotProyecto);
        if not ControlContratos.FINDFIRST then begin
            nLinea := nLinea + 1;
            ControlContratos.INIT;
            ControlContratos.Linea := nLinea;
            ControlContratos.Proyecto := Rec.Proyecto;
            ControlContratos."Tipo Movimiento" := ControlContratos."Tipo Movimiento"::TotProyecto;
            ControlContratos."Linea de Totales" := TRUE;
            ControlContratos.VALIDATE(Origen);
            ControlContratos.VALIDATE(Orden1);
            ControlContratos.VALIDATE("Vendor for Search");
            ControlContratos.INSERT(FALSE);
        end;
    end;

    procedure AddMaximoProveedor()
    begin
        QuoBuildingSetup.GET();

        if (Linea = 0) then begin
            ControlContratos.RESET;
            if ControlContratos.FINDLAST then
                Linea := ControlContratos.Linea
            else
                Linea := 1;
        end;

        ControlContratos.RESET;
        ControlContratos.SETRANGE(Proyecto, Proyecto);
        ControlContratos.SETFILTER(Contrato, '');
        ControlContratos.SETRANGE(Proveedor, Proveedor);
        ControlContratos.SETRANGE("Tipo Documento", "Tipo Documento"::MaxPro);
        ControlContratos.SETFILTER("Importe Maximo", '<>0');
        if not ControlContratos.FINDFIRST then begin
            ControlContratos.INIT;
            ControlContratos.Linea := Linea;
            ControlContratos.Proyecto := Rec.Proyecto;
            ControlContratos."Tipo Movimiento" := ControlContratos."Tipo Movimiento"::Movimiento;
            ControlContratos.Proveedor := Proveedor;
            ControlContratos."Tipo Documento" := ControlContratos."Tipo Documento"::MaxPro;
            ControlContratos."Importe Maximo" := ImporteMaximoProveedor;
            ControlContratos."Importe Pendiente" := ControlContratos."Importe Maximo";
            ControlContratos.VALIDATE(Origen);
            ControlContratos.VALIDATE(Orden1);
            ControlContratos.VALIDATE("Vendor for Search");
            ControlContratos.INSERT(FALSE);

            Linea += 1;
        end;
    end;

    LOCAL procedure DeleteMaximo()
    var
        //       ControlContratos@1100286003 :
        ControlContratos: Record 7206912;
    begin
        //Borrar la l�nea de totales
        ControlContratos.RESET;
        ControlContratos.SETFILTER(Linea, '<>%1', Linea);
        ControlContratos.SETRANGE(Proyecto, Rec.Proyecto);
        if (Contrato <> '') then begin
            ControlContratos.SETRANGE(Contrato, Rec.Contrato);
            if (ControlContratos.COUNT = 2) then
                ControlContratos.DELETEALL;
        end else begin
            ControlContratos.SETFILTER(Contrato, '');
            ControlContratos.SETRANGE(Proveedor, Rec.Proveedor);
            if (ControlContratos.COUNT = 3) then
                ControlContratos.DELETEALL;
        end;

        //Borrar inicio y fin del proyecto
        ControlContratos.RESET;
        ControlContratos.SETFILTER(Linea, '<>%1', Linea);
        ControlContratos.SETRANGE(Proyecto, Rec.Proyecto);
        if (ControlContratos.COUNT = 2) then
            ControlContratos.DELETEALL;
    end;

    /*begin
    //{
//      Q18495 (EPV) 21/12/22 - Error en la ordenaci�n debido a los valores de Orden 1 y Orden 2.
//        Se amplia el tama�o del campo "Orden 1" a 30 caracteres
//      Q20392 AML A�adido tipo documento Anulacion Albaran
//    }
    end.
  */
}







