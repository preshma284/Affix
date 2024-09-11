tableextension 50115 "MyExtension50115" extends "Purchase Header"
{

    DataCaptionFields = "No.", "Buy-from Vendor Name";
    CaptionML = ENU = 'Purchase Header', ESP = 'Cab. compra';
    LookupPageID = "Purchase List";

    fields
    {
        field(50002; "Job Name"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Job"."Description" WHERE("No." = FIELD("QB Job No.")));
            CaptionML = ENU = 'Job name', ESP = 'Nombre proyecto';
            Description = 'Q19224';
            Editable = false;


        }
        field(50003; "Budget Name"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Data Piecework For Production"."Description" WHERE("Job No." = FIELD("QB Job No."),
                                                                                                                         "Piecework Code" = FIELD("QB Budget item")));
            CaptionML = ESP = 'Descripci�n P.Presup.';
            Description = 'Q19224';
            Editable = false;


        }
        field(50004; "From Several Vendors"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'From Several Vendors', ESP = 'Desde proveedores varios';
            Description = 'BS19196';
            Editable = false;


        }
        field(50005; "Vendor Credit Exceeded"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Vendor Credit Exceeded', ESP = 'Cr�dito proveedor superado';
            Description = 'BS::20087';
            Editable = false;


        }
        field(50006; "Mail Send Vendor Credit Exc."; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Mail Send Vendor Credit Exc.', ESP = 'Mail cr�dito prov. sup. enviado';
            Description = 'BS::20087';
            Editable = false;


        }
        field(50007; "Last Invoice"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Last Invoice', ESP = '�ltima factura';
            Description = 'BS::19888';
            Editable = false;


        }
        field(50008; "Last Invoice Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Last Invoice Date', ESP = 'Fecha �ltima factura';
            Description = 'BS::19888';


        }
        field(50012; "Notas filtro"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Notas filtro', ESP = 'Notas filtro';
            Description = 'BS::19798';
            Editable = false;


        }
        field(50013; "QW % Withholding by GE"; Decimal)
        {
            CaptionML = ENU = '% Withholding by G.E', ESP = '% retenci�n pago B.E.';
            Description = 'BS::19974';
            Editable = false;


        }
        field(50014; "Ajuste Manual Ret"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'BS::19974';


        }
        field(7174331; "QuoSII Auto Posting Date"; Date)
        {
            CaptionML = ENU = 'SII Auto Posting Date', ESP = 'SII Fecha Registro Auto';
            Description = 'QuoSII_1.3.03.006';


        }
        field(7174332; "QuoSII Entity"; Code[20])
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
        field(7174336; "QuoSII Purch. Invoice Type"; Code[20])
        {
            TableRelation = "SII Type List Value"."Code" WHERE("Type" = CONST("PurchInvType"),
                                                                                                   "SII Entity" = FIELD("QuoSII Entity"),
                                                                                                   "Code" = FILTER(<> 'R*'));
            CaptionML = ENU = 'Invoice Type', ESP = 'Tipo Factura';
            Description = 'QuoSII';


        }
        field(7174337; "QuoSII Purch. Cor. Inv. Type"; Code[20])
        {
            TableRelation = "SII Type List Value"."Code" WHERE("Type" = CONST("PurchInvType"),
                                                                                                   "SII Entity" = FIELD("QuoSII Entity"),
                                                                                                   "Code" = FILTER('R*'));
            CaptionML = ENU = 'Corrected Invoice Type', ESP = 'Tipo Factura Rectificativa';
            Description = 'QuoSII';


        }
        field(7174338; "QuoSII Purch. Cr.Memo Type"; Code[20])
        {
            TableRelation = "SII Type List Value"."Code" WHERE("Type" = CONST("CorrectedInvType"),
                                                                                                   "SII Entity" = FIELD("QuoSII Entity"));


            CaptionML = ENU = 'Cr. Memo Type', ESP = 'Tipo Abono';
            Description = 'QuoSII';

            trigger OnValidate();
            BEGIN
                //JAV 11/05/22: - QuoSII 1.06.07 Se traspasa la funcionalidad a la cu 7174332 SII Procesing para unificar
            END;


        }
        field(7174339; "QuoSII Purch Special Regimen"; Code[20])
        {
            TableRelation = "SII Type List Value"."Code" WHERE("Type" = CONST("KeySpecialPurchInv"),
                                                                                                   "SII Entity" = FIELD("QuoSII Entity"));
            CaptionML = ENU = 'Special Regimen', ESP = 'R�gimen Especial';
            Description = 'QuoSII';


        }
        field(7174340; "QuoSII Purch Special Regimen 1"; Code[20])
        {
            TableRelation = IF ("QuoSII Purch Special Regimen" = FILTER(07)) "SII Type List Value"."Code" WHERE("Type" = CONST("KeySpecialSalesInv"), "SII Entity" = FIELD("QuoSII Entity"), "Code" = FILTER('01' | '03' | '05' | '12')) ELSE IF ("QuoSII Purch Special Regimen" = FILTER(05)) "SII Type List Value"."Code" WHERE("Type" = CONST("KeySpecialSalesInv"), "SII Entity" = FIELD("QuoSII Entity"), "Code" = FILTER('01' | '06' | '07' | '08' | '12')) ELSE IF ("QuoSII Purch Special Regimen" = FILTER(12)) "SII Type List Value"."Code" WHERE("Type" = CONST("KeySpecialSalesInv"), "SII Entity" = FIELD("QuoSII Entity"), "Code" = FILTER('05' | '06' | '07' | '08')) ELSE IF ("QuoSII Purch Special Regimen" = FILTER(03)) "SII Type List Value"."Code" WHERE("Type" = CONST("KeySpecialSalesInv"), "SII Entity" = FIELD("QuoSII Entity"), "Code" = FILTER(01)) ELSE IF ("QuoSII Purch Special Regimen" = FILTER(01)) "SII Type List Value"."Code" WHERE("Type" = CONST("KeySpecialSalesInv"), "SII Entity" = FIELD("QuoSII Entity"), "Code" = FILTER(08));
            CaptionML = ENU = 'Special Regimen 1', ESP = 'R�gimen Especial 1';
            Description = 'QuoSII';


        }
        field(7174341; "QuoSII Purch Special Regimen 2"; Code[20])
        {
            TableRelation = IF ("QuoSII Purch Special Regimen" = FILTER(07)) "SII Type List Value"."Code" WHERE("Type" = CONST("KeySpecialSalesInv"), "SII Entity" = FIELD("QuoSII Entity"), "Code" = FILTER('01' | '03' | '05' | '12')) ELSE IF ("QuoSII Purch Special Regimen" = FILTER(05)) "SII Type List Value"."Code" WHERE("Type" = CONST("KeySpecialSalesInv"), "SII Entity" = FIELD("QuoSII Entity"), "Code" = FILTER('01' | '06' | '07' | '08' | '12')) ELSE IF ("QuoSII Purch Special Regimen" = FILTER(12)) "SII Type List Value"."Code" WHERE("Type" = CONST("KeySpecialSalesInv"), "SII Entity" = FIELD("QuoSII Entity"), "Code" = FILTER('05' | '06' | '07' | '08')) ELSE IF ("QuoSII Purch Special Regimen" = FILTER(03)) "SII Type List Value"."Code" WHERE("Type" = CONST("KeySpecialSalesInv"), "SII Entity" = FIELD("QuoSII Entity"), "Code" = FILTER(01)) ELSE IF ("QuoSII Purch Special Regimen" = FILTER(01)) "SII Type List Value"."Code" WHERE("Type" = CONST("KeySpecialSalesInv"), "SII Entity" = FIELD("QuoSII Entity"), "Code" = FILTER(08));
            CaptionML = ENU = 'Special Regimen 2', ESP = 'R�gimen Especial 2';
            Description = 'QuoSII';


        }
        field(7174342; "QuoSII Purch. UE Inv Type"; Code[20])
        {
            TableRelation = "SII Type List Value"."Code" WHERE("Type" = CONST("IntraType"),
                                                                                                   "SII Entity" = FIELD("QuoSII Entity"));
            CaptionML = ENU = 'Purch. UE Inv Type', ESP = 'Tipo Factura IntraComunitaria';
            Description = 'QuoSII';


        }
        field(7174343; "QuoSII Bienes Description"; Text[40])
        {
            CaptionML = ENU = 'Bienes Description', ESP = 'Descripci�n Bienes';
            Description = 'QuoSII';


        }
        field(7174344; "QuoSII Operator Address"; Text[100])
        {
            CaptionML = ENU = 'Operator Address', ESP = 'Direcci�n Operador';
            Description = 'QuoSII';


        }
        field(7174345; "QuoSII Last Ticket No."; Code[20])
        {
            CaptionML = ENU = 'Last Ticket No.', ESP = '�ltimo N� Ticket';
            Description = 'QuoSII';


        }
        field(7174346; "QuoSII Third Party"; Boolean)
        {
            CaptionML = ENU = 'Third Party', ESP = 'Emitida por tercero';
            Description = 'QuoSII';


        }
        field(7174347; "QuoSII Exercise-Period"; Code[7])
        {


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
        field(7174360; "DP Force Not Use Prorrata"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Apply prorrata', ESP = 'Forzar no aplicar';
            Description = 'DP 1.00.00 PRORRATA JAV 21/06/22: [TT] Si se marca este campo no se aplicar� la prorrata en ning�in caso, aunque el sistema calcule que si debe usarse';


        }
        field(7174361; "DP Apply Prorrata Type"; Option)
        {
            OptionMembers = "No","General","Especial";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Apply prorrata', ESP = 'Tipo de Prorrata Aplicable';
            OptionCaptionML = ENU = 'No,General,Special', ESP = 'No,General,Especial';

            Description = 'DP 1.00.00 PRORRATA';
            Editable = false;


        }
        field(7174362; "DP Prorrata %"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = '% Prorrata Aplicada';
            DecimalPlaces = 0 : 0;
            MinValue = 0;
            MaxValue = 100;
            Description = 'DP 1.00.00 PRORRATA';
            Editable = false;


        }
        field(7174364; "DP Non Deductible VAT Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Purchase Line"."DP Non Deductible VAT amount" WHERE("Document Type" = FIELD("Document Type"),
                                                                                                                         "Document No." = FIELD("No.")));
            CaptionML = ESP = 'IVA no deducible';
            Description = 'DP 1.00.00 PRORRATA : JAV 21/06/22: [TT] Este campo indica el importe total de IVA no deducible del documento';
            Editable = false;


        }
        field(7174365; "DP Deductible VAT Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Purchase Line"."DP Deductible VAT amount" WHERE("Document Type" = FIELD("Document Type"),
                                                                                                                     "Document No." = FIELD("No.")));
            CaptionML = ESP = 'IVA deducible';
            Description = 'DP 1.00.00 PRORRATA : JAV 21/06/22: [TT] Este campo indica el importe total de IVA deducible del documento';
            Editable = false;


        }
        field(7207270; "QW Cod. Withholding by GE"; Code[20])
        {
            TableRelation = "Withholding Group"."Code" WHERE("Withholding Type" = FILTER("G.E"),
                                                                                                 "Use in" = FILTER('Booth' | 'Vendor'));
            CaptionML = ENU = 'Cod. Withholding by G.E', ESP = 'C�d. retenci�n por B.E.';
            Description = 'QB 1.0 - QB22111';


        }
        field(7207271; "QW Cod. Withholding by PIT"; Code[20])
        {
            TableRelation = "Withholding Group"."Code" WHERE("Withholding Type" = FILTER("PIT"),
                                                                                                 "Use in" = FILTER('Booth' | 'Vendor'));
            CaptionML = ENU = 'Cod. Withholding by PIT', ESP = 'C�d. retenci�n por IRPF';
            Description = 'QB 1.0 - QB22111';


        }
        field(7207272; "QW Total Withholding GE"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Purchase Line"."QW Withholding Amount by GE" WHERE("Document Type" = FIELD("Document Type"),
                                                                                                                        "Document No." = FIELD("No.")));
            CaptionML = ENU = 'Total Withholding G.E', ESP = 'Total retenci�n B.E.';
            Description = 'QB 1.0 - QB22111';
            Editable = false;


        }
        field(7207273; "QW Total Withholding PIT"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Purchase Line"."QW Withholding Amount by PIT" WHERE("Document Type" = FIELD("Document Type"),
                                                                                                                         "Document No." = FIELD("No.")));
            CaptionML = ENU = 'Total Withholding PIT', ESP = 'Total retenci�n IRPF';
            Description = 'QB 1.0 - QB22111';
            Editable = false;


        }
        field(7207275; "QB Order To"; Option)
        {
            OptionMembers = "Job","Location";
            CaptionML = ENU = 'Order To', ESP = 'Pedido contra';
            OptionCaptionML = ENU = 'Job,Location', ESP = 'Proyecto,Almac�n';

            Description = 'QB 1.0 - QB2514';


        }
        field(7207276; "QB Job No."; Code[20])
        {
            TableRelation = "Job";


            CaptionML = ENU = 'Job No.', ESP = 'N� proyecto';
            Description = 'QB 1.0 - QB2514';

            trigger OnValidate();
            VAR
                //                                                                 Job@1100286000 :
                Job: Record 167;
                //                                                                 Text000@1100286001 :
                Text000: TextConst ENU = 'You have changed %1 on the purchase header, but it has not been changed on the existing purchase lines.\', ESP = '�Desea modificar el proyecto en las l�neas de compra existentes?';
                //                                                                 Text001@100000001 :
                Text001: TextConst ENU = 'You can not specify Job on orders against Location', ESP = 'No puede especificar proyecto en pedidos contra almac�n';
                //                                                                 QBTableSubscriber@100000002 :
                QBTableSubscriber: Codeunit 7207347;
                //                                                                 Text002@1100286003 :
                Text002: TextConst ESP = 'No tiene acceso al proyecto %1';
            BEGIN
                //JAV 29/06/22: - QB 1.10.57 No se permite cambiar el campo si el documento no est� abierto
                TESTFIELD(Status, Status::Open);

                //JAV 23/05/22: - QB 1.10.43 Se revisa el validate del campo, se incluye el tratamiento del cambio del proyecto de aprobaci�n
                IF (Rec."QB Job No." = '') THEN
                    EXIT;

                IF "QB Order To" = "QB Order To"::Location THEN
                    ERROR(Text001);

                //Mirar que el proyecto est� asignado al usuario
                IF NOT FunctionQB.CanUserAccessJob("QB Job No.") THEN
                    ERROR(Text002, "QB Job No.");


                //Actualizar la dimensi�n en la cabecera
                QBTableSubscriber.ChangeJobNo_TPurchaseHeader(Rec);


                //JAV 20/05/22: - QB 1.10.42 Tras cambiar el proyecto en la cabecera, ver si tiene l�neas con diferente proyecto y ponerlo en el de aprobaci�n
                //{---
                //                                                                //JAV 01/11/19: - Si cambia el proyecto en la cabecera, preguntar si se quiere cambiar en las l�neas
                //                                                                IF ("QB Job No." <> xRec."QB Job No.") AND (PurchLinesExist) AND (NOT HideValidationDialog) THEN BEGIN 
                //                                                                  IF CONFIRM(Text000, TRUE) THEN BEGIN 
                //                                                                    PurchLine.RESET;
                //                                                                    PurchLine.SETRANGE("Document Type","Document Type");
                //                                                                    PurchLine.SETRANGE("Document No.","No.");
                //                                                                    PurchLine.SETFILTER("No.",'<>%1', '');
                //                                                                    IF PurchLine.FINDSET(TRUE) THEN
                //                                                                      REPEAT
                //                                                                        PurchLine.VALIDATE("Job No.", "QB Job No.");
                //                                                                        PurchLine.MODIFY;
                //                                                                      UNTIL PurchLine.NEXT = 0;
                //                                                                  END;
                //                                                                END;
                //                                                                ---}
                MsgLines := '';
                IF (Rec."QB Job No." <> xRec."QB Job No.") AND (PurchLinesExist) AND (NOT HideValidationDialog) THEN BEGIN
                    PurchLine.RESET;
                    PurchLine.SETRANGE("Document Type", Rec."Document Type");
                    PurchLine.SETRANGE("Document No.", Rec."No.");
                    PurchLine.SETFILTER("Job No.", '<>%1 & <>%2', '', Rec."QB Job No.");
                    IF NOT PurchLine.ISEMPTY THEN
                        MsgLines := STRSUBSTNO('Tiene %1 l�neas con el proyecto diferente, rev�selas si es necesario.\ ', PurchLine.COUNT);
                END;

                Ok := FALSE;
                IF (Rec."QB Approval Job No" = '') THEN
                    Ok := TRUE
                ELSE IF (Rec."QB Approval Job No" <> Rec."QB Job No.") THEN BEGIN
                    Ok := CONFIRM(MsgLines + '�Desea cambiar el proyecto de aprobaci�n?', TRUE);
                    MsgLines := '';
                END;

                IF (Ok) THEN
                    Rec.VALIDATE("QB Approval Job No", Rec."QB Job No.");

                IF (MsgLines <> '') THEN
                    MESSAGE(MsgLines);


                //JAV 01/07/19: - N�mero de serie de registro de FRI por proyecto
                IF (FunctionQB.QB_UserSeriesForJob) THEN BEGIN
                    IF (Job.GET("QB Job No.")) THEN BEGIN
                        IF (Job."Serie Registro FRI" <> '') THEN BEGIN
                            "Receiving No. Series" := Job."Serie Registro FRI";
                        END;
                    END;
                END;
            END;

            trigger OnLookup();
            VAR
                //                                                               JobNo@1100286001 :
                JobNo: Code[20];
            BEGIN
                //JAV 25/07/19: - Al sacar la lista de proyectos, filtrar por los que se pueden ver por el usuario
                JobNo := Rec."QB Job No."; //JAV 03/03/22: - QB 1.10.22 Pasar el proyecto actual a la funci�n
                IF FunctionQB.LookupUserJobs(JobNo) THEN
                    VALIDATE("QB Job No.", JobNo);
            END;


        }
        field(7207277; "QB Temp Document Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'QB 1.0 - JAV 20/03/20: - Para guardar temporalmente la fecha del documento en procesos de validaci�n';


        }
        field(7207278; "QB Receipt Date"; Date)
        {


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Fecha Recepci�n';
            Description = 'QB 1.0 - JAV 08/01/20: ROIG_CYS GAP12 - Recepci�n de documentos, fecha de recepci�n';

            trigger OnValidate();
            BEGIN
                IF xRec."QB Receipt Date" <> "QB Receipt Date" THEN
                    UpdateDocumentDate := TRUE;
                VALIDATE("Payment Terms Code");
                VALIDATE("Prepmt. Payment Terms Code");
            END;


        }
        field(7207279; "QB Total document amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Importe Proveedor';
            Description = 'QB 1.0 - JAV 08/01/20: ROIG_CYS GAP12 - Recepci�n de documentos, importe del documento';


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
        field(7207285; "QB Contract"; Boolean)
        {
            CaptionML = ENU = 'From Comparative', ESP = 'Desde un Comparativo';
            Description = 'QB 1.0 - QB2515  JAV 04/08/22: Se cambia el caption';
            Editable = false;


        }
        field(7207289; "QB Receive in FRIS"; Boolean)
        {
            CaptionML = ENU = 'Receive in FRIS', ESP = 'Recibir en FRIS';
            Description = 'QB 1.0 - QB2517';


        }
        field(7207290; "QB % Proformar"; Decimal)
        {
            CaptionML = ESP = 'Porc. de proforma a generar';
            MinValue = 0;
            MaxValue = 100;
            Description = 'QB 1.08.48  JAV 21/04/21: - Porcentaje por defecto a proformar en el documento';


        }
        field(7207291; "QB Do not send to SII"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'No subir al SII';
            Description = 'QB 1.04 - JAV 28/05/20: - Este documento no subir� autom�ticamente al SII de MS';


        }
        field(7207294; "QB First Receipt"; Boolean)
        {
            CaptionML = ENU = 'First Receipt', ESP = 'Primer Albar�n';
            Description = 'QB 1.8.48 JAV 14/06/21 Indica si es el primer albar�n de una factura, para cambiar metodo y forma de pago';


        }
        field(7207295; "QB Contract No."; Code[20])
        {
            TableRelation = "Purchase Header"."No." WHERE("Document Type" = CONST("Order"),
                                                                                              "QB Job No." = FIELD("QB Job No."));


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Order to Cancel', ESP = 'N� Contrato';
            Description = 'QB 1.0 - JAV 15/06/19: - Sobre que contrato estamos trabajando';

            trigger OnLookup();
            VAR
                //                                                               QBPageSubscriber@100000000 :
                QBPageSubscriber: Codeunit 7207349;
            BEGIN
                QBPageSubscriber.LookUpContrat("QB Contract No.");
            END;


        }
        field(7207296; "QW Base Withholding GE"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Purchase Line"."QW Base Withholding by GE" WHERE("Document Type" = FIELD("Document Type"),
                                                                                                                      "Document No." = FIELD("No.")));
            CaptionML = ENU = 'Total Withholding G.E', ESP = 'Base retenci�n B.E.';
            Description = 'QB 1.0 - QB22111';
            Editable = false;


        }
        field(7207297; "QW Base Withholding PIT"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Purchase Line"."QW Base Withholding by PIT" WHERE("Document Type" = FIELD("Document Type"),
                                                                                                                       "Document No." = FIELD("No.")));
            CaptionML = ENU = 'Total Withholding PIT', ESP = 'Base retenci�n IRPF';
            Description = 'QB 1.0 - QB22111';
            Editable = false;


        }
        field(7207298; "QW Total Withholding GE Before"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Purchase Line"."Amount" WHERE("Document Type" = FIELD("Document Type"),
                                                                                                 "Document No." = FIELD("No."),
                                                                                                 "QW Withholding by GE Line" = CONST(true)));
            CaptionML = ENU = 'Total Withholding G.E', ESP = 'Total retenci�n B.E. Fra.';
            Description = 'QB 1.0 - JAV 23/10/19: - Se doblan los campos de la retenci�n de B.E. para tener ambos importes disponibles';
            Editable = false;


        }
        field(7207299; "QB Obralia Entry"; Integer)
        {
            TableRelation = "Obralia Log Entry";


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Obralia Entry', ESP = 'Reg. Obralia';
            Description = 'QB 1.05.07 - JAV 23/07/20 : - Entrada en el registro de Obralia';
            Editable = false;

            trigger OnValidate();
            VAR
                //                                                                 ObraliaLogEntry@1100286000 :
                ObraliaLogEntry: Record 7206904;
                //                                                                 PurchasesPayablesSetup@1100286001 :
                PurchasesPayablesSetup: Record 312;
                //                                                                 txtQB000@1100286002 :
                txtQB000: TextConst ESP = 'Rechazado por Obralia';
            BEGIN
                ObraliaLogEntry.GET("QB Obralia Entry");
                PurchasesPayablesSetup.GET;

                IF (ObraliaLogEntry.IsSemaphorGreen) AND ("OLD_QB Approval Coment" = txtQB000) THEN BEGIN
                    VALIDATE("OLD_QB Approval Situation", Rec."OLD_QB Approval Situation"::Pending);
                    "OLD_QB Approval Coment" := '';
                END;

                IF (ObraliaLogEntry.IsSemaphorRed) THEN BEGIN
                    VALIDATE("OLD_QB Approval Situation", Rec."OLD_QB Approval Situation"::Rejected);
                    "OLD_QB Approval Coment" := txtQB000;
                END;

                MODIFY;
            END;


        }
        field(7207302; "OLD_QB Approval Situation"; Option)
        {
            OptionMembers = "Pending","Approved","Rejected","Withheld";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Status', ESP = 'Situaci�n de la Aprobaci�n';
            OptionCaptionML = ESP = 'Pendiente,Aprobado,Rechazado,Retenido';

            Description = '### ELIMINAR ### No se usa';
            Editable = false;


        }
        field(7207303; "OLD_QB Approval Coment"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Comentario Aprobaci�n';
            Description = '### ELIMINAR ### No se usa';
            Editable = false;


        }
        field(7207304; "OLD_QBApproval Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Fecha aprobaci�n';
            Description = '### ELIMINAR ### No se usa';
            Editable = false;


        }
        field(7207305; "OLD_QB Approval Circuit"; Option)
        {
            OptionMembers = "General","Materiales","Subcontratas";

            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Circuito de AprobaciÂ¢n';
            OptionCaptionML = ESP = 'General,Materiales,Subcontratas';

            Description = '### ELIMINAR ### No se usa';

            trigger OnValidate();
            VAR
                // txt001@1100286000 :
                txt001: TextConst ESP = 'No puede usar este circuito de aprobaciÂ¢n';
            BEGIN
            END;


        }
        field(7207306; "QB SII Year-Month"; Text[7])
        {


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'SII Ejercicio-Periodo';
            Description = 'QB 1.05 - JAV Ejercicio y periodo en que se declar� en el SII de Microsoft';
            Editable = false;

            trigger OnValidate();
            BEGIN
                IF ("Posting Date" <> 0D) THEN
                    "QB SII Year-Month" := FORMAT(DATE2DMY("Posting Date", 3)) + '-' + FORMAT("Posting Date", 0, '<Month,2>');
            END;


        }
        field(7207307; "QB Payment Phases"; Code[20])
        {
            TableRelation = "QB Payments Phases";


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Fases de Pago';
            Description = 'QB 1.06 - JAV 06/07/20: - Si el pago se hacer por fases de pago';

            trigger OnValidate();
            BEGIN
                //JAV 29/06/22: - QB 1.10.57 No se permite cambiar el campo si el documento no est� abierto
                TESTFIELD(Status, Status::Open);

                IF ("QB Payment Phases" <> '') THEN BEGIN
                    "Payment Method Code" := '';
                    "Payment Terms Code" := '';
                    QBPaymentPhasesandDueDate.MountDocument(Rec);
                END ELSE BEGIN
                    IF Vend.GET("Buy-from Vendor No.") THEN BEGIN
                        IF ("Payment Method Code" = '') THEN
                            "Payment Method Code" := Vend."Payment Method Code";
                        IF ("Payment Terms Code" = '') THEN
                            "Payment Terms Code" := Vend."Payment Terms Code";
                    END;
                END;
            END;


        }
        field(7207308; "QB SII Operation Description"; Code[20])
        {
            TableRelation = "QB SII Operation Description";


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Descripci�n operaci�n SII';
            Description = 'QB 1.06 - JAV 09/07/20: - De la tabla de descripciones de la operaci�n';

            trigger OnValidate();
            VAR
                //                                                                 QBSIIOperationDescription@1100286000 :
                QBSIIOperationDescription: Record 7206931;
            BEGIN
                IF (QBSIIOperationDescription.GET("QB SII Operation Description")) THEN
                    "Operation Description" := QBSIIOperationDescription.Description;
            END;


        }
        field(7207309; "QB Calc Due Date"; Option)
        {
            OptionMembers = "Standar","Document","Reception","Approval";

            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Calculo Vencimientos';
            OptionCaptionML = ENU = 'Standar,Document,Reception,Approval', ESP = 'La configurada en QB,Fecha del Documento,Fecha de Recepci�n,Fecha de Aprobaci�n';

            Description = 'QB 1.06 - JAV 12/07/20: - A partir de que fecha se calcula el vto de las fras de compra, GAP12 ROIG CyS,ORTIZ';

            trigger OnValidate();
            BEGIN
                IF xRec."QB Calc Due Date" <> "QB Calc Due Date" THEN BEGIN
                    UpdateDocumentDate := TRUE;
                    IF ("QB Calc Due Date" = "QB Calc Due Date"::Reception) THEN BEGIN
                        "QB No. Days Calc Due Date" := FunctionQB.QB_NoDaysCalcDueDate;
                    END;
                END;

                IF ("QB Calc Due Date" <> "QB Calc Due Date"::Reception) THEN
                    "QB No. Days Calc Due Date" := 0;


                VALIDATE("Payment Terms Code");
                VALIDATE("Prepmt. Payment Terms Code");
                VALIDATE("QW Witholding Due Date", 0D);
            END;


        }
        field(7207310; "QB No. Days Calc Due Date"; Integer)
        {


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'N� d�as tras Recepci�n';
            Description = 'QB 1.06 - JAV 12/07/20: - d�as adicionales para el c�lculo del vto de las fras de compra, ORTIZ';

            trigger OnValidate();
            BEGIN
                IF xRec."QB No. Days Calc Due Date" <> "QB No. Days Calc Due Date" THEN
                    UpdateDocumentDate := TRUE;
                VALIDATE("Payment Terms Code");
                VALIDATE("Prepmt. Payment Terms Code");
            END;


        }
        field(7207311; "QB Due Date Base"; Date)
        {


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Base Calculo Vto.';
            Description = 'QB 1.06 - JAV 12/07/20: - Fecha base para el c�clulo de los vencimientos de las fras de compra,ORTIZ';
            Editable = false;

            trigger OnValidate();
            BEGIN
                VALIDATE("QW Witholding Due Date", 0D);
            END;


        }
        field(7207312; "QB Merge conditions in Rcpt."; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Albaranes dif.cond.';
            Description = 'QB 1.06 - JAV 12/07/20: - Si se pueden mezclar albaranes con diferentes condiciones en la factura';


        }
        field(7207313; "QW Witholding Due Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Fecha Vto. Retenci�n';
            Description = 'QB 1.06.07 - JAV 30/07/20: - Fecha de vencimiento de la retenci�n de buena ejecuci�n';


        }
        field(7207314; "QB Documentation Verified"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Documentaci�n Verificada';
            Description = 'QB 1.06.17 - JAV 01/10/20: - Si se ha verificado la documentaci�n que debe aportar el proveedor con la factura';


        }
        field(7207315; "QB From Proform"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Desde la proforma';
            Description = 'QB 1.08.41   JAV 27/04/21: - Indica el n�mnero de la proforma que se est� facturando';


        }
        field(7207320; "QB Prepayment Use"; Option)
        {
            OptionMembers = "No","Prepayment","Application","DontProcess";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Prepayment', ESP = 'Uso del Anticipo';
            OptionCaptionML = ENU = 'No,Prepayment,Application,Dont process', ESP = 'No,Anticipo,Aplicaci�n,No Procesar';

            Description = 'Q12879';


        }
        field(7207321; "QB Prepayment Pending"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("QB Prepayment"."Amount" WHERE("Job No." = FIELD("QB Job No."),
                                                                                                 "Account Type" = CONST("Vendor"),
                                                                                                 "Account No." = FIELD("Buy-from Vendor No."),
                                                                                                 "Currency Code" = FIELD("Currency Code")));
            CaptionML = ENU = 'Prepayment Pending Amount', ESP = 'Anticipo Pendiente';
            Description = 'Q12879';
            Editable = false;


        }
        field(7207322; "QB Prepayment Apply"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Prepayment Amount to Apply', ESP = 'Descontar Anticipo';
            Description = 'Q12879';

            trigger OnValidate();
            VAR
                //                                                                 QBPrepayments@1100286000 :
                QBPrepayments: Codeunit 7207300;
                //                                                                 ExceedAmtErr@1100286001 :
                ExceedAmtErr: TextConst ENU = 'The amount of the prepayment cannot exceed the pending.', ESP = 'El importe del anticipo no puede ser superior al pendiente.';
            BEGIN
                //Q12879 -
                CALCFIELDS("QB Prepayment Pending");
                IF ("QB Prepayment Apply" > "QB Prepayment Pending") THEN
                    ERROR(ExceedAmtErr);

                IF "QB Prepayment Apply" = 0 THEN
                    "QB Prepayment Use" := "QB Prepayment Use"::No
                ELSE
                    "QB Prepayment Use" := "QB Prepayment Use"::Application;

                QBPrepayments.CreatePrepayment_PurchaseLines(Rec);
                //Q12879 +
            END;


        }
        field(7207324; "QB Generate Proform"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Generar Proforma tras registrar';
            Description = 'QB 1.08.41 JAV 06/05/21: - Si est� marcado se generar� la proforma tras registrar el documento';


        }
        field(7207325; "QB Order No."; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'N� Pedido';
            Description = 'QB 1.08.42 JAV 17/05/21: - N�mero del pedido, este campo proviene de la proforma';


        }
        field(7207326; "QB Prepayment Type"; Option)
        {
            OptionMembers = "No","Invoice","Bill";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Tipo de Prepago';
            OptionCaptionML = ENU = 'No,Invoice,Bill', ESP = 'No,Factura,Pago';

            Description = 'QB 1.08.43 - Tipo de prepago a generar';


        }
        field(7207330; "QB No. Generated Proforms"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("QB Proform Header" WHERE("Order No." = FIELD("No.")));
            CaptionML = ESP = 'N� proformas generadas';
            Description = 'QB 1.08.48 - JAV 06/06/21 N� de documentos de proformas generadas de este documentos';
            Editable = false;


        }
        field(7207331; "QB Manage by Proforms"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Manejo por Proformas';
            Description = 'QB 1.08.48 - JAV 06/06/21 Si el documento se debe manejar a trav�s de las proformas';


        }
        field(7207332; "QB Payable Bank No."; Code[20])
        {
            TableRelation = "Bank Account";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'QB Payable Bank No.', ESP = 'N� de banco de pago';
            Description = 'QB 1.09.22 JAV 06/10/21 Banco por defecto para los pagos a este proveedor';


        }
        field(7207336; "QB Approval Circuit Code"; Code[20])
        {
            TableRelation = IF ("Document Type" = CONST("Order")) "QB Approval Circuit Header" WHERE("Document Type" = CONST("PurchaseOrder")) ELSE IF ("Document Type" = CONST("Invoice")) "QB Approval Circuit Header" WHERE("Document Type" = CONST("PurchaseInvoice")) ELSE IF ("Document Type" = CONST("Credit Memo")) "QB Approval Circuit Header" WHERE("Document Type" = CONST("PurchaseCrMemo"));
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Approval Circuit Code', ESP = 'Circuito de Aprobaci�n';
            Description = 'QB 1.10.22 - JAV 22/02/22 [TT] Que circuito de aprobaci�n que se utilizar� para este documento';


        }
        field(7207337; "QB Approval Job No"; Code[20])
        {
            TableRelation = "Job";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Proyecto para la Aprobaci�n';
            Description = 'QB 1.10.42 JAV 21/06/22 [TT] Indica el proyecto que se usar� para aprobar este documento, puede ser diferente al establecido para el documento en general';


        }
        field(7207338; "QB Approval Budget item"; Code[20])
        {
            TableRelation = "Data Piecework For Production"."Piecework Code" WHERE("Job No." = FIELD("QB Approval Job No"),
                                                                                                                         "Account Type" = FILTER("Unit"));
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'P.Presup. para la Aprobaci�n';
            Description = 'QB 1.10.57 JAV 30/06/22 [TT] Indica la partida presupuestaria o la U.Obra que se usar� para aprobar este documento, puede ser diferente al establecido para el documento en general';


        }
        field(7207342; "QB Prepayment Data"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Datos del Anticipo Aplicado';
            Description = 'QB 1.10.49 JAV 13/06/22: [TT] Indica el c�digo de los datos aplicados del anticipo al documento';


        }

        field(7207350; "Works Date"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Works Date', ESP = 'Fecha trabajos';
            Description = 'Q19775';


        }
        field(7207700; "QB Stocks New Functionality"; Boolean)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'New_Functionality', ESP = 'Nueva Funcionalidad Stocks';
            Description = 'QB_ST01';

            trigger OnValidate();
            VAR
                //                                                                 PurchasesPayablesSetup@1100286000 :
                PurchasesPayablesSetup: Record 312;
            BEGIN
                PurchasesPayablesSetup.GET;
                IF PurchasesPayablesSetup."QB Stocks Active New Function" = PurchasesPayablesSetup."QB Stocks Active New Function"::No THEN "QB Stocks New Functionality" := FALSE;
                IF PurchasesPayablesSetup."QB Stocks Active New Function" = PurchasesPayablesSetup."QB Stocks Active New Function"::Mandatory THEN "QB Stocks New Functionality" := TRUE;
            END;


        }
        field(7238177; "QB Budget item"; Code[20])
        {
            TableRelation = "Data Piecework For Production"."Piecework Code" WHERE("Job No." = FIELD("QB Job No."),
                                                                                                                         "Account Type" = FILTER("Unit"));


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Partida Presupuestaria';
            Description = 'QPR';

            trigger OnValidate();
            BEGIN
                //JAV 29/06/22: - QB 1.10.57 No se permite cambiar el campo si el documento no est� abierto
                TESTFIELD(Status, Status::Open);

                IF (Rec."QB Budget item" = '') THEN
                    EXIT;

                //JAV 20/05/22: - QB 1.10.42 Actualizar la dimensi�n con el sistema nuevo
                //JAV 28/10/22: - QB 1.12.11 Solo si est� marcado el check de crear dimensi�n = Partida cambiar la dimensi�n CA pues van de la mano
                IF (QuoBuildingSetup.GET()) THEN
                    IF (QuoBuildingSetup."QB_QPR Create Dim.Value") THEN
                        FunctionQB.SetDimensionIDWithGlobals(FunctionQB.ReturnDimCA, Rec."QB Budget item", Rec."Shortcut Dimension 1 Code", Rec."Shortcut Dimension 2 Code", Rec."Dimension Set ID");

                //JAV 20/05/22: - QB 1.10.42 Tras cambiar UO/Partida en la cabecera, ver si ponerla en la de aprobaci�n
                MsgLines := '';
                IF (Rec."QB Budget item" <> xRec."QB Budget item") THEN BEGIN
                    PurchLine.RESET;
                    PurchLine.SETRANGE("Document Type", Rec."Document Type");
                    PurchLine.SETRANGE("Document No.", Rec."No.");
                    PurchLine.SETFILTER("Piecework No.", '<>%1 & <>%2', '', Rec."QB Budget item");
                    IF NOT PurchLine.ISEMPTY THEN
                        MsgLines := STRSUBSTNO('Tiene %1 l�neas con una partida diferente, rev�selas si es necesario.\ ', PurchLine.COUNT);
                END;

                Ok := FALSE;
                IF (Rec."QB Approval Budget item" = '') THEN
                    Ok := TRUE
                ELSE IF (Rec."QB Approval Budget item" <> Rec."QB Budget item") THEN BEGIN
                    Ok := CONFIRM(MsgLines + '�Desea cambiar la Partida Presupuestaria de aprobaci�n?', TRUE);
                    MsgLines := '';
                END;

                IF (Ok) THEN
                    Rec.VALIDATE("QB Approval Budget item", Rec."QB Budget item");

                IF (MsgLines <> '') THEN
                    MESSAGE(MsgLines);
            END;


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
        // key(key3;"Document Type","Buy-from Vendor No.")
        //  {
        /* ;
  */
        // }
        // key(key4;"Document Type","Pay-to Vendor No.")
        //  {
        /* ;
  */
        // }
        // key(key5;"Buy-from Vendor No.")
        //  {
        /* ;
  */
        // }
        // key(key6;"Incoming Document Entry No.")
        //  {
        /* ;
  */
        // }
        // key(key7;"Document Date")
        //  {
        /* ;
  */
        // }
        // key(key8;"Status","Expected Receipt Date","Location Code","Responsibility Center")
        //  {
        /* ;
  */
        // }
    }
    fieldgroups
    {
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
        //       YouCannotChangeFieldErr@1006 :
        YouCannotChangeFieldErr:
// %1 - fieldcaption
TextConst ENU = 'You cannot change %1 because the order is associated with one or more sales orders.', ESP = 'No se puede cambiar %1 porque el pedido est� asociado con pedidos de venta.';
        //       Text007@1007 :
        Text007: TextConst ENU = '%1 is greater than %2 in the %3 table.\', ESP = '%1 es mayor que %2 en la tabla %3.\';
        //       Text008@1008 :
        Text008: TextConst ENU = 'Confirm change?', ESP = '�Confirma el cambio?';
        //       Text009@1009 :
        Text009:
// "%1 = Document No."
TextConst ENU = 'Deleting this document will cause a gap in the number series for receipts. An empty receipt %1 will be created to fill this gap in the number series.\\Do you want to continue?', ESP = 'Si elimina el documento, se provocar� una discontinuidad en los n�meros de serie de los recibos. Se crear� un recibo en blanco %1 para corregir esta discontinuidad en los n�meros de serie.\\�Desea continuar?';
        //       Text012@1012 :
        Text012:
// "%1 = Document No."
TextConst ENU = 'Deleting this document will cause a gap in the number series for posted invoices. An empty posted invoice %1 will be created to fill this gap in the number series.\\Do you want to continue?', ESP = 'Si elimina el documento se provocar� una discontinuidad en la numeraci�n de la serie de facturas registradas. Se crear� una factura registrada en blanco %1 para completar este error en las series num�ricas.\\�Desea continuar?';
        //       Text014@1014 :
        Text014:
// "%1 = Document No."
TextConst ENU = 'Deleting this document will cause a gap in the number series for posted credit memos. An empty posted credit memo %1 will be created to fill this gap in the number series.\\Do you want to continue?', ESP = 'Si elimina el documento, se provocar� una discontinuidad en la serie num�rica de abonos registrados. Se crear� un abono registrado en blanco %1 para completar este error en las series num�ricas.\\�Desea continuar?';
        //       RecreatePurchLinesMsg@1016 :
        RecreatePurchLinesMsg:
// %1: FieldCaption
TextConst ENU = 'if you change %1, the existing purchase lines will be deleted and new purchase lines based on the new information in the header will be created.\\Do you want to continue?', ESP = 'Si cambia %1, se eliminar�n las l�neas de compra actuales y se crear�n nuevas l�neas de compra bas�ndose en la nueva informaci�n de la cabecera.\\�Desea continuar?';
        //       ResetItemChargeAssignMsg@1093 :
        ResetItemChargeAssignMsg:
// %1: FieldCaption
TextConst ENU = 'if you change %1, the existing purchase lines will be deleted and new purchase lines based on the new information in the header will be created.\The amount of the item charge assignment will be reset to 0.\\Do you want to continue?', ESP = 'Si cambia %1, se eliminar�n las l�neas de compra actuales y se crear�n l�neas de compra nuevas basadas en la informaci�n nueva de la cabecera.\El importe de la asignaci�n del cargo del producto se pondr� a 0.\\�Desea continuar?';
        //       Text018@1017 :
        Text018: TextConst ENU = 'You must delete the existing purchase lines before you can change %1.', ESP = 'Se deben eliminar las l�neas de compra existentes antes de cambiar %1.';
        //       LinesNotUpdatedMsg@1018 :
        LinesNotUpdatedMsg:
// You have changed Posting Date on the purchase header, but it has not been changed on the existing purchase lines.
TextConst ENU = 'You have changed %1 on the purchase header, but it has not been changed on the existing purchase lines.', ESP = 'Se ha modificado %1 en la cab. compra, pero no se ha modificado en las l�neas de compra existentes.';
        //       Text020@1019 :
        Text020: TextConst ENU = 'You must update the existing purchase lines manually.', ESP = 'Debe actualizar las l�neas de compra existentes manualmente.';
        //       AffectExchangeRateMsg@1020 :
        AffectExchangeRateMsg: TextConst ENU = 'The change may affect the exchange rate that is used for price calculation on the purchase lines.', ESP = 'El cambio puede afectar al tipo de cambio usado en el c�lculo del precio en las l�neas de compra.';
        //       Text022@1021 :
        Text022: TextConst ENU = 'Do you want to update the exchange rate?', ESP = '�Confirma que desea modificar el tipo de cambio?';
        //       Text023@1022 :
        Text023: TextConst ENU = 'You cannot delete this document. Your identification is set up to process from %1 %2 only.', ESP = 'No puede borrar este documento. Su identificaci�n est� configurada s�lo para procesar %1 %2.';
        //       Text025@1024 :
        Text025: TextConst ENU = 'You have modified the %1 field. Note that the recalculation of VAT may cause penny differences, so you must check the amounts afterwards. ', ESP = 'Ha modificado el campo %1. El nuevo c�lculo de IVA puede tener alguna diferencia, por lo que deber�a comprobar los importes. ';
        //       Text027@1026 :
        Text027: TextConst ENU = 'Do you want to update the %2 field on the lines to reflect the new value of %1?', ESP = '�Confirma que desea actualizar el %2 campo en la l�neas para reflejar el nuevo valor de %1?';
        //       Text028@1027 :
        Text028: TextConst ENU = 'Your identification is set up to process from %1 %2 only.', ESP = 'Su identificaci�n est� configurada para procesar s�lo desde %1 %2.';
        //       Text029@1028 :
        Text029:
// "%1 = Document No."
TextConst ENU = 'Deleting this document will cause a gap in the number series for return shipments. An empty return shipment %1 will be created to fill this gap in the number series.\\Do you want to continue?', ESP = 'Si elimina este documento, se provocar� una discontinuidad en los n�meros de serie de los env�os devoluci�n. Se crear� un env�o devoluci�n en blanco %1 para corregir esta discontinuidad en los n�meros de serie.\\�Desea continuar?';
        //       Text032@1031 :
        Text032:
// You have modified Currency Factor.\\Do you want to update the lines?
TextConst ENU = 'You have modified %1.\\Do you want to update the lines?', ESP = 'Ha modificado %1.\\�Desea actualizar las l�neas?';
        //       PurchSetup@1033 :
        PurchSetup: Record 312;
        //       GLSetup@1034 :
        GLSetup: Record 98;
        //       GLAcc@1035 :
        GLAcc: Record 15;
        //       PurchLine@1036 :
        PurchLine: Record 39;
        //       xPurchLine@1080 :
        xPurchLine: Record 39;
        //       VendLedgEntry@1037 :
        VendLedgEntry: Record 25;
        //       Vend@1038 :
        Vend: Record 23;
        //       PaymentTerms@1039 :
        PaymentTerms: Record 3;
        //       PaymentMethod@1040 :
        PaymentMethod: Record 289;
        //       CurrExchRate@1041 :
        CurrExchRate: Record 330;
        //       PurchHeader@1042 :
        PurchHeader: Record 38;
        //       PurchCommentLine@1043 :
        PurchCommentLine: Record 43;
        //       Cust@1045 :
        Cust: Record 18;
        //       CompanyInfo@1046 :
        CompanyInfo: Record 79;
        //       PostCode@1047 :
        PostCode: Record 225;
        //       OrderAddr@1048 :
        OrderAddr: Record 224;
        //       BankAcc@1049 :
        BankAcc: Record 270;
        //       PurchRcptHeader@1050 :
        PurchRcptHeader: Record 120;
        //       PurchInvHeader@1051 :
        PurchInvHeader: Record 122;
        //       PurchCrMemoHeader@1052 :
        PurchCrMemoHeader: Record 124;
        //       ReturnShptHeader@1053 :
        ReturnShptHeader: Record 6650;
        //       PurchInvHeaderPrepmt@1090 :
        PurchInvHeaderPrepmt: Record 122;
        //       PurchCrMemoHeaderPrepmt@1089 :
        PurchCrMemoHeaderPrepmt: Record 124;
        //       GenBusPostingGrp@1054 :
        GenBusPostingGrp: Record 250;
        //       RespCenter@1056 :
        RespCenter: Record 5714;
        //       Location@1057 :
        Location: Record 14;
        //       WhseRequest@1058 :
        WhseRequest: Record 5765;
        //       InvtSetup@1059 :
        InvtSetup: Record 313;
        //       SalespersonPurchaser@1932 :
        SalespersonPurchaser: Record 13;
        //       NoSeriesMgt@1060 :
        NoSeriesMgt: Codeunit 396;
        //       DimMgt@1065 :
        DimMgt: Codeunit 408;
        //       ApprovalsMgmt@1082 :
        ApprovalsMgmt: Codeunit 1535;
        //       UserSetupMgt@1066 :
        UserSetupMgt: Codeunit 5700;
        //       LeadTimeMgt@1002 :
        LeadTimeMgt: Codeunit 5404;
        //       PostingSetupMgt@1023 :
        PostingSetupMgt: Codeunit 48;
        //       CurrencyDate@1069 :
        CurrencyDate: Date;
        //       HideValidationDialog@1070 :
        HideValidationDialog: Boolean;
        //       Confirmed@1071 :
        Confirmed: Boolean;
        //       Text034@1072 :
        Text034: TextConst ENU = 'You cannot change the %1 when the %2 has been filled in.', ESP = 'No puede cambiar %1 despu�s de introducir datos en %2.';
        //       Text037@1076 :
        Text037: TextConst ENU = 'Contact %1 %2 is not related to vendor %3.', ESP = 'Contacto %1 %2 no est� relacionado con proveedor %3.';
        //       Text038@1075 :
        Text038: TextConst ENU = 'Contact %1 %2 is related to a different company than vendor %3.', ESP = 'Contacto %1 %2 est� relacionado con una empresa diferente al proveedor %3.';
        //       Text039@1077 :
        Text039: TextConst ENU = 'Contact %1 %2 is not related to a vendor.', ESP = 'Contacto %1 %2 no est� relacionado con un proveedor.';
        //       SkipBuyFromContact@1030 :
        SkipBuyFromContact: Boolean;
        //       SkipPayToContact@1078 :
        SkipPayToContact: Boolean;
        //       Text040@1079 :
        Text040: TextConst ENU = 'You can not change the %1 field because %2 %3 has %4 = %5 and the %6 has already been assigned %7 %8.', ESP = 'No puede cambiar el campo %1 porque %2 %3 tiene %4 = %5 y ya se ha asignado el %6 a %7 %8.';
        //       Text042@1084 :
        Text042: TextConst ENU = 'You must cancel the approval process if you wish to change the %1.', ESP = 'Debe cancelar el proceso de aprobaci�n si desea cambiar el %1.';
        //       Text045@1086 :
        Text045: TextConst ENU = 'Deleting this document will cause a gap in the number series for prepayment invoices. An empty prepayment invoice %1 will be created to fill this gap in the number series.\\Do you want to continue?', ESP = 'Si elimina el documento, se provocar� una discontinuidad en la numeraci�n de la serie de facturas de prepago. Se crear� una factura prepago en blanco %1 para completar este error en las series num�ricas.\\�Desea continuar?';
        //       Text046@1087 :
        Text046: TextConst ENU = 'Deleting this document will cause a gap in the number series for prepayment credit memos. An empty prepayment credit memo %1 will be created to fill this gap in the number series.\\Do you want to continue?', ESP = 'Si elimina el documento, se provocar� una discontinuidad en la numeraci�n de la serie de abonos de prepago. Se crear� un abono prepago en blanco %1 para completar este error en las series num�ricas.\\�Desea continuar?';
        //       Text049@1092 :
        Text049: TextConst ENU = '%1 is set up to process from %2 %3 only.', ESP = 'Se ha configurado %1 para procesar s�lo desde %2 %3.';
        //       Text050@1067 :
        Text050: TextConst ENU = 'Reservations exist for this order. These reservations will be canceled if a date conflict is caused by this change.\\Do you want to continue?', ESP = 'Existen reservas para este pedido. Dichas reservas se cancelar�n si este cambio provoca un conflicto de fechas.\\�Desea continuar?';
        //       Text051@1025 :
        Text051: TextConst ENU = 'You may have changed a dimension.\\Do you want to update the lines?', ESP = 'Puede que haya cambiado una dimensi�n.\\�Desea actualizar las l�neas?';
        //       Text052@1091 :
        Text052: TextConst ENU = 'The %1 field on the purchase order %2 must be the same as on sales order %3.', ESP = 'El campo %1 del pedido de compra %2 debe ser igual al del pedido de venta %3.';
        //       UpdateDocumentDate@1120 :
        UpdateDocumentDate: Boolean;
        //       PrepaymentInvoicesNotPaidErr@1074 :
        PrepaymentInvoicesNotPaidErr:
// You cannot post the document of type Order with the number 1001 before all related prepayment invoices are posted.
TextConst ENU = 'You cannot post the document of type %1 with the number %2 before all related prepayment invoices are posted.', ESP = 'No puede registrar el documento de tipo %1 con el n�mero %2 antes de que se registren todas las facturas de prepago relacionadas.';
        //       Text054@1096 :
        Text054: TextConst ENU = 'There are unpaid prepayment invoices that are related to the document of type %1 with the number %2.', ESP = 'Hay facturas prepago sin pagar relacionadas con el documento de tipo %1 con el n�mero %2.';
        //       AdjustDueDate@1100012 :
        AdjustDueDate: Codeunit 10700;
        //       Text1100000@1100009 :
        Text1100000: TextConst ENU = 'It exists a Posted Purchase Receipt %1 %2 with %3 set to %4', ESP = 'Existe albar�n compra registrado %1 %2 con %3 definido como %4';
        //       Text10700@1100000 :
        Text10700: TextConst ENU = '%1 cannot be different from 0 when %2 is %3', ESP = '%1 no puede ser diferente de 0 cuando %2 es %3';
        //       DeferralLineQst@1055 :
        DeferralLineQst:
// "%1=The posting date on the document."
TextConst ENU = 'You have changed the %1 on the purchase header, do you want to update the deferral schedules for the lines with this date?', ESP = 'Ha cambiado %1 en el encabezado de compra. �Desea actualizar las previsiones de fraccionamiento para las l�neas con esta fecha?';
        //       PostedDocsToPrintCreatedMsg@1083 :
        PostedDocsToPrintCreatedMsg: TextConst ENU = 'One or more related posted documents have been generated during deletion to fill gaps in the posting number series. You can view or print the documents from the respective document archive.', ESP = 'Durante la eliminaci�n, se han generado uno o m�s documentos registrados relacionados en sustituci�n de los n�meros de registro que faltan de la serie. Puede ver o imprimir los documentos del archivo de documentos correspondiente.';
        //       BuyFromVendorTxt@1010 :
        BuyFromVendorTxt: TextConst ENU = 'Buy-from Vendor', ESP = 'Proveedor de compra';
        //       PayToVendorTxt@1011 :
        PayToVendorTxt: TextConst ENU = 'Pay-to Vendor', ESP = 'Proveedor de pago';
        //       DocumentNotPostedClosePageQst@1013 :
        DocumentNotPostedClosePageQst: TextConst ENU = 'The document has not been posted.\Are you sure you want to exit?', ESP = 'El documento no se registr�.\�Est� seguro de que desea salir?';
        //       PurchOrderDocTxt@1000 :
        PurchOrderDocTxt: TextConst ENU = 'Purchase Order', ESP = 'Pedido compra';
        //       SelectNoSeriesAllowed@1015 :
        SelectNoSeriesAllowed: Boolean;
        //       PurchQuoteDocTxt@1088 :
        PurchQuoteDocTxt: TextConst ENU = 'Purchase Quote', ESP = 'Oferta de compra';
        //       MixedDropshipmentErr@1001 :
        MixedDropshipmentErr: TextConst ENU = 'You cannot print the purchase order because it contains one or more lines for drop shipment in addition to regular purchase lines.', ESP = 'No puede imprimir el pedido de compra porque contiene una o m�s l�neas de env�o adem�s de las l�neas de compra normales.';
        //       ModifyVendorAddressNotificationLbl@1062 :
        ModifyVendorAddressNotificationLbl: TextConst ENU = 'Update the address', ESP = 'Actualizar la direcci�n';
        //       DontShowAgainActionLbl@1064 :
        DontShowAgainActionLbl: TextConst ENU = 'Don''t show again', ESP = 'No volver a mostrar';
        //       ModifyVendorAddressNotificationMsg@1063 :
        ModifyVendorAddressNotificationMsg:
// "%1=Vendor name"
TextConst ENU = 'The address you entered for %1 is different from the Vendor''s existing address.', ESP = 'La direcci�n indicada para %1 es distinta de la direcci�n existente del proveedor.';
        //       ModifyBuyFromVendorAddressNotificationNameTxt@1106 :
        ModifyBuyFromVendorAddressNotificationNameTxt: TextConst ENU = 'Update Buy-from Vendor Address', ESP = 'Actualizar direcci�n del proveedor de compra';
        //       ModifyBuyFromVendorAddressNotificationDescriptionTxt@1098 :
        ModifyBuyFromVendorAddressNotificationDescriptionTxt: TextConst ENU = 'Warn if the Buy-from address on sales documents is different from the Vendor''s existing address.', ESP = 'Permite advertir si la direcci�n de compra de los documentos de venta es distinta de la direcci�n existente del proveedor.';
        //       ModifyPayToVendorAddressNotificationNameTxt@1102 :
        ModifyPayToVendorAddressNotificationNameTxt: TextConst ENU = 'Update Pay-to Vendor Address', ESP = 'Actualizar direcci�n del proveedor de pago';
        //       ModifyPayToVendorAddressNotificationDescriptionTxt@1099 :
        ModifyPayToVendorAddressNotificationDescriptionTxt: TextConst ENU = 'Warn if the Pay-to address on sales documents is different from the Vendor''s existing address.', ESP = 'Permite advertir si la direcci�n de pago de los documentos de venta es distinta de la direcci�n existente del proveedor.';
        //       PurchaseAlreadyExistsTxt@1029 :
        PurchaseAlreadyExistsTxt:
// "%1 = Document Type; %2 = Document No."
TextConst ENU = 'Purchase %1 %2 already exists for this vendor.', ESP = 'Ya existe la compra %1 %2 para este proveedor.';
        //       ShowVendLedgEntryTxt@1044 :
        ShowVendLedgEntryTxt: TextConst ENU = 'Show the vendor ledger entry.', ESP = 'Muestra el movimiento contable de proveedor.';
        //       ShowDocAlreadyExistNotificationNameTxt@1068 :
        ShowDocAlreadyExistNotificationNameTxt: TextConst ENU = 'Purchase document with same external document number already exists.', ESP = 'Ya existe un documento de compra con el mismo n�mero de documento externo.';
        //       ShowDocAlreadyExistNotificationDescriptionTxt@1061 :
        ShowDocAlreadyExistNotificationDescriptionTxt: TextConst ENU = 'Warn if purchase document with same external document number already exists.', ESP = 'Advierte si ya existe un documento de compra con el mismo n�mero de documento externo.';
        //       DuplicatedCaptionsNotAllowedErr@1081 :
        DuplicatedCaptionsNotAllowedErr: TextConst ENU = 'Field captions must not be duplicated when using this method. Use UpdatePurchLinesByFieldNo instead.', ESP = 'No se deben duplicar t�tulos de campo cuando se utiliza este m�todo. Use UpdatePurchLinesByFieldNo en su lugar.';
        //       MissingExchangeRatesQst@1032 :
        MissingExchangeRatesQst:
// %1 - currency code, %2 - posting date
TextConst ENU = 'There are no exchange rates for currency %1 and date %2. Do you want to add them now? Otherwise, the last change you made will be reverted.', ESP = 'No hay tipos de cambio para la divisa %1 y la fecha %2. �Desea agregarlos ahora? De lo contrario, se revertir� el �ltimo cambio que hizo.';
        //       SplitMessageTxt@1085 :
        SplitMessageTxt:
// Some message text 1.\Some message text 2.
TextConst ENU = '%1\%2', ESP = '%1\%2';
        //       "------------------------------ QB"@1100286000 :
        "------------------------------ QB": Integer;
        //       FunctionQB@1100286001 :
        FunctionQB: Codeunit 7207272;
        //       QuoBuildingSetup@1100286005 :
        QuoBuildingSetup: Record 7207278;
        //       QBPaymentPhasesandDueDate@1100286003 :
        QBPaymentPhasesandDueDate: Codeunit 7207336;
        //       MsgLines@1100286004 :
        MsgLines: Text;
        //       Ok@1100286002 :
        Ok: Boolean;





    /*
    trigger OnInsert();    var
    //                StandardCodesMgt@1000 :
                   StandardCodesMgt: Codeunit 170;
                 begin
                   InitInsert;

                   if GETFILTER("Buy-from Vendor No.") <> '' then
                     if GETRANGEMIN("Buy-from Vendor No.") = GETRANGEMAX("Buy-from Vendor No.") then
                       VALIDATE("Buy-from Vendor No.",GETRANGEMIN("Buy-from Vendor No."));

                   if "Purchaser Code" = '' then
                     SetDefaultPurchaser;

                   if "Buy-from Vendor No." <> '' then
                     StandardCodesMgt.CheckShowPurchRecurringLinesNotification(Rec);
                 end;


    */

    /*
    trigger OnDelete();    var
    //                PostPurchDelete@1000 :
                   PostPurchDelete: Codeunit 364;
    //                ArchiveManagement@1001 :
                   ArchiveManagement: Codeunit 5063;
                 begin
                   if not UserSetupMgt.CheckRespCenter(1,"Responsibility Center") then
                     ERROR(
                       Text023,
                       RespCenter.TABLECAPTION,UserSetupMgt.GetPurchasesFilter);

                   ArchiveManagement.AutoArchivePurchDocument(Rec);
                   PostPurchDelete.DeleteHeader(
                     Rec,PurchRcptHeader,PurchInvHeader,PurchCrMemoHeader,
                     ReturnShptHeader,PurchInvHeaderPrepmt,PurchCrMemoHeaderPrepmt);
                   VALIDATE("Applies-to ID",'');
                   VALIDATE("Incoming Document Entry No.",0);

                   ApprovalsMgmt.OnDeleteRecordInApprovalRequest(RECORDID);
                   PurchLine.LOCKTABLE;

                   WhseRequest.SETRANGE("Source Type",DATABASE::"Purchase Line");
                   WhseRequest.SETRANGE("Source Subtype","Document Type");
                   WhseRequest.SETRANGE("Source No.","No.");
                   WhseRequest.DELETEALL(TRUE);

                   PurchLine.SETRANGE("Document Type","Document Type");
                   PurchLine.SETRANGE("Document No.","No.");
                   PurchLine.SETRANGE(Type,PurchLine.Type::"Charge (Item)");
                   DeletePurchaseLines;
                   PurchLine.SETRANGE(Type);
                   DeletePurchaseLines;

                   PurchCommentLine.SETRANGE("Document Type","Document Type");
                   PurchCommentLine.SETRANGE("No.","No.");
                   PurchCommentLine.DELETEALL;

                   if (PurchRcptHeader."No." <> '') or
                      (PurchInvHeader."No." <> '') or
                      (PurchCrMemoHeader."No." <> '') or
                      (ReturnShptHeader."No." <> '') or
                      (PurchInvHeaderPrepmt."No." <> '') or
                      (PurchCrMemoHeaderPrepmt."No." <> '')
                   then
                     MESSAGE(PostedDocsToPrintCreatedMsg);
                 end;


    */

    /*
    trigger OnRename();    begin
                   ERROR(Text003,TABLECAPTION);
                 end;

    */




    /*
    procedure InitInsert ()
        begin
          if "No." = '' then begin
            TestNoSeries;
            NoSeriesMgt.InitSeries(GetNoSeriesCode,xRec."No. Series","Posting Date","No.","No. Series");
          end;

          InitRecord;
        end;
    */



    //     procedure InitRecord ()
    //     var
    // //       ArchiveManagement@1000 :
    //       ArchiveManagement: Codeunit 5063;
    // //       SIIManagement@1100000 :
    //       SIIManagement: Codeunit 10756;
    //     begin
    //       PurchSetup.GET;

    //       CASE "Document Type" OF
    //         "Document Type"::Quote,"Document Type"::Order:
    //           begin
    //             NoSeriesMgt.SetDefaultSeries("Posting No. Series",PurchSetup."Posted Invoice Nos.");
    //             NoSeriesMgt.SetDefaultSeries("Receiving No. Series",PurchSetup."Posted Receipt Nos.");
    //             if "Document Type" = "Document Type"::Order then begin
    //               NoSeriesMgt.SetDefaultSeries("Prepayment No. Series",PurchSetup."Posted Prepmt. Inv. Nos.");
    //               NoSeriesMgt.SetDefaultSeries("Prepmt. Cr. Memo No. Series",PurchSetup."Posted Prepmt. Cr. Memo Nos.");
    //             end;
    //           end;
    //         "Document Type"::Invoice:
    //           begin
    //             if ("No. Series" <> '') and
    //                (PurchSetup."Invoice Nos." = PurchSetup."Posted Invoice Nos.")
    //             then
    //               "Posting No. Series" := "No. Series"
    //             else
    //               NoSeriesMgt.SetDefaultSeries("Posting No. Series",PurchSetup."Posted Invoice Nos.");
    //             if PurchSetup."Receipt on Invoice" then
    //               NoSeriesMgt.SetDefaultSeries("Receiving No. Series",PurchSetup."Posted Receipt Nos.");
    //           end;
    //         "Document Type"::"Return Order":
    //           begin
    //             NoSeriesMgt.SetDefaultSeries("Posting No. Series",PurchSetup."Posted Credit Memo Nos.");
    //             NoSeriesMgt.SetDefaultSeries("Return Shipment No. Series",PurchSetup."Posted Return Shpt. Nos.");
    //           end;
    //         "Document Type"::"Credit Memo":
    //           begin
    //             if ("No. Series" <> '') and
    //                (PurchSetup."Credit Memo Nos." = PurchSetup."Posted Credit Memo Nos.")
    //             then
    //               "Posting No. Series" := "No. Series"
    //             else
    //               NoSeriesMgt.SetDefaultSeries("Posting No. Series",PurchSetup."Posted Credit Memo Nos.");
    //             if PurchSetup."Return Shipment on Credit Memo" then
    //               NoSeriesMgt.SetDefaultSeries("Return Shipment No. Series",PurchSetup."Posted Return Shpt. Nos.");
    //           end;
    //       end;

    //       if "Document Type" = "Document Type"::Invoice then
    //         "Expected Receipt Date" := WORKDATE;

    //       if not ("Document Type" IN ["Document Type"::"Blanket Order","Document Type"::Quote]) and
    //          ("Posting Date" = 0D)
    //       then
    //         "Posting Date" := WORKDATE;

    //       if PurchSetup."Default Posting Date" = PurchSetup."Default Posting Date"::"No Date" then
    //         "Posting Date" := 0D;

    //       "Order Date" := WORKDATE;
    //       "Document Date" := WORKDATE;

    //       ValidateEmptySellToCustomerAndLocation;

    //       if IsCreditDocType then begin
    //         GLSetup.GET;
    //         Correction := GLSetup."Mark Cr. Memos as Corrections";
    //       end;

    //       "Posting Description" := FORMAT("Document Type") + ' ' + "No.";

    //       UpdateInboundWhseHandlingTime;

    //       "Responsibility Center" := UserSetupMgt.GetRespCenter(1,"Responsibility Center");
    //       "Doc. No. Occurrence" := ArchiveManagement.GetNextOccurrenceNo(DATABASE::"Purchase Header","Document Type","No.");
    //       SIIManagement.UpdateSIIInfoInPurchDoc(Rec);
    //       InitSii;

    //       OnAfterInitRecord(Rec);
    //     end;


    /*
    LOCAL procedure InitNoSeries ()
        begin
          if xRec."Receiving No." <> '' then begin
            "Receiving No. Series" := xRec."Receiving No. Series";
            "Receiving No." := xRec."Receiving No.";
          end;
          if xRec."Posting No." <> '' then begin
            "Posting No. Series" := xRec."Posting No. Series";
            "Posting No." := xRec."Posting No.";
          end;
          if xRec."Return Shipment No." <> '' then begin
            "Return Shipment No. Series" := xRec."Return Shipment No. Series";
            "Return Shipment No." := xRec."Return Shipment No.";
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



    /*
    LOCAL procedure InitSii ()
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
            if "Buy-from Vendor No." <> '' then
              if Vend.GET("Buy-from Vendor No.") then
                if Vend."No." <> '' then
                  if SIIManagement.VendorIsIntraCommunity(Vend."No.") then
                    "Special Scheme Code" := "Special Scheme Code"::"09 Intra-Community Acquisition"
                  else
                    "Special Scheme Code" := "Special Scheme Code"::"01 General";
        end;
    */



    //     procedure AssistEdit (OldPurchHeader@1000 :

    /*
    procedure AssistEdit (OldPurchHeader: Record 38) : Boolean;
        begin
          PurchSetup.GET;
          TestNoSeries;
          if NoSeriesMgt.SelectSeries(GetNoSeriesCode,OldPurchHeader."No. Series","No. Series") then begin
            PurchSetup.GET;
            TestNoSeries;
            NoSeriesMgt.SetSeries("No.");
            exit(TRUE);
          end;
        end;
    */




    /*
    procedure TestNoSeries ()
        begin
          PurchSetup.GET;
          CASE "Document Type" OF
            "Document Type"::Quote:
              PurchSetup.TESTFIELD("Quote Nos.");
            "Document Type"::Order:
              PurchSetup.TESTFIELD("Order Nos.");
            "Document Type"::Invoice:
              begin
                PurchSetup.TESTFIELD("Invoice Nos.");
                PurchSetup.TESTFIELD("Posted Invoice Nos.");
              end;
            "Document Type"::"Return Order":
              PurchSetup.TESTFIELD("Return Order Nos.");
            "Document Type"::"Credit Memo":
              begin
                PurchSetup.TESTFIELD("Credit Memo Nos.");
                PurchSetup.TESTFIELD("Posted Credit Memo Nos.");
              end;
            "Document Type"::"Blanket Order":
              PurchSetup.TESTFIELD("Blanket Order Nos.");
          end;

          OnAfterTestNoSeries(Rec);
        end;
    */




    /*
    procedure GetNoSeriesCode () : Code[20];
        var
    //       NoSeriesCode@1001 :
          NoSeriesCode: Code[20];
        begin
          CASE "Document Type" OF
            "Document Type"::Quote:
              NoSeriesCode := PurchSetup."Quote Nos.";
            "Document Type"::Order:
              NoSeriesCode := PurchSetup."Order Nos.";
            "Document Type"::Invoice:
              NoSeriesCode := PurchSetup."Invoice Nos.";
            "Document Type"::"Return Order":
              NoSeriesCode := PurchSetup."Return Order Nos.";
            "Document Type"::"Credit Memo":
              NoSeriesCode := PurchSetup."Credit Memo Nos.";
            "Document Type"::"Blanket Order":
              NoSeriesCode := PurchSetup."Blanket Order Nos.";
          end;
          OnAfterGetNoSeriesCode(Rec,PurchSetup,NoSeriesCode);
          exit(NoSeriesMgt.GetNoSeriesWithCheck(NoSeriesCode,SelectNoSeriesAllowed,"No. Series"));
        end;
    */



    /*
    LOCAL procedure GetPostingNoSeriesCode () PostingNos : Code[20];
        begin
          if IsCreditDocType then
            PostingNos := PurchSetup."Posted Credit Memo Nos."
          else
            PostingNos := PurchSetup."Posted Invoice Nos.";

          OnAfterGetPostingNoSeriesCode(Rec,PostingNos);
        end;
    */



    /*
    LOCAL procedure GetPostingPrepaymentNoSeriesCode () PostingNos : Code[20];
        begin
          if IsCreditDocType then
            PostingNos := PurchSetup."Posted Prepmt. Cr. Memo Nos."
          else
            PostingNos := PurchSetup."Posted Prepmt. Inv. Nos.";

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
                Text040,
                FIELDCAPTION("Posting Date"),NoSeriesCapt,NoSeriesCode,
                NoSeries.FIELDCAPTION("Date Order"),NoSeries."Date Order","Document Type",
                NoCapt,No);
          end;
        end;
    */




    /*
    procedure ConfirmDeletion () : Boolean;
        var
    //       SourceCode@1001 :
          SourceCode: Record 230;
    //       SourceCodeSetup@1000 :
          SourceCodeSetup: Record 242;
    //       PostPurchDelete@1002 :
          PostPurchDelete: Codeunit 364;
    //       ConfirmManagement@1003 :
          ConfirmManagement: Codeunit 27;
        begin
          SourceCodeSetup.GET;
          SourceCodeSetup.TESTFIELD("Deleted Document");
          SourceCode.GET(SourceCodeSetup."Deleted Document");

          PostPurchDelete.InitDeleteHeader(
            Rec,PurchRcptHeader,PurchInvHeader,PurchCrMemoHeader,
            ReturnShptHeader,PurchInvHeaderPrepmt,PurchCrMemoHeaderPrepmt,SourceCode.Code);

          if PurchRcptHeader."No." <> '' then
            if not ConfirmManagement.ConfirmProcess(STRSUBSTNO(Text009,PurchRcptHeader."No."),TRUE) then
              exit;
          if PurchInvHeader."No." <> '' then
            if not ConfirmManagement.ConfirmProcess(STRSUBSTNO(Text012,PurchInvHeader."No."),TRUE) then
              exit;
          if PurchCrMemoHeader."No." <> '' then
            if not ConfirmManagement.ConfirmProcess(STRSUBSTNO(Text014,PurchCrMemoHeader."No."),TRUE) then
              exit;
          if ReturnShptHeader."No." <> '' then
            if not ConfirmManagement.ConfirmProcess(STRSUBSTNO(Text029,ReturnShptHeader."No."),TRUE) then
              exit;
          if "Prepayment No." <> '' then
            if not ConfirmManagement.ConfirmProcess(STRSUBSTNO(Text045,PurchInvHeaderPrepmt."No."),TRUE) then
              exit;
          if "Prepmt. Cr. Memo No." <> '' then
            if not ConfirmManagement.ConfirmProcess(STRSUBSTNO(Text046,PurchCrMemoHeaderPrepmt."No."),TRUE) then
              exit;
          exit(TRUE);
        end;
    */


    //     LOCAL procedure GetVend (VendNo@1000 :

    /*
    LOCAL procedure GetVend (VendNo: Code[20])
        begin
          if VendNo <> Vend."No." then
            Vend.GET(VendNo);
        end;
    */




    /*
    procedure PurchLinesExist () : Boolean;
        begin
          PurchLine.RESET;
          PurchLine.SETRANGE("Document Type","Document Type");
          PurchLine.SETRANGE("Document No.","No.");
          exit(PurchLine.FINDFIRST);
        end;
    */


    //     LOCAL procedure RecreatePurchLines (ChangedFieldName@1000 :

    /*
    LOCAL procedure RecreatePurchLines (ChangedFieldName: Text[100])
        var
    //       TempPurchLine@1001 :
          TempPurchLine: Record 39 TEMPORARY;
    //       ItemChargeAssgntPurch@1005 :
          ItemChargeAssgntPurch: Record 5805;
    //       TempItemChargeAssgntPurch@1004 :
          TempItemChargeAssgntPurch: Record 5805 TEMPORARY;
    //       TempInteger@1003 :
          TempInteger: Record 2000000026 TEMPORARY;
    //       SalesHeader@1006 :
          SalesHeader: Record 36;
    //       TransferExtendedText@1009 :
          TransferExtendedText: Codeunit 378;
    //       ConfirmManagement@1008 :
          ConfirmManagement: Codeunit 27;
    //       ExtendedTextAdded@1002 :
          ExtendedTextAdded: Boolean;
    //       ConfirmText@1007 :
          ConfirmText: Text;
    //       IsHandled@1010 :
          IsHandled: Boolean;
        begin
          if not PurchLinesExist then
            exit;

          IsHandled := FALSE;
          OnRecreatePurchLinesOnBeforeConfirm(Rec,xRec,ChangedFieldName,HideValidationDialog,Confirmed,IsHandled);
          if not IsHandled then
            if GetHideValidationDialog then
              Confirmed := TRUE
            else begin
              if HasItemChargeAssignment then
                ConfirmText := ResetItemChargeAssignMsg
              else
                ConfirmText := RecreatePurchLinesMsg;
              Confirmed := ConfirmManagement.ConfirmProcess(STRSUBSTNO(ConfirmText,ChangedFieldName),TRUE);
            end;

          if Confirmed then begin
            PurchLine.LOCKTABLE;
            ItemChargeAssgntPurch.LOCKTABLE;
            MODIFY;
            OnBeforeRecreatePurchLines(Rec);

            PurchLine.RESET;
            PurchLine.SETRANGE("Document Type","Document Type");
            PurchLine.SETRANGE("Document No.","No.");
            if PurchLine.FINDSET then begin
              repeat
                PurchLine.TESTFIELD("Quantity Received",0);
                PurchLine.TESTFIELD("Quantity Invoiced",0);
                PurchLine.TESTFIELD("Return Qty. Shipped",0);
                PurchLine.CALCFIELDS("Reserved Qty. (Base)");
                PurchLine.TESTFIELD("Reserved Qty. (Base)",0);
                PurchLine.TESTFIELD("Receipt No.",'');
                PurchLine.TESTFIELD("Return Shipment No.",'');
                PurchLine.TESTFIELD("Blanket Order No.",'');
                if PurchLine."Drop Shipment" or PurchLine."Special Order" then begin
                  CASE TRUE OF
                    PurchLine."Drop Shipment":
                      SalesHeader.GET(SalesHeader."Document Type"::Order,PurchLine."Sales Order No.");
                    PurchLine."Special Order":
                      SalesHeader.GET(SalesHeader."Document Type"::Order,PurchLine."Special Order Sales No.");
                  end;
                  TESTFIELD("Sell-to Customer No.",SalesHeader."Sell-to Customer No.");
                  TESTFIELD("Ship-to Code",SalesHeader."Ship-to Code");
                end;

                PurchLine.TESTFIELD("Prepmt. Amt. Inv.",0);
                TempPurchLine := PurchLine;
                if PurchLine.Nonstock then begin
                  PurchLine.Nonstock := FALSE;
                  PurchLine.MODIFY;
                end;
                OnRecreatePurchLinesOnBeforeTempPurchLineInsert(TempPurchLine,PurchLine);
                TempPurchLine.INSERT;
              until PurchLine.NEXT = 0;

              TransferItemChargeAssgntPurchToTemp(ItemChargeAssgntPurch,TempItemChargeAssgntPurch);

              PurchLine.DELETEALL(TRUE);

              PurchLine.INIT;
              PurchLine."Line No." := 0;
              TempPurchLine.FINDSET;
              ExtendedTextAdded := FALSE;
              repeat
                if TempPurchLine."Attached to Line No." = 0 then begin
                  PurchLine.INIT;
                  PurchLine."Line No." := PurchLine."Line No." + 10000;
                  PurchLine.VALIDATE(Type,TempPurchLine.Type);
                  OnRecreatePurchLinesOnAfterValidateType(PurchLine,TempPurchLine);
                  if TempPurchLine."No." = '' then begin
                    PurchLine.VALIDATE(Description,TempPurchLine.Description);
                    PurchLine.VALIDATE("Description 2",TempPurchLine."Description 2");
                  end else begin
                    PurchLine.VALIDATE("No.",TempPurchLine."No.");
                    if PurchLine.Type <> PurchLine.Type::" " then
                      CASE TRUE OF
                        TempPurchLine."Drop Shipment":
                          TransferSavedFieldsDropShipment(PurchLine,TempPurchLine);
                        TempPurchLine."Special Order":
                          TransferSavedFieldsSpecialOrder(PurchLine,TempPurchLine);
                        else
                          TransferSavedFields(PurchLine,TempPurchLine);
                      end;
                  end;

                  OnRecreatePurchLinesOnBeforeInsertPurchLine(PurchLine,TempPurchLine);
                  PurchLine.INSERT;
                  ExtendedTextAdded := FALSE;

                  OnAfterRecreatePurchLine(PurchLine,TempPurchLine);

                  if PurchLine.Type = PurchLine.Type::Item then
                    RecreatePurchLinesFillItemChargeAssignment(PurchLine,TempPurchLine,TempItemChargeAssgntPurch);

                  if PurchLine.Type = PurchLine.Type::"Charge (Item)" then begin
                    TempInteger.INIT;
                    TempInteger.Number := PurchLine."Line No.";
                    TempInteger.INSERT;
                  end;
                end else
                  if not ExtendedTextAdded then begin
                    TransferExtendedText.PurchCheckIfAnyExtText(PurchLine,TRUE);
                    TransferExtendedText.InsertPurchExtText(PurchLine);
                    OnAfterTransferExtendedTextForPurchaseLineRecreation(PurchLine);
                    PurchLine.FINDLAST;
                    ExtendedTextAdded := TRUE;
                  end;
              until TempPurchLine.NEXT = 0;

              RecreateItemChargeAssgntPurch(TempItemChargeAssgntPurch,TempPurchLine,TempInteger);

              TempPurchLine.SETRANGE(Type);
              TempPurchLine.DELETEALL;
              OnAfterDeleteAllTempPurchLines;
            end;
          end else
            ERROR(
              Text018,ChangedFieldName);
        end;
    */


    //     LOCAL procedure RecreatePurchLinesFillItemChargeAssignment (PurchLine@1000 : Record 39;var TempPurchLine@1001 : TEMPORARY Record 39;var TempItemChargeAssgntPurch@1002 :

    /*
    LOCAL procedure RecreatePurchLinesFillItemChargeAssignment (PurchLine: Record 39;var TempPurchLine: Record 39 TEMPORARY;var TempItemChargeAssgntPurch: Record 5805 TEMPORARY)
        begin
          ClearItemAssgntPurchFilter(TempItemChargeAssgntPurch);
          TempItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Type",TempPurchLine."Document Type");
          TempItemChargeAssgntPurch.SETRANGE("Applies-to Doc. No.",TempPurchLine."Document No.");
          TempItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Line No.",TempPurchLine."Line No.");
          if TempItemChargeAssgntPurch.FINDSET then
            repeat
              if not TempItemChargeAssgntPurch.MARK then begin
                TempItemChargeAssgntPurch."Applies-to Doc. Line No." := PurchLine."Line No.";
                TempItemChargeAssgntPurch.Description := PurchLine.Description;
                TempItemChargeAssgntPurch.MODIFY;
                TempItemChargeAssgntPurch.MARK(TRUE);
              end;
            until TempItemChargeAssgntPurch.NEXT = 0;
        end;
    */


    //     LOCAL procedure RecreateItemChargeAssgntPurch (var TempItemChargeAssgntPurch@1001 : TEMPORARY Record 5805;var TempPurchLine@1000 : TEMPORARY Record 39;var TempInteger@1002 :

    /*
    LOCAL procedure RecreateItemChargeAssgntPurch (var TempItemChargeAssgntPurch: Record 5805 TEMPORARY;var TempPurchLine: Record 39 TEMPORARY;var TempInteger: Record 2000000026 TEMPORARY)
        var
    //       ItemChargeAssgntPurch@1003 :
          ItemChargeAssgntPurch: Record 5805;
        begin
          ClearItemAssgntPurchFilter(TempItemChargeAssgntPurch);
          TempPurchLine.SETRANGE(Type,TempPurchLine.Type::"Charge (Item)");
          if TempPurchLine.FINDSET then
            repeat
              TempItemChargeAssgntPurch.SETRANGE("Document Line No.",TempPurchLine."Line No.");
              if TempItemChargeAssgntPurch.FINDSET then begin
                repeat
                  TempInteger.FINDFIRST;
                  ItemChargeAssgntPurch.INIT;
                  ItemChargeAssgntPurch := TempItemChargeAssgntPurch;
                  ItemChargeAssgntPurch."Document Line No." := TempInteger.Number;
                  ItemChargeAssgntPurch.VALIDATE("Unit Cost",0);
                  ItemChargeAssgntPurch.INSERT;
                until TempItemChargeAssgntPurch.NEXT = 0;
                TempInteger.DELETE;
              end;
            until TempPurchLine.NEXT = 0;

          ClearItemAssgntPurchFilter(TempItemChargeAssgntPurch);
          TempItemChargeAssgntPurch.DELETEALL;
        end;
    */


    //     LOCAL procedure TransferSavedFields (var DestinationPurchaseLine@1000 : Record 39;var SourcePurchaseLine@1001 :

    /*
    LOCAL procedure TransferSavedFields (var DestinationPurchaseLine: Record 39;var SourcePurchaseLine: Record 39)
        begin
          DestinationPurchaseLine.VALIDATE("Unit of Measure Code",SourcePurchaseLine."Unit of Measure Code");
          DestinationPurchaseLine.VALIDATE("Variant Code",SourcePurchaseLine."Variant Code");
          DestinationPurchaseLine."Prod. Order No." := SourcePurchaseLine."Prod. Order No.";
          if DestinationPurchaseLine."Prod. Order No." <> '' then begin
            DestinationPurchaseLine.Description := SourcePurchaseLine.Description;
            DestinationPurchaseLine.VALIDATE("VAT Prod. Posting Group",SourcePurchaseLine."VAT Prod. Posting Group");
            DestinationPurchaseLine.VALIDATE("Gen. Prod. Posting Group",SourcePurchaseLine."Gen. Prod. Posting Group");
            DestinationPurchaseLine.VALIDATE("Expected Receipt Date",SourcePurchaseLine."Expected Receipt Date");
            DestinationPurchaseLine.VALIDATE("Requested Receipt Date",SourcePurchaseLine."Requested Receipt Date");
            DestinationPurchaseLine.VALIDATE("Qty. per Unit of Measure",SourcePurchaseLine."Qty. per Unit of Measure");
          end;
          if (SourcePurchaseLine."Job No." <> '') and (SourcePurchaseLine."Job Task No." <> '') then begin
            DestinationPurchaseLine.VALIDATE("Job No.",SourcePurchaseLine."Job No.");
            DestinationPurchaseLine.VALIDATE("Job Task No.",SourcePurchaseLine."Job Task No.");
            DestinationPurchaseLine."Job Line Type" := SourcePurchaseLine."Job Line Type";
          end;
          if SourcePurchaseLine.Quantity <> 0 then
            DestinationPurchaseLine.VALIDATE(Quantity,SourcePurchaseLine.Quantity);
          if ("Currency Code" = xRec."Currency Code") and (PurchLine."Direct Unit Cost" = 0) then
            DestinationPurchaseLine.VALIDATE("Direct Unit Cost",SourcePurchaseLine."Direct Unit Cost");
          DestinationPurchaseLine."Routing No." := SourcePurchaseLine."Routing No.";
          DestinationPurchaseLine."Routing Reference No." := SourcePurchaseLine."Routing Reference No.";
          DestinationPurchaseLine."Operation No." := SourcePurchaseLine."Operation No.";
          DestinationPurchaseLine."Work Center No." := SourcePurchaseLine."Work Center No.";
          DestinationPurchaseLine."Prod. Order Line No." := SourcePurchaseLine."Prod. Order Line No.";
          DestinationPurchaseLine."Overhead Rate" := SourcePurchaseLine."Overhead Rate";
        end;
    */


    //     LOCAL procedure TransferSavedFieldsDropShipment (var DestinationPurchaseLine@1001 : Record 39;var SourcePurchaseLine@1000 :

    /*
    LOCAL procedure TransferSavedFieldsDropShipment (var DestinationPurchaseLine: Record 39;var SourcePurchaseLine: Record 39)
        var
    //       SalesLine@1003 :
          SalesLine: Record 37;
    //       CopyDocMgt@1002 :
          CopyDocMgt: Codeunit 6620;
        begin
          SalesLine.GET(SalesLine."Document Type"::Order,
            SourcePurchaseLine."Sales Order No.",
            SourcePurchaseLine."Sales Order Line No.");
          CopyDocMgt.TransfldsFromSalesToPurchLine(SalesLine,DestinationPurchaseLine);
          DestinationPurchaseLine."Drop Shipment" := SourcePurchaseLine."Drop Shipment";
          DestinationPurchaseLine."Purchasing Code" := SalesLine."Purchasing Code";
          DestinationPurchaseLine."Sales Order No." := SourcePurchaseLine."Sales Order No.";
          DestinationPurchaseLine."Sales Order Line No." := SourcePurchaseLine."Sales Order Line No.";
          EVALUATE(DestinationPurchaseLine."Inbound Whse. Handling Time",'<0D>');
          DestinationPurchaseLine.VALIDATE("Inbound Whse. Handling Time");
          SalesLine.VALIDATE("Unit Cost (LCY)",DestinationPurchaseLine."Unit Cost (LCY)");
          SalesLine."Purchase Order No." := DestinationPurchaseLine."Document No.";
          SalesLine."Purch. Order Line No." := DestinationPurchaseLine."Line No.";
          SalesLine.MODIFY;
        end;
    */


    //     LOCAL procedure TransferSavedFieldsSpecialOrder (var DestinationPurchaseLine@1003 : Record 39;var SourcePurchaseLine@1002 :

    /*
    LOCAL procedure TransferSavedFieldsSpecialOrder (var DestinationPurchaseLine: Record 39;var SourcePurchaseLine: Record 39)
        var
    //       SalesLine@1004 :
          SalesLine: Record 37;
    //       CopyDocMgt@1000 :
          CopyDocMgt: Codeunit 6620;
        begin
          SalesLine.GET(SalesLine."Document Type"::Order,
            SourcePurchaseLine."Special Order Sales No.",
            SourcePurchaseLine."Special Order Sales Line No.");
          CopyDocMgt.TransfldsFromSalesToPurchLine(SalesLine,DestinationPurchaseLine);
          DestinationPurchaseLine."Special Order" := SourcePurchaseLine."Special Order";
          DestinationPurchaseLine."Purchasing Code" := SalesLine."Purchasing Code";
          DestinationPurchaseLine."Special Order Sales No." := SourcePurchaseLine."Special Order Sales No.";
          DestinationPurchaseLine."Special Order Sales Line No." := SourcePurchaseLine."Special Order Sales Line No.";
          DestinationPurchaseLine.VALIDATE("Unit of Measure Code",SourcePurchaseLine."Unit of Measure Code");
          if SourcePurchaseLine.Quantity <> 0 then
            DestinationPurchaseLine.VALIDATE(Quantity,SourcePurchaseLine.Quantity);

          SalesLine.VALIDATE("Unit Cost (LCY)",DestinationPurchaseLine."Unit Cost (LCY)");
          SalesLine."Special Order Purchase No." := DestinationPurchaseLine."Document No.";
          SalesLine."Special Order Purch. Line No." := DestinationPurchaseLine."Line No.";
          SalesLine.MODIFY;
        end;
    */



    //     procedure MessageIfPurchLinesExist (ChangedFieldName@1000 :

    /*
    procedure MessageIfPurchLinesExist (ChangedFieldName: Text[100])
        var
    //       MessageText@1001 :
          MessageText: Text;
        begin
          if PurchLinesExist and not GetHideValidationDialog then begin
            MessageText := STRSUBSTNO(LinesNotUpdatedMsg,ChangedFieldName);
            MessageText := STRSUBSTNO(SplitMessageTxt,MessageText,Text020);
            MESSAGE(MessageText);
          end;
        end;
    */



    //     procedure PriceMessageIfPurchLinesExist (ChangedFieldName@1000 :

    /*
    procedure PriceMessageIfPurchLinesExist (ChangedFieldName: Text[100])
        var
    //       MessageText@1001 :
          MessageText: Text;
        begin
          if PurchLinesExist and not GetHideValidationDialog then begin
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
                RecreatePurchLines(FIELDCAPTION("Currency Code"));
            end else begin
              if ConfirmManagement.ConfirmProcess(
                   STRSUBSTNO(MissingExchangeRatesQst,"Currency Code",CurrencyDate),TRUE)
              then begin
                UpdateCurrencyExchangeRates.OpenExchangeRatesPage("Currency Code");
                UpdateCurrencyFactor;
              end else
                RevertCurrencyCodeAndPostingDate;
            end;
          end else begin
            "Currency Factor" := 0;
            if "Currency Code" <> xRec."Currency Code" then
              RecreatePurchLines(FIELDCAPTION("Currency Code"));
          end;

          OnAfterUpdateCurrencyFactor(Rec,GetHideValidationDialog);
        end;
    */



    /*
    LOCAL procedure ConfirmUpdateCurrencyFactor () : Boolean;
        begin
          if GetHideValidationDialog or not GUIALLOWED then
            Confirmed := TRUE
          else
            Confirmed := CONFIRM(Text022,FALSE);
          if Confirmed then
            VALIDATE("Currency Factor")
          else
            "Currency Factor" := xRec."Currency Factor";
          exit(Confirmed);
        end;
    */




    /*
    procedure GetHideValidationDialog () : Boolean;
        begin
          exit(HideValidationDialog);
        end;
    */



    //     procedure SetHideValidationDialog (NewHideValidationDialog@1000 :

    /*
    procedure SetHideValidationDialog (NewHideValidationDialog: Boolean)
        begin
          HideValidationDialog := NewHideValidationDialog;
        end;
    */



    //     procedure UpdatePurchLines (ChangedFieldName@1000 : Text[100];AskQuestion@1001 :

    /*
    procedure UpdatePurchLines (ChangedFieldName: Text[100];AskQuestion: Boolean)
        var
    //       Field@1002 :
          Field: Record 2000000041;
        begin
          Field.SETRANGE(TableNo,DATABASE::"Purchase Header");
          Field.SETRANGE("Field Caption",ChangedFieldName);
          Field.SETFILTER(ObsoleteState,'<>%1',Field.ObsoleteState::Removed);
          Field.FIND('-');
          if Field.NEXT <> 0 then
            ERROR(DuplicatedCaptionsNotAllowedErr);
          UpdatePurchLinesByFieldNo(Field."No.",AskQuestion);

          OnAfterUpdatePurchLines(Rec);
        end;
    */



    //     procedure UpdatePurchLinesByFieldNo (ChangedFieldNo@1000 : Integer;AskQuestion@1001 :

    /*
    procedure UpdatePurchLinesByFieldNo (ChangedFieldNo: Integer;AskQuestion: Boolean)
        var
    //       Field@1004 :
          Field: Record 2000000041;
    //       PurchLineReserve@1003 :
          PurchLineReserve: Codeunit 99000834;
    //       Question@1002 :
          Question: Text[250];
        begin
          if not PurchLinesExist then
            exit;

          if not Field.GET(DATABASE::"Purchase Header",ChangedFieldNo) then
            Field.GET(DATABASE::"Purchase Line",ChangedFieldNo);

          if AskQuestion then begin
            Question := STRSUBSTNO(Text032,Field."Field Caption");
            if GUIALLOWED then
              if DIALOG.CONFIRM(Question,TRUE) then
                CASE ChangedFieldNo OF
                  FIELDNO("Expected Receipt Date"),
                  FIELDNO("Requested Receipt Date"),
                  FIELDNO("Promised Receipt Date"),
                  FIELDNO("Lead Time Calculation"),
                  FIELDNO("Inbound Whse. Handling Time"):
                    ConfirmResvDateConflict;
                end
              else
                exit;
          end;

          PurchLine.LOCKTABLE;
          MODIFY;

          PurchLine.RESET;
          PurchLine.SETRANGE("Document Type","Document Type");
          PurchLine.SETRANGE("Document No.","No.");
          if PurchLine.FINDSET then
            repeat
              xPurchLine := PurchLine;
              CASE ChangedFieldNo OF
                FIELDNO("Expected Receipt Date"):
                  if PurchLine."No." <> '' then
                    PurchLine.VALIDATE("Expected Receipt Date","Expected Receipt Date");
                FIELDNO("Currency Factor"):
                  if PurchLine.Type <> PurchLine.Type::" " then
                    PurchLine.VALIDATE("Direct Unit Cost");
                FIELDNO("Transaction Type"):
                  PurchLine.VALIDATE("Transaction Type","Transaction Type");
                FIELDNO("Transport Method"):
                  PurchLine.VALIDATE("Transport Method","Transport Method");
                FIELDNO("Entry Point"):
                  PurchLine.VALIDATE("Entry Point","Entry Point");
                FIELDNO(Area):
                  PurchLine.VALIDATE(Area,Area);
                FIELDNO("Transaction Specification"):
                  PurchLine.VALIDATE("Transaction Specification","Transaction Specification");
                FIELDNO("Requested Receipt Date"):
                  if PurchLine."No." <> '' then
                    PurchLine.VALIDATE("Requested Receipt Date","Requested Receipt Date");
                FIELDNO("Prepayment %"):
                  if PurchLine."No." <> '' then
                    PurchLine.VALIDATE("Prepayment %","Prepayment %");
                FIELDNO("Promised Receipt Date"):
                  if PurchLine."No." <> '' then
                    PurchLine.VALIDATE("Promised Receipt Date","Promised Receipt Date");
                FIELDNO("Lead Time Calculation"):
                  if PurchLine."No." <> '' then
                    PurchLine.VALIDATE("Lead Time Calculation","Lead Time Calculation");
                FIELDNO("Inbound Whse. Handling Time"):
                  if PurchLine."No." <> '' then
                    PurchLine.VALIDATE("Inbound Whse. Handling Time","Inbound Whse. Handling Time");
                PurchLine.FIELDNO("Deferral Code"):
                  if PurchLine."No." <> '' then
                    PurchLine.VALIDATE("Deferral Code");
                else
                  OnUpdatePurchLinesByChangedFieldName(Rec,PurchLine,Field."Field Caption");
              end;
              PurchLine.MODIFY(TRUE);
              PurchLineReserve.VerifyChange(PurchLine,xPurchLine);
            until PurchLine.NEXT = 0;
        end;
    */



    /*
    LOCAL procedure ConfirmResvDateConflict ()
        var
    //       ResvEngMgt@1000 :
          ResvEngMgt: Codeunit 99000831;
    //       ConfirmManagement@1001 :
          ConfirmManagement: Codeunit 27;
        begin
          if ResvEngMgt.ResvExistsForPurchHeader(Rec) then
            if not ConfirmManagement.ConfirmProcess(Text050,TRUE) then
              ERROR('');
        end;
    */



    //     procedure CreateDim (Type1@1000 : Integer;No1@1001 : Code[20];Type2@1002 : Integer;No2@1003 : Code[20];Type3@1004 : Integer;No3@1005 : Code[20];Type4@1006 : Integer;No4@1007 :

    /*
    procedure CreateDim (Type1: Integer;No1: Code[20];Type2: Integer;No2: Code[20];Type3: Integer;No3: Code[20];Type4: Integer;No4: Code[20])
        var
    //       SourceCodeSetup@1010 :
          SourceCodeSetup: Record 242;
    //       TableID@1011 :
          TableID: ARRAY [10] OF Integer;
    //       No@1012 :
          No: ARRAY [10] OF Code[20];
    //       OldDimSetID@1008 :
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
          OnAfterCreateDimTableIDs(Rec,CurrFieldNo,TableID,No);

          "Shortcut Dimension 1 Code" := '';
          "Shortcut Dimension 2 Code" := '';
          OldDimSetID := "Dimension Set ID";
          "Dimension Set ID" :=
            DimMgt.GetRecDefaultDimID(
              Rec,CurrFieldNo,TableID,No,SourceCodeSetup.Purchases,"Shortcut Dimension 1 Code","Shortcut Dimension 2 Code",0,0);

          if (OldDimSetID <> "Dimension Set ID") and PurchLinesExist then begin
            MODIFY;
            UpdateAllLineDim("Dimension Set ID",OldDimSetID);
          end;
        end;
    */



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
            if PurchLinesExist then
              UpdateAllLineDim("Dimension Set ID",OldDimSetID);
          end;

          OnAfterValidateShortcutDimCode(Rec,xRec,FieldNumber,ShortcutDimCode);
        end;
    */



    /*
    LOCAL procedure ReceivedPurchLinesExist () : Boolean;
        begin
          PurchLine.RESET;
          PurchLine.SETRANGE("Document Type","Document Type");
          PurchLine.SETRANGE("Document No.","No.");
          PurchLine.SETFILTER("Quantity Received",'<>0');
          exit(PurchLine.FINDFIRST);
        end;
    */



    /*
    LOCAL procedure ReturnShipmentExist () : Boolean;
        begin
          PurchLine.RESET;
          PurchLine.SETRANGE("Document Type","Document Type");
          PurchLine.SETRANGE("Document No.","No.");
          PurchLine.SETFILTER("Return Qty. Shipped",'<>0');
          exit(PurchLine.FINDFIRST);
        end;
    */




    /*
    procedure UpdateShipToAddress ()
        begin
          if IsCreditDocType then begin
            OnAfterUpdateShipToAddress(Rec);
            exit;
          end;

          if ("Location Code" <> '') and Location.GET("Location Code") and ("Sell-to Customer No." = '') then begin
            SetShipToAddress(
              Location.Name,Location."Name 2",Location.Address,Location."Address 2",
              Location.City,Location."Post Code",Location.County,Location."Country/Region Code");
            "Ship-to Contact" := Location.Contact;
          end;

          if ("Location Code" = '') and ("Sell-to Customer No." = '') then begin
            CompanyInfo.GET;
            "Ship-to Code" := '';
            SetShipToAddress(
              CompanyInfo."Ship-to Name",CompanyInfo."Ship-to Name 2",CompanyInfo."Ship-to Address",CompanyInfo."Ship-to Address 2",
              CompanyInfo."Ship-to City",CompanyInfo."Ship-to Post Code",CompanyInfo."Ship-to County",
              CompanyInfo."Ship-to Country/Region Code");
            "Ship-to Contact" := CompanyInfo."Ship-to Contact";
          end;

          OnAfterUpdateShipToAddress(Rec);
        end;
    */



    /*
    LOCAL procedure DeletePurchaseLines ()
        var
    //       ReservMgt@1000 :
          ReservMgt: Codeunit 99000845;
        begin
          if PurchLine.FINDSET then begin
            ReservMgt.DeleteDocumentReservation(DATABASE::"Purchase Line","Document Type","No.",GetHideValidationDialog);
            repeat
              PurchLine.SuspendStatusCheck(TRUE);
              PurchLine.DELETE(TRUE);
            until PurchLine.NEXT = 0;
          end;
        end;
    */


    //     LOCAL procedure ClearItemAssgntPurchFilter (var TempItemChargeAssgntPurch@1000 :

    /*
    LOCAL procedure ClearItemAssgntPurchFilter (var TempItemChargeAssgntPurch: Record 5805 TEMPORARY)
        begin
          TempItemChargeAssgntPurch.SETRANGE("Document Line No.");
          TempItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Type");
          TempItemChargeAssgntPurch.SETRANGE("Applies-to Doc. No.");
          TempItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Line No.");
        end;
    */


    //     LOCAL procedure CheckReceiptInfo (var PurchLine@1000 : Record 39;PayTo@1001 :

    /*
    LOCAL procedure CheckReceiptInfo (var PurchLine: Record 39;PayTo: Boolean)
        begin
          if "Document Type" = "Document Type"::Order then
            PurchLine.SETFILTER("Quantity Received",'<>0')
          else
            if "Document Type" = "Document Type"::Invoice then begin
              if not PayTo then
                PurchLine.SETRANGE("Buy-from Vendor No.",xRec."Buy-from Vendor No.");
              PurchLine.SETFILTER("Receipt No.",'<>%1','');
            end;

          if PurchLine.FINDFIRST then
            if "Document Type" = "Document Type"::Order then
              PurchLine.TESTFIELD("Quantity Received",0)
            else
              PurchLine.TESTFIELD("Receipt No.",'');
          PurchLine.SETRANGE("Receipt No.");
          PurchLine.SETRANGE("Quantity Received");
          if not PayTo then
            PurchLine.SETRANGE("Buy-from Vendor No.");
        end;
    */


    //     LOCAL procedure CheckPrepmtInfo (var PurchLine@1000 :

    /*
    LOCAL procedure CheckPrepmtInfo (var PurchLine: Record 39)
        begin
          if "Document Type" = "Document Type"::Order then begin
            PurchLine.SETFILTER("Prepmt. Amt. Inv.",'<>0');
            if PurchLine.FIND('-') then
              PurchLine.TESTFIELD("Prepmt. Amt. Inv.",0);
            PurchLine.SETRANGE("Prepmt. Amt. Inv.");
          end;
        end;
    */


    //     LOCAL procedure CheckReturnInfo (var PurchLine@1000 : Record 39;PayTo@1001 :

    /*
    LOCAL procedure CheckReturnInfo (var PurchLine: Record 39;PayTo: Boolean)
        begin
          if "Document Type" = "Document Type"::"Return Order" then
            PurchLine.SETFILTER("Return Qty. Shipped",'<>0')
          else
            if "Document Type" = "Document Type"::"Credit Memo" then begin
              if not PayTo then
                PurchLine.SETRANGE("Buy-from Vendor No.",xRec."Buy-from Vendor No.");
              PurchLine.SETFILTER("Return Shipment No.",'<>%1','');
            end;

          if PurchLine.FINDFIRST then
            if "Document Type" = "Document Type"::"Return Order" then
              PurchLine.TESTFIELD("Return Qty. Shipped",0)
            else
              PurchLine.TESTFIELD("Return Shipment No.",'');
        end;
    */


    //     LOCAL procedure UpdateBuyFromCont (VendorNo@1000 :

    /*
    LOCAL procedure UpdateBuyFromCont (VendorNo: Code[20])
        var
    //       ContBusRel@1003 :
          ContBusRel: Record 5054;
    //       Vend@1004 :
          Vend: Record 23;
    //       OfficeContact@1001 :
          OfficeContact: Record 5050;
    //       OfficeMgt@1002 :
          OfficeMgt: Codeunit 1630;
        begin
          if OfficeMgt.GetContact(OfficeContact,VendorNo) then begin
            SetHideValidationDialog(TRUE);
            UpdateBuyFromVend(OfficeContact."No.");
            SetHideValidationDialog(FALSE);
          end else
            if Vend.GET(VendorNo) then begin
              if Vend."Primary Contact No." <> '' then
                "Buy-from Contact No." := Vend."Primary Contact No."
              else
                "Buy-from Contact No." := ContBusRel.GetContactNo(ContBusRel."Link to Table"::Vendor,"Buy-from Vendor No.");
              "Buy-from Contact" := Vend.Contact;
            end;

          if "Buy-from Contact No." <> '' then
            if OfficeContact.GET("Buy-from Contact No.") then
              OfficeContact.CheckIfPrivacyBlockedGeneric;

          OnAfterUpdateBuyFromCont(Rec,Vend,OfficeContact);
        end;
    */


    //     LOCAL procedure UpdatePayToCont (VendorNo@1000 :
    LOCAL procedure UpdatePayToCont(VendorNo: Code[20])
    var
        //       ContBusRel@1003 :
        ContBusRel: Record 5054;
        //       Vend@1001 :
        Vend: Record 23;
        //       Contact@1002 :
        Contact: Record 5050;
    begin
        if Vend.GET(VendorNo) then begin
            if Vend."Primary Contact No." <> '' then
                "Pay-to Contact No." := Vend."Primary Contact No."
            else
                "Pay-to Contact No." := ContBusRel.GetContactNo(ContBusRel."Link to Table"::Vendor, "Pay-to Vendor No.");
            "Pay-to Contact" := Vend.Contact;
        end;

        if "Pay-to Contact No." <> '' then
            if Contact.GET("Pay-to Contact No.") then
                Contact.CheckIfPrivacyBlockedGeneric;

        OnAfterUpdatePayToCont(Rec, Vend, Contact);
    end;

    //     LOCAL procedure UpdateBuyFromVend (ContactNo@1002 :

    /*
    LOCAL procedure UpdateBuyFromVend (ContactNo: Code[20])
        var
    //       ContBusinessRelation@1007 :
          ContBusinessRelation: Record 5054;
    //       Vend@1006 :
          Vend: Record 23;
    //       Cont@1005 :
          Cont: Record 5050;
        begin
          if Cont.GET(ContactNo) then begin
            "Buy-from Contact No." := Cont."No.";
            if Cont.Type = Cont.Type::Person then
              "Buy-from Contact" := Cont.Name
            else
              if Vend.GET("Buy-from Vendor No.") then
                "Buy-from Contact" := Vend.Contact
              else
                "Buy-from Contact" := ''
          end else begin
            "Buy-from Contact" := '';
            exit;
          end;

          if ContBusinessRelation.FindByContact(ContBusinessRelation."Link to Table"::Vendor,Cont."Company No.") then begin
            if ("Buy-from Vendor No." <> '') and
               ("Buy-from Vendor No." <> ContBusinessRelation."No.")
            then
              ERROR(Text037,Cont."No.",Cont.Name,"Buy-from Vendor No.");
            if "Buy-from Vendor No." = '' then begin
              SkipBuyFromContact := TRUE;
              VALIDATE("Buy-from Vendor No.",ContBusinessRelation."No.");
              SkipBuyFromContact := FALSE;
            end;
          end else
            ERROR(Text039,Cont."No.",Cont.Name);

          if ("Buy-from Vendor No." = "Pay-to Vendor No.") or
             ("Pay-to Vendor No." = '')
          then
            VALIDATE("Pay-to Contact No.","Buy-from Contact No.");

          OnAfterUpdateBuyFromVend(Rec,Cont);
        end;
    */


    //     LOCAL procedure UpdatePayToVend (ContactNo@1000 :

    /*
    LOCAL procedure UpdatePayToVend (ContactNo: Code[20])
        var
    //       ContBusinessRelation@1005 :
          ContBusinessRelation: Record 5054;
    //       Vend@1004 :
          Vend: Record 23;
    //       Cont@1003 :
          Cont: Record 5050;
        begin
          if Cont.GET(ContactNo) then begin
            "Pay-to Contact No." := Cont."No.";
            if Cont.Type = Cont.Type::Person then
              "Pay-to Contact" := Cont.Name
            else
              if Vend.GET("Pay-to Vendor No.") then
                "Pay-to Contact" := Vend.Contact
              else
                "Pay-to Contact" := '';
          end else begin
            "Pay-to Contact" := '';
            exit;
          end;

          if ContBusinessRelation.FindByContact(ContBusinessRelation."Link to Table"::Vendor,Cont."Company No.") then begin
            if "Pay-to Vendor No." = '' then begin
              SkipPayToContact := TRUE;
              VALIDATE("Pay-to Vendor No.",ContBusinessRelation."No.");
              SkipPayToContact := FALSE;
            end else
              if "Pay-to Vendor No." <> ContBusinessRelation."No." then
                ERROR(Text037,Cont."No.",Cont.Name,"Pay-to Vendor No.");
          end else
            ERROR(Text039,Cont."No.",Cont.Name);
        end;
    */




    /*
    procedure CreateInvtPutAwayPick ()
        var
    //       WhseRequest@1000 :
          WhseRequest: Record 5765;
        begin
          TESTFIELD(Status,Status::Released);

          WhseRequest.RESET;
          WhseRequest.SETCURRENTKEY("Source Document","Source No.");
          CASE "Document Type" OF
            "Document Type"::Order:
              WhseRequest.SETRANGE("Source Document",WhseRequest."Source Document"::"Purchase Order");
            "Document Type"::"Return Order":
              WhseRequest.SETRANGE("Source Document",WhseRequest."Source Document"::"Purchase Return Order");
          end;
          WhseRequest.SETRANGE("Source No.","No.");
          REPORT.RUNMODAL(REPORT::"Create Invt Put-away/Pick/Mvmt",TRUE,FALSE,WhseRequest);
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
            if PurchLinesExist then
              UpdateAllLineDim("Dimension Set ID",OldDimSetID);
          end;
        end;
    */



    //     procedure UpdateAllLineDim (NewParentDimSetID@1000 : Integer;OldParentDimSetID@1001 :

    /*
    procedure UpdateAllLineDim (NewParentDimSetID: Integer;OldParentDimSetID: Integer)
        var
    //       ConfirmManagement@1004 :
          ConfirmManagement: Codeunit 27;
    //       NewDimSetID@1002 :
          NewDimSetID: Integer;
    //       ReceivedShippedItemLineDimChangeConfirmed@1003 :
          ReceivedShippedItemLineDimChangeConfirmed: Boolean;
        begin
          // Update all lines with changed dimensions.

          if NewParentDimSetID = OldParentDimSetID then
            exit;
          if not ConfirmManagement.ConfirmProcess(Text051,TRUE) then
            exit;

          PurchLine.RESET;
          PurchLine.SETRANGE("Document Type","Document Type");
          PurchLine.SETRANGE("Document No.","No.");
          PurchLine.LOCKTABLE;
          if PurchLine.FIND('-') then
            repeat
              NewDimSetID := DimMgt.GetDeltaDimSetID(PurchLine."Dimension Set ID",NewParentDimSetID,OldParentDimSetID);
              if PurchLine."Dimension Set ID" <> NewDimSetID then begin
                PurchLine."Dimension Set ID" := NewDimSetID;

                if not GetHideValidationDialog and GUIALLOWED then
                  VerifyReceivedShippedItemLineDimChange(ReceivedShippedItemLineDimChangeConfirmed);

                DimMgt.UpdateGlobalDimFromDimSetID(
                  PurchLine."Dimension Set ID",PurchLine."Shortcut Dimension 1 Code",PurchLine."Shortcut Dimension 2 Code");
                PurchLine.MODIFY;
              end;
            until PurchLine.NEXT = 0;
        end;
    */


    //     LOCAL procedure VerifyReceivedShippedItemLineDimChange (var ReceivedShippedItemLineDimChangeConfirmed@1000 :

    /*
    LOCAL procedure VerifyReceivedShippedItemLineDimChange (var ReceivedShippedItemLineDimChangeConfirmed: Boolean)
        begin
          if PurchLine.IsReceivedShippedItemDimChanged then
            if not ReceivedShippedItemLineDimChangeConfirmed then
              ReceivedShippedItemLineDimChangeConfirmed := PurchLine.ConfirmReceivedShippedItemDimChange;
        end;
    */



    //     procedure SetAmountToApply (AppliesToDocNo@1000 : Code[20];VendorNo@1001 :

    /*
    procedure SetAmountToApply (AppliesToDocNo: Code[20];VendorNo: Code[20])
        var
    //       VendLedgEntry@1002 :
          VendLedgEntry: Record 25;
        begin
          VendLedgEntry.SETCURRENTKEY("Document No.");
          VendLedgEntry.SETRANGE("Document No.",AppliesToDocNo);
          VendLedgEntry.SETRANGE("Vendor No.",VendorNo);
          VendLedgEntry.SETRANGE(Open,TRUE);
          if VendLedgEntry.FINDFIRST then begin
            if VendLedgEntry."Amount to Apply" = 0 then  begin
              VendLedgEntry.CALCFIELDS("Remaining Amount");
              VendLedgEntry."Amount to Apply" := VendLedgEntry."Remaining Amount";
            end else
              VendLedgEntry."Amount to Apply" := 0;
            VendLedgEntry."Accepted Payment Tolerance" := 0;
            VendLedgEntry."Accepted Pmt. Disc. Tolerance" := FALSE;
            CODEUNIT.RUN(CODEUNIT::"Vend. Entry-Edit",VendLedgEntry);
          end;
        end;
    */




    /*
    procedure SetShipToForSpecOrder ()
        begin
          if Location.GET("Location Code") then begin
            "Ship-to Code" := '';
            SetShipToAddress(
              Location.Name,Location."Name 2",Location.Address,Location."Address 2",
              Location.City,Location."Post Code",Location.County,Location."Country/Region Code");
            "Ship-to Contact" := Location.Contact;
            "Location Code" := Location.Code;
          end else begin
            CompanyInfo.GET;
            "Ship-to Code" := '';
            SetShipToAddress(
              CompanyInfo."Ship-to Name",CompanyInfo."Ship-to Name 2",CompanyInfo."Ship-to Address",CompanyInfo."Ship-to Address 2",
              CompanyInfo."Ship-to City",CompanyInfo."Ship-to Post Code",CompanyInfo."Ship-to County",
              CompanyInfo."Ship-to Country/Region Code");
            "Ship-to Contact" := CompanyInfo."Ship-to Contact";
            "Location Code" := '';
          end;

          OnAfterSetShipToForSpecOrder(Rec);
        end;
    */


    //     LOCAL procedure JobUpdatePurchLines (SkipJobCurrFactorUpdate@1000 :

    /*
    LOCAL procedure JobUpdatePurchLines (SkipJobCurrFactorUpdate: Boolean)
        begin
          WITH PurchLine DO begin
            SETFILTER("Job No.",'<>%1','');
            SETFILTER("Job Task No.",'<>%1','');
            LOCKTABLE;
            if FINDSET(TRUE) then begin
              SetPurchHeader(Rec);
              repeat
                if not SkipJobCurrFactorUpdate then
                  JobSetCurrencyFactor;
                CreateTempJobJnlLine(FALSE);
                UpdateJobPrices;
                MODIFY;
              until NEXT = 0;
            end;
          end
        end;
    */



    /*
    procedure GetPstdDocLinesToRevere ()
        var
    //       PurchPostedDocLines@1002 :
          PurchPostedDocLines: Page 5855;
        begin
          GetVend("Buy-from Vendor No.");
          PurchPostedDocLines.SetToPurchHeader(Rec);
          PurchPostedDocLines.SETRECORD(Vend);
          PurchPostedDocLines.LOOKUPMODE := TRUE;
          if PurchPostedDocLines.RUNMODAL = ACTION::LookupOK then
            PurchPostedDocLines.CopyLineToDoc;

          CLEAR(PurchPostedDocLines);
        end;
    */



    procedure SetSecurityFilterOnRespCenter()
    begin
        if UserSetupMgt.GetPurchasesFilter <> '' then begin
            FILTERGROUP(2);
            SETRANGE("Responsibility Center", UserSetupMgt.GetPurchasesFilter);
            FILTERGROUP(0);
        end;

        SETRANGE("Date Filter", 0D, WORKDATE - 1);

        //JAV 18/07/20: - QB Filtro de proyectos permitidos para el usuario
        FunctionQB.SetUserJobPurchasesFilter(Rec);
    end;



    /*
    procedure CalcInvDiscForHeader ()
        var
    //       PurchaseInvDisc@1000 :
          PurchaseInvDisc: Codeunit 70;
        begin
          PurchSetup.GET;
          if PurchSetup."Calc. Inv. Discount" then
            PurchaseInvDisc.CalculateIncDiscForHeader(Rec);
        end;
    */



    //     procedure AddShipToAddress (SalesHeader@1000 : Record 36;ShowError@1001 :

    /*
    procedure AddShipToAddress (SalesHeader: Record 36;ShowError: Boolean)
        var
    //       PurchLine2@1002 :
          PurchLine2: Record 39;
        begin
          if ShowError then begin
            PurchLine2.RESET;
            PurchLine2.SETRANGE("Document Type","Document Type"::Order);
            PurchLine2.SETRANGE("Document No.","No.");
            if not PurchLine2.ISEMPTY then begin
              if "Ship-to Name" <> SalesHeader."Ship-to Name" then
                ERROR(Text052,FIELDCAPTION("Ship-to Name"),"No.",SalesHeader."No.");
              if "Ship-to Name 2" <> SalesHeader."Ship-to Name 2" then
                ERROR(Text052,FIELDCAPTION("Ship-to Name 2"),"No.",SalesHeader."No.");
              if "Ship-to Address" <> SalesHeader."Ship-to Address" then
                ERROR(Text052,FIELDCAPTION("Ship-to Address"),"No.",SalesHeader."No.");
              if "Ship-to Address 2" <> SalesHeader."Ship-to Address 2" then
                ERROR(Text052,FIELDCAPTION("Ship-to Address 2"),"No.",SalesHeader."No.");
              if "Ship-to Post Code" <> SalesHeader."Ship-to Post Code" then
                ERROR(Text052,FIELDCAPTION("Ship-to Post Code"),"No.",SalesHeader."No.");
              if "Ship-to City" <> SalesHeader."Ship-to City" then
                ERROR(Text052,FIELDCAPTION("Ship-to City"),"No.",SalesHeader."No.");
              if "Ship-to Contact" <> SalesHeader."Ship-to Contact" then
                ERROR(Text052,FIELDCAPTION("Ship-to Contact"),"No.",SalesHeader."No.");
            end else begin
              // no purchase line exists
              "Ship-to Name" := SalesHeader."Ship-to Name";
              "Ship-to Name 2" := SalesHeader."Ship-to Name 2";
              "Ship-to Address" := SalesHeader."Ship-to Address";
              "Ship-to Address 2" := SalesHeader."Ship-to Address 2";
              "Ship-to Post Code" := SalesHeader."Ship-to Post Code";
              "Ship-to City" := SalesHeader."Ship-to City";
              "Ship-to Contact" := SalesHeader."Ship-to Contact";
            end;
          end;
        end;
    */



    //     procedure DropShptOrderExists (SalesHeader@1000 :

    /*
    procedure DropShptOrderExists (SalesHeader: Record 36) : Boolean;
        var
    //       SalesLine2@1001 :
          SalesLine2: Record 37;
        begin
          // returns TRUE if sales is either Drop Shipment of Special Order
          SalesLine2.RESET;
          SalesLine2.SETRANGE("Document Type",SalesLine2."Document Type"::Order);
          SalesLine2.SETRANGE("Document No.",SalesHeader."No.");
          SalesLine2.SETRANGE("Drop Shipment",TRUE);
          exit(not SalesLine2.ISEMPTY);
        end;
    */



    //     procedure SpecialOrderExists (SalesHeader@1000 :

    /*
    procedure SpecialOrderExists (SalesHeader: Record 36) : Boolean;
        var
    //       SalesLine3@1001 :
          SalesLine3: Record 37;
        begin
          SalesLine3.RESET;
          SalesLine3.SETRANGE("Document Type",SalesLine3."Document Type"::Order);
          SalesLine3.SETRANGE("Document No.",SalesHeader."No.");
          SalesLine3.SETRANGE("Special Order",TRUE);
          exit(not SalesLine3.ISEMPTY);
        end;
    */



    /*
    LOCAL procedure CheckDropShipmentLineExists ()
        var
    //       SalesShipmentLine@1000 :
          SalesShipmentLine: Record 111;
        begin
          SalesShipmentLine.SETRANGE("Purchase Order No.","No.");
          SalesShipmentLine.SETRANGE("Drop Shipment",TRUE);
          if not SalesShipmentLine.ISEMPTY then
            ERROR(YouCannotChangeFieldErr,FIELDCAPTION("Buy-from Vendor No."));
        end;
    */




    /*
    procedure QtyToReceiveIsZero () : Boolean;
        begin
          PurchLine.RESET;
          PurchLine.SETRANGE("Document Type","Document Type");
          PurchLine.SETRANGE("Document No.","No.");
          PurchLine.SETFILTER("Qty. to Receive",'<>0');
          exit(PurchLine.ISEMPTY);
        end;
    */



    /*
    LOCAL procedure IsApprovedForPosting () : Boolean;
        var
    //       PrepaymentMgt@1000 :
          PrepaymentMgt: Codeunit 441;
    //       ConfirmManagement@1001 :
          ConfirmManagement: Codeunit 27;
        begin
          if ApprovalsMgmt.PrePostApprovalCheckPurch(Rec) then begin
            if PrepaymentMgt.TestPurchasePrepayment(Rec) then
              ERROR(PrepaymentInvoicesNotPaidErr,"Document Type","No.");
            if PrepaymentMgt.TestPurchasePayment(Rec) then
              if not ConfirmManagement.ConfirmProcess(STRSUBSTNO(Text054,"Document Type","No."),TRUE) then
                exit(FALSE);
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
          if ApprovalsMgmt.PrePostApprovalCheckPurch(Rec) then begin
            if PrepaymentMgt.TestPurchasePrepayment(Rec) then
              exit(FALSE);
            if PrepaymentMgt.TestPurchasePayment(Rec) then
              exit(FALSE);
            exit(TRUE);
          end;
        end;
    */




    /*
    procedure IsTotalValid () : Boolean;
        var
    //       IncomingDocument@1002 :
          IncomingDocument: Record 130;
    //       PurchaseLine@1001 :
          PurchaseLine: Record 39;
    //       TempTotalPurchaseLine@1000 :
          TempTotalPurchaseLine: Record 39 TEMPORARY;
    //       GeneralLedgerSetup@1005 :
          GeneralLedgerSetup: Record 98;
    //       DocumentTotals@1003 :
          DocumentTotals: Codeunit 57;
    //       VATAmount@1004 :
          VATAmount: Decimal;
        begin
          if not IncomingDocument.GET("Incoming Document Entry No.") then
            exit(TRUE);

          if IncomingDocument."Amount Incl. VAT" = 0 then
            exit(TRUE);

          PurchaseLine.SETRANGE("Document Type","Document Type");
          PurchaseLine.SETRANGE("Document No.","No.");
          if not PurchaseLine.FINDFIRST then
            exit(TRUE);

          GeneralLedgerSetup.GET;
          if (IncomingDocument."Currency Code" <> PurchaseLine."Currency Code") and
             (IncomingDocument."Currency Code" <> GeneralLedgerSetup."LCY Code")
          then
            exit(TRUE);

          TempTotalPurchaseLine.INIT;
          DocumentTotals.PurchaseCalculateTotalsWithInvoiceRounding(PurchaseLine,VATAmount,TempTotalPurchaseLine);

          exit(IncomingDocument."Amount Incl. VAT" = TempTotalPurchaseLine."Amount Including VAT");
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
    //       PurchasePostViaJobQueue@1000 :
          PurchasePostViaJobQueue: Codeunit 98;
        begin
          PurchasePostViaJobQueue.CancelQueueEntry(Rec);
        end;
    */



    //     procedure AddSpecialOrderToAddress (SalesHeader@1000 : Record 36;ShowError@1001 :

    /*
    procedure AddSpecialOrderToAddress (SalesHeader: Record 36;ShowError: Boolean)
        var
    //       PurchLine3@1003 :
          PurchLine3: Record 39;
    //       LocationCode@1004 :
          LocationCode: Record 14;
        begin
          if ShowError then begin
            PurchLine3.RESET;
            PurchLine3.SETRANGE("Document Type","Document Type"::Order);
            PurchLine3.SETRANGE("Document No.","No.");
            if not PurchLine3.ISEMPTY then begin
              LocationCode.GET("Location Code");
              if "Ship-to Name" <> LocationCode.Name then
                ERROR(Text052,FIELDCAPTION("Ship-to Name"),"No.",SalesHeader."No.");
              if "Ship-to Name 2" <> LocationCode."Name 2" then
                ERROR(Text052,FIELDCAPTION("Ship-to Name 2"),"No.",SalesHeader."No.");
              if "Ship-to Address" <> LocationCode.Address then
                ERROR(Text052,FIELDCAPTION("Ship-to Address"),"No.",SalesHeader."No.");
              if "Ship-to Address 2" <> LocationCode."Address 2" then
                ERROR(Text052,FIELDCAPTION("Ship-to Address 2"),"No.",SalesHeader."No.");
              if "Ship-to Post Code" <> LocationCode."Post Code" then
                ERROR(Text052,FIELDCAPTION("Ship-to Post Code"),"No.",SalesHeader."No.");
              if "Ship-to City" <> LocationCode.City then
                ERROR(Text052,FIELDCAPTION("Ship-to City"),"No.",SalesHeader."No.");
              if "Ship-to Contact" <> LocationCode.Contact then
                ERROR(Text052,FIELDCAPTION("Ship-to Contact"),"No.",SalesHeader."No.");
            end else
              SetShipToForSpecOrder;
          end;
        end;
    */




    /*
    procedure InvoicedLineExists () : Boolean;
        var
    //       PurchLine@1000 :
          PurchLine: Record 39;
        begin
          PurchLine.SETRANGE("Document Type","Document Type");
          PurchLine.SETRANGE("Document No.","No.");
          PurchLine.SETFILTER(Type,'<>%1',PurchLine.Type::" ");
          PurchLine.SETFILTER("Quantity Invoiced",'<>%1',0);
          exit(not PurchLine.ISEMPTY);
        end;
    */




    /*
    procedure CreateDimSetForPrepmtAccDefaultDim ()
        var
    //       PurchaseLine@1001 :
          PurchaseLine: Record 39;
    //       TempPurchaseLine@1002 :
          TempPurchaseLine: Record 39 TEMPORARY;
        begin
          PurchaseLine.SETRANGE("Document Type","Document Type");
          PurchaseLine.SETRANGE("Document No.","No.");
          PurchaseLine.SETFILTER("Prepmt. Amt. Inv.",'<>%1',0);
          if PurchaseLine.FINDSET then
            repeat
              CollectParamsInBufferForCreateDimSet(TempPurchaseLine,PurchaseLine);
            until PurchaseLine.NEXT = 0;
          TempPurchaseLine.RESET;
          TempPurchaseLine.MARKEDONLY(FALSE);
          if TempPurchaseLine.FINDSET then
            repeat
              PurchaseLine.CreateDim(DATABASE::"G/L Account",TempPurchaseLine."No.",
                DATABASE::Job,TempPurchaseLine."Job No.",
                DATABASE::"Responsibility Center",TempPurchaseLine."Responsibility Center",
                DATABASE::"Work Center",TempPurchaseLine."Work Center No.");
            until TempPurchaseLine.NEXT = 0;
        end;
    */


    //     LOCAL procedure CollectParamsInBufferForCreateDimSet (var TempPurchaseLine@1000 : TEMPORARY Record 39;PurchaseLine@1001 :

    /*
    LOCAL procedure CollectParamsInBufferForCreateDimSet (var TempPurchaseLine: Record 39 TEMPORARY;PurchaseLine: Record 39)
        var
    //       GenPostingSetup@1002 :
          GenPostingSetup: Record 252;
    //       DefaultDimension@1003 :
          DefaultDimension: Record 352;
        begin
          TempPurchaseLine.SETRANGE("Gen. Bus. Posting Group",PurchaseLine."Gen. Bus. Posting Group");
          TempPurchaseLine.SETRANGE("Gen. Prod. Posting Group",PurchaseLine."Gen. Prod. Posting Group");
          if not TempPurchaseLine.FINDFIRST then begin
            GenPostingSetup.GET(PurchaseLine."Gen. Bus. Posting Group",PurchaseLine."Gen. Prod. Posting Group");
            GenPostingSetup.TESTFIELD("Purch. Prepayments Account");
            DefaultDimension.SETRANGE("Table ID",DATABASE::"G/L Account");
            DefaultDimension.SETRANGE("No.",GenPostingSetup."Purch. Prepayments Account");
            InsertTempPurchaseLineInBuffer(TempPurchaseLine,PurchaseLine,
              GenPostingSetup."Purch. Prepayments Account",DefaultDimension.ISEMPTY);
          end else
            if not TempPurchaseLine.MARK then begin
              TempPurchaseLine.SETRANGE("Job No.",PurchaseLine."Job No.");
              TempPurchaseLine.SETRANGE("Responsibility Center",PurchaseLine."Responsibility Center");
              TempPurchaseLine.SETRANGE("Work Center No.",PurchaseLine."Work Center No.");
              if TempPurchaseLine.ISEMPTY then
                InsertTempPurchaseLineInBuffer(TempPurchaseLine,PurchaseLine,TempPurchaseLine."No.",FALSE)
            end;
        end;
    */


    //     LOCAL procedure InsertTempPurchaseLineInBuffer (var TempPurchaseLine@1000 : TEMPORARY Record 39;PurchaseLine@1001 : Record 39;AccountNo@1002 : Code[20];DefaultDimenstionsNotExist@1003 :

    /*
    LOCAL procedure InsertTempPurchaseLineInBuffer (var TempPurchaseLine: Record 39 TEMPORARY;PurchaseLine: Record 39;AccountNo: Code[20];DefaultDimenstionsNotExist: Boolean)
        begin
          TempPurchaseLine.INIT;
          TempPurchaseLine."Line No." := PurchaseLine."Line No.";
          TempPurchaseLine."No." := AccountNo;
          TempPurchaseLine."Job No." := PurchaseLine."Job No.";
          TempPurchaseLine."Responsibility Center" := PurchaseLine."Responsibility Center";
          TempPurchaseLine."Work Center No." := PurchaseLine."Work Center No.";
          TempPurchaseLine."Gen. Bus. Posting Group" := PurchaseLine."Gen. Bus. Posting Group";
          TempPurchaseLine."Gen. Prod. Posting Group" := PurchaseLine."Gen. Prod. Posting Group";
          TempPurchaseLine.MARK := DefaultDimenstionsNotExist;
          TempPurchaseLine.INSERT;
        end;
    */


    //     LOCAL procedure TransferItemChargeAssgntPurchToTemp (var ItemChargeAssgntPurch@1000 : Record 5805;var TempItemChargeAssgntPurch@1001 :

    /*
    LOCAL procedure TransferItemChargeAssgntPurchToTemp (var ItemChargeAssgntPurch: Record 5805;var TempItemChargeAssgntPurch: Record 5805 TEMPORARY)
        begin
          ItemChargeAssgntPurch.SETRANGE("Document Type","Document Type");
          ItemChargeAssgntPurch.SETRANGE("Document No.","No.");
          if ItemChargeAssgntPurch.FINDSET then begin
            repeat
              TempItemChargeAssgntPurch := ItemChargeAssgntPurch;
              TempItemChargeAssgntPurch.INSERT;
            until ItemChargeAssgntPurch.NEXT = 0;
            ItemChargeAssgntPurch.DELETEALL;
          end;
        end;
    */




    /*
    procedure OpenPurchaseOrderStatistics ()
        begin
          CalcInvDiscForHeader;
          CreateDimSetForPrepmtAccDefaultDim;
          COMMIT;
          PAGE.RUNMODAL(PAGE::"Purchase Order Statistics",Rec);
        end;
    */




    /*
    procedure GetCardpageID () : Integer;
        begin
          CASE "Document Type" OF
            "Document Type"::Quote:
              exit(PAGE::"Purchase Quote");
            "Document Type"::Order:
              exit(PAGE::"Purchase Order");
            "Document Type"::Invoice:
              exit(PAGE::"Purchase Invoice");
            "Document Type"::"Credit Memo":
              exit(PAGE::"Purchase Credit Memo");
            "Document Type"::"Blanket Order":
              exit(PAGE::"Blanket Purchase Order");
            "Document Type"::"Return Order":
              exit(PAGE::"Purchase Return Order");
          end;
        end;

        [Integration(TRUE)]
    */



    /*
    procedure OnCheckPurchasePostRestrictions ()
        begin
        end;

        [Integration(TRUE)]
    */


    /*
    LOCAL procedure OnCheckPurchaseReleaseRestrictions ()
        begin
        end;
    */




    /*
    procedure CheckPurchaseReleaseRestrictions ()
        var
    //       ApprovalsMgmt@1000 :
          ApprovalsMgmt: Codeunit 1535;
        begin
          OnCheckPurchaseReleaseRestrictions;
          ApprovalsMgmt.PrePostApprovalCheckPurch(Rec);
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



    //     procedure TriggerOnAfterPostPurchaseDoc (var GenJnlPostLine@1001 : Codeunit 12;PurchRcpHdrNo@1002 : Code[20];RetShptHdrNo@1003 : Code[20];PurchInvHdrNo@1004 : Code[20];PurchCrMemoHdrNo@1005 :

    /*
    procedure TriggerOnAfterPostPurchaseDoc (var GenJnlPostLine: Codeunit 12;PurchRcpHdrNo: Code[20];RetShptHdrNo: Code[20];PurchInvHdrNo: Code[20];PurchCrMemoHdrNo: Code[20])
        var
    //       PurchPost@1000 :
          PurchPost: Codeunit 90;
        begin
          PurchPost.OnAfterPostPurchaseDoc(Rec,GenJnlPostLine,PurchRcpHdrNo,RetShptHdrNo,PurchInvHdrNo,PurchCrMemoHdrNo,FALSE);
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
          DeferralHeader.SETRANGE("Deferral Doc. Type",DeferralUtilities.GetPurchDeferralDocType);
          DeferralHeader.SETRANGE("Gen. Jnl. Template Name",'');
          DeferralHeader.SETRANGE("Gen. Jnl. Batch Name",'');
          DeferralHeader.SETRANGE("Document Type","Document Type");
          DeferralHeader.SETRANGE("Document No.","No.");
          exit(not DeferralHeader.ISEMPTY);
        end;
    */



    /*
    LOCAL procedure ConfirmUpdateDeferralDate ()
        begin
          if GetHideValidationDialog or not GUIALLOWED then
            Confirmed := TRUE
          else
            Confirmed := CONFIRM(DeferralLineQst,FALSE,FIELDCAPTION("Posting Date"));
          if Confirmed then
            UpdatePurchLinesByFieldNo(PurchLine.FIELDNO("Deferral Code"),FALSE);
        end;
    */




    /*
    procedure IsCreditDocType () : Boolean;
        var
    //       CreditDocType@1000 :
          CreditDocType: Boolean;
        begin
          CreditDocType := "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"];
          OnBeforeIsCreditDocType(Rec,CreditDocType);
          exit(CreditDocType);
        end;
    */




    /*
    procedure SetBuyFromVendorFromFilter ()
        var
    //       BuyFromVendorNo@1000 :
          BuyFromVendorNo: Code[20];
        begin
          BuyFromVendorNo := GetFilterVendNo;
          if BuyFromVendorNo = '' then begin
            FILTERGROUP(2);
            BuyFromVendorNo := GetFilterVendNo;
            FILTERGROUP(0);
          end;
          if BuyFromVendorNo <> '' then
            VALIDATE("Buy-from Vendor No.",BuyFromVendorNo);
        end;
    */




    /*
    procedure CopyBuyFromVendorFilter ()
        var
    //       BuyFromVendorFilter@1000 :
          BuyFromVendorFilter: Text;
        begin
          BuyFromVendorFilter := GETFILTER("Buy-from Vendor No.");
          if BuyFromVendorFilter <> '' then begin
            FILTERGROUP(2);
            SETFILTER("Buy-from Vendor No.",BuyFromVendorFilter);
            FILTERGROUP(0)
          end;
        end;
    */



    /*
    LOCAL procedure GetFilterVendNo () : Code[20];
        begin
          if GETFILTER("Buy-from Vendor No.") <> '' then
            if GETRANGEMIN("Buy-from Vendor No.") = GETRANGEMAX("Buy-from Vendor No.") then
              exit(GETRANGEMAX("Buy-from Vendor No."));
        end;
    */




    /*
    procedure HasBuyFromAddress () : Boolean;
        begin
          CASE TRUE OF
            "Buy-from Address" <> '':
              exit(TRUE);
            "Buy-from Address 2" <> '':
              exit(TRUE);
            "Buy-from City" <> '':
              exit(TRUE);
            "Buy-from Country/Region Code" <> '':
              exit(TRUE);
            "Buy-from County" <> '':
              exit(TRUE);
            "Buy-from Post Code" <> '':
              exit(TRUE);
            "Buy-from Contact" <> '':
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
    procedure HasPayToAddress () : Boolean;
        begin
          CASE TRUE OF
            "Pay-to Address" <> '':
              exit(TRUE);
            "Pay-to Address 2" <> '':
              exit(TRUE);
            "Pay-to City" <> '':
              exit(TRUE);
            "Pay-to Country/Region Code" <> '':
              exit(TRUE);
            "Pay-to County" <> '':
              exit(TRUE);
            "Pay-to Post Code" <> '':
              exit(TRUE);
            "Pay-to Contact" <> '':
              exit(TRUE);
          end;

          exit(FALSE);
        end;
    */



    /*
    LOCAL procedure HasItemChargeAssignment () : Boolean;
        var
    //       ItemChargeAssgntPurch@1000 :
          ItemChargeAssgntPurch: Record 5805;
        begin
          ItemChargeAssgntPurch.SETRANGE("Document Type","Document Type");
          ItemChargeAssgntPurch.SETRANGE("Document No.","No.");
          ItemChargeAssgntPurch.SETFILTER("Amount to Assign",'<>%1',0);
          exit(not ItemChargeAssgntPurch.ISEMPTY);
        end;
    */


    //     LOCAL procedure CopyBuyFromVendorAddressFieldsFromVendor (var BuyFromVendor@1000 : Record 23;ForceCopy@1001 :

    /*
    LOCAL procedure CopyBuyFromVendorAddressFieldsFromVendor (var BuyFromVendor: Record 23;ForceCopy: Boolean)
        begin
          if BuyFromVendorIsReplaced or ShouldCopyAddressFromBuyFromVendor(BuyFromVendor) or ForceCopy then begin
            "Buy-from Address" := BuyFromVendor.Address;
            "Buy-from Address 2" := BuyFromVendor."Address 2";
            "Buy-from City" := BuyFromVendor.City;
            "Buy-from Post Code" := BuyFromVendor."Post Code";
            "Buy-from County" := BuyFromVendor.County;
            "Buy-from Country/Region Code" := BuyFromVendor."Country/Region Code";
            OnAfterCopyBuyFromVendorAddressFieldsFromVendor(Rec,BuyFromVendor);
          end;
        end;
    */


    //     LOCAL procedure CopyShipToVendorAddressFieldsFromVendor (var BuyFromVendor@1000 : Record 23;ForceCopy@1001 :

    /*
    LOCAL procedure CopyShipToVendorAddressFieldsFromVendor (var BuyFromVendor: Record 23;ForceCopy: Boolean)
        begin
          if BuyFromVendorIsReplaced or (not HasShipToAddress) or ForceCopy then begin
            "Ship-to Address" := BuyFromVendor.Address;
            "Ship-to Address 2" := BuyFromVendor."Address 2";
            "Ship-to City" := BuyFromVendor.City;
            "Ship-to Post Code" := BuyFromVendor."Post Code";
            "Ship-to County" := BuyFromVendor.County;
            VALIDATE("Ship-to Country/Region Code",BuyFromVendor."Country/Region Code");
            OnAfterCopyShipToVendorAddressFieldsFromVendor(Rec,BuyFromVendor);
          end;
        end;
    */


    //     LOCAL procedure CopyPayToVendorAddressFieldsFromVendor (var PayToVendor@1000 : Record 23;ForceCopy@1001 :

    /*
    LOCAL procedure CopyPayToVendorAddressFieldsFromVendor (var PayToVendor: Record 23;ForceCopy: Boolean)
        begin
          if PayToVendorIsReplaced or ShouldCopyAddressFromPayToVendor(PayToVendor) or ForceCopy then begin
            "Pay-to Address" := PayToVendor.Address;
            "Pay-to Address 2" := PayToVendor."Address 2";
            "Pay-to City" := PayToVendor.City;
            "Pay-to Post Code" := PayToVendor."Post Code";
            "Pay-to County" := PayToVendor.County;
            "Pay-to Country/Region Code" := PayToVendor."Country/Region Code";
            OnAfterCopyPayToVendorAddressFieldsFromVendor(Rec,PayToVendor);
          end;
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


    //     LOCAL procedure ShouldCopyAddressFromBuyFromVendor (BuyFromVendor@1000 :

    /*
    LOCAL procedure ShouldCopyAddressFromBuyFromVendor (BuyFromVendor: Record 23) : Boolean;
        begin
          exit((not HasBuyFromAddress) and BuyFromVendor.HasAddress);
        end;
    */


    //     LOCAL procedure ShouldCopyAddressFromPayToVendor (PayToVendor@1000 :

    /*
    LOCAL procedure ShouldCopyAddressFromPayToVendor (PayToVendor: Record 23) : Boolean;
        begin
          exit((not HasPayToAddress) and PayToVendor.HasAddress);
        end;
    */


    //     LOCAL procedure ShouldLookForVendorByName (VendorNo@1000 :

    /*
    LOCAL procedure ShouldLookForVendorByName (VendorNo: Code[20]) : Boolean;
        var
    //       Vendor@1001 :
          Vendor: Record 23;
        begin
          if VendorNo = '' then
            exit(TRUE);

          if not Vendor.GET(VendorNo) then
            exit(TRUE);

          exit(not Vendor."Disable Search by Name");
        end;
    */



    /*
    LOCAL procedure BuyFromVendorIsReplaced () : Boolean;
        begin
          exit((xRec."Buy-from Vendor No." <> '') and (xRec."Buy-from Vendor No." <> "Buy-from Vendor No."));
        end;
    */



    /*
    LOCAL procedure PayToVendorIsReplaced () : Boolean;
        begin
          exit((xRec."Pay-to Vendor No." <> '') and (xRec."Pay-to Vendor No." <> "Pay-to Vendor No."));
        end;
    */


    //     LOCAL procedure UpdatePayToAddressFromBuyFromAddress (FieldNumber@1000 :

    /*
    LOCAL procedure UpdatePayToAddressFromBuyFromAddress (FieldNumber: Integer)
        begin
          if ("Order Address Code" = '') and PayToAddressEqualsOldBuyFromAddress then
            CASE FieldNumber OF
              FIELDNO("Pay-to Address"):
                if xRec."Buy-from Address" = "Pay-to Address" then
                  "Pay-to Address" := "Buy-from Address";
              FIELDNO("Pay-to Address 2"):
                if xRec."Buy-from Address 2" = "Pay-to Address 2" then
                  "Pay-to Address 2" := "Buy-from Address 2";
              FIELDNO("Pay-to City"), FIELDNO("Pay-to Post Code"):
                begin
                  if xRec."Buy-from City" = "Pay-to City" then
                    "Pay-to City" := "Buy-from City";
                  if xRec."Buy-from Post Code" = "Pay-to Post Code" then
                    "Pay-to Post Code" := "Buy-from Post Code";
                  if xRec."Buy-from County" = "Pay-to County" then
                    "Pay-to County" := "Buy-from County";
                  if xRec."Buy-from Country/Region Code" = "Pay-to Country/Region Code" then
                    "Pay-to Country/Region Code" := "Buy-from Country/Region Code";
                end;
              FIELDNO("Pay-to County"):
                if xRec."Buy-from County" = "Pay-to County" then
                  "Pay-to County" := "Buy-from County";
              FIELDNO("Pay-to Country/Region Code"):
                if  xRec."Buy-from Country/Region Code" = "Pay-to Country/Region Code" then
                  "Pay-to Country/Region Code" := "Buy-from Country/Region Code";
            end;
        end;
    */



    /*
    LOCAL procedure PayToAddressEqualsOldBuyFromAddress () : Boolean;
        begin
          if (xRec."Buy-from Address" = "Pay-to Address") and
             (xRec."Buy-from Address 2" = "Pay-to Address 2") and
             (xRec."Buy-from City" = "Pay-to City") and
             (xRec."Buy-from County" = "Pay-to County") and
             (xRec."Buy-from Post Code" = "Pay-to Post Code") and
             (xRec."Buy-from Country/Region Code" = "Pay-to Country/Region Code")
          then
            exit(TRUE);
        end;
    */




    /*
    procedure ConfirmCloseUnposted () : Boolean;
        var
    //       InstructionMgt@1000 :
          InstructionMgt: Codeunit 1330;
        begin
          if PurchLinesExist then
            if InstructionMgt.IsUnpostedEnabledForRecord(Rec) then
              exit(InstructionMgt.ShowConfirm(DocumentNotPostedClosePageQst,InstructionMgt.QueryPostOnCloseCode));
          exit(TRUE)
        end;
    */



    //     procedure InitFromPurchHeader (SourcePurchHeader@1000 :

    /*
    procedure InitFromPurchHeader (SourcePurchHeader: Record 38)
        begin
          "Document Date" := SourcePurchHeader."Document Date";
          "Expected Receipt Date" := SourcePurchHeader."Expected Receipt Date";
          "Shortcut Dimension 1 Code" := SourcePurchHeader."Shortcut Dimension 1 Code";
          "Shortcut Dimension 2 Code" := SourcePurchHeader."Shortcut Dimension 2 Code";
          "Dimension Set ID" := SourcePurchHeader."Dimension Set ID";
          "Location Code" := SourcePurchHeader."Location Code";
          SetShipToAddress(
            SourcePurchHeader."Ship-to Name",SourcePurchHeader."Ship-to Name 2",SourcePurchHeader."Ship-to Address",
            SourcePurchHeader."Ship-to Address 2",SourcePurchHeader."Ship-to City",SourcePurchHeader."Ship-to Post Code",
            SourcePurchHeader."Ship-to County",SourcePurchHeader."Ship-to Country/Region Code");
          "Ship-to Contact" := SourcePurchHeader."Ship-to Contact";
        end;
    */


    //     LOCAL procedure InitFromVendor (VendorNo@1000 : Code[20];VendorCaption@1001 :

    /*
    LOCAL procedure InitFromVendor (VendorNo: Code[20];VendorCaption: Text) : Boolean;
        begin
          PurchLine.SETRANGE("Document Type","Document Type");
          PurchLine.SETRANGE("Document No.","No.");
          if VendorNo = '' then begin
            if not PurchLine.ISEMPTY then
              ERROR(Text005,VendorCaption);
            INIT;
            PurchSetup.GET;
            "No. Series" := xRec."No. Series";
            InitRecord;
            InitNoSeries;
            exit(TRUE);
          end;
        end;
    */


    //     LOCAL procedure InitFromContact (ContactNo@1000 : Code[20];VendorNo@1001 : Code[20];ContactCaption@1002 :

    /*
    LOCAL procedure InitFromContact (ContactNo: Code[20];VendorNo: Code[20];ContactCaption: Text) : Boolean;
        begin
          PurchLine.SETRANGE("Document Type","Document Type");
          PurchLine.SETRANGE("Document No.","No.");
          if (ContactNo = '') and (VendorNo = '') then begin
            if not PurchLine.ISEMPTY then
              ERROR(Text005,ContactCaption);
            INIT;
            PurchSetup.GET;
            "No. Series" := xRec."No. Series";
            InitRecord;
            InitNoSeries;
            exit(TRUE);
          end;
        end;
    */


    //     LOCAL procedure LookupContact (VendorNo@1000 : Code[20];ContactNo@1003 : Code[20];var Contact@1001 :

    /*
    LOCAL procedure LookupContact (VendorNo: Code[20];ContactNo: Code[20];var Contact: Record 5050)
        var
    //       ContactBusinessRelation@1002 :
          ContactBusinessRelation: Record 5054;
        begin
          if ContactBusinessRelation.FindByRelation(ContactBusinessRelation."Link to Table"::Vendor,VendorNo) then
            Contact.SETRANGE("Company No.",ContactBusinessRelation."Contact No.")
          else
            Contact.SETRANGE("Company No.",'');
          if ContactNo <> '' then
            if Contact.GET(ContactNo) then ;
        end;
    */




    /*
    procedure SendRecords ()
        var
    //       DocumentSendingProfile@1000 :
          DocumentSendingProfile: Record 60;
    //       ReportSelections@1001 :
          ReportSelections: Record 77;
    //       DocTxt@1002 :
          DocTxt: Text[150];
        begin
          CheckMixedDropShipment;

          GetReportSelectionsUsageFromDocumentType(ReportSelections.Usage,DocTxt);

          DocumentSendingProfile.SendVendorRecords(
            ReportSelections.Usage,Rec,DocTxt,"Buy-from Vendor No.","No.",
            FIELDNO("Buy-from Vendor No."),FIELDNO("No."));
        end;
    */



    //     procedure PrintRecords (ShowRequestForm@1002 :

    /*
    procedure PrintRecords (ShowRequestForm: Boolean)
        var
    //       DocumentSendingProfile@1001 :
          DocumentSendingProfile: Record 60;
    //       DummyReportSelections@1000 :
          DummyReportSelections: Record 77;
        begin
          CheckMixedDropShipment;

          DocumentSendingProfile.TrySendToPrinterVendor(
            DummyReportSelections.Usage::"P.Order",Rec,FIELDNO("Buy-from Vendor No."),ShowRequestForm);
        end;
    */



    //     procedure SendProfile (var DocumentSendingProfile@1000 :

    /*
    procedure SendProfile (var DocumentSendingProfile: Record 60)
        var
    //       DummyReportSelections@1001 :
          DummyReportSelections: Record 77;
        begin
          CheckMixedDropShipment;

          DocumentSendingProfile.SendVendor(
            DummyReportSelections.Usage::"P.Order",Rec,"No.","Buy-from Vendor No.",
            PurchOrderDocTxt,FIELDNO("Buy-from Vendor No."),FIELDNO("No."));
        end;
    */



    /*
    LOCAL procedure CheckMixedDropShipment ()
        begin
          if HasMixedDropShipment then
            ERROR(MixedDropshipmentErr);
        end;
    */



    /*
    LOCAL procedure HasMixedDropShipment () : Boolean;
        var
    //       PurchaseLine@1000 :
          PurchaseLine: Record 39;
    //       HasDropShipmentLines@1001 :
          HasDropShipmentLines: Boolean;
        begin
          PurchaseLine.SETRANGE("Document Type","Document Type");
          PurchaseLine.SETRANGE("Document No.","No.");
          PurchaseLine.SETFILTER("No.",'<>%1','');
          PurchaseLine.SETFILTER(Type,'%1|%2',PurchaseLine.Type::Item,PurchaseLine.Type::"Fixed Asset");
          PurchaseLine.SETRANGE("Drop Shipment",TRUE);

          HasDropShipmentLines := not PurchaseLine.ISEMPTY;

          PurchaseLine.SETRANGE("Drop Shipment",FALSE);

          exit(HasDropShipmentLines and not PurchaseLine.ISEMPTY);
        end;
    */



    /*
    LOCAL procedure SetDefaultPurchaser ()
        var
    //       UserSetup@1000 :
          UserSetup: Record 91;
        begin
          if not UserSetup.GET(USERID) then
            exit;

          if UserSetup."Salespers./Purch. Code" <> '' then
            if SalespersonPurchaser.GET(UserSetup."Salespers./Purch. Code") then
              if not SalespersonPurchaser.VerifySalesPersonPurchaserPrivacyBlocked(SalespersonPurchaser) then
                VALIDATE("Purchaser Code",UserSetup."Salespers./Purch. Code");
        end;
    */



    //     procedure OnAfterValidateBuyFromVendorNo (var PurchaseHeader@1000 : Record 38;var xPurchaseHeader@1001 :

    /*
    procedure OnAfterValidateBuyFromVendorNo (var PurchaseHeader: Record 38;var xPurchaseHeader: Record 38)
        begin
          if PurchaseHeader.GETFILTER("Buy-from Vendor No.") = xPurchaseHeader."Buy-from Vendor No." then
            if PurchaseHeader."Buy-from Vendor No." <> xPurchaseHeader."Buy-from Vendor No." then
              PurchaseHeader.SETRANGE("Buy-from Vendor No.");
        end;
    */



    //     procedure BatchConfirmUpdateDeferralDate (var BatchConfirm@1000 : ' ,Skip,Update';ReplacePostingDate@1001 : Boolean;PostingDateReq@1002 :

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
              UpdatePurchLinesByFieldNo(PurchLine.FIELDNO("Deferral Code"),FALSE);
          end;
          COMMIT;
        end;
    */




    /*
    procedure SetAllowSelectNoSeries ()
        begin
          SelectNoSeriesAllowed := TRUE;
        end;
    */



    /*
    LOCAL procedure ModifyPayToVendorAddress ()
        var
    //       Vendor@1000 :
          Vendor: Record 23;
        begin
          PurchSetup.GET;
          if PurchSetup."Ignore Updated Addresses" then
            exit;
          if IsCreditDocType then
            exit;
          if ("Pay-to Vendor No." <> "Buy-from Vendor No.") and Vendor.GET("Pay-to Vendor No.") then
            if HasPayToAddress and HasDifferentPayToAddress(Vendor) then
              ShowModifyAddressNotification(GetModifyPayToVendorAddressNotificationId,
                ModifyVendorAddressNotificationLbl,ModifyVendorAddressNotificationMsg,
                'CopyPayToVendorAddressFieldsFromSalesDocument',"Pay-to Vendor No.",
                "Pay-to Name",FIELDNAME("Pay-to Vendor No."));
        end;
    */



    /*
    LOCAL procedure ModifyVendorAddress ()
        var
    //       Vendor@1000 :
          Vendor: Record 23;
        begin
          PurchSetup.GET;
          if PurchSetup."Ignore Updated Addresses" then
            exit;
          if IsCreditDocType then
            exit;
          if Vendor.GET("Buy-from Vendor No.") and HasBuyFromAddress and HasDifferentBuyFromAddress(Vendor) then
            ShowModifyAddressNotification(GetModifyVendorAddressNotificationId,
              ModifyVendorAddressNotificationLbl,ModifyVendorAddressNotificationMsg,
              'CopyBuyFromVendorAddressFieldsFromSalesDocument',"Buy-from Vendor No.",
              "Buy-from Vendor Name",FIELDNAME("Buy-from Vendor No."));
        end;
    */


    //     LOCAL procedure ShowModifyAddressNotification (NotificationID@1001 : GUID;NotificationLbl@1004 : Text;NotificationMsg@1005 : Text;NotificationFunctionTok@1006 : Text;VendorNumber@1002 : Code[20];VendorName@1003 : Text[50];VendorNumberFieldName@1008 :

    /*
    LOCAL procedure ShowModifyAddressNotification (NotificationID: GUID;NotificationLbl: Text;NotificationMsg: Text;NotificationFunctionTok: Text;VendorNumber: Code[20];VendorName: Text[50];VendorNumberFieldName: Text)
        var
    //       MyNotifications@1009 :
          MyNotifications: Record 1518;
    //       NotificationLifecycleMgt@1007 :
          NotificationLifecycleMgt: Codeunit 1511;
    //       ModifyVendorAddressNotification@1000 :
          ModifyVendorAddressNotification: Notification;
        begin
          if not MyNotifications.IsEnabled(NotificationID) then
            exit;

          ModifyVendorAddressNotification.ID := NotificationID;
          ModifyVendorAddressNotification.MESSAGE := STRSUBSTNO(NotificationMsg,VendorName);
          ModifyVendorAddressNotification.ADDACTION(NotificationLbl,CODEUNIT::"Document Notifications",NotificationFunctionTok);
          ModifyVendorAddressNotification.ADDACTION(
            DontShowAgainActionLbl,CODEUNIT::"Document Notifications",'HidePurchaseNotificationForCurrentUser');
          ModifyVendorAddressNotification.SCOPE := NOTIFICATIONSCOPE::LocalScope;
          ModifyVendorAddressNotification.SETDATA(FIELDNAME("Document Type"),FORMAT("Document Type"));
          ModifyVendorAddressNotification.SETDATA(FIELDNAME("No."),"No.");
          ModifyVendorAddressNotification.SETDATA(VendorNumberFieldName,VendorNumber);
          NotificationLifecycleMgt.SendNotification(ModifyVendorAddressNotification,RECORDID);
        end;
    */



    //     procedure RecallModifyAddressNotification (NotificationID@1001 :

    /*
    procedure RecallModifyAddressNotification (NotificationID: GUID)
        var
    //       MyNotifications@1002 :
          MyNotifications: Record 1518;
    //       ModifyVendorAddressNotification@1000 :
          ModifyVendorAddressNotification: Notification;
        begin
          if IsCreditDocType or (not MyNotifications.IsEnabled(NotificationID)) then
            exit;
          ModifyVendorAddressNotification.ID := NotificationID;
          ModifyVendorAddressNotification.RECALL;
        end;
    */




    /*
    procedure GetModifyVendorAddressNotificationId () : GUID;
        begin
          exit('CF3D0CD3-C54A-47D1-8A3F-57A6CCBA8DDE');
        end;
    */




    /*
    procedure GetModifyPayToVendorAddressNotificationId () : GUID;
        begin
          exit('16E45B3A-CB9F-4B2C-9F08-2BCE39E9E980');
        end;
    */




    /*
    procedure GetShowExternalDocAlreadyExistNotificationId () : GUID;
        begin
          exit('D87F624C-D3BE-4E6B-A369-D18AE269181A');
        end;
    */




    /*
    procedure GetLineInvoiceDiscountResetNotificationId () : GUID;
        begin
          exit('3DC9C8BC-0512-4A49-B587-256C308EBCAA');
        end;
    */



    /*
    LOCAL procedure UpdateInboundWhseHandlingTime ()
        begin
          if "Location Code" = '' then begin
            if InvtSetup.GET then
              "Inbound Whse. Handling Time" := InvtSetup."Inbound Whse. Handling Time";
          end else begin
            if Location.GET("Location Code") then;
            "Inbound Whse. Handling Time" := Location."Inbound Whse. Handling Time";
          end;
        end;
    */




    /*
    procedure SetModifyVendorAddressNotificationDefaultState ()
        var
    //       MyNotifications@1000 :
          MyNotifications: Record 1518;
        begin
          MyNotifications.InsertDefault(GetModifyVendorAddressNotificationId,
            ModifyBuyFromVendorAddressNotificationNameTxt,ModifyBuyFromVendorAddressNotificationDescriptionTxt,TRUE);
        end;
    */




    /*
    procedure SetModifyPayToVendorAddressNotificationDefaultState ()
        var
    //       MyNotifications@1000 :
          MyNotifications: Record 1518;
        begin
          MyNotifications.InsertDefault(GetModifyPayToVendorAddressNotificationId,
            ModifyPayToVendorAddressNotificationNameTxt,ModifyPayToVendorAddressNotificationDescriptionTxt,TRUE);
        end;
    */



    //     procedure SetShowExternalDocAlreadyExistNotificationDefaultState (DefaultState@1001 :

    /*
    procedure SetShowExternalDocAlreadyExistNotificationDefaultState (DefaultState: Boolean)
        var
    //       MyNotifications@1000 :
          MyNotifications: Record 1518;
        begin
          MyNotifications.InsertDefault(GetShowExternalDocAlreadyExistNotificationId,
            ShowDocAlreadyExistNotificationNameTxt,ShowDocAlreadyExistNotificationDescriptionTxt,DefaultState);
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
              GetModifyVendorAddressNotificationId:
                MyNotifications.InsertDefault(NotificationID,ModifyBuyFromVendorAddressNotificationNameTxt,
                  ModifyBuyFromVendorAddressNotificationDescriptionTxt,FALSE);
              GetModifyPayToVendorAddressNotificationId:
                MyNotifications.InsertDefault(NotificationID,ModifyPayToVendorAddressNotificationNameTxt,
                  ModifyPayToVendorAddressNotificationDescriptionTxt,FALSE);
            end;
        end;
    */


    //     LOCAL procedure HasDifferentBuyFromAddress (Vendor@1000 :

    /*
    LOCAL procedure HasDifferentBuyFromAddress (Vendor: Record 23) : Boolean;
        begin
          exit(("Buy-from Address" <> Vendor.Address) or
            ("Buy-from Address 2" <> Vendor."Address 2") or
            ("Buy-from City" <> Vendor.City) or
            ("Buy-from Country/Region Code" <> Vendor."Country/Region Code") or
            ("Buy-from County" <> Vendor.County) or
            ("Buy-from Post Code" <> Vendor."Post Code") or
            ("Buy-from Contact" <> Vendor.Contact));
        end;
    */


    //     LOCAL procedure HasDifferentPayToAddress (Vendor@1000 :

    /*
    LOCAL procedure HasDifferentPayToAddress (Vendor: Record 23) : Boolean;
        begin
          exit(("Pay-to Address" <> Vendor.Address) or
            ("Pay-to Address 2" <> Vendor."Address 2") or
            ("Pay-to City" <> Vendor.City) or
            ("Pay-to Country/Region Code" <> Vendor."Country/Region Code") or
            ("Pay-to County" <> Vendor.County) or
            ("Pay-to Post Code" <> Vendor."Post Code") or
            ("Pay-to Contact" <> Vendor.Contact));
        end;
    */


    //     LOCAL procedure FindPostedDocumentWithSameExternalDocNo (var VendorLedgerEntry@1000 : Record 25;ExternalDocumentNo@1001 :

    /*
    LOCAL procedure FindPostedDocumentWithSameExternalDocNo (var VendorLedgerEntry: Record 25;ExternalDocumentNo: Code[35]) : Boolean;
        var
    //       VendorMgt@1002 :
          VendorMgt: Codeunit 1312;
        begin
          VendorMgt.SetFilterForExternalDocNo(
            VendorLedgerEntry,GetGenJnlDocumentType,ExternalDocumentNo,"Pay-to Vendor No.","Document Date");
          exit(VendorLedgerEntry.FINDFIRST);
        end;
    */




    /*
    procedure FilterPartialReceived ()
        var
    //       PurchaseHeaderOriginal@1000 :
          PurchaseHeaderOriginal: Record 38;
    //       ReceiveFilter@1004 :
          ReceiveFilter: Text;
    //       IsMarked@1003 :
          IsMarked: Boolean;
    //       ReceiveValue@1001 :
          ReceiveValue: Boolean;
        begin
          ReceiveFilter := GETFILTER(Receive);
          SETRANGE(Receive);
          EVALUATE(ReceiveValue,ReceiveFilter);

          PurchaseHeaderOriginal := Rec;
          if FINDSET then
            repeat
              if not HasReceivedLines then
                IsMarked := not ReceiveValue
              else
                IsMarked := ReceiveValue;
              MARK(IsMarked);
            until NEXT = 0;

          Rec := PurchaseHeaderOriginal;
          MARKEDONLY(TRUE);
        end;
    */




    /*
    procedure FilterPartialInvoiced ()
        var
    //       PurchaseHeaderOriginal@1000 :
          PurchaseHeaderOriginal: Record 38;
    //       InvoiceFilter@1004 :
          InvoiceFilter: Text;
    //       IsMarked@1003 :
          IsMarked: Boolean;
    //       InvoiceValue@1001 :
          InvoiceValue: Boolean;
        begin
          InvoiceFilter := GETFILTER(Invoice);
          SETRANGE(Invoice);
          EVALUATE(InvoiceValue,InvoiceFilter);

          PurchaseHeaderOriginal := Rec;
          if FINDSET then
            repeat
              if not HasInvoicedLines then
                IsMarked := not InvoiceValue
              else
                IsMarked := InvoiceValue;
              MARK(IsMarked);
            until NEXT = 0;

          Rec := PurchaseHeaderOriginal;
          MARKEDONLY(TRUE);
        end;
    */



    /*
    LOCAL procedure HasReceivedLines () : Boolean;
        var
    //       PurchaseLine@1002 :
          PurchaseLine: Record 39;
        begin
          PurchaseLine.SETRANGE("Document Type","Document Type");
          PurchaseLine.SETRANGE("Document No.","No.");
          PurchaseLine.SETFILTER("No.",'<>%1','');
          PurchaseLine.SETFILTER("Quantity Received",'<>%1',0);
          exit(not PurchaseLine.ISEMPTY);
        end;
    */



    /*
    LOCAL procedure HasInvoicedLines () : Boolean;
        var
    //       PurchaseLine@1002 :
          PurchaseLine: Record 39;
        begin
          PurchaseLine.SETRANGE("Document Type","Document Type");
          PurchaseLine.SETRANGE("Document No.","No.");
          PurchaseLine.SETFILTER("No.",'<>%1','');
          PurchaseLine.SETFILTER("Quantity Invoiced",'<>%1',0);
          exit(not PurchaseLine.ISEMPTY);
        end;
    */


    //     LOCAL procedure ShowExternalDocAlreadyExistNotification (VendorLedgerEntry@1000 :

    /*
    LOCAL procedure ShowExternalDocAlreadyExistNotification (VendorLedgerEntry: Record 25)
        var
    //       NotificationLifecycleMgt@1002 :
          NotificationLifecycleMgt: Codeunit 1511;
    //       DocAlreadyExistNotification@1001 :
          DocAlreadyExistNotification: Notification;
        begin
          if not IsDocAlreadyExistNotificationEnabled then
            exit;

          DocAlreadyExistNotification.ID := GetShowExternalDocAlreadyExistNotificationId;
          DocAlreadyExistNotification.MESSAGE :=
            STRSUBSTNO(PurchaseAlreadyExistsTxt,VendorLedgerEntry."Document Type",VendorLedgerEntry."External Document No.");
          DocAlreadyExistNotification.ADDACTION(ShowVendLedgEntryTxt,CODEUNIT::"Document Notifications",'ShowVendorLedgerEntry');
          DocAlreadyExistNotification.SCOPE := NOTIFICATIONSCOPE::LocalScope;
          DocAlreadyExistNotification.SETDATA(FIELDNAME("Document Type"),FORMAT("Document Type"));
          DocAlreadyExistNotification.SETDATA(FIELDNAME("No."),"No.");
          DocAlreadyExistNotification.SETDATA(VendorLedgerEntry.FIELDNAME("Entry No."),FORMAT(VendorLedgerEntry."Entry No."));
          NotificationLifecycleMgt.SendNotificationWithAdditionalContext(
            DocAlreadyExistNotification,RECORDID,GetShowExternalDocAlreadyExistNotificationId);
        end;
    */



    /*
    LOCAL procedure GetGenJnlDocumentType () : Integer;
        var
    //       RefGenJournalLine@1000 :
          RefGenJournalLine: Record 81;
        begin
          CASE "Document Type" OF
            "Document Type"::"Blanket Order",
            "Document Type"::Quote,
            "Document Type"::Invoice,
            "Document Type"::Order:
              exit(RefGenJournalLine."Document Type"::Invoice);
            else
              exit(RefGenJournalLine."Document Type"::"Credit Memo");
          end;
        end;
    */



    /*
    LOCAL procedure RecallExternalDocAlreadyExistsNotification ()
        var
    //       NotificationLifecycleMgt@1000 :
          NotificationLifecycleMgt: Codeunit 1511;
        begin
          if not IsDocAlreadyExistNotificationEnabled then
            exit;

          NotificationLifecycleMgt.RecallNotificationsForRecordWithAdditionalContext(
            RECORDID,GetShowExternalDocAlreadyExistNotificationId,TRUE);
        end;
    */



    /*
    LOCAL procedure IsDocAlreadyExistNotificationEnabled () : Boolean;
        var
    //       InstructionMgt@1000 :
          InstructionMgt: Codeunit 1330;
        begin
          exit(InstructionMgt.IsMyNotificationEnabled(GetShowExternalDocAlreadyExistNotificationId));
        end;
    */




    /*
    procedure ShipToAddressEqualsCompanyShipToAddress () : Boolean;
        var
    //       CompanyInformation@1000 :
          CompanyInformation: Record 79;
        begin
          CompanyInformation.GET;
          exit(IsShipToAddressEqualToCompanyShipToAddress(Rec,CompanyInformation));
        end;
    */


    //     LOCAL procedure IsShipToAddressEqualToCompanyShipToAddress (PurchaseHeader@1000 : Record 38;CompanyInformation@1001 :

    /*
    LOCAL procedure IsShipToAddressEqualToCompanyShipToAddress (PurchaseHeader: Record 38;CompanyInformation: Record 79) : Boolean;
        begin
          exit(
            (PurchaseHeader."Ship-to Address" = CompanyInformation."Ship-to Address") and
            (PurchaseHeader."Ship-to Address 2" = CompanyInformation."Ship-to Address 2") and
            (PurchaseHeader."Ship-to City" = CompanyInformation."Ship-to City") and
            (PurchaseHeader."Ship-to County" = CompanyInformation."Ship-to County") and
            (PurchaseHeader."Ship-to Post Code" = CompanyInformation."Ship-to Post Code") and
            (PurchaseHeader."Ship-to Country/Region Code" = CompanyInformation."Ship-to Country/Region Code") and
            (PurchaseHeader."Ship-to Name" = CompanyInformation."Ship-to Name"));
        end;
    */




    /*
    procedure BuyFromAddressEqualsShipToAddress () : Boolean;
        begin
          exit(
            ("Ship-to Address" = "Buy-from Address") and
            ("Ship-to Address 2" = "Buy-from Address 2") and
            ("Ship-to City" = "Buy-from City") and
            ("Ship-to County" = "Buy-from County") and
            ("Ship-to Post Code" = "Buy-from Post Code") and
            ("Ship-to Country/Region Code" = "Buy-from Country/Region Code") and
            ("Ship-to Name" = "Buy-from Vendor Name"));
        end;
    */




    /*
    procedure BuyFromAddressEqualsPayToAddress () : Boolean;
        begin
          exit(
            ("Pay-to Address" = "Buy-from Address") and
            ("Pay-to Address 2" = "Buy-from Address 2") and
            ("Pay-to City" = "Buy-from City") and
            ("Pay-to County" = "Buy-from County") and
            ("Pay-to Post Code" = "Buy-from Post Code") and
            ("Pay-to Country/Region Code" = "Buy-from Country/Region Code") and
            ("Pay-to Contact No." = "Buy-from Contact No.") and
            ("Pay-to Contact" = "Buy-from Contact"));
        end;
    */


    //     LOCAL procedure SetPurchaserCode (PurchaserCodeToCheck@1000 : Code[20];var PurchaserCodeToAssign@1001 :

    /*
    LOCAL procedure SetPurchaserCode (PurchaserCodeToCheck: Code[20];var PurchaserCodeToAssign: Code[20])
        begin
          if PurchaserCodeToCheck <> '' then begin
            if SalespersonPurchaser.GET(PurchaserCodeToCheck) then
              if SalespersonPurchaser.VerifySalesPersonPurchaserPrivacyBlocked(SalespersonPurchaser) then
                PurchaserCodeToAssign := ''
              else
                PurchaserCodeToAssign := PurchaserCodeToCheck;
          end else
            PurchaserCodeToAssign := '';
        end;
    */



    //     procedure ValidatePurchaserOnPurchHeader (PurchaseHeader2@1000 : Record 38;IsTransaction@1001 : Boolean;IsPostAction@1002 :

    /*
    procedure ValidatePurchaserOnPurchHeader (PurchaseHeader2: Record 38;IsTransaction: Boolean;IsPostAction: Boolean)
        begin
          if PurchaseHeader2."Purchaser Code" <> '' then
            if SalespersonPurchaser.GET(PurchaseHeader2."Purchaser Code") then
              if SalespersonPurchaser.VerifySalesPersonPurchaserPrivacyBlocked(SalespersonPurchaser) then begin
                if IsTransaction then
                  ERROR(SalespersonPurchaser.GetPrivacyBlockedTransactionText(SalespersonPurchaser,IsPostAction,FALSE));
                if not IsTransaction then
                  ERROR(SalespersonPurchaser.GetPrivacyBlockedGenericText(SalespersonPurchaser,FALSE));
              end;
        end;
    */


    //     LOCAL procedure GetReportSelectionsUsageFromDocumentType (var ReportSelectionsUsage@1000 : Option;var DocTxt@1001 :

    /*
    LOCAL procedure GetReportSelectionsUsageFromDocumentType (var ReportSelectionsUsage: Option;var DocTxt: Text[150])
        var
    //       ReportSelections@1002 :
          ReportSelections: Record 77;
        begin
          CASE "Document Type" OF
            "Document Type"::Order:
              begin
                ReportSelectionsUsage := ReportSelections.Usage::"P.Order";
                DocTxt := PurchOrderDocTxt;
              end;
            "Document Type"::Quote:
              begin
                ReportSelectionsUsage := ReportSelections.Usage::"P.Quote";
                DocTxt := PurchQuoteDocTxt;
              end;
          end;
        end;
    */



    /*
    LOCAL procedure RevertCurrencyCodeAndPostingDate ()
        begin
          "Currency Code" := xRec."Currency Code";
          "Posting Date" := xRec."Posting Date";
          MODIFY;
        end;
    */



    /*
    LOCAL procedure ValidateEmptySellToCustomerAndLocation ()
        begin
          VALIDATE("Sell-to Customer No.",'');
          if "Buy-from Vendor No." <> '' then
            GetVend("Buy-from Vendor No.");
          VALIDATE("Location Code",UserSetupMgt.GetLocation(1,Vend."Location Code","Responsibility Center"));
        end;
    */




    /*
    procedure CheckForBlockedLines ()
        var
    //       CurrentPurchLine@1001 :
          CurrentPurchLine: Record 39;
    //       Item@1000 :
          Item: Record 27;
        begin
          CurrentPurchLine.SETCURRENTKEY("Document Type","Document No.",Type);
          CurrentPurchLine.SETRANGE("Document Type","Document Type");
          CurrentPurchLine.SETRANGE("Document No.","No.");
          CurrentPurchLine.SETRANGE(Type,CurrentPurchLine.Type::Item);
          CurrentPurchLine.SETFILTER("No.",'<>''''');

          if CurrentPurchLine.FINDSET then
            repeat
              Item.GET(CurrentPurchLine."No.");
              Item.TESTFIELD(Blocked,FALSE);
            until CurrentPurchLine.NEXT = 0;
        end;
    */



    //     LOCAL procedure OnAfterInitRecord (var PurchHeader@1000 :


    LOCAL procedure OnAfterInitRecord(var PurchHeader: Record 38)
    begin
    end;




    //     LOCAL procedure OnAfterInitNoSeries (var PurchHeader@1000 :

    /*
    LOCAL procedure OnAfterInitNoSeries (var PurchHeader: Record 38)
        begin
        end;
    */



    //     LOCAL procedure OnAfterChangePricesIncludingVAT (var PurchaseHeader@1000 :

    /*
    LOCAL procedure OnAfterChangePricesIncludingVAT (var PurchaseHeader: Record 38)
        begin
        end;
    */



    //     LOCAL procedure OnAfterConfirmPurchPrice (var PurchaseHeader@1000 : Record 38;var PurchaseLine@1001 : Record 39;var RecalculateLines@1002 :

    /*
    LOCAL procedure OnAfterConfirmPurchPrice (var PurchaseHeader: Record 38;var PurchaseLine: Record 39;var RecalculateLines: Boolean)
        begin
        end;
    */



    //     LOCAL procedure OnAfterCopyBuyFromVendorFieldsFromVendor (var PurchaseHeader@1000 : Record 38;Vendor@1001 :

    /*
    LOCAL procedure OnAfterCopyBuyFromVendorFieldsFromVendor (var PurchaseHeader: Record 38;Vendor: Record 23)
        begin
        end;
    */



    //     LOCAL procedure OnAfterCopyBuyFromVendorAddressFieldsFromVendor (var PurchaseHeader@1000 : Record 38;BuyFromVendor@1001 :

    /*
    LOCAL procedure OnAfterCopyBuyFromVendorAddressFieldsFromVendor (var PurchaseHeader: Record 38;BuyFromVendor: Record 23)
        begin
        end;
    */



    //     LOCAL procedure OnAfterCopyPayToVendorAddressFieldsFromVendor (var PurchaseHeader@1000 : Record 38;PayToVendor@1001 :

    /*
    LOCAL procedure OnAfterCopyPayToVendorAddressFieldsFromVendor (var PurchaseHeader: Record 38;PayToVendor: Record 23)
        begin
        end;
    */



    //     LOCAL procedure OnAfterCopyShipToVendorAddressFieldsFromVendor (var PurchaseHeader@1000 : Record 38;BuyFromVendor@1001 :

    /*
    LOCAL procedure OnAfterCopyShipToVendorAddressFieldsFromVendor (var PurchaseHeader: Record 38;BuyFromVendor: Record 23)
        begin
        end;
    */



    //     LOCAL procedure OnAfterRecreatePurchLine (var PurchLine@1000 : Record 39;var TempPurchLine@1001 :

    /*
    LOCAL procedure OnAfterRecreatePurchLine (var PurchLine: Record 39;var TempPurchLine: Record 39 TEMPORARY)
        begin
        end;
    */




    /*
    LOCAL procedure OnAfterDeleteAllTempPurchLines ()
        begin
        end;
    */



    //     LOCAL procedure OnAfterGetNoSeriesCode (var PurchHeader@1000 : Record 38;PurchSetup@1001 : Record 312;var NoSeriesCode@1002 :

    /*
    LOCAL procedure OnAfterGetNoSeriesCode (var PurchHeader: Record 38;PurchSetup: Record 312;var NoSeriesCode: Code[20])
        begin
        end;
    */



    //     LOCAL procedure OnAfterGetPostingNoSeriesCode (PurchaseHeader@1000 : Record 38;var PostingNos@1001 :

    /*
    LOCAL procedure OnAfterGetPostingNoSeriesCode (PurchaseHeader: Record 38;var PostingNos: Code[20])
        begin
        end;
    */



    //     LOCAL procedure OnAfterGetPrepaymentPostingNoSeriesCode (PurchaseHeader@1000 : Record 38;var PostingNos@1001 :

    /*
    LOCAL procedure OnAfterGetPrepaymentPostingNoSeriesCode (PurchaseHeader: Record 38;var PostingNos: Code[20])
        begin
        end;
    */



    //     LOCAL procedure OnAfterSetShipToForSpecOrder (var PurchaseHeader@1000 :

    /*
    LOCAL procedure OnAfterSetShipToForSpecOrder (var PurchaseHeader: Record 38)
        begin
        end;
    */



    //     LOCAL procedure OnAfterTestNoSeries (var PurchHeader@1000 :

    /*
    LOCAL procedure OnAfterTestNoSeries (var PurchHeader: Record 38)
        begin
        end;
    */



    //     LOCAL procedure OnAfterUpdateBuyFromVend (var PurchaseHeader@1000 : Record 38;Contact@1001 :

    /*
    LOCAL procedure OnAfterUpdateBuyFromVend (var PurchaseHeader: Record 38;Contact: Record 5050)
        begin
        end;
    */



    //     LOCAL procedure OnAfterUpdateBuyFromCont (var PurchaseHeader@1000 : Record 38;Vendor@1001 : Record 23;Contact@1002 :

    /*
    LOCAL procedure OnAfterUpdateBuyFromCont (var PurchaseHeader: Record 38;Vendor: Record 23;Contact: Record 5050)
        begin
        end;
    */



    //     LOCAL procedure OnAfterUpdatePayToCont (var PurchaseHeader@1000 : Record 38;Vendor@1001 : Record 23;Contact@1002 :


    LOCAL procedure OnAfterUpdatePayToCont(var PurchaseHeader: Record 38; Vendor: Record 23; Contact: Record 5050)
    begin
    end;




    //     LOCAL procedure OnAfterUpdateShipToAddress (var PurchHeader@1000 :

    /*
    LOCAL procedure OnAfterUpdateShipToAddress (var PurchHeader: Record 38)
        begin
        end;
    */



    //     LOCAL procedure OnAfterUpdateCurrencyFactor (var PurchaseHeader@1000 : Record 38;HideValidationDialog@1001 :

    /*
    LOCAL procedure OnAfterUpdateCurrencyFactor (var PurchaseHeader: Record 38;HideValidationDialog: Boolean)
        begin
        end;
    */



    //     LOCAL procedure OnAfterAppliesToDocNoOnLookup (var PurchaseHeader@1000 : Record 38;VendorLedgerEntry@1001 :

    /*
    LOCAL procedure OnAfterAppliesToDocNoOnLookup (var PurchaseHeader: Record 38;VendorLedgerEntry: Record 25)
        begin
        end;
    */



    //     LOCAL procedure OnUpdatePurchLinesByChangedFieldName (PurchHeader@1000 : Record 38;var PurchLine@1001 : Record 39;ChangedFieldName@1002 :

    /*
    LOCAL procedure OnUpdatePurchLinesByChangedFieldName (PurchHeader: Record 38;var PurchLine: Record 39;ChangedFieldName: Text[100])
        begin
        end;
    */



    //     LOCAL procedure OnAfterCreateDimTableIDs (var PurchaseHeader@1000 : Record 38;FieldNo@1001 : Integer;var TableID@1003 : ARRAY [10] OF Integer;var No@1002 :

    /*
    LOCAL procedure OnAfterCreateDimTableIDs (var PurchaseHeader: Record 38;FieldNo: Integer;var TableID: ARRAY [10] OF Integer;var No: ARRAY [10] OF Code[20])
        begin
        end;
    */



    //     LOCAL procedure OnAfterValidateShortcutDimCode (var PurchHeader@1000 : Record 38;xPurchHeader@1001 : Record 38;FieldNumber@1003 : Integer;var ShortcutDimCode@1002 :

    /*
    LOCAL procedure OnAfterValidateShortcutDimCode (var PurchHeader: Record 38;xPurchHeader: Record 38;FieldNumber: Integer;var ShortcutDimCode: Code[20])
        begin
        end;
    */



    //     LOCAL procedure OnAfterTransferExtendedTextForPurchaseLineRecreation (var PurchLine@1000 :

    /*
    LOCAL procedure OnAfterTransferExtendedTextForPurchaseLineRecreation (var PurchLine: Record 39)
        begin
        end;

        [Integration(TRUE)]
    */

    //     procedure OnValidatePurchaseHeaderPayToVendorNo (Vendor@1214 :

    /*
    procedure OnValidatePurchaseHeaderPayToVendorNo (Vendor: Record 23)
        begin
        end;
    */



    //     LOCAL procedure OnBeforeIsCreditDocType (PurchaseHeader@1000 : Record 38;var CreditDocType@1001 :

    /*
    LOCAL procedure OnBeforeIsCreditDocType (PurchaseHeader: Record 38;var CreditDocType: Boolean)
        begin
        end;
    */



    //     LOCAL procedure OnBeforeUpdateCurrencyFactor (var PurchaseHeader@1000 : Record 38;var Updated@1001 :

    /*
    LOCAL procedure OnBeforeUpdateCurrencyFactor (var PurchaseHeader: Record 38;var Updated: Boolean)
        begin
        end;
    */



    //     LOCAL procedure OnBeforeRecreatePurchLines (var PurchHeader@1000 :

    /*
    LOCAL procedure OnBeforeRecreatePurchLines (var PurchHeader: Record 38)
        begin
        end;
    */



    //     LOCAL procedure OnRecreatePurchLinesOnAfterValidateType (var PurchaseLine@1000 : Record 39;TempPurchaseLine@1001 :

    /*
    LOCAL procedure OnRecreatePurchLinesOnAfterValidateType (var PurchaseLine: Record 39;TempPurchaseLine: Record 39 TEMPORARY)
        begin
        end;
    */



    //     LOCAL procedure OnRecreatePurchLinesOnBeforeInsertPurchLine (var PurchaseLine@1000 : Record 39;var TempPurchaseLine@1001 :

    /*
    LOCAL procedure OnRecreatePurchLinesOnBeforeInsertPurchLine (var PurchaseLine: Record 39;var TempPurchaseLine: Record 39 TEMPORARY)
        begin
        end;
    */



    //     LOCAL procedure OnRecreatePurchLinesOnBeforeTempPurchLineInsert (var TempPurchaseLine@1000 : TEMPORARY Record 39;PurchaseLine@1001 :

    /*
    LOCAL procedure OnRecreatePurchLinesOnBeforeTempPurchLineInsert (var TempPurchaseLine: Record 39 TEMPORARY;PurchaseLine: Record 39)
        begin
        end;
    */



    //     LOCAL procedure OnValidateBuyFromVendorNoBeforeRecreateLines (var PurchaseHeader@1000 : Record 38;FieldNo@1001 :

    /*
    LOCAL procedure OnValidateBuyFromVendorNoBeforeRecreateLines (var PurchaseHeader: Record 38;FieldNo: Integer)
        begin
        end;
    */



    //     LOCAL procedure OnValidatePaytoVendorNoBeforeRecreateLines (var PurchaseHeader@1001 : Record 38;FieldNo@1000 :

    /*
    LOCAL procedure OnValidatePaytoVendorNoBeforeRecreateLines (var PurchaseHeader: Record 38;FieldNo: Integer)
        begin
        end;
    */



    //     LOCAL procedure OnRecreatePurchLinesOnBeforeConfirm (var PurchaseHeader@1000 : Record 38;xPurchaseHeader@1001 : Record 38;ChangedFieldName@1002 : Text[100];HideValidationDialog@1003 : Boolean;var Confirmed@1004 : Boolean;var IsHandled@1005 :

    /*
    LOCAL procedure OnRecreatePurchLinesOnBeforeConfirm (var PurchaseHeader: Record 38;xPurchaseHeader: Record 38;ChangedFieldName: Text[100];HideValidationDialog: Boolean;var Confirmed: Boolean;var IsHandled: Boolean)
        begin
        end;
    */



    //     LOCAL procedure OnAfterUpdatePurchLines (var PurchaseHeader@1000 :

    /*
    LOCAL procedure OnAfterUpdatePurchLines (var PurchaseHeader: Record 38)
        begin
        end;

        /*begin
        //{
    //      PEL 13/06/18: - QB2395 Se crea nuevos campo --> Eliminado con las nuevas aprobaciones
    //      PEL 19/03/19: - OBR. Creados campos de Obralia
    //      JAV 15/06/19: - Se a�ade el campo de pedido a cancelar, para el control de contratos
    //      JAV 01/07/19: - N�mero de serie de registro de FRI por proyecto
    //      JAV 03/07/19: - Poner doc externo y nombre del proveedor en la descripci�n del registro
    //      JAV 04/07/19: - Se a�ade el campo de fecha operaci�n SII
    //      JAV 04/07/19: - La fecha del documento no puede ser nunca mayor a la de registro
    //      QCPM_GAP18 >>
    //      JAV 03/09/19: - Para poder cambiar el proveedor, elimino la l�nea de la retenci�n antes de regenerar l�neas y paso el c�lculo del validate del proveedor de pago al de venta
    //      JAV 23/10/19: - Se doblan los campos de la retenci�n de B.E. para tener ambos importes disponibles
    //                    - Se cambian los eventos a la CU de retenciones
    //      JAV 01/11/19: - Si cambia el proyecto en la cabecera, preguntar si se quiere cambiar en las l�neas
    //                    - Se a�ade la funci�n ChangeJobFromLine para cambiar el proyecto desde las l�neas
    //      JAV 12/11/19: - Se cambia el table relation del campo "Activity code"
    //      JAV 08/01/20: - ROIG_CYS GAP12 Se a�aden los campos 50007 "Receipt Date" y 50008 "Total document amount"
    //      JAV 04/02/20: - Si la anterior fecha estaba en blanco y la fecha de documento no, no cambia esta.
    //                    - Si no hay fecha de registro, no dar el error de fecha del documento
    //                    - Se cambia la fecha de base para el c�lculo del vencimiento por el nuevo par�metro, usando una funci�n que nos la retorna
    //      JAV 13/02/20: - Se reduce el campo "Succeeded Company Name" de 250 a 50 pues no hay sitio en la tabla
    //      QuoSII_1.1 - 16/08/2017 - Se modifican los campos 7174332 y 7174334. Se elimina el campo 7174333
    //                              - Se modifica el trigger Buy-from Vendor No. - OnValidate() para que inicialice el campo "Purch. Invoice Type" siempre a F1 si el tipo es LF
    //      QuoSII_1.3.03.006 21/11/17 MCM - Se incluye el campo para importarlo como Fecha de Registro contable
    //      QuoSII1.4 23/04/18 PEL - A�adido valor LC al campo Purch. Inv Type
    //                             - Cambiado primer semestre en Purch. Invoice Type, Purch. Invoice Type 1 y Purch. Invoice Type 2
    //                             - Al validar Buy-from Vendor No. inicializar Purch. Special Regimen si fecha reg es anterior a fecha incl SII
    //      QuoSII1.4 23/04/18 PEL - Nuevas validaciones en Special Regiments
    //      QuoSII_1.4.02.042 29/11/18 MCM - Se incluye la opci�n de enviar a la ATCN
    //      QuoSII_1.4.98.999 11/07/19 QMD - Filtros para la tabla SII Type List Value
    //      QuoSII_1.4.02.042.22 29/07/19 QMD - Bug_12510 - Abonos no trae el R�gimen configurado en el proveedor
    //      QuoSII_1.4.92.999 21/08/19 QMD - Controles del QuoSII en BBDD que no lo necesitan.
    //      Q12879 JDC 26/02/21 - Added field 7207320 "QB Prepayment", 7207321 "QB Prepmt. Pending Amt", 7207322 "QB Prepmt. Amt. to Apply", 7207323 "QB Prepmt. Description"
    //      JAV 06/07/21: - QB 1.09.04 Se elimina el c�digo del validate del campo QW Witholding Due Date, se pasa a un evento en la CU de retenciones
    //      JAV 16/07/21: - QB 1.09.06 Se traslada a la CU de Retenciones todas las acciones relacionadas con sus campos
    //      JAV 15/09/21: - QB 1.09.17 Se pasa el c�digo del validate del campo "QW Witholding Due Date" a la CU de manejo de tablas
    //
    //      QuoSII1.5z 15/09/21 JAV - Mejora en el manejo de los campos relacionados, se pasa todo el c�digo a la CU de manejo de objetos est�ndar del QuoSII
    //      QPR Q15434 MCM 15/10/21 - Se crea el campo QB Budget item
    //      JAV 21/01/22: - QB 1.10.11 Se eliminan campos relacionados con el contrato que no son utilizados en el programa para nada
    //      AML 22/03/22 QB_ST01: Se a�ade campo New_Functionality QB_ST01.
    //      JAV 11/05/22: - QuoSII 1.06.07 Se traspasa la funcionalidad a la cu 7174332 SII Procesing para unificar
    //      JAV 21/06/22: - DP 1.00.00 Se a�aden los campos para el manejo de la prorrata. Modificado a partir de MercaBarna DP04a, Q12228, CEI14253, Q13668, CEI14117
    //                                    7174360 "DP Force not Use Prorrata"
    //                                    7174361 "DP Apply Prorrata Type"
    //                                    7174362" DP Prorrata %"
    //                                    7174364 "DP Non Deductible VAT Amount"
    //                                    7174365 "DP Deductible VAT Amount"
    //      JAV 29/06/22: - QB 1.10.57 No se permite cambiar algunos campos si el documento no est� abierto
    //      JAV 30/06/22: - QB 1.10.57 Estaba mal el table relation del campo "QB Approval Budget item"
    //      JAV 04/08/22: - QB 1.11.01 Se cambia el caption del campo 7207285 "QB Contract"
    //      JAV 28/10/22: - QB 1.12.11 Solo si est� marcado el check de crear dimensi�n = Partida cambiar la dimensi�n CA pues van de la mano
    //      JJEP 19/04/2023: - Q19224 - COM034 - NOMBRE DE PROYECTO EN FICHAS DE COMPRAS
    //      Q19196 CSM 22/05/23 - IMP018 proveedores y clientes Varios. (B.S.)  NEW FIELD: 50004
    //      BS19798 CSM 20/10/23  � Campos filtrables �comentarios filtro� y �notas filtro�.  New Field: 50012. Modify Field: 46.
    //      BS::20087 CSM 09/11/23 � COM039 Env�o correo a proveedor Superaci�n Cr�dito M�ximo. New Fields: 50005, 50006.
    //      BS::19974 AML 21/11/23 - Creado cmpo "QW % Withholding by GE"
    //      BS::19888 CSM 27/11/23 � COM037 �ltima certificaci�n proveedor.  New Fields: 50007 y 50008.
    //    }
        end.
      */
}




