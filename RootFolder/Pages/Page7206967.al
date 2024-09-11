page 7206967 "QB Manage User Companies"
{
CaptionML=ENU='Manage Company User',ESP='Asociar usuario a empresas';
    InsertAllowed=false;
    DeleteAllowed=false;
    ModifyAllowed=false;
    SourceTable=2000000006;
    DataCaptionExpression='Asistente Configuraci�n Usuario';
    PageType=Card;
    
  layout
{
area(content)
{
repeater("table")
{
        
                CaptionML=ESP='Crear usuario';
    field("Name";rec."Name")
    {
        
                Editable=false ;
    }
    field("Display Name";rec."Display Name")
    {
        
                Editable=false ;
    }
    field("Activa";Activa)
    {
        
                CaptionML=ESP='Activa';
                ToolTipML=ESP='Si se activa, el usuario puede cambiar el check de mezclar albaranes con diferentes condiciones en las facturas de compra';
                
                            

  ;trigger OnValidate()    BEGIN
                             SetActive;
                           END;


    }

}

}
}
  trigger OnAfterGetRecord()    BEGIN
                       Activa := IsActive;
                     END;



    var
      Text001 : TextConst ENU='The account %1 is not a valid Windows account.',ESP='La cuenta %1 no es una cuenta Windows v�lida.';
      Text002 : TextConst ENU='The account %1 already exists.',ESP='La cuenta %1 ya existe.';
      Text003 : TextConst ENU='The account %1 is not allowed.',ESP='La cuenta %1 no se permite.';
      UserGroupMember : Record 9001;
      Grupo : Text;
      Usuario : Text;
      Activa : Boolean;

    

LOCAL procedure IsActive() : Boolean;
    begin
      UserGroupMember.RESET;
      UserGroupMember.SETRANGE("User Group Code", Grupo);
      UserGroupMember.SETRANGE("User Security ID", Usuario);
      UserGroupMember.SETRANGE("Company Name", rec.Name);
      exit (not UserGroupMember.ISEMPTY);
    end;

    LOCAL procedure SetActive();
    begin
      if (Activa) then begin
        //Pongo el usuario en la empresa
        UserGroupMember.INIT;
        UserGroupMember."User Group Code" := Grupo;
        UserGroupMember."User Security ID" := Usuario;
        UserGroupMember."Company Name" := Rec.Name;
        if UserGroupMember.INSERT(TRUE) then ;

        //Lo elimino de todas las empresas
        UserGroupMember.RESET;
        UserGroupMember.SETRANGE("User Group Code", Grupo);
        UserGroupMember.SETRANGE("User Security ID", Usuario);
        UserGroupMember.SETFILTER("Company Name", '=%1','');
        UserGroupMember.DELETEALL(TRUE);

      end ELSE begin
        //Elimino el usuario de la empresa
        UserGroupMember.RESET;
        UserGroupMember.SETRANGE("User Group Code", Grupo);
        UserGroupMember.SETRANGE("User Security ID", Usuario);
        UserGroupMember.SETRANGE("Company Name", rec.Name);
        UserGroupMember.DELETEALL(TRUE);

        //Lo a�ado a todas las empresas si no est� en ninguna
        UserGroupMember.RESET;
        UserGroupMember.SETRANGE("User Group Code", Grupo);
        UserGroupMember.SETRANGE("User Security ID", Usuario);
        if (UserGroupMember.ISEMPTY) then begin
          UserGroupMember.INIT;
          UserGroupMember."User Group Code" := Grupo;
          UserGroupMember."User Security ID" := Usuario;
          UserGroupMember."Company Name" := '';
          if UserGroupMember.INSERT(TRUE) then ;
        end;
      end;
    end;

    procedure SetData(pGrupo : Text;pUsuario : Text);
    begin
      Grupo := pGrupo;
      Usuario := pUsuario;
    end;

    // begin//end
}








