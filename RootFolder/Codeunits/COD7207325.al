Codeunit 7207325 "Reg. Regul. Stock (s/n)"
{
  
  
    TableNo=7207408;
    trigger OnRun()
BEGIN
            HeaderRegularizationStock.COPY(Rec);
            //-16245
            HeaderRegularizationStock.SETFILTER("No.",Rec."No.");
            //+16245
            Code;
            Rec := HeaderRegularizationStock;
          END;
    VAR
      HeaderRegularizationStock : Record 7207408;
      Text001 : TextConst ENU='Are you sure you want to register document %1?',ESP='�Confirma que desea registrar el documento %1?';
      HeaderRegularizationStock2 : Record 7207408;

    PROCEDURE Code();
    BEGIN

      WITH HeaderRegularizationStock DO BEGIN
        IF NOT CONFIRM(Text001,FALSE,"No.") THEN  // VG
          EXIT;
        //HeaderRegularizationStock2.SETRANGE(HeaderRegularizationStock2."No.","No.");
        // REPORT.RUNMODAL(REPORT::"Create Ship. Output Regular.",FALSE,TRUE,HeaderRegularizationStock);
      END;
    END;

    /*BEGIN
/*{
      16245 DGG 280122 - Correccion para que registre solo la cabecera que se est� gestionando.
    }
END.*/
}







