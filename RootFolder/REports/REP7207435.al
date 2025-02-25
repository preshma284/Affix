report 7207435 "QB Pago Anticipado"
{


    ProcessingOnly = true;

    dataset
    {

    }
    requestpage
    {

        layout
        {
            area(content)
            {
                group("group887")
                {

                    CaptionML = ENU = 'Options', ESP = 'Opciones';
                    field("optProyecto"; "optProyecto")
                    {

                        CaptionML = ESP = 'Proyecto';
                        TableRelation = Job."No." WHERE("Card Type" = CONST("Proyecto operativo"));
                        ShowMandatory = True;
                    }
                    field("optProveedor"; "optProveedor")
                    {

                        CaptionML = ESP = 'Proveedor';
                        ToolTipML = ESP = 'Proveedor al que generar el pago anticipado';
                        TableRelation = Vendor;


                        ShowMandatory = True;
                        trigger OnValidate()
                        BEGIN
                            Vendor.GET(optProveedor);
                            optFormaPago := Vendor."Payment Method Code";
                            optTerminosPago := Vendor."Payment Terms Code";
                        END;


                    }
                    field("optFechaDocumento"; "optFechaDocumento")
                    {

                        CaptionML = ESP = 'Fecha del documento del proveedor';
                        //OptionCaptionML=ESP='Fecha del documento del proveedor';
                        ShowMandatory = True;
                    }
                    field("optFechaVencimiento"; "optFechaVencimiento")
                    {

                        CaptionML = ESP = 'Fecha de Vencimiento';
                        // OptionCaptionML=ESP='Fecha de Vencimiento';
                        ShowMandatory = True;
                    }
                    field("optNroFactura"; "optNroFactura")
                    {

                        CaptionML = ESP = 'S/Documento';
                        ToolTipML = ESP = 'El n£mero del documento del proveedor';
                        ShowMandatory = True;
                    }
                    field("optImporte"; "optImporte")
                    {

                        CaptionML = ESP = 'Importe a pagar';
                        ToolTipML = ESP = 'Importe a pagar en el efecto';
                        BlankZero = true;
                        ShowMandatory = True;
                    }
                    field("optFormaPago"; "optFormaPago")
                    {

                        CaptionML = ESP = 'Forma de Pago';
                        ToolTipML = ESP = 'Forma de pago del efecto a generar';
                        TableRelation = "Payment Method";
                        ShowMandatory = True;
                    }
                    field("optTerminosPago"; "optTerminosPago")
                    {

                        CaptionML = ESP = 'T‚rminos de pago';
                        ToolTipML = ESP = 'M‚todo de pago del efeco a generar';
                        TableRelation = "Payment Terms";
                        ShowMandatory = True

    ;
                    }

                }

            }
        }
    }
    labels
    {
    }

    var
        //       QBRelationshipSetup@7001100 :
        QBRelationshipSetup: Record 7207335;
        //       Cabecera@7001114 :
        Cabecera: Record 7206922;
        //       Lineas@7001105 :
        Lineas: Record 7206923;
        //       Job@1100286001 :
        Job: Record 167;
        //       Vendor@7001102 :
        Vendor: Record 23;
        //       PaymentMethod@7001103 :
        PaymentMethod: Record 289;
        //       PaymentTerms@7001104 :
        PaymentTerms: Record 3;
        //       Bank@7001109 :
        Bank: Record 270;
        //       NoSeriesMgt@7001108 :
        NoSeriesMgt: Codeunit 396;
        //       varRelacion@7001101 :
        varRelacion: Integer;
        //       varLinea@7001106 :
        varLinea: Integer;
        //       varNroDocumento@7001107 :
        varNroDocumento: Code[20];
        //       "------------------------------- Opciones de la page"@7001143 :
        "------------------------------- Opciones de la page": Integer;
        //       optProyecto@1100286000 :
        optProyecto: Code[20];
        //       optProveedor@7001144 :
        optProveedor: Code[20];
        //       optFechaDocumento@7001141 :
        optFechaDocumento: Date;
        //       optFechaVencimiento@7001140 :
        optFechaVencimiento: Date;
        //       optNroFactura@7001127 :
        optNroFactura: Text[20];
        //       optImporte@7001129 :
        optImporte: Decimal;
        //       optFormaPago@7001139 :
        optFormaPago: Code[10];
        //       optTerminosPago@7001111 :
        optTerminosPago: Code[10];



    trigger OnInitReport();
    begin
        optFechaVencimiento := WORKDATE;
    end;

    trigger OnPreReport();
    begin
        Cabecera.GET(varRelacion);
        Job.GET(optProyecto);
        Bank.GET(Cabecera."Bank Account No.");
        Vendor.GET(optProveedor);
        PaymentMethod.GET(optFormaPago);
        PaymentTerms.GET(optTerminosPago);
        //if optFechaDocumento = 0D then ERROR('Debe indicar la fecha del documento');
        if optFechaVencimiento = 0D then ERROR('Debe indicar la fecha de vencimiento');
        if optNroFactura = '' then ERROR('Debe indicar el n£mero del documento del proveedor');
        if optImporte = 0 then ERROR('Debe indicar el importe');
        if (PaymentTerms."No. of Installments" > 1) then ERROR('Solo puede generarse un £nico vencimiento de un pago anticipado');
        Lineas.RESET;
        Lineas.SETRANGE("Relacion No.", varRelacion);
        if (Lineas.FINDLAST) then
            varLinea := Lineas."Line No."
        else
            varLinea := 0;

        QBRelationshipSetup.GET();
        QBRelationshipSetup.TESTFIELD("RP Serie para Pago Anticipado");
        NoSeriesMgt.InitSeries(QBRelationshipSetup."RP Serie para Pago Anticipado", '', 0D, varNroDocumento, QBRelationshipSetup."RP Serie para Pago Anticipado");

        if (PaymentMethod."Convert in Payment Relation" <> '') then
            PaymentMethod.GET(PaymentMethod."Convert in Payment Relation");

        if (not PaymentMethod."Create Bills") then
            ERROR('La forma de pago %1 no genera efectos', PaymentMethod.Code);

        Lineas.INIT;
        Lineas."Relacion No." := varRelacion;
        Lineas."Line No." += 10000;
        Lineas.INSERT;

        Lineas."Tipo Linea" := Lineas."Tipo Linea"::Anticipado;
        Lineas.VALIDATE("Vendor No.", optProveedor);
        Lineas.VALIDATE("Job No.", optProyecto);
        Lineas."Document Type" := Lineas."Document Type"::Bill;
        Lineas."Document No." := varNroDocumento;
        Lineas."Bill No." := '1';
        Lineas."External Document No." := optNroFactura;
        Lineas."Document Date" := optFechaDocumento;
        Lineas."Due Date" := optFechaVencimiento;
        Lineas."Payment Terms Code" := optTerminosPago;
        Lineas."Payment Method Code" := optFormaPago;
        Lineas.Amount := optImporte;
        Lineas."Currency Code" := Bank."Currency Code";
        Lineas.SetDescription;
        Lineas.BuscarErrores(FALSE);
        Lineas."No. Pagare" := '';
        Lineas.MODIFY;
    end;



    // procedure SetRelacion (parNumero@7001100 :
    procedure SetRelacion(parNumero: Integer)
    begin
        varRelacion := parNumero;
    end;

    /*begin
    end.
  */

}



