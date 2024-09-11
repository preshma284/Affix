tableextension 50195 "QBU EmployeeExt" extends "Employee"
{
  
  DataCaptionFields="No.","Name","First Family Name","Second Family Name";
    CaptionML=ENU='Employee',ESP='Empleado';
    LookupPageID="Employee List";
    DrillDownPageID="Employee List";
  
  fields
{
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
   // key(key3;"Status","Union Code")
  //  {
       /* ;
 */
   // }
   // key(key4;"Status","Emplymt. Contract Code")
  //  {
       /* ;
 */
   // }
}
  fieldgroups
{
   // fieldgroup(DropDown;"No.","First Family Name","Name","Initials","Job Title")
   // {
       // 
   // }
   // fieldgroup(Brick;"First Family Name","Name","Job Title","Image")
   // {
       // 
   // }
}
  
    var
//       HumanResSetup@1000 :
      HumanResSetup: Record 5218;
//       Res@1002 :
      Res: Record 156;
//       PostCode@1003 :
      PostCode: Record 225;
//       AlternativeAddr@1004 :
      AlternativeAddr: Record 5201;
//       EmployeeQualification@1005 :
      EmployeeQualification: Record 5203;
//       Relative@1006 :
      Relative: Record 5205;
//       EmployeeAbsence@1007 :
      EmployeeAbsence: Record 5207;
//       MiscArticleInformation@1008 :
      MiscArticleInformation: Record 5214;
//       ConfidentialInformation@1009 :
      ConfidentialInformation: Record 5216;
//       HumanResComment@1010 :
      HumanResComment: Record 5208;
//       SalespersonPurchaser@1011 :
      SalespersonPurchaser: Record 13;
//       NoSeriesMgt@1012 :
      NoSeriesMgt: Codeunit 396;
//       EmployeeResUpdate@1013 :
      EmployeeResUpdate: Codeunit 5200;
//       EmployeeSalespersonUpdate@1014 :
      EmployeeSalespersonUpdate: Codeunit 5201;
//       DimMgt@1015 :
      DimMgt: Codeunit 408;
//       Text000@1016 :
      Text000: TextConst ENU='Before you can use Online Map, you must fill in the Online Map Setup window.\See Setting Up Online Map in Help.',ESP='Para poder usar Online Map, primero debe rellenar la ventana Configuraci¢n Online Map.\Consulte Configuraci¢n de Online Map en la Ayuda.';
//       BlockedEmplForJnrlErr@1001 :
      BlockedEmplForJnrlErr: 
// "%1 = employee no."
TextConst ENU='You cannot create this document because employee %1 is blocked due to privacy.',ESP='No puede crear este documento porque el empleado %1 est  bloqueado por motivos de privacidad.';
//       BlockedEmplForJnrlPostingErr@1017 :
      BlockedEmplForJnrlPostingErr: 
// "%1 = employee no."
TextConst ENU='You cannot post this document because employee %1 is blocked due to privacy.',ESP='No puede registrar este documento porque el empleado %1 est  bloqueado por motivos de privacidad.';

    
    


/*
trigger OnInsert();    begin
               "Last Modified Date Time" := CURRENTDATETIME;
               if "No." = '' then begin
                 HumanResSetup.GET;
                 HumanResSetup.TESTFIELD("Employee Nos.");
                 NoSeriesMgt.InitSeries(HumanResSetup."Employee Nos.",xRec."No. Series",0D,"No.","No. Series");
               end;

               DimMgt.UpdateDefaultDim(
                 DATABASE::Employee,"No.",
                 "Global Dimension 1 Code","Global Dimension 2 Code");
               UpdateSearchName;
             end;


*/

/*
trigger OnModify();    begin
               "Last Modified Date Time" := CURRENTDATETIME;
               "Last Date Modified" := TODAY;
               if Res.READPERMISSION then
                 EmployeeResUpdate.HumanResToRes(xRec,Rec);
               if SalespersonPurchaser.READPERMISSION then
                 EmployeeSalespersonUpdate.HumanResToSalesPerson(xRec,Rec);
               UpdateSearchName;
             end;


*/

/*
trigger OnDelete();    begin
               AlternativeAddr.SETRANGE("Employee No.","No.");
               AlternativeAddr.DELETEALL;

               EmployeeQualification.SETRANGE("Employee No.","No.");
               EmployeeQualification.DELETEALL;

               Relative.SETRANGE("Employee No.","No.");
               Relative.DELETEALL;

               EmployeeAbsence.SETRANGE("Employee No.","No.");
               EmployeeAbsence.DELETEALL;

               MiscArticleInformation.SETRANGE("Employee No.","No.");
               MiscArticleInformation.DELETEALL;

               ConfidentialInformation.SETRANGE("Employee No.","No.");
               ConfidentialInformation.DELETEALL;

               HumanResComment.SETRANGE("No.","No.");
               HumanResComment.DELETEALL;

               DimMgt.DeleteDefaultDim(DATABASE::Employee,"No.");
             end;


*/

/*
trigger OnRename();    begin
               DimMgt.RenameDefaultDim(DATABASE::Employee,xRec."No.","No.");
               "Last Modified Date Time" := CURRENTDATETIME;
               "Last Date Modified" := TODAY;
               UpdateSearchName;
             end;

*/




/*
procedure AssistEdit () : Boolean;
    begin
      HumanResSetup.GET;
      HumanResSetup.TESTFIELD("Employee Nos.");
      if NoSeriesMgt.SelectSeries(HumanResSetup."Employee Nos.",xRec."No. Series","No. Series") then begin
        NoSeriesMgt.SetSeries("No.");
        exit(TRUE);
      end;
    end;
*/


    
    
/*
procedure FullName () : Text[100];
    var
//       NewFullName@1000 :
      NewFullName: Text[100];
//       Handled@1001 :
      Handled: Boolean;
    begin
      OnBeforeGetFullName(Rec,NewFullName,Handled);
      if Handled then
        exit(NewFullName);

      exit(Name + ' ' + "First Family Name" + ' ' + "Second Family Name");
    end;
*/


    
//     procedure ValidateShortcutDimCode (FieldNumber@1000 : Integer;var ShortcutDimCode@1001 :
    
/*
procedure ValidateShortcutDimCode (FieldNumber: Integer;var ShortcutDimCode: Code[20])
    begin
      DimMgt.ValidateDimValueCode(FieldNumber,ShortcutDimCode);
      DimMgt.SaveDefaultDim(DATABASE::Employee,"No.",FieldNumber,ShortcutDimCode);
      MODIFY;
    end;
*/


    
    
/*
procedure DisplayMap ()
    var
//       MapPoint@1001 :
      MapPoint: Record 800;
//       MapMgt@1000 :
      MapMgt: Codeunit 802;
    begin
      if MapPoint.FINDFIRST then
        MapMgt.MakeSelection(DATABASE::Employee,GETPOSITION)
      else
        MESSAGE(Text000);
    end;
*/


    
/*
LOCAL procedure UpdateSearchName ()
    var
//       PrevSearchName@1000 :
      PrevSearchName: Code[250];
    begin
      PrevSearchName := xRec.FullName + ' ' + xRec.Initials;
      if (((Name <> xRec.Name) or ("First Family Name" <> xRec."First Family Name") or
           ("Second Family Name" <> xRec."Second Family Name") or (Initials <> xRec.Initials)) and ("Search Name" = PrevSearchName))
      then
        "Search Name" := SetSearchNameToFullnameAndInitials;
    end;
*/


    
/*
LOCAL procedure SetSearchNameToFullnameAndInitials () : Code[250];
    begin
      exit(FullName + ' ' + Initials);
    end;
*/


    
    
/*
procedure GetBankAccountNo () : Text;
    begin
      if IBAN <> '' then
        exit(DELCHR(IBAN,'=<>'));

      if "Bank Account No." <> '' then
        exit("Bank Account No.");
    end;
*/


    
//     procedure CheckBlockedEmployeeOnJnls (IsPosting@1000 :
    
/*
procedure CheckBlockedEmployeeOnJnls (IsPosting: Boolean)
    begin
      if "Privacy Blocked" then begin
        if IsPosting then
          ERROR(BlockedEmplForJnrlPostingErr,"No.");
        ERROR(BlockedEmplForJnrlErr,"No.")
      end;
    end;
*/


    
//     LOCAL procedure OnBeforeGetFullName (Employee@1000 : Record 5200;var NewFullName@1001 : Text[100];var Handled@1002 :
    
/*
LOCAL procedure OnBeforeGetFullName (Employee: Record 5200;var NewFullName: Text[100];var Handled: Boolean)
    begin
    end;

    /*begin
    end.
  */
}





