page 7206908 "QB Responsibles Templ. Charge"
{
CaptionML=ENU='Responsibles Templates Charge',ESP='Cargar Plantilla de Responsables';
    InsertAllowed=false;
    DeleteAllowed=false;
    SourceTable=7206991;
    PageType=Card;
    SourceTableTemporary=true;
    
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Code";rec."Code")
    {
        
                Visible=false;
                Editable=false ;
    }
    field("Use in";rec."Use in")
    {
        
                Visible=false;
                Editable=false ;
    }
    field("Position";rec."Position")
    {
        
                Editable=false ;
    }
    field("Description";rec."Description")
    {
        
    }
    field("The User";rec."The User")
    {
        
                Editable=false ;
    }
    field("User ID";rec."User ID")
    {
        
                Editable=false ;
    }
    field("Name";rec."Name")
    {
        
    }
    field("User to Use";rec."User to Use")
    {
        
    }
    field("Name of User to Use";rec."Name of User to Use")
    {
        
    }

}

}
}
  trigger OnAfterGetRecord()    BEGIN
                       SetEditable;
                     END;

trigger OnQueryClosePage(CloseAction: Action): Boolean    BEGIN
                       IF (CloseAction = ACTION::LookupOK) THEN
                         OnClose;
                     END;



    var
      Job : Record 167;
      Job2 : Record 167;
      QBJobResponsible : Record 7206992;
      ResponsiblesTemplate : Record 7206991;
      edUser : Boolean ;
      globalType : Option;
      globalID : Code[20];
      Text000 : TextConst ESP='No ha definido un usuario para %1';
      globalTemplate : Code[20];
      globalEliminar : Boolean;

    LOCAL procedure SetEditable();
    begin
      edUser := (rec."The User" = rec."The User"::"is fixed");
    end;

    procedure OnOpen(Type: Option "Jobs","Departments","Quotes","RealEstate";pRecordID : Code[20];Template : Code[20];pEliminar : Boolean);
    var
      UserSetup : Record 91;
    begin
      globalType := Type;
      globalID   := pRecordID;
      globalTemplate := Template;
      globalEliminar := pEliminar;

      //Cargar la tabla temporal
      Rec.DELETEALL;
      ResponsiblesTemplate.SetFilterType(Type, pRecordID);        //JAV 31/08/21: - QB 1.09.99 Filtro por el tipo de registro
      ResponsiblesTemplate.SETRANGE(Template, globalTemplate);    //JAV 10/02/22: - QB 1.10.19 Filtro por la plantilla
      if (ResponsiblesTemplate.FINDSET) then
      repeat
        Rec := ResponsiblesTemplate;
        //JAV 28/06/22: - QB 1.10.54 Eliminar el Rec.VALIDATE y verificar despu�s si el usuario existe, si no dejarlo en blanco
        CASE Rec."The User" OF
          Rec."The User"::"Can defined"      : Rec."User to Use" := '';
          Rec."The User"::"is optional"      : Rec."User to Use" := '';
          Rec."The User"::"is fixed"         : Rec."User to Use" := ResponsiblesTemplate."User ID";
          Rec."The User"::"copy from quotes" : Rec."User to Use" := FindQuoteUser;
        end;
        if (Rec."User to Use" <> '') and (not UserSetup.GET(rec."User to Use")) then begin
          MESSAGE('El usuario %1 no existe en la configuraci�n de usuarios, se dejar� en blanco.', Rec."User to Use");
          Rec."User to Use" := '';
        end;
        Rec.INSERT;
      until ResponsiblesTemplate.NEXT = 0;
    end;

    procedure OnClose();
    begin
      //Paso los registros cargados al real
      if (globalEliminar) then begin
        QBJobResponsible.RESET;
        QBJobResponsible.SETRANGE(Type, globalType);
        QBJobResponsible.SETRANGE("Table Code", globalID);
        QBJobResponsible.DELETEALL;
      end;

      if (Rec.FINDSET) then
        repeat
          //Miro los que vienen del estudio
          if (Rec."User to Use" = '') and (Rec."The User" = Rec."The User"::"copy from quotes") then
            Rec.VALIDATE("User to Use", FindQuoteUser);

          //Reviso que todos los obligatorios tengan usuario
          if (Rec."The User" IN [Rec."The User"::"Can defined", Rec."The User"::"is fixed"]) and (Rec."User to Use" = '') then
            ERROR(Text000, Rec.Description);

          if (Rec."User to Use" <> '') then begin
            if (QBJobResponsible.GET(globalType, globalID, '',rec. Code)) then begin   //JAV 22/06/22: - QB 1.10.52 Se a�ade campo de unidad de obra, aqu� faltaba en el Rec.GET
              QBJobResponsible."User ID" := Rec."User to Use";
              QBJobResponsible.MODIFY;
            end ELSE begin
              QBJobResponsible.INIT;
              QBJobResponsible.Type := globalType;               //JAV 23/10/20 - QB 1.07.00 Se a�ade que es para proyectos o departamentos
              QBJobResponsible."Table Code" := globalID;         //JAV 23/10/20 - QB 1.07.00 Se a�ade la clave del registro a usar
              QBJobResponsible."Piecework No." := '';                        //JAV 22/06/22: - QB 1.10.52 Se a�ade campo de unidad de obra
              QBJobResponsible."ID Register" := Rec.Code;
              QBJobResponsible.Position := Rec.Position;
              QBJobResponsible."User ID" := Rec."User to Use";
              QBJobResponsible.INSERT;
            end;
          end;
        until (Rec.NEXT = 0);
    end;

    LOCAL procedure FindQuoteUser() : Text;
    begin
      if (Job2.GET(Job."Original Quote Code")) then begin      //Leo la versi�n
        if (Job2.GET(Job2."Original Quote Code")) then begin   //Busco su padre
          QBJobResponsible.RESET;
          QBJobResponsible.SETRANGE(Type, QBJobResponsible.Type::Job);    //JAV 23/10/20 - QB 1.07.00 Se a�ade que es para proyectos
          QBJobResponsible.SETRANGE("Table Code", Job2."No.");
          QBJobResponsible.SETRANGE( Position, rec. Position);
          if QBJobResponsible.FINDFIRST then
            exit(QBJobResponsible."User ID");
        end;
      end;
      exit('');
    end;

    // begin
    /*{
      JAV 28/01/20: - Nueva p�gina para crear los responsables de estudios y obras a partir de las plantillas
      JAV 10/02/22: - QB 1.10.19 Se a�ade el Filtro por la plantilla
    }*///end
}








