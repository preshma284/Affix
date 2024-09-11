page 7207016 "Plan Job Budget Units"
{
CaptionML=ENU='Plan Job Units',ESP='Planif. unidades de obra';
    SaveValues=true;
    InsertAllowed=false;
    DeleteAllowed=false;
    ModifyAllowed=false;
    SourceTable=7207386;
    PageType=Card;
    
  layout
{
area(content)
{
group("group6")
{
        
                CaptionML=ENU='Matrix Options',ESP='Opciones Matriz';
    field("PeriodType";PeriodType)
    {
        
                CaptionML=ENU='View By',ESP='Ver por';
                // OptionCaptionML=ENU='View By',ESP='Ver por';
                Editable=false;
                Style=StrongAccent;
                StyleExpr=TRUE;
                
                            ;trigger OnValidate()    BEGIN
                             SetColumns(SetWanted::Initial);
                           END;


    }
    field("QtyType";QtyType)
    {
        
                CaptionML=ENU='View as',ESP='Ver como';
                OptionCaptionML=ENU='View as',ESP='Ver como';
                Visible=false;
                Style=StrongAccent;
                StyleExpr=TRUE ;
    }
    field("ColumnSet";ColumnSet)
    {
        
                CaptionML=ENU='Column Set',ESP='Conjunto de valores';
                Editable=FALSE ;
    }
group("group10")
{
        
                CaptionML=ENU='Matrix Options',ESP='Ver';
                Visible=false;
    field("vDir";vDir)
    {
        
                CaptionML=ENU='Directs',ESP='Directos';
    }
    field("vInd";vInd)
    {
        
                CaptionML=ENU='Indirects',ESP='Indirectos';
    }

}

}

}
}actions
{
area(Processing)
{

    action("action1")
    {
        CaptionML=ENU='&Show Matrix',ESP='&Muestra Matriz';
                      ToolTipML=ENU='&Show Matrix',ESP='&Muestra Matriz';
                      Image=ShowMatrix;
                      
                                trigger OnAction()    VAR
                                 PlanJobUnitsMatrix : Page 7207060;
                               BEGIN
                                 //JAV 22/06/21: - QB 1.09.01 Se a�ade el filtro de tipo de U.O.
                                 //JAV 19/10/21: - QB 1.09.22 Se a�ade el caption del rango de columnas visible
                                 PlanJobUnitsMatrix.Load(MatrixColumnCaptions,MatrixRecords,QtyType,NoJob,BudgetFilter,ColumnSet, vDir, vInd);
                                 PlanJobUnitsMatrix.RUNMODAL;
                               END;


    }
    action("action2")
    {
        CaptionML=ENU='Previous Set',ESP='Periodo anterior';
                      ToolTipML=ENU='Previous Set',ESP='Periodo anterior';
                      Image=PreviousSet;
                      
                                trigger OnAction()    VAR
                                 MATRIX_Step: Option "First","Previous","Next";
                               BEGIN
                                 SetColumns(SetWanted::Previous);
                               END;


    }
    action("action3")
    {
        CaptionML=ENU='Next Set',ESP='Periodo siguiente';
                      ToolTipML=ENU='Next Set',ESP='Periodo siguiente';
                      Image=NextSet;
                      
                                
    trigger OnAction()    VAR
                                 MATRIX_Step: Option "First","Previous","Next";
                               BEGIN
                                 SetColumns(SetWanted::NEXT);
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
                actionref(action2_Promoted; action2)
                {
                }
                actionref(action3_Promoted; action3)
                {
                }
            }
        }
}
  trigger OnOpenPage()    BEGIN
                 SetColumns(SetWanted::Initial);
                 NoJob := Rec.GETFILTER("Job No.");
                 BudgetFilter := Rec.GETFILTER("Budget Filter");
                 //JAV 22/06/21: - QB 1.09.01 Se a�ade el filtro de tipo de U.O.
                 TypeFilter := Rec.GETFILTER(Type);
                 IsDirectCost := (TypeFilter = FORMAT(rec.Type::Piecework));

                 //Veremos por meses
                 PeriodType := PeriodType::Month;

                 vDir := IsDirectCost;
                 vInd := NOT vDir;
               END;



    var
      MatrixRecords : ARRAY [32] OF Record 2000000007;
      ColumnSet : Text[1024];
      MatrixColumnCaptions : ARRAY [32] OF Text[1024];
      // PeriodType: Option "Day","Week","Month","Quarter","Year","Accounting Period";
      PeriodType : Enum "Analysis Period Type";
      SetWanted: Option "Initial","Previous","Same","Next";
      QtyType: Option "Net Change","Balance at Date";
      NoJob : Code[20];
      BudgetFilter : Code[20];
      TypeFilter : Text;
      IsDirectCost : Boolean;
      PKFirstRecInCurrSet : Text[100];
      vDir : Boolean;
      vInd : Boolean;

    procedure SetColumns(SetWanted: Option "Initial","Previous","Same","Next");
    var
      MatrixMgt : Codeunit 9200;
      Job : Record 167;
      CurrSetLength : Integer;
    begin
      if Job.GET(rec."Job No.") then;
      MatrixMgt.GeneratePeriodMatrixData(SetWanted,32,FALSE,PeriodType,FORMAT(Job."Starting Date")+'..'+FORMAT(Job."Ending Date"),
                                         PKFirstRecInCurrSet,MatrixColumnCaptions,ColumnSet,CurrSetLength,MatrixRecords);
    end;

    // begin
    /*{
      JAV 22/06/21: - QB 1.09.01 Se a�ade el filtro de tipo de U.O.
    }*///end
}







