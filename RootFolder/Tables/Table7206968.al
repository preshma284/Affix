table 7206968 "QB Posted Service Order Header"
{


    CaptionML = ENU = 'Posted Service Order Header', ESP = 'Cabecera Pedido Servicio Registrado';
    LookupPageID = "QB Post. Service Order List";
    DrillDownPageID = "QB Post. Service Order List";

    fields
    {
        field(1; "No."; Code[20])
        {
            CaptionML = ENU = 'No.', ESP = 'N�';


        }
        field(2; "Job Description"; Text[50])
        {
            CaptionML = ENU = 'Description', ESP = 'Descripción';


        }
        field(3; "Description 2"; Text[50])
        {
            CaptionML = ENU = 'Description 2', ESP = 'Descripción 2';


        }
        field(4; "Posting Date"; Date)
        {
            CaptionML = ENU = 'Posting Date', ESP = 'Fecha registro';


        }
        field(5; "Posting Description"; Text[50])
        {
            CaptionML = ENU = 'Posting Description', ESP = 'Texto de registro';


        }
        field(6; "Shortcut Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(1));
            CaptionML = ENU = 'Shortcut Dimension 1 Code', ESP = 'C�d. dim. acceso dir. 1';
            CaptionClass = '1,2,1';


        }
        field(7; "Shortcut Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2));
            CaptionML = ENU = 'Shortcut Dimension 2 Code', ESP = 'C�d. dim. acceso dir. 2';
            CaptionClass = '1,2,2';


        }
        field(8; "Currency Code"; Code[10])
        {
            TableRelation = "Currency";
            CaptionML = ENU = 'Currency Code', ESP = 'C�d. divisa';
            Editable = false;


        }
        field(9; "Currency Factor"; Decimal)
        {
            CaptionML = ENU = 'Currency Factor', ESP = 'Factor divisa';
            DecimalPlaces = 0 : 15;
            MinValue = 0;


        }
        field(10; "Comment"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("QB Comment Line" WHERE("Document Type" = CONST("Measure Hist."),
                                                                                              "No." = FIELD("No.")));
            CaptionML = ENU = 'Comment', ESP = 'Comentario';
            Editable = false;


        }
        field(16; "Service Date"; Date)
        {
            CaptionML = ENU = 'Service Date', ESP = 'Fecha del Servicio';
            Description = 'Q16212';


        }
        field(17; "Ext order service"; Code[10])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Ext order service', ESP = 'N� de pedido de servicio externo';
            Description = 'Q16212';


        }
        field(19; "Text Ext order service"; Text[30])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Text Ext order service', ESP = 'Texto pedido de servicio externo';
            Description = 'Q16212';


        }
        field(20; "Job No."; Code[20])
        {
            TableRelation = "Job";
            CaptionML = ENU = 'Job No.', ESP = 'N� proyecto';


        }
        field(21; "Customer No."; Code[20])
        {
            TableRelation = "Customer";
            CaptionML = ENU = 'Customer No.', ESP = 'N�  cliente';


        }
        field(23; "Name"; Text[50])
        {
            CaptionML = ENU = 'Name', ESP = 'Nombre';
            Editable = false;


        }
        field(24; "Address"; Text[50])
        {
            CaptionML = ENU = 'Address', ESP = 'Direcci�n';
            Editable = false;


        }
        field(25; "Address 2"; Text[50])
        {
            CaptionML = ENU = 'Address 2', ESP = 'Direcci�n 2';
            Editable = false;


        }
        field(26; "City"; Text[50])
        {
            CaptionML = ENU = 'City', ESP = 'Poblaci�n';
            Editable = false;


        }
        field(27; "Contact"; Text[50])
        {
            CaptionML = ENU = 'Contact', ESP = 'Contacto';
            Editable = false;


        }
        field(28; "County"; Text[50])
        {
            CaptionML = ENU = 'County', ESP = 'Provincia';
            Editable = false;


        }
        field(29; "Post Code"; Code[20])
        {
            CaptionML = ENU = 'Post Code', ESP = 'C.P.';
            Editable = false;


        }
        field(30; "Country Code"; Code[10])
        {
            TableRelation = "Country/Region";
            CaptionML = ENU = 'Country Code', ESP = 'C�d. Pa�s';
            Editable = false;


        }
        field(31; "Name 2"; Text[50])
        {
            CaptionML = ENU = 'Name 2', ESP = 'Nombre 2';
            Editable = false;


        }
        field(35; "Responsibility Center"; Code[10])
        {
            TableRelation = "Responsibility Center";
            CaptionML = ENU = 'Responsibility Center', ESP = 'Centro Responsabilidad';


        }
        field(39; "Dimension Set ID"; Integer)
        {
            TableRelation = "Dimension Set Entry";


            CaptionML = ENU = 'Dimension Set ID', ESP = 'Id. grupo dimensiones';
            Editable = false;

            trigger OnLookup();
            BEGIN
                ShowDimensions;
            END;


        }
        field(44; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'No. Series', ESP = 'N� serie';
            Editable = false;


        }
        field(45; "Posting No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Posting No. Series', ESP = 'N� serie registro';


        }
        field(46; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
            CaptionML = ENU = 'Date Filter', ESP = 'Filtro fecha';


        }
        field(48; "Invoicing Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Invoicing Date', ESP = 'Fecha facturacion';
            Description = 'Q16212';


        }
        field(51; "Bill-to No. Customer"; Code[20])
        {
            TableRelation = "Customer";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Bill-to No. Customer', ESP = 'Factura a N� cliente';


        }
        field(52; "Cod. Payment Terms"; Code[10])
        {
            TableRelation = "Payment Terms";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Cod. terminos pago', ESP = 'C�d. t�rminos pago';


        }
        field(53; "Due Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Due Date', ESP = 'Fecha vencimiento';


        }
        field(54; "% Payment Discount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = '% Payment Discount', ESP = '% Dto. P.P.';


        }
        field(55; "Payment Method Code"; Code[10])
        {
            TableRelation = "Payment Method";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Cod. forma pago', ESP = 'C�d. forma pago';


        }
        field(56; "Payment In-Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Payment In-Code', ESP = 'Pago en-C�digo';


        }
        field(57; "Customer Bank Code"; Code[20])
        {
            TableRelation = "Customer Bank Account"."Code" WHERE("Customer No." = FIELD("Bill-to No. Customer"));
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Customer Bank Code', ESP = 'C�d. banco cliente';


        }
        field(50000; "Expenses/Investment"; Option)
        {
            OptionMembers = "Expenses","Investment","Emergencies";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Expenses/Investment', ESP = 'Gastos/Inversi�n';
            OptionCaptionML = ENU = 'Expenses,Investment,Emergencies', ESP = 'Gastos,Inversi�n,Urgencia';

            Description = 'Q5609';


        }
        field(50001; "Service Order Type"; Code[10])
        {
            TableRelation = "Service Order Type";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Service Order Type', ESP = 'Tipo pedido servicio';
            Description = 'Q5767';


        }
        field(50002; "Total Cost"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("QB Posted Service Order Lines"."Cost Amount" WHERE("Document No." = FIELD("No.")));
            CaptionML = ENU = 'Total Cost', ESP = 'Coste total';
            Description = 'Q5769';


        }
        field(50003; "Base"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("QB Posted Service Order Lines"."Sale Amount" WHERE("Document No." = FIELD("No.")));
            CaptionML = ENU = 'Base', ESP = 'Base';
            Description = 'Q5769';


        }
        field(50004; "Status"; Option)
        {
            OptionMembers = "Pending","In Process","Finished","On Hold","Invoiced";

            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Status', ESP = 'Estado';
            OptionCaptionML = ENU = 'Pending,In Process,Finished,On Hold,Invoiced', ESP = 'Pendiente,En proceso,Terminado,En espera,Facturado';

            Description = 'Q5870';

            trigger OnValidate();
            VAR
                //                                                                 JobQueueEntry@1000 :
                JobQueueEntry: Record 472;
                //                                                                 RepairStatus@1001 :
                RepairStatus: Record 5927;
            BEGIN
            END;


        }
        field(50008; "Grouping Criteria"; Code[20])
        {
            TableRelation = "QB Grouping Criteria";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Grouping Criteria', ESP = 'Criterios de agrupaci�n';
            Description = 'Q5611';


        }
        field(50010; "Failure Caused By"; Text[200])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Failure Caused By', ESP = 'Aver�a causada por';
            Description = 'Q5614';


        }
        field(50011; "Failiure Company"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Company', ESP = 'Empresa';
            Description = 'Q5614';


        }
        field(50012; "Failiure Phone No."; Text[30])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Phone No.', ESP = 'Tel�fono';
            Description = 'Q5614';


        }
        field(50013; "Failiure Address"; Text[75])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Address', ESP = 'Domicilio';
            Description = 'Q5614';


        }
        field(50014; "Company Failure Maker"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Company Failure Maker', ESP = 'Empresa que produjo la rotura';
            Description = 'Q5614';


        }
        field(50015; "Working Company"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Working Company', ESP = 'Empresa para la que trabaja';
            Description = 'Q5614';


        }
        field(50016; "Instaled Service"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Instaled Service', ESP = 'Servicio instalado';
            Description = 'Q5614';


        }
        field(50017; "Failiure Cause"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Failiure Cause', ESP = 'Causa de la rotura';
            Description = 'Q5614';


        }
        field(50019; "Contract No."; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Contract No.', ESP = 'N� contrato';
            Description = 'QIN';


        }
        field(50020; "Operation Result"; BLOB)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Operation Result', ESP = 'Resultado operaci�n';


        }
        field(50050; "Invoice Generated"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Invoiced', ESP = 'Facturado';


        }
        field(50051; "Pre-Assigned Invoice No."; Code[20])
        {
            TableRelation = "Sales Header"."No." WHERE("No." = FIELD("Pre-Assigned Invoice No."));
            CaptionML = ENU = 'Pre-Assigned Invoice No.', ESP = 'No. Factura preasignado';
            Description = 'QB 1.09.21';


        }
        field(50052; "Posted Invoice No."; Code[20])
        {
            TableRelation = "Sales Invoice Header"."No." WHERE("No." = FIELD("Posted Invoice No."));
            CaptionML = ENU = 'Posted Invoice No.', ESP = 'No. Factura Registrada';
            Description = 'QB 1.09.21';


        }
        field(50053; "Invoice Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Invoice Posting Date', ESP = 'Fecha Registro Factura';
            Description = 'QB 1.09.21';


        }
        field(50100; "Ship-to Code"; Code[10])
        {
            TableRelation = "Ship-to Address"."Code" WHERE("Customer No." = FIELD("Customer No."));


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Ship-to Code', ESP = 'C�d. direcci�n env�o cliente';
            Description = 'Q5767';

            trigger OnValidate();
            VAR
                //                                                                 ShipToAddr@1000 :
                ShipToAddr: Record 222;
                //                                                                 Cust@1100286000 :
                Cust: Record 18;
            BEGIN
            END;


        }
        field(50101; "Ship-to Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Ship-to Name', ESP = 'Nombre direcci�n de env�o';
            Description = 'Q5767';


        }
        field(50102; "Ship-to Name 2"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Ship-to Name 2', ESP = 'Nombre direcci�n de env�o 2';
            Description = 'Q5767';


        }
        field(50103; "Ship-to Address"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Ship-to Address', ESP = 'Direcci�n de env�o';
            Description = 'Q5767';


        }
        field(50104; "Ship-to Address 2"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Ship-to Address 2', ESP = 'Direcci�n de env�o 2';
            Description = 'Q5767';


        }
        field(50105; "Ship-to City"; Text[30])
        {
            TableRelation = IF ("Ship-to Country/Region Code" = CONST()) "Post Code".City ELSE IF ("Ship-to Country/Region Code" = FILTER(<> '')) "Post Code"."City" WHERE("Country/Region Code" = FIELD("Ship-to Country/Region Code"));


            ValidateTableRelation = false;
            //TestTableRelation=false;
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Ship-to City', ESP = 'Poblaci�n direcci�n de env�o';
            Description = 'Q5767';

            trigger OnValidate();
            VAR
                //                                                                 PostCode@1100286000 :
                PostCode: Record 225;
            BEGIN
            END;


        }
        field(50106; "Ship-to Contact"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Ship-to Contact', ESP = 'Contacto de direcci�n de env�o';
            Description = 'Q5767';


        }
        field(50107; "Location Code"; Code[10])
        {
            TableRelation = "Location";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Location Code', ESP = 'C�d. almac�n';
            Description = 'Q5767';


        }
        field(50108; "Ship-to Post Code"; Code[20])
        {
            TableRelation = IF ("Ship-to Country/Region Code" = CONST()) "Post Code" ELSE IF ("Ship-to Country/Region Code" = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD("Ship-to Country/Region Code"));


            ValidateTableRelation = false;
            //TestTableRelation=false;
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Ship-to Post Code', ESP = 'C.P. direcci�n de env�o';
            Description = 'Q5767';

            trigger OnValidate();
            VAR
                //                                                                 PostCode@1100286000 :
                PostCode: Record 225;
            BEGIN
            END;


        }
        field(50109; "Ship-to County"; Text[30])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Ship-to County', ESP = 'Provincia direcci�n de env�o';
            Description = 'Q5767';


        }
        field(50110; "Ship-to Country/Region Code"; Code[10])
        {
            TableRelation = "Country/Region";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Ship-to Country/Region Code', ESP = 'C�d. pa�s/regi�n direcci�n de env�o';
            Description = 'Q5767';


        }
        field(50111; "Shipping Agent Code"; Code[10])
        {
            TableRelation = "Shipping Agent";
            AccessByPermission = TableData 5790 = R;
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Shipping Agent Code', ESP = 'C�d. transportista';
            Description = 'Q5767';


        }
        field(50112; "Shipping Advice"; Option)
        {
            OptionMembers = "Partial","Complete";

            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Shipping Advice', ESP = 'Aviso env�o';
            OptionCaptionML = ENU = 'Partial,Complete', ESP = 'Parcial,Completo';

            Description = 'Q5767';

            trigger OnValidate();
            VAR
                //                                                                 WhseValidateSourceHeader@1000 :
                WhseValidateSourceHeader: Codeunit 5781;
            BEGIN
            END;


        }
        field(50113; "Shipping Time"; DateFormula)
        {
            AccessByPermission = TableData 5790 = R;
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Shipping Time', ESP = 'Tiempo env�o';
            Description = 'Q5767';


        }
        field(50114; "Shipping Agent Service Code"; Code[10])
        {
            TableRelation = "Shipping Agent Services"."Code" WHERE("Shipping Agent Code" = FIELD("Shipping Agent Code"));
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Shipping Agent Service Code', ESP = 'C�d. servicio transportista';
            Description = 'Q5767';


        }
        field(50115; "Ship-to Fax No."; Text[30])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Ship-to Fax No.', ESP = 'N� fax direcci�n de env�o';
            Description = 'Q5767';


        }
        field(50116; "Ship-to E-Mail"; Text[80])
        {


            ExtendedDatatype = EMail;
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Ship-to Email', ESP = 'Correo electr�nico direcci�n de env�o';
            Description = 'Q5767';

            trigger OnValidate();
            VAR
                //                                                                 MailManagement@1000 :
                MailManagement: Codeunit 9520;
            BEGIN
            END;


        }
        field(50117; "Ship-to Phone"; Text[30])
        {
            ExtendedDatatype = PhoneNo;
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Ship-to Phone', ESP = 'Tel�fono de direcci�n de env�o';
            Description = 'Q5767';


        }
        field(50118; "Ship-to Phone 2"; Text[30])
        {
            ExtendedDatatype = PhoneNo;
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Ship-to Phone 2', ESP = 'Tel�fono 2 direcci�n de env�o';
            Description = 'Q5767';


        }
        field(50119; "Shipment Method Code"; Code[10])
        {
            TableRelation = "Shipment Method";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Shipment Method Code', ESP = 'C�d. condiciones env�o';
            Description = 'Q5767';


        }
        field(50120; "Price review"; Boolean)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Price review', ESP = 'Revision precios';
            Description = 'Q12733, Marcamos si esta medici�n esta sujeta de revisi�n de precios';

            trigger OnValidate();
            VAR
                //                                                                 lrPriceReview@100000000 :
                lrPriceReview: Record 7206965;
                //                                                                 errNoPriceReview@100000001 :
                errNoPriceReview: TextConst ENU = 'There is no price review for the job %1.', ESP = 'No hay ninguna revisi�n de precios para el proyecto %1.';
                //                                                                 lPriceReviewList@100000002 :
                lPriceReviewList: Page 7207053;
                //                                                                 errSelectCode@100000003 :
                errSelectCode: TextConst ENU = 'You must select a price review code.', ESP = 'Debe seleccionar un codigo de revisi�n de precios.';
            BEGIN
            END;


        }
        field(50121; "Price review code"; Code[10])
        {
            TableRelation = "QB Price x job review"."Review code" WHERE("Job No." = FIELD("Job No."));
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Price review code', ESP = 'Cod. Revision precios';
            Description = 'Q12733, Especifica el c�digo que aplica a este medici�n';


        }
        field(50122; "Price review percentage"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Price review percentage', ESP = 'Porcentaje revision precios';
            Description = 'Q12733, Traemos el porcentaje del c�digo de revision';


        }
    }
    keys
    {
        key(key1; "No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       UserSetupManagement@7001100 :
        UserSetupManagement: Codeunit 5700;
        //       HasGotSalesUserSetup@7001101 :
        HasGotSalesUserSetup: Boolean;
        //       UserRespCenter@7001102 :
        UserRespCenter: Code[20];
        //       DimensionManagement@7001103 :
        DimensionManagement: Codeunit "DimensionManagement";
        //       HistMeasureLines@7001104 :
        HistMeasureLines: Record 7207339;
        //       QBCommentLine@7001105 :
        QBCommentLine: Record 7207270;
        //       Text027@7001106 :
        Text027: TextConst ENU = 'Your identification is set up to process from %1 %2 only.', ESP = 'Su identificaci�n est� configurada para procesar s�lo desde %1 %2.';
        //       ResponsibilityCenter@7001107 :
        ResponsibilityCenter: Record 5714;
        //       UserManagement@7001108 :
        UserManagement: Codeunit 418;



    trigger OnDelete();
    begin
        LOCKTABLE;

        HistMeasureLines.RESET;
        HistMeasureLines.SETRANGE("Document No.", "No.");
        HistMeasureLines.DELETEALL(TRUE);

        QBCommentLine.SETRANGE("No.", "No.");
        QBCommentLine.DELETEALL;
    end;



    procedure Navigate()
    var
        //       NavigatePage@1000 :
        NavigatePage: Page "Navigate";
    begin
        //NavigatePage.SetDoc("Posting Date","No.");
        NavigatePage.SetDoc("Invoice Posting Date", "Posted Invoice No.");
        NavigatePage.RUN;
    end;

    //     procedure FilterResponsability (var HistMeasurements@1000000000 :
    procedure FilterResponsability(var HistMeasurements: Record 7206968)
    begin
    end;

    procedure ShowDimensions()
    begin
        DimensionManagement.ShowDimensionSet("Dimension Set ID", STRSUBSTNO('%1 %2', TABLECAPTION, "No."));
    end;

    procedure FSR()
    begin
    end;


    //     procedure SetOperationResult (NewWorkDescription@1000 :
    procedure SetOperationResult(NewWorkDescription: Text)
    var
        //       TempBlob@1001 :
        TempBlob: Codeunit "Temp Blob";
        Blob: OutStream;
        InStr: InStream;
    begin
        CLEAR("Operation Result");
        if NewWorkDescription = '' then
            exit;
        // TempBlob.Blob := "Operation Result";
        /*To be tested*/

        TempBlob.CreateOutStream(Blob, TextEncoding::Windows);
        Blob.Write("Operation Result");
        // TempBlob.WriteAsText(NewWorkDescription, TEXTENCODING::Windows);
        /*To be tested*/

        TempBlob.CreateOutStream(Blob, TextEncoding::Windows);
        Blob.Write(NewWorkDescription);
        // "Operation Result" := TempBlob.Blob;
        /*To be tested*/

        TempBlob.CreateInStream(InStr, TextEncoding::Windows);
        InStr.Read("Operation Result");
        MODIFY;
    end;


    procedure GetOperationResult(): Text;
    var
        //       TempBlob@1000 :
        TempBlob: Codeunit "Temp Blob";
        Blob: OutStream;
        InStr: InStream;
        //       CR@1004 :
        CR: Text[1];
    begin
        CALCFIELDS("Operation Result");
        if not "Operation Result".HASVALUE then
            exit('');
        CR[1] := 10;
        // TempBlob.Blob := "Operation Result";
        /*To be tested*/

        TempBlob.CreateOutStream(Blob, TextEncoding::Windows);
        Blob.Write("Operation Result");
        // exit(TempBlob.ReadAsText(CR, TEXTENCODING::Windows)) ;
        /*To be tested*/

        TempBlob.CreateInStream(InStr, TextEncoding::Windows);
        InStr.Read(CR);
        exit(CR);
    end;

    /*begin
    end.
  */
}







