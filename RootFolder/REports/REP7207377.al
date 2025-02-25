report 7207377 "Released Vendor Deferred VAT"
{
  ApplicationArea=All;

  
  
    Permissions=TableData 254=rim,
                TableData 45=rm;
    CaptionML=ENU='Released Vendor Deferred VAT',ESP='Liberar IVA diferido proveedor';
    ProcessingOnly=true;
    
  dataset
{

DataItem("VAT Entry";"VAT Entry")
{

               DataItemTableView=SORTING("Entry No.");
               
                                 ;
trigger OnPreDataItem();
    BEGIN 
                               "VAT Entry".SETRANGE("Document No.", DocumentNo);
                               "VAT Entry".SETFILTER(Base, '=0');
                               "VAT Entry".SETFILTER("Remaining Unrealized Base", '<>0');
                               IF ("VAT Entry".COUNT <> 1) THEN
                                 ERROR('Debe indicar un �nico documento v�lido.');
                             END;

trigger OnAfterGetRecord();
    BEGIN 


                                  IF Base <> 0 THEN
                                    ERROR(Text50002);

                                  //Creaci�n del nuevo registro
                                  VATEntry.INIT;
                                  VATEntry.TRANSFERFIELDS("VAT Entry");
                                  VATEntry.Base := "Remaining Unrealized Base";
                                  VATEntry.Amount := "Remaining Unrealized Amount";
                                  VATEntry."Unrealized Amount" := 0;
                                  VATEntry."Unrealized Base" := 0;
                                  VATEntry."Remaining Unrealized Base" := 0;
                                  VATEntry."Remaining Unrealized Amount" := 0;
                                  VATEntry."Additional-Currency Amount" := "Add.-Curr. Rem. Unreal. Amount";
                                  VATEntry."Additional-Currency Base" := "Add.-Curr. Rem. Unreal. Base";
                                  VATEntry."Add.-Currency Unrealized Amt." := 0;
                                  VATEntry."Add.-Currency Unrealized Base" := 0;
                                  VATEntry."Add.-Curr. Rem. Unreal. Amount" := 0;
                                  VATEntry."Add.-Curr. Rem. Unreal. Base" := 0;
                                  VATEntry.Closed := FALSE;
                                  VATEntry."VAT Bus. Posting Group" := "VAT Bus. Posting Group";
                                  VATEntry."VAT Prod. Posting Group" := "VAT Prod. Posting Group";
                                  VATEntry."Posting Date" := DateReg;
                                  VATEntry."Gen. Bus. Posting Group":="Gen. Bus. Posting Group";
                                  VATEntry."Gen. Prod. Posting Group":="Gen. Prod. Posting Group";
                                  VATEntry."Unrealized VAT Entry No.":="Entry No.";
                                  VATEntry."Document Type":=VATEntry."Document Type"::Payment;
                                  VATEntry2.RESET;
                                  IF VATEntry2.FINDLAST THEN
                                    VATEntry."Entry No.":=VATEntry2."Entry No." + 1;
                                  VATEntry.INSERT(TRUE);

                                  // Modificacion del registro actual
                                  "Remaining Unrealized Base" := 0;
                                  "Remaining Unrealized Amount" := 0;
                                  MODIFY;

                                  IF NOT VATPostingSetup.GET("VAT Bus. Posting Group","VAT Prod. Posting Group") THEN
                                     ERROR(Text50004,"VAT Bus. Posting Group","VAT Prod. Posting Group");

                                  GenJournalLine.INIT;
                                  GenJournalLine.SETCURRENTKEY(GenJournalLine."Journal Template Name",
                                                                 GenJournalLine."Journal Batch Name",
                                                                 GenJournalLine."Line No.");
                                  GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
                                  GenJournalLine."Posting Date" := DateReg;
                                  GenJournalLine."Document No." := "Document No.";
                                  GenJournalLine.VALIDATE("Account No." ,VATPostingSetup."Purch. VAT Unreal. Account");
                                  GenJournalLine.Description := Text000;

                                  IF VATEntry.Amount < 0 THEN BEGIN 
                                     Amount := VATEntry.Amount * (-1);
                                     GenJournalLine."Debit Amount" := Amount;
                                     GenJournalLine."Credit Amount" :=0;
                                     GenJournalLine.Amount := Amount;
                                     GenJournalLine."Amount (LCY)" := Amount;
                                     GenJournalLine."Balance (LCY)" := Amount;
                                     END ELSE BEGIN 
                                     Amount:=VATEntry.Amount;
                                     GenJournalLine."Debit Amount" :=0;
                                     GenJournalLine."Credit Amount" :=Amount;
                                     GenJournalLine.Amount := -Amount;
                                     GenJournalLine."Amount (LCY)" := -Amount;
                                     GenJournalLine."Balance (LCY)" := -Amount;
                                  END;

                                  GenJournalLine."Due Date" := DateReg;
                                  CLEAR(GenJournalLine."Gen. Bus. Posting Group");
                                  CLEAR(GenJournalLine."Gen. Prod. Posting Group");
                                  CLEAR(GenJournalLine."Bal. Gen. Bus. Posting Group");
                                  CLEAR(GenJournalLine."Bal. Gen. Prod. Posting Group");
                                  CLEAR(GenJournalLine."Account Type");
                                  CLEAR(GenJournalLine."Document Type");
                                  CLEAR(GenJournalLine."Gen. Posting Type");


                                  DefaultDimension.SETRANGE("Table ID",DATABASE::"G/L Account");
                                  DefaultDimension.SETRANGE("No.",VATPostingSetup."Purch. VAT Unreal. Account");
                                  DefaultDimension.SETFILTER("Dimension Value Code",'<>%1','');
                                  IF DefaultDimension.FINDFIRST THEN
                                    REPEAT
                                      FunctionQB.UpdateDimSet(DefaultDimension."No.",DefaultDimension."Dimension Value Code",GenJournalLine."Dimension Set ID");
                                      DimensionManagement.UpdateGlobalDimFromDimSetID(GenJournalLine."Dimension Set ID",GenJournalLine."Shortcut Dimension 1 Code",GenJournalLine."Shortcut Dimension 2 Code");
                                    UNTIL DefaultDimension.NEXT = 0;

                                  GenJnlPostLine.RunWithCheck(GenJournalLine);


                                  // Contrapartida
                                  GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
                                  GenJournalLine."Posting Date" := DateReg;
                                  GenJournalLine."Document No." :="Document No.";
                                  GenJournalLine.VALIDATE("Account No." ,VATPostingSetup."Purchase VAT Account");
                                  GenJournalLine.Description := Text000;
                                  IF VATEntry.Amount<0 THEN BEGIN 
                                     Amount:=VATEntry.Amount*(-1);
                                     GenJournalLine."Debit Amount" :=0;
                                     GenJournalLine."Credit Amount" :=Amount;
                                     GenJournalLine.Amount := -Amount;
                                     GenJournalLine."Amount (LCY)" := -Amount;
                                     GenJournalLine."Balance (LCY)" := -Amount;
                                     END ELSE BEGIN 
                                     Amount:=VATEntry.Amount;
                                     GenJournalLine."Debit Amount" :=Amount;
                                     GenJournalLine."Credit Amount" :=0;
                                     GenJournalLine.Amount := Amount;
                                     GenJournalLine."Amount (LCY)" := Amount;
                                     GenJournalLine."Balance (LCY)" := Amount;
                                  END;
                                  GenJournalLine."Due Date" := DateReg;
                                  CLEAR(GenJournalLine."Gen. Bus. Posting Group");
                                  CLEAR(GenJournalLine."Gen. Prod. Posting Group");
                                  CLEAR(GenJournalLine."Bal. Gen. Bus. Posting Group");
                                  CLEAR(GenJournalLine."Bal. Gen. Prod. Posting Group");
                                  CLEAR(GenJournalLine."Account Type");
                                  CLEAR(GenJournalLine."Document Type");
                                  CLEAR(GenJournalLine."Gen. Posting Type");

                                  DefaultDimension.SETRANGE("Table ID",DATABASE::"G/L Account");
                                  DefaultDimension.SETRANGE("No.",VATPostingSetup."Purchase VAT Account");
                                  DefaultDimension.SETFILTER("Dimension Value Code",'<>%1','');
                                  IF DefaultDimension.FIND('-') THEN
                                    REPEAT
                                      FunctionQB.UpdateDimSet(DefaultDimension."No.",DefaultDimension."Dimension Value Code",GenJournalLine."Dimension Set ID");
                                      DimensionManagement.UpdateGlobalDimFromDimSetID(GenJournalLine."Dimension Set ID",GenJournalLine."Shortcut Dimension 1 Code",GenJournalLine."Shortcut Dimension 2 Code");
                                    UNTIL DefaultDimension.NEXT = 0;

                                  GenJnlPostLine.RunWithCheck(GenJournalLine);

                                  IF GLRegister.FINDLAST THEN BEGIN 
                                    GLRegister."From VAT Entry No." := VATEntry."Entry No.";
                                    GLRegister."To VAT Entry No." := VATEntry."Entry No.";
                                    GLRegister.MODIFY;
                                  END;

                                  VATEntry."Transaction No.":= GLRegister."No.";
                                  VATEntry.MODIFY;
                                END;


}
}
  requestpage
  {

    layout
{
area(content)
{
group("group694")
{
        
                  CaptionML=ENU='Options',ESP='Opciones';
    field("DateReg";"DateReg")
    {
        
                  CaptionML=ENU='Posting Date',ESP='Fecha registro';
    }
    field("DocumentNo";"DocumentNo")
    {
        
                  CaptionML=ESP='Nro Documento';
                  
                              

    ;trigger OnValidate()    BEGIN
                               VATEntry.RESET;
                               VATEntry.SETRANGE("Document No.", DocumentNo);
                               //PSM 17/09/21>>
                               VATEntry.SETRANGE(Type, VATEntry.Type::Purchase);
                               //VATEntry.SETRANGE(Type, VATEntry.Type::Sale);
                               //PSM 17/09/21<<
                               VATEntry.SETFILTER("Remaining Unrealized Base", '<>0');
                               IF VATEntry.ISEMPTY THEN
                                 ERROR('No existe ese documento con IVA diferido pendiente');
                               IF (VATEntry.COUNT <> 1) THEN
                                 ERROR('Hay mas de un documento de IVA diferido posible, no se puede liberar');
                             END;


    }

}

}
}
  }
  labels
{
}
  
    var
//       Text50001@7001101 :
      Text50001: TextConst ENU='Do you confirm that you want to make the VAT entry made?',ESP='�Confirma que desea realizar el asiento de IVA Realizado?';
//       Text50002@7001100 :
      Text50002: TextConst ENU='Document number is not VAT not done?',ESP='�N� de Documento no es de IVA no Realizado?';
//       VATEntry@7001102 :
      VATEntry: Record 254;
//       VATEntry2@7001104 :
      VATEntry2: Record 254;
//       VATPostingSetup@7001105 :
      VATPostingSetup: Record 325;
//       Text50004@7001106 :
      Text50004: TextConst ENU='There is no combination of accounting group configuration: %1, %2',ESP='No existe combinacion de configuracion de grupos contables : %1,%2';
//       GenJournalLine@7001107 :
      GenJournalLine: Record 81;
//       Text000@7001108 :
      Text000: TextConst ENU='VAT Release Provider',ESP='Liberaci�n de IVA de proveedor';
//       DefaultDimension@7001110 :
      DefaultDimension: Record 352;
//       GLRegister@7001114 :
      GLRegister: Record 45;
//       FunctionQB@1100286004 :
      FunctionQB: Codeunit 7207272;
//       DimensionManagement@1100286003 :
      DimensionManagement: Codeunit 408;
//       GenJnlPostLine@1100286002 :
      GenJnlPostLine: Codeunit 12;
//       DateReg@1100286001 :
      DateReg: Date;
//       Amount@1100286000 :
      Amount: Decimal;
//       DocumentNo@1100286005 :
      DocumentNo: Code[20];

    

trigger OnInitReport();    begin
                   DateReg := WORKDATE;
                 end;

trigger OnPreReport();    begin
                  // Controles de Verificaci�n.
                  if (DocumentNo = '') then
                    ERROR('No ha indicado el documento');

                  if not CONFIRM(Text50001,FALSE) then
                    exit;
                end;



/*begin
    {
      PSM 17/09/21: Se cambia el filtro del "Tipo de documento" en la pantalla
    }
    end.
  */
  
}




