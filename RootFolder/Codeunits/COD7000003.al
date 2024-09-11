Codeunit 50034 "BG/PO-Post and Print 1"
{
  
  
    Permissions=TableData 7000005=rm,
                TableData 7000006=rm,
                TableData 7000007=rm,
                TableData 7000020=rm,
                TableData 7000021=rm,
                TableData 7000022=rm;
    trigger OnRun()
BEGIN
          END;
    VAR
      Text1100000 : TextConst ENU='This Bill Group has not been printed. Do you want to continue?',ESP='La remesa no se ha impreso. �Confirma que desea continuar?';
      Text1100001 : TextConst ENU='The posting process has been cancelled by the user.',ESP='El proceso de registro ha sido cancelado por el usuario.';
      Text1100002 : TextConst ENU='Do you want to post the Bill Group?',ESP='�Confirma que desea registrar la remesa?';
      Text1100003 : TextConst ENU='This Payment Order has not been printed. Do you want to continue?',ESP='La orden pago no se ha impreso. �Confirma que desea continuar?';
      Text1100004 : TextConst ENU='Do you want to post the Payment Order?',ESP='�Confirma que desea registrar la orden de pago?';
      CarteraReportSelection : Record 7000013;
      "---------------------------------- QB" : Integer;
      ApprovalsMgmt : Codeunit 7206927;

    // PROCEDURE ReceivablePostOnly(BillGr : Record 7000005);
    // BEGIN
    //   IF BillGr."No. Printed" = 0 THEN BEGIN
    //     IF NOT
    //        CONFIRM(
    //          Text1100000)
    //     THEN
    //       ERROR(Text1100001);
    //   END ELSE
    //     IF NOT
    //        CONFIRM(
    //          Text1100002,FALSE)
    //     THEN
    //       ERROR(Text1100001);

    //   BillGr.SETRECFILTER;
    //   // REPORT.RUNMODAL(REPORT::"Post Bill Group",
    //   //   BillGr."Dealing Type" = BillGr."Dealing Type"::Discount,
    //   //   FALSE,
    //   //   BillGr);
    // END;

    // PROCEDURE ReceivablePostAndPrint(BillGr : Record 7000005);
    // VAR
    //   PostedBillGr : Record 7000006;
    // BEGIN
    //   BillGr.SETRECFILTER;
    //   // REPORT.RUNMODAL(REPORT::"Post Bill Group",
    //   //   BillGr."Dealing Type" = BillGr."Dealing Type"::Discount,
    //   //   FALSE,
    //   //   BillGr);

    //   COMMIT;

    //   IF PostedBillGr.GET(BillGr."No.") THEN BEGIN
    //     PostedBillGr.SETRECFILTER;
    //     CarteraReportSelection.RESET;
    //     CarteraReportSelection.SETRANGE(Usage,CarteraReportSelection.Usage::"Posted Bill Group");
    //     CarteraReportSelection.FIND('-');
    //     REPEAT
    //       CarteraReportSelection.TESTFIELD("Report ID");
    //       REPORT.RUN(CarteraReportSelection."Report ID",FALSE,FALSE,PostedBillGr);
    //     UNTIL CarteraReportSelection.NEXT = 0;
    //   END;
    // END;

    PROCEDURE PayablePostOnly(PmtOrd : Record 7000020);
    BEGIN
      //JAV 23/10/20: - QB 1.07.00 Verificar las aprobaciones
      ApprovalsMgmt.PrePostApprovalCheck(PmtOrd);

      IF PmtOrd."No. Printed" = 0 THEN BEGIN
        IF NOT
           CONFIRM(
             Text1100003)
        THEN
          ERROR(Text1100001);
      END ELSE
        IF NOT
           CONFIRM(
             Text1100004,FALSE)
        THEN
          ERROR(Text1100001);

      PmtOrd.SETRECFILTER;
      REPORT.RUNMODAL(REPORT::"Post Payment Order",FALSE,FALSE,PmtOrd);
    END;

    PROCEDURE PayablePostAndPrint(PmtOrd : Record 7000020);
    VAR
      PostedPmtOrd : Record 7000021;
    BEGIN
      //JAV 23/10/20: - QB 1.07.00 Verificar las aprobaciones
      ApprovalsMgmt.PrePostApprovalCheck(PmtOrd);

      PmtOrd.SETRECFILTER;
      REPORT.RUNMODAL(REPORT::"Post Payment Order",FALSE,FALSE,PmtOrd);

      COMMIT;

      IF PostedPmtOrd.GET(PmtOrd."No.") THEN BEGIN
        PostedPmtOrd.SETRECFILTER;
        CarteraReportSelection.RESET;
        CarteraReportSelection.SETRANGE(Usage,CarteraReportSelection.Usage::"Posted Payment Order");
        CarteraReportSelection.FIND('-');
        REPEAT
          CarteraReportSelection.TESTFIELD("Report ID");
          REPORT.RUN(CarteraReportSelection."Report ID",FALSE,FALSE,PostedPmtOrd);
        UNTIL CarteraReportSelection.NEXT = 0;
      END;
    END;

    // PROCEDURE PrintCounter(Table : Integer;Number : Code[20]);
    // VAR
    //   PostedBillGr : Record 7000006;
    //   ClosedBillGr : Record 7000007;
    //   PostedPaymentOrder : Record 7000021;
    //   ClosedPaymentOrder : Record 7000022;
    //   BillGr : Record 7000005;
    //   PaymentOrder : Record 7000020;
    // BEGIN
    //   CASE TRUE OF
    //     Table = DATABASE::"Bill Group":
    //       BEGIN
    //         BillGr.GET(Number);
    //         BillGr."No. Printed" := BillGr."No. Printed" + 1;
    //         BillGr.MODIFY;
    //       END;
    //     Table = DATABASE::"Payment Order":
    //       BEGIN
    //         PaymentOrder.GET(Number);
    //         PaymentOrder."No. Printed" := PaymentOrder."No. Printed" + 1;
    //         PaymentOrder.MODIFY;
    //       END;
    //     Table = DATABASE::"Posted Bill Group":
    //       BEGIN
    //         PostedBillGr.GET(Number);
    //         PostedBillGr."No. Printed" := PostedBillGr."No. Printed" + 1;
    //         PostedBillGr.MODIFY;
    //       END;
    //     Table = DATABASE::"Closed Bill Group":
    //       BEGIN
    //         ClosedBillGr.GET(Number);
    //         ClosedBillGr."No. Printed" := ClosedBillGr."No. Printed" + 1;
    //         ClosedBillGr.MODIFY;
    //       END;
    //     Table = DATABASE::"Posted Payment Order":
    //       BEGIN
    //         PostedPaymentOrder.GET(Number);
    //         PostedPaymentOrder."No. Printed" := PostedPaymentOrder."No. Printed" + 1;
    //         PostedPaymentOrder.MODIFY;
    //       END;
    //     Table = DATABASE::"Closed Payment Order":
    //       BEGIN
    //         ClosedPaymentOrder.GET(Number);
    //         ClosedPaymentOrder."No. Printed" := ClosedPaymentOrder."No. Printed" + 1;
    //         ClosedPaymentOrder.MODIFY;
    //       END;
    //   END;
    //   COMMIT;
    // END;

    /* BEGIN
END.*/
}









