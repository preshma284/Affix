report 7207432 "QB Crear Efectos"
{


    CaptionML = ENU = 'Suggest Vendor Payments', ESP = 'Proponer efectos a proveedores';
    ProcessingOnly = true;

    dataset
    {

        DataItem("Vendor"; "Vendor")
        {

            DataItemTableView = SORTING("No.");


            RequestFilterFields = "No.";
            DataItem("Vendor Ledger Entry"; "Vendor Ledger Entry")
            {

                DataItemTableView = SORTING("Vendor No.", "Open", "Positive", "Due Date", "Currency Code")
                                 WHERE("Open" = CONST(true), "Positive" = CONST(false), "On Hold" = FILTER(= ''));


                RequestFilterFields = "Payment Method Code";

                DataItemLink = "Vendor No." = FIELD("No.");
                trigger OnPreDataItem();
                BEGIN
                    IF varHastaFecha = 0D THEN
                        varHastaFecha := 99991231D;
                    SETRANGE("Due Date", varDesdeFecha, varHastaFecha);

                    IF (varPaymentMethod <> '') THEN
                        SETRANGE("Payment Method Code", varPaymentMethod);

                    IF (parEfectos) THEN
                        SETRANGE("Document Type", "Document Type"::Bill)
                    ELSE
                        SETRANGE("Document Type", "Document Type"::Invoice);

                    //No incluir documento en ¢rdenes de pago
                    SETFILTER("Document Situation", '%1|%2', "Vendor Ledger Entry"."Document Situation"::" ", "Vendor Ledger Entry"."Document Situation"::Cartera);
                END;

                trigger OnAfterGetRecord();
                BEGIN
                    //Si no es de la misma divisa del banco, me lo salto
                    IF (parCurrencyCode <> "Vendor Ledger Entry"."Currency Code") THEN
                        CurrReport.SKIP;

                    //JAV 19/10/20: - QB 1.06.19 Si est  activa la aprobaci¢n de cartera, tiene que estar aprobado en cartera para poder incluirlo
                    IF (ApprovalCarteraDoc.IsApprovalsWorkflowActive) THEN BEGIN
                        CarteraDoc.RESET;
                        CarteraDoc.SETCURRENTKEY(Type, "Document No.");                              //JAV 30/06/22: - QB 1.10.57 Para acelerar un poco se a¤ade una key
                        CarteraDoc.SETRANGE(Type, CarteraDoc.Type::Payable);
                        CarteraDoc.SETRANGE("Document No.", "Vendor Ledger Entry"."Document No.");
                        //CarteraDoc.SETRANGE("Posting Date", "Vendor Ledger Entry"."Posting Date");  //JAV 30/06/22: - QB 1.10.57 Se quita este filtro porque no tiene sentido y no retorna valores correctos
                        CarteraDoc.SETRANGE("Account No.", "Vendor Ledger Entry"."Vendor No.");
                        IF (CarteraDoc.FINDFIRST) THEN
                            IF (CarteraDoc."Approval Status" <> CarteraDoc."Approval Status"::Released) THEN
                                CurrReport.SKIP;
                    END;

                    //Si no tiene Importe a convertir me lo salto. Pongo el importe del documento y le resto lo que est‚ en otras relaciones
                    "Vendor Ledger Entry".CALCFIELDS("Remaining Amount");
                    ImportePendiente := ABS("Vendor Ledger Entry"."Remaining Amount");

                    recLineas.RESET;
                    recLineas.SETRANGE("Relacion No.", parNroRelacion);
                    recLineas.SETRANGE("Document No.", "Vendor Ledger Entry"."Document No.");
                    IF recLineas.FINDSET THEN
                        REPEAT
                            ImportePendiente -= ABS(recLineas.Amount);
                        UNTIL recLineas.NEXT = 0;

                    IF ImportePendiente <= 0 THEN
                        CurrReport.SKIP;

                    //Montar nuevo m‚todo de pago
                    IF (varMetodoPago <> '') THEN
                        NewMetodoPago := varMetodoPago
                    ELSE BEGIN
                        NewMetodoPago := "Vendor Ledger Entry"."Payment Method Code";
                        IF PaymentMethod.GET(NewMetodoPago) THEN
                            IF (PaymentMethod."Convert in Payment Relation" <> '') THEN
                                NewMetodoPago := PaymentMethod."Convert in Payment Relation";
                    END;

                    IF NOT PaymentMethod.GET(NewMetodoPago) THEN
                        CurrReport.SKIP;
                    IF NOT PaymentMethod."Create Bills" THEN
                        CurrReport.SKIP;

                    //Montar nuevos t‚minos de pago
                    IF (varTerminoPago <> '') THEN
                        NewTerminosPago := varTerminoPago
                    ELSE
                        NewTerminosPago := "Vendor Ledger Entry"."Payment Terms Code";

                    IF NOT PaymentTerms.GET(NewTerminosPago) THEN
                        CurrReport.SKIP;

                    //Montar la tabla de plazos y porcentajes de los efectos
                    CLEAR(TablaPlazos);
                    CLEAR(TablaPorc);
                    MaxVto := 1;
                    TablaPlazos[MaxVto] := FORMAT(PaymentTerms."Due Date Calculation");
                    TablaPorc[MaxVto] := 100;

                    Porcentaje := 100;
                    Installment.RESET;
                    Installment.SETRANGE("Payment Terms Code", PaymentTerms.Code);
                    IF Installment.FINDSET THEN BEGIN
                        REPEAT
                            TablaPlazos[MaxVto + 1] := Installment."Gap between Installments"; //el vencimiento del siguiente plazo, no del actual
                            IF (Porcentaje > Installment."% of Total") THEN
                                TablaPorc[MaxVto] := Installment."% of Total"
                            ELSE
                                TablaPorc[MaxVto] := Porcentaje;
                            Porcentaje -= TablaPorc[MaxVto];
                            MaxVto += 1;
                        UNTIL Installment.NEXT = 0;
                        MaxVto -= 1;
                        IF (Porcentaje <> 0) THEN
                            TablaPorc[MaxVto] += Porcentaje;
                    END;

                    // Buscar el n£mero del primer efecto a generar
                    recLineas.RESET;
                    recLineas.SETCURRENTKEY("Relacion No.", "Document Type", "Document No.", "Bill No.");
                    //recLineas.SETRANGE("Relacion No.", parNroRelacion);
                    recLineas.SETRANGE("Document Type", "Vendor Ledger Entry"."Document Type");
                    recLineas.SETRANGE("Document No.", "Vendor Ledger Entry"."Document No.");
                    NextBillNo := FORMAT(recLineas.COUNT);
                    IF (recLineas.COUNT = 1) THEN BEGIN
                        recLineas.FINDFIRST;
                        IF (recLineas."Relacion No." = parNroRelacion) THEN BEGIN
                            recLineas."Bill No." := NextBillNo;
                            recLineas.MODIFY(TRUE);
                        END;
                    END;

                    // Establece importe y fecha base de c lculo de los vencimientos
                    ImporteRestante := ImportePendiente;
                    FechaVto := "Vendor Ledger Entry"."Due Date";

                    //----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                    //------------ PROCESO DE CONVERTIR LA FACTURA EN EFECTOS --------------------------------------------------------------------------------------------------------------------
                    //----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                    //Generar los efectos por plazos
                    FOR CurrVto := 1 TO MaxVto DO BEGIN
                        //Calculo la fecha del vencimiento
                        IF (varFechaVtoEfecto = 0D) THEN
                            FechaVto := CalcularFecha(CurrVto, TablaPlazos[CurrVto], FechaVto,
                                                      "Vendor Ledger Entry"."Document Date", PaymentTerms, Vendor."No.")
                        ELSE
                            FechaVto := varFechaVtoEfecto;

                        //Calculo el importe correspondiente al plazo
                        Importe := CalcularImporte(ImportePendiente, ImporteRestante, TablaPorc[CurrVto] / 100, CurrVto = MaxVto);

                        //Aumento el contador de efectos
                        NextBillNo := INCSTR(NextBillNo);

                        //Relleno el diario
                        NextLineNo += 10000;
                        recLineas.INIT;
                        recLineas."Relacion No." := parNroRelacion;
                        recLineas."Line No." := NextLineNo;
                        IF "Vendor Ledger Entry"."Remaining Amount" <= 0 THEN
                            recLineas."Tipo Linea" := recLineas."Tipo Linea"::Factura
                        ELSE
                            recLineas."Tipo Linea" := recLineas."Tipo Linea"::Abono;
                        recLineas."Document Type" := "Vendor Ledger Entry"."Document Type";
                        recLineas."Document No." := "Vendor Ledger Entry"."Document No.";
                        IF (NextBillNo = '1') AND (MaxVto = 1) THEN
                            recLineas."Bill No." := ''
                        ELSE
                            recLineas."Bill No." := NextBillNo;
                        recLineas.VALIDATE("Vendor No.", "Vendor Ledger Entry"."Vendor No.");
                        recLineas.VALIDATE("Currency Code", "Vendor Ledger Entry"."Currency Code");
                        IF "Vendor Ledger Entry"."Remaining Amount" <= 0 THEN
                            recLineas.VALIDATE(Amount, Importe)
                        ELSE
                            recLineas.VALIDATE(Amount, -Importe);
                        recLineas."Original Due Date" := "Vendor Ledger Entry"."Due Date";
                        recLineas."Dimension Set ID" := "Vendor Ledger Entry"."Dimension Set ID";
                        recLineas."External Document No." := "Vendor Ledger Entry"."External Document No.";
                        recLineas.VALIDATE("No. Mov. Proveedor", "Vendor Ledger Entry"."Entry No.");
                        recLineas.VALIDATE("Payment Method Code", NewMetodoPago);
                        recLineas.VALIDATE("Payment Terms Code", PaymentTerms.Code);
                        recLineas."Due Date" := FechaVto;

                        recLineas.SetDescription;

                        //IF (recLineas."Due Date" < varFechaRegistro) THEN
                        //  recLineas."Due Date" := varFechaRegistro;
                        recLineas.INSERT(TRUE);
                    END;
                END;


            }
            trigger OnPreDataItem();
            BEGIN
                //Saltarse proveedores bloqueados y empleados
                SETRANGE(Blocked, Vendor.Blocked::" ");
                CASE varIncluir OF
                    varIncluir::Proveedores:
                        SETRANGE("QB Employee", FALSE);
                    varIncluir::Empleados:
                        SETRANGE("QB Employee", TRUE);
                END;
                Window.OPEN(Text000);
                mRec := COUNT + 1;
                nRec := 0;
            END;

            trigger OnAfterGetRecord();
            BEGIN
                nRec += 1;
                Window.UPDATE(1, ROUND(nRec * 10000 / mRec, 1));
            END;

            trigger OnPostDataItem();
            BEGIN
                Window.CLOSE;
            END;


        }
    }
    requestpage
    {

        layout
        {
            area(content)
            {
                group("group851")
                {

                    CaptionML = ENU = 'Options', ESP = 'Opciones';
                    group("group852")
                    {

                        CaptionML = ENU = 'Options', ESP = 'Fecha de registro';
                        field("varFechaRegistro"; "varFechaRegistro")
                        {

                            CaptionML = ENU = 'Posting Date', ESP = 'Fecha de registro';
                            ToolTipML = ENU = 'Specifies the date for the posting of this batch job. By default, the working date is entered, but you can change it.', ESP = 'Especifica la fecha de registro de este proceso. La fecha de trabajo se introduce de forma predeterminada, pero es posible cambiarla.';
                            Editable = false;
                        }
                        field("varIncluir"; "varIncluir")
                        {

                            CaptionML = ESP = 'Incluir';
                        }

                    }
                    group("group855")
                    {

                        CaptionML = ENU = 'Options', ESP = 'Filtros';
                        field("varDesdeFecha"; "varDesdeFecha")
                        {

                            CaptionML = ESP = 'Desde Fecha Vto.';
                        }
                        field("varHastaFecha"; "varHastaFecha")
                        {

                            CaptionML = ENU = 'Last Payment Date', ESP = 'Hasta Fecha Vto.';
                            ToolTipML = ENU = 'Specifies the latest payment date that can appear on the vendor ledger entries to be included in the batch job. Only entries that have a due date or a payment discount date before or on this date will be included. If the payment date is earlier than the system date, a warning will be displayed.', ESP = 'Especifica la £ltima fecha de vencimiento que puede aparecer en los movimientos de proveedor que se van a incluir en el proceso. Solo se incluir n los movimientos cuya fecha de vencimiento sean iguales o anteriores a esta fecha. Si la fecha se deja en blanco se buscar n todas las fechas';
                        }
                        field("varPaymentMethod"; "varPaymentMethod")
                        {

                            CaptionML = ESP = 'Forma de Pago';
                            ToolTipML = ESP = 'Indica la forma de pago de los efectos que desea incluir, si no especifica nada ser n todos';
                            TableRelation = "Payment Method";
                        }

                    }
                    group("group859")
                    {

                        CaptionML = ENU = 'Options', ESP = 'Generaci¢n';
                        field("varFechaVtoEfecto"; "varFechaVtoEfecto")
                        {

                            CaptionML = ESP = 'Nueva Fecha Vencimiento';
                            ToolTipML = ESP = 'Si se especifica se usar  esta para los vencimientos, si se deja en blanco se calcular  seg£n el m‚todo de pago. En ambos casos luego podr  cambiar la fecha de vencimiento en el diario.';
                        }
                        field("varMetodoPago"; "varMetodoPago")
                        {

                            CaptionML = ESP = 'Nueva Forma de Pago';
                            ToolTipML = ESP = 'Este campo se usar  solo si no es posible establecer autom ticamente la forma de pago de los nuevos efectos creados.';
                            TableRelation = "Payment Method";
                        }
                        field("varTerminoPago"; "varTerminoPago")
                        {

                            CaptionML = ESP = 'Nuevos T‚rminos de pago';
                            ToolTipML = ESP = 'Este campo se usar  solo si no es posible establecer autom ticamente los t‚rminos de pago de los nuevos efectos creados.';
                            TableRelation = "Payment Terms"

    ;
                        }

                    }

                }

            }
        }
    }
    labels
    {
    }

    var
        //       GLSetup@7001199 :
        GLSetup: Record 98;
        //       PurchSetup@7001192 :
        PurchSetup: Record 312;
        //       recLineas@7001116 :
        recLineas: Record 7206923;
        //       recLineas2@7001112 :
        recLineas2: Record 7206923;
        //       PaymentMethod@7001148 :
        PaymentMethod: Record 289;
        //       PaymentTerms@7001188 :
        PaymentTerms: Record 3;
        //       Installment@7001190 :
        Installment: Record 7000018;
        //       Fac@7001114 :
        Fac: Record 122;
        //       Abo@7001117 :
        Abo: Record 124;
        //       CarteraDoc@1100286007 :
        CarteraDoc: Record 7000002;
        //       ApprovalCarteraDoc@1100286008 :
        ApprovalCarteraDoc: Codeunit 7206917;
        //       AdjustDueDate@1100286009 :
        AdjustDueDate: Codeunit 10700;
        //       NextLineNo@7001181 :
        NextLineNo: Integer;
        //       NextBillNo@7001186 :
        NextBillNo: Code[10];
        //       NewMetodoPago@7001107 :
        NewMetodoPago: Code[20];
        //       NewTerminosPago@7001110 :
        NewTerminosPago: Code[20];
        //       MaxVto@7001198 :
        MaxVto: Integer;
        //       CurrVto@7001187 :
        CurrVto: Integer;
        //       FechaVto@7001189 :
        FechaVto: Date;
        //       Porcentaje@7001191 :
        Porcentaje: Decimal;
        //       ImportePendiente@7001109 :
        ImportePendiente: Decimal;
        //       Importe@7001193 :
        Importe: Decimal;
        //       ImporteRestante@7001113 :
        ImporteRestante: Decimal;
        //       TablaPlazos@7001196 :
        TablaPlazos: ARRAY[20] OF Text;
        //       TablaPorc@7001197 :
        TablaPorc: ARRAY[20] OF Decimal;
        //       Window@7001134 :
        Window: Dialog;
        //       Text000@7001173 :
        Text000: TextConst ENU = 'Procesing @1@@@@@@@@@@@@@@@@@@@@', ESP = 'Procesando @1@@@@@@@@@@@@@@@@@@@@';
        //       Text001@7001167 :
        Text001: TextConst ENU = 'Starting Document No. must contain a number.', ESP = 'No ha indicado fecha de registro';
        //       nRec@7001101 :
        nRec: Integer;
        //       mRec@7001105 :
        mRec: Integer;
        //       Saltar@7001102 :
        Saltar: Boolean;
        //       auxTxt@7001118 :
        auxTxt: Text;
        //       "--- Opciones de la Page -------------------------------------------"@7001127 :
        "--- Opciones de la Page -------------------------------------------": Integer;
        //       parNroRelacion@1100286001 :
        parNroRelacion: Integer;
        //       parCurrencyCode@1100286002 :
        parCurrencyCode: Code[10];
        //       parEfectos@1100286003 :
        parEfectos: Boolean;
        //       varPaymentMethod@1100286006 :
        varPaymentMethod: Code[20];
        //       varFechaRegistro@7001132 :
        varFechaRegistro: Date;
        //       varDesdeFecha@1100286005 :
        varDesdeFecha: Date;
        //       varHastaFecha@1100286004 :
        varHastaFecha: Date;
        //       varFechaVtoEfecto@7001103 :
        varFechaVtoEfecto: Date;
        //       varTerminoPago@7001104 :
        varTerminoPago: Code[20];
        //       varMetodoPago@7001106 :
        varMetodoPago: Code[20];
        //       varIncluir@1100286000 :
        varIncluir: Option "Proveedores","Empleados";



    trigger OnInitReport();
    begin
        varFechaRegistro := WORKDATE;
    end;

    trigger OnPreReport();
    begin
        if varFechaRegistro = 0D then
            ERROR(Text001);

        //Buscar nro de l¡nea y serie de registro
        recLineas.RESET;
        recLineas.SETRANGE("Relacion No.", parNroRelacion);
        if recLineas.FINDLAST then
            NextLineNo := recLineas."Line No."
        else
            NextLineNo := 0;
    end;



    // LOCAL procedure CalcularFecha (Plazo@7001104 : Integer;DateFormulaText@1100002 : Code[20];DueDate@1100003 : Date;DocDate@7001101 : Date;PaymentTerms@7001103 : Record 3;Vendor@7001102 :
    LOCAL procedure CalcularFecha(Plazo: Integer; DateFormulaText: Code[20]; DueDate: Date; DocDate: Date; PaymentTerms: Record 3; Vendor: Code[20]): Date;
    var
        //       DateFormula@1100004 :
        DateFormula: DateFormula;
        //       Vto@7001100 :
        Vto: Date;
    begin
        if (Plazo <> 1) then begin
            EVALUATE(DateFormula, DateFormulaText);
            DueDate := CALCDATE(DateFormula, DueDate);
        end;
        Vto := DueDate;
        AdjustDueDate.PurchAdjustDueDate(DueDate, DocDate, PaymentTerms.CalculateMaxDueDate(DocDate), Vendor);
        if (DueDate <> 0D) then
            exit(DueDate)
        else
            exit(Vto);
    end;

    //     LOCAL procedure CalcularImporte (parImporte@7001100 : Decimal;var parMax@7001101 : Decimal;parPorcentaje@7001102 : Decimal;parUltimo@7001103 :
    LOCAL procedure CalcularImporte(parImporte: Decimal; var parMax: Decimal; parPorcentaje: Decimal; parUltimo: Boolean): Decimal;
    begin
        parImporte := Redondear(parImporte * parPorcentaje);
        if (parUltimo) or (parImporte > parMax) then
            parImporte := parMax;
        parMax -= parImporte;
        exit(parImporte);
    end;

    //     LOCAL procedure Redondear (Amount@1100000 :
    LOCAL procedure Redondear(Amount: Decimal): Decimal;
    begin
        PurchSetup.GET;
        GLSetup.GET;

        if PurchSetup."Invoice Rounding" then
            Amount := ROUND(
                Amount,
                GLSetup."Inv. Rounding Precision (LCY)",
                SELECTSTR(GLSetup."Inv. Rounding Type (LCY)" + 1, '=,>,<'))
        else
            Amount := ROUND(
                Amount,
                GLSetup."Amount Rounding Precision");

        exit(Amount);
    end;

    LOCAL procedure "-------------"()
    begin
    end;

    //     procedure SetDatos (pNro@1000 : Integer;pFecha@7001101 : Date;pCurrency@7001100 : Code[10];pEfectos@1100286000 :
    procedure SetDatos(pNro: Integer; pFecha: Date; pCurrency: Code[10]; pEfectos: Boolean)
    begin
        parNroRelacion := pNro;
        varFechaRegistro := pFecha;
        parCurrencyCode := pCurrency;
        parEfectos := pEfectos;
    end;

    /*begin
    //{
//      JAV 30/06/22: - QB 1.10.57 Para acelerar un poco se a¤ade una key. Se quita un filtro porque no tiene sentido y no retorna valores correctos
//    }
    end.
  */

}



// RequestFilterFields="Payment Method Code";
