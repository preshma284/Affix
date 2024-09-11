page 7174393 "QM MasterData Setup Fields"
{
CaptionML=ENU='MasterData Setup Fields',ESP='Master Data Campos';
    SaveValues=true;
    InsertAllowed=false;
    DeleteAllowed=false;
    SourceTable=7174393;
    PageType=Worksheet;
    
  layout
{
area(content)
{
repeater("table")
{
        
    field("Table No.";rec."Table No.")
    {
        
                Visible=false;
                Editable=FALSE ;
    }
    field("Field No.";rec."Field No.")
    {
        
                Editable=FALSE;
                StyleExpr=stLine ;
    }
    field("Field Name";rec."Field Name")
    {
        
                StyleExpr=stLine ;
    }
    field("PK";rec."PK")
    {
        
                ToolTipML=ESP='Indica si el campo es parte de la clave primaria (ser� siempre sincronizable y por tanto no editable en destino)';
    }
    field("FlowFilter";rec."FlowFilter")
    {
        
                ToolTipML=ESP='Indica si el campo es usado solo para filtros (no es un campo sincronizable y es siempre editable en destino)';
    }
    field("FlowField";rec."FlowField")
    {
        
                ToolTipML=ESP='Indica si el campo es de tipo calculado (no es un campo sincronizable y no es editable en destino)';
    }
    field("Date Variable";rec."Date Variable")
    {
        
                ToolTipML=ESP='Este campo indiica si la fecha puede ser la de alta o la de �ltima modificaci�n, que deben marcarse siempre como editables en destino para evitar problemas de cambios sobre cambios';
    }
    field("Relation Table No.";rec."Relation Table No.")
    {
        
                ToolTipML=ESP='Este valor indica con que tabla se relaciona este campo';
                BlankZero=true;
    }
    field("Relation Table Name";rec."Relation Table Name")
    {
        
                ToolTipML=ESP='Este valor indica el nombre de la tabla con la que se relaciona este campo';
    }
    field("MD_Relacionada";Relacionada)
    {
        
                CaptionML=ESP='Incluir';
                Visible=SeeMD;
                Editable=FALSE;
                
                              ;trigger OnAssistEdit()    BEGIN
                               Rec.CALCFIELDS("Relation Table No.");

                               IF (Rec."Relation Table No." = 0) OR (Rec."Relation Table No." = Rec."Table No.") THEN
                                 EXIT;

                               Rec.CALCFIELDS("MD Relation Table Sync");
                               IF (Rec."MD Relation Table Sync") THEN BEGIN
                                 IF (QMMasterDataTable.GET(rec."Relation Table No.")) THEN BEGIN
                                   QMMasterDataTable.Sync := FALSE;
                                   QMMasterDataTable.MODIFY;
                                 END;
                                 MESSAGE('La tabla %1 ha dejado de sincronizarse', Rec."Relation Table No.");
                               END ELSE BEGIN
                                 IF (QMMasterDataTable.GET(rec."Relation Table No.")) THEN BEGIN
                                   QMMasterDataTable.Sync := TRUE;
                                   QMMasterDataTable.MODIFY;
                                 END ELSE BEGIN
                                   QMMasterDataTable.INIT;
                                   QMMasterDataTable."Table No." := Rec."Relation Table No.";
                                   QMMasterDataTable.Sync := TRUE;
                                   QMMasterDataTable.INSERT(TRUE);
                                 END;
                                 MESSAGE('Revise los campos de la tabla %1 que acaba de a�adir en la sincronizaci�n', Rec."Relation Table No.");
                               END;
                               Rec.MODIFY;

                               OnAfterGet;
                             END;


    }
    field("Not editable in destination";rec."Not editable in destination")
    {
        
                ToolTipML=ESP='En la sicronizaci�n por tablas, incica si el campo no ser� editable en la empresa de destino de la sincronizaci�n';
                Visible=SeeMD;
                Editable=edNotEditable ;
    }
    field("CN_Relacionada";Relacionada)
    {
        
                CaptionML=ESP='Incluir';
                Visible=seeConf;
                Editable=FALSE;
                
                              ;trigger OnAssistEdit()    BEGIN
                               Rec.CALCFIELDS("Relation Table No.");

                               IF (Rec."Relation Table No." = 0) OR (Rec."Relation Table No." = Rec."Table No.") THEN
                                 EXIT;

                               Rec.CALCFIELDS("CN Relation Table Sync");
                               IF (Rec."CN Relation Table Sync") THEN BEGIN
                                 IF (QMMasterDataConfTables.GET(rec."Relation Table No.")) THEN BEGIN
                                   QMMasterDataConfTables.Configuration := QMMasterDataConfTables.Configuration::Yes;
                                   QMMasterDataConfTables.MODIFY;
                                 END;
                                 MESSAGE('La tabla %1 ha dejado de sincronizarse', Rec."Relation Table No.");
                               END ELSE BEGIN
                                 IF (QMMasterDataConfTables.GET(rec."Relation Table No.")) THEN BEGIN
                                   QMMasterDataConfTables.Configuration := QMMasterDataConfTables.Configuration::OnlyQB;
                                   QMMasterDataConfTables.MODIFY;
                                 END ELSE BEGIN
                                   QMMasterDataConfTables.INIT;
                                   QMMasterDataConfTables."Table No." := Rec."Relation Table No.";
                                   QMMasterDataConfTables.Configuration := QMMasterDataConfTables.Configuration::OnlyQB;
                                   QMMasterDataConfTables.INSERT(TRUE);
                                 END;
                                 MESSAGE('Revise los campos de la tabla %1 que acaba de a�adir en la sincronizaci�n', Rec."Relation Table No.");
                               END;
                               Rec.MODIFY;

                               OnAfterGet;
                             END;


    }
    field("Syncronization";rec."Syncronization")
    {
        
                Visible=seeConf;
                Editable=edNotEditable 

  ;
    }

}

}
}actions
{
area(Processing)
{

    action("action1")
    {
        CaptionML=ESP='Todos a SI';
                      Promoted=true;
                      Image=Approve;
                      PromotedCategory=Process;
                      
                                trigger OnAction()    BEGIN
                                 QMMasterDataTableField.INIT;
                                 QMMasterDataTableField.SETRANGE("Table No.", Tabla);
                                 IF (QMMasterDataTableField.FINDSET) THEN
                                   REPEAT
                                     IF (QMMasterDataTableField."Date Variable") THEN BEGIN
                                       QMMasterDataTableField.VALIDATE("Not editable in destination", FALSE);
                                       MESSAGE('No se marca el campo %1 por ser una posible fecha de creaci�n o de �ltima modificaci�n', QMMasterDataTableField."Field No.");
                                     END ELSE BEGIN
                                       QMMasterDataTableField.CALCFIELDS(FlowFilter, FlowField);
                                       QMMasterDataTableField.VALIDATE("Not editable in destination", NOT (QMMasterDataTableField.FlowFilter OR QMMasterDataTableField.FlowField));
                                     END;
                                     QMMasterDataTableField.MODIFY;
                                   UNTIL (QMMasterDataTableField.NEXT = 0);
                               END;


    }
    action("action2")
    {
        CaptionML=ESP='Todos a NO';
                      Promoted=true;
                      Image=Cancel;
                      PromotedCategory=Process;
                      
                                
    trigger OnAction()    BEGIN
                                 QMMasterDataTableField.INIT;
                                 QMMasterDataTableField.SETRANGE("Table No.", Tabla);
                                 QMMasterDataTableField.SETRANGE(PK, FALSE);
                                 QMMasterDataTableField.MODIFYALL("Not editable in destination", FALSE);
                               END;


    }

}
}
  trigger OnOpenPage()    BEGIN
                 Txt := Rec.GETFILTER("Table No.");
                 EVALUATE(Tabla, Txt);
                 //JAV 12/04/23: - MD 1.00.02 Revisar siempre los campos al entrar en la pantalla, pueden exisitir nuevos o eliminados
                 Rec.CreateFields(Tabla);
               END;

trigger OnAfterGetRecord()    BEGIN
                       OnAfterGet;
                     END;

trigger OnAfterGetCurrRecord()    BEGIN
                           OnAfterGet;
                         END;



    var
      tbFields : Record 2000000041;
      QMMasterDataTable : Record 7174392;
      QMMasterDataConfTables : Record 7174389;
      QMMasterDataTableField : Record 7174393;
      Tabla : Integer;
      Txt : Text;
      edNotEditable : Boolean;
      stLine : Text;
      Relacionada : Text[10];
      seeMD : Boolean;
      seeConf : Boolean;

    LOCAL procedure OnAfterGet();
    begin
      Rec.CALCFIELDS("MD Relation Table Sync", "CN Relation Table Sync", FlowField, FlowFilter);

      Relacionada := '';
      if ((seeMD) and (rec."MD Relation Table Sync")) or ((seeConf) and (rec."CN Relation Table Sync")) then
        Relacionada := 'Incluida';

      edNotEditable := (not rec.PK) and (not rec.FlowFilter) and (not rec.FlowField);
      stLine := 'Standar';
      if (rec.FlowField or rec.FlowFilter) then
        stLine := 'Subordinate';
      if (rec."Date Variable") then
        stLine := 'Attention';
      if (rec.PK) then
        stLine := 'Strong';
    end;

    procedure SetType(pType: Option "MD","Conf");
    begin
      seeMD   := (pType = pType::MD);
      seeConf := (pType = pType::Conf);
    end;

    // begin//end
}








