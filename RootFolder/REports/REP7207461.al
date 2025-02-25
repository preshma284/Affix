report 7207461 "QB Job Ledged Entry Set Origin"
{
  
  
    Permissions=TableData 169=rm;
    CaptionML=ENU='Informa origen y nombre',ESP='Informa origen y nombre';
    ProcessingOnly=true;
  
  dataset
{

DataItem("Job Ledger Entry";"Job Ledger Entry")
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
                                    IF ("Job Ledger Entry"."Source Type"=0) THEN
                                      "Job Ledger Entry".VALIDATE("Source Type", "Job Ledger Entry"."Source Type"::Vendor);
                                    IF ("Job Ledger Entry"."Source Document Type"=0) THEN
                                      "Job Ledger Entry".VALIDATE("Source Document Type", "Job Ledger Entry"."Source Document Type"::Invoice);
                                    IF ("Job Ledger Entry"."Source No."='') THEN
                                      "Job Ledger Entry".VALIDATE("Source No.", pInvHead."Buy-from Vendor No.");
                                    IF ("Job Ledger Entry"."Source Name"='') THEN
                                      "Job Ledger Entry".VALIDATE("Source Name", pInvHead."Buy-from Vendor Name");
                                    "Job Ledger Entry".MODIFY;
                                  END ELSE
                                    IF FindCrMemo THEN BEGIN 
                                      IF ("Job Ledger Entry"."Source Type"=0) THEN
                                        "Job Ledger Entry".VALIDATE("Source Type", "Job Ledger Entry"."Source Type"::Vendor);
                                      IF ("Job Ledger Entry"."Source Document Type"=0) THEN
                                        "Job Ledger Entry".VALIDATE("Source Document Type", "Job Ledger Entry"."Source Document Type"::"Credit Memo");
                                      IF ("Job Ledger Entry"."Source No."='') THEN
                                        "Job Ledger Entry".VALIDATE("Source No.", pCrMemoHead."Buy-from Vendor No.");
                                      IF ("Job Ledger Entry"."Source Name"='') THEN
                                        "Job Ledger Entry".VALIDATE("Source Name", pCrMemoHead."Buy-from Vendor Name");
                                      "Job Ledger Entry".MODIFY;
                                    END ELSE
                                      IF FindReceipt THEN BEGIN 
                                        IF ("Job Ledger Entry"."Source Type"=0) THEN
                                          "Job Ledger Entry".VALIDATE("Source Type", "Job Ledger Entry"."Source Type"::Vendor);
                                        IF ("Job Ledger Entry"."Source Document Type"=0) THEN
                                          "Job Ledger Entry".VALIDATE("Source Document Type", "Job Ledger Entry"."Source Document Type"::Shipping);
                                        IF ("Job Ledger Entry"."Source No."='') THEN
                                          "Job Ledger Entry".VALIDATE("Source No.", pRcptHead."Buy-from Vendor No.");
                                        IF ("Job Ledger Entry"."Source Name"='') THEN
                                          "Job Ledger Entry".VALIDATE("Source Name", pRcptHead."Buy-from Vendor Name");
                                        "Job Ledger Entry".MODIFY;
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
      if ("Job Ledger Entry"."Source Type"=0)
      or ("Job Ledger Entry"."Source Document Type"=0)
      or ("Job Ledger Entry"."Source No."='')
      or ("Job Ledger Entry"."Source Name"='') then
        Empty := TRUE;

      exit(Empty);
    end;

    LOCAL procedure FindInvoice () HaveInv : Boolean;
    begin
      pInvHead.RESET;
      pInvHead.SETRANGE("No.", "Job Ledger Entry"."Document No.");
      pInvHead.SETRANGE("Posting Date", "Job Ledger Entry"."Posting Date");
      if pInvHead.FINDSET then
        HaveInv := TRUE;

      exit(HaveInv);
    end;

    LOCAL procedure FindReceipt () HaveRcpt : Boolean;
    begin
      pRcptHead.RESET;
      pRcptHead.SETRANGE("No.", "Job Ledger Entry"."Document No.");
      pRcptHead.SETRANGE("Posting Date", "Job Ledger Entry"."Posting Date");
      if pRcptHead.FINDSET then
        HaveRcpt := TRUE;

      exit(HaveRcpt);
    end;

    LOCAL procedure FindCrMemo () HaveCrMemo : Boolean;
    begin
      pCrMemoHead.RESET;
      pCrMemoHead.SETRANGE("No.", "Job Ledger Entry"."Document No.");
      pCrMemoHead.SETRANGE("Posting Date", "Job Ledger Entry"."Posting Date");
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



