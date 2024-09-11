tableextension 50113 "MyExtension50113" extends "Sales Header"
{

    DataCaptionFields = "No.", "Sell-to Customer Name";
    CaptionML = ENU = 'Sales Header', ESP = 'Cab. venta';
    LookupPageID = "Sales List";

    fields
    {
        field(50000; "From Several Customers"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'From Several Customers', ESP = 'Desde clientes varios';
            Description = 'Q19196';
            Editable = false;


        }
        field(50002; "G.E.W. mod."; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("Sales Line" WHERE("Document Type" = FIELD("Document Type"),
                                                                                         "Document No." = FIELD("No."),
                                                                                         "G.E.W. mod." = CONST(true)));
            CaptionML = ENU = 'G.E.W. mod.', ESP = 'Ret. B.E. modificada';
            Description = 'BS::20668';
            Editable = false;


        }
        field(50003; "Certification Period"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Certification Period', ESP = 'Periodo certificaci�n';
            Description = 'BS::21212';


        }
        field(50035; "Price review percentage"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Price review percentage', ESP = 'Porcentaje revision precios';
            Description = 'Q12733';


        }
        field(50036; "IPC/Rev aplicado"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'IPC/Rev aplicado', ESP = 'IPC/Rev aplicado';
            Description = 'Q12733';


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
                //                                                                 pgPriceReviewList@100000002 :
                pgPriceReviewList: Page 7207053;
                //                                                                 errSelectCode@100000003 :
                errSelectCode: TextConst ENU = 'You must select a price review code.', ESP = 'Debe seleccionar un codigo de revisi�n de precios.';
                //                                                                 errReviewApplied@100000004 :
                errReviewApplied: TextConst ENU = 'The price review has been applied.', ESP = 'La revisi�n de precios ya ha sido aplicada.';
            BEGIN
                IF "IPC/Rev aplicado" THEN
                    ERROR(errReviewApplied);

                //. Si el proyecto no tiene ning�n c�digo de revisi�n, no dejamos marcar este campo
                IF "Price review" THEN BEGIN
                    lrPriceReview.FILTERGROUP(2);
                    lrPriceReview.SETRANGE("Job No.", "QB Job No.");
                    lrPriceReview.FILTERGROUP(0);
                    IF (NOT lrPriceReview.FINDFIRST) THEN
                        ERROR(errNoPriceReview, "QB Job No.");

                    IF (lrPriceReview.COUNT > 1) THEN BEGIN
                        //Si existen varias revisiones hacemos que el usuario escoja una, si no usar� la �nica existente
                        CLEAR(pgPriceReviewList);
                        pgPriceReviewList.SETTABLEVIEW(lrPriceReview);
                        pgPriceReviewList.LOOKUPMODE(TRUE);
                        pgPriceReviewList.EDITABLE(FALSE);
                        IF pgPriceReviewList.RUNMODAL <> ACTION::LookupOK THEN
                            ERROR(errSelectCode);
                        pgPriceReviewList.GETRECORD(lrPriceReview);
                    END;

                    VALIDATE("Price review code", lrPriceReview."Review code");
                    VALIDATE("Price review percentage", lrPriceReview.Percentage);
                END ELSE BEGIN
                    VALIDATE("Price review code", '');
                    VALIDATE("Price review percentage", 0);
                END;
            END;


        }
        field(50121; "Price review code"; Code[10])
        {
            TableRelation = "QB Price x job review"."Review code" WHERE("Job No." = FIELD("QB Job No."));
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Price review code', ESP = 'Cod. Revision precios';
            Description = 'Q12733, Especifica el c�digo que aplica a este medici�n';


        }
        field(7174331; "QuoSII Entity"; Code[20])
        {
            TableRelation = "SII Type List Value"."Code" WHERE("Type" = CONST("SIIEntity"),
                                                                                                   "SII Entity" = CONST(''));


            CaptionML = ENU = 'SII Entity', ESP = 'Entidad SII';
            Description = 'QuoSII_1.4.2.042';

            trigger OnValidate();
            BEGIN
                //JAV 11/05/22: - QuoSII 1.06.07 Se traspasa la funcionalidad a la cu 7174332 SII Procesing para unificar
            END;


        }
        field(7174332; "QuoSII Sales Invoice Type"; Code[20])
        {
            TableRelation = "SII Type List Value"."Code" WHERE("Type" = CONST("SalesInvType"),
                                                                                                   "SII Entity" = FIELD("QuoSII Entity"),
                                                                                                   "Code" = FILTER(<> 'R*'));
            CaptionML = ENU = 'Invoice Type', ESP = 'Tipo Factura';
            Description = 'QuoSII';


        }
        field(7174333; "QuoSII Sales Cor. Invoice Type"; Code[20])
        {
            TableRelation = "SII Type List Value"."Code" WHERE("Type" = CONST("SalesInvType"),
                                                                                                   "SII Entity" = FIELD("QuoSII Entity"),
                                                                                                   "Code" = FILTER('R*'));
            CaptionML = ENU = 'Corrected Invoice Type', ESP = 'Tipo Factura Rectificativa';
            Description = 'QuoSII';


        }
        field(7174334; "QuoSII Sales Cr.Memo Type"; Code[20])
        {
            TableRelation = "SII Type List Value"."Code" WHERE("Type" = CONST("CorrectedInvType"),
                                                                                                   "SII Entity" = FIELD("QuoSII Entity"));


            CaptionML = ENU = 'Cr.Memo Type', ESP = 'Tipo Abono';
            Description = 'QuoSII';

            trigger OnValidate();
            BEGIN
                //JAV 11/05/22: - QuoSII 1.06.07 Se traspasa la funcionalidad a la cu 7174332 SII Procesing para unificar
            END;


        }
        field(7174335; "QuoSII Sales Special Regimen"; Code[20])
        {
            TableRelation = "SII Type List Value"."Code" WHERE("Type" = CONST("KeySpecialSalesInv"),
                                                                                                   "SII Entity" = FIELD("QuoSII Entity"));
            CaptionML = ENU = 'Special Regimen', ESP = 'R�gimen Especial';
            Description = 'QuoSII';


        }
        field(7174336; "QuoSII Sales Special Regimen 1"; Code[20])
        {
            TableRelation = IF ("QuoSII Sales Special Regimen" = FILTER(07)) "SII Type List Value"."Code" WHERE("Type" = CONST("KeySpecialSalesInv"), "SII Entity" = FIELD("QuoSII Entity"), "Code" = FILTER('01' | '03' | '05' | '09' | '11' | '12' | '13' | '14' | '15')) ELSE IF ("QuoSII Sales Special Regimen" = FILTER(05)) "SII Type List Value"."Code" WHERE("Type" = CONST("KeySpecialSalesInv"), "SII Entity" = FIELD("QuoSII Entity"), "Code" = FILTER('01' | '06' | '07' | '08' | '11' | '12' | '13')) ELSE IF ("QuoSII Sales Special Regimen" = FILTER(06)) "SII Type List Value"."Code" WHERE("Type" = CONST("KeySpecialSalesInv"), "SII Entity" = FIELD("QuoSII Entity"), "Code" = FILTER('05' | '11' | '12' | '13' | '14' | '15')) ELSE IF ("QuoSII Sales Special Regimen" = FILTER('11' | '12' | '13')) "SII Type List Value"."Code" WHERE("Type" = CONST("KeySpecialSalesInv"), "SII Entity" = FIELD("QuoSII Entity"), "Code" = FILTER('06' | '07' | '08' | '15')) ELSE IF ("QuoSII Sales Special Regimen" = FILTER(03)) "SII Type List Value"."Code" WHERE("Type" = CONST("KeySpecialSalesInv"), "SII Entity" = FIELD("QuoSII Entity"), "Code" = FILTER(01)) ELSE IF ("QuoSII Sales Special Regimen" = FILTER(01)) "SII Type List Value"."Code" WHERE("Type" = CONST("KeySpecialSalesInv"), "SII Entity" = FIELD("QuoSII Entity"), "Code" = FILTER('02' | '05' | '07' | '08'));
            CaptionML = ENU = 'Special Regimen 1', ESP = 'R�gimen Especial 1';
            Description = 'QuoSII';


        }
        field(7174337; "QuoSII Sales Special Regimen 2"; Code[20])
        {
            TableRelation = IF ("QuoSII Sales Special Regimen" = FILTER(07)) "SII Type List Value"."Code" WHERE("Type" = CONST("KeySpecialSalesInv"), "SII Entity" = FIELD("QuoSII Entity"), "Code" = FILTER('01' | '03' | '05' | '09' | '11' | '12' | '13' | '14' | '15')) ELSE IF ("QuoSII Sales Special Regimen" = FILTER(05)) "SII Type List Value"."Code" WHERE("Type" = CONST("KeySpecialSalesInv"), "SII Entity" = FIELD("QuoSII Entity"), "Code" = FILTER('01' | '06' | '07' | '08' | '11' | '12' | '13')) ELSE IF ("QuoSII Sales Special Regimen" = FILTER(06)) "SII Type List Value"."Code" WHERE("Type" = CONST("KeySpecialSalesInv"), "SII Entity" = FIELD("QuoSII Entity"), "Code" = FILTER('05' | '11' | '12' | '13' | '14' | '15')) ELSE IF ("QuoSII Sales Special Regimen" = FILTER('11' | '12' | '13')) "SII Type List Value"."Code" WHERE("Type" = CONST("KeySpecialSalesInv"), "SII Entity" = FIELD("QuoSII Entity"), "Code" = FILTER('06' | '07' | '08' | '15')) ELSE IF ("QuoSII Sales Special Regimen" = FILTER(03)) "SII Type List Value"."Code" WHERE("Type" = CONST("KeySpecialSalesInv"), "SII Entity" = FIELD("QuoSII Entity"), "Code" = FILTER(01)) ELSE IF ("QuoSII Sales Special Regimen" = FILTER(01)) "SII Type List Value"."Code" WHERE("Type" = CONST("KeySpecialSalesInv"), "SII Entity" = FIELD("QuoSII Entity"), "Code" = FILTER('02' | '05' | '07' | '08'));
            CaptionML = ENU = 'Special Regimen 2', ESP = 'R�gimen Especial 2';
            Description = 'QuoSII';


        }
        field(7174338; "QuoSII Sales UE Inv Type"; Code[20])
        {
            TableRelation = "SII Type List Value"."Code" WHERE("Type" = CONST("IntraType"),
                                                                                                   "SII Entity" = FIELD("QuoSII Entity"));
            CaptionML = ENU = 'Sales UE Inv Type', ESP = 'Tipo Factura IntraComunitaria';
            Description = 'QuoSII';


        }
        field(7174339; "QuoSII Bienes Description"; Text[40])
        {
            CaptionML = ENU = 'Bienes Description', ESP = 'Descripci�n Bienes';
            Description = 'QuoSII';


        }
        field(7174340; "QuoSII Operator Address"; Text[120])
        {
            CaptionML = ENU = 'Operator Address', ESP = 'Direcci�n Operador';
            Description = 'QuoSII';


        }
        field(7174341; "QuoSII Last Ticket No."; Code[20])
        {
            CaptionML = ENU = 'Last Ticket No.', ESP = '�ltimo N� Ticket';
            Description = 'QuoSII';


        }
        field(7174342; "QuoSII Third Party"; Boolean)
        {
            CaptionML = ENU = 'Third Party', ESP = 'Emitida por tercero';
            Description = 'QuoSII';


        }
        field(7174343; "QuoSII First Ticket No."; Code[20])
        {
            CaptionML = ENU = 'First Ticket No.', ESP = 'Primer N� Ticket';
            Description = 'QuoSII';


        }
        field(7174347; "QuoSII Exercise-Period"; Code[7])
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'SII Entity', ESP = 'Periodo Liquidaci�n';
            Description = 'QuoSII 1.5d   JAV 12/04/21 Ejercicio y Periodo en que se declara';
            Editable = false;

            trigger OnValidate();
            VAR
                //                                                                 QuoSII@7174331 :
                QuoSII: Integer;
                //                                                                 PurchaseLine@7174332 :
                PurchaseLine: Record 39;
                //                                                                 txtQuoSII000@1100286000 :
                txtQuoSII000: TextConst ESP = 'No se puede cambiar el campo %1 cuando existen l�neas.';
            BEGIN
            END;


        }
        field(7174348; "QuoSII Operation Date"; Date)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'SII Entity', ESP = 'Fecha operaci�n';
            Description = 'QuoSII 1.5d   JAV 12/04/21 Fecha de la operaci�n';
            Editable = false;

            trigger OnValidate();
            VAR
                //                                                                 QuoSII@7174331 :
                QuoSII: Integer;
                //                                                                 PurchaseLine@7174332 :
                PurchaseLine: Record 39;
                //                                                                 txtQuoSII000@1100286000 :
                txtQuoSII000: TextConst ESP = 'No se puede cambiar el campo %1 cuando existen l�neas.';
            BEGIN
            END;


        }
        field(7174365; "QFA Period Start Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Periodo de Facturaci�n Inicio';
            Description = 'QFA JAV 20/03/21 - Fecha de inicio del periodo de facturaci�n';


        }
        field(7174366; "QFA Period End Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Periodo de Facturaci�n Final';
            Description = 'QFA JAV 20/03/21 - Fecha de fin del periodo de facturaci�n';


        }
        field(7207270; "QW Cod. Withholding by GE"; Code[20])
        {
            TableRelation = "Withholding Group"."Code" WHERE("Withholding Type" = FILTER("G.E"),
                                                                                                 "Use in" = FILTER('Booth' | 'Customer'));
            CaptionML = ENU = 'Cod. Wittholding by G.E.', ESP = 'C�d. retenci�n por B.E.';
            Description = 'QB 1.00 - QB22111';


        }
        field(7207271; "QW Cod. Withholding by PIT"; Code[20])
        {
            TableRelation = "Withholding Group"."Code" WHERE("Withholding Type" = FILTER("PIT"),
                                                                                                 "Use in" = FILTER('Booth' | 'Customer'));
            CaptionML = ENU = 'Cod. Withholding by PIT', ESP = 'C�d. retenci�n por IRPF';
            Description = 'QB 1.00 - QB22111';


        }
        field(7207272; "QW Total Withholding GE"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Sales Line"."QW Withholding Amount by GE" WHERE("Document Type" = FIELD("Document Type"),
                                                                                                                     "Document No." = FIELD("No.")));
            CaptionML = ENU = 'Total Withholding G.E', ESP = 'Total retenci�n B.E.';
            Description = 'QB 1.00 - QB22111';
            Editable = false;


        }
        field(7207273; "QW Total Withholding PIT"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Sales Line"."QW Withholding Amount by PIT" WHERE("Document Type" = FIELD("Document Type"),
                                                                                                                      "Document No." = FIELD("No.")));
            CaptionML = ENU = 'Total retencion IRPF', ESP = 'Total retenci�n IRPF';
            Description = 'QB 1.00 - QB22111';
            Editable = false;


        }
        field(7207275; "QB Job No."; Code[20])
        {
            TableRelation = "Job";
            CaptionML = ENU = 'Job No.', ESP = 'No. proyecto';
            Description = 'QB 1.00 - QB2412';


        }
        field(7207276; "QB Job Sale Doc. Type"; Option)
        {
            OptionMembers = "Standar","Equipament Advance","Advance by Store","Price Review";
            CaptionML = ENU = 'Job Sale Doc. Type', ESP = 'Tipo doc. venta proyecto';
            OptionCaptionML = ENU = 'Standar,Equipament Advance,Advance by Store,Price Review', ESP = 'Estandar,Anticipo de maquinaria,Anticipo por acopios,Revisi�n precios';

            Description = 'QB 1.00 - QB28123';


        }
        field(7207279; "QB Payment Bank No."; Code[20])
        {
            TableRelation = "Bank Account"."No.";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Payment Bank No.', ESP = 'N� de banco de cobro';
            Description = 'QB 1.8.38 JAV 12/04/21 estaba mal numerado respeco al hist�rico, se cambia el n�mero aqu� para no afectar al hist�rico';


        }
        field(7207280; "QB Operation date SII"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Fecha operaci�n SII';
            Description = 'QB 1.0 - QB5555 JAV 04/07/19: Fecha de operaci�n para el SII';


        }
        field(7207282; "QW Withholding mov liq."; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Liquida mov. retenci�n n�';
            Description = 'QB 1.04 - JAV 26/05/20: Que movimiento de retenci�n de garant�a liquida esta factura';


        }
        field(7207283; "QB Prepayment Use"; Option)
        {
            OptionMembers = "No","Prepayment","Application","DontProcess";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Uso del anticipo';
            OptionCaptionML = ENU = 'No,Prepayment,Application,Dont Process', ESP = 'No,Anticipo,Aplicaci�n,No Procesar';

            Description = 'QB 1,06 - Si es un anticipo de proyecto';


        }
        field(7207284; "QB Prepayment Pending"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("QB Prepayment"."Amount" WHERE("Job No." = FIELD("QB Job No."),
                                                                                                 "Account Type" = CONST("Customer"),
                                                                                                 "Account No." = FIELD("Sell-to Customer No."),
                                                                                                 "Currency Code" = FIELD("Currency Code")));
            CaptionML = ESP = 'Anticipo Pendiente';
            Description = 'QB 1,06 - Importe del anticipo pendiente';
            Editable = false;


        }
        field(7207285; "QB Prepayment Apply"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Descontar Anticipo';
            Description = 'QB 1,06 - Importe del anticipo a descontar';

            trigger OnValidate();
            VAR
                //                                                                 QBPrepayments@1100286000 :
                QBPrepayments: Codeunit 7207300;
                //                                                                 txtQB000@1100286001 :
                txtQB000: TextConst ENU = 'The amount of the prepayment cannot exceed the pending.', ESP = 'El importe del anticipo no puede ser superior al pendiente.';
            BEGIN
                CALCFIELDS("QB Prepayment Pending");
                IF ("QB Prepayment Apply" > "QB Prepayment Pending") THEN
                    ERROR(txtQB000);

                IF ("QB Prepayment Apply" = 0) THEN
                    "QB Prepayment Use" := "QB Prepayment Use"::No
                ELSE
                    "QB Prepayment Use" := "QB Prepayment Use"::Application;

                QBPrepayments.CreatePrepayment_SalesLines(Rec); //A�adir la l�nea del prepago
            END;


        }
        field(7207287; "QB Prepayment Type"; Option)
        {
            OptionMembers = "No","Invoice","Bill";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Prepayment Type', ESP = 'Tipo de Prepago';
            OptionCaptionML = ENU = 'No,Invoice,Bill', ESP = 'No,Factura,Pago';

            Description = 'QB 1.08.43 - Tipo de prepago a generar';


        }
        field(7207289; "QB Prepayment Data"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Datos del Anticipo Aplicado';
            Description = 'QB 1.10.49 JAV 13/06/22: [TT] Indica el c�digo de los datos aplicados del anticipo al documento';


        }
        field(7207291; "QB Do not send to SII"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'No subir al SII';
            Description = 'QB 1.04 - JAV 28/05/20: - Este documento no subir� autom�ticamente al SII de MS';


        }
        field(7207296; "QW Base Withholding GE"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Sales Line"."QW Base Withholding by GE" WHERE("Document Type" = FIELD("Document Type"),
                                                                                                                   "Document No." = FIELD("No.")));
            CaptionML = ENU = 'Total Withholding G.E', ESP = 'Base retenci�n B.E.';
            Description = 'QB 1.00 - QB22111';
            Editable = false;


        }
        field(7207297; "QW Base Withholding PIT"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Sales Line"."QW Base Withholding by PIT" WHERE("Document Type" = FIELD("Document Type"),
                                                                                                                    "Document No." = FIELD("No.")));
            CaptionML = ENU = 'Total Withholding PIT', ESP = 'Base retenci�n IRPF';
            Description = 'QB 1.00 - QB22111';
            Editable = false;


        }
        field(7207298; "QW Total Withholding GE Before"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Sales Line"."Amount" WHERE("Document Type" = FIELD("Document Type"),
                                                                                              "Document No." = FIELD("No."),
                                                                                              "QW Withholding by GE Line" = CONST(true)));
            CaptionML = ENU = 'Total Withholding G.E', ESP = 'Total retenci�n B.E. Fra.';
            Description = 'QB 1.00 - JAV 23/10/19: - Se doblan los campos de la retenci�n de B.E. para tener ambos importes disponibles';
            Editable = false;


        }
        field(7207306; "QB SII Year-Month"; Text[7])
        {


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'SII Ejercicio-Periodo';
            Description = 'QB 1.05 - JAV Ejercicio y periodo en que se declar� en el SII de Microsoft';
            Editable = false;

            trigger OnValidate();
            BEGIN
                //Q19433-
                IF Rec."Posting Date" <> 0D THEN
                    //Q19433+
                    "QB SII Year-Month" := FORMAT(DATE2DMY(Rec."Posting Date", 3)) + '-' + FORMAT(Rec."Posting Date", 0, '<Month,2>');
            END;


        }
        field(7207307; "QB Certification code"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Certification code', ESP = 'C�d. certificaci�n';
            Description = 'QB 1.06 - Nro de la certificaci�n generada';


        }
        field(7207313; "QW Witholding Due Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Fecha Vto. Retenci�n';
            Description = 'QB 1.06.07 - JAV 30/07/20: - Fecha de vencimiento de la retenci�n de buena ejecuci�n';


        }
        field(7238177; "QB Budget item"; Code[20])
        {
            TableRelation = "Data Piecework For Production"."Piecework Code" WHERE("Job No." = FIELD("QB Job No."),
                                                                                                                         "Account Type" = FILTER("Unit"));
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Partida Presupuestaria';
            Description = 'QPR';


        }
    }
    keys
    {
        // key(key1;"Document Type","No.")
        //  {
        /* Clustered=true;
  */
        // }
        // key(key2;"No.","Document Type")
        //  {
        /* ;
  */
        // }
        // key(key3;"Document Type","Sell-to Customer No.")
        //  {
        /* ;
  */
        // }
        // key(key4;"Document Type","Bill-to Customer No.")
        //  {
        /* ;
  */
        // }
        // key(key5;"Document Type","Combine Shipments","Bill-to Customer No.","Currency Code","EU 3-Party Trade","Dimension Set ID")
        //  {
        /* ;
  */
        // }
        // key(key6;"Sell-to Customer No.","External Document No.")
        //  {
        /* ;
  */
        // }
        // key(key7;"Document Type","Sell-to Contact No.")
        //  {
        /* ;
  */
        // }
        // key(key8;"Bill-to Contact No.")
        //  {
        /* ;
  */
        // }
        // key(key9;"Incoming Document Entry No.")
        //  {
        /* ;
  */
        // }
        // key(key10;"Document Date")
        //  {
        /* ;
  */
        // }
    }
    fieldgroups
    {
        // fieldgroup(Brick;"No.","Sell-to Customer Name","Amount","Sell-to Contact","Amount Including VAT")
        // {
        // 
        // }
    }

    var
        //       Text003@1003 :
        Text003: TextConst ENU = 'You cannot rename a %1.', ESP = 'No se puede cambiar el nombre a %1.';
        //       ConfirmChangeQst@1004 :
        ConfirmChangeQst:
// "%1 = a Field Caption like Currency Code"
TextConst ENU = 'Do you want to change %1?', ESP = '�Confirma que desea cambiar %1?';
        //       Text005@1005 :
        Text005: TextConst ENU = 'You cannot reset %1 because the document still has one or more lines.', ESP = 'No se puede modificar %1 ya que el documento tiene una o m�s l�neas.';
        //       Text006@1006 :
        Text006: TextConst ENU = 'You cannot change %1 because the order is associated with one or more purchase orders.', ESP = 'No se puede cambiar %1 porque el pedido est� asociado a pedidos de compra.';
        //       Text007@1007 :
        Text007: TextConst ENU = '%1 cannot be greater than %2 in the %3 table.', ESP = 'En la tabla %3, %1 no puede ser mayor que %2.';
        //       Text009@1009 :
        Text009: TextConst ENU = 'Deleting this document will cause a gap in the number series for shipments. An empty shipment %1 will be created to fill this gap in the number series.\\Do you want to continue?', ESP = 'Si elimina el documento, se provocar� una discontinuidad en la numeraci�n de la serie de albaranes. Un env�o dev. vac�o %1 se crear� para llenar este error en las series num�ricas.\\�Desea continuar?';
        //       Text012@1012 :
        Text012: TextConst ENU = 'Deleting this document will cause a gap in the number series for posted invoices. An empty posted invoice %1 will be created to fill this gap in the number series.\\Do you want to continue?', ESP = 'Si elimina el documento se provocar� una discontinuidad en la numeraci�n de la serie de facturas registradas. Se crear� una factura registrada en blanco %1 para completar este error en las series num�ricas.\\�Desea continuar?';
        //       Text014@1014 :
        Text014: TextConst ENU = 'Deleting this document will cause a gap in the number series for posted credit memos. An empty posted credit memo %1 will be created to fill this gap in the number series.\\Do you want to continue?', ESP = 'Si elimina el documento, se provocar� una discontinuidad en la serie num�rica de abonos registrados. Se crear� un abono registrado en blanco %1 para completar este error en las series num�ricas.\\�Desea continuar?';
        //       RecreateSalesLinesMsg@1015 :
        RecreateSalesLinesMsg:
// %1: FieldCaption
TextConst ENU = 'if you change %1, the existing sales lines will be deleted and new sales lines based on the new information on the header will be created.\\Do you want to continue?', ESP = 'Si cambia %1, se eliminar�n las l�neas de venta actuales y se crear�n l�neas de venta nuevas basadas en la informaci�n nueva de la cabecera.\\�Desea continuar?';
        //       ResetItemChargeAssignMsg@1075 :
        ResetItemChargeAssignMsg:
// %1: FieldCaption
TextConst ENU = 'if you change %1, the existing sales lines will be deleted and new sales lines based on the new information on the header will be created.\The amount of the item charge assignment will be reset to 0.\\Do you want to continue?', ESP = 'Si cambia %1, se eliminar�n las l�neas de venta actuales y se crear�n l�neas de venta nuevas basadas en la informaci�n nueva de la cabecera.\El importe de la asignaci�n del cargo del producto se pondr� a 0.\\�Desea continuar?';
        //       Text017@1017 :
        Text017: TextConst ENU = 'You must delete the existing sales lines before you can change %1.', ESP = 'Se deben eliminar las l�neas de venta existentes antes de cambiar %1.';
        //       LinesNotUpdatedMsg@1018 :
        LinesNotUpdatedMsg:
// You have changed Order Date on the sales header, but it has not been changed on the existing sales lines.
TextConst ENU = 'You have changed %1 on the sales header, but it has not been changed on the existing sales lines.', ESP = 'Se ha modificado %1 en cab. ventas, pero no se ha modificado en las l�neas de venta.';
        //       Text019@1019 :
        Text019: TextConst ENU = 'You must update the existing sales lines manually.', ESP = 'Debe actualizar las l�neas de venta existentes manualmente.';
        //       AffectExchangeRateMsg@1020 :
        AffectExchangeRateMsg: TextConst ENU = 'The change may affect the exchange rate that is used for price calculation on the sales lines.', ESP = 'El cambio puede afectar al tipo de cambio usado en el c�lculo de precio en las l�neas de vtas.';
        //       Text021@1021 :
        Text021: TextConst ENU = 'Do you want to update the exchange rate?', ESP = '�Confirma que desea modificar el tipo de cambio?';
        //       Text022@1022 :
        Text022: TextConst ENU = 'You cannot delete this document. Your identification is set up to process from %1 %2 only.', ESP = 'No puede borrar este documento. Su identificaci�n est� configurada s�lo para procesar %1 %2.';
        //       Text024@1024 :
        Text024: TextConst ENU = 'You have modified the %1 field. The recalculation of VAT may cause penny differences, so you must check the amounts afterward. Do you want to update the %2 field on the lines to reflect the new value of %1?', ESP = 'Ha modificado el campo %1. El nuevo c�lculo de IVA puede tener alguna diferencia, por lo que deber�a comprobar los importes. �Desea actualizar el campo %2 en la l�neas para reflejar el nuevo valor de %1?';
        //       Text027@1027 :
        Text027: TextConst ENU = 'Your identification is set up to process from %1 %2 only.', ESP = 'Su identificaci�n est� configurada para procesar s�lo desde %1 %2.';
        //       Text028@1028 :
        Text028: TextConst ENU = 'You cannot change the %1 when the %2 has been filled in.', ESP = 'No puede cambiar %1 despu�s de introducir datos en %2.';
        //       Text030@1030 :
        Text030: TextConst ENU = 'Deleting this document will cause a gap in the number series for return receipts. An empty return receipt %1 will be created to fill this gap in the number series.\\Do you want to continue?', ESP = 'Eliminar este documento causar� un error en la serie num�rica de las recep. devol. Se crear� una recep. devoluc. %1 para completar este error en las series num�ricas.\\�Desea continuar?';
        //       Text031@1031 :
        Text031:
// You have modified Shipment Date.\\Do you want to update the lines?
TextConst ENU = 'You have modified %1.\\Do you want to update the lines?', ESP = 'Ha modificado %1.\\�Desea actualizar las l�neas?';
        //       SalesSetup@1033 :
        SalesSetup: Record 311;
        //       GLSetup@1034 :
        GLSetup: Record 98;
        //       GLAcc@1035 :
        GLAcc: Record 15;
        //       SalesHeader@1036 :
        SalesHeader: Record 36;
        //       SalesLine@1037 :
        SalesLine: Record 37;
        //       CustLedgEntry@1038 :
        CustLedgEntry: Record 21;
        //       Cust@1039 :
        Cust: Record 18;
        //       PaymentTerms@1040 :
        PaymentTerms: Record 3;
        //       PaymentMethod@1041 :
        PaymentMethod: Record 289;
        //       CurrExchRate@1042 :
        CurrExchRate: Record 330;
        //       SalesCommentLine@1043 :
        SalesCommentLine: Record 44;
        //       PostCode@1045 :
        PostCode: Record 225;
        //       BankAcc@1046 :
        BankAcc: Record 270;
        //       SalesShptHeader@1047 :
        SalesShptHeader: Record 110;
        //       SalesInvHeader@1048 :
        SalesInvHeader: Record 112;
        //       SalesCrMemoHeader@1049 :
        SalesCrMemoHeader: Record 114;
        //       ReturnRcptHeader@1050 :
        ReturnRcptHeader: Record 6660;
        //       SalesInvHeaderPrepmt@1101 :
        SalesInvHeaderPrepmt: Record 112;
        //       SalesCrMemoHeaderPrepmt@1100 :
        SalesCrMemoHeaderPrepmt: Record 114;
        //       GenBusPostingGrp@1051 :
        GenBusPostingGrp: Record 250;
        //       RespCenter@1053 :
        RespCenter: Record 5714;
        //       InvtSetup@1054 :
        InvtSetup: Record 313;
        //       Location@1055 :
        Location: Record 14;
        //       WhseRequest@1056 :
        WhseRequest: Record 5765;
        //       ReservEntry@1001 :
        ReservEntry: Record 337;
        //       TempReservEntry@1000 :
        TempReservEntry: Record 337 TEMPORARY;
        //       CompanyInfo@1002 :
        CompanyInfo: Record 79;
        //       Salesperson@1932 :
        Salesperson: Record 13;
        //       UserSetupMgt@1058 :
        UserSetupMgt: Codeunit 5700;
        //       NoSeriesMgt@1059 :
        NoSeriesMgt: Codeunit 396;
        //       CustCheckCreditLimit@1060 :
        CustCheckCreditLimit: Codeunit 312;
        //       DimMgt@1065 :
        DimMgt: Codeunit 408;
        //       IdentityManagement@1010 :
        IdentityManagement: Codeunit 9801;
        //       ApprovalsMgmt@1082 :
        ApprovalsMgmt: Codeunit 1535;
        //       WhseSourceHeader@1073 :
        WhseSourceHeader: Codeunit 5781;
        //       SalesLineReserve@1066 :
        SalesLineReserve: Codeunit 99000832;
        //       PostingSetupMgt@1085 :
        PostingSetupMgt: Codeunit 48;
        //       CurrencyDate@1068 :
        CurrencyDate: Date;
        //       HideValidationDialog@1069 :
        HideValidationDialog: Boolean;
        //       Confirmed@1070 :
        Confirmed: Boolean;
        //       Text035@1076 :
        Text035: TextConst ENU = 'You cannot Release Quote or Make Order unless you specify a customer on the quote.\\Do you want to create customer(s) now?', ESP = 'No puede lanzar oferta � hacer pedido hasta que especifique un cliente en la oferta.\\�Quiere crear un cliente(s) ahora?';
        //       Text037@1078 :
        Text037: TextConst ENU = 'Contact %1 %2 is not related to customer %3.', ESP = 'Contacto %1 %2 no est� relacionado con el cliente %3.';
        //       Text038@1074 :
        Text038: TextConst ENU = 'Contact %1 %2 is related to a different company than customer %3.', ESP = 'Contacto %1 %2 est� relacionado con una empresa diferente al cliente %3.';
        //       Text039@1086 :
        Text039: TextConst ENU = 'Contact %1 %2 is not related to a customer.', ESP = 'Contacto %1 %2 no est� relacionado con un cliente.';
        //       Text040@1083 :
        Text040: TextConst ENU = 'A won opportunity is linked to this order.\It has to be changed to status Lost before the Order can be deleted.\Do you want to change the status for this opportunity now?', ESP = 'Se vincula una oportunidad ganada a este pedido.\Debe cambiar el estado a Perdida para poder eliminar el pedido.\�Desea cambiar el estado para esta oportunidad?';
        //       Text044@1088 :
        Text044: TextConst ENU = 'The status of the opportunity has not been changed. The program has aborted deleting the order.', ESP = 'No se ha cambiado el estado de la oportunidad. El programa ha anulado la eliminaci�n del pedido.';
        //       SkipSellToContact@1016 :
        SkipSellToContact: Boolean;
        //       SkipBillToContact@1025 :
        SkipBillToContact: Boolean;
        //       Text045@1081 :
        Text045: TextConst ENU = 'You can not change the %1 field because %2 %3 has %4 = %5 and the %6 has already been assigned %7 %8.', ESP = 'No puede cambiar el campo %1 porque %2 %3 tiene %4 = %5 y ya se ha asignado el %6 a %7 %8.';
        //       Text048@1091 :
        Text048: TextConst ENU = 'Sales quote %1 has already been assigned to opportunity %2. Would you like to reassign this quote?', ESP = 'La oferta de ventas %1 ya fue asignada a la oportunidad %2. �Desea volver a asignar la oferta?';
        //       Text049@1092 :
        Text049: TextConst ENU = 'The %1 field cannot be blank because this quote is linked to an opportunity.', ESP = 'El campo %1 no puede estar vac�o porque la oferta est� asociada a una oportunidad.';
        //       InsertMode@1093 :
        InsertMode: Boolean;
        //       HideCreditCheckDialogue@1097 :
        HideCreditCheckDialogue: Boolean;
        //       Text051@1071 :
        Text051: TextConst ENU = 'The sales %1 %2 already exists.', ESP = 'Ya existen las ventas %1 %2.';
        //       Text053@1102 :
        Text053: TextConst ENU = 'You must cancel the approval process if you wish to change the %1.', ESP = 'Debe cancelar el proceso de aprobaci�n si desea cambiar el %1.';
        //       Text056@1105 :
        Text056: TextConst ENU = 'Deleting this document will cause a gap in the number series for prepayment invoices. An empty prepayment invoice %1 will be created to fill this gap in the number series.\\Do you want to continue?', ESP = 'Si elimina el documento, se provocar� una discontinuidad en la numeraci�n de la serie de facturas de prepago. Se crear� una factura prepago en blanco %1 para completar este error en las series num�ricas.\\�Desea continuar?';
        //       Text057@1108 :
        Text057: TextConst ENU = 'Deleting this document will cause a gap in the number series for prepayment credit memos. An empty prepayment credit memo %1 will be created to fill this gap in the number series.\\Do you want to continue?', ESP = 'Si elimina el documento, se provocar� una discontinuidad en la numeraci�n de la serie de abonos de prepago. Se crear� un abono prepago en blanco %1 para completar este error en las series num�ricas.\\�Desea continuar?';
        //       Text061@1110 :
        Text061: TextConst ENU = '%1 is set up to process from %2 %3 only.', ESP = 'Se ha configurado %1 para procesar s�lo desde %2 %3.';
        //       Text062@1072 :
        Text062: TextConst ENU = 'You cannot change %1 because the corresponding %2 %3 has been assigned to this %4.', ESP = 'No puede cambiar %1 porque el %2 %3 correspondiente ha sido asignado a este %4.';
        //       Text063@1077 :
        Text063: TextConst ENU = 'Reservations exist for this order. These reservations will be canceled if a date conflict is caused by this change.\\Do you want to continue?', ESP = 'Existen reservas para este pedido. Dichas reservas se cancelar�n si este cambio provoca un conflicto de fechas.\\�Desea continuar?';
        //       Text064@1090 :
        Text064: TextConst ENU = 'You may have changed a dimension.\\Do you want to update the lines?', ESP = 'Puede que haya cambiado una dimensi�n.\\�Desea actualizar las l�neas?';
        //       UpdateDocumentDate@1120 :
        UpdateDocumentDate: Boolean;
        //       Text066@1095 :
        Text066: TextConst ENU = 'You cannot change %1 to %2 because an open inventory pick on the %3.', ESP = 'No puede cambiar %1 a %2 debido a un picking de inventario abierto en %3.';
        //       Text070@1096 :
        Text070: TextConst ENU = 'You cannot change %1  to %2 because an open warehouse shipment exists for the %3.', ESP = 'No puede cambiar %1 a %2 debido a que existe un env�o de almac�n abierto para %3.';
        //       BilltoCustomerNoChanged@1121 :
        BilltoCustomerNoChanged: Boolean;
        //       SelectNoSeriesAllowed@1067 :
        SelectNoSeriesAllowed: Boolean;
        //       PrepaymentInvoicesNotPaidErr@1011 :
        PrepaymentInvoicesNotPaidErr:
// You cannot post the document of type Order with the number 1001 before all related prepayment invoices are posted.
TextConst ENU = 'You cannot post the document of type %1 with the number %2 before all related prepayment invoices are posted.', ESP = 'No puede registrar el documento de tipo %1 con el n�mero %2 antes de que se registren todas las facturas de prepago relacionadas.';
        //       Text072@1013 :
        Text072: TextConst ENU = 'There are unpaid prepayment invoices related to the document of type %1 with the number %2.', ESP = 'Hay facturas prepago sin pagar relacionadas con el documento de tipo %1 con el n�mero %2.';
        //       AdjustDueDate@1100000 :
        AdjustDueDate: Codeunit 10700;
        //       Text10700@1100001 :
        Text10700: TextConst ENU = '%1 cannot be different from 0 when %2 is %3', ESP = '%1 no puede ser diferente de 0 cuando %2 es %3';
        //       DeferralLineQst@1044 :
        DeferralLineQst: TextConst ENU = 'Do you want to update the deferral schedules for the lines?', ESP = '�Desea actualizar las previsiones de fraccionamiento para las l�neas?';
        //       SynchronizingMsg@1026 :
        SynchronizingMsg: TextConst ENU = 'Synchronizing ...\ from: Sales Header with %1\ to: Assembly Header with %2.', ESP = 'Sincronizando...\ desde: Encabezado de ventas con %1\ hasta: Encabezado de ensamblado con %2.';
        //       EstimateTxt@1023 :
        EstimateTxt: TextConst ENU = 'Estimate', ESP = 'Estimaci�n';
        //       ShippingAdviceErr@1029 :
        ShippingAdviceErr: TextConst ENU = 'This order must be a complete shipment.', ESP = 'Este pedido debe ser un env�o completo.';
        //       PostedDocsToPrintCreatedMsg@1084 :
        PostedDocsToPrintCreatedMsg: TextConst ENU = 'One or more related posted documents have been generated during deletion to fill gaps in the posting number series. You can view or print the documents from the respective document archive.', ESP = 'Durante la eliminaci�n, se han generado uno o m�s documentos registrados relacionados en sustituci�n de los n�meros de registro que faltan de la serie. Puede ver o imprimir los documentos del archivo de documentos correspondiente.';
        //       DocumentNotPostedClosePageQst@1061 :
        DocumentNotPostedClosePageQst: TextConst ENU = 'The document has not been posted.\Are you sure you want to exit?', ESP = 'El documento no se registr�.\�Est� seguro de que desea salir?';
        //       SelectCustomerTemplateQst@1008 :
        SelectCustomerTemplateQst: TextConst ENU = 'Do you want to select the customer template?', ESP = '�Quiere seleccionar la plantilla de cliente?';
        //       ModifyCustomerAddressNotificationLbl@1062 :
        ModifyCustomerAddressNotificationLbl: TextConst ENU = 'Update the address', ESP = 'Actualizar la direcci�n';
        //       DontShowAgainActionLbl@1064 :
        DontShowAgainActionLbl: TextConst ENU = 'Don''t show again', ESP = 'No volver a mostrar';
        //       ModifyCustomerAddressNotificationMsg@1063 :
        ModifyCustomerAddressNotificationMsg:
// "%1=customer name"
TextConst ENU = 'The address you entered for %1 is different from the customer''s existing address.', ESP = 'La direcci�n indicada para %1 es distinta de la direcci�n existente del cliente.';
        //       ValidVATNoMsg@1254 :
        ValidVATNoMsg: TextConst ENU = 'The VAT registration number is valid.', ESP = 'El CIF/NIF es v�lido.';
        //       InvalidVatRegNoMsg@1255 :
        InvalidVatRegNoMsg: TextConst ENU = 'The VAT registration number is not valid. Try entering the number again.', ESP = 'El CIF/NIF no es v�lido. Pruebe a especificar el n�mero de nuevo.';
        //       SellToCustomerTxt@1052 :
        SellToCustomerTxt: TextConst ENU = 'Sell-to Customer', ESP = 'Cliente de venta';
        //       BillToCustomerTxt@1057 :
        BillToCustomerTxt: TextConst ENU = 'Bill-to Customer', ESP = 'Cliente de facturaci�n';
        //       ModifySellToCustomerAddressNotificationNameTxt@1087 :
        ModifySellToCustomerAddressNotificationNameTxt: TextConst ENU = 'Update Sell-to Customer Address', ESP = 'Actualizar direcci�n del cliente de venta';
        //       ModifySellToCustomerAddressNotificationDescriptionTxt@1098 :
        ModifySellToCustomerAddressNotificationDescriptionTxt: TextConst ENU = 'Warn if the sell-to address on sales documents is different from the customer''s existing address.', ESP = 'Permite advertir si la direcci�n de venta de los documentos de venta es distinta de la direcci�n existente del cliente.';
        //       ModifyBillToCustomerAddressNotificationNameTxt@1089 :
        ModifyBillToCustomerAddressNotificationNameTxt: TextConst ENU = 'Update Bill-to Customer Address', ESP = 'Actualizar direcci�n del cliente de facturaci�n';
        //       ModifyBillToCustomerAddressNotificationDescriptionTxt@1099 :
        ModifyBillToCustomerAddressNotificationDescriptionTxt: TextConst ENU = 'Warn if the bill-to address on sales documents is different from the customer''s existing address.', ESP = 'Permite advertir si la direcci�n de facturaci�n de los documentos de venta es distinta de la direcci�n existente del cliente.';
        //       DuplicatedCaptionsNotAllowedErr@1094 :
        DuplicatedCaptionsNotAllowedErr: TextConst ENU = 'Field captions must not be duplicated when using this method. Use UpdateSalesLinesByFieldNo instead.', ESP = 'No se deben duplicar t�tulos de campo cuando se utiliza este m�todo. Use UpdateSalesLinesByFieldNo en su lugar.';
        //       PhoneNoCannotContainLettersErr@1080 :
        PhoneNoCannotContainLettersErr: TextConst ENU = 'You cannot enter letters in this field.', ESP = 'No puede introducir letras en este campo.';
        //       MissingExchangeRatesQst@1032 :
        MissingExchangeRatesQst:
// %1 - currency code, %2 - posting date
TextConst ENU = 'There are no exchange rates for currency %1 and date %2. Do you want to add them now? Otherwise, the last change you made will be reverted.', ESP = 'No hay tipos de cambio para la divisa %1 y la fecha %2. �Desea agregarlos ahora? De lo contrario, se revertir� el �ltimo cambio que hizo.';
        //       SplitMessageTxt@1079 :
        SplitMessageTxt:
// Some message text 1.\Some message text 2.
TextConst ENU = '%1\%2', ESP = '%1\%2';
        //       StatusCheckSuspended@1103 :
        StatusCheckSuspended: Boolean;
        //       ConfirmEmptyEmailQst@1104 :
        ConfirmEmptyEmailQst:
// %1 - Contact No., %2 - Email
TextConst ENU = 'Contact %1 has no email address specified. The value in the Email field on the sales order, %2, will be deleted. Do you want to continue?', ESP = 'El contacto %1 no tiene una direcci�n de correo electr�nico especificada. Se eliminar� el valor del campo Correo electr�nico del pedido de venta, %2. �Desea continuar?';





    /*
    trigger OnInsert();    var
    //                O365SalesInvoiceMgmt@1000 :
                   O365SalesInvoiceMgmt: Codeunit 2310;
    //                StandardCodesMgt@1001 :
                   StandardCodesMgt: Codeunit 170;
                 begin
                   InitInsert;
                   InsertMode := TRUE;

                   SetSellToCustomerFromFilter;

                   if GetFilterContNo <> '' then
                     VALIDATE("Sell-to Contact No.",GetFilterContNo);

                   VALIDATE("Payment Instructions Id",O365SalesInvoiceMgmt.GetDefaultPaymentInstructionsId);

                   if "Salesperson Code" = '' then
                     SetDefaultSalesperson;

                   if "Sell-to Customer No." <> '' then
                     StandardCodesMgt.CheckShowSalesRecurringLinesNotification(Rec);
                 end;


    */

    /*
    trigger OnDelete();    var
    //                CustInvoiceDisc@1002 :
                   CustInvoiceDisc: Record 19;
    //                PostSalesDelete@1003 :
                   PostSalesDelete: Codeunit 363;
    //                ArchiveManagement@1000 :
                   ArchiveManagement: Codeunit 5063;
                 begin
                   if not UserSetupMgt.CheckRespCenter(0,"Responsibility Center") then
                     ERROR(
                       Text022,
                       RespCenter.TABLECAPTION,UserSetupMgt.GetSalesFilter);

                   ArchiveManagement.AutoArchiveSalesDocument(Rec);
                   PostSalesDelete.DeleteHeader(
                     Rec,SalesShptHeader,SalesInvHeader,SalesCrMemoHeader,ReturnRcptHeader,
                     SalesInvHeaderPrepmt,SalesCrMemoHeaderPrepmt);
                   UpdateOpportunity;

                   VALIDATE("Applies-to ID",'');
                   VALIDATE("Incoming Document Entry No.",0);

                   ApprovalsMgmt.OnDeleteRecordInApprovalRequest(RECORDID);
                   SalesLine.RESET;
                   SalesLine.LOCKTABLE;

                   WhseRequest.SETRANGE("Source Type",DATABASE::"Sales Line");
                   WhseRequest.SETRANGE("Source Subtype","Document Type");
                   WhseRequest.SETRANGE("Source No.","No.");
                   if not WhseRequest.ISEMPTY then
                     WhseRequest.DELETEALL(TRUE);

                   SalesLine.SETRANGE("Document Type","Document Type");
                   SalesLine.SETRANGE("Document No.","No.");
                   SalesLine.SETRANGE(Type,SalesLine.Type::"Charge (Item)");

                   DeleteSalesLines;
                   SalesLine.SETRANGE(Type);
                   DeleteSalesLines;

                   SalesCommentLine.SETRANGE("Document Type","Document Type");
                   SalesCommentLine.SETRANGE("No.","No.");
                   SalesCommentLine.DELETEALL;

                   if (SalesShptHeader."No." <> '') or
                      (SalesInvHeader."No." <> '') or
                      (SalesCrMemoHeader."No." <> '') or
                      (ReturnRcptHeader."No." <> '') or
                      (SalesInvHeaderPrepmt."No." <> '') or
                      (SalesCrMemoHeaderPrepmt."No." <> '')
                   then
                     MESSAGE(PostedDocsToPrintCreatedMsg);

                   if IdentityManagement.IsInvAppId and CustInvoiceDisc.GET(SalesHeader."Invoice Disc. Code") then
                     CustInvoiceDisc.DELETE; // Cleanup of autogenerated cust. invoice discounts
                 end;


    */

    /*
    trigger OnRename();    begin
                   ERROR(Text003,TABLECAPTION);
                 end;

    */




    /*
    procedure InitInsert ()
        var
    //       IsHandled@1000 :
          IsHandled: Boolean;
        begin
          IsHandled := FALSE;
          OnBeforeInitInsert(Rec,xRec,IsHandled);
          if not IsHandled then
            if "No." = '' then begin
              TestNoSeries;
              NoSeriesMgt.InitSeries(GetNoSeriesCode,xRec."No. Series","Posting Date","No.","No. Series");
            end;

          OnInitInsertOnBeforeInitRecord(Rec,xRec);
          InitRecord;
        end;
    */



    procedure InitRecord()
    var
        //       ArchiveManagement@1000 :
        ArchiveManagement: Codeunit 5063;
        //       IsHandled@1001 :
        IsHandled: Boolean;
        //       SIIManagement@1100000 :
        SIIManagement: Codeunit 10756;
    begin
        SalesSetup.GET;
        IsHandled := FALSE;
        OnBeforeInitRecord(Rec, IsHandled);
        if not IsHandled then
            CASE "Document Type" OF
                "Document Type"::Quote, "Document Type"::Order:
                    begin
                        NoSeriesMgt.SetDefaultSeries("Posting No. Series", SalesSetup."Posted Invoice Nos.");
                        NoSeriesMgt.SetDefaultSeries("Shipping No. Series", SalesSetup."Posted Shipment Nos.");
                        if "Document Type" = "Document Type"::Order then begin
                            NoSeriesMgt.SetDefaultSeries("Prepayment No. Series", SalesSetup."Posted Prepmt. Inv. Nos.");
                            NoSeriesMgt.SetDefaultSeries("Prepmt. Cr. Memo No. Series", SalesSetup."Posted Prepmt. Cr. Memo Nos.");
                        end;
                    end;
                "Document Type"::Invoice:
                    begin
                        if ("No. Series" <> '') and
                           (SalesSetup."Invoice Nos." = SalesSetup."Posted Invoice Nos.")
                        then
                            "Posting No. Series" := "No. Series"
                        else
                            NoSeriesMgt.SetDefaultSeries("Posting No. Series", SalesSetup."Posted Invoice Nos.");
                        if SalesSetup."Shipment on Invoice" then
                            NoSeriesMgt.SetDefaultSeries("Shipping No. Series", SalesSetup."Posted Shipment Nos.");
                    end;
                "Document Type"::"Return Order":
                    begin
                        NoSeriesMgt.SetDefaultSeries("Posting No. Series", SalesSetup."Posted Credit Memo Nos.");
                        NoSeriesMgt.SetDefaultSeries("Return Receipt No. Series", SalesSetup."Posted Return Receipt Nos.");
                    end;
                "Document Type"::"Credit Memo":
                    begin
                        if ("No. Series" <> '') and
                           (SalesSetup."Credit Memo Nos." = SalesSetup."Posted Credit Memo Nos.")
                        then
                            "Posting No. Series" := "No. Series"
                        else
                            NoSeriesMgt.SetDefaultSeries("Posting No. Series", SalesSetup."Posted Credit Memo Nos.");
                        if SalesSetup."Return Receipt on Credit Memo" then
                            NoSeriesMgt.SetDefaultSeries("Return Receipt No. Series", SalesSetup."Posted Return Receipt Nos.");
                    end;
            end;

        if "Document Type" IN ["Document Type"::Order, "Document Type"::Invoice, "Document Type"::Quote] then
            "Shipment Date" := WORKDATE;
        if not ("Document Type" IN ["Document Type"::"Blanket Order", "Document Type"::Quote]) and
           ("Posting Date" = 0D)
        then
            "Posting Date" := WORKDATE;

        if SalesSetup."Default Posting Date" = SalesSetup."Default Posting Date"::"No Date" then
            "Posting Date" := 0D;

        "Order Date" := WORKDATE;
        "Document Date" := WORKDATE;
        if "Document Type" = "Document Type"::Quote then
            CalcQuoteValidUntilDate;

        VALIDATE("Location Code", UserSetupMgt.GetLocation(0, Cust."Location Code", "Responsibility Center"));

        if IsCreditDocType then begin
            GLSetup.GET;
            Correction := GLSetup."Mark Cr. Memos as Corrections";
        end;

        "Posting Description" := FORMAT("Document Type") + ' ' + "No.";

        UpdateOutboundWhseHandlingTime;

        "Responsibility Center" := UserSetupMgt.GetRespCenter(0, "Responsibility Center");
        "Doc. No. Occurrence" := ArchiveManagement.GetNextOccurrenceNo(DATABASE::"Sales Header", "Document Type", "No.");
        SIIManagement.UpdateSIIInfoInSalesDoc(Rec);
        InitSii;

        OnAfterInitRecord(Rec);
    end;


    /*
    LOCAL procedure InitNoSeries ()
        begin
          if xRec."Shipping No." <> '' then begin
            "Shipping No. Series" := xRec."Shipping No. Series";
            "Shipping No." := xRec."Shipping No.";
          end;
          if xRec."Posting No." <> '' then begin
            "Posting No. Series" := xRec."Posting No. Series";
            "Posting No." := xRec."Posting No.";
          end;
          if xRec."Return Receipt No." <> '' then begin
            "Return Receipt No. Series" := xRec."Return Receipt No. Series";
            "Return Receipt No." := xRec."Return Receipt No.";
          end;
          if xRec."Prepayment No." <> '' then begin
            "Prepayment No. Series" := xRec."Prepayment No. Series";
            "Prepayment No." := xRec."Prepayment No.";
          end;
          if xRec."Prepmt. Cr. Memo No." <> '' then begin
            "Prepmt. Cr. Memo No. Series" := xRec."Prepmt. Cr. Memo No. Series";
            "Prepmt. Cr. Memo No." := xRec."Prepmt. Cr. Memo No.";
          end;

          OnAfterInitNoSeries(Rec);
        end;
    */


    LOCAL procedure InitSii()
    var
        //       GeneralLedgerSetup@1100000 :
        GeneralLedgerSetup: Record 98;
        //       SIIManagement@1100001 :
        SIIManagement: Codeunit 10756;
    begin
        GeneralLedgerSetup.GET;
        if GeneralLedgerSetup."VAT Cash Regime" then
            "Special Scheme Code" := "Special Scheme Code"::"07 Special Cash"
        else
            if "Sell-to Customer No." <> '' then
                if Cust.GET("Sell-to Customer No.") then
                    if SIIManagement.CountryIsLocal("VAT Country/Region Code") or
                      SIIManagement.CustomerIsIntraCommunity(Cust."No.")
                    then
                        "Special Scheme Code" := "Special Scheme Code"::"01 General"
                    else
                        "Special Scheme Code" := "Special Scheme Code"::"02 Export";
    end;


    //     procedure AssistEdit (OldSalesHeader@1000 :

    /*
    procedure AssistEdit (OldSalesHeader: Record 36) : Boolean;
        var
    //       SalesHeader2@1001 :
          SalesHeader2: Record 36;
        begin
          WITH SalesHeader DO begin
            COPY(Rec);
            SalesSetup.GET;
            TestNoSeries;
            if NoSeriesMgt.SelectSeries(GetNoSeriesCode,OldSalesHeader."No. Series","No. Series") then begin
              if ("Sell-to Customer No." = '') and ("Sell-to Contact No." = '') then begin
                HideCreditCheckDialogue := FALSE;
                CheckCreditMaxBeforeInsert;
                HideCreditCheckDialogue := TRUE;
              end;
              NoSeriesMgt.SetSeries("No.");
              if SalesHeader2.GET("Document Type","No.") then
                ERROR(Text051,LOWERCASE(FORMAT("Document Type")),"No.");
              Rec := SalesHeader;
              exit(TRUE);
            end;
          end;
        end;
    */




    /*
    procedure TestNoSeries ()
        var
    //       IsHandled@1000 :
          IsHandled: Boolean;
        begin
          SalesSetup.GET;
          IsHandled := FALSE;
          OnBeforeTestNoSeries(Rec,IsHandled);
          if not IsHandled then
            CASE "Document Type" OF
              "Document Type"::Quote:
                SalesSetup.TESTFIELD("Quote Nos.");
              "Document Type"::Order:
                SalesSetup.TESTFIELD("Order Nos.");
              "Document Type"::Invoice:
                begin
                  SalesSetup.TESTFIELD("Invoice Nos.");
                  SalesSetup.TESTFIELD("Posted Invoice Nos.");
                end;
              "Document Type"::"Return Order":
                SalesSetup.TESTFIELD("Return Order Nos.");
              "Document Type"::"Credit Memo":
                begin
                  SalesSetup.TESTFIELD("Credit Memo Nos.");
                  SalesSetup.TESTFIELD("Posted Credit Memo Nos.");
                end;
              "Document Type"::"Blanket Order":
                SalesSetup.TESTFIELD("Blanket Order Nos.");
            end;

          OnAfterTestNoSeries(Rec);
        end;
    */




    /*
    procedure GetNoSeriesCode () : Code[20];
        var
    //       NoSeriesCode@1000 :
          NoSeriesCode: Code[20];
        begin
          CASE "Document Type" OF
            "Document Type"::Quote:
              NoSeriesCode := SalesSetup."Quote Nos.";
            "Document Type"::Order:
              NoSeriesCode := SalesSetup."Order Nos.";
            "Document Type"::Invoice:
              NoSeriesCode := SalesSetup."Invoice Nos.";
            "Document Type"::"Return Order":
              NoSeriesCode := SalesSetup."Return Order Nos.";
            "Document Type"::"Credit Memo":
              NoSeriesCode := SalesSetup."Credit Memo Nos.";
            "Document Type"::"Blanket Order":
              NoSeriesCode := SalesSetup."Blanket Order Nos.";
          end;
          OnAfterGetNoSeriesCode(Rec,SalesSetup,NoSeriesCode);
          exit(NoSeriesMgt.GetNoSeriesWithCheck(NoSeriesCode,SelectNoSeriesAllowed,"No. Series"));
        end;
    */



    /*
    LOCAL procedure GetPostingNoSeriesCode () PostingNos : Code[20];
        begin
          if IsCreditDocType then
            PostingNos := SalesSetup."Posted Credit Memo Nos."
          else
            PostingNos := SalesSetup."Posted Invoice Nos.";

          OnAfterGetPostingNoSeriesCode(Rec,PostingNos);
        end;
    */



    /*
    LOCAL procedure GetPostingPrepaymentNoSeriesCode () PostingNos : Code[20];
        begin
          if IsCreditDocType then
            PostingNos := SalesSetup."Posted Prepmt. Cr. Memo Nos."
          else
            PostingNos := SalesSetup."Posted Prepmt. Inv. Nos.";

          OnAfterGetPrepaymentPostingNoSeriesCode(Rec,PostingNos);
        end;
    */


    //     LOCAL procedure TestNoSeriesDate (No@1000 : Code[20];NoSeriesCode@1001 : Code[20];NoCapt@1002 : Text[1024];NoSeriesCapt@1004 :

    /*
    LOCAL procedure TestNoSeriesDate (No: Code[20];NoSeriesCode: Code[20];NoCapt: Text[1024];NoSeriesCapt: Text[1024])
        var
    //       NoSeries@1005 :
          NoSeries: Record 308;
        begin
          if (No <> '') and (NoSeriesCode <> '') then begin
            NoSeries.GET(NoSeriesCode);
            if NoSeries."Date Order" then
              ERROR(
                Text045,
                FIELDCAPTION("Posting Date"),NoSeriesCapt,NoSeriesCode,
                NoSeries.FIELDCAPTION("Date Order"),NoSeries."Date Order","Document Type",
                NoCapt,No);
          end;
        end;
    */




    /*
    procedure ConfirmDeletion () : Boolean;
        var
    //       SourceCode@1002 :
          SourceCode: Record 230;
    //       SourceCodeSetup@1001 :
          SourceCodeSetup: Record 242;
    //       PostSalesDelete@1000 :
          PostSalesDelete: Codeunit 363;
    //       ConfirmManagement@1003 :
          ConfirmManagement: Codeunit 27;
        begin
          SourceCodeSetup.GET;
          SourceCodeSetup.TESTFIELD("Deleted Document");
          SourceCode.GET(SourceCodeSetup."Deleted Document");

          PostSalesDelete.InitDeleteHeader(
            Rec,SalesShptHeader,SalesInvHeader,SalesCrMemoHeader,ReturnRcptHeader,
            SalesInvHeaderPrepmt,SalesCrMemoHeaderPrepmt,SourceCode.Code);

          if SalesShptHeader."No." <> '' then
            if not ConfirmManagement.ConfirmProcess(STRSUBSTNO(Text009,SalesShptHeader."No."),TRUE) then
              exit;
          if SalesInvHeader."No." <> '' then
            if not ConfirmManagement.ConfirmProcess(STRSUBSTNO(Text012,SalesInvHeader."No."),TRUE) then
              exit;
          if SalesCrMemoHeader."No." <> '' then
            if not ConfirmManagement.ConfirmProcess(STRSUBSTNO(Text014,SalesCrMemoHeader."No."),TRUE) then
              exit;
          if ReturnRcptHeader."No." <> '' then
            if not ConfirmManagement.ConfirmProcess(STRSUBSTNO(Text030,ReturnRcptHeader."No."),TRUE) then
              exit;
          if "Prepayment No." <> '' then
            if not ConfirmManagement.ConfirmProcess(STRSUBSTNO(Text056,SalesInvHeaderPrepmt."No."),TRUE) then
              exit;
          if "Prepmt. Cr. Memo No." <> '' then
            if not ConfirmManagement.ConfirmProcess(STRSUBSTNO(Text057,SalesCrMemoHeaderPrepmt."No."),TRUE) then
              exit;
          exit(TRUE);
        end;
    */


    //     LOCAL procedure GetCust (CustNo@1000 :

    /*
    LOCAL procedure GetCust (CustNo: Code[20])
        var
    //       O365SalesInitialSetup@1001 :
          O365SalesInitialSetup: Record 2110;
        begin
          if not (("Document Type" = "Document Type"::Quote) and (CustNo = '')) then begin
            if CustNo <> Cust."No." then
              Cust.GET(CustNo);
          end else
            CLEAR(Cust);
          if IdentityManagement.IsInvAppId and O365SalesInitialSetup.GET then
            Cust."Payment Terms Code" := O365SalesInitialSetup."Default Payment Terms Code";
        end;
    */




    /*
    procedure SalesLinesExist () : Boolean;
        begin
          SalesLine.RESET;
          SalesLine.SETRANGE("Document Type","Document Type");
          SalesLine.SETRANGE("Document No.","No.");
          exit(not SalesLine.ISEMPTY);
        end;
    */


    //     LOCAL procedure RecreateSalesLines (ChangedFieldName@1000 :

    /*
    LOCAL procedure RecreateSalesLines (ChangedFieldName: Text[100])
        var
    //       TempSalesLine@1001 :
          TempSalesLine: Record 37 TEMPORARY;
    //       ItemChargeAssgntSales@1004 :
          ItemChargeAssgntSales: Record 5809;
    //       TempItemChargeAssgntSales@1003 :
          TempItemChargeAssgntSales: Record 5809 TEMPORARY;
    //       TempInteger@1006 :
          TempInteger: Record 2000000026 TEMPORARY;
    //       TempATOLink@1009 :
          TempATOLink: Record 904 TEMPORARY;
    //       ATOLink@1010 :
          ATOLink: Record 904;
    //       TransferExtendedText@1005 :
          TransferExtendedText: Codeunit 378;
    //       ExtendedTextAdded@1002 :
          ExtendedTextAdded: Boolean;
    //       ConfirmText@1007 :
          ConfirmText: Text;
    //       IsHandled@1008 :
          IsHandled: Boolean;
        begin
          if SalesLinesExist then begin
            OnRecreateSalesLinesOnBeforeConfirm(Rec,xRec,ChangedFieldName,HideValidationDialog,Confirmed,IsHandled);
            if not IsHandled then
              if GetHideValidationDialog or not GUIALLOWED then
                Confirmed := TRUE
              else begin
                if HasItemChargeAssignment then
                  ConfirmText := ResetItemChargeAssignMsg
                else
                  ConfirmText := RecreateSalesLinesMsg;
                Confirmed := CONFIRM(ConfirmText,FALSE,ChangedFieldName);
              end;

            if Confirmed then begin
              SalesLine.LOCKTABLE;
              ItemChargeAssgntSales.LOCKTABLE;
              ReservEntry.LOCKTABLE;
              MODIFY;
              OnBeforeRecreateSalesLines(Rec);
              SalesLine.RESET;
              SalesLine.SETRANGE("Document Type","Document Type");
              SalesLine.SETRANGE("Document No.","No.");
              if SalesLine.FINDSET then begin
                TempReservEntry.DELETEALL;
                RecreateReservEntryReqLine(TempSalesLine,TempATOLink,ATOLink);
                TransferItemChargeAssgntSalesToTemp(ItemChargeAssgntSales,TempItemChargeAssgntSales);
                SalesLine.DELETEALL(TRUE);
                SalesLine.INIT;
                SalesLine."Line No." := 0;
                TempSalesLine.FINDSET;
                ExtendedTextAdded := FALSE;
                SalesLine.BlockDynamicTracking(TRUE);
                repeat
                  if TempSalesLine."Attached to Line No." = 0 then begin
                    CreateSalesLine(TempSalesLine);
                    ExtendedTextAdded := FALSE;
                    OnAfterRecreateSalesLine(SalesLine,TempSalesLine);

                    if SalesLine.Type = SalesLine.Type::Item then begin
                      ClearItemAssgntSalesFilter(TempItemChargeAssgntSales);
                      TempItemChargeAssgntSales.SETRANGE("Applies-to Doc. Type",TempSalesLine."Document Type");
                      TempItemChargeAssgntSales.SETRANGE("Applies-to Doc. No.",TempSalesLine."Document No.");
                      TempItemChargeAssgntSales.SETRANGE("Applies-to Doc. Line No.",TempSalesLine."Line No.");
                      if TempItemChargeAssgntSales.FINDSET then
                        repeat
                          if not TempItemChargeAssgntSales.MARK then begin
                            TempItemChargeAssgntSales."Applies-to Doc. Line No." := SalesLine."Line No.";
                            TempItemChargeAssgntSales.Description := SalesLine.Description;
                            TempItemChargeAssgntSales.MODIFY;
                            TempItemChargeAssgntSales.MARK(TRUE);
                          end;
                        until TempItemChargeAssgntSales.NEXT = 0;
                    end;
                    if SalesLine.Type = SalesLine.Type::"Charge (Item)" then begin
                      TempInteger.INIT;
                      TempInteger.Number := SalesLine."Line No.";
                      TempInteger.INSERT;
                    end;
                  end else
                    if not ExtendedTextAdded then begin
                      TransferExtendedText.SalesCheckIfAnyExtText(SalesLine,TRUE);
                      TransferExtendedText.InsertSalesExtText(SalesLine);
                      OnAfterTransferExtendedTextForSalesLineRecreation(SalesLine);

                      SalesLine.FINDLAST;
                      ExtendedTextAdded := TRUE;
                    end;
                  SalesLineReserve.CopyReservEntryFromTemp(TempReservEntry,TempSalesLine,SalesLine."Line No.");
                  RecreateReqLine(TempSalesLine,SalesLine."Line No.",FALSE);
                  SynchronizeForReservations(SalesLine,TempSalesLine);

                  if TempATOLink.AsmExistsForSalesLine(TempSalesLine) then begin
                    ATOLink := TempATOLink;
                    ATOLink."Document Line No." := SalesLine."Line No.";
                    ATOLink.INSERT;
                    ATOLink.UpdateAsmFromSalesLineATOExist(SalesLine);
                    TempATOLink.DELETE;
                  end;
                until TempSalesLine.NEXT = 0;

                ClearItemAssgntSalesFilter(TempItemChargeAssgntSales);
                TempSalesLine.SETRANGE(Type,SalesLine.Type::"Charge (Item)");
                CreateItemChargeAssgntSales(ItemChargeAssgntSales,TempItemChargeAssgntSales,TempSalesLine,TempInteger);
                TempSalesLine.SETRANGE(Type);
                TempSalesLine.DELETEALL;
                OnAfterDeleteAllTempSalesLines;
                ClearItemAssgntSalesFilter(TempItemChargeAssgntSales);
                TempItemChargeAssgntSales.DELETEALL;
              end;
            end else
              ERROR(
                Text017,ChangedFieldName);
          end;

          SalesLine.BlockDynamicTracking(FALSE);
        end;
    */



    //     procedure MessageIfSalesLinesExist (ChangedFieldName@1000 :

    /*
    procedure MessageIfSalesLinesExist (ChangedFieldName: Text[100])
        var
    //       MessageText@1001 :
          MessageText: Text;
        begin
          if SalesLinesExist and not GetHideValidationDialog then begin
            MessageText := STRSUBSTNO(LinesNotUpdatedMsg,ChangedFieldName);
            MessageText := STRSUBSTNO(SplitMessageTxt,MessageText,Text019);
            MESSAGE(MessageText);
          end;
        end;
    */



    //     procedure PriceMessageIfSalesLinesExist (ChangedFieldName@1000 :

    /*
    procedure PriceMessageIfSalesLinesExist (ChangedFieldName: Text[100])
        var
    //       MessageText@1001 :
          MessageText: Text;
        begin
          if SalesLinesExist and not GetHideValidationDialog then begin
            MessageText := STRSUBSTNO(LinesNotUpdatedMsg,ChangedFieldName);
            if "Currency Code" <> '' then
              MessageText := STRSUBSTNO(SplitMessageTxt,MessageText,AffectExchangeRateMsg);
            MESSAGE(MessageText);
          end;
        end;
    */




    /*
    procedure UpdateCurrencyFactor ()
        var
    //       UpdateCurrencyExchangeRates@1001 :
          UpdateCurrencyExchangeRates: Codeunit 1281;
    //       ConfirmManagement@1002 :
          ConfirmManagement: Codeunit 27;
    //       Updated@1000 :
          Updated: Boolean;
        begin
          OnBeforeUpdateCurrencyFactor(Rec,Updated);
          if Updated then
            exit;

          if "Currency Code" <> '' then begin
            if "Posting Date" <> 0D then
              CurrencyDate := "Posting Date"
            else
              CurrencyDate := WORKDATE;

            if UpdateCurrencyExchangeRates.ExchangeRatesForCurrencyExist(CurrencyDate,"Currency Code") then begin
              "Currency Factor" := CurrExchRate.ExchangeRate(CurrencyDate,"Currency Code");
              if "Currency Code" <> xRec."Currency Code" then
                RecreateSalesLines(FIELDCAPTION("Currency Code"));
            end else begin
              if ConfirmManagement.ConfirmProcess(
                   STRSUBSTNO(MissingExchangeRatesQst,"Currency Code",CurrencyDate),TRUE)
              then begin
                COMMIT;
                UpdateCurrencyExchangeRates.OpenExchangeRatesPage("Currency Code");
                UpdateCurrencyFactor;
              end else
                RevertCurrencyCodeAndPostingDate;
            end;
          end else begin
            "Currency Factor" := 0;
            if "Currency Code" <> xRec."Currency Code" then
              RecreateSalesLines(FIELDCAPTION("Currency Code"));
          end;

          OnAfterUpdateCurrencyFactor(Rec,GetHideValidationDialog);
        end;
    */



    /*
    LOCAL procedure ConfirmUpdateCurrencyFactor ()
        begin
          if GetHideValidationDialog or not GUIALLOWED then
            Confirmed := TRUE
          else
            Confirmed := CONFIRM(Text021,FALSE);
          if Confirmed then
            VALIDATE("Currency Factor")
          else
            "Currency Factor" := xRec."Currency Factor";
        end;
    */



    //     procedure SetHideValidationDialog (NewHideValidationDialog@1000 :

    /*
    procedure SetHideValidationDialog (NewHideValidationDialog: Boolean)
        begin
          HideValidationDialog := NewHideValidationDialog;
        end;
    */




    /*
    procedure GetHideValidationDialog () : Boolean;
        var
    //       IdentityManagement@1000 :
          IdentityManagement: Codeunit 9801;
        begin
          exit(HideValidationDialog or IdentityManagement.IsInvAppId);
        end;
    */



    //     procedure UpdateSalesLines (ChangedFieldName@1000 : Text[100];AskQuestion@1001 :

    /*
    procedure UpdateSalesLines (ChangedFieldName: Text[100];AskQuestion: Boolean)
        var
    //       Field@1002 :
          Field: Record 2000000041;
        begin
          Field.SETRANGE(TableNo,DATABASE::"Sales Header");
          Field.SETRANGE("Field Caption",ChangedFieldName);
          Field.SETFILTER(ObsoleteState,'<>%1',Field.ObsoleteState::Removed);
          Field.FIND('-');
          if Field.NEXT <> 0 then
            ERROR(DuplicatedCaptionsNotAllowedErr);
          UpdateSalesLinesByFieldNo(Field."No.",AskQuestion);

          OnAfterUpdateSalesLines(Rec);
        end;
    */



    //     procedure UpdateSalesLinesByFieldNo (ChangedFieldNo@1000 : Integer;AskQuestion@1001 :
    procedure UpdateSalesLinesByFieldNo(ChangedFieldNo: Integer; AskQuestion: Boolean)
    var
        //       Field@1006 :
        Field: Record 2000000041;
        //       JobTransferLine@1004 :
        JobTransferLine: Codeunit 1004;
        //       PermissionManager@1003 :
        PermissionManager: Codeunit 9002;
        PermissionManager1: Codeunit "Permission Manager 1";
        //       Question@1002 :
        Question: Text[250];
        //       NotRunningOnSaaS@1005 :
        NotRunningOnSaaS: Boolean;
        //       IsHandled@1007 :
        IsHandled: Boolean;
    begin
        IsHandled := FALSE;
        OnBeforeUpdateSalesLinesByFieldNo(Rec, ChangedFieldNo, AskQuestion, IsHandled);
        if IsHandled then
            exit;
        if not SalesLinesExist then
            exit;

        if not Field.GET(DATABASE::"Sales Header", ChangedFieldNo) then
            Field.GET(DATABASE::"Sales Line", ChangedFieldNo);

        NotRunningOnSaaS := TRUE;
        CASE ChangedFieldNo OF
            FIELDNO("Shipping Agent Code"),
          FIELDNO("Shipping Agent Service Code"):
                NotRunningOnSaaS := not PermissionManager1.SoftwareAsAService;
        end;
        if AskQuestion then begin
            Question := STRSUBSTNO(Text031, Field."Field Caption");
            if GUIALLOWED and not GetHideValidationDialog then
                if NotRunningOnSaaS then
                    if DIALOG.CONFIRM(Question, TRUE) then
                        CASE ChangedFieldNo OF
                            FIELDNO("Shipment Date"),
                          FIELDNO("Shipping Agent Code"),
                          FIELDNO("Shipping Agent Service Code"),
                          FIELDNO("Shipping Time"),
                          FIELDNO("Requested Delivery Date"),
                          FIELDNO("Promised Delivery Date"),
                          FIELDNO("Outbound Whse. Handling Time"):
                                ConfirmResvDateConflict;
                        end
                    else
                        exit
                else
                    ConfirmResvDateConflict;
        end;

        SalesLine.LOCKTABLE;
        MODIFY;

        SalesLine.RESET;
        SalesLine.SETRANGE("Document Type", "Document Type");
        SalesLine.SETRANGE("Document No.", "No.");
        if SalesLine.FINDSET then
            repeat
                OnBeforeSalesLineByChangedFieldNo(SalesHeader, SalesLine, ChangedFieldNo, IsHandled);
                if not IsHandled then
                    CASE ChangedFieldNo OF
                        FIELDNO("Shipment Date"):
                            if SalesLine."No." <> '' then
                                SalesLine.VALIDATE("Shipment Date", "Shipment Date");
                        FIELDNO("Currency Factor"):
                            if SalesLine.Type <> SalesLine.Type::" " then begin
                                SalesLine.VALIDATE("Unit Price");
                                SalesLine.VALIDATE("Unit Cost (LCY)");
                                if SalesLine."Job No." <> '' then
                                    JobTransferLine.FromSalesHeaderToPlanningLine(SalesLine, "Currency Factor");
                            end;
                        FIELDNO("Transaction Type"):
                            SalesLine.VALIDATE("Transaction Type", "Transaction Type");
                        FIELDNO("Transport Method"):
                            SalesLine.VALIDATE("Transport Method", "Transport Method");
                        FIELDNO("exit Point"):
                            SalesLine.VALIDATE("exit Point", "exit Point");
                        FIELDNO(Area):
                            SalesLine.VALIDATE(Area, Area);
                        FIELDNO("Transaction Specification"):
                            SalesLine.VALIDATE("Transaction Specification", "Transaction Specification");
                        FIELDNO("Shipping Agent Code"):
                            SalesLine.VALIDATE("Shipping Agent Code", "Shipping Agent Code");
                        FIELDNO("Shipping Agent Service Code"):
                            if SalesLine."No." <> '' then
                                SalesLine.VALIDATE("Shipping Agent Service Code", "Shipping Agent Service Code");
                        FIELDNO("Shipping Time"):
                            if SalesLine."No." <> '' then
                                SalesLine.VALIDATE("Shipping Time", "Shipping Time");
                        FIELDNO("Prepayment %"):
                            if SalesLine."No." <> '' then
                                SalesLine.VALIDATE("Prepayment %", "Prepayment %");
                        FIELDNO("Requested Delivery Date"):
                            if SalesLine."No." <> '' then
                                SalesLine.VALIDATE("Requested Delivery Date", "Requested Delivery Date");
                        FIELDNO("Promised Delivery Date"):
                            if SalesLine."No." <> '' then
                                SalesLine.VALIDATE("Promised Delivery Date", "Promised Delivery Date");
                        FIELDNO("Outbound Whse. Handling Time"):
                            if SalesLine."No." <> '' then
                                SalesLine.VALIDATE("Outbound Whse. Handling Time", "Outbound Whse. Handling Time");
                        SalesLine.FIELDNO("Deferral Code"):
                            if SalesLine."No." <> '' then
                                SalesLine.VALIDATE("Deferral Code");
                        else
                            OnUpdateSalesLineByChangedFieldName(Rec, SalesLine, Field."Field Caption");
                    end;
                SalesLineReserve.AssignForPlanning(SalesLine);
                SalesLine.MODIFY(TRUE);
            until SalesLine.NEXT = 0;
    end;



    LOCAL procedure ConfirmResvDateConflict()
    var
        //       ResvEngMgt@1000 :
        ResvEngMgt: Codeunit 99000831;
    begin
        if ResvEngMgt.ResvExistsForSalesHeader(Rec) then
            if not CONFIRM(Text063, FALSE) then
                ERROR('');
    end;




    //     procedure CreateDim (Type1@1000 : Integer;No1@1001 : Code[20];Type2@1002 : Integer;No2@1003 : Code[20];Type3@1004 : Integer;No3@1005 : Code[20];Type4@1006 : Integer;No4@1007 : Code[20];Type5@1008 : Integer;No5@1009 :
    procedure CreateDim(Type1: Integer; No1: Code[20]; Type2: Integer; No2: Code[20]; Type3: Integer; No3: Code[20]; Type4: Integer; No4: Code[20]; Type5: Integer; No5: Code[20])
    var
        //       SourceCodeSetup@1010 :
        SourceCodeSetup: Record 242;
        //       TableID@1011 :
        TableID: ARRAY[10] OF Integer;
        //       No@1012 :
        No: ARRAY[10] OF Code[20];
        DefaultDimSource: List of [Dictionary of [Integer, Code[20]]];
        //       OldDimSetID@1013 :
        OldDimSetID: Integer;
    begin
        SourceCodeSetup.GET;
        TableID[1] := Type1;
        No[1] := No1;
        TableID[2] := Type2;
        No[2] := No2;
        TableID[3] := Type3;
        No[3] := No3;
        TableID[4] := Type4;
        No[4] := No4;
        TableID[5] := Type5;
        No[5] := No5;


        OnAfterCreateDimTableIDs(Rec, CurrFieldNo, TableID, No);

        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        OldDimSetID := "Dimension Set ID";
        DimMgt.AddDimSource(DefaultDimSource, TableID[1], No[1]);
        DimMgt.AddDimSource(DefaultDimSource, TableID[2], No[2]);
        DimMgt.AddDimSource(DefaultDimSource, TableID[3], No[3]);
        //DimMgt.AddDimSource(DefaultDimSource, TableID[4], No[4]);
        DimMgt.AddDimSource(DefaultDimSource, TableID[4], No[4]);
        
        DimMgt.AddDimSource(DefaultDimSource, TableID[5], No[5]);
        "Dimension Set ID" :=
          DimMgt.GetRecDefaultDimID(
            Rec, CurrFieldNo, DefaultDimSource, SourceCodeSetup.Sales, "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", 0, 0);

        if (OldDimSetID <> "Dimension Set ID") and SalesLinesExist then begin
            MODIFY;
            UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;


    //     procedure ValidateShortcutDimCode (FieldNumber@1000 : Integer;var ShortcutDimCode@1001 :

    /*
    procedure ValidateShortcutDimCode (FieldNumber: Integer;var ShortcutDimCode: Code[20])
        var
    //       OldDimSetID@1005 :
          OldDimSetID: Integer;
        begin
          OldDimSetID := "Dimension Set ID";
          DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");
          if "No." <> '' then
            MODIFY;

          if OldDimSetID <> "Dimension Set ID" then begin
            MODIFY;
            if SalesLinesExist then
              UpdateAllLineDim("Dimension Set ID",OldDimSetID);
          end;

          OnAfterValidateShortcutDimCode(Rec,xRec,FieldNumber,ShortcutDimCode);
        end;
    */



    /*
    LOCAL procedure ShippedSalesLinesExist () : Boolean;
        begin
          SalesLine.RESET;
          SalesLine.SETRANGE("Document Type","Document Type");
          SalesLine.SETRANGE("Document No.","No.");
          SalesLine.SETFILTER("Quantity Shipped",'<>0');
          exit(SalesLine.FINDFIRST);
        end;
    */



    /*
    LOCAL procedure ReturnReceiptExist () : Boolean;
        begin
          SalesLine.RESET;
          SalesLine.SETRANGE("Document Type","Document Type");
          SalesLine.SETRANGE("Document No.","No.");
          SalesLine.SETFILTER("Return Qty. Received",'<>0');
          exit(SalesLine.FINDFIRST);
        end;
    */



    /*
    LOCAL procedure DeleteSalesLines ()
        var
    //       ReservMgt@1000 :
          ReservMgt: Codeunit 99000845;
        begin
          if SalesLine.FINDSET then begin
            ReservMgt.DeleteDocumentReservation(DATABASE::"Sales Line","Document Type","No.",GetHideValidationDialog);
            repeat
              SalesLine.SuspendStatusCheck(TRUE);
              SalesLine.DELETE(TRUE);
            until SalesLine.NEXT = 0;
          end;
        end;
    */


    //     LOCAL procedure ClearItemAssgntSalesFilter (var TempItemChargeAssgntSales@1000 :

    /*
    LOCAL procedure ClearItemAssgntSalesFilter (var TempItemChargeAssgntSales: Record 5809 TEMPORARY)
        begin
          TempItemChargeAssgntSales.SETRANGE("Document Line No.");
          TempItemChargeAssgntSales.SETRANGE("Applies-to Doc. Type");
          TempItemChargeAssgntSales.SETRANGE("Applies-to Doc. No.");
          TempItemChargeAssgntSales.SETRANGE("Applies-to Doc. Line No.");
        end;
    */



    //     procedure CheckCustomerCreated (Prompt@1000 :

    /*
    procedure CheckCustomerCreated (Prompt: Boolean) : Boolean;
        var
    //       Cont@1001 :
          Cont: Record 5050;
    //       ConfirmManagement@1002 :
          ConfirmManagement: Codeunit 27;
        begin
          if ("Bill-to Customer No." <> '') and ("Sell-to Customer No." <> '') then
            exit(TRUE);

          if Prompt then
            if not ConfirmManagement.ConfirmProcess(Text035,TRUE) then
              exit(FALSE);

          if "Sell-to Customer No." = '' then begin
            TESTFIELD("Sell-to Contact No.");
            TESTFIELD("Sell-to Customer Template Code");
            GetContact(Cont,"Sell-to Contact No.");
            Cont.CreateCustomer("Sell-to Customer Template Code");
            COMMIT;
            GET("Document Type"::Quote,"No.");
          end;

          if "Bill-to Customer No." = '' then begin
            TESTFIELD("Bill-to Contact No.");
            TESTFIELD("Bill-to Customer Template Code");
            GetContact(Cont,"Bill-to Contact No.");
            Cont.CreateCustomer("Bill-to Customer Template Code");
            COMMIT;
            GET("Document Type"::Quote,"No.");
          end;

          exit(("Bill-to Customer No." <> '') and ("Sell-to Customer No." <> ''));
        end;
    */


    //     LOCAL procedure CheckShipmentInfo (var SalesLine@1000 : Record 37;BillTo@1001 :

    /*
    LOCAL procedure CheckShipmentInfo (var SalesLine: Record 37;BillTo: Boolean)
        begin
          if "Document Type" = "Document Type"::Order then
            SalesLine.SETFILTER("Quantity Shipped",'<>0')
          else
            if "Document Type" = "Document Type"::Invoice then begin
              if not BillTo then
                SalesLine.SETRANGE("Sell-to Customer No.",xRec."Sell-to Customer No.");
              SalesLine.SETFILTER("Shipment No.",'<>%1','');
            end;

          if SalesLine.FINDFIRST then
            if "Document Type" = "Document Type"::Order then
              TestQuantityShippedField(SalesLine)
            else
              SalesLine.TESTFIELD("Shipment No.",'');
          SalesLine.SETRANGE("Shipment No.");
          SalesLine.SETRANGE("Quantity Shipped");
        end;
    */


    //     LOCAL procedure CheckPrepmtInfo (var SalesLine@1000 :

    /*
    LOCAL procedure CheckPrepmtInfo (var SalesLine: Record 37)
        begin
          if "Document Type" = "Document Type"::Order then begin
            SalesLine.SETFILTER("Prepmt. Amt. Inv.",'<>0');
            if SalesLine.FIND('-') then
              SalesLine.TESTFIELD("Prepmt. Amt. Inv.",0);
            SalesLine.SETRANGE("Prepmt. Amt. Inv.");
          end;
        end;
    */


    //     LOCAL procedure CheckReturnInfo (var SalesLine@1000 : Record 37;BillTo@1001 :

    /*
    LOCAL procedure CheckReturnInfo (var SalesLine: Record 37;BillTo: Boolean)
        begin
          if "Document Type" = "Document Type"::"Return Order" then
            SalesLine.SETFILTER("Return Qty. Received",'<>0')
          else
            if "Document Type" = "Document Type"::"Credit Memo" then begin
              if not BillTo then
                SalesLine.SETRANGE("Sell-to Customer No.",xRec."Sell-to Customer No.");
              SalesLine.SETFILTER("Return Receipt No.",'<>%1','');
            end;

          if SalesLine.FINDFIRST then
            if "Document Type" = "Document Type"::"Return Order" then
              SalesLine.TESTFIELD("Return Qty. Received",0)
            else
              SalesLine.TESTFIELD("Return Receipt No.",'');
        end;
    */


    //     LOCAL procedure CopyFromSellToCustTemplate (SellToCustTemplate@1000 :

    /*
    LOCAL procedure CopyFromSellToCustTemplate (SellToCustTemplate: Record 5105)
        begin
          SellToCustTemplate.TESTFIELD("Gen. Bus. Posting Group");
          "Gen. Bus. Posting Group" := SellToCustTemplate."Gen. Bus. Posting Group";
          "VAT Bus. Posting Group" := SellToCustTemplate."VAT Bus. Posting Group";
          if "Bill-to Customer No." = '' then
            VALIDATE("Bill-to Customer Template Code","Sell-to Customer Template Code");

          OnAfterCopyFromSellToCustTemplate(Rec,SellToCustTemplate);
        end;
    */


    //     LOCAL procedure RecreateReqLine (OldSalesLine@1000 : Record 37;NewSourceRefNo@1001 : Integer;ToTemp@1002 :

    /*
    LOCAL procedure RecreateReqLine (OldSalesLine: Record 37;NewSourceRefNo: Integer;ToTemp: Boolean)
        var
    //       ReqLine@1003 :
          ReqLine: Record 246;
    //       TempReqLine@1004 :
          TempReqLine: Record 246 TEMPORARY;
        begin
          if ToTemp then begin
            ReqLine.SETCURRENTKEY("Order Promising ID","Order Promising Line ID","Order Promising Line No.");
            ReqLine.SETRANGE("Order Promising ID",OldSalesLine."Document No.");
            ReqLine.SETRANGE("Order Promising Line ID",OldSalesLine."Line No.");
            if ReqLine.FINDSET then
              repeat
                TempReqLine := ReqLine;
                TempReqLine.INSERT;
              until ReqLine.NEXT = 0;
            ReqLine.DELETEALL;
          end else begin
            CLEAR(TempReqLine);
            TempReqLine.SETCURRENTKEY("Order Promising ID","Order Promising Line ID","Order Promising Line No.");
            TempReqLine.SETRANGE("Order Promising ID",OldSalesLine."Document No.");
            TempReqLine.SETRANGE("Order Promising Line ID",OldSalesLine."Line No.");
            if TempReqLine.FINDSET then
              repeat
                ReqLine := TempReqLine;
                ReqLine."Order Promising Line ID" := NewSourceRefNo;
                ReqLine.INSERT;
              until TempReqLine.NEXT = 0;
            TempReqLine.DELETEALL;
          end;
        end;
    */


    //     LOCAL procedure UpdateSellToCont (CustomerNo@1000 :

    /*
    LOCAL procedure UpdateSellToCont (CustomerNo: Code[20])
        var
    //       ContBusRel@1003 :
          ContBusRel: Record 5054;
    //       Cust@1004 :
          Cust: Record 18;
    //       OfficeContact@1001 :
          OfficeContact: Record 5050;
    //       OfficeMgt@1002 :
          OfficeMgt: Codeunit 1630;
        begin
          if OfficeMgt.GetContact(OfficeContact,CustomerNo) then begin
            HideValidationDialog := TRUE;
            UpdateSellToCust(OfficeContact."No.");
            HideValidationDialog := FALSE;
          end else
            if Cust.GET(CustomerNo) then begin
              if Cust."Primary Contact No." <> '' then
                "Sell-to Contact No." := Cust."Primary Contact No."
              else begin
                ContBusRel.RESET;
                ContBusRel.SETCURRENTKEY("Link to Table","No.");
                ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::Customer);
                ContBusRel.SETRANGE("No.","Sell-to Customer No.");
                if ContBusRel.FINDFIRST then
                  "Sell-to Contact No." := ContBusRel."Contact No."
                else
                  "Sell-to Contact No." := '';
              end;
              "Sell-to Contact" := Cust.Contact;
            end;
          if "Sell-to Contact No." <> '' then
            if OfficeContact.GET("Sell-to Contact No.") then
              OfficeContact.CheckIfPrivacyBlockedGeneric;

          OnAfterUpdateSellToCont(Rec,Cust,OfficeContact);
        end;
    */


    //     LOCAL procedure UpdateBillToCont (CustomerNo@1000 :

    /*
    LOCAL procedure UpdateBillToCont (CustomerNo: Code[20])
        var
    //       ContBusRel@1003 :
          ContBusRel: Record 5054;
    //       Cust@1001 :
          Cust: Record 18;
    //       Contact@1002 :
          Contact: Record 5050;
        begin
          if Cust.GET(CustomerNo) then begin
            if Cust."Primary Contact No." <> '' then
              "Bill-to Contact No." := Cust."Primary Contact No."
            else begin
              ContBusRel.RESET;
              ContBusRel.SETCURRENTKEY("Link to Table","No.");
              ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::Customer);
              ContBusRel.SETRANGE("No.","Bill-to Customer No.");
              if ContBusRel.FINDFIRST then
                "Bill-to Contact No." := ContBusRel."Contact No."
              else
                "Bill-to Contact No." := '';
            end;
            "Bill-to Contact" := Cust.Contact;
          end;
          if "Bill-to Contact No." <> '' then
            if Contact.GET("Bill-to Contact No.") then
              Contact.CheckIfPrivacyBlockedGeneric;

          OnAfterUpdateBillToCont(Rec,Cust,Contact);
        end;
    */


    //     LOCAL procedure UpdateSellToCust (ContactNo@1002 :
    LOCAL procedure UpdateSellToCust(ContactNo: Code[20])
    var
        //       ContBusinessRelation@1007 :
        ContBusinessRelation: Record 5054;
        //       Customer@1006 :
        Customer: Record 18;
        //       Cont@1005 :
        Cont: Record 5050;
        //       CustTemplate@1004 :
        CustTemplate: Record "Customer Templ.";
        //       SearchContact@1003 :
        SearchContact: Record 5050;
        //       ContactBusinessRelationFound@1001 :
        ContactBusinessRelationFound: Boolean;
    begin
        if not Cont.GET(ContactNo) then begin
            "Sell-to Contact" := '';
            exit;
        end;
        "Sell-to Contact No." := Cont."No.";

        if Cont.Type = Cont.Type::Person then
            ContactBusinessRelationFound := ContBusinessRelation.FindByContact(ContBusinessRelation."Link to Table"::Customer, Cont."No.");
        if not ContactBusinessRelationFound then
            ContactBusinessRelationFound :=
              ContBusinessRelation.FindByContact(ContBusinessRelation."Link to Table"::Customer, Cont."Company No.");

        if ContactBusinessRelationFound then begin
            if ("Sell-to Customer No." <> '') and ("Sell-to Customer No." <> ContBusinessRelation."No.") then
                ERROR(Text037, Cont."No.", Cont.Name, "Sell-to Customer No.");

            if "Sell-to Customer No." = '' then begin
                SkipSellToContact := TRUE;
                VALIDATE("Sell-to Customer No.", ContBusinessRelation."No.");
                SkipSellToContact := FALSE;
            end;

            if (Cont."E-Mail" = '') and ("Sell-to E-Mail" <> '') and GUIALLOWED then begin
                if CONFIRM(ConfirmEmptyEmailQst, FALSE, Cont."No.", "Sell-to E-Mail") then
                    VALIDATE("Sell-to E-Mail", Cont."E-Mail");
            end else
                VALIDATE("Sell-to E-Mail", Cont."E-Mail");
            VALIDATE("Sell-to Phone No.", Cont."Phone No.");
        end else begin
            if "Document Type" = "Document Type"::Quote then begin
                if Cont."Company No." <> '' then
                    SearchContact.GET(Cont."Company No.")
                else
                    SearchContact := Cont;
                "Sell-to Customer Name" := SearchContact."Company Name";
                "Sell-to Customer Name 2" := SearchContact."Name 2";
                "Sell-to Phone No." := SearchContact."Phone No.";
                "Sell-to E-Mail" := SearchContact."E-Mail";
                SetShipToAddress(
                  SearchContact."Company Name", SearchContact."Name 2", SearchContact.Address, SearchContact."Address 2",
                  SearchContact.City, SearchContact."Post Code", SearchContact.County, SearchContact."Country/Region Code");
                if ("Sell-to Customer Templ. Code" = '') and (not CustTemplate.ISEMPTY) then
                    VALIDATE("Sell-to Customer Templ. Code", Cont.FindCustomerTemplate);
            end else
                ERROR(Text039, Cont."No.", Cont.Name);
            "Sell-to Contact" := Cont.Name;
        end;

        if (Cont.Type = Cont.Type::Company) and Customer.GET("Sell-to Customer No.") then
            "Sell-to Contact" := Customer.Contact
        else
            if Cont.Type = Cont.Type::Company then
                "Sell-to Contact" := ''
            else
                "Sell-to Contact" := Cont.Name;

        if "Document Type" = "Document Type"::Quote then begin
            if Customer.GET("Sell-to Customer No.") or Customer.GET(ContBusinessRelation."No.") then begin
                if Customer."Copy Sell-to Addr. to Qte From" = Customer."Copy Sell-to Addr. to Qte From"::Company then begin
                    if Cont."Company No." <> '' then
                        Cont.GET(Cont."Company No.");
                end;
            end else begin
                if Cont."Company No." <> '' then
                    Cont.GET(Cont."Company No.");
            end;
            "Sell-to Address" := Cont.Address;
            "Sell-to Address 2" := Cont."Address 2";
            "Sell-to City" := Cont.City;
            "Sell-to Post Code" := Cont."Post Code";
            "Sell-to County" := Cont.County;
            "Sell-to Country/Region Code" := Cont."Country/Region Code";
        end;
        if ("Sell-to Customer No." = "Bill-to Customer No.") or
           ("Bill-to Customer No." = '')
        then
            VALIDATE("Bill-to Contact No.", "Sell-to Contact No.");

        OnAfterUpdateSellToCust(Rec, Cont);
    end;

    //     LOCAL procedure UpdateBillToCust (ContactNo@1000 :

    /*
    LOCAL procedure UpdateBillToCust (ContactNo: Code[20])
        var
    //       ContBusinessRelation@1005 :
          ContBusinessRelation: Record 5054;
    //       Cust@1004 :
          Cust: Record 18;
    //       Cont@1003 :
          Cont: Record 5050;
    //       CustTemplate@1002 :
          CustTemplate: Record 5105;
    //       SearchContact@1001 :
          SearchContact: Record 5050;
    //       ContactBusinessRelationFound@1007 :
          ContactBusinessRelationFound: Boolean;
        begin
          if not Cont.GET(ContactNo) then begin
            "Bill-to Contact" := '';
            exit;
          end;
          "Bill-to Contact No." := Cont."No.";

          if Cust.GET("Bill-to Customer No.") and (Cont.Type = Cont.Type::Company) then
            "Bill-to Contact" := Cust.Contact
          else
            if Cont.Type = Cont.Type::Company then
              "Bill-to Contact" := ''
            else
              "Bill-to Contact" := Cont.Name;

          if Cont.Type = Cont.Type::Person then
            ContactBusinessRelationFound := ContBusinessRelation.FindByContact(ContBusinessRelation."Link to Table"::Customer,Cont."No.");
          if not ContactBusinessRelationFound then
            ContactBusinessRelationFound :=
              ContBusinessRelation.FindByContact(ContBusinessRelation."Link to Table"::Customer,Cont."Company No.");

          if ContactBusinessRelationFound then begin
            if "Bill-to Customer No." = '' then begin
              SkipBillToContact := TRUE;
              VALIDATE("Bill-to Customer No.",ContBusinessRelation."No.");
              SkipBillToContact := FALSE;
              "Bill-to Customer Template Code" := '';
            end else
              if "Bill-to Customer No." <> ContBusinessRelation."No." then
                ERROR(Text037,Cont."No.",Cont.Name,"Bill-to Customer No.");
          end else begin
            if "Document Type" = "Document Type"::Quote then begin
              if Cont."Company No." <> '' then
                SearchContact.GET(Cont."Company No.")
              else
                SearchContact.GET(Cont."No.");

              "Bill-to Name" := SearchContact."Company Name";
              "Bill-to Name 2" := SearchContact."Name 2";
              "Bill-to Address" := SearchContact.Address;
              "Bill-to Address 2" := SearchContact."Address 2";
              "Bill-to City" := SearchContact.City;
              "Bill-to Post Code" := SearchContact."Post Code";
              "Bill-to County" := SearchContact.County;
              "Bill-to Country/Region Code" := SearchContact."Country/Region Code";
              "VAT Registration No." := SearchContact."VAT Registration No.";
              VALIDATE("Currency Code",SearchContact."Currency Code");
              "Language Code" := SearchContact."Language Code";

              OnUpdateBillToCustOnAfterSalesQuote(Rec,SearchContact);

              if ("Bill-to Customer Template Code" = '') and (not CustTemplate.ISEMPTY) then
                VALIDATE("Bill-to Customer Template Code",Cont.FindCustomerTemplate);
            end else
              ERROR(Text039,Cont."No.",Cont.Name);
          end;
        end;
    */



    /*
    LOCAL procedure UpdateSellToCustTemplateCode ()
        begin
          if ("Document Type" = "Document Type"::Quote) and ("Sell-to Customer No." = '') and ("Sell-to Customer Template Code" = '' ) and
             (GetFilterContNo = '')
          then
            VALIDATE("Sell-to Customer Template Code",SelectSalesHeaderCustomerTemplate);
        end;
    */


    //     LOCAL procedure GetShippingTime (CalledByFieldNo@1000 :

    /*
    LOCAL procedure GetShippingTime (CalledByFieldNo: Integer)
        var
    //       ShippingAgentServices@1001 :
          ShippingAgentServices: Record 5790;
        begin
          if (CalledByFieldNo <> CurrFieldNo) and (CurrFieldNo <> 0) then
            exit;

          if ShippingAgentServices.GET("Shipping Agent Code","Shipping Agent Service Code") then
            "Shipping Time" := ShippingAgentServices."Shipping Time"
          else begin
            GetCust("Sell-to Customer No.");
            "Shipping Time" := Cust."Shipping Time"
          end;
          if not (CalledByFieldNo IN [FIELDNO("Shipping Agent Code"),FIELDNO("Shipping Agent Service Code")]) then
            VALIDATE("Shipping Time");
        end;
    */


    //     LOCAL procedure GetContact (var Contact@1000 : Record 5050;ContactNo@1001 :

    /*
    LOCAL procedure GetContact (var Contact: Record 5050;ContactNo: Code[20])
        begin
          Contact.GET(ContactNo);
          if (Contact.Type = Contact.Type::Person) and (Contact."Company No." <> '') then
            Contact.GET(Contact."Company No.");
        end;
    */




    /*
    procedure CheckCreditMaxBeforeInsert ()
        var
    //       SalesHeader@1001 :
          SalesHeader: Record 36;
    //       ContBusinessRelation@1002 :
          ContBusinessRelation: Record 5054;
    //       Cont@1003 :
          Cont: Record 5050;
    //       CustCheckCreditLimit@1000 :
          CustCheckCreditLimit: Codeunit 312;
        begin
          if HideCreditCheckDialogue then
            exit;
          if (GetFilterCustNo <> '') or ("Sell-to Customer No." <> '') then begin
            if "Sell-to Customer No." <> '' then
              Cust.GET("Sell-to Customer No.")
            else
              Cust.GET(GetFilterCustNo);
            if Cust."Bill-to Customer No." <> '' then
              SalesHeader."Bill-to Customer No." := Cust."Bill-to Customer No."
            else
              SalesHeader."Bill-to Customer No." := Cust."No.";
            CustCheckCreditLimit.SalesHeaderCheck(SalesHeader);
          end else
            if GetFilterContNo <> '' then begin
              Cont.GET(GetFilterContNo);
              if ContBusinessRelation.FindByContact(ContBusinessRelation."Link to Table"::Customer,Cont."Company No.") then begin
                Cust.GET(ContBusinessRelation."No.");
                if Cust."Bill-to Customer No." <> '' then
                  SalesHeader."Bill-to Customer No." := Cust."Bill-to Customer No."
                else
                  SalesHeader."Bill-to Customer No." := Cust."No.";
                CustCheckCreditLimit.SalesHeaderCheck(SalesHeader);
              end;
            end;
        end;
    */




    /*
    procedure CreateInvtPutAwayPick ()
        var
    //       WhseRequest@1000 :
          WhseRequest: Record 5765;
        begin
          if "Document Type" = "Document Type"::Order then
            if not IsApprovedForPosting then
              exit;
          TESTFIELD(Status,Status::Released);

          WhseRequest.RESET;
          WhseRequest.SETCURRENTKEY("Source Document","Source No.");
          CASE "Document Type" OF
            "Document Type"::Order:
              begin
                if "Shipping Advice" = "Shipping Advice"::Complete then
                  CheckShippingAdvice;
                WhseRequest.SETRANGE("Source Document",WhseRequest."Source Document"::"Sales Order");
              end;
            "Document Type"::"Return Order":
              WhseRequest.SETRANGE("Source Document",WhseRequest."Source Document"::"Sales Return Order");
          end;
          WhseRequest.SETRANGE("Source No.","No.");
          REPORT.RUNMODAL(REPORT::"Create Invt Put-away/Pick/Mvmt",TRUE,FALSE,WhseRequest);
        end;
    */




    /*
    procedure CreateTask ()
        var
    //       TempTask@1000 :
          TempTask: Record 5080 TEMPORARY;
        begin
          TESTFIELD("Sell-to Contact No.");
          TempTask.CreateTaskFromSalesHeader(Rec);
        end;
    */




    /*
    procedure UpdateShipToAddress ()
        begin
          if IsCreditDocType then begin
            if "Location Code" <> '' then begin
              Location.GET("Location Code");
              SetShipToAddress(
                Location.Name,Location."Name 2",Location.Address,Location."Address 2",Location.City,
                Location."Post Code",Location.County,Location."Country/Region Code");
              "Ship-to Contact" := Location.Contact;
            end else begin
              CompanyInfo.GET;
              "Ship-to Code" := '';
              SetShipToAddress(
                CompanyInfo."Ship-to Name",CompanyInfo."Ship-to Name 2",CompanyInfo."Ship-to Address",CompanyInfo."Ship-to Address 2",
                CompanyInfo."Ship-to City",CompanyInfo."Ship-to Post Code",CompanyInfo."Ship-to County",
                CompanyInfo."Ship-to Country/Region Code");
              "Ship-to Contact" := CompanyInfo."Ship-to Contact";
            end;
            "VAT Country/Region Code" := "Sell-to Country/Region Code";
          end;

          OnAfterUpdateShipToAddress(Rec,xRec);
        end;
    */




    /*
    procedure ShowDocDim ()
        var
    //       OldDimSetID@1000 :
          OldDimSetID: Integer;
        begin
          OldDimSetID := "Dimension Set ID";
          "Dimension Set ID" :=
            DimMgt.EditDimensionSet2(
              "Dimension Set ID",STRSUBSTNO('%1 %2',"Document Type","No."),
              "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
          if OldDimSetID <> "Dimension Set ID" then begin
            MODIFY;
            if SalesLinesExist then
              UpdateAllLineDim("Dimension Set ID",OldDimSetID);
          end;
        end;
    */



    //     procedure UpdateAllLineDim (NewParentDimSetID@1000 : Integer;OldParentDimSetID@1001 :

    /*
    procedure UpdateAllLineDim (NewParentDimSetID: Integer;OldParentDimSetID: Integer)
        var
    //       ATOLink@1003 :
          ATOLink: Record 904;
    //       NewDimSetID@1002 :
          NewDimSetID: Integer;
    //       ShippedReceivedItemLineDimChangeConfirmed@1004 :
          ShippedReceivedItemLineDimChangeConfirmed: Boolean;
        begin
          // Update all lines with changed dimensions.

          if NewParentDimSetID = OldParentDimSetID then
            exit;
          if not GetHideValidationDialog and GUIALLOWED then
            if not CONFIRM(Text064) then
              exit;

          SalesLine.RESET;
          SalesLine.SETRANGE("Document Type","Document Type");
          SalesLine.SETRANGE("Document No.","No.");
          SalesLine.LOCKTABLE;
          if SalesLine.FIND('-') then
            repeat
              NewDimSetID := DimMgt.GetDeltaDimSetID(SalesLine."Dimension Set ID",NewParentDimSetID,OldParentDimSetID);
              if SalesLine."Dimension Set ID" <> NewDimSetID then begin
                SalesLine."Dimension Set ID" := NewDimSetID;

                if not GetHideValidationDialog and GUIALLOWED then
                  VerifyShippedReceivedItemLineDimChange(ShippedReceivedItemLineDimChangeConfirmed);

                DimMgt.UpdateGlobalDimFromDimSetID(
                  SalesLine."Dimension Set ID",SalesLine."Shortcut Dimension 1 Code",SalesLine."Shortcut Dimension 2 Code");
                SalesLine.MODIFY;
                ATOLink.UpdateAsmDimFromSalesLine(SalesLine);
              end;
            until SalesLine.NEXT = 0;
        end;
    */


    //     LOCAL procedure VerifyShippedReceivedItemLineDimChange (var ShippedReceivedItemLineDimChangeConfirmed@1000 :

    /*
    LOCAL procedure VerifyShippedReceivedItemLineDimChange (var ShippedReceivedItemLineDimChangeConfirmed: Boolean)
        begin
          if SalesLine.IsShippedReceivedItemDimChanged then
            if not ShippedReceivedItemLineDimChangeConfirmed then
              ShippedReceivedItemLineDimChangeConfirmed := SalesLine.ConfirmShippedReceivedItemDimChange;
        end;
    */



    //     procedure LookupAdjmtValueEntries (QtyType@1000 :

    /*
    procedure LookupAdjmtValueEntries (QtyType: Option "General","Invoicin")
        var
    //       ItemLedgEntry@1004 :
          ItemLedgEntry: Record 32;
    //       SalesLine@1001 :
          SalesLine: Record 37;
    //       SalesShptLine@1005 :
          SalesShptLine: Record 111;
    //       ReturnRcptLine@1002 :
          ReturnRcptLine: Record 6661;
    //       TempValueEntry@1003 :
          TempValueEntry: Record 5802 TEMPORARY;
        begin
          SalesLine.SETRANGE("Document Type","Document Type");
          SalesLine.SETRANGE("Document No.","No.");
          TempValueEntry.RESET;
          TempValueEntry.DELETEALL;

          CASE "Document Type" OF
            "Document Type"::Order,"Document Type"::Invoice:
              begin
                if SalesLine.FINDSET then
                  repeat
                    if (SalesLine.Type = SalesLine.Type::Item) and (SalesLine.Quantity <> 0) then
                      WITH SalesShptLine DO begin
                        if SalesLine."Shipment No." <> '' then begin
                          SETRANGE("Document No.",SalesLine."Shipment No.");
                          SETRANGE("Line No.",SalesLine."Shipment Line No.");
                        end else begin
                          SETCURRENTKEY("Order No.","Order Line No.");
                          SETRANGE("Order No.",SalesLine."Document No.");
                          SETRANGE("Order Line No.",SalesLine."Line No.");
                        end;
                        SETRANGE(Correction,FALSE);
                        if QtyType = QtyType::Invoicing then
                          SETFILTER("Qty. Shipped not Invoiced",'<>0');

                        if FINDSET then
                          repeat
                            FilterPstdDocLnItemLedgEntries(ItemLedgEntry);
                            if ItemLedgEntry.FINDSET then
                              repeat
                                CreateTempAdjmtValueEntries(TempValueEntry,ItemLedgEntry."Entry No.");
                              until ItemLedgEntry.NEXT = 0;
                          until NEXT = 0;
                      end;
                  until SalesLine.NEXT = 0;
              end;
            "Document Type"::"Return Order","Document Type"::"Credit Memo":
              begin
                if SalesLine.FINDSET then
                  repeat
                    if (SalesLine.Type = SalesLine.Type::Item) and (SalesLine.Quantity <> 0) then
                      WITH ReturnRcptLine DO begin
                        if SalesLine."Return Receipt No." <> '' then begin
                          SETRANGE("Document No.",SalesLine."Return Receipt No.");
                          SETRANGE("Line No.",SalesLine."Return Receipt Line No.");
                        end else begin
                          SETCURRENTKEY("Return Order No.","Return Order Line No.");
                          SETRANGE("Return Order No.",SalesLine."Document No.");
                          SETRANGE("Return Order Line No.",SalesLine."Line No.");
                        end;
                        SETRANGE(Correction,FALSE);
                        if QtyType = QtyType::Invoicing then
                          SETFILTER("Return Qty. Rcd. not Invd.",'<>0');

                        if FINDSET then
                          repeat
                            FilterPstdDocLnItemLedgEntries(ItemLedgEntry);
                            if ItemLedgEntry.FINDSET then
                              repeat
                                CreateTempAdjmtValueEntries(TempValueEntry,ItemLedgEntry."Entry No.");
                              until ItemLedgEntry.NEXT = 0;
                          until NEXT = 0;
                      end;
                  until SalesLine.NEXT = 0;
              end;
          end;
          PAGE.RUNMODAL(0,TempValueEntry);
        end;
    */




    /*
    procedure GetCustomerVATRegistrationNumber () : Text;
        begin
          exit("VAT Registration No.");
        end;
    */




    /*
    procedure GetCustomerVATRegistrationNumberLbl () : Text;
        begin
          exit(FIELDCAPTION("VAT Registration No."));
        end;
    */




    /*
    procedure GetCustomerGlobalLocationNumber () : Text;
        begin
          exit('');
        end;
    */




    /*
    procedure GetCustomerGlobalLocationNumberLbl () : Text;
        begin
          exit('');
        end;
    */


    //     LOCAL procedure CreateTempAdjmtValueEntries (var TempValueEntry@1001 : TEMPORARY Record 5802;ItemLedgEntryNo@1000 :

    /*
    LOCAL procedure CreateTempAdjmtValueEntries (var TempValueEntry: Record 5802 TEMPORARY;ItemLedgEntryNo: Integer)
        var
    //       ValueEntry@1002 :
          ValueEntry: Record 5802;
        begin
          WITH ValueEntry DO begin
            SETCURRENTKEY("Item Ledger Entry No.");
            SETRANGE("Item Ledger Entry No.",ItemLedgEntryNo);
            if FINDSET then
              repeat
                if Adjustment then begin
                  TempValueEntry := ValueEntry;
                  if TempValueEntry.INSERT then;
                end;
              until NEXT = 0;
          end;
        end;
    */




    /*
    procedure GetPstdDocLinesToRevere ()
        var
    //       SalesPostedDocLines@1000 :
          SalesPostedDocLines: Page 5850;
        begin
          GetCust("Sell-to Customer No.");
          SalesPostedDocLines.SetToSalesHeader(Rec);
          SalesPostedDocLines.SETRECORD(Cust);
          SalesPostedDocLines.LOOKUPMODE := TRUE;
          if SalesPostedDocLines.RUNMODAL = ACTION::LookupOK then
            SalesPostedDocLines.CopyLineToDoc;

          CLEAR(SalesPostedDocLines);
        end;
    */




    /*
    procedure CalcInvDiscForHeader ()
        var
    //       SalesInvDisc@1000 :
          SalesInvDisc: Codeunit 60;
        begin
          SalesSetup.GET;
          if SalesSetup."Calc. Inv. Discount" then
            SalesInvDisc.CalculateIncDiscForHeader(Rec);
        end;
    */




    /*
    procedure SetSecurityFilterOnRespCenter ()
        begin
          if UserSetupMgt.GetSalesFilter <> '' then begin
            FILTERGROUP(2);
            SETRANGE("Responsibility Center",UserSetupMgt.GetSalesFilter);
            FILTERGROUP(0);
          end;

          SETRANGE("Date Filter",0D,WORKDATE - 1);
        end;
    */


    //     LOCAL procedure SynchronizeForReservations (var NewSalesLine@1000 : Record 37;OldSalesLine@1001 :

    /*
    LOCAL procedure SynchronizeForReservations (var NewSalesLine: Record 37;OldSalesLine: Record 37)
        begin
          NewSalesLine.CALCFIELDS("Reserved Quantity");
          if NewSalesLine."Reserved Quantity" = 0 then
            exit;
          if NewSalesLine."Location Code" <> OldSalesLine."Location Code" then
            NewSalesLine.VALIDATE("Location Code",OldSalesLine."Location Code");
          if NewSalesLine."Bin Code" <> OldSalesLine."Bin Code" then
            NewSalesLine.VALIDATE("Bin Code",OldSalesLine."Bin Code");
          if NewSalesLine.MODIFY then;
        end;
    */



    //     procedure InventoryPickConflict (DocType@1002 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';DocNo@1003 : Code[20];ShippingAdvice@1004 :

    /*
    procedure InventoryPickConflict (DocType: Option "Quote","Order","Invoice","Credit Memo","Blanket Order","Return Order";DocNo: Code[20];ShippingAdvice: Option "Partial","Complet") : Boolean;
        var
    //       WarehouseActivityLine@1000 :
          WarehouseActivityLine: Record 5767;
    //       SalesLine@1001 :
          SalesLine: Record 37;
        begin
          if ShippingAdvice <> ShippingAdvice::Complete then
            exit(FALSE);
          WarehouseActivityLine.SETCURRENTKEY("Source Type","Source Subtype","Source No.");
          WarehouseActivityLine.SETRANGE("Source Type",DATABASE::"Sales Line");
          WarehouseActivityLine.SETRANGE("Source Subtype",DocType);
          WarehouseActivityLine.SETRANGE("Source No.",DocNo);
          if WarehouseActivityLine.ISEMPTY then
            exit(FALSE);
          SalesLine.SETRANGE("Document Type",DocType);
          SalesLine.SETRANGE("Document No.",DocNo);
          SalesLine.SETRANGE(Type,SalesLine.Type::Item);
          if SalesLine.ISEMPTY then
            exit(FALSE);
          exit(TRUE);
        end;
    */



    //     procedure WhseShpmntConflict (DocType@1002 : 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';DocNo@1001 : Code[20];ShippingAdvice@1000 :

    /*
    procedure WhseShpmntConflict (DocType: Option "Quote","Order","Invoice","Credit Memo","Blanket Order","Return Order";DocNo: Code[20];ShippingAdvice: Option "Partial","Complet") : Boolean;
        var
    //       WarehouseShipmentLine@1003 :
          WarehouseShipmentLine: Record 7321;
        begin
          if ShippingAdvice <> ShippingAdvice::Complete then
            exit(FALSE);
          WarehouseShipmentLine.SETCURRENTKEY("Source Type","Source Subtype","Source No.","Source Line No.");
          WarehouseShipmentLine.SETRANGE("Source Type",DATABASE::"Sales Line");
          WarehouseShipmentLine.SETRANGE("Source Subtype",DocType);
          WarehouseShipmentLine.SETRANGE("Source No.",DocNo);
          if WarehouseShipmentLine.ISEMPTY then
            exit(FALSE);
          exit(TRUE);
        end;
    */



    /*
    LOCAL procedure CheckCreditLimit ()
        var
    //       SalesHeader@1000 :
          SalesHeader: Record 36;
    //       IsHandled@1001 :
          IsHandled: Boolean;
        begin
          SalesHeader := Rec;

          if GUIALLOWED and
             (CurrFieldNo <> 0) and CheckCreditLimitCondition and SalesHeader.FIND
          then begin
            "Amount Including VAT" := 0;
            if "Document Type" = "Document Type"::Order then
              if BilltoCustomerNoChanged then begin
                SalesLine.SETRANGE("Document Type",SalesLine."Document Type"::Order);
                SalesLine.SETRANGE("Document No.","No.");
                SalesLine.CALCSUMS("Outstanding Amount","Shipped not Invoiced");
                "Amount Including VAT" := SalesLine."Outstanding Amount" + SalesLine."Shipped not Invoiced";
              end;

            IsHandled := FALSE;
            OnBeforeCheckCreditLimit(Rec,IsHandled);
            if not IsHandled then
              CustCheckCreditLimit.SalesHeaderCheck(Rec);

            CALCFIELDS("Amount Including VAT");
          end;
        end;
    */



    /*
    LOCAL procedure CheckCreditLimitCondition () : Boolean;
        var
    //       RunCheck@1000 :
          RunCheck: Boolean;
        begin
          RunCheck := ("Document Type" <= "Document Type"::Invoice) or ("Document Type" = "Document Type"::"Blanket Order");
          OnAfterCheckCreditLimitCondition(Rec,RunCheck);
          exit(RunCheck);
        end;
    */




    /*
    procedure CheckItemAvailabilityInLines ()
        var
    //       SalesLine@1000 :
          SalesLine: Record 37;
    //       ItemCheckAvail@1001 :
          ItemCheckAvail: Codeunit 311;
        begin
          SalesLine.SETRANGE("Document Type","Document Type");
          SalesLine.SETRANGE("Document No.","No.");
          SalesLine.SETRANGE(Type,SalesLine.Type::Item);
          SalesLine.SETFILTER("No.",'<>%1','');
          SalesLine.SETFILTER("Outstanding Quantity",'<>%1',0);
          if SalesLine.FINDSET then
            repeat
              if ItemCheckAvail.SalesLineCheck(SalesLine) then
                ItemCheckAvail.RaiseUpdateInterruptedError;
            until SalesLine.NEXT = 0;
        end;
    */




    /*
    procedure QtyToShipIsZero () : Boolean;
        begin
          SalesLine.RESET;
          SalesLine.SETRANGE("Document Type","Document Type");
          SalesLine.SETRANGE("Document No.","No.");
          SalesLine.SETFILTER("Qty. to Ship",'<>0');
          exit(SalesLine.ISEMPTY);
        end;
    */




    /*
    procedure IsApprovedForPosting () : Boolean;
        var
    //       PrepaymentMgt@1001 :
          PrepaymentMgt: Codeunit 441;
        begin
          if ApprovalsMgmt.PrePostApprovalCheckSales(Rec) then begin
            if PrepaymentMgt.TestSalesPrepayment(Rec) then
              ERROR(PrepaymentInvoicesNotPaidErr,"Document Type","No.");
            if "Document Type" = "Document Type"::Order then
              if PrepaymentMgt.TestSalesPayment(Rec) then
                ERROR(Text072,"Document Type","No.");
            exit(TRUE);
          end;
        end;
    */




    /*
    procedure IsApprovedForPostingBatch () : Boolean;
        var
    //       PrepaymentMgt@1000 :
          PrepaymentMgt: Codeunit 441;
        begin
          if ApprovalsMgmt.PrePostApprovalCheckSales(Rec) then begin
            if PrepaymentMgt.TestSalesPrepayment(Rec) then
              exit(FALSE);
            if PrepaymentMgt.TestSalesPayment(Rec) then
              exit(FALSE);
            exit(TRUE);
          end;
        end;
    */



    /*
    procedure ValidatePaymentTerms ()
        begin
          GLSetup.GET;
          if ("Document Type" <> "Document Type"::"Credit Memo") or
             (GLSetup."Payment Discount Type" = GLSetup."Payment Discount Type"::"Calc. Pmt. Disc. on Lines")
          then
            if ("Payment Terms Code" <> '') and ("Document Date" <> 0D) then begin
              PaymentTerms.GET("Payment Terms Code");
              "Due Date" := CALCDATE(PaymentTerms."Due Date Calculation","Document Date");
              AdjustDueDate.SalesAdjustDueDate(
                "Due Date","Document Date",PaymentTerms.CalculateMaxDueDate("Document Date"),"Bill-to Customer No.");
              "Pmt. Discount Date" := CALCDATE(PaymentTerms."Due Date Calculation","Document Date");
            end else begin
              "Due Date" := "Document Date";
              AdjustDueDate.SalesAdjustDueDate("Due Date","Document Date",12319999D,"Bill-to Customer No.");
              "Pmt. Discount Date" := "Document Date";
            end;
        end;
    */




    /*
    procedure GetLegalStatement () : Text;
        begin
          SalesSetup.GET;
          exit(SalesSetup.GetLegalStatement);
        end;
    */



    //     procedure SendToPosting (PostingCodeunitID@1000 :

    /*
    procedure SendToPosting (PostingCodeunitID: Integer)
        begin
          if not IsApprovedForPosting then
            exit;
          CODEUNIT.RUN(PostingCodeunitID,Rec);
        end;
    */




    /*
    procedure CancelBackgroundPosting ()
        var
    //       SalesPostViaJobQueue@1000 :
          SalesPostViaJobQueue: Codeunit 88;
        begin
          SalesPostViaJobQueue.CancelQueueEntry(Rec);
        end;
    */



    //     procedure EmailRecords (ShowDialog@1000 :

    /*
    procedure EmailRecords (ShowDialog: Boolean)
        var
    //       DocumentSendingProfile@1003 :
          DocumentSendingProfile: Record 60;
    //       DummyReportSelections@1001 :
          DummyReportSelections: Record 77;
        begin
          CASE "Document Type" OF
            "Document Type"::Quote:
              begin
                DocumentSendingProfile.TrySendToEMail(
                  DummyReportSelections.Usage::"S.Quote",Rec,FIELDNO("No."),
                  GetDocTypeTxt,FIELDNO("Bill-to Customer No."),ShowDialog);
                FIND;
                "Quote Sent to Customer" := CURRENTDATETIME;
                MODIFY;
              end;
            "Document Type"::Invoice:
              DocumentSendingProfile.TrySendToEMail(
                DummyReportSelections.Usage::"S.Invoice Draft",Rec,FIELDNO("No."),
                GetDocTypeTxt,FIELDNO("Bill-to Customer No."),ShowDialog);
          end;

          OnAfterSendSalesHeader(Rec,ShowDialog);
        end;
    */




    /*
    procedure GetDocTypeTxt () : Text[50];
        var
    //       IdentityManagement@1000 :
          IdentityManagement: Codeunit 9801;
        begin
          if "Document Type" = "Document Type"::Quote then
            if IdentityManagement.IsInvAppId then
              exit(EstimateTxt);
          exit(FORMAT("Document Type"));
        end;
    */



    //     procedure LinkSalesDocWithOpportunity (OldOpportunityNo@1000 :

    /*
    procedure LinkSalesDocWithOpportunity (OldOpportunityNo: Code[20])
        var
    //       SalesHeader@1001 :
          SalesHeader: Record 36;
    //       Opportunity@1002 :
          Opportunity: Record 5092;
    //       ConfirmManagement@1003 :
          ConfirmManagement: Codeunit 27;
        begin
          if "Opportunity No." <> OldOpportunityNo then begin
            if "Opportunity No." <> '' then
              if Opportunity.GET("Opportunity No.") then begin
                Opportunity.TESTFIELD(Status,Opportunity.Status::"In Progress");
                if Opportunity."Sales Document No." <> '' then begin
                  if ConfirmManagement.ConfirmProcess(
                       STRSUBSTNO(Text048,Opportunity."Sales Document No.",Opportunity."No."),TRUE)
                  then begin
                    if SalesHeader.GET("Document Type"::Quote,Opportunity."Sales Document No.") then begin
                      SalesHeader."Opportunity No." := '';
                      SalesHeader.MODIFY;
                    end;
                    UpdateOpportunityLink(Opportunity,Opportunity."Sales Document Type"::Quote,"No.");
                  end else
                    "Opportunity No." := OldOpportunityNo;
                end else
                  UpdateOpportunityLink(Opportunity,Opportunity."Sales Document Type"::Quote,"No.");
              end;
            if (OldOpportunityNo <> '') and Opportunity.GET(OldOpportunityNo) then
              UpdateOpportunityLink(Opportunity,Opportunity."Sales Document Type"::" ",'');
          end;
        end;
    */


    //     LOCAL procedure UpdateOpportunityLink (Opportunity@1000 : Record 5092;SalesDocumentType@1001 : Option;SalesHeaderNo@1002 :

    /*
    LOCAL procedure UpdateOpportunityLink (Opportunity: Record 5092;SalesDocumentType: Option;SalesHeaderNo: Code[20])
        begin
          Opportunity."Sales Document Type" := SalesDocumentType;
          Opportunity."Sales Document No." := SalesHeaderNo;
          Opportunity.MODIFY;
        end;
    */




    /*
    procedure SynchronizeAsmHeader ()
        var
    //       AsmHeader@1003 :
          AsmHeader: Record 900;
    //       ATOLink@1002 :
          ATOLink: Record 904;
    //       Window@1000 :
          Window: Dialog;
        begin
          ATOLink.SETCURRENTKEY(Type,"Document Type","Document No.");
          ATOLink.SETRANGE(Type,ATOLink.Type::Sale);
          ATOLink.SETRANGE("Document Type","Document Type");
          ATOLink.SETRANGE("Document No.","No.");
          if ATOLink.FINDSET then
            repeat
              if AsmHeader.GET(ATOLink."Assembly Document Type",ATOLink."Assembly Document No.") then
                if "Posting Date" <> AsmHeader."Posting Date" then begin
                  Window.OPEN(STRSUBSTNO(SynchronizingMsg,"No.",AsmHeader."No."));
                  AsmHeader.VALIDATE("Posting Date","Posting Date");
                  AsmHeader.MODIFY;
                  Window.CLOSE;
                end;
            until ATOLink.NEXT = 0;
        end;
    */




    /*
    procedure CheckShippingAdvice ()
        var
    //       SalesLine@1000 :
          SalesLine: Record 37;
    //       Item@1003 :
          Item: Record 27;
    //       QtyToShipBaseTotal@1002 :
          QtyToShipBaseTotal: Decimal;
    //       Result@1001 :
          Result: Boolean;
        begin
          SalesLine.SETRANGE("Document Type","Document Type");
          SalesLine.SETRANGE("Document No.","No.");
          SalesLine.SETRANGE("Drop Shipment",FALSE);
          SalesLine.SETRANGE(Type,SalesLine.Type::Item);
          Result := TRUE;
          if SalesLine.FINDSET then
            repeat
              Item.GET(SalesLine."No.");
              if SalesLine.IsShipment and (Item.Type = Item.Type::Inventory) then begin
                QtyToShipBaseTotal += SalesLine."Qty. to Ship (Base)";
                if SalesLine."Quantity (Base)" <>
                   SalesLine."Qty. to Ship (Base)" + SalesLine."Qty. Shipped (Base)"
                then
                  Result := FALSE;
              end;
            until SalesLine.NEXT = 0;
          if QtyToShipBaseTotal = 0 then
            Result := TRUE;
          if not Result then
            ERROR(ShippingAdviceErr);
        end;
    */



    /*
    LOCAL procedure GetFilterCustNo () : Code[20];
        var
    //       MinValue@1002 :
          MinValue: Code[20];
    //       MaxValue@1001 :
          MaxValue: Code[20];
        begin
          if GETFILTER("Sell-to Customer No.") <> '' then begin
            if TryGetFilterCustNoRange(MinValue,MaxValue) then
              if MinValue = MaxValue then
                exit(MaxValue);
          end;
        end;

        [TryFunction]
    */

    //     LOCAL procedure TryGetFilterCustNoRange (var MinValue@1001 : Code[20];var MaxValue@1000 :

    /*
    LOCAL procedure TryGetFilterCustNoRange (var MinValue: Code[20];var MaxValue: Code[20])
        begin
          MinValue := GETRANGEMIN("Sell-to Customer No.");
          MaxValue := GETRANGEMAX("Sell-to Customer No.");
        end;
    */



    /*
    LOCAL procedure GetFilterCustNoByApplyingFilter () : Code[20];
        var
    //       SalesHeader@1002 :
          SalesHeader: Record 36;
    //       MinValue@1001 :
          MinValue: Code[20];
    //       MaxValue@1000 :
          MaxValue: Code[20];
        begin
          if GETFILTER("Sell-to Customer No.") <> '' then begin
            SalesHeader.COPYFILTERS(Rec);
            SalesHeader.SETCURRENTKEY("Sell-to Customer No.");
            if SalesHeader.FINDFIRST then
              MinValue := SalesHeader."Sell-to Customer No.";
            if SalesHeader.FINDLAST then
              MaxValue := SalesHeader."Sell-to Customer No.";
            if MinValue = MaxValue then
              exit(MaxValue);
          end;
        end;
    */



    /*
    LOCAL procedure GetFilterContNo () : Code[20];
        begin
          if GETFILTER("Sell-to Contact No.") <> '' then
            if GETRANGEMIN("Sell-to Contact No.") = GETRANGEMAX("Sell-to Contact No.") then
              exit(GETRANGEMAX("Sell-to Contact No."));
        end;
    */



    /*
    LOCAL procedure CheckCreditLimitIfLineNotInsertedYet ()
        begin
          if "No." = '' then begin
            HideCreditCheckDialogue := FALSE;
            CheckCreditMaxBeforeInsert;
            HideCreditCheckDialogue := TRUE;
          end;
        end;
    */




    /*
    procedure InvoicedLineExists () : Boolean;
        var
    //       SalesLine@1000 :
          SalesLine: Record 37;
        begin
          SalesLine.SETRANGE("Document Type","Document Type");
          SalesLine.SETRANGE("Document No.","No.");
          SalesLine.SETFILTER(Type,'<>%1',SalesLine.Type::" ");
          SalesLine.SETFILTER("Quantity Invoiced",'<>%1',0);
          exit(not SalesLine.ISEMPTY);
        end;
    */




    /*
    procedure CreateDimSetForPrepmtAccDefaultDim ()
        var
    //       SalesLine@1000 :
          SalesLine: Record 37;
    //       TempSalesLine@1003 :
          TempSalesLine: Record 37 TEMPORARY;
        begin
          SalesLine.SETRANGE("Document Type","Document Type");
          SalesLine.SETRANGE("Document No.","No.");
          SalesLine.SETFILTER("Prepmt. Amt. Inv.",'<>%1',0);
          if SalesLine.FINDSET then
            repeat
              CollectParamsInBufferForCreateDimSet(TempSalesLine,SalesLine);
            until SalesLine.NEXT = 0;
          TempSalesLine.RESET;
          TempSalesLine.MARKEDONLY(FALSE);
          if TempSalesLine.FINDSET then
            repeat
              SalesLine.CreateDim(DATABASE::"G/L Account",TempSalesLine."No.",
                DATABASE::Job,TempSalesLine."Job No.",
                DATABASE::"Responsibility Center",TempSalesLine."Responsibility Center");
            until TempSalesLine.NEXT = 0;
        end;
    */


    //     LOCAL procedure CollectParamsInBufferForCreateDimSet (var TempSalesLine@1000 : TEMPORARY Record 37;SalesLine@1001 :

    /*
    LOCAL procedure CollectParamsInBufferForCreateDimSet (var TempSalesLine: Record 37 TEMPORARY;SalesLine: Record 37)
        var
    //       GenPostingSetup@1003 :
          GenPostingSetup: Record 252;
    //       DefaultDimension@1002 :
          DefaultDimension: Record 352;
        begin
          TempSalesLine.SETRANGE("Gen. Bus. Posting Group",SalesLine."Gen. Bus. Posting Group");
          TempSalesLine.SETRANGE("Gen. Prod. Posting Group",SalesLine."Gen. Prod. Posting Group");
          if not TempSalesLine.FINDFIRST then begin
            GenPostingSetup.GET(SalesLine."Gen. Bus. Posting Group",SalesLine."Gen. Prod. Posting Group");
            DefaultDimension.SETRANGE("Table ID",DATABASE::"G/L Account");
            DefaultDimension.SETRANGE("No.",GenPostingSetup.GetSalesPrepmtAccount);
            InsertTempSalesLineInBuffer(TempSalesLine,SalesLine,GenPostingSetup."Sales Prepayments Account",DefaultDimension.ISEMPTY);
          end else
            if not TempSalesLine.MARK then begin
              TempSalesLine.SETRANGE("Job No.",SalesLine."Job No.");
              TempSalesLine.SETRANGE("Responsibility Center",SalesLine."Responsibility Center");
              if TempSalesLine.ISEMPTY then
                InsertTempSalesLineInBuffer(TempSalesLine,SalesLine,TempSalesLine."No.",FALSE);
            end;
        end;
    */


    //     LOCAL procedure InsertTempSalesLineInBuffer (var TempSalesLine@1001 : TEMPORARY Record 37;SalesLine@1000 : Record 37;AccountNo@1002 : Code[20];DefaultDimensionsNotExist@1003 :

    /*
    LOCAL procedure InsertTempSalesLineInBuffer (var TempSalesLine: Record 37 TEMPORARY;SalesLine: Record 37;AccountNo: Code[20];DefaultDimensionsNotExist: Boolean)
        begin
          TempSalesLine.INIT;
          TempSalesLine."Line No." := SalesLine."Line No.";
          TempSalesLine."No." := AccountNo;
          TempSalesLine."Job No." := SalesLine."Job No.";
          TempSalesLine."Responsibility Center" := SalesLine."Responsibility Center";
          TempSalesLine."Gen. Bus. Posting Group" := SalesLine."Gen. Bus. Posting Group";
          TempSalesLine."Gen. Prod. Posting Group" := SalesLine."Gen. Prod. Posting Group";
          TempSalesLine.MARK := DefaultDimensionsNotExist;
          TempSalesLine.INSERT;
        end;
    */




    /*
    procedure OpenSalesOrderStatistics ()
        begin
          CalcInvDiscForHeader;
          CreateDimSetForPrepmtAccDefaultDim;
          COMMIT;
          PAGE.RUNMODAL(PAGE::"Sales Order Statistics",Rec);
        end;
    */




    /*
    procedure GetCardpageID () : Integer;
        begin
          CASE "Document Type" OF
            "Document Type"::Quote:
              exit(PAGE::"Sales Quote");
            "Document Type"::Order:
              exit(PAGE::"Sales Order");
            "Document Type"::Invoice:
              exit(PAGE::"Sales Invoice");
            "Document Type"::"Credit Memo":
              exit(PAGE::"Sales Credit Memo");
            "Document Type"::"Blanket Order":
              exit(PAGE::"Blanket Sales Order");
            "Document Type"::"Return Order":
              exit(PAGE::"Sales Return Order");
          end;
        end;
    */




    /*
    procedure CheckAvailableCreditLimit () : Decimal;
        var
    //       Customer@1000 :
          Customer: Record 18;
    //       AvailableCreditLimit@1002 :
          AvailableCreditLimit: Decimal;
        begin
          if ("Bill-to Customer No." = '') and ("Sell-to Customer No." = '') then
            exit(0);

          if not Customer.GET("Bill-to Customer No.") then
            Customer.GET("Sell-to Customer No.");

          AvailableCreditLimit := Customer.CalcAvailableCredit;

          if AvailableCreditLimit < 0 then
            OnCustomerCreditLimitExceeded
          else
            OnCustomerCreditLimitNotExceeded;

          exit(AvailableCreditLimit);
        end;
    */



    //     procedure SetStatus (NewStatus@1000 :

    /*
    procedure SetStatus (NewStatus: Option)
        begin
          Status := NewStatus;
          MODIFY;
        end;
    */



    /*
    LOCAL procedure TestSalesLineFieldsBeforeRecreate ()
        begin
          SalesLine.TESTFIELD("Job No.",'');
          SalesLine.TESTFIELD("Job Contract Entry No.",0);
          SalesLine.TESTFIELD("Quantity Invoiced",0);
          SalesLine.TESTFIELD("Return Qty. Received",0);
          SalesLine.TESTFIELD("Shipment No.",'');
          SalesLine.TESTFIELD("Return Receipt No.",'');
          SalesLine.TESTFIELD("Blanket Order No.",'');
          SalesLine.TESTFIELD("Prepmt. Amt. Inv.",0);
          TestQuantityShippedField(SalesLine);
        end;
    */


    //     LOCAL procedure RecreateReservEntryReqLine (var TempSalesLine@1000 : TEMPORARY Record 37;var TempATOLink@1003 : TEMPORARY Record 904;var ATOLink@1002 :

    /*
    LOCAL procedure RecreateReservEntryReqLine (var TempSalesLine: Record 37 TEMPORARY;var TempATOLink: Record 904 TEMPORARY;var ATOLink: Record 904)
        begin
          repeat
            TestSalesLineFieldsBeforeRecreate;
            if (SalesLine."Location Code" <> "Location Code") and (not SalesLine.IsNonInventoriableItem) then
              SalesLine.VALIDATE("Location Code","Location Code");
            TempSalesLine := SalesLine;
            if SalesLine.Nonstock then begin
              SalesLine.Nonstock := FALSE;
              SalesLine.MODIFY;
            end;

            if ATOLink.AsmExistsForSalesLine(TempSalesLine) then begin
              TempATOLink := ATOLink;
              TempATOLink.INSERT;
              ATOLink.DELETE;
            end;

            TempSalesLine.INSERT;
            OnAfterInsertTempSalesLine(SalesLine,TempSalesLine);
            SalesLineReserve.CopyReservEntryToTemp(TempReservEntry,SalesLine);
            RecreateReqLine(SalesLine,0,TRUE);
          until SalesLine.NEXT = 0;
        end;
    */


    //     LOCAL procedure TransferItemChargeAssgntSalesToTemp (var ItemChargeAssgntSales@1001 : Record 5809;var TempItemChargeAssgntSales@1000 :

    /*
    LOCAL procedure TransferItemChargeAssgntSalesToTemp (var ItemChargeAssgntSales: Record 5809;var TempItemChargeAssgntSales: Record 5809 TEMPORARY)
        begin
          ItemChargeAssgntSales.SETRANGE("Document Type","Document Type");
          ItemChargeAssgntSales.SETRANGE("Document No.","No.");
          if ItemChargeAssgntSales.FINDSET then begin
            repeat
              TempItemChargeAssgntSales.INIT;
              TempItemChargeAssgntSales := ItemChargeAssgntSales;
              TempItemChargeAssgntSales.INSERT;
            until ItemChargeAssgntSales.NEXT = 0;
            ItemChargeAssgntSales.DELETEALL;
          end;
        end;
    */


    //     LOCAL procedure CreateSalesLine (var TempSalesLine@1000 :

    /*
    LOCAL procedure CreateSalesLine (var TempSalesLine: Record 37 TEMPORARY)
        begin
          SalesLine.INIT;
          SalesLine."Line No." := SalesLine."Line No." + 10000;
          SalesLine.VALIDATE(Type,TempSalesLine.Type);
          OnCreateSalesLineOnAfterAssignType(SalesLine,TempSalesLine);
          if TempSalesLine."No." = '' then begin
            SalesLine.VALIDATE(Description,TempSalesLine.Description);
            SalesLine.VALIDATE("Description 2",TempSalesLine."Description 2");
          end else begin
            SalesLine.VALIDATE("No.",TempSalesLine."No.");
            if SalesLine.Type <> SalesLine.Type::" " then begin
              SalesLine.VALIDATE("Unit of Measure Code",TempSalesLine."Unit of Measure Code");
              SalesLine.VALIDATE("Variant Code",TempSalesLine."Variant Code");
              if TempSalesLine.Quantity <> 0 then begin
                SalesLine.VALIDATE(Quantity,TempSalesLine.Quantity);
                SalesLine.VALIDATE("Qty. to Assemble to Order",TempSalesLine."Qty. to Assemble to Order");
              end;
              SalesLine."Purchase Order No." := TempSalesLine."Purchase Order No.";
              SalesLine."Purch. Order Line No." := TempSalesLine."Purch. Order Line No.";
              SalesLine."Drop Shipment" := SalesLine."Purch. Order Line No." <> 0;
            end;
            SalesLine.VALIDATE("Shipment Date",TempSalesLine."Shipment Date");
          end;
          OnBeforeSalesLineInsert(SalesLine,TempSalesLine);
          SalesLine.INSERT;
          OnAfterCreateSalesLine(SalesLine,TempSalesLine);
        end;
    */


    //     LOCAL procedure CreateItemChargeAssgntSales (var ItemChargeAssgntSales@1001 : Record 5809;var TempItemChargeAssgntSales@1000 : TEMPORARY Record 5809;var TempSalesLine@1002 : TEMPORARY Record 37;var TempInteger@1003 :

    /*
    LOCAL procedure CreateItemChargeAssgntSales (var ItemChargeAssgntSales: Record 5809;var TempItemChargeAssgntSales: Record 5809 TEMPORARY;var TempSalesLine: Record 37 TEMPORARY;var TempInteger: Record 2000000026 TEMPORARY)
        begin
          if TempSalesLine.FINDSET then
            repeat
              TempItemChargeAssgntSales.SETRANGE("Document Line No.",TempSalesLine."Line No.");
              if TempItemChargeAssgntSales.FINDSET then begin
                repeat
                  TempInteger.FINDFIRST;
                  ItemChargeAssgntSales.INIT;
                  ItemChargeAssgntSales := TempItemChargeAssgntSales;
                  ItemChargeAssgntSales."Document Line No." := TempInteger.Number;
                  ItemChargeAssgntSales.VALIDATE("Unit Cost",0);
                  ItemChargeAssgntSales.INSERT;
                until TempItemChargeAssgntSales.NEXT = 0;
                TempInteger.DELETE;
              end;
            until TempSalesLine.NEXT = 0;
        end;
    */




    LOCAL procedure UpdateOutboundWhseHandlingTime()
    begin
        if "Location Code" <> '' then begin
            if Location.GET("Location Code") then
                "Outbound Whse. Handling Time" := Location."Outbound Whse. Handling Time";
        end else
            if InvtSetup.GET then
                "Outbound Whse. Handling Time" := InvtSetup."Outbound Whse. Handling Time";
    end;







    /*
     [Integration(TRUE)]
    procedure OnCheckSalesPostRestrictions ()
        begin
        end;

        [Integration(TRUE)]
    */



    /*
    procedure OnCustomerCreditLimitExceeded ()
        begin
        end;

        [Integration(TRUE)]
    */



    /*
    procedure OnCustomerCreditLimitNotExceeded ()
        begin
        end;

        [Integration(TRUE)]
    */


    /*
    LOCAL procedure OnCheckSalesReleaseRestrictions ()
        begin
        end;
    */




    /*
    procedure CheckSalesReleaseRestrictions ()
        var
    //       ApprovalsMgmt@1000 :
          ApprovalsMgmt: Codeunit 1535;
        begin
          OnCheckSalesReleaseRestrictions;
          ApprovalsMgmt.PrePostApprovalCheckSales(Rec);
        end;
    */




    /*
    procedure DeferralHeadersExist () : Boolean;
        var
    //       DeferralHeader@1000 :
          DeferralHeader: Record 1701;
    //       DeferralUtilities@1001 :
          DeferralUtilities: Codeunit 1720;
        begin
          DeferralHeader.SETRANGE("Deferral Doc. Type",DeferralUtilities.GetSalesDeferralDocType);
          DeferralHeader.SETRANGE("Gen. Jnl. Template Name",'');
          DeferralHeader.SETRANGE("Gen. Jnl. Batch Name",'');
          DeferralHeader.SETRANGE("Document Type","Document Type");
          DeferralHeader.SETRANGE("Document No.","No.");
          exit(not DeferralHeader.ISEMPTY);
        end;
    */




    /*
    procedure SetSellToCustomerFromFilter ()
        var
    //       SellToCustomerNo@1000 :
          SellToCustomerNo: Code[20];
        begin
          SellToCustomerNo := GetFilterCustNo;
          if SellToCustomerNo = '' then begin
            FILTERGROUP(2);
            SellToCustomerNo := GetFilterCustNo;
            if SellToCustomerNo = '' then
              SellToCustomerNo := GetFilterCustNoByApplyingFilter;
            FILTERGROUP(0);
          end;
          if SellToCustomerNo <> '' then
            VALIDATE("Sell-to Customer No.",SellToCustomerNo);
        end;
    */




    /*
    procedure CopySellToCustomerFilter ()
        var
    //       SellToCustomerFilter@1000 :
          SellToCustomerFilter: Text;
        begin
          SellToCustomerFilter := GETFILTER("Sell-to Customer No.");
          if SellToCustomerFilter <> '' then begin
            FILTERGROUP(2);
            SETFILTER("Sell-to Customer No.",SellToCustomerFilter);
            FILTERGROUP(0)
          end;
        end;
    */



    /*
    LOCAL procedure ConfirmUpdateDeferralDate ()
        begin
          if GetHideValidationDialog or not GUIALLOWED then
            Confirmed := TRUE
          else
            Confirmed := CONFIRM(DeferralLineQst,FALSE);
          if Confirmed then
            UpdateSalesLinesByFieldNo(SalesLine.FIELDNO("Deferral Code"),FALSE);
        end;
    */



    //     procedure BatchConfirmUpdateDeferralDate (var BatchConfirm@1000 : ' ,Skip,Update';ReplacePostingDate@1004 : Boolean;PostingDateReq@1003 :

    /*
    procedure BatchConfirmUpdateDeferralDate (var BatchConfirm: Option " ","Skip","Update";ReplacePostingDate: Boolean;PostingDateReq: Date)
        begin
          if (not ReplacePostingDate) or (PostingDateReq = "Posting Date") or (BatchConfirm = BatchConfirm::Skip) then
            exit;

          if not DeferralHeadersExist then
            exit;

          "Posting Date" := PostingDateReq;
          CASE BatchConfirm OF
            BatchConfirm::" ":
              begin
                ConfirmUpdateDeferralDate;
                if Confirmed then
                  BatchConfirm := BatchConfirm::Update
                else
                  BatchConfirm := BatchConfirm::Skip;
              end;
            BatchConfirm::Update:
              UpdateSalesLinesByFieldNo(SalesLine.FIELDNO("Deferral Code"),FALSE);
          end;
          COMMIT;
        end;
    */




    /*
    procedure GetSelectedPaymentServicesText () : Text;
        var
    //       PaymentServiceSetup@1000 :
          PaymentServiceSetup: Record 1060;
        begin
          exit(PaymentServiceSetup.GetSelectedPaymentsText("Payment Service Set ID"));
        end;
    */




    /*
    procedure SetDefaultPaymentServices ()
        var
    //       PaymentServiceSetup@1000 :
          PaymentServiceSetup: Record 1060;
    //       SetID@1001 :
          SetID: Integer;
        begin
          if not PaymentServiceSetup.CanChangePaymentService(Rec) then
            exit;

          if PaymentServiceSetup.GetDefaultPaymentServices(SetID) then
            VALIDATE("Payment Service Set ID",SetID);
        end;
    */




    /*
    procedure ChangePaymentServiceSetting ()
        var
    //       PaymentServiceSetup@1000 :
          PaymentServiceSetup: Record 1060;
    //       SetID@1001 :
          SetID: Integer;
        begin
          SetID := "Payment Service Set ID";
          if PaymentServiceSetup.SelectPaymentService(SetID) then begin
            VALIDATE("Payment Service Set ID",SetID);
            MODIFY(TRUE);
          end;
        end;
    */




    /*
    procedure IsCreditDocType () : Boolean;
        begin
          exit("Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"]);
        end;
    */




    /*
    procedure HasSellToAddress () : Boolean;
        begin
          CASE TRUE OF
            "Sell-to Address" <> '':
              exit(TRUE);
            "Sell-to Address 2" <> '':
              exit(TRUE);
            "Sell-to City" <> '':
              exit(TRUE);
            "Sell-to Country/Region Code" <> '':
              exit(TRUE);
            "Sell-to County" <> '':
              exit(TRUE);
            "Sell-to Post Code" <> '':
              exit(TRUE);
            "Sell-to Contact" <> '':
              exit(TRUE);
          end;

          exit(FALSE);
        end;
    */




    /*
    procedure HasShipToAddress () : Boolean;
        begin
          CASE TRUE OF
            "Ship-to Address" <> '':
              exit(TRUE);
            "Ship-to Address 2" <> '':
              exit(TRUE);
            "Ship-to City" <> '':
              exit(TRUE);
            "Ship-to Country/Region Code" <> '':
              exit(TRUE);
            "Ship-to County" <> '':
              exit(TRUE);
            "Ship-to Post Code" <> '':
              exit(TRUE);
            "Ship-to Contact" <> '':
              exit(TRUE);
          end;

          exit(FALSE);
        end;
    */




    /*
    procedure HasBillToAddress () : Boolean;
        begin
          CASE TRUE OF
            "Bill-to Address" <> '':
              exit(TRUE);
            "Bill-to Address 2" <> '':
              exit(TRUE);
            "Bill-to City" <> '':
              exit(TRUE);
            "Bill-to Country/Region Code" <> '':
              exit(TRUE);
            "Bill-to County" <> '':
              exit(TRUE);
            "Bill-to Post Code" <> '':
              exit(TRUE);
            "Bill-to Contact" <> '':
              exit(TRUE);
          end;

          exit(FALSE);
        end;
    */



    /*
    LOCAL procedure HasItemChargeAssignment () : Boolean;
        var
    //       ItemChargeAssgntSales@1000 :
          ItemChargeAssgntSales: Record 5809;
        begin
          ItemChargeAssgntSales.SETRANGE("Document Type","Document Type");
          ItemChargeAssgntSales.SETRANGE("Document No.","No.");
          ItemChargeAssgntSales.SETFILTER("Amount to Assign",'<>%1',0);
          exit(not ItemChargeAssgntSales.ISEMPTY);
        end;
    */


    //     LOCAL procedure CopySellToCustomerAddressFieldsFromCustomer (var SellToCustomer@1000 :

    /*
    LOCAL procedure CopySellToCustomerAddressFieldsFromCustomer (var SellToCustomer: Record 18)
        begin
          "Sell-to Customer Template Code" := '';
          "Sell-to Customer Name" := Cust.Name;
          "Sell-to Customer Name 2" := Cust."Name 2";
          "Sell-to Phone No." := Cust."Phone No.";
          "Sell-to E-Mail" := Cust."E-Mail";
          if SellToCustomerIsReplaced or ShouldCopyAddressFromSellToCustomer(SellToCustomer) then begin
            "Sell-to Address" := SellToCustomer.Address;
            "Sell-to Address 2" := SellToCustomer."Address 2";
            "Sell-to City" := SellToCustomer.City;
            "Sell-to Post Code" := SellToCustomer."Post Code";
            "Sell-to County" := SellToCustomer.County;
            "Sell-to Country/Region Code" := SellToCustomer."Country/Region Code";
          end;
          if not SkipSellToContact then
            "Sell-to Contact" := SellToCustomer.Contact;
          "Gen. Bus. Posting Group" := SellToCustomer."Gen. Bus. Posting Group";
          "VAT Bus. Posting Group" := SellToCustomer."VAT Bus. Posting Group";
          "Tax Area Code" := SellToCustomer."Tax Area Code";
          "Tax Liable" := SellToCustomer."Tax Liable";
          "VAT Registration No." := SellToCustomer."VAT Registration No.";
          "VAT Country/Region Code" := SellToCustomer."Country/Region Code";
          "Shipping Advice" := SellToCustomer."Shipping Advice";
          "Responsibility Center" := UserSetupMgt.GetRespCenter(0,SellToCustomer."Responsibility Center");
          OnCopySelltoCustomerAddressFieldsFromCustomerOnAfterAssignRespCenter(Rec,SellToCustomer,CurrFieldNo);
          VALIDATE("Location Code",UserSetupMgt.GetLocation(0,SellToCustomer."Location Code","Responsibility Center"));

          OnAfterCopySellToCustomerAddressFieldsFromCustomer(Rec,SellToCustomer,CurrFieldNo);
        end;
    */


    //     LOCAL procedure CopyShipToCustomerAddressFieldsFromCustomer (var SellToCustomer@1000 :

    /*
    LOCAL procedure CopyShipToCustomerAddressFieldsFromCustomer (var SellToCustomer: Record 18)
        var
    //       SellToCustTemplate@1001 :
          SellToCustTemplate: Record 5105;
        begin
          "Ship-to Name" := Cust.Name;
          "Ship-to Name 2" := Cust."Name 2";
          if SellToCustomerIsReplaced or ShipToAddressEqualsOldSellToAddress then begin
            "Ship-to Address" := SellToCustomer.Address;
            "Ship-to Address 2" := SellToCustomer."Address 2";
            "Ship-to City" := SellToCustomer.City;
            "Ship-to Post Code" := SellToCustomer."Post Code";
            "Ship-to County" := SellToCustomer.County;
            VALIDATE("Ship-to Country/Region Code",SellToCustomer."Country/Region Code");
          end;
          "Ship-to Contact" := Cust.Contact;
          if Cust."Shipment Method Code" <> '' then
            VALIDATE("Shipment Method Code",Cust."Shipment Method Code");
          if not SellToCustTemplate.GET("Sell-to Customer Template Code") then begin
            "Tax Area Code" := Cust."Tax Area Code";
            "Tax Liable" := Cust."Tax Liable";
          end;
          if Cust."Location Code" <> '' then
            VALIDATE("Location Code",Cust."Location Code");
          "Shipping Agent Code" := Cust."Shipping Agent Code";
          "Shipping Agent Service Code" := Cust."Shipping Agent Service Code";

          OnAfterCopyShipToCustomerAddressFieldsFromCustomer(Rec,SellToCustomer);
        end;
    */


    //     LOCAL procedure CopyShipToCustomerAddressFieldsFromShipToAddr (ShipToAddr@1000 :

    /*
    LOCAL procedure CopyShipToCustomerAddressFieldsFromShipToAddr (ShipToAddr: Record 222)
        begin
          "Ship-to Name" := ShipToAddr.Name;
          "Ship-to Name 2" := ShipToAddr."Name 2";
          "Ship-to Address" := ShipToAddr.Address;
          "Ship-to Address 2" := ShipToAddr."Address 2";
          "Ship-to City" := ShipToAddr.City;
          "Ship-to Post Code" := ShipToAddr."Post Code";
          "Ship-to County" := ShipToAddr.County;
          VALIDATE("Ship-to Country/Region Code",ShipToAddr."Country/Region Code");
          "Ship-to Contact" := ShipToAddr.Contact;
          if ShipToAddr."Shipment Method Code" <> '' then
            VALIDATE("Shipment Method Code",ShipToAddr."Shipment Method Code");
          if ShipToAddr."Location Code" <> '' then
            VALIDATE("Location Code",ShipToAddr."Location Code");
          "Shipping Agent Code" := ShipToAddr."Shipping Agent Code";
          "Shipping Agent Service Code" := ShipToAddr."Shipping Agent Service Code";
          if ShipToAddr."Tax Area Code" <> '' then
            "Tax Area Code" := ShipToAddr."Tax Area Code";
          "Tax Liable" := ShipToAddr."Tax Liable";

          OnAfterCopyShipToCustomerAddressFieldsFromShipToAddr(Rec,ShipToAddr);
        end;
    */


    //     LOCAL procedure CopyBillToCustomerAddressFieldsFromCustomer (var BillToCustomer@1000 :

    /*
    LOCAL procedure CopyBillToCustomerAddressFieldsFromCustomer (var BillToCustomer: Record 18)
        begin
          "Bill-to Customer Template Code" := '';
          "Bill-to Name" := BillToCustomer.Name;
          "Bill-to Name 2" := BillToCustomer."Name 2";
          if BillToCustomerIsReplaced or ShouldCopyAddressFromBillToCustomer(BillToCustomer) then begin
            "Bill-to Address" := BillToCustomer.Address;
            "Bill-to Address 2" := BillToCustomer."Address 2";
            "Bill-to City" := BillToCustomer.City;
            "Bill-to Post Code" := BillToCustomer."Post Code";
            "Bill-to County" := BillToCustomer.County;
            "Bill-to Country/Region Code" := BillToCustomer."Country/Region Code";
          end;
          if not SkipBillToContact then
            "Bill-to Contact" := BillToCustomer.Contact;
          "Payment Terms Code" := BillToCustomer."Payment Terms Code";
          "Prepmt. Payment Terms Code" := BillToCustomer."Payment Terms Code";

          if "Document Type" IN ["Document Type"::"Credit Memo","Document Type"::"Return Order"] then begin
            "Payment Method Code" := '';
            if PaymentTerms.GET("Payment Terms Code") then
              if PaymentTerms."Calc. Pmt. Disc. on Cr. Memos" then
                "Payment Method Code" := BillToCustomer."Payment Method Code"
          end else
            "Payment Method Code" := BillToCustomer."Payment Method Code";

          GLSetup.GET;
          if GLSetup."Bill-to/Sell-to VAT Calc." = GLSetup."Bill-to/Sell-to VAT Calc."::"Bill-to/Pay-to No." then begin
            "VAT Bus. Posting Group" := BillToCustomer."VAT Bus. Posting Group";
            "VAT Country/Region Code" := BillToCustomer."Country/Region Code";
            "VAT Registration No." := BillToCustomer."VAT Registration No.";
            "Gen. Bus. Posting Group" := BillToCustomer."Gen. Bus. Posting Group";
          end;
          "Customer Posting Group" := BillToCustomer."Customer Posting Group";
          "Currency Code" := BillToCustomer."Currency Code";
          "Customer Price Group" := BillToCustomer."Customer Price Group";
          "Prices Including VAT" := BillToCustomer."Prices Including VAT";
          "Allow Line Disc." := BillToCustomer."Allow Line Disc.";
          "Invoice Disc. Code" := BillToCustomer."Invoice Disc. Code";
          "Customer Disc. Group" := BillToCustomer."Customer Disc. Group";
          "Language Code" := BillToCustomer."Language Code";
          SetSalespersonCode(BillToCustomer."Salesperson Code","Salesperson Code");
          "Combine Shipments" := BillToCustomer."Combine Shipments";
          Reserve := BillToCustomer.Reserve;
          if "Document Type" = "Document Type"::Order then
            "Prepayment %" := BillToCustomer."Prepayment %";
          "Tax Area Code" := BillToCustomer."Tax Area Code";
          "Tax Liable" := BillToCustomer."Tax Liable";
          "Cust. Bank Acc. Code" := BillToCustomer."Preferred Bank Account Code";

          OnAfterSetFieldsBilltoCustomer(Rec,BillToCustomer);
        end;
    */



    //     procedure SetShipToAddress (ShipToName@1000 : Text[50];ShipToName2@1001 : Text[50];ShipToAddress@1002 : Text[50];ShipToAddress2@1003 : Text[50];ShipToCity@1004 : Text[30];ShipToPostCode@1005 : Code[20];ShipToCounty@1006 : Text[30];ShipToCountryRegionCode@1007 :

    /*
    procedure SetShipToAddress (ShipToName: Text[50];ShipToName2: Text[50];ShipToAddress: Text[50];ShipToAddress2: Text[50];ShipToCity: Text[30];ShipToPostCode: Code[20];ShipToCounty: Text[30];ShipToCountryRegionCode: Code[10])
        begin
          "Ship-to Name" := ShipToName;
          "Ship-to Name 2" := ShipToName2;
          "Ship-to Address" := ShipToAddress;
          "Ship-to Address 2" := ShipToAddress2;
          "Ship-to City" := ShipToCity;
          "Ship-to Post Code" := ShipToPostCode;
          "Ship-to County" := ShipToCounty;
          "Ship-to Country/Region Code" := ShipToCountryRegionCode;
        end;
    */


    //     LOCAL procedure ShouldCopyAddressFromSellToCustomer (SellToCustomer@1000 :

    /*
    LOCAL procedure ShouldCopyAddressFromSellToCustomer (SellToCustomer: Record 18) : Boolean;
        begin
          exit((not HasSellToAddress) and SellToCustomer.HasAddress);
        end;
    */


    //     LOCAL procedure ShouldCopyAddressFromBillToCustomer (BillToCustomer@1000 :

    /*
    LOCAL procedure ShouldCopyAddressFromBillToCustomer (BillToCustomer: Record 18) : Boolean;
        begin
          exit((not HasBillToAddress) and BillToCustomer.HasAddress);
        end;
    */



    /*
    LOCAL procedure SellToCustomerIsReplaced () : Boolean;
        begin
          exit((xRec."Sell-to Customer No." <> '') and (xRec."Sell-to Customer No." <> "Sell-to Customer No."));
        end;
    */



    /*
    LOCAL procedure BillToCustomerIsReplaced () : Boolean;
        begin
          exit((xRec."Bill-to Customer No." <> '') and (xRec."Bill-to Customer No." <> "Bill-to Customer No."));
        end;
    */


    //     LOCAL procedure UpdateShipToAddressFromSellToAddress (FieldNumber@1000 :
    LOCAL procedure UpdateShipToAddressFromSellToAddress(FieldNumber: Integer)
    begin
        if ("Ship-to Code" = '') and ShipToAddressEqualsOldSellToAddress then
            CASE FieldNumber OF
                FIELDNO("Ship-to Address"):
                    "Ship-to Address" := "Sell-to Address";
                FIELDNO("Ship-to Address 2"):
                    "Ship-to Address 2" := "Sell-to Address 2";
                FIELDNO("Ship-to City"), FIELDNO("Ship-to Post Code"):
                    begin
                        "Ship-to City" := "Sell-to City";
                        "Ship-to Post Code" := "Sell-to Post Code";
                        "Ship-to County" := "Sell-to County";
                        "Ship-to Country/Region Code" := "Sell-to Country/Region Code";
                    end;
                FIELDNO("Ship-to County"):
                    "Ship-to County" := "Sell-to County";
                FIELDNO("Ship-to Country/Region Code"):
                    "Ship-to Country/Region Code" := "Sell-to Country/Region Code";
            end;
    end;



    LOCAL procedure ShipToAddressEqualsOldSellToAddress(): Boolean;
    begin
        exit(IsShipToAddressEqualToSellToAddress(xRec, Rec));
    end;





    /*
    procedure ShipToAddressEqualsSellToAddress () : Boolean;
        begin
          exit(IsShipToAddressEqualToSellToAddress(Rec,Rec));
        end;
    */


    //     LOCAL procedure IsShipToAddressEqualToSellToAddress (SalesHeaderWithSellTo@1000 : Record 36;SalesHeaderWithShipTo@1001 :


    LOCAL procedure IsShipToAddressEqualToSellToAddress(SalesHeaderWithSellTo: Record 36; SalesHeaderWithShipTo: Record 36): Boolean;
    begin
        if (SalesHeaderWithSellTo."Sell-to Address" = SalesHeaderWithShipTo."Ship-to Address") and
           (SalesHeaderWithSellTo."Sell-to Address 2" = SalesHeaderWithShipTo."Ship-to Address 2") and
           (SalesHeaderWithSellTo."Sell-to City" = SalesHeaderWithShipTo."Ship-to City") and
           (SalesHeaderWithSellTo."Sell-to County" = SalesHeaderWithShipTo."Ship-to County") and
           (SalesHeaderWithSellTo."Sell-to Post Code" = SalesHeaderWithShipTo."Ship-to Post Code") and
           (SalesHeaderWithSellTo."Sell-to Country/Region Code" = SalesHeaderWithShipTo."Ship-to Country/Region Code") and
           (SalesHeaderWithSellTo."Sell-to Contact" = SalesHeaderWithShipTo."Ship-to Contact")
        then
            exit(TRUE);
    end;





    /*
    procedure BillToAddressEqualsSellToAddress () : Boolean;
        begin
          exit(IsBillToAddressEqualToSellToAddress(Rec,Rec));
        end;
    */


    //     LOCAL procedure IsBillToAddressEqualToSellToAddress (SalesHeaderWithSellTo@1000 : Record 36;SalesHeaderWithBillTo@1001 :

    /*
    LOCAL procedure IsBillToAddressEqualToSellToAddress (SalesHeaderWithSellTo: Record 36;SalesHeaderWithBillTo: Record 36) : Boolean;
        begin
          if (SalesHeaderWithSellTo."Sell-to Address" = SalesHeaderWithBillTo."Bill-to Address") and
             (SalesHeaderWithSellTo."Sell-to Address 2" = SalesHeaderWithBillTo."Bill-to Address 2") and
             (SalesHeaderWithSellTo."Sell-to City" = SalesHeaderWithBillTo."Bill-to City") and
             (SalesHeaderWithSellTo."Sell-to County" = SalesHeaderWithBillTo."Bill-to County") and
             (SalesHeaderWithSellTo."Sell-to Post Code" = SalesHeaderWithBillTo."Bill-to Post Code") and
             (SalesHeaderWithSellTo."Sell-to Country/Region Code" = SalesHeaderWithBillTo."Bill-to Country/Region Code") and
             (SalesHeaderWithSellTo."Sell-to Contact No." = SalesHeaderWithBillTo."Bill-to Contact No.") and
             (SalesHeaderWithSellTo."Sell-to Contact" = SalesHeaderWithBillTo."Bill-to Contact")
          then
            exit(TRUE);
        end;
    */




    /*
    procedure CopySellToAddressToShipToAddress ()
        begin
          "Ship-to Address" := "Sell-to Address";
          "Ship-to Address 2" := "Sell-to Address 2";
          "Ship-to City" := "Sell-to City";
          "Ship-to Contact" := "Sell-to Contact";
          "Ship-to Country/Region Code" := "Sell-to Country/Region Code";
          "Ship-to County" := "Sell-to County";
          "Ship-to Post Code" := "Sell-to Post Code";

          OnAfterCopySellToAddressToShipToAddress(Rec);
        end;
    */




    /*
    procedure CopySellToAddressToBillToAddress ()
        begin
          if "Bill-to Customer No." = "Sell-to Customer No." then begin
            "Bill-to Address" := "Sell-to Address";
            "Bill-to Address 2" := "Sell-to Address 2";
            "Bill-to Post Code" := "Sell-to Post Code";
            "Bill-to Country/Region Code" := "Sell-to Country/Region Code";
            "Bill-to City" := "Sell-to City";
            "Bill-to County" := "Sell-to County";
            OnAfterCopySellToAddressToBillToAddress(Rec);
          end;
        end;
    */



    /*
    LOCAL procedure UpdateShipToContact ()
        begin
          if not (CurrFieldNo IN [FIELDNO("Sell-to Contact"),FIELDNO("Sell-to Contact No.")]) then
            exit;

          if IsCreditDocType then
            exit;

          VALIDATE("Ship-to Contact","Sell-to Contact");
        end;
    */




    /*
    procedure ConfirmCloseUnposted () : Boolean;
        var
    //       InstructionMgt@1000 :
          InstructionMgt: Codeunit 1330;
        begin
          if SalesLinesExist then
            if InstructionMgt.IsUnpostedEnabledForRecord(Rec) then
              exit(InstructionMgt.ShowConfirm(DocumentNotPostedClosePageQst,InstructionMgt.QueryPostOnCloseCode));
          exit(TRUE)
        end;
    */



    /*
    LOCAL procedure UpdateOpportunity ()
        var
    //       Opp@1002 :
          Opp: Record 5092;
    //       OpportunityEntry@1001 :
          OpportunityEntry: Record 5093;
    //       ConfirmManagement@1000 :
          ConfirmManagement: Codeunit 27;
        begin
          if not ("Opportunity No." <> '') or not ("Document Type" IN ["Document Type"::Quote,"Document Type"::Order]) then
            exit;

          if not Opp.GET("Opportunity No.") then
            exit;

          if "Document Type" = "Document Type"::Order then begin
            if not ConfirmManagement.ConfirmProcess(Text040,TRUE) then
              ERROR(Text044);

            OpportunityEntry.SETRANGE("Opportunity No.","Opportunity No.");
            OpportunityEntry.MODIFYALL(Active,FALSE);

            OpportunityEntry.INIT;
            OpportunityEntry.VALIDATE("Opportunity No.",Opp."No.");

            OpportunityEntry.LOCKTABLE;
            OpportunityEntry."Entry No." := GetOpportunityEntryNo;
            OpportunityEntry."Sales Cycle Code" := Opp."Sales Cycle Code";
            OpportunityEntry."Contact No." := Opp."Contact No.";
            OpportunityEntry."Contact Company No." := Opp."Contact Company No.";
            OpportunityEntry."Salesperson Code" := Opp."Salesperson Code";
            OpportunityEntry."Campaign No." := Opp."Campaign No.";
            OpportunityEntry."Action Taken" := OpportunityEntry."Action Taken"::Lost;
            OpportunityEntry.Active := TRUE;
            OpportunityEntry."Completed %" := 100;
            OpportunityEntry."Estimated Value (LCY)" := GetOpportunityEntryEstimatedValue;
            OpportunityEntry."Estimated Close Date" := Opp."Date Closed";
            OpportunityEntry.INSERT(TRUE);
          end;
          Opp.FIND;
          Opp."Sales Document Type" := Opp."Sales Document Type"::" ";
          Opp."Sales Document No." := '';
          Opp.MODIFY;
          "Opportunity No." := '';
        end;
    */



    /*
    LOCAL procedure GetOpportunityEntryNo () : Integer;
        var
    //       OpportunityEntry@1000 :
          OpportunityEntry: Record 5093;
        begin
          if OpportunityEntry.FINDLAST then
            exit(OpportunityEntry."Entry No." + 1);
          exit(1);
        end;
    */



    /*
    LOCAL procedure GetOpportunityEntryEstimatedValue () : Decimal;
        var
    //       OpportunityEntry@1000 :
          OpportunityEntry: Record 5093;
        begin
          OpportunityEntry.SETRANGE("Opportunity No.","Opportunity No.");
          if OpportunityEntry.FINDLAST then
            exit(OpportunityEntry."Estimated Value (LCY)");
        end;
    */



    //     procedure InitFromSalesHeader (SourceSalesHeader@1000 :

    /*
    procedure InitFromSalesHeader (SourceSalesHeader: Record 36)
        begin
          "Document Date" := SourceSalesHeader."Document Date";
          "Shipment Date" := SourceSalesHeader."Shipment Date";
          "Shortcut Dimension 1 Code" := SourceSalesHeader."Shortcut Dimension 1 Code";
          "Shortcut Dimension 2 Code" := SourceSalesHeader."Shortcut Dimension 2 Code";
          "Dimension Set ID" := SourceSalesHeader."Dimension Set ID";
          "Location Code" := SourceSalesHeader."Location Code";
          SetShipToAddress(
            SourceSalesHeader."Ship-to Name",SourceSalesHeader."Ship-to Name 2",SourceSalesHeader."Ship-to Address",
            SourceSalesHeader."Ship-to Address 2",SourceSalesHeader."Ship-to City",SourceSalesHeader."Ship-to Post Code",
            SourceSalesHeader."Ship-to County",SourceSalesHeader."Ship-to Country/Region Code");
          "Ship-to Contact" := SourceSalesHeader."Ship-to Contact";
        end;
    */


    //     LOCAL procedure InitFromContact (ContactNo@1000 : Code[20];CustomerNo@1001 : Code[20];ContactCaption@1002 :

    /*
    LOCAL procedure InitFromContact (ContactNo: Code[20];CustomerNo: Code[20];ContactCaption: Text) : Boolean;
        begin
          SalesLine.RESET;
          SalesLine.SETRANGE("Document Type","Document Type");
          SalesLine.SETRANGE("Document No.","No.");
          if (ContactNo = '') and (CustomerNo = '') then begin
            if not SalesLine.ISEMPTY then
              ERROR(Text005,ContactCaption);
            INIT;
            SalesSetup.GET;
            "No. Series" := xRec."No. Series";
            InitRecord;
            InitNoSeries;
            exit(TRUE);
          end;
        end;
    */


    //     LOCAL procedure InitFromTemplate (TemplateCode@1000 : Code[20];TemplateCaption@1001 :

    /*
    LOCAL procedure InitFromTemplate (TemplateCode: Code[20];TemplateCaption: Text) : Boolean;
        begin
          SalesLine.RESET;
          SalesLine.SETRANGE("Document Type","Document Type");
          SalesLine.SETRANGE("Document No.","No.");
          if TemplateCode = '' then begin
            if not SalesLine.ISEMPTY then
              ERROR(Text005,TemplateCaption);
            INIT;
            SalesSetup.GET;
            "No. Series" := xRec."No. Series";
            InitRecord;
            InitNoSeries;
            exit(TRUE);
          end;
        end;
    */



    /*
    LOCAL procedure ValidateTaxAreaCode ()
        var
    //       TaxArea@1000 :
          TaxArea: Record 318;
    //       IdentityManagement@1001 :
          IdentityManagement: Codeunit 9801;
        begin
          if "Tax Area Code" = '' then
            exit;
          if IdentityManagement.IsInvAppId then begin
            if not TaxArea.GET("Tax Area Code") then begin
              TaxArea.SETFILTER(Code,"Tax Area Code" + '*');
              if not TaxArea.FINDFIRST then
                TaxArea.CreateTaxArea("Tax Area Code","Sell-to City","Sell-to County");
              "Tax Area Code" := TaxArea.Code;
            end;

            if Cust.GET("Sell-to Customer No.") then
              if Cust."Tax Area Code" = '' then begin
                Cust."Tax Area Code" := "Tax Area Code";
                Cust.MODIFY;
              end;
          end else
            TaxArea.GET("Tax Area Code");
        end;
    */



    //     procedure SetWorkDescription (NewWorkDescription@1000 :
    procedure SetWorkDescription(NewWorkDescription: Text)
    var
        TempBlob: Codeunit "Temp Blob";
        Blob: OutStream;
        InStr: InStream;

    begin
        CLEAR("Work Description");
        if NewWorkDescription = '' then
            exit;
        // TempBlob.Blob := "Work Description";
        //To be tested

        TempBlob.CreateOutStream(Blob, TextEncoding::Windows);
        Blob.Write("Work Description");

        //Q16565 DCS 08/03/22 Solucionar problema en BLOB con acentos. JAV 09/03/22 se incorpora a QB 1.10.23
        //TempBlob.WriteAsText(NewWorkDescription,TEXTENCODING::UTF8);
        // TempBlob.WriteAsText(NewWorkDescription, TEXTENCODING::Windows);
        //To be tested

        TempBlob.CreateOutStream(Blob, TextEncoding::Windows);
        Blob.Write(NewWorkDescription);
        //Q16565 fin

        // "Work Description" := TempBlob.Blob;
        //To be tested

        TempBlob.CreateInStream(InStr, TextEncoding::Windows);
        InStr.Read("Work Description");
        MODIFY;
    end;



    /*
    procedure GetWorkDescription () : Text;
        begin
          CALCFIELDS("Work Description");
          exit(GetWorkDescriptionWorkDescriptionCalculated);
        end;
    */



    procedure GetWorkDescriptionWorkDescriptionCalculated(): Text;
    var
        TempBlob: Codeunit "Temp Blob";
        Blob: OutStream;
        InStr: InStream;

        //       CR@1004 :
        CR: Text[1];
    begin
        if not "Work Description".HASVALUE then
            exit('');

        CR[1] := 10;
        // TempBlob.Blob := "Work Description";
        //To be tested

        TempBlob.CreateOutStream(Blob, TextEncoding::Windows);
        Blob.Write("Work Description");

        //JAV 09/09/20: - QB 1.06.12 La descripci�n del trabajo se lee con codificaci�n windows para evitar problemas con el UTF8 y ciertos caracteres como � o �
        // exit(TempBlob.ReadAsText(CR, TEXTENCODING::Windows)) ;
        //To be tested

        TempBlob.CreateInStream(InStr, TextEncoding::Windows);
        InStr.Read(CR);
        exit(CR);
        //QB fin

        // exit(TempBlob.ReadAsText(CR,TEXTENCODING::UTF8));
    end;

    //     LOCAL procedure LookupContact (CustomerNo@1000 : Code[20];ContactNo@1003 : Code[20];var Contact@1001 :

    /*
    LOCAL procedure LookupContact (CustomerNo: Code[20];ContactNo: Code[20];var Contact: Record 5050)
        var
    //       ContactBusinessRelation@1002 :
          ContactBusinessRelation: Record 5054;
    //       FilterByContactCompany@1004 :
          FilterByContactCompany: Boolean;
        begin
          if ContactBusinessRelation.FindByRelation(ContactBusinessRelation."Link to Table"::Customer,CustomerNo) then
            Contact.SETRANGE("Company No.",ContactBusinessRelation."Contact No.")
          else
            if "Document Type" = "Document Type"::Quote then
              FilterByContactCompany := TRUE
            else
              Contact.SETRANGE("Company No.",'');
          if ContactNo <> '' then
            if Contact.GET(ContactNo) then
              if FilterByContactCompany then
                Contact.SETRANGE("Company No.",Contact."Company No.");
        end;
    */




    /*
    procedure SetAllowSelectNoSeries ()
        begin
          SelectNoSeriesAllowed := TRUE;
        end;
    */



    /*
    LOCAL procedure SetDefaultSalesperson ()
        var
    //       UserSetup@1000 :
          UserSetup: Record 91;
        begin
          if not UserSetup.GET(USERID) then
            exit;

          if UserSetup."Salespers./Purch. Code" <> '' then
            if Salesperson.GET(UserSetup."Salespers./Purch. Code") then
              if not Salesperson.VerifySalesPersonPurchaserPrivacyBlocked(Salesperson) then
                VALIDATE("Salesperson Code",UserSetup."Salespers./Purch. Code");
        end;
    */



    //     procedure SelltoCustomerNoOnAfterValidate (var SalesHeader@1000 : Record 36;var xSalesHeader@1001 :

    /*
    procedure SelltoCustomerNoOnAfterValidate (var SalesHeader: Record 36;var xSalesHeader: Record 36)
        begin
          if SalesHeader.GETFILTER("Sell-to Customer No.") = xSalesHeader."Sell-to Customer No." then
            if SalesHeader."Sell-to Customer No." <> xSalesHeader."Sell-to Customer No." then
              SalesHeader.SETRANGE("Sell-to Customer No.");
        end;
    */




    /*
    procedure SelectSalesHeaderCustomerTemplate () : Code[10];
        var
    //       Contact@1001 :
          Contact: Record 5050;
    //       ConfirmManagement@1000 :
          ConfirmManagement: Codeunit 27;
        begin
          Contact.GET("Sell-to Contact No.");
          if (Contact.Type = Contact.Type::Person) and (Contact."Company No." <> '')then
            Contact.GET(Contact."Company No.");
          if not Contact.ContactToCustBusinessRelationExist then
            if ConfirmManagement.ConfirmProcessUI(SelectCustomerTemplateQst,FALSE) then begin
              COMMIT;
              exit(Contact.LookupCustomerTemplate);
            end;
        end;
    */



    /*
    LOCAL procedure ModifyBillToCustomerAddress ()
        var
    //       Customer@1000 :
          Customer: Record 18;
        begin
          SalesSetup.GET;
          if SalesSetup."Ignore Updated Addresses" then
            exit;
          if IsCreditDocType then
            exit;
          if ("Bill-to Customer No." <> "Sell-to Customer No.") and Customer.GET("Bill-to Customer No.") then
            if HasBillToAddress and HasDifferentBillToAddress(Customer) then
              ShowModifyAddressNotification(GetModifyBillToCustomerAddressNotificationId,
                ModifyCustomerAddressNotificationLbl,ModifyCustomerAddressNotificationMsg,
                'CopyBillToCustomerAddressFieldsFromSalesDocument',"Bill-to Customer No.",
                "Bill-to Name",FIELDNAME("Bill-to Customer No."));
        end;
    */



    /*
    LOCAL procedure ModifyCustomerAddress ()
        var
    //       Customer@1000 :
          Customer: Record 18;
        begin
          SalesSetup.GET;
          if SalesSetup."Ignore Updated Addresses" then
            exit;
          if IsCreditDocType then
            exit;
          if Customer.GET("Sell-to Customer No.") and HasSellToAddress and HasDifferentSellToAddress(Customer) then
            ShowModifyAddressNotification(GetModifyCustomerAddressNotificationId,
              ModifyCustomerAddressNotificationLbl,ModifyCustomerAddressNotificationMsg,
              'CopySellToCustomerAddressFieldsFromSalesDocument',"Sell-to Customer No.",
              "Sell-to Customer Name",FIELDNAME("Sell-to Customer No."));
        end;
    */


    //     LOCAL procedure ShowModifyAddressNotification (NotificationID@1001 : GUID;NotificationLbl@1004 : Text;NotificationMsg@1005 : Text;NotificationFunctionTok@1006 : Text;CustomerNumber@1002 : Code[20];CustomerName@1003 : Text[50];CustomerNumberFieldName@1008 :

    /*
    LOCAL procedure ShowModifyAddressNotification (NotificationID: GUID;NotificationLbl: Text;NotificationMsg: Text;NotificationFunctionTok: Text;CustomerNumber: Code[20];CustomerName: Text[50];CustomerNumberFieldName: Text)
        var
    //       MyNotifications@1009 :
          MyNotifications: Record 1518;
    //       NotificationLifecycleMgt@1007 :
          NotificationLifecycleMgt: Codeunit 1511;
    //       PageMyNotifications@1010 :
          PageMyNotifications: Page 1518;
    //       ModifyCustomerAddressNotification@1000 :
          ModifyCustomerAddressNotification: Notification;
        begin
          if not MyNotifications.GET(USERID,NotificationID) then
            PageMyNotifications.InitializeNotificationsWithDefaultState;

          if not MyNotifications.IsEnabled(NotificationID) then
            exit;

          ModifyCustomerAddressNotification.ID := NotificationID;
          ModifyCustomerAddressNotification.MESSAGE := STRSUBSTNO(NotificationMsg,CustomerName);
          ModifyCustomerAddressNotification.ADDACTION(NotificationLbl,CODEUNIT::"Document Notifications",NotificationFunctionTok);
          ModifyCustomerAddressNotification.ADDACTION(
            DontShowAgainActionLbl,CODEUNIT::"Document Notifications",'HideNotificationForCurrentUser');
          ModifyCustomerAddressNotification.SCOPE := NOTIFICATIONSCOPE::LocalScope;
          ModifyCustomerAddressNotification.SETDATA(FIELDNAME("Document Type"),FORMAT("Document Type"));
          ModifyCustomerAddressNotification.SETDATA(FIELDNAME("No."),"No.");
          ModifyCustomerAddressNotification.SETDATA(CustomerNumberFieldName,CustomerNumber);
          NotificationLifecycleMgt.SendNotification(ModifyCustomerAddressNotification,RECORDID);
        end;
    */



    //     procedure RecallModifyAddressNotification (NotificationID@1001 :

    /*
    procedure RecallModifyAddressNotification (NotificationID: GUID)
        var
    //       MyNotifications@1002 :
          MyNotifications: Record 1518;
    //       ModifyCustomerAddressNotification@1000 :
          ModifyCustomerAddressNotification: Notification;
        begin
          if IsCreditDocType or (not MyNotifications.IsEnabled(NotificationID)) then
            exit;

          ModifyCustomerAddressNotification.ID := NotificationID;
          ModifyCustomerAddressNotification.RECALL;
        end;
    */




    /*
    procedure GetModifyCustomerAddressNotificationId () : GUID;
        begin
          exit('509FD112-31EC-4CDC-AEBF-19B8FEBA526F');
        end;
    */




    /*
    procedure GetModifyBillToCustomerAddressNotificationId () : GUID;
        begin
          exit('2096CE78-6A74-48DB-BC9A-CD5C21504FC1');
        end;
    */




    /*
    procedure GetLineInvoiceDiscountResetNotificationId () : GUID;
        begin
          exit('35AB3090-2E03-4849-BBF9-9664DE464605');
        end;
    */




    /*
    procedure SetModifyCustomerAddressNotificationDefaultState ()
        var
    //       MyNotifications@1000 :
          MyNotifications: Record 1518;
        begin
          MyNotifications.InsertDefault(GetModifyCustomerAddressNotificationId,
            ModifySellToCustomerAddressNotificationNameTxt,ModifySellToCustomerAddressNotificationDescriptionTxt,TRUE);
        end;
    */




    /*
    procedure SetModifyBillToCustomerAddressNotificationDefaultState ()
        var
    //       MyNotifications@1000 :
          MyNotifications: Record 1518;
        begin
          MyNotifications.InsertDefault(GetModifyBillToCustomerAddressNotificationId,
            ModifyBillToCustomerAddressNotificationNameTxt,ModifyBillToCustomerAddressNotificationDescriptionTxt,TRUE);
        end;
    */



    //     procedure DontNotifyCurrentUserAgain (NotificationID@1001 :

    /*
    procedure DontNotifyCurrentUserAgain (NotificationID: GUID)
        var
    //       MyNotifications@1000 :
          MyNotifications: Record 1518;
        begin
          if not MyNotifications.Disable(NotificationID) then
            CASE NotificationID OF
              GetModifyCustomerAddressNotificationId:
                MyNotifications.InsertDefault(NotificationID,ModifySellToCustomerAddressNotificationNameTxt,
                  ModifySellToCustomerAddressNotificationDescriptionTxt,FALSE);
              GetModifyBillToCustomerAddressNotificationId:
                MyNotifications.InsertDefault(NotificationID,ModifyBillToCustomerAddressNotificationNameTxt,
                  ModifyBillToCustomerAddressNotificationDescriptionTxt,FALSE);
            end;
        end;
    */



    //     procedure HasDifferentSellToAddress (Customer@1000 :

    /*
    procedure HasDifferentSellToAddress (Customer: Record 18) : Boolean;
        begin
          exit(("Sell-to Address" <> Customer.Address) or
            ("Sell-to Address 2" <> Customer."Address 2") or
            ("Sell-to City" <> Customer.City) or
            ("Sell-to Country/Region Code" <> Customer."Country/Region Code") or
            ("Sell-to County" <> Customer.County) or
            ("Sell-to Post Code" <> Customer."Post Code") or
            ("Sell-to Contact" <> Customer.Contact));
        end;
    */



    //     procedure HasDifferentBillToAddress (Customer@1000 :

    /*
    procedure HasDifferentBillToAddress (Customer: Record 18) : Boolean;
        begin
          exit(("Bill-to Address" <> Customer.Address) or
            ("Bill-to Address 2" <> Customer."Address 2") or
            ("Bill-to City" <> Customer.City) or
            ("Bill-to Country/Region Code" <> Customer."Country/Region Code") or
            ("Bill-to County" <> Customer.County) or
            ("Bill-to Post Code" <> Customer."Post Code") or
            ("Bill-to Contact" <> Customer.Contact));
        end;
    */



    //     procedure HasDifferentShipToAddress (Customer@1000 :

    /*
    procedure HasDifferentShipToAddress (Customer: Record 18) : Boolean;
        begin
          exit(("Ship-to Address" <> Customer.Address) or
            ("Ship-to Address 2" <> Customer."Address 2") or
            ("Ship-to City" <> Customer.City) or
            ("Ship-to Country/Region Code" <> Customer."Country/Region Code") or
            ("Ship-to County" <> Customer.County) or
            ("Ship-to Post Code" <> Customer."Post Code") or
            ("Ship-to Contact" <> Customer.Contact));
        end;
    */




    /*
    procedure ShowInteractionLogEntries ()
        var
    //       InteractionLogEntry@1000 :
          InteractionLogEntry: Record 5065;
        begin
          if "Bill-to Contact No." <> '' then
            InteractionLogEntry.SETRANGE("Contact No.","Bill-to Contact No.");
          CASE "Document Type" OF
            "Document Type"::Order:
              InteractionLogEntry.SETRANGE("Document Type",InteractionLogEntry."Document Type"::"Sales Ord. Cnfrmn.");
            "Document Type"::Quote:
              InteractionLogEntry.SETRANGE("Document Type",InteractionLogEntry."Document Type"::"Sales Qte.");
          end;

          InteractionLogEntry.SETRANGE("Document No.","No.");
          PAGE.RUN(PAGE::"Interaction Log Entries",InteractionLogEntry);
        end;
    */




    /*
    procedure GetBillToNo () : Code[20];
        begin
          if ("Document Type" = "Document Type"::Quote) and
             ("Bill-to Customer No." = '') and ("Bill-to Contact No." <> '') and
             ("Bill-to Customer Template Code" <> '')
          then
            exit("Bill-to Contact No.");
          exit("Bill-to Customer No.");
        end;
    */




    /*
    procedure GetCurrencySymbol () : Text[10];
        var
    //       GeneralLedgerSetup@1000 :
          GeneralLedgerSetup: Record 98;
    //       Currency@1001 :
          Currency: Record 4;
        begin
          if GeneralLedgerSetup.GET then
            if ("Currency Code" = '') or ("Currency Code" = GeneralLedgerSetup."LCY Code") then
              exit(GeneralLedgerSetup.GetCurrencySymbol);

          if Currency.GET("Currency Code") then
            exit(Currency.GetCurrencySymbol);

          exit("Currency Code");
        end;
    */


    //     LOCAL procedure SetSalespersonCode (SalesPersonCodeToCheck@1000 : Code[20];var SalesPersonCodeToAssign@1001 :

    /*
    LOCAL procedure SetSalespersonCode (SalesPersonCodeToCheck: Code[20];var SalesPersonCodeToAssign: Code[20])
        begin
          if SalesPersonCodeToCheck <> '' then begin
            if Salesperson.GET(SalesPersonCodeToCheck) then
              if Salesperson.VerifySalesPersonPurchaserPrivacyBlocked(Salesperson) then
                SalesPersonCodeToAssign := ''
              else
                SalesPersonCodeToAssign := SalesPersonCodeToCheck;
          end else
            SalesPersonCodeToAssign := '';
        end;
    */



    //     procedure ValidateSalesPersonOnSalesHeader (SalesHeader2@1000 : Record 36;IsTransaction@1001 : Boolean;IsPostAction@1002 :

    /*
    procedure ValidateSalesPersonOnSalesHeader (SalesHeader2: Record 36;IsTransaction: Boolean;IsPostAction: Boolean)
        begin
          if SalesHeader2."Salesperson Code" <> '' then
            if Salesperson.GET(SalesHeader2."Salesperson Code") then
              if Salesperson.VerifySalesPersonPurchaserPrivacyBlocked(Salesperson) then begin
                if IsTransaction then
                  ERROR(Salesperson.GetPrivacyBlockedTransactionText(Salesperson,IsPostAction,TRUE));
                if not IsTransaction then
                  ERROR(Salesperson.GetPrivacyBlockedGenericText(Salesperson,TRUE));
              end;
        end;
    */



    /*
    LOCAL procedure RevertCurrencyCodeAndPostingDate ()
        begin
          "Currency Code" := xRec."Currency Code";
          "Posting Date" := xRec."Posting Date";
        end;
    */


    //     LOCAL procedure ShouldLookForCustomerByName (CustomerNo@1000 :

    /*
    LOCAL procedure ShouldLookForCustomerByName (CustomerNo: Code[20]) : Boolean;
        var
    //       Customer@1001 :
          Customer: Record 18;
        begin
          if CustomerNo = '' then
            exit(TRUE);

          if not Customer.GET(CustomerNo) then
            exit(TRUE);

          exit(not Customer."Disable Search by Name");
        end;
    */




    LOCAL procedure CalcQuoteValidUntilDate()
    var
        //       BlankDateFormula@1000 :
        BlankDateFormula: DateFormula;
    begin
        SalesSetup.GET;
        if SalesSetup."Quote Validity Calculation" <> BlankDateFormula then
            "Quote Valid until Date" := CALCDATE(SalesSetup."Quote Validity Calculation", "Document Date");
    end;




    //     procedure TestQuantityShippedField (SalesLine@1000 :

    /*
    procedure TestQuantityShippedField (SalesLine: Record 37)
        begin
          SalesLine.TESTFIELD("Quantity Shipped",0);
          OnAfterTestQuantityShippedField(SalesLine);
        end;
    */




    /*
    procedure TestStatusOpen ()
        begin
          OnBeforeTestStatusOpen(Rec);

          if StatusCheckSuspended then
            exit;

          TESTFIELD(Status,Status::Open);

          OnAfterTestStatusOpen(Rec);
        end;
    */



    //     procedure SuspendStatusCheck (Suspend@1000 :

    /*
    procedure SuspendStatusCheck (Suspend: Boolean)
        begin
          StatusCheckSuspended := Suspend;
        end;
    */




    /*
    procedure CheckForBlockedLines ()
        var
    //       CurrentSalesLine@1000 :
          CurrentSalesLine: Record 37;
    //       Item@1001 :
          Item: Record 27;
    //       Resource@1002 :
          Resource: Record 156;
        begin
          CurrentSalesLine.SETCURRENTKEY("Document Type","Document No.",Type);
          CurrentSalesLine.SETRANGE("Document Type","Document Type");
          CurrentSalesLine.SETRANGE("Document No.","No.");
          CurrentSalesLine.SETFILTER(Type,'%1|%2',CurrentSalesLine.Type::Item,CurrentSalesLine.Type::Resource);
          CurrentSalesLine.SETFILTER("No.",'<>''''');

          if CurrentSalesLine.FINDSET then
            repeat
              CASE CurrentSalesLine.Type OF
                CurrentSalesLine.Type::Item:
                  begin
                    Item.GET(CurrentSalesLine."No.");
                    Item.TESTFIELD(Blocked,FALSE);
                  end;
                CurrentSalesLine.Type::Resource:
                  begin
                    Resource.GET(CurrentSalesLine."No.");
                    Resource.CheckResourcePrivacyBlocked(FALSE);
                    Resource.TESTFIELD(Blocked,FALSE);
                  end;
              end;
            until CurrentSalesLine.NEXT = 0;
        end;
    */



    //     LOCAL procedure OnAfterInitRecord (var SalesHeader@1000 :


    LOCAL procedure OnAfterInitRecord(var SalesHeader: Record 36)
    begin
    end;




    //     LOCAL procedure OnAfterInitNoSeries (var SalesHeader@1000 :

    /*
    LOCAL procedure OnAfterInitNoSeries (var SalesHeader: Record 36)
        begin
        end;
    */



    //     LOCAL procedure OnAfterCheckCreditLimitCondition (var SalesHeader@1000 : Record 36;var RunCheck@1001 :

    /*
    LOCAL procedure OnAfterCheckCreditLimitCondition (var SalesHeader: Record 36;var RunCheck: Boolean)
        begin
        end;
    */



    //     LOCAL procedure OnAfterConfirmSalesPrice (var SalesHeader@1000 : Record 36;var SalesLine@1001 : Record 37;var RecalculateLines@1002 :

    /*
    LOCAL procedure OnAfterConfirmSalesPrice (var SalesHeader: Record 36;var SalesLine: Record 37;var RecalculateLines: Boolean)
        begin
        end;
    */



    //     LOCAL procedure OnAfterRecreateSalesLine (var SalesLine@1000 : Record 37;var TempSalesLine@1001 :

    /*
    LOCAL procedure OnAfterRecreateSalesLine (var SalesLine: Record 37;var TempSalesLine: Record 37 TEMPORARY)
        begin
        end;
    */




    /*
    LOCAL procedure OnAfterDeleteAllTempSalesLines ()
        begin
        end;
    */



    //     LOCAL procedure OnAfterInsertTempSalesLine (SalesLine@1000 : Record 37;var TempSalesLine@1001 :

    /*
    LOCAL procedure OnAfterInsertTempSalesLine (SalesLine: Record 37;var TempSalesLine: Record 37 TEMPORARY)
        begin
        end;
    */



    //     LOCAL procedure OnAfterGetNoSeriesCode (var SalesHeader@1000 : Record 36;SalesReceivablesSetup@1001 : Record 311;var NoSeriesCode@1002 :

    /*
    LOCAL procedure OnAfterGetNoSeriesCode (var SalesHeader: Record 36;SalesReceivablesSetup: Record 311;var NoSeriesCode: Code[20])
        begin
        end;
    */



    //     LOCAL procedure OnAfterGetPostingNoSeriesCode (SalesHeader@1000 : Record 36;var PostingNos@1001 :

    /*
    LOCAL procedure OnAfterGetPostingNoSeriesCode (SalesHeader: Record 36;var PostingNos: Code[20])
        begin
        end;
    */



    //     LOCAL procedure OnAfterGetPrepaymentPostingNoSeriesCode (SalesHeader@1000 : Record 36;var PostingNos@1001 :

    /*
    LOCAL procedure OnAfterGetPrepaymentPostingNoSeriesCode (SalesHeader: Record 36;var PostingNos: Code[20])
        begin
        end;
    */



    //     LOCAL procedure OnAfterTestNoSeries (var SalesHeader@1000 :

    /*
    LOCAL procedure OnAfterTestNoSeries (var SalesHeader: Record 36)
        begin
        end;
    */



    //     LOCAL procedure OnAfterUpdateShipToAddress (var SalesHeader@1000 : Record 36;xSalesHeader@1001 :

    /*
    LOCAL procedure OnAfterUpdateShipToAddress (var SalesHeader: Record 36;xSalesHeader: Record 36)
        begin
        end;
    */



    //     LOCAL procedure OnAfterUpdateCurrencyFactor (var SalesHeader@1000 : Record 36;HideValidationDialog@1001 :

    /*
    LOCAL procedure OnAfterUpdateCurrencyFactor (var SalesHeader: Record 36;HideValidationDialog: Boolean)
        begin
        end;
    */



    //     LOCAL procedure OnAfterAppliesToDocNoOnLookup (var SalesHeader@1000 : Record 36;CustLedgerEntry@1001 :

    /*
    LOCAL procedure OnAfterAppliesToDocNoOnLookup (var SalesHeader: Record 36;CustLedgerEntry: Record 21)
        begin
        end;
    */



    //     LOCAL procedure OnUpdateSalesLineByChangedFieldName (SalesHeader@1000 : Record 36;var SalesLine@1001 : Record 37;ChangedFieldName@1002 :


    LOCAL procedure OnUpdateSalesLineByChangedFieldName(SalesHeader: Record 36; var SalesLine: Record 37; ChangedFieldName: Text[100])
    begin
    end;




    //     LOCAL procedure OnAfterCreateDimTableIDs (var SalesHeader@1000 : Record 36;FieldNo@1001 : Integer;var TableID@1003 : ARRAY [10] OF Integer;var No@1002 :


    LOCAL procedure OnAfterCreateDimTableIDs(var SalesHeader: Record 36; FieldNo: Integer; var TableID: ARRAY[10] OF Integer; var No: ARRAY[10] OF Code[20])
    begin
    end;




    //     LOCAL procedure OnAfterValidateShortcutDimCode (var SalesHeader@1000 : Record 36;xSalesHeader@1001 : Record 36;FieldNumber@1003 : Integer;var ShortcutDimCode@1002 :

    /*
    LOCAL procedure OnAfterValidateShortcutDimCode (var SalesHeader: Record 36;xSalesHeader: Record 36;FieldNumber: Integer;var ShortcutDimCode: Code[20])
        begin
        end;
    */



    //     LOCAL procedure OnAfterCreateSalesLine (var SalesLine@1000 : Record 37;var TempSalesLine@1001 :

    /*
    LOCAL procedure OnAfterCreateSalesLine (var SalesLine: Record 37;var TempSalesLine: Record 37 TEMPORARY)
        begin
        end;
    */



    //     LOCAL procedure OnAfterSalesQuoteAccepted (var SalesHeader@1000 :

    /*
    LOCAL procedure OnAfterSalesQuoteAccepted (var SalesHeader: Record 36)
        begin
        end;
    */



    //     LOCAL procedure OnAfterChangePricesIncludingVAT (var SalesHeader@1000 :

    /*
    LOCAL procedure OnAfterChangePricesIncludingVAT (var SalesHeader: Record 36)
        begin
        end;
    */



    //     LOCAL procedure OnAfterSendSalesHeader (var SalesHeader@1000 : Record 36;ShowDialog@1001 :

    /*
    LOCAL procedure OnAfterSendSalesHeader (var SalesHeader: Record 36;ShowDialog: Boolean)
        begin
        end;
    */



    //     LOCAL procedure OnAfterSetFieldsBilltoCustomer (var SalesHeader@1000 : Record 36;Customer@1001 :

    /*
    LOCAL procedure OnAfterSetFieldsBilltoCustomer (var SalesHeader: Record 36;Customer: Record 18)
        begin
        end;
    */



    //     LOCAL procedure OnAfterTransferExtendedTextForSalesLineRecreation (var SalesLine@1000 :

    /*
    LOCAL procedure OnAfterTransferExtendedTextForSalesLineRecreation (var SalesLine: Record 37)
        begin
        end;
    */



    //     LOCAL procedure OnAfterCopyFromSellToCustTemplate (var SalesHeader@1000 : Record 36;SellToCustTemplate@1001 :

    /*
    LOCAL procedure OnAfterCopyFromSellToCustTemplate (var SalesHeader: Record 36;SellToCustTemplate: Record 5105)
        begin
        end;
    */



    //     LOCAL procedure OnAfterCopySellToAddressToShipToAddress (var SalesHeader@1000 :

    /*
    LOCAL procedure OnAfterCopySellToAddressToShipToAddress (var SalesHeader: Record 36)
        begin
        end;
    */



    //     LOCAL procedure OnAfterCopySellToAddressToBillToAddress (var SalesHeader@1000 :

    /*
    LOCAL procedure OnAfterCopySellToAddressToBillToAddress (var SalesHeader: Record 36)
        begin
        end;
    */



    //     LOCAL procedure OnAfterCopySellToCustomerAddressFieldsFromCustomer (var SalesHeader@1000 : Record 36;SellToCustomer@1001 : Record 18;CurrentFieldNo@1002 :

    /*
    LOCAL procedure OnAfterCopySellToCustomerAddressFieldsFromCustomer (var SalesHeader: Record 36;SellToCustomer: Record 18;CurrentFieldNo: Integer)
        begin
        end;
    */



    //     LOCAL procedure OnAfterCopyShipToCustomerAddressFieldsFromCustomer (var SalesHeader@1000 : Record 36;SellToCustomer@1001 :

    /*
    LOCAL procedure OnAfterCopyShipToCustomerAddressFieldsFromCustomer (var SalesHeader: Record 36;SellToCustomer: Record 18)
        begin
        end;
    */



    //     LOCAL procedure OnAfterCopyShipToCustomerAddressFieldsFromShipToAddr (var SalesHeader@1000 : Record 36;ShipToAddress@1001 :

    /*
    LOCAL procedure OnAfterCopyShipToCustomerAddressFieldsFromShipToAddr (var SalesHeader: Record 36;ShipToAddress: Record 222)
        begin
        end;
    */



    //     LOCAL procedure OnBeforeCheckCreditLimit (var SalesHeader@1000 : Record 36;var IsHandled@1001 :

    /*
    LOCAL procedure OnBeforeCheckCreditLimit (var SalesHeader: Record 36;var IsHandled: Boolean)
        begin
        end;
    */



    //     LOCAL procedure OnBeforeInitInsert (var SalesHeader@1000 : Record 36;xSalesHeader@1001 : Record 36;var IsHandled@1002 :

    /*
    LOCAL procedure OnBeforeInitInsert (var SalesHeader: Record 36;xSalesHeader: Record 36;var IsHandled: Boolean)
        begin
        end;
    */



    //     LOCAL procedure OnBeforeInitRecord (var SalesHeader@1000 : Record 36;var IsHandled@1001 :


    LOCAL procedure OnBeforeInitRecord(var SalesHeader: Record 36; var IsHandled: Boolean)
    begin
    end;




    //     LOCAL procedure OnBeforeUpdateCurrencyFactor (var SalesHeader@1000 : Record 36;var Updated@1001 :

    /*
    LOCAL procedure OnBeforeUpdateCurrencyFactor (var SalesHeader: Record 36;var Updated: Boolean)
        begin
        end;
    */



    //     LOCAL procedure OnBeforeRecreateSalesLines (var SalesHeader@1000 :

    /*
    LOCAL procedure OnBeforeRecreateSalesLines (var SalesHeader: Record 36)
        begin
        end;
    */



    //     LOCAL procedure OnBeforeSalesLineByChangedFieldNo (SalesHeader@1000 : Record 36;var SalesLine@1001 : Record 37;ChangedFieldNo@1003 : Integer;var IsHandled@1002 :


    LOCAL procedure OnBeforeSalesLineByChangedFieldNo(SalesHeader: Record 36; var SalesLine: Record 37; ChangedFieldNo: Integer; var IsHandled: Boolean)
    begin
    end;




    //     LOCAL procedure OnBeforeSalesLineInsert (var SalesLine@1000 : Record 37;var TempSalesLine@1001 :

    /*
    LOCAL procedure OnBeforeSalesLineInsert (var SalesLine: Record 37;var TempSalesLine: Record 37 TEMPORARY)
        begin
        end;
    */



    //     LOCAL procedure OnBeforeTestNoSeries (var SalesHeader@1000 : Record 36;var IsHandled@1001 :

    /*
    LOCAL procedure OnBeforeTestNoSeries (var SalesHeader: Record 36;var IsHandled: Boolean)
        begin
        end;
    */



    //     LOCAL procedure OnBeforeUpdateSalesLinesByFieldNo (var SalesHeader@1000 : Record 36;ChangedFieldNo@1001 : Integer;var AskQuestion@1002 : Boolean;var IsHandled@1003 :


    LOCAL procedure OnBeforeUpdateSalesLinesByFieldNo(var SalesHeader: Record 36; ChangedFieldNo: Integer; var AskQuestion: Boolean; var IsHandled: Boolean)
    begin
    end;




    //     LOCAL procedure OnCopySelltoCustomerAddressFieldsFromCustomerOnAfterAssignRespCenter (var SalesHeader@1000 : Record 36;Customer@1001 : Record 18;FieldNo@1002 :

    /*
    LOCAL procedure OnCopySelltoCustomerAddressFieldsFromCustomerOnAfterAssignRespCenter (var SalesHeader: Record 36;Customer: Record 18;FieldNo: Integer)
        begin
        end;
    */



    //     LOCAL procedure OnCreateSalesLineOnAfterAssignType (var SalesLine@1000 : Record 37;var TempSalesLine@1001 :

    /*
    LOCAL procedure OnCreateSalesLineOnAfterAssignType (var SalesLine: Record 37;var TempSalesLine: Record 37 TEMPORARY)
        begin
        end;
    */



    //     LOCAL procedure OnInitInsertOnBeforeInitRecord (var SalesHeader@1000 : Record 36;xSalesHeader@1001 :

    /*
    LOCAL procedure OnInitInsertOnBeforeInitRecord (var SalesHeader: Record 36;xSalesHeader: Record 36)
        begin
        end;
    */



    //     LOCAL procedure OnUpdateBillToCustOnAfterSalesQuote (var SalesHeader@1000 : Record 36;Contact@1001 :

    /*
    LOCAL procedure OnUpdateBillToCustOnAfterSalesQuote (var SalesHeader: Record 36;Contact: Record 5050)
        begin
        end;
    */



    //     LOCAL procedure OnValidateBilltoCustomerTemplateCodeBeforeRecreateSalesLines (var SalesHeader@1000 : Record 36;FieldNo@1001 :

    /*
    LOCAL procedure OnValidateBilltoCustomerTemplateCodeBeforeRecreateSalesLines (var SalesHeader: Record 36;FieldNo: Integer)
        begin
        end;
    */



    //     LOCAL procedure OnValidateSellToCustomerNoAfterInit (var SalesHeader@1000 : Record 36;xSalesHeader@1001 :

    /*
    LOCAL procedure OnValidateSellToCustomerNoAfterInit (var SalesHeader: Record 36;xSalesHeader: Record 36)
        begin
        end;
    */



    //     LOCAL procedure OnAfterTestQuantityShippedField (SalesLine@1000 :

    /*
    LOCAL procedure OnAfterTestQuantityShippedField (SalesLine: Record 37)
        begin
        end;

        [Integration(TRUE)]
    */

    //     LOCAL procedure OnBeforeTestStatusOpen (var SalesHeader@1000 :

    /*
    LOCAL procedure OnBeforeTestStatusOpen (var SalesHeader: Record 36)
        begin
        end;

        [Integration(TRUE)]
    */

    //     LOCAL procedure OnAfterTestStatusOpen (var SalesHeader@1000 :

    /*
    LOCAL procedure OnAfterTestStatusOpen (var SalesHeader: Record 36)
        begin
        end;
    */



    //     LOCAL procedure OnAfterUpdateBillToCont (var SalesHeader@1000 : Record 36;Customer@1001 : Record 18;Contact@1002 :

    /*
    LOCAL procedure OnAfterUpdateBillToCont (var SalesHeader: Record 36;Customer: Record 18;Contact: Record 5050)
        begin
        end;
    */



    //     LOCAL procedure OnAfterUpdateSellToCont (var SalesHeader@1000 : Record 36;Customer@1001 : Record 18;Contact@1002 :

    /*
    LOCAL procedure OnAfterUpdateSellToCont (var SalesHeader: Record 36;Customer: Record 18;Contact: Record 5050)
        begin
        end;
    */



    //     LOCAL procedure OnAfterUpdateSellToCust (var SalesHeader@1000 : Record 36;Contact@1001 :


    LOCAL procedure OnAfterUpdateSellToCust(var SalesHeader: Record 36; Contact: Record 5050)
    begin
    end;




    //     LOCAL procedure OnAfterUpdateSalesLines (var SalesHeader@1000 :

    /*
    LOCAL procedure OnAfterUpdateSalesLines (var SalesHeader: Record 36)
        begin
        end;
    */



    //     LOCAL procedure OnRecreateSalesLinesOnBeforeConfirm (var SalesHeader@1000 : Record 36;xSalesHeader@1001 : Record 36;ChangedFieldName@1002 : Text[100];HideValidationDialog@1003 : Boolean;var Confirmed@1004 : Boolean;var IsHandled@1005 :

    /*
    LOCAL procedure OnRecreateSalesLinesOnBeforeConfirm (var SalesHeader: Record 36;xSalesHeader: Record 36;ChangedFieldName: Text[100];HideValidationDialog: Boolean;var Confirmed: Boolean;var IsHandled: Boolean)
        begin
        end;

        /*begin
        //{
    //      MCG 19/07/18: - Q3707 A�adido campo "Payment bank No."
    //      JAV 20/06/19: - N�mero de serie de registro por proyecto
    //      JAV 03/07/19: - Poner doc externo y nombre del cliente en la descripci�n del registro
    //                  : - QCPM_GAP18 Aviso de fecha de registro superior al la del SII
    //      JAV 03/09/19: - Cargar las retenciones del cliente
    //      JAV 23/10/19: - Se doblan los campos de la retenci�n de B.E. para tener ambos importes disponibles
    //                    - Se cambian los eventos a la CU de retenciones
    //          16/08/17: - QuoSII_1.1 - Se modifican los campos 7174332 y 7174334. Se elimina el campo 7174333
    //                                 - Se modifica el trigger Sell-to Customer No. - OnValidate() para que inicialice el campo "Sales Invoice Type" siempre a F1 si el tipo es LF
    //      PEL 23/04/18: - QuoSII1.4 - Cambiado primer semestre en Sales Invoice Type, Sales Invoice Type 1 y Sales Invoice Type 2
    //                                - Al validar Sell-to Customer No. inicializar QuoSII Sales Special Regimen si fecha reg es anterior a fecha incl SII
    //      PEL 23/04/18: - QuoSII1.4 Nuevas validaciones en Special Regiments
    //      MCM 29/11/18: - QuoSII_1.4.02.042 Se incluye la opci�n de enviar a la ATCN
    //      QMD 11/07/19: - QuoSII_1.4.98.999 Filtros para la tabla SII Type List Value
    //      QMD 29/07/19: - QuoSII_1.4.02.042.22 Bug_12510 - Abonos no trae el R�gimen configurado en el proveedor
    //      QMD 21/08/19: - QuoSII_1.4.92.999 Controles del QuoSII en BBDD que no lo necesitan.
    //      JAV 09/09/20: - QB 1.06.12 La descripci�n del trabajo se lee con codificaci�n windows para evitar problemas
    //      JAV 06/07/21: - QB 1.09.04 Se elimina el c�digo del validate del campo QW Witholding Due Date, se pasa a un evento en la CU de retenciones
    //      JAV 16/07/21: - QB 1.09.06 Se traslada a la CU de Retenciones todas las acciones relacionadas con sus campos
    //      JAV 15/09/21: - QB 1.09.17 Se pasa el c�digo del validate del campo "QW Witholding Due Date" a la CU de manejo de tablas
    //      JAV 15/09/21: - QuoSII1.5z Mejora en el manejo de los campos relacionados, se pasa todo el c�digo a la CU de manejo de objetos est�ndar del QuoSII
    //      MCM 20/10/21: - QPR Q15431 Se crea el campo QB Budget item
    //      EPV 16/02/22: - Q12733 A�adir los campos "Price review", "Price review code", "Price review percentage" para traer la informacion de los pedidos de servicio
    //      DCS 08/03/22: - Q16565 Solucionar problema en BLOB con acentos. JAV 09/03/22 se incorpora a QB 1.10.23
    //      JAV 11/05/22: - QuoSII 1.06.07 Se traspasa la funcionalidad a la cu 7174332 SII Procesing para unificar
    //      PSM 05/05/23: - Q19433 Validar "Posting Date" s�lo cuando est� relleno
    //      Q19196 CSM 22/05/23 - IMP018 proveedores y clientes Varios. (B.S.)  NEW FIELD: 50000
    //      BS::20668 CSM 04/01/24 � VEN027 Modificar importe retenci�n en venta.
    //      BS::21212 CSM 18/03/24 � VEN017 Inf. Clientes previsi�n tesorer�a V3-CR.  New Field: 50003
    //    }
        end.
      */
}




