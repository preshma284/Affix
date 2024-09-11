page 7207375 "Post. Measur. Bill of Item"
{
Editable=false;
    CaptionML=ESP='Hist. Descompuesto medici¢n';
    SourceTable=7207396;
    PageType=List;
    
  layout
{
area(content)
{
repeater("Group")
{
        
    field("Description";rec."Description")
    {
        
                Style=Strong;
                StyleExpr=TRUE ;
    }
    field("Budget Units";rec."Budget Units")
    {
        
                Style=Strong;
                StyleExpr=TRUE ;
    }
    field("Budget Length";rec."Budget Length")
    {
        
                Style=Strong;
                StyleExpr=TRUE ;
    }
    field("Budget Width";rec."Budget Width")
    {
        
                Style=Strong;
                StyleExpr=TRUE ;
    }
    field("Budget Height";rec."Budget Height")
    {
        
                Style=Strong;
                StyleExpr=TRUE ;
    }
    field("Budget Total";rec."Budget Total")
    {
        
                Style=Strong;
                StyleExpr=TRUE ;
    }
    field("Realized Units";rec."Realized Units")
    {
        
                Style=StrongAccent;
                StyleExpr=TRUE ;
    }
    field("Period Units";rec."Period Units")
    {
        
    }
    field("Measured Units";rec."Measured Units")
    {
        
    }
    field("Measured % Progress";rec."Measured % Progress")
    {
        
    }
    field("Realized Total";rec."Realized Total")
    {
        
                Style=StrongAccent;
                StyleExpr=TRUE ;
    }
    field("Period Total";rec."Period Total")
    {
        
                Style=Strong;
                StyleExpr=TRUE ;
    }
    field("Measured Total";rec."Measured Total")
    {
        
                Style=Strong;
                StyleExpr=TRUE ;
    }

}
group("group41")
{
        
group("group42")
{
        
                CaptionML=ENU='Previous Measured Quantity',ESP='Totales';
    field("TotalMeadureBudget";TotalMeadureBudget)
    {
        
                CaptionML=ENU='Previous Measured Quantity',ESP='Cantidad Total Presupuestada';
                Editable=FALSE;
                Style=Strong;
                StyleExpr=TRUE ;
    }
    field("TotalMeasureAnt";TotalMeasureAnt)
    {
        
                CaptionML=ENU='Previous Measured Quantity',ESP='Cantidad medida anterior';
                Editable=FALSE;
                Style=Strong;
                StyleExpr=TRUE ;
    }
    field("TotalMeasureOrigin";TotalMeasureOrigin)
    {
        
                CaptionML=ENU='Total Origin Quantity',ESP='Cantidad total origen';
                Editable=FALSE;
                Style=Strong;
                StyleExpr=TRUE ;
    }
    field("TotalMeasurePeriod";TotalMeasurePeriod)
    {
        
                CaptionML=ENU='Total Quantity Term',ESP='Cantidad total per¡odo';
                Editable=FALSE;
                Style=Strong;
                StyleExpr=TRUE 

  ;
    }

}

}

}
}
  trigger OnAfterGetRecord()    BEGIN
                       UpdateData;
                     END;



    var
      TotalMeadureBudget : Decimal;
      TotalMeasureOrigin : Decimal;
      TotalMeasurePeriod : Decimal;
      TotalMeasureAnt : Decimal;
      MeasurementLines : Record 7207337;
      ProdMeasureLines : Record 7207400;
      MeasureLinesBillofItem : Record 7207396;

    procedure UpdateData();
    begin
      TotalMeadureBudget := 0;
      TotalMeasureOrigin := 0;
      TotalMeasurePeriod := 0;

      MeasureLinesBillofItem.RESET;
      MeasureLinesBillofItem.SETRANGE("Document Type", rec."Document Type");
      MeasureLinesBillofItem.SETRANGE("Document No.", rec."Document No.");
      MeasureLinesBillofItem.SETRANGE("Line No.", rec."Line No.");
      if MeasureLinesBillofItem.FINDSET(FALSE) then
        repeat
          TotalMeadureBudget += MeasureLinesBillofItem."Budget Total";
          TotalMeasureOrigin += MeasureLinesBillofItem."Measured Total";
          TotalMeasurePeriod += MeasureLinesBillofItem."Period Total";
        until MeasureLinesBillofItem.NEXT = 0;

      TotalMeasureAnt := TotalMeasureOrigin - TotalMeasurePeriod;
    end;

    // begin
    /*{
      Q19284 CSM 17/05/23 Í Cancelar detalle de medici¢n en RV.  Nueva ordenaci¢n de las columnas.
    }*///end
}







