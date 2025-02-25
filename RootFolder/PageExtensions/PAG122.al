pageextension 50117 MyExtension122 extends 122//17
{
layout
{
addafter("Job No.")
{
    field("QB_PieceworkCode";rec."QB Piecework Code")
    {
        
}
} addafter("Dimension Set ID")
{
    field("DP_OriginalVATAmount";rec."DP Original VAT Amount")
    {
        
                Visible=seeProrrata or seeNonDeductible ;
}
    field("DP_NonDeductiblePorc";rec."DP Non Deductible %")
    {
        
                Visible=seeNonDeductible ;
}
    field("DP_NonDeductibleAmount";rec."DP Non Deductible Amount")
    {
        
                Visible=seeNonDeductible ;
}
    field("DP_Prorrata";rec."DP Prorrata Type")
    {
        
                Visible=seeProrrata ;
}
    field("DP_ProvProrrataPorc";rec."DP Prov. Prorrata %")
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
      GLAcc : Record 15;
      GenJnlPostPreview : Codeunit 19;
      DimensionSetIDFilter : Page 481;
      "----------------------------------------------- Prorrata" : Integer;
      DPManagement : Codeunit 7174414;
      seeProrrata : Boolean;
      seeNonDeductible : Boolean;

    
    

//procedure
//Local procedure GetCaption() : Text[250];
//    begin
//      if ( GLAcc."No." <> rec."G/L Account No."  )then
//        if ( not GLAcc.GET(rec."G/L Account No.")  )then
//          if ( Rec.GETFILTER(rec."G/L Account No.") <> ''  )then
//            if ( GLAcc.GET(Rec.GETRANGEMIN(rec."G/L Account No."))  )then;
//      exit(STRSUBSTNO('%1 %2',GLAcc."No.",GLAcc.Name))
//    end;

//procedure
}

