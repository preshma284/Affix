tableextension 50196 "MyExtension50196" extends "Fixed Asset"
{
  
  /*
Permissions=TableData 5629 r;
*/DataCaptionFields="No.","Description";
    CaptionML=ENU='Fixed Asset',ESP='Activo fijo';
    LookupPageID="Fixed Asset List";
    DrillDownPageID="Fixed Asset List";
  
  fields
{
    field(7207270;"Asset Allocation Job";Code[20])
    {
        TableRelation="Job";
                                                   

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Asset Allocation Job',ESP='Proyecto imputaci¢n Activos';
                                                   Description='Q17292';

trigger OnValidate();
    VAR
//                                                                 DistribLines@1100286000 :
                                                                DistribLines: Record 7206999;
//                                                                 QBError001@1100286001 :
                                                                QBError001: TextConst ESP='No puede informar este campo si el activo tiene l­neas de distribuci¢n';
                                                              BEGIN 
                                                                IF "Asset Allocation Job" <> '' THEN BEGIN 
                                                                  DistribLines.RESET;
                                                                  DistribLines.SETRANGE("AF Code", "No.");
                                                                  IF NOT DistribLines.ISEMPTY THEN
                                                                    ERROR(QBError001);
                                                                END;
                                                              END;


    }
    field(7207271;"Piecework Code";Code[20])
    {
        TableRelation="Data Piecework For Production"."Piecework Code" WHERE ("Job No."=FIELD("Asset Allocation Job"));
                                                   

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Cod. unidad de obra',ESP='C¢d. unidad de obra';
                                                   Description='Q17292' ;

trigger OnValidate();
    VAR
//                                                                 DistribLines@1100286000 :
                                                                DistribLines: Record 7206999;
//                                                                 QBError001@1100286001 :
                                                                QBError001: TextConst ESP='No puede informar este campo si el activo tiene l­neas de distribuci¢n';
                                                              BEGIN 
                                                                IF "Asset Allocation Job" <> '' THEN BEGIN 
                                                                  DistribLines.RESET;
                                                                  DistribLines.SETRANGE("AF Code", "No.");
                                                                  IF NOT DistribLines.ISEMPTY THEN
                                                                    ERROR(QBError001);
                                                                END;
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
   // key(key2;"Search Description")
  //  {
       /* ;
 */
   // }
   // key(key3;"FA Class Code")
  //  {
       /* ;
 */
   // }
   // key(key4;"FA Subclass Code")
  //  {
       /* ;
 */
   // }
   // key(key5;"Component of Main Asset","Main Asset/Component")
  //  {
       /* ;
 */
   // }
   // key(key6;"FA Location Code")
  //  {
       /* ;
 */
   // }
   // key(key7;"Global Dimension 1 Code")
  //  {
       /* ;
 */
   // }
   // key(key8;"Global Dimension 2 Code")
  //  {
       /* ;
 */
   // }
   // key(key9;"FA Posting Group")
  //  {
       /* ;
 */
   // }
}
  fieldgroups
{
   // fieldgroup(DropDown;"No.","Description","FA Class Code")
   // {
       // 
   // }
   // fieldgroup(Brick;"No.","Description","FA Class Code","Image")
   // {
       // 
   // }
}
  
    var
//       Text000@1000 :
      Text000: TextConst ENU='A main asset cannot be deleted.',ESP='Un activo principal no se puede eliminar.';
//       Text001@1001 :
      Text001: TextConst ENU='You cannot delete %1 %2 because it has associated depreciation books.',ESP='No se puede eliminar %1 %2 ya que tiene asociados libros de amortizaci¢n.';
//       CommentLine@1002 :
      CommentLine: Record 97;
//       FA@1003 :
      FA: Record 5600;
//       FASetup@1004 :
      FASetup: Record 5603;
//       MaintenanceRegistration@1005 :
      MaintenanceRegistration: Record 5616;
//       MainAssetComp@1007 :
      MainAssetComp: Record 5640;
//       InsCoverageLedgEntry@1008 :
      InsCoverageLedgEntry: Record 5629;
//       FAMoveEntries@1009 :
      FAMoveEntries: Codeunit 5623;
//       NoSeriesMgt@1010 :
      NoSeriesMgt: Codeunit 396;
//       DimMgt@1011 :
      DimMgt: Codeunit 408;
//       UnexpctedSubclassErr@1006 :
      UnexpctedSubclassErr: TextConst ENU='This fixed asset subclass belongs to a different fixed asset class.',ESP='Esta subclase de activo fijo pertenece a una clase de activo fijo diferente.';
//       DontAskAgainActionTxt@1018 :
      DontAskAgainActionTxt: TextConst ENU='Don''t ask again',ESP='No volver a preguntar';
//       NotificationNameTxt@1016 :
      NotificationNameTxt: TextConst ENU='Fixed Asset Acquisition Wizard',ESP='Asistente de adquisici¢n de activos fijos';
//       NotificationDescriptionTxt@1015 :
      NotificationDescriptionTxt: TextConst ENU='Notify when ready to acquire the fixed asset.',ESP='Notificar cuando est‚ listo para comprar el activo fijo.';
//       ReadyToAcquireMsg@1014 :
      ReadyToAcquireMsg: TextConst ENU='You are ready to acquire the fixed asset.',ESP='Est  listo para comprar el activo fijo.';
//       AcquireActionTxt@1013 :
      AcquireActionTxt: TextConst ENU='Acquire',ESP='Adquirir';

    
    


/*
trigger OnInsert();    begin
               if "No." = '' then begin
                 FASetup.GET;
                 FASetup.TESTFIELD("Fixed Asset Nos.");
                 NoSeriesMgt.InitSeries(FASetup."Fixed Asset Nos.",xRec."No. Series",0D,"No.","No. Series");
               end;

               "Main Asset/Component" := "Main Asset/Component"::" ";
               "Component of Main Asset" := '';

               DimMgt.UpdateDefaultDim(
                 DATABASE::"Fixed Asset","No.",
                 "Global Dimension 1 Code","Global Dimension 2 Code");
             end;


*/

/*
trigger OnModify();    begin
               "Last Date Modified" := TODAY;
             end;


*/

/*
trigger OnDelete();    var
//                FADeprBook@1000 :
               FADeprBook: Record 5612;
             begin
               LOCKTABLE;
               MainAssetComp.LOCKTABLE;
               InsCoverageLedgEntry.LOCKTABLE;
               if "Main Asset/Component" = "Main Asset/Component"::"Main Asset" then
                 ERROR(Text000);
               FAMoveEntries.MoveFAInsuranceEntries("No.");
               FADeprBook.SETRANGE("FA No.","No.");
               FADeprBook.DELETEALL(TRUE);
               if not FADeprBook.ISEMPTY then
                 ERROR(Text001,TABLECAPTION,"No.");

               MainAssetComp.SETCURRENTKEY("FA No.");
               MainAssetComp.SETRANGE("FA No.","No.");
               MainAssetComp.DELETEALL;
               if "Main Asset/Component" = "Main Asset/Component"::Component then begin
                 MainAssetComp.RESET;
                 MainAssetComp.SETRANGE("Main Asset No.","Component of Main Asset");
                 MainAssetComp.SETRANGE("FA No.",'');
                 MainAssetComp.DELETEALL;
                 MainAssetComp.SETRANGE("FA No.");
                 if not MainAssetComp.FINDFIRST then begin
                   FA.GET("Component of Main Asset");
                   FA."Main Asset/Component" := FA."Main Asset/Component"::" ";
                   FA."Component of Main Asset" := '';
                   FA.MODIFY;
                 end;
               end;

               MaintenanceRegistration.SETRANGE("FA No.","No.");
               MaintenanceRegistration.DELETEALL;

               CommentLine.SETRANGE("Table Name",CommentLine."Table Name"::"Fixed Asset");
               CommentLine.SETRANGE("No.","No.");
               CommentLine.DELETEALL;

               DimMgt.DeleteDefaultDim(DATABASE::"Fixed Asset","No.");
             end;


*/

/*
trigger OnRename();    var
//                SalesLine@1000 :
               SalesLine: Record 37;
//                PurchaseLine@1001 :
               PurchaseLine: Record 39;
             begin
               SalesLine.RenameNo(SalesLine.Type::"Fixed Asset",xRec."No.","No.");
               PurchaseLine.RenameNo(PurchaseLine.Type::"Fixed Asset",xRec."No.","No.");
               DimMgt.RenameDefaultDim(DATABASE::"Fixed Asset",xRec."No.","No.");

               "Last Date Modified" := TODAY;
             end;

*/



// procedure AssistEdit (OldFA@1000 :

/*
procedure AssistEdit (OldFA: Record 5600) : Boolean;
    begin
      WITH FA DO begin
        FA := Rec;
        FASetup.GET;
        FASetup.TESTFIELD("Fixed Asset Nos.");
        if NoSeriesMgt.SelectSeries(FASetup."Fixed Asset Nos.",OldFA."No. Series","No. Series") then begin
          NoSeriesMgt.SetSeries("No.");
          Rec := FA;
          exit(TRUE);
        end;
      end;
    end;
*/


    
//     procedure ValidateShortcutDimCode (FieldNumber@1000 : Integer;var ShortcutDimCode@1001 :
    
/*
procedure ValidateShortcutDimCode (FieldNumber: Integer;var ShortcutDimCode: Code[20])
    begin
      DimMgt.ValidateDimValueCode(FieldNumber,ShortcutDimCode);
      DimMgt.SaveDefaultDim(DATABASE::"Fixed Asset","No.",FieldNumber,ShortcutDimCode);
      MODIFY(TRUE);
    end;
*/


    
    
/*
procedure FieldsForAcquitionInGeneralGroupAreCompleted () : Boolean;
    begin
      exit(("No." <> '') and (Description <> '') and ("FA Subclass Code" <> ''));
    end;
*/


    
    
/*
procedure ShowAcquireWizardNotification ()
    var
//       NotificationLifecycleMgt@1002 :
      NotificationLifecycleMgt: Codeunit 1511;
//       FixedAssetAcquisitionWizard@1001 :
      FixedAssetAcquisitionWizard: Codeunit 5550;
//       FAAcquireWizardNotification@1000 :
      FAAcquireWizardNotification: Notification;
    begin
      if IsNotificationEnabledForCurrentUser then begin
        FAAcquireWizardNotification.ID(GetNotificationID);
        FAAcquireWizardNotification.MESSAGE(ReadyToAcquireMsg);
        FAAcquireWizardNotification.SCOPE(NOTIFICATIONSCOPE::LocalScope);
        FAAcquireWizardNotification.ADDACTION(
          AcquireActionTxt,CODEUNIT::"Fixed Asset Acquisition Wizard",'RunAcquisitionWizardFromNotification');
        FAAcquireWizardNotification.ADDACTION(
          DontAskAgainActionTxt,CODEUNIT::"Fixed Asset Acquisition Wizard",'HideNotificationForCurrentUser');
        FAAcquireWizardNotification.SETDATA(FixedAssetAcquisitionWizard.GetNotificationFANoDataItemID,"No.");
        NotificationLifecycleMgt.SendNotification(FAAcquireWizardNotification,RECORDID);
      end
    end;
*/


    
    
/*
procedure GetNotificationID () : GUID;
    begin
      exit('3d5c2f86-cfb9-4407-97c3-9df74c7696c9');
    end;
*/


    
    
/*
procedure SetNotificationDefaultState ()
    var
//       MyNotifications@1000 :
      MyNotifications: Record 1518;
    begin
      MyNotifications.InsertDefault(GetNotificationID,NotificationNameTxt,NotificationDescriptionTxt,TRUE);
    end;
*/


    
/*
LOCAL procedure IsNotificationEnabledForCurrentUser () : Boolean;
    var
//       MyNotifications@1000 :
      MyNotifications: Record 1518;
    begin
      exit(MyNotifications.IsEnabled(GetNotificationID));
    end;
*/


    
    
/*
procedure DontNotifyCurrentUserAgain ()
    var
//       MyNotifications@1000 :
      MyNotifications: Record 1518;
    begin
      if not MyNotifications.Disable(GetNotificationID) then
        MyNotifications.InsertDefault(GetNotificationID,NotificationNameTxt,NotificationDescriptionTxt,FALSE);
    end;
*/


    
    
/*
procedure RecallNotificationForCurrentUser ()
    var
//       NotificationLifecycleMgt@1000 :
      NotificationLifecycleMgt: Codeunit 1511;
    begin
      NotificationLifecycleMgt.RecallNotificationsForRecord(RECORDID,FALSE);
    end;

    /*begin
    //{
//      CPA 22/06/22 - QB 1.10.58 (Q17292) Nuevos campos "Asset Allocation Job" y "Piecework Code"
//    }
    end.
  */
}




