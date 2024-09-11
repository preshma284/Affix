tableextension 50166 "MyExtension50166" extends "Purchases & Payables Setup"
{


    CaptionML = ENU = 'Purchases & Payables Setup', ESP = 'Conf. compras y pagos';
    LookupPageID = "Purchases & Payables Setup";
    DrillDownPageID = "Purchases & Payables Setup";

    fields
    {
        field(7207270; "Expense Notes No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'Expense Notes No. Series', ESP = 'N� Serie Notas de Gasto';
            Description = 'QB 1.00';


        }
        field(7207271; "Post. Expe. Notes No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'Post. Expe. Notes No. Series', ESP = 'No. serie notas gasto regist.';
            Description = 'QB 1.00';


        }
        field(7207272; "Invoice Exp. Notes No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'No. serie fact. notas gasto', ESP = 'N� serie fact. notas gasto';
            Description = 'QB 1.00';


        }
        field(7207273; "Comparative Quotes No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'Comparative Quotes', ESP = 'N� serie Comparativo de Ofertas';
            Description = 'QB 1.00 - QB2515';


        }
        field(7207274; "QB Proforma No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'Comparative Quotes', ESP = 'N� serie Proformas';
            Description = 'QB 1.08.41 - PROFORMAS';


        }
        field(7207275; "QB Proforma Date"; Option)
        {
            OptionMembers = "Work","Order";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Fecha de la proforma';
            OptionCaptionML = ESP = 'Trabajo,Pedido';

            Description = 'QB 1.08.43 - PROFORMAS';


        }
        field(7207276; "QB % Proforma"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = '% Cnt. de proforma por defecto';
            MinValue = 0;
            MaxValue = 100;
            Description = 'QB 1.08.41 - PROFORMAS';


        }
        field(7207277; "QB Proforma Def. Group"; Option)
        {
            OptionMembers = "None","Piecework","Code";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Agrupar proforma por';
            OptionCaptionML = ESP = 'No agrupar,Por Unidad de Obra,Por c�digo de Recurso/Producto';

            Description = 'QB 1.08.43';


        }
        field(7207278; "Evaluations Nos. No. Series"; Code[20])
        {
            TableRelation = "No. Series";
            CaptionML = ENU = 'Evaluations Nos.', ESP = 'N� Serie Evaluaciones';
            Description = 'QB 1.00 - QB2514';


        }
        field(7207279; "Vendor Conditions Type"; Option)
        {
            OptionMembers = " ","G/L Account","Item","Resource";

            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Type', ESP = 'Tipo para Condiciones';
            OptionCaptionML = ENU = '" ,G/L Account,Item,Resource"', ESP = '" ,Cuenta,Producto,Recurso"';

            Description = 'QB 1.00 - JAV 03/12/19: - Tipo de l�nea para crear la de otras condiciones del proveedor en pedidos de compra';

            trigger OnValidate();
            VAR
                //                                                                 TempPurchLine@1000 :
                TempPurchLine: Record 39 TEMPORARY;
            BEGIN
            END;


        }
        field(7207280; "Vendor Conditions No."; Code[20])
        {
            TableRelation = IF ("Vendor Conditions Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST("Posting"), "Direct Posting" = CONST(true)) ELSE IF ("Vendor Conditions Type" = CONST("Item")) Item ELSE IF ("Vendor Conditions Type" = CONST("Resource")) Resource WHERE("Type" = CONST("Subcontracting"));


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'No.', ESP = 'C�digo para Condiciones';
            Description = 'QB 1.00 - JAV 03/12/19: - C�digo para crear la de otras condiciones del proveedor en pedidos de compra';

            trigger OnValidate();
            VAR
                //                                                                 TempPurchLine@1003 :
                TempPurchLine: Record 39 TEMPORARY;
                //                                                                 FindRecordMgt@1000 :
                FindRecordMgt: Codeunit 703;
            BEGIN
            END;


        }
        field(7207281; "Vendor Conditions CA"; Code[20])
        {
            TableRelation = "Dimension Value"."Code" WHERE("Global Dimension No." = CONST(2));


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'No.', ESP = 'C.A. para Condiciones';
            Description = 'QB 1.00 - JAV 03/12/19: - C�digo para el CA al crear las otras condiciones del proveedor en pedidos de compra';

            trigger OnValidate();
            VAR
                //                                                                 TempPurchLine@1003 :
                TempPurchLine: Record 39 TEMPORARY;
                //                                                                 FindRecordMgt@1000 :
                FindRecordMgt: Codeunit 703;
            BEGIN
            END;


        }
        field(7207282; "Vendor Conditions Piecework"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'U.Obra para Condiciones';
            Description = 'QB 1.00 - JAV 03/12/19: - Unidad de Obra de indirectos para crear las otras condiciones del proveedor en pedidos de compra';


        }
        field(7207283; "QB No Validate Proform"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'No validar las Proformas';
            Description = 'QB 1.08.48 - PROFORMAS: JAV 07/06/21 - [TT] Si no es obligatorio validar las proformas para facturarlas';


        }
        field(7207284; "QB Proform All"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Proformar todo';
            Description = 'QB 1.09.08 - PROFORMAS: JAV 18/07/21 - [TT] Si se desea proformar cualquier producto o recurso por defecto';


        }
        field(7207285; "Always Use FRI"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Always Use FRI', ESP = 'Usar siempre FRI';
            Description = 'QB 1.00 - QBV';


        }
        field(7207288; "Obralia WS"; Text[150])
        {
            ExtendedDatatype = URL;
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Purchases Obralia WS', ESP = 'URL del servicio';
            Description = 'QB 1.00 - OBR URL, si est� en blanco se usa la est�ndar';


        }
        field(7207289; "Obralia User"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'WS User', ESP = 'Usuario';
            Description = 'QB 1.00 - OBR Usuario';


        }
        field(7207290; "Obralia Password"; Text[30])
        {
            ExtendedDatatype = Masked;
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'WS Password', ESP = 'Contrase�a';
            Description = 'QB 1.00 - OBR Password';


        }
        field(7207291; "Obralia Activated"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Activar Obralia';
            Description = 'QB 1.06.05 - JAV 23/07/20: - Si se activa el enlace con Obralia';


        }
        field(7207292; "Obralia Green"; Code[10])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Valor para Verde';
            Description = 'QB 1.06.05 - JAV 23/07/20: - [TT] Valores que indican semaforo Verde para Obralia, pueden ser varias letras';


        }
        field(7207293; "Obralia Red"; Code[10])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Valor para Rojo';
            Description = 'QB 1.06.05 - JAV 23/07/20: - [TT] Valores que indican semaforo Rojo para Obralia, pueden ser varias letras';


        }
        field(7207300; "QB Proforma Text"; BLOB)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Texto para proforma';
            Description = 'QB 1.08.43 - JAV 20/05/21: - Texto para el pie de la proforma';


        }
        field(7207301; "QB Proforma Last Text"; BLOB)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Texto para �ltima proforma';
            Description = 'QB 1.08.43 - JAV 20/05/21: - Texto para el pie de la �ltima proforma';


        }
        field(7207302; "QB_Comision - Tipo Individual"; Option)
        {
            OptionMembers = "Desglosada","SinDesglose";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Opc. Asiento Individual';
            OptionCaptionML = ESP = 'Desglosada,Sin Desglosar';

            Description = 'QRE';


        }
        field(7207310; "QB Comp Firmantes"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Usar firmantes por cargos';
            Description = 'QB 1.10.14 JAV 26/01/21: - Si se emplean los firmantes definidos aqu� o los fijos del comparativo';


        }
        field(7207311; "QB Comp Cargo Firmante 1"; Code[10])
        {
            TableRelation = "QB Position";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Comparative, signing 1', ESP = 'Comparativos, Cargo del firmante 1';
            Description = 'QB 1.10.14 JAV 26/01/21: - Cargo del firmante 1 para usar en comparativos';


        }
        field(7207312; "QB Comp Cargo Firmante 2"; Code[10])
        {
            TableRelation = "QB Position";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Comparative, signing 2', ESP = 'Comparativos, Cargo del firmante 2';
            Description = 'QB 1.10.14 JAV 26/01/21: - Cargo del firmante 2 para usar en comparativos';


        }
        field(7207313; "QB Comp Cargo Firmante 3"; Code[10])
        {
            TableRelation = "QB Position";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Comparative, signing 3', ESP = 'Comparativos, Cargo del firmante 3';
            Description = 'QB 1.10.14 JAV 26/01/21: - Cargo del firmante 3 para usar en comparativos';


        }
        field(7207314; "QB Comp Cargo Firmante 4"; Code[10])
        {
            TableRelation = "QB Position";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Comparative, signing 4', ESP = 'Comparativos, Cargo del firmante 4';
            Description = 'QB 1.10.14 JAV 26/01/21: - Cargo del firmante 4 para usar en comparativos';


        }
        field(7207321; "QB Comp Firmante 1"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Comparative, signing 1', ESP = 'Comparativos, Descripci�n del firmante 1';
            Description = 'QB 1.10.14 JAV 26/01/21: - Cargo del firmante 1 para usar en comparativos';


        }
        field(7207322; "QB Comp Firmante 2"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Comparative, signing 2', ESP = 'Comparativos, Descripci�n del firmante 2';
            Description = 'QB 1.10.14 JAV 26/01/21: - Cargo del firmante 2 para usar en comparativos';


        }
        field(7207323; "QB Comp Firmante 3"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Comparative, signing 3', ESP = 'Comparativos, Descripci�n del firmante 3';
            Description = 'QB 1.10.14 JAV 26/01/21: - Cargo del firmante 3 para usar en comparativos';


        }
        field(7207324; "QB Comp Firmante 4"; Text[50])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Comparative, signing 4', ESP = 'Comparativos, Descripci�n del firmante 4';
            Description = 'QB 1.10.14 JAV 26/01/21: - Cargo del firmante 4 para usar en comparativos';


        }
        field(7207700; "QB Stocks Active New Function"; Option)
        {
            OptionMembers = "No","Yes","Mandatory","Default Yes";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Active new functionality stocks', ESP = 'Activ. nueva func. stocks';
            OptionCaptionML = ENU = 'No,Yes,Mandatory,Default Yes', ESP = 'No,Si,Obligatorio,Por defecto Si';

            Description = 'QB_ST01';


        }
        field(7207701; "QB Stocks Post Inv.Cost to G/L"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Post Inventory Cost to G/L', ESP = 'Pasar coste de Inventario a Contabilidad';
            Description = 'QB_ST01';


        }
        field(7238177; "QB Comp Value Qty.  Purc. Line"; Option)
        {
            OptionMembers = "Quantity","Amount";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Comp Value Qty.  Purc. Line', ESP = 'Comp. Cant Valor a Lin. Ped.';
            OptionCaptionML = ENU = 'Quantity,Amount', ESP = 'Cantidad,Importe';

            Description = 'QRE 16539 07/03/22: Valor a llevar al campo Cantidad desde el comparativo al pedido';


        }
        field(7238178; "QB Not Item Neg. Cost"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'No Permitir Costes Negativos en productos';
            Description = 'QB 1.10.56 28/06/22 : AML';


        }
        field(7238190; "QB Archive when reopen"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Archive when reopen', ESP = 'Archivar al reabrir';
            Description = 'QB_QRE 17704';


        }
        field(7238191; "QB Porcentaje Uso Contrato"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Contract use percentage', ESP = 'Porcentaje uso contrato';
            Description = 'BS:18338';


        }
        field(7238192; "QB Cargo Responsable Aviso"; Code[20])
        {
            TableRelation = "QB Position"."Code";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Position responsible to notify', ESP = 'Cargo responsable aviso';
            Description = 'BS:18338';


        }
        field(7238193; "QB Cargo Responsable Aviso Seg"; Code[20])
        {
            TableRelation = "QB Position"."Code";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Position responsible to notify', ESP = 'Cargo responsable de aviso Seguro';
            Description = 'BS::20016';


        }
    }
    keys
    {
        // key(key1;"Primary Key")
        //  {
        /* Clustered=true;
  */
        // }
    }
    fieldgroups
    {
    }

    var
        //       Text001@1000 :
        Text001: TextConst ENU = 'Job Queue Priority must be zero or positive.', ESP = 'La prioridad de la cola de proyecto debe ser cero o positiva.';
        //       GLSetup@1100000 :
        GLSetup: Record 98;
        //       RecordHasBeenRead@1001 :
        RecordHasBeenRead: Boolean;



    /*
    procedure GetRecordOnce ()
        begin
          if RecordHasBeenRead then
            exit;
          GET;
          RecordHasBeenRead := TRUE;
        end;
    */




    /*
    procedure JobQueueActive () : Boolean;
        begin
          GET;
          exit("Post with Job Queue" or "Post & Print with Job Queue");
        end;
    */


    LOCAL procedure "----------------------------------------"()
    begin
    end;



    procedure QB_GetText(): Text;
    var
        //       CR@100000000 :
        CR: Text[1];
        TempBlob: Codeunit "Temp Blob";
        Blob: OutStream;
        InStr: InStream;

    begin
        CALCFIELDS("QB Proforma Text");
        if not "QB Proforma Text".HASVALUE then
            exit('');
        CR[1] := 10;
        // TempBlob.Blob := "QB Proforma Text";
        //To be tested

        TempBlob.CreateOutStream(Blob, TextEncoding::Windows);
        Blob.Write("QB Proforma Text");
        // exit(TempBlob.ReadAsText(CR, TEXTENCODING::Windows)) ;
        //To be tested

        TempBlob.CreateInStream(InStr, TextEncoding::Windows);
        InStr.Read(CR);
        exit(CR);
    end;





    procedure QB_GetLastText(): Text;
    var
        //       CR@100000000 :
        CR: Text[1];
        TempBlob: Codeunit "Temp Blob";
        Blob: OutStream;
        InStr: InStream;

    begin
        CALCFIELDS("QB Proforma Last Text");
        if not "QB Proforma Last Text".HASVALUE then
            exit('');
        CR[1] := 10;
        // TempBlob.Blob := "QB Proforma Last Text";
        //To be tested

        TempBlob.CreateOutStream(Blob, TextEncoding::Windows);
        Blob.Write("QB Proforma Last Text");
        // exit(TempBlob.ReadAsText(CR, TEXTENCODING::Windows)) ;
        //To be tested

        TempBlob.CreateInStream(InStr, TextEncoding::Windows);
        InStr.Read(CR);
        exit(CR);
    end;



    //     procedure QB_SetText (pTxt@100000001 :


    procedure QB_SetText(pTxt: Text)
    var
        TempBlob: Codeunit "Temp Blob";
        Blob: OutStream;
        InStr: InStream;

    begin
        // TempBlob.WriteAsText(pTxt, TEXTENCODING::Windows);
        //To be tested

        TempBlob.CreateOutStream(Blob, TextEncoding::Windows);
        Blob.Write(pTxt);
        // "QB Proforma Text" := TempBlob.Blob;
        //To be tested

        TempBlob.CreateInStream(InStr, TextEncoding::Windows);
        InStr.Read("QB Proforma Text");
        if not MODIFY then
            INSERT;
    end;



    //     procedure QB_SetLastText (pTxt@100000001 :


    procedure QB_SetLastText(pTxt: Text)
    var
        TempBlob: Codeunit "Temp Blob";
        Blob: OutStream;
        InStr: InStream;

    begin
        // TempBlob.WriteAsText(pTxt, TEXTENCODING::Windows);
        //To be tested

        TempBlob.CreateOutStream(Blob, TextEncoding::Windows);
        Blob.Write(pTxt);
        // "QB Proforma Last Text" := TempBlob.Blob;
        //To be tested

        TempBlob.CreateInStream(InStr, TextEncoding::Windows);
        InStr.Read("QB Proforma Last Text");
        if not MODIFY then
            INSERT;
    end;

    /*begin
    //{
//      PEL 13/06/18: - QB2395 Se crea nuevo campo --> Eliminado con las nuevas aprobaciones
//      PGM 19/03/18: - QBV A�adido nuevo campo "Always Use FRI"
//      PEL 19/03/19: - OBR Campos de Obralia creados
//      JAV 03/10/19: - Se eliminan los campos 7207280 a 7207284 pues ya no se usan con el selector de informes
//      JDC 22/07/19: - GAP002 Added field 50010 "Mandatory Certificate Check"
//      JAV 21/11/19: - Se eliminan los campos "Other Vendor Conditions Code 1" y "Other Vendor Conditions Code 2" pues ya no se usan
//      JAV 26/11/19: - Se elimina el campo "Posted Evaluations Nos." que no se utiliza
//                    - Se a�ande los campos "Vendor Conditions Type", "Vendor Conditions No.", "Vendor Conditions CA" y "Vendor Conditions Piecework"
//                      para incluir las otras condiciones del proveedor en los pedidos de compra
//      JAV 04/02/20: - GAP12 ROIG CyS se a�aden los campos "Max. Dif. Amount Invoice" y "Calc Due Date"
//      JAV 08/09/21: - QB 1.09.17 Se aumenta a 20 las longitudes de los campos que son contadores
//      DGG 07/03/22: - 16539 Se a�ade campo 7238177, para indicar el valor con el que debe informar el campo cantidad en las lineas del pedido al convertir a pedido el comparativo
//      AML 22/03/22: - Se a�ade campo Active_Stocks_Function;
//      DGG 15/07/22: - 17704.Se a�ade campo 7238190 "Archive when reopen".
//      HAN 12/01/23: - BS:18338 Nuevos campos Porcentaje Uso Contrato y Cargo Responsable a enviarle el mail
//      BS::20016 CSM 30/11/23 � VAR013 control documentaci�n obra.
//    }
    end.
  */
}




