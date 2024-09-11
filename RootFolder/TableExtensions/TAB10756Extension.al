tableextension 50213 "MyExtension50213" extends "SII Purch. Doc. Scheme Code"
{
  
  
    CaptionML=ENU='SII Purch. Doc. Scheme Code',ESP='C¢d. esquema doc. compra SII';
    ////LookupPageID=Page10771;
    ////DrillDownPageID=Page10771;
  
  fields
{
}
  keys
{
   // key(key1;"Document Type","Document No.","Special Scheme Code")
  //  {
       /* Clustered=true;
 */
   // }
}
  fieldgroups
{
}
  
    var
//       CannotInsertMoreThanThreeCodesErr@1100000 :
      CannotInsertMoreThanThreeCodesErr: TextConst ENU='You cannot specify more than three special scheme codes for each document.',ESP='No se pueden especificar m s de tres c¢digos de esquemas especiales para cada documento.';

    


/*
trigger OnInsert();    var
//                SIIPurchDocSchemeCode@1100000 :
               SIIPurchDocSchemeCode: Record 10756;
//                SIISchemeCodeMgt@1100001 :
               SIISchemeCodeMgt: Codeunit 10758;
             begin
               SIIPurchDocSchemeCode.SETRANGE("Document Type","Document Type");
               SIIPurchDocSchemeCode.SETRANGE("Document No.","Document No.");
               if SIIPurchDocSchemeCode.COUNT = SIISchemeCodeMgt.GetMaxNumberOfRegimeCodes then
                 ERROR(CannotInsertMoreThanThreeCodesErr);
             end;

*/



/*begin
    end.
  */
}




