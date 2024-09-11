tableextension 50189 "MyExtension50189" extends "Sales Header Archive"
{
  
  DataCaptionFields="No.","Sell-to Customer Name","Version No.";
    CaptionML=ENU='Sales Header Archive',ESP='Archivo cab. venta';
    LookupPageID="Sales List Archive";
    DrillDownPageID="Sales List Archive";
  
  fields
{
    field(7207270;"Cod. Withholding by G.E";Code[20])
    {
        TableRelation="Withholding Group"."Code" WHERE ("Withholding Type"=FILTER("G.E"),
                                                                                                 "Use in"=FILTER('Booth'|'Customer'));
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Cod. Wittholding by G.E.',ESP='C¢d. retenci¢n por B.E.';
                                                   Description='QB 1.00 - QB22111';


    }
    field(7207271;"Cod. Withholding by PIT";Code[20])
    {
        TableRelation="Withholding Group"."Code" WHERE ("Withholding Type"=FILTER("PIT"),
                                                                                                 "Use in"=FILTER('Booth'|'Customer'));
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Cod. Withholding by PIT',ESP='C¢d. retenci¢n por IRPF';
                                                   Description='QB 1.00 - QB22111';


    }
    field(7207272;"Total Withholding G.E";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("Sales Line"."QW Withholding Amount by GE" WHERE ("Document Type"=FIELD("Document Type"),
                                                                                                                     "Document No."=FIELD("No.")));
                                                   CaptionML=ENU='Total Withholding G.E',ESP='Total retenci¢n B.E.';
                                                   Description='QB 1.00 - QB22111';
                                                   Editable=false;


    }
    field(7207273;"Total Withholding PIT";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("Sales Line"."QW Withholding Amount by PIT" WHERE ("Document Type"=FIELD("Document Type"),
                                                                                                                      "Document No."=FIELD("No.")));
                                                   CaptionML=ENU='Total retencion IRPF',ESP='Total retenci¢n IRPF';
                                                   Description='QB 1.00 - QB22111';
                                                   Editable=false;


    }
    field(7207275;"Job No.";Code[20])
    {
        TableRelation="Job";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Job No.',ESP='No. proyecto';
                                                   Description='QB 1.00 - QB2412';


    }
    field(7207276;"Job Sale Doc. Type";Option)
    {
        OptionMembers="Standar","Equipament Advance","Advance by Store","Price Review";DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Job Sale Doc. Type',ESP='Tipo doc. venta proyecto';
                                                   OptionCaptionML=ENU='Standar,Equipament Advance,Advance by Store,Price Review',ESP='Estandar,Anticipo de maquinaria,Anticipo por acopios,Revisi¢n precios';
                                                   
                                                   Description='QB 1.00 - QB28123';


    }
    field(7207277;"Value Date";Date)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Value Date',ESP='Fecha valor';
                                                   Description='QB 1.00';


    }
    field(7207296;"Base Withholding G.E";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("Sales Line"."QW Base Withholding by GE" WHERE ("Document Type"=FIELD("Document Type"),
                                                                                                                   "Document No."=FIELD("No.")));
                                                   CaptionML=ENU='Total Withholding G.E',ESP='Base retenci¢n B.E.';
                                                   Description='QB 1.00 - QB22111';
                                                   Editable=false;


    }
    field(7207297;"Base Withholding PIT";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("Sales Line"."QW Base Withholding by PIT" WHERE ("Document Type"=FIELD("Document Type"),
                                                                                                                    "Document No."=FIELD("No.")));
                                                   CaptionML=ENU='Total Withholding PIT',ESP='Base retenci¢n IRPF';
                                                   Description='QB 1.00 - QB22111';
                                                   Editable=false;


    }
    field(7207298;"Total Withholding G.E Before";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Sum("Sales Line"."Amount" WHERE ("Document Type"=FIELD("Document Type"),
                                                                                              "Document No."=FIELD("No."),
                                                                                              "QW Withholding by GE Line"=CONST(true)));
                                                   CaptionML=ENU='Total Withholding G.E',ESP='Total retenci¢n B.E. Fra.';
                                                   Description='QB 1.00 - JAV 23/10/19: - Se doblan los campos de la retenci¢n de B.E. para tener ambos importes disponibles';
                                                   Editable=false;


    }
    field(7207299;"Payment Bank No.";Code[20])
    {
        TableRelation="Bank Account"."No.";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='N§ de banco de cobro';
                                                   Description='QB 1.00 - Q3707' ;


    }
}
  keys
{
   // key(key1;"Document Type","No.","Doc. No. Occurrence","Version No.")
  //  {
       /* Clustered=true;
 */
   // }
   // key(key2;"Document Type","Sell-to Customer No.")
  //  {
       /* ;
 */
   // }
}
  fieldgroups
{
}
  
    var
//       SalesCommentLineArch@1001 :
      SalesCommentLineArch: Record 5126;
//       DimMgt@1002 :
      DimMgt: Codeunit 408;
//       UserSetupMgt@1000 :
      UserSetupMgt: Codeunit 5700;

    
    


/*
trigger OnDelete();    var
//                SalesLineArchive@1000 :
               SalesLineArchive: Record 5108;
//                DeferralHeaderArchive@1001 :
               DeferralHeaderArchive: Record 5127;
//                CatalogItemMgt@1002 :
               CatalogItemMgt: Codeunit 5703;
//                DeferralUtilities@1003 :
               DeferralUtilities: Codeunit 1720;
             begin
               SalesLineArchive.SETRANGE("Document Type","Document Type");
               SalesLineArchive.SETRANGE("Document No.","No.");
               SalesLineArchive.SETRANGE("Doc. No. Occurrence","Doc. No. Occurrence");
               SalesLineArchive.SETRANGE("Version No.","Version No.");
               SalesLineArchive.SETRANGE(Nonstock,TRUE);
               if SalesLineArchive.FINDSET(TRUE) then
                 repeat
                   CatalogItemMgt.DelNonStockSalesArch(SalesLineArchive);
                 until SalesLineArchive.NEXT = 0;
               SalesLineArchive.SETRANGE(Nonstock);
               SalesLineArchive.DELETEALL;

               SalesCommentLineArch.SETRANGE("Document Type","Document Type");
               SalesCommentLineArch.SETRANGE("No.","No.");
               SalesCommentLineArch.SETRANGE("Doc. No. Occurrence","Doc. No. Occurrence");
               SalesCommentLineArch.SETRANGE("Version No.","Version No.");
               SalesCommentLineArch.DELETEALL;

               DeferralHeaderArchive.SETRANGE("Deferral Doc. Type",DeferralUtilities.GetSalesDeferralDocType);
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
      if UserSetupMgt.GetSalesFilter <> '' then begin
        FILTERGROUP(2);
        SETRANGE("Responsibility Center",UserSetupMgt.GetSalesFilter);
        FILTERGROUP(0);
      end;
    end;

    /*begin
    //{
//      Q3707 19/07/18 MCG - A¤adido campo "Payment bank No."
//    }
    end.
  */
}




