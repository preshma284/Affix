table 7238727 "QBU SalesLineExt"
{


    ;
    fields
    {
        field(1; "Record Id"; RecordID)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Id. Registro';


        }
        field(2; "Document Type"; Option)
        {
            OptionMembers = "Quote","Order","Invoice","Credit Memo","Blanket Order","Return Order";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Document Type', ESP = 'Tipo documento';
            OptionCaptionML = ENU = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order', ESP = 'Oferta,Pedido,Factura,Abono,Pedido abierto,Devoluci�n';



        }
        field(3; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Document No.', ESP = 'N� documento';


        }
        field(4; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Line No.', ESP = 'N� l�nea';


        }
        field(5; "Type"; Option)
        {
            OptionMembers = " ","G/L Account","Item","Resource","Fixed Asset","Charge (Item)";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Type', ESP = 'Tipo';
            OptionCaptionML = ENU = '" ,G/L Account,Item,Resource,Fixed Asset,Charge (Item)"', ESP = '" ,Cuenta,Producto,Recurso,Activo fijo,Cargo (prod.)"';



        }
        field(6; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'No.', ESP = 'N�';


        }
        field(25; "VAT %"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'VAT %', ESP = '% IVA';
            DecimalPlaces = 0 : 5;
            Editable = false;


        }
        field(26; "Sell-to Customer No."; Code[20])
        {
            TableRelation = "Customer";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Sell-to Customer No.', ESP = 'Venta a-N� cliente';
            Editable = false;


        }
        field(45; "Job No."; Code[20])
        {
            TableRelation = "Job";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Job No.', ESP = 'N� proyecto';


        }
        field(480; "Dimension Set ID"; Integer)
        {
            TableRelation = "Dimension Set Entry";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Dimension Set ID', ESP = 'Id. grupo dimensiones';
            Editable = false;


        }
        field(7238181; "Cod concepto reforma"; Code[10])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Reform item code', ESP = 'C�d concepto reforma';
            Description = 'QRE 1.00.00 15454';


        }
        field(7238182; "Concept Type"; Option)
        {
            OptionMembers = " ","Concept","Item","Fixed Asset","Charge (Item)";

            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Type', ESP = 'Tipo';
            OptionCaptionML = ENU = '" ,Concept,Item,,Fixed Asset,Charge (Item)"', ESP = '" ,Concepto,Producto,,Activo fijo,Cargo (Prod.)"';

            Description = 'QRE 1.00.00 15454';

            trigger OnValidate();
            VAR
                //                                                                 RecCabCompra@1000000000 :
                RecCabCompra: Record 38;
            BEGIN
                GetTableNo();
                IF "Table No." = DATABASE::"Sales Line" THEN BEGIN
                    GetSalesHeader();
                    SalesLine.VALIDATE(Type, "Concept Type");
                    SalesLine.MODIFY();
                END;
            END;


        }
        field(7238183; "Concept No."; Code[20])
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'No.', ESP = 'N�';
            Description = 'QRE 1.00.00 15454';

            trigger OnValidate();
            BEGIN
                //SHE.DRF.20/20
                // IF "Con20p/ Type" <> "Concept Type"::Concept THEN
                //  VALIDATE("No.","Concept No.")
                // ELSE BEGIN 
                //  SalesHeader.GET("Document Type","Document No.");
                //  Cust2.GET(SalesHeader."Bill-to Customer No.");
                //  IF NOT Cust2."Cliente Interco" THEN BEGIN 
                //    Concepto.GET("Concept No.");
                //    VALIDATE("No.",Concepto."Account No. Sale");
                //    Description := Concepto.Descripción;
                //    "Description 2" := '';
                //  END
                //  ELSE BEGIN 
                //    Empresa.SETRANGE(Empresa."No. Interco",Cust2."No. Interco");
                //    Empresa.FIND('-');
                //    EmpresaOrigen.GET(COMPANYNAME);
                //    ConceptoPorEmpresa.GET(EmpresaOrigen."No. Interco",Empresa."No. Interco","Concept No.");
                //    VALIDATE("No.",ConceptoPorEmpresa."Cuenta Venta");
                //    Concepto.GET("Concept No.");
                //    Description := Concepto.Descripción;
                //    "Description 2" := '';
                //  END;
                // END;
            END;


        }
        field(7238184; "Impto. cantidad"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Impto. cantidad';
            DecimalPlaces = 3 : 3;
            Description = 'QRE 1.00.00 15454';


        }
        field(7238185; "Descuento por cantidad"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Line Discount %', ESP = 'Descuento por cantidad';
            DecimalPlaces = 3 : 3;
            MinValue = 0;
            Description = 'QRE 1.00.00 15454';
            AutoFormatType = 2;

            trigger OnValidate();
            BEGIN
                //-006
                GetTableNo();
                IF "Table No." = DATABASE::"Sales Line" THEN BEGIN
                    GetSalesHeader();

                    CASE "Descuento por cantidad" OF
                        0:
                            BEGIN
                                IF SalesLine."Line Discount %" = 0 THEN BEGIN
                                    SalesLine."Line Discount Amount" :=
                                        ROUND(
                                          ROUND(SalesLine."Qty. to Invoice" * "Descuento por cantidad", Currency."Amount Rounding Precision"));
                                    SalesLine."Inv. Discount Amount" := 0;
                                    SalesLine."Inv. Disc. Amount to Invoice" := 0;
                                    SalesLine."Pmt. Discount Amount" := 0;
                                END;
                            END;
                        ELSE BEGIN
                            SalesLine.VALIDATE("Line Discount %", 0);
                            SalesLine."Line Discount Amount" :=
                              ROUND(
                                ROUND(SalesLine."Qty. to Invoice" * "Descuento por cantidad", Currency."Amount Rounding Precision"));
                            SalesLine."Inv. Discount Amount" := 0;
                            SalesLine."Inv. Disc. Amount to Invoice" := 0;
                            SalesLine."Pmt. Discount Amount" := 0;
                        END;
                    END;
                END;

                SalesLine.UpdateAmounts;
                //+006
            END;


        }
        field(7238187; "QB_Transaction Type"; Option)
        {
            OptionMembers = " ","Pendiente de formalizar","Pre-contrato","Contrato","Cobros aplazados","Escriturada","Reformas","Consumos","Renuncia","Atípicas","Cancelación","Venta","Devoluciones","Entregada","Modificación de cobros","Contrato + Escrituras","Renuncia + Traspaso","Deshacer","Reserva alq.","Contrato alq.","Traspaso alq.","Deshacer reserva alq.","Liquidar alq.","Facturar alq.","Renovar rta. alq.","Renovar contrato alq.","Deshacer alq.","Contrato OC","Liquidar alq. OC","Pase Resultado","Depósito fianzas","Recuperación fianzas","Devolución fianzas","Registro fianzas","Mod. fecha entrega llaves","Disposiciones","Canc. hipotecarias","Amortización","Cesion derechos","Baja","Carencia";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Tipo operación';
            OptionCaptionML = ENU = '" ,Pending formalisation,Pre-contract,Contract,Deferred collections,Notarised,Reforms,Consumption,Waiver,Atypical,Cancellation,Sale,Returns,Delivered,Modification of contracts,Contract + Deeds,Waiver + Transfer,Undo,Rental reservation,Rental Contracto,Transfer rental,Undo rental resevation,Settle rent,Invoice rent,Update rental income,Update rental contract,Undo rent,Option to buy contract,Settle option to buy rent,Move to Results,Pay in deposits,Recover deposits,Return deposits,Register deposits,Modify key delivery date,Disposals,Cancel mortgages,Redemption,Transfer of rights,Carencia"', ESP = '" ,Pendiente de formalizar,Pre-contrato,Contrato,Cobros aplazados,Escriturada,Reformas,Consumos,Renuncia,At�picas,Cancelaci�n,Venta,Devoluciones,Entregada,Modificaci�n de cobros,Contrato + Escrituras,Renuncia + Traspaso,Deshacer,Reserva alq.,Contrato alq.,Traspaso alq.,Deshacer reserva alq.,Liquidar alq.,Facturar alq.,Renovar rta. alq.,Renovar contrato alq.,Deshacer alq.,Contrato OC,Liquidar alq. OC,Pase Resultado,Dep�sito fianzas,Recuperaci�n fianzas,Devoluci�n fianzas,Registro fianzas,Mod. fecha entrega llaves,Disposiciones,Canc. hipotecarias,Amortizaci�n,Cesion derechos,,,Baja,Carencia"';

            Description = 'QRE 1.00.00 15449';


        }
        field(7238188; "QB_Classif Code 1"; Code[20])
        {
            TableRelation = "Proyectos inmobiliarios"."No.";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'C�d Clasif1';
            Description = 'QRE 1.00.00 15449';


        }
        field(7238189; "QB_Classif Code 2"; Code[20])
        {
            TableRelation = "Clasificación Clasif 2"."Código";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'C�d Clasif2';
            Description = 'QRE 1.00.00 15449';


        }
        field(7238190; "QB_Due Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Fecha de vencimiento';
            Description = 'QRE 1.00.00 15449';


        }
        field(7238191; "QB_Post-delivery collection"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Cobro post entrega';
            Description = 'QRE 1.00.00 15449';


        }
        field(7238192; "QB_Sales Unit"; Code[30])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Unidad de venta';
            Description = 'QRE 1.00.00 15449';


        }
        field(7238194; "QB_Renta"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Rent', ESP = 'Renta';
            Description = 'QRE 1.00.00 15454';


        }
        field(7238195; "QB_Tipo concepto fact. alq."; Option)
        {
            OptionMembers = " ","Renta","Concepto","Gasto","Contrato","Opción compra","Suministro";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Renting invoice item type', ESP = 'Tipo concepto fact. alq.';
            OptionCaptionML = ENU = '" ,Rent,Item,Expense,Contract,Purchase Option"', ESP = '" ,Renta,Concepto,Gasto,Contrato,Opci�n compra,Suministro"';

            Description = 'QRE 1.00.00 15454';


        }
        field(7238196; "Viene de Construccion"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Viene de Construcci�n';
            Description = 'QRE 1.00.00 15452';


        }
        field(7238197; "Mov. Certificacion"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Mov. Certificaci�n';
            Description = 'QRE 1.00.00 15452';


        }
        field(7238198; "No. Mov. Certificacion"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'N� Mov. Certificaci�n';
            Description = 'QRE 1.00.00 15452';


        }
        field(7238199; "Cod. Obra Certificacion"; Code[10])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'C�d. Obra Certificaci�n';
            Description = 'QRE 1.00.00 15452';


        }
        field(7238200; "Cod. Elemento Padre Cert"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'C�d. Elemento Padre Cert';
            Description = 'QRE 1.00.00 15452';


        }
        field(7238201; "Cod. Elemento Hijo Cert"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'C�d. Elemento Hijo Cert';
            Description = 'QRE 1.00.00 15452';


        }
    }
    keys
    {
        key(key1; "Record Id")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       SalesLine@1100286005 :
        SalesLine: Record 37;
        //       rID@1100286004 :
        rID: RecordID;
        //       SalesHeader@1100286003 :
        SalesHeader: Record 36;
        //       Currency@1100286002 :
        Currency: Record 4;
        //       "Table No."@1100286000 :
        "Table No.": Integer;

    //     procedure Read (SalesLine@1100286000 :
    procedure Read(SalesLine: Record 37): Boolean;
    begin
        //Busca un registro, si no existe lo inicializa, retorna encontrado o no
        Rec.RESET;
        Rec.SETRANGE("Record Id", SalesLine.RECORDID);
        if not Rec.FINDFIRST then begin
            Rec.INIT;
            Rec."Record Id" := SalesLine.RECORDID;
            /*To be Tested*/
            //Rec."Document Type" := SalesLine."Document Type";
            Rec."Document Type" := ConvertDocumentTypeToOption(SalesLine."Document Type");
            Rec."Document No." := SalesLine."Document No.";
            Rec."Line No." := SalesLine."Line No.";
            /*To be Tested*/
            //Rec."Document Type" := SalesLine.Type;
            Rec.Type := ConvertTypeToOption(SalesLine.Type);
            Rec."No." := SalesLine."No.";
            Rec."VAT %" := SalesLine."VAT %";
            Rec."Sell-to Customer No." := SalesLine."Sell-to Customer No.";
            Rec."Job No." := SalesLine."Job No.";
            Rec."Dimension Set ID" := SalesLine."Dimension Set ID";

            exit(FALSE);
        end;
        exit(TRUE)
    end;

    //Added method to handle enum type to option
    procedure ConvertTypeToOption(DocumentType: Enum "Sales Line Type"): Option;
    var
        optionValue: Option " ","G/L Account","Item","Resource","Fixed Asset","Charge (Item)","Allocation Account";
    begin
        case DocumentType of
            DocumentType::" ":
                optionValue := optionValue::" ";
            DocumentType::"G/L Account":
                optionValue := optionValue::"G/L Account";
            DocumentType::"Item":
                optionValue := optionValue::"Item";
            DocumentType::"Resource":
                optionValue := optionValue::"Resource";
            DocumentType::"Fixed Asset":
                optionValue := optionValue::"Fixed Asset";
            DocumentType::"Charge (Item)":
                optionValue := optionValue::"Charge (Item)";
            DocumentType::"Allocation Account":
                optionValue := optionValue::"Allocation Account";
            else
                Error('Invalid Document Type: %1', DocumentType);
        end;

        exit(optionValue);
    end;
    //Added method to handle enum type to option
    procedure ConvertDocumentTypeToOption(DocumentType: Enum "Sales Document Type"): Option;
    var
        optionValue: Option "Quote","Order","Invoice","Credit Memo","Blanket Order","Return Order";
    begin
        case DocumentType of
            DocumentType::"Quote":
                optionValue := optionValue::"Quote";
            DocumentType::"Order":
                optionValue := optionValue::"Order";
            DocumentType::"Invoice":
                optionValue := optionValue::"Invoice";
            DocumentType::"Credit Memo":
                optionValue := optionValue::"Credit Memo";
            DocumentType::"Blanket Order":
                optionValue := optionValue::"Blanket Order";
            DocumentType::"Return Order":
                optionValue := optionValue::"Return Order";
            else
                Error('Invalid Document Type: %1', DocumentType);
        end;

        exit(optionValue);
    end;

    procedure Save()
    begin
        //Guarda el registro
        if not Rec.MODIFY then
            Rec.INSERT(TRUE);
    end;

    LOCAL procedure GetTableNo()
    begin
        rID := Rec."Record Id";
        "Table No." := rID.TABLENO;
    end;

    LOCAL procedure GetSalesLine()
    var
        //       rRef@1100286002 :
        rRef: RecordRef;
    begin
        SalesLine.RESET();
        rRef.OPEN(DATABASE::"Sales Line");
        rRef := rID.GETRECORD();
        rRef.FINDFIRST();
        rRef.SETTABLE(SalesLine);
    end;

    LOCAL procedure GetSalesHeader()
    begin
        SalesHeader.GET(SalesLine."Document Type", SalesLine."Document No.");
        if SalesHeader."Currency Code" = '' then
            Currency.InitRoundingPrecision
        else begin
            SalesHeader.TESTFIELD("Currency Factor");
            Currency.GET(SalesHeader."Currency Code");
            Currency.TESTFIELD("Amount Rounding Precision");
        end;
        SalesHeader.TESTFIELD(Status, SalesHeader.Status::Open);
    end;

    /*begin
    end.
  */
}







