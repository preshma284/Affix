table 7206918 "QB Text"
{


    CaptionML = ENU = 'QuoBuilding Text', ESP = 'Textos para QuoBuilding';

    fields
    {
        field(1; "Table"; Option)
        {
            OptionMembers = "Preciario","Job","Diario","Comparativo","Contrato","Medicion","Certificacion";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Tabla';
            OptionCaptionML = ENU = 'Cost Database,Job,Purchase Lines', ESP = 'Preciario,Proyecto,Diario de Necesidades,Comparativo,Contrato,Medici�n,Certificaci�n';

            Description = 'QB 1.0';


        }
        field(2; "Key1"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Clave 1';
            Description = 'QB 1.0';


        }
        field(3; "Key2"; Code[30])
        {
            CaptionML = ENU = 'No.', ESP = 'Clave 2';
            Description = 'QB 1.0';


        }
        field(4; "Key3"; Code[20])
        {
            CaptionML = ENU = 'No.', ESP = 'Clave 3';
            Description = 'QB 1.0';


        }
        field(10; "Cost Text"; BLOB)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Extended description', ESP = 'Texto Coste';
            Description = 'QB 1.0';
            SubType = Memo;

            trigger OnValidate();
            BEGIN
                "Cost Size" := "Cost Text".LENGTH;
            END;


        }
        field(11; "Cost Size"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Tama�o Texto Coste';
            Description = 'QB 1.0';
            Editable = false;


        }
        field(12; "Sales Text"; BLOB)
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Extended description', ESP = 'Texto Venta';
            Description = 'QB 1.0';
            SubType = Memo;

            trigger OnValidate();
            BEGIN
                "Sales Size" := "Sales Text".LENGTH;
            END;


        }
        field(13; "Sales Size"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Tama�o Texto Venta';
            Description = 'QB 1.0';
            Editable = false;


        }
    }
    keys
    {
        key(key1; "Table", "Key1", "Key2", "Key3")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       UntitledMsg@1002 :
        UntitledMsg: TextConst ENU = 'untitled', ESP = 'SinT�tulo';
        //       Text001@1001 :
        Text001: TextConst ENU = 'You cannot purchase resources.', ESP = 'No se pueden comprar recursos.';
        //       RenameRecordErr@1000 :
        RenameRecordErr:
// %1 is TableName Field %2 is No.Table Field
TextConst ENU = 'You cannot rename %1 or %2.', ESP = 'No puede cambiar el nombre de %1 o %2.';
        //       QBTablePublisher@7001100 :
        QBTablePublisher: Codeunit 7207346;

    procedure GetCostText(): Text;
    var
        //       CR@100000000 :
        CR: Text[1];
        //       TempBlob@100000001 :
        TempBlob: Codeunit "Temp Blob";
        Blob: OutStream;
        InStr: InStream;
    begin
        CALCFIELDS("Cost Text");
        if not "Cost Text".HASVALUE then
            exit('');
        CR[1] := 10;
        // TempBlob.Blob := "Cost Text";
        /*To be tested*/

        TempBlob.CreateOutStream(Blob, TextEncoding::Windows);
        Blob.Write("Cost Text");
        // exit(TempBlob.ReadAsText(CR, TEXTENCODING::Windows)) ;
        /*To be tested*/

        TempBlob.CreateInStream(InStr, TextEncoding::Windows);
        InStr.Read(CR);
        exit(CR);
    end;

    //     procedure SetCostText (pTxt@100000001 :
    procedure SetCostText(pTxt: Text)
    var
        //       TempBlob@100000000 :
        TempBlob: Codeunit "Temp Blob";
        Blob: OutStream;
        InStr: InStream;
    begin
        // TempBlob.WriteAsText(pTxt, TEXTENCODING::Windows);
        /*To be tested*/

        TempBlob.CreateOutStream(Blob, TextEncoding::Windows);
        Blob.Write(pTxt);
        // "Cost Text" := TempBlob.Blob;
        /*To be tested*/

        TempBlob.CreateInStream(InStr, TextEncoding::Windows);
        InStr.Read("Cost Text");
        "Cost Size" := "Cost Text".LENGTH;
        if not MODIFY then
            INSERT;
    end;

    //     procedure AddCostText (pTxt@1100286008 : Text;AddCR@1100286000 :
    procedure AddCostText(pTxt: Text; AddCR: Boolean)
    var
        //       txtDestino@1100286011 :
        txtDestino: Text;
        //       CRLF@1100286009 :
        CRLF: Text[2];
    begin
        //A�adir un texto de un registro al registro actual solo si no est� repetido. A�ade un salto de l�nea si est� as� puesto
        if (pTxt <> '') then begin
            txtDestino := GetCostText;

            if (txtDestino = '') then
                txtDestino := pTxt
            else begin
                if (STRPOS(txtDestino, pTxt) = 0) then begin
                    if (AddCR) then begin
                        CRLF[1] := 10;
                        CRLF[2] := 13;
                        txtDestino += CRLF + CRLF;
                    end;
                    txtDestino += pTxt;
                end;
            end;

            SetCostText(txtDestino);
        end;

        //Guardar
    end;

    procedure GetSalesText(): Text;
    var
        //       CR@100000000 :
        CR: Text[1];
        //       TempBlob@100000001 :
        TempBlob: Codeunit "Temp Blob";
        Blob: OutStream;
        InStr: InStream;
    begin
        //Si no tiene texto para venta, retorna el de coste
        if ("Sales Size" = 0) then
            exit(GetCostText)
        else begin
            CALCFIELDS("Sales Text");
            if not "Sales Text".HASVALUE then
                exit('');
            CR[1] := 10;
            // TempBlob.Blob := "Sales Text";
            /*To be tested*/

            TempBlob.CreateOutStream(Blob, TextEncoding::Windows);
            Blob.Write("Sales Text");
            // exit(TempBlob.ReadAsText(CR, TEXTENCODING::Windows)) ;
            /*To be tested*/

            TempBlob.CreateInStream(InStr, TextEncoding::Windows);
            InStr.Read(CR);
            exit(CR);
        end;
    end;

    //     procedure SetSalesText (pTxt@100000001 :
    procedure SetSalesText(pTxt: Text)
    var
        //       TempBlob@100000000 :
        TempBlob: Codeunit "Temp Blob";
        Blob: OutStream;
        InStr: InStream;
        //       cText@1100286000 :
        cText: Text;
    begin
        CLEAR("Sales Text");
        if pTxt <> '' then begin
            cText := GetCostText;
            if (pTxt <> cText) then begin
                // TempBlob.WriteAsText(pTxt, TEXTENCODING::Windows);
                /*To be tested*/

                TempBlob.CreateOutStream(Blob, TextEncoding::Windows);
                Blob.Write(pTxt);
                // "Sales Text" := TempBlob.Blob;
                /*To be tested*/

                TempBlob.CreateInStream(InStr, TextEncoding::Windows);
                InStr.Read("Sales Text");
            end;
        end;
        "Sales Size" := "Sales Text".LENGTH;
        MODIFY;
    end;

    //     procedure AddSalesText (pTxt@1100286008 : Text;AddCR@1100286000 :
    procedure AddSalesText(pTxt: Text; AddCR: Boolean)
    var
        //       txtDestino@1100286011 :
        txtDestino: Text;
        //       CRLF@1100286009 :
        CRLF: Text[2];
    begin
        //A�adir un texto de un registro al registro actual solo si no est� repetido. A�ade un salto de l�nea si est� as� puesto
        if (pTxt <> '') then begin
            txtDestino := GetSalesText;

            if (txtDestino = '') then
                txtDestino := pTxt
            else begin
                if (STRPOS(txtDestino, pTxt) = 0) then begin
                    if (AddCR) then begin
                        CRLF[1] := 10;
                        CRLF[2] := 13;
                        txtDestino += CRLF + CRLF;
                    end;
                    txtDestino += pTxt;
                end;
            end;

            SetSalesText(txtDestino);
        end;

        //Guardar
    end;

    //     procedure CopyTo (sTable@100000006 : Option;sKey1@100000005 : Code[20];sKey2@100000004 : Code[20];sKey3@1100286001 : Code[20];dTable@100000001 : Option;dKey1@100000002 : Code[20];dKey2@100000003 : Code[20];dKey3@1100286000 :
    procedure CopyTo(sTable: Option; sKey1: Code[20]; sKey2: Code[20]; sKey3: Code[20]; dTable: Option; dKey1: Code[20]; dKey2: Code[20]; dKey3: Code[20])
    var
        //       sQBText@100000000 :
        sQBText: Record 7206918;
        //       dQBText@100000007 :
        dQBText: Record 7206918;
    begin
        //Copiar de una tabla a otra los textos
        if (sQBText.GET(sTable, sKey1, sKey2, sKey3)) then begin

            if (not dQBText.GET(dTable, dKey1, dKey2, dKey3)) then begin
                dQBText.INIT;
                dQBText.Table := dTable;
                dQBText.Key1 := dKey1;
                dQBText.Key2 := dKey2;
                dQBText.Key3 := dKey3;
                dQBText.INSERT;
            end;

            //pasar el texto para coste
            if (IsCost(dTable)) then begin
                sQBText.CALCFIELDS("Cost Text");
                dQBText."Cost Text" := sQBText."Cost Text";
                dQBText."Cost Size" := dQBText."Cost Text".LENGTH;
            end;
            //pasar el texto para venta
            if (IsOnlySales(dTable)) or ((IsSales(dTable)) and (sQBText."Sales Size" <> 0)) then begin
                sQBText.CALCFIELDS("Sales Text");
                dQBText."Sales Text" := sQBText."Sales Text";
                dQBText."Sales Size" := dQBText."Sales Text".LENGTH;
            end;
            dQBText.MODIFY;
        end;
    end;

    //     procedure InsertCostText (pText@1100286001 : Text;pTable@100000002 : Option;pKey1@100000001 : Code[20];pKey2@100000000 : Code[20];pKey3@1100286000 :
    procedure InsertCostText(pText: Text; pTable: Option; pKey1: Code[20]; pKey2: Code[20]; pKey3: Code[20])
    begin
        //Insertar un texto en la tabla
        if (not GET(pTable, pKey1, pKey2, pKey3)) then begin
            INIT;
            Table := pTable;
            Key1 := pKey1;
            Key2 := pKey2;
            Key3 := pKey3;
            INSERT;
        end;
        SetCostText(pText);
    end;

    //     procedure InsertSalesText (pText@1100286001 : Text;pTable@100000002 : Option;pKey1@100000001 : Code[20];pKey2@100000000 : Code[20];pKey3@1100286000 :
    procedure InsertSalesText(pText: Text; pTable: Option; pKey1: Code[20]; pKey2: Code[20]; pKey3: Code[20])
    begin
        //Insertar un texto en la tabla
        if (not GET(pTable, pKey1, pKey2, pKey3)) then begin
            INIT;
            Table := pTable;
            Key1 := pKey1;
            Key2 := pKey2;
            Key3 := pKey3;
            INSERT;
        end;
        SetSalesText(pText);
    end;

    //     procedure CombineText (Level@1100286010 : Integer;sTable@1100286008 : Option;sKey1@1100286007 : Code[20];sKey2@1100286006 : Code[20];sKey3@1100286004 : Code[20];dTable@1100286003 : Option;dKey1@1100286002 : Code[20];dKey2@1100286001 : Code[20];dKey3@1100286000 :
    procedure CombineText(Level: Integer; sTable: Option; sKey1: Code[20]; sKey2: Code[20]; sKey3: Code[20]; dTable: Option; dKey1: Code[20]; dKey2: Code[20]; dKey3: Code[20])
    var
        //       sQBText@1100286012 :
        sQBText: Record 7206918;
        //       dQBText@1100286013 :
        dQBText: Record 7206918;
        //       Text1@1100286011 :
        Text1: Text;
    begin
        //Combinar varios registros en el actual, si no est�n repetidos. A�ade un salto de l�nea cada vez
        sQBText.RESET;
        sQBText.SETRANGE(Table, sTable);
        sQBText.SETRANGE(Key1, sKey1);
        if (Level > 1) then
            sQBText.SETRANGE(Key2, sKey2)
        else
            sQBText.SETFILTER(Key2, '<>%1', '');
        if (Level > 2) then
            sQBText.SETRANGE(Key3, sKey3)
        else
            sQBText.SETFILTER(Key3, '<>%1', '');
        if (sQBText.FINDSET) then
            repeat
                if (not dQBText.GET(dTable, dKey1, dKey2, dKey3)) then begin
                    dQBText := sQBText;
                    dQBText.Table := dTable;
                    dQBText.Key1 := dKey1;
                    dQBText.Key2 := dKey2;
                    dQBText.Key3 := dKey3;
                    dQBText.INSERT;
                end;

                //pasar el texto para coste
                if (IsCost(dTable)) then begin
                    Text1 := sQBText.GetCostText;
                    dQBText.AddCostText(Text1, TRUE);
                end;
                //pasar el texto para venta
                if (IsOnlySales(dTable)) or ((IsSales(dTable)) and (sQBText."Sales Size" <> 0)) then begin
                    Text1 := sQBText.GetSalesText;
                    dQBText.AddSalesText(Text1, TRUE);
                end;

            until sQBText.NEXT = 0;
    end;

    //     procedure IsCost (pTable@1100286000 :
    procedure IsCost(pTable: Option): Boolean;
    begin
        exit(pTable IN [Table::Preciario, Table::Job, Table::Diario, Table::Comparativo, Table::Contrato]);
    end;

    //     procedure IsOnlyCost (pTable@1100286000 :
    procedure IsOnlyCost(pTable: Option): Boolean;
    begin
        exit(pTable IN [Table::Diario, Table::Comparativo, Table::Contrato]);
    end;

    //     procedure IsSales (pTable@1100286000 :
    procedure IsSales(pTable: Option): Boolean;
    begin
        exit(pTable IN [Table::Preciario, Table::Job, Table::Medicion, Table::Certificacion]);
    end;

    //     procedure IsOnlySales (pTable@1100286000 :
    procedure IsOnlySales(pTable: Option): Boolean;
    begin
        exit(pTable IN [Table::Medicion, Table::Certificacion]);
    end;

    /*begin
    end.
  */
}







