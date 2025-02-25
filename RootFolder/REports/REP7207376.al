report 7207376 "Import Budget Excel"
{


    CaptionML = ENU = 'Import Budget Excel', ESP = 'Importar presup. Excel';
    ProcessingOnly = true;

    dataset
    {

        DataItem("Filas"; "2000000026")
        {

            DataItemTableView = SORTING("Number");

            ;
            trigger OnPreDataItem();
            BEGIN
                IF CJob = '' THEN
                    ERROR(Text007);

                Job.GET(CJob);
                ExcelBuffer.RESET;
                //Leo el buffer desde la fila que me indiquenque es la primera que tiene datos
                IF ExcelBuffer.FINDSET THEN
                    SETRANGE(Number, FirstRowSignificant, ExcelBuffer."Row No.");

                PieceworkInProgressTA := '';
                PieceworkInProgressTAC := '';
                PieceworkInProgressDC := '';
                AccountLines := 0;
                AccountLinesC := 0;
            END;

            trigger OnAfterGetRecord();
            BEGIN
                Window.UPDATE(2, Filas.Number);

                Type := GetColTxt(2, Text009);
                PieceworkCode := GetColTxt(3, Text010);
                Description := GetColTxt(5, Text011);

                CASE GetColTxt(1, Text008) OF
                    Text012: //Tipo Unidad de Obra
                        BEGIN
                            IF NOT DataPieceworkForProduction.GET(CJob, PieceworkCode) THEN BEGIN
                                CLEAR(DataPieceworkForProduction);
                                DataPieceworkForProduction.VALIDATE("Job No.", CJob);
                                DataPieceworkForProduction.VALIDATE("Piecework Code", PieceworkCode);
                                DataPieceworkForProduction.INSERT(TRUE);
                            END;
                            IF (Type IN [Text013, Text090]) THEN
                                DataPieceworkForProduction."Account Type" := DataPieceworkForProduction."Account Type"::Heading
                            ELSE
                                DataPieceworkForProduction."Account Type" := DataPieceworkForProduction."Account Type"::Unit;
                            DataPieceworkForProduction.Description := COPYSTR(Description, 1, MAXSTRLEN(DataPieceworkForProduction.Description));
                            DataPieceworkForProduction."Description 2" := COPYSTR(Description, MAXSTRLEN(DataPieceworkForProduction.Description) + 1, MAXSTRLEN(DataPieceworkForProduction."Description 2"));

                            IF (GetColBol(6, Text009)) THEN BEGIN
                                DataPieceworkForProduction.VALIDATE("Production Unit", TRUE);
                                IF (DataPieceworkForProduction."Account Type" = DataPieceworkForProduction."Account Type"::Unit) THEN BEGIN
                                    DataPieceworkForProduction.VALIDATE("Budget Measure", GetColDec(8, Text014));
                                    DataPieceworkForProduction.VALIDATE("Initial Produc. Price", GetColDec(10, Text015));
                                END;
                            END ELSE
                                DataPieceworkForProduction."Production Unit" := FALSE;

                            IF (GetColBol(7, Text009)) THEN BEGIN
                                DataPieceworkForProduction.VALIDATE("Customer Certification Unit", TRUE);
                                IF (DataPieceworkForProduction."Account Type" = DataPieceworkForProduction."Account Type"::Unit) THEN BEGIN
                                    DataPieceworkForProduction.VALIDATE(DataPieceworkForProduction."Sales Amount (Base)", GetColDec(11, Text016));
                                    DataPieceworkForProduction.VALIDATE(DataPieceworkForProduction."Unit Price Sale (base)", GetColDec(12, Text017));
                                END;
                            END ELSE
                                DataPieceworkForProduction."Customer Certification Unit" := FALSE;

                            DataPieceworkForProduction.MODIFY(TRUE);

                        END;

                    Text091: //Tipo Texto adicional
                        BEGIN
                            IF DataPieceworkForProduction.GET(CJob, PieceworkCode) THEN BEGIN
                                IF (DataPieceworkForProduction."Production Unit") THEN BEGIN
                                    IF PieceworkInProgressTA <> DataPieceworkForProduction."Piecework Code" THEN
                                        QBText.InsertCostText(Description, QBText.Table::Job, DataPieceworkForProduction."Job No.", DataPieceworkForProduction."Piecework Code", '');
                                END ELSE IF (DataPieceworkForProduction."Customer Certification Unit") THEN BEGIN
                                    IF PieceworkInProgressTA <> DataPieceworkForProduction."Piecework Code" THEN
                                        QBText.InsertSalesText(Description, QBText.Table::Job, DataPieceworkForProduction."Job No.", DataPieceworkForProduction."Piecework Code", '');
                                END;
                            END;
                        END;

                    Text092: //Tipo Descompuesto
                        BEGIN
                            IF DataPieceworkForProduction.GET(CJob, PieceworkCode) THEN BEGIN
                                IF PieceworkInProgressDC <> DataPieceworkForProduction."Piecework Code" THEN BEGIN
                                    DataCostByPiecework.SETRANGE("Job No.", CJob);
                                    DataCostByPiecework.SETRANGE("Piecework Code", DataPieceworkForProduction."Piecework Code");
                                    DataCostByPiecework.SETRANGE("Cod. Budget", CBudget);
                                    IF DataCostByPiecework.FINDFIRST THEN
                                        DataCostByPiecework.DELETEALL(TRUE);
                                    PieceworkInProgressDC := DataPieceworkForProduction."Piecework Code"
                                END;
                                CLEAR(DataCostByPiecework);
                                DataCostByPiecework.VALIDATE("Job No.", CJob);
                                DataCostByPiecework.VALIDATE("Piecework Code", DataPieceworkForProduction."Piecework Code");
                                DataCostByPiecework.VALIDATE("Cod. Budget", CBudget);

                                CASE Type OF
                                    Text018:
                                        DataCostByPiecework.VALIDATE("Cost Type", DataCostByPiecework."Cost Type"::Resource);
                                    Text019:
                                        DataCostByPiecework.VALIDATE("Cost Type", DataCostByPiecework."Cost Type"::Item);
                                    Text020:
                                        DataCostByPiecework.VALIDATE("Cost Type", DataCostByPiecework."Cost Type"::Account);
                                    Text021:
                                        DataCostByPiecework.VALIDATE("Cost Type", DataCostByPiecework."Cost Type"::"Resource Group");
                                END;

                                DataCostByPiecework.VALIDATE("No.", GetColTxt(4, Text022));
                                DataCostByPiecework.INSERT(TRUE);

                                DataCostByPiecework.VALIDATE(DataCostByPiecework."Performance By Piecework", GetColDec(16, Text023));
                                DataCostByPiecework.VALIDATE("Analytical Concept Direct Cost", GetColTxt(17, Text024));
                                DataCostByPiecework.VALIDATE(DataCostByPiecework."Direct Unitary Cost (JC)", GetColDec(18, Text025));
                                DataCostByPiecework.VALIDATE(DataCostByPiecework."Analytical Concept Ind. Cost", GetColTxt(19, Text028));
                                DataCostByPiecework.VALIDATE(DataCostByPiecework."Indirect Unit Cost", GetColDec(20, Text030));
                                DataCostByPiecework.MODIFY;
                            END;
                        END;
                END;
            END;

            trigger OnPostDataItem();
            BEGIN
                Window.CLOSE;
            END;


        }
    }
    requestpage
    {

        layout
        {
            area(content)
            {
                group("group663")
                {

                    CaptionML = ENU = 'Options', ESP = 'Opciones';
                    group("group664")
                    {

                        CaptionML = ENU = 'Import data from:', ESP = 'Importa datos de:';
                        field("FileName"; "FileName")
                        {

                            CaptionML = ENU = 'File Name', ESP = 'Nombre de fichero';
                            Editable = False;

                            ; trigger OnAssistEdit()
                            BEGIN
                                RequestFile;
                                SheetName := ExcelBuffer.SelectSheetsName(ServerFileName);
                            END;


                        }
                        field("SheetName"; "SheetName")
                        {

                            CaptionML = ENU = 'Sheet Name', ESP = 'Nombre de hoja';

                            ; trigger OnAssistEdit()
                            BEGIN
                                IF ServerFileName = '' THEN
                                    RequestFile;

                                SheetName := ExcelBuffer.SelectSheetsName(ServerFileName);
                            END;


                        }
                        field("FirstRowSignificant"; "FirstRowSignificant")
                        {

                            CaptionML = ENU = 'First row with data', ESP = 'Primera fila con datos';
                        }

                    }

                }
                group("group668")
                {

                    CaptionML = ENU = 'Import data from:', ESP = 'Uso de Columnas';
                    field("'A,B,C,D,E,F,G,H,J,K,L'"; 'A,B,C,D,E,F,G,H,J,K,L')
                    {

                        CaptionML = ESP = 'Tipo UO';
                    }
                    field("'A,C,E'"; 'A,C,E')
                    {

                        CaptionML = ESP = 'Tipo TA';
                    }
                    field("'A,C,D,E,P.Q.R.S.T'"; 'A,C,D,E,P.Q.R.S.T')
                    {

                        CaptionML = ESP = 'Tipo DC';
                    }

                }
                group("group672")
                {

                    CaptionML = ENU = 'Import data from:', ESP = 'Columnas';
                    field("'A'"; 'A')
                    {

                        CaptionML = ESP = 'Tipo (UO/TA/DC)';
                    }
                    field("'B'"; 'B')
                    {

                        CaptionML = ESP = 'Tipo (Mayor/Detalle)';
                    }
                    field("'C'"; 'C')
                    {

                        CaptionML = ESP = 'C¢digo U.O.';
                    }
                    field("'D'"; 'D')
                    {

                        CaptionML = ESP = 'C¢digo Descompuesto';
                    }
                    field("'E'"; 'E')
                    {

                        CaptionML = ESP = 'Descripci¢n';
                    }
                    field("'F'"; 'F')
                    {

                        CaptionML = ESP = 'Es unidad de producci¢n';
                    }
                    field("'G'"; 'G')
                    {

                        CaptionML = ESP = 'Es unidad de certificaci¢n';
                    }
                    field("'H'"; 'H')
                    {

                        CaptionML = ESP = 'Medici¢n de coste';
                    }
                    field("'I'"; 'I')
                    {

                        CaptionML = ESP = 'Libre';
                    }
                    field("'J'"; 'J')
                    {

                        CaptionML = ESP = 'Precio de Coste';
                    }
                    field("'K'"; 'K')
                    {

                        CaptionML = ESP = 'Medici¢n de Venta';
                    }
                    field("'L'"; 'L')
                    {

                        CaptionML = ESP = 'Precio de Venta';
                    }
                    field("'M'"; 'M')
                    {

                        CaptionML = ESP = 'Libre';
                    }
                    field("'N'"; 'N')
                    {

                        CaptionML = ESP = 'Libre';
                    }
                    field("'O'"; 'O')
                    {

                        CaptionML = ESP = 'Libre';
                    }
                    field("'P'"; 'P')
                    {

                        CaptionML = ESP = 'Cantidad por U.O.';
                    }
                    field("'Q'"; 'Q')
                    {

                        CaptionML = ESP = 'C.A.';
                    }
                    field("'R'"; 'R')
                    {

                        CaptionML = ESP = 'Precio Coste';
                    }
                    field("'S'"; 'S')
                    {

                        CaptionML = ESP = 'C.A. Indirecto';
                    }
                    field("'T'"; 'T')
                    {

                        CaptionML = ESP = 'Precio Indirecto';
                    }

                }

            }
        }
    }
    labels
    {
    }

    var
        //       ExcelBuffer@7001100 :
        ExcelBuffer: Record 370;
        //       ServerFileName@7001101 :
        ServerFileName: Text;
        //       SheetName@7001102 :
        SheetName: Text[250];
        //       Window@7001103 :
        Window: Dialog;
        //       FileName@7001104 :
        FileName: Text[250];
        //       CJob@7001105 :
        CJob: Code[20];
        //       Text000@7001106 :
        Text000: TextConst ENU = 'Processing:\', ESP = 'Procesando:\';
        //       Text001@7001107 :
        Text001: TextConst ENU = 'File: #4########################################\', ESP = 'Fichero: #4########################################\';
        //       Text002@7001108 :
        Text002: TextConst ENU = 'Sheet:              #1##############################\', ESP = 'Hoja:              #1##############################\';
        //       Text003@7001109 :
        Text003: TextConst ENU = 'Row:                                    #2########\', ESP = 'Fila:                                    #2########\';
        //       Text004@7001110 :
        Text004: TextConst ENU = 'Column:                                 #3########\', ESP = 'Columna:                                 #3########\';
        //       Text005@7001111 :
        Text005: TextConst ENU = 'Data:    #5########################################\', ESP = 'Dato:    #5########################################\';
        //       Job@7001112 :
        Job: Record 167;
        //       Text007@7001114 :
        Text007: TextConst ENU = 'The report has to be released from a budget by piecework', ESP = 'El report tiene que ser lanzado desde un presupuesto por UO';
        //       FirstRowSignificant@7001113 :
        FirstRowSignificant: Integer;
        //       PieceworkInProgressTA@7001115 :
        PieceworkInProgressTA: Code[20];
        //       PieceworkInProgressTAC@7001116 :
        PieceworkInProgressTAC: Code[20];
        //       PieceworkInProgressDC@7001117 :
        PieceworkInProgressDC: Code[20];
        //       AccountLines@7001118 :
        AccountLines: Integer;
        //       AccountLinesC@7001119 :
        AccountLinesC: Integer;
        //       Type@7001121 :
        Type: Text[30];
        //       PieceworkCode@7001122 :
        PieceworkCode: Code[20];
        //       Description@7001123 :
        Description: Text[80];
        //       DataPieceworkForProduction@7001124 :
        DataPieceworkForProduction: Record 7207386;
        //       Text006@1100286007 :
        Text006: TextConst ENU = 'Import file Excel', ESP = 'Importar fich. Excel';
        //       Text029@1100286006 :
        Text029: TextConst ENU = 'You must enter a file name.', ESP = 'Debe introducir un nombre de archivo.';
        //       Text012@1100286005 :
        Text012: TextConst ENU = 'Piecework', ESP = 'UO';
        //       Text091@1100286010 :
        Text091: TextConst ESP = 'TA';
        //       Text092@1100286011 :
        Text092: TextConst ESP = 'DC';
        //       Text090@1100286009 :
        Text090: TextConst ESP = 'HEADING';
        //       Text013@1100286004 :
        Text013: TextConst ENU = 'Heading', ESP = 'MAYOR';
        //       Text018@1100286003 :
        Text018: TextConst ENU = 'Resource', ESP = 'RECURSO';
        //       Text019@1100286002 :
        Text019: TextConst ENU = 'Item', ESP = 'PRODUCTO';
        //       Text020@1100286001 :
        Text020: TextConst ENU = 'Account', ESP = 'CUENTA';
        //       Text021@1100286000 :
        Text021: TextConst ENU = 'Resource Group', ESP = 'FAMILIA';
        //       "--------------- Columnas"@1100286008 :
        "--------------- Columnas": TextConst;
        //       Text008@7001125 :
        Text008: TextConst ENU = 'Data type', ESP = 'Tipo dato';
        //       Text009@7001126 :
        Text009: TextConst ENU = 'Piecework type', ESP = 'Tipo de U.O.';
        //       Text010@7001127 :
        Text010: TextConst ENU = 'Piecework', ESP = 'Unidad de obra';
        //       Text011@7001128 :
        Text011: TextConst ENU = 'Description', ESP = 'Descripci¢n';
        //       Text014@7001135 :
        Text014: TextConst ENU = 'Measure', ESP = 'Medici¢n';
        //       Text015@7001136 :
        Text015: TextConst ENU = 'Production Price', ESP = 'Precio Producci¢n';
        //       Text016@7001137 :
        Text016: TextConst ENU = 'Sales amount to customer', ESP = 'Cantidad venta a cliente';
        //       Text017@7001138 :
        Text017: TextConst ENU = 'Sale price to customer', ESP = 'Precio venta a cliente';
        //       DataCostByPiecework@7001141 :
        DataCostByPiecework: Record 7207387;
        //       CBudget@7001142 :
        CBudget: Code[20];
        //       Text022@7001147 :
        Text022: TextConst ENU = 'Bill of item Code', ESP = 'Cod. descompuesto';
        //       Text023@7001148 :
        Text023: TextConst ENU = 'Quantity per piecework', ESP = 'Cantidad por unidad de obra';
        //       Text024@7001149 :
        Text024: TextConst ENU = 'Direct Analytic Concept', ESP = 'Concepto anal¡tico directo';
        //       Text025@7001152 :
        Text025: TextConst ENU = 'Direct Cost Price', ESP = 'Precio coste directo';
        //       Text028@7001153 :
        Text028: TextConst ENU = 'Indirect Analytic Concept', ESP = 'Concepto analitico indirecto';
        //       Text030@7001154 :
        Text030: TextConst ENU = 'Indirect Cost Price', ESP = 'Precio coste indirecto';
        //       FileManagement@7001155 :
        FileManagement: Codeunit 419;
        //       QBText@100000000 :
        QBText: Record 7206918;



    trigger OnPreReport();
    begin
        ExcelBuffer.LOCKTABLE;
        ExcelBuffer.DELETEALL;
        ReadExcelSheet;

        Window.OPEN(Text000 +
                    Text001 +
                    Text002 +
                    Text003 +
                    Text004 +
                    Text005);

        Window.UPDATE(4, FileName);
        Window.UPDATE(1, SheetName);
    end;



    LOCAL procedure ReadExcelSheet()
    begin
        ExcelBuffer.OpenBook(ServerFileName, SheetName);
        ExcelBuffer.ReadSheet;
    end;

    procedure RequestFile()
    begin
        if FileName <> '' then
            ServerFileName := FileManagement.UploadFile(Text006, FileName)
        else
            ServerFileName := FileManagement.UploadFile(Text006, '.xlsx');

        ValidateServerFileName;
        FileName := FileManagement.GetFileName(ServerFileName);
    end;

    LOCAL procedure ValidateServerFileName()
    begin
        if ServerFileName = '' then begin
            FileName := '';
            SheetName := '';
            ERROR(Text029);
        end;
    end;

    //     procedure ReceiveParameters (PCJob@1100251000 : Code[20];PCBudget@1100000 :
    procedure ReceiveParameters(PCJob: Code[20]; PCBudget: Code[20])
    begin
        CJob := PCJob;
        CBudget := PCBudget;
    end;

    //     LOCAL procedure GetColTxt (nCol@1100286000 : Integer;Text@1100286002 :
    LOCAL procedure GetColTxt(nCol: Integer; Text: Text): Text;
    var
        //       txtAux@1100286001 :
        txtAux: Text;
    begin
        Window.UPDATE(3, nCol);
        Window.UPDATE(5, Text);

        txtAux := '';
        if ExcelBuffer.GET(Filas.Number, 16) then
            txtAux := UPPERCASE(ExcelBuffer."Cell Value as Text");
        txtAux := DELCHR(txtAux, '<>');
        exit(txtAux);
    end;

    //     LOCAL procedure GetColDec (nCol@1100286000 : Integer;Text@1100286002 :
    LOCAL procedure GetColDec(nCol: Integer; Text: Text): Decimal;
    var
        //       decAux@1100286001 :
        decAux: Decimal;
    begin
        if not EVALUATE(decAux, GetColTxt(nCol, Text)) then
            decAux := 0;
        decAux := ROUND(decAux, 0.01);
        exit(decAux);
    end;

    //     LOCAL procedure GetColBol (pCol@1100286000 : Integer;Text@1100286001 :
    LOCAL procedure GetColBol(pCol: Integer; Text: Text): Boolean;
    begin
        if (GetColTxt(pCol, Text) IN ['S', 'Y']) then
            exit(TRUE)
        else
            exit(FALSE);
    end;

    /*begin
    //{
//      JAV 21/10/21: - QB 1.09.22 Se ponen en may£sculas contantes que se comparan condatos leidos y pasados a may£sculas
//    }
    end.
  */

}



