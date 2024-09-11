tableextension 50190 "MyExtension50190" extends "Sales Line Archive"
{
  
  
    CaptionML=ENU='Sales Line Archive',ESP='Archivo l¡n. venta';/*
PasteIsValid=false;
*/
  ;
  fields
{
    field(7207270;"% Withholding by G.E";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='% Withholding by G.E',ESP='% retenci¢n pago B.E.';
                                                   Description='QB 1.00 - QB22111     JAV 19/09/19: - Se cambia el caption';
                                                   Editable=false;


    }
    field(7207271;"Withholding Amount by G.E";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Wittholding Amount by G.E',ESP='Importe retenci¢n pago B.E.';
                                                   Description='QB 1.00 - QB22111     JAV 19/09/19: - Se cambia el caption';
                                                   Editable=false;


    }
    field(7207272;"% Withholding by PIT";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='% Withholding PIT',ESP='% retenci¢n IRPF';
                                                   Description='QB 1.00 - QB22111';
                                                   Editable=false;


    }
    field(7207273;"Withholding Amount by PIT";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Withholding Amount by PIT',ESP='Importe retenci¢n por IRPF';
                                                   Description='QB 1.00 - QB22111';
                                                   Editable=false;


    }
    field(7207274;"Certification code";Code[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Certification code',ESP='C¢d. certificaci¢n';
                                                   Description='QB 1.00 - QB22111';


    }
    field(7207275;"Certification Line No.";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Certification Line No.',ESP='N§ l¡nea de certificaci¢n';
                                                   Description='QB 1.00 - QB22111';


    }
    field(7207276;"Certification Piecework No.";Code[20])
    {
        TableRelation="Data Piecework For Production"."Piecework Code" WHERE ("Job No."=FIELD("Job No."));
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='No. Unidad obra certificacion',ESP='N§ Unidad obra certificaci¢n';
                                                   Description='QB 1.00 - QB22111';


    }
    field(7207277;"Milestone No.";Code[10])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Field No.',ESP='N§ de hito';
                                                   Description='QB 1.00 - QB22111';


    }
    field(7207278;"Usage Document";Code[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Usage Document',ESP='Documento Utilizaci¢n';
                                                   Description='QB 1.00 - QB22111';
                                                   Editable=false;


    }
    field(7207279;"Usage Document Line";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Usage Document Line',ESP='L¡n. Documento Utilizaci¢n';
                                                   Description='QB 1.00 - QB22111';
                                                   Editable=false;


    }
    field(7207283;"Not apply Withholding by G.E";Boolean)
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Cod. Withholding by G.E',ESP='Aplicar retenci¢n por B.E.';
                                                   Description='QB 1.00 - JAV 11/08/19: - Si no se aplica la retenci¢n por Buena Ejecuci¢n a la linea';

trigger OnValidate();
    VAR
//                                                                 Withholdingtreating@100000000 :
                                                                Withholdingtreating: Codeunit 7207306;
                                                              BEGIN 
                                                              END;


    }
    field(7207284;"Not apply Withholding by PIT";Boolean)
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Cod. Withholding by PIT',ESP='Aplicar retenci¢n por IRPF';
                                                   Description='QB 1.00 - JAV 11/08/19: - Si no se aplica la retenci¢n por IRPF a la l¡nea     JAV 19/09/19: - Se cambia el caption';

trigger OnValidate();
    VAR
//                                                                 Withholdingtreating@100000000 :
                                                                Withholdingtreating: Codeunit 7207306;
                                                              BEGIN 
                                                              END;


    }
    field(7207285;"Base Withholding by G.E";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='% Withholding by G.E',ESP='Base ret. pago B.E.';
                                                   Description='QB 1.00 - JAV 11/08/19: - Base de c lculo de la retenci¢n por B.E.';
                                                   Editable=false;


    }
    field(7207286;"Base Withholding by PIT";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='% Withholding by PIT',ESP='Base ret. IRPF';
                                                   Description='QB 1.00 - JAV 11/08/19: - Base de c lculo de la retenci¢n por IRPF';
                                                   Editable=false;


    }
    field(7207287;"Withholding by G.E Line";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Cod. Withholding by G.E',ESP='L¡nea de retenci¢n de B.E.';
                                                   Description='QB 1.00 - JAV 18/08/19: - Si es la l¡nea donde se calcula la retenci¢n por Buena Ejecuci¢n' ;


    }
}
  keys
{
   // key(key1;"Document Type","Document No.","Line No.","Doc. No. Occurrence","Version No.")
  //  {
       /* ;
 */
   // }
   // key(key2;"Sell-to Customer No.")
  //  {
       /* ;
 */
   // }
   // key(key3;"Bill-to Customer No.")
  //  {
       /* ;
 */
   // }
}
  fieldgroups
{
}
  
    var
//       DimMgt@1000 :
      DimMgt: Codeunit 408;
//       DeferralUtilities@1001 :
      DeferralUtilities: Codeunit 1720;

    
    


/*
trigger OnDelete();    var
//                SalesCommentLinearch@1000 :
               SalesCommentLinearch: Record 5126;
//                DeferralHeaderArchive@1001 :
               DeferralHeaderArchive: Record 5127;
             begin
               SalesCommentLinearch.SETRANGE("Document Type","Document Type");
               SalesCommentLinearch.SETRANGE("No.","Document No.");
               SalesCommentLinearch.SETRANGE("Document Line No.","Line No.");
               SalesCommentLinearch.SETRANGE("Doc. No. Occurrence","Doc. No. Occurrence");
               SalesCommentLinearch.SETRANGE("Version No.","Version No.");
               if not SalesCommentLinearch.ISEMPTY then
                 SalesCommentLinearch.DELETEALL;

               if "Deferral Code" <> '' then
                 DeferralHeaderArchive.DeleteHeader(DeferralUtilities.GetSalesDeferralDocType,
                   "Document Type","Document No.","Doc. No. Occurrence","Version No.","Line No.");
             end;

*/



// procedure GetCaptionClass (FieldNumber@1000 :

/*
procedure GetCaptionClass (FieldNumber: Integer) : Text[80];
    var
//       SalesHeaderArchive@1001 :
      SalesHeaderArchive: Record 5107;
    begin
      if not SalesHeaderArchive.GET("Document Type","Document No.","Doc. No. Occurrence","Version No.") then begin
        SalesHeaderArchive."No." := '';
        SalesHeaderArchive.INIT;
      end;
      if SalesHeaderArchive."Prices Including VAT" then
        exit('2,1,' + GetFieldCaption(FieldNumber));

      exit('2,0,' + GetFieldCaption(FieldNumber));
    end;
*/


//     LOCAL procedure GetFieldCaption (FieldNumber@1000 :
    
/*
LOCAL procedure GetFieldCaption (FieldNumber: Integer) : Text[100];
    var
//       Field@1001 :
      Field: Record 2000000041;
    begin
      Field.GET(DATABASE::"Sales Line",FieldNumber);
      exit(Field."Field Caption");
    end;
*/


    
    
/*
procedure ShowDimensions ()
    begin
      DimMgt.ShowDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2',"Document Type","Document No."));
    end;
*/


    
    
/*
procedure ShowLineComments ()
    var
//       SalesCommentLineArch@1000 :
      SalesCommentLineArch: Record 5126;
//       SalesArchCommentSheet@1001 :
      SalesArchCommentSheet: Page 5180;
    begin
      SalesCommentLineArch.SETRANGE("Document Type","Document Type");
      SalesCommentLineArch.SETRANGE("No.","Document No.");
      SalesCommentLineArch.SETRANGE("Document Line No.","Line No.");
      SalesCommentLineArch.SETRANGE("Doc. No. Occurrence","Doc. No. Occurrence");
      SalesCommentLineArch.SETRANGE("Version No.","Version No.");
      CLEAR(SalesArchCommentSheet);
      SalesArchCommentSheet.SETTABLEVIEW(SalesCommentLineArch);
      SalesArchCommentSheet.RUNMODAL;
    end;
*/


    
    
/*
procedure ShowDeferrals ()
    begin
      DeferralUtilities.OpenLineScheduleArchive(
        "Deferral Code",DeferralUtilities.GetSalesDeferralDocType,
        "Document Type","Document No.",
        "Doc. No. Occurrence","Version No.","Line No.");
    end;
*/


    
//     procedure CopyTempLines (SalesHeaderArchive@1003 : Record 5107;var TempSalesLine@1000 :
    
/*
procedure CopyTempLines (SalesHeaderArchive: Record 5107;var TempSalesLine: Record 37 TEMPORARY)
    var
//       SalesLineArchive@1001 :
      SalesLineArchive: Record 5108;
    begin
      DELETEALL;

      SalesLineArchive.SETRANGE("Document Type",SalesHeaderArchive."Document Type");
      SalesLineArchive.SETRANGE("Document No.",SalesHeaderArchive."No.");
      SalesLineArchive.SETRANGE("Version No.",SalesHeaderArchive."Version No.");
      if SalesLineArchive.FINDSET then
        repeat
          INIT;
          Rec := SalesLineArchive;
          INSERT;
          TempSalesLine.TRANSFERFIELDS(SalesLineArchive);
          TempSalesLine.INSERT;
        until SalesLineArchive.NEXT = 0;
    end;

    /*begin
    end.
  */
}




