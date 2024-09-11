table 7206980 "QPR Budget Template Header"
{
  
  
    CaptionML=ENU='Budget Template',ESP='Plantilla de Presupuesto';
    LookupPageID="QPR Budget Template List";
    DrillDownPageID="QPR Budget Template List";
  
  fields
{
    field(1;"Template Code";Code[20])
    {
        CaptionML=ESP='C¢digo';


    }
    field(10;"Description";Text[80])
    {
        CaptionML=ESP='Nombre';


    }
}
  keys
{
    key(key1;"Template Code")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  
    var
//       Job@1100286000 :
      Job: Record 167;

    /*begin
    {
      JAV 08/04/22: - QB 1.10.32 Se mejoran las plantillas de presupuestos, se cambian nombres y captios, se a¤ade activable
    }
    end.
  */
}







