report 7207416 "Comparativo Compras"
{


    CaptionML = ENU = 'Comparative Quote Printing', ESP = 'Impresi¢n comparativo oferta';

    dataset
    {

        DataItem("Comparative Quote Header"; "Comparative Quote Header")
        {

            DataItemTableView = SORTING("No.")
                                 ORDER(Ascending);


            RequestFilterFields = "No.";
            Column(InfoEmpresa_Picture; CompanyInformation.Picture)
            {
                //SourceExpr=CompanyInformation.Picture;
            }
            Column(CabFComparativo; "Comparative Quote Header"."Comparative Date")
            {
                //SourceExpr="Comparative Quote Header"."Comparative Date";
            }
            Column(CabNo; "Comparative Quote Header"."No.")
            {
                //SourceExpr="Comparative Quote Header"."No.";
            }
            Column(CabFiltroActividad; "Comparative Quote Header"."Activity Filter")
            {
                //SourceExpr="Comparative Quote Header"."Activity Filter";
            }
            Column(CabJobNo; "Job No.")
            {
                //SourceExpr="Job No.";
            }
            Column(ProyDesc; Job.Description)
            {
                //SourceExpr=Job.Description;
            }
            Column(varTexto; TextV)
            {
                //SourceExpr=TextV;
            }
            Column(txtActDescripcion; ActDescription)
            {
                //SourceExpr=ActDescription;
            }
            Column(NombreProvSeleccionado; NombreProveedorSeleccionado)
            {
                //SourceExpr=NombreProveedorSeleccionado;
            }
            Column(FechaIni; FechaIni)
            {
                //SourceExpr=FechaIni;
            }
            Column(FechaFin; FechaFin)
            {
                //SourceExpr=FechaFin;
            }
            Column(CodFormaPago; CodFormaPago)
            {
                //SourceExpr=CodFormaPago;
            }
            Column(PortRet; PortRet)
            {
                //SourceExpr=PortRet;
            }
            Column(DiasVencimiento; DiasVencimiento)
            {
                //SourceExpr=DiasVencimiento;
            }
            DataItem("Data Prices Vendor"; "Data Prices Vendor")
            {

                DataItemTableView = SORTING("Quote Code", "Vendor No.", "Contact No.", "Line No.")
                                 ORDER(Ascending);
                DataItemLink = "Quote Code" = FIELD("No.");
                Column(CodOferta_Datospreciosproveedor; "Data Prices Vendor"."Quote Code")
                {
                    //SourceExpr="Data Prices Vendor"."Quote Code";
                }
                Column(VendorNo_Datospreciosproveedor; "Data Prices Vendor"."Vendor No.")
                {
                    //SourceExpr="Data Prices Vendor"."Vendor No.";
                }
                Column(Type_Datospreciosproveedor; "Data Prices Vendor".Type)
                {
                    //SourceExpr="Data Prices Vendor".Type;
                }
                Column(No_Datospreciosproveedor; "Data Prices Vendor"."No.")
                {
                    //SourceExpr="Data Prices Vendor"."No.";
                }
                Column(Quantity_Datospreciosproveedor; "Data Prices Vendor".Quantity)
                {
                    //SourceExpr="Data Prices Vendor".Quantity;
                }
                Column(JobNo_Datospreciosproveedor; "Data Prices Vendor"."Job No.")
                {
                    //SourceExpr="Data Prices Vendor"."Job No.";
                }
                Column(LocationCode_Datospreciosproveedor; "Data Prices Vendor"."Location Code")
                {
                    //SourceExpr="Data Prices Vendor"."Location Code";
                }
                Column(Precioproveedor_Datospreciosproveedor; "Data Prices Vendor"."Vendor Price")
                {
                    //SourceExpr="Data Prices Vendor"."Vendor Price";
                }
                Column(Importecompra_Datospreciosproveedor; "Data Prices Vendor"."Purchase Amount")
                {
                    //SourceExpr="Data Prices Vendor"."Purchase Amount";
                }
                Column(LineNo_Datospreciosproveedor; "Data Prices Vendor"."Line No.")
                {
                    //SourceExpr="Data Prices Vendor"."Line No.";
                }
                Column(Precioprevisto_Datospreciosproveedor; "Data Prices Vendor"."Estimated Price")
                {
                    //SourceExpr="Data Prices Vendor"."Estimated Price";
                }
                Column(Precioobjetivo_Datospreciosproveedor; "Data Prices Vendor"."Target Price")
                {
                    //SourceExpr="Data Prices Vendor"."Target Price";
                }
                Column(ContactNo_Datospreciosproveedor; "Data Prices Vendor"."Contact No.")
                {
                    //SourceExpr="Data Prices Vendor"."Contact No.";
                }
                Column(txtTelef; Telef)
                {
                    //SourceExpr=Telef;
                }
                Column(txtMail; Mail)
                {
                    //SourceExpr=Mail;
                }
                Column(txtFax; Fax)
                {
                    //SourceExpr=Fax;
                }
                Column(txtName; Name)
                {
                    //SourceExpr=Name;
                }
                Column(txtContact; Contact)
                {
                    //SourceExpr=Contact;
                }
                Column(txtUM; UM)
                {
                    //SourceExpr=UM;
                }
                Column(txtDescripcion; Description)
                {
                    //SourceExpr=Description;
                }
                Column(decQTY; QTY)
                {
                    //SourceExpr=QTY;
                }
                Column(txtMovil; Movil)
                {
                    //SourceExpr=Movil;
                }
                Column(UnidadObra; UnidadObra)
                {
                    //SourceExpr=UnidadObra;
                }
                //D1 Triggers
                trigger OnAfterGetRecord();
                BEGIN
                    IF "Other Vendor Conditions"."Vendor No." = '' THEN BEGIN
                        recContact.GET("Data Prices Vendor"."Contact No.");
                        NameOtras := recContact.Name;
                    END ELSE BEGIN
                        Vendor.GET("Other Vendor Conditions"."Vendor No.");
                        NameOtras := Vendor.Name;
                    END;
                END;
            }

            DataItem("Other Vendor Conditions"; "Other Vendor Conditions")
            {

                DataItemLink = "Quote Code" = FIELD("No.");
                Column(Description_Otrascondicionesproveedor; "Other Vendor Conditions".Description)
                {
                    //SourceExpr="Other Vendor Conditions".Description;
                }
                Column(Code_Otrascondicionesproveedor; "Other Vendor Conditions".Code)
                {
                    //SourceExpr="Other Vendor Conditions".Code;
                }
                Column(VendorNo_Otrascondicionesproveedor; "Other Vendor Conditions"."Vendor No.")
                {
                    //SourceExpr="Other Vendor Conditions"."Vendor No.";
                }
                Column(Amount_Otrascondicionesproveedor; "Other Vendor Conditions".Amount)
                {
                    //SourceExpr="Other Vendor Conditions".Amount;
                }
                Column(txtNameOtras; NameOtras)
                {
                    //SourceExpr=NameOtras;
                }
                //D2 Triggers
                trigger OnAfterGetRecord();
                BEGIN
                    IF "Data Prices Vendor"."Contact No." <> '' THEN BEGIN
                        recContact.GET("Data Prices Vendor"."Contact No.");
                        Telef := recContact."Phone No.";
                        Mail := recContact."E-Mail";
                        Fax := recContact."Fax No.";
                        Name := recContact.Name;
                        Contact := recContact.Name;
                        Movil := recContact."Mobile Phone No.";
                    END ELSE BEGIN
                        Vendor.GET("Data Prices Vendor"."Vendor No.");
                        Telef := Vendor."Phone No.";
                        Mail := Vendor."E-Mail";
                        Fax := Vendor."Fax No.";
                        Name := Vendor.Name;
                        Contact := Vendor.Contact;
                    END;

                    Description := "Data Prices Vendor".TypeDescription("Data Prices Vendor".Type, "Data Prices Vendor"."No.");
                    UM := "Data Prices Vendor".TypeUM("Data Prices Vendor".Type, "Data Prices Vendor"."No.");
                    QTY := "Data Prices Vendor".TypeQTY("Data Prices Vendor".Type, "Data Prices Vendor"."No.");
                    Flag := FALSE;
                    ActDescription := '';
                    IF "Comparative Quote Header"."Activity Filter" <> '' THEN BEGIN
                        ActivityQB.RESET;
                        ActivityQB.SETFILTER("Activity Code", "Comparative Quote Header"."Activity Filter");
                        IF ActivityQB.FIND('-') THEN BEGIN
                            REPEAT
                                IF STRLEN(ActDescription) + STRLEN(ActivityQB.Description) > MAXSTRLEN(ActDescription) THEN
                                    Flag := TRUE;
                                IF ActDescription <> '' THEN
                                    ActDescription := COPYSTR(ActDescription + ' ; ' + ActivityQB.Description, 1, MAXSTRLEN(ActDescription))
                                ELSE
                                    ActDescription := COPYSTR(ActivityQB.Description, 1, MAXSTRLEN(ActDescription));
                            UNTIL (ActivityQB.NEXT() = 0) OR (Flag);
                        END;
                    END;

                    //Unidad de obra - Columna Partida
                    ComparativeQuoteLines.RESET;
                    ComparativeQuoteLines.SETRANGE("Job No.", "Data Prices Vendor"."Job No.");
                    ComparativeQuoteLines.SETRANGE("Quote No.", "Data Prices Vendor"."Quote Code");
                    ComparativeQuoteLines.SETRANGE("No.", "Data Prices Vendor"."No.");
                    IF ComparativeQuoteLines.FINDFIRST THEN
                        UnidadObra := ComparativeQuoteLines."Piecework No.";
                END;
            }

            DataItem("Vendor Conditions Data"; "Vendor Conditions Data")
            {

                DataItemLink = "Quote Code" = FIELD("No.");
                Column(VendorNo_Datoscondicionesproveedor; "Vendor Conditions Data"."Vendor No.")
                {
                    //SourceExpr="Vendor Conditions Data"."Vendor No.";
                }
                Column(ValidezOferta_Datoscondicionesproveedor; "Vendor Conditions Data"."Quote Validity")
                {
                    //SourceExpr="Vendor Conditions Data"."Quote Validity";
                }
                Column(PaymentTermsCode_Datoscondicionesproveedor; "Vendor Conditions Data"."Payment Terms Code")
                {
                    //SourceExpr="Vendor Conditions Data"."Payment Terms Code";
                }
                Column(PaymentMethodCode_Datoscondicionesproveedor; "Vendor Conditions Data"."Payment Method Code")
                {
                    //SourceExpr="Vendor Conditions Data"."Payment Method Code";
                }
                Column(Codretencion_Datoscondicionesproveedor; "Vendor Conditions Data"."Withholding Code")
                {
                    //SourceExpr="Vendor Conditions Data"."Withholding Code";
                }
                Column(DevolRetencion_Datoscondicionesproveedor; "Vendor Conditions Data"."Return Withholding")
                {
                    //SourceExpr="Vendor Conditions Data"."Return Withholding";
                }
                Column(Fechafin_Datoscondicionesproveedor; "Vendor Conditions Data"."End Date")
                {
                    //SourceExpr="Vendor Conditions Data"."End Date";
                }
                Column(Fechaoferta_Datoscondicionesproveedor; "Vendor Conditions Data"."Quonte Date")
                {
                    //SourceExpr="Vendor Conditions Data"."Quonte Date";
                }
                Column(Fechainicio_Datoscondicionesproveedor; "Vendor Conditions Data"."Start Date")
                {
                    //SourceExpr="Vendor Conditions Data"."Start Date" ;
                }
                //D3 Triggers
            }
            //CQH Triggers
            trigger OnPreDataItem();
            BEGIN
                CompanyInformation.GET;
                CompanyInformation.CALCFIELDS(CompanyInformation.Picture);
            END;

            trigger OnAfterGetRecord();
            BEGIN
                Job.GET("Comparative Quote Header"."Job No.");
                CLEAR(QBCommentLine);
                Counter := 0;
                TextV := '';
                QBCommentLine.RESET;
                QBCommentLine.SETRANGE("Document Type", QBCommentLine."Document Type"::Reestimation);
                QBCommentLine.SETRANGE("No.", "Comparative Quote Header"."No.");
                IF QBCommentLine.FINDSET THEN
                    REPEAT
                        Counter := Counter + 1;
                        TextV := TextV + QBCommentLine.Comment + ' ';
                    UNTIL (QBCommentLine.NEXT = 0) OR (Counter >= 3);

                Vendor.RESET;
                Vendor.SETRANGE("No.", "Comparative Quote Header"."Selected Vendor");
                IF Vendor.FINDSET THEN
                    NombreProveedorSeleccionado := Vendor.Name;

                VendorConditionsData.RESET;
                VendorConditionsData.SETRANGE("Vendor No.", "Comparative Quote Header"."Selected Vendor");
                IF VendorConditionsData.FINDSET THEN BEGIN
                    FechaIni := VendorConditionsData."Start Date";
                    FechaFin := VendorConditionsData."End Date";
                    CodFormaPago := VendorConditionsData."Payment Method Code";
                    CodRet := VendorConditionsData."Withholding Code";
                    CodTermPago := VendorConditionsData."Payment Terms Code";
                END;

                WithholdingGroup.RESET;
                WithholdingGroup.SETRANGE(Code, CodFormaPago);
                IF WithholdingGroup.FINDSET THEN
                    PortRet := WithholdingGroup."Percentage Withholding";

                PaymentTerms.RESET;
                PaymentTerms.SETRANGE(Code, CodTermPago);
                IF PaymentTerms.FINDSET THEN
                    DiasVencimiento := PaymentTerms."Max. No. of Days till Due Date";
            END;


        }
    }

    requestpage
    {

        layout
        {
        }
    }
    labels
    {
        txtTit = 'Comparativo de ofertas/';
        txtObra = 'Obra:/';
        txtFComp = 'Fecha comparativa/';
        txtOferta = 'N§ oferta/';
        txtFiltro = 'Filtro actividad/';
        txtN = 'N§/';
        txtMed = 'Medici¢n/';
        txtCdadPrev = 'Cdad. Prevista/';
        txtConcep = 'Concepto/';
        txtTf = 'Tfno./';
        lblFax = 'Fax/';
        txtMov = 'M¢vil/';
        txtEmail = 'Mail/ Mail/';
        txtPrecio = 'PRECIO/';
        txtTotal = 'TOTAL/';
        txtOfOptima = 'OFERTA àPTIMA/';
        txtImpInicialPrev = 'Importe inicial previsto/';
        txtImpPrev = 'Importe previsto/';
        txtImporte = 'Importe/';
        txtObjetivo = 'objetivo/';
        txtSumUO = 'SUMA UNIDADES DE OBRA/';
        txtDifImpPrevi = 'Diferencia con importe previsto/';
        txtDifImpObj = 'Diferencia con importe objetivo/';
        txtFComienzo = 'Fecha de comienzo/';
        txtFOferta = 'Fecha de la oferta/';
        txtFValidezOf = 'Validez de la oferta/';
        txtFTermin = 'Fecha de terminaci¢n/';
        txtFPago = 'Forma de pago/';
        txtTPago = 'T‚rmino de pago/';
        txtRetencion = 'Retenci¢n/';
        txtDevGarant = 'Devoluci¢n Garant¡a/';
        txtSumVar = 'SUMA VARIOS/';
        txtTotContrat = 'TOTAL CONTRATO/';
        txtObserv = 'OBSERVACIONES/';
        txtSuministros = 'SUMINISTROS ESPECÖFICOS DE COMPRAS/';
        txtDtor = 'DTOR. DPTO. SOLICITANTE/';
        txtDirCompras = 'DIRECTOR DE COMPRAS/';
        txtDirGeneral = 'DIRECTOR GENERAL/';
        txtFdo = 'Fdo.:/';
        txtFecha = 'Fecha/';
        txtFObra = 'JEFE DE OBRA/';
        txtJGRUPO = 'JEFE DE GRUPO/';
        txtDel = 'DELEGADO/';
        txtDir = 'DIRECTOR GENERAL O DTOR. DE CONSTRUCCIàN/';
        lbIncluido = 'INCLUIDO/';
        lbimporte = 'IMPORTE/';
        lbOtrasCond = 'OTRAS CONDICIONES/';
        txtPartida = 'SHIPMENT/ PARTIDA/';
        txtUD = 'UNIT/ UD/';
        txtK = '"K "/ "K "/';
        txtValidacionFirma = 'VALIDATION AND SIGNS/ VALIDACIàN Y FIRMAS/';
        txtFormaPago = 'PAYMENT METHOD/ FORMA PAGO/';
        txtAjudicatario = 'AWARDEE/ ADJUDICATARIO/';
        txtOfertaEconomica = 'MOST CHEAPER OFFER/ OFERTA MAS ECONàMICA/';
        txtDias = 'DAYS:/ DÖAS:/';
        txtTipo = 'TYPE:/ TIPO:/';
        txtRET = 'RET.:/ RET.:/';
        txtInicio = 'START/ INICIO/';
        txtFinal = 'END/ FINAL/';
        txtPenal = 'PENALTY/ PENLZ./';
        txtPlazoDev = 'RETURN TERM/ PLAZO DEVOLUCIàN/';
        txtMedContrato = 'CONTRACT MEAS./ MED. DEL CONTRATO/';
        txtPrecioVenta = 'SALES PRICE/ PRECIO DE VENTA/';
    }

    var
        //       Text001@1100227090 :
        Text001: TextConst ESP = '#.##0,00 [$€-1]';
        //       Text002@1100227089 :
        Text002: TextConst ESP = '#.##0,00000 [$€-1]';
        //       CompanyInformation@7001100 :
        CompanyInformation: Record 79;
        //       Job@1100227001 :
        Job: Record 167;
        //       Vendor@7001104 :
        Vendor: Record 23;
        //       recContact@7001103 :
        recContact: Record 5050;
        //       ActivityQB@7001102 :
        ActivityQB: Record 7207280;
        //       QBCommentLine@7001101 :
        QBCommentLine: Record 7207270;
        //       Counter@7001105 :
        Counter: Integer;
        //       QTY@7001106 :
        QTY: Decimal;
        //       Flag@7001107 :
        Flag: Boolean;
        //       Telef@1100227002 :
        Telef: Text[20];
        //       Mail@1100227003 :
        Mail: Text[50];
        //       Fax@1100227004 :
        Fax: Text[20];
        //       Name@1100227005 :
        Name: Text[100];
        //       Contact@1100227019 :
        Contact: Text[100];
        //       Description@1100227008 :
        Description: Text[80];
        //       UM@1100227009 :
        UM: Text[50];
        //       ActDescription@1100227012 :
        ActDescription: Text[250];
        //       OptimalVendor@1100227014 :
        OptimalVendor: Code[10];
        //       NameOtras@1100227015 :
        NameOtras: Text[100];
        //       TextV@1100227016 :
        TextV: Text[250];
        //       NombreProveedorSeleccionado@7001108 :
        NombreProveedorSeleccionado: Text;
        //       VendorConditionsData@7001109 :
        VendorConditionsData: Record 7207414;
        //       FechaIni@7001110 :
        FechaIni: Date;
        //       FechaFin@7001111 :
        FechaFin: Date;
        //       CodFormaPago@7001112 :
        CodFormaPago: Code[20];
        //       CodRet@7001113 :
        CodRet: Code[20];
        //       WithholdingGroup@7001114 :
        WithholdingGroup: Record 7207330;
        //       PortRet@7001115 :
        PortRet: Decimal;
        //       DiasVencimiento@7001116 :
        DiasVencimiento: Integer;
        //       PaymentTerms@7001117 :
        PaymentTerms: Record 3;
        //       CodTermPago@7001118 :
        CodTermPago: Code[10];
        //       Movil@7001119 :
        Movil: Text[20];
        //       ComparativeQuoteLines@7001120 :
        ComparativeQuoteLines: Record 7207413;
        //       UnidadObra@7001121 :
        UnidadObra: Code[20];

    /*begin
    end.
  */

}



