tableextension 50192 "QBU Purchase Line ArchiveExt" extends "Purchase Line Archive"
{
  
  
    CaptionML=ENU='Purchase Line Archive',ESP='Archivo l¡n. compra';/*
PasteIsValid=false;
*/
  ;
  fields
{
    field(7207270;"QBU % Withholding by G.E";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='% Withholding by G.E',ESP='% retenci¢n pago B.E.';
                                                   Description='QB 1.00 - QB22111     JAV 19/09/19: - Se cambia el caption';
                                                   Editable=false;


    }
    field(7207271;"QBU Withholding Amount by G.E";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Withholding Amount by G.E',ESP='Importe ret. pago B.E.';
                                                   Description='QB 1.00 - QB22111     JAV 19/09/19: - Se cambia el caption';
                                                   Editable=false;
                                                   AutoFormatType=1;


    }
    field(7207272;"QBU % Withholding by PIT";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='% Withholding by PIT',ESP='% retenci¢n IRPF';
                                                   Description='QB 1.00 - QB22111';
                                                   Editable=false;


    }
    field(7207273;"QBU Withholding Amount by PIT";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Withholding Amount by PIT',ESP='Importe retenci¢n por IRPF';
                                                   Description='QB 1.00 - QB22111';
                                                   Editable=false;
                                                   AutoFormatType=1;


    }
    field(7207274;"QBU Piecework No.";Text[20])
    {
        TableRelation="Data Piecework For Production"."Piecework Code" WHERE ("Job No."=FIELD("Job No."),
                                                                                                                         "Production Unit"=FILTER(true));
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Piecework No.',ESP='N§ unidad de obra';
                                                   Description='QB 1.00 - QB2514';


    }
    field(7207275;"QBU Qty. to Receive Origin";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Qty. to Receive Origin',ESP='Cantidad a recibir a origen';
                                                   DecimalPlaces=0:5;
                                                   Description='QB 1.00 - QB2517';


    }
    field(7207278;"QBU Updated budget";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Updated budget',ESP='Presupuesto actualizado';
                                                   Description='QB 1.00 - QB2516';


    }
    field(7207279;"QBU Usage Document";Code[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Usage Document',ESP='Documento Utilizaci¢n';
                                                   Description='QB 1.00 - QB25110';
                                                   Editable=false;


    }
    field(7207280;"QBU Usage Document Line";Integer)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Usage Document Line',ESP='L¡n. Documento Utilizaci¢n';
                                                   Description='QB 1.00 - QB25110';
                                                   Editable=false;


    }
    field(7207281;"QBU Receive in FRIS";Boolean)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Lookup("Purch. Rcpt. Header"."Receive in FRIS" WHERE ("No."=FIELD("Document No.")));
                                                   CaptionML=ENU='Receive in FRIS',ESP='Recibir en FRI''S';
                                                   Description='QB 1.00 -';
                                                   Editable=false;


    }
    field(7207282;"QBU Code Piecework PRESTO";Code[40])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Code Piecework PRESTO',ESP='C¢d. U.O PRESTO';
                                                   Description='QB 1.00 - QB3685';


    }
    field(7207283;"QBU Not apply Withholding by G.E";Boolean)
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Cod. Withholding by G.E',ESP='No aplicar ret. B.E.';
                                                   Description='QB 1.00 - JAV 11/08/19: - Si no se aplica la retenci¢n por Buena Ejecuci¢n a la linea';

trigger OnValidate();
    VAR
//                                                                 Withholdingtreating@100000000 :
                                                                Withholdingtreating: Codeunit 7207306;
                                                              BEGIN 
                                                              END;


    }
    field(7207284;"QBU Not apply Withholding by PIT";Boolean)
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Cod. Withholding by PIT',ESP='No aplicar ret. IRPF';
                                                   Description='QB 1.00 - JAV 11/08/19: - Si no se aplica la retenci¢n por IRPF a la l¡nea';

trigger OnValidate();
    VAR
//                                                                 Withholdingtreating@100000000 :
                                                                Withholdingtreating: Codeunit 7207306;
                                                              BEGIN 
                                                              END;


    }
    field(7207285;"QBU Base Withholding by G.E";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='% Withholding by G.E',ESP='Base ret. pago B.E.';
                                                   Description='QB 1.00 - JAV 11/08/19: - Base de c lculo de la retenci¢n por B.E.                       JAV 19/09/19: - Se cambia el caption';
                                                   Editable=false;


    }
    field(7207286;"QBU Base Withholding by PIT";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='% Withholding by PIT',ESP='Base ret. IRPF';
                                                   Description='QB 1.00 - JAV 11/08/19: - Base de c lculo de la retenci¢n por IRPF';
                                                   Editable=false;


    }
    field(7207287;"QBU Withholding by G.E Line";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Cod. Withholding by G.E',ESP='L¡nea de retenci¢n de B.E.';
                                                   Description='QB 1.00 - JAV 18/08/19: - Si es la l¡nea donde se calcula la retenci¢n por Buena Ejecuci¢n';


    }
    field(7207291;"QBU Cancelled";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Anulada';
                                                   Description='QB 1.00 - JAV  06/07/19: - Si se ha cancelado la l¡nea';


    }
}
  keys
{
   // key(key1;"Document Type","Document No.","Line No.","Doc. No. Occurrence","Version No.")
  //  {
       /* ;
 */
   // }
   // key(key2;"Buy-from Vendor No.")
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
//                PurchCommentLineArch@1000 :
               PurchCommentLineArch: Record 5125;
//                DeferralHeaderArchive@1001 :
               DeferralHeaderArchive: Record 5127;
             begin
               PurchCommentLineArch.SETRANGE("Document Type","Document Type");
               PurchCommentLineArch.SETRANGE("No.","No.");
               PurchCommentLineArch.SETRANGE("Document Line No.","Line No.");
               PurchCommentLineArch.SETRANGE("Doc. No. Occurrence","Doc. No. Occurrence");
               PurchCommentLineArch.SETRANGE("Version No.","Version No.");
               if not PurchCommentLineArch.ISEMPTY then
                 PurchCommentLineArch.DELETEALL;

               if "Deferral Code" <> '' then
                 DeferralHeaderArchive.DeleteHeader(DeferralUtilities.GetPurchDeferralDocType,
                   "Document Type","Document No.","Doc. No. Occurrence","Version No.","Line No.");
             end;

*/



// procedure GetCaptionClass (FieldNumber@1000 :

/*
procedure GetCaptionClass (FieldNumber: Integer) : Text[80];
    var
//       PurchaseHeaderArchive@1001 :
      PurchaseHeaderArchive: Record 5109;
    begin
      if not PurchaseHeaderArchive.GET("Document Type","Document No.","Doc. No. Occurrence","Version No.") then begin
        PurchaseHeaderArchive."No." := '';
        PurchaseHeaderArchive.INIT;
      end;
      if PurchaseHeaderArchive."Prices Including VAT" then
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
      Field.GET(DATABASE::"Purchase Line",FieldNumber);
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
//       PurchCommentLineArch@1000 :
      PurchCommentLineArch: Record 5125;
//       PurchArchCommentSheet@1001 :
      PurchArchCommentSheet: Page 5179;
    begin
      PurchCommentLineArch.SETRANGE("Document Type","Document Type");
      PurchCommentLineArch.SETRANGE("No.","Document No.");
      PurchCommentLineArch.SETRANGE("Document Line No.","Line No.");
      PurchCommentLineArch.SETRANGE("Doc. No. Occurrence","Doc. No. Occurrence");
      PurchCommentLineArch.SETRANGE("Version No.","Version No.");
      CLEAR(PurchArchCommentSheet);
      PurchArchCommentSheet.SETTABLEVIEW(PurchCommentLineArch);
      PurchArchCommentSheet.RUNMODAL;
    end;
*/


    
    
/*
procedure ShowDeferrals ()
    begin
      DeferralUtilities.OpenLineScheduleArchive(
        "Deferral Code",DeferralUtilities.GetPurchDeferralDocType,
        "Document Type","Document No.",
        "Doc. No. Occurrence","Version No.","Line No.");
    end;

    /*begin
    end.
  */
}





