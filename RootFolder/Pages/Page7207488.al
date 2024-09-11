page 7207488 "Records Budget Costs FB"
{
CaptionML=ENU='Budget Costs Records Control',ESP='Presup. Costes Exped. Control';
    SourceTable=7207386;
    SourceTableView=SORTING("Job No.","Customer Certification Unit","Piecework Code")
                    ORDER(Ascending)
                    WHERE("Type"=CONST("Piecework"),"Customer Certification Unit"=FILTER(true));
    PageType=CardPart;
    
  layout
{
area(content)
{
    field("txtCurrency";txtCurrency)
    {
        
                CaptionML=ESP='Divisa';
                Visible=useCurrencies;
                Editable=FALSE ;
    }
group("group120")
{
        
                CaptionML=ENU='Detail of Cost Budget',ESP='Presupuesto de costes';
    field("Amounts[1]_";Amounts[1])
    {
        
                CaptionML=ENU='Direct Cost',ESP='Costes Directos';
                Editable=FALSE ;
    }
    field("Amounts[2]_";Amounts[2])
    {
        
                CaptionML=ENU='Indirect Cost',ESP='Costes Indirectos';
                Editable=FALSE ;
    }
    field("Amounts[10]_";Amounts[10])
    {
        
                ExtendedDatatype=Ratio;
                CaptionML=ENU='Totals',ESP='Indirectos S/Total';
    }
    field("Amounts[11]_";Amounts[11])
    {
        
                ExtendedDatatype=Ratio;
                CaptionML=ENU='Totals (LCY)',ESP='Totales (DL)';
    }
    field("Amounts[12]_";Amounts[12])
    {
        
                CaptionML=ENU='K',ESP='K real';
                Editable=False ;
    }
    field("Amounts[13]_";Amounts[13])
    {
        
                CaptionML=ENU='Planned K',ESP='K prevista';
    }

}
group("group127")
{
        
                CaptionML=ENU='Margin Unfold',ESP='Desglose del Margen';
    field("Amounts[14]_";Amounts[14])
    {
        
                ExtendedDatatype=Ratio;
                CaptionML=ENU='Sale',ESP='% margen previsto';
    }
    field("Amounts[15]_";Amounts[15])
    {
        
                ExtendedDatatype=Ratio;
                CaptionML=ENU='Sale (LCY)',ESP='Venta (DL)';
    }
    field("Amounts[16]_";Amounts[16])
    {
        
                ExtendedDatatype=Ratio;
                CaptionML=ENU='Direct Cost',ESP='Margen S/Directos';
    }
    field("Amounts[17]_";Amounts[17])
    {
        
                ExtendedDatatype=Ratio;
                CaptionML=ENU='Direct Cost (LCY)',ESP='Costes directos (DL)';
    }

}

}
}
  
trigger OnOpenPage()    BEGIN
                 //JAV 08/04/20: - Si se usan las divisas en los proyectos
                 JobCurrencyExchangeFunction.SetPageCurrencies(useCurrencies, 0);
               END;

trigger OnAfterGetRecord()    BEGIN
                       CalculateAmouts;
                     END;



    var
      FunctionQB : Codeunit 7207272;
      useCurrencies : Boolean;
      SeeCurrency : Integer;
      txtCurrency : Text;
      Amounts : ARRAY [20] OF Decimal;
      JobCurrencyExchangeFunction : Codeunit 7207332;

    procedure SetCurrency(pCurrency : Integer);
    begin
      SeeCurrency := pCurrency;
    end;

    LOCAL procedure CalculateAmouts();
    var
      Job : Record 167;
      k : Decimal;
      "----------------------------------" : Integer;
      JobCurrencyExchangeFunction : Codeunit 7207332;
      FromCurrency : Code[20];
      ToCurrency : Code[20];
      i : Integer;
      Amount : Decimal;
      Factor : Decimal;
    begin
      CLEAR(Amounts);
      if (not Job.GET(rec."Job No.")) then
        exit;

      Rec.SETRANGE("Budget Filter",Job."Current Piecework Budget");
      Job.SETRANGE("Budget Filter",Job."Current Piecework Budget");
      Job.CALCFIELDS("Direct Cost Amount PieceWork", "Indirect Cost Amount Piecework");
      if (Job."Direct Cost Amount PieceWork" + Job."Indirect Cost Amount Piecework" <> 0) then
        k := Job.CalcContractAmount_DL / (Job."Direct Cost Amount PieceWork" + Job."Indirect Cost Amount Piecework")
      ELSE
        k:= 0;

      Amounts[10] := Job.CalcPercentageCostIndirect_DL;
      Amounts[11] := Amounts[10] * 100;
      Amounts[12] := k;
      Amounts[13] := Job."Planned K";
      Amounts[14] := Job.CalcMarginPricePercentage_DL;
      Amounts[15] := Amounts[14] * 100;
      Amounts[16] := Job.CalcMarginDirect_DL;
      Amounts[17] := Amounts[16] * 100;

      //Divisas
      CASE SeeCurrency OF
        0 : begin
              txtCurrency  := 'Local (DL)';
              FromCurrency := Job."Currency Code";
              ToCurrency   := '';
              Amounts[1] := Job."Direct Cost Amount PieceWork";
              Amounts[2] := Job."Indirect Cost Amount Piecework";
            end;
        1 : begin
              txtCurrency  := Job."Currency Code" + ' (DP)';
              FromCurrency := '';
              ToCurrency   := '';
              Job.CALCFIELDS("Direct Cost Amount PW (JC)", "Indirect Cost Amount PW (JC)");
              Amounts[1] := Job."Direct Cost Amount PW (JC)";
              Amounts[2] := Job."Indirect Cost Amount PW (JC)";      end;
        2 : begin
              txtCurrency  := Job."Aditional Currency" + ' (DR)';
              FromCurrency := '';
              ToCurrency   := Job."Aditional Currency";
              Amounts[1] := Job."Direct Cost Amount PieceWork";
              Amounts[2] := Job."Indirect Cost Amount Piecework";
              FOR i:=1 TO 2 DO begin
                JobCurrencyExchangeFunction.CalculateCurrencyValue(Job."No.", Amounts[i] ,FromCurrency, ToCurrency, Job."Currency Value Date", 0, Amount, Factor);
                Amounts[i] := Amount;
              end;
            end;
      end;
    end;

    // begin
    /*{
      JAV 05/10/19: - Se eliminan campos redundantes, pero hay que mejorar esta p gina para que de informaci¢n mas £til
    }*///end
}







