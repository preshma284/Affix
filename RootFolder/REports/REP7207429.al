report 7207429 "Warehouse Invoices"
{
  ApplicationArea=All;



    CaptionML = ENU = 'Warehouse Invoices', ESP = 'Facturas de Almac‚n';

    dataset
    {

        DataItem("Sales Invoice Header"; "Sales Invoice Header")
        {

            PrintOnlyIfDetail = false;
            ;
            Column(COMPANYNAME; COMPANYNAME)
            {
                //SourceExpr=COMPANYNAME;
            }
            Column(No_SalesInvoiceHeader; "Sales Invoice Header"."No.")
            {
                //OptionCaptionML=ENU='Factura',ESP='Factura';
                //SourceExpr="Sales Invoice Header"."No.";
            }
            Column(BilltoCustomerNo_SalesInvoiceHeader; "Sales Invoice Header"."Bill-to Customer No.")
            {
                //OptionCaptionML=ENU='Bill to Customer No.',ESP='No. de cliente';
                //SourceExpr="Sales Invoice Header"."Bill-to Customer No.";
            }
            Column(BilltoName_SalesInvoiceHeader; "Sales Invoice Header"."Bill-to Name")
            {
                //OptionCaptionML=ENU='Bill to Name',ESP='Nombre del cliente';
                //SourceExpr="Sales Invoice Header"."Bill-to Name";
            }
            Column(Amount_SalesInvoiceHeader; "Sales Invoice Header".Amount)
            {
                //OptionCaptionML=ENU='Amount',ESP='Importe';
                //SourceExpr="Sales Invoice Header".Amount;
            }
            Column(LocationCode_SalesInvoiceHeader; "Sales Invoice Header"."Location Code")
            {
                //OptionCaptionML=ENU='Location Code',ESP='Cod. Almac‚n';
                //SourceExpr="Sales Invoice Header"."Location Code";
            }
            Column(PostingDate_SalesInvoiceHeader; "Sales Invoice Header"."Posting Date")
            {
                //OptionCaptionML=ENU='Posting Date',ESP='Fecha de Registro';
                //SourceExpr="Sales Invoice Header"."Posting Date";
            }
            Column(No_SalesInvoiceHeaderCAPTION; "Sales Invoice Header".FIELDCAPTION("No."))
            {
                //OptionCaptionML=ESP=Factura;
                //SourceExpr="Sales Invoice Header".FIELDCAPTION("No.");
            }
            Column(PostingDate_SalesInvoiceHeaderCAPTION; "Sales Invoice Header".FIELDCAPTION("Posting Date"))
            {
                //SourceExpr="Sales Invoice Header".FIELDCAPTION("Posting Date");
            }
            Column(Amount_SalesInvoiceHeaderCAPTION; "Sales Invoice Header".FIELDCAPTION(Amount))
            {
                //SourceExpr="Sales Invoice Header".FIELDCAPTION(Amount);
            }
            Column(BilltoPostCode_SalesInvoiceHeader; "Sales Invoice Header"."Bill-to Post Code")
            {
                //SourceExpr="Sales Invoice Header"."Bill-to Post Code";
            }
            DataItem("Company Information"; "Company Information")
            {

                PrintOnlyIfDetail = false;
                ;
                Column(Picture_CompanyInformation; "Company Information".Picture)
                {
                    //SourceExpr="Company Information".Picture;
                }
                Column(Name_CompanyInformation; "Company Information".Name)
                {
                    //SourceExpr="Company Information".Name;
                }
                Column(Address_CompanyInformation; "Company Information".Address)
                {
                    //SourceExpr="Company Information".Address;
                }
                Column(PostCode_CompanyInformation; "Company Information"."Post Code")
                {
                    //SourceExpr="Company Information"."Post Code";
                }
                Column(City_CompanyInformation; "Company Information".City)
                {
                    //SourceExpr="Company Information".City;
                }
                Column(County_CompanyInformation; "Company Information".County)
                {
                    //SourceExpr="Company Information".County;
                }
                Column(Pais_CompanyInformation; Pais)
                {
                    //SourceExpr=Pa¡s ;
                }
                trigger OnPreDataItem();
                BEGIN
                    TablaCountryRegion.RESET;
                    TablaCompanyInformation.GET;
                    TablaCountryRegion.SETFILTER(Code, TablaCompanyInformation."Country/Region Code");
                    IF TablaCountryRegion.FINDFIRST THEN
                        Pais := TablaCountryRegion.Name;
                END;


            }
            trigger OnPreDataItem();
            begin
                //{TablaSalesInvoiceHeader.RESET;
                //                               TablaSalesInvoiceHeader.GET;
                //                               IF TablaSalesInvoiceHeader."Location Code" = '' THEN
                //                                 TablaSalesInvoiceHeader."Location Code" := 'NO ALMACEN';
                //                                 }
                SETFILTER("No.", NumFactura);
            END;

            trigger OnAfterGetRecord();
            BEGIN
                CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");
            END;


        }
    }
    requestpage
    {

        layout
        {
            area(content)
            {


                field("Numero de Factura"; "NumFactura")
                {

                    CaptionML = ESP = 'N£mero de Factura';
                    TableRelation = "Sales Invoice Header"

    ;
                }

            }
        }
    }
    labels
    {
    }

    var
        //       TablaSalesInvoiceHeader@1100286001 :
        TablaSalesInvoiceHeader: Record 112;
        //       TablaCountryRegion@1100286002 :
        TablaCountryRegion: Record 9;
        //       Pa¡s@1100286003 :
        Pais: Text;
        //       TablaCompanyInformation@1100286004 :
        TablaCompanyInformation: Record 79;
        //       Language@1100286000 :
        Language: Codeunit "Language";
        //       NumFactura@1100286005 :
        NumFactura: Code[20];

    /*begin
    end.
  */

}




