pageextension 50264 MyExtension7000015 extends 7000015//7000007
{
layout
{
addafter("Amount Grouped (LCY)")
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
      ClosedBillGr : Record 7000007;
      Navigate : Page 344;

    

//procedure

//procedure
}

