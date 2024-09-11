tableextension 50124 "MyExtension50124" extends "User Setup"
{
  
  
    CaptionML=ENU='User Setup',ESP='Configuraci¢n usuarios';
    LookupPageID="User Setup";
    DrillDownPageID="User Setup";
  
  fields
{
    field(50000;"Aut. Presupuestos";Boolean)
    {
        DataClassification=ToBeClassified;


    }
    field(50001;"Aut. modif. retencion";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   Description='BS::19974';


    }
    field(50002;"Allow G.E.W. Sale mod.";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Allow G.E.W. Sale mod.',ESP='Permite mod. B.E. venta';
                                                   Description='BS::20668';


    }
    field(50003;"Cancel Measurement";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Cancel Measurement',ESP='Cancelar medici�n';
                                                   Description='BS::21677';


    }
    field(50004;"Allow Internal Changes";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Allow Internal Changes',ESP='Permite cambiar Interno';
                                                   Description='19975';


    }
    field(50005;"Open Budgets";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Permite cambiar pres. a abierto';


    }
    field(7207270;"Jobs Resp. Ctr. Filter";Code[10])
    {
        TableRelation="Responsibility Center";
                                                   CaptionML=ENU='Filter Resp. Jobs',ESP='Filtro Centro Resp. proyectos';
                                                   Description='QB 1.00 - QB22110';


    }
    field(7207271;"View all Jobs";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Can see all Jobs',ESP='Puede ver todas las obras';
                                                   Description='QB 1.00 - JAV 11/07/19: - Si el usuario puede ver todas las obras o solo las que tenga asocidas';


    }
    field(7207272;"Guarantees Administrator";Boolean)
    {
        

                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Guarantees Administrator',ESP='Responsable financiero Garant¡as';
                                                   Description='QB 1.00 - JAV 27/08/19: - Si es el Responsable financiero de las Garant¡as';

trigger OnValidate();
    VAR
//                                                                 Text002@100000000 :
                                                                Text002: TextConst ESP='Debe indicar un mail para este usuario para recibir las solicitudes de avales/fianzas';
                                                              BEGIN 
                                                                //JAV 27/08/19: - Se a¤ade el campo 7207272 "Guarantees Administrator" para indicar si es administrador de garant¡as
                                                                IF ("Guarantees Administrator") AND ("E-Mail" = '') THEN
                                                                  MESSAGE(Text002);
                                                              END;


    }
    field(7207273;"Change Rctp. Merge";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Change Rctp. Conditions Merged',ESP='Puede Activar Albaranes Dif.Cond.';
                                                   Description='QB 1.06 - JAV 12/07/20: - [TT] Si se activa, el usuario puede cambiar el check de mezclar albaranes con diferentes condiciones en las facturas de compra.';


    }
    field(7207274;"Substitute from date";Date)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Substitute from date',ESP='Substituir desde fecha';
                                                   Description='QB 1.07.17 - JAV 24/12/20: - Substituir autom ticamente entre que fechas';


    }
    field(7207275;"Substitute to date";Date)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Substitute to date',ESP='Substituir hasta fecha';
                                                   Description='QB 1.07.17 - JAV 24/12/20: - Substituir autom ticamente entre que fechas';


    }
    field(7207276;"See Balance";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='See Balance',ESP='Ver Saldos';
                                                   Description='QB 1.08.48 - JAV 16/06/21: - Si el usuario puede ver las columnas del saldo en diarios y en bancos';


    }
    field(7207277;"QB Register in closed period";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Allow Register in closed period',ESP='Registrar en periodos cerrados';
                                                   Description='Q13715';


    }
    field(7207278;"QPR Modify Budgets Status";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Allow Modify Quote Status',ESP='Puede Modificar estado Presupuestos';
                                                   Description='QPR 1.00.01 - JAV 14/07/21: - Si puede cambiar el estado interno de los presupuestos';


    }
    field(7207279;"QB Allow Negative Target";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Allow Negative Target',ESP='Permitir Objetivo Negativo';
                                                   Description='QB 1.09.02 - MMS Q13643 A¤adir campo que indica Permitir o no un Objetivo Negativo';


    }
    field(7207280;"Allow Gen. Posted Elec.Payment";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Allow Delete Ofers',ESP='Puede generar Pago Electr¢nico Registrado';
                                                   Description='QB 1.09.17 - JAV 09/09/21 [TT] Indica si el usuario puede generar documentos electr¢nicos de ¢rdenes de pago registradas';


    }
    field(7207281;"Can Change Dimensions";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Allow Change Dimensions',ESP='Puede cambiar dimensiones';
                                                   Description='QB 1.10.03 - JAV 29/11/21 [TT] Indica si el usuario puede cambiar las dimensiones de movimientos registrados';


    }
    field(7207283;"Allow Delete Job Quotes";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Allow Delete Ofers',ESP='Puede eliminar Estudios';
                                                   Description='QB 1.00 - JAV 11/03/19 Si el usuario puede eliminar estudios';


    }
    field(7207284;"Use FRI";Option)
    {
        OptionMembers="Conf","Always","Optional";DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Use FRI',ESP='Usar FRI';
                                                   OptionCaptionML=ENU='By Configuration,Always,Option',ESP='Seg£n configuraci¢n,Siempre,Opcional';
                                                   
                                                   Description='QB 1.00 - JAV 20/03/19 comportamiento del usuario sobre los FRI';


    }
    field(7207285;"Control Contracts";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Control Contracts',ESP='Aprueba sobrepasar Contratos';
                                                   Description='QB 1.00 - JAV 14/05/19 si puede sobrepasar el control de los contratos';


    }
    field(7207286;"QB Validate Proform";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Allow Validate Proforms',ESP='Validador de Proformas';
                                                   Description='QB 1.08.41 - JAV 05/05/21 Si el usuario puede validar las proformas antes de facturarlas';


    }
    field(7207287;"Modify Budget Status";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Allow Modify Budget Status',ESP='Puede Modificar estado presupuesto Obra';
                                                   Description='QB 1.00 - QCPM_GAP08';


    }
    field(7207288;"Modify Quote Status";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Allow Modify Quote Status',ESP='Puede Modificar estado estudio';
                                                   Description='QB 1.00 - QCPM_GAP04';


    }
    field(7207289;"Modify Quote";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Allow Modify Quote',ESP='Puede Modificar estudios';
                                                   Description='QB 1.00 - QCPM_GAP04';


    }
    field(7207290;"Modify Job Status";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Allow Modify Quote Status',ESP='Puede Modificar estado proyecto';
                                                   Description='QB 1.00 - JAV 13/06/19: - Si puede cambiar el estado del proyecto';


    }
    field(7207291;"Modify Job";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Allow Modify Quote',ESP='Puede Modificar proyectos';
                                                   Description='QB 1.00 - JAV 13/06/19: - Si puede editar proyectos';


    }
    field(7207292;"Mark Certifications Invoiced";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Can Mark Certification Like Invoiced',ESP='Marcar Certificaci¢n como Facturada';
                                                   Description='QB 1.08.16 - JAV 26/02/21 [TT] Indica si el usuario puede marcar las certificaciones como facturadas' ;


    }
}
  keys
{
   // key(key1;"User ID")
  //  {
       /* Clustered=true;
 */
   // }
}
  fieldgroups
{
}
  
    var
//       Text001@1000 :
      Text001: TextConst ENU='The %1 Salesperson/Purchaser code is already assigned to another User ID %2.',ESP='El c¢digo de Vendedor/Comprador %1 ya est  asignado a otro id. usuario %2.';
//       Text003@1002 :
      Text003: TextConst ENU='You cannot have both a %1 and %2. ',ESP='No puede tener un %1 y una %2. ';
//       Text005@1004 :
      Text005: TextConst ENU='You cannot have approval limits less than zero.',ESP='No puede tener l¡mites de aprobaci¢n inferiores a cero.';
//       SalesPersonPurchaser@1011 :
      SalesPersonPurchaser: Record 13;
//       PrivacyBlockedGenericErr@1013 :
      PrivacyBlockedGenericErr: 
// "%1 = salesperson / purchaser code."
TextConst ENU='Privacy Blocked must not be true for Salesperson / Purchaser %1.',ESP='La opci¢n Privacidad bloqueada no debe ser verdadera para el Vendedor/Comprador %1.';
//       UserSetupManagement@1001 :
      UserSetupManagement: Codeunit 5700;

    
    


/*
trigger OnInsert();    var
//                User@1000 :
               User: Record 2000000120;
             begin
               if "E-Mail" <> '' then
                 exit;
               if "User ID" <> '' then
                 exit;
               User.SETRANGE("User Name","User ID");
               if User.FINDFIRST then
                 "E-Mail" := COPYSTR(User."Contact Email",1,MAXSTRLEN("E-Mail"));
             end;


*/

/*
trigger OnDelete();    var
//                NotificationSetup@1000 :
               NotificationSetup: Record 1512;
             begin
               NotificationSetup.SETRANGE("User ID","User ID");
               NotificationSetup.DELETEALL(TRUE);
             end;

*/



// procedure CreateApprovalUserSetup (User@1000 :

/*
procedure CreateApprovalUserSetup (User: Record 2000000120)
    var
//       UserSetup@1001 :
      UserSetup: Record 91;
//       ApprovalUserSetup@1002 :
      ApprovalUserSetup: Record 91;
    begin
      ApprovalUserSetup.INIT;
      ApprovalUserSetup.VALIDATE("User ID",User."User Name");
      ApprovalUserSetup.VALIDATE("Sales Amount Approval Limit",GetDefaultSalesAmountApprovalLimit);
      ApprovalUserSetup.VALIDATE("Purchase Amount Approval Limit",GetDefaultPurchaseAmountApprovalLimit);
      ApprovalUserSetup.VALIDATE("E-Mail",User."Contact Email");
      UserSetup.SETRANGE("Sales Amount Approval Limit",UserSetup.GetDefaultSalesAmountApprovalLimit);
      if UserSetup.FINDFIRST then
        ApprovalUserSetup.VALIDATE("Approver ID",UserSetup."Approver ID");
      if ApprovalUserSetup.INSERT then;
    end;
*/


    
    
/*
procedure GetDefaultSalesAmountApprovalLimit () : Integer;
    var
//       UserSetup@1001 :
      UserSetup: Record 91;
//       DefaultApprovalLimit@1000 :
      DefaultApprovalLimit: Integer;
//       LimitedApprovers@1002 :
      LimitedApprovers: Integer;
    begin
      UserSetup.SETRANGE("Unlimited Sales Approval",FALSE);

      if UserSetup.FINDFIRST then begin
        DefaultApprovalLimit := UserSetup."Sales Amount Approval Limit";
        LimitedApprovers := UserSetup.COUNT;
        UserSetup.SETRANGE("Sales Amount Approval Limit",DefaultApprovalLimit);
        if LimitedApprovers = UserSetup.COUNT then
          exit(DefaultApprovalLimit);
      end;

      // Return 0 if no user setup exists or no default value is found
      exit(0);
    end;
*/


    
    
/*
procedure GetDefaultPurchaseAmountApprovalLimit () : Integer;
    var
//       UserSetup@1002 :
      UserSetup: Record 91;
//       DefaultApprovalLimit@1001 :
      DefaultApprovalLimit: Integer;
//       LimitedApprovers@1000 :
      LimitedApprovers: Integer;
    begin
      UserSetup.SETRANGE("Unlimited Purchase Approval",FALSE);

      if UserSetup.FINDFIRST then begin
        DefaultApprovalLimit := UserSetup."Purchase Amount Approval Limit";
        LimitedApprovers := UserSetup.COUNT;
        UserSetup.SETRANGE("Purchase Amount Approval Limit",DefaultApprovalLimit);
        if LimitedApprovers = UserSetup.COUNT then
          exit(DefaultApprovalLimit);
      end;

      // Return 0 if no user setup exists or no default value is found
      exit(0);
    end;
*/


    
    
/*
procedure HideExternalUsers ()
    var
//       PermissionManager@1001 :
      PermissionManager: Codeunit 9002;
//       OriginalFilterGroup@1000 :
      OriginalFilterGroup: Integer;
    begin
      if not PermissionManager.SoftwareAsAService then
        exit;

      OriginalFilterGroup := FILTERGROUP;
      FILTERGROUP := 2;
      CALCFIELDS("License Type");
      SETFILTER("License Type",'<>%1',"License Type"::"External User");
      FILTERGROUP := OriginalFilterGroup;
    end;
*/


    
/*
LOCAL procedure UpdateSalesPerson ()
    var
//       SalespersonPurchaser@1000 :
      SalespersonPurchaser: Record 13;
    begin
      if ("E-Mail" <> '') and SalespersonPurchaser.GET("Salespers./Purch. Code") then begin
        SalespersonPurchaser."E-Mail" := COPYSTR("E-Mail",1,MAXSTRLEN(SalespersonPurchaser."E-Mail"));
        SalespersonPurchaser.MODIFY;
      end;
    end;
*/


//     LOCAL procedure ValidateSalesPersonPurchOnUserSetup (UserSetup2@1000 :
    
/*
LOCAL procedure ValidateSalesPersonPurchOnUserSetup (UserSetup2: Record 91)
    begin
      if UserSetup2."Salespers./Purch. Code" <> '' then
        if SalesPersonPurchaser.GET(UserSetup2."Salespers./Purch. Code") then
          if SalesPersonPurchaser.VerifySalesPersonPurchaserPrivacyBlocked(SalesPersonPurchaser) then
            ERROR(PrivacyBlockedGenericErr,UserSetup2."Salespers./Purch. Code")
    end;
*/


    
//     procedure CheckAllowedPostingDates (NotificationType@1000 :
    
/*
procedure CheckAllowedPostingDates (NotificationType: Option "Error","Notificatio")
    begin
      UserSetupManagement.CheckAllowedPostingDatesRange(
        "Allow Posting From","Allow Posting To",NotificationType,DATABASE::"User Setup");
    end;
*/


//     procedure GetSubstitute (pUser@1100286000 :
    procedure GetSubstitute (pUser: Code[50]) : Code[50];
    var
//       UserSetup@1100286001 :
      UserSetup: Record 91;
    begin
      //JAV 24/12/20: - QB 1.07.17 Busca el aprobador de un usuario por si tiene un substituto en la fecha actual, si no lo tiene ser  el propio usuario
      if (UserSetup.GET(pUser)) then
        if (UserSetup.Substitute <> '') then
          if (UserSetup."Substitute from date" <> 0D) and (UserSetup."Substitute from date" <= TODAY) then
            if (UserSetup."Substitute to date" = 0D) or (UserSetup."Substitute to date" >= TODAY) then
              exit(UserSetup.Substitute);

      exit(pUser);
    end;

    /*begin
    //{
//      NZG 27/06/18: - Q2431 Se a¤ade campo nuevo "Cod. Comprador"  --> Eliminado con las nuevas aprobaciones
//      JAV 11/03/19: - Se a¤ade el campo 7000113 "Eliminar Estudios" para indicar si el usuario puede hacerlo --> Renumerado a 7207283
//      JAV 08/05/19: - Se cambia el alta para que tome el nombre del usuario tambi‚n
//      JAV 02/06/19: - Se a¤aden campos para permitir o no modificar estudios
//      JAV 13/06/19: - Se a¤aden campos para permitir o no modificar proyectos
//      JAV 11/07/19: - Se a¤ade el campo 7207271 "View all Jobs", si el usuario puede ver todas las obras o solo las que tenga asocidas
//      JAV 27/08/19: - Se a¤ade el campo 7207272 "Guarantees Administrator" para indicar si es el Responsable financiero de las Garant¡as
//      JAV 14/10/19: - Se mejora el proceso de cargar el dato del usuario creando una funci¢n que se puede llamar desde alta y modificaci¢n
//      JAV 29/01/20: - Se elimina el campo 7207279 "User Name" y la funci¢n "SetFromUser" pues no se utiliza el campo en ning£n sitio
//      JAV 02/03/20: - Se a¤ade el campo del Aprobador para documentos con certificados caducados
//      QMD 23/06/21: - Q13715 Se a¤ade campo "QB Register in closed period"
//      MMS 13/07/21: - Q13643 Se a¤ade campo bool "QB Allow Negative Target"
//      JAV 14/07/21: - QPR 1.00.01 Se a¤ade el campo "QPR Modify Budgets Status" para indicar si puede modificar el estado de los presupuestos
//      JAV 15/09/21: - QB 1.09.17 Se a¤ade el campo "Allow Gen. Posted Elec.Payment" para indicar que puede generar el fichero electr¢nico de las ¢rdenes de pago registradas
//      APC 15/05/22: - QB 1.10.41 (Q16494) Se a�ade el campo 7207293 "Send Sales Document"
//      AML 13/11/23: - Autorizacion presupuesto compras.
//      AML 21/11/23: - BS::19974 Autorizacion modificar retenciones.
//      BS::20668 CSM 04/01/24 � VEN027 Modificar importe retenci�n en venta.
//    }
    end.
  */
}




