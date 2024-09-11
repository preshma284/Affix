tableextension 50100 "QBU Payment TermsExt" extends "Payment Terms"
{
  
  DataCaptionFields="Code","Description";
    CaptionML=ENU='Payment Terms',ESP='T‚rminos pago';
    LookupPageID="Payment Terms";
  
  fields
{
    field(7207270;"QBU Requires purchase approval";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Requires approval on purchases',ESP='Requiere aprobaci¢n en compras';
                                                   Description='JAV 13/03/20: - Se renumera el campo pasando a numeraci¢n QB, JAV 28/07/19: -  Si el uso de este m‚todo de pago en compras necesita aprobaci¢n' ;


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
   // fieldgroup(DropDown;"Code","Description","Due Date Calculation")
   // {
       // 
   // }
   // fieldgroup(Brick;"Code","Description","Due Date Calculation")
   // {
       // 
   // }
}
  
    var
//       IdentityManagement@1000 :
      IdentityManagement: Codeunit 9801;
//       CannotRemoveDefaultPaymentTermsErr@1001 :
      CannotRemoveDefaultPaymentTermsErr: TextConst ENU='You cannot remove the default payment terms.',ESP='No puede quitar los t‚rminos de pago predeterminados.';
//       Text10700@1100002 :
      Text10700: 
// %1 is fieldcaption,%2 is fieldcaption,%3 is tablecaption
TextConst ENU='The %1 exceeds the %2 defined on the %3.',ESP='El %1 supera el %2 definido en el %3.';
//       Text10701@1100003 :
      Text10701: TextConst ENU='The value must be greater than or equal to 0.',ESP='El valor debe ser mayor o igual que 0.';

    


/*
trigger OnInsert();    begin
               SetLastModifiedDateTime;
             end;


*/

/*
trigger OnModify();    begin
               SetLastModifiedDateTime;
             end;


*/

/*
trigger OnDelete();    var
//                PaymentTermsTranslation@1000 :
               PaymentTermsTranslation: Record 462;
//                O365SalesInitialSetup@1001 :
               O365SalesInitialSetup: Record 2110;
//                Installment@1100000 :
               Installment: Record 7000018;
             begin
               if IdentityManagement.IsInvAppId then
                 if O365SalesInitialSetup.GET and
                    (O365SalesInitialSetup."Default Payment Terms Code" = Code)
                 then
                   ERROR(CannotRemoveDefaultPaymentTermsErr);

               WITH PaymentTermsTranslation DO begin
                 SETRANGE("Payment Term",Code);
                 DELETEALL
               end;

               if Installment.WRITEPERMISSION then begin
                 Installment.SETRANGE("Payment Terms Code",Code);
                 Installment.DELETEALL;
               end;
             end;


*/

/*
trigger OnRename();    begin
               SetLastModifiedDateTime;
             end;

*/




/*
LOCAL procedure SetLastModifiedDateTime ()
    begin
      "Last Modified Date Time" := CURRENTDATETIME;
    end;
*/


    
//     procedure TranslateDescription (var PaymentTerms@1000 : Record 3;Language@1001 :
    
/*
procedure TranslateDescription (var PaymentTerms: Record 3;Language: Code[10])
    var
//       PaymentTermsTranslation@1002 :
      PaymentTermsTranslation: Record 462;
    begin
      if PaymentTermsTranslation.GET(PaymentTerms.Code,Language) then
        PaymentTerms.Description := PaymentTermsTranslation.Description;
    end;
*/


//     procedure CalculateMaxDueDate (BaseDate@1100000 :
    
/*
procedure CalculateMaxDueDate (BaseDate: Date) : Date;
    begin
      if "Max. No. of Days till Due Date" = 0 then
        exit(12319999D);
      exit(CALCDATE(STRSUBSTNO('<%1D>',"Max. No. of Days till Due Date"),BaseDate));
    end;
*/


//     procedure VerifyMaxNoDaysTillDueDate (DueDate@1100002 : Date;DocumentDate@1100003 : Date;MessageFieldCaption@1100001 :
    
/*
procedure VerifyMaxNoDaysTillDueDate (DueDate: Date;DocumentDate: Date;MessageFieldCaption: Text[50])
    begin
      if (DueDate <> 0D) and ("Max. No. of Days till Due Date" > 0) then
        if DueDate - DocumentDate > "Max. No. of Days till Due Date" then
          ERROR(Text10700,MessageFieldCaption,FIELDCAPTION("Max. No. of Days till Due Date"),TABLECAPTION);
    end;
*/


    
    
/*
procedure GetDescriptionInCurrentLanguage () : Text[50];
    var
//       Language@1000 :
      Language: Record 8;
//       PaymentTermTranslation@1001 :
      PaymentTermTranslation: Record 462;
    begin
      if PaymentTermTranslation.GET(Code,Language.GetUserLanguage) then
        exit(PaymentTermTranslation.Description);

      exit(Description);
    end;
*/


    
    
/*
procedure UsePaymentDiscount () : Boolean;
    var
//       PaymentTerms@1000 :
      PaymentTerms: Record 3;
    begin
      PaymentTerms.SETFILTER("Discount %",'<>%1',0);

      exit(not PaymentTerms.ISEMPTY);
    end;

    /*begin
    //{
//      JAV 11/09/19: - Se a¤ade el campo 50002 "Approval required by Position" que indica si el uso de esta forma de pago en compras necesita aprobaci¢n, que cargo debe aprobarla
//    }
    end.
  */
}





