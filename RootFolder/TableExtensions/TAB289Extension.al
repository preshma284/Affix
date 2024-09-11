tableextension 50164 "MyExtension50164" extends "Payment Method"
{
  
  DataCaptionFields="Code","Description";
    CaptionML=ENU='Payment Method',ESP='Forma pago';
    LookupPageID="Payment Methods";
    DrillDownPageID="Payment Methods";
  
  fields
{
    field(7174331;"QuoSII Cobro Metalico SII";Boolean)
    {
        CaptionML=ENU='Payment Cash SII',ESP='Cobro Metalico SII';
                                                   Description='QuoSII';


    }
    field(7174332;"QuoSII Type SII";Code[20])
    {
        TableRelation="SII Type List Value"."Code" WHERE ("Type"=CONST("PaymentMethod"),
                                                                                                   "SII Entity"=FIELD("QuoSII Entity"));
                                                   CaptionML=ENU='Type SII',ESP='Tipo SII';
                                                   Description='QuoSII';


    }
    field(7174333;"QuoSII Entity";Code[20])
    {
        TableRelation="SII Type List Value"."Code" WHERE ("Type"=CONST("SIIEntity"),
                                                                                                   "SII Entity"=CONST(''));
                                                   

                                                   CaptionML=ENU='SII Entity',ESP='Entidad SII';
                                                   Description='QuoSII_1.4.2.042';

trigger OnValidate();
    VAR
//                                                                 SalesLine@7174331 :
                                                                SalesLine: Record 37;
                                                              BEGIN 
                                                              END;


    }
    field(7174334;"QFA Payment Means Type";Option)
    {
        OptionMembers=" ","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19";DataClassification=ToBeClassified;
                                                   CaptionML=ESP='C¢digo FACE para eFactura';
                                                   OptionCaptionML=ENU='" ,01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19"',ESP='" ,01 Al contado,02 Recibo Domiciliado,03 Recibo,04 Transferencia,05 Letra Aceptada,06 Cr‚dito Documentario,07 Contrato Adjudicaci¢n,08 Letra de cambio,09 Pagar‚ a la Orden,10 Pagar‚ No a la Orden,11 Cheque,12 Reposici¢n,13 Especiales,14 Compensaci¢n,15 Giro postal,16 Cheque conformado,17 Cheque bancario,18 Pago contra reembolso,19 Pago mediante tarjeta"';
                                                   
                                                   Description='QFA 1.3h';


    }
    field(7207270;"Requires approval on purchases";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='User',ESP='Requiere aprobaci¢n en compras';
                                                   Description='QB 1.00 - JAV 13/03/20: - Se renumera el campo pasando a numeraci¢n QB, JAV 28/07/19: -  Si el uso de este m‚todo de pago en compras necesita aprobaci¢n';


    }
    field(7207271;"Convert in Payment Relation";Code[10])
    {
        TableRelation="Payment Method";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Convertir en relaciones de pago',ENG='Convert to';
                                                   Description='QB 1.00 - PERTEO: Para generar los efectos pasar  a esta';


    }
    field(7207272;"Mandatory Vendor Bank";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Mandatory Vendor Bank',ESP='Banco proveedor obligatorio';
                                                   Description='QB 1.00 - PERTEO: QPE6439';


    }
    field(7207273;"QB % Discount in Proforms";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='% Descuento en proformas';
                                                   MinValue=0;
                                                   MaxValue=100;
                                                   Description='QB 1.08.41 JAV 04/05/21: - Porcentaje de dto. Pronto Pago que se aplica solo en las proformas de compra';


    }
    field(7207274;"QB Confirming Customer";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Confirming Customer',ESP='Confirming Cliente';
                                                   Description='QB 1.10.09 JAV 13/01/22: - [TT] Indica si esta forma de pago se usa para operaciones de Conformnig de Clientes';


    }
    field(7207275;"QB Confirming Vendor";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Confirming Vendor',ESP='Confirming Proveedor';
                                                   Description='QB 1.10.09 JAV 13/01/22: - [TT] Indica si esta forma de pago se usa para operaciones de Conformnig de Proveedores' ;


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
   // fieldgroup(Brick;"Code","Description")
   // {
       // 
   // }
}
  
    var
//       Text1100000@1100000 :
      Text1100000: TextConst ENU='%1 must be set equal to False',ESP='%1 debe estar desactivado';
//       UseForInvoicingErr@1000 :
      UseForInvoicingErr: TextConst ENU='The Use for Invoicing property must be set to true in the Invoicing App.',ESP='El uso para la propiedad de facturaci¢n debe establecerse en true en Microsoft Invoicing.';

    


/*
trigger OnInsert();    var
//                IdentityManagement@1000 :
               IdentityManagement: Codeunit 9801;
             begin
               if IdentityManagement.IsInvAppId then
                 if not "Use for Invoicing" then
                   VALIDATE("Use for Invoicing",TRUE);

               "Last Modified Date Time" := CURRENTDATETIME;
             end;


*/

/*
trigger OnModify();    begin
               "Last Modified Date Time" := CURRENTDATETIME;
             end;


*/

/*
trigger OnRename();    begin
               "Last Modified Date Time" := CURRENTDATETIME;
             end;

*/



// LOCAL procedure CheckGLAcc (AccNo@1000 :

/*
LOCAL procedure CheckGLAcc (AccNo: Code[20])
    var
//       GLAcc@1001 :
      GLAcc: Record 15;
    begin
      if AccNo <> '' then begin
        GLAcc.GET(AccNo);
        GLAcc.CheckGLAcc;
        GLAcc.TESTFIELD("Direct Posting",TRUE);
      end;
    end;
*/


    
//     procedure TranslateDescription (Language@1001 :
    
/*
procedure TranslateDescription (Language: Code[10])
    var
//       PaymentMethodTranslation@1003 :
      PaymentMethodTranslation: Record 466;
    begin
      if PaymentMethodTranslation.GET(Code,Language) then
        VALIDATE(Description,COPYSTR(PaymentMethodTranslation.Description,1,MAXSTRLEN(Description)));
    end;
*/


    
    
/*
procedure GetDescriptionInCurrentLanguage () : Text[100];
    var
//       Language@1000 :
      Language: Record 8;
//       PaymentMethodTranslation@1001 :
      PaymentMethodTranslation: Record 466;
    begin
      if PaymentMethodTranslation.GET(Code,Language.GetUserLanguage) then
        exit(PaymentMethodTranslation.Description);

      exit(Description);
    end;

    /*begin
    //{
//      JAV 08/05/19: - 50000 "Convertir" PERTEO: Para generar los efectos pasar  a esta
//      PEL 12/02/19: - QPE6439: Creado campo "Mandatory Vendro Bank"
//      JAV 11/09/19: - Se a¤ade el campo 50002 "Approval required by Position" que indica si el uso de esta forma de pago en compras necesita aprobaci¢n, que cargo debe aprobarla
//    }
    end.
  */
}




