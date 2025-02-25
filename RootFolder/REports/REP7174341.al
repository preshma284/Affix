report 7174341 "DP Calc. Next Prorrata Percent"
{
  
  
    CaptionML=ESP='Proponer porcentaje prorrata';
    ProcessingOnly=true;
  
  dataset
{

DataItem("G/L Entry";"G/L Entry")
{

               DataItemTableView=SORTING("G/L Account No.","VAT Prod. Posting Group");
               

               RequestFilterFields="G/L Account No.","VAT Prod. Posting Group";
trigger OnAfterGetRecord();
    BEGIN 
                                  IF ("Gen. Posting Type" = "G/L Entry"."Gen. Posting Type"::Sale) THEN BEGIN 
                                    IF VATPostingSetup.GET("VAT Bus. Posting Group", "VAT Prod. Posting Group") THEN BEGIN 
                                      CASE VATPostingSetup."VAT Calculation Type" OF
                                        VATPostingSetup."VAT Calculation Type"::"No Taxable VAT"                                                           : ImporteNoSujeto += "G/L Entry".Amount;
                                        VATPostingSetup."VAT Calculation Type"::"Normal VAT", VATPostingSetup."VAT Calculation Type"::"Reverse Charge VAT" : ImporteSujeto   += "G/L Entry".Amount;
                                      END;
                                    END;
                                  END;
                                END;


}
}
  requestpage
  {

    layout
{
}
  }
  labels
{
}
  
    var
//       VATPostingSetup@1100286003 :
      VATPostingSetup: Record 325;
//       ImporteNoSujeto@1100286002 :
      ImporteNoSujeto: Decimal;
//       ImporteSujeto@1100286001 :
      ImporteSujeto: Decimal;
//       PropuestaProrrata@1100286000 :
      PropuestaProrrata: Decimal;
//       TotalFor@1100286006 :
      TotalFor: TextConst ESP='Total para ';

    /*begin
    {
      JAV 21/06/22: - DP 1.00.00 Se a¤ade nuevo report para el manejo de la prorrata. Modificado a partir de MercaBarna DP04a, Q12228, CEI14253, Q13668, CEI14117
    }
    end.
  */
  
}



