pageextension 50259 MyExtension7000009 extends 7000009//7000005
{
layout
{
addafter("Amount (LCY)")
{
    field("QB Bill Group Confirming";rec."QB Bill Group Confirming")
    {
        
                ToolTipML=ESP='Indica si esta remesa es de Confirmnig';
}
}

}

actions
{


}

//trigger

//trigger

var
      BankAcc : Record 270;
      BillGr : Record 7000005;
      BankSel : Page 7000018;
      PostBGPO : Codeunit 7000003;

    

//procedure

//procedure
}

