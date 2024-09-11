tableextension 50212 "MyExtension50212" extends "SII Sales Document Scheme Code"
{
  
  
    CaptionML=ENU='SII Sales Document Scheme Code',ESP='C¢d. esquema de documentos de venta SII';
    ////LookupPageID=Page10770;
    ////DrillDownPageID=Page10770;
  
  fields
{
}
  keys
{
   // key(key1;"Entry Type","Document Type","Document No.","Special Scheme Code")
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
//                SIISalesDocumentSchemeCode@1100000 :
               SIISalesDocumentSchemeCode: Record 10755;
//                SIISchemeCodeMgt@1100001 :
               SIISchemeCodeMgt: Codeunit 10758;
             begin
               SIISalesDocumentSchemeCode.SETRANGE("Entry Type","Entry Type");
               SIISalesDocumentSchemeCode.SETRANGE("Document Type","Document Type");
               SIISalesDocumentSchemeCode.SETRANGE("Document No.","Document No.");
               if SIISalesDocumentSchemeCode.COUNT = SIISchemeCodeMgt.GetMaxNumberOfRegimeCodes then
                 ERROR(CannotInsertMoreThanThreeCodesErr);
             end;

*/



/*begin
    end.
  */
}




