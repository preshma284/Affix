table 7206990 "QB Job Responsibles Group Tem."
{
  
  
    CaptionML=ESP='Grupos de Plantillas de responsables';
  
  fields
{
    field(1;"Code";Code[10])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Code',ESP='C¢digo';


    }
    field(2;"Description";Text[50])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Description',ESP='Descripci¢n';


    }
    field(3;"Use in";Option)
    {
        OptionMembers="All","Quotes","Operative Jobs","Quotes&Jobs","Budgets","RealEstate";DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Use in',ESP='Usar Para';
                                                   OptionCaptionML=ENU='All,Quotes,Operative Jobs,Quotes & Jobs,,Budgets,Real Estate',ESP='Todos,Estudios,Obras,Estudios y Obras,,Presupuestos,RealEstate';
                                                   
                                                   Description='QB 1.10.09   JAV 19/12/21: [TT] Para que tipo proyectos puede usarse';


    }
    field(10;"Include";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Include',ESP='Incluir';
                                                   Description='QB 1.10.09   JAV 20/12/21: Campo temporal para seleccionar [TT] Maque las plantillas que desea incluir en el proyecto' ;


    }
}
  keys
{
    key(key1;"Code")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  
    var
//       QuoBuildingSetup@1100286001 :
      QuoBuildingSetup: Record 7207278;

    /*begin
    {
      JAV 24/06/22: - QB 1.10.54 Se elimina el manejo por departamentos que no tiene sentido aqu¡
    }
    end.
  */
}







