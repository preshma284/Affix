pageextension 50261 MyExtension7000012 extends 7000012//7000006
{
layout
{
addafter("Remaining Amount (LCY)")
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
      PostedBillGr : Record 7000006;
      Navigate : Page 344;

    

//procedure

//procedure
}

