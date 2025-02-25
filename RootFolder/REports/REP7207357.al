report 7207357 "Quote Request Report"
{


    CaptionML = ENU = 'Quote Request Report', ESP = 'Solicitud de precios a proveedores';

    dataset
    {

        DataItem("Vendor Conditions Data"; "Vendor Conditions Data")
        {

            DataItemTableView = SORTING("Quote Code", "Vendor No.", "Contact No.", "Version No.");
            ;
            Column(Referencia; refReferencia)
            {
                //SourceExpr=refReferencia;
            }
            Column(Clave_CodOferta; "Vendor Conditions Data"."Quote Code")
            {
                //SourceExpr="Vendor Conditions Data"."Quote Code";
            }
            Column(Clave_Proveedor; "Vendor Conditions Data"."Vendor No.")
            {
                //SourceExpr="Vendor Conditions Data"."Vendor No.";
            }
            Column(Clave_Contacto; "Vendor Conditions Data"."Contact No.")
            {
                //SourceExpr="Vendor Conditions Data"."Contact No.";
            }
            Column(Proyecto; ComparativeQuoteLines."Job No.")
            {
                //SourceExpr=ComparativeQuoteLines."Job No.";
            }
            Column(VendAddr_1; VendAddr[1])
            {
                //SourceExpr=VendAddr[1];
            }
            Column(VendAddr_2; VendAddr[2])
            {
                //SourceExpr=VendAddr[2];
            }
            Column(VendAddr_3; VendAddr[3])
            {
                //SourceExpr=VendAddr[3];
            }
            Column(VendAddr_4; VendAddr[4])
            {
                //SourceExpr=VendAddr[4];
            }
            Column(VendAddr_5; VendAddr[5])
            {
                //SourceExpr=VendAddr[5];
            }
            Column(VendAddr_6; VendAddr[6])
            {
                //SourceExpr=VendAddr[6];
            }
            Column(VendAddr_7; VendAddr[7])
            {
                //SourceExpr=VendAddr[7];
            }
            Column(VendAddr_8; VendAddr[8])
            {
                //SourceExpr=VendAddr[8];
            }
            Column(VendAddr_9; VendAddr[9])
            {
                //SourceExpr=VendAddr[9];
            }
            Column(InfoEmpresaPicture; CompanyInformation.Picture)
            {
                //SourceExpr=CompanyInformation.Picture;
            }
            Column(boolAgrupar; opcGroup)
            {
                //SourceExpr=opcGroup;
            }
            Column(boolDescUO; opcDescriptions = opcDescriptions::"De la l¡nea")
            {
                //SourceExpr=opcDescriptions = opcDescriptions::"De la l¡nea";
            }
            Column(booDescrLargas; opcDescriptionsLong)
            {
                //SourceExpr=opcDescriptionsLong;
            }
            Column(nombreResponsable; nombreResponsable)
            {
                //SourceExpr=nombreResponsable;
            }
            Column(RazonSocial; RazonSocial)
            {
                //SourceExpr=RazonSocial;
            }
            Column(Contacto; Contacto)
            {
                //SourceExpr=Contacto;
            }
            Column(Telefono; Telefono)
            {
                //SourceExpr=Telefono;
            }
            Column(email; email)
            {
                //SourceExpr=email;
            }
            Column(PorcRetencion; PorcRetencion)
            {
                //SourceExpr=PorcRetencion;
            }
            Column(DescripcionTermsPago; DescripcionTermsPago)
            {
                //SourceExpr=DescripcionTermsPago;
            }
            Column(DescripcionMethPago; DescripcionMethPago)
            {
                //SourceExpr=DescripcionMethPago;
            }
            Column(DiasDePago; DiasDePago)
            {
                //SourceExpr=DiasDePago;
            }
            Column(lblPrecio; FiltroPrecio)
            {
                //SourceExpr=FiltroPrecio;
            }
            Column(lblImporte; FiltroImporte)
            {
                //SourceExpr=FiltroImporte;
            }
            Column(nMeses; nMeses)
            {
                //SourceExpr=nMeses;
            }
            DataItem("tmpDataPricesVendor"; "Data Prices Vendor")
            {

                DataItemTableView = SORTING("Quote Code", "Vendor No.", "Contact No.", "Line No.")
                                 ORDER(Ascending);
                PrintOnlyIfDetail = false;
                DataItemLink = "Quote Code" = FIELD("Quote Code"),
                            "Vendor No." = FIELD("Vendor No."),
                            "Contact No." = FIELD("Contact No.");
                UseTemporary = true;
                Column(Line_LineNo; tmpDataPricesVendor."Line No.")
                {
                    //SourceExpr=tmpDataPricesVendor."Line No.";
                }
                Column(Line_CodLinea; CodLinea)
                {
                    //SourceExpr=CodLinea;
                }
                Column(Line_DescUnidadObra; DescUnidadObra)
                {
                    //SourceExpr=DescUnidadObra;
                }
                Column(Line_DatPrecioCantidad; tmpDataPricesVendor.Quantity)
                {
                    //SourceExpr=tmpDataPricesVendor.Quantity;
                }
                Column(Line_Fecha; FechaServicio)
                {
                    //SourceExpr=FechaServicio;
                }
                Column(Line_Codunidad; UnitCode)
                {
                    //SourceExpr=UnitCode;
                }
                Column(Line_TextoExtendido; TextoExtendido)
                {
                    //SourceExpr=TextoExtendido;
                }
                Column(Line_RecUODescripcion; DataPieceworkForProduction.Description + '' + DataPieceworkForProduction."Description 2")
                {
                    //SourceExpr=DataPieceworkForProduction.Description + '' + DataPieceworkForProduction."Description 2";
                }
                Column(Line_DatPreciosNo; tmpDataPricesVendor."No.")
                {
                    //SourceExpr=tmpDataPricesVendor."No.";
                }
                Column(Line_DatPrecioDescOferta; QuoteDescription)
                {
                    //SourceExpr=QuoteDescription;
                }
                Column(b_______________________________; 11)
                {
                    //SourceExpr=11;
                }
                Column(Line_DatPreciosType; tmpDataPricesVendor.Type)
                {
                    //SourceExpr=tmpDataPricesVendor.Type;
                }
                Column(Line_DatPreciosLineNo; tmpDataPricesVendor."Line No.")
                {
                    //SourceExpr=tmpDataPricesVendor."Line No.";
                }
                Column(Line_VendorPrice_DataPricesVendor; tmpDataPricesVendor."Vendor Price")
                {
                    //SourceExpr=tmpDataPricesVendor."Vendor Price";
                }
                Column(Line_UnidadObra; UnidadObra)
                {
                    //SourceExpr=UnidadObra;
                }
                DataItem("Other Vendor Conditions"; "Other Vendor Conditions")
                {

                    DataItemTableView = SORTING("Quote Code", "Vendor No.", "Contact No.", "Version No.", "Code");
                    DataItemLink = "Quote Code" = FIELD("Quote Code"),
                            "Vendor No." = FIELD("Vendor No."),
                            "Version No." = FIELD("Version No.");
                    Column(Other_Code; "Other Vendor Conditions".Code)
                    {
                        //SourceExpr="Other Vendor Conditions".Code;
                    }
                    Column(Other_Description; "Other Vendor Conditions".Description)
                    {
                        //SourceExpr="Other Vendor Conditions".Description ;
                    }
                    trigger OnAfterGetRecord();
                    BEGIN
                        //JAV 11/03/19: - Si se desea sin datos del proveedor se quedan en blanco
                        IF (opcSinDatosProveedor) THEN
                            Description := '';
                        //JAV 11/03/19 fin
                    END;


                }
                trigger OnAfterGetRecord();
                BEGIN
                    QuoteDescription := tmpDataPricesVendor.TypeDescription(Type, "No.");

                    //N§ unidad Obra, unidad de medida y fecha de servicio
                    UnidadObra := '';
                    FechaServicio := 0D;
                    UnitCode := '';
                    IF ComparativeQuoteLines.GET("Quote Code", "Line No.") THEN BEGIN
                        UnidadObra := ComparativeQuoteLines."Piecework No.";
                        FechaServicio := ComparativeQuoteLines."Requirements date";
                        UnitCode := ComparativeQuoteLines."Unit of measurement Code";
                    END;

                    //CVP 10/07/2013
                    IF ComparativeQuoteLines."Base Measurement Unit Qty." = 0 THEN
                        BaseAmount := tmpDataPricesVendor.Quantity
                    ELSE
                        BaseAmount := tmpDataPricesVendor.Quantity * ComparativeQuoteLines."Base Measurement Unit Qty.";


                    //Unidad de obra de la l¡nea
                    IF NOT DataPieceworkForProduction.GET("Job No.", "Piecework No.") THEN
                        DataPieceworkForProduction.INIT;

                    //C¢digo a presentar, el de la U.Obra o el n£mero de la l¡nea
                    IF (opcGroup) THEN
                        CodLinea := FiltroUO + UnidadObra
                    ELSE
                        CodLinea := FiltroNro + FORMAT(tmpDataPricesVendor."Line No.");

                    //Descripci¢n de la l¡nea
                    DescUnidadObra := '';
                    CASE opcDescriptions OF
                        opcDescriptions::"De la l¡nea":
                            DescUnidadObra := QuoteDescription;
                        opcDescriptions::"De la U.Obra":
                            DescUnidadObra := DataPieceworkForProduction.Description + ' ' + DataPieceworkForProduction."Description 2";
                        opcDescriptions::"Del producto o recurso":
                            BEGIN
                                IF tmpDataPricesVendor.Type = tmpDataPricesVendor.Type::Item THEN BEGIN
                                    IF Item.GET(tmpDataPricesVendor."No.") THEN
                                        DescUnidadObra := Item.Description + ' ' + Item."Description 2";
                                END;
                                IF tmpDataPricesVendor.Type = tmpDataPricesVendor.Type::Resource THEN BEGIN
                                    IF Resource.GET(tmpDataPricesVendor."No.") THEN
                                        DescUnidadObra := Resource.Name + ' ' + Resource."Name 2";
                                END;
                            END;
                    END;

                    IF (NOT opcGroup) AND (opcShowUO) THEN
                        DescUnidadObra := UnidadObra + ' ' + DescUnidadObra;

                    //Texto extendido de la l¡nea, si no lo tiene el de la U.Obra
                    TextoExtendido := '';
                    IF (opcDescriptionsLong) THEN BEGIN
                        IF (NOT opcGroup) THEN
                            IF QBText.GET(QBText.Table::Comparativo, tmpDataPricesVendor."Quote Code", tmpDataPricesVendor."Line No.", '') THEN
                                TextoExtendido := QBText.GetCostText;

                        IF (TextoExtendido = '') THEN
                            IF QBText.GET(QBText.Table::Job, tmpDataPricesVendor."Job No.", UnidadObra) THEN
                                TextoExtendido := QBText.GetCostText;
                    END;
                END;


            }
            trigger OnPreDataItem();
            BEGIN
                //JAV 11/03/19 Se cambia de lugar para que se calcule solo una vez y no en cada proveedor
                "Vendor Conditions Data".FINDFIRST;
                IF Job.GET("Vendor Conditions Data"."Job No.") THEN BEGIN
                    Resource.RESET;
                    IF Resource.GET(Job."Person Responsible") THEN
                        nombreResponsable := Resource.Name + ' ' + Resource."Name 2";
                END;
                //JAV 11/03/19 fin
            END;

            trigger OnAfterGetRecord();
            BEGIN
                IF ComparativeQuoteHeader.GET("Vendor Conditions Data"."Quote Code") THEN
                    nMeses := ComparativeQuoteHeader."Generate for months"
                ELSE
                    nMeses := 0;

                IF ("Vendor No." <> '') THEN
                    refReferencia := FiltroRef + "Quote Code" + ' ' + "Vendor No." + ' ' + FORMAT("Version No.")
                ELSE
                    refReferencia := FiltroRef + "Quote Code" + ' ' + "Contact No." + ' ' + FORMAT("Version No.");


                //JAV 11/03/19: - Limpiar los datos antes de procesar, si no tomar  el dato del proveedor anterior
                CLEAR(VendAddr);
                RazonSocial := '';
                Contacto := '';
                Telefono := '';
                NoFax := '';
                email := '';
                PorcRetencion := 0;
                CodTermPago := '';
                CodFormPago := '';
                DescripcionTermsPago := '';
                DescripcionMethPago := '';
                DiasDePago := 0;

                //JAV 11/03/19: - Si se desea con datos del proveedor se calculan, si no quedan en blanco
                contador += 1;
                IF (opcSinDatosProveedor) AND (contador > 1) THEN
                    CurrReport.SKIP;

                IF (NOT opcSinDatosProveedor) THEN BEGIN
                    IF "Vendor Conditions Data"."Vendor No." <> '' THEN BEGIN
                        Vendor.GET("Vendor Conditions Data"."Vendor No.");
                        FormatAddr.Vendor(VendAddr, Vendor);
                        RazonSocial := Vendor.Name + ' ' + Vendor."Name 2";
                        Contacto := Vendor.Contact;
                        Telefono := Vendor."Phone No.";
                        NoFax := Vendor."Fax No.";
                        email := Vendor."E-Mail";

                    END ELSE BEGIN
                        IF NOT Contact.GET("Vendor Conditions Data"."Contact No.") THEN
                            CLEAR(Contact);
                        FormatAddr.ContactAddr(VendAddr, Contact);
                        RazonSocial := Contact.Name + ' ' + Contact."Name 2";
                        ;
                        Contacto := '';
                        Telefono := Contact."Phone No.";
                        NoFax := Contact."Fax No.";
                        email := Contact."E-Mail";
                    END;
                    //++zz
                    IF NoFax <> '' THEN
                        VendAddr[9] := Contact.FIELDCAPTION("Fax No.") + ': ' + NoFax
                    ELSE
                        VendAddr[9] := '';

                    COMPRESSARRAY(VendAddr);

                    //JAV 12/11/19: - Se eliminan lecturas de tablas que no se usan

                    //Retenciones Vendedor
                    IF WithholdingGroup.GET(WithholdingGroup."Withholding Type"::"G.E", "Vendor Conditions Data"."Withholding Code") THEN
                        PorcRetencion := WithholdingGroup."Percentage Withholding"
                    ELSE
                        PorcRetencion := 0;

                    //Forma de pago
                    CodTermPago := "Vendor Conditions Data"."Payment Terms Code";
                    CodFormPago := "Vendor Conditions Data"."Payment Method Code";
                    IF PaymentTerms.GET(CodTermPago) THEN
                        DescripcionTermsPago := PaymentTerms.Description;

                    IF PaymentMethod.GET(CodFormPago) THEN
                        DescripcionMethPago := PaymentMethod.Description;


                    //Dias de pago
                    PaymentDay.RESET;
                    PaymentDay.SETRANGE("Table Name", PaymentDay."Table Name"::"Company Information");
                    PaymentDay.SETRANGE(Code, CompanyInformation."Payment Days Code");
                    IF PaymentDay.FINDFIRST THEN
                        DiasDePago := PaymentDay."Day of the month";

                END;

                //Montamos las l¡neas agrupadas o todas
                tmpDataPricesVendor.RESET;
                tmpDataPricesVendor.DELETEALL;

                DataPricesVendor.RESET;
                DataPricesVendor.SETRANGE("Quote Code", "Vendor Conditions Data"."Quote Code");
                DataPricesVendor.SETRANGE("Vendor No.", "Vendor Conditions Data"."Vendor No.");
                DataPricesVendor.SETRANGE("Contact No.", "Vendor Conditions Data"."Contact No.");
                DataPricesVendor.SETRANGE("Version No.", "Vendor Conditions Data"."Version No.");
                IF (DataPricesVendor.FINDSET(FALSE)) THEN
                    REPEAT
                        IF (NOT opcGroup) THEN BEGIN
                            tmpDataPricesVendor := DataPricesVendor;
                            tmpDataPricesVendor.INSERT;
                        END ELSE BEGIN
                            tmpDataPricesVendor.RESET;
                            tmpDataPricesVendor.SETRANGE(Type, DataPricesVendor.Type);
                            tmpDataPricesVendor.SETRANGE("No.", DataPricesVendor."No.");
                            IF tmpDataPricesVendor.ISEMPTY THEN BEGIN
                                tmpDataPricesVendor := DataPricesVendor;
                                tmpDataPricesVendor.INSERT;
                            END;
                        END;
                    UNTIL (DataPricesVendor.NEXT = 0);
            END;


        }
    }
    requestpage
    {

        layout
        {
            area(content)
            {
                group("group627")
                {

                    field("boolAgrupar"; "opcGroup")
                    {

                        CaptionML = ENU = 'Group by type and number', ESP = 'Agrupar por tipo y n£mero';

                        ; trigger OnValidate()
                        BEGIN
                            SetEditable;
                        END;


                    }
                    field("booDescripcionesMaestros"; "opcDescriptions")
                    {

                        CaptionML = ENU = 'Print Item/Resource description', ESP = 'Imprimir descripci¢n';
                        Editable = edDescriptions;
                    }
                    field("boolDescripcionesUO"; "opcDescriptionsLong")
                    {

                        CaptionML = ENU = 'Print long descriptions', ESP = 'Imprimir descripciones largas';
                    }
                    field("boolShowUO"; "opcShowUO")
                    {

                        CaptionML = ENU = 'Show PW Code', ESP = 'Mostrar c¢digos de U.O';
                        Editable = edShowUO;
                    }
                    field("opcSinDatosProveedor"; "opcSinDatosProveedor")
                    {

                        CaptionML = ESP = 'Sin datos del Proveedor';
                    }

                }

            }
        }
        trigger OnOpenPage()
        BEGIN
            opcGroup := FALSE;
            opcDescriptions := 0;
            opcDescriptionsLong := TRUE;
            opcShowUO := TRUE;
            opcSinDatosProveedor := FALSE;

            SetEditable;
        END;


    }
    labels
    {
        lblReportName = 'Solicitud de oferta a proveedores/ Solicitud de oferta a proveedores/';
        lblCodOferta = 'C¢d. Oferta/';
        lblActividad = 'Actividad/';
        lblEstimadosSrs = 'Estimados se¤ores:/';
        lblRogamos = 'Les solicitamos su mejor oferta para la entrega de los siguientes suministro / servicios, conforme a las condiciones solicitadas, rogando no cambien los datos marcados en rojo y solo rellenen los espacios sobreados en gris claro./';
        lblNum = 'CODE/ CàDIGO/';
        lblUdadMedida = 'MEASURE/ UD/';
        lblCantidad = 'QUANTITY/ CANTIDAD/';
        lblFecha = 'FECHA SERVICIO/';
        lblDesc = 'SUMMARY/TEXT/ RESUMEN/TEXTO/';
        lblObserv = 'OBSERVACIONES/';
        lblNLine = 'L¡nea/';
        lblRazonSocial = 'Business name:/ Raz¢n social:/';
        lblNomContacto = 'Contact Name:/ Nom. Contacto:/';
        lblNoTelefono = 'Phone Number:/ N§ telf.:/';
        lblMail = 'Mail:/ E-Mail:/';
        lblCondGener = 'GENERAL CONDITIONS/ CONDICIONES GENERALES/';
        lblCondPart = 'PARTICULAR CONDITIONS/ CONDICIONES PARTICULARES/';
        lblFirma = 'SIGN. AND STAMP VENDOR/ FIRMA Y SELLO PROVEEDOR/';
        lblReferencia = 'N/Ref./';
        lblMeses1 = 'Se servir n las cantidades indicadas una vez al mes durante/';
        lblMeses2 = 'meses a partir de la fecha indicada/';
    }

    var
        //       DataPricesVendor@1100286024 :
        DataPricesVendor: Record 7207415;
        //       Vendor@1100227002 :
        Vendor: Record 23;
        //       Contact@7001106 :
        Contact: Record 5050;
        //       CompanyInformation@7001105 :
        CompanyInformation: Record 79;
        //       Item@7001104 :
        Item: Record 27;
        //       Job@1100286003 :
        Job: Record 167;
        //       Resource@7001103 :
        Resource: Record 156;
        //       ComparativeQuoteHeader@1100286009 :
        ComparativeQuoteHeader: Record 7207412;
        //       ComparativeQuoteLines@1100286005 :
        ComparativeQuoteLines: Record 7207413;
        //       WithholdingGroup@1100286006 :
        WithholdingGroup: Record 7207330;
        //       PaymentMethod@1100286004 :
        PaymentMethod: Record 289;
        //       PaymentTerms@1100286014 :
        PaymentTerms: Record 3;
        //       PaymentDay@1100286013 :
        PaymentDay: Record 10701;
        //       DataPieceworkForProduction@1100286008 :
        DataPieceworkForProduction: Record 7207386;
        //       QBText@100000000 :
        QBText: Record 7206918;
        //       FormatAddr@1100286002 :
        FormatAddr: Codeunit 365;
        //       UnitCode@7001109 :
        UnitCode: Code[10];
        //       i@7001108 :
        i: Integer;
        //       BaseAmount@7001110 :
        BaseAmount: Decimal;
        //       VendAddr@1100227000 :
        VendAddr: ARRAY[9] OF Text[50];
        //       NoFax@1100227004 :
        NoFax: Text[30];
        //       Description@1100227009 :
        Description: ARRAY[3] OF Text[250];
        //       QuoteDescription@1100227010 :
        QuoteDescription: Text[250];
        //       nombreResponsable@7001116 :
        nombreResponsable: Text;
        //       RazonSocial@7001117 :
        RazonSocial: Text;
        //       Contacto@7001118 :
        Contacto: Text[50];
        //       Telefono@7001119 :
        Telefono: Text[30];
        //       email@7001120 :
        email: Text[80];
        //       PorcRetencion@7001123 :
        PorcRetencion: Decimal;
        //       CodTermPago@7001125 :
        CodTermPago: Code[10];
        //       CodFormPago@7001126 :
        CodFormPago: Code[10];
        //       DescripcionTermsPago@7001129 :
        DescripcionTermsPago: Text[50];
        //       DescripcionMethPago@7001130 :
        DescripcionMethPago: Text[50];
        //       DiasDePago@7001132 :
        DiasDePago: Integer;
        //       UnidadObra@7001134 :
        UnidadObra: Code[20];
        //       CodLinea@7001135 :
        CodLinea: Code[20];
        //       DescUnidadObra@7001139 :
        DescUnidadObra: Text;
        //       TextoExtendido@7001141 :
        TextoExtendido: Text;
        //       contador@7001144 :
        contador: Integer;
        //       Text2@100000001 :
        Text2: Text;
        //       FechaServicio@1100286030 :
        FechaServicio: Date;
        //       nMeses@1100286000 :
        nMeses: Integer;
        //       "--------------------------------- Referencia de la l¡nea"@1100286022 :
        "--------------------------------- Referencia de la l¡nea": Integer;
        //       refReferencia@1100286023 :
        refReferencia: Text;
        //       "--------------------------------- Opciones"@1100286001 :
        "--------------------------------- Opciones": Integer;
        //       opcGroup@1100286007 :
        opcGroup: Boolean;
        //       opcDescriptions@1100286015 :
        opcDescriptions: Option "De la l¡nea","De la U.Obra","Del producto o recurso";
        //       opcDescriptionsLong@1100286017 :
        opcDescriptionsLong: Boolean;
        //       opcShowUO@1100286016 :
        opcShowUO: Boolean;
        //       opcSinDatosProveedor@1100286018 :
        opcSinDatosProveedor: Boolean;
        //       edDescriptions@1100286019 :
        edDescriptions: Boolean;
        //       edShowUO@1100286020 :
        edShowUO: Boolean;
        //       FiltroRef@1100286029 :
        FiltroRef: TextConst ESP = '#R';
        //       FiltroUO@1100286028 :
        FiltroUO: TextConst ESP = '#U';
        //       FiltroNro@1100286027 :
        FiltroNro: TextConst ESP = '#C';
        //       FiltroOtras@1100286026 :
        FiltroOtras: TextConst ESP = '#O';
        //       FiltroPrecio@1100286025 :
        FiltroPrecio: TextConst ESP = '# PRECIO';
        //       FiltroImporte@1100286021 :
        FiltroImporte: TextConst ESP = '# IMPORTE';



    trigger OnPreReport();
    begin
        CompanyInformation.GET;
        CompanyInformation.CALCFIELDS(CompanyInformation.Picture);
    end;



    procedure SetEditable()
    begin
        if (opcGroup) then begin
            opcDescriptions := opcDescriptions::"Del producto o recurso";
            opcShowUO := TRUE;
        end;

        edDescriptions := (not opcGroup);
        edShowUO := (not opcGroup);

        RequestOptionsPage.UPDATE;
    end;

    /*begin
    //{
//      QB5988 13/02/19 PEL: Mirar terminos y formas de pago solo si existe provedor.
//      JAV 11/03/19: - Si el proveedor no existe, tomaba los datos del anterior
//                    - Calcular el responsable solo una vez
//                    - Poder lanzarlo sin los datos del proveedor
//      JAV 11/04/19: - Se cambia el label "lblDesc" que era err¢neo
//      JAV 03/10/19: - Se cambia el c¢digo que monta el texto extendido por la nueva funci¢n que lo hace
//      JAV 12/11/19: - Se eliminan lecturas de tablas que no se usan
//    }
    end.
  */

}



