page 7206996 "Analitical Distribution"
{
CaptionML=ENU='Analitical Distribution',ESP='Distribuci�n anal�tica';
    SourceTable=7206999;
    DelayedInsert=true;
    PageType=List;
    SourceTableTemporary=true;
    AutoSplitKey=true;
    ShowFilter=false;
    
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Job No.";rec."Job No.")
    {
        
                
                            ;trigger OnValidate()    BEGIN
                             QB_SetTxtPiecework(rec."Job No.");
                           END;


    }
    field("Piecework Code";rec."Piecework Code")
    {
        
                CaptionClass=txtPiecework ;
    }
    field("Description";rec."Description")
    {
        
    }
    field("Shortcut Dimension 1 Code";rec."Shortcut Dimension 1 Code")
    {
        
    }
    field("Shortcut Dimension 2 Code";rec."Shortcut Dimension 2 Code")
    {
        
    }
    field("Distribution %";rec."Distribution %")
    {
        
    }

}

}
area(FactBoxes)
{
    part("part1";699)
    {
        SubPageLink="Dimension Set ID"=FIELD("Dimension Set ID");
    }

}
}actions
{
area(Creation)
{

group("group2")
{
        CaptionML=ENU='&Line',ESP='&L�nea';
                      Image=Line ;
    action("Dimensions")
    {
        
                      AccessByPermission=TableData 348=R;
                      ShortCutKey='Shift+Ctrl+D';
                      CaptionML=ENU='Dimensions',ESP='Dimensiones';
                      ToolTipML=ENU='View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.',ESP='Permite ver o editar dimensiones, como el �rea, el proyecto o el departamento, que pueden asignarse a los documentos de venta y compra para distribuir costes y analizar el historial de transacciones.';
                      ApplicationArea=Dimensions;
                      Image=Dimensions;
                      
                                
    trigger OnAction()    BEGIN
                                 rec.ShowDimensions;
                                 CurrPage.SAVERECORD;
                               END;


    }

}

}
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(Dimensions_Promoted; Dimensions)
                {
                }
            }
        }
}
  
trigger OnAfterGetRecord()    BEGIN
                       QB_SetTxtPiecework(rec."Job No.");
                     END;

trigger OnInsertRecord(BelowxRec: Boolean): Boolean    BEGIN
                     rec."AF Code" :=   FACode;
                     //ErrorIfDuplicated;
                   END;

trigger OnModifyRecord(): Boolean    BEGIN
                     //ErrorIfDuplicated;
                   END;

trigger OnQueryClosePage(CloseAction: Action): Boolean    VAR
                       FixedAsset : Record 5600;
                     BEGIN
                       EXIT(UpdateAnalititicalDistribution);
                     END;



    var
      ErrorNot100 : TextConst ENU='Actual Distribution is %1%. It must be 100%. if you want to quit, distribution will not be saved.',ESP='La distribuci�n introducida es %1%. Debe ser 100%. Si cierra la distribuci�n introducida no se guardar�. �Desea cerrar?';
      FACode : Code[20];
      AnaliticalDistrbution : Record 7206999;
      WasDistributed : Boolean;
      txtPiecework : Text[80];
      FunctionQB : Codeunit 7207272;

    procedure SetFA(No : Code[20]);
    begin
      FACode := No;

      AnaliticalDistrbution.RESET;
      AnaliticalDistrbution.SETRANGE("AF Code", FACode);
      if AnaliticalDistrbution.FINDSET then repeat
        Rec := AnaliticalDistrbution;
        Rec.INSERT;
      until AnaliticalDistrbution.NEXT = 0;
    end;

    LOCAL procedure UpdateAnalititicalDistribution() : Boolean;
    var
      FA : Record 5600;
    begin
      //Se chequea que sea 100%
      Rec.RESET();
      Rec.CALCSUMS(rec."Distribution %");

      if (Rec."Distribution %" <> 100) and (Rec."Distribution %" <> 0) then
        exit(CONFIRM(ErrorNot100,FALSE, FORMAT(Rec."Distribution %")))
      ELSE begin
        //Si esta todo correcto, guardamos los cambios a la tabla

        //Se bloquea tabla para que no se produzca ningun analisis durante el borrado y escritura de las nuevas lineas.
        AnaliticalDistrbution.LOCKTABLE;

        AnaliticalDistrbution.RESET();
        AnaliticalDistrbution.SETRANGE("AF Code", FACode);
        AnaliticalDistrbution.DELETEALL(TRUE);

        if Rec.FINDSET then begin
          repeat
            AnaliticalDistrbution := Rec;
            AnaliticalDistrbution."Entry No." := 0;
            AnaliticalDistrbution.INSERT(TRUE);
          until Rec.NEXT = 0;

          FA.GET(FACode);
          FA."Asset Allocation Job" := '';
          FA."Piecework Code" := '';
          FA.MODIFY;

        end;

        exit(TRUE);
      end;
    end;

    procedure QB_SetTxtPiecework(Job : Code[20]);
    begin
      if (Job = '') then
        Job := Rec."Job No.";

      if (FunctionQB.Job_IsBudget(Job)) then
        txtPiecework := 'Partida Presupuestaria'
      ELSE
        txtPiecework := 'Unidad de Obra';

      //CurrPage.UPDATE(FALSE);
    end;

    LOCAL procedure ErrorIfDuplicated();
    var
      AnaliticalDistrib : Record 7206999 TEMPORARY;
      FACode : Code[20];
      JobNo : Code[20];
      PieceworkCode : Code[20];
      DimensionSetID : Integer;
      EntryNo : Integer;
      ErrorDupicatedRecord : TextConst ENU='Ya existe una l�nea de distribuci�n con la misma combinaci�n de proyecto, unidad de obra y valores de dimensi�n';
    begin
      FACode := Rec."AF Code";
      JobNo := Rec."Job No.";
      PieceworkCode := Rec."Piecework Code";
      DimensionSetID := Rec."Dimension Set ID";
      EntryNo := Rec."Entry No.";

      Rec.RESET;
      Rec.SETFILTER("Entry No.", '<>%1', EntryNo);
      Rec.SETRANGE("AF Code", FACode);
      Rec.SETRANGE("Job No.", JobNo);
      Rec.SETRANGE("Piecework Code", PieceworkCode);
      Rec.SETRANGE("Dimension Set ID", DimensionSetID);
      if not Rec.ISEMPTY then
        ERROR(ErrorDupicatedRecord);
    end;

    // begin//end
}







