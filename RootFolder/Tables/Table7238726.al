table 7238726 "QB_SalesHeaderExt" //7238726

{


    ;
    fields
    {
        field(1; "Record Id"; RecordID)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Id. Registro';


        }
        field(2; "Document Type"; Option)//field type to Enum
        {
            OptionMembers = "Quote","Order","Invoice","Credit Memo","Blanket Order","Return Order";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Document Type', ESP = 'Tipo documento';
            OptionCaptionML = ENU = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order', ESP = 'Oferta,Pedido,Factura,Abono,Pedido abierto,Devoluci�n';

            Description = 'TAB36 QRE 1.00.00 15454';


        }
        field(3; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'No.', ESP = 'N�';
            Description = 'TAB36 QRE 1.00.00 15454';


        }
        field(7238178; "QB_Transaction Type"; Option)
        {
            OptionMembers = " ","Pendiente de formalizar","Pre-contrato","Contrato","Cobros aplazados","Escriturada","Reformas","Consumos","Renuncia","Atípicas","Cancelación","Venta","Devoluciones","Entregada","Modificación de contratos","Contrato + Escrituras","Renuncia + Traspaso","Deshacer","Reserva alq.","Contrato alq.","Traspaso alq.","Deshacer reserva alq.","Liquidar alq.","Facturar alq.","Renovar rta. alq.","Renovar contrato alq.","Deshacer alq.","Contrato OC","Liquidar alq. OC","Pase Resultado","Depósito fianzas","Recuperación fianzas","Devolución fianzas","Registro fianzas","Mod. fecha entrega llaves","Disposiciones","Canc. hipotecarias","Amortización","Cesion derechos","Provisión","Modificación de precontratos";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Tipo operaci�n';
            OptionCaptionML = ESP = '" ,Pendiente de formalizar,Pre-contrato,Contrato,Cobros aplazados,Escriturada,Reformas,Consumos,Renuncia,At�picas,Cancelaci�n,Venta,Devoluciones,Entregada,Modificaci�n de contratos,Contrato + Escrituras,Renuncia + Traspaso,Deshacer,Reserva alq.,Contrato alq.,Traspaso alq.,Deshacer reserva alq.,Liquidar alq.,Facturar alq.,Renovar rta. alq.,Renovar contrato alq.,Deshacer alq.,Contrato OC,Liquidar alq. OC,Pase Resultado,Dep�sito fianzas,Recuperaci�n fianzas,Devoluci�n fianzas,Registro fianzas,Mod. fecha entrega llaves,Disposiciones,Canc. hipotecarias,Amortizaci�n,Cesion derechos,Provisi�n,Modificaci�n de precontratos"';

            Description = 'TAB36 QRE 1.00.00 15454';


        }
        field(7238179; "QB_Classif Code 1"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'C�d Clasif1';
            Description = 'TAB36 QRE 1.00.00 15454';


        }
        field(7238249; "Sell-to Customer No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'TAB36 QRE 1.00.00 15454. Necesario para table relation de campo Operaci�n de Venta/alquiler';


        }
        field(7238250; "QB_Sales unit"; Code[30])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Unidad de venta';
            Description = 'TAB36 QRE 1.00.00 15454';


        }
        field(7238265; "Cod Clasif2"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Classif Code 2', ESP = 'C�d Clasif2';
            Description = 'TAB36 QRE 1.00.00 15454';


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


    //     procedure Read (SalesHeader@1100286000 :
    procedure Read(SalesHeader: Record 36): Boolean;
    begin
        //Busca un registro, si no existe lo inicializa, retorna encontrado o no
        Rec.RESET;
        Rec.SETRANGE("Record Id", SalesHeader.RECORDID);
        if not Rec.FINDFIRST then begin
            Rec.INIT;
            Rec."Record Id" := SalesHeader.RECORDID;
            //verified the order in enum
            Rec."Document Type" := SalesHeader."Document Type".AsInteger();
            Rec."No." := SalesHeader."No.";
            exit(FALSE);
        end;
        exit(TRUE)
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







