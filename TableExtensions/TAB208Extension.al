tableextension 50153 "QBU Job Posting GroupExt" extends "Job Posting Group"
{
  
  
    CaptionML=ENU='Job Posting Group',ESP='Grupo registro proyecto';
    LookupPageID="Job Posting Groups";
    DrillDownPageID="Job Posting Groups";
  
  fields
{
    field(7207270;"QBU Sales Analytic Concept";Code[20])
    {
        TableRelation="Dimension Value"."Code";
                                                   

                                                   CaptionML=ENU='Sales Analytic Concept',ESP='Concepto anal¡tico ventas';
                                                   Description='QB2414';

trigger OnValidate();
    VAR
//                                                                 QBTablePublisher@7001100 :
                                                                QBTablePublisher: Codeunit 7207346;
                                                              BEGIN 
                                                              END;

trigger OnLookup();
    VAR
//                                                               FunctionQB@100000000 :
                                                              FunctionQB: Codeunit 7207272;
                                                            BEGIN 
                                                              FunctionQB.LookUpCA("Sales Analytic Concept",FALSE);
                                                            END;


    }
    field(7207271;"QBU Income Account Job in Progress";Code[20])
    {
        TableRelation="G/L Account";
                                                   CaptionML=ENU='Income Account Job in Progress',ESP='Cuenta ingreso obra en curso';
                                                   Description='QB24111';


    }
    field(7207272;"QBU CA Income Job in Progress";Code[20])
    {
        TableRelation="Dimension Value"."Code";
                                                   

                                                   CaptionML=ENU='CA Income Job in Progress',ESP='CA ingreso obra en curso';
                                                   Description='QB24111';

trigger OnLookup();
    VAR
//                                                               FunctionQB@100000000 :
                                                              FunctionQB: Codeunit 7207272;
                                                            BEGIN 
                                                              FunctionQB.LookUpCA("CA Income Job in Progress",FALSE);
                                                            END;


    }
    field(7207273;"QBU Cont. Acc. Job in Progress(+)";Code[20])
    {
        TableRelation="G/L Account";
                                                   CaptionML=ENU='Cont. Acc. Job in Progress(+)',ESP='Cta. contr. obra en curso(+)';
                                                   Description='QB24111';


    }
    field(7207274;"QBU Cont. Acc. Job in Progress(-)";Code[20])
    {
        TableRelation="G/L Account";
                                                   CaptionML=ENU='Cont. Acc. Job in Progress(-)',ESP='Cta. contr. obra en curso(-)';
                                                   Description='QB24111';


    }
    field(7207275;"QBU Invoice Certi. Type";Option)
    {
        OptionMembers="Standar","Account","Resource","Item";DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Facturar Certificaci¢n Tipo';
                                                   OptionCaptionML=ENU='" ,Account,Resource,Item"',ESP='" ,Cuenta,Recurso,Producto"';
                                                   
                                                   Description='QB 1.08.39 - JAV 14/04/21 Al facturar la certificaci¢n, que tipo de registro usar  en la linea';


    }
    field(7207276;"QBU Invoice Certi. No.";Code[20])
    {
        TableRelation=IF ("QB Invoice Certi. Type"=CONST("Account")) "G/L Account"."No."                                                                 ELSE IF ("QB Invoice Certi. Type"=CONST("Resource")) Resource."No."                                                                 ELSE IF ("QB Invoice Certi. Type"=CONST("Item")) Item."No.";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Facturar Certificaci¢n N§';
                                                   Description='QB 1.08.39 - JAV 14/04/21 Al facturar la certificaci¢n, que registro usar  en la linea';


    }
    field(7207278;"QBU Invoice Acc. Service Order";Code[20])
    {
        TableRelation="G/L Account";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Invoice Acc. Service Order',ESP='Cta. Fact. Ped. Servicio';
                                                   Description='QB 1.09.21 - PEDIDOSSERVICIO' ;


    }
}
  keys
{
   // key(key1;"Code")
  //  {
       /* Clustered=true;
 */
   // }
}
  fieldgroups
{
   // fieldgroup(Brick;"Code")
   // {
       // 
   // }
}
  
    var
//       YouCannotDeleteErr@1000 :
      YouCannotDeleteErr: 
// "%1 = Code"
TextConst ENU='You cannot delete %1.',ESP='No puede eliminar %1.';

    


/*
trigger OnDelete();    begin
               CheckGroupUsage;
             end;

*/




/*
LOCAL procedure CheckGroupUsage ()
    var
//       Job@1000 :
      Job: Record 167;
//       JobLedgerEntry@1001 :
      JobLedgerEntry: Record 169;
    begin
      Job.SETRANGE("Job Posting Group",Code);
      if not Job.ISEMPTY then
        ERROR(YouCannotDeleteErr,Code);

      JobLedgerEntry.SETRANGE("Job Posting Group",Code);
      if not JobLedgerEntry.ISEMPTY then
        ERROR(YouCannotDeleteErr,Code);
    end;
*/


    
    
/*
procedure GetWIPCostsAccount () : Code[20];
    begin
      TESTFIELD("WIP Costs Account");
      exit("WIP Costs Account");
    end;
*/


    
    
/*
procedure GetWIPAccruedCostsAccount () : Code[20];
    begin
      TESTFIELD("WIP Accrued Costs Account");
      exit("WIP Accrued Costs Account");
    end;
*/


    
    
/*
procedure GetWIPAccruedSalesAccount () : Code[20];
    begin
      TESTFIELD("WIP Accrued Sales Account");
      exit("WIP Accrued Sales Account");
    end;
*/


    
    
/*
procedure GetWIPInvoicedSalesAccount () : Code[20];
    begin
      TESTFIELD("WIP Invoiced Sales Account");
      exit("WIP Invoiced Sales Account");
    end;
*/


    
    
/*
procedure GetJobCostsAppliedAccount () : Code[20];
    begin
      TESTFIELD("Job Costs Applied Account");
      exit("Job Costs Applied Account");
    end;
*/


    
    
/*
procedure GetJobCostsAdjustmentAccount () : Code[20];
    begin
      TESTFIELD("Job Costs Adjustment Account");
      exit("Job Costs Adjustment Account");
    end;
*/


    
    
/*
procedure GetGLExpenseAccountContract () : Code[20];
    begin
      TESTFIELD("G/L Expense Acc. (Contract)");
      exit("G/L Expense Acc. (Contract)");
    end;
*/


    
    
/*
procedure GetJobSalesAdjustmentAccount () : Code[20];
    begin
      TESTFIELD("Job Sales Adjustment Account");
      exit("Job Sales Adjustment Account");
    end;
*/


    
    
/*
procedure GetJobSalesAppliedAccount () : Code[20];
    begin
      TESTFIELD("Job Sales Applied Account");
      exit("Job Sales Applied Account");
    end;
*/


    
    
/*
procedure GetRecognizedCostsAccount () : Code[20];
    begin
      TESTFIELD("Recognized Costs Account");
      exit("Recognized Costs Account");
    end;
*/


    
    
/*
procedure GetRecognizedSalesAccount () : Code[20];
    begin
      TESTFIELD("Recognized Sales Account");
      exit("Recognized Sales Account");
    end;
*/


    
    
/*
procedure GetItemCostsAppliedAccount () : Code[20];
    begin
      TESTFIELD("Item Costs Applied Account");
      exit("Item Costs Applied Account");
    end;
*/


    
    
/*
procedure GetResourceCostsAppliedAccount () : Code[20];
    begin
      TESTFIELD("Resource Costs Applied Account");
      exit("Resource Costs Applied Account");
    end;
*/


    
    
/*
procedure GetGLCostsAppliedAccount () : Code[20];
    begin
      TESTFIELD("G/L Costs Applied Account");
      exit("G/L Costs Applied Account");
    end;

    /*begin
    end.
  */
}





