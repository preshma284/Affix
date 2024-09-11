page 50002 "QuoSync Setup"
{
  ApplicationArea=All;

    AccessByPermission=TableData 50002=RIMD;
    UsageCategory=Lists;
    CaptionML=ENU='Company Sync Setup',ESP='Sincronizar Empresas: Configuraci�n';
    SourceTable=50002;
    DelayedInsert=true;
    PageType=Document;
    
  layout
{
area(content)
{
group("group4")
{
        
                CaptionML=ESP='Configuraci�n';
group("group5")
{
        
                CaptionML=ESP='Datos generales';
    field("Active";rec."Active")
    {
        
    }
    field("Company Type";rec."Company Type")
    {
        
    }
    field("Destination Company";rec."Destination Company")
    {
        
    }
    field("Delete after days";rec."Delete after days")
    {
        
    }
    field("Last Sync";rec."Last Sync")
    {
        
    }

}
group("group11")
{
        
                CaptionML=ESP='Datos de Acceso';
    field("Connection Type";rec."Connection Type")
    {
        
                
                            ;trigger OnValidate()    BEGIN
                             setEditable;
                           END;


    }
    field("Server";rec."Server")
    {
        
                Editable=edExternal;
                
                            ;trigger OnValidate()    BEGIN
                             setEditable;
                           END;


    }
    field("Database";rec."Database")
    {
        
                Editable=edExternal;
                
                            ;trigger OnValidate()    BEGIN
                             setEditable;
                           END;


    }
    field("Security";rec."Security")
    {
        
                Editable=edSecurity;
                
                            ;trigger OnValidate()    BEGIN
                             setEditable;
                           END;


    }
    field("User";rec."User")
    {
        
                Editable=edUser ;
    }
    field("Password";rec."Password")
    {
        
                ExtendedDatatype=Masked;
                Editable=edUser ;
    }

}

}
    part("part1";50003)
    {
        ;
    }

}
}actions
{
area(Processing)
{

    action("action1")
    {
        CaptionML=ESP='Probar Conexi�n';
                      Enabled=edExternal;
                      Image=TestDatabase;
                      
                                
    trigger OnAction()    BEGIN
                                 TestConnection;
                               END;


    }

}
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action1_Promoted; action1)
                {
                }
            }
        }
}
  
trigger OnOpenPage()    BEGIN
                 IF NOT Rec.GET THEN BEGIN
                   Rec.INIT;
                   Rec.INSERT;
                 END;
               END;

trigger OnAfterGetRecord()    BEGIN
                       setEditable;
                     END;



    var
      QuoSyncReceiveData : Codeunit 50001;
      edExternal : Boolean;
      edSecurity : Boolean;
      edUser : Boolean;

    LOCAL procedure setEditable();
    begin
      edExternal := (rec."Connection Type" = rec."Connection Type"::SQL) or (rec."Connection Type" = rec."Connection Type"::Azure);
      edSecurity := (rec."Connection Type" = rec."Connection Type"::SQL);
      edUser := ((rec."Connection Type" = rec."Connection Type"::SQL) and (rec.Security = rec.Security::UserPassword)) or (rec."Connection Type" = rec."Connection Type"::Azure);
    end;

    LOCAL procedure TestConnection();
    var
      msgerror : Text;
    begin
      QuoSyncReceiveData.Connect(TRUE, TRUE);
    end;

    // begin//end
}









