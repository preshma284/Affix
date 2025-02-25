report 7207453 "QPR Import Budget Templ. Excel"
{
  
  
    CaptionML=ENU='Import Budget Excel',ESP='Importar presup. Excel';
    ProcessingOnly=true;
    
  dataset
{

DataItem("Filas";"2000000026")
{

               DataItemTableView=SORTING("Number");
               
                               ;
trigger OnPreDataItem();
    BEGIN 
                               IF CJob = '' THEN
                                 ERROR(Text007);

                               ExcelBuffer.RESET;
                               //Leo el buffer desde la fila que me indiquenque es la primera que tiene datos
                               IF ExcelBuffer.FINDLAST THEN
                                 SETRANGE(Number,FirstRowSignificant,ExcelBuffer."Row No.");

                               PieceworkInProgressTA := '';
                               PieceworkInProgressTAC := '';
                               PieceworkInProgressDC := '';
                               AccountLines := 0;
                               AccountLinesC := 0;
                             END;

trigger OnAfterGetRecord();
    BEGIN 
                                  Window.UPDATE(2,Filas.Number);
                                  QB_QPRCostGroupLine.INIT;
                                  QB_QPRCostGroupLine."Template Code" := CJob;
                                  QB_QPRCostGroupLine.Code := GetColTxt(1);
                                  QB_QPRCostGroupLine.Description := GetColTxt(2);
                                  EVALUATE(QB_QPRCostGroupLine.Indentation,GetColTxt(3));
                                  EVALUATE(QB_QPRCostGroupLine."Account Type",GetColTxt(4));
                                  IF QB_QPRCostGroupLine."Account Type" = QB_QPRCostGroupLine."Account Type"::Heading THEN
                                      QB_QPRCostGroupLine.VALIDATE(Totaling);
                                  EVALUATE(QB_QPRCostGroupLine."QPR Use",GetColTxt(5));
                                  EVALUATE(QB_QPRCostGroupLine."QPR Activable",GetColTxt(6));
                                  EVALUATE(QB_QPRCostGroupLine."QPR Type",GetColTxt(7));
                                  QB_QPRCostGroupLine."QPR No." := GetColTxt(8);
                                  QB_QPRCostGroupLine."QPR Name" := GetColTxt(9);
                                  QB_QPRCostGroupLine."QPR AC" := GetColTxt(10);
                                  QB_QPRCostGroupLine."QPR Gen Prod. Posting Group" := GetColTxt(11);
                                  QB_QPRCostGroupLine."QPR Gen Posting Group" := GetColTxt(12);
                                  QB_QPRCostGroupLine."QPR VAT Prod. Posting Group" := GetColTxt(13);

                                  IF QB_QPRCostGroupLine.INSERT THEN;
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
group("group960")
{
        
                  CaptionML=ENU='Options',ESP='Opciones';
group("group961")
{
        
                  CaptionML=ENU='Import data from:',ESP='Importa datos de:';
    field("FileName";"FileName")
    {
        
                  CaptionML=ENU='File Name',ESP='Nombre de fichero';
                  Editable=False;
                  
                                ;trigger OnAssistEdit()    BEGIN
                                 RequestFile;
                                 SheetName := ExcelBuffer.SelectSheetsName(ServerFileName);
                               END;


    }
    field("SheetName";"SheetName")
    {
        
                  CaptionML=ENU='Sheet Name',ESP='Nombre de hoja';
                  
                                ;trigger OnAssistEdit()    BEGIN
                                 IF ServerFileName = '' THEN
                                   RequestFile;

                                 SheetName := ExcelBuffer.SelectSheetsName(ServerFileName);
                               END;


    }
    field("FirstRowSignificant";"FirstRowSignificant")
    {
        
                  CaptionML=ENU='First row with data',ESP='Primera fila con datos';
    }

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
      Text000: TextConst ENU='Processing:\',ESP='Procesando:\';
//       Text001@7001107 :
      Text001: TextConst ENU='File: #4########################################\',ESP='Fichero: #4########################################\';
//       Text002@7001108 :
      Text002: TextConst ENU='Sheet:              #1##############################\',ESP='Hoja:              #1##############################\';
//       Text003@7001109 :
      Text003: TextConst ENU='Row:                                    #2########\',ESP='Fila:                                    #2########\';
//       Text004@7001110 :
      Text004: TextConst ENU='Column:                                 #3########\',ESP='Columna:                                 #3########\';
//       Text005@7001111 :
      Text005: TextConst ENU='Data:    #5########################################\',ESP='Dato:    #5########################################\';
//       Job@7001112 :
      Job: Record 167;
//       Text007@7001114 :
      Text007: TextConst ENU='The report has to be released from a budget by piecework',ESP='El report tiene que ser lanzado desde un presupuesto por UO';
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
      Text006: TextConst ENU='Import file Excel',ESP='Importar fich. Excel';
//       Text029@1100286006 :
      Text029: TextConst ENU='You must enter a file name.',ESP='Debe introducir un nombre de archivo.';
//       Text012@1100286005 :
      Text012: TextConst ENU='Piecework',ESP='UO';
//       Text091@1100286010 :
      Text091: TextConst ESP='TA';
//       Text092@1100286011 :
      Text092: TextConst ESP='DC';
//       Text090@1100286009 :
      Text090: TextConst ESP='HEADING';
//       Text013@1100286004 :
      Text013: TextConst ENU='Heading',ESP='MAYOR';
//       Text018@1100286003 :
      Text018: TextConst ENU='Resource',ESP='RECURSO';
//       Text019@1100286002 :
      Text019: TextConst ENU='Item',ESP='PRODUCTO';
//       Text020@1100286001 :
      Text020: TextConst ENU='Account',ESP='CUENTA';
//       Text021@1100286000 :
      Text021: TextConst ENU='Resource Group',ESP='FAMILIA';
//       "--------------- Columnas"@1100286008 :
      "--------------- Columnas": TextConst;
//       Text008@7001125 :
      Text008: TextConst ENU='Data type',ESP='Tipo dato';
//       Text009@7001126 :
      Text009: TextConst ENU='Piecework type',ESP='Tipo de U.O.';
//       Text010@7001127 :
      Text010: TextConst ENU='Piecework',ESP='Unidad de obra';
//       Text011@7001128 :
      Text011: TextConst ENU='Description',ESP='Descripci¢n';
//       Text014@7001135 :
      Text014: TextConst ENU='Measure',ESP='Medici¢n';
//       Text015@7001136 :
      Text015: TextConst ENU='Production Price',ESP='Precio Producci¢n';
//       Text016@7001137 :
      Text016: TextConst ENU='Sales amount to customer',ESP='Cantidad venta a cliente';
//       Text017@7001138 :
      Text017: TextConst ENU='Sale price to customer',ESP='Precio venta a cliente';
//       DataCostByPiecework@7001141 :
      DataCostByPiecework: Record 7207387;
//       CBudget@7001142 :
      CBudget: Code[20];
//       Text022@7001147 :
      Text022: TextConst ENU='Bill of item Code',ESP='Cod. descompuesto';
//       Text023@7001148 :
      Text023: TextConst ENU='Quantity per piecework',ESP='Cantidad por unidad de obra';
//       Text024@7001149 :
      Text024: TextConst ENU='Direct Analytic Concept',ESP='Concepto anal¡tico directo';
//       Text025@7001152 :
      Text025: TextConst ENU='Direct Cost Price',ESP='Precio coste directo';
//       Text028@7001153 :
      Text028: TextConst ENU='Indirect Analytic Concept',ESP='Concepto analitico indirecto';
//       Text030@7001154 :
      Text030: TextConst ENU='Indirect Cost Price',ESP='Precio coste indirecto';
//       FileManagement@7001155 :
      FileManagement: Codeunit 419;
//       QBText@100000000 :
      QBText: Record 7206918;
//       QB_QPRCostGroupLine@1100286012 :
      QB_QPRCostGroupLine: Record 7206981;

    

trigger OnInitReport();    begin
                   FirstRowSignificant := 4;
                 end;

trigger OnPreReport();    begin
                  ExcelBuffer.LOCKTABLE;
                  ExcelBuffer.DELETEALL;
                  ReadExcelSheet;

                  Window.OPEN(Text000 +
                              Text001 +
                              Text002 +
                              Text003 +
                              Text004 +
                              Text005);

                  Window.UPDATE(4,FileName);
                  Window.UPDATE(1,SheetName);
                end;



LOCAL procedure ReadExcelSheet ()
    begin
      ExcelBuffer.OpenBook(ServerFileName,SheetName);
      ExcelBuffer.ReadSheet;
    end;

    procedure RequestFile ()
    begin
      if FileName <> '' then
        ServerFileName := FileManagement.UploadFile(Text006,FileName)
      else
        ServerFileName := FileManagement.UploadFile(Text006,'.xlsx');

      ValidateServerFileName;
      FileName := FileManagement.GetFileName(ServerFileName);
    end;

    LOCAL procedure ValidateServerFileName ()
    begin
      if ServerFileName = '' then begin
        FileName := '';
        SheetName := '';
        ERROR(Text029);
      end;
    end;

//     procedure SetParameters (PCJob@1100251000 :
    procedure SetParameters (PCJob: Code[20])
    begin
      CJob := PCJob;
    end;

//     LOCAL procedure GetColTxt (nCol@1100286000 :
    LOCAL procedure GetColTxt (nCol: Integer) : Text;
    var
//       txtAux@1100286001 :
      txtAux: Text;
    begin
      Window.UPDATE(3,nCol);

      txtAux := '';
      //if ExcelBuffer.GET(Filas.Number,16) then
      if ExcelBuffer.GET(Filas.Number,nCol) then
        txtAux := UPPERCASE(ExcelBuffer."Cell Value as Text");
      txtAux := DELCHR(txtAux,'<>');
      exit(txtAux);
    end;

//     LOCAL procedure GetColDec (nCol@1100286000 :
    LOCAL procedure GetColDec (nCol: Integer) : Decimal;
    var
//       decAux@1100286001 :
      decAux: Decimal;
    begin
      if not EVALUATE(decAux,GetColTxt(nCol)) then
        decAux := 0;
      decAux := ROUND(decAux,0.01);
      exit(decAux);
    end;

//     LOCAL procedure GetColBol (pCol@1100286000 :
    LOCAL procedure GetColBol (pCol: Integer) : Boolean;
    begin
      if (GetColTxt(pCol) IN ['S', 'Y']) then
        exit(TRUE)
      else
        exit(FALSE);
    end;

    /*begin
    //{
//      JAV 08/04/22: - QB 1.10.32 Se mejoran las plantillas de presupuestos, se cambian nombres y captios, se a¤ade activable
//    }
    end.
  */
  
}



