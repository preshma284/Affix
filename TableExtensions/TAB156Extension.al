tableextension 50144 "QBU ResourceExt" extends "Resource"
{
  
  DataCaptionFields="No.","Name";
    CaptionML=ENU='Resource',ESP='Recurso';
    LookupPageID="Resource List";
    DrillDownPageID="Resource List";
  
  fields
{
    field(50000;"QBU Do Not Control In Contracts";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Do Not Control In Contracts',ESP='No controlar en contratos';
                                                   Description='BS::19831';


    }
    field(7207270;"QBU Jobs Deviation";Code[20])
    {
        TableRelation=Job WHERE ("Status"=CONST("Open"));
                                                   CaptionML=ENU='Jobs desviation',ESP='Proyecto desviaci¢n';
                                                   Description='QB 1.00 - QB2411';


    }
    field(7207271;"QBU Jobs Not Assigned";Code[20])
    {
        TableRelation="Job";
                                                   CaptionML=ENU='Jobs Not Assignes',ESP='Proyecto no asignadas';
                                                   Description='QB 1.00 - QB2411';


    }
    field(7207272;"QBU Type Calendar";Code[10])
    {
        TableRelation="Type Calendar";
                                                   CaptionML=ENU='Type Calendar',ESP='Calendario tipo';
                                                   Description='QB 1.00 - QB2411';


    }
    field(7207273;"QBU Cod. Type Jobs not Assigned";Code[10])
    {
        TableRelation="Work Type";
                                                   CaptionML=ENU='Cod. Type Jobs not Assigned',ESP='Cod. tipo proyecto no asignado';
                                                   Description='QB 1.00 - QB2411';


    }
    field(7207274;"QBU Activity Code";Code[20])
    {
        TableRelation="Activity QB";
                                                   CaptionML=ENU='Activity Code',ESP='Cod. actividad';
                                                   Description='QB 1.00 - QB2513';


    }
    field(7207275;"QBU Created by PRESTO S/N";Boolean)
    {
        CaptionML=ENU='Create by Presto S/N',ESP='Creado desde PRESTO';
                                                   Description='QB 1.00 - QB2411';
                                                   Editable=false;


    }
    field(7207276;"QBU Cod. C.A. Indirect Costs";Code[20])
    {
        TableRelation="Dimension Value"."Code";
                                                   

                                                   CaptionML=ENU='Cod. C.A. Indirects Costs',ESP='C.A. Costes Indirectos';
                                                   Description='QB 1.00 - QB2411';

trigger OnLookup();
    VAR
//                                                               FunctionQB@100000001 :
                                                              FunctionQB: Codeunit 7207272;
                                                            BEGIN 
                                                              FunctionQB.LookUpCA("Cod. C.A. Indirect Costs",FALSE);
                                                            END;


    }
    field(7207277;"QBU Cod. Type Depreciation Jobs";Code[10])
    {
        TableRelation="Work Type";
                                                   CaptionML=ENU='Cod. Type Depreciation Jobs',ESP='Cod. tipo trabajo amortizaci¢n';
                                                   Description='QB 1.00 - QB2411';


    }
    field(7207278;"QBU Potency (PH)";Decimal)
    {
        CaptionML=ENU='Potency(PH)',ESP='Potencia(PH)';
                                                   Description='QB 1.00 - QB2411';


    }
    field(7207279;"QBU Actual Cost";Decimal)
    {
        CaptionML=ENU='Actual Cost',ESP='Coste Actual';
                                                   Description='QB 1.00 - QB2411';


    }
    field(7207280;"QBU Usage (ITS/HR x HP)";Decimal)
    {
        CaptionML=ENU='Usage (ITS/HR x HP)',ESP='Consumo(ITS/HR x HP)';
                                                   Description='QB 1.00 - QB2411';


    }
    field(7207281;"QBU Cod. C.A. Direct Costs";Code[20])
    {
        TableRelation="Dimension Value"."Code";
                                                   

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Cod. C.A. Indirects Costs',ESP='C.A. Costes Directos';
                                                   Description='QB 1.06.08 - JAV 14/08/20: - Concepto anal¡tico para usar en costes directos';

trigger OnLookup();
    VAR
//                                                               FunctionQB@100000001 :
                                                              FunctionQB: Codeunit 7207272;
                                                            BEGIN 
                                                              FunctionQB.LookUpCA("Cod. C.A. Direct Costs",FALSE);
                                                            END;


    }
    field(7207282;"QBU Proformable";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Asignable a proforma';
                                                   Description='QB 1.08.41 - JAV 21/04/21: - Si el recurso se puede asignar a una proforma (por defecto los que sean tipo subcontrata lo ser n)';


    }
    field(7207496;"QBU Data Missed";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Data Missed';
                                                   Description='QB 1.06.14 JAV 17/08/20: - Si faltan datos obligatorios';
                                                   Editable=false;


    }
    field(7207497;"QBU Data Missed Message";Text[50])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Data Missed Message',ESP='Datos Obligatorios que faltan';
                                                   Description='QB 1.06.14 JAV 17/08/20: - Texto con los datos que faltan';
                                                   Editable=false;


    }
    field(7207498;"QBU Data Missed Old Blocked";Boolean)
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Last Blocked';
                                                   Description='QB 1.06.14 JAV 17/08/20: - Estado del bloqueo antes de faltar datos para poder reponerlo' ;

trigger OnValidate();
    VAR
//                                                                 CustLedgerEntry@1001 :
                                                                CustLedgerEntry: Record 21;
//                                                                 AccountingPeriod@1002 :
                                                                AccountingPeriod: Record 50;
//                                                                 IdentityManagement@1000 :
                                                                IdentityManagement: Codeunit 9801;
                                                              BEGIN 
                                                              END;


    }
}
  keys
{
   // key(key1;"No.")
  //  {
       /* Clustered=true;
 */
   // }
   // key(key2;"Search Name")
  //  {
       /* ;
 */
   // }
   // key(key3;"Gen. Prod. Posting Group")
  //  {
       /* ;
 */
   // }
   // key(key4;"Name")
  //  {
       /* ;
 */
   // }
   // key(key5;"Type")
  //  {
       /* ;
 */
   // }
   // key(key6;"Base Unit of Measure")
  //  {
       /* ;
 */
   // }
}
  fieldgroups
{
   // fieldgroup(DropDown;"No.","Name","Type","Base Unit of Measure")
   // {
       // 
   // }
   // fieldgroup(Brick;"No.","Name","Type","Base Unit of Measure","Image")
   // {
       // 
   // }
}
  
    var
//       Text001@1001 :
      Text001: TextConst ENU='Do you want to change %1?',ESP='¨Confirma que desea cambiar %1?';
//       ResSetup@1002 :
      ResSetup: Record 314;
//       Res@1003 :
      Res: Record 156;
//       ResCapacityEntry@1004 :
      ResCapacityEntry: Record 160;
//       CommentLine@1006 :
      CommentLine: Record 97;
//       ResCost@1007 :
      ResCost: Record 202;
//       ResPrice@1008 :
      ResPrice: Record 201;
//       SalesOrderLine@1009 :
      SalesOrderLine: Record 37;
//       ExtTextHeader@1010 :
      ExtTextHeader: Record 279;
//       PostCode@1011 :
      PostCode: Record 225;
//       GenProdPostingGrp@1012 :
      GenProdPostingGrp: Record 251;
//       ResSkill@1016 :
      ResSkill: Record 5956;
//       ResLoc@1017 :
      ResLoc: Record 5952;
//       ResServZone@1018 :
      ResServZone: Record 5958;
//       ResUnitMeasure@1020 :
      ResUnitMeasure: Record 205;
//       PlanningLine@1005 :
      PlanningLine: Record 1003;
//       NoSeriesMgt@1013 :
      NoSeriesMgt: Codeunit 396;
//       MoveEntries@1014 :
      MoveEntries: Codeunit 361;
//       DimMgt@1015 :
      DimMgt: Codeunit 408;
//       Text002@1019 :
      Text002: TextConst ENU='You cannot change %1 because there are ledger entries for this resource.',ESP='No puede cambiar el %1 por que hay movs. contables para este recurso.';
//       Text004@1022 :
      Text004: TextConst ENU='Before you can use Online Map, you must fill in the Online Map Setup window.\See Setting Up Online Map in Help.',ESP='Para poder usar Online Map, primero debe rellenar la ventana Configuraci¢n Online Map.\Consulte Configuraci¢n de Online Map en la Ayuda.';
//       TimeSheetMgt@1023 :
      TimeSheetMgt: Codeunit 950;
//       Text005@1024 :
      Text005: TextConst ENU='%1 cannot be changed since unprocessed time sheet lines exist for this resource.',ESP='%1 no se puede cambiar puesto que existen l¡neas del parte de horas no procesadas para este recurso.';
//       Text006@1025 :
      Text006: 
// You cannot delete Resource LIFT since unprocessed time sheet lines exist for this resource.
TextConst ENU='You cannot delete %1 %2 because unprocessed time sheet lines exist for this resource.',ESP='No se puede eliminar %1 %2 porque existen l¡neas de parte de horas no procesadas para este recurso.';
//       BaseUnitOfMeasureQtyMustBeOneErr@1026 :
      BaseUnitOfMeasureQtyMustBeOneErr: 
// "%1 Name of Unit of measure (e.g. BOX, PCS, KG...), %2 Qty. of %1 per base unit of measure "
TextConst ENU='The quantity per base unit of measure must be 1. %1 is set up with %2 per unit of measure.',ESP='La cantidad por unidad de medida base debe ser 1. %1 est  configurada con %2 por unidad de medida.';
//       CannotDeleteResourceErr@1027 :
      CannotDeleteResourceErr: 
// "%1 = Resource No."
TextConst ENU='You cannot delete resource %1 because it is used in one or more job planning lines.',ESP='No puede eliminar el recurso %1 porque se usa en una o m s l¡neas de planificaci¢n de proyecto.';
//       SalesDocumentExistsErr@1028 :
      SalesDocumentExistsErr: 
// "%1 = Resource No."
TextConst ENU='You cannot delete resource %1 because there are one or more outstanding %2 that include this resource.',ESP='No puede borrar el recurso %1 porque hay uno o m s %2 pendientes que incluyen este recurso.';
//       PrivacyBlockedPostErr@7001104 :
      PrivacyBlockedPostErr: 
// "%1=resource no."
TextConst ENU='You cannot post this line because resource %1 is blocked due to privacy.',ESP='No puede registrar esta l­nea porque el recurso %1 estÿ bloqueado por motivos de privacidad.';
//       PrivacyBlockedErr@7001105 :
      PrivacyBlockedErr: 
// "%1=resource no."
TextConst ENU='You cannot create this line because resource %1 is blocked due to privacy.',ESP='No puede crear esta l­nea porque el recurso %1 estÿ bloqueado por motivos de privacidad.';
//       ConfirmBlockedPrivacyBlockedQst@7001106 :
      ConfirmBlockedPrivacyBlockedQst: TextConst ENU='if you change the Blocked field, the Privacy Blocked field is changed to No. Do you want to continue?',ESP='Si cambia el campo Bloqueado, se cambiarÿ el campo Privacidad bloqueada a No. ùDesea continuar?';
//       CanNotChangeBlockedDueToPrivacyBlockedErr@7001107 :
      CanNotChangeBlockedDueToPrivacyBlockedErr: TextConst ENU='The Blocked field cannot be changed because the user is blocked for privacy reasons.',ESP='No se puede cambiar el campo Bloqueado porque el usuario estÿ bloqueado por motivos de privacidad.';
//       "--------------------------- QB"@1100286001 :
      "--------------------------- QB": Integer;
//       FunctionQB@1100286002 :
      FunctionQB: Codeunit 7207272;

    
    


/*
trigger OnInsert();    begin
               if "No." = '' then begin
                 ResSetup.GET;
                 ResSetup.TESTFIELD("Resource Nos.");
                 NoSeriesMgt.InitSeries(ResSetup."Resource Nos.",xRec."No. Series",0D,"No.","No. Series");
               end;

               if GETFILTER("Resource Group No.") <> '' then
                 if GETRANGEMIN("Resource Group No.") = GETRANGEMAX("Resource Group No.") then
                   VALIDATE("Resource Group No.",GETRANGEMIN("Resource Group No."));

               DimMgt.UpdateDefaultDim(
                 DATABASE::Resource,"No.",
                 "Global Dimension 1 Code","Global Dimension 2 Code");
             end;


*/

/*
trigger OnModify();    begin
               "Last Date Modified" := TODAY;
             end;


*/

/*
trigger OnDelete();    begin
               CheckJobPlanningLine;

               MoveEntries.MoveResEntries(Rec);

               ResCapacityEntry.SETCURRENTKEY("Resource No.");
               ResCapacityEntry.SETRANGE("Resource No.","No.");
               ResCapacityEntry.DELETEALL;

               ResCost.SETRANGE(Type,ResCost.Type::Resource);
               ResCost.SETRANGE(Code,"No.");
               ResCost.DELETEALL;

               ResPrice.SETRANGE(Type,ResPrice.Type::Resource);
               ResPrice.SETRANGE(Code,"No.");
               ResPrice.DELETEALL;

               CommentLine.SETRANGE("Table Name",CommentLine."Table Name"::Resource);
               CommentLine.SETRANGE("No.","No.");
               CommentLine.DELETEALL;

               ExtTextHeader.SETRANGE("Table Name",ExtTextHeader."Table Name"::Resource);
               ExtTextHeader.SETRANGE("No.","No.");
               ExtTextHeader.DELETEALL(TRUE);

               ResSkill.RESET;
               ResSkill.SETRANGE(Type,ResSkill.Type::Resource);
               ResSkill.SETRANGE("No.","No.");
               ResSkill.DELETEALL;

               ResLoc.RESET;
               ResLoc.SETCURRENTKEY("Resource No.","Starting Date");
               ResLoc.SETRANGE("Resource No.","No.");
               ResLoc.DELETEALL;

               ResServZone.RESET;
               ResServZone.SETRANGE("Resource No.","No.");
               ResServZone.DELETEALL;

               ResUnitMeasure.RESET;
               ResUnitMeasure.SETRANGE("Resource No.","No.");
               ResUnitMeasure.DELETEALL;

               SalesOrderLine.SETCURRENTKEY(Type,"No.");
               SalesOrderLine.SETRANGE(Type,SalesOrderLine.Type::Resource);
               SalesOrderLine.SETRANGE("No.","No.");
               if SalesOrderLine.FINDFIRST then
                 ERROR(SalesDocumentExistsErr,"No.",SalesOrderLine."Document Type");

               if ExistUnprocessedTimeSheets then
                 ERROR(Text006,TABLECAPTION,"No.");

               DimMgt.DeleteDefaultDim(DATABASE::Resource,"No.");
             end;


*/

/*
trigger OnRename();    var
//                SalesLine@1000 :
               SalesLine: Record 37;
             begin
               SalesLine.RenameNo(SalesLine.Type::Resource,xRec."No.","No.");
               DimMgt.RenameDefaultDim(DATABASE::Resource,xRec."No.","No.");

               "Last Date Modified" := TODAY;
             end;

*/



// procedure AssistEdit (OldRes@1000 :

/*
procedure AssistEdit (OldRes: Record 156) : Boolean;
    begin
      WITH Res DO begin
        Res := Rec;
        ResSetup.GET;
        ResSetup.TESTFIELD("Resource Nos.");
        if NoSeriesMgt.SelectSeries(ResSetup."Resource Nos.",OldRes."No. Series","No. Series") then begin
          ResSetup.GET;
          ResSetup.TESTFIELD("Resource Nos.");
          NoSeriesMgt.SetSeries("No.");
          Rec := Res;
          exit(TRUE);
        end;
      end;
    end;
*/


    
//     procedure ValidateShortcutDimCode (FieldNumber@1000 : Integer;var ShortcutDimCode@1001 :
    procedure ValidateShortcutDimCode (FieldNumber: Integer;var ShortcutDimCode: Code[20])
    var
//       QBTablePublisher@100000000 :
      QBTablePublisher: Codeunit 7207346;
    begin
      DimMgt.ValidateDimValueCode(FieldNumber,ShortcutDimCode);
      DimMgt.SaveDefaultDim(DATABASE::Resource,"No.",FieldNumber,ShortcutDimCode);
      MODIFY;
      QBTablePublisher.ValidateShortCutDimCodeResource(ShortcutDimCode,Rec);
    end;

    
    
/*
procedure DisplayMap ()
    var
//       MapPoint@1001 :
      MapPoint: Record 800;
//       MapMgt@1000 :
      MapMgt: Codeunit 802;
    begin
      if MapPoint.FINDFIRST then
        MapMgt.MakeSelection(DATABASE::Resource,GETPOSITION)
      else
        MESSAGE(Text004);
    end;
*/


    
//     procedure GetUnitOfMeasureFilter (No@1000 : Code[20];UnitofMeasureCode@1002 :
    
/*
procedure GetUnitOfMeasureFilter (No: Code[20];UnitofMeasureCode: Code[10]) Filter : Text;
    var
//       ResourceUnitOfMeasure@1001 :
      ResourceUnitOfMeasure: Record 205;
    begin
      ResourceUnitOfMeasure.GET(No,UnitofMeasureCode);
      if ResourceUnitOfMeasure."Related to Base Unit of Meas." then begin
        CLEAR(ResourceUnitOfMeasure);
        ResourceUnitOfMeasure.SETRANGE("Resource No.",No);
        ResourceUnitOfMeasure.SETRANGE("Related to Base Unit of Meas.",TRUE);
        if ResourceUnitOfMeasure.FINDSET then begin
          repeat
            Filter := Filter + GetQuotedCode(ResourceUnitOfMeasure.Code) + '|';
          until ResourceUnitOfMeasure.NEXT = 0;
          Filter := DELSTR(Filter,STRLEN(Filter));
        end;
      end else
        Filter := GetQuotedCode(UnitofMeasureCode);
    end;
*/


    
/*
LOCAL procedure ExistUnprocessedTimeSheets () : Boolean;
    var
//       TimeSheetHeader@1001 :
      TimeSheetHeader: Record 950;
//       TimeSheetLine@1002 :
      TimeSheetLine: Record 951;
    begin
      TimeSheetHeader.SETCURRENTKEY("Resource No.");
      TimeSheetHeader.SETRANGE("Resource No.","No.");
      if TimeSheetHeader.FINDSET then
        repeat
          TimeSheetLine.SETRANGE("Time Sheet No.",TimeSheetHeader."No.");
          TimeSheetLine.SETRANGE(Posted,FALSE);
          if not TimeSheetLine.ISEMPTY then
            exit(TRUE);
        until TimeSheetHeader.NEXT = 0;

      exit(FALSE);
    end;
*/


    
    
/*
procedure CreateTimeSheets ()
    var
//       Resource@1000 :
      Resource: Record 156;
    begin
      TESTFIELD("Use Time Sheet",TRUE);
      Resource.GET("No.");
      Resource.SETRECFILTER;
      REPORT.RUNMODAL(REPORT::"Create Time Sheets",TRUE,FALSE,Resource);
    end;
*/


//     LOCAL procedure GetQuotedCode (Code@1000 :
    
/*
LOCAL procedure GetQuotedCode (Code: Text) : Text;
    begin
      exit(STRSUBSTNO('''%1''',Code));
    end;
*/


//     LOCAL procedure TestNoEntriesExist (CurrentFieldName@1001 :
    
/*
LOCAL procedure TestNoEntriesExist (CurrentFieldName: Text[100])
    var
//       ResLedgEntry@1000 :
      ResLedgEntry: Record 203;
    begin
      ResLedgEntry.SETRANGE("Resource No.","No.");
      if not ResLedgEntry.ISEMPTY then
        ERROR(Text002,CurrentFieldName);
    end;
*/


    
/*
LOCAL procedure CheckJobPlanningLine ()
    var
//       JobPlanningLine@1001 :
      JobPlanningLine: Record 1003;
    begin
      JobPlanningLine.SETCURRENTKEY(Type,"No.");
      JobPlanningLine.SETRANGE(Type,JobPlanningLine.Type::Resource);
      JobPlanningLine.SETRANGE("No.","No.");
      if not JobPlanningLine.ISEMPTY then
        ERROR(CannotDeleteResourceErr,"No.");
    end;
*/


    
//     procedure CheckResourcePrivacyBlocked (IsPosting@1000 :
    
/*
procedure CheckResourcePrivacyBlocked (IsPosting: Boolean)
    begin
      if "Privacy Blocked" then begin
        if IsPosting then
          ERROR(PrivacyBlockedPostErr,"No.");
        ERROR(PrivacyBlockedErr,"No.");
      end;
    end;

    /*begin
    //{
//      BS::19831 CSM 30/10/23 Í Bolsas de contrataci¢n en proy.  New Field 50000.
//    }
    end.
  */
}





