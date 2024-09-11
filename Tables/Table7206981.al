table 7206981 "QBU QPR Budget Template  Line"
{
  
  
    CaptionML=ENU='Budget Template Line',ESP='Linea de Plantilla de Presupuesto';
  
  fields
{
    field(1;"Template Code";Code[20])
    {
        CaptionML=ESP='Plantilla';


    }
    field(2;"Code";Code[20])
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='C¢digo';

trigger OnValidate();
    BEGIN 
                                                                VALIDATE(Totaling);
                                                              END;


    }
    field(21;"Description";Text[50])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Description',ESP='DescripciÂ¢n';


    }
    field(46;"Account Type";Option)
    {
        OptionMembers="Unit","Heading";

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Account Type',ESP='Tipo mov.';
                                                   OptionCaptionML=ENU='Unit,Heading',ESP='Unidad,Mayor';
                                                   

trigger OnValidate();
    BEGIN 
                                                                VALIDATE(Totaling);

                                                                IF ("Account Type" = "Account Type"::Heading) THEN BEGIN 
                                                                  "QPR Type" := "QPR Type"::" ";
                                                                  "QPR No." := '';
                                                                  "QPR Name" := '';
                                                                END;
                                                              END;


    }
    field(47;"Indentation";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Indentation',ESP='Indentar';
                                                   MinValue=0;
                                                   Editable=true;


    }
    field(48;"Totaling";Text[250])
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Totaling',ESP='Sumatorio';
                                                   Editable=false;

trigger OnValidate();
    BEGIN 
                                                                IF ("Account Type" = "Account Type"::Heading) THEN
                                                                  Totaling := Code + '..' + PADSTR(Code,20,'9')
                                                                ELSE
                                                                  Totaling := '';
                                                              END;


    }
    field(600;"QPR Type";Option)
    {
        OptionMembers=" ","Account","Resource","Item";

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Cost Type',ESP='Tipo';
                                                   OptionCaptionML=ENU='" ,Account,Resource,Item"',ESP='" ,Cuenta,Recurso,Producto"';
                                                   

trigger OnValidate();
    VAR
//                                                                 QPRAmounts@1100286000 :
                                                                QPRAmounts: Record 7207383;
                                                              BEGIN 
                                                                //Si cambia el tipo, no podemos mantener estos datos
                                                                IF ("QPR Type" <> xRec."QPR Type") THEN BEGIN 
                                                                  "QPR No." := '';
                                                                  "QPR Name" := '';
                                                                END;
                                                              END;


    }
    field(602;"QPR No.";Code[20])
    {
        TableRelation=IF ("QPR Type"=CONST("Account")) "G/L Account"                                                                 ELSE IF ("QPR Type"=CONST("Resource")) Resource WHERE ("Type"=CONST("PartidaPresupuestaria"))                                                                 ELSE IF ("QPR Type"=CONST("Item")) Item;
                                                   

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='No.',ESP='NÂ§';

trigger OnValidate();
    VAR
//                                                                 GLAccount@1100286000 :
                                                                GLAccount: Record 15;
//                                                                 Item@1100286001 :
                                                                Item: Record 27;
//                                                                 Resource@1100286002 :
                                                                Resource: Record 156;
//                                                                 lJob@1100286003 :
                                                                lJob: Record 167;
//                                                                 lJobBudget@1100286004 :
                                                                lJobBudget: Record 7207407;
//                                                                 QPRAmounts@1100286005 :
                                                                QPRAmounts: Record 7207383;
//                                                                 QPRBudgetsProcesing@1100286008 :
                                                                QPRBudgetsProcesing: Codeunit 7206930;
//                                                                 sCos@1100286006 :
                                                                sCos: Decimal;
//                                                                 sIng@1100286007 :
                                                                sIng: Decimal;
                                                              BEGIN 
                                                                "QPR Name" := '';
                                                                CASE "QPR Type" OF
                                                                 "QPR Type"::Account:
                                                                    BEGIN 
                                                                      GLAccount.GET("QPR No.");
                                                                      "QPR Name" := GLAccount.Name;
                                                                    END;

                                                                  "QPR Type"::Resource:
                                                                    BEGIN 
                                                                      Resource.GET("QPR No.");
                                                                      IF (Resource.Type <> Resource.Type::PartidaPresupuestaria) THEN
                                                                        ERROR(Text606);
                                                                      "QPR Name" := Resource.Name;
                                                                    END;

                                                                  "QPR Type"::Item:
                                                                    BEGIN 
                                                                      Item.GET("QPR No.");
                                                                      "QPR Name" := Item.Description;
                                                                    END;
                                                                END;
                                                              END;


    }
    field(603;"QPR Name";Text[50])
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='No.',ESP='Nombre';
                                                   Editable=false;

trigger OnValidate();
    VAR
//                                                                 GLAccount@1100286000 :
                                                                GLAccount: Record 15;
                                                              BEGIN 
                                                              END;


    }
    field(605;"QPR Use";Option)
    {
        OptionMembers=" ","Gasto","Ingreso";DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Uso';
                                                   OptionCaptionML=ENU='" ,Cost,Sale"',ESP='" ,Gasto,Ingreso"';
                                                   


    }
    field(606;"QPR AC";Code[20])
    {
        TableRelation="Dimension Value"."Code" WHERE ("Global Dimension No."=CONST(2));
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Concepto anal¡tico';


    }
    field(607;"QPR Gen Prod. Posting Group";Code[20])
    {
        TableRelation="Gen. Product Posting Group";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='VAT Prod. Posting Group',ESP='Grupo registro de prod.';


    }
    field(608;"QPR Gen Posting Group";Code[20])
    {
        TableRelation="Gen. Business Posting Group";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='VAT Prod. Posting Group',ESP='Grupo registro general';


    }
    field(609;"QPR VAT Prod. Posting Group";Code[20])
    {
        TableRelation="VAT Product Posting Group";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='VAT Prod. Posting Group',ESP='Grupo registro IVA prod.';


    }
    field(610;"QPR Account No";Code[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='N§ Cuenta';
                                                   Editable=false;


    }
    field(611;"QPR Activable";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Permite Gastos Activables';
                                                   Description='QB 1.10.33 - JAV 08/04/22 - [TT] Si se marca indica que se pueden generar gastos activables de esta partida presupuestaria (se generan siempre que el proyecto y el estado del mismo lo permitan)' ;


    }
}
  keys
{
    key(key1;"Template Code","Code")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  
    var
//       Job@1100286000 :
      Job: Record 167;
//       GLAccount@1100286001 :
      GLAccount: Record 15;
//       Text606@1100286002 :
      Text606: TextConst ESP='Solo puede elegir recursos de tipo Partida Presupuestaria';

    /*begin
    {
      JAV 08/04/22: - QB 1.10.32 Se mejoran las plantillas de presupuestos, se cambian nombres y captios, se a¤ade activable
    }
    end.
  */
}







