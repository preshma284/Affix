report 7207288 "Gen. Milestones by Budget"
{
  
  
    ProcessingOnly=true;
  
  dataset
{

DataItem("JobPlanningLine";"Job Planning Line")
{

               DataItemTableView=SORTING("Job No.","Analytical concept","Job Task No.");
               

               RequestFilterFields="Line No.";
trigger OnPreDataItem();
    BEGIN 
                               Window.OPEN(Text001);
                               codeJob := '';
                               codeAC := '';
                               codeTask := '';
                               decTotalCost := 0;
                               decTotalDeposited := 0;
                             END;

trigger OnAfterGetRecord();
    BEGIN 

                                  IF (JobPlanningLine."Job No." <> codeJob) OR
                                     (JobPlanningLine."Job Task No." <> codeTask) OR
                                     (JobPlanningLine."Analytical concept" <> codeAC) THEN BEGIN 
                                    CreateLine;
                                    codeJob := JobPlanningLine."Job No.";
                                    codeAC := JobPlanningLine."Analytical concept";
                                    codeTask := JobPlanningLine."Job Task No.";
                                    decTotalDeposited := JobPlanningLine."Total Price (LCY)";
                                    decTotalCost := JobPlanningLine."Total Cost (LCY)";
                                  END ELSE BEGIN 
                                    decTotalDeposited := decTotalDeposited + JobPlanningLine."Total Price (LCY)";
                                    decTotalCost := decTotalCost + JobPlanningLine."Total Cost (LCY)";
                                  END;
                                END;

trigger OnPostDataItem();
    BEGIN 
                                IF (decTotalDeposited <> 0) OR (decTotalCost <> 0) THEN
                                  CreateLine;
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
//       decTotalCost@7001104 :
      decTotalCost: Decimal;
//       decTotalDeposited@7001103 :
      decTotalDeposited: Decimal;
//       codeJob@7001102 :
      codeJob: Code[20];
//       codeAC@7001101 :
      codeAC: Code[20];
//       codeTask@7001100 :
      codeTask: Code[20];
//       NoDoc@7001112 :
      NoDoc: Code[20];
//       NoCust@7001111 :
      NoCust: Code[20];
//       Job@7001110 :
      Job: Code[20];
//       recJob@7001109 :
      recJob: Record 167;
//       recGCP@7001108 :
      recGCP: Record 208;
//       Window@7001107 :
      Window: Dialog;
//       recAccount@7001106 :
      recAccount: Record 15;
//       NoLin@7001115 :
      NoLin: Integer;
//       recSaleHeader@7001114 :
      recSaleHeader: Record 36;
//       recSaleLines@7001113 :
      recSaleLines: Record 37;
//       Text001@7001105 :
      Text001: TextConst ENU='Creating Invoice',ESP='Generando Factura';

//     procedure SetCabVtas (locSalesHeader@1000000000 :
    procedure SetCabVtas (locSalesHeader: Record 36)
    begin
      NoDoc := locSalesHeader."No.";
      NoCust := locSalesHeader."Sell-to Customer No.";
      Job := locSalesHeader."QB Job No.";
    end;

    procedure FunNoLine ()
    var
//       locSaleLine@1000000000 :
      locSaleLine: Record 37;
    begin
      locSaleLine.RESET;
      locSaleLine.SETRANGE(locSaleLine."Document No.",NoDoc);
      locSaleLine.SETRANGE(locSaleLine."Document Type",locSaleLine."Document Type"::Invoice);
      if locSaleLine.FINDLAST then
        NoLin:= locSaleLine."Line No." + 10000
      else
        NoLin:= 10000;
    end;

    procedure CreateLine ()
    begin
      recJob.GET(Job);
      recGCP.GET(recJob."Job Posting Group");
      recGCP.TESTFIELD(recGCP."Job Costs Adjustment Account");
      recAccount.GET(recGCP."Job Costs Adjustment Account");
      JobPlanningLine.TESTFIELD(JobPlanningLine."Analytical concept");
      recSaleHeader.GET(recSaleHeader."Document Type"::Invoice,NoDoc);

      FunNoLine;
      recSaleLines."Document Type":=recSaleLines."Document Type"::Invoice;
      recSaleLines.VALIDATE("Document No.",NoDoc);
      recSaleLines.VALIDATE(recSaleLines."Line No.",NoLin);
      recSaleLines.INSERT(TRUE);
      recSaleLines.VALIDATE(recSaleLines."Sell-to Customer No.",NoCust);
      recSaleLines.VALIDATE(recSaleLines."Bill-to Customer No.",NoCust);
      recSaleLines.Type:=recSaleLines.Type::"G/L Account";
      recSaleLines.VALIDATE("No.",recGCP."Job Costs Adjustment Account");

      recSaleLines.VALIDATE(recSaleLines.Quantity,1);
      recSaleLines.VALIDATE(recSaleLines."Unit Cost (LCY)",decTotalCost);
      if recSaleHeader."Currency Code" = '' then begin
        recSaleLines.VALIDATE(recSaleLines."Unit Price",decTotalDeposited);
        recSaleLines.VALIDATE(recSaleLines.Amount,decTotalDeposited);
      end else begin
        recSaleLines.VALIDATE(recSaleLines."Unit Price",decTotalDeposited *
                           recSaleHeader."Currency Factor");
        recSaleLines.VALIDATE(recSaleLines.Amount,decTotalDeposited *
                           recSaleHeader."Currency Factor");
      end;
      recSaleLines.VALIDATE(recSaleLines."Job No.",codeJob);
      recSaleLines.VALIDATE("Job Task No.",codeTask);
      recSaleLines.VALIDATE("Shortcut Dimension 2 Code",codeAC);
      recSaleLines.MODIFY(TRUE);
    end;

    /*begin
    end.
  */
  
}



