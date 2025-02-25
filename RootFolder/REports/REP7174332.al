report 7174332 "SII Import Document"
{


    ProcessingOnly = true;
    UseRequestPage = true;

    dataset
    {

        DataItem("LFECEOIE"; "2000000026")
        {

            DataItemTableView = SORTING("Number");
            ;
            DataItem("LFRPROIR"; "2000000026")
            {

                DataItemTableView = SORTING("Number");
                ;
                DataItem("LFBI"; "2000000026")
                {

                    DataItemTableView = SORTING("Number");
                    ;
                    DataItem("LFCM"; "2000000026")
                    {

                        DataItemTableView = SORTING("Number");

                        ;
                        trigger OnAfterGetRecord();
                        BEGIN
                            //Incluir los Cobros en met lico
                            SIIDocumentProcesing.CreateDocumentCobroMetalico(DocumentType, FromDate, ToDate);

                            SETRANGE(Number, 1, 0);
                        END;


                    }
                    trigger OnPreDataItem();
                    BEGIN
                        //Incluir los bienes de inversi¢n
                        SIIDocumentProcesing.CreateDocumentBI(DocumentType, FromDate, ToDate);

                        SETRANGE(Number, 1, 0);
                    END;


                }
                trigger OnPreDataItem();
                BEGIN
                    //Incluir las Facturas recibidas
                    IF (DocumentType IN [DocumentType::"Facturas Recibidas", DocumentType::"Pagos de Facturas Recibidas",
                                         DocumentType::"Facturas de Operaciones intracomunitarias"]) THEN
                        SIIDocumentProcesing.CreateDocumentVendor(DocumentType, OperationType, "VendorNo.", SIIExported, FromDate, ToDate);

                    SETRANGE(Number, 1, 0);
                END;


            }
            trigger OnPreDataItem();
            BEGIN
                //Incluir las Facturas emitidas
                IF (DocumentType IN [DocumentType::"Facturas Emitidas", DocumentType::"Cobros de Facturas Emitidas",
                                     DocumentType::"Facturas de Operaciones intracomunitarias"]) THEN
                    SIIDocumentProcesing.CreateDocumentCustomer(DocumentType, OperationType, "CustomerNo.", SIIExported, FromDate, ToDate, OTSDate);

                SETRANGE(Number, 1, 0);
            END;


        }
    }
    requestpage
    {

        layout
        {
            area(content)
            {


                field("DocumentType"; "DocumentType")
                {

                    CaptionML = ENU = 'Document Type', ESP = 'Tipo Documento';

                    ; trigger OnValidate()
                    BEGIN
                        IF DocumentType IN [DocumentType::"Cobros de Facturas Emitidas", DocumentType::"Cobros Metalico",
                                            DocumentType::"Facturas Emitidas", DocumentType::"Facturas Bienes de Inversi¢n",
                                            DocumentType::"Facturas de Operaciones intracomunitarias"]
                        THEN BEGIN
                            CustomerEditable := TRUE;
                            VendorEditable := FALSE;
                        END ELSE BEGIN
                            CustomerEditable := FALSE;
                            VendorEditable := TRUE;
                        END;
                    END;


                }
                field("FromDate"; "FromDate")
                {

                    CaptionML = ENU = 'From Date', ESP = 'Desde fecha';
                }
                field("ToDate"; "ToDate")
                {

                    CaptionML = ENU = 'To Date', ESP = 'Hasta Fecha';
                }
                field("CustomerNo."; "CustomerNo.")
                {

                    CaptionML = ENU = 'Customer Filter', ESP = 'Filtro Cliente';
                    TableRelation = Customer."No.";
                }
                field("VendorNo."; "VendorNo.")
                {

                    CaptionML = ENU = 'Vendor Filter', ESP = 'Filtro Proveedor';
                    TableRelation = Vendor."No.";
                }
                field("Include SII Exported"; "SIIExported")
                {

                    CaptionML = ENU = 'Include SII Exported', ESP = 'Incluir Exportados SII';
                }
                field("OTSDate"; "OTSDate")
                {

                    CaptionML = ESP = 'Fecha Tracto Sucesivo';
                    ToolTipML = ESP = 'Si se informa se usar  esta fecha como la actual, si no se informa se usar  siempre al fecha actual. A partir de esta fecha se calcula si se ha alcanzado la fecha de devengo de estos documentos para su inclusi¢n como facturas en la lista de documentos para subir al SII';
                }

            }
        }
        trigger OnOpenPage()
        BEGIN
            VendorEditable := FALSE;
            CustomerEditable := FALSE;

            IF DocumentType IN [DocumentType::"Cobros de Facturas Emitidas", DocumentType::"Cobros Metalico",
                                DocumentType::"Facturas Emitidas", DocumentType::"Facturas Bienes de Inversi¢n",
                                DocumentType::"Facturas de Operaciones intracomunitarias"]
            THEN BEGIN
                CustomerEditable := TRUE;
                VendorEditable := FALSE;
            END ELSE BEGIN
                CustomerEditable := FALSE;
                VendorEditable := TRUE;
            END;
        END;


    }
    labels
    {
    }

    var
        //       SIIDocumentProcesing@1100286006 :
        SIIDocumentProcesing: Codeunit 7174333;
        //       DocumentType@1100286022 :
        DocumentType: Option " ","Facturas Emitidas","Facturas Recibidas","Operaciones de seguros","Cobros Metalico","Facturas Bienes de Inversi¢n","Facturas de Operaciones intracomunitarias","Cobros de Facturas Emitidas","Pagos de Facturas Recibidas";
        //       FromDate@1100286020 :
        FromDate: Date;
        //       ToDate@1100286019 :
        ToDate: Date;
        //       OTSDate@1100286000 :
        OTSDate: Date;
        //       "CustomerNo."@1100286018 :
        "CustomerNo.": Code[10];
        //       "VendorNo."@1100286017 :
        "VendorNo.": Code[10];
        //       OperationType@1100286016 :
        OperationType: Option " ","Alta","Modificaci¢n","Baja";
        //       VendorEditable@7174332 :
        VendorEditable: Boolean;
        //       CustomerEditable@7174331 :
        CustomerEditable: Boolean;
        //       SIIExported@7174335 :
        SIIExported: Boolean;
        //       FirstDate@1100286001 :
        FirstDate: Date;

    //     procedure SetDocumentType (NewDocumentType@1100286000 :
    procedure SetDocumentType(NewDocumentType: Integer)
    begin
        DocumentType := NewDocumentType;
    end;

    //     procedure GetTypeValueDescription (TypeValue@1000000000 : Integer;TypeValueCode@1000000001 :
    procedure GetTypeValueDescription(TypeValue: Integer; TypeValueCode: Code[20]): Text;
    var
        //       TypeListValue@1100286000 :
        TypeListValue: Record 7174331;
    begin
        TypeListValue.RESET;
        TypeListValue.SETRANGE(Type, TypeValue);
        TypeListValue.SETRANGE(Code, TypeValueCode);
        if TypeListValue.FINDFIRST then
            exit(TypeListValue.Description);
    end;

    /*begin
    //{
//      //-QUO PEL
//      // QUOSII_02_02 --> 07/09/2017 --> Aviso al incluir un documento existente en SII Documents
//      QuoSII_1.3.02.005 171108 MCM - Se limpian los datos de la variable SIIDocuments
//      QuoSII.1.3.02.001 171109 PGM - Si la fecha de registro se encuentra entre el 1 y el 15 se comprueba
//                                     la configuracion de la empresa.
//      QuoSII_1.3.02.006 171110 MCM - Se comenta el código porque no es correcto.
//                                     Se modifica el código para que asigne el nº de documento SII a las líneas.
//      QuoSII_1.3.03.006 21/11/17 MCM - Se incluye la opci¢n de incluir como Fecha de Registro contable la fecha real de contabilizaci¢n
//      QuoSII1.3_014 12/04/18 - MCM - Se a¤ade el campo IRPF Type
//      QuoSII1.3_015 12/04/18 - MCM - Se corrige el error provocado cuando hay l¡neas no sujetas y sujetas en facturas recibidas
//      QuoSII1.4.03 09/03/2018 PEL
//
//      QuoSII1.4-2 10/04/18 PEL: -Si la fecha de registro del documento es anterior a la fecha indicada en el campo Fecha Inclusi¢n SII de la tabla Company Information
//                             modificar el campo "Description Operation 1"
//              20/04/18 PGM: -Si el importe del documento es superior a 100.000.000° y el campo Ignorar Mensaje no esta marcado, mostrar un mesaje de confirmaci¢n antes de insertarlo.
//      QuoSII_1.4.0.017 MCM 04/07/18 - Se modifica la referencia externa.
//      QuoSII_1.4.01.043 PGM 07/09/2018 - Se informa la base imponible y la cuota deducible a 0 cuando la clave de r‚gimen especial es agencias de viajes.
//      QuoSII_1.4.01.042 PGM 18/09/2019 - Correcci¢n del c lculo del importe total en facturas con IRPF
//      QuoSII_1.4.02.042 29/11/18 MCM - Se incluye la opci¢n de enviar a la ATCN
//      QuoSII_1.4.02.042.15 19/02/19 MCM - Se incluye la compatibilidad con retenciones de ventas.
//      QuoSII_1.4.02.042.16 19/02/19 MCM - Se corrige el valor de la cuota deducible en facturas con criterio de caja.
//      QuoSII.1.4.02.042.21 26/06/19 QMD - Se modifica para obtener los datos de la contraparte (Nombre y NIF) de la empresa fiscal y no del emisor de la factura.
//      QuoSII_1.4.99.999 28/06/19 QMD - Se reinicia el campo para controlar que se ha editado desde la p gina
//      QuoSII_1.4.94.999 QMD 15/07/19  - Informar campo tipo exenta
//      QuoSII_1.4.02.042.23 29/07/19 QMD - Bug_12287 - SII Facturas No sujetas (alquileres)
//      1901 30/09/19 CHP: PBI 13369, Creamos la funci¢n 'EliminarEspacios' y la invocamos.
//      BUG16625 14/01/21 CHP - Se corrige el valor de "No VAT Type" (ya corregido en esta versi¢n).
//
//      2101 AJS 30042021 QFS-OC-21001. Tratamiento de IVA no realizado
//      2102 AJS 06052021 QFS-OC-21001. Al buscar en los movimientos detallados de liquidacion no se puede filtrar por Exportado SII
//                                      En ProcessUnrealizedPayment cuando creamos el nuevo documento sii tiene que ser de tipo FE aunque con la informacion de cobro
//                                      Actualizar los datos del documento SII nuevo para que no se quede la marca de enviado
//                                      En la factura modificada dejamos el total pendiente
//      BUG17266 AJS 07052021: Hago que la funcion GetTypeValueDescription sea publica
//
//      JAV 15/04/21: - QuoSII 1.5f bloquear la fecha inicial de documentos que suben al SII
//      JAV 13/05/21: - QuoSII 1.5k Env¡o de documentos del tipo 14 y sus cobros
//      PSM 19/05/21: - QuoSII 1.5k Combinaci¢n de IVA exento con Tipo No Sujeta, env¡o como No Sujeto
//
//      JAV 26/05/21: - QuoSII 1.5p Se traslada el c¢digo a una CU para no repetir c¢digo
//      JAV 08/09/22: - QuoSII 1.06.12 Se incluye la fecha para operacines de Tracto Sucesivo
//    }
    end.
  */

}



