table 7207299 "QBU Transfer Price Cost"
{
  
  
  ;
  fields
{
    field(1;"Type";Option)
    {
        OptionMembers="Resource","Group(Resource)","All";CaptionML=ENU='Type',ESP='Tipo';
                                                   OptionCaptionML=ENU='Resource,Group(Resource),All',ESP='Recurso,Fam. recurso,Ambos';
                                                   


    }
    field(2;"Code";Code[20])
    {
        TableRelation=IF ("Type"=CONST("Resource")) "Resource"                                                                 ELSE IF ("Type"=CONST("Group(Resource)")) "Resource Group";
                                                   

                                                   CaptionML=ENU='Code',ESP='Código';

trigger OnValidate();
    BEGIN 
                                                                IF (Code <> '') AND (Type = Type::All) THEN
                                                                  FIELDERROR(Code,STRSUBSTNO(Text000,FIELDCAPTION(Type),FORMAT(Type)));
                                                              END;


    }
    field(3;"Cod. Dept.";Code[20])
    {
        

                                                   CaptionML=ENU='Cod. Dept.',ESP='Cód. departamento';

trigger OnValidate();
    BEGIN 
                                                                IF Type = Type::Resource THEN BEGIN 
                                                                  recResource.GET(Code);
                                                                  CASE FunctionQB.GetPosDimensions(FunctionQB.ReturnDimDpto) OF
                                                                    1 : IF (recResource."Global Dimension 1 Code" = "Cod. Dept.") THEN ERROR(Text001,Code);
                                                                    2 : IF (recResource."Global Dimension 2 Code" = "Cod. Dept.") THEN ERROR(Text001,Code);
                                                                  END;
                                                                END;

                                                                IF Type = Type::"Group(Resource)" THEN BEGIN 
                                                                  recResourceGroup.GET(Code);
                                                                  IF (recResourceGroup."Cod. C.A. Direct Cost" = "Cod. Dept.") THEN ERROR(Text002,Code); //// ESTO NO ES CORRECTO, hay que revisarlo
                                                                END;

                                                                FunctionQB.ValidateDpto("Cod. Dept.");
                                                              END;

trigger OnLookup();
    VAR
//                                                               codeDpt@1000000000 :
                                                              codeDpt: Code[20];
                                                            BEGIN 
                                                              IF FunctionQB.LookUpDpto(codeDpt,FALSE) THEN
                                                                VALIDATE("Cod. Dept.",codeDpt);
                                                            END;


    }
    field(4;"Work Type Code";Code[10])
    {
        TableRelation="Work Type";
                                                   CaptionML=ENU='Work Type Code',ESP='Cód. tipo trabajo';


    }
    field(5;"Unit Cost";Decimal)
    {
        CaptionML=ENU='Unit Cost',ESP='Precio coste'; ;


    }
}
  keys
{
    key(key1;"Type","Code","Cod. Dept.","Work Type Code")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  
    var
//       Text000@7001102 :
      Text000: TextConst ENU='cannot be specified when %1 is %2',ESP='No se puede indicar cuando %1 es %2.';
//       Text001@7001101 :
      Text001: TextConst ENU='Cannot be specified the same departament associated to resource %1',ESP='No se puede indicar el mismo dpto. asociado al recurso %1.';
//       Text002@7001100 :
      Text002: TextConst ENU='Cannot be specified the same departament associated to Group resource %1',ESP='No se puede indicar el mismo dpto. asociado a la familia recurso %1.';
//       FunctionQB@7001105 :
      FunctionQB: Codeunit 7207272;
//       recResource@7001104 :
      recResource: Record 156;
//       recResourceGroup@7001103 :
      recResourceGroup: Record 152;

    /*begin
    end.
  */
}







