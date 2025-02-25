pageextension 50118 MyExtension123 extends 123//254
{
layout
{
addafter("EU Service")
{
    field("DP Original VAT Amount";rec."DP Original VAT Amount")
    {
        
                Visible=seeProrrata or seeNonDeductible ;
}
    field("DP Non Deductible %";rec."DP Non Deductible %")
    {
        
                Visible=seeNonDeductible ;
}
    field("DP Non Deductible Amount";rec."DP Non Deductible Amount")
    {
        
                Visible=seeNonDeductible ;
}
    field("DP Prorrata Type";rec."DP Prorrata Type")
    {
        
                Visible=seeProrrata ;
}
    field("DP Prov. Prorrata %";rec."DP Prov. Prorrata %")
    {
        
                Visible=seeProrrata 

  ;
}
}

}

actions
{


}

//trigger
trigger OnOpenPage()    BEGIN
                 //JAV 21/06/22: - DP 1.00.00 Se a¤aden los campos de la prorrata y su condici¢n de visibles
                 seeProrrata := DPManagement.AccessToProrrata;
                 seeNonDeductible := DPManagement.AccessToNonDeductible;  //JAV 14/07/22: - DP 1.00.04 Se a¤ade el IVA no deducible
               END;


//trigger

var
      "----------------------------------------------- Prorrata" : Integer;
      DPManagement : Codeunit 7174414;
      seeProrrata : Boolean;
      seeNonDeductible : Boolean;

    

//procedure
//procedure Set(var TempVATEntry : Record 254 TEMPORARY );
//    begin
//      if ( TempVATEntry.FINDSET  )then
//        repeat
//          Rec := TempVATEntry;
//          Rec.INSERT;
//        until TempVATEntry.NEXT = 0;
//    end;

//procedure
}

