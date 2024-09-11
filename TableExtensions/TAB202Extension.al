tableextension 50151 "QBU Resource CostExt" extends "Resource Cost"
{
  
  
    CaptionML=ENU='Resource Cost',ESP='Precio coste recurso';
  
  fields
{
    field(7207270;"QBU C.A. Direct Cost Allocation";Code[20])
    {
        TableRelation="Dimension Value"."Code";
                                                   

                                                   CaptionML=ENU='C.A.  Direct Cost Allocation',ESP='C.A. Imputaci¢n coste direco';
                                                   Description='QB 1.00 - QB2411';

trigger OnLookup();
    VAR
//                                                               FunctionQB@100000002 :
                                                              FunctionQB: Codeunit 7207272;
                                                            BEGIN 
                                                              FunctionQB.LookUpCA("C.A. Direct Cost Allocation",FALSE);
                                                            END;


    }
    field(7207271;"QBU Acc. Direct Cost Allocation";Code[20])
    {
        TableRelation="G/L Account";
                                                   CaptionML=ENU='Account Direct Cost Allocationn',ESP='Cuenta imputaci¢n costes directos.';
                                                   Description='QB 1.00 - QB2411';


    }
    field(7207272;"QBU C.A. Direct Cost Appl. Account";Code[20])
    {
        TableRelation="Dimension Value"."Code";
                                                   

                                                   CaptionML=ENU='C.A. Direct Cost Appl. Account',ESP='C.A. contrapartida costes dir.';
                                                   Description='QB 1.00 - QB2411';

trigger OnLookup();
    VAR
//                                                               FunctionQB@1100286000 :
                                                              FunctionQB: Codeunit 7207272;
                                                            BEGIN 
                                                              FunctionQB.LookUpCA("C.A. Direct Cost Appl. Account",FALSE);
                                                            END;


    }
    field(7207273;"QBU Acc. Direct Cost Appl. Account";Code[20])
    {
        TableRelation="G/L Account";
                                                   CaptionML=ENU='Acc. Direct Cost Appl. Account',ESP='Cta. contrapartida costes directos';
                                                   Description='QB 1.00 - QB2411';


    }
    field(7207274;"QBU C.A. Indirect Cost Allocation";Code[20])
    {
        TableRelation="Dimension Value"."Code";
                                                   

                                                   CaptionML=ENU='C.A. Indirect Cost Allocation',ESP='C.A. Imputaci¢n de coste indirecto';
                                                   Description='QB 1.00 - QB2411';

trigger OnLookup();
    VAR
//                                                               FunctionQB@1100286000 :
                                                              FunctionQB: Codeunit 7207272;
                                                            BEGIN 
                                                              FunctionQB.LookUpCA("C.A. Indirect Cost Allocation",FALSE);
                                                            END;


    }
    field(7207275;"QBU Acc. Indirect Cost Allocation";Code[20])
    {
        TableRelation="G/L Account";
                                                   CaptionML=ENU='Account Ind. Cost Allocation',ESP='Cuenta imputaci¢n coste indirectos';
                                                   Description='QB 1.00 - QB2411';


    }
    field(7207276;"QBU C.A. Ind. Cost Appl. Account";Code[20])
    {
        TableRelation="Dimension Value"."Code";
                                                   

                                                   CaptionML=ENU='C.A. Ind. Cost Appl. Account',ESP='C.A. contrapartida costes indirectos';
                                                   Description='QB 1.00 - QB2411';

trigger OnLookup();
    VAR
//                                                               FunctionQB@1100286000 :
                                                              FunctionQB: Codeunit 7207272;
                                                            BEGIN 
                                                              FunctionQB.LookUpCA("C.A. Ind. Cost Appl. Account",FALSE);
                                                            END;


    }
    field(7207277;"QBU Acc. Ind. Cost Appl. Account";Code[20])
    {
        TableRelation="G/L Account";
                                                   CaptionML=ENU='Acc. Ind. Cost Appl. Account',ESP='Cta. contrapartida costes indirectos';
                                                   Description='QB 1.00 - QB2411' ;


    }
}
  keys
{
   // key(key1;"Type","Code","Work Type Code")
  //  {
       /* Clustered=true;
 */
   // }
}
  fieldgroups
{
}
  
    var
//       Text000@1000 :
      Text000: TextConst ENU='cannot be specified when %1 is %2',ESP='No se puede indicar cuando %1 es %2.';

    /*begin
    end.
  */
}





