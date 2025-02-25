report 7207308 "Posted Output Shipment Header"
{


    CaptionML = ENU = 'Posted Output Shipment Header', ESP = 'Hist. Albaran de salida';

    dataset
    {

        DataItem("Posted Output Shipment Header"; "Posted Output Shipment Header")
        {

            DataItemTableView = SORTING("No.");
            RequestFilterHeadingML = ENU = 'Posted Sales Shipment', ESP = 'Hist. Albar n Salida';


            RequestFilterFields = "No.";
            Column(HistAlbAlbSalidaNo; "No.")
            {
                //SourceExpr="No.";
            }
            DataItem("CopyLoop"; "2000000026")
            {

                DataItemTableView = SORTING("Number");
                ;
                DataItem("PageLoop"; "2000000026")
                {

                    DataItemTableView = SORTING("Number")
                                 WHERE("Number" = CONST(1));
                    Column(CustAddr_1_; CustAddr[1])
                    {
                        //SourceExpr=CustAddr[1];
                    }
                    Column(CustAddr_2_; CustAddr[2])
                    {
                        //SourceExpr=CustAddr[2];
                    }
                    Column(CustAddr_3_; CustAddr[3])
                    {
                        //SourceExpr=CustAddr[3];
                    }
                    Column(CustAddr_4_; CustAddr[4])
                    {
                        //SourceExpr=CustAddr[4];
                    }
                    Column(CustAddr_5_; CustAddr[5])
                    {
                        //SourceExpr=CustAddr[5];
                    }
                    Column(CustAddr_6_; CustAddr[6])
                    {
                        //SourceExpr=CustAddr[6];
                    }
                    Column(HistAlbSalidaProy; "Posted Output Shipment Header"."Job No.")
                    {
                        IncludeCaption = true;
                        //SourceExpr="Posted Output Shipment Header"."Job No.";
                    }
                    Column(HistAlbSalidaNo; "Posted Output Shipment Header"."No.")
                    {
                        IncludeCaption = true;
                        //SourceExpr="Posted Output Shipment Header"."No.";
                    }
                    Column(CustAddr_7_; CustAddr[7])
                    {
                        //SourceExpr=CustAddr[7];
                    }
                    Column(CustAddr_8_; CustAddr[8])
                    {
                        //SourceExpr=CustAddr[8];
                    }
                    Column(HistAlbAlbSalidaFRegistro; "Posted Output Shipment Header"."Posting Date")
                    {
                        //SourceExpr="Posted Output Shipment Header"."Posting Date";
                    }
                    Column(RecJobDescription; RecJob.Description)
                    {
                        //SourceExpr=RecJob.Description;
                    }
                    Column(CopyText; CopyText)
                    {
                        //SourceExpr=CopyText;
                    }
                    Column(PageLoop_Number; Number)
                    {
                        //SourceExpr=Number;
                    }
                    Column(CompanyPicture; RecCompanyInfo.Picture)
                    {
                        //SourceExpr=RecCompanyInfo.Picture;
                    }
                    Column(includeLogo; includeLogo)
                    {
                        //SourceExpr=includeLogo;
                    }
                    Column(NoOfCopies; NoOfCopies)
                    {
                        //SourceExpr=NoOfCopies;
                    }
                    Column(OutputNo; OutputNo)
                    {
                        //SourceExpr=OutputNo;
                    }
                    Column(IndexDoc; DocIndex)
                    {
                        //SourceExpr=DocIndex;
                    }
                    DataItem("Posted Output Shipment Lines"; "Posted Output Shipment Lines")
                    {

                        DataItemTableView = SORTING("Document No.", "Line No.");
                        DataItemLinkReference = "Posted Output Shipment Header";
                        DataItemLink = "Document No." = FIELD("No.");
                        Column(HistLinAlbSalidaNo; "No.")
                        {
                            IncludeCaption = true;
                            //SourceExpr="No.";
                        }
                        Column(HistLinAlbSalidaDesc; Description)
                        {
                            IncludeCaption = true;
                            //SourceExpr=Description;
                        }
                        Column(HistLinAlbSalidaCantidad; Quantity)
                        {
                            IncludeCaption = true;
                            //SourceExpr=Quantity;
                        }
                        Column(HistLinAlbSalidaUnidadMedida; "Unit of Mensure Quantity")
                        {
                            //SourceExpr="Unit of Mensure Quantity";
                        }
                        Column(HistLinAlbSalidaUnitCost; "Unit Cost")
                        {
                            //SourceExpr="Unit Cost";
                        }
                        Column(HistLinAlbSalidaTotalCost; "Total Cost")
                        {
                            //SourceExpr="Total Cost";
                        }
                        Column(HistLinAlbSalidaDocumentNo; "Document No.")
                        {
                            //SourceExpr="Document No.";
                        }
                        Column(HistLinAlbSalidaLineNo; "Line No.")
                        {
                            //SourceExpr="Line No." ;
                        }
                    }
                }
                trigger OnPreDataItem();
                BEGIN
                    NoOfLoops := 1 + ABS(NoOfCopies);
                    CopyText := '';
                    SETRANGE(Number, 1, NoOfLoops);


                    OutputNo := 1;
                END;

                trigger OnAfterGetRecord();
                BEGIN
                    IF Number > 1 THEN BEGIN
                        CopyText := Text001;
                        OutputNo += 1;
                    END;

                    CurrReport.PAGENO := 1;
                    //Contamos los n£meros de documentos impresos
                    DocIndex += 1;
                END;


            }
            trigger OnAfterGetRecord();
            BEGIN
                FOR i := 1 TO ARRAYLEN(CustAddr) DO
                    CustAddr[i] := '';

                RecJob.GET("Job No.");
                IF RecCliente.GET(RecJob."Bill-to Customer No.") THEN
                    FormatAddr.Customer(CustAddr, RecCliente);
            END;


        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group("group475")
                {

                    CaptionML = ESP = 'Options';
                    field("NoOfCopies"; "NoOfCopies")
                    {

                        CaptionML = ENU = 'No. Copies', ESP = 'N£m. Copias';
                    }
                    field("includeLogo"; "includeLogo")
                    {

                        CaptionML = ENU = 'Include Logo', ESP = 'Incluye Logo';
                    }

                }

            }
        }
    }
    labels
    {
        TextAlbSalida = 'ALBARAN DE SALIDA/ ALBARµN DE SALIDA/';
        TextMaterial = 'MATERIAL DE ALMACEN/ MATERIAL DE ALMACN/';
        TextCliente = 'CUSTOMER/ CLIENTE/';
        TextDestino = 'Destino/ Destino/';
        TextDescDestino = 'Descripci¢n destino/ Descripci¢n destino/';
        TextUd = 'Ud./ Ud./';
        txtRecepcionObra = 'RECEPCIàN OBRA/ RECEPCIàN OBRA/';
        txtJefeAlmacen = 'JEFE ALMACN/';
        txtFecha = 'Fecha/ Fecha/';
        TextPrecio = 'Price/ Precio/';
        TextImporte = 'Amount/ Importe/';
        TextPage = 'Page/ P g./';
        TextTotal = 'TOTAL/ TOTAL/';
    }

    var
        //       Text000@1000 :
        Text000: TextConst ENU = 'Salesperson', ESP = 'Vendedor';
        //       Text002@1002 :
        Text002: TextConst ENU = 'Sales - Shipment %1', ESP = 'Venta - Alb. venta %1';
        //       Text003@1003 :
        Text003: TextConst ENU = 'Page %1', ESP = 'P g. %1';
        //       CustAddr@1012 :
        CustAddr: ARRAY[8] OF Text[50];
        //       MoreLines@1017 :
        MoreLines: Boolean;
        //       NoOfCopies@1018 :
        NoOfCopies: Integer;
        //       CopyText@1000000004 :
        CopyText: Text[30];
        //       NoOfLoops@1019 :
        NoOfLoops: Integer;
        //       i@1022 :
        i: Integer;
        //       FormatAddr@1023 :
        FormatAddr: Codeunit 365;
        //       Continue@1027 :
        Continue: Boolean;
        //       RecCliente@1000000000 :
        RecCliente: Record 18;
        //       RecJob@1000000001 :
        RecJob: Record 167;
        //       Text001@1100227000 :
        Text001: TextConst ENU = 'COPIA';
        //       includeLogo@1100227001 :
        includeLogo: Boolean;
        //       RecCompanyInfo@1100227002 :
        RecCompanyInfo: Record 79;
        //       OutputNo@1100227003 :
        OutputNo: Integer;
        //       DocIndex@1100227004 :
        DocIndex: Integer;



    trigger OnPreReport();
    begin
        if includeLogo then begin
            RecCompanyInfo.GET; //Get Company Information record
            RecCompanyInfo.CALCFIELDS(Picture); //Retrieve company logo
        end;
    end;



    /*begin
        end.
      */

}



