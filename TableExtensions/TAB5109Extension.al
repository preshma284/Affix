tableextension 50191 "QBU Purchase Header ArchiveExt" extends "Purchase Header Archive"
{
  
  DataCaptionFields="No.","Buy-from Vendor Name","Version No.";
    CaptionML=ENU='Purchase Header Archive',ESP='Archivo cab. compra';
    LookupPageID="Purchase List Archive";
    DrillDownPageID="Purchase List Archive";
  
  fields
{
    field(7207270;"QBU Cod. Withholding by G.E";Code[20])
    {
        TableRelation="Withholding Group"."Code" WHERE ("Withholding Type"=FILTER("G.E"),
                                                                                                 "Use in"=FILTER('Booth'|'Vendor'));
                                                   CaptionML=ENU='Cod. Withholding by G.E',ESP='C¢d. retenci¢n por B.E.';
                                                   Description='QB22111';


    }
    field(7207271;"QBU Cod. Withholding by PIT";Code[20])
    {
        TableRelation="Withholding Group"."Code" WHERE ("Withholding Type"=FILTER("PIT"),
                                                                                                 "Use in"=FILTER('Booth'|'Vendor'));
                                                   CaptionML=ENU='Cod. Withholding by PIT',ESP='C¢d. retenci¢n por IRPF';
                                                   Description='QB22111';


    }
    field(7207272;"QBU Total Withholding G.E";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("Purchase Line"."QW Withholding Amount by GE" WHERE ("Document Type"=FIELD("Document Type"),
                                                                                                                        "Document No."=FIELD("No.")));
                                                   CaptionML=ENU='Total Withholding G.E',ESP='Total retenci¢n B.E.';
                                                   Description='QB22111';
                                                   Editable=false;


    }
    field(7207273;"QBU Total Withholding PIT";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("Purchase Line"."QW Withholding Amount by PIT" WHERE ("Document Type"=FIELD("Document Type"),
                                                                                                                         "Document No."=FIELD("No.")));
                                                   CaptionML=ENU='Total Withholding PIT',ESP='Total retenci¢n IRPF';
                                                   Description='QB22111';
                                                   Editable=false;


    }
    field(7207275;"QBU Order To";Option)
    {
        OptionMembers="Job","Location";CaptionML=ENU='Order To',ESP='Pedido contra';
                                                   OptionCaptionML=ENU='Job,Location',ESP='Proyecto,Almac‚n';
                                                   
                                                   Description='QB2514';


    }
    field(7207276;"QBU Job No.";Code[20])
    {
        TableRelation="Job";
                                                   CaptionML=ENU='Job No.',ESP='N§ proyecto';
                                                   Description='QB2514';


    }
    field(7207277;"QBU Temp Document Date";Date)
    {
        DataClassification=ToBeClassified;
                                                   Description='QB 1.00 - JAV 20/03/20: - Para guardar temporalmente la fecha del documento en procesos de validaci¢n';


    }
    field(7207278;"QBU Receipt Date";Date)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Fecha Recepci¢n';
                                                   Description='QB 1.00 - JAV 08/01/20: ROIG_CYS GAP12 - Recepci¢n de documentos, fecha de recepci¢n';


    }
    field(7207279;"QBU Total document amount";Decimal)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Importe Proveedor';
                                                   Description='QB 1.00 - JAV 08/01/20: ROIG_CYS GAP12 - Recepci¢n de documentos, importe del documento';


    }
    field(7207280;"QBU Operation date SII";Date)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Fecha operaci¢n SII';
                                                   Description='QB 1.00 - QB5555 JAV 04/07/19: Fecha de operaci¢n para el SII';


    }
    field(7207284;"QBU _Date Fax";Date)
    {
        ObsoleteState=Removed;
                                                   ObsoleteReason='Ya no se utiliza';
                                                   CaptionML=ENU='Date Fax',ESP='Fecha Fax';
                                                   Description='QB 1.00 - ### ELIMINAR ### no se usa';


    }
    field(7207285;"QBU Contract";Boolean)
    {
        CaptionML=ENU='Contrato',ESP='Contrato';
                                                   Description='QB2515';


    }
    field(7207289;"QBU Receive in FRIS";Boolean)
    {
        CaptionML=ENU='Receive in FRIS',ESP='Recibir en FRIS';
                                                   Description='QB2517';


    }
    field(7207292;"QBU Cancelled";Boolean)
    {
        CaptionML=ENU='Voided',ESP='Anulado';
                                                   Description='QB';
                                                   Editable=false;


    }
    field(7207293;"QBU No. Receipt Cancel";Code[20])
    {
        CaptionML=ENU='No. Recieving Void',ESP='N§ albaran que anula';
                                                   Description='QB';


    }
    field(7207294;"QBU First Receipt";Boolean)
    {
        CaptionML=ENU='QB First Receipt',ESP='QB First Receipt';


    }
    field(7207295;"QBU Contract No.";Code[20])
    {
        TableRelation="Purchase Header"."No." WHERE ("Document Type"=CONST("Order"));
                                                   

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Order to Cancel',ESP='N§ Contrato';
                                                   Description='JAV 15/06/19: - Sobre que contrato estamos trabajando';

trigger OnLookup();
    VAR
//                                                               QBPageSubscriber@100000000 :
                                                              QBPageSubscriber: Codeunit 7207349;
                                                            BEGIN 
                                                            END;


    }
    field(7207296;"QBU Base Withholding G.E";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("Purchase Line"."QW Base Withholding by GE" WHERE ("Document Type"=FIELD("Document Type"),
                                                                                                                      "Document No."=FIELD("No.")));
                                                   CaptionML=ENU='Total Withholding G.E',ESP='Base retenci¢n B.E.';
                                                   Description='QB22111';
                                                   Editable=false;


    }
    field(7207297;"QBU Base Withholding PIT";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("Purchase Line"."QW Base Withholding by PIT" WHERE ("Document Type"=FIELD("Document Type"),
                                                                                                                       "Document No."=FIELD("No.")));
                                                   CaptionML=ENU='Total Withholding PIT',ESP='Base retenci¢n IRPF';
                                                   Description='QB22111';
                                                   Editable=false;


    }
    field(7207298;"QBU Total Withholding G.E Before";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("Purchase Line"."Amount" WHERE ("Document Type"=FIELD("Document Type"),
                                                                                                 "Document No."=FIELD("No."),
                                                                                                 "QW Withholding by GE Line"=CONST(true)));
                                                   CaptionML=ENU='Total Withholding G.E',ESP='Total retenci¢n B.E. Fra.';
                                                   Description='JAV 23/10/19: - Se doblan los campos de la retenci¢n de B.E. para tener ambos importes disponibles';
                                                   Editable=false;


    }
    field(7207299;"QBU Obralia Entry";Integer)
    {
        TableRelation="Obralia Log Entry";
                                                   

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Obralia User ID',ESP='Obralia';
                                                   Description='QB 1.05.06 - JAV 23/07/20 : - Entrada en el registro de Obralia';
                                                   Editable=false;

trigger OnValidate();
    VAR
//                                                                 ObraliaLogEntry@1100286000 :
                                                                ObraliaLogEntry: Record 7206904;
//                                                                 PurchasesPayablesSetup@1100286001 :
                                                                PurchasesPayablesSetup: Record 312;
                                                              BEGIN 
                                                              END;


    }
    field(7207302;"QBU Approval Situation";Option)
    {
        OptionMembers="Pending","Approved","Rejected","Withheld";DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Status',ESP='Situaci¢n de la Aprobaci¢n';
                                                   OptionCaptionML=ESP='Pendiente,Aprobado,Rechazado,Retenido';
                                                   
                                                   Description='QB 1.03 - JAV 14/10/19: - Situaci¢n de la aprobaci¢n';
                                                   Editable=false;


    }
    field(7207303;"QBU Approval Coment";Text[80])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Comentario Aprobaci¢n';
                                                   Description='QB 1.03 - JAV 14/10/19: - éltimo comentario de la aprobaci¢n, retenci¢n o rechazo';
                                                   Editable=false;


    }
    field(7207304;"QBU Approval Date";Date)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Fecha aprobaci¢n';
                                                   Description='QB 1.03 - JAV 14/10/19: - Feha de la aprobaci¢n, retenci¢n o rechazo';
                                                   Editable=false;


    }
    field(7207305;"QBU Approval Circuit";Option)
    {
        OptionMembers="General","Materiales","Subcontratas";

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Circuito de Aprobaci¢n';
                                                   OptionCaptionML=ESP='General,Materiales,Subcontratas';
                                                   
                                                   Description='QB 1.04 - JAV' ;

trigger OnValidate();
    VAR
//                                                                 txt001@1100286000 :
                                                                txt001: TextConst ESP='No puede usar este circuito de aprobaci¢n';
                                                              BEGIN 
                                                              END;


    }
}
  keys
{
   // key(key1;"Document Type","No.","Doc. No. Occurrence","Version No.")
  //  {
       /* Clustered=true;
 */
   // }
   // key(key2;"Document Type","Buy-from Vendor No.")
  //  {
       /* ;
 */
   // }
}
  fieldgroups
{
}
  
    var
//       PurchCommentLineArch@1001 :
      PurchCommentLineArch: Record 5125;
//       DimMgt@1002 :
      DimMgt: Codeunit 408;
//       UserSetupMgt@1000 :
      UserSetupMgt: Codeunit 5700;

    
    


/*
trigger OnDelete();    var
//                PurchaseLineArchive@1001 :
               PurchaseLineArchive: Record 5110;
//                DeferralHeaderArchive@1000 :
               DeferralHeaderArchive: Record 5127;
//                DeferralUtilities@1002 :
               DeferralUtilities: Codeunit 1720;
             begin
               PurchaseLineArchive.SETRANGE("Document Type","Document Type");
               PurchaseLineArchive.SETRANGE("Document No.","No.");
               PurchaseLineArchive.SETRANGE("Doc. No. Occurrence","Doc. No. Occurrence");
               PurchaseLineArchive.SETRANGE("Version No.","Version No.");
               PurchaseLineArchive.DELETEALL;

               PurchCommentLineArch.SETRANGE("Document Type","Document Type");
               PurchCommentLineArch.SETRANGE("No.","No.");
               PurchCommentLineArch.SETRANGE("Doc. No. Occurrence","Doc. No. Occurrence");
               PurchCommentLineArch.SETRANGE("Version No.","Version No.");
               PurchCommentLineArch.DELETEALL;

               DeferralHeaderArchive.SETRANGE("Deferral Doc. Type",DeferralUtilities.GetPurchDeferralDocType);
               DeferralHeaderArchive.SETRANGE("Document Type","Document Type");
               DeferralHeaderArchive.SETRANGE("Document No.","No.");
               DeferralHeaderArchive.SETRANGE("Doc. No. Occurrence","Doc. No. Occurrence");
               DeferralHeaderArchive.SETRANGE("Version No.","Version No.");
               DeferralHeaderArchive.DELETEALL(TRUE);
             end;

*/




/*
procedure ShowDimensions ()
    begin
      DimMgt.ShowDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2',"Document Type","No."));
    end;
*/


    
    
/*
procedure SetSecurityFilterOnRespCenter ()
    begin
      if UserSetupMgt.GetPurchasesFilter <> '' then begin
        FILTERGROUP(2);
        SETRANGE("Responsibility Center",UserSetupMgt.GetPurchasesFilter);
        FILTERGROUP(0);
      end;
    end;

    /*begin
    //{
//      JAV 21/01/22: - QB 1.10.11 Se eliminan campos relacionados con el contrato que no son utilizados en el programa para nada
//    }
    end.
  */
}





