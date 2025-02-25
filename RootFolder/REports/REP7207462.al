report 7207462 "QB Gen.Ledger Entry Set Origin"
{
  
  
    Permissions=TableData 17=rm;
    CaptionML=ENU='Informa origen y nombre',ESP='Informa origen y nombre';
    ProcessingOnly=true;
  
  dataset
{

DataItem("G/L Entry";"G/L Entry")
{

               DataItemTableView=;
               
                               ;
trigger OnPreDataItem();
    BEGIN 
                               Windows.OPEN(Text001);
                             END;

trigger OnAfterGetRecord();
    BEGIN 
                                  IF NOT(AreFieldsEmpty) THEN
                                    CurrReport.SKIP;

                                  CLEAR(pRcptHead);
                                  CLEAR(pInvHead);
                                  CLEAR(pCrMemoHead);
                                  IF FindInvoice THEN BEGIN 
                                    IF ("G/L Entry"."Source Type"=0) THEN
                                      "G/L Entry".VALIDATE("Source Type", "G/L Entry"."Source Type"::Vendor);
                                    IF ("G/L Entry"."Source No."='') THEN
                                      "G/L Entry".VALIDATE("Source No.", pInvHead."Buy-from Vendor No.");
                                    "G/L Entry".MODIFY;
                                  END ELSE
                                    IF FindCrMemo THEN BEGIN 
                                      IF ("G/L Entry"."Source Type"=0) THEN
                                        "G/L Entry".VALIDATE("Source Type", "G/L Entry"."Source Type"::Vendor);
                                      IF ("G/L Entry"."Source No."='') THEN
                                        "G/L Entry".VALIDATE("Source No.", pCrMemoHead."Buy-from Vendor No.");
                                      "G/L Entry".MODIFY;
                                    END ELSE
                                      IF FindReceipt THEN BEGIN 
                                        IF ("G/L Entry"."Source Type"=0) THEN
                                          "G/L Entry".VALIDATE("Source Type", "G/L Entry"."Source Type"::Vendor);
                                        IF ("G/L Entry"."Source No."='') THEN
                                          "G/L Entry".VALIDATE("Source No.", pRcptHead."Buy-from Vendor No.");
                                        "G/L Entry".MODIFY;
                                      END;
                                END;

trigger OnPostDataItem();
    BEGIN 
                                Windows.CLOSE;
                                MESSAGE(Text002);
                              END;


}
}
  requestpage
  {

    layout
{
}
  }
  labels
{
}
  
    var
//       Text001@1000000000 :
      Text001: TextConst ENU='Procesando movs...... Espere, por favor.',ESP='Procesando movs...... Espere, por favor.';
//       Text002@1000000001 :
      Text002: TextConst ENU='end process.',ESP='Proceso finalizado.';
//       Windows@1000000002 :
      Windows: Dialog;
//       pRcptHead@1000000003 :
      pRcptHead: Record 120;
//       pInvHead@1000000004 :
      pInvHead: Record 122;
//       pCrMemoHead@1100286000 :
      pCrMemoHead: Record 124;

    LOCAL procedure AreFieldsEmpty () Empty : Boolean;
    begin
      if ("G/L Entry"."Source Type"=0)
      or ("G/L Entry"."Source No."='') then
        Empty := TRUE;

      exit(Empty);
    end;

    LOCAL procedure FindInvoice () HaveInv : Boolean;
    begin
      pInvHead.RESET;
      pInvHead.SETRANGE("No.", "G/L Entry"."Document No.");
      pInvHead.SETRANGE("Posting Date", "G/L Entry"."Posting Date");
      if pInvHead.FINDSET then
        HaveInv := TRUE;

      exit(HaveInv);
    end;

    LOCAL procedure FindReceipt () HaveRcpt : Boolean;
    begin
      pRcptHead.RESET;
      pRcptHead.SETRANGE("No.", "G/L Entry"."Document No.");
      //pRcptHead.SETRANGE("Posting Date", "G/L Entry"."Posting Date");
      //los albaranes se Desprovisionan en otra fecha.
      if pRcptHead.FINDSET then
        HaveRcpt := TRUE;

      exit(HaveRcpt);
    end;

    LOCAL procedure FindCrMemo () HaveCrMemo : Boolean;
    begin
      pCrMemoHead.RESET;
      pCrMemoHead.SETRANGE("No.", "G/L Entry"."Document No.");
      pCrMemoHead.SETRANGE("Posting Date", "G/L Entry"."Posting Date");
      if pCrMemoHead.FINDSET then
        HaveCrMemo := TRUE;

      exit(HaveCrMemo);
    end;

    /*begin
    //{
//      Q17975 CSM 15/09/2022 Í Informar Origen.
//    }
    end.
  */
  
}



