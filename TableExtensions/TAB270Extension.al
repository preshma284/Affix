tableextension 50159 "QBU Bank AccountExt" extends "Bank Account"
{

    /*
  Permissions=TableData 271 r;
  */
    DataCaptionFields = "No.", "Name";
    CaptionML = ENU = 'Bank Account', ESP = 'Banco';
    LookupPageID = "Bank Account List";
    DrillDownPageID = "Bank Account List";

    fields
    {
        field(50000; "Texto pagare"; Text[100])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Texto pagar�';
            Description = 'Q18290';


        }
        field(50001; "Posicion inicio pagare"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Posici�n inicio pagar�';
            Description = 'Q18290';


        }
        field(50002; "Num caracteres pagare"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'N�m caracteres pagar�';
            Description = 'Q18290';


        }
        field(7207270; "JV Dimension Code"; Code[20])
        {
            TableRelation = "Dimension Value"."Code";
            CaptionML = ENU = 'JV Dimension Code', ESP = 'Cod. dimension UTE';
            Description = 'QB 1.00';
            CaptionClass = '1,2,5';


        }
        field(7207271; "Confirming Contract No."; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Confirming contract no.', ESP = 'N�mero de contrato de Confirming';
            Description = 'QB 1.00 - QVE3043 JAV 11/03/20: - Se amplia de 10 a 12 y el 15/10/20 se amplia de 12 a 20';


        }
        field(7207272; "Maximo  No. Cheque"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Ult. n� pagar�', ESP = 'M�ximo  n� cheque';
            Description = 'QB 1.02';


        }
        field(7207273; "No. control cheque"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'N� control cheque';
            MinValue = 0;
            MaxValue = 6;
            Description = 'QB 1.02';


        }
        field(7207274; "No. cheque adicional"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'N� cheque adicional';
            Description = 'QB 1.02';


        }
        field(7207275; "No. control cheque adicional"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'N� control cheque adicional';
            MinValue = 0;
            MaxValue = 6;
            Description = 'QB 1.02';


        }
        field(7207276; "Serie banco"; Code[10])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'N� Serie Banco';
            Description = 'QB 1.02';


        }
        field(7207277; "N67 Obligatoria"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'N67 Obligatoria';
            Description = 'QB 1.02';


        }
        field(7207278; "Digitos banco N 67"; Code[4])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'N� D�gitos banco para N67';
            Description = 'QB 1.02';


        }
        field(7207279; "Fecha ult. fichero N67"; Date)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Fecha �ltimpo fichero N67';
            Description = 'QB 1.02';


        }
        field(7207280; "Dig.Control Bankinter"; Code[2])
        {
            DataClassification = ToBeClassified;
            Description = 'QB 1.06.01 - JAV 14/07/20: Para generar el confirming de Bankinter';


        }
        field(7207281; "Imp Lineas Documentos"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Nro Lineas Documentos';
            Description = 'QB 1.01 - JAV 28/04/20 Impresi�n de cheques en l�se, cuantas l�neas caben en una hoja';


        }
        field(7207282; "Pagare sin Barras"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Pagar� sin C.Barras impreso';
            Description = 'QB 1.05 - Si el pagar� no lo lleva hay que calcular algunas cosas';


        }
        field(7207285; "Margin days for conciliation"; Integer)
        {
            CaptionML = ESP = 'Dias margen conciliacion';
            Description = 'QB 1.06.14 - JAV 15/09/20 : - D�as de margen para la conciliaci�n bancaria por defecto para este banco';


        }
        field(7207286; "Confirming Line"; Code[10])
        {
            TableRelation = "QB Confirming Lines";


            CaptionML = ESP = 'L�nea de Confirming asociada';
            Description = 'QB 1.06.15 - JAV 23/09/20 : - L�nea de Confirming asociada a la cuenta bancaria';

            trigger OnValidate();
            VAR
                //                                                                 QBConfirmingBankAccounts@1100286000 :
                QBConfirmingBankAccounts: Record 7206947;
            BEGIN
                //Si antes ten�a una l�nea y ahora se ha puesto otra, elimino la anterior
                IF (xRec."Confirming Line" <> '') AND ("Confirming Line" <> xRec."Confirming Line") THEN BEGIN
                    IF QBConfirmingBankAccounts.GET(xRec."Confirming Line", COMPANYNAME, "No.") THEN BEGIN
                        QBConfirmingBankAccounts.SetAmountUsed;
                        IF (QBConfirmingBankAccounts."Amount Disposed" <> 0) THEN
                            ERROR(txtQB000);
                        QBConfirmingBankAccounts.DELETE;
                    END;
                END;

                //Si ahora tiene una l�nea y ha cambiado, creo la nueva
                IF ("Confirming Line" <> '') AND ("Confirming Line" <> xRec."Confirming Line") THEN BEGIN
                    QBConfirmingBankAccounts.INIT;
                    QBConfirmingBankAccounts."Confirming Line" := "Confirming Line";
                    QBConfirmingBankAccounts.Company := COMPANYNAME;
                    QBConfirmingBankAccounts."Bank Account" := "No.";
                    QBConfirmingBankAccounts.Description := DELCHR(Name + ' ' + "Name 2", '<>', ' ');
                    IF NOT QBConfirmingBankAccounts.INSERT THEN;
                END;
            END;


        }
        field(7207287; "Factoring Line"; Code[10])
        {
            TableRelation = "QB Factoring Lines";


            CaptionML = ESP = 'L�nea de Factoring asociada';
            Description = 'QB 1.06.15 - JAV 23/09/20 : - L�nea de Factoring  asociada a la cuenta bancaria';

            trigger OnValidate();
            VAR
                //                                                                 QBFactoringBankAccount@1100286000 :
                QBFactoringBankAccount: Record 7206949;
            BEGIN
                //Si antes ten�a una l�nea y ahora se ha puesto otra, elimino la anterior
                IF (xRec."Factoring Line" <> '') AND ("Factoring Line" <> xRec."Factoring Line") THEN BEGIN
                    IF QBFactoringBankAccount.GET(xRec."Factoring Line", COMPANYNAME, "No.") THEN BEGIN
                        QBFactoringBankAccount.SetAmountUsed;
                        IF (QBFactoringBankAccount."Amount Disposed" <> 0) THEN
                            ERROR(txtQB001);
                        QBFactoringBankAccount.DELETE;
                    END;
                END;

                //Si ahora tiene una l�nea y ha cambiado, creo la nueva
                IF ("Factoring Line" <> '') AND ("Factoring Line" <> xRec."Factoring Line") THEN BEGIN
                    QBFactoringBankAccount.INIT;
                    QBFactoringBankAccount."Factoring Line" := "Factoring Line";
                    QBFactoringBankAccount.Company := COMPANYNAME;
                    QBFactoringBankAccount."Bank Account" := "No.";
                    QBFactoringBankAccount.Description := DELCHR(Name + ' ' + "Name 2", '<>', ' ');
                    IF NOT QBFactoringBankAccount.INSERT THEN;
                END;
            END;


        }
        field(7207288; "Electronic Report"; Integer)
        {
            TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = CONST("Report"));


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Formato de Confirming';
            Description = 'QB 1.08.05 - JAV 25/01/21 Que formato de configming usar';

            trigger OnValidate();
            BEGIN
                //JAV 15/09/21: - QB 1.09.17 Nueva forma de obtener el n�mero del formato de confirming
                IF ("Electronic Report" <> 0) AND (NOT GenerateElectronicsPayments.ValidateNumber("Electronic Report")) THEN
                    ERROR('Formato no v�lido');
            END;

            trigger OnLookup();
            VAR
                //                                                               QBReportSelections@1100286000 :
                QBReportSelections: Record 7206901;
            BEGIN
                //JAV 15/09/21: - QB 1.09.17 Nueva forma de obtener el n�mero del formato de confirming
                "Electronic Report" := STRMENU(GenerateElectronicsPayments.GetMenuTxt, "Electronic Report", 'Seleccione formato');

                //"Electronic Report" := QBReportSelections.GetReportSelected(QBReportSelections.Usage::G1);
            END;


        }
        field(7207299; "Imp Use"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Usar impresi�n matricial';
            Description = 'QB 1.01 - JAV 28/04/20 Impresi�n de cheques en matricial, Si se utiliza este formato';


        }
        field(7207300; "Imp Lineas"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'N� lineas del pagar�';
            Description = 'QB 1.01 - JAV 28/04/20 Impresi�n de cheques en matricial, nro de l�neas de altura';


        }
        field(7207301; "Imp Importe Lin"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Importe, l�nea';
            Description = 'QB 1.01 - JAV 28/04/20 Impresi�n de cheques en matricial';


        }
        field(7207302; "Imp Importe Col"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Importe, columna';
            Description = 'QB 1.01 - JAV 28/04/20 Impresi�n de cheques en matricial';


        }
        field(7207303; "Imp Importe Lon"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Importe, longiitud';
            Description = 'QB 1.01 - JAV 28/04/20 Impresi�n de cheques en matricial';


        }
        field(7207304; "Imp Letras1 Lin"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Importe texto 1, linea';
            Description = 'QB 1.01 - JAV 28/04/20 Impresi�n de cheques en matricial';


        }
        field(7207305; "Imp Letras1 Col"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Importe texto 1, columna';
            Description = 'QB 1.01 - JAV 28/04/20 Impresi�n de cheques en matricial';


        }
        field(7207306; "Imp Letras1 Lon"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Importe texto 1, longitud';
            Description = 'QB 1.01 - JAV 28/04/20 Impresi�n de cheques en matricial';


        }
        field(7207307; "Imp Letras2 Lin"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Importe texto 2, linea';
            Description = 'QB 1.01 - JAV 28/04/20 Impresi�n de cheques en matricial';


        }
        field(7207308; "Imp Letras2 Col"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Importe texto 2, columna';
            Description = 'QB 1.01 - JAV 28/04/20 Impresi�n de cheques en matricial';


        }
        field(7207309; "Imp Letras2 Lon"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Importe texto 2, longitud';
            Description = 'QB 1.01 - JAV 28/04/20 Impresi�n de cheques en matricial';


        }
        field(7207310; "Imp Destinatario Lin"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Destinatario, linea';
            Description = 'QB 1.01 - JAV 28/04/20 Impresi�n de cheques en matricial';


        }
        field(7207311; "Imp Destinatario Col"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Destinatario Columna';
            Description = 'QB 1.01 - JAV 28/04/20 Impresi�n de cheques en matricial';


        }
        field(7207312; "Imp Destinatario Lon"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Destinatario Longitud';
            Description = 'QB 1.01 - JAV 28/04/20 Impresi�n de cheques en matricial';


        }
        field(7207313; "Imp Firma Lin"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Firma Linea';
            Description = 'QB 1.01 - JAV 28/04/20 Impresi�n de cheques en matricial';


        }
        field(7207314; "Imp Firma Lugar Col"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Firma, lugar Columna';
            Description = 'QB 1.01 - JAV 28/04/20 Impresi�n de cheques en matricial';


        }
        field(7207315; "Imp Firma Lugar Lon"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Firma, Lugar Longitud';
            Description = 'QB 1.01 - JAV 28/04/20 Impresi�n de cheques en matricial';


        }
        field(7207316; "Imp Firma Dia Col"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Firma Dia Columna';
            Description = 'QB 1.01 - JAV 28/04/20 Impresi�n de cheques en matricial';


        }
        field(7207317; "Imp Firma Mes Col"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Imp Firma Mes Columna';
            Description = 'QB 1.01 - JAV 28/04/20 Impresi�n de cheques en matricial';


        }
        field(7207318; "Imp Firma AÂ¤o Col"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Imp Firma A�o Columna';
            Description = 'QB 1.01 - JAV 28/04/20 Impresi�n de cheques en matricial';


        }
        field(7207319; "Imp Vto Lin"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Fecha Vto L�nea';
            Description = 'QB 1.01 - JAV 28/04/20 Impresi�n de cheques en matricial';


        }
        field(7207320; "Imp Vto Dia Col"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Fecha Vto, dia Columna';
            Description = 'QB 1.01 - JAV 28/04/20 Impresi�n de cheques en matricial';


        }
        field(7207321; "Imp Vto Mes Col"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Fecha Vto, mes Columna';
            Description = 'QB 1.01 - JAV 28/04/20 Impresi�n de cheques en matricial';


        }
        field(7207322; "Imp Vto AÂ¤o Col"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Fecha Vto, a�o Columna';
            Description = 'QB 1.01 - JAV 28/04/20 Impresi�n de cheques en matricial';


        }
        field(7207323; "Imp Impresora"; Text[250])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Impresora';
            Description = 'QB 1.01 - JAV 28/04/20 Impresi�n de cheques en matricial';


        }
        field(7207330; "Rep2 Check Report ID"; Integer)
        {
            TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = CONST("Report"));


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Check Report ID', ESP = 'N� informe cheque/pagar�';
            Description = 'QB 1.06.02 - JAV 19/07/20 Para numerar los cheques/pagar�s en varios formatos';

            trigger OnValidate();
            BEGIN
                CALCFIELDS("Rep2 Check Report Name");
            END;


        }
        field(7207331; "Rep2 Check Report Name"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("AllObjWithCaption"."Object Name" WHERE("Object Type" = CONST("Report"),
                                                                                                             "Object ID" = FIELD("Rep2 Check Report ID")));
            CaptionML = ENU = 'Check Report Name', ESP = 'Nombre informe';
            Description = 'QB 1.06.02 - JAV 19/07/20 Para numerar los cheques/pagar�s en varios formatos';
            Editable = false;


        }
        field(7207332; "Rep2 Last Check No."; Code[20])
        {
            AccessByPermission = TableData 272 = R;
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Last Check No.', ESP = '�lt. n� cheque/pagar�';
            Description = 'QB 1.06.02 - JAV 19/07/20 Para numerar los cheques/pagar�s en varios formatos';


        }
        field(7207333; "Rep2 Maximo  No. Cheque"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Ult. n� pagar�', ESP = 'M�ximo  n� cheque/pagar�';
            Description = 'QB 1.06.02 - JAV 19/07/20 Para numerar los cheques/pagar�s en varios formatos';


        }
        field(7207334; "Rep3 Check Report ID"; Integer)
        {
            TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = CONST("Report"));


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Check Report ID', ESP = 'N� informe cheque/pagar�';
            Description = 'QB 1.06.02 - JAV 19/07/20 Para numerar los cheques/pagar�s en varios formatos';

            trigger OnValidate();
            BEGIN
                CALCFIELDS("Rep3 Check Report Name");
            END;


        }
        field(7207335; "Rep3 Check Report Name"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("AllObjWithCaption"."Object Name" WHERE("Object Type" = CONST("Report"),
                                                                                                             "Object ID" = FIELD("Rep3 Check Report ID")));
            CaptionML = ENU = 'Check Report Name', ESP = 'Nombre informe';
            Description = 'QB 1.06.02 - JAV 19/07/20 Para numerar los cheques/pagar�s en varios formatos';
            Editable = false;


        }
        field(7207336; "Rep3 Last Check No."; Code[20])
        {
            AccessByPermission = TableData 272 = R;
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Last Check No.', ESP = '�lt. n� cheque/pagar�';
            Description = 'QB 1.06.02 - JAV 19/07/20 Para numerar los cheques/pagar�s en varios formatos';


        }
        field(7207337; "Rep3 Maximo  No. Cheque"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Ult. n� pagar�', ESP = 'M�ximo  n� cheque/pagar�';
            Description = 'QB 1.06.02 - JAV 19/07/20 Para numerar los cheques/pagar�s en varios formatos';


        }
        field(7207338; "Rep4 Check Report ID"; Integer)
        {
            TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = CONST("Report"));


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Check Report ID', ESP = 'N� informe cheque/pagar�';
            Description = 'QB 1.06.02 - JAV 19/07/20 Para numerar los cheques/pagar�s en varios formatos';

            trigger OnValidate();
            BEGIN
                CALCFIELDS("Rep4 Check Report Name");
            END;


        }
        field(7207339; "Rep4 Check Report Name"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("AllObjWithCaption"."Object Name" WHERE("Object Type" = CONST("Report"),
                                                                                                             "Object ID" = FIELD("Rep4 Check Report ID")));
            CaptionML = ENU = 'Check Report Name', ESP = 'Nombre informe';
            Description = 'QB 1.06.02 - JAV 19/07/20 Para numerar los cheques/pagar�s en varios formatos';
            Editable = false;


        }
        field(7207340; "Rep4 Last Check No."; Code[20])
        {
            AccessByPermission = TableData 272 = R;
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Last Check No.', ESP = '�lt. n� cheque/pagar�';
            Description = 'QB 1.06.02 - JAV 19/07/20 Para numerar los cheques/pagar�s en varios formatos';


        }
        field(7207341; "Rep4 Maximo  No. Cheque"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Ult. n� pagar�', ESP = 'M�ximo  n� cheque/pagar�';
            Description = 'QB 1.06.02 - JAV 19/07/20 Para numerar los cheques/pagar�s en varios formatos';


        }
    }
    keys
    {
        // key(key1;"No.")
        //  {
        /* Clustered=true;
  */
        // }
        // key(key2;"Search Name")
        //  {
        /* ;
  */
        // }
        // key(key3;"Bank Acc. Posting Group")
        //  {
        /* ;
  */
        // }
        // key(key4;"Currency Code")
        //  {
        /* ;
  */
        // }
    }
    fieldgroups
    {
        // fieldgroup(DropDown;"No.","Name","Bank Account No.","Currency Code")
        // {
        // 
        // }
        // fieldgroup(Brick;"No.","Name","Bank Account No.","Currency Code","Image")
        // {
        // 
        // }
    }

    var
        //       Text000@1000 :
        Text000: TextConst ENU = 'You cannot change %1 because there are one or more open ledger entries for this bank account.', ESP = 'No se puede cambiar el banco %1 porque tiene movimientos pendientes.';
        //       Text003@1003 :
        Text003: TextConst ENU = 'Do you wish to create a contact for %1 %2?', ESP = '�Confirma que desea crear un contacto para %1 %2?';
        //       GLSetup@1004 :
        GLSetup: Record 98;
        //       BankAcc@1005 :
        BankAcc: Record 270;
        //       BankAccLedgEntry@1006 :
        BankAccLedgEntry: Record 271;
        //       CommentLine@1007 :
        CommentLine: Record 97;
        //       PostCode@1008 :
        PostCode: Record 225;
        //       CarteraSetup@1100006 :
        CarteraSetup: Record 7000016;
        //       PostedBillGr@1100004 :
        PostedBillGr: Record 7000006;
        //       ClosedBillGr@1100003 :
        ClosedBillGr: Record 7000007;
        //       PostedPmtOrd@1100002 :
        PostedPmtOrd: Record 7000021;
        //       ClosedPmtOrd@1100001 :
        ClosedPmtOrd: Record 7000022;
        //       Suffix@1100000 :
        Suffix: Record 7000024;
        //       NoSeriesMgt@1009 :
        NoSeriesMgt: Codeunit 396;
        //       MoveEntries@1010 :
        MoveEntries: Codeunit 361;
        //       UpdateContFromBank@1011 :
        UpdateContFromBank: Codeunit 5058;
        //       DimMgt@1012 :
        DimMgt: Codeunit 408;
        //       GenerateElectronicsPayments@1100286003 :
        GenerateElectronicsPayments: Codeunit 7206908;
        //       InsertFromContact@1013 :
        InsertFromContact: Boolean;
        //       Text004@1014 :
        Text004: TextConst ENU = 'Before you can use Online Map, you must fill in the Online Map Setup window.\See Setting Up Online Map in Help.', ESP = 'Para poder usar Online Map, primero debe rellenar la ventana Configuraci�n Online Map.\Consulte Configuraci�n de Online Map en la Ayuda.';
        //       Text1100000@1100007 :
        Text1100000: TextConst ENU = 'You cannot change %1 because there are one or more posted bill groups for this bank account.', ESP = 'No se puede cambiar el banco %1 porque tiene remesas registradas.';
        //       Text1100001@1100008 :
        Text1100001: TextConst ENU = 'You cannot change %1 because there are one or more posted payment orders for this bank account.', ESP = 'No se puede cambiar el banco %1 porque tiene �rdenes pago registradas.';
        //       BankAccIdentifierIsEmptyErr@1001 :
        BankAccIdentifierIsEmptyErr: TextConst ENU = 'You must specify either a %1 or an %2.', ESP = 'Debe especificar %1 o %2.';
        //       InvalidPercentageValueErr@1002 :
        InvalidPercentageValueErr:
// %1 is "field caption and %2 is "Percentage"
TextConst ENU = 'if %1 is %2, then the value must be between 0 and 99.', ESP = 'Si %1 es %2, entonces el valor debe ser entre 0 y 99.';
        //       InvalidValueErr@1015 :
        InvalidValueErr: TextConst ENU = 'The value must be positive.', ESP = 'El valor debe ser positivo.';
        //       DataExchNotSetErr@1016 :
        DataExchNotSetErr: TextConst ENU = 'The Data Exchange Code field must be filled.', ESP = 'Debe completarse el campo C�digo de intercambio de datos.';
        //       BankStmtScheduledDownloadDescTxt@1018 :
        BankStmtScheduledDownloadDescTxt:
// %1 - Bank Account name
TextConst ENU = '%1 Bank Statement Import', ESP = 'Importaci�n extracto bancario %1';
        //       JobQEntriesCreatedQst@1019 :
        JobQEntriesCreatedQst: TextConst ENU = 'A job queue entry for import of bank statements has been created.\\Do you want to open the Job Queue Entry window?', ESP = 'Se cre� un movimiento de la cola de proyectos para la importaci�n de extractos bancarios.\\�Quiere abrir la ventana Mov. cola proyecto?';
        //       TransactionImportTimespanMustBePositiveErr@1020 :
        TransactionImportTimespanMustBePositiveErr: TextConst ENU = 'The value in the Number of Days Included field must be a positive number not greater than 9999.', ESP = 'El valor del campo N�mero de d�as incluidos debe ser un n�mero positivo menor que 9999.';
        //       MFANotSupportedErr@1021 :
        MFANotSupportedErr: TextConst ENU = 'Cannot setup automatic bank statement import because the selected bank requires multi-factor authentication.', ESP = 'No se puede configurar la importaci�n autom�tica de extractos bancarios porque el banco seleccionado requiere la autenticaci�n multifactor.';
        //       BankAccNotLinkedErr@1023 :
        BankAccNotLinkedErr: TextConst ENU = 'This bank account is not linked to an online bank account.', ESP = 'Este banco no est� vinculado a un banco en l�nea.';
        //       AutoLogonNotPossibleErr@1024 :
        AutoLogonNotPossibleErr: TextConst ENU = 'Automatic logon is not possible for this bank account.', ESP = 'El inicio de sesi�n autom�tico no es posible para este banco.';
        //       CancelTxt@1017 :
        CancelTxt: TextConst ENU = 'Cancel', ESP = 'Cancelar';
        //       OnlineFeedStatementStatus@1022 :
        OnlineFeedStatementStatus: Option "not Linked","Linked","Linked and Auto. Bank Statement Enabled";
        //       "------------------------ QB"@1100286000 :
        "------------------------ QB": TextConst;
        //       txtQB000@1100286001 :
        txtQB000: TextConst ESP = 'Tiene riesgo pendiente del banco en esa l�nea de Confirming, no lo puede sacar de la l�nea';
        //       txtQB001@1100286002 :
        txtQB001: TextConst ESP = 'Tiene riesgo pendiente del banco en esa l�nea de Factoring, no lo puede sacar de la l�nea';





    /*
    trigger OnInsert();    begin
                   if "No." = '' then begin
                     GLSetup.GET;
                     GLSetup.TESTFIELD("Bank Account Nos.");
                     NoSeriesMgt.InitSeries(GLSetup."Bank Account Nos.",xRec."No. Series",0D,"No.","No. Series");
                     "Operation Fees Code" := "No.";
                     "Customer Ratings Code" := "No.";
                   end;

                   if not InsertFromContact then
                     UpdateContFromBank.OnInsert(Rec);

                   DimMgt.UpdateDefaultDim(
                     DATABASE::"Bank Account","No.",
                     "Global Dimension 1 Code","Global Dimension 2 Code");
                 end;


    */

    /*
    trigger OnModify();    begin
                   "Last Date Modified" := TODAY;

                   if IsContactUpdateNeeded then begin
                     MODIFY;
                     UpdateContFromBank.OnModify(Rec);
                     if not FIND then begin
                       RESET;
                       if FIND then;
                     end;
                   end;
                 end;


    */

    /*
    trigger OnDelete();    var
    //                DocumentMove@1100000 :
                   DocumentMove: Codeunit 7000004;
                 begin
                   MoveEntries.MoveBankAccEntries(Rec);
                   DocumentMove.MoveBankAccDocs(Rec);

                   CommentLine.SETRANGE("Table Name",CommentLine."Table Name"::"Bank Account");
                   CommentLine.SETRANGE("No.","No.");
                   CommentLine.DELETEALL;

                   if CarteraSetup.READPERMISSION then begin
                     Suffix.SETRANGE("Bank Acc. Code","No.");
                     Suffix.DELETEALL;
                   end;

                   UpdateContFromBank.OnDelete(Rec);

                   DimMgt.DeleteDefaultDim(DATABASE::"Bank Account","No.");
                 end;


    */

    /*
    trigger OnRename();    begin
                   DimMgt.RenameDefaultDim(DATABASE::"Bank Account",xRec."No.","No.");
                   "Last Date Modified" := TODAY;
                 end;

    */



    // procedure AssistEdit (OldBankAcc@1000 :

    /*
    procedure AssistEdit (OldBankAcc: Record 270) : Boolean;
        begin
          WITH BankAcc DO begin
            BankAcc := Rec;
            GLSetup.GET;
            GLSetup.TESTFIELD("Bank Account Nos.");
            if NoSeriesMgt.SelectSeries(GLSetup."Bank Account Nos.",OldBankAcc."No. Series","No. Series") then begin
              GLSetup.GET;
              GLSetup.TESTFIELD("Bank Account Nos.");
              NoSeriesMgt.SetSeries("No.");
              Rec := BankAcc;
              exit(TRUE);
            end;
          end;
        end;
    */



    //     procedure ValidateShortcutDimCode (FieldNumber@1000 : Integer;var ShortcutDimCode@1001 :

    /*
    procedure ValidateShortcutDimCode (FieldNumber: Integer;var ShortcutDimCode: Code[20])
        begin
          DimMgt.ValidateDimValueCode(FieldNumber,ShortcutDimCode);
          DimMgt.SaveDefaultDim(DATABASE::"Bank Account","No.",FieldNumber,ShortcutDimCode);
          MODIFY;
        end;
    */




    /*
    procedure ShowContact ()
        var
    //       ContBusRel@1000 :
          ContBusRel: Record 5054;
    //       Cont@1001 :
          Cont: Record 5050;
        begin
          if "No." = '' then
            exit;

          ContBusRel.SETCURRENTKEY("Link to Table","No.");
          ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::"Bank Account");
          ContBusRel.SETRANGE("No.","No.");
          if not ContBusRel.FINDFIRST then begin
            if not CONFIRM(Text003,FALSE,TABLECAPTION,"No.") then
              exit;
            UpdateContFromBank.InsertNewContact(Rec,FALSE);
            ContBusRel.FINDFIRST;
          end;
          COMMIT;

          Cont.FILTERGROUP(2);
          Cont.SETCURRENTKEY("Company Name","Company No.",Type,Name);
          Cont.SETRANGE("Company No.",ContBusRel."Contact No.");
          PAGE.RUN(PAGE::"Contact List",Cont);
        end;
    */



    //     procedure SetInsertFromContact (FromContact@1000 :

    /*
    procedure SetInsertFromContact (FromContact: Boolean)
        begin
          InsertFromContact := FromContact;
        end;
    */




    /*
    procedure GetPaymentExportCodeunitID () : Integer;
        var
    //       BankExportImportSetup@1000 :
          BankExportImportSetup: Record 1200;
        begin
          GetBankExportImportSetup(BankExportImportSetup);
          exit(BankExportImportSetup."Processing Codeunit ID");
        end;
    */




    /*
    procedure GetPaymentExportXMLPortID () : Integer;
        var
    //       BankExportImportSetup@1000 :
          BankExportImportSetup: Record 1200;
        begin
          GetBankExportImportSetup(BankExportImportSetup);
          BankExportImportSetup.TESTFIELD("Processing XMLport ID");
          exit(BankExportImportSetup."Processing XMLport ID");
        end;
    */




    /*
    procedure GetDDExportCodeunitID () : Integer;
        var
    //       BankExportImportSetup@1000 :
          BankExportImportSetup: Record 1200;
        begin
          GetDDExportImportSetup(BankExportImportSetup);
          BankExportImportSetup.TESTFIELD("Processing Codeunit ID");
          exit(BankExportImportSetup."Processing Codeunit ID");
        end;
    */




    /*
    procedure GetDDExportXMLPortID () : Integer;
        var
    //       BankExportImportSetup@1000 :
          BankExportImportSetup: Record 1200;
        begin
          GetDDExportImportSetup(BankExportImportSetup);
          BankExportImportSetup.TESTFIELD("Processing XMLport ID");
          exit(BankExportImportSetup."Processing XMLport ID");
        end;
    */



    //     procedure GetBankExportImportSetup (var BankExportImportSetup@1001 :

    /*
    procedure GetBankExportImportSetup (var BankExportImportSetup: Record 1200)
        begin
          TESTFIELD("Payment Export Format");
          BankExportImportSetup.GET("Payment Export Format");
        end;
    */



    //     procedure GetDDExportImportSetup (var BankExportImportSetup@1001 :

    /*
    procedure GetDDExportImportSetup (var BankExportImportSetup: Record 1200)
        begin
          TESTFIELD("SEPA Direct Debit Exp. Format");
          BankExportImportSetup.GET("SEPA Direct Debit Exp. Format");
        end;
    */




    /*
    procedure GetCreditTransferMessageNo () : Code[20];
        var
    //       NoSeriesManagement@1000 :
          NoSeriesManagement: Codeunit 396;
        begin
          TESTFIELD("Credit Transfer Msg. Nos.");
          exit(NoSeriesManagement.GetNextNo("Credit Transfer Msg. Nos.",TODAY,TRUE));
        end;
    */




    /*
    procedure GetDirectDebitMessageNo () : Code[20];
        var
    //       NoSeriesManagement@1000 :
          NoSeriesManagement: Codeunit 396;
        begin
          TESTFIELD("Direct Debit Msg. Nos.");
          exit(NoSeriesManagement.GetNextNo("Direct Debit Msg. Nos.",TODAY,TRUE));
        end;
    */




    /*
    procedure DisplayMap ()
        var
    //       MapPoint@1001 :
          MapPoint: Record 800;
    //       MapMgt@1000 :
          MapMgt: Codeunit 802;
        begin
          if MapPoint.FINDFIRST then
            MapMgt.MakeSelection(DATABASE::"Bank Account",GETPOSITION)
          else
            MESSAGE(Text004);
        end;
    */



    /*
    procedure BuildCCC ()
        begin
          "CCC No." := "CCC Bank No." + "CCC Bank Branch No." + "CCC Control Digits" + "CCC Bank Account No.";
          if "CCC No." <> '' then
            TESTFIELD("Bank Account No.",'');
        end;
    */


    //     procedure PrePadString (InString@1000 : Text[250];MaxLen@1001 :

    /*
    procedure PrePadString (InString: Text[250];MaxLen: Integer) : Text[250];
        begin
          exit(PADSTR('', MaxLen - STRLEN(InString),'0') + InString);
        end;
    */


    //     procedure DiscInterestsTotalAmt (PostDateFilter@1100000 :

    /*
    procedure DiscInterestsTotalAmt (PostDateFilter: Code[250]) : Decimal;
        begin
          if CarteraSetup.READPERMISSION then begin
            PostedBillGr.SETCURRENTKEY("Bank Account No.","Posting Date");
            PostedBillGr.SETRANGE("Bank Account No.","No.");
            PostedBillGr.SETFILTER("Posting Date",PostDateFilter);
            PostedBillGr.CALCSUMS("Discount Interests Amt.");
            ClosedBillGr.SETCURRENTKEY("Bank Account No.","Posting Date");
            ClosedBillGr.SETRANGE("Bank Account No.","No.");
            ClosedBillGr.SETFILTER("Posting Date",PostDateFilter);
            ClosedBillGr.CALCSUMS("Discount Interests Amt.");
            exit(PostedBillGr."Discount Interests Amt." + ClosedBillGr."Discount Interests Amt.");
          end;
        end;
    */


    //     procedure ServicesFeesTotalAmt (PostDateFilter@1100000 :

    /*
    procedure ServicesFeesTotalAmt (PostDateFilter: Code[250]) : Decimal;
        begin
          if CarteraSetup.READPERMISSION then begin
            PostedBillGr.SETCURRENTKEY("Bank Account No.","Posting Date");
            PostedBillGr.SETRANGE("Bank Account No.","No.");
            PostedBillGr.SETFILTER("Posting Date",PostDateFilter);
            PostedBillGr.CALCSUMS("Discount Expenses Amt.");
            ClosedBillGr.SETCURRENTKEY("Bank Account No.","Posting Date");
            ClosedBillGr.SETRANGE("Bank Account No.","No.");
            ClosedBillGr.SETFILTER("Posting Date",PostDateFilter);
            ClosedBillGr.CALCSUMS("Discount Expenses Amt.");
            exit(PostedBillGr."Discount Expenses Amt." + ClosedBillGr."Discount Expenses Amt.");
          end;
        end;
    */


    //     procedure CollectionFeesTotalAmt (PostDateFilter@1100000 :

    /*
    procedure CollectionFeesTotalAmt (PostDateFilter: Code[250]) : Decimal;
        begin
          if CarteraSetup.READPERMISSION then begin
            PostedBillGr.SETCURRENTKEY("Bank Account No.","Posting Date");
            PostedBillGr.SETRANGE("Bank Account No.","No.");
            PostedBillGr.SETFILTER("Posting Date",PostDateFilter);
            PostedBillGr.CALCSUMS("Collection Expenses Amt.");
            ClosedBillGr.SETCURRENTKEY("Bank Account No.","Posting Date");
            ClosedBillGr.SETRANGE("Bank Account No.","No.");
            ClosedBillGr.SETFILTER("Posting Date",PostDateFilter);
            ClosedBillGr.CALCSUMS("Collection Expenses Amt.");
            exit(PostedBillGr."Collection Expenses Amt." + ClosedBillGr."Collection Expenses Amt.");
          end;
        end;
    */


    //     procedure RejExpensesAmt (PostDateFilter@1100000 :

    /*
    procedure RejExpensesAmt (PostDateFilter: Code[250]) : Decimal;
        begin
          if CarteraSetup.READPERMISSION then begin
            PostedBillGr.SETCURRENTKEY("Bank Account No.","Posting Date");
            PostedBillGr.SETRANGE("Bank Account No.","No.");
            PostedBillGr.SETFILTER("Posting Date",PostDateFilter);
            PostedBillGr.CALCSUMS("Rejection Expenses Amt.");
            ClosedBillGr.SETCURRENTKEY("Bank Account No.","Posting Date");
            ClosedBillGr.SETRANGE("Bank Account No.","No.");
            ClosedBillGr.SETFILTER("Posting Date",PostDateFilter);
            ClosedBillGr.CALCSUMS("Rejection Expenses Amt.");
            exit(PostedBillGr."Rejection Expenses Amt." + ClosedBillGr."Rejection Expenses Amt.");
          end;
        end;
    */


    //     procedure RiskFactFeesTotalAmt (PostDateFilter@1100000 :

    /*
    procedure RiskFactFeesTotalAmt (PostDateFilter: Code[250]) : Decimal;
        begin
          if CarteraSetup.READPERMISSION then begin
            PostedBillGr.SETCURRENTKEY("Bank Account No.","Posting Date",Factoring);
            PostedBillGr.SETRANGE("Bank Account No.","No.");
            PostedBillGr.SETFILTER("Posting Date",PostDateFilter);
            PostedBillGr.CALCSUMS("Risked Factoring Exp. Amt.");
            ClosedBillGr.SETCURRENTKEY("Bank Account No.","Posting Date",Factoring);
            ClosedBillGr.SETRANGE("Bank Account No.","No.");
            ClosedBillGr.SETFILTER("Posting Date",PostDateFilter);
            ClosedBillGr.CALCSUMS("Risked Factoring Exp. Amt.");
            exit(PostedBillGr."Risked Factoring Exp. Amt." + ClosedBillGr."Risked Factoring Exp. Amt.");
          end;
        end;
    */


    //     procedure UnriskFactFeesTotalAmt (PostDateFilter@1100000 :

    /*
    procedure UnriskFactFeesTotalAmt (PostDateFilter: Code[250]) : Decimal;
        begin
          if CarteraSetup.READPERMISSION then begin
            PostedBillGr.SETCURRENTKEY("Bank Account No.","Posting Date",Factoring);
            PostedBillGr.SETRANGE("Bank Account No.","No.");
            PostedBillGr.SETFILTER("Posting Date",PostDateFilter);
            PostedBillGr.CALCSUMS("Collection Expenses Amt.");
            ClosedBillGr.SETCURRENTKEY("Bank Account No.","Posting Date",Factoring);
            ClosedBillGr.SETRANGE("Bank Account No.","No.");
            ClosedBillGr.SETFILTER("Posting Date",PostDateFilter);
            ClosedBillGr.CALCSUMS("Unrisked Factoring Exp. Amt.");
            exit(PostedBillGr."Unrisked Factoring Exp. Amt." + ClosedBillGr."Unrisked Factoring Exp. Amt.");
          end;
        end;
    */


    //     procedure DiscInterestFactTotalAmt (PostDateFilter@1100000 :

    /*
    procedure DiscInterestFactTotalAmt (PostDateFilter: Code[250]) : Decimal;
        begin
          if CarteraSetup.READPERMISSION then begin
            PostedBillGr.SETCURRENTKEY("Bank Account No.","Posting Date",Factoring);
            PostedBillGr.SETRANGE("Bank Account No.","No.");
            PostedBillGr.SETFILTER(Factoring,'<>%1',PostedBillGr.Factoring::" ");
            PostedBillGr.SETFILTER("Posting Date",PostDateFilter);
            PostedBillGr.CALCSUMS("Discount Interests Amt.");
            ClosedBillGr.SETCURRENTKEY("Bank Account No.","Posting Date",Factoring);
            ClosedBillGr.SETRANGE("Bank Account No.","No.");
            ClosedBillGr.SETFILTER(Factoring,'<>%1',ClosedBillGr.Factoring::" ");
            ClosedBillGr.SETFILTER("Posting Date",PostDateFilter);
            ClosedBillGr.CALCSUMS("Discount Interests Amt.");
            PostedBillGr.SETRANGE(Factoring);
            ClosedBillGr.SETRANGE(Factoring);
            exit(PostedBillGr."Discount Interests Amt." + ClosedBillGr."Discount Interests Amt.");
          end;
        end;
    */


    //     procedure PaymentOrderFeesTotalAmt (PostDateFilter@1100000 :

    /*
    procedure PaymentOrderFeesTotalAmt (PostDateFilter: Code[250]) : Decimal;
        begin
          if CarteraSetup.READPERMISSION then begin
            PostedPmtOrd.SETCURRENTKEY("Bank Account No.","Posting Date");
            PostedPmtOrd.SETRANGE("Bank Account No.","No.");
            PostedPmtOrd.SETFILTER("Posting Date",PostDateFilter);
            PostedPmtOrd.CALCSUMS("Payment Order Expenses Amt.");
            ClosedPmtOrd.SETCURRENTKEY("Bank Account No.","Posting Date");
            ClosedPmtOrd.SETRANGE("Bank Account No.","No.");
            ClosedPmtOrd.SETFILTER("Posting Date",PostDateFilter);
            ClosedPmtOrd.CALCSUMS("Payment Order Expenses Amt.");
            exit(PostedPmtOrd."Payment Order Expenses Amt." + ClosedPmtOrd."Payment Order Expenses Amt.");
          end;
        end;
    */



    //     procedure GetDataExchDef (var DataExchDef@1000 :

    /*
    procedure GetDataExchDef (var DataExchDef: Record 1222)
        var
    //       BankExportImportSetup@1001 :
          BankExportImportSetup: Record 1200;
    //       DataExchDefCodeResponse@1002 :
          DataExchDefCodeResponse: Code[20];
    //       Handled@1003 :
          Handled: Boolean;
        begin
          OnGetDataExchangeDefinitionEvent(DataExchDefCodeResponse,Handled);
          if not Handled then begin
            TESTFIELD("Bank Statement Import Format");
            DataExchDefCodeResponse := "Bank Statement Import Format";
          end;

          if DataExchDefCodeResponse = '' then
            ERROR(DataExchNotSetErr);

          BankExportImportSetup.GET(DataExchDefCodeResponse);
          BankExportImportSetup.TESTFIELD("Data Exch. Def. Code");

          DataExchDef.GET(BankExportImportSetup."Data Exch. Def. Code");
          DataExchDef.TESTFIELD(Type,DataExchDef.Type::"Bank Statement Import");
        end;
    */



    //     procedure GetDataExchDefPaymentExport (var DataExchDef@1000 :

    /*
    procedure GetDataExchDefPaymentExport (var DataExchDef: Record 1222)
        var
    //       BankExportImportSetup@1001 :
          BankExportImportSetup: Record 1200;
        begin
          TESTFIELD("Payment Export Format");
          BankExportImportSetup.GET("Payment Export Format");
          BankExportImportSetup.TESTFIELD("Data Exch. Def. Code");
          DataExchDef.GET(BankExportImportSetup."Data Exch. Def. Code");
          DataExchDef.TESTFIELD(Type,DataExchDef.Type::"Payment Export");
        end;
    */




    /*
    procedure GetBankAccountNoWithCheck () AccountNo : Text;
        begin
          AccountNo := GetBankAccountNo;
          if AccountNo = '' then
            ERROR(BankAccIdentifierIsEmptyErr,FIELDCAPTION("Bank Account No."),FIELDCAPTION(IBAN));
        end;
    */




    /*
    procedure GetBankAccountNo () : Text;
        begin
          if IBAN <> '' then
            exit(DELCHR(IBAN,'=<>'));

          if "Bank Account No." <> '' then
            exit("Bank Account No.");
        end;
    */




    /*
    procedure IsInLocalCurrency () : Boolean;
        var
    //       GeneralLedgerSetup@1000 :
          GeneralLedgerSetup: Record 98;
        begin
          if "Currency Code" = '' then
            exit(TRUE);

          GeneralLedgerSetup.GET;
          exit("Currency Code" = GeneralLedgerSetup.GetCurrencyCode(''));
        end;
    */




    /*
    procedure GetPosPayExportCodeunitID () : Integer;
        var
    //       BankExportImportSetup@1000 :
          BankExportImportSetup: Record 1200;
        begin
          TESTFIELD("Positive Pay Export Code");
          BankExportImportSetup.GET("Positive Pay Export Code");
          exit(BankExportImportSetup."Processing Codeunit ID");
        end;
    */




    /*
    procedure IsLinkedToBankStatementServiceProvider () : Boolean;
        var
    //       IsBankAccountLinked@1000 :
          IsBankAccountLinked: Boolean;
        begin
          OnCheckLinkedToStatementProviderEvent(Rec,IsBankAccountLinked);
          exit(IsBankAccountLinked);
        end;
    */




    /*
    procedure StatementProvidersExist () : Boolean;
        var
    //       TempNameValueBuffer@1000 :
          TempNameValueBuffer: Record 823 TEMPORARY;
        begin
          OnGetStatementProvidersEvent(TempNameValueBuffer);
          exit(not TempNameValueBuffer.ISEMPTY);
        end;
    */



    //     procedure LinkStatementProvider (var BankAccount@1001 :

    /*
    procedure LinkStatementProvider (var BankAccount: Record 270)
        var
    //       StatementProvider@1000 :
          StatementProvider: Text;
        begin
          StatementProvider := SelectBankLinkingService;

          if StatementProvider <> '' then
            OnLinkStatementProviderEvent(BankAccount,StatementProvider);
        end;
    */



    //     procedure SimpleLinkStatementProvider (var OnlineBankAccLink@1001 :

    /*
    procedure SimpleLinkStatementProvider (var OnlineBankAccLink: Record 777)
        var
    //       StatementProvider@1000 :
          StatementProvider: Text;
        begin
          StatementProvider := SelectBankLinkingService;

          if StatementProvider <> '' then
            OnSimpleLinkStatementProviderEvent(OnlineBankAccLink,StatementProvider);
        end;
    */




    /*
    procedure UnlinkStatementProvider ()
        var
    //       Handled@1000 :
          Handled: Boolean;
        begin
          OnUnlinkStatementProviderEvent(Rec,Handled);
        end;
    */



    //     procedure RefreshStatementProvider (var BankAccount@1001 :

    /*
    procedure RefreshStatementProvider (var BankAccount: Record 270)
        var
    //       StatementProvider@1000 :
          StatementProvider: Text;
        begin
          StatementProvider := SelectBankLinkingService;

          if StatementProvider <> '' then
            OnRefreshStatementProviderEvent(BankAccount,StatementProvider);
        end;
    */




    /*
    procedure UpdateBankAccountLinking ()
        var
    //       StatementProvider@1000 :
          StatementProvider: Text;
        begin
          StatementProvider := SelectBankLinkingService;

          if StatementProvider <> '' then
            OnUpdateBankAccountLinkingEvent(Rec,StatementProvider);
        end;
    */



    //     procedure GetUnlinkedBankAccounts (var TempUnlinkedBankAccount@1000 :

    /*
    procedure GetUnlinkedBankAccounts (var TempUnlinkedBankAccount: Record 270 TEMPORARY)
        var
    //       BankAccount@1001 :
          BankAccount: Record 270;
        begin
          if BankAccount.FINDSET then
            repeat
              if not BankAccount.IsLinkedToBankStatementServiceProvider then begin
                TempUnlinkedBankAccount := BankAccount;
                TempUnlinkedBankAccount.INSERT;
              end;
            until BankAccount.NEXT = 0;
        end;
    */



    //     procedure GetLinkedBankAccounts (var TempUnlinkedBankAccount@1000 :

    /*
    procedure GetLinkedBankAccounts (var TempUnlinkedBankAccount: Record 270 TEMPORARY)
        var
    //       BankAccount@1001 :
          BankAccount: Record 270;
        begin
          if BankAccount.FINDSET then
            repeat
              if BankAccount.IsLinkedToBankStatementServiceProvider then begin
                TempUnlinkedBankAccount := BankAccount;
                TempUnlinkedBankAccount.INSERT;
              end;
            until BankAccount.NEXT = 0;
        end;
    */



    /*
    LOCAL procedure SelectBankLinkingService () : Text;
        var
    //       TempNameValueBuffer@1002 :
          TempNameValueBuffer: Record 823 TEMPORARY;
    //       OptionStr@1001 :
          OptionStr: Text;
    //       OptionNo@1000 :
          OptionNo: Integer;
        begin
          OnGetStatementProvidersEvent(TempNameValueBuffer);

          if TempNameValueBuffer.ISEMPTY then
            exit(''); // Action should not be visible in this case so should not occur

          if (TempNameValueBuffer.COUNT = 1) or (not GUIALLOWED) then
            exit(TempNameValueBuffer.Name);

          TempNameValueBuffer.FINDSET;
          repeat
            OptionStr += STRSUBSTNO('%1,',TempNameValueBuffer.Value);
          until TempNameValueBuffer.NEXT = 0;
          OptionStr += CancelTxt;

          OptionNo := STRMENU(OptionStr);
          if (OptionNo = 0) or (OptionNo = TempNameValueBuffer.COUNT + 1) then
            exit;

          TempNameValueBuffer.SETRANGE(Value,SELECTSTR(OptionNo,OptionStr));
          TempNameValueBuffer.FINDFIRST;

          exit(TempNameValueBuffer.Name);
        end;
    */




    /*
    procedure IsAutoLogonPossible () : Boolean;
        var
    //       AutoLogonPossible@1000 :
          AutoLogonPossible: Boolean;
        begin
          AutoLogonPossible := TRUE;
          OnCheckAutoLogonPossibleEvent(Rec,AutoLogonPossible);
          exit(AutoLogonPossible)
        end;
    */



    /*
    LOCAL procedure ScheduleBankStatementDownload ()
        var
    //       JobQueueEntry@1002 :
          JobQueueEntry: Record 472;
        begin
          if not IsLinkedToBankStatementServiceProvider then
            ERROR(BankAccNotLinkedErr);
          if not IsAutoLogonPossible then
            ERROR(AutoLogonNotPossibleErr);

          JobQueueEntry.ScheduleRecurrentJobQueueEntry(JobQueueEntry."Object Type to Run"::Codeunit,
            CODEUNIT::"Automatic Import of Bank Stmt.",RECORDID);
          JobQueueEntry."Timeout (sec.)" := 1800;
          JobQueueEntry.Description :=
            COPYSTR(STRSUBSTNO(BankStmtScheduledDownloadDescTxt,Name),1,MAXSTRLEN(JobQueueEntry.Description));
          JobQueueEntry."Notify On Success" := FALSE;
          JobQueueEntry."No. of Minutes between Runs" := 121;
          JobQueueEntry.MODIFY;
          if CONFIRM(JobQEntriesCreatedQst) then
            ShowBankStatementDownloadJobQueueEntry;
        end;
    */



    /*
    LOCAL procedure UnscheduleBankStatementDownload ()
        var
    //       JobQueueEntry@1002 :
          JobQueueEntry: Record 472;
        begin
          SetAutomaticImportJobQueueEntryFilters(JobQueueEntry);
          if not JobQueueEntry.ISEMPTY then
            JobQueueEntry.DELETEALL;
        end;
    */



    //     procedure CreateNewAccount (OnlineBankAccLink@1000 :

    /*
    procedure CreateNewAccount (OnlineBankAccLink: Record 777)
        var
    //       GeneralLedgerSetup@1001 :
          GeneralLedgerSetup: Record 98;
    //       CurrencyCode@1002 :
          CurrencyCode: Code[10];
        begin
          GeneralLedgerSetup.GET;
          INIT;
          VALIDATE("Bank Account No.",OnlineBankAccLink."Bank Account No.");
          VALIDATE(Name,OnlineBankAccLink.Name);
          if OnlineBankAccLink."Currency Code" <> '' then
            CurrencyCode := GeneralLedgerSetup.GetCurrencyCode(OnlineBankAccLink."Currency Code");
          VALIDATE("Currency Code",CurrencyCode);
          VALIDATE(Contact,OnlineBankAccLink.Contact);
        end;
    */



    /*
    LOCAL procedure ShowBankStatementDownloadJobQueueEntry ()
        var
    //       JobQueueEntry@1000 :
          JobQueueEntry: Record 472;
        begin
          SetAutomaticImportJobQueueEntryFilters(JobQueueEntry);
          if JobQueueEntry.FINDFIRST then
            PAGE.RUN(PAGE::"Job Queue Entry Card",JobQueueEntry);
        end;
    */


    //     LOCAL procedure SetAutomaticImportJobQueueEntryFilters (var JobQueueEntry@1000 :

    /*
    LOCAL procedure SetAutomaticImportJobQueueEntryFilters (var JobQueueEntry: Record 472)
        begin
          JobQueueEntry.SETRANGE("Object Type to Run",JobQueueEntry."Object Type to Run"::Codeunit);
          JobQueueEntry.SETRANGE("Object ID to Run",CODEUNIT::"Automatic Import of Bank Stmt.");
          JobQueueEntry.SETRANGE("Record ID to Process",RECORDID);
        end;
    */



    //     procedure GetOnlineFeedStatementStatus (var OnlineFeedStatus@1000 : Option;var Linked@1001 :

    /*
    procedure GetOnlineFeedStatementStatus (var OnlineFeedStatus: Option;var Linked: Boolean)
        begin
          Linked := FALSE;
          OnlineFeedStatus := OnlineFeedStatementStatus::"not Linked";
          if IsLinkedToBankStatementServiceProvider then begin
            Linked := TRUE;
            OnlineFeedStatus := OnlineFeedStatementStatus::Linked;
            if IsScheduledBankStatement then
              OnlineFeedStatus := OnlineFeedStatementStatus::"Linked and Auto. Bank Statement Enabled";
          end;
        end;
    */



    /*
    LOCAL procedure IsScheduledBankStatement () : Boolean;
        var
    //       JobQueueEntry@1000 :
          JobQueueEntry: Record 472;
        begin
          JobQueueEntry.SETRANGE("Record ID to Process",RECORDID);
          exit(JobQueueEntry.FINDFIRST);
        end;
    */




    /*
    procedure DisableStatementProviders ()
        var
    //       TempNameValueBuffer@1000 :
          TempNameValueBuffer: Record 823 TEMPORARY;
        begin
          OnGetStatementProvidersEvent(TempNameValueBuffer);
          if TempNameValueBuffer.FINDSET then
            repeat
              OnDisableStatementProviderEvent(TempNameValueBuffer.Name);
            until TempNameValueBuffer.NEXT = 0;
        end;
    */



    /*
    LOCAL procedure IsContactUpdateNeeded () : Boolean;
        var
    //       BankContUpdate@1001 :
          BankContUpdate: Codeunit 5058;
    //       UpdateNeeded@1000 :
          UpdateNeeded: Boolean;
        begin
          UpdateNeeded :=
            (Name <> xRec.Name) or
            ("Search Name" <> xRec."Search Name") or
            ("Name 2" <> xRec."Name 2") or
            (Address <> xRec.Address) or
            ("Address 2" <> xRec."Address 2") or
            (City <> xRec.City) or
            ("Phone No." <> xRec."Phone No.") or
            ("Telex No." <> xRec."Telex No.") or
            ("Territory Code" <> xRec."Territory Code") or
            ("Currency Code" <> xRec."Currency Code") or
            ("Language Code" <> xRec."Language Code") or
            ("Our Contact Code" <> xRec."Our Contact Code") or
            ("Country/Region Code" <> xRec."Country/Region Code") or
            ("Fax No." <> xRec."Fax No.") or
            ("Telex Answer Back" <> xRec."Telex Answer Back") or
            ("Post Code" <> xRec."Post Code") or
            (County <> xRec.County) or
            ("E-Mail" <> xRec."E-Mail") or
            ("Home Page" <> xRec."Home Page");

          if not UpdateNeeded and not ISTEMPORARY then
            UpdateNeeded := BankContUpdate.ContactNameIsBlank("No.");

          OnAfterIsUpdateNeeded(xRec,Rec,UpdateNeeded);
          exit(UpdateNeeded);
        end;
    */



    //     LOCAL procedure OnAfterIsUpdateNeeded (BankAccount@1000 : Record 270;xBankAccount@1001 : Record 270;var UpdateNeeded@1002 :

    /*
    LOCAL procedure OnAfterIsUpdateNeeded (BankAccount: Record 270;xBankAccount: Record 270;var UpdateNeeded: Boolean)
        begin
        end;
    */



    //     LOCAL procedure OnCheckLinkedToStatementProviderEvent (var BankAccount@1000 : Record 270;var IsLinked@1002 :

    /*
    LOCAL procedure OnCheckLinkedToStatementProviderEvent (var BankAccount: Record 270;var IsLinked: Boolean)
        begin
          // The subscriber of this event should answer whether the bank account is linked to a bank statement provider service
        end;
    */



    //     LOCAL procedure OnCheckAutoLogonPossibleEvent (var BankAccount@1000 : Record 270;var AutoLogonPossible@1001 :

    /*
    LOCAL procedure OnCheckAutoLogonPossibleEvent (var BankAccount: Record 270;var AutoLogonPossible: Boolean)
        begin
          // The subscriber of this event should answer whether the bank account can be logged on to without multi-factor authentication
        end;
    */



    //     LOCAL procedure OnUnlinkStatementProviderEvent (var BankAccount@1000 : Record 270;var Handled@1002 :

    /*
    LOCAL procedure OnUnlinkStatementProviderEvent (var BankAccount: Record 270;var Handled: Boolean)
        begin
          // The subscriber of this event should unlink the bank account from a bank statement provider service
        end;
    */




    //     procedure OnMarkAccountLinkedEvent (var OnlineBankAccLink@1000 : Record 777;var BankAccount@1001 :

    /*
    procedure OnMarkAccountLinkedEvent (var OnlineBankAccLink: Record 777;var BankAccount: Record 270)
        begin
          // The subscriber of this event should Mark the account linked to a bank statement provider service
        end;
    */



    //     LOCAL procedure OnSimpleLinkStatementProviderEvent (var OnlineBankAccLink@1000 : Record 777;var StatementProvider@1002 :

    /*
    LOCAL procedure OnSimpleLinkStatementProviderEvent (var OnlineBankAccLink: Record 777;var StatementProvider: Text)
        begin
          // The subscriber of this event should link the bank account to a bank statement provider service
        end;
    */



    //     LOCAL procedure OnLinkStatementProviderEvent (var BankAccount@1000 : Record 270;var StatementProvider@1002 :

    /*
    LOCAL procedure OnLinkStatementProviderEvent (var BankAccount: Record 270;var StatementProvider: Text)
        begin
          // The subscriber of this event should link the bank account to a bank statement provider service
        end;
    */



    //     LOCAL procedure OnRefreshStatementProviderEvent (var BankAccount@1000 : Record 270;var StatementProvider@1002 :

    /*
    LOCAL procedure OnRefreshStatementProviderEvent (var BankAccount: Record 270;var StatementProvider: Text)
        begin
          // The subscriber of this event should refresh the bank account linked to a bank statement provider service
        end;

        [Integration(TRUE)]
    */

    //     LOCAL procedure OnGetDataExchangeDefinitionEvent (var DataExchDefCodeResponse@1001 : Code[20];var Handled@1000 :

    /*
    LOCAL procedure OnGetDataExchangeDefinitionEvent (var DataExchDefCodeResponse: Code[20];var Handled: Boolean)
        begin
          // This event should retrieve the data exchange definition format for processing the online feeds
        end;
    */



    //     LOCAL procedure OnUpdateBankAccountLinkingEvent (var BankAccount@1000 : Record 270;var StatementProvider@1001 :

    /*
    LOCAL procedure OnUpdateBankAccountLinkingEvent (var BankAccount: Record 270;var StatementProvider: Text)
        begin
          // This event should handle updating of the single or multiple bank accounts
        end;
    */



    //     LOCAL procedure OnGetStatementProvidersEvent (var TempNameValueBuffer@1002 :

    /*
    LOCAL procedure OnGetStatementProvidersEvent (var TempNameValueBuffer: Record 823 TEMPORARY)
        begin
          // The subscriber of this event should insert a unique identifier (Name) and friendly name of the provider (Value)
        end;
    */



    //     LOCAL procedure OnDisableStatementProviderEvent (ProviderName@1002 :

    /*
    LOCAL procedure OnDisableStatementProviderEvent (ProviderName: Text)
        begin
          // The subscriber of this event should disable the statement provider with the given name
        end;

        /*begin
        //{
    //      QVE3043 PGM 17/10/2018 - A�adido campo nuevo para el confirming de los bancos.
    //      JAV 08/05/19: - A�adidos los campos
    //                            50001 No. control cheque
    //                            50002 No. cheque adicional
    //                            50003 No. control cheque adicional
    //                            50004 Serie banco
    //                            50005 Fecha ult. fichero N67
    //                            50006 Digitos banco N 67
    //                            50007 N67 Obligatoria
    //                            50011 Maximo  No. Cheque
    //      JAV 03/07/19: - Verificar el CCC y montar el IBAN si es correcto
    //      JAV 15/09/20: - QB 1.06.14 Se a�ade el campo "Margin days for conciliation" que indica los d�as de margen para la conciliaci�n bancaria por defecto para este banco
    //      JAV 15/09/21: - QB 1.09.17 Se cambia el manejo de los ficheros de confirming
    //    }
        end.
      */
}





