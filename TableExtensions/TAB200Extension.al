tableextension 50149 "QBU Work TypeExt" extends "Work Type"
{
  
  
    CaptionML=ENU='Work Type',ESP='Tipo trabajo';
    LookupPageID="Work Types";
    DrillDownPageID="Work Types";
  
  fields
{
    field(7207270;"QBU Compute Hours";Boolean)
    {
        CaptionML=ENU='Compute Hours',ESP='Computa para horas';


    }
    field(7207271;"QBU C.A. Direct Cost Allocation";Code[20])
    {
        TableRelation="Dimension Value"."Code";
                                                   

                                                   CaptionML=ENU='C.A. Direct Cost Allocation',ESP='C.A. imputaci¢n coste directo';
                                                   Description='QB 1.00';

trigger OnLookup();
    VAR
//                                                               FunctionQB@100000000 :
                                                              FunctionQB: Codeunit 7207272;
                                                            BEGIN 
                                                              FunctionQB.LookUpCA("C.A. Direct Cost Allocation",FALSE);
                                                            END;


    }
    field(7207272;"QBU Acc. Direct Cost Allocation";Code[20])
    {
        TableRelation="G/L Account";
                                                   CaptionML=ENU='Acc. Direct Cost Allocation',ESP='Cuenta imputaci¢n coste dir.';
                                                   Description='QB 1.00';


    }
    field(7207273;"QBU C.A. Direct Cost App. Account";Code[20])
    {
        TableRelation="Dimension Value"."Code";
                                                   

                                                   CaptionML=ENU='C.A. Direct Cost App. Account',ESP='C.A. contrapartida costes dir.';
                                                   Description='QB 1.00';

trigger OnLookup();
    VAR
//                                                               FunctionQB@1100286000 :
                                                              FunctionQB: Codeunit 7207272;
                                                            BEGIN 
                                                              FunctionQB.LookUpCA("C.A. Direct Cost App. Account",FALSE);
                                                            END;


    }
    field(7207274;"QBU Acc. Direct Cost App. Account";Code[20])
    {
        TableRelation="G/L Account";
                                                   CaptionML=ENU='Acc. Direct Cost App. Account',ESP='Cta. contrapartida costes dir.';
                                                   Description='QB 1.00';


    }
    field(7207275;"QBU C.A. Indirect Cost Allocation";Code[20])
    {
        TableRelation="Dimension Value"."Code";
                                                   

                                                   CaptionML=ENU='C.A. Indirect Cost Allocation',ESP='C.A. imputaci¢n coste indirec.';
                                                   Description='QB 1.00';

trigger OnLookup();
    VAR
//                                                               FunctionQB@1100286000 :
                                                              FunctionQB: Codeunit 7207272;
                                                            BEGIN 
                                                              FunctionQB.LookUpCA("C.A. Indirect Cost Allocation",FALSE);
                                                            END;


    }
    field(7207276;"QBU Acc. Indirect Cost Allocation";Code[20])
    {
        TableRelation="G/L Account";
                                                   CaptionML=ENU='Acc. Indirect Cost Allocation',ESP='Cuenta imputaci¢n coste ind.';
                                                   Description='QB 1.00';


    }
    field(7207277;"QBU C.A. Indirect Cost App. Accoun";Code[20])
    {
        TableRelation="Dimension Value"."Code";
                                                   

                                                   CaptionML=ENU='C.A. Indirect Cost App. Accoun',ESP='C.A. contrapartida costes ind.';
                                                   Description='QB 1.00';

trigger OnLookup();
    VAR
//                                                               FunctionQB@1100286000 :
                                                              FunctionQB: Codeunit 7207272;
                                                            BEGIN 
                                                              FunctionQB.LookUpCA("C.A. Indirect Cost App. Accoun",FALSE);
                                                            END;


    }
    field(7207278;"QBU Acc. Indirect Cost App. Accoun";Code[20])
    {
        TableRelation="G/L Account";
                                                   CaptionML=ENU='Acc. Indirect Cost App. Accoun',ESP='Cta. contrapatrida costes ind.';
                                                   Description='QB 1.00';


    }
    field(7207279;"QBU Salary Concept";Code[20])
    {
        TableRelation="Salary Code";
                                                   CaptionML=ENU='Salary Concept',ESP='Concepto n¢mina';
                                                   Description='QB 1.00' ;


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
   // fieldgroup(DropDown;"Code","Description","Unit of Measure Code")
   // {
       // 
   // }
}
  

    /*begin
    end.
  */
}





