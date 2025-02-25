report 7207309 "Output Shipment"
{


    CaptionML = ENU = 'Output Shipment', ESP = 'Albaran de salida';

    dataset
    {

        DataItem("Output Shipment Header"; "Output Shipment Header")
        {

            DataItemTableView = SORTING("No.");
            RequestFilterHeadingML = ENU = 'Output Shipment', ESP = 'Albar n de salida no registrado';


            RequestFilterFields = "No.";
            Column(No_OutputShipmentHeader; "No.")
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
                    Column(CustAddr_7_; CustAddr[7])
                    {
                        //SourceExpr=CustAddr[7];
                    }
                    Column(CustAddr_8_; CustAddr[8])
                    {
                        //SourceExpr=CustAddr[8];
                    }
                    Column(ShipmentOutputJob; "Output Shipment Header"."Job No.")
                    {
                        IncludeCaption = true;
                        //SourceExpr="Output Shipment Header"."Job No.";
                    }
                    Column(ShipmentOutputNo; "Output Shipment Header"."No.")
                    {
                        IncludeCaption = true;
                        //SourceExpr="Output Shipment Header"."No.";
                    }
                    Column(ShipmentOutputFRegister; "Output Shipment Header"."Posting Date")
                    {
                        //SourceExpr="Output Shipment Header"."Posting Date";
                    }
                    Column(RecJobDescription; Job.Description)
                    {
                        //SourceExpr=Job.Description;
                    }
                    Column(CopyText; CopyText)
                    {
                        //SourceExpr=CopyText;
                    }
                    Column(PageLoop_Number; Number)
                    {
                        //SourceExpr=Number;
                    }
                    Column(CompanyPicture; CompanyInformation.Picture)
                    {
                        //SourceExpr=CompanyInformation.Picture;
                    }
                    Column(IncludeLogo; includeLogo)
                    {
                        //SourceExpr=includeLogo;
                    }
                    Column(NoofCopies; NoOfCopies)
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
                    DataItem("Output Shipment Lines"; "Output Shipment Lines")
                    {

                        DataItemTableView = SORTING("Document No.", "Line No.");
                        DataItemLinkReference = "Output Shipment Header";
                        DataItemLink = "Document No." = FIELD("No.");
                        Column(OutShipLineNo; OutputShipmentLines."No.")
                        {
                            IncludeCaption = true;
                            //SourceExpr=OutputShipmentLines."No.";
                        }
                        Column(OutShipLineDes; Description)
                        {
                            IncludeCaption = true;
                            //SourceExpr=Description;
                        }
                        Column(OutShipLineQuan; Quantity)
                        {
                            IncludeCaption = true;
                            //SourceExpr=Quantity;
                        }
                        Column(OutShipLineUnitofMea; "Unit of Measure Code")
                        {
                            //SourceExpr="Unit of Measure Code";
                        }
                        Column(OutShipLineNoUnitCost; "Unit Cost")
                        {
                            //SourceExpr="Unit Cost";
                        }
                        Column(OutShipLineNoTotalCost; "Total Cost")
                        {
                            //SourceExpr="Total Cost";
                        }
                        Column(OutShipLineNoDocumentNo; "Document No.")
                        {
                            //SourceExpr="Document No.";
                        }
                        Column(OutShipLineLineNo; "Line No.")
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

                Job.GET("Job No.");
                IF Customer.GET(Job."Bill-to Customer No.") THEN
                    FormatAddress.Customer(CustAddr, Customer);
            END;


        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group("group479")
                {

                    CaptionML = ENU = 'Options', ESP = 'Opciones';
                    field("NoofCopies"; "NoOfCopies")
                    {

                        CaptionML = ENU = 'Copies No.', ESP = 'Num. Copias';
                    }
                    field("IncludeLogo"; "includeLogo")
                    {

                        CaptionML = ENU = 'Include Logo', ESP = 'Incluye Logo';
                    }

                }

            }
        }
    }
    labels
    {
        TextOutShipment = 'OUTPUT SHIPMENT/ ALBARµN DE SALIDA/';
        TextMaterial = 'STOCK MATERIAL/ MATERIAL DE ALMACN/';
        TextCustomer = 'CUSTOMER/ CLIENTE/';
        TextDestination = 'Destination/ Destino/';
        TextDescDestination = 'Destination Description/ Descripci¢n destino/';
        TextU = 'Unit/ Ud./';
        txtReceptionJob = 'RECEPTION JOB/ RECEPCIàN OBRA/';
        txtBossStore = 'BOSS STORE/';
        txtDate = 'Date/ Fecha/';
        TextPrice = 'Price/ Precio/';
        TextAmount = 'Amount/ Importe/';
        TextPage = 'Page/ P g./';
        TextTotal = 'TOTAL/ TOTAL/';
    }

    var
        //       Job@7001100 :
        Job: Record 167;
        //       CompanyInformation@7001101 :
        CompanyInformation: Record 79;
        //       OutputShipmentLines@7001102 :
        OutputShipmentLines: Record 7207309;
        //       includeLogo@7001103 :
        includeLogo: Boolean;
        //       i@7001104 :
        i: Integer;
        //       CustAddr@7001105 :
        CustAddr: ARRAY[8] OF Text[50];
        //       Customer@7001106 :
        Customer: Record 18;
        //       FormatAddress@7001107 :
        FormatAddress: Codeunit 365;
        //       NoOfLoops@7001108 :
        NoOfLoops: Integer;
        //       CopyText@7001109 :
        CopyText: Text[30];
        //       NoOfCopies@7001110 :
        NoOfCopies: Integer;
        //       OutputNo@7001111 :
        OutputNo: Integer;
        //       Text001@7001112 :
        Text001: TextConst ENU = 'COPY', ESP = 'COPIA';
        //       DocIndex@7001113 :
        DocIndex: Integer;



    trigger OnPreReport();
    begin
        if includeLogo then begin
            CompanyInformation.GET; //Get Company Information record
            CompanyInformation.CALCFIELDS(Picture); //Retrieve company logo
        end;
    end;



    /*begin
        end.
      */

}



