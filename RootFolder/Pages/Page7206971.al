page 7206971 "QB Tracking subcontracting"
{
CaptionML=ENU='Tracing Subcontracting by Purchas Code',ESP='Seguimiento subcontrataciones por c�digos de compra';
    InsertAllowed=false;
    DeleteAllowed=false;
    SourceTable=7207387;
    SourceTableView=SORTING("Job No.","Piecework Code","Cod. Budget","Cost Type","No.")
                    WHERE("Cost Type"=FILTER("Resource"));
    PageType=List;
    
  layout
{
area(content)
{
group("Group")
{
        
                CaptionML=ENU='Options',ESP='Opciones';
    field("PeriodType";PeriodType)
    {
        
                CaptionML=ENU='See for',ESP='Ver por';
                ToolTipML=ENU='Day',ESP='D�a';
                OptionCaptionML=ENU='See for',ESP='Ver por';
                Style=StandardAccent;
                StyleExpr=TRUE;
                
                            ;trigger OnValidate()    BEGIN
                             IF PeriodType = PeriodType::"Accounting Period" THEN
                               AccountingPerioPeriodTypeOnVal;
                             IF PeriodType = PeriodType::Year THEN
                               YearPeriodTypeOnValidate;
                             IF PeriodType = PeriodType::Quarter THEN
                               QuarterPeriodTypeOnValidate;
                             IF PeriodType = PeriodType::Month THEN
                               MonthPeriodTypeOnValidate;
                             IF PeriodType = PeriodType::Week THEN
                               WeekPeriodTypeOnValidate;
                             IF PeriodType = PeriodType::Day THEN
                               DayPeriodTypeOnValidate;
                             CurrPage.UPDATE;
                           END;


    }
    field("";'')
    {
        
                CaptionML=ENU='See How',ESP='Ver como';
                ToolTipML=ENU='Net Change',ESP='Saldo periodo';
                // OptionCaptionML=ENU='See How',ESP='Ver como';
                Style=StandardAccent;
                StyleExpr=TRUE;
                
                            ;trigger OnValidate()    BEGIN
                             IF AmountType = AmountType::"Balance at Date" THEN
                               BalanceatDateAmountTypeOnValid;
                             IF AmountType = AmountType::"Net Change" THEN
                               NetChangeAmountTypeOnValidate;
                             CurrPage.UPDATE;
                           END;


    }

}
repeater("table")
{
        
                IndentationColumn=DescriptionIdent;
                IndentationControls=Description;
    field("Piecework Code";rec."Piecework Code")
    {
        
                Editable=False;
                Style=Strong;
                StyleExpr=TRUE ;
    }
    field("PieceWorkDescription";DataPieceworkProduction.GetStyle(rec."Piecework Code"))
    {
        
                CaptionML=ENU='PieceWork Description',ESP='Desc. unidad de obra';
                Editable=FALSE ;
    }
    field("No.";rec."No.")
    {
        
    }
    field("Description";rec."Description")
    {
        
                Editable=False;
                Style=Standard;
                StyleExpr=TRUE ;
    }
    field("GetTotalMeasure";rec."GetTotalMeasure")
    {
        
                CaptionML=ENU='Piecework Measure',ESP='Medici�n Partida';
    }
    field("GetUnitofMeasure";rec."GetUnitofMeasure")
    {
        
                CaptionML=ENU='Piecework Unit of Measure',ESP='Unidad Media U.O.';
                Editable=false ;
    }
    field("Performance By Piecework";rec."Performance By Piecework")
    {
        
    }
    field("TotalMeasure";rec.GetTotalMeasure*rec."Performance By Piecework")
    {
        
                CaptionML=ENU='Total Measure',ESP='Medici�n Total';
                Editable=false ;
    }
    field("Cod. Measure Unit";rec."Cod. Measure Unit")
    {
        
                Editable=false ;
    }
    field("Direct Unitary Cost (JC)";rec."Direct Unitary Cost (JC)")
    {
        
    }
    field("Qty. In Contract";rec."Qty. In Contract")
    {
        
    }
    field("Amount In Contract";rec."Amount In Contract")
    {
        
    }
    field("GetMeasurePerformed";rec."GetMeasurePerformed")
    {
        
                CaptionML=ENU='Performed Measure',ESP='Medici�n Ejecutada';
    }
    field("ExpectedMeasure";rec.GetMeasurePerformed*rec."Performance By Piecework")
    {
        
                CaptionML=ENU='Expected Cost Measure',ESP='Medici�n Coste previsto';
                Editable=false ;
    }
    field("ExpectedAmount";rec.GetMeasurePerformed*rec."Performance By Piecework"*rec."Direct Unitary Cost (JC)")
    {
        
                CaptionML=ENU='"Expected Cost Amount "',ESP='Importe Coste Previsto';
                Editable=FALSE ;
    }
    field("Measure Product Exec.";rec."Measure Product Exec.")
    {
        
                Editable=false ;
    }
    field("Product Exec. Cost";rec."Product Exec. Cost")
    {
        
                Editable=false ;
    }
    field("Measure Resource Exec.";rec."Measure Resource Exec.")
    {
        
    }
    field("Resource Exec. Cost";rec."Resource Exec. Cost")
    {
        
    }
    field("Qty. Invoiced";rec."Qty. Invoiced")
    {
        
                Editable=false ;
    }
    field("Amount Invoiced";rec."Amount Invoiced")
    {
        
                Editable=false ;
    }
    field("Qty. CreditMemo";rec."Qty. CreditMemo")
    {
        
                Editable=false ;
    }
    field("Amount CreditMemo";rec."Amount CreditMemo")
    {
        
                Editable=false 

  ;
    }

}

}
}actions
{
area(Navigation)
{

group("group2")
{
        CaptionML=ENU='&Piecework',ESP='&Unidad Obra';
    action("action1")
    {
        ShortCutKey='Ctrl+F7';
                      CaptionML=ENU='Ledger Entries',ESP='&Movimientos';
                      RunObject=Page 92;
                      RunPageView=SORTING("Job No.","Posting Date","Type","No.","Entry Type","Piecework No.");
RunPageLink="Job No."=FIELD("Job No."), "Piecework No."=FIELD("Piecework Code");
                      Image=JobLedger ;
    }
    action("Refresh")
    {
        
                      CaptionML=ENU='A&nalytic Piecework',ESP='Refrescar';
                      Visible=false;
                      Image=InsertStartingFee;
                      
                                trigger OnAction()    BEGIN

                                 CurrPage.UPDATE;
                               END;


    }

}

}
area(Processing)
{

    action("action3")
    {
        CaptionML=ENU='Previous Period',ESP='Periodo anterior';
                      ToolTipML=ENU='Previous Period',ESP='Periodo anterior';
                      Image=PreviousRecord;
                      
                                trigger OnAction()    BEGIN
                                 FindPeriod('<=');
                               END;


    }
    action("action4")
    {
        CaptionML=ENU='Next Period',ESP='Periodo siguiente';
                      ToolTipML=ENU='Next Period',ESP='Periodo siguiente';
                      Image=NextRecord;
                      
                                
    trigger OnAction()    BEGIN
                                 FindPeriod('>=');
                               END;


    }

}
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action3_Promoted; action3)
                {
                }
                actionref(action4_Promoted; action4)
                {
                }
                actionref(Refresh_Promoted; Refresh)
                {
                }
            }
        }
}
  

trigger OnOpenPage()    VAR
                 JobBudget : Record 7207407;
               BEGIN
                 AmountType:=AmountType::"Balance at Date";
                 FindPeriod('');
                 //Rec.SETRANGE("Activity Code");
                 //FILTRO DE PRESUPUESTO ACTIVO JMMA
                 JobBudget.RESET;
                 JobBudget.SETRANGE("Job No.",rec."Job No.");
                 JobBudget.SETRANGE("Actual Budget",TRUE);
                 IF JobBudget.FINDFIRST THEN
                   Rec.SETFILTER("Cod. Budget",JobBudget."Cod. Budget");
                 //
               END;

trigger OnAfterGetRecord()    BEGIN
                       DescriptionIdent := 0;
                       /*{
                       Rec.CALCFIELDS("Amount Production Budget","Aver. Cost Price Pend. Budget","Budget Measure","Total Measurement Production",
                       "Amount Production Performed","Amount Cost Budget DP");
                       OnFormatPieceworkCode;
                       OnFormatDescription;
                       OnFormatMeasureBudget;
                       OnFormatMeasureProduction;
                       OnFormatAmountCostPerform;
                       CalQuantityMeasureSubcontracting;
                       CalAmountMeasureSubcontracting;
                       CalQuantityInvoicedSubcontracting;
                       CalAmountInvoicedSubcontracting;
                       CalQuantityCreditMemoSubcontracting;
                       CalAmountCreditMemoSucbonctracting;
                       }*/
                     END;



    var
      DataPieceworkProduction : Record 7207386;
      // PeriodType: Option "Day","Week","Month","Quarter","Year","Accounting Period";
      PeriodType: Enum "Analysis Period Type";
      AmountType: Option "Net Change","Balance at Date";
      DescriptionIdent : Integer;
      PieceworkCodeEmphasize : Boolean;
      DescriptionEmphasize : Boolean;
      MeasureBudgetEmphasize : Boolean;
      MeasureProductionEmphasize : Boolean;
      AmountCostRealizedEmphasize : Boolean;
      QuantityMeaureSubconEmphasize : Boolean;
      AmountMeasureSubconEmphasize : Boolean;
      QuantityInvoicedSubconEmphasize : Boolean;
      AmountInvoicedSubconEmphasize : Boolean;
      QuantityCreditMemoEmphasize : Boolean;
      AmountCreditMemoEmphasize : Boolean;

    LOCAL procedure FindPeriod(SearchText : Code[10]);
    var
      Calendar : Record 2000000007;
      AccountingPeriod : Record 50;
      PeriodFormMgt : Codeunit 50324;
    begin
      if Rec.GETFILTER("Filter Date") <> '' then begin
        Calendar.SETFILTER("Period Start",rec.GETFILTER("Filter Date"));
        if not PeriodFormMgt.FindDate('+',Calendar,PeriodType) then
          PeriodFormMgt.FindDate('+',Calendar,PeriodType::Day);
        Calendar.SETRANGE("Period Start");
      end;
      PeriodFormMgt.FindDate(SearchText,Calendar,PeriodType);
      if AmountType = AmountType::"Net Change" then
        if Calendar."Period Start" = Calendar."Period end" then
          Rec.SETRANGE("Filter Date",Calendar."Period Start")
        ELSE
          Rec.SETRANGE("Filter Date",Calendar."Period Start",Calendar."Period end")
      ELSE
        Rec.SETRANGE("Filter Date",0D,Calendar."Period end");
    end;

    LOCAL procedure OnFormatPieceworkCode();
    begin
      /*{
      if "Account Type" <> "Account Type"::Unit then begin
        PieceworkCodeEmphasize := TRUE;
      end;
      }*/
    end;

    LOCAL procedure OnFormatDescription();
    begin
      //JMMA DescriptionIdent := Indentation;
      /*{
      if "Account Type" <> "Account Type"::Unit then begin
        DescriptionEmphasize := TRUE;
      end;
      }*/
    end;

    LOCAL procedure OnFormatMeasureBudget();
    begin
      /*{if "Account Type" <> "Account Type"::Unit then begin
        MeasureBudgetEmphasize := TRUE;
      end;
      }*/
    end;

    LOCAL procedure OnFormatMeasureProduction();
    begin
      /*{if "Account Type" <> "Account Type"::Unit then begin
        MeasureProductionEmphasize := TRUE;
      end;
      }*/
    end;

    LOCAL procedure OnFormatAmountCostPerform();
    begin
      /*{
      if "Account Type" <> "Account Type"::Unit then begin
        AmountCostRealizedEmphasize := TRUE;
      end;
      }*/
    end;

    LOCAL procedure CalQuantityMeasureSubcontracting();
    begin
      /*{
      if "Account Type" <> "Account Type"::Unit then begin
        QuantityMeaureSubconEmphasize := TRUE;
      end;
      }*/
    end;

    LOCAL procedure CalAmountMeasureSubcontracting();
    begin
      /*{
      if "Account Type" <> "Account Type"::Unit then begin
        AmountMeasureSubconEmphasize := TRUE;
      end;
      }*/
    end;

    LOCAL procedure CalQuantityInvoicedSubcontracting();
    begin
      /*{
      if "Account Type" <> "Account Type"::Unit then begin
        QuantityInvoicedSubconEmphasize := TRUE;
      end;
      }*/
    end;

    LOCAL procedure CalAmountInvoicedSubcontracting();
    begin
      /*{
      if "Account Type" <> "Account Type"::Unit then begin
        AmountInvoicedSubconEmphasize := TRUE;
      end;
      }*/
    end;

    LOCAL procedure CalQuantityCreditMemoSubcontracting();
    begin
      /*{
      if "Account Type" <> "Account Type"::Unit then begin
        QuantityCreditMemoEmphasize := TRUE;
      end;
      }*/
    end;

    LOCAL procedure CalAmountCreditMemoSucbonctracting();
    begin
      /*{
      if "Account Type" <> "Account Type"::Unit then begin
        AmountCreditMemoEmphasize := TRUE;
      end;
      }*/
    end;

    LOCAL procedure AccountingPerioPeriodTypeOnVal();
    begin
      AccountingPerioPeriodTypOnPush;
    end;

    LOCAL procedure AccountingPerioPeriodTypOnPush();
    begin
      FindPeriod('');
    end;

    LOCAL procedure YearPeriodTypeOnValidate();
    begin
      YearPeriodTypeOnPush;
    end;

    LOCAL procedure YearPeriodTypeOnPush();
    begin
      FindPeriod('');
    end;

    LOCAL procedure QuarterPeriodTypeOnValidate();
    begin
      QuarterPeriodTypeOnPush;
    end;

    LOCAL procedure QuarterPeriodTypeOnPush();
    begin
      FindPeriod('');
    end;

    LOCAL procedure MonthPeriodTypeOnValidate();
    begin
      MonthPeriodTypeOnPush;
    end;

    LOCAL procedure MonthPeriodTypeOnPush();
    begin
      FindPeriod('');
    end;

    LOCAL procedure WeekPeriodTypeOnValidate();
    begin
      WeekPeriodTypeOnPush;
    end;

    LOCAL procedure WeekPeriodTypeOnPush();
    begin
      FindPeriod('');
    end;

    LOCAL procedure DayPeriodTypeOnPush();
    begin
      FindPeriod('');
    end;

    LOCAL procedure DayPeriodTypeOnValidate();
    begin
      DayPeriodTypeOnPush;
    end;

    LOCAL procedure BalanceatDateAmountTypeOnValid();
    begin
      BalanceatDateAmountTypeOnPush;
    end;

    LOCAL procedure BalanceatDateAmountTypeOnPush();
    begin
      FindPeriod('');
    end;

    LOCAL procedure NetChangeAmountTypeOnValidate();
    begin
      NetChangeAmountTypeOnPush;
    end;

    LOCAL procedure NetChangeAmountTypeOnPush();
    begin
      FindPeriod('');
    end;

    procedure ShowMeasureSubcontracting();
    var
      LPurchRcptLine : Record 121;
      LDataPieceworkForProduction : Record 7207386;
    begin
      /*{
      if "Account Type" = "Account Type"::Unit then begin
        LPurchRcptLine.RESET;
        LPurchRcptLine.SETCURRENTKEY("Job No.","Piecework N�",Type,"No.","Order Date");
        LPurchRcptLine.SETRANGE("Job No.", rec."Job No.");
        LPurchRcptLine.SETRANGE("Piecework N�","Piecework Code");
        LPurchRcptLine.SETRANGE(Type,LPurchRcptLine.Type::"6");
        LPurchRcptLine.SETRANGE("No.","No. Subcontracting Resource");
        Rec.COPYFILTER("Filter Date",LPurchRcptLine."Order Date");
        PAGE.RUNMODAL(0,LPurchRcptLine);
      end ELSE begin
        LDataPieceworkForProduction.RESET;
        LDataPieceworkForProduction.SETRANGE("Job No.", rec."Job No.");
        LDataPieceworkForProduction.SETFILTER("Piecework Code",Totaling);
        if LDataPieceworkForProduction.FINDSET then
          repeat
            LPurchRcptLine.RESET;
            LPurchRcptLine.SETCURRENTKEY("Job No.","Piecework N�",Type,"No.","Order Date");
            LPurchRcptLine.SETRANGE("Job No.",LDataPieceworkForProduction."Job No.");
            LPurchRcptLine.SETRANGE("Piecework N�",LDataPieceworkForProduction."Piecework Code");
            LPurchRcptLine.SETRANGE(Type,LPurchRcptLine.Type::"6");
            LPurchRcptLine.SETRANGE("No.",LDataPieceworkForProduction."No. Subcontracting Resource");
            Rec.COPYFILTER("Filter Date",LPurchRcptLine."Order Date");
            if LPurchRcptLine.FINDSET then begin
              repeat
                LPurchRcptLine.MARK(TRUE);
              until LPurchRcptLine.NEXT = 0;
            end;

          until LDataPieceworkForProduction.NEXT = 0;
          LPurchRcptLine.SETRANGE("Job No.");
          LPurchRcptLine.SETRANGE("Piecework N�");
          LPurchRcptLine.SETRANGE(Type);
          LPurchRcptLine.SETRANGE("No.");
          LPurchRcptLine.SETRANGE("Order Date");
          LPurchRcptLine.MARKEDONLY(TRUE);
          PAGE.RUNMODAL(0,LPurchRcptLine);
      end;
      }*/
    end;

    procedure ShowInvoicedSubcontracting();
    var
      LPurchInvLine : Record 123;
      LDataPieceworkForProduction : Record 7207386;
    begin
      /*{
      if "Account Type" = "Account Type"::Unit then begin
        LPurchInvLine.RESET;
        LPurchInvLine.SETCURRENTKEY("Job No.","Piecework No.",Type,"No.","Expected Receipt Date");
        LPurchInvLine.SETRANGE("Job No.", rec."Job No.");
        LPurchInvLine.SETRANGE("Piecework No.","Piecework Code");
        LPurchInvLine.SETRANGE(Type,LPurchInvLine.Type::Resource);
        LPurchInvLine.SETRANGE("No.","No. Subcontracting Resource");
        Rec.COPYFILTER("Filter Date",LPurchInvLine."Expected Receipt Date");
        PAGE.RUNMODAL(0,LPurchInvLine);
      end ELSE begin
        LDataPieceworkForProduction.RESET;
        LDataPieceworkForProduction.SETRANGE("Job No.", rec."Job No.");
        LDataPieceworkForProduction.SETFILTER("Piecework Code",Totaling);
        if LDataPieceworkForProduction.FINDSET then
          repeat
            LPurchInvLine.RESET;
            LPurchInvLine.SETCURRENTKEY("Job No.","Piecework No.",Type,"No.","Expected Receipt Date");
            LPurchInvLine.SETRANGE("Job No.",LDataPieceworkForProduction."Job No.");
            LPurchInvLine.SETRANGE("Piecework No.",LDataPieceworkForProduction."Piecework Code");
            LPurchInvLine.SETRANGE(Type,LPurchInvLine.Type::Resource);
            LPurchInvLine.SETRANGE("No.",LDataPieceworkForProduction."No. Subcontracting Resource");
            Rec.COPYFILTER("Filter Date",LPurchInvLine."Expected Receipt Date");
            if LPurchInvLine.FINDFIRST then begin
              repeat
                LPurchInvLine.MARK(TRUE);
              until LPurchInvLine.NEXT = 0;
            end;

          until LDataPieceworkForProduction.NEXT = 0;
          LPurchInvLine.SETRANGE("Job No.");
          LPurchInvLine.SETRANGE("Piecework No.");
          LPurchInvLine.SETRANGE(Type);
          LPurchInvLine.SETRANGE("No.");
          LPurchInvLine.SETRANGE("Expected Receipt Date");
          LPurchInvLine.MARKEDONLY(TRUE);
          PAGE.RUNMODAL(0,LPurchInvLine);
      end;
      }*/
    end;

    procedure ShowCreditMemoSubcontracting();
    var
      LPurchCrMemoLine : Record 125;
      LDataPieceworkForProduction : Record 7207386;
    begin
      /*{
      if "Account Type" = "Account Type"::Unit then begin
        LPurchCrMemoLine.RESET;
        LPurchCrMemoLine.SETCURRENTKEY("Job No.","Piecework No.",Type,"No.","Expected Receipt Date");
        LPurchCrMemoLine.SETRANGE("Job No.", rec."Job No.");
        LPurchCrMemoLine.SETRANGE("Piecework No.","Piecework Code");
        LPurchCrMemoLine.SETRANGE(Type,LPurchCrMemoLine.Type::Resource);
        LPurchCrMemoLine.SETRANGE("No.","No. Subcontracting Resource");
        Rec.COPYFILTER("Filter Date",LPurchCrMemoLine."Expected Receipt Date");
        PAGE.RUNMODAL(0,LPurchCrMemoLine);
      end ELSE begin
        LDataPieceworkForProduction.RESET;
        LDataPieceworkForProduction.SETRANGE("Job No.", rec."Job No.");
        LDataPieceworkForProduction.SETFILTER("Piecework Code",Totaling);
        if LDataPieceworkForProduction.FINDSET then
          repeat
            LPurchCrMemoLine.RESET;
            LPurchCrMemoLine.SETCURRENTKEY("Job No.","Piecework No.",Type,"No.","Expected Receipt Date");
            LPurchCrMemoLine.SETRANGE("Job No.",LDataPieceworkForProduction."Job No.");
            LPurchCrMemoLine.SETRANGE("Piecework No.",LDataPieceworkForProduction."Piecework Code");
            LPurchCrMemoLine.SETRANGE(Type,LPurchCrMemoLine.Type::Resource);
            LPurchCrMemoLine.SETRANGE("No.",LDataPieceworkForProduction."No. Subcontracting Resource");
            Rec.COPYFILTER("Filter Date",LPurchCrMemoLine."Expected Receipt Date");
            if LPurchCrMemoLine.FINDSET then begin
              repeat
                LPurchCrMemoLine.MARK(TRUE);
              until LPurchCrMemoLine.NEXT = 0;
            end;

          until LDataPieceworkForProduction.NEXT = 0;
          LPurchCrMemoLine.SETRANGE("Job No.");
          LPurchCrMemoLine.SETRANGE("Piecework No.");
          LPurchCrMemoLine.SETRANGE(Type);
          LPurchCrMemoLine.SETRANGE("No.");
          LPurchCrMemoLine.SETRANGE("Expected Receipt Date");
          LPurchCrMemoLine.MARKEDONLY(TRUE);
          PAGE.RUNMODAL(0,LPurchCrMemoLine);
      end;
      }*/
    end;

    // begin
    /*{
      Q9585 JDC 18/06/20 - Added field "PieceWorkDescription"
    }*///end
}








