tableextension 50121 "MyExtension50121" extends "Gen. Journal Line"
{

    /*
  Permissions=TableData 112 r,
                  TableData 1221 rimd;
  */
    CaptionML = ENU = 'Gen. Journal Line', ESP = 'L�n. diario general';

    fields
    {
        field(50000; "Internal"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Internal', ESP = 'Interno';
            Description = '19975';


        }
        field(50013; "QW % Withholding by GE"; Decimal)
        {
            CaptionML = ENU = '% Withholding by G.E', ESP = '% retenci�n pago B.E.';
            Description = 'BS::19974';
            Editable = false;


        }
        field(50014; "QW % Withholding by Journal"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'BS::19974';


        }
        field(50015; "Ajuste Manual Ret"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'BS::19974';


        }
        field(50016; "With Approvals"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("Approval Entry" WHERE("Journal Template Name" = FIELD("Journal Template Name"),
                                                                                             "Journal Batch Name" = FIELD("Journal Batch Name"),
                                                                                             "Journal Line No." = FIELD("Line No.")));
            CaptionML = ENU = 'With Approvals', ESP = 'Con aprobaciones';
            Description = 'BS::20411';
            Editable = false;


        }
        field(50120; "Status"; Option)
        {
            OptionMembers = "Open","Released","Pending Approval","Canceled";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Status', ESP = 'Estado';
            OptionCaptionML = ENU = 'Open,Released,Pending Approval,Canceled', ESP = 'Abierto,Lanzado,Aprobaci�n pendiente,Cancelado';

            Description = 'BS::22309';
            Editable = false;


        }
        field(7174331; "QuoSII Auto Posting Date"; Date)
        {
            CaptionML = ENU = 'SII Auto Posting Date', ESP = 'SII Fecha Registro Auto';
            Description = 'QuoSII_1.3.03.006';


        }
        field(7174332; "QuoSII Sales Invoice Type QS"; Code[20])
        {
            TableRelation = "SII Type List Value"."Code" WHERE("Type" = CONST("SalesInvType"),
                                                                                                   "SII Entity" = FIELD("QuoSII Entity"));


            CaptionML = ENU = 'Invoice Type', ESP = 'Tipo Factura';
            Description = 'QuoSII';

            trigger OnValidate();
            VAR
                //                                                                 Text7174332@1100286000 :
                Text7174332: TextConst ENU = 'No puede introducir un valor en el campo %1 cuando el campo %2 es %3.';
            BEGIN
                IF "Account Type" = "Account Type"::Customer THEN BEGIN
                    //QuoSII.2_4.begin 
                    IF NOT ("Document Type" IN ["Document Type"::" ", "Document Type"::Invoice, "Document Type"::"Credit Memo"]) THEN
                        //QuoSII.2_4.end
                        ERROR(Text7174332, FIELDCAPTION("QuoSII Sales Invoice Type QS"), FIELDCAPTION("Document Type"), "Document Type");
                END ELSE
                    ERROR(Text7174332, FIELDCAPTION("QuoSII Sales Invoice Type QS"), FIELDCAPTION("Account Type"), "Account Type");
            END;


        }
        field(7174333; "QuoSII Sales Cor. Invoice Type"; Code[20])
        {
            TableRelation = "SII Type List Value"."Code" WHERE("Type" = CONST("SalesInvType"),
                                                                                                   "SII Entity" = FIELD("QuoSII Entity"));


            CaptionML = ENU = 'Corrected Invoice Type', ESP = 'Tipo Factura Rectificativa';
            Description = 'QuoSII';

            trigger OnValidate();
            VAR
                //                                                                 Text7174332@1100286000 :
                Text7174332: TextConst ENU = 'No puede introducir un valor en el campo %1 cuando el campo %2 es %3.';
            BEGIN
                //QuoSII.2_4.begin 
                IF "Account Type" <> "Account Type"::Customer THEN
                    //QuoSII.2_4.end
                    ERROR(Text7174332, FIELDCAPTION("QuoSII Sales Cor. Invoice Type"), FIELDCAPTION("Account Type"), "Account Type");
            END;


        }
        field(7174334; "QuoSII Sales Cr.Memo Type"; Code[20])
        {
            TableRelation = "SII Type List Value"."Code" WHERE("Type" = CONST("CorrectedInvType"),
                                                                                                   "SII Entity" = FIELD("QuoSII Entity"));


            CaptionML = ENU = 'Cr.Memo Type', ESP = 'Tipo Abono';
            Description = 'QuoSII';

            trigger OnValidate();
            VAR
                //                                                                 Text7174332@1100286001 :
                Text7174332: TextConst ENU = 'No puede introducir un valor en el campo %1 cuando el campo %2 es %3.';
                //                                                                 Text7174338@1100286000 :
                Text7174338: TextConst ENU = 'No se permite el tipo %1 para el tipo de documento %2.';
            BEGIN
                IF "Account Type" = "Account Type"::Customer THEN BEGIN
                    //QuoSII.2_4.begin 
                    IF ("Document Type" = "Document Type"::"Credit Memo") AND ("QuoSII Sales Cr.Memo Type" = 'S') THEN
                        ERROR(Text7174338, "QuoSII Sales Cr.Memo Type", "Document Type");
                    //QuoSII.2_4.end
                END ELSE
                    ERROR(Text7174332, FIELDCAPTION("QuoSII Sales Cr.Memo Type"), FIELDCAPTION("Account Type"), "Account Type");
            END;


        }
        field(7174335; "QuoSII Sales Special Regimen"; Code[20])
        {
            TableRelation = "SII Type List Value"."Code" WHERE("Type" = CONST("KeySpecialSalesInv"),
                                                                                                   "SII Entity" = FIELD("QuoSII Entity"));


            CaptionML = ENU = 'Special Regimen', ESP = 'R�gimen Especial';
            Description = 'QuoSII';

            trigger OnValidate();
            VAR
                //                                                                 Text7174332@1100286000 :
                Text7174332: TextConst ENU = 'No puede introducir un valor en el campo %1 cuando el campo %2 es %3.';
            BEGIN
                IF "Account Type" = "Account Type"::Customer THEN BEGIN
                    //QuoSII.2_4.begin 
                    IF NOT ("Document Type" IN ["Document Type"::" ", "Document Type"::Invoice, "Document Type"::"Credit Memo", "Document Type"::Payment]) THEN
                        //QuoSII.2_4.end
                        ERROR(Text7174332, FIELDCAPTION("QuoSII Sales Special Regimen"), FIELDCAPTION("Document Type"), "Document Type");
                END ELSE
                    ERROR(Text7174332, FIELDCAPTION("QuoSII Sales Special Regimen"), FIELDCAPTION("Account Type"), "Account Type");
            END;


        }
        field(7174336; "QuoSII Purch. Invoice Type QS"; Code[20])
        {
            TableRelation = "SII Type List Value"."Code" WHERE("Type" = CONST("PurchInvType"),
                                                                                                   "SII Entity" = FIELD("QuoSII Entity"));
            CaptionML = ENU = 'Invoice Type', ESP = 'Tipo Factura';
            Description = 'QuoSII';


        }
        field(7174337; "QuoSII Purch. Cor. Inv. Type"; Code[20])
        {
            TableRelation = "SII Type List Value"."Code" WHERE("Type" = CONST("PurchInvType"),
                                                                                                   "SII Entity" = FIELD("QuoSII Entity"));


            CaptionML = ENU = 'Corrected Invoice Type', ESP = 'Tipo Factura Rectificativa';
            Description = 'QuoSII';

            trigger OnValidate();
            VAR
                //                                                                 Text7174332@1100286000 :
                Text7174332: TextConst ENU = 'No puede introducir un valor en el campo %1 cuando el campo %2 es %3.';
            BEGIN
                //QuoSII.2_4.begin 
                IF "Account Type" <> "Account Type"::Vendor THEN
                    //QuoSII.2_4.end
                    ERROR(Text7174332, FIELDCAPTION("QuoSII Purch. Cor. Inv. Type"), FIELDCAPTION("Account Type"), "Account Type");
            END;


        }
        field(7174338; "QuoSII Purch. Cr.Memo Type"; Code[20])
        {
            TableRelation = "SII Type List Value"."Code" WHERE("Type" = CONST("CorrectedInvType"),
                                                                                                   "SII Entity" = FIELD("QuoSII Entity"));


            CaptionML = ENU = 'Cr. Memo Type', ESP = 'Tipo Abono';
            Description = 'QuoSII';

            trigger OnValidate();
            VAR
                //                                                                 Text7174332@1100286001 :
                Text7174332: TextConst ENU = 'No puede introducir un valor en el campo %1 cuando el campo %2 es %3.';
                //                                                                 Text7174338@1100286000 :
                Text7174338: TextConst ENU = 'No se permite el tipo %1 para el tipo de documento %2.';
            BEGIN
                IF "Account Type" = "Account Type"::Vendor THEN BEGIN
                    //QuoSII.2_4.begin 
                    IF ("Document Type" = "Document Type"::"Credit Memo") AND ("QuoSII Purch. Cr.Memo Type" = 'S') THEN
                        ERROR(Text7174338, "QuoSII Purch. Cr.Memo Type", "Document Type");
                    //QuoSII.2_4.end
                END ELSE
                    ERROR(Text7174332, FIELDCAPTION("QuoSII Purch. Cr.Memo Type"), FIELDCAPTION("Account Type"), "Account Type");
            END;


        }
        field(7174339; "QuoSII Purch. Special Regimen"; Code[20])
        {
            TableRelation = "SII Type List Value"."Code" WHERE("Type" = CONST("KeySpecialPurchInv"),
                                                                                                   "SII Entity" = FIELD("QuoSII Entity"));


            CaptionML = ENU = 'Special Regimen', ESP = 'R�gimen Especial';
            Description = 'QuoSII';

            trigger OnValidate();
            VAR
                //                                                                 Text7174332@1100286000 :
                Text7174332: TextConst ENU = 'No puede introducir un valor en el campo %1 cuando el campo %2 es %3.';
            BEGIN
                IF "Account Type" = "Account Type"::Vendor THEN BEGIN
                    //QuoSII.2_4.begin 
                    IF NOT ("Document Type" IN ["Document Type"::" ", "Document Type"::Invoice, "Document Type"::"Credit Memo", "Document Type"::Payment]) THEN
                        //QuoSII.2_4.end
                        ERROR(Text7174332, FIELDCAPTION("QuoSII Purch. Special Regimen"), FIELDCAPTION("Document Type"), "Document Type");
                END ELSE
                    ERROR(Text7174332, FIELDCAPTION("QuoSII Purch. Special Regimen"), FIELDCAPTION("Account Type"), "Account Type");
            END;


        }
        field(7174340; "QuoSII Sales UE Inv Type"; Code[20])
        {
            TableRelation = "SII Type List Value"."Code" WHERE("Type" = CONST("IntraKey"),
                                                                                                   "SII Entity" = FIELD("QuoSII Entity"));


            CaptionML = ENU = 'Sales UE Inv Type', ESP = 'Tipo Factura IntraComunitaria';
            Description = 'QuoSII';

            trigger OnValidate();
            VAR
                //                                                                 Customer@1100286000 :
                Customer: Record 18;
                //                                                                 CustomerPostGroup@1100286001 :
                CustomerPostGroup: Record 92;
                //                                                                 Text7174332@1100286002 :
                Text7174332: TextConst ENU = 'No puede introducir un valor en el campo %1 cuando el campo %2 es %3.';
                //                                                                 Text7174333@1100286003 :
                Text7174333: TextConst ENU = 'Solo se puede introducir un valor en el campo %1 si la factura es intracomunitaria.';
            BEGIN
                IF "Account Type" = "Account Type"::Customer THEN BEGIN
                    Customer.GET("Account No.");
                    CustomerPostGroup.RESET;
                    CustomerPostGroup.GET(Customer."Customer Posting Group");
                    IF "Document Type" <> "Document Type"::Invoice THEN
                        ERROR(Text7174332, FIELDCAPTION("QuoSII Sales Invoice Type QS"), FIELDCAPTION("Document Type"), "Document Type")
                    ELSE BEGIN
                        IF CustomerPostGroup."QuoSII Type" <> CustomerPostGroup."QuoSII Type"::OI THEN
                            ERROR(Text7174333, FIELDCAPTION("QuoSII Sales Invoice Type QS"));
                    END;
                END ELSE
                    ERROR(Text7174332, FIELDCAPTION("QuoSII Sales UE Inv Type"), FIELDCAPTION("Account Type"), "Account Type");
            END;


        }
        field(7174341; "QuoSII Purch. UE Inv Type"; Code[20])
        {
            TableRelation = "SII Type List Value"."Code" WHERE("Type" = CONST("IntraKey"),
                                                                                                   "SII Entity" = FIELD("QuoSII Entity"));


            CaptionML = ENU = 'Purch. UE Inv Type', ESP = 'Tipo Factura IntraComunitaria';
            Description = 'QuoSII';

            trigger OnValidate();
            VAR
                //                                                                 Text7174332@1100286001 :
                Text7174332: TextConst ENU = 'No puede introducir un valor en el campo %1 cuando el campo %2 es %3.';
                //                                                                 Text7174333@1100286000 :
                Text7174333: TextConst ENU = 'Solo se puede introducir un valor en el campo %1 si la factura es intracomunitaria.';
                //                                                                 Vendor@1100286002 :
                Vendor: Record 23;
                //                                                                 VendorPostGroup@1100286003 :
                VendorPostGroup: Record 93;
            BEGIN
                IF "Account Type" = "Account Type"::Vendor THEN BEGIN
                    Vendor.GET("Account No.");
                    VendorPostGroup.RESET;
                    VendorPostGroup.GET(Vendor."Vendor Posting Group");
                    IF "Document Type" <> "Document Type"::Invoice THEN
                        ERROR(Text7174332, FIELDCAPTION("QuoSII Purch. UE Inv Type"), FIELDCAPTION("Document Type"), "Document Type")
                    ELSE BEGIN
                        IF VendorPostGroup."QuoSII Type" <> VendorPostGroup."QuoSII Type"::OI THEN
                            ERROR(Text7174333, FIELDCAPTION("QuoSII Purch. UE Inv Type"));
                    END;
                END ELSE
                    ERROR(Text7174332, FIELDCAPTION("QuoSII Purch. UE Inv Type"), FIELDCAPTION("Account Type"), "Account Type");
            END;


        }
        field(7174342; "QuoSII Purch. Special Reg. 1"; Code[20])
        {
            TableRelation = IF ("QuoSII Sales Special Regimen" = FILTER(07)) "SII Type List Value"."Code" WHERE("Type" = CONST("KeySpecialSalesInv"), "SII Entity" = FIELD("QuoSII Entity"), "Code" = FILTER('01' | '03' | '05' | '09' | '11' | '12' | '13' | '14' | '15')) ELSE IF ("QuoSII Sales Special Regimen" = FILTER(05)) "SII Type List Value"."Code" WHERE("Type" = CONST("KeySpecialSalesInv"), "SII Entity" = FIELD("QuoSII Entity"), "Code" = FILTER('01' | '06' | '08' | '11' | '12' | '13')) ELSE IF ("QuoSII Sales Special Regimen" = FILTER(06)) "SII Type List Value"."Code" WHERE("Type" = CONST("KeySpecialSalesInv"), "SII Entity" = FIELD("QuoSII Entity"), "Code" = FILTER('05' | '11' | '12' | '13' | '14' | '15')) ELSE IF ("QuoSII Sales Special Regimen" = FILTER('11' | '12' | '13')) "SII Type List Value"."Code" WHERE("Type" = CONST("KeySpecialSalesInv"), "SII Entity" = FIELD("QuoSII Entity"), "Code" = FILTER('08' | '15')) ELSE IF ("QuoSII Sales Special Regimen" = FILTER(03)) "SII Type List Value"."Code" WHERE("Type" = CONST("KeySpecialSalesInv"), "SII Entity" = FIELD("QuoSII Entity"), "Code" = FILTER(01)) ELSE IF ("QuoSII Sales Special Regimen" = FILTER(01)) "SII Type List Value"."Code" WHERE("Type" = CONST("KeySpecialSalesInv"), "SII Entity" = FIELD("QuoSII Entity"), "Code" = FILTER('02' | '05' | '08'));


            CaptionML = ENU = 'Special Regimen 1', ESP = 'R�gimen Especial 1';
            Description = 'QuoSII';

            trigger OnValidate();
            BEGIN
                //QuoSII_1.4.98.999.begin 
                // //QuoSII_1.4.02.042.begin 
                // IF "Purch. Special Regimen" = '07' THEN BEGIN 
                //  IF ("Purch. Special Regimen 1" <> '') AND NOT ("Purch. Special Regimen 1" IN ['01','03','05','12']) THEN
                //    ERROR(Text7174333,Rec.FIELDCAPTION("Purch. Special Regimen 1"),'01','03','05','12');
                // END ELSE BEGIN 
                //  IF "Purch. Special Regimen" = '05' THEN BEGIN 
                //    IF ("Purch. Special Regimen 1" <> '') AND NOT ("Purch. Special Regimen 1" IN ['01','12','06','08']) THEN
                //      ERROR(Text7174333,Rec.FIELDCAPTION("Purch. Special Regimen 1"),'01','12','06','08');
                //  END ELSE BEGIN 
                //    IF "Purch. Special Regimen" = '12' THEN BEGIN 
                //      IF ("Purch. Special Regimen 1" <> '') AND NOT ("Purch. Special Regimen 1" = '08') THEN
                //        ERROR(Text7174334,Rec.FIELDCAPTION("Purch. Special Regimen 1"),'08');
                //    END ELSE BEGIN 
                //      IF "Purch. Special Regimen" = '06' THEN BEGIN 
                //        IF ("Purch. Special Regimen 1" <> '') AND ("Purch. Special Regimen 1" <> '12') THEN
                //          ERROR(Text7174331,Rec.FIELDCAPTION("Purch. Special Regimen 1"),'12');
                //      END ELSE BEGIN 
                //        IF "Purch. Special Regimen" IN ['03','08'] THEN BEGIN 
                //          IF ("Purch. Special Regimen 1" <> '') AND NOT ("Purch. Special Regimen 1" = '01') THEN
                //            ERROR(Text7174331,Rec.FIELDCAPTION("Purch. Special Regimen 1"),'01');
                //        END;
                //      END;
                //    END;
                //  END;
                // END;
                // //QuoSII_1.4.02.042.end
                //QuoSII_1.4.98.999.end
            END;


        }
        field(7174343; "QuoSII Purch. Special Reg. 2"; Code[20])
        {
            TableRelation = IF ("QuoSII Sales Special Regimen" = FILTER(07)) "SII Type List Value"."Code" WHERE("Type" = CONST("KeySpecialSalesInv"), "SII Entity" = FIELD("QuoSII Entity"), "Code" = FILTER('01' | '03' | '05' | '09' | '11' | '12' | '13' | '14' | '15')) ELSE IF ("QuoSII Sales Special Regimen" = FILTER(05)) "SII Type List Value"."Code" WHERE("Type" = CONST("KeySpecialSalesInv"), "SII Entity" = FIELD("QuoSII Entity"), "Code" = FILTER('01' | '06' | '08' | '11' | '12' | '13')) ELSE IF ("QuoSII Sales Special Regimen" = FILTER(06)) "SII Type List Value"."Code" WHERE("Type" = CONST("KeySpecialSalesInv"), "SII Entity" = FIELD("QuoSII Entity"), "Code" = FILTER('05' | '11' | '12' | '13' | '14' | '15')) ELSE IF ("QuoSII Sales Special Regimen" = FILTER('11' | '12' | '13')) "SII Type List Value"."Code" WHERE("Type" = CONST("KeySpecialSalesInv"), "SII Entity" = FIELD("QuoSII Entity"), "Code" = FILTER('08' | '15')) ELSE IF ("QuoSII Sales Special Regimen" = FILTER(03)) "SII Type List Value"."Code" WHERE("Type" = CONST("KeySpecialSalesInv"), "SII Entity" = FIELD("QuoSII Entity"), "Code" = FILTER(01)) ELSE IF ("QuoSII Sales Special Regimen" = FILTER(01)) "SII Type List Value"."Code" WHERE("Type" = CONST("KeySpecialSalesInv"), "SII Entity" = FIELD("QuoSII Entity"), "Code" = FILTER('02' | '05' | '08'));


            CaptionML = ENU = 'Special Regimen 2', ESP = 'R�gimen Especial 2';
            Description = 'QuoSII';

            trigger OnValidate();
            BEGIN
                //QuoSII_1.4.98.999.begin 
                // //QuoSII_1.4.02.042.begin 
                // IF "Purch. Special Regimen" = '07' THEN BEGIN 
                //  IF ("Purch. Special Regimen 2" <> '') AND NOT ("Purch. Special Regimen 2" IN ['01','03','05','12']) THEN
                //    ERROR(Text7174333,Rec.FIELDCAPTION("Purch. Special Regimen 2"),'01','03','05','12');
                // END ELSE BEGIN 
                //  IF "Purch. Special Regimen" = '05' THEN BEGIN 
                //    IF ("Purch. Special Regimen 2" <> '') AND NOT ("Purch. Special Regimen 2" IN ['01','12','06','08']) THEN
                //      ERROR(Text7174333,Rec.FIELDCAPTION("Purch. Special Regimen 2"),'01','12','06','08');
                //  END ELSE BEGIN 
                //    IF "Purch. Special Regimen" = '12' THEN BEGIN 
                //      IF ("Purch. Special Regimen 2" <> '') AND NOT ("Purch. Special Regimen 2" = '08') THEN
                //        ERROR(Text7174334,Rec.FIELDCAPTION("Purch. Special Regimen 2"),'08');
                //    END ELSE BEGIN 
                //      IF "Purch. Special Regimen" = '06' THEN BEGIN 
                //        IF ("Purch. Special Regimen 2" <> '') AND ("Purch. Special Regimen 2" <> '12') THEN
                //          ERROR(Text7174331,Rec.FIELDCAPTION("Purch. Special Regimen 2"),'12');
                //      END ELSE BEGIN 
                //        IF "Purch. Special Regimen" IN ['03','08'] THEN BEGIN 
                //          IF ("Purch. Special Regimen 2" <> '') AND NOT ("Purch. Special Regimen 2" = '01') THEN
                //            ERROR(Text7174331,Rec.FIELDCAPTION("Purch. Special Regimen 2"),'01');
                //        END;
                //      END;
                //    END;
                //  END;
                // END;
                // //QuoSII_1.4.02.042.end
                //QuoSII_1.4.98.999.end
            END;


        }
        field(7174344; "QuoSII Sales Special Regimen 1"; Code[20])
        {
            TableRelation = IF ("QuoSII Sales Special Regimen" = FILTER(07)) "SII Type List Value"."Code" WHERE("Type" = CONST("KeySpecialSalesInv"), "SII Entity" = FIELD("QuoSII Entity"), "Code" = FILTER('01' | '03' | '05' | '09' | '11' | '12' | '13' | '14' | '15')) ELSE IF ("QuoSII Sales Special Regimen" = FILTER(05)) "SII Type List Value"."Code" WHERE("Type" = CONST("KeySpecialSalesInv"), "SII Entity" = FIELD("QuoSII Entity"), "Code" = FILTER('01' | '06' | '08' | '11' | '12' | '13')) ELSE IF ("QuoSII Sales Special Regimen" = FILTER(06)) "SII Type List Value"."Code" WHERE("Type" = CONST("KeySpecialSalesInv"), "SII Entity" = FIELD("QuoSII Entity"), "Code" = FILTER('05' | '11' | '12' | '13' | '14' | '15')) ELSE IF ("QuoSII Sales Special Regimen" = FILTER('11' | '12' | '13')) "SII Type List Value"."Code" WHERE("Type" = CONST("KeySpecialSalesInv"), "SII Entity" = FIELD("QuoSII Entity"), "Code" = FILTER('08' | '15')) ELSE IF ("QuoSII Sales Special Regimen" = FILTER(03)) "SII Type List Value"."Code" WHERE("Type" = CONST("KeySpecialSalesInv"), "SII Entity" = FIELD("QuoSII Entity"), "Code" = FILTER(01)) ELSE IF ("QuoSII Sales Special Regimen" = FILTER(01)) "SII Type List Value"."Code" WHERE("Type" = CONST("KeySpecialSalesInv"), "SII Entity" = FIELD("QuoSII Entity"), "Code" = FILTER('02' | '05' | '08'));


            CaptionML = ENU = 'Special Regimen 1', ESP = 'R�gimen Especial 1';
            Description = 'QuoSII';

            trigger OnValidate();
            BEGIN
                //QuoSII_1.4.98.999.begin 
                // //QuoSII_1.4.02.042.begin 
                // IF "Sales Special Regimen" = '07' THEN BEGIN 
                //  IF ("Sales Special Regimen 1" <> '') AND NOT ("Sales Special Regimen 1" IN ['01','03','05','09','11','12','13','14','15']) THEN
                //    ERROR(Text7174331,Rec.FIELDCAPTION("Sales Special Regimen 1"),'01','03','05','09','11','12','13','14','15');
                // END ELSE BEGIN 
                //  IF "Sales Special Regimen" = '05' THEN BEGIN 
                //    IF ("Sales Special Regimen 1" <> '') AND NOT ("Sales Special Regimen 1" IN ['01','11','12','13','06','08']) THEN
                //      ERROR(Text7174336,Rec.FIELDCAPTION("Sales Special Regimen 1"),'01','11','12','13','06','08');
                //  END ELSE BEGIN 
                //    IF "Sales Special Regimen" = '06' THEN BEGIN 
                //      IF ("Sales Special Regimen 1" <> '') AND NOT ("Sales Special Regimen 1" IN ['11','12','13','14','15']) THEN
                //        ERROR(Text7174334,Rec.FIELDCAPTION("Sales Special Regimen 1"),'11','12','13','14','15');
                //    END ELSE BEGIN 
                //      IF "Sales Special Regimen" IN ['11','12','13'] THEN BEGIN 
                //        IF ("Sales Special Regimen 1" <> '') AND NOT ("Sales Special Regimen 1" IN ['08','15']) THEN
                //          ERROR(Text7174332,Rec.FIELDCAPTION("Sales Special Regimen 1"),'08','15');
                //      END ELSE BEGIN 
                //        IF "Sales Special Regimen" IN ['03','08'] THEN BEGIN 
                //          IF ("Sales Special Regimen 1" <> '') AND NOT ("Sales Special Regimen 1" ='01') THEN
                //            ERROR(Text7174337,Rec.FIELDCAPTION("Sales Special Regimen 1"),'01');
                //        END ELSE BEGIN 
                //          IF "Sales Special Regimen" = '01' THEN BEGIN 
                //            IF ("Sales Special Regimen 1" <> '') AND NOT ("Sales Special Regimen 1" = '02') THEN
                //              ERROR(Text7174337,Rec.FIELDCAPTION("Sales Special Regimen 1"),'02');
                //          END;
                //        END;
                //      END;
                //    END;
                //  END;
                // END;
                // //QuoSII_1.4.02.042.end
                //QuoSII_1.4.98.999.end
            END;


        }
        field(7174345; "QuoSII Sales Special Regimen 2"; Code[20])
        {
            TableRelation = IF ("QuoSII Sales Special Regimen" = FILTER(07)) "SII Type List Value"."Code" WHERE("Type" = CONST("KeySpecialSalesInv"), "SII Entity" = FIELD("QuoSII Entity"), "Code" = FILTER('01' | '03' | '05' | '09' | '11' | '12' | '13' | '14' | '15')) ELSE IF ("QuoSII Sales Special Regimen" = FILTER(05)) "SII Type List Value"."Code" WHERE("Type" = CONST("KeySpecialSalesInv"), "SII Entity" = FIELD("QuoSII Entity"), "Code" = FILTER('01' | '06' | '08' | '11' | '12' | '13')) ELSE IF ("QuoSII Sales Special Regimen" = FILTER(06)) "SII Type List Value"."Code" WHERE("Type" = CONST("KeySpecialSalesInv"), "SII Entity" = FIELD("QuoSII Entity"), "Code" = FILTER('05' | '11' | '12' | '13' | '14' | '15')) ELSE IF ("QuoSII Sales Special Regimen" = FILTER('11' | '12' | '13')) "SII Type List Value"."Code" WHERE("Type" = CONST("KeySpecialSalesInv"), "SII Entity" = FIELD("QuoSII Entity"), "Code" = FILTER('08' | '15')) ELSE IF ("QuoSII Sales Special Regimen" = FILTER(03)) "SII Type List Value"."Code" WHERE("Type" = CONST("KeySpecialSalesInv"), "SII Entity" = FIELD("QuoSII Entity"), "Code" = FILTER(01)) ELSE IF ("QuoSII Sales Special Regimen" = FILTER(01)) "SII Type List Value"."Code" WHERE("Type" = CONST("KeySpecialSalesInv"), "SII Entity" = FIELD("QuoSII Entity"), "Code" = FILTER('02' | '05' | '08'));


            CaptionML = ENU = 'Special Regimen 2', ESP = 'R�gimen Especial 2';
            Description = 'QuoSII';

            trigger OnValidate();
            BEGIN
                //QuoSII_1.4.98.999.begin 
                // //QuoSII_1.4.02.042.begin 
                // IF "Sales Special Regimen" = '07' THEN BEGIN 
                //  IF ("Sales Special Regimen 2" <> '') AND NOT ("Sales Special Regimen 2" IN ['01','03','05','09','11','12','13','14','15']) THEN
                //    ERROR(Text7174331,Rec.FIELDCAPTION("Sales Special Regimen 2"),'01','03','05','09','11','12','13','14','15');
                // END ELSE BEGIN 
                //  IF "Sales Special Regimen" = '05' THEN BEGIN 
                //    IF ("Sales Special Regimen 2" <> '') AND NOT ("Sales Special Regimen 2" IN ['01','11','12','13','06','08']) THEN
                //      ERROR(Text7174336,Rec.FIELDCAPTION("Sales Special Regimen 2"),'01','11','12','13','06','08');
                //  END ELSE BEGIN 
                //    IF "Sales Special Regimen" = '06' THEN BEGIN 
                //      IF ("Sales Special Regimen 2" <> '') AND NOT ("Sales Special Regimen 2" IN ['11','12','13','14','15']) THEN
                //        ERROR(Text7174334,Rec.FIELDCAPTION("Sales Special Regimen 2"),'11','12','13','14','15');
                //    END ELSE BEGIN 
                //      IF "Sales Special Regimen" IN ['11','12','13'] THEN BEGIN 
                //        IF ("Sales Special Regimen 2" <> '') AND NOT ("Sales Special Regimen 2" IN ['08','15']) THEN
                //          ERROR(Text7174332,Rec.FIELDCAPTION("Sales Special Regimen 2"),'08','15');
                //      END ELSE BEGIN 
                //        IF "Sales Special Regimen" IN ['03','08'] THEN BEGIN 
                //          IF ("Sales Special Regimen 2" <> '') AND NOT ("Sales Special Regimen 2" ='01') THEN
                //            ERROR(Text7174337,Rec.FIELDCAPTION("Sales Special Regimen 2"),'01');
                //        END ELSE BEGIN 
                //          IF "Sales Special Regimen" = '01' THEN BEGIN 
                //            IF ("Sales Special Regimen 2" <> '') AND NOT ("Sales Special Regimen 2" = '02') THEN
                //              ERROR(Text7174337,Rec.FIELDCAPTION("Sales Special Regimen 2"),'02');
                //          END;
                //        END;
                //      END;
                //    END;
                //  END;
                // END;
                // //QuoSII_1.4.02.042.end
                //QuoSII_1.4.98.999.end
            END;


        }
        field(7174346; "QuoSII Bienes Description"; Text[40])
        {


            CaptionML = ENU = 'Bienes Description', ESP = 'Descripci�n Bienes';
            Description = 'QuoSII';

            trigger OnValidate();
            VAR
                //                                                                 Vendor@1100286001 :
                Vendor: Record 23;
                //                                                                 VendorPostGroup@1100286000 :
                VendorPostGroup: Record 93;
                //                                                                 Text7174332@1100286003 :
                Text7174332: TextConst ENU = 'No puede introducir un valor en el campo %1 cuando el campo %2 es %3.';
                //                                                                 Text7174333@1100286002 :
                Text7174333: TextConst ENU = 'Solo se puede introducir un valor en el campo %1 si la factura es intracomunitaria.';
                //                                                                 Customer@1100286005 :
                Customer: Record 18;
                //                                                                 CustomerPostGroup@1100286004 :
                CustomerPostGroup: Record 92;
            BEGIN
                IF "Account Type" = "Account Type"::Vendor THEN BEGIN
                    Vendor.GET("Account No.");
                    VendorPostGroup.RESET;
                    VendorPostGroup.GET(Vendor."Vendor Posting Group");
                    IF "Document Type" <> "Document Type"::Invoice THEN
                        ERROR(Text7174332, FIELDCAPTION("QuoSII Purch. UE Inv Type"), FIELDCAPTION("Document Type"), "Document Type")
                    ELSE BEGIN
                        IF VendorPostGroup."QuoSII Type" <> VendorPostGroup."QuoSII Type"::OI THEN
                            ERROR(Text7174333, FIELDCAPTION("QuoSII Purch. UE Inv Type"));
                    END;
                END ELSE BEGIN
                    IF "Account Type" = "Account Type"::Customer THEN BEGIN
                        Customer.GET("Account No.");
                        CustomerPostGroup.RESET;
                        CustomerPostGroup.GET(Customer."Customer Posting Group");
                        IF "Document Type" <> "Document Type"::Invoice THEN
                            ERROR(Text7174332, FIELDCAPTION("QuoSII Purch. UE Inv Type"), FIELDCAPTION("Document Type"), "Document Type")
                        ELSE BEGIN
                            IF CustomerPostGroup."QuoSII Type" <> CustomerPostGroup."QuoSII Type"::OI THEN
                                ERROR(Text7174333, FIELDCAPTION("QuoSII Sales UE Inv Type"));
                        END;
                    END ELSE
                        ERROR(Text7174332, FIELDCAPTION("QuoSII Sales UE Inv Type"), FIELDCAPTION("Account Type"), "Account Type");
                END;
            END;


        }
        field(7174347; "QuoSII Operator Address"; Text[120])
        {


            CaptionML = ENU = 'Operator Address', ESP = 'Direcci�n Operador';
            Description = 'QuoSII Cambiado de 120 a 100';

            trigger OnValidate();
            VAR
                //                                                                 Vendor@1100286003 :
                Vendor: Record 23;
                //                                                                 VendorPostGroup@1100286002 :
                VendorPostGroup: Record 93;
                //                                                                 Customer@1100286001 :
                Customer: Record 18;
                //                                                                 CustomerPostGroup@1100286000 :
                CustomerPostGroup: Record 92;
                //                                                                 Text7174332@1100286005 :
                Text7174332: TextConst ENU = 'No puede introducir un valor en el campo %1 cuando el campo %2 es %3.';
                //                                                                 Text7174333@1100286004 :
                Text7174333: TextConst ENU = 'Solo se puede introducir un valor en el campo %1 si la factura es intracomunitaria.';
            BEGIN
                IF "Account Type" = "Account Type"::Vendor THEN BEGIN
                    Vendor.GET("Account No.");
                    VendorPostGroup.RESET;
                    VendorPostGroup.GET(Vendor."Vendor Posting Group");
                    IF "Document Type" <> "Document Type"::Invoice THEN
                        ERROR(Text7174332, FIELDCAPTION("QuoSII Operator Address"), FIELDCAPTION("Document Type"), "Document Type")
                    ELSE BEGIN
                        IF VendorPostGroup."QuoSII Type" <> VendorPostGroup."QuoSII Type"::OI THEN
                            ERROR(Text7174333, FIELDCAPTION("QuoSII Operator Address"));
                    END;
                END ELSE BEGIN
                    IF "Account Type" = "Account Type"::Customer THEN BEGIN
                        Customer.GET("Account No.");
                        CustomerPostGroup.RESET;
                        CustomerPostGroup.GET(Customer."Customer Posting Group");
                        IF "Document Type" <> "Document Type"::Invoice THEN
                            ERROR(Text7174332, FIELDCAPTION("QuoSII Operator Address"), FIELDCAPTION("Document Type"), "Document Type")
                        ELSE BEGIN
                            IF CustomerPostGroup."QuoSII Type" <> CustomerPostGroup."QuoSII Type"::OI THEN
                                ERROR(Text7174333, FIELDCAPTION("QuoSII Operator Address"));
                        END;
                    END ELSE
                        ERROR(Text7174332, FIELDCAPTION("QuoSII Operator Address"), FIELDCAPTION("Account Type"), "Account Type");
                END;
            END;


        }
        field(7174348; "QuoSII UE Country"; Code[10])
        {
            TableRelation = "Country/Region"."QuoSII Country Code";


            CaptionML = ENU = 'UE Country', ESP = 'Estado Miembro';
            Description = 'QuoSII';

            trigger OnValidate();
            VAR
                //                                                                 Text7174332@1100286001 :
                Text7174332: TextConst ENU = 'No puede introducir un valor en el campo %1 cuando el campo %2 es %3.';
                //                                                                 Text7174333@1100286000 :
                Text7174333: TextConst ENU = 'Solo se puede introducir un valor en el campo %1 si la factura es intracomunitaria.';
                //                                                                 Vendor@1100286005 :
                Vendor: Record 23;
                //                                                                 VendorPostGroup@1100286004 :
                VendorPostGroup: Record 93;
                //                                                                 Customer@1100286003 :
                Customer: Record 18;
                //                                                                 CustomerPostGroup@1100286002 :
                CustomerPostGroup: Record 92;
            BEGIN
                IF "Account Type" = "Account Type"::Vendor THEN BEGIN
                    Vendor.GET("Account No.");
                    VendorPostGroup.RESET;
                    VendorPostGroup.GET(Vendor."Vendor Posting Group");
                    IF "Document Type" <> "Document Type"::Invoice THEN
                        ERROR(Text7174332, FIELDCAPTION("QuoSII UE Country"), FIELDCAPTION("Document Type"), "Document Type")
                    ELSE BEGIN
                        IF VendorPostGroup."QuoSII Type" <> VendorPostGroup."QuoSII Type"::OI THEN
                            ERROR(Text7174333, FIELDCAPTION("QuoSII UE Country"));
                    END;
                END ELSE BEGIN
                    IF "Account Type" = "Account Type"::Customer THEN BEGIN
                        Customer.GET("Account No.");
                        CustomerPostGroup.RESET;
                        CustomerPostGroup.GET(Customer."Customer Posting Group");
                        IF "Document Type" <> "Document Type"::Invoice THEN
                            ERROR(Text7174332, FIELDCAPTION("QuoSII UE Country"), FIELDCAPTION("Document Type"), "Document Type")
                        ELSE BEGIN
                            IF CustomerPostGroup."QuoSII Type" <> CustomerPostGroup."QuoSII Type"::OI THEN
                                ERROR(Text7174333, FIELDCAPTION("QuoSII UE Country"));
                        END;
                    END ELSE
                        ERROR(Text7174332, FIELDCAPTION("QuoSII UE Country"), FIELDCAPTION("Account Type"), "Account Type");
                END;
            END;


        }
        field(7174349; "QuoSII Medio Cobro/Pago"; Code[20])
        {
            TableRelation = "SII Type List Value"."Code" WHERE("Type" = CONST("PaymentMethod"),
                                                                                                   "SII Entity" = FIELD("QuoSII Entity"));
            CaptionML = ENU = 'Receivable/Payment Method', ESP = 'Medio Cobro/Pago';
            Description = 'QuoSII';


        }
        field(7174350; "QuoSII Cuenta Medio Cobro/Pago"; Text[34])
        {
            CaptionML = ENU = 'Receivable/Payment Account', ESP = 'Cuenta Medio Cobro/Pago';
            Description = 'QuoSII';


        }
        field(7174351; "QuoSII Last Ticket No."; Code[20])
        {
            CaptionML = ENU = 'Last Ticket No.', ESP = '�ltimo N� Ticket';
            Description = 'QuoSII';


        }
        field(7174352; "QuoSII Purch. Third Party"; Boolean)
        {
            CaptionML = ENU = 'Third Party', ESP = 'Emitida por tercero';
            Description = 'QuoSII';


        }
        field(7174353; "QuoSII Sales Third Party"; Boolean)
        {
            CaptionML = ENU = 'Third Party', ESP = 'Emitida por tercero';
            Description = 'QuoSII';


        }
        field(7174354; "QuoSII Situacion Inmueble"; Code[2])
        {
            TableRelation = "SII Type List Value"."Code" WHERE("Type" = CONST("PropertyLocation"),
                                                                                                   "SII Entity" = FIELD("QuoSII Entity"));
            CaptionML = ENU = 'Property Situation', ESP = 'Situacion Inmueble';
            Description = 'QuoSII.007';


        }
        field(7174355; "QuoSII Referencia Catastral"; Code[25])
        {
            CaptionML = ENU = 'Cadastral Reference', ESP = 'Referencia Catastral';
            Description = 'QuoSII.007';


        }
        field(7174356; "QuoSII Payment Cash SII"; Boolean)
        {
            CaptionML = ENU = 'Payment Cash SII', ESP = 'Cobro Met�lico SII';
            Description = 'QuoSII_04';


        }
        field(7174357; "QuoSII First Ticket No."; Code[20])
        {
            CaptionML = ENU = 'First Ticket No.', ESP = 'Primer N� Ticket';
            Description = 'QuoSII';


        }
        field(7174358; "QuoSII Entity"; Code[20])
        {
            TableRelation = "SII Type List Value"."Code" WHERE("Type" = CONST("SIIEntity"),
                                                                                                   "SII Entity" = CONST(''));
            CaptionML = ENU = 'SII Entity', ESP = 'Entidad SII';
            Description = 'QuoSII_1.4.2.042';


        }
        field(7174390; "DP Original VAT Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Prorrata Orig. VAT Amount', ESP = 'Importe IVA Original Prorrata';
            Description = 'DP04';
            AutoFormatType = 1;
            AutoFormatExpression = "Currency Code";


        }
        field(7174391; "DP Non Deductible %"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = '% VAT non deductible', ESP = '% IVA no deducible';
            Description = 'DP04';


        }
        field(7174392; "DP Non Deductible Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Non Deductible VAT Amount', ESP = 'Importe IVA no deducible';
            Description = 'DP04';
            AutoFormatType = 1;
            AutoFormatExpression = "Currency Code";


        }
        field(7174393; "DP Prorrata Type"; Option)
        {
            OptionMembers = " ","Provisional","Definitiva";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Prorrata', ESP = 'Tipo de Prorrata';
            OptionCaptionML = ENU = '" ,Provisional,Final"', ESP = '" ,Provisional,Definitiva"';

            Description = 'DP04';


        }
        field(7174394; "DP Prov. Prorrata %"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Prov. Prorrata %', ESP = '% Prorrata provisional';
            BlankZero = true;
            Description = 'DP04';


        }
        field(7207270; "Piecework Code"; Code[20])
        {
            TableRelation = "Data Piecework For Production"."Piecework Code" WHERE("Job No." = FIELD("Job No."));


            CaptionML = ENU = 'No. Job Unit', ESP = 'N� unidad de obra';
            Description = 'QB22110,QB2713';

            trigger OnValidate();
            BEGIN
                //JAV 05/03/21: - QB 1.08.21 Esto revisa las dimensiones
                xRec."Job No." := '';
                VALIDATE("Job No.");
            END;


        }
        field(7207271; "Expense Note Code"; Code[20])
        {
            CaptionML = ENU = 'Expense Note Code', ESP = 'C�d. Nota gasto';
            Description = 'QB22110';
            Editable = false;


        }
        field(7207272; "QW Withholding Type"; Option)
        {
            OptionMembers = "G.E","PIT";
            CaptionML = ENU = 'Withholding Type', ESP = 'Tipo retenci�n';
            OptionCaptionML = ENU = 'G.E,PIT', ESP = 'B.E.,IRPF';

            Description = 'QB22111';


        }
        field(7207273; "QW Withholding Group"; Code[20])
        {
            TableRelation = IF ("QW Withholding Type" = CONST("G.E")) "Withholding Group".Code WHERE("Withholding Type" = FILTER("G.E")) ELSE IF ("QW Withholding Type" = CONST("PIT")) "Withholding Group".Code WHERE("Withholding Type" = FILTER("PIT"));
            CaptionML = ENU = 'Withholding Group', ESP = 'Grupo retenci�n';
            Description = 'QB22111';


        }
        field(7207274; "QW Withholding Due Date"; Date)
        {
            CaptionML = ENU = 'Due Date', ESP = 'Fecha Vto. Retenci�n';
            Description = 'QB22111';


        }
        field(7207275; "QW Withholding Base"; Decimal)
        {


            CaptionML = ENU = 'Withholding Base', ESP = 'Base retenci�n';
            Description = 'QB22111';
            AutoFormatType = 1;

            trigger OnValidate();
            BEGIN
                GetCurrency;
                IF "Currency Code" = '' THEN
                    "QW Withholding Base (LCY)" := "QW Withholding Base"
                ELSE
                    "QW Withholding Base (LCY)" := ROUND(CurrExchRate.ExchangeAmtFCYToLCY("Posting Date", "Currency Code", "QW Withholding Base", "Currency Factor"));
            END;


        }
        field(7207276; "QW Withholding Base (LCY)"; Decimal)
        {
            CaptionML = ENU = 'Withholding Base(LCY)', ESP = 'Base de retencion (DL)';
            Description = 'QB22111';


        }
        field(7207277; "QW Applies-to Withholding Doc."; Code[20])
        {
            CaptionML = ENU = 'Applies-to Withholding Doc.', ESP = 'Liq. documento retenci�n';
            Description = 'QB21111';
            Editable = false;


        }
        field(7207278; "Not Applicable Amount Appl."; Decimal)
        {
            CaptionML = ENU = 'Not Applicable Amount Appl.', ESP = 'Importe no aplicable liq.';
            Description = 'QB22111';
            Editable = false;


        }
        field(7207279; "Already Generated Job Entry"; Boolean)
        {
            CaptionML = ENU = 'Already Generated Job Entry.', ESP = 'Mov. proyecto ya generado';
            Description = 'QB2713';


        }
        field(7207280; "Usage/Sale"; Option)
        {
            OptionMembers = "Usage","Sale";
            CaptionML = ENU = 'Usage/Sale', ESP = 'Consumo/Venta';
            OptionCaptionML = ENU = 'Usage,Sale', ESP = 'Consumo,Venta';

            Description = 'QB2713';


        }
        field(7207281; "Post Purch. Rcpt. Pending y/n"; Boolean)
        {
            CaptionML = ENU = 'Contab. alb. pdte s/n', ESP = 'Contab. alb. pdte s/n';
            Description = 'QB2517';


        }
        field(7207284; "Job Closure Entry"; Boolean)
        {
            CaptionML = ENU = 'Job Closure Entry', ESP = 'Movimiento de cierre de obra';
            Description = 'QB';


        }
        field(7207285; "Destination Entry JV"; Code[20])
        {
            TableRelation = "Dimension Value"."Code";
            CaptionML = ENU = 'Destination Entry JV', ESP = 'UTE mov. destino';
            Description = 'QB';


        }
        field(7207286; "Job Sale Doc. Type"; Option)
        {
            OptionMembers = "Standar","Eqipament Advance","Advance by Store","Price Review";
            CaptionML = ESP = 'Tipo doc. venta proyecto';
            OptionCaptionML = ENU = 'Standar,Eqipament Advance,Advance by Store,Price Review', ESP = 'Estandar,Anticipo de maquinar�a,Anticipo por acopios,Revisi�n precios';

            Description = 'QB';


        }
        field(7207287; "App. Account Dest. Entry JV"; Code[20])
        {
            TableRelation = "Dimension Value"."Code";
            CaptionML = ENU = 'App. Account Dest. Entry JV', ESP = 'UTE mov. destino contrapartida';
            Description = 'QB';


        }
        field(7207290; "QW Withholding Entry"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Withholding Entry', ESP = 'M�v. retenci�n';
            Description = 'QB_180720';


        }
        field(7207291; "QW WithHolding Job No."; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'WithHolding Job No.', ESP = 'C�d. Proyecto retenci�n';
            Description = 'QB 25/02/20: - Si es un movimiento de retenci�n, de que proyecto proviene';


        }
        field(7207292; "Shipment Line No"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'N� L�nea del albar�n';
            Description = 'QB 1.06.21  - JAV 21/10/20: - Si es un albar�n de compra, de que l�nea es';


        }
        field(7207293; "Adjust WIP"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Ajustes de Obra en curso';
            Description = 'QB 1,07,11 - JAV 12/12/20: - Si es un movimiento de ajuets del WIP';


        }
        field(7207294; "QB Prepayment Entry No"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'N� Mov. de Anticipo';
            Description = 'QB 1.10.31 - JAV 04/04/22: - Se cambia de boolean a integer, ahora guarda el nro de registro del anticipo';


        }
        field(7207295; "QB Job No."; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'USO INTERNO Cod. Proyecto';
            Description = 'QB 1.09.03 - JAV 27/06/21: - Aqu� se guarda el c�digo del proyecto para usarlo en el movimiento de cliente o proveedor. SOLO ES CAMPO DE USO INTERNO POR UNA FUNCION';


        }
        field(7207296; "QB Payment Bank No."; Code[20])
        {
            TableRelation = "Bank Account"."No.";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Payment Bank No.', ESP = 'N� de banco de cobro';
            Description = 'QB 1.10.01';


        }
        field(7207297; "QB Confirming"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Confirming', ESP = 'Confirming';
            Description = 'QB 1.10.09 JAV 13/01/22: - [TT: Indica si la operaci�n ha provenido de un confirming]';


        }
        field(7207298; "QB Confirming Dealing Type"; Option)
        {
            OptionMembers = " ","Collection","Discount";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Confirming Dealing Type', ESP = 'Confirming Tipo gesti�n';
            OptionCaptionML = ENU = '" ,Collection,Discount"', ESP = '" ,Cobro,Descuento"';

            Description = 'QB 1.10.09 JAV 13/01/22: - [TT: Indica el tipo de gesti�n del confirming si la operaci�n es de este tipo]';


        }
        field(7207299; "QB Redrawing"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Redrawing', ESP = 'Recirculando';
            Description = 'QB 1.10.27 EPV Q16712 nueva funcionalidad (INESCO). Permitir Recircular facturas a Cartera en �rdenes de pago registradas. Campo de uso interno';


        }
        field(7207300; "Do not sent to SII"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'No subir al SII';
            Description = 'QB 1.10.40 - QuoSII 1.06.07  JAV 11/05/22: - Si se marca este campo, el movimiento no debe subir al SII de MS ni al QuoSII';


        }
        field(7207301; "QB Activation Mov."; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Es Activaci�n';
            Description = 'QB 1.12.00 JAV 06/10/22: - Se marca internamente para indicar que es un movimiento de Activaci�n del gasto';


        }
        field(7207302; "QB Activation Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Activation Code', ESP = 'Activado con el c�digo';
            Description = 'QB 1.12.00 JAV 06/10/22: - Con que c�digo se ha activado el gasto';


        }
        field(7207700; "QB Stocks Document Type"; Option)
        {
            OptionMembers = " ","Receipt","Invoice","Return Receipt","Credit Memo","Output Shipment";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Document Type stocks', ESP = 'Stock Tipo Documento';
            OptionCaptionML = ENU = '" ,Receipt,Invoice,Return Receipt,Credit Memo,Output Shipment No."', ESP = '" ,Albaran compra, Factura Compra,Devoluci�n Compra, Abono Compra,Albar�n Salida"';

            Description = 'QB_ST01';


        }
        field(7207701; "QB Stocks Document No"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Document No Stocks', ESP = 'Stock Num. Documento';
            Description = 'QB_ST01';


        }
        field(7207702; "QB Stocks Output Shipment Line"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Document Line Stocks', ESP = 'Stock Linea Documento';
            Description = 'QB_ST01';


        }
        field(7207703; "QB Stocks Item No."; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Item No.', ESP = 'No. Producto';
            Description = 'QB_ST01';


        }
        field(7207704; "QB Stocks Output Shipment No."; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Output Shipment No.', ESP = 'Albar�n de Salida';
            Description = 'QB_ST01';


        }
        field(7207705; "QB Stocks Document Line"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'QB_ST01';


        }
    }
    keys
    {
        // key(key1;"Journal Template Name","Journal Batch Name","Posting Date","Document No.")
        //  {
        /* MaintainSQLIndex=false;
  */
        // }
        // key(key2;"Account Type","Account No.","Applies-to Doc. Type","Applies-to Doc. No.")
        //  {
        /* ;
  */
        // }
        // key(key3;"Document No.")
        //  {
        /* ;
  */
        // }
        // key(key4;"Journal Template Name","Journal Batch Name","Posting Date","Transaction No.")
        //  {
        /* ;
  */
        // }
        // key(key5;"Journal Template Name","Journal Batch Name","Transfer Type")
        //  {
        /* ;
  */
        // }
        // key(key6;"Incoming Document Entry No.")
        //  {
        /* ;
  */
        // }
        // key(key7;"Document No.","Posting Date","Source Code")
        //  {
        /* //SumIndexFields="VAT Amount (LCY)","Bal. VAT Amount (LCY)"
                                                    MaintainSQLIndex=false;
  */
        // }
    }
    fieldgroups
    {
    }

    var
        //       Text000@1000 :
        Text000:
// "%1=Account Type,%2=Balance Account Type"
TextConst ENU = '%1 or %2 must be a G/L Account or Bank Account.', ESP = '%1 o %2 deben ser tipo Cuenta o Banco.';
        //       Text001@1001 :
        Text001: TextConst ENU = 'You must not specify %1 when %2 is %3.', ESP = 'No se debe especificar %1 cuando %2 es %3.';
        //       Text002@1002 :
        Text002: TextConst ENU = 'cannot be specified without %1', ESP = 'no se puede especificar sin %1';
        //       ChangeCurrencyQst@1003 :
        ChangeCurrencyQst:
// "%1=FromCurrencyCode, %2=ToCurrencyCode"
TextConst ENU = 'The Currency Code in the Gen. Journal Line will be changed from %1 to %2.\\Do you want to continue?', ESP = 'El C�d. divisa de L�n. diario general debe cambiarse de %1 a %2.\\�Quiere continuar?';
        //       UpdateInterruptedErr@1005 :
        UpdateInterruptedErr: TextConst ENU = 'The update has been interrupted to respect the warning.', ESP = 'Se ha interrumpido la actualizaci�n para respetar la advertencia.';
        //       Text006@1006 :
        Text006: TextConst ENU = 'The %1 option can only be used internally in the system.', ESP = 'La opci�n %1 es de uso interno del sistema.';
        //       Text007@1007 :
        Text007:
// "%1=Account Type,%2=Balance Account Type"
TextConst ENU = '%1 or %2 must be a bank account.', ESP = '%1 o %2 debe ser de tipo Banco.';
        //       Text008@1008 :
        Text008: TextConst ENU = ' must be 0 when %1 is %2.', ESP = ' debe ser 0 cuando %1 es %2.';
        //       Text009@1009 :
        Text009: TextConst ENU = 'LCY', ESP = 'DL';
        //       Text010@1010 :
        Text010: TextConst ENU = '%1 must be %2 or %3.', ESP = '%1 debe ser %2 o %3.';
        //       Text011@1011 :
        Text011: TextConst ENU = '%1 must be negative.', ESP = 'El %1 debe ser negativo.';
        //       Text012@1012 :
        Text012: TextConst ENU = '%1 must be positive.', ESP = 'El %1 debe ser positivo.';
        //       Text013@1013 :
        Text013: TextConst ENU = 'The %1 must not be more than %2.', ESP = '%1 no debe ser m�s que %2.';
        //       GenJnlTemplate@1014 :
        GenJnlTemplate: Record 80;
        //       GenJnlBatch@1015 :
        GenJnlBatch: Record 232;
        //       GenJnlLine@1016 :
        GenJnlLine: Record 81;
        //       Currency@1022 :
        Currency: Record 4;
        //       CurrExchRate@1023 :
        CurrExchRate: Record 330;
        //       PaymentTerms@1024 :
        PaymentTerms: Record 3;
        //       CustLedgEntry@1025 :
        CustLedgEntry: Record 21;
        //       VendLedgEntry@1026 :
        VendLedgEntry: Record 25;
        //       EmplLedgEntry@1020 :
        EmplLedgEntry: Record 5222;
        //       GenJnlAlloc@1027 :
        GenJnlAlloc: Record 221;
        //       VATPostingSetup@1028 :
        VATPostingSetup: Record 325;
        //       GenBusPostingGrp@1035 :
        GenBusPostingGrp: Record 250;
        //       GenProdPostingGrp@1036 :
        GenProdPostingGrp: Record 251;
        //       GLSetup@1037 :
        GLSetup: Record 98;
        //       Job@1060 :
        Job: Record 167;
        //       SourceCodeSetup@1017 :
        SourceCodeSetup: Record 242;
        //       TempJobJnlLine@1059 :
        TempJobJnlLine: Record 210 TEMPORARY;
        //       SalespersonPurchaser@1932 :
        SalespersonPurchaser: Record 13;
        //       NoSeriesMgt@1040 :
        NoSeriesMgt: Codeunit 396;
        //       CustCheckCreditLimit@1041 :
        CustCheckCreditLimit: Codeunit 312;
        //       SalesTaxCalculate@1042 :
        SalesTaxCalculate: Codeunit 398;
        //       GenJnlApply@1043 :
        GenJnlApply: Codeunit 225;
        //       GenJnlShowCTEntries@1039 :
        GenJnlShowCTEntries: Codeunit 16;
        //       CustEntrySetApplID@1044 :
        CustEntrySetApplID: Codeunit 101;
        //       VendEntrySetApplID@1045 :
        VendEntrySetApplID: Codeunit 111;
        //       EmplEntrySetApplID@1029 :
        EmplEntrySetApplID: Codeunit 112;
        //       DimMgt@1046 :
        DimMgt: Codeunit 408;
        //       PaymentToleranceMgt@1053 :
        PaymentToleranceMgt: Codeunit 426;
        //       DeferralUtilities@1051 :
        DeferralUtilities: Codeunit 1720;
        //       ApprovalsMgmt@1069 :
        ApprovalsMgmt: Codeunit 1535;
        //       Window@1004 :
        Window: Dialog;
        //       DeferralDocType@1050 :
        DeferralDocType: Option "Purchase","Sales","G/L";
        //       CurrencyCode@1052 :
        CurrencyCode: Code[10];
        //       Text014@1054 :
        Text014:
// "%1=Caption of Table Customer, %2=Customer No, %3=Caption of field Bill-to Customer No, %4=Value of Bill-to customer no."
TextConst ENU = 'The %1 %2 has a %3 %4.\\Do you still want to use %1 %2 in this journal line?', ESP = '%1 %2 tiene %3 %4.\\�Todav�a quiere utilizar %1 %2 en esta l�nea del diario?';
        //       TemplateFound@1056 :
        TemplateFound: Boolean;
        //       Text015@1058 :
        Text015: TextConst ENU = 'You are not allowed to apply and post an entry to an entry with an earlier posting date.\\Instead, post %1 %2 and then apply it to %3 %4.', ESP = 'No tiene permiso para aplicar ni registrar un movimiento con una fecha de registro anterior.\\En su lugar, registre %1 %2 y, a continuaci�n, apl�quelo a %3 %4.';
        //       CurrencyDate@1061 :
        CurrencyDate: Date;
        //       Text016@1062 :
        Text016: TextConst ENU = '%1 must be G/L Account or Bank Account.', ESP = '%1 deber�a ser una cuenta o banco.';
        //       HideValidationDialog@1064 :
        HideValidationDialog: Boolean;
        //       Text018@1066 :
        Text018: TextConst ENU = '%1 can only be set when %2 is set.', ESP = 'Solo se puede establecer %1 cuando se establece %2.';
        //       Text019@1067 :
        Text019: TextConst ENU = '%1 cannot be changed when %2 is set.', ESP = '%1 no se puede cambiar cuando se establece %2.';
        //       GLSetupRead@1019 :
        GLSetupRead: Boolean;
        //       ElectPmtMgmt@1100001 :
        ElectPmtMgmt: Codeunit 10701;
        //       Text1100100@1100000 :
        Text1100100: TextConst ENU = '% cannot be applied, since it is included in a payment order.', ESP = '%1 no se puede aplicar porque est� incluido en una orden de pago.';
        //       ExportAgainQst@1038 :
        ExportAgainQst: TextConst ENU = 'One or more of the selected lines have already been exported. Do you want to export them again?', ESP = 'Una o m�s de las l�neas seleccionadas ya se han exportado. �Desea repetir la exportaci�n?';
        //       NothingToExportErr@1021 :
        NothingToExportErr: TextConst ENU = 'There is nothing to export.', ESP = 'No hay nada que exportar.';
        //       NotExistErr@1068 :
        NotExistErr:
// "%1=Document number"
TextConst ENU = 'Document number %1 does not exist or is already closed.', ESP = 'El n�mero de documento %1 no existe o ya est� cerrado.';
        //       DocNoFilterErr@1047 :
        DocNoFilterErr: TextConst ENU = 'The document numbers cannot be renumbered while there is an active filter on the Document No. field.', ESP = 'Los n�meros de documento no se pueden renumerar mientras haya un filtro activo en el campo N� documento.';
        //       DueDateMsg@1150 :
        DueDateMsg: TextConst ENU = 'This posting date will cause an overdue payment.', ESP = 'Esta fecha de registro resultar� en un pago vencido.';
        //       CalcPostDateMsg@1169 :
        CalcPostDateMsg: TextConst ENU = 'Processing payment journal lines #1##########', ESP = 'Procesando l�ns. diario pagos #1##########';
        //       NoEntriesToVoidErr@1018 :
        NoEntriesToVoidErr: TextConst ENU = 'There are no entries to void.', ESP = 'No hay entradas para anular.';
        //       OnlyLocalCurrencyForEmployeeErr@1030 :
        OnlyLocalCurrencyForEmployeeErr: TextConst ENU = 'The value of the Currency Code field must be empty. General journal lines in foreign currency are not supported for employee account type.', ESP = 'El valor del campo C�d. divisa debe estar vac�o. No se admiten l�neas del diario general en la divisa extranjera para el tipo de cuenta de empleado.';
        //       AccTypeNotSupportedErr@1031 :
        AccTypeNotSupportedErr: TextConst ENU = 'You cannot specify a deferral code for this type of account.', ESP = 'No se puede especificar un c�digo de fraccionamiento para este tipo de cuenta.';
        //       SalespersonPurchPrivacyBlockErr@1933 :
        SalespersonPurchPrivacyBlockErr:
// "%1 = salesperson / purchaser code."
TextConst ENU = 'Privacy Blocked must not be true for Salesperson / Purchaser %1.', ESP = 'La opci�n Privacidad bloqueada no debe ser verdadera para el Vendedor/Comprador %1.';
        //       BlockedErr@1033 :
        BlockedErr:
// "%1=Blocked field value,%2=Account Type,%3=Account No."
TextConst ENU = 'The Blocked field must not be %1 for %2 %3.', ESP = 'El campo Bloqueado no debe ser %1 para %2 %3.';
        //       BlockedEmplErr@1032 :
        BlockedEmplErr:
// "%1 = Employee no. "
TextConst ENU = 'You cannot export file because employee %1 is blocked due to privacy.', ESP = 'No puede exportar el archivo porque el empleado %1 est� bloqueado por motivos de privacidad.';
        //       IncorrectAccTypeErr@1100002 :
        IncorrectAccTypeErr:
// "%1=Account Type,%2=Balance Account Type,%3=Customer or Vendor"
TextConst ENU = '%1 or %2 must be a %3.', ESP = '%1 o %2 debe ser un(a) %3.';
        //       OneOrAnotherTok@1100004 :
        OneOrAnotherTok:
// Customer or Vendor
TextConst ENU = '%1 or %2', ESP = '%1 o %2';
        //       QBTablePublisher@7001100 :
        QBTablePublisher: Codeunit 7207346;





    /*
    trigger OnInsert();    begin
                   GenJnlAlloc.LOCKTABLE;
                   LOCKTABLE;

                   SetLastModifiedDateTime;

                   GenJnlTemplate.GET("Journal Template Name");
                   GenJnlBatch.GET("Journal Template Name","Journal Batch Name");
                   "Copy VAT Setup to Jnl. Lines" := GenJnlBatch."Copy VAT Setup to Jnl. Lines";
                   "Posting No. Series" := GenJnlBatch."Posting No. Series";
                   "Check Printed" := FALSE;

                   ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
                   ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");

                   if ("Bank Payment Type" = "Bank Payment Type"::"Electronic Payment") and ("Account Type" = "Account Type"::Vendor) then
                     ElectPmtMgmt.GetTransferType("Account No.",Amount,"Transfer Type",FALSE);
                 end;


    */

    /*
    trigger OnModify();    begin
                   SetLastModifiedDateTime;

                   TESTFIELD("Check Printed",FALSE);
                   if ("Bank Payment Type" = "Bank Payment Type"::"Electronic Payment") and ("Account Type" = "Account Type"::Vendor) then begin
                     ElectPmtMgmt.GetTransferType("Account No.",Amount,"Transfer Type",FALSE);
                     MODIFY;
                   end;

                   if ("Applies-to ID" = '') and (xRec."Applies-to ID" <> '') then
                     ClearCustVendApplnEntry;
                 end;


    */

    /*
    trigger OnDelete();    var
    //                GenJournalBatch@1001 :
                   GenJournalBatch: Record 232;
    //                GenJournalLine@1002 :
                   GenJournalLine: Record 81;
                 begin
                   ApprovalsMgmt.OnCancelGeneralJournalLineApprovalRequest(Rec);

                   // Lines are deleted 1 by 1, this actually check if this is the last line in the General journal Bach
                   GenJournalLine.SETRANGE("Journal Template Name","Journal Template Name");
                   GenJournalLine.SETRANGE("Journal Batch Name","Journal Batch Name");
                   if GenJournalLine.COUNT = 1 then
                     if GenJournalBatch.GET("Journal Template Name","Journal Batch Name") then
                       ApprovalsMgmt.OnCancelGeneralJournalBatchApprovalRequest(GenJournalBatch);

                   TESTFIELD("Check Printed",FALSE);
                   TESTFIELD("Exported to Payment File",FALSE);

                   ClearCustVendApplnEntry;
                   ClearAppliedGenJnlLine;
                   DeletePaymentFileErrors;
                   ClearDataExchangeEntries(FALSE);

                   GenJnlAlloc.SETRANGE("Journal Template Name","Journal Template Name");
                   GenJnlAlloc.SETRANGE("Journal Batch Name","Journal Batch Name");
                   GenJnlAlloc.SETRANGE("Journal Line No.","Line No.");
                   GenJnlAlloc.DELETEALL;

                   DeferralUtilities.DeferralCodeOnDelete(
                     DeferralDocType::"G/L",
                     "Journal Template Name",
                     "Journal Batch Name",0,'',"Line No.");

                   VALIDATE("Incoming Document Entry No.",0);
                 end;


    */

    /*
    trigger OnRename();    begin
                   ApprovalsMgmt.OnRenameRecordInApprovalRequest(xRec.RECORDID,RECORDID);

                   TESTFIELD("Check Printed",FALSE);
                   TESTFIELD("Exported to Payment File",FALSE);
                 end;

    */




    /*
    procedure EmptyLine () : Boolean;
        begin
          exit(
            ("Account No." = '') and (Amount = 0) and
            (("Bal. Account No." = '') or not "System-Created Entry"));
        end;
    */




    /*
    procedure UpdateLineBalance ()
        begin
          "Debit Amount" := 0;
          "Credit Amount" := 0;

          if ((Amount > 0) and (not Correction)) or
             ((Amount < 0) and Correction)
          then
            "Debit Amount" := Amount
          else
            if Amount <> 0 then
              "Credit Amount" := -Amount;

          if "Currency Code" = '' then
            "Amount (LCY)" := Amount;
          CASE TRUE OF
            ("Account No." <> '') and ("Bal. Account No." <> ''):
              "Balance (LCY)" := 0;
            "Bal. Account No." <> '':
              "Balance (LCY)" := -"Amount (LCY)";
            else
              "Balance (LCY)" := "Amount (LCY)";
          end;

          OnUpdateLineBalanceOnAfterAssignBalanceLCY("Balance (LCY)");

          CLEAR(GenJnlAlloc);
          GenJnlAlloc.UpdateAllocations(Rec);

          UpdateSalesPurchLCY;

          if ("Deferral Code" <> '') and (Amount <> xRec.Amount) and ((Amount <> 0) and (xRec.Amount <> 0)) then
            VALIDATE("Deferral Code");
        end;
    */



    //     procedure SetUpNewLine (LastGenJnlLine@1000 : Record 81;Balance@1001 : Decimal;BottomLine@1002 :

    /*
    procedure SetUpNewLine (LastGenJnlLine: Record 81;Balance: Decimal;BottomLine: Boolean)
        begin
          GenJnlTemplate.GET("Journal Template Name");
          GenJnlBatch.GET("Journal Template Name","Journal Batch Name");
          GenJnlLine.SETRANGE("Journal Template Name","Journal Template Name");
          GenJnlLine.SETRANGE("Journal Batch Name","Journal Batch Name");
          if GenJnlLine.FINDFIRST then begin
            "Posting Date" := LastGenJnlLine."Posting Date";
            "Document Date" := LastGenJnlLine."Posting Date";
            "Document No." := LastGenJnlLine."Document No.";
            "Transaction No." := LastGenJnlLine."Transaction No.";
            if BottomLine and
               (Balance - LastGenJnlLine."Balance (LCY)" = 0) and
               not LastGenJnlLine.EmptyLine
            then
              IncrementDocumentNo(GenJnlBatch,"Document No.");
          end else begin
            "Posting Date" := WORKDATE;
            "Document Date" := WORKDATE;
            if GenJnlBatch."No. Series" <> '' then begin
              CLEAR(NoSeriesMgt);
              "Document No." := NoSeriesMgt.TryGetNextNo(GenJnlBatch."No. Series","Posting Date");
            end;
          end;
          if GenJnlTemplate.Recurring then
            "Recurring Method" := LastGenJnlLine."Recurring Method";
          CASE GenJnlTemplate.Type OF
            GenJnlTemplate.Type::Payments:
              begin
                "Account Type" := "Account Type"::Vendor;
                "Document Type" := "Document Type"::Payment;
              end;
            else begin
              "Account Type" := LastGenJnlLine."Account Type";
              "Document Type" := LastGenJnlLine."Document Type";
            end;
          end;
          "Source Code" := GenJnlTemplate."Source Code";
          "Reason Code" := GenJnlBatch."Reason Code";
          "Posting No. Series" := GenJnlBatch."Posting No. Series";
          "Bal. Account Type" := GenJnlBatch."Bal. Account Type";
          if ("Account Type" IN ["Account Type"::Customer,"Account Type"::Vendor,"Account Type"::"Fixed Asset"]) and
             ("Bal. Account Type" IN ["Bal. Account Type"::Customer,"Bal. Account Type"::Vendor,"Bal. Account Type"::"Fixed Asset"])
          then
            "Account Type" := "Account Type"::"G/L Account";
          VALIDATE("Bal. Account No.",GenJnlBatch."Bal. Account No.");
          Description := '';
          if GenJnlBatch."Suggest Balancing Amount" then
            SuggestBalancingAmount(LastGenJnlLine,BottomLine);

          UpdateJournalBatchID;

          OnAfterSetupNewLine(Rec,GenJnlTemplate,GenJnlBatch,LastGenJnlLine,Balance,BottomLine);
        end;
    */



    //     procedure InitNewLine (PostingDate@1000 : Date;DocumentDate@1001 : Date;PostingDescription@1002 : Text[50];ShortcutDim1Code@1003 : Code[20];ShortcutDim2Code@1004 : Code[20];DimSetID@1005 : Integer;ReasonCode@1006 :

    /*
    procedure InitNewLine (PostingDate: Date;DocumentDate: Date;PostingDescription: Text[50];ShortcutDim1Code: Code[20];ShortcutDim2Code: Code[20];DimSetID: Integer;ReasonCode: Code[10])
        begin
          INIT;
          "Posting Date" := PostingDate;
          "Document Date" := DocumentDate;
          Description := PostingDescription;
          "Shortcut Dimension 1 Code" := ShortcutDim1Code;
          "Shortcut Dimension 2 Code" := ShortcutDim2Code;
          "Dimension Set ID" := DimSetID;
          "Reason Code" := ReasonCode;
        end;
    */


    //     LOCAL procedure InitGenJnlLineBufferWithCustVend (var TempGenJournalLine@1100000 :

    /*
    LOCAL procedure InitGenJnlLineBufferWithCustVend (var TempGenJournalLine: Record 81 TEMPORARY)
        begin
          TempGenJournalLine.INIT;
          CASE TRUE OF
            "Account Type" IN ["Account Type"::Customer,"Account Type"::Vendor]:
              begin
                TempGenJournalLine."Account Type" := "Account Type";
                TempGenJournalLine."Account No." := "Account No.";
              end;
            "Bal. Account Type" IN ["Bal. Account Type"::Customer,"Bal. Account Type"::Vendor]:
              begin
                TempGenJournalLine."Account Type" := "Bal. Account Type";
                TempGenJournalLine."Account No." := "Bal. Account No.";
              end;
          end;
        end;
    */




    /*
    procedure CheckDocNoOnLines ()
        var
    //       GenJnlBatch@1002 :
          GenJnlBatch: Record 232;
    //       GenJnlLine@1001 :
          GenJnlLine: Record 81;
    //       LastDocNo@1003 :
          LastDocNo: Code[20];
        begin
          GenJnlLine.COPYFILTERS(Rec);

          if not GenJnlLine.FINDSET then
            exit;
          GenJnlBatch.GET(GenJnlLine."Journal Template Name",GenJnlLine."Journal Batch Name");
          if GenJnlBatch."No. Series" = '' then
            exit;

          CLEAR(NoSeriesMgt);
          repeat
            GenJnlLine.CheckDocNoBasedOnNoSeries(LastDocNo,GenJnlBatch."No. Series",NoSeriesMgt);
            LastDocNo := GenJnlLine."Document No.";
          until GenJnlLine.NEXT = 0;
        end;
    */



    //     procedure CheckDocNoBasedOnNoSeries (LastDocNo@1002 : Code[20];NoSeriesCode@1000 : Code[20];var NoSeriesMgtInstance@1001 :

    /*
    procedure CheckDocNoBasedOnNoSeries (LastDocNo: Code[20];NoSeriesCode: Code[20];var NoSeriesMgtInstance: Codeunit 396)
        var
    //       DocNo@1100000 :
          DocNo: Code[20];
        begin
          if NoSeriesCode = '' then
            exit;

          if (LastDocNo = '') or ("Document No." <> LastDocNo) then begin
            DocNo := NoSeriesMgtInstance.GetNextNo(NoSeriesCode,"Posting Date",FALSE);
            if not "Exported to Payment File" then
              if "Document No." <> DocNo then
                NoSeriesMgtInstance.TestManualWithDocumentNo(NoSeriesCode,"Document No.");  // allow use of manual document numbers.
          end;
        end;
    */




    /*
    procedure RenumberDocumentNo ()
        var
    //       GenJnlLine2@1006 :
          GenJnlLine2: Record 81;
    //       DocNo@1003 :
          DocNo: Code[20];
    //       FirstDocNo@1008 :
          FirstDocNo: Code[20];
    //       FirstTempDocNo@1009 :
          FirstTempDocNo: Code[20];
    //       LastTempDocNo@1010 :
          LastTempDocNo: Code[20];
        begin
          TESTFIELD("Check Printed",FALSE);

          GenJnlBatch.GET("Journal Template Name","Journal Batch Name");
          if GenJnlBatch."No. Series" = '' then
            exit;
          if GETFILTER("Document No.") <> '' then
            ERROR(DocNoFilterErr);
          CLEAR(NoSeriesMgt);
          FirstDocNo := NoSeriesMgt.TryGetNextNo(GenJnlBatch."No. Series","Posting Date");
          FirstTempDocNo := 'RENUMBERED-000000001';
          // step1 - renumber to non-existing document number
          DocNo := FirstTempDocNo;
          GenJnlLine2 := Rec;
          GenJnlLine2.RESET;
          RenumberDocNoOnLines(DocNo,GenJnlLine2);
          LastTempDocNo := DocNo;

          // step2 - renumber to real document number (within Filter)
          DocNo := FirstDocNo;
          GenJnlLine2.COPYFILTERS(Rec);
          GenJnlLine2 := Rec;
          RenumberDocNoOnLines(DocNo,GenJnlLine2);

          // step3 - renumber to real document number (outside filter)
          DocNo := INCSTR(DocNo);
          GenJnlLine2.RESET;
          GenJnlLine2.SETRANGE("Document No.",FirstTempDocNo,LastTempDocNo);
          RenumberDocNoOnLines(DocNo,GenJnlLine2);

          GET("Journal Template Name","Journal Batch Name","Line No.");
        end;
    */


    //     LOCAL procedure RenumberDocNoOnLines (var DocNo@1000 : Code[20];var GenJnlLine2@1001 :

    /*
    LOCAL procedure RenumberDocNoOnLines (var DocNo: Code[20];var GenJnlLine2: Record 81)
        var
    //       LastGenJnlLine@1002 :
          LastGenJnlLine: Record 81;
    //       GenJnlLine3@1005 :
          GenJnlLine3: Record 81;
    //       PrevDocNo@1004 :
          PrevDocNo: Code[20];
    //       FirstDocNo@1006 :
          FirstDocNo: Code[20];
    //       First@1003 :
          First: Boolean;
        begin
          FirstDocNo := DocNo;
          WITH GenJnlLine2 DO begin
            SETCURRENTKEY("Journal Template Name","Journal Batch Name","Document No.");
            SETRANGE("Journal Template Name","Journal Template Name");
            SETRANGE("Journal Batch Name","Journal Batch Name");
            LastGenJnlLine.INIT;
            First := TRUE;
            if FINDSET then begin
              repeat
                if "Document No." = FirstDocNo then
                  exit;
                if not First and (("Document No." <> PrevDocNo) or ("Bal. Account No." <> '')) and not LastGenJnlLine.EmptyLine then
                  DocNo := INCSTR(DocNo);
                PrevDocNo := "Document No.";
                if "Document No." <> '' then begin
                  if "Applies-to ID" = "Document No." then
                    RenumberAppliesToID(GenJnlLine2,"Document No.",DocNo);
                  RenumberAppliesToDocNo(GenJnlLine2,"Document No.",DocNo);
                end;
                GenJnlLine3.GET("Journal Template Name","Journal Batch Name","Line No.");
                GenJnlLine3."Document No." := DocNo;
                GenJnlLine3.MODIFY;
                First := FALSE;
                LastGenJnlLine := GenJnlLine2
              until NEXT = 0
            end
          end
        end;
    */


    //     LOCAL procedure RenumberAppliesToID (GenJnlLine2@1002 : Record 81;OriginalAppliesToID@1000 : Code[50];NewAppliesToID@1001 :

    /*
    LOCAL procedure RenumberAppliesToID (GenJnlLine2: Record 81;OriginalAppliesToID: Code[50];NewAppliesToID: Code[50])
        var
    //       CustLedgEntry@1003 :
          CustLedgEntry: Record 21;
    //       CustLedgEntry2@1009 :
          CustLedgEntry2: Record 21;
    //       VendLedgEntry@1004 :
          VendLedgEntry: Record 25;
    //       VendLedgEntry2@1010 :
          VendLedgEntry2: Record 25;
    //       AccType@1005 :
          AccType: Option;
    //       AccNo@1006 :
          AccNo: Code[20];
        begin
          GetAccTypeAndNo(GenJnlLine2,AccType,AccNo);
          CASE AccType OF
            "Account Type"::Customer:
              begin
                CustLedgEntry.SETRANGE("Customer No.",AccNo);
                CustLedgEntry.SETRANGE("Applies-to ID",OriginalAppliesToID);
                if CustLedgEntry.FINDSET then
                  repeat
                    CustLedgEntry2.GET(CustLedgEntry."Entry No.");
                    CustLedgEntry2."Applies-to ID" := NewAppliesToID;
                    CODEUNIT.RUN(CODEUNIT::"Cust. Entry-Edit",CustLedgEntry2);
                  until CustLedgEntry.NEXT = 0;
              end;
            "Account Type"::Vendor:
              begin
                VendLedgEntry.SETRANGE("Vendor No.",AccNo);
                VendLedgEntry.SETRANGE("Applies-to ID",OriginalAppliesToID);
                if VendLedgEntry.FINDSET then
                  repeat
                    VendLedgEntry2.GET(VendLedgEntry."Entry No.");
                    VendLedgEntry2."Applies-to ID" := NewAppliesToID;
                    CODEUNIT.RUN(CODEUNIT::"Vend. Entry-Edit",VendLedgEntry2);
                  until VendLedgEntry.NEXT = 0;
              end;
            else
              exit
          end;
          GenJnlLine2."Applies-to ID" := NewAppliesToID;
          GenJnlLine2.MODIFY;
        end;
    */


    //     LOCAL procedure RenumberAppliesToDocNo (GenJnlLine2@1002 : Record 81;OriginalAppliesToDocNo@1001 : Code[20];NewAppliesToDocNo@1000 :

    /*
    LOCAL procedure RenumberAppliesToDocNo (GenJnlLine2: Record 81;OriginalAppliesToDocNo: Code[20];NewAppliesToDocNo: Code[20])
        begin
          GenJnlLine2.RESET;
          GenJnlLine2.SETRANGE("Journal Template Name",GenJnlLine2."Journal Template Name");
          GenJnlLine2.SETRANGE("Journal Batch Name",GenJnlLine2."Journal Batch Name");
          GenJnlLine2.SETRANGE("Applies-to Doc. Type",GenJnlLine2."Document Type");
          GenJnlLine2.SETRANGE("Applies-to Doc. No.",OriginalAppliesToDocNo);
          GenJnlLine2.MODIFYALL("Applies-to Doc. No.",NewAppliesToDocNo);
        end;
    */



    /*
    LOCAL procedure CheckVATInAlloc ()
        begin
          if "Gen. Posting Type" <> 0 then begin
            GenJnlAlloc.RESET;
            GenJnlAlloc.SETRANGE("Journal Template Name","Journal Template Name");
            GenJnlAlloc.SETRANGE("Journal Batch Name","Journal Batch Name");
            GenJnlAlloc.SETRANGE("Journal Line No.","Line No.");
            if GenJnlAlloc.FIND('-') then
              repeat
                GenJnlAlloc.CheckVAT(Rec);
              until GenJnlAlloc.NEXT = 0;
          end;
        end;
    */


    //     LOCAL procedure SetCurrencyCode (AccType2@1000 : 'G/L Account,Customer,Vendor,Bank Account';AccNo2@1001 :

    /*
    LOCAL procedure SetCurrencyCode (AccType2: Option "G/L Account","Customer","Vendor","Bank Account";AccNo2: Code[20]) : Boolean;
        var
    //       BankAcc@1002 :
          BankAcc: Record 270;
        begin
          "Currency Code" := '';
          if AccNo2 <> '' then
            if AccType2 = AccType2::"Bank Account" then
              if BankAcc.GET(AccNo2) then
                "Currency Code" := BankAcc."Currency Code";
          exit("Currency Code" <> '');
        end;
    */



    //     procedure SetCurrencyFactor (CurrencyCode@1000 : Code[10];CurrencyFactor@1001 :

    /*
    procedure SetCurrencyFactor (CurrencyCode: Code[10];CurrencyFactor: Decimal)
        begin
          "Currency Code" := CurrencyCode;
          if "Currency Code" = '' then
            "Currency Factor" := 1
          else
            "Currency Factor" := CurrencyFactor;
        end;
    */



    /*
    LOCAL procedure GetCurrency ()
        begin
          if "Additional-Currency Posting" =
             "Additional-Currency Posting"::"Additional-Currency Amount Only"
          then begin
            if GLSetup."Additional Reporting Currency" = '' then
              ReadGLSetup;
            CurrencyCode := GLSetup."Additional Reporting Currency";
          end else
            CurrencyCode := "Currency Code";

          if CurrencyCode = '' then begin
            CLEAR(Currency);
            Currency.InitRoundingPrecision
          end else
            if CurrencyCode <> Currency.Code then begin
              Currency.GET(CurrencyCode);
              Currency.TESTFIELD("Amount Rounding Precision");
            end;
        end;
    */




    /*
    procedure UpdateSource ()
        var
    //       SourceExists1@1000 :
          SourceExists1: Boolean;
    //       SourceExists2@1001 :
          SourceExists2: Boolean;
        begin
          SourceExists1 := ("Account Type" <> "Account Type"::"G/L Account") and ("Account No." <> '');
          SourceExists2 := ("Bal. Account Type" <> "Bal. Account Type"::"G/L Account") and ("Bal. Account No." <> '');
          CASE TRUE OF
            SourceExists1 and not SourceExists2:
              begin
                "Source Type" := "Account Type";
                "Source No." := "Account No.";
              end;
            SourceExists2 and not SourceExists1:
              begin
                "Source Type" := "Bal. Account Type";
                "Source No." := "Bal. Account No.";
              end;
            else begin
              "Source Type" := "Source Type"::" ";
              "Source No." := '';
            end;
          end;
        end;
    */


    //     LOCAL procedure CheckGLAcc (GLAcc@1000 :

    /*
    LOCAL procedure CheckGLAcc (GLAcc: Record 15)
        begin
          GLAcc.CheckGLAcc;
          if GLAcc."Direct Posting" or ("Journal Template Name" = '') or "System-Created Entry" then
            exit;
          if "Posting Date" <> 0D then
            if "Posting Date" = CLOSINGDATE("Posting Date") then
              exit;

          CheckDirectPosting(GLAcc);
        end;
    */


    //     LOCAL procedure CheckICPartner (ICPartnerCode@1000 : Code[20];AccountType@1001 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';AccountNo@1002 :

    /*
    LOCAL procedure CheckICPartner (ICPartnerCode: Code[20];AccountType: Option "G/L Account","Customer","Vendor","Bank Account","Fixed Asset","IC Partner";AccountNo: Code[20])
        var
    //       ICPartner@1003 :
          ICPartner: Record 413;
        begin
          if ICPartnerCode <> '' then begin
            if GenJnlTemplate.GET("Journal Template Name") then;
            if (ICPartnerCode <> '') and ICPartner.GET(ICPartnerCode) then begin
              ICPartner.CheckICPartnerIndirect(FORMAT(AccountType),AccountNo);
              "IC Partner Code" := ICPartnerCode;
            end;
          end;
        end;
    */


    //     LOCAL procedure CheckAccAndBalAccType (AccType@1100000 :

    /*
    LOCAL procedure CheckAccAndBalAccType (AccType: Option "G/L Account","Customer","Vendor","Bank Account","Fixed Asset","IC Partne")
        begin
          if ("Account Type" <> AccType) and ("Bal. Account Type" <> AccType) then
            ERROR(
              IncorrectAccTypeErr,
              FIELDCAPTION("Account Type"),FIELDCAPTION("Bal. Account Type"),FORMAT(AccType));
        end;
    */



    /*
    LOCAL procedure CheckDataForCorrection ()
        begin
          TESTFIELD("Document Type","Document Type"::"Credit Memo");
          if not (("Account Type" IN ["Account Type"::Customer,"Account Type"::Vendor]) or
                  ("Bal. Account Type" IN ["Bal. Account Type"::Customer,"Bal. Account Type"::Vendor]))
          then
            ERROR(IncorrectAccTypeErr,
              FIELDCAPTION("Account Type"),FIELDCAPTION("Bal. Account Type"),
              STRSUBSTNO(OneOrAnotherTok,FORMAT("Account Type"::Customer),FORMAT("Account Type"::Vendor)));
        end;
    */


    //     LOCAL procedure CheckDirectPosting (var GLAccount@1001 :

    /*
    LOCAL procedure CheckDirectPosting (var GLAccount: Record 15)
        var
    //       IsHandled@1000 :
          IsHandled: Boolean;
        begin
          IsHandled := FALSE;
          OnBeforeCheckDirectPosting(GLAccount,IsHandled,Rec);
          if IsHandled then
            exit;

          GLAccount.TESTFIELD("Direct Posting",TRUE);

          OnAfterCheckDirectPosting(GLAccount,Rec);
        end;
    */




    /*
    procedure GetFAAddCurrExchRate ()
        var
    //       DeprBook@1000 :
          DeprBook: Record 5611;
    //       FADeprBook@1003 :
          FADeprBook: Record 5612;
    //       FANo@1001 :
          FANo: Code[20];
    //       UseFAAddCurrExchRate@1002 :
          UseFAAddCurrExchRate: Boolean;
        begin
          "FA Add.-Currency Factor" := 0;
          if ("FA Posting Type" <> "FA Posting Type"::" ") and
             ("Depreciation Book Code" <> '')
          then begin
            if "Account Type" = "Account Type"::"Fixed Asset" then
              FANo := "Account No.";
            if "Bal. Account Type" = "Bal. Account Type"::"Fixed Asset" then
              FANo := "Bal. Account No.";
            if FANo <> '' then begin
              DeprBook.GET("Depreciation Book Code");
              CASE "FA Posting Type" OF
                "FA Posting Type"::"Acquisition Cost":
                  UseFAAddCurrExchRate := DeprBook."Add-Curr Exch Rate - Acq. Cost";
                "FA Posting Type"::Depreciation:
                  UseFAAddCurrExchRate := DeprBook."Add.-Curr. Exch. Rate - Depr.";
                "FA Posting Type"::"Write-Down":
                  UseFAAddCurrExchRate := DeprBook."Add-Curr Exch Rate -Write-Down";
                "FA Posting Type"::Appreciation:
                  UseFAAddCurrExchRate := DeprBook."Add-Curr. Exch. Rate - Apprec.";
                "FA Posting Type"::"Custom 1":
                  UseFAAddCurrExchRate := DeprBook."Add-Curr. Exch Rate - Custom 1";
                "FA Posting Type"::"Custom 2":
                  UseFAAddCurrExchRate := DeprBook."Add-Curr. Exch Rate - Custom 2";
                "FA Posting Type"::Disposal:
                  UseFAAddCurrExchRate := DeprBook."Add.-Curr. Exch. Rate - Disp.";
                "FA Posting Type"::Maintenance:
                  UseFAAddCurrExchRate := DeprBook."Add.-Curr. Exch. Rate - Maint.";
              end;
              if UseFAAddCurrExchRate then begin
                FADeprBook.GET(FANo,"Depreciation Book Code");
                FADeprBook.TESTFIELD("FA Add.-Currency Factor");
                "FA Add.-Currency Factor" := FADeprBook."FA Add.-Currency Factor";
              end;
            end;
          end;
        end;
    */



    //     procedure GetShowCurrencyCode (CurrencyCode@1000 :

    /*
    procedure GetShowCurrencyCode (CurrencyCode: Code[10]) : Code[10];
        begin
          if CurrencyCode <> '' then
            exit(CurrencyCode);

          exit(Text009);
        end;
    */




    /*
    procedure ClearCustVendApplnEntry ()
        var
    //       TempCustLedgEntry@1000 :
          TempCustLedgEntry: Record 21 TEMPORARY;
    //       TempVendLedgEntry@1001 :
          TempVendLedgEntry: Record 25 TEMPORARY;
    //       TempEmplLedgEntry@1002 :
          TempEmplLedgEntry: Record 5222 TEMPORARY;
    //       AccType@1004 :
          AccType: Option "G/L Account","Customer","Vendor","Bank Account","Fixed Asset","IC Partner","Employee";
    //       AccNo@1005 :
          AccNo: Code[20];
        begin
          GetAccTypeAndNo(Rec,AccType,AccNo);
          CASE AccType OF
            AccType::Customer:
              if xRec."Applies-to ID" <> '' then begin
                if FindFirstCustLedgEntryWithAppliesToID(AccNo,xRec."Applies-to ID") then begin
                  ClearCustApplnEntryFields;
                  TempCustLedgEntry.DELETEALL;
                  CustEntrySetApplID.SetApplId(CustLedgEntry,TempCustLedgEntry,'');
                end
              end else
                if xRec."Applies-to Doc. No." <> '' then
                  if FindFirstCustLedgEntryWithAppliesToDocNo(AccNo,xRec."Applies-to Doc. No.") then begin
                    ClearCustApplnEntryFields;
                    CODEUNIT.RUN(CODEUNIT::"Cust. Entry-Edit",CustLedgEntry);
                  end;
            AccType::Vendor:
              if xRec."Applies-to ID" <> '' then begin
                if FindFirstVendLedgEntryWithAppliesToID(AccNo,xRec."Applies-to ID") then begin
                  ClearVendApplnEntryFields;
                  TempVendLedgEntry.DELETEALL;
                  VendEntrySetApplID.SetApplId(VendLedgEntry,TempVendLedgEntry,'');
                end
              end else
                if xRec."Applies-to Doc. No." <> '' then
                  if FindFirstVendLedgEntryWithAppliesToDocNo(AccNo,xRec."Applies-to Doc. No.") then begin
                    ClearVendApplnEntryFields;
                    CODEUNIT.RUN(CODEUNIT::"Vend. Entry-Edit",VendLedgEntry);
                  end;
            AccType::Employee:
              if xRec."Applies-to ID" <> '' then begin
                if FindFirstEmplLedgEntryWithAppliesToID(AccNo,xRec."Applies-to ID") then begin
                  ClearEmplApplnEntryFields;
                  TempEmplLedgEntry.DELETEALL;
                  EmplEntrySetApplID.SetApplId(EmplLedgEntry,TempEmplLedgEntry,'');
                end
              end else
                if xRec."Applies-to Doc. No." <> '' then
                  if FindFirstEmplLedgEntryWithAppliesToDocNo(AccNo,xRec."Applies-to Doc. No.") then begin
                    ClearEmplApplnEntryFields;
                    CODEUNIT.RUN(CODEUNIT::"Empl. Entry-Edit",EmplLedgEntry);
                  end;
          end;
        end;
    */



    /*
    LOCAL procedure ClearCustApplnEntryFields ()
        begin
          CustLedgEntry."Accepted Pmt. Disc. Tolerance" := FALSE;
          CustLedgEntry."Accepted Payment Tolerance" := 0;
          CustLedgEntry."Amount to Apply" := 0;

          OnAfterClearCustApplnEntryFields(CustLedgEntry);
        end;
    */



    /*
    LOCAL procedure ClearVendApplnEntryFields ()
        begin
          VendLedgEntry."Accepted Pmt. Disc. Tolerance" := FALSE;
          VendLedgEntry."Accepted Payment Tolerance" := 0;
          VendLedgEntry."Amount to Apply" := 0;

          OnAfterClearVendApplnEntryFields(VendLedgEntry);
        end;
    */



    /*
    LOCAL procedure ClearEmplApplnEntryFields ()
        begin
          EmplLedgEntry."Amount to Apply" := 0;

          OnAfterClearEmplApplnEntryFields(EmplLedgEntry);
        end;
    */




    /*
    procedure CheckFixedCurrency () : Boolean;
        var
    //       CurrExchRate@1000 :
          CurrExchRate: Record 330;
        begin
          CurrExchRate.SETRANGE("Currency Code","Currency Code");
          CurrExchRate.SETRANGE("Starting Date",0D,"Posting Date");

          if not CurrExchRate.FINDLAST then
            exit(FALSE);

          if CurrExchRate."Relational Currency Code" = '' then
            exit(
              CurrExchRate."Fix Exchange Rate Amount" =
              CurrExchRate."Fix Exchange Rate Amount"::Both);

          if CurrExchRate."Fix Exchange Rate Amount" <>
             CurrExchRate."Fix Exchange Rate Amount"::Both
          then
            exit(FALSE);

          CurrExchRate.SETRANGE("Currency Code",CurrExchRate."Relational Currency Code");
          if CurrExchRate.FINDLAST then
            exit(
              CurrExchRate."Fix Exchange Rate Amount" =
              CurrExchRate."Fix Exchange Rate Amount"::Both);

          exit(FALSE);
        end;
    */



    //     procedure CreateDim (Type1@1000 : Integer;No1@1001 : Code[20];Type2@1002 : Integer;No2@1003 : Code[20];Type3@1004 : Integer;No3@1005 : Code[20];Type4@1006 : Integer;No4@1007 : Code[20];Type5@1008 : Integer;No5@1009 :

    /*
    procedure CreateDim (Type1: Integer;No1: Code[20];Type2: Integer;No2: Code[20];Type3: Integer;No3: Code[20];Type4: Integer;No4: Code[20];Type5: Integer;No5: Code[20])
        var
    //       TableID@1010 :
          TableID: ARRAY [10] OF Integer;
    //       No@1011 :
          No: ARRAY [10] OF Code[20];
        begin
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
          OnAfterCreateDimTableIDs(Rec,CurrFieldNo,TableID,No);

          "Shortcut Dimension 1 Code" := '';
          "Shortcut Dimension 2 Code" := '';
          "Dimension Set ID" :=
            DimMgt.GetRecDefaultDimID(
              Rec,CurrFieldNo,TableID,No,"Source Code","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code",0,0);
        end;
    */



    //     procedure ValidateShortcutDimCode (FieldNumber@1000 : Integer;var ShortcutDimCode@1001 :

    /*
    procedure ValidateShortcutDimCode (FieldNumber: Integer;var ShortcutDimCode: Code[20])
        begin
          TESTFIELD("Check Printed",FALSE);
          DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");
        end;
    */


    //     LOCAL procedure ValidateAmount (ShouldCheckPaymentTolerance@1000 :

    /*
    LOCAL procedure ValidateAmount (ShouldCheckPaymentTolerance: Boolean)
        begin
          GetCurrency;
          if "Currency Code" = '' then
            "Amount (LCY)" := Amount
          else
            "Amount (LCY)" := ROUND(
                CurrExchRate.ExchangeAmtFCYToLCY("Posting Date","Currency Code",Amount,"Currency Factor"));
          OnValidateAmountOnAfterAssignAmountLCY("Amount (LCY)");

          Amount := ROUND(Amount,Currency."Amount Rounding Precision");
          if (CurrFieldNo <> 0) and
             (CurrFieldNo <> FIELDNO("Applies-to Doc. No.")) and
             ((("Account Type" = "Account Type"::Customer) and
               ("Account No." <> '') and (Amount > 0) and
               (CurrFieldNo <> FIELDNO("Bal. Account No."))) or
              (("Bal. Account Type" = "Bal. Account Type"::Customer) and
               ("Bal. Account No." <> '') and (Amount < 0) and
               (CurrFieldNo <> FIELDNO("Account No."))))
          then
            CustCheckCreditLimit.GenJnlLineCheck(Rec);

          VALIDATE("VAT %");
          VALIDATE("Bal. VAT %");
          UpdateLineBalance;
          if "Deferral Code" <> '' then
            VALIDATE("Deferral Code");

          if Amount <> xRec.Amount then begin
            if ("Applies-to Doc. No." <> '') or ("Applies-to ID" <> '') then
              SetApplyToAmount;
            if ShouldCheckPaymentTolerance then
              if (xRec.Amount <> 0) or (xRec."Applies-to Doc. No." <> '') or (xRec."Applies-to ID" <> '') then
                PaymentToleranceMgt.PmtTolGenJnl(Rec);
          end;

          if JobTaskIsSet then begin
            CreateTempJobJnlLine;
            UpdatePricesFromJobJnlLine;
          end;
        end;
    */



    //     procedure LookupShortcutDimCode (FieldNumber@1000 : Integer;var ShortcutDimCode@1001 :

    /*
    procedure LookupShortcutDimCode (FieldNumber: Integer;var ShortcutDimCode: Code[20])
        begin
          TESTFIELD("Check Printed",FALSE);
          DimMgt.LookupDimValueCode(FieldNumber,ShortcutDimCode);
          DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");
        end;
    */



    //     procedure ShowShortcutDimCode (var ShortcutDimCode@1000 :

    /*
    procedure ShowShortcutDimCode (var ShortcutDimCode: ARRAY [8] OF Code[20])
        begin
          DimMgt.GetShortcutDimensions("Dimension Set ID",ShortcutDimCode);
        end;
    */




    /*
    procedure ShowDimensions ()
        begin
          "Dimension Set ID" :=
            DimMgt.EditDimensionSet2(
              "Dimension Set ID",STRSUBSTNO('%1 %2 %3',"Journal Template Name","Journal Batch Name","Line No."),
              "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
        end;
    */




    /*
    procedure GetFAVATSetup ()
        var
    //       LocalGLAcc@1000 :
          LocalGLAcc: Record 15;
    //       FAPostingGr@1001 :
          FAPostingGr: Record 5606;
    //       FABalAcc@1002 :
          FABalAcc: Boolean;
        begin
          if CurrFieldNo = 0 then
            exit;
          if ("Account Type" <> "Account Type"::"Fixed Asset") and
             ("Bal. Account Type" <> "Bal. Account Type"::"Fixed Asset")
          then
            exit;
          FABalAcc := ("Bal. Account Type" = "Bal. Account Type"::"Fixed Asset");
          if not FABalAcc then begin
            ClearPostingGroups;
            "Tax Group Code" := '';
            VALIDATE("VAT Prod. Posting Group");
          end;
          if FABalAcc then begin
            ClearBalancePostingGroups;
            "Bal. Tax Group Code" := '';
            VALIDATE("Bal. VAT Prod. Posting Group");
          end;
          if CopyVATSetupToJnlLines then
            if (("FA Posting Type" = "FA Posting Type"::"Acquisition Cost") or
                ("FA Posting Type" = "FA Posting Type"::Disposal) or
                ("FA Posting Type" = "FA Posting Type"::Maintenance)) and
               ("Posting Group" <> '')
            then
              if FAPostingGr.GET("Posting Group") then begin
                CASE "FA Posting Type" OF
                  "FA Posting Type"::"Acquisition Cost":
                    LocalGLAcc.GET(FAPostingGr.GetAcquisitionCostAccount);
                  "FA Posting Type"::Disposal:
                    LocalGLAcc.GET(FAPostingGr.GetAcquisitionCostAccountOnDisposal);
                  "FA Posting Type"::Maintenance:
                    LocalGLAcc.GET(FAPostingGr.GetMaintenanceExpenseAccount);
                end;
                LocalGLAcc.CheckGLAcc;
                if not FABalAcc then begin
                  "Gen. Posting Type" := LocalGLAcc."Gen. Posting Type";
                  "Gen. Bus. Posting Group" := LocalGLAcc."Gen. Bus. Posting Group";
                  "Gen. Prod. Posting Group" := LocalGLAcc."Gen. Prod. Posting Group";
                  "VAT Bus. Posting Group" := LocalGLAcc."VAT Bus. Posting Group";
                  "VAT Prod. Posting Group" := LocalGLAcc."VAT Prod. Posting Group";
                  "Tax Group Code" := LocalGLAcc."Tax Group Code";
                  VALIDATE("VAT Prod. Posting Group");
                end else begin;
                  "Bal. Gen. Posting Type" := LocalGLAcc."Gen. Posting Type";
                  "Bal. Gen. Bus. Posting Group" := LocalGLAcc."Gen. Bus. Posting Group";
                  "Bal. Gen. Prod. Posting Group" := LocalGLAcc."Gen. Prod. Posting Group";
                  "Bal. VAT Bus. Posting Group" := LocalGLAcc."VAT Bus. Posting Group";
                  "Bal. VAT Prod. Posting Group" := LocalGLAcc."VAT Prod. Posting Group";
                  "Bal. Tax Group Code" := LocalGLAcc."Tax Group Code";
                  VALIDATE("Bal. VAT Prod. Posting Group");
                end;
              end;
        end;
    */


    //     LOCAL procedure GetFADeprBook (FANo@1003 :

    /*
    LOCAL procedure GetFADeprBook (FANo: Code[20])
        var
    //       FASetup@1000 :
          FASetup: Record 5603;
    //       FADeprBook@1001 :
          FADeprBook: Record 5612;
    //       DefaultFADeprBook@1002 :
          DefaultFADeprBook: Record 5612;
        begin
          if "Depreciation Book Code" = '' then begin
            FASetup.GET;

            DefaultFADeprBook.SETRANGE("FA No.",FANo);
            DefaultFADeprBook.SETRANGE("Default FA Depreciation Book",TRUE);

            CASE TRUE OF
              DefaultFADeprBook.FINDFIRST:
                "Depreciation Book Code" := DefaultFADeprBook."Depreciation Book Code";
              FADeprBook.GET(FANo,FASetup."Default Depr. Book"):
                "Depreciation Book Code" := FASetup."Default Depr. Book";
              else
                "Depreciation Book Code" := '';
            end;
          end;

          if "Depreciation Book Code" <> '' then begin
            FADeprBook.GET(FANo,"Depreciation Book Code");
            "Posting Group" := FADeprBook."FA Posting Group";
          end;
        end;
    */




    /*
    procedure GetTemplate ()
        begin
          if not TemplateFound then
            GenJnlTemplate.GET("Journal Template Name");
          TemplateFound := TRUE;
        end;
    */


    LOCAL procedure UpdateSalesPurchLCY()
    begin
        "Sales/Purch. (LCY)" := 0;
        if (not "System-Created Entry") and ("Document Type" IN ["Document Type"::Invoice, "Document Type"::"Credit Memo"]) then begin
            if ("Account Type" IN ["Account Type"::Customer, "Account Type"::Vendor]) and
                (("Bal. Account No." <> '') or ("Recurring Method" <> "Recurring Method"::" "))
            then
                "Sales/Purch. (LCY)" := "Amount (LCY)" + "Bal. VAT Amount (LCY)";
            if ("Bal. Account Type" IN ["Bal. Account Type"::Customer, "Bal. Account Type"::Vendor]) and ("Account No." <> '') then
                "Sales/Purch. (LCY)" := -("Amount (LCY)" - "VAT Amount (LCY)");
        end;
    end;


    //     procedure LookUpAppliesToDocCust (AccNo@1000 :

    /*
    procedure LookUpAppliesToDocCust (AccNo: Code[20])
        var
    //       ApplyCustEntries@1002 :
          ApplyCustEntries: Page 232;
        begin
          OnBeforeLookUpAppliesToDocCust(Rec,AccNo);

          CLEAR(CustLedgEntry);
          CustLedgEntry.SETCURRENTKEY("Customer No.",Open,Positive,"Due Date");
          if AccNo <> '' then
            CustLedgEntry.SETRANGE("Customer No.",AccNo);
          CustLedgEntry.SETRANGE(Open,TRUE);
          CustLedgEntry.SETFILTER("Document Situation",'<>%1',CustLedgEntry."Document Situation"::"Posted BG/PO");
          if "Applies-to Doc. No." <> '' then begin
            CustLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
            CustLedgEntry.SETRANGE("Document No.","Applies-to Doc. No.");
            CustLedgEntry.SETRANGE("Bill No.","Applies-to Bill No.");
            if CustLedgEntry.ISEMPTY then begin
              CustLedgEntry.SETRANGE("Document Type");
              CustLedgEntry.SETRANGE("Document No.");
              CustLedgEntry.SETRANGE("Bill No.");
            end;
          end;
          if "Applies-to ID" <> '' then begin
            CustLedgEntry.SETRANGE("Applies-to ID","Applies-to ID");
            if CustLedgEntry.ISEMPTY then
              CustLedgEntry.SETRANGE("Applies-to ID");
          end;
          if "Applies-to Doc. Type" <> "Applies-to Doc. Type"::" " then begin
            CustLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
            if CustLedgEntry.ISEMPTY then
              CustLedgEntry.SETRANGE("Document Type");
          end;
          if Amount <> 0 then begin
            CustLedgEntry.SETRANGE(Positive,Amount < 0);
            if CustLedgEntry.ISEMPTY then
              CustLedgEntry.SETRANGE(Positive);
          end;
          OnLookUpAppliesToDocCustOnAfterSetFilters(CustLedgEntry,Rec);

          ApplyCustEntries.SetGenJnlLine(Rec,GenJnlLine.FIELDNO("Applies-to Doc. No."));
          ApplyCustEntries.SETTABLEVIEW(CustLedgEntry);
          ApplyCustEntries.SETRECORD(CustLedgEntry);
          ApplyCustEntries.LOOKUPMODE(TRUE);
          if ApplyCustEntries.RUNMODAL = ACTION::LookupOK then begin
            ApplyCustEntries.GETRECORD(CustLedgEntry);
            if AccNo = '' then begin
              AccNo := CustLedgEntry."Customer No.";
              if "Bal. Account Type" = "Bal. Account Type"::Customer then
                VALIDATE("Bal. Account No.",AccNo)
              else
                VALIDATE("Account No.",AccNo);
            end;
            SetAmountWithCustLedgEntry;
            UpdateDocumentTypeAndAppliesTo(CustLedgEntry."Document Type",CustLedgEntry."Document No.");
            "Applies-to Bill No." := CustLedgEntry."Bill No.";
            OnLookUpAppliesToDocCustOnAfterUpdateDocumentTypeAndAppliesTo(Rec,CustLedgEntry);
          end;
        end;
    */



    //     procedure LookUpAppliesToDocVend (AccNo@1000 :

    /*
    procedure LookUpAppliesToDocVend (AccNo: Code[20])
        var
    //       ApplyVendEntries@1001 :
          ApplyVendEntries: Page 233;
        begin
          OnBeforeLookUpAppliesToDocVend(Rec,AccNo);

          CLEAR(VendLedgEntry);
          VendLedgEntry.SETCURRENTKEY("Vendor No.",Open,Positive,"Due Date");
          if AccNo <> '' then
            VendLedgEntry.SETRANGE("Vendor No.",AccNo);
          VendLedgEntry.SETRANGE(Open,TRUE);
          if "Applies-to Doc. No." <> '' then begin
            VendLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
            VendLedgEntry.SETRANGE("Document No.","Applies-to Doc. No.");
            VendLedgEntry.SETRANGE("Bill No.","Applies-to Bill No.");
            if VendLedgEntry.ISEMPTY then begin
              VendLedgEntry.SETRANGE("Document Type");
              VendLedgEntry.SETRANGE("Document No.");
              VendLedgEntry.SETRANGE("Bill No.");
            end;
          end;
          if "Applies-to ID" <> '' then begin
            VendLedgEntry.SETRANGE("Applies-to ID","Applies-to ID");
            if VendLedgEntry.ISEMPTY then
              VendLedgEntry.SETRANGE("Applies-to ID");
          end;
          if "Applies-to Doc. Type" <> "Applies-to Doc. Type"::" " then begin
            VendLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
            if VendLedgEntry.ISEMPTY then
              VendLedgEntry.SETRANGE("Document Type");
          end;
          if  "Applies-to Doc. No." <> ''then begin
            VendLedgEntry.SETRANGE("Document No.","Applies-to Doc. No.");
            if VendLedgEntry.ISEMPTY then
              VendLedgEntry.SETRANGE("Document No.");
          end;
          if Amount <> 0 then begin
            VendLedgEntry.SETRANGE(Positive,Amount < 0);
            if VendLedgEntry.ISEMPTY then;
            VendLedgEntry.SETRANGE(Positive);
          end;
          OnLookUpAppliesToDocVendOnAfterSetFilters(VendLedgEntry,Rec);

          ApplyVendEntries.SetGenJnlLine(Rec,GenJnlLine.FIELDNO("Applies-to Doc. No."));
          ApplyVendEntries.SETTABLEVIEW(VendLedgEntry);
          ApplyVendEntries.SETRECORD(VendLedgEntry);
          ApplyVendEntries.LOOKUPMODE(TRUE);
          if ApplyVendEntries.RUNMODAL = ACTION::LookupOK then begin
            ApplyVendEntries.GETRECORD(VendLedgEntry);
            if AccNo = '' then begin
              AccNo := VendLedgEntry."Vendor No.";
              if "Bal. Account Type" = "Bal. Account Type"::Vendor then
                VALIDATE("Bal. Account No.",AccNo)
              else
                VALIDATE("Account No.",AccNo);
            end;
            if VendLedgEntry."Document Situation" = VendLedgEntry."Document Situation"::"Posted BG/PO" then
              ERROR(Text1100100,VendLedgEntry.Description);
            SetAmountWithVendLedgEntry;
            UpdateDocumentTypeAndAppliesTo(VendLedgEntry."Document Type",VendLedgEntry."Document No.");
            "Applies-to Bill No." := VendLedgEntry."Bill No.";
            OnLookUpAppliesToDocVendOnAfterUpdateDocumentTypeAndAppliesTo(Rec,VendLedgEntry);
          end;
        end;
    */



    //     procedure LookUpAppliesToDocEmpl (AccNo@1000 :

    /*
    procedure LookUpAppliesToDocEmpl (AccNo: Code[20])
        var
    //       ApplyEmplEntries@1001 :
          ApplyEmplEntries: Page 234;
        begin
          OnBeforeLookUpAppliesToDocEmpl(Rec,AccNo);

          CLEAR(EmplLedgEntry);
          EmplLedgEntry.SETCURRENTKEY("Employee No.",Open,Positive);
          if AccNo <> '' then
            EmplLedgEntry.SETRANGE("Employee No.",AccNo);
          EmplLedgEntry.SETRANGE(Open,TRUE);
          if "Applies-to Doc. No." <> '' then begin
            EmplLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
            EmplLedgEntry.SETRANGE("Document No.","Applies-to Doc. No.");
            if EmplLedgEntry.ISEMPTY then begin
              EmplLedgEntry.SETRANGE("Document Type");
              EmplLedgEntry.SETRANGE("Document No.");
            end;
          end;
          if "Applies-to ID" <> '' then begin
            EmplLedgEntry.SETRANGE("Applies-to ID","Applies-to ID");
            if EmplLedgEntry.ISEMPTY then
              EmplLedgEntry.SETRANGE("Applies-to ID");
          end;
          if "Applies-to Doc. Type" <> "Applies-to Doc. Type"::" " then begin
            EmplLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
            if EmplLedgEntry.ISEMPTY then
              EmplLedgEntry.SETRANGE("Document Type");
          end;
          if  "Applies-to Doc. No." <> '' then begin
            EmplLedgEntry.SETRANGE("Document No.","Applies-to Doc. No.");
            if EmplLedgEntry.ISEMPTY then
              EmplLedgEntry.SETRANGE("Document No.");
          end;
          if Amount <> 0 then begin
            EmplLedgEntry.SETRANGE(Positive,Amount < 0);
            if EmplLedgEntry.ISEMPTY then;
            EmplLedgEntry.SETRANGE(Positive);
          end;
          OnLookUpAppliesToDocEmplOnAfterSetFilters(EmplLedgEntry,Rec);

          ApplyEmplEntries.SetGenJnlLine(Rec,GenJnlLine.FIELDNO("Applies-to Doc. No."));
          ApplyEmplEntries.SETTABLEVIEW(EmplLedgEntry);
          ApplyEmplEntries.SETRECORD(EmplLedgEntry);
          ApplyEmplEntries.LOOKUPMODE(TRUE);
          if ApplyEmplEntries.RUNMODAL = ACTION::LookupOK then begin
            ApplyEmplEntries.GETRECORD(EmplLedgEntry);
            if AccNo = '' then begin
              AccNo := EmplLedgEntry."Employee No.";
              if "Bal. Account Type" = "Bal. Account Type"::Employee then
                VALIDATE("Bal. Account No.",AccNo)
              else
                VALIDATE("Account No.",AccNo);
            end;
            SetAmountWithEmplLedgEntry;
            UpdateDocumentTypeAndAppliesTo(EmplLedgEntry."Document Type",EmplLedgEntry."Document No.");
            OnLookUpAppliesToDocEmplOnAfterUpdateDocumentTypeAndAppliesTo(Rec,EmplLedgEntry);
          end;
        end;
    */




    /*
    procedure SetApplyToAmount ()
        begin
          CASE "Account Type" OF
            "Account Type"::Customer:
              begin
                CustLedgEntry.SETCURRENTKEY("Document No.");
                CustLedgEntry.SETRANGE("Document No.","Applies-to Doc. No.");
                CustLedgEntry.SETRANGE("Customer No.","Account No.");
                CustLedgEntry.SETRANGE(Open,TRUE);
                if CustLedgEntry.FIND('-') then
                  if CustLedgEntry."Amount to Apply" = 0 then begin
                    CustLedgEntry.CALCFIELDS("Remaining Amount");
                    CustLedgEntry."Amount to Apply" := CustLedgEntry."Remaining Amount";
                    CODEUNIT.RUN(CODEUNIT::"Cust. Entry-Edit",CustLedgEntry);
                  end;
              end;
            "Account Type"::Vendor:
              begin
                VendLedgEntry.SETCURRENTKEY("Document No.");
                VendLedgEntry.SETRANGE("Document No.","Applies-to Doc. No.");
                VendLedgEntry.SETRANGE("Vendor No.","Account No.");
                VendLedgEntry.SETRANGE(Open,TRUE);
                if VendLedgEntry.FIND('-') then
                  if VendLedgEntry."Amount to Apply" = 0 then  begin
                    VendLedgEntry.CALCFIELDS("Remaining Amount");
                    VendLedgEntry."Amount to Apply" := VendLedgEntry."Remaining Amount";
                    CODEUNIT.RUN(CODEUNIT::"Vend. Entry-Edit",VendLedgEntry);
                  end;
              end;
            "Account Type"::Employee:
              begin
                EmplLedgEntry.SETCURRENTKEY("Document No.");
                EmplLedgEntry.SETRANGE("Document No.","Applies-to Doc. No.");
                EmplLedgEntry.SETRANGE("Employee No.","Account No.");
                EmplLedgEntry.SETRANGE(Open,TRUE);
                if EmplLedgEntry.FIND('-') then
                  if EmplLedgEntry."Amount to Apply" = 0 then begin
                    EmplLedgEntry.CALCFIELDS("Remaining Amount");
                    EmplLedgEntry."Amount to Apply" := EmplLedgEntry."Remaining Amount";
                    CODEUNIT.RUN(CODEUNIT::"Empl. Entry-Edit",EmplLedgEntry);
                  end;
              end;
          end;
        end;
    */



    //     procedure ValidateApplyRequirements (TempGenJnlLine@1000 :

    /*
    procedure ValidateApplyRequirements (TempGenJnlLine: Record 81 TEMPORARY)
        begin
          if (TempGenJnlLine."Bal. Account Type" = TempGenJnlLine."Bal. Account Type"::Customer) or
             (TempGenJnlLine."Bal. Account Type" = TempGenJnlLine."Bal. Account Type"::Vendor) or
             (TempGenJnlLine."Bal. Account Type" = TempGenJnlLine."Bal. Account Type"::Vendor)
          then
            CODEUNIT.RUN(CODEUNIT::"Exchange Acc. G/L Journal Line",TempGenJnlLine);

          CASE TempGenJnlLine."Account Type" OF
            TempGenJnlLine."Account Type"::Customer:
              if TempGenJnlLine."Applies-to ID" <> '' then begin
                CustLedgEntry.SETCURRENTKEY("Customer No.","Applies-to ID",Open);
                CustLedgEntry.SETRANGE("Customer No.",TempGenJnlLine."Account No.");
                CustLedgEntry.SETRANGE("Applies-to ID",TempGenJnlLine."Applies-to ID");
                CustLedgEntry.SETRANGE(Open,TRUE);
                if CustLedgEntry.FIND('-') then
                  repeat
                    if TempGenJnlLine."Posting Date" < CustLedgEntry."Posting Date" then
                      ERROR(
                        Text015,TempGenJnlLine."Document Type",TempGenJnlLine."Document No.",
                        CustLedgEntry."Document Type",CustLedgEntry."Document No.");
                  until CustLedgEntry.NEXT = 0;
              end else
                if TempGenJnlLine."Applies-to Doc. No." <> '' then begin
                  CustLedgEntry.SETCURRENTKEY("Document No.");
                  CustLedgEntry.SETRANGE("Document No.",TempGenJnlLine."Applies-to Doc. No.");
                  if TempGenJnlLine."Applies-to Doc. Type" <> TempGenJnlLine."Applies-to Doc. Type"::" " then
                    CustLedgEntry.SETRANGE("Document Type",TempGenJnlLine."Applies-to Doc. Type");
                  CustLedgEntry.SETRANGE("Customer No.",TempGenJnlLine."Account No.");
                  CustLedgEntry.SETRANGE(Open,TRUE);
                  if CustLedgEntry.FIND('-') then
                    if TempGenJnlLine."Posting Date" < CustLedgEntry."Posting Date" then
                      ERROR(
                        Text015,TempGenJnlLine."Document Type",TempGenJnlLine."Document No.",
                        CustLedgEntry."Document Type",CustLedgEntry."Document No.");
                end;
            TempGenJnlLine."Account Type"::Vendor:
              if TempGenJnlLine."Applies-to ID" <> '' then begin
                VendLedgEntry.SETCURRENTKEY("Vendor No.","Applies-to ID",Open);
                VendLedgEntry.SETRANGE("Vendor No.",TempGenJnlLine."Account No.");
                VendLedgEntry.SETRANGE("Applies-to ID",TempGenJnlLine."Applies-to ID");
                VendLedgEntry.SETRANGE(Open,TRUE);
                if VendLedgEntry.FINDSET then
                  repeat
                    if TempGenJnlLine."Posting Date" < VendLedgEntry."Posting Date" then
                      ERROR(
                        Text015,TempGenJnlLine."Document Type",TempGenJnlLine."Document No.",
                        VendLedgEntry."Document Type",VendLedgEntry."Document No.");
                  until VendLedgEntry.NEXT = 0;
              end else
                if TempGenJnlLine."Applies-to Doc. No." <> '' then begin
                  VendLedgEntry.SETCURRENTKEY("Document No.");
                  VendLedgEntry.SETRANGE("Document No.",TempGenJnlLine."Applies-to Doc. No.");
                  if TempGenJnlLine."Applies-to Doc. Type" <> TempGenJnlLine."Applies-to Doc. Type"::" " then
                    VendLedgEntry.SETRANGE("Document Type",TempGenJnlLine."Applies-to Doc. Type");
                  VendLedgEntry.SETRANGE("Vendor No.",TempGenJnlLine."Account No.");
                  VendLedgEntry.SETRANGE(Open,TRUE);
                  if VendLedgEntry.FIND('-') then begin
                    if TempGenJnlLine."Posting Date" < VendLedgEntry."Posting Date" then
                      ERROR(
                        Text015,TempGenJnlLine."Document Type",TempGenJnlLine."Document No.",
                        VendLedgEntry."Document Type",VendLedgEntry."Document No.");
                    if VendLedgEntry."Document Situation" = VendLedgEntry."Document Situation"::"Posted BG/PO" then
                      ERROR(Text1100100,VendLedgEntry.Description);
                  end;
                end;
            TempGenJnlLine."Account Type"::Employee:
              if TempGenJnlLine."Applies-to ID" <> '' then begin
                EmplLedgEntry.SETCURRENTKEY("Employee No.","Applies-to ID",Open);
                EmplLedgEntry.SETRANGE("Employee No.",TempGenJnlLine."Account No.");
                EmplLedgEntry.SETRANGE("Applies-to ID",TempGenJnlLine."Applies-to ID");
                EmplLedgEntry.SETRANGE(Open,TRUE);
                if EmplLedgEntry.FINDSET then
                  repeat
                    if TempGenJnlLine."Posting Date" < EmplLedgEntry."Posting Date" then
                      ERROR(
                        Text015,TempGenJnlLine."Document Type",TempGenJnlLine."Document No.",
                        EmplLedgEntry."Document Type",EmplLedgEntry."Document No.");
                  until EmplLedgEntry.NEXT = 0;
              end else
                if TempGenJnlLine."Applies-to Doc. No." <> '' then begin
                  EmplLedgEntry.SETCURRENTKEY("Document No.");
                  EmplLedgEntry.SETRANGE("Document No.",TempGenJnlLine."Applies-to Doc. No.");
                  if TempGenJnlLine."Applies-to Doc. Type" <> EmplLedgEntry."Applies-to Doc. Type"::" " then
                    EmplLedgEntry.SETRANGE("Document Type",TempGenJnlLine."Applies-to Doc. Type");
                  EmplLedgEntry.SETRANGE("Employee No.",TempGenJnlLine."Account No.");
                  EmplLedgEntry.SETRANGE(Open,TRUE);
                  if EmplLedgEntry.FIND('-') then
                    if TempGenJnlLine."Posting Date" < EmplLedgEntry."Posting Date" then
                      ERROR(
                        Text015,TempGenJnlLine."Document Type",TempGenJnlLine."Document No.",
                        EmplLedgEntry."Document Type",EmplLedgEntry."Document No.");
                end;
          end;

          OnAfterValidateApplyRequirements(TempGenJnlLine);
        end;
    */


    //     LOCAL procedure UpdateCountryCodeAndVATRegNo (No@1000 :
    LOCAL procedure UpdateCountryCodeAndVATRegNo(No: Code[20])
    var
        //       Cust@1001 :
        Cust: Record 18;
        //       Vend@1002 :
        Vend: Record 23;
    begin
        if No = '' then begin
            "Country/Region Code" := '';
            "VAT Registration No." := '';
            exit;
        end;

        ReadGLSetup;
        CASE TRUE OF
            ("Account Type" = "Account Type"::Customer) or ("Bal. Account Type" = "Bal. Account Type"::Customer):
                begin
                    Cust.GET(No);
                    "Country/Region Code" := Cust."Country/Region Code";
                    "VAT Registration No." := Cust."VAT Registration No.";
                end;
            ("Account Type" = "Account Type"::Vendor) or ("Bal. Account Type" = "Bal. Account Type"::Vendor):
                begin
                    Vend.GET(No);
                    "Country/Region Code" := Vend."Country/Region Code";
                    "VAT Registration No." := Vend."VAT Registration No.";
                end;

            else   //QB
                QBTablePublisher.UpdateCountryCodeAndVATRegNoTGenJournalLine(Rec);  //QB

        end;
    end;



    /*
    procedure JobTaskIsSet () : Boolean;
        begin
          exit(("Job No." <> '') and ("Job Task No." <> '') and ("Account Type" = "Account Type"::"G/L Account"));
        end;
    */




    /*
    procedure CreateTempJobJnlLine ()
        var
    //       TmpJobJnlOverallCurrencyFactor@1001 :
          TmpJobJnlOverallCurrencyFactor: Decimal;
        begin
          OnBeforeCreateTempJobJnlLine(TempJobJnlLine,Rec,xRec,CurrFieldNo);

          TESTFIELD("Posting Date");
          CLEAR(TempJobJnlLine);
          TempJobJnlLine.DontCheckStdCost;
          TempJobJnlLine.VALIDATE("Job No.","Job No.");
          TempJobJnlLine.VALIDATE("Job Task No.","Job Task No.");
          if CurrFieldNo <> FIELDNO("Posting Date") then
            TempJobJnlLine.VALIDATE("Posting Date","Posting Date")
          else
            TempJobJnlLine.VALIDATE("Posting Date",xRec."Posting Date");
          TempJobJnlLine.VALIDATE(Type,TempJobJnlLine.Type::"G/L Account");
          if "Job Currency Code" <> '' then begin
            if "Posting Date" = 0D then
              CurrencyDate := WORKDATE
            else
              CurrencyDate := "Posting Date";

            if "Currency Code" = "Job Currency Code" then
              "Job Currency Factor" := "Currency Factor"
            else
              "Job Currency Factor" := CurrExchRate.ExchangeRate(CurrencyDate,"Job Currency Code");
            TempJobJnlLine.SetCurrencyFactor("Job Currency Factor");
          end;
          TempJobJnlLine.VALIDATE("No.","Account No.");
          TempJobJnlLine.VALIDATE(Quantity,"Job Quantity");

          if "Currency Factor" = 0 then begin
            if "Job Currency Factor" = 0 then
              TmpJobJnlOverallCurrencyFactor := 1
            else
              TmpJobJnlOverallCurrencyFactor := "Job Currency Factor";
          end else begin
            if "Job Currency Factor" = 0 then
              TmpJobJnlOverallCurrencyFactor := 1 / "Currency Factor"
            else
              TmpJobJnlOverallCurrencyFactor := "Job Currency Factor" / "Currency Factor"
          end;

          if "Job Quantity" <> 0 then
            TempJobJnlLine.VALIDATE("Unit Cost",((Amount - "VAT Amount") * TmpJobJnlOverallCurrencyFactor) / "Job Quantity");

          if (xRec."Account No." = "Account No.") and (xRec."Job Task No." = "Job Task No.") and ("Job Unit Price" <> 0) then begin
            if TempJobJnlLine."Cost Factor" = 0 then
              TempJobJnlLine."Unit Price" := xRec."Job Unit Price";
            TempJobJnlLine."Line Amount" := xRec."Job Line Amount";
            TempJobJnlLine."Line Discount %" := xRec."Job Line Discount %";
            TempJobJnlLine."Line Discount Amount" := xRec."Job Line Discount Amount";
            TempJobJnlLine.VALIDATE("Unit Price");
          end;

          OnAfterCreateTempJobJnlLine(TempJobJnlLine,Rec,xRec,CurrFieldNo);
        end;
    */




    /*
    procedure UpdatePricesFromJobJnlLine ()
        begin
          "Job Unit Price" := TempJobJnlLine."Unit Price";
          "Job Total Price" := TempJobJnlLine."Total Price";
          "Job Line Amount" := TempJobJnlLine."Line Amount";
          "Job Line Discount Amount" := TempJobJnlLine."Line Discount Amount";
          "Job Unit Cost" := TempJobJnlLine."Unit Cost";
          "Job Total Cost" := TempJobJnlLine."Total Cost";
          "Job Line Discount %" := TempJobJnlLine."Line Discount %";

          "Job Unit Price (LCY)" := TempJobJnlLine."Unit Price (LCY)";
          "Job Total Price (LCY)" := TempJobJnlLine."Total Price (LCY)";
          "Job Line Amount (LCY)" := TempJobJnlLine."Line Amount (LCY)";
          "Job Line Disc. Amount (LCY)" := TempJobJnlLine."Line Discount Amount (LCY)";
          "Job Unit Cost (LCY)" := TempJobJnlLine."Unit Cost (LCY)";
          "Job Total Cost (LCY)" := TempJobJnlLine."Total Cost (LCY)";

          OnAfterUpdatePricesFromJobJnlLine(Rec,TempJobJnlLine);
        end;
    */



    //     procedure SetHideValidation (NewHideValidationDialog@1000 :

    /*
    procedure SetHideValidation (NewHideValidationDialog: Boolean)
        begin
          HideValidationDialog := NewHideValidationDialog;
        end;
    */



    /*
    LOCAL procedure GetDefaultICPartnerGLAccNo () : Code[20];
        var
    //       GLAcc@1001 :
          GLAcc: Record 15;
    //       GLAccNo@1002 :
          GLAccNo: Code[20];
        begin
          if "IC Partner Code" <> '' then begin
            if "Account Type" = "Account Type"::"G/L Account" then
              GLAccNo := "Account No."
            else
              GLAccNo := "Bal. Account No.";
            if GLAcc.GET(GLAccNo) then
              exit(GLAcc."Default IC Partner G/L Acc. No")
          end;
        end;
    */




    /*
    procedure IsApplied () : Boolean;
        begin
          if "Applies-to Doc. No." <> '' then
            exit(TRUE);
          if "Applies-to ID" <> '' then
            exit(TRUE);
          exit(FALSE);
        end;
    */




    /*
    procedure DataCaption () : Text[250];
        var
    //       GenJnlBatch@1000 :
          GenJnlBatch: Record 232;
        begin
          if GenJnlBatch.GET("Journal Template Name","Journal Batch Name") then
            exit(GenJnlBatch.Name + '-' + GenJnlBatch.Description);
        end;
    */




    LOCAL procedure ReadGLSetup()
    begin
        if not GLSetupRead then begin
            GLSetup.GET;
            GLSetupRead := TRUE;
        end;
    end;



    //     procedure AdjustDueDate (MaxDate@1100000 :

    /*
    procedure AdjustDueDate (MaxDate: Date)
        var
    //       DueDateAdjust@1100001 :
          DueDateAdjust: Codeunit 10700;
        begin
          CASE "Account Type" OF
            "Account Type"::Customer:
              if "Bill-to/Pay-to No." <> '' then
                DueDateAdjust.SalesAdjustDueDate("Due Date","Document Date",MaxDate,"Bill-to/Pay-to No.")
              else
                DueDateAdjust.SalesAdjustDueDate("Due Date","Document Date",MaxDate,"Account No.");
            "Account Type"::Vendor:
              DueDateAdjust.PurchAdjustDueDate("Due Date","Document Date",MaxDate,"Account No.");
          end;
        end;
    */



    // procedure GetCustLedgerEntry ()
    // begin
    //   if ("Account Type" = "Account Type"::Customer) and ("Account No." = '') and
    //      ("Applies-to Doc. No." <> '') and (Amount = 0)
    //   then begin
    //     CustLedgEntry.RESET;
    //     CustLedgEntry.SETRANGE("Document No.","Applies-to Doc. No.");
    //     CustLedgEntry.SETRANGE(Open,TRUE);
    //     if not CustLedgEntry.FINDFIRST then
    //       ERROR(NotExistErr,"Applies-to Doc. No.");

    //     VALIDATE("Account No.",CustLedgEntry."Customer No.");
    //     CustLedgEntry.CALCFIELDS("Remaining Amount");

    //     if "Posting Date" <= CustLedgEntry."Pmt. Discount Date" then
    //       Amount := -(CustLedgEntry."Remaining Amount" - CustLedgEntry."Remaining Pmt. Disc. Possible")
    //     else
    //       Amount := -CustLedgEntry."Remaining Amount";

    //     if "Currency Code" <> CustLedgEntry."Currency Code" then
    //       UpdateCurrencyCode(CustLedgEntry."Currency Code");

    //     SetAppliesToFields(
    //           CustLedgEntry."Document Type",CustLedgEntry."Document No.",CustLedgEntry."External Document No.");

    //     GenJnlBatch.GET("Journal Template Name","Journal Batch Name");
    //     if GenJnlBatch."Bal. Account No." <> '' then begin
    //       "Bal. Account Type" := GenJnlBatch."Bal. Account Type";
    //       VALIDATE("Bal. Account No.",GenJnlBatch."Bal. Account No.");
    //     end else
    //       VALIDATE(Amount);
    //   end;

    //   OnAfterGetCustLedgerEntry(Rec,CustLedgEntry);
    // end;



    /*
    procedure GetVendLedgerEntry ()
        begin
          if ("Account Type" = "Account Type"::Vendor) and ("Account No." = '') and
             ("Applies-to Doc. No." <> '') and (Amount = 0)
          then begin
            VendLedgEntry.RESET;
            VendLedgEntry.SETRANGE("Document No.","Applies-to Doc. No.");
            VendLedgEntry.SETRANGE(Open,TRUE);
            if not VendLedgEntry.FINDFIRST then
              ERROR(NotExistErr,"Applies-to Doc. No.");

            VALIDATE("Account No.",VendLedgEntry."Vendor No.");
            VendLedgEntry.CALCFIELDS("Remaining Amount");

            if "Posting Date" <= VendLedgEntry."Pmt. Discount Date" then
              Amount := -(VendLedgEntry."Remaining Amount" - VendLedgEntry."Remaining Pmt. Disc. Possible")
            else
              Amount := -VendLedgEntry."Remaining Amount";

            if "Currency Code" <> VendLedgEntry."Currency Code" then
              UpdateCurrencyCode(VendLedgEntry."Currency Code");

            SetAppliesToFields(
              VendLedgEntry."Document Type",VendLedgEntry."Document No.",VendLedgEntry."External Document No.");

            GenJnlBatch.GET("Journal Template Name","Journal Batch Name");
            if GenJnlBatch."Bal. Account No." <> '' then begin
              "Bal. Account Type" := GenJnlBatch."Bal. Account Type";
              VALIDATE("Bal. Account No.",GenJnlBatch."Bal. Account No.");
            end else
              VALIDATE(Amount);
          end;

          OnAfterGetVendLedgerEntry(Rec,VendLedgEntry);
        end;
    */




    /*
    procedure GetEmplLedgerEntry ()
        begin
          if ("Account Type" = "Account Type"::Employee) and ("Account No." = '') and
             ("Applies-to Doc. No." <> '') and (Amount = 0)
          then begin
            EmplLedgEntry.RESET;
            EmplLedgEntry.SETRANGE("Document No.","Applies-to Doc. No.");
            EmplLedgEntry.SETRANGE(Open,TRUE);
            if not EmplLedgEntry.FINDFIRST then
              ERROR(NotExistErr,"Applies-to Doc. No.");

            VALIDATE("Account No.",EmplLedgEntry."Employee No.");
            EmplLedgEntry.CALCFIELDS("Remaining Amount");

            Amount := -EmplLedgEntry."Remaining Amount";

            SetAppliesToFields(EmplLedgEntry."Document Type",EmplLedgEntry."Document No.",'');

            GenJnlBatch.GET("Journal Template Name","Journal Batch Name");
            if GenJnlBatch."Bal. Account No." <> '' then begin
              "Bal. Account Type" := GenJnlBatch."Bal. Account Type";
              VALIDATE("Bal. Account No.",GenJnlBatch."Bal. Account No.");
            end else
              VALIDATE(Amount);
          end;

          OnAfterGetEmplLedgerEntry(Rec,EmplLedgEntry);
        end;
    */


    //     LOCAL procedure UpdateCurrencyCode (NewCurrencyCode@1000 :

    /*
    LOCAL procedure UpdateCurrencyCode (NewCurrencyCode: Code[10])
        var
    //       FromCurrencyCode@1002 :
          FromCurrencyCode: Code[10];
    //       ToCurrencyCode@1001 :
          ToCurrencyCode: Code[10];
        begin
          FromCurrencyCode := GetShowCurrencyCode("Currency Code");
          ToCurrencyCode := GetShowCurrencyCode(NewCurrencyCode);
          if not CONFIRM(STRSUBSTNO(ChangeCurrencyQst,FromCurrencyCode,ToCurrencyCode),TRUE) then
            ERROR(UpdateInterruptedErr);
          VALIDATE("Currency Code",NewCurrencyCode);
        end;
    */


    //     LOCAL procedure SetAppliesToFields (DocType@1000 : Option;DocNo@1001 : Code[20];ExtDocNo@1002 :

    /*
    LOCAL procedure SetAppliesToFields (DocType: Option;DocNo: Code[20];ExtDocNo: Code[35])
        begin
          UpdateDocumentTypeAndAppliesTo(DocType,DocNo);

          if ("Applies-to Doc. Type" = "Applies-to Doc. Type"::Invoice) and
             ("Document Type" = "Document Type"::Payment)
          then
            "Applies-to Ext. Doc. No." := ExtDocNo;
        end;
    */



    /*
    LOCAL procedure CustVendAccountNosModified () : Boolean;
        begin
          exit(
            (("Bal. Account No." <> xRec."Bal. Account No.") and
             ("Bal. Account Type" IN ["Bal. Account Type"::Customer,"Bal. Account Type"::Vendor])) or
            (("Account No." <> xRec."Account No.") and
             ("Account Type" IN ["Account Type"::Customer,"Account Type"::Vendor])))
        end;
    */



    /*
    LOCAL procedure CheckPaymentTolerance ()
        begin
          if Amount <> 0 then
            if ("Bal. Account No." <> xRec."Bal. Account No.") or ("Account No." <> xRec."Account No.") then
              PaymentToleranceMgt.PmtTolGenJnl(Rec);
        end;
    */




    /*
    procedure IncludeVATAmount () : Boolean;
        begin
          exit(
            ("VAT Posting" = "VAT Posting"::"Manual VAT Entry") and
            ("VAT Calculation Type" <> "VAT Calculation Type"::"Reverse Charge VAT"));
        end;
    */



    //     procedure ConvertAmtFCYToLCYForSourceCurrency (Amount@1000 :

    /*
    procedure ConvertAmtFCYToLCYForSourceCurrency (Amount: Decimal) : Decimal;
        var
    //       Currency@1001 :
          Currency: Record 4;
    //       CurrExchRate@1003 :
          CurrExchRate: Record 330;
    //       CurrencyFactor@1002 :
          CurrencyFactor: Decimal;
        begin
          if (Amount = 0) or ("Source Currency Code" = '') then
            exit(Amount);

          Currency.GET("Source Currency Code");
          CurrencyFactor := CurrExchRate.ExchangeRate("Posting Date","Source Currency Code");
          exit(
            ROUND(
              CurrExchRate.ExchangeAmtFCYToLCY(
                "Posting Date","Source Currency Code",Amount,CurrencyFactor),
              Currency."Amount Rounding Precision"));
        end;
    */




    /*
    procedure MatchSingleLedgerEntry ()
        begin
          CODEUNIT.RUN(CODEUNIT::"Match General Journal Lines",Rec);
        end;
    */




    /*
    procedure GetStyle () : Text;
        begin
          if "Applied Automatically" then
            exit('Favorable')
        end;
    */



    //     procedure GetOverdueDateInteractions (var OverdueWarningText@1001 :

    /*
    procedure GetOverdueDateInteractions (var OverdueWarningText: Text) : Text;
        var
    //       DueDate@1000 :
          DueDate: Date;
        begin
          DueDate := GetAppliesToDocDueDate;
          OverdueWarningText := '';
          if (DueDate <> 0D) and (DueDate < "Posting Date") then begin
            OverdueWarningText := DueDateMsg;
            exit('Unfavorable');
          end;
          exit('');
        end;
    */



    //     procedure ClearDataExchangeEntries (DeleteHeaderEntries@1002 :

    /*
    procedure ClearDataExchangeEntries (DeleteHeaderEntries: Boolean)
        var
    //       DataExchField@1001 :
          DataExchField: Record 1221;
    //       GenJournalLine@1000 :
          GenJournalLine: Record 81;
        begin
          if "Data Exch. Entry No." = 0 then
            exit;

          DataExchField.DeleteRelatedRecords("Data Exch. Entry No.","Data Exch. Line No.");

          GenJournalLine.SETRANGE("Journal Template Name","Journal Template Name");
          GenJournalLine.SETRANGE("Journal Batch Name","Journal Batch Name");
          GenJournalLine.SETRANGE("Data Exch. Entry No.","Data Exch. Entry No.");
          GenJournalLine.SETFILTER("Line No.",'<>%1',"Line No.");
          if GenJournalLine.ISEMPTY or DeleteHeaderEntries then
            DataExchField.DeleteRelatedRecords("Data Exch. Entry No.",0);
        end;
    */




    /*
    procedure ClearAppliedGenJnlLine ()
        var
    //       GenJournalLine@1000 :
          GenJournalLine: Record 81;
        begin
          if "Applies-to Doc. No." = '' then
            exit;
          GenJournalLine.SETRANGE("Journal Template Name","Journal Template Name");
          GenJournalLine.SETRANGE("Journal Batch Name","Journal Batch Name");
          GenJournalLine.SETFILTER("Line No.",'<>%1',"Line No.");
          GenJournalLine.SETRANGE("Document Type","Applies-to Doc. Type");
          GenJournalLine.SETRANGE("Document No.","Applies-to Doc. No.");
          GenJournalLine.MODIFYALL("Applied Automatically",FALSE);
          GenJournalLine.MODIFYALL("Account Type",GenJournalLine."Account Type"::"G/L Account");
          GenJournalLine.MODIFYALL("Account No.",'');
        end;
    */




    /*
    procedure GetIncomingDocumentURL () : Text[1000];
        var
    //       IncomingDocument@1000 :
          IncomingDocument: Record 130;
        begin
          if "Incoming Document Entry No." = 0 then
            exit('');

          IncomingDocument.GET("Incoming Document Entry No.");
          exit(IncomingDocument.GetURL);
        end;
    */



    //     procedure InsertPaymentFileError (Text@1001 :

    /*
    procedure InsertPaymentFileError (Text: Text)
        var
    //       PaymentJnlExportErrorText@1000 :
          PaymentJnlExportErrorText: Record 1228;
        begin
          PaymentJnlExportErrorText.CreateNew(Rec,Text,'','');
        end;
    */



    //     procedure InsertPaymentFileErrorWithDetails (ErrorText@1001 : Text;AddnlInfo@1002 : Text;ExtSupportInfo@1003 :

    /*
    procedure InsertPaymentFileErrorWithDetails (ErrorText: Text;AddnlInfo: Text;ExtSupportInfo: Text)
        var
    //       PaymentJnlExportErrorText@1000 :
          PaymentJnlExportErrorText: Record 1228;
        begin
          PaymentJnlExportErrorText.CreateNew(Rec,ErrorText,AddnlInfo,ExtSupportInfo);
        end;
    */




    /*
    procedure DeletePaymentFileBatchErrors ()
        var
    //       PaymentJnlExportErrorText@1000 :
          PaymentJnlExportErrorText: Record 1228;
        begin
          PaymentJnlExportErrorText.DeleteJnlBatchErrors(Rec);
        end;
    */




    /*
    procedure DeletePaymentFileErrors ()
        var
    //       PaymentJnlExportErrorText@1000 :
          PaymentJnlExportErrorText: Record 1228;
        begin
          PaymentJnlExportErrorText.DeleteJnlLineErrors(Rec);
        end;
    */




    /*
    procedure HasPaymentFileErrors () : Boolean;
        var
    //       PaymentJnlExportErrorText@1000 :
          PaymentJnlExportErrorText: Record 1228;
        begin
          exit(PaymentJnlExportErrorText.JnlLineHasErrors(Rec));
        end;
    */




    /*
    procedure HasPaymentFileErrorsInBatch () : Boolean;
        var
    //       PaymentJnlExportErrorText@1000 :
          PaymentJnlExportErrorText: Record 1228;
        begin
          exit(PaymentJnlExportErrorText.JnlBatchHasErrors(Rec));
        end;
    */


    //     LOCAL procedure UpdateDescription (Name@1000 :

    /*
    LOCAL procedure UpdateDescription (Name: Text[50])
        begin
          if not IsAdHocDescription then
            Description := Name;
        end;
    */



    /*
    LOCAL procedure IsAdHocDescription () : Boolean;
        var
    //       GLAccount@1000 :
          GLAccount: Record 15;
    //       Customer@1001 :
          Customer: Record 18;
    //       Vendor@1002 :
          Vendor: Record 23;
    //       BankAccount@1003 :
          BankAccount: Record 270;
    //       FixedAsset@1004 :
          FixedAsset: Record 5600;
    //       ICPartner@1005 :
          ICPartner: Record 413;
    //       Employee@1006 :
          Employee: Record 5200;
        begin
          if Description = '' then
            exit(FALSE);
          if xRec."Account No." = '' then
            exit(TRUE);

          CASE xRec."Account Type" OF
            xRec."Account Type"::"G/L Account":
              exit(GLAccount.GET(xRec."Account No.") and (GLAccount.Name <> Description));
            xRec."Account Type"::Customer:
              exit(Customer.GET(xRec."Account No.") and (Customer.Name <> Description));
            xRec."Account Type"::Vendor:
              exit(Vendor.GET(xRec."Account No.") and (Vendor.Name <> Description));
            xRec."Account Type"::"Bank Account":
              exit(BankAccount.GET(xRec."Account No.") and (BankAccount.Name <> Description));
            xRec."Account Type"::"Fixed Asset":
              exit(FixedAsset.GET(xRec."Account No.") and (FixedAsset.Description <> Description));
            xRec."Account Type"::"IC Partner":
              exit(ICPartner.GET(xRec."Account No.") and (ICPartner.Name <> Description));
            xRec."Account Type"::Employee:
              exit(Employee.GET(xRec."Account No.") and (Employee.FullName <> Description));
          end;
          exit(FALSE);
        end;
    */




    /*
    procedure GetAppliesToDocEntryNo () : Integer;
        var
    //       CustLedgEntry@1000 :
          CustLedgEntry: Record 21;
    //       VendLedgEntry@1001 :
          VendLedgEntry: Record 25;
    //       AccType@1003 :
          AccType: Option "G/L Account","Customer","Vendor","Bank Account","Fixed Asset","IC Partner","Employee";
    //       AccNo@1002 :
          AccNo: Code[20];
        begin
          GetAccTypeAndNo(Rec,AccType,AccNo);
          CASE AccType OF
            AccType::Customer:
              begin
                GetAppliesToDocCustLedgEntry(CustLedgEntry,AccNo);
                exit(CustLedgEntry."Entry No.");
              end;
            AccType::Vendor:
              begin
                GetAppliesToDocVendLedgEntry(VendLedgEntry,AccNo);
                exit(VendLedgEntry."Entry No.");
              end;
            AccType::Employee:
              begin
                GetAppliesToDocEmplLedgEntry(EmplLedgEntry,AccNo);
                exit(EmplLedgEntry."Entry No.");
              end;
          end;
        end;
    */




    /*
    procedure GetAppliesToDocDueDate () : Date;
        var
    //       CustLedgEntry@1000 :
          CustLedgEntry: Record 21;
    //       VendLedgEntry@1001 :
          VendLedgEntry: Record 25;
    //       AccType@1003 :
          AccType: Option "G/L Account","Customer","Vendor","Bank Account","Fixed Asset";
    //       AccNo@1002 :
          AccNo: Code[20];
        begin
          GetAccTypeAndNo(Rec,AccType,AccNo);
          CASE AccType OF
            AccType::Customer:
              begin
                GetAppliesToDocCustLedgEntry(CustLedgEntry,AccNo);
                exit(CustLedgEntry."Due Date");
              end;
            AccType::Vendor:
              begin
                GetAppliesToDocVendLedgEntry(VendLedgEntry,AccNo);
                exit(VendLedgEntry."Due Date");
              end;
          end;
        end;
    */


    //     LOCAL procedure GetAppliesToDocCustLedgEntry (var CustLedgEntry@1000 : Record 21;AccNo@1001 :

    /*
    LOCAL procedure GetAppliesToDocCustLedgEntry (var CustLedgEntry: Record 21;AccNo: Code[20])
        begin
          CustLedgEntry.SETRANGE("Customer No.",AccNo);
          CustLedgEntry.SETRANGE(Open,TRUE);
          if "Applies-to Doc. No." <> '' then begin
            CustLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
            CustLedgEntry.SETRANGE("Document No.","Applies-to Doc. No.");
            CustLedgEntry.SETRANGE("Bill No.","Applies-to Bill No.");
            if CustLedgEntry.FINDFIRST then;
          end else
            if "Applies-to ID" <> '' then begin
              CustLedgEntry.SETRANGE("Applies-to ID","Applies-to ID");
              if CustLedgEntry.FINDFIRST then;
            end;
        end;
    */


    //     LOCAL procedure GetAppliesToDocVendLedgEntry (var VendLedgEntry@1000 : Record 25;AccNo@1001 :

    /*
    LOCAL procedure GetAppliesToDocVendLedgEntry (var VendLedgEntry: Record 25;AccNo: Code[20])
        begin
          VendLedgEntry.SETRANGE("Vendor No.",AccNo);
          VendLedgEntry.SETRANGE(Open,TRUE);
          if "Applies-to Doc. No." <> '' then begin
            VendLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
            VendLedgEntry.SETRANGE("Document No.","Applies-to Doc. No.");
            VendLedgEntry.SETRANGE("Bill No.","Applies-to Bill No.");
            if VendLedgEntry.FINDFIRST then;
          end else
            if "Applies-to ID" <> '' then begin
              VendLedgEntry.SETRANGE("Applies-to ID","Applies-to ID");
              if VendLedgEntry.FINDFIRST then;
            end;
        end;
    */


    //     LOCAL procedure GetAppliesToDocEmplLedgEntry (var EmplLedgEntry@1000 : Record 5222;AccNo@1001 :

    /*
    LOCAL procedure GetAppliesToDocEmplLedgEntry (var EmplLedgEntry: Record 5222;AccNo: Code[20])
        begin
          EmplLedgEntry.SETRANGE("Employee No.",AccNo);
          EmplLedgEntry.SETRANGE(Open,TRUE);
          if "Applies-to Doc. No." <> '' then begin
            EmplLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
            EmplLedgEntry.SETRANGE("Document No.","Applies-to Doc. No.");
            if EmplLedgEntry.FINDFIRST then;
          end else
            if "Applies-to ID" <> '' then begin
              EmplLedgEntry.SETRANGE("Applies-to ID","Applies-to ID");
              if EmplLedgEntry.FINDFIRST then;
            end;
        end;
    */



    /*
    procedure SetJournalLineFieldsFromApplication ()
        var
    //       AccType@1005 :
          AccType: Option "G/L Account","Customer","Vendor","Bank Account","Fixed Asset","IC Partner","Employee";
    //       AccNo@1004 :
          AccNo: Code[20];
    //       RecBankAccount@1100002 :
          RecBankAccount: Code[20];
        begin
          "Exported to Payment File" := FALSE;
          GetAccTypeAndNo(Rec,AccType,AccNo);
          CASE AccType OF
            AccType::Customer:
              if "Applies-to ID" <> '' then begin
                if FindFirstCustLedgEntryWithAppliesToID(AccNo,"Applies-to ID") then begin
                  CustLedgEntry.SETRANGE("Exported to Payment File",TRUE);
                  "Exported to Payment File" := CustLedgEntry.FINDFIRST;
                end
              end else
                if "Applies-to Doc. No." <> '' then
                  if FindFirstCustLedgEntryWithAppliesToDocNo(AccNo,"Applies-to Doc. No.") then begin
                    "Exported to Payment File" := CustLedgEntry."Exported to Payment File";
                    "Applies-to Ext. Doc. No." := CustLedgEntry."External Document No.";
                    RecBankAccount := CustLedgEntry."Recipient Bank Account";
                  end;
            AccType::Vendor:
              if "Applies-to ID" <> '' then begin
                if FindFirstVendLedgEntryWithAppliesToID(AccNo,"Applies-to ID") then begin
                  VendLedgEntry.SETRANGE("Exported to Payment File",TRUE);
                  "Exported to Payment File" := VendLedgEntry.FINDFIRST;
                end
              end else
                if "Applies-to Doc. No." <> '' then
                  if FindFirstVendLedgEntryWithAppliesToDocNo(AccNo,"Applies-to Doc. No.") then begin
                    "Exported to Payment File" := VendLedgEntry."Exported to Payment File";
                    "Applies-to Ext. Doc. No." := VendLedgEntry."External Document No.";
                    RecBankAccount := VendLedgEntry."Recipient Bank Account";
                  end;
            AccType::Employee:
              if "Applies-to ID" <> '' then begin
                if FindFirstEmplLedgEntryWithAppliesToID(AccNo,"Applies-to ID") then begin
                  EmplLedgEntry.SETRANGE("Exported to Payment File",TRUE);
                  "Exported to Payment File" := EmplLedgEntry.FINDFIRST;
                end
              end else
                if "Applies-to Doc. No." <> '' then
                  if FindFirstEmplLedgEntryWithAppliesToDocNo(AccNo,"Applies-to Doc. No.") then
                    "Exported to Payment File" := EmplLedgEntry."Exported to Payment File";
          end;
          SetApplnRecipientBankAccount(AccType,AccNo,"Applies-to Doc. No.",RecBankAccount);

          OnAfterSetJournalLineFieldsFromApplication(Rec,AccType,AccNo);
        end;
    */


    //     LOCAL procedure GetAccTypeAndNo (GenJnlLine2@1002 : Record 81;var AccType@1000 : Option;var AccNo@1001 :

    /*
    LOCAL procedure GetAccTypeAndNo (GenJnlLine2: Record 81;var AccType: Option;var AccNo: Code[20])
        begin
          if GenJnlLine2."Bal. Account Type" IN
             [GenJnlLine2."Bal. Account Type"::Customer,GenJnlLine2."Bal. Account Type"::Vendor,GenJnlLine2."Bal. Account Type"::Employee]
          then begin
            AccType := GenJnlLine2."Bal. Account Type";
            AccNo := GenJnlLine2."Bal. Account No.";
          end else begin
            AccType := GenJnlLine2."Account Type";
            AccNo := GenJnlLine2."Account No.";
          end;
        end;
    */


    //     LOCAL procedure FindFirstCustLedgEntryWithAppliesToID (AccNo@1000 : Code[20];AppliesToID@1001 :

    /*
    LOCAL procedure FindFirstCustLedgEntryWithAppliesToID (AccNo: Code[20];AppliesToID: Code[50]) : Boolean;
        begin
          CustLedgEntry.RESET;
          CustLedgEntry.SETCURRENTKEY("Customer No.","Applies-to ID",Open);
          CustLedgEntry.SETRANGE("Customer No.",AccNo);
          CustLedgEntry.SETRANGE("Applies-to ID",AppliesToID);
          CustLedgEntry.SETRANGE(Open,TRUE);
          exit(CustLedgEntry.FINDFIRST)
        end;
    */


    //     LOCAL procedure FindFirstCustLedgEntryWithAppliesToDocNo (AccNo@1000 : Code[20];AppliestoDocNo@1001 :

    /*
    LOCAL procedure FindFirstCustLedgEntryWithAppliesToDocNo (AccNo: Code[20];AppliestoDocNo: Code[20]) : Boolean;
        begin
          CustLedgEntry.RESET;
          CustLedgEntry.SETCURRENTKEY("Document No.");
          CustLedgEntry.SETRANGE("Document No.",AppliestoDocNo);
          CustLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
          CustLedgEntry.SETRANGE("Bill No.","Applies-to Bill No.");
          CustLedgEntry.SETRANGE("Customer No.",AccNo);
          CustLedgEntry.SETRANGE(Open,TRUE);
          exit(CustLedgEntry.FINDFIRST)
        end;
    */


    //     LOCAL procedure FindFirstVendLedgEntryWithAppliesToID (AccNo@1000 : Code[20];AppliesToID@1001 :

    /*
    LOCAL procedure FindFirstVendLedgEntryWithAppliesToID (AccNo: Code[20];AppliesToID: Code[50]) : Boolean;
        begin
          VendLedgEntry.RESET;
          VendLedgEntry.SETCURRENTKEY("Vendor No.","Applies-to ID",Open);
          VendLedgEntry.SETRANGE("Vendor No.",AccNo);
          VendLedgEntry.SETRANGE("Applies-to ID",AppliesToID);
          VendLedgEntry.SETRANGE(Open,TRUE);
          exit(VendLedgEntry.FINDFIRST)
        end;
    */


    //     LOCAL procedure FindFirstVendLedgEntryWithAppliesToDocNo (AccNo@1000 : Code[20];AppliestoDocNo@1001 :

    /*
    LOCAL procedure FindFirstVendLedgEntryWithAppliesToDocNo (AccNo: Code[20];AppliestoDocNo: Code[20]) : Boolean;
        begin
          VendLedgEntry.RESET;
          VendLedgEntry.SETCURRENTKEY("Document No.");
          VendLedgEntry.SETRANGE("Document No.",AppliestoDocNo);
          VendLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
          VendLedgEntry.SETRANGE("Bill No.","Applies-to Bill No.");
          VendLedgEntry.SETRANGE("Vendor No.",AccNo);
          VendLedgEntry.SETRANGE(Open,TRUE);
          exit(VendLedgEntry.FINDFIRST)
        end;
    */


    //     LOCAL procedure FindFirstEmplLedgEntryWithAppliesToID (AccNo@1000 : Code[20];AppliesToID@1001 :

    /*
    LOCAL procedure FindFirstEmplLedgEntryWithAppliesToID (AccNo: Code[20];AppliesToID: Code[50]) : Boolean;
        begin
          EmplLedgEntry.RESET;
          EmplLedgEntry.SETCURRENTKEY("Employee No.","Applies-to ID",Open);
          EmplLedgEntry.SETRANGE("Employee No.",AccNo);
          EmplLedgEntry.SETRANGE("Applies-to ID",AppliesToID);
          EmplLedgEntry.SETRANGE(Open,TRUE);
          exit(EmplLedgEntry.FINDFIRST)
        end;
    */


    //     LOCAL procedure FindFirstEmplLedgEntryWithAppliesToDocNo (AccNo@1000 : Code[20];AppliestoDocNo@1001 :

    /*
    LOCAL procedure FindFirstEmplLedgEntryWithAppliesToDocNo (AccNo: Code[20];AppliestoDocNo: Code[20]) : Boolean;
        begin
          EmplLedgEntry.RESET;
          EmplLedgEntry.SETCURRENTKEY("Document No.");
          EmplLedgEntry.SETRANGE("Document No.",AppliestoDocNo);
          EmplLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
          EmplLedgEntry.SETRANGE("Employee No.",AccNo);
          EmplLedgEntry.SETRANGE(Open,TRUE);
          exit(EmplLedgEntry.FINDFIRST)
        end;
    */



    /*
    LOCAL procedure ClearPostingGroups ()
        begin
          "Gen. Posting Type" := "Gen. Posting Type"::" ";
          "Gen. Bus. Posting Group" := '';
          "Gen. Prod. Posting Group" := '';
          "VAT Bus. Posting Group" := '';
          "VAT Prod. Posting Group" := '';

          OnAfterClearPostingGroups(Rec);
        end;
    */



    /*
    LOCAL procedure ClearBalancePostingGroups ()
        begin
          "Bal. Gen. Posting Type" := "Bal. Gen. Posting Type"::" ";
          "Bal. Gen. Bus. Posting Group" := '';
          "Bal. Gen. Prod. Posting Group" := '';
          "Bal. VAT Bus. Posting Group" := '';
          "Bal. VAT Prod. Posting Group" := '';

          OnAfterClearBalPostingGroups(Rec);
        end;
    */



    /*
    LOCAL procedure CleanLine ()
        begin
          UpdateLineBalance;
          UpdateSource;
          CreateDim(
            DimMgt.TypeToTableID1("Account Type"),"Account No.",
            DimMgt.TypeToTableID1("Bal. Account Type"),"Bal. Account No.",
            DATABASE::Job,"Job No.",
            DATABASE::"Salesperson/Purchaser","Salespers./Purch. Code",
            DATABASE::Campaign,"Campaign No.");
          if not ("Bal. Account Type" IN ["Bal. Account Type"::Customer,"Bal. Account Type"::Vendor]) then
            "Recipient Bank Account" := '';
          if xRec."Account No." <> '' then begin
            ClearPostingGroups;
            "Tax Area Code" := '';
            "Tax Liable" := FALSE;
            "Tax Group Code" := '';
            "Bill-to/Pay-to No." := '';
            "Ship-to/Order Address Code" := '';
            "Sell-to/Buy-from No." := '';
            UpdateCountryCodeAndVATRegNo('');
          end;

          CASE "Account Type" OF
            "Account Type"::"G/L Account":
              UpdateAccountID;
            "Account Type"::Customer:
              UpdateCustomerID;
          end;
        end;
    */




    LOCAL procedure ReplaceDescription(): Boolean;
    begin
        if "Bal. Account No." = '' then
            exit(TRUE);
        GenJnlBatch.GET("Journal Template Name", "Journal Batch Name");
        exit(GenJnlBatch."Bal. Account No." <> '');
    end;



    //     LOCAL procedure AddCustVendIC (AccountType@1000 : Option;AccountNo@1001 :

    /*
    LOCAL procedure AddCustVendIC (AccountType: Option;AccountNo: Code[20]) : Boolean;
        begin
          SETRANGE("Account Type",AccountType);
          SETRANGE("Account No.",AccountNo);
          if not ISEMPTY then
            exit(FALSE);

          RESET;
          if FINDLAST then;
          "Line No." += 10000;

          "Account Type" := AccountType;
          "Account No." := AccountNo;
          INSERT;
          exit(TRUE);
        end;
    */



    //     procedure IsCustVendICAdded (GenJournalLine@1000 :

    /*
    procedure IsCustVendICAdded (GenJournalLine: Record 81) : Boolean;
        begin
          if (GenJournalLine."Account No." <> '') and
             (GenJournalLine."Account Type" IN ["Account Type"::Customer,"Account Type"::Vendor,"Account Type"::"IC Partner"])
          then
            exit(AddCustVendIC(GenJournalLine."Account Type",GenJournalLine."Account No."));

          if (GenJournalLine."Bal. Account No." <> '') and
             (GenJournalLine."Bal. Account Type" IN ["Bal. Account Type"::Customer,
                                                     "Bal. Account Type"::Vendor,
                                                     "Bal. Account Type"::"IC Partner"])
          then
            exit(AddCustVendIC(GenJournalLine."Bal. Account Type",GenJournalLine."Bal. Account No."));

          exit(FALSE);
        end;
    */




    /*
    procedure IsExportedToPaymentFile () : Boolean;
        begin
          exit(IsPaymentJournallLineExported or IsAppliedToVendorLedgerEntryExported);
        end;
    */




    /*
    procedure IsPaymentJournallLineExported () : Boolean;
        var
    //       GenJnlLine@1001 :
          GenJnlLine: Record 81;
    //       OldFilterGroup@1000 :
          OldFilterGroup: Integer;
    //       HasExportedLines@1002 :
          HasExportedLines: Boolean;
        begin
          WITH GenJnlLine DO begin
            COPYFILTERS(Rec);
            OldFilterGroup := FILTERGROUP;
            FILTERGROUP := 10;
            SETRANGE("Exported to Payment File",TRUE);
            HasExportedLines := not ISEMPTY;
            SETRANGE("Exported to Payment File");
            FILTERGROUP := OldFilterGroup;
          end;
          exit(HasExportedLines);
        end;
    */




    /*
    procedure IsAppliedToVendorLedgerEntryExported () : Boolean;
        var
    //       GenJnlLine@1001 :
          GenJnlLine: Record 81;
    //       VendLedgerEntry@1002 :
          VendLedgerEntry: Record 25;
        begin
          GenJnlLine.COPYFILTERS(Rec);

          if GenJnlLine.FINDSET then
            repeat
              if GenJnlLine.IsApplied then begin
                VendLedgerEntry.SETRANGE("Vendor No.",GenJnlLine."Account No.");
                if GenJnlLine."Applies-to Doc. No." <> '' then begin
                  VendLedgerEntry.SETRANGE("Document Type",GenJnlLine."Applies-to Doc. Type");
                  VendLedgerEntry.SETRANGE("Document No.",GenJnlLine."Applies-to Doc. No.");
                end;
                if GenJnlLine."Applies-to ID" <> '' then
                  VendLedgerEntry.SETRANGE("Applies-to ID",GenJnlLine."Applies-to ID");
                VendLedgerEntry.SETRANGE("Exported to Payment File",TRUE);
                if not VendLedgerEntry.ISEMPTY then
                  exit(TRUE);
              end;

              VendLedgerEntry.RESET;
              VendLedgerEntry.SETRANGE("Vendor No.",GenJnlLine."Account No.");
              VendLedgerEntry.SETRANGE("Applies-to Doc. Type",GenJnlLine."Document Type");
              VendLedgerEntry.SETRANGE("Applies-to Doc. No.",GenJnlLine."Document No.");
              VendLedgerEntry.SETRANGE("Exported to Payment File",TRUE);
              if not VendLedgerEntry.ISEMPTY then
                exit(TRUE);
            until GenJnlLine.NEXT = 0;

          exit(FALSE);
        end;
    */



    /*
    LOCAL procedure ClearAppliedAutomatically ()
        begin
          if CurrFieldNo <> 0 then
            "Applied Automatically" := FALSE;
        end;
    */



    //     procedure SetPostingDateAsDueDate (DueDate@1002 : Date;DateOffset@1000 :

    /*
    procedure SetPostingDateAsDueDate (DueDate: Date;DateOffset: DateFormula) : Boolean;
        var
    //       NewPostingDate@1001 :
          NewPostingDate: Date;
        begin
          if DueDate = 0D then
            exit(FALSE);

          NewPostingDate := CALCDATE(DateOffset,DueDate);
          if NewPostingDate < WORKDATE then begin
            VALIDATE("Posting Date",WORKDATE);
            exit(TRUE);
          end;

          VALIDATE("Posting Date",NewPostingDate);
          exit(FALSE);
        end;
    */




    /*
    procedure CalculatePostingDate ()
        var
    //       GenJnlLine@1000 :
          GenJnlLine: Record 81;
    //       EmptyDateFormula@1001 :
          EmptyDateFormula: DateFormula;
        begin
          GenJnlLine.COPY(Rec);
          GenJnlLine.SETRANGE("Journal Template Name","Journal Template Name");
          GenJnlLine.SETRANGE("Journal Batch Name","Journal Batch Name");

          if GenJnlLine.FINDSET then begin
            Window.OPEN(CalcPostDateMsg);
            repeat
              EVALUATE(EmptyDateFormula,'<0D>');
              GenJnlLine.SetPostingDateAsDueDate(GenJnlLine.GetAppliesToDocDueDate,EmptyDateFormula);
              GenJnlLine.MODIFY(TRUE);
              Window.UPDATE(1,GenJnlLine."Document No.");
            until GenJnlLine.NEXT = 0;
            Window.CLOSE;
          end;
        end;
    */




    /*
    procedure ImportBankStatement ()
        var
    //       ProcessGenJnlLines@1000 :
          ProcessGenJnlLines: Codeunit 1247;
        begin
          ProcessGenJnlLines.ImportBankStatement(Rec);
        end;
    */




    /*
    procedure ExportPaymentFile ()
        var
    //       BankAcc@1000 :
          BankAcc: Record 270;
        begin
          if not FINDSET then
            ERROR(NothingToExportErr);
          SETRANGE("Journal Template Name","Journal Template Name");
          SETRANGE("Journal Batch Name","Journal Batch Name");
          TESTFIELD("Check Printed",FALSE);

          CheckDocNoOnLines;
          if IsExportedToPaymentFile then
            if not CONFIRM(ExportAgainQst) then
              exit;
          BankAcc.GET("Bal. Account No.");
          if BankAcc.GetPaymentExportCodeunitID > 0 then
            CODEUNIT.RUN(BankAcc.GetPaymentExportCodeunitID,Rec)
          else
            CODEUNIT.RUN(CODEUNIT::"Exp. Launcher Gen. Jnl.",Rec);
        end;
    */




    /*
    procedure TotalExportedAmount () : Decimal;
        var
    //       CreditTransferEntry@1000 :
          CreditTransferEntry: Record 1206;
        begin
          if not ("Account Type" IN ["Account Type"::Customer,"Account Type"::Vendor,"Account Type"::Employee]) then
            exit(0);
          GenJnlShowCTEntries.SetFiltersOnCreditTransferEntry(Rec,CreditTransferEntry);
          CreditTransferEntry.CALCSUMS("Transfer Amount");
          exit(CreditTransferEntry."Transfer Amount");
        end;
    */




    /*
    procedure DrillDownExportedAmount ()
        var
    //       CreditTransferEntry@1000 :
          CreditTransferEntry: Record 1206;
        begin
          if not ("Account Type" IN ["Account Type"::Customer,"Account Type"::Vendor,"Account Type"::Employee]) then
            exit;
          GenJnlShowCTEntries.SetFiltersOnCreditTransferEntry(Rec,CreditTransferEntry);
          PAGE.RUN(PAGE::"Credit Transfer Reg. Entries",CreditTransferEntry);
        end;
    */



    /*
    LOCAL procedure CopyDimensionsFromJobTaskLine ()
        begin
          "Dimension Set ID" := TempJobJnlLine."Dimension Set ID";
          "Shortcut Dimension 1 Code" := TempJobJnlLine."Shortcut Dimension 1 Code";
          "Shortcut Dimension 2 Code" := TempJobJnlLine."Shortcut Dimension 2 Code";
        end;
    */



    //     procedure CopyDocumentFields (DocType@1004 : Option;DocNo@1003 : Code[20];ExtDocNo@1002 : Text[35];SourceCode@1001 : Code[10];NoSeriesCode@1000 :

    /*
    procedure CopyDocumentFields (DocType: Option;DocNo: Code[20];ExtDocNo: Text[35];SourceCode: Code[10];NoSeriesCode: Code[20])
        begin
          "Document Type" := DocType;
          "Document No." := DocNo;
          "External Document No." := ExtDocNo;
          "Source Code" := SourceCode;
          if NoSeriesCode <> '' then
            "Posting No. Series" := NoSeriesCode;
        end;
    */



    //     procedure CopyCustLedgEntry (CustLedgerEntry@1000 :

    /*
    procedure CopyCustLedgEntry (CustLedgerEntry: Record 21)
        begin
          "Document Type" := CustLedgerEntry."Document Type";
          Description := CustLedgerEntry.Description;
          "Shortcut Dimension 1 Code" := CustLedgerEntry."Global Dimension 1 Code";
          "Shortcut Dimension 2 Code" := CustLedgerEntry."Global Dimension 2 Code";
          "Dimension Set ID" := CustLedgerEntry."Dimension Set ID";
          "Posting Group" := CustLedgerEntry."Customer Posting Group";
          "Source Type" := "Source Type"::Customer;
          "Source No." := CustLedgerEntry."Customer No.";

          OnAfterCopyGenJnlLineFromCustLedgEntry(CustLedgEntry,Rec);
        end;
    */



    //     procedure CopyFromGenJnlAllocation (GenJnlAlloc@1000 :

    /*
    procedure CopyFromGenJnlAllocation (GenJnlAlloc: Record 221)
        begin
          "Account No." := GenJnlAlloc."Account No.";
          "Shortcut Dimension 1 Code" := GenJnlAlloc."Shortcut Dimension 1 Code";
          "Shortcut Dimension 2 Code" := GenJnlAlloc."Shortcut Dimension 2 Code";
          "Dimension Set ID" := GenJnlAlloc."Dimension Set ID";
          "Gen. Posting Type" := GenJnlAlloc."Gen. Posting Type";
          "Gen. Bus. Posting Group" := GenJnlAlloc."Gen. Bus. Posting Group";
          "Gen. Prod. Posting Group" := GenJnlAlloc."Gen. Prod. Posting Group";
          "VAT Bus. Posting Group" := GenJnlAlloc."VAT Bus. Posting Group";
          "VAT Prod. Posting Group" := GenJnlAlloc."VAT Prod. Posting Group";
          "Tax Area Code" := GenJnlAlloc."Tax Area Code";
          "Tax Liable" := GenJnlAlloc."Tax Liable";
          "Tax Group Code" := GenJnlAlloc."Tax Group Code";
          "Use Tax" := GenJnlAlloc."Use Tax";
          "VAT Calculation Type" := GenJnlAlloc."VAT Calculation Type";
          "VAT Amount" := GenJnlAlloc."VAT Amount";
          "VAT Base Amount" := GenJnlAlloc.Amount - GenJnlAlloc."VAT Amount";
          "VAT %" := GenJnlAlloc."VAT %";
          "Source Currency Amount" := GenJnlAlloc."Additional-Currency Amount";
          Amount := GenJnlAlloc.Amount;
          "Amount (LCY)" := GenJnlAlloc.Amount;

          OnAfterCopyGenJnlLineFromGenJnlAllocation(GenJnlAlloc,Rec);
        end;
    */



    //     procedure CopyFromInvoicePostBuffer (InvoicePostBuffer@1001 :


    procedure CopyFromInvoicePostBuffer(InvoicePostBuffer: Record "Invoice Posting Buffer")
    begin
        "Account No." := InvoicePostBuffer."G/L Account";
        "System-Created Entry" := InvoicePostBuffer."System-Created Entry";
        "Gen. Bus. Posting Group" := InvoicePostBuffer."Gen. Bus. Posting Group";
        "Gen. Prod. Posting Group" := InvoicePostBuffer."Gen. Prod. Posting Group";
        "VAT Bus. Posting Group" := InvoicePostBuffer."VAT Bus. Posting Group";
        "VAT Prod. Posting Group" := InvoicePostBuffer."VAT Prod. Posting Group";
        "Tax Area Code" := InvoicePostBuffer."Tax Area Code";
        "Tax Liable" := InvoicePostBuffer."Tax Liable";
        "Tax Group Code" := InvoicePostBuffer."Tax Group Code";
        "Use Tax" := InvoicePostBuffer."Use Tax";
        Quantity := InvoicePostBuffer.Quantity;
        "VAT %" := InvoicePostBuffer."VAT %";
        "VAT Calculation Type" := InvoicePostBuffer."VAT Calculation Type";
        "VAT Posting" := "VAT Posting"::"Manual VAT Entry";
        "Job No." := InvoicePostBuffer."Job No.";
        "Deferral Code" := InvoicePostBuffer."Deferral Code";
        "Deferral Line No." := InvoicePostBuffer."Deferral Line No.";
        Amount := InvoicePostBuffer.Amount;
        "Source Currency Amount" := InvoicePostBuffer."Amount (ACY)";
        "VAT Base Amount" := InvoicePostBuffer."VAT Base Amount";
        "Source Curr. VAT Base Amount" := InvoicePostBuffer."VAT Base Amount (ACY)";
        "VAT Amount" := InvoicePostBuffer."VAT Amount";
        "Source Curr. VAT Amount" := InvoicePostBuffer."VAT Amount (ACY)";
        "VAT Difference" := InvoicePostBuffer."VAT Difference";
        "VAT Base Before Pmt. Disc." := InvoicePostBuffer."VAT Base Before Pmt. Disc.";

        OnAfterCopyGenJnlLineFromInvPostBuffer(InvoicePostBuffer, Rec);
    end;




    //     procedure CopyFromInvoicePostBufferFA (InvoicePostBuffer@1001 :


    procedure CopyFromInvoicePostBufferFA(InvoicePostBuffer: Record "Invoice Posting Buffer")
    begin
        "Account Type" := "Account Type"::"Fixed Asset";
        "FA Posting Date" := InvoicePostBuffer."FA Posting Date";
        "Depreciation Book Code" := InvoicePostBuffer."Depreciation Book Code";
        "Salvage Value" := InvoicePostBuffer."Salvage Value";
        "Depr. until FA Posting Date" := InvoicePostBuffer."Depr. until FA Posting Date";
        "Depr. Acquisition Cost" := InvoicePostBuffer."Depr. Acquisition Cost";
        "Maintenance Code" := InvoicePostBuffer."Maintenance Code";
        "Insurance No." := InvoicePostBuffer."Insurance No.";
        "Budgeted FA No." := InvoicePostBuffer."Budgeted FA No.";
        "Duplicate in Depreciation Book" := InvoicePostBuffer."Duplicate in Depreciation Book";
        "Use Duplication List" := InvoicePostBuffer."Use Duplication List";

        OnAfterCopyGenJnlLineFromInvPostBufferFA(InvoicePostBuffer, Rec);
    end;




    //     procedure CopyFromPrepmtInvoiceBuffer (PrepmtInvLineBuffer@1001 :

    /*
    procedure CopyFromPrepmtInvoiceBuffer (PrepmtInvLineBuffer: Record 461)
        begin
          "Account No." := PrepmtInvLineBuffer."G/L Account No.";
          "Gen. Bus. Posting Group" := PrepmtInvLineBuffer."Gen. Bus. Posting Group";
          "Gen. Prod. Posting Group" := PrepmtInvLineBuffer."Gen. Prod. Posting Group";
          "VAT Bus. Posting Group" := PrepmtInvLineBuffer."VAT Bus. Posting Group";
          "VAT Prod. Posting Group" := PrepmtInvLineBuffer."VAT Prod. Posting Group";
          "Tax Area Code" := PrepmtInvLineBuffer."Tax Area Code";
          "Tax Liable" := PrepmtInvLineBuffer."Tax Liable";
          "Tax Group Code" := PrepmtInvLineBuffer."Tax Group Code";
          "Use Tax" := FALSE;
          "VAT Calculation Type" := PrepmtInvLineBuffer."VAT Calculation Type";
          "Job No." := PrepmtInvLineBuffer."Job No.";
          Amount := PrepmtInvLineBuffer.Amount;
          "Source Currency Amount" := PrepmtInvLineBuffer."Amount (ACY)";
          "VAT Base Amount" := PrepmtInvLineBuffer."VAT Base Amount";
          "Source Curr. VAT Base Amount" := PrepmtInvLineBuffer."VAT Base Amount (ACY)";
          "VAT Amount" := PrepmtInvLineBuffer."VAT Amount";
          "Source Curr. VAT Amount" := PrepmtInvLineBuffer."VAT Amount (ACY)";
          "VAT Difference" := PrepmtInvLineBuffer."VAT Difference";
          "VAT Base Before Pmt. Disc." := PrepmtInvLineBuffer."VAT Base Before Pmt. Disc.";

          OnAfterCopyGenJnlLineFromPrepmtInvBuffer(PrepmtInvLineBuffer,Rec);
        end;
    */



    //     procedure CopyFromPurchHeader (PurchHeader@1001 :

    /*
    procedure CopyFromPurchHeader (PurchHeader: Record 38)
        begin
          "Source Currency Code" := PurchHeader."Currency Code";
          "Currency Factor" := PurchHeader."Currency Factor";
          Correction := PurchHeader.Correction;
          "VAT Base Discount %" := PurchHeader."VAT Base Discount %";
          "Sell-to/Buy-from No." := PurchHeader."Buy-from Vendor No.";
          "Bill-to/Pay-to No." := PurchHeader."Pay-to Vendor No.";
          "Country/Region Code" := PurchHeader."VAT Country/Region Code";
          "VAT Registration No." := PurchHeader."VAT Registration No.";
          "Source Type" := "Source Type"::Vendor;
          "Source No." := PurchHeader."Pay-to Vendor No.";
          "Posting No. Series" := PurchHeader."Posting No. Series";
          "IC Partner Code" := PurchHeader."Pay-to IC Partner Code";
          "Ship-to/Order Address Code" := PurchHeader."Order Address Code";
          "Salespers./Purch. Code" := PurchHeader."Purchaser Code";
          "On Hold" := PurchHeader."On Hold";
          if "Account Type" = "Account Type"::Vendor then
            "Posting Group" := PurchHeader."Vendor Posting Group";

          OnAfterCopyGenJnlLineFromPurchHeader(PurchHeader,Rec);
        end;
    */



    //     procedure CopyFromPurchHeaderPrepmt (PurchHeader@1000 :

    /*
    procedure CopyFromPurchHeaderPrepmt (PurchHeader: Record 38)
        begin
          "Source Currency Code" := PurchHeader."Currency Code";
          "VAT Base Discount %" := PurchHeader."VAT Base Discount %";
          "Bill-to/Pay-to No." := PurchHeader."Pay-to Vendor No.";
          "Country/Region Code" := PurchHeader."VAT Country/Region Code";
          "VAT Registration No." := PurchHeader."VAT Registration No.";
          "Source Type" := "Source Type"::Vendor;
          "Source No." := PurchHeader."Pay-to Vendor No.";
          "IC Partner Code" := PurchHeader."Buy-from IC Partner Code";
          "VAT Posting" := "VAT Posting"::"Manual VAT Entry";
          "Payment Terms Code" := PurchHeader."Payment Terms Code";
          "Payment Method Code" := PurchHeader."Payment Method Code";
          "Generate AutoInvoices" := PurchHeader."Generate Autoinvoices" or PurchHeader."Generate Autocredit Memo";
          "System-Created Entry" := TRUE;
          Prepayment := TRUE;

          OnAfterCopyGenJnlLineFromPurchHeaderPrepmt(PurchHeader,Rec);
        end;
    */



    //     procedure CopyFromPurchHeaderPrepmtPost (PurchHeader@1000 : Record 38;UsePmtDisc@1001 :

    /*
    procedure CopyFromPurchHeaderPrepmtPost (PurchHeader: Record 38;UsePmtDisc: Boolean)
        begin
          "Account Type" := "Account Type"::Vendor;
          "Account No." := PurchHeader."Pay-to Vendor No.";
          SetCurrencyFactor(PurchHeader."Currency Code",PurchHeader."Currency Factor");
          "Source Currency Code" := PurchHeader."Currency Code";
          "Bill-to/Pay-to No." := PurchHeader."Pay-to Vendor No.";
          "Sell-to/Buy-from No." := PurchHeader."Buy-from Vendor No.";
          "Salespers./Purch. Code" := PurchHeader."Purchaser Code";
          "Source Type" := "Source Type"::Customer;
          "Source No." := PurchHeader."Pay-to Vendor No.";
          "IC Partner Code" := PurchHeader."Buy-from IC Partner Code";
          "System-Created Entry" := TRUE;
          Prepayment := TRUE;
          "Due Date" := PurchHeader."Prepayment Due Date";
          "Payment Terms Code" := PurchHeader."Payment Terms Code";
          "Payment Method Code" := PurchHeader."Payment Method Code";
          "Recipient Bank Account" := PurchHeader."Vendor Bank Acc. Code";
          if UsePmtDisc then begin
            "Pmt. Discount Date" := PurchHeader."Prepmt. Pmt. Discount Date";
            "Payment Discount %" := PurchHeader."Prepmt. Payment Discount %";
          end;

          OnAfterCopyGenJnlLineFromPurchHeaderPrepmtPost(PurchHeader,Rec,UsePmtDisc);
        end;
    */



    //     procedure CopyFromPurchHeaderApplyTo (PurchHeader@1001 :

    /*
    procedure CopyFromPurchHeaderApplyTo (PurchHeader: Record 38)
        begin
          "Applies-to Doc. Type" := PurchHeader."Applies-to Doc. Type";
          "Applies-to Doc. No." := PurchHeader."Applies-to Doc. No.";
          "Applies-to ID" := PurchHeader."Applies-to ID";
          "Allow Application" := PurchHeader."Bal. Account No." = '';

          OnAfterCopyGenJnlLineFromPurchHeaderApplyTo(PurchHeader,Rec);
        end;
    */



    //     procedure CopyFromPurchHeaderPayment (PurchHeader@1001 :

    /*
    procedure CopyFromPurchHeaderPayment (PurchHeader: Record 38)
        begin
          "Due Date" := PurchHeader."Due Date";
          "Payment Terms Code" := PurchHeader."Payment Terms Code";
          "Pmt. Discount Date" := PurchHeader."Pmt. Discount Date";
          "Payment Discount %" := PurchHeader."Payment Discount %";
          "Creditor No." := PurchHeader."Creditor No.";
          "Payment Reference" := PurchHeader."Payment Reference";
          "Payment Method Code" := PurchHeader."Payment Method Code";

          OnAfterCopyGenJnlLineFromPurchHeaderPayment(PurchHeader,Rec);
        end;
    */



    //     procedure CopyFromSalesHeader (SalesHeader@1001 :

    /*
    procedure CopyFromSalesHeader (SalesHeader: Record 36)
        begin
          "Source Currency Code" := SalesHeader."Currency Code";
          "Currency Factor" := SalesHeader."Currency Factor";
          "VAT Base Discount %" := SalesHeader."VAT Base Discount %";
          Correction := SalesHeader.Correction;
          "EU 3-Party Trade" := SalesHeader."EU 3-Party Trade";
          "Sell-to/Buy-from No." := SalesHeader."Sell-to Customer No.";
          "Bill-to/Pay-to No." := SalesHeader."Bill-to Customer No.";
          "Country/Region Code" := SalesHeader."VAT Country/Region Code";
          "VAT Registration No." := SalesHeader."VAT Registration No.";
          "Source Type" := "Source Type"::Customer;
          "Source No." := SalesHeader."Bill-to Customer No.";
          "Posting No. Series" := SalesHeader."Posting No. Series";
          "Ship-to/Order Address Code" := SalesHeader."Ship-to Code";
          "IC Partner Code" := SalesHeader."Bill-to IC Partner Code";
          "Salespers./Purch. Code" := SalesHeader."Salesperson Code";
          "On Hold" := SalesHeader."On Hold";
          if "Account Type" = "Account Type"::Customer then
            "Posting Group" := SalesHeader."Customer Posting Group";

          OnAfterCopyGenJnlLineFromSalesHeader(SalesHeader,Rec);
        end;
    */



    //     procedure CopyFromSalesHeaderPrepmt (SalesHeader@1000 :

    /*
    procedure CopyFromSalesHeaderPrepmt (SalesHeader: Record 36)
        begin
          "Source Currency Code" := SalesHeader."Currency Code";
          "VAT Base Discount %" := SalesHeader."VAT Base Discount %";
          "EU 3-Party Trade" := SalesHeader."EU 3-Party Trade";
          "Bill-to/Pay-to No." := SalesHeader."Bill-to Customer No.";
          "Country/Region Code" := SalesHeader."VAT Country/Region Code";
          "VAT Registration No." := SalesHeader."VAT Registration No.";
          "Source Type" := "Source Type"::Customer;
          "Source No." := SalesHeader."Bill-to Customer No.";
          "IC Partner Code" := SalesHeader."Sell-to IC Partner Code";
          "VAT Posting" := "VAT Posting"::"Manual VAT Entry";
          "Payment Terms Code" := SalesHeader."Payment Terms Code";
          "Payment Method Code" := SalesHeader."Payment Method Code";
          "System-Created Entry" := TRUE;
          Prepayment := TRUE;

          OnAfterCopyGenJnlLineFromSalesHeaderPrepmt(SalesHeader,Rec);
        end;
    */



    //     procedure CopyFromSalesHeaderPrepmtPost (SalesHeader@1000 : Record 36;UsePmtDisc@1001 :

    /*
    procedure CopyFromSalesHeaderPrepmtPost (SalesHeader: Record 36;UsePmtDisc: Boolean)
        begin
          "Account Type" := "Account Type"::Customer;
          "Account No." := SalesHeader."Bill-to Customer No.";
          SetCurrencyFactor(SalesHeader."Currency Code",SalesHeader."Currency Factor");
          "Source Currency Code" := SalesHeader."Currency Code";
          "Sell-to/Buy-from No." := SalesHeader."Sell-to Customer No.";
          "Bill-to/Pay-to No." := SalesHeader."Bill-to Customer No.";
          "Salespers./Purch. Code" := SalesHeader."Salesperson Code";
          "Source Type" := "Source Type"::Customer;
          "Source No." := SalesHeader."Bill-to Customer No.";
          "IC Partner Code" := SalesHeader."Sell-to IC Partner Code";
          "System-Created Entry" := TRUE;
          Prepayment := TRUE;
          "Due Date" := SalesHeader."Prepayment Due Date";
          "Payment Terms Code" := SalesHeader."Prepmt. Payment Terms Code";
          "Payment Method Code" := SalesHeader."Payment Method Code";
          "Recipient Bank Account" := SalesHeader."Cust. Bank Acc. Code";
          if UsePmtDisc then begin
            "Pmt. Discount Date" := SalesHeader."Prepmt. Pmt. Discount Date";
            "Payment Discount %" := SalesHeader."Prepmt. Payment Discount %";
          end;

          OnAfterCopyGenJnlLineFromSalesHeaderPrepmtPost(SalesHeader,Rec,UsePmtDisc);
        end;
    */



    //     procedure CopyFromSalesHeaderApplyTo (SalesHeader@1001 :

    /*
    procedure CopyFromSalesHeaderApplyTo (SalesHeader: Record 36)
        begin
          "Applies-to Doc. Type" := SalesHeader."Applies-to Doc. Type";
          "Applies-to Doc. No." := SalesHeader."Applies-to Doc. No.";
          "Applies-to ID" := SalesHeader."Applies-to ID";
          "Allow Application" := SalesHeader."Bal. Account No." = '';

          OnAfterCopyGenJnlLineFromSalesHeaderApplyTo(SalesHeader,Rec);
        end;
    */



    //     procedure CopyFromSalesHeaderPayment (SalesHeader@1001 :

    /*
    procedure CopyFromSalesHeaderPayment (SalesHeader: Record 36)
        begin
          "Due Date" := SalesHeader."Due Date";
          "Payment Terms Code" := SalesHeader."Payment Terms Code";
          "Payment Method Code" := SalesHeader."Payment Method Code";
          "Pmt. Discount Date" := SalesHeader."Pmt. Discount Date";
          "Payment Discount %" := SalesHeader."Payment Discount %";
          "Direct Debit Mandate ID" := SalesHeader."Direct Debit Mandate ID";

          OnAfterCopyGenJnlLineFromSalesHeaderPayment(SalesHeader,Rec);
        end;
    */



    //     procedure CopyFromServiceHeader (ServiceHeader@1001 :

    /*
    procedure CopyFromServiceHeader (ServiceHeader: Record 5900)
        begin
          "Source Currency Code" := ServiceHeader."Currency Code";
          Correction := ServiceHeader.Correction;
          "VAT Base Discount %" := ServiceHeader."VAT Base Discount %";
          "Sell-to/Buy-from No." := ServiceHeader."Customer No.";
          "Bill-to/Pay-to No." := ServiceHeader."Bill-to Customer No.";
          "Country/Region Code" := ServiceHeader."VAT Country/Region Code";
          "VAT Registration No." := ServiceHeader."VAT Registration No.";
          "Source Type" := "Source Type"::Customer;
          "Source No." := ServiceHeader."Bill-to Customer No.";
          "Posting No. Series" := ServiceHeader."Posting No. Series";
          "Ship-to/Order Address Code" := ServiceHeader."Ship-to Code";
          "EU 3-Party Trade" := ServiceHeader."EU 3-Party Trade";
          "Salespers./Purch. Code" := ServiceHeader."Salesperson Code";
          "Payment Terms Code" := ServiceHeader."Payment Terms Code";
          "Payment Method Code" := ServiceHeader."Payment Method Code";
          "Correction Type" := ServiceHeader."Correction Type";
          "Corrected Invoice No." := ServiceHeader."Corrected Invoice No.";
          "Sales Invoice Type" := ServiceHeader."Invoice Type";
          "Sales Cr. Memo Type" := ServiceHeader."Cr. Memo Type";
          "Sales Special Scheme Code" := ServiceHeader."Special Scheme Code";
          "Succeeded Company Name" := ServiceHeader."Succeeded Company Name";
          "Succeeded VAT Registration No." := ServiceHeader."Succeeded VAT Registration No.";

          OnAfterCopyGenJnlLineFromServHeader(ServiceHeader,Rec);
        end;
    */



    //     procedure CopyFromServiceHeaderApplyTo (ServiceHeader@1001 :

    /*
    procedure CopyFromServiceHeaderApplyTo (ServiceHeader: Record 5900)
        begin
          "Applies-to Doc. Type" := ServiceHeader."Applies-to Doc. Type";
          "Applies-to Doc. No." := ServiceHeader."Applies-to Doc. No.";
          "Applies-to ID" := ServiceHeader."Applies-to ID";
          "Applies-to Bill No." := ServiceHeader."Applies-to Bill No.";
          "Allow Application" := ServiceHeader."Bal. Account No." = '';

          OnAfterCopyGenJnlLineFromServHeaderApplyTo(ServiceHeader,Rec);
        end;
    */



    //     procedure CopyFromServiceHeaderPayment (ServiceHeader@1001 :

    /*
    procedure CopyFromServiceHeaderPayment (ServiceHeader: Record 5900)
        begin
          "Due Date" := ServiceHeader."Due Date";
          "Payment Terms Code" := ServiceHeader."Payment Terms Code";
          "Payment Method Code" := ServiceHeader."Payment Method Code";
          "Pmt. Discount Date" := ServiceHeader."Pmt. Discount Date";
          "Payment Discount %" := ServiceHeader."Payment Discount %";

          OnAfterCopyGenJnlLineFromServHeaderPayment(ServiceHeader,Rec);
        end;
    */



    //     procedure CopyFromPaymentCustLedgEntry (CustLedgEntry@1000 :

    /*
    procedure CopyFromPaymentCustLedgEntry (CustLedgEntry: Record 21)
        begin
          "Document No." := CustLedgEntry."Document No.";
          "Account Type" := "Account Type"::Customer;
          "Account No." := CustLedgEntry."Customer No.";
          "Shortcut Dimension 1 Code" := CustLedgEntry."Global Dimension 1 Code";
          "Shortcut Dimension 2 Code" := CustLedgEntry."Global Dimension 2 Code";
          "Dimension Set ID" := CustLedgEntry."Dimension Set ID";
          "Posting Group" := CustLedgEntry."Customer Posting Group";
          "Source Type" := "Source Type"::Customer;
          "Source No." := CustLedgEntry."Customer No.";
          "Source Currency Code" := CustLedgEntry."Currency Code";
          "System-Created Entry" := TRUE;
          "Financial Void" := TRUE;
          Correction := TRUE;
        end;
    */



    //     procedure CopyFromPaymentVendLedgEntry (VendLedgEntry@1000 :

    /*
    procedure CopyFromPaymentVendLedgEntry (VendLedgEntry: Record 25)
        begin
          "Document No." := VendLedgEntry."Document No.";
          "Account Type" := "Account Type"::Vendor;
          "Account No." := VendLedgEntry."Vendor No.";
          "Shortcut Dimension 1 Code" := VendLedgEntry."Global Dimension 1 Code";
          "Shortcut Dimension 2 Code" := VendLedgEntry."Global Dimension 2 Code";
          "Dimension Set ID" := VendLedgEntry."Dimension Set ID";
          "Posting Group" := VendLedgEntry."Vendor Posting Group";
          "Source Type" := "Source Type"::Vendor;
          "Source No." := VendLedgEntry."Vendor No.";
          "Source Currency Code" := VendLedgEntry."Currency Code";
          "System-Created Entry" := TRUE;
          "Financial Void" := TRUE;
          Correction := TRUE;
        end;
    */



    //     procedure CopyFromPaymentEmpLedgEntry (EmployeeLedgerEntry@1000 :

    /*
    procedure CopyFromPaymentEmpLedgEntry (EmployeeLedgerEntry: Record 5222)
        begin
          "Document No." := EmployeeLedgerEntry."Document No.";
          "Account Type" := "Account Type"::Employee;
          "Account No." := EmployeeLedgerEntry."Employee No.";
          "Shortcut Dimension 1 Code" := EmployeeLedgerEntry."Global Dimension 1 Code";
          "Shortcut Dimension 2 Code" := EmployeeLedgerEntry."Global Dimension 2 Code";
          "Dimension Set ID" := EmployeeLedgerEntry."Dimension Set ID";
          "Posting Group" := EmployeeLedgerEntry."Employee Posting Group";
          "Source Type" := "Source Type"::Employee;
          "Source No." := EmployeeLedgerEntry."Employee No.";
          "Source Currency Code" := EmployeeLedgerEntry."Currency Code";
          "System-Created Entry" := TRUE;
          "Financial Void" := TRUE;
          Correction := TRUE;
        end;
    */



    /*
    LOCAL procedure CopyVATSetupToJnlLines () : Boolean;
        begin
          if ("Journal Template Name" <> '') and ("Journal Batch Name" <> '') then
            if GenJnlBatch.GET("Journal Template Name","Journal Batch Name") then
              exit(GenJnlBatch."Copy VAT Setup to Jnl. Lines");
          exit("Copy VAT Setup to Jnl. Lines");
        end;
    */



    /*
    LOCAL procedure SetAmountWithCustLedgEntry ()
        begin
          OnBeforeSetAmountWithCustLedgEntry(Rec,CustLedgEntry);

          if "Currency Code" <> CustLedgEntry."Currency Code" then
            CheckModifyCurrencyCode(GenJnlLine."Account Type"::Customer,CustLedgEntry."Currency Code");
          if Amount = 0 then begin
            CustLedgEntry.CALCFIELDS("Remaining Amount");
            SetAmountWithRemaining(
              PaymentToleranceMgt.CheckCalcPmtDiscGenJnlCust(Rec,CustLedgEntry,0,FALSE),
              CustLedgEntry."Amount to Apply",CustLedgEntry."Remaining Amount",CustLedgEntry."Remaining Pmt. Disc. Possible");
          end;
        end;
    */



    /*
    LOCAL procedure SetAmountWithVendLedgEntry ()
        begin
          OnBeforeSetAmountWithVendLedgEntry(Rec,VendLedgEntry);

          if "Currency Code" <> VendLedgEntry."Currency Code" then
            CheckModifyCurrencyCode("Account Type"::Vendor,VendLedgEntry."Currency Code");
          if Amount = 0 then begin
            VendLedgEntry.CALCFIELDS("Remaining Amount");
            SetAmountWithRemaining(
              PaymentToleranceMgt.CheckCalcPmtDiscGenJnlVend(Rec,VendLedgEntry,0,FALSE),
              VendLedgEntry."Amount to Apply",VendLedgEntry."Remaining Amount",VendLedgEntry."Remaining Pmt. Disc. Possible");
          end;
        end;
    */



    /*
    LOCAL procedure SetAmountWithEmplLedgEntry ()
        begin
          if Amount = 0 then begin
            EmplLedgEntry.CALCFIELDS("Remaining Amount");
            SetAmountWithRemaining(FALSE,EmplLedgEntry."Amount to Apply",EmplLedgEntry."Remaining Amount",0.0);
          end;
        end;
    */



    //     procedure CheckModifyCurrencyCode (AccountType@1000 : Option;CustVendLedgEntryCurrencyCode@1001 :

    /*
    procedure CheckModifyCurrencyCode (AccountType: Option;CustVendLedgEntryCurrencyCode: Code[10])
        begin
          if Amount = 0 then
            UpdateCurrencyCode(CustVendLedgEntryCurrencyCode)
          else
            GenJnlApply.CheckAgainstApplnCurrency(
              "Currency Code",CustVendLedgEntryCurrencyCode,AccountType,TRUE);
        end;
    */


    //     LOCAL procedure SetAmountWithRemaining (CalcPmtDisc@1000 : Boolean;AmountToApply@1001 : Decimal;RemainingAmount@1002 : Decimal;RemainingPmtDiscPossible@1003 :

    /*
    LOCAL procedure SetAmountWithRemaining (CalcPmtDisc: Boolean;AmountToApply: Decimal;RemainingAmount: Decimal;RemainingPmtDiscPossible: Decimal)
        begin
          if AmountToApply <> 0 then
            if CalcPmtDisc and (ABS(AmountToApply) >= ABS(RemainingAmount - RemainingPmtDiscPossible)) then
              Amount := -(RemainingAmount - RemainingPmtDiscPossible)
            else
              Amount := -AmountToApply
          else
            if CalcPmtDisc then
              Amount := -(RemainingAmount - RemainingPmtDiscPossible)
            else
              Amount := -RemainingAmount;
          if "Bal. Account Type" IN ["Bal. Account Type"::Customer,"Bal. Account Type"::Vendor] then
            Amount := -Amount;

          OnAfterSetAmountWithRemaining(Rec);
          ValidateAmount(FALSE);
        end;
    */




    /*
    procedure IsOpenedFromBatch () : Boolean;
        var
    //       GenJournalBatch@1002 :
          GenJournalBatch: Record 232;
    //       TemplateFilter@1001 :
          TemplateFilter: Text;
    //       BatchFilter@1000 :
          BatchFilter: Text;
        begin
          BatchFilter := GETFILTER("Journal Batch Name");
          if (BatchFilter = '') and ("Journal Batch Name" <> '') then
            BatchFilter := "Journal Batch Name";

          if BatchFilter <> '' then begin
            TemplateFilter := GETFILTER("Journal Template Name");
            if (TemplateFilter = '') and ("Journal Template Name" <> '') then begin
              TemplateFilter := "Journal Template Name";
              SETFILTER("Journal Template Name",TemplateFilter);
            end;
            if TemplateFilter <> '' then
              GenJournalBatch.SETFILTER("Journal Template Name",TemplateFilter);
            GenJournalBatch.SETFILTER(Name,BatchFilter);
            GenJournalBatch.FINDFIRST;
          end;

          exit((("Journal Batch Name" <> '') and ("Journal Template Name" = '')) or (BatchFilter <> ''));
        end;
    */




    /*
    procedure GetDeferralAmount () DeferralAmount : Decimal;
        begin
          if "VAT Base Amount" <> 0 then
            DeferralAmount := "VAT Base Amount"
          else
            DeferralAmount := Amount;
        end;
    */


    //     procedure ShowDeferrals (PostingDate@1000 : Date;CurrencyCode@1001 :

    /*
    procedure ShowDeferrals (PostingDate: Date;CurrencyCode: Code[10]) : Boolean;
        var
    //       DeferralUtilities@1002 :
          DeferralUtilities: Codeunit 1720;
        begin
          exit(
            DeferralUtilities.OpenLineScheduleEdit(
              "Deferral Code",GetDeferralDocType,"Journal Template Name","Journal Batch Name",0,'',"Line No.",
              GetDeferralAmount,PostingDate,Description,CurrencyCode));
        end;
    */




    /*
    procedure GetDeferralDocType () : Integer;
        begin
          exit(DeferralDocType::"G/L");
        end;
    */




    /*
    procedure IsForPurchase () : Boolean;
        begin
          if ("Account Type" = "Account Type"::Vendor) or ("Bal. Account Type" = "Bal. Account Type"::Vendor) then
            exit(TRUE);

          exit(FALSE);
        end;
    */




    /*
    procedure IsForSales () : Boolean;
        begin
          if ("Account Type" = "Account Type"::Customer) or ("Bal. Account Type" = "Bal. Account Type"::Customer) then
            exit(TRUE);

          exit(FALSE);
        end;

        [Integration(TRUE)]
    */


    /*
    procedure OnCheckGenJournalLinePostRestrictions ()
        begin
        end;

        [Integration(TRUE)]
    */


    /*
    procedure OnCheckGenJournalLinePrintCheckRestrictions ()
        begin
        end;

        [Integration(TRUE)]
    */

    //     procedure OnMoveGenJournalLine (ToRecordID@1000 :


    procedure OnMoveGenJournalLine(ToRecordID: RecordID)
    begin
    end;




    //     procedure IncrementDocumentNo (GenJnlBatch@1000 : Record 232;var LastDocNumber@1002 :

    /*
    procedure IncrementDocumentNo (GenJnlBatch: Record 232;var LastDocNumber: Code[20])
        var
    //       NoSeriesLine@1001 :
          NoSeriesLine: Record 309;
    //       NoSeriesManagement@1100000 :
          NoSeriesManagement: Codeunit 396;
        begin
          GenJnlTemplate.GET("Journal Template Name");
          if GenJnlTemplate."Force Doc. Balance" then
            if GenJnlBatch."No. Series" <> '' then begin
              NoSeriesManagement.SetNoSeriesLineFilter(NoSeriesLine,GenJnlBatch."No. Series","Posting Date");
              if NoSeriesLine."Increment-by No." > 1 then
                NoSeriesManagement.IncrementNoText(LastDocNumber,NoSeriesLine."Increment-by No.")
              else
                LastDocNumber := INCSTR(LastDocNumber)
            end else
              LastDocNumber := INCSTR(LastDocNumber)
          else
            if "Transaction No." > 0 then
              "Transaction No." := "Transaction No." + 1;
        end;
    */




    /*
    procedure NeedCheckZeroAmount () : Boolean;
        begin
          exit(
            ("Account No." <> '') and
            not "System-Created Entry" and
            not "Allow Zero-Amount Posting" and
            ("Account Type" <> "Account Type"::"Fixed Asset"));
        end;
    */




    /*
    procedure IsRecurring () : Boolean;
        var
    //       GenJournalTemplate@1000 :
          GenJournalTemplate: Record 80;
        begin
          if "Journal Template Name" <> '' then
            if GenJournalTemplate.GET("Journal Template Name") then
              exit(GenJournalTemplate.Recurring);

          exit(FALSE);
        end;
    */


    //     LOCAL procedure SuggestBalancingAmount (LastGenJnlLine@1001 : Record 81;BottomLine@1003 :

    /*
    LOCAL procedure SuggestBalancingAmount (LastGenJnlLine: Record 81;BottomLine: Boolean)
        var
    //       GenJournalLine@1000 :
          GenJournalLine: Record 81;
        begin
          if "Document No." = '' then
            exit;
          if GETFILTERS <> '' then
            exit;

          GenJournalLine.SETRANGE("Journal Template Name",LastGenJnlLine."Journal Template Name");
          GenJournalLine.SETRANGE("Journal Batch Name",LastGenJnlLine."Journal Batch Name");
          if BottomLine then
            GenJournalLine.SETFILTER("Line No.",'<=%1',LastGenJnlLine."Line No.")
          else
            GenJournalLine.SETFILTER("Line No.",'<%1',LastGenJnlLine."Line No.");

          if GenJournalLine.FINDLAST then begin
            if BottomLine then begin
              GenJournalLine.SETRANGE("Document No.",LastGenJnlLine."Document No.");
              GenJournalLine.SETRANGE("Posting Date",LastGenJnlLine."Posting Date");
            end else begin
              GenJournalLine.SETRANGE("Document No.",GenJournalLine."Document No.");
              GenJournalLine.SETRANGE("Posting Date",GenJournalLine."Posting Date");
            end;
            GenJournalLine.SETRANGE("Bal. Account No.",'');
            if GenJournalLine.FINDFIRST then begin
              GenJournalLine.CALCSUMS(Amount);
              "Document No." := GenJournalLine."Document No.";
              "Posting Date" := GenJournalLine."Posting Date";
              VALIDATE(Amount,-GenJournalLine.Amount);
            end;
          end;
        end;
    */



    /*
    LOCAL procedure GetGLAccount ()
        var
    //       GLAcc@1000 :
          GLAcc: Record 15;
        begin
          GLAcc.GET("Account No.");
          CheckGLAcc(GLAcc);
          if ReplaceDescription and (not GLAcc."Omit Default Descr. in Jnl.") then
            UpdateDescription(GLAcc.Name)
          else
            if GLAcc."Omit Default Descr. in Jnl." then
              Description := '';
          if ("Bal. Account No." = '') or
             ("Bal. Account Type" IN
              ["Bal. Account Type"::"G/L Account","Bal. Account Type"::"Bank Account"])
          then begin
            "Posting Group" := '';
            "Salespers./Purch. Code" := '';
            "Payment Terms Code" := '';
            "Payment Method Code" := '';
          end;
          if "Bal. Account No." = '' then
            "Currency Code" := '';
          if CopyVATSetupToJnlLines then begin
            "Gen. Posting Type" := GLAcc."Gen. Posting Type";
            "Gen. Bus. Posting Group" := GLAcc."Gen. Bus. Posting Group";
            "Gen. Prod. Posting Group" := GLAcc."Gen. Prod. Posting Group";
            "VAT Bus. Posting Group" := GLAcc."VAT Bus. Posting Group";
            "VAT Prod. Posting Group" := GLAcc."VAT Prod. Posting Group";
          end;
          "Tax Area Code" := GLAcc."Tax Area Code";
          "Tax Liable" := GLAcc."Tax Liable";
          "Tax Group Code" := GLAcc."Tax Group Code";
          if "Posting Date" <> 0D then
            if "Posting Date" = CLOSINGDATE("Posting Date") then
              ClearPostingGroups;
          VALIDATE("Deferral Code",GLAcc."Default Deferral Template Code");

          OnAfterAccountNoOnValidateGetGLAccount(Rec,GLAcc);
        end;
    */



    /*
    LOCAL procedure GetGLBalAccount ()
        var
    //       GLAcc@1000 :
          GLAcc: Record 15;
        begin
          GLAcc.GET("Bal. Account No.");
          CheckGLAcc(GLAcc);
          if "Account No." = '' then begin
            Description := GLAcc.Name;
            "Currency Code" := '';
          end;
          if ("Account No." = '') or
             ("Account Type" IN
              ["Account Type"::"G/L Account","Account Type"::"Bank Account"])
          then begin
            "Posting Group" := '';
            "Salespers./Purch. Code" := '';
            "Payment Terms Code" := '';
          end;
          if CopyVATSetupToJnlLines then begin
            "Bal. Gen. Posting Type" := GLAcc."Gen. Posting Type";
            "Bal. Gen. Bus. Posting Group" := GLAcc."Gen. Bus. Posting Group";
            "Bal. Gen. Prod. Posting Group" := GLAcc."Gen. Prod. Posting Group";
            "Bal. VAT Bus. Posting Group" := GLAcc."VAT Bus. Posting Group";
            "Bal. VAT Prod. Posting Group" := GLAcc."VAT Prod. Posting Group";
          end;
          "Bal. Tax Area Code" := GLAcc."Tax Area Code";
          "Bal. Tax Liable" := GLAcc."Tax Liable";
          "Bal. Tax Group Code" := GLAcc."Tax Group Code";
          if "Posting Date" <> 0D then
            if "Posting Date" = CLOSINGDATE("Posting Date") then
              ClearBalancePostingGroups;

          OnAfterAccountNoOnValidateGetGLBalAccount(Rec,GLAcc);
        end;
    */


    LOCAL procedure GetCustomerAccount()
    var
        //       Cust@1000 :
        Cust: Record 18;
    begin
        Cust.GET("Account No.");
        Cust.CheckBlockedCustOnJnls(Cust, "Document Type", FALSE);
        CheckICPartner(Cust."IC Partner Code", "Account Type", "Account No.");
        UpdateDescription(Cust.Name);
        "Payment Method Code" := Cust."Payment Method Code";
        VALIDATE("Recipient Bank Account", Cust."Preferred Bank Account Code");
        "Posting Group" := Cust."Customer Posting Group";
        SetSalespersonPurchaserCode(Cust."Salesperson Code", "Salespers./Purch. Code");
        Cust.TESTFIELD("Payment Terms Code");
        "Payment Terms Code" := Cust."Payment Terms Code";
        VALIDATE("Bill-to/Pay-to No.", "Account No.");
        VALIDATE("Sell-to/Buy-from No.", "Account No.");
        if not SetCurrencyCode("Bal. Account Type", "Bal. Account No.") then
            "Currency Code" := Cust."Currency Code";
        ClearPostingGroups;
        if "Document Type" = "Document Type"::"Credit Memo" then
            "Payment Method Code" := ''
        else begin
            Cust.TESTFIELD("Payment Method Code");
            "Payment Method Code" := Cust."Payment Method Code";
        end;
        if (Cust."Bill-to Customer No." <> '') and (Cust."Bill-to Customer No." <> "Account No.") and
           not HideValidationDialog
        then
            if not CONFIRM(Text014, FALSE, Cust.TABLECAPTION, Cust."No.", Cust.FIELDCAPTION("Bill-to Customer No."),
                 Cust."Bill-to Customer No.")
            then
                ERROR('');
        VALIDATE("Payment Terms Code");
        CheckPaymentTolerance;

        // +QB
        QBTablePublisher.GetCustomerAccountTGenJournalLine(Rec);   //QB
                                                                   // -QB
        OnAfterAccountNoOnValidateGetCustomerAccount(Rec, Cust, CurrFieldNo);
    end;

    LOCAL procedure GetCustomerBalAccount()
    var
        //       Cust@1000 :
        Cust: Record 18;
    begin
        Cust.GET("Bal. Account No.");
        Cust.CheckBlockedCustOnJnls(Cust, "Document Type", FALSE);
        CheckICPartner(Cust."IC Partner Code", "Bal. Account Type", "Bal. Account No.");
        if "Account No." = '' then
            Description := Cust.Name;
        "Payment Method Code" := Cust."Payment Method Code";
        VALIDATE("Recipient Bank Account", Cust."Preferred Bank Account Code");
        "Posting Group" := Cust."Customer Posting Group";
        SetSalespersonPurchaserCode(Cust."Salesperson Code", "Salespers./Purch. Code");
        "Payment Terms Code" := Cust."Payment Terms Code";
        VALIDATE("Bill-to/Pay-to No.", "Bal. Account No.");
        VALIDATE("Sell-to/Buy-from No.", "Bal. Account No.");
        if ("Account No." = '') or ("Account Type" = "Account Type"::"G/L Account") then
            "Currency Code" := Cust."Currency Code";
        if ("Account Type" = "Account Type"::"Bank Account") and ("Currency Code" = '') then
            "Currency Code" := Cust."Currency Code";
        ClearBalancePostingGroups;
        if (Cust."Bill-to Customer No." <> '') and (Cust."Bill-to Customer No." <> "Bal. Account No.") and
           not HideValidationDialog
        then
            if not CONFIRM(Text014, FALSE, Cust.TABLECAPTION, Cust."No.", Cust.FIELDCAPTION("Bill-to Customer No."),
                 Cust."Bill-to Customer No.")
            then
                ERROR('');
        VALIDATE("Payment Terms Code");
        CheckPaymentTolerance;

        //+QB
        QBTablePublisher.GetCustomerBalAccountTGenJournalLine(Rec);   //QB
                                                                      // -QB
        OnAfterAccountNoOnValidateGetCustomerBalAccount(Rec, Cust, CurrFieldNo);
    end;

    LOCAL procedure GetVendorAccount()
    var
        //       Vend@1000 :
        Vend: Record 23;
    begin
        Vend.GET("Account No.");
        Vend.CheckBlockedVendOnJnls(Vend, "Document Type", FALSE);
        CheckICPartner(Vend."IC Partner Code", "Account Type", "Account No.");
        UpdateDescription(Vend.Name);
        "Payment Method Code" := Vend."Payment Method Code";
        "Creditor No." := Vend."Creditor No.";

        OnGenJnlLineGetVendorAccount(Vend);

        VALIDATE("Recipient Bank Account", Vend."Preferred Bank Account Code");
        "Posting Group" := Vend."Vendor Posting Group";
        SetSalespersonPurchaserCode(Vend."Purchaser Code", "Salespers./Purch. Code");
        Vend.TESTFIELD("Payment Terms Code");
        "Payment Terms Code" := Vend."Payment Terms Code";
        VALIDATE("Bill-to/Pay-to No.", "Account No.");
        VALIDATE("Sell-to/Buy-from No.", "Account No.");
        if not SetCurrencyCode("Bal. Account Type", "Bal. Account No.") then
            "Currency Code" := Vend."Currency Code";
        ClearPostingGroups;
        if "Document Type" = "Document Type"::"Credit Memo" then
            "Payment Method Code" := ''
        else begin
            Vend.TESTFIELD("Payment Method Code");
            "Payment Method Code" := Vend."Payment Method Code";
        end;
        if (Vend."Pay-to Vendor No." <> '') and (Vend."Pay-to Vendor No." <> "Account No.") and
           not HideValidationDialog
        then
            if not CONFIRM(Text014, FALSE, Vend.TABLECAPTION, Vend."No.", Vend.FIELDCAPTION("Pay-to Vendor No."),
                 Vend."Pay-to Vendor No.")
            then
                ERROR('');
        VALIDATE("Payment Terms Code");
        CheckPaymentTolerance;

        //+QB
        QBTablePublisher.GetVendorAccountTGenJournalLine(Rec);
        // -QB

        OnAfterAccountNoOnValidateGetVendorAccount(Rec, Vend, CurrFieldNo);
    end;


    /*
    LOCAL procedure GetEmployeeAccount ()
        var
    //       Employee@1000 :
          Employee: Record 5200;
        begin
          Employee.GET("Account No.");
          Employee.CheckBlockedEmployeeOnJnls(FALSE);
          UpdateDescriptionWithEmployeeName(Employee);
          "Posting Group" := Employee."Employee Posting Group";
          SetSalespersonPurchaserCode(Employee."Salespers./Purch. Code","Salespers./Purch. Code");
          "Currency Code" := '';
          ClearPostingGroups;

          OnAfterAccountNoOnValidateGetEmployeeAccount(Rec,Employee);
        end;
    */


    LOCAL procedure GetVendorBalAccount()
    var
        //       Vend@1000 :
        Vend: Record 23;
    begin
        Vend.GET("Bal. Account No.");
        Vend.CheckBlockedVendOnJnls(Vend, "Document Type", FALSE);
        CheckICPartner(Vend."IC Partner Code", "Bal. Account Type", "Bal. Account No.");
        if "Account No." = '' then
            Description := Vend.Name;
        "Payment Method Code" := Vend."Payment Method Code";
        VALIDATE("Recipient Bank Account", Vend."Preferred Bank Account Code");
        "Posting Group" := Vend."Vendor Posting Group";
        SetSalespersonPurchaserCode(Vend."Purchaser Code", "Salespers./Purch. Code");
        "Payment Terms Code" := Vend."Payment Terms Code";
        VALIDATE("Bill-to/Pay-to No.", "Bal. Account No.");
        VALIDATE("Sell-to/Buy-from No.", "Bal. Account No.");
        if ("Account No." = '') or ("Account Type" = "Account Type"::"G/L Account") then
            "Currency Code" := Vend."Currency Code";
        if ("Account Type" = "Account Type"::"Bank Account") and ("Currency Code" = '') then
            "Currency Code" := Vend."Currency Code";
        ClearBalancePostingGroups;
        if (Vend."Pay-to Vendor No." <> '') and (Vend."Pay-to Vendor No." <> "Bal. Account No.") and
           not HideValidationDialog
        then
            if not CONFIRM(Text014, FALSE, Vend.TABLECAPTION, Vend."No.", Vend.FIELDCAPTION("Pay-to Vendor No."),
                 Vend."Pay-to Vendor No.")
            then
                ERROR('');
        VALIDATE("Payment Terms Code");
        CheckPaymentTolerance;

        // +QB
        QBTablePublisher.GetVendorBalAccountTGenJournalLine(Rec);  //QB
                                                                   // -QB
        OnAfterAccountNoOnValidateGetVendorBalAccount(Rec, Vend, CurrFieldNo);
    end;


    /*
    LOCAL procedure GetEmployeeBalAccount ()
        var
    //       Employee@1000 :
          Employee: Record 5200;
        begin
          Employee.GET("Bal. Account No.");
          Employee.CheckBlockedEmployeeOnJnls(FALSE);
          if "Account No." = '' then
            UpdateDescriptionWithEmployeeName(Employee);
          "Posting Group" := Employee."Employee Posting Group";
          SetSalespersonPurchaserCode(Employee."Salespers./Purch. Code","Salespers./Purch. Code");
          "Currency Code" := '';
          ClearBalancePostingGroups;

          OnAfterAccountNoOnValidateGetEmployeeBalAccount(Rec,Employee,CurrFieldNo);
        end;
    */


    LOCAL procedure GetBankAccount()
    var
        //       BankAcc@1000 :
        BankAcc: Record 270;
    begin
        BankAcc.GET("Account No.");
        BankAcc.TESTFIELD(Blocked, FALSE);
        if ReplaceDescription then
            UpdateDescription(BankAcc.Name);
        if ("Bal. Account No." = '') or
           ("Bal. Account Type" IN
            ["Bal. Account Type"::"G/L Account", "Bal. Account Type"::"Bank Account"])
        then begin
            "Posting Group" := '';
            "Salespers./Purch. Code" := '';
            "Payment Terms Code" := '';
        end;
        if BankAcc."Currency Code" = '' then begin
            if "Bal. Account No." = '' then
                "Currency Code" := '';
        end else
            if SetCurrencyCode("Bal. Account Type", "Bal. Account No.") then
                BankAcc.TESTFIELD("Currency Code", "Currency Code")
            else
                "Currency Code" := BankAcc."Currency Code";
        ClearPostingGroups;

        // +QB
        QBTablePublisher.GetBankAccountTGenJournalLine(Rec);  //QB
                                                              // -QB
        OnAfterAccountNoOnValidateGetBankAccount(Rec, BankAcc, CurrFieldNo);
    end;

    LOCAL procedure GetBankBalAccount()
    var
        //       BankAcc@1000 :
        BankAcc: Record 270;
    begin
        BankAcc.GET("Bal. Account No.");
        BankAcc.TESTFIELD(Blocked, FALSE);
        if "Account No." = '' then
            Description := BankAcc.Name;

        if ("Account No." = '') or
           ("Account Type" IN
            ["Account Type"::"G/L Account", "Account Type"::"Bank Account"])
        then begin
            "Posting Group" := '';
            "Salespers./Purch. Code" := '';
            "Payment Terms Code" := '';
        end;
        if BankAcc."Currency Code" = '' then
            if "Account No." = '' then
                "Currency Code" := ''
            else
                ClearCurrencyCode
        else
            if SetCurrencyCode("Bal. Account Type", "Bal. Account No.") then
                BankAcc.TESTFIELD("Currency Code", "Currency Code")
            else
                "Currency Code" := BankAcc."Currency Code";
        ClearBalancePostingGroups;

        // +QB
        QBTablePublisher.GetBankBalAccountTGenJournalLine(Rec);   //QB
                                                                  // -QB
        OnAfterAccountNoOnValidateGetBankBalAccount(Rec, BankAcc, CurrFieldNo);
    end;


    /*
    LOCAL procedure GetFAAccount ()
        var
    //       FA@1000 :
          FA: Record 5600;
        begin
          FA.GET("Account No.");
          FA.TESTFIELD(Blocked,FALSE);
          FA.TESTFIELD(Inactive,FALSE);
          FA.TESTFIELD("Budgeted Asset",FALSE);
          UpdateDescription(FA.Description);
          GetFADeprBook("Account No.");
          GetFAVATSetup;
          GetFAAddCurrExchRate;

          OnAfterAccountNoOnValidateGetFAAccount(Rec,FA);
        end;
    */



    /*
    LOCAL procedure GetFABalAccount ()
        var
    //       FA@1000 :
          FA: Record 5600;
        begin
          FA.GET("Bal. Account No.");
          FA.TESTFIELD(Blocked,FALSE);
          FA.TESTFIELD(Inactive,FALSE);
          FA.TESTFIELD("Budgeted Asset",FALSE);
          if "Account No." = '' then
            Description := FA.Description;
          GetFADeprBook("Bal. Account No.");
          GetFAVATSetup;
          GetFAAddCurrExchRate;

          OnAfterAccountNoOnValidateGetFABalAccount(Rec,FA);
        end;
    */



    /*
    LOCAL procedure GetICPartnerAccount ()
        var
    //       ICPartner@1000 :
          ICPartner: Record 413;
        begin
          ICPartner.GET("Account No.");
          ICPartner.CheckICPartner;
          UpdateDescription(ICPartner.Name);
          if ("Bal. Account No." = '') or ("Bal. Account Type" = "Bal. Account Type"::"G/L Account") then
            "Currency Code" := ICPartner."Currency Code";
          if ("Bal. Account Type" = "Bal. Account Type"::"Bank Account") and ("Currency Code" = '') then
            "Currency Code" := ICPartner."Currency Code";
          ClearPostingGroups;
          "IC Partner Code" := "Account No.";

          OnAfterAccountNoOnValidateGetICPartnerAccount(Rec,ICPartner);
        end;
    */



    /*
    LOCAL procedure GetICPartnerBalAccount ()
        var
    //       ICPartner@1000 :
          ICPartner: Record 413;
        begin
          ICPartner.GET("Bal. Account No.");
          if "Account No." = '' then
            Description := ICPartner.Name;

          if ("Account No." = '') or ("Account Type" = "Account Type"::"G/L Account") then
            "Currency Code" := ICPartner."Currency Code";
          if ("Account Type" = "Account Type"::"Bank Account") and ("Currency Code" = '') then
            "Currency Code" := ICPartner."Currency Code";
          ClearBalancePostingGroups;
          "IC Partner Code" := "Bal. Account No.";

          OnAfterAccountNoOnValidateGetICPartnerBalAccount(Rec,ICPartner);
        end;
    */



    //     procedure CreateFAAcquisitionLines (var FAGenJournalLine@1008 :

    /*
    procedure CreateFAAcquisitionLines (var FAGenJournalLine: Record 81)
        var
    //       BalancingGenJnlLine@1006 :
          BalancingGenJnlLine: Record 81;
    //       LocalGLAcc@1001 :
          LocalGLAcc: Record 15;
    //       FAPostingGr@1000 :
          FAPostingGr: Record 5606;
        begin
          TESTFIELD("Journal Template Name");
          TESTFIELD("Journal Batch Name");
          TESTFIELD("Posting Date");
          TESTFIELD("Account Type");
          TESTFIELD("Account No.");
          TESTFIELD("Posting Date");

          // Creating Fixed Asset Line
          FAGenJournalLine.INIT;
          FAGenJournalLine.VALIDATE("Journal Template Name","Journal Template Name");
          FAGenJournalLine.VALIDATE("Journal Batch Name","Journal Batch Name");
          FAGenJournalLine.VALIDATE("Line No.",GetNewLineNo("Journal Template Name","Journal Batch Name"));
          FAGenJournalLine.VALIDATE("Document Type","Document Type");
          FAGenJournalLine.VALIDATE("Document No.",GenerateLineDocNo("Journal Batch Name","Posting Date","Journal Template Name"));
          FAGenJournalLine.VALIDATE("Account Type","Account Type");
          FAGenJournalLine.VALIDATE("Account No.","Account No.");
          FAGenJournalLine.VALIDATE(Amount,Amount);
          FAGenJournalLine.VALIDATE("Posting Date","Posting Date");
          FAGenJournalLine.VALIDATE("FA Posting Type","FA Posting Type"::"Acquisition Cost");
          FAGenJournalLine.VALIDATE("External Document No.","External Document No.");
          FAGenJournalLine.INSERT(TRUE);

          // Creating Balancing Line
          BalancingGenJnlLine.COPY(FAGenJournalLine);
          BalancingGenJnlLine.VALIDATE("Account Type","Bal. Account Type");
          BalancingGenJnlLine.VALIDATE("Account No.","Bal. Account No.");
          BalancingGenJnlLine.VALIDATE(Amount,-Amount);
          BalancingGenJnlLine.VALIDATE("Line No.",GetNewLineNo("Journal Template Name","Journal Batch Name"));
          BalancingGenJnlLine.INSERT(TRUE);

          FAGenJournalLine.TESTFIELD("Posting Group");

          // Inserting additional fields in Fixed Asset line required for acquisition
          if FAPostingGr.GET(FAGenJournalLine."Posting Group") then begin
            LocalGLAcc.GET(FAPostingGr."Acquisition Cost Account");
            LocalGLAcc.CheckGLAcc;
            FAGenJournalLine.VALIDATE("Gen. Posting Type",LocalGLAcc."Gen. Posting Type");
            FAGenJournalLine.VALIDATE("Gen. Bus. Posting Group",LocalGLAcc."Gen. Bus. Posting Group");
            FAGenJournalLine.VALIDATE("Gen. Prod. Posting Group",LocalGLAcc."Gen. Prod. Posting Group");
            FAGenJournalLine.VALIDATE("VAT Bus. Posting Group",LocalGLAcc."VAT Bus. Posting Group");
            FAGenJournalLine.VALIDATE("VAT Prod. Posting Group",LocalGLAcc."VAT Prod. Posting Group");
            FAGenJournalLine.VALIDATE("Tax Group Code",LocalGLAcc."Tax Group Code");
            FAGenJournalLine.VALIDATE("VAT Prod. Posting Group");
            FAGenJournalLine.MODIFY(TRUE)
          end;

          // Inserting Source Code
          if "Source Code" = '' then begin
            GenJnlTemplate.GET("Journal Template Name");
            FAGenJournalLine.VALIDATE("Source Code",GenJnlTemplate."Source Code");
            FAGenJournalLine.MODIFY(TRUE);
            BalancingGenJnlLine.VALIDATE("Source Code",GenJnlTemplate."Source Code");
            BalancingGenJnlLine.MODIFY(TRUE);
          end;
        end;
    */


    //     LOCAL procedure GenerateLineDocNo (BatchName@1004 : Code[10];PostingDate@1002 : Date;TemplateName@1005 :

    /*
    LOCAL procedure GenerateLineDocNo (BatchName: Code[10];PostingDate: Date;TemplateName: Code[20]) DocumentNo : Code[20];
        var
    //       GenJournalBatch@1000 :
          GenJournalBatch: Record 232;
    //       NoSeriesManagement@1003 :
          NoSeriesManagement: Codeunit 396;
        begin
          GenJournalBatch.GET(TemplateName,BatchName);
          if GenJournalBatch."No. Series" <> '' then
            DocumentNo := NoSeriesManagement.TryGetNextNo(GenJournalBatch."No. Series",PostingDate);
        end;
    */



    /*
    LOCAL procedure GetFilterAccountNo () : Code[20];
        begin
          if GETFILTER("Account No.") <> '' then
            if GETRANGEMIN("Account No.") = GETRANGEMAX("Account No.") then
              exit(GETRANGEMAX("Account No."));
        end;
    */




    /*
    procedure SetAccountNoFromFilter ()
        var
    //       AccountNo@1000 :
          AccountNo: Code[20];
        begin
          AccountNo := GetFilterAccountNo;
          if AccountNo = '' then begin
            FILTERGROUP(2);
            AccountNo := GetFilterAccountNo;
            FILTERGROUP(0);
          end;
          if AccountNo <> '' then
            "Account No." := AccountNo;
        end;
    */



    //     procedure GetNewLineNo (TemplateName@1000 : Code[10];BatchName@1001 :

    /*
    procedure GetNewLineNo (TemplateName: Code[10];BatchName: Code[10]) : Integer;
        var
    //       GenJournalLine@1002 :
          GenJournalLine: Record 81;
        begin
          GenJournalLine.VALIDATE("Journal Template Name",TemplateName);
          GenJournalLine.VALIDATE("Journal Batch Name",BatchName);
          GenJournalLine.SETRANGE("Journal Template Name",TemplateName);
          GenJournalLine.SETRANGE("Journal Batch Name",BatchName);
          if GenJournalLine.FINDLAST then
            exit(GenJournalLine."Line No." + 10000);
          exit(10000);
        end;
    */




    /*
    procedure VoidPaymentFile ()
        var
    //       TempGenJnlLine@1000 :
          TempGenJnlLine: Record 81 TEMPORARY;
    //       GenJournalLine2@1002 :
          GenJournalLine2: Record 81;
    //       VoidTransmitElecPmnts@1001 :
          VoidTransmitElecPmnts: Report 9200;
        begin
          TempGenJnlLine.RESET;
          TempGenJnlLine := Rec;
          TempGenJnlLine.SETRANGE("Journal Template Name","Journal Template Name");
          TempGenJnlLine.SETRANGE("Journal Batch Name","Journal Batch Name");
          GenJournalLine2.COPYFILTERS(TempGenJnlLine);
          GenJournalLine2.SETFILTER("Document Type",'Payment|Refund');
          GenJournalLine2.SETFILTER("Bank Payment Type",'Electronic Payment|Electronic Payment-IAT');
          GenJournalLine2.SETRANGE("Exported to Payment File",TRUE);
          GenJournalLine2.SETRANGE("Check Transmitted",FALSE);
          if not GenJournalLine2.FINDFIRST then
            ERROR(NoEntriesToVoidErr);

          CLEAR(VoidTransmitElecPmnts);
          VoidTransmitElecPmnts.SetUsageType(1);   // Void
          VoidTransmitElecPmnts.SETTABLEVIEW(TempGenJnlLine);
          if "Account Type" = "Account Type"::"Bank Account" then
            VoidTransmitElecPmnts.SetBankAccountNo("Account No.")
          else
            if "Bal. Account Type" = "Bal. Account Type"::"Bank Account" then
              VoidTransmitElecPmnts.SetBankAccountNo("Bal. Account No.");
          VoidTransmitElecPmnts.RUNMODAL;
        end;
    */




    /*
    procedure TransmitPaymentFile ()
        var
    //       TempGenJnlLine@1000 :
          TempGenJnlLine: Record 81 TEMPORARY;
    //       VoidTransmitElecPmnts@1001 :
          VoidTransmitElecPmnts: Report 9200;
        begin
          TempGenJnlLine.RESET;
          TempGenJnlLine := Rec;
          TempGenJnlLine.SETRANGE("Journal Template Name","Journal Template Name");
          TempGenJnlLine.SETRANGE("Journal Batch Name","Journal Batch Name");
          CLEAR(VoidTransmitElecPmnts);
          VoidTransmitElecPmnts.SetUsageType(2);   // Transmit
          VoidTransmitElecPmnts.SETTABLEVIEW(TempGenJnlLine);
          if "Account Type" = "Account Type"::"Bank Account" then
            VoidTransmitElecPmnts.SetBankAccountNo("Account No.")
          else
            if "Bal. Account Type" = "Bal. Account Type"::"Bank Account" then
              VoidTransmitElecPmnts.SetBankAccountNo("Bal. Account No.");
          VoidTransmitElecPmnts.RUNMODAL;
        end;
    */


    //     LOCAL procedure SetSalespersonPurchaserCode (SalesperPurchCodeToCheck@1000 : Code[20];var SalesperPuchCodeToAssign@1001 :


    LOCAL procedure SetSalespersonPurchaserCode(SalesperPurchCodeToCheck: Code[20]; var SalesperPuchCodeToAssign: Code[20])
    begin
        if SalesperPurchCodeToCheck <> '' then
            if SalespersonPurchaser.GET(SalesperPurchCodeToCheck) then
                if SalespersonPurchaser.VerifySalesPersonPurchaserPrivacyBlocked(SalespersonPurchaser) then
                    SalesperPuchCodeToAssign := ''
                else
                    SalesperPuchCodeToAssign := SalesperPurchCodeToCheck;
    end;




    //     procedure ValidateSalesPersonPurchaserCode (GenJournalLine2@1000 :

    /*
    procedure ValidateSalesPersonPurchaserCode (GenJournalLine2: Record 81)
        begin
          if GenJournalLine2."Salespers./Purch. Code" <> '' then
            if SalespersonPurchaser.GET(GenJournalLine2."Salespers./Purch. Code") then
              if SalespersonPurchaser.VerifySalesPersonPurchaserPrivacyBlocked(SalespersonPurchaser) then
                ERROR(SalespersonPurchPrivacyBlockErr,GenJournalLine2."Salespers./Purch. Code");
        end;
    */


    //     LOCAL procedure SetApplnRecipientBankAccount (AccType@1100001 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset';AccNo@1100000 : Code[20];AppliesToDocNo@1100004 : Code[20];RecipientBankAcc@1100005 :

    /*
    LOCAL procedure SetApplnRecipientBankAccount (AccType: Option "G/L Account","Customer","Vendor","Bank Account","Fixed Asset";AccNo: Code[20];AppliesToDocNo: Code[20];RecipientBankAcc: Code[20])
        var
    //       Customer@1100003 :
          Customer: Record 18;
    //       Vendor@1100002 :
          Vendor: Record 23;
        begin
          if AppliesToDocNo = '' then
            CASE AccType OF
              AccType::Customer:
                if Customer.GET(AccNo) and (Customer."Preferred Bank Account Code" <> '') then
                  VALIDATE("Recipient Bank Account",Customer."Preferred Bank Account Code");
              AccType::Vendor:
                if Vendor.GET(AccNo) and (Vendor."Preferred Bank Account Code" <> '') then
                  VALIDATE("Recipient Bank Account",Vendor."Preferred Bank Account Code");
            end
          else
            if RecipientBankAcc <> '' then
              VALIDATE("Recipient Bank Account",RecipientBankAcc);
        end;
    */




    /*
    procedure CheckIfPrivacyBlocked ()
        var
    //       Customer@1002 :
          Customer: Record 18;
    //       Vendor@1001 :
          Vendor: Record 23;
    //       Employee@1000 :
          Employee: Record 5200;
        begin
          if FIND('-') then begin
            repeat
              CASE "Account Type" OF
                "Account Type"::Customer:
                  begin
                    Customer.GET("Account No.");
                    if Customer."Privacy Blocked" then
                      ERROR(Customer.GetPrivacyBlockedGenericErrorText(Customer));
                    if Customer.Blocked = Customer.Blocked::All then
                      ERROR(BlockedErr,Customer.Blocked,Customer.TABLECAPTION,Customer."No.");
                  end;
                "Account Type"::Vendor:
                  begin
                    Vendor.GET("Account No.");
                    if Vendor."Privacy Blocked" then
                      ERROR(Vendor.GetPrivacyBlockedGenericErrorText(Vendor));
                    if Vendor.Blocked IN [Vendor.Blocked::All,Vendor.Blocked::Payment] then
                      ERROR(BlockedErr,Vendor.Blocked,Vendor.TABLECAPTION,Vendor."No.");
                  end;
                "Account Type"::Employee:
                  begin
                    Employee.GET("Account No.");
                    if Employee."Privacy Blocked" then
                      ERROR(BlockedEmplErr,Employee."No.");
                  end;
              end;
            until NEXT <= 0;
          end;
        end;
    */



    /*
    LOCAL procedure ClearInvCrMemoTypeFields ()
        begin
          "Sales Invoice Type" := 0;
          "Sales Cr. Memo Type" := 0;
          "Sales Special Scheme Code" := 0;
          "Purch. Invoice Type" := 0;
          "Purch. Cr. Memo Type" := 0;
          "Purch. Special Scheme Code" := 0;
          "Correction Type" := 0;
          "Corrected Invoice No." := '';
        end;
    */




    LOCAL procedure ClearCurrencyCode()
    var
        //       BankAccount@1000 :
        BankAccount: Record 270;
    begin
        if (xRec."Bal. Account Type" = xRec."Bal. Account Type"::"Bank Account") and (xRec."Bal. Account No." <> '') then begin
            BankAccount.GET(xRec."Bal. Account No.");
            if BankAccount."Currency Code" = "Currency Code" then
                "Currency Code" := '';
        end;
    end;




    //     LOCAL procedure OnAfterSetupNewLine (var GenJournalLine@1000 : Record 81;GenJournalTemplate@1001 : Record 80;GenJournalBatch@1002 : Record 232;LastGenJournalLine@1003 : Record 81;Balance@1004 : Decimal;BottomLine@1005 :

    /*
    LOCAL procedure OnAfterSetupNewLine (var GenJournalLine: Record 81;GenJournalTemplate: Record 80;GenJournalBatch: Record 232;LastGenJournalLine: Record 81;Balance: Decimal;BottomLine: Boolean)
        begin
        end;
    */



    //     LOCAL procedure OnAfterClearCustApplnEntryFields (var CustLedgerEntry@1000 :

    /*
    LOCAL procedure OnAfterClearCustApplnEntryFields (var CustLedgerEntry: Record 21)
        begin
        end;
    */



    //     LOCAL procedure OnAfterClearEmplApplnEntryFields (var EmployeeLedgerEntry@1000 :

    /*
    LOCAL procedure OnAfterClearEmplApplnEntryFields (var EmployeeLedgerEntry: Record 5222)
        begin
        end;
    */



    //     LOCAL procedure OnAfterClearVendApplnEntryFields (var VendorLedgerEntry@1000 :

    /*
    LOCAL procedure OnAfterClearVendApplnEntryFields (var VendorLedgerEntry: Record 25)
        begin
        end;
    */



    //     LOCAL procedure OnAfterCopyGenJnlLineFromCustLedgEntry (CustLedgerEntry@1000 : Record 21;var GenJournalLine@1001 :

    /*
    LOCAL procedure OnAfterCopyGenJnlLineFromCustLedgEntry (CustLedgerEntry: Record 21;var GenJournalLine: Record 81)
        begin
        end;
    */



    //     LOCAL procedure OnAfterCopyGenJnlLineFromGenJnlAllocation (GenJnlAllocation@1000 : Record 221;var GenJournalLine@1001 :

    /*
    LOCAL procedure OnAfterCopyGenJnlLineFromGenJnlAllocation (GenJnlAllocation: Record 221;var GenJournalLine: Record 81)
        begin
        end;
    */



    //     LOCAL procedure OnAfterCopyGenJnlLineFromSalesHeader (SalesHeader@1001 : Record 36;var GenJournalLine@1000 :

    /*
    LOCAL procedure OnAfterCopyGenJnlLineFromSalesHeader (SalesHeader: Record 36;var GenJournalLine: Record 81)
        begin
        end;
    */



    //     LOCAL procedure OnAfterCopyGenJnlLineFromSalesHeaderPrepmt (SalesHeader@1000 : Record 36;var GenJournalLine@1001 :

    /*
    LOCAL procedure OnAfterCopyGenJnlLineFromSalesHeaderPrepmt (SalesHeader: Record 36;var GenJournalLine: Record 81)
        begin
        end;
    */



    //     LOCAL procedure OnAfterCopyGenJnlLineFromSalesHeaderPrepmtPost (SalesHeader@1000 : Record 36;var GenJournalLine@1001 : Record 81;UsePmtDisc@1002 :

    /*
    LOCAL procedure OnAfterCopyGenJnlLineFromSalesHeaderPrepmtPost (SalesHeader: Record 36;var GenJournalLine: Record 81;UsePmtDisc: Boolean)
        begin
        end;
    */



    //     LOCAL procedure OnAfterCopyGenJnlLineFromSalesHeaderApplyTo (SalesHeader@1000 : Record 36;var GenJournalLine@1001 :

    /*
    LOCAL procedure OnAfterCopyGenJnlLineFromSalesHeaderApplyTo (SalesHeader: Record 36;var GenJournalLine: Record 81)
        begin
        end;
    */



    //     LOCAL procedure OnAfterCopyGenJnlLineFromSalesHeaderPayment (SalesHeader@1000 : Record 36;var GenJournalLine@1001 :

    /*
    LOCAL procedure OnAfterCopyGenJnlLineFromSalesHeaderPayment (SalesHeader: Record 36;var GenJournalLine: Record 81)
        begin
        end;
    */



    //     LOCAL procedure OnAfterCopyGenJnlLineFromPurchHeader (PurchaseHeader@1001 : Record 38;var GenJournalLine@1000 :

    /*
    LOCAL procedure OnAfterCopyGenJnlLineFromPurchHeader (PurchaseHeader: Record 38;var GenJournalLine: Record 81)
        begin
        end;
    */



    //     LOCAL procedure OnAfterCopyGenJnlLineFromPurchHeaderPrepmt (PurchaseHeader@1001 : Record 38;var GenJournalLine@1000 :

    /*
    LOCAL procedure OnAfterCopyGenJnlLineFromPurchHeaderPrepmt (PurchaseHeader: Record 38;var GenJournalLine: Record 81)
        begin
        end;
    */



    //     LOCAL procedure OnAfterCopyGenJnlLineFromPurchHeaderPrepmtPost (PurchaseHeader@1000 : Record 38;var GenJournalLine@1001 : Record 81;UsePmtDisc@1002 :

    /*
    LOCAL procedure OnAfterCopyGenJnlLineFromPurchHeaderPrepmtPost (PurchaseHeader: Record 38;var GenJournalLine: Record 81;UsePmtDisc: Boolean)
        begin
        end;
    */



    //     LOCAL procedure OnAfterCopyGenJnlLineFromPurchHeaderApplyTo (PurchaseHeader@1000 : Record 38;var GenJournalLine@1001 :

    /*
    LOCAL procedure OnAfterCopyGenJnlLineFromPurchHeaderApplyTo (PurchaseHeader: Record 38;var GenJournalLine: Record 81)
        begin
        end;
    */



    //     LOCAL procedure OnAfterCopyGenJnlLineFromPurchHeaderPayment (PurchaseHeader@1000 : Record 38;var GenJournalLine@1001 :

    /*
    LOCAL procedure OnAfterCopyGenJnlLineFromPurchHeaderPayment (PurchaseHeader: Record 38;var GenJournalLine: Record 81)
        begin
        end;
    */



    //     LOCAL procedure OnAfterCopyGenJnlLineFromServHeader (ServiceHeader@1001 : Record 5900;var GenJournalLine@1000 :

    /*
    LOCAL procedure OnAfterCopyGenJnlLineFromServHeader (ServiceHeader: Record 5900;var GenJournalLine: Record 81)
        begin
        end;
    */



    //     LOCAL procedure OnAfterCopyGenJnlLineFromServHeaderApplyTo (ServiceHeader@1001 : Record 5900;var GenJournalLine@1000 :

    /*
    LOCAL procedure OnAfterCopyGenJnlLineFromServHeaderApplyTo (ServiceHeader: Record 5900;var GenJournalLine: Record 81)
        begin
        end;
    */



    //     LOCAL procedure OnAfterCopyGenJnlLineFromServHeaderPayment (ServiceHeader@1001 : Record 5900;var GenJournalLine@1000 :

    /*
    LOCAL procedure OnAfterCopyGenJnlLineFromServHeaderPayment (ServiceHeader: Record 5900;var GenJournalLine: Record 81)
        begin
        end;
    */



    //     LOCAL procedure OnAfterCopyGenJnlLineFromInvPostBuffer (InvoicePostBuffer@1001 : Record 49;var GenJournalLine@1000 :


    LOCAL procedure OnAfterCopyGenJnlLineFromInvPostBuffer(InvoicePostBuffer: Record "Invoice Posting Buffer"; var GenJournalLine: Record 81)
    begin
    end;




    //     LOCAL procedure OnAfterCopyGenJnlLineFromInvPostBufferFA (InvoicePostBuffer@1000 : Record 49;var GenJournalLine@1001 :


    LOCAL procedure OnAfterCopyGenJnlLineFromInvPostBufferFA(InvoicePostBuffer: Record "Invoice Posting Buffer"; var GenJournalLine: Record 81)
    begin
    end;




    //     LOCAL procedure OnAfterCopyGenJnlLineFromPrepmtInvBuffer (PrepmtInvLineBuffer@1001 : Record 461;var GenJournalLine@1000 :

    /*
    LOCAL procedure OnAfterCopyGenJnlLineFromPrepmtInvBuffer (PrepmtInvLineBuffer: Record 461;var GenJournalLine: Record 81)
        begin
        end;
    */



    //     LOCAL procedure OnAfterAccountNoOnValidateGetGLAccount (var GenJournalLine@1000 : Record 81;var GLAccount@1001 :

    /*
    LOCAL procedure OnAfterAccountNoOnValidateGetGLAccount (var GenJournalLine: Record 81;var GLAccount: Record 15)
        begin
        end;
    */



    //     LOCAL procedure OnAfterAccountNoOnValidateGetGLBalAccount (var GenJournalLine@1000 : Record 81;var GLAccount@1001 :

    /*
    LOCAL procedure OnAfterAccountNoOnValidateGetGLBalAccount (var GenJournalLine: Record 81;var GLAccount: Record 15)
        begin
        end;
    */



    //     LOCAL procedure OnAfterAccountNoOnValidateGetCustomerAccount (var GenJournalLine@1000 : Record 81;var Customer@1001 : Record 18;FieldNo@1002 :


    LOCAL procedure OnAfterAccountNoOnValidateGetCustomerAccount(var GenJournalLine: Record 81; var Customer: Record 18; FieldNo: Integer)
    begin
    end;




    //     LOCAL procedure OnAfterAccountNoOnValidateGetCustomerBalAccount (var GenJournalLine@1000 : Record 81;var Customer@1001 : Record 18;FieldNo@1002 :


    LOCAL procedure OnAfterAccountNoOnValidateGetCustomerBalAccount(var GenJournalLine: Record 81; var Customer: Record 18; FieldNo: Integer)
    begin
    end;




    //     LOCAL procedure OnAfterAccountNoOnValidateGetVendorAccount (var GenJournalLine@1000 : Record 81;var Vendor@1001 : Record 23;FieldNo@1002 :


    LOCAL procedure OnAfterAccountNoOnValidateGetVendorAccount(var GenJournalLine: Record 81; var Vendor: Record 23; FieldNo: Integer)
    begin
    end;




    //     LOCAL procedure OnAfterAccountNoOnValidateGetVendorBalAccount (var GenJournalLine@1000 : Record 81;var Vendor@1001 : Record 23;FieldNo@1002 :


    LOCAL procedure OnAfterAccountNoOnValidateGetVendorBalAccount(var GenJournalLine: Record 81; var Vendor: Record 23; FieldNo: Integer)
    begin
    end;




    //     LOCAL procedure OnAfterAccountNoOnValidateGetEmployeeAccount (var GenJournalLine@1000 : Record 81;var Employee@1001 :

    /*
    LOCAL procedure OnAfterAccountNoOnValidateGetEmployeeAccount (var GenJournalLine: Record 81;var Employee: Record 5200)
        begin
        end;
    */



    //     LOCAL procedure OnAfterAccountNoOnValidateGetEmployeeBalAccount (var GenJournalLine@1000 : Record 81;var Employee@1001 : Record 5200;FieldNo@1002 :

    /*
    LOCAL procedure OnAfterAccountNoOnValidateGetEmployeeBalAccount (var GenJournalLine: Record 81;var Employee: Record 5200;FieldNo: Integer)
        begin
        end;
    */



    //     LOCAL procedure OnAfterAccountNoOnValidateGetBankAccount (var GenJournalLine@1000 : Record 81;var BankAccount@1001 : Record 270;FieldNo@1002 :


    LOCAL procedure OnAfterAccountNoOnValidateGetBankAccount(var GenJournalLine: Record 81; var BankAccount: Record 270; FieldNo: Integer)
    begin
    end;




    //     LOCAL procedure OnAfterAccountNoOnValidateGetBankBalAccount (var GenJournalLine@1000 : Record 81;var BankAccount@1001 : Record 270;FieldNo@1002 :


    LOCAL procedure OnAfterAccountNoOnValidateGetBankBalAccount(var GenJournalLine: Record 81; var BankAccount: Record 270; FieldNo: Integer)
    begin
    end;




    //     LOCAL procedure OnAfterAccountNoOnValidateGetFAAccount (var GenJournalLine@1000 : Record 81;var FixedAsset@1001 :

    /*
    LOCAL procedure OnAfterAccountNoOnValidateGetFAAccount (var GenJournalLine: Record 81;var FixedAsset: Record 5600)
        begin
        end;
    */



    //     LOCAL procedure OnAfterAccountNoOnValidateGetFABalAccount (var GenJournalLine@1000 : Record 81;var FixedAsset@1001 :

    /*
    LOCAL procedure OnAfterAccountNoOnValidateGetFABalAccount (var GenJournalLine: Record 81;var FixedAsset: Record 5600)
        begin
        end;
    */



    //     LOCAL procedure OnAfterAccountNoOnValidateGetICPartnerAccount (var GenJournalLine@1000 : Record 81;var ICPartner@1001 :

    /*
    LOCAL procedure OnAfterAccountNoOnValidateGetICPartnerAccount (var GenJournalLine: Record 81;var ICPartner: Record 413)
        begin
        end;
    */



    //     LOCAL procedure OnAfterAccountNoOnValidateGetICPartnerBalAccount (var GenJournalLine@1000 : Record 81;var ICPartner@1001 :

    /*
    LOCAL procedure OnAfterAccountNoOnValidateGetICPartnerBalAccount (var GenJournalLine: Record 81;var ICPartner: Record 413)
        begin
        end;
    */



    //     LOCAL procedure OnAfterCreateTempJobJnlLine (var JobJournalLine@1003 : Record 210;GenJournalLine@1002 : Record 81;xGenJournalLine@1001 : Record 81;CurrFieldNo@1000 :

    /*
    LOCAL procedure OnAfterCreateTempJobJnlLine (var JobJournalLine: Record 210;GenJournalLine: Record 81;xGenJournalLine: Record 81;CurrFieldNo: Integer)
        begin
        end;
    */



    //     LOCAL procedure OnBeforeCreateTempJobJnlLine (var JobJournalLine@1003 : Record 210;GenJournalLine@1000 : Record 81;xGenJournalLine@1002 : Record 81;CurrFieldNo@1001 :

    /*
    LOCAL procedure OnBeforeCreateTempJobJnlLine (var JobJournalLine: Record 210;GenJournalLine: Record 81;xGenJournalLine: Record 81;CurrFieldNo: Integer)
        begin
        end;
    */



    //     LOCAL procedure OnAfterUpdatePricesFromJobJnlLine (var GenJournalLine@1000 : Record 81;JobJournalLine@1001 :

    /*
    LOCAL procedure OnAfterUpdatePricesFromJobJnlLine (var GenJournalLine: Record 81;JobJournalLine: Record 210)
        begin
        end;
    */



    //     LOCAL procedure OnAfterCreateDimTableIDs (var GenJournalLine@1000 : Record 81;FieldNo@1001 : Integer;var TableID@1003 : ARRAY [10] OF Integer;var No@1002 :

    /*
    LOCAL procedure OnAfterCreateDimTableIDs (var GenJournalLine: Record 81;FieldNo: Integer;var TableID: ARRAY [10] OF Integer;var No: ARRAY [10] OF Code[20])
        begin
        end;
    */



    //     LOCAL procedure OnAfterClearPostingGroups (var GenJournalLine@1000 :

    /*
    LOCAL procedure OnAfterClearPostingGroups (var GenJournalLine: Record 81)
        begin
        end;
    */



    //     LOCAL procedure OnAfterClearBalPostingGroups (var GenJournalLine@1000 :

    /*
    LOCAL procedure OnAfterClearBalPostingGroups (var GenJournalLine: Record 81)
        begin
        end;
    */



    //     LOCAL procedure OnAfterGetCustLedgerEntry (var GenJournalLine@1000 : Record 81;CustLedgerEntry@1001 :

    /*
    LOCAL procedure OnAfterGetCustLedgerEntry (var GenJournalLine: Record 81;CustLedgerEntry: Record 21)
        begin
        end;
    */



    //     LOCAL procedure OnAfterGetEmplLedgerEntry (var GenJournalLine@1000 : Record 81;EmployeeLedgerEntry@1001 :

    /*
    LOCAL procedure OnAfterGetEmplLedgerEntry (var GenJournalLine: Record 81;EmployeeLedgerEntry: Record 5222)
        begin
        end;
    */



    //     LOCAL procedure OnAfterGetVendLedgerEntry (var GenJournalLine@1000 : Record 81;VendorLedgerEntry@1001 :

    /*
    LOCAL procedure OnAfterGetVendLedgerEntry (var GenJournalLine: Record 81;VendorLedgerEntry: Record 25)
        begin
        end;
    */



    //     LOCAL procedure OnAfterValidateApplyRequirements (TempGenJnlLine@1000 :

    /*
    LOCAL procedure OnAfterValidateApplyRequirements (TempGenJnlLine: Record 81 TEMPORARY)
        begin
        end;
    */



    //     LOCAL procedure OnAfterCheckDirectPosting (var GLAccount@1000 : Record 15;GenJournalLine@1001 :

    /*
    LOCAL procedure OnAfterCheckDirectPosting (var GLAccount: Record 15;GenJournalLine: Record 81)
        begin
        end;
    */



    //     LOCAL procedure OnAfterSetAmountWithRemaining (var GenJournalLine@1000 :

    /*
    LOCAL procedure OnAfterSetAmountWithRemaining (var GenJournalLine: Record 81)
        begin
        end;
    */



    //     LOCAL procedure OnAfterSetJournalLineFieldsFromApplication (var GenJournalLine@1000 : Record 81;AccType@1002 : 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Employee';AccNo@1001 :

    /*
    LOCAL procedure OnAfterSetJournalLineFieldsFromApplication (var GenJournalLine: Record 81;AccType: Option "G/L Account","Customer","Vendor","Bank Account","Fixed Asset","IC Partner","Employee";AccNo: Code[20])
        begin
        end;
    */



    //     LOCAL procedure OnAfterUpdateDocumentTypeAndAppliesToFields (var GenJournalLine@1000 : Record 81;DocType@1002 : Integer;DocNo@1001 :

    /*
    LOCAL procedure OnAfterUpdateDocumentTypeAndAppliesToFields (var GenJournalLine: Record 81;DocType: Integer;DocNo: Code[20])
        begin
        end;
    */



    //     LOCAL procedure OnBeforeCheckDirectPosting (var GLAccount@1000 : Record 15;var IsHandled@1001 : Boolean;GenJournalLine@1002 :

    /*
    LOCAL procedure OnBeforeCheckDirectPosting (var GLAccount: Record 15;var IsHandled: Boolean;GenJournalLine: Record 81)
        begin
        end;
    */



    //     LOCAL procedure OnBeforeLookUpAppliesToDocCust (GenJournalLine@1000 : Record 81;AccNo@1001 :

    /*
    LOCAL procedure OnBeforeLookUpAppliesToDocCust (GenJournalLine: Record 81;AccNo: Code[20])
        begin
        end;
    */



    //     LOCAL procedure OnBeforeLookUpAppliesToDocEmpl (GenJournalLine@1001 : Record 81;AccNo@1000 :

    /*
    LOCAL procedure OnBeforeLookUpAppliesToDocEmpl (GenJournalLine: Record 81;AccNo: Code[20])
        begin
        end;
    */



    //     LOCAL procedure OnBeforeLookUpAppliesToDocVend (GenJournalLine@1001 : Record 81;AccNo@1000 :

    /*
    LOCAL procedure OnBeforeLookUpAppliesToDocVend (GenJournalLine: Record 81;AccNo: Code[20])
        begin
        end;
    */



    //     LOCAL procedure OnBeforeSetAmountWithCustLedgEntry (var GenJournalLine@1000 : Record 81;var CustLedgerEntry@1001 :

    /*
    LOCAL procedure OnBeforeSetAmountWithCustLedgEntry (var GenJournalLine: Record 81;var CustLedgerEntry: Record 21)
        begin
        end;
    */



    //     LOCAL procedure OnBeforeSetAmountWithVendLedgEntry (var GenJournalLine@1000 : Record 81;var VendorLedgerEntry@1001 :

    /*
    LOCAL procedure OnBeforeSetAmountWithVendLedgEntry (var GenJournalLine: Record 81;var VendorLedgerEntry: Record 25)
        begin
        end;
    */



    //     LOCAL procedure OnLookUpAppliesToDocCustOnAfterSetFilters (var CustLedgerEntry@1000 : Record 21;var GenJournalLine@1001 :

    /*
    LOCAL procedure OnLookUpAppliesToDocCustOnAfterSetFilters (var CustLedgerEntry: Record 21;var GenJournalLine: Record 81)
        begin
        end;
    */



    //     LOCAL procedure OnBeforeValidateBalGenBusPostingGroup (var GenJournalLine@1001 : Record 81;var CheckIfFieldIsEmpty@1000 :

    /*
    LOCAL procedure OnBeforeValidateBalGenBusPostingGroup (var GenJournalLine: Record 81;var CheckIfFieldIsEmpty: Boolean)
        begin
        end;
    */



    //     LOCAL procedure OnBeforeValidateBalGenPostingType (var GenJournalLine@1001 : Record 81;var CheckIfFieldIsEmpty@1000 :

    /*
    LOCAL procedure OnBeforeValidateBalGenPostingType (var GenJournalLine: Record 81;var CheckIfFieldIsEmpty: Boolean)
        begin
        end;
    */



    //     LOCAL procedure OnBeforeValidateBalGenProdPostingGroup (var GenJournalLine@1001 : Record 81;var CheckIfFieldIsEmpty@1000 :

    /*
    LOCAL procedure OnBeforeValidateBalGenProdPostingGroup (var GenJournalLine: Record 81;var CheckIfFieldIsEmpty: Boolean)
        begin
        end;
    */



    //     LOCAL procedure OnBeforeValidateGenBusPostingGroup (var GenJournalLine@1000 : Record 81;var CheckIfFieldIsEmpty@1001 :

    /*
    LOCAL procedure OnBeforeValidateGenBusPostingGroup (var GenJournalLine: Record 81;var CheckIfFieldIsEmpty: Boolean)
        begin
        end;
    */



    //     LOCAL procedure OnBeforeValidateGenPostingType (var GenJournalLine@1001 : Record 81;var CheckIfFieldIsEmpty@1000 :

    /*
    LOCAL procedure OnBeforeValidateGenPostingType (var GenJournalLine: Record 81;var CheckIfFieldIsEmpty: Boolean)
        begin
        end;
    */



    //     LOCAL procedure OnBeforeValidateGenProdPostingGroup (var GenJournalLine@1001 : Record 81;var CheckIfFieldIsEmpty@1000 :

    /*
    LOCAL procedure OnBeforeValidateGenProdPostingGroup (var GenJournalLine: Record 81;var CheckIfFieldIsEmpty: Boolean)
        begin
        end;
    */



    //     LOCAL procedure OnLookUpAppliesToDocCustOnAfterUpdateDocumentTypeAndAppliesTo (var GenJournalLine@1000 : Record 81;CustLedgerEntry@1001 :

    /*
    LOCAL procedure OnLookUpAppliesToDocCustOnAfterUpdateDocumentTypeAndAppliesTo (var GenJournalLine: Record 81;CustLedgerEntry: Record 21)
        begin
        end;
    */



    //     LOCAL procedure OnLookUpAppliesToDocEmplOnAfterSetFilters (var EmployeeLedgerEntry@1000 : Record 5222;var GenJournalLine@1001 :

    /*
    LOCAL procedure OnLookUpAppliesToDocEmplOnAfterSetFilters (var EmployeeLedgerEntry: Record 5222;var GenJournalLine: Record 81)
        begin
        end;
    */



    //     LOCAL procedure OnLookUpAppliesToDocEmplOnAfterUpdateDocumentTypeAndAppliesTo (var GenJournalLine@1000 : Record 81;EmployeeLedgerEntry@1001 :

    /*
    LOCAL procedure OnLookUpAppliesToDocEmplOnAfterUpdateDocumentTypeAndAppliesTo (var GenJournalLine: Record 81;EmployeeLedgerEntry: Record 5222)
        begin
        end;
    */



    //     LOCAL procedure OnLookUpAppliesToDocVendOnAfterSetFilters (var VendorLedgerEntry@1000 : Record 25;var GenJournalLine@1001 :

    /*
    LOCAL procedure OnLookUpAppliesToDocVendOnAfterSetFilters (var VendorLedgerEntry: Record 25;var GenJournalLine: Record 81)
        begin
        end;
    */



    //     LOCAL procedure OnLookUpAppliesToDocVendOnAfterUpdateDocumentTypeAndAppliesTo (var GenJournalLine@1000 : Record 81;VendorLedgerEntry@1001 :

    /*
    LOCAL procedure OnLookUpAppliesToDocVendOnAfterUpdateDocumentTypeAndAppliesTo (var GenJournalLine: Record 81;VendorLedgerEntry: Record 25)
        begin
        end;

        [Integration(TRUE)]
    */

    //     LOCAL procedure OnUpdateLineBalanceOnAfterAssignBalanceLCY (var BalanceLCY@1000 :

    /*
    LOCAL procedure OnUpdateLineBalanceOnAfterAssignBalanceLCY (var BalanceLCY: Decimal)
        begin
        end;

        [Integration(TRUE)]
    */

    //     LOCAL procedure OnValidateAmountOnAfterAssignAmountLCY (var AmountLCY@1000 :

    /*
    LOCAL procedure OnValidateAmountOnAfterAssignAmountLCY (var AmountLCY: Decimal)
        begin
        end;

        [Integration(TRUE)]
    */

    //     LOCAL procedure OnValidateBalVATPctOnAfterAssignBalVATAmountLCY (var BalVATAmountLCY@1000 :

    /*
    LOCAL procedure OnValidateBalVATPctOnAfterAssignBalVATAmountLCY (var BalVATAmountLCY: Decimal)
        begin
        end;
    */



    /*
    LOCAL procedure SetLastModifiedDateTime ()
        var
    //       DotNet_DateTimeOffset@1000 :
          DotNet_DateTimeOffset: Codeunit 3006;
        begin
          "Last Modified DateTime" := DotNet_DateTimeOffset.ConvertToUtcDateTime(CURRENTDATETIME);
        end;
    */


    //     LOCAL procedure UpdateDocumentTypeAndAppliesTo (DocType@1000 : Integer;DocNo@1001 :

    /*
    LOCAL procedure UpdateDocumentTypeAndAppliesTo (DocType: Integer;DocNo: Code[20])
        begin
          "Applies-to Doc. Type" := DocType;
          "Applies-to Doc. No." := DocNo;
          "Applies-to ID" := '';

          OnAfterUpdateDocumentTypeAndAppliesToFields(Rec,DocType,DocNo);

          if "Document Type" <> "Document Type"::" " then
            exit;

          if not ("Account Type" IN ["Account Type"::Customer,"Account Type"::Vendor]) then
            exit;

          CASE "Applies-to Doc. Type" OF
            "Applies-to Doc. Type"::Payment:
              "Document Type" := "Document Type"::Invoice;
            "Applies-to Doc. Type"::"Credit Memo":
              "Document Type" := "Document Type"::Refund;
            "Applies-to Doc. Type"::Invoice,
            "Applies-to Doc. Type"::Refund:
              "Document Type" := "Document Type"::Payment;
          end;
        end;
    */




    /*
    procedure UpdateAccountID ()
        var
    //       GLAccount@1000 :
          GLAccount: Record 15;
        begin
          if "Account Type" <> "Account Type"::"G/L Account" then
            exit;

          if "Account No." = '' then begin
            CLEAR("Account Id");
            exit;
          end;

          if not GLAccount.GET("Account No.") then
            exit;

          "Account Id" := GLAccount.Id;
        end;
    */



    /*
    LOCAL procedure UpdateAccountNo ()
        var
    //       GLAccount@1001 :
          GLAccount: Record 15;
        begin
          if ISNULLGUID("Account Id") then
            exit;

          GLAccount.SETRANGE(Id,"Account Id");
          if not GLAccount.FINDFIRST then
            exit;

          "Account No." := GLAccount."No.";
        end;
    */




    /*
    procedure UpdateCustomerID ()
        var
    //       Customer@1000 :
          Customer: Record 18;
        begin
          if "Account Type" <> "Account Type"::Customer then
            exit;

          if "Account No." = '' then begin
            CLEAR("Customer Id");
            exit;
          end;

          if not Customer.GET("Account No.") then
            exit;

          "Customer Id" := Customer.Id;
        end;
    */



    /*
    LOCAL procedure UpdateCustomerNo ()
        var
    //       Customer@1001 :
          Customer: Record 18;
        begin
          if ISNULLGUID("Customer Id") then
            exit;

          Customer.SETRANGE(Id,"Customer Id");
          if not Customer.FINDFIRST then
            exit;

          "Account No." := Customer."No.";
        end;
    */




    /*
    procedure UpdateAppliesToInvoiceID ()
        var
    //       SalesInvoiceHeader@1000 :
          SalesInvoiceHeader: Record 112;
        begin
          if "Applies-to Doc. Type" <> "Applies-to Doc. Type"::Invoice then
            exit;

          if "Applies-to Doc. No." = '' then begin
            CLEAR("Applies-to Invoice Id");
            exit;
          end;

          if not SalesInvoiceHeader.GET("Applies-to Doc. No.") then
            exit;

          "Applies-to Invoice Id" := SalesInvoiceHeader.Id;
        end;
    */



    /*
    LOCAL procedure UpdateAppliesToInvoiceNo ()
        var
    //       SalesInvoiceHeader@1001 :
          SalesInvoiceHeader: Record 112;
        begin
          if ISNULLGUID("Applies-to Invoice Id") then
            exit;

          SalesInvoiceHeader.SETRANGE(Id,"Applies-to Invoice Id");
          if not SalesInvoiceHeader.FINDFIRST then
            exit;

          "Applies-to Doc. No." := SalesInvoiceHeader."No.";
        end;
    */




    /*
    procedure UpdateGraphContactId ()
        var
    //       Customer@1003 :
          Customer: Record 18;
    //       Contact@1002 :
          Contact: Record 5050;
    //       GraphIntContact@1001 :
          GraphIntContact: Codeunit 5461;
    //       GraphID@1000 :
          GraphID: Text[250];
        begin
          if ISNULLGUID("Customer Id") then
            CLEAR("Contact Graph Id");

          Customer.SETRANGE(Id,"Customer Id");
          if not Customer.FINDFIRST then
            CLEAR("Contact Graph Id");

          if not GraphIntContact.FindGraphContactIdFromCustomer(GraphID,Customer,Contact) then
            CLEAR("Contact Graph Id");

          "Contact Graph Id" := GraphID;
        end;
    */




    /*
    procedure UpdateJournalBatchID ()
        var
    //       GenJournalBatch@1000 :
          GenJournalBatch: Record 232;
        begin
          if not GenJournalBatch.GET("Journal Template Name","Journal Batch Name") then
            exit;

          "Journal Batch Id" := GenJournalBatch.Id;
        end;
    */



    /*
    LOCAL procedure UpdateJournalBatchName ()
        var
    //       GenJournalBatch@1001 :
          GenJournalBatch: Record 232;
        begin
          GenJournalBatch.SETRANGE(Id,"Journal Batch Id");
          if not GenJournalBatch.FINDFIRST then
            exit;

          "Journal Batch Name" := GenJournalBatch.Name;
        end;
    */




    /*
    procedure UpdatePaymentMethodId ()
        var
    //       PaymentMethod@1000 :
          PaymentMethod: Record 289;
        begin
          if "Payment Method Code" = '' then begin
            CLEAR("Payment Method Id");
            exit;
          end;

          if not PaymentMethod.GET("Payment Method Code") then
            exit;

          "Payment Method Id" := PaymentMethod.Id;
        end;
    */



    /*
    LOCAL procedure UpdatePaymentMethodCode ()
        var
    //       PaymentMethod@1001 :
          PaymentMethod: Record 289;
        begin
          if ISNULLGUID("Payment Method Id") then
            exit;

          PaymentMethod.SETRANGE(Id,"Payment Method Id");
          if not PaymentMethod.FINDFIRST then
            exit;

          "Payment Method Code" := PaymentMethod.Code;
        end;
    */


    //     LOCAL procedure UpdateDescriptionWithEmployeeName (Employee@1000 :

    /*
    LOCAL procedure UpdateDescriptionWithEmployeeName (Employee: Record 5200)
        begin
          if STRLEN(Employee.FullName) <= MAXSTRLEN(Description) then
            UpdateDescription(COPYSTR(Employee.FullName,1,MAXSTRLEN(Description)))
          else
            UpdateDescription(Employee.Initials);
        end;

        [Integration(TRUE)]
    */

    //     procedure OnGenJnlLineGetVendorAccount (Vendor@1213 :

    /*
    procedure OnGenJnlLineGetVendorAccount (Vendor: Record 23)
        begin
        end;
    */



    /*
    procedure ShowDeferralSchedule ()
        begin
          if "Account Type" = "Account Type"::"Fixed Asset" then
            ERROR(AccTypeNotSupportedErr);

          ShowDeferrals("Posting Date","Currency Code");
        end;
    */



    /*
    procedure fCalcApprovalStatus_BS20411 () : Text;
        var
    //       ApprovalEntry@1100286000 :
          ApprovalEntry: Record 454;
        begin
          //BS::20411 CSM 22/01/24 � PYC028 Estado de aprobaci�n en l�neas de diarios pagos. -
          ApprovalEntry.RESET;
          ApprovalEntry.SETRANGE("Journal Template Name", Rec."Journal Template Name");
          ApprovalEntry.SETRANGE("Journal Batch Name", Rec."Journal Batch Name");
          ApprovalEntry.SETRANGE("Journal Line No.", Rec."Line No.");
          if ApprovalEntry.FINDLAST then begin
            CASE (ApprovalEntry.Status) OF
              //BS::21338-
              ApprovalEntry.Status::Created, ApprovalEntry.Status::Open :
              //ApprovalEntry.Status::Created :
              //BS:21338+
                exit('Pendiente aprobaci�n');

              //BS::21338-
              ApprovalEntry.Status::Rejected :
              //ApprovalEntry.Status::Open, ApprovalEntry.Status::Canceled, ApprovalEntry.Status::Rejected :
              //BS:21338+
                exit('Abierto');
              //BS:21338+

              //BS::21338-
              ApprovalEntry.Status::Canceled :
                exit('Cancelado');
              //BS:21338+

              ApprovalEntry.Status::Approved :
                exit('Lanzado');
            end;
          end else
            exit('');

          //BS::20411 CSM 22/01/24 � PYC028 Estado de aprobaci�n en l�neas de diarios pagos. +
        end;

        /*begin
        //{
    //      QB 25/02/20: - Se a�ade el campo "WithHolding Job No.", si es un movimiento de retenci�n indica de que proyecto proviene
    //      QuoSII_1.1 - 16/08/2017 - Se modifican los campos 7174332, 7174334 y 7174336. Se elimina el campo 7174333, 7174337 y 7174338
    //                              - Se modifica la funci�n GetVendorAccount para que inicialice el campo "Purch. Invoice Type" siempre a F1 si el tipo es LF
    //                              - Se modifica la funci�n GetCustomerAccount para que inicialice el campo "Sales Invoice Type" siempre a F1 si el tipo es LF
    //      QuoSII_1.3.03.006 21/11/17 MCM - Se incluye el campo para importarlo como Fecha de Registro contable
    //      QuoSII1.4 23/04/18 PEL - A�adido valor LC al campo Purch. Inv Type
    //                             - Cambiado primer semestre en Sales Invoice Type, Sales Invoice Type 1 y Sales Invoice Type 2
    //                             - Cambiado primer semestre en Purch. Invoice Type, Purch. Invoice Type 1 y Purch. Invoice Type 2
    //      QuoSII1.4 23/04/18 PEL - Nuevas validaciones en Special Regiments
    //      QuoSII_1.4.02.042 29/11/18 MCM - Se incluye la opci�n de enviar a la ATCN
    //      QuoSII_1.4.93.999 10/07/19 QMD - Se copia el valor del campo R�gimen Especial del cliente o proveedor
    //      QuoSII_1.4.98.999 11/07/19 QMD - Filtros para la tabla SII Type List Value
    //      QuoSII_1.4.92.999 21/08/19 QMD - Controles del QuoSII en BBDD que no lo necesitan.
    //      PGM 07/10/20: - Creado el tipo "Shipment" en el campo "Document Type".
    //      JAV 23/03/22: - QB 1.10.27 Se eliminan los campos 7207282, 7207283, 7207288 y 7207289 que no se usan en el programa
    //      EPV         : - QB 1.10.27 INESCO Q16712 Permitir Recircular facturas a Cartera en �rdenes de pago registradas. Nuevo campo: "QB Redrawing"
    //      AML 23/03/22 Creados campos QB_ST01 para control valoraci�n existencias.
    //      JAV 04/04/22: - QB 1.10.31 Se cambia el campo 7207294 de boolean a integer, ahora guarda el nro de registro del anticipo
    //      JAV 17/06/22: - QB 1.10.50 Se elimina el campo 7207500 "QB Budget Item" duplicado con el 7207270
    //      JAV 21/06/22: - DP 1.00.00 Se a�aden los campos para el manejo de la prorrata. Modificado a partir de MercaBarna DP04a, Q12228, CEI14253, Q13668, CEI14117
    //                                    7174390 "DP Prorrata"
    //                                    7174391 "DP Prov. Prorrata %"
    //                                    7174392 "DP Prorrata Orig. VAT Amount"
    //      JAV 06/10/22: - QB 1.12.00 Se a�ade el campo 7207301 "QB Activation Mov.". 15/11/22 Se a�ade el campo 7207302 "QB Activation Code"
    //      BS::19974 AML 21/11/23 - Creado cmpo "QW % Withholding by GE"
    //      BS::20411 CSM 22/01/24 � PYC028 Estado de aprobaci�n en l�neas de diarios pagos. New Fields.
    //    }
        end.
      */
}




