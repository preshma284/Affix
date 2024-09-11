report 7207347 "Adjust Periodic Expenses"
{
  ApplicationArea=All;

  
  
    CaptionML=ENU='Adjust Periodic Expenses',ESP='Ajustar gastos periodificables';
    ProcessingOnly=true;
    
  dataset
{

DataItem("Job";"Job")
{

               DataItemTableView=SORTING("No.");
               

               RequestFilterFields="No.";
DataItem("Data Piecework For Production";"Data Piecework For Production")
{

               DataItemTableView=SORTING("Job No.","Piecework Code")
                                 WHERE("Account Type"=CONST("Unit"));
DataItemLink="Job No."= FIELD("No.") ;
trigger OnPreDataItem();
    BEGIN 
                               //JAV 08/07/19: - Se cambia lo que presenta en la pantalla para que sean datos coherentes
                               NumberRegister := 0;
                               TotalRegister := COUNT;
                               //Q18150
                               PieceworkSetup.GET;
                               //Q18150
                             END;

trigger OnAfterGetRecord();
    VAR
//                                   LDataPieceworkForProduction@7001100 :
                                  LDataPieceworkForProduction: Record 7207386;
//                                   LProdructionProcessed@7001101 :
                                  LProdructionProcessed: Decimal;
//                                   Porce@1100286000 :
                                  Porce: Decimal;
//                                   Records@1100286002 :
                                  Records: Record 7207393;
//                                   Objective@1100286001 :
                                  Objective: Decimal;
                                BEGIN 
                                  //JAV 08/07/19: - Se cambia lo que presenta en la pantalla para que sean datos coherentes
                                  //Window.UPDATE(2, ROUND((NumberRegister/NumberRegister)*10000,1));
                                  NumberRegister +=1;
                                  Window.UPDATE(2, ROUND((NumberRegister/TotalRegister)*10000,1));

                                  IF  NOT "Data Piecework For Production"."Periodic Cost"  THEN
                                    CurrReport.SKIP;

                                  "Data Piecework For Production".SETFILTER("Filter Date",'..%1',DateAllocation);
                                  "Data Piecework For Production".SETRANGE("Budget Filter",Job.GETFILTER("Budget Filter"));
                                  CALCFIELDS("Amount Cost Performed (JC)");
                                  "Data Piecework For Production".SETRANGE("Filter Date");
                                  CALCFIELDS("Amount Cost Budget (JC)");

                                  //Comentarios: Para cambiar la gestion de los indirectos periodificables como un porcentaje sobre la producci¢n realizada BRUTA
                                  //independientemente del estado de tramitacion.
                                  LProdructionProcessed := 0;
                                  LDataPieceworkForProduction.SETRANGE("Job No.",Job."No.");
                                  LDataPieceworkForProduction.SETRANGE("Filter Date",0D,DateAllocation);
                                  LDataPieceworkForProduction.SETRANGE("Account Type",LDataPieceworkForProduction."Account Type"::Unit);
                                  LDataPieceworkForProduction.SETRANGE("Production Unit",TRUE);
                                  IF LDataPieceworkForProduction.FINDSET THEN
                                    REPEAT
                                      LDataPieceworkForProduction.CALCFIELDS("Amount Production Performed");
                                      LProdructionProcessed += ROUND(LDataPieceworkForProduction."Amount Production Performed" * LDataPieceworkForProduction."% Processed Production" / 100,0.01);
                                    UNTIL LDataPieceworkForProduction.NEXT = 0;

                                  // para no generar apuntes a 0
                                  IF (Job."Production Budget Amount" <> 0) THEN BEGIN 
                                    // traigo las cuentas del grupo contable unidad de coste
                                    UnitsPostingGroup.RESET;
                                    UnitsPostingGroup.GET("Data Piecework For Production"."Posting Group Unit Cost");
                                    UnitsPostingGroup.TESTFIELD("Cost Account");
                                    UnitsPostingGroup.TESTFIELD("Cost Analytic Concept");
                                    UnitsPostingGroup.TESTFIELD("Account Per. Applicaction Acc.");

                                    //Calculo del importe
                                    Amount := ROUND("Data Piecework For Production"."Amount Cost Budget (JC)" * LProdructionProcessed / Job."Production Budget Amount",GeneralLedgerSetup."Amount Rounding Precision") -
                                                    "Data Piecework For Production"."Amount Cost Performed (JC)";
                                    //-Q19838 Q18150
                                    Records.GET("Data Piecework For Production"."Job No.","Data Piecework For Production"."No. Record");
                                    ////
                                    IF Records."Record Status" = Records."Record Status"::Approved THEN Objective := PieceworkSetup."Objective % High" / 100;
                                    IF Records."Record Status" = Records."Record Status"::"Technical Approval" THEN Objective := PieceworkSetup."Objective % Medium" / 100;
                                    IF Records."Record Status" = Records."Record Status"::Management THEN Objective := PieceworkSetup."Objective % Low" / 100;


                                    Total := FALSE;
                                    Porce := 0;
                                    IF Job."Production Budget Amount"  <> 0 THEN Porce := LProdructionProcessed / Job."Production Budget Amount";
                                    IF (Porce + 0.01) >= 1 THEN Total := TRUE; // Un 99.99 lo consideramos un 100.
                                    //////////////////////////IF Total THEN Amount := "Data Piecework For Production"."Amount Cost Budget (JC)" - "Data Piecework For Production"."Amount Cost Performed (JC)";
                                    IF Total THEN Amount := ROUND(("Data Piecework For Production"."Amount Cost Budget (JC)" - "Data Piecework For Production"."Amount Cost Performed (JC)") * Objective,0.01);
                                    //+Q19838
                                    //A¤adir las l¡neas  JAV 18/05/22: - QB 1.10.42 Se mejoran los procesos pasando el texto adecuado, se evita c¢digo duplicado
                                    IF (Amount <> 0) THEN BEGIN 
                                      AddLine(+Amount,DateAllocation  ,UnitsPostingGroup."Cost Account"                  , UnitsPostingGroup."Cost Analytic Concept", 'Periodificaci¢n del periodo a origen');
                                      AddLine(-Amount,DateAllocation  ,UnitsPostingGroup."Account Per. Applicaction Acc.", UnitsPostingGroup."Cost Analytic Concept", 'Periodificaci¢n del periodo a origen');
                                      //-Q19838 Q18150
                                      //AddLine(-Amount,DateAllocation+1,UnitsPostingGroup."Cost Account"                  , UnitsPostingGroup."Cost Analytic Concept", 'Deshacer periodificaci¢n del periodo a origen');
                                      //AddLine(+Amount,DateAllocation+1,UnitsPostingGroup."Account Per. Applicaction Acc.", UnitsPostingGroup."Cost Analytic Concept", 'Deshacer periodificaci¢n del periodo a origen');
                                      IF NOT Total THEN AddLine(-Amount,DateAllocation+1,UnitsPostingGroup."Cost Account"                  , UnitsPostingGroup."Cost Analytic Concept", 'Deshacer periodificaci¢n del periodo a origen');
                                      IF NOT Total THEN AddLine(+Amount,DateAllocation+1,UnitsPostingGroup."Account Per. Applicaction Acc.", UnitsPostingGroup."Cost Analytic Concept", 'Deshacer periodificaci¢n del periodo a origen');
                                      //+Q19838
                                    END;
                                  END;
                                END;


}
trigger OnPreDataItem();
    BEGIN 
                               NroJob := 0;
                               TotJob := COUNT;
                               LastJob := '';
                             END;

trigger OnAfterGetRecord();
    BEGIN 
                                  //JAV 08/07/19: - Se cambia lo que presentar en la pantalla para que sean datos coherentes
                                  NroJob += 1;
                                  Window.UPDATE(1, ROUND((NroJob/TotJob)*10000,1));

                                  //JAV 18/05/22: - QB 1.10.42 Si ya existen l¡neas  de ese proyecto, borrar o dar un error
                                  IF (Job."No." <> LastJob) THEN BEGIN 
                                    LastJob := Job."No.";

                                    GenJournalLine.RESET;
                                    GenJournalLine.SETRANGE("Journal Template Name",Book);
                                    GenJournalLine.SETRANGE("Journal Batch Name",Section);
                                    GenJournalLine.SETRANGE("Job No.", Job."No.");
                                    IF (NOT GenJournalLine.ISEMPTY) THEN BEGIN 
                                      IF CONFIRM('Existen l¡neas del proyecto %1, si no se eliminan puede duplicar datos, ¨desea eliminarlas?', TRUE, Job."No.") THEN BEGIN 
                                        GenJournalLine.DELETEALL;
                                      END;
                                    END;
                                  END;

                                  //Para cambiar la gestion de los indirectos periodificables
                                  Job.SETRANGE("Budget Filter",Job."Current Piecework Budget");
                                  Job.CALCFIELDS("Production Budget Amount");
                                  Job.SETRANGE("Posting Date Filter",0D,DateAllocation);
                                  Job.CALCFIELDS("Actual Production Amount");
                                END;


}
}
  requestpage
  {

    layout
{
area(content)
{
group("group572")
{
        
                  CaptionML=ENU='Options',ESP='Opciones';
    field("DateAllocation";"DateAllocation")
    {
        
                  CaptionML=ENU='Register Date',ESP='Fecha registro';
                  
                              ;trigger OnValidate()    BEGIN
                               DateAllocationOnAfterValidate;
                             END;


    }
    field("NumDoc";"NumDoc")
    {
        
                  CaptionML=ENU='Documento No.',ESP='N§ documento';
    }

}

}
}
  }
  labels
{
}
  
    var
//       QuoBuildingSetup@7001100 :
      QuoBuildingSetup: Record 7207278;
//       DataPieceworkForProduction@1100286018 :
      DataPieceworkForProduction: Record 7207386;
//       UnitsPostingGroup@1100286017 :
      UnitsPostingGroup: Record 7207431;
//       GeneralLedgerSetup@1100286016 :
      GeneralLedgerSetup: Record 98;
//       GenJournalTemplate@1100286015 :
      GenJournalTemplate: Record 80;
//       GenJournalLine@1100286014 :
      GenJournalLine: Record 81;
//       FunctionQB@1100286013 :
      FunctionQB: Codeunit 7207272;
//       DimensionManagement@1100286012 :
      DimensionManagement: Codeunit 408;
//       GeneralJournal@1100286011 :
      GeneralJournal: Page 39;
//       Text000@7001103 :
      Text000: TextConst ENU='You must indicate the date of allocation',ESP='Debe indicar la fecha de imputaci¢n';
//       Window@7001106 :
      Window: Dialog;
//       Book@1100286021 :
      Book: Code[20];
//       Section@1100286020 :
      Section: Code[10];
//       SrcCode@1100286019 :
      SrcCode: Code[20];
//       LastJob@1100286022 :
      LastJob: Code[20];
//       NumberRegister@7001110 :
      NumberRegister: Integer;
//       TotalRegister@7001111 :
      TotalRegister: Integer;
//       Text004@7001112 :
      Text004: TextConst ENU='%1 entries have been generated',ESP='Se han generado %1 movimientos, ¨desea verlos?';
//       FirstLine@1100286007 :
      FirstLine: Integer;
//       LastLine@1100286006 :
      LastLine: Integer;
//       Amount@7001116 :
      Amount: Decimal;
//       NroLin@1100286000 :
      NroLin: Integer;
//       Text005@1100286003 :
      Text005: TextConst ENU='You must enter a document number in options',ESP='Debe indicar un n£mero de documento en opciones';
//       Text006@1100286002 :
      Text006: TextConst ENU='Processing delivery note lines \\',ESP='Proyecto @1@@@@@@@@@@@@@@@@@ \\';
//       Text007@1100286001 :
      Text007: TextConst ENU='Generating Entry #1###### from #2###### ',ESP='U.O. @2@@@@@@@@@@@@@@@@@';
//       NroJob@1100286004 :
      NroJob: Integer;
//       TotJob@1100286005 :
      TotJob: Integer;
//       "-------------------------- Opciones"@1100286008 :
      "-------------------------- Opciones": Integer;
//       DateAllocation@1100286009 :
      DateAllocation: Date;
//       NumDoc@1100286010 :
      NumDoc: Code[20];
//       Total@1100286023 :
      Total: Boolean;
//       PieceworkSetup@1100286024 :
      PieceworkSetup: Record 7207279;

    

trigger OnInitReport();    begin
                   QuoBuildingSetup.GET;
                   QuoBuildingSetup.TESTFIELD("Periodic Expense Book");
                   QuoBuildingSetup.TESTFIELD("Periodic Expense Batch Book");

                   Book := QuoBuildingSetup."Periodic Expense Book";
                   Section := QuoBuildingSetup."Periodic Expense Batch Book";
                 end;

trigger OnPreReport();    begin
                  if DateAllocation = 0D then
                    ERROR(Text000);
                  if NumDoc = '' then
                    ERROR(Text005);

                  //JAV 08/07/19: - Se cambia lo que presentar en la pantalla para que sean datos coherentes
                  // Window.OPEN(
                  //          Text006 +
                  //          '@3@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\\'+
                  //          Text007);
                  //NumberRegister := "Data Piecework For Production" .COUNT;
                  //Window.UPDATE(2,NumberRegister);

                  Window.OPEN(Text006 + Text007);
                  NroLin := 0;

                  //JAV 18/05/22: - QB 1.10.42 Calcular el numero de la l¡nea para el diario una sola vez
                  FirstLine := 0;
                  GenJournalLine.RESET;
                  GenJournalLine.SETRANGE("Journal Template Name",Book);
                  GenJournalLine.SETRANGE("Journal Batch Name",Section);
                  if GenJournalLine.FINDLAST then
                    LastLine := GenJournalLine."Line No."
                  else
                    LastLine := 0;

                  // traigo el c¢digo de origen del libro una sola vez
                  GenJournalTemplate.GET(QuoBuildingSetup."Periodic Expense Book");
                  SrcCode := GenJournalTemplate."Source Code";
                end;

trigger OnPostReport();    begin
                   if (NroLin = 0) then
                     MESSAGE('no se han generado l¡neas')
                   else if (CONFIRM(Text004, TRUE, NroLin)) then begin
                     GenJournalLine.RESET;
                     GenJournalLine.FILTERGROUP(2);
                     GenJournalLine.SETFILTER("Journal Template Name",Book);
                     GenJournalLine.SETFILTER("Journal Batch Name",Section);
                     GenJournalLine.SETRANGE("Line No.", FirstLine, LastLine);
                     GenJournalLine.FILTERGROUP(0);

                     COMMIT; // Por el RunModal
                     CLEAR(GeneralJournal);
                     GeneralJournal.SETTABLEVIEW(GenJournalLine);
                     GeneralJournal.SETRECORD(GenJournalLine);
                     GeneralJournal.RUNMODAL;
                   end;
                 end;



// LOCAL procedure AddLine (PAmount@1100286002 : Decimal;PDate@1100286001 : Date;PAccount@1100286000 : Code[10];pCA@1100286004 : Code[20];pDescripcion@1100286003 :
LOCAL procedure AddLine (PAmount: Decimal;PDate: Date;PAccount: Code[10];pCA: Code[20];pDescripcion: Text)
    begin
      //JAV 18/05/22: - QB 1.10.42 Se evita c¢digo duplicado, se cambian las cuatro funcones por una sola
      //-Q19838 Q18150 Para que no grabe l¡neas con coste 0.
      if PAmount = 0 then exit;
      //+Q19838

      NroLin += 1;
      LastLine += 10000;
      if (FirstLine = 0) then
        FirstLine := LastLine;

      GenJournalLine.INIT;
      GenJournalLine.VALIDATE("Journal Template Name",Book);
      GenJournalLine.VALIDATE("Journal Batch Name",Section);
      GenJournalLine.VALIDATE("Line No.", LastLine);
      GenJournalLine.VALIDATE("Account Type",GenJournalLine."Account Type"::"G/L Account");
      GenJournalLine.VALIDATE(GenJournalLine."Account No.",PAccount);
      GenJournalLine.Description := pDescripcion;
      GenJournalLine.VALIDATE("Posting Date",PDate);
      GenJournalLine.VALIDATE("Document Type",GenJournalLine."Document Type"::" ");
      GenJournalLine.VALIDATE("Document No.",NumDoc);
      GenJournalLine.VALIDATE("Currency Code",Job."Currency Code"); //JMMA 251120 a¤adir divisa del proyecto
      GenJournalLine.VALIDATE("Job No.","Data Piecework For Production"."Job No.");
      GenJournalLine.VALIDATE("Piecework Code","Data Piecework For Production"."Piecework Code");
      GenJournalLine.VALIDATE("Already Generated Job Entry",FALSE);
      GenJournalLine.VALIDATE("Gen. Bus. Posting Group",'');
      GenJournalLine.VALIDATE("Gen. Prod. Posting Group",'');
      GenJournalLine.VALIDATE("VAT Bus. Posting Group",'');
      GenJournalLine.VALIDATE("VAT Prod. Posting Group",'');
      GenJournalLine.VALIDATE("Gen. Posting Type",GenJournalLine."Gen. Posting Type"::" ");
      GenJournalLine."VAT %" := 0;
      GenJournalLine.Correction := FALSE;
      GenJournalLine.VALIDATE("Source Code",SrcCode);
      GenJournalLine.VALIDATE(Amount,PAmount);
      GenJournalLine."Job Closure Entry" := TRUE;

      FunctionQB.UpdateDimSet(FunctionQB.ReturnDimCA, pCA, GenJournalLine."Dimension Set ID");
      DimensionManagement.UpdateGlobalDimFromDimSetID(GenJournalLine."Dimension Set ID",GenJournalLine."Shortcut Dimension 1 Code",GenJournalLine."Shortcut Dimension 2 Code");

      GenJournalLine.INSERT;
    end;

    LOCAL procedure DateAllocationOnAfterValidate ()
    begin
      if DateAllocation <> 0D then begin
        DateAllocation := CALCDATE('PM',DateAllocation);
        NumDoc := 'PER_' + FORMAT(DateAllocation, 0, '<Month Text,3>-<Year,2>');
      end;
    end;

    /*begin
    //{
//      JAV 08/07/19: - Se crea un avariable NroLin para que cuente l¡neas reales insertadas
//      JAV 08/07/19: - Se cambia lo que se presenta en la pantalla para que sean datos coherentes
//      JAV 18/05/22: - QB 1.10.42 Se mejoran los procesos, se evita c¢digo duplicado
//      AML 30/06/23: - Q19838 Q18150 Ajustes para el calculo con el 100% de produccion.
//    }
    end.
  */
  
}




