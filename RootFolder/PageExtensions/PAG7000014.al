pageextension 50263 MyExtension7000014 extends 7000014//7000006
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

    

//procedure

//procedure
}

