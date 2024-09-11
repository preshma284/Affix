page 7174352 "DP Input Integer Dialog"
{
CaptionML=ENU='Date-Time Dialog',ESP='Cuadro de di logo Fecha y hora';
    PageType=StandardDialog;
  layout
{
area(content)
{
    field("DP.Application Year";DP."Application Year")
    {
        
                CaptionML=ENU='Year to Execute prorrata',ESP='Ejercicio';
                ApplicationArea=All;
    }
    field("DP.Prorrata Calc. Type";DP."Prorrata Calc. Type")
    {
        
                CaptionML=ESP='Tipo de Prorrata';
    }
    field("DP.Prorrata %";DP."Prorrata %")
    {
        
                CaptionML=ESP='Porcentaje';
                DecimalPlaces=0:0;
                MinValue=0;
                MaxValue=100 

  ;
    }

}
}
  
    var
      DP : Record 7174351 TEMPORARY;
      Year : Integer;
      Type : Option;
      Percentaje : Decimal;
      PageType: Option "New","Calc";

    //[External]
    procedure SetData(pPageType : Option;pYear : Integer);
    begin
      //Establecer los datos inciales para la pantalla
      DP.INIT;
      DP."Application Year" := pYear;
      PageType := pPageType;
    end;

    //[External]
    procedure GetData1(var pYear : Integer;var pType : Option;var pPercentaje : Decimal);
    begin
      //Obtener los datos informados en la pantalla de tipo 1
      pYear := DP."Application Year";
      pType := DP."Prorrata Calc. Type";
      pPercentaje := DP."Prorrata %";
    end;

    //[External]
    procedure GetData2(var pYear : Integer);
    begin
      //Obtener los datos informados en la pantalla de tipo 2
      pYear := DP."Application Year";
    end;

    // begin
    /*{
      JAV 21/06/22: - DP 1.00.00 Nueva p gina para el manejo de las prorratas. Modificado a partir de MercaBarna DP04a, Q12228, CEI14253, Q13668, CEI14117
    }*///end
}








