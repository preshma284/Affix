table 7238729 "QBU PurchaseLineExt"
{


    CaptionML = ENU = 'Purchase Line Ext', ESP = 'Lin. Compra Ext';

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

            Description = 'QRE 1.00.00 15454';


        }
        field(3; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Document No.', ESP = 'N� documento';
            Description = 'QRE 1.00.00 15454';


        }
        field(4; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Line No.', ESP = 'N� l�nea';
            Description = 'QRE 1.00.00 15454';


        }
        field(5; "Type"; Option)
        {
            OptionMembers = " ","G/L Account","Item","Fixed Asset","Charge (Item)","Resource";

            CaptionML = ENU = 'Type', ESP = 'Tipo';
            OptionCaptionML = ENU = '" ,G/L Account,Item,,Fixed Asset,Charge (Item),,Resource"', ESP = '" ,Cuenta,Producto,,Activo fijo,Cargo (Prod.),,Recurso"';

            Description = 'QB2514';

            trigger OnValidate();
            VAR
                //                                                                 TempPurchLine@1000 :
                TempPurchLine: Record 39 TEMPORARY;
            BEGIN
            END;


        }
        field(6; "No."; Code[20])
        {

            CaptionML = ENU = 'No.', ESP = 'N�';

            trigger OnValidate();
            VAR
                //                                                                 TempPurchLine@1003 :
                TempPurchLine: Record 39 TEMPORARY;
                //                                                                 FindRecordMgt@1000 :
                FindRecordMgt: Codeunit 703;
                //                                                                 bCuentaGastos@1100254000 :
                bCuentaGastos: Boolean;
            BEGIN
            END;


        }
        field(25; "VAT %"; Decimal)
        {
            CaptionML = ENU = 'VAT %', ESP = '% IVA';
            DecimalPlaces = 0 : 5;
            Editable = false;


        }
        field(26; "Buy-from Vendor No."; Code[20])
        {
            TableRelation = "Vendor";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Buy-from Vendor No.', ESP = 'Compra a-N� proveedor';
            Editable = false;


        }
        field(480; "Dimension Set ID"; Integer)
        {
            TableRelation = "Dimension Set Entry";
            CaptionML = ENU = 'Dimension Set ID', ESP = 'Id. grupo dimensiones';
            Editable = false;


        }
        field(7238178; "QB_Transaction Type"; Option)
        {
            OptionMembers = " ","Pendiente de formalizar","Pre-contrato","Contrato","Cobros aplazados","Escriturada","Reformas","Consumos","Renuncia","Atípicas","Cancelación","Venta","Devoluciones","Entregada","Modificación de cobros","Contrato + Escrituras","Renuncia + Traspaso","Deshacer","Reserva alq.","Contrato alq.","Traspaso alq.","Deshacer reserva alq.","Liquidar alq.","Facturar alq.","Renovar rta. alq.","Renovar contrato alq.","Deshacer alq.","Contrato OC","Liquidar alq. OC","Pase Resultado","Depósito fianzas","Recuperación fianzas","Devolución fianzas","Registro fianzas","Mod. fecha entrega llaves","Disposiciones","Canc. hipotecarias","Amortización","Cesion derechos","Baja","Carencia";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Tipo operaci�n';
            OptionCaptionML = ENU = '" ,Pending formalisation,Pre-contract,Contract,Deferred collections,Notarised,Reforms,Consumption,Waiver,Atypical,Cancellation,Sale,Returns,Delivered,Modification of contracts,Contract + Deeds,Waiver + Transfer,Undo,Rental reservation,Rental Contracto,Transfer rental,Undo rental resevation,Settle rent,Invoice rent,Update rental income,Update rental contract,Undo rent,Option to buy contract,Settle option to buy rent,Move to Results,Pay in deposits,Recover deposits,Return deposits,Register deposits,Modify key delivery date,Disposals,Cancel mortgages,Redemption,Transfer of rights,Carencia"', ESP = '" ,Pendiente de formalizar,Pre-contrato,Contrato,Cobros aplazados,Escriturada,Reformas,Consumos,Renuncia,At�picas,Cancelaci�n,Venta,Devoluciones,Entregada,Modificaci�n de cobros,Contrato + Escrituras,Renuncia + Traspaso,Deshacer,Reserva alq.,Contrato alq.,Traspaso alq.,Deshacer reserva alq.,Liquidar alq.,Facturar alq.,Renovar rta. alq.,Renovar contrato alq.,Deshacer alq.,Contrato OC,Liquidar alq. OC,Pase Resultado,Dep�sito fianzas,Recuperaci�n fianzas,Devoluci�n fianzas,Registro fianzas,Mod. fecha entrega llaves,Disposiciones,Canc. hipotecarias,Amortizaci�n,Cesion derechos,,,Baja,Carencia"';

            Description = 'QRE 1.00.00 15449';


        }
        field(7238179; "QB_Classif Code 1"; Code[20])
        {
            TableRelation = "Proyectos inmobiliarios"."No.";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'C�d Clasif1';
            Description = 'QRE 1.00.00 15449';


        }
        field(7238180; "QB_Classif Code 2"; Code[20])
        {
            TableRelation = "Clasificación Clasif 2"."Código";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'C�d Clasif2';
            Description = 'QRE 1.00.00 15449';


        }
        field(7238181; "QB_Due Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Fecha de vencimiento';
            Description = 'QRE 1.00.00 15449';


        }
        field(7238182; "QB_Post-delivery collection"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Cobro post entrega';
            Description = 'QRE 1.00.00 15449';


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


    //     procedure Read (PurchaseLine@1100286000 :
    procedure Read(PurchaseLine: Record 39): Boolean;
    begin
        //Busca un registro, si no existe lo inicializa, retorna encontrado o no
        Rec.RESET;
        Rec.SETRANGE("Record Id", PurchaseLine.RECORDID);
        if not Rec.FINDFIRST then begin
            Rec.INIT;
            Rec."Record Id" := PurchaseLine.RECORDID;
            /*To Be Tested*/
            // Rec."Document Type" := PurchaseLine."Document Type";
            Rec."Document Type" := ConvertDocumentTypeToOption(PurchaseLine."Document Type");
            Rec."Document No." := PurchaseLine."Document No.";
            Rec."Line No." := PurchaseLine."Line No.";
            /*To Be Tested*/
            // Rec.Type := PurchaseLine.Type;
            Rec.Type := ConvertTypeToOption(PurchaseLine.Type);
            Rec."No." := PurchaseLine."No.";
            Rec."VAT %" := PurchaseLine."VAT %";
            Rec."Buy-from Vendor No." := PurchaseLine."Buy-from Vendor No.";
            Rec."Dimension Set ID" := PurchaseLine."Dimension Set ID";
            exit(FALSE);
        end;
        exit(TRUE)
    end;

    //Added method to handle enum type to option
    procedure ConvertTypeToOption(DocumentType: Enum "Purchase Line Type"): Option;
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
    procedure ConvertDocumentTypeToOption(DocumentType: Enum "Purchase Document Type"): Option;
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

    /*begin
    end.
  */
}







