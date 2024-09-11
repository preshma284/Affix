page 7206966 "QB Manage Users"
{
  ApplicationArea=All;

CaptionML=ENU='Manage User',ESP='Asistente Configuraci�n Usuarios';
    SourceTable=2000000120;
    DataCaptionExpression='Asistente Configuraci�n Usuarios';
    PageType=List;
    
  layout
{
area(content)
{
repeater("table")
{
        
                CaptionML=ESP='Crear usuario';
    field("Windows User Name";WindowsUserName)
    {
        
                AssistEdit=false;
                CaptionML=ENU='Windows User Name',ESP='Nombre de usuario Windows';
                ToolTipML=ENU='Specifies the name of a valid Active Directory user, using the format domain\username.',ESP='Especifica el nombre de un usuario v�lido de Active Directory, con el formato dominio\nombreDeUsuario.';
                ApplicationArea=Basic,Suite;
                Importance=Promoted;
                Visible=NOT IsWindowsClient;
                
                            ;trigger OnValidate()    BEGIN
                             ValidateWindowsUserName;
                           END;


    }
    field("Windows User Name Desktop";WindowsUserName)
    {
        
                AssistEdit=true;
                CaptionML=ENU='Windows User Name',ESP='Nombre de usuario Windows';
                ToolTipML=ENU='Specifies the name of a valid Active Directory user, using the format domain\username.',ESP='Especifica el nombre de un usuario v�lido de Active Directory, con el formato dominio\nombreDeUsuario.';
                ApplicationArea=Basic,Suite;
                Importance=Promoted;
                Visible=IsWindowsClient;
                
                              ;trigger OnValidate()    BEGIN
                             ValidateWindowsUserName;
                           END;

trigger OnAssistEdit()    VAR
                              //  DSOP : DotNet "'Microsoft.Dynamics.Nav.Management.DSObjectPickerWrapper, Version=13.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35'.Microsoft.Dynamics.Nav.Management.DSObjectPicker.DSObjectPickerWrapper" RUNONCLIENT;
                               result : Text;
                             BEGIN
                              //  DSOP := DSOP.DSObjectPickerWrapper;
                              //  result := DSOP.InvokeDialogAndReturnSid;
                               IF result <> '' THEN BEGIN
                                 rec."Windows Security ID" := result;
                                 ValidateSid;
                                 WindowsUserName := IdentityManagement.UserName(rec."Windows Security ID");
                                 SetUserName;
                               END;
                             END;


    }
    field("State";rec."State")
    {
        
                
                            ;trigger OnValidate()    BEGIN
                             ContarUsuarios;
                           END;


    }
    field("License Type";rec."License Type")
    {
        
                
                            ;trigger OnValidate()    BEGIN
                             ContarUsuarios;
                           END;


    }
    field("Full Name";rec."Full Name")
    {
        
                ToolTipML=ENU='Specifies the full name of the user.',ESP='Especifica el nombre completo del usuario.';
                ApplicationArea=Basic,Suite;
    }
    field("Contact Email";rec."Contact Email")
    {
        
                CaptionML=ESP='e-mail';
                
                            ;trigger OnValidate()    BEGIN
                             SetUserData;
                           END;


    }
    field("Rol";Rol)
    {
        
                CaptionML=ESP='Rol';
                TableRelation="User Group" WHERE ("Code"=FILTER('QB*'));
                
                            ;trigger OnValidate()    BEGIN
                             SetUserData;
                             CurrPage.UPDATE;
                           END;


    }
    field("NrEmpresas";NrEmpresas)
    {
        
                CaptionML=ESP='Empresas';
                Editable=FALSE;
                
                              ;trigger OnAssistEdit()    BEGIN
                               ManageCompanies;
                             END;


    }
    field("P[1]_";P[1])
    {
        
                CaptionML=ESP='GENERAL: Ver todas las obras';
                ToolTipML=ESP='Si el usuario puede ver todas las obras o solo las que tenga asocidas';
                
                            ;trigger OnValidate()    BEGIN
                             SetUserData;
                           END;


    }
    field("P[2]_";P[2])
    {
        
                CaptionML=ESP='GARANTIAS: Responsable financiero';
                ToolTipML=ESP='Si es el Responsable financiero de las Garant�as';
                
                            ;trigger OnValidate()    BEGIN
                             SetUserData;
                           END;


    }
    field("P[3]_";P[3])
    {
        
                CaptionML=ESP='ESTUDIOS: Puede Modificar';
                ToolTipML=ESP='Puede Modificar estudios';
                
                            ;trigger OnValidate()    BEGIN
                             SetUserData;
                           END;


    }
    field("P[4]_";P[4])
    {
        
                CaptionML=ESP='ESTUDIOS: Modificar estado';
                ToolTipML=ESP='Si el usuario puede Modificar el estado en los estudios';
                
                            ;trigger OnValidate()    BEGIN
                             SetUserData;
                           END;


    }
    field("P[5]_";P[5])
    {
        
                CaptionML=ESP='ESTUDIOS: Eliminar';
                ToolTipML=ESP='Si el usuario puede eliminar estudios';
                
                            ;trigger OnValidate()    BEGIN
                             SetUserData;
                           END;


    }
    field("P[6]_";P[6])
    {
        
                CaptionML=ESP='PROYECTOS: Editar';
                ToolTipML=ESP='Si puede editar proyectos';
                
                            ;trigger OnValidate()    BEGIN
                             SetUserData;
                           END;


    }
    field("P[7]_";P[7])
    {
        
                CaptionML=ESP='PROYECTOS: Estado del proyecto';
                ToolTipML=ESP='Si puede cambiar el estado del proyecto';
                
                            ;trigger OnValidate()    BEGIN
                             SetUserData;
                           END;


    }
    field("P[8]_";P[8])
    {
        
                CaptionML=ESP='PROYECTOS: Estado de presupuesto';
                ToolTipML=ESP='Si el usuario puede Modificar estado presupuesto';
                
                            ;trigger OnValidate()    BEGIN
                             SetUserData;
                           END;


    }
    field("P[9]_";P[9])
    {
        
                CaptionML=ESP='COMPRAS: Sobrepasar Contratos';
                ToolTipML=ESP='Si el usuario tiene habilitado el poder sobrepasar el control de los contratos';
                
                            ;trigger OnValidate()    BEGIN
                             SetUserData;
                           END;


    }
    field("P[10]_";P[10])
    {
        
                CaptionML=ESP='COMPRAS: Mezclar condiciones albaranes';
                ToolTipML=ESP='Si se activa, el usuario puede cambiar el check de mezclar albaranes con diferentes condiciones en las facturas de compra';
                
                            ;trigger OnValidate()    BEGIN
                             SetUserData;
                           END;


    }

}
group("group53")
{
        
    field("NU[1]_";NU[1])
    {
        
                CaptionML=ESP='N� Usuarios';
                Editable=false ;
    }
    field("NU[2]_";NU[2])
    {
        
                CaptionML=ESP='N� Usuarios Activos';
                Editable=false ;
    }
    field("NU[3]_";NU[3])
    {
        
                CaptionML=ESP='N� Usuarios Completos Activos';
                Editable=FALSE ;
    }
    field("NU[4]_";NU[4])
    {
        
                CaptionML=ESP='N� Usuarios Limitados Activos';
                Editable=FALSE 

  ;
    }

}

}
}
  trigger OnOpenPage()    BEGIN
                 Rec.SETCURRENTKEY("User Name");
                 ContarUsuarios;
               END;

trigger OnAfterGetRecord()    BEGIN
                       GetUserData;
                     END;

trigger OnNewRecord(BelowxRec: Boolean)    BEGIN
                  CLEAR(Rec);
                  GetUserData;
                END;

trigger OnDeleteRecord(): Boolean    BEGIN
                     DeleteUser;
                   END;

trigger OnAfterGetCurrRecord()    BEGIN
                           IsNewUser := (rec."User Name" = '');
                         END;



    var
      rUser : Record 2000000120;
      UserSetup : Record 91;
      UserGroup : Record 9000;
      UserGroupMember : Record 9001;
      IdentityManagement : Codeunit 9801;
      Text000 : TextConst ESP='Todas';
      Text001 : TextConst ENU='The account %1 is not a valid Windows account.',ESP='La cuenta %1 no es una cuenta Windows v�lida.';
      Text002 : TextConst ENU='The account %1 already exists.',ESP='La cuenta %1 ya existe.';
      Text003 : TextConst ENU='The account %1 is not allowed.',ESP='La cuenta %1 no se permite.';
      PermissionManager : Codeunit 9002;
      ClientTypeManagement : Codeunit 50192;
      UserMgt : Codeunit 418;
      IsWindowsClient : Boolean;
      IsNewUser : Boolean;
      HaveUserID : Boolean;
      WindowsUserName : Text;
      Rol : Text;
      mail : Text;
      P : ARRAY [20] OF Boolean;
      NU : ARRAY [10] OF Integer;
      NrEmpresas : Text;
      Company : Record 2000000006;
      tmpCompany : Record 2000000006 TEMPORARY;
      Created : Boolean;

    LOCAL procedure ValidateWindowsUserName();
    var
      UserSID : Text;
    begin
      ValidateWindowsUserNameW;

      CurrPage.UPDATE;
      Rec.RESET;
      Rec.SETCURRENTKEY("User Name");

      HaveUserID := (rec."Windows Security ID" <> '');
      GetUserData;
      SetUserData;
      ContarUsuarios;
    end;

    LOCAL procedure ValidateWindowsUserNameW();
    var
      UserSID : Text;
    begin
      if WindowsUserName = '' then
        rec."Windows Security ID" := ''
      ELSE begin
        UserSID := SID(WindowsUserName);
        WindowsUserName := IdentityManagement.UserName(UserSID);
        if WindowsUserName <> '' then begin
          rec."Windows Security ID" := UserSID;
          ValidateSid;
          SetUserNameW;
        end ELSE
          ERROR(Text001,WindowsUserName);
      end;
    end;

    LOCAL procedure ValidateSid();
    var
      User : Record 2000000120;
    begin
      if rec."Windows Security ID" = '' then
        ERROR(Text001,rec."User Name");

      if (rec."Windows Security ID" = 'S-1-1-0') or (rec."Windows Security ID" = 'S-1-5-7') or (rec."Windows Security ID" = 'S-1-5-32-544') then
        ERROR(Text003,IdentityManagement.UserName(rec."Windows Security ID"));

      User.SETFILTER("Windows Security ID", rec."Windows Security ID");
      User.SETFILTER("User Security ID",'<>%1',rec."User Security ID");
      if not User.ISEMPTY then
        ERROR(Text002,User."User Name");
    end;

    LOCAL procedure SetUserName();
    begin
      SetUserNameW;
    end;

    LOCAL procedure SetUserNameW();
    begin
      rec."User Name" := WindowsUserName;
      UserMgt.ValidateUserName(Rec,xRec,WindowsUserName);
      rec."User Security ID" := CREATEGUID;
      Rec.TESTFIELD("User Name");
    end;

    LOCAL procedure GetUserData();
    begin
      WindowsUserName := rec."User Name";

      Rol := '';
      CLEAR(P);

      UserGroupMember.RESET;
      UserGroupMember.SETRANGE( "User Security ID", rec. "User Security ID");
      if (UserGroupMember.FINDFIRST) then
        Rol := UserGroupMember."User Group Code";

      UserSetup.RESET;  //Me posicion en la empresa actual, la configuraci�n ser� igual en el resto de empresas
      if (UserSetup.GET(rec."User Name")) then begin
        if (rec."Contact Email" = '') then
          rec."Contact Email" := UserSetup."E-Mail";

        P[ 1] := UserSetup."View all Jobs";
        P[ 2] := UserSetup."Guarantees Administrator";
        P[ 3] := UserSetup."Modify Quote";
        P[ 4] := UserSetup."Modify Quote Status";
        P[ 5] := UserSetup."Allow DELETE Job Quotes";
        P[ 6] := UserSetup."Modify Job";
        P[ 7] := UserSetup."Modify Job Status";
        P[ 8] := UserSetup."Modify Budget Status";
        P[ 9] := UserSetup."Control Contracts";
        P[10] := UserSetup."Change Rctp. Merge";
      end;

      tmpCompany.DELETEALL;
      UserGroupMember.RESET;
      UserGroupMember.SETRANGE( "User Security ID", rec. "User Security ID");
      if (UserGroupMember.FINDSET(FALSE)) then
        repeat
          if (UserGroupMember."Company Name" <> '') then begin
            tmpCompany.Name := UserGroupMember."Company Name";
            if not tmpCompany.INSERT then ;
          end;
        until (UserGroupMember.NEXT = 0);
      if (tmpCompany.ISEMPTY) then
        NrEmpresas := Text000
      ELSE
        NrEmpresas := '  ' + FORMAT(tmpCompany.COUNT);
    end;

    LOCAL procedure SetUserData();
    begin
      //Guardo el rol asociado al usuario en la tabla de miembros del grupo
      UserGroupMember.RESET;
      UserGroupMember.SETRANGE( "User Security ID", rec. "User Security ID");
      if (UserGroupMember.FINDSET(TRUE)) then begin                  //Si existen roles definidos, los cambio
        repeat
          if (Rol <> UserGroupMember."User Group Code") then
            UserGroupMember.RENAME(Rol, UserGroupMember."User Security ID", UserGroupMember."Company Name");
        until (UserGroupMember.NEXT = 0);
      end ELSE begin                                                      //Si no existen roles, creo uno nuevo
        UserGroupMember.INIT;
        UserGroupMember."User Group Code" := Rol;
        UserGroupMember."User Security ID" := rec."User Security ID";
        UserGroupMember.INSERT;
      end;

      //Monto la temporal de empresas a las que puede acceder
      tmpCompany.DELETEALL;
      UserGroupMember.RESET;
      UserGroupMember.SETRANGE( "User Security ID", rec. "User Security ID");
      if (UserGroupMember.FINDSET(FALSE)) then
        repeat
          if (UserGroupMember."Company Name" <> '') then begin
            tmpCompany.Name := UserGroupMember."Company Name";
            if not tmpCompany.INSERT then ;
          end;
        until (UserGroupMember.NEXT = 0);

      if (tmpCompany.ISEMPTY) then begin
        Company.RESET;
        if (Company.FINDSET(FALSE)) then
          repeat
            tmpCompany.Name := Company.Name;
            if not tmpCompany.INSERT then ;
          until (Company.NEXT = 0);
      end;

      //Modifico los datos de configuraci�n de usuarios en todas las empresas a las que accede
      tmpCompany.RESET;
      if (tmpCompany.FINDSET) then
        repeat
          UserSetup.CHANGECOMPANY(tmpCompany.Name);
          if (not UserSetup.GET(rec."User Name")) then begin
            UserSetup.INIT;
            UserSetup."User ID" := rec."User Name";
            UserSetup.INSERT;
          end;

          UserSetup."E-Mail" := rec."Contact Email";
          UserSetup."View all Jobs" := P[1];
          UserSetup."Guarantees Administrator" := P[2];
          UserSetup."Modify Quote" := P[3];
          UserSetup."Modify Quote Status" := P[4];
          UserSetup."Allow DELETE Job Quotes" := P[5];
          UserSetup."Modify Job" := P[6];
          UserSetup."Modify Job Status" := P[7];
          UserSetup."Modify Budget Status" := P[8];
          UserSetup."Control Contracts" := P[9];
          UserSetup."Change Rctp. Merge" := P[10];
          UserSetup.MODIFY;

        until (tmpCompany.NEXT = 0);
    end;

    LOCAL procedure ContarUsuarios();
    begin
      CurrPage.UPDATE;
      rUser.RESET;
      NU[1] := rUser.COUNT;
      rUser.SETRANGE(State, rUser.State::Enabled);
      NU[2] := rUser.COUNT;
      rUser.SETRANGE("License Type", rUser."License Type"::"Full User");
      NU[3] := rUser.COUNT;
      rUser.SETRANGE("License Type", rUser."License Type"::"Limited User");
      NU[4] := rUser.COUNT;
    end;

    LOCAL procedure DeleteUser();
    begin
      //Elimina el registro de configuraci�n del usuario en todas las empresas
      Company.RESET;
      if (Company.FINDSET(FALSE)) then
        repeat
          UserSetup.CHANGECOMPANY(tmpCompany.Name);
          if (UserSetup.GET(rec."User Name")) then
            UserSetup.DELETE;
        until (Company.NEXT = 0);
    end;

    LOCAL procedure ManageCompanies();
    var
      QBManageUser : Page 7206967;
    begin
      CLEAR(QBManageUser);
      QBManageUser.SetData(Rol, rec."User Security ID");
      QBManageUser.RUNMODAL;
    end;

    procedure CreateNewUser(pUserID : Text;pRol : Text) : Boolean;
    begin
      WindowsUserName := pUserID;
      Rol := pRol;
      if (not UserGroup.GET(Rol)) then
        exit(FALSE);

      if not CreateOne then
        exit(FALSE);

      Rec.INSERT;

      SetUserData;
    end;

    [TryFunction]
    LOCAL procedure CreateOne();
    begin
      ValidateWindowsUserNameW;
    end;

    procedure AddUserToCompany(pUserID : Text;pCompany : Text) : Boolean;
    var
      User : Record 2000000120;
      UserGroupMember : Record 9001;
      Grupo : Text;
    begin
      User.RESET;
      User.SETRANGE("User Name", pUserID);
      if (User.FINDFIRST) then begin
        //Busco el rol que debe tener asociado ya el asociado
        UserGroupMember.RESET;
        UserGroupMember.SETRANGE("User Security ID", User."User Security ID");
        if (UserGroupMember.FINDFIRST) then
          Grupo := UserGroupMember."User Group Code";

        //Quito el acceso a todas las empresas si lo tiene
        UserGroupMember.RESET;
        UserGroupMember.SETRANGE("User Security ID", User."User Security ID");
        UserGroupMember.SETFILTER("Company Name", '=%1','');
        UserGroupMember.DELETEALL;

        //Pongo el usuario en la empresa
        UserGroupMember.INIT;
        UserGroupMember."User Group Code" := Grupo;
        UserGroupMember."User Security ID" := User."User Security ID";
        UserGroupMember."Company Name" := pCompany;
        if UserGroupMember.INSERT(TRUE) then ;
      end;
    end;

    // begin//end
}









