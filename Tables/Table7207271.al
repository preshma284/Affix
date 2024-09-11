table 7207271 "QBU Cost Database"
{


    CaptionML = ENU = 'Preciario', ESP = 'Preciario';
    LookupPageID = "Cost Database List";
    DrillDownPageID = "Cost Database List";

    fields
    {
        field(1; "Code"; Code[20])
        {


            CaptionML = ENU = 'Code', ESP = 'C�digo';

            trigger OnValidate();
            BEGIN
                IF Code <> xRec.Code THEN BEGIN
                    QuoBuildingSetup.GET;
                    NoSeriesManagement.TestManual(QuoBuildingSetup."Serie for Cost Database");
                    "Series No." := '';
                END;
            END;


        }
        field(2; "Description"; Text[50])
        {
            CaptionML = ENU = 'Description', ESP = 'Descripción';


        }
        field(3; "Job Classification"; Code[10])
        {
            TableRelation = "Job Classification"."Code";
            CaptionML = ENU = 'Job Classification', ESP = 'Clasificaci�n proyecto';


        }
        field(4; "Date Hight"; Date)
        {
            CaptionML = ENU = 'Date Hight', ESP = 'Fecha alta';


        }
        field(5; "Series No."; Code[20])
        {
            CaptionML = ENU = 'Series No.', ESP = 'No. serie';


        }
        field(6; "Cost Database PRESTO Code"; Code[20])
        {
            CaptionML = ENU = 'Cost Database PRESTO Code', ESP = 'Cod. Preciario PRESTO';


        }
        field(7; "Archived"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Archivado';


        }
        field(8; "Type JU"; Option)
        {
            OptionMembers = "Direct","Indirect","Booth";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Tipo U.O.';
            OptionCaptionML = ENU = 'Direct,Indirect,Booth', ESP = 'Directos,Indirectos,Ambos';

            Description = 'JAV 30/09/19: - Tipo de preciario (directos o indirectos)';


        }
        field(9; "Type Unit"; Option)
        {
            OptionMembers = "Cost","CostSale","Sale";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Tipo Descompuestos';
            OptionCaptionML = ENU = 'Cost,Cost & Sale,Sale', ESP = 'Coste,Coste y venta,Venta';

            Description = 'QB 1.06.09 - JAV 06/08/20: - Si tiene datos de coste o de coste y venta';


        }
        field(10; "Used for Direct cost"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(Job WHERE("Import Cost Database Direct" = FIELD("Code")));
            CaptionML = ENU = 'Used for Direct cost', ESP = 'Usado para costes directos';
            Description = 'JAV 18/03/19: Informa en que proyectos/estudios se ha usado  JAV 02/10/19: - En los que se ha usado para cargar costes directos';
            Editable = false;


        }
        field(11; "Used for Indirect cost"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(Job WHERE("Import Cost Database Indirect" = FIELD("Code")));
            CaptionML = ENU = 'Used for Direct cost', ESP = 'Usado para costes indirectos';
            Description = 'JAV 02/10/19: Informa en que proyectos/estudios se ha usado para cargar costes indirectos';
            Editable = false;


        }
        field(12; "Currency"; Code[10])
        {
            TableRelation = "Currency";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Currency Code', ESP = 'C�d. divisa';


        }
        field(13; "CI Cost"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ESP = '% Indirectos globales Coste';
            Description = 'QB 1.12.24 JAV 03/12/22: - El % de indirectos para aplicarlos globalmente en coste';

            trigger OnValidate();
            BEGIN
                IF (Rec."CI Cost" <> xRec."CI Cost") THEN BEGIN
                    IF (NOT CONFIRM('Ha cambiado el coeficiente lo que cambiar� los importes, �confirma el cambio?', FALSE)) THEN
                        ERROR('');
                    QBCostDatabase.CD_CalculateCI(Rec, 0);
                END;
            END;


        }
        field(14; "CI Sales"; Decimal)
        {


            DataClassification = ToBeClassified;
            CaptionML = ESP = '% Indirectos globales Venta';
            Description = 'QB 1.12.24 JAV 03/12/22: - El % de indirectos para aplicarlos globalmente en venta';

            trigger OnValidate();
            BEGIN
                IF (Rec."CI Sales" <> xRec."CI Sales") THEN BEGIN
                    IF (NOT CONFIRM('Ha cambiado el coeficiente lo que cambiar� los importes, �confirma el cambio?', FALSE)) THEN
                        ERROR('');
                    QBCostDatabase.CD_CalculateCI(Rec, 1);
                END;
            END;


        }
        field(15; "Version"; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Versi�n';
            Description = 'QB 1.12.24 JAV 04/12/22: - La versi�n que tienen los datos, as� se carga en funci�n de su estructura sin problemas';


        }
        field(20; "UO Red. Qty"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'U.O. Redondeo Cantidad';
            DecimalPlaces = 2 : 5;
            Description = 'QB 1.12.24 JAV 26/11/22: - Redondeaos a utilizar en la carga';


        }
        field(21; "UO Red. Price"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'U.O. Redondeo Precio';
            DecimalPlaces = 2 : 5;
            Description = 'QB 1.12.24 JAV 26/11/22: - Redondeaos a utilizar en la carga';


        }
        field(22; "UO Red. Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'U.O. Redondeo Importe';
            DecimalPlaces = 2 : 5;
            Description = 'QB 1.12.24 JAV 26/11/22: - Redondeaos a utilizar en la carga';


        }
        field(23; "Des Red. Qty"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Desc. Redondeo Cantidad';
            DecimalPlaces = 2 : 5;
            Description = 'QB 1.12.24 JAV 26/11/22: - Redondeaos a utilizar en la carga';


        }
        field(24; "Des Red. Price"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Desc. Redondeo Precio';
            DecimalPlaces = 2 : 5;
            Description = 'QB 1.12.24 JAV 26/11/22: - Redondeaos a utilizar en la carga';


        }
        field(25; "Des Red. Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Desc. Redondeo Importe';
            DecimalPlaces = 2 : 5;
            Description = 'QB 1.12.24 JAV 26/11/22: - Redondeaos a utilizar en la carga';


        }
        field(26; "Porcentual Cost"; Option)
        {
            OptionMembers = "Upload","Distribute","DontUpload";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Para porcentuales en coste';
            OptionCaptionML = ENU = 'Upload,Distribute,Don''t upload', ESP = 'Cargar,Distribuir,No cargar';

            Description = 'QB 1.12.24 JAV 12/12/22 - Como manejar los porcentuales en coste';


        }
        field(27; "Porcentual Sales"; Option)
        {
            OptionMembers = "Upload","Distribute","DontUpload";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Para porcentuales en venta';
            OptionCaptionML = ENU = 'Upload,Distribute,Don''t upload', ESP = 'Cargar,Distribuir,No cargar';

            Description = 'QB 1.12.24 JAV 12/12/22 - Como manejar los porcentuales en venta';


        }
        field(30; "Errors Header Text"; BLOB)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Errores de Mayor';
            Description = 'QB 1.12.24 JAV 26/11/22: - Los errores detectados en el preciario tras la revisi�n, precio recibido/precio calculado';
            SubType = Memo;


        }
        field(31; "Errors Header No."; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'N� Errores de Mayor';
            Description = 'QB 1.12.24 JAV 26/11/22: - El n�mero de los errores detectados en el preciario tras la revisi�n, precio recibido/precio calculado';
            Editable = false;


        }
        field(32; "Errors Desc Text"; BLOB)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Errores de descompuestos';
            Description = 'QB 1.12.24 JAV 26/11/22: - Los errores detectados en el preciario tras la revisi�n, unidades de �ltimo nivel de tipo auxiliar sin descompuestos';
            SubType = Memo;


        }
        field(33; "Errors Desc No."; Integer)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'N� Errores de descompuestos';
            Description = 'QB 1.12.24 JAV 26/11/22: - El n�mero de los errores detectados en el preciario tras la revisi�n, unidades de �ltimo nivel de tipo auxiliar sin descompuestos';
            Editable = false;


        }
        field(100; "PrimerNivel"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'Q18345';


        }
        field(101; "NombreFicheroBC3"; Text[100])
        {
            DataClassification = ToBeClassified;
            Description = 'Q18345';


        }
        field(102; "TextoPrimerNivel"; Text[100])
        {
            DataClassification = ToBeClassified;
            Description = 'Q18345';


        }
    }
    keys
    {
        key(key1; "Code")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       QuoBuildingSetup@60000 :
        QuoBuildingSetup: Record 7207278;
        //       CostDatabase@60002 :
        CostDatabase: Record 7207271;
        //       txt01@1100286000 :
        txt01: TextConst ESP = 'Este preciario se ha usado en %1 estudios y/o proyectos, confirme que desea eliminarlo';
        //       TempBlob@1100286001 :
        TempBlob: Codeunit "Temp Blob";
        Blob: OutStream;
        InStr: InStream;
        //       QBCostDatabase@1100286003 :
        QBCostDatabase: Codeunit 7206986;
        //       NoSeriesManagement@1100286004 :
        NoSeriesManagement: Codeunit "NoSeriesManagement";
        //       OPCerror@1100286002 :
        OPCerror: Option "Header","Desc";



    trigger OnInsert();
    begin
        if Code = '' then begin
            QuoBuildingSetup.GET;
            QuoBuildingSetup.TESTFIELD(QuoBuildingSetup."Serie for Cost Database");
            NoSeriesManagement.InitSeries(QuoBuildingSetup."Serie for Cost Database", xRec."Series No.", 0D, Code, "Series No.");
        end;
    end;

    trigger OnDelete();
    begin
        //JAV 18/03/19: - Se a�ade el campo 7 "Used" con la cuenta de en cuantos proyectos se ha usado y se limita el borrado
        //JAV 01/10/19: - Se a�ade el campo de tipo y se divide el campo Used en dos para directos e indirectos
        CALCFIELDS("Used for Direct cost", "Used for Indirect cost");
        if ("Used for Direct cost" + "Used for Indirect cost" <> 0) then
            if not CONFIRM(txt01, FALSE, "Used for Direct cost" + "Used for Indirect cost") then
                ERROR('');
        //JAV 18/03/19 fin

        //JAV 23/11/20: - Se traspasa el borrado de las tablas auxiliares a una funci�n
        DeleteData(Code);
    end;

    trigger OnRename();
    var
        //                QBText@1100286000 :
        QBText: Record 7206918;
    begin
        //JAV 04/12/22: - QB 1.12.24 Cambiar los textos extendidos que no puede cambiar el rename autom�ticamente
        QBText.RESET;
        QBText.SETRANGE(Table, QBText.Table::Preciario);
        QBText.SETRANGE(Key1, xRec.Code);
        if QBText.FINDSET then
            repeat
                QBText.CopyTo(QBText.Table, QBText.Key1, QBText.Key2, QBText.Key3, QBText.Table, Rec.Code, QBText.Key2, QBText.Key3);
                QBText.DELETE;
            until QBText.NEXT = 0;
    end;



    // procedure AssitEdit (CostDatabase@60000 :
    procedure AssitEdit(CostDatabase: Record 7207271): Boolean;
    begin
        //WITH CostDatabase DO begin
        CostDatabase := Rec;
        QuoBuildingSetup.GET;
        QuoBuildingSetup.TESTFIELD(QuoBuildingSetup."Serie for Cost Database");
        if NoSeriesManagement.SelectSeries(QuoBuildingSetup."Serie for Cost Database", CostDatabase."Series No.", "Series No.") then begin
            QuoBuildingSetup.GET;
            QuoBuildingSetup.TESTFIELD(QuoBuildingSetup."Serie for Cost Database");
            NoSeriesManagement.SetSeries(Code);
            Rec := CostDatabase;
            exit(TRUE);
        end;
        //end;
    end;

    //     procedure DeleteData (pCode@1100286005 :
    procedure DeleteData(pCode: Code[20])
    var
        //       Piecework@1100286004 :
        Piecework: Record 7207277;
        //       QBText@1100286003 :
        QBText: Record 7206918;
        //       BillofItemData@1100286002 :
        BillofItemData: Record 7207384;
        //       MeasureLinePieceworkPRESTO@1100286001 :
        MeasureLinePieceworkPRESTO: Record 7207285;
        //       PriceCostDatabasePRESTO@1100286000 :
        PriceCostDatabasePRESTO: Record 7207284;
        //       QBBillofItemDataRed@1100286006 :
        QBBillofItemDataRed: Record 7207398;
    begin
        //JAV 23/11/20: - QB 1.07.06 Borrar las tablas auxiliares que cuelgan del preciario
        Piecework.RESET;
        Piecework.SETRANGE("Cost Database Default", pCode);
        Piecework.DELETEALL(TRUE);

        // Eliminar Datos de descompuesto
        BillofItemData.RESET;
        BillofItemData.SETRANGE("Cod. Cost database", pCode);
        BillofItemData.DELETEALL;

        // Eliminar las l�neas de medici�n
        MeasureLinePieceworkPRESTO.SETRANGE("Cost Database Code", pCode);
        MeasureLinePieceworkPRESTO.DELETEALL(TRUE);

        //Eliminar textos extendidos
        QBText.RESET;
        QBText.SETRANGE(Table, QBText.Table::Preciario);
        QBText.SETRANGE(Key1, pCode);
        QBText.DELETEALL;

        // Precios de presto
        PriceCostDatabasePRESTO.SETRANGE("Cod. Cost Database", pCode);
        PriceCostDatabasePRESTO.DELETEALL;

        //JAV 12/12/22: - QB 1.12.24 Auxiliar para reducciones
        QBBillofItemDataRed.SETRANGE("Cod. Cost database", pCode);
        QBBillofItemDataRed.DELETEALL;
    end;

    //     procedure GetPrecision (pType@1100286000 :
    procedure GetPrecision(pType: Option "uoQ","uoP","uoA","deQ","deP","deA"): Decimal;
    var
        //       Currency@1100286002 :
        Currency: Record 4;
        //       value@1100286001 :
        value: Decimal;
    begin
        CLEAR(Currency);
        Currency.InitRoundingPrecision;
        value := 0;
        CASE pType OF
            pType::uoQ:
                if (Rec."UO Red. Qty" <> 0) then
                    value := Rec."UO Red. Qty" else
                    value := 0.001;
            pType::uoP:
                if (Rec."UO Red. Price" <> 0) then
                    value := Rec."UO Red. Price" else
                    value := Currency."Unit-Amount Rounding Precision";
            pType::uoA:
                if (Rec."UO Red. Amount" <> 0) then
                    value := Rec."UO Red. Amount" else
                    value := Currency."Amount Rounding Precision";
            pType::deQ:
                if (Rec."Des Red. Qty" <> 0) then
                    value := Rec."Des Red. Qty" else
                    value := 0.001;
            pType::deP:
                if (Rec."Des Red. Price" <> 0) then
                    value := Rec."Des Red. Price" else
                    value := Currency."Unit-Amount Rounding Precision";
            pType::deA:
                if (Rec."Des Red. Amount" <> 0) then
                    value := Rec."Des Red. Amount" else
                    value := Currency."Unit-Amount Rounding Precision";
        end;
        if (value = 0) then
            value := 0.01;

        exit(value);
    end;

    /*begin
    //{
//      JAV 18/03/19: - Se a�ade el campo 7 "Used" con la cuenta de en cuantos proyectos se ha usado y se limita el borrado por este campo
//      JAV 01/10/19: - Se a�ade el campo de tipo y se divide el campo Used en dos para directos e indirectos
//      JAV 28/11/22: - QB 1.12.24 Mejoras en las carga de los BC3.
//                                 Se a�aden campos para redondeos (20 a 25)
//                                 Se a�aden campos para errores (30 a 33)
//                                 Se a�aden campos para CI (13 y 14), e su validate se llama a la funci�n CalculateCI
//                                 Se elimina la funci�n UpdatePiecework, se traslada al rename
//      AML 14/06/23: - Q18345 Campos Primer Nivel y nombre fichero creados para la exportaci�n de certificaciones.
//    }
    end.
  */
}







