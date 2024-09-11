table 7207306 "QBU Standard/Competition"
{
  
  
    CaptionML=ENU='Competitor Score',ESP='Puntuaci¢n del Competidor';
    LookupPageID="Standard/Competition";
    DrillDownPageID="Standard/Competition";
  
  fields
{
    field(1;"Quote Code";Code[20])
    {
        TableRelation="Job"."No.";
                                                   CaptionML=ENU='Quote Code',ESP='Cod. oferta';


    }
    field(2;"Competitor Code";Code[20])
    {
        TableRelation="Contact"."No.";
                                                   CaptionML=ENU='Competition Code',ESP='Cod. competidor';
                                                   Description='JAV 13/08/19: - Se cambia nombre y caption para hacerlos mas adecuados   QB 1.10.12 JAV 24/01/22 Se aumenta de 10 a 20 para evitar error de longitud';


    }
    field(3;"Standard Code";Code[10])
    {
        TableRelation="Award Criterion"."Code";
                                                   CaptionML=ENU='Standard Code',ESP='Cod. criterio';
                                                   Description='JAV 13/08/19: - Se hace no editable';
                                                   Editable=false;


    }
    field(4;"Score";Decimal)
    {
        

                                                   CaptionML=ENU='Score',ESP='Puntuaci¢n';

trigger OnValidate();
    BEGIN 
                                                                CALCFIELDS("Max. Score");
                                                                IF ("Max. Score" > 0) AND (Score > "Max. Score") THEN
                                                                  ERROR(txtQB000);
                                                              END;


    }
    field(10;"Max. Score";Decimal)
    {
        FieldClass=FlowField;
                                                   CalcFormula=Lookup("Standard/Quote"."Maximun Score" WHERE ("Quote Code"=FIELD("Quote Code"),
                                                                                                            "Standard Code"=FIELD("Standard Code")));
                                                   CaptionML=ESP='Puntuaci¢n M xima';
                                                   Description='QB 1.06.14 JAV 18/09/20: - Puntuaci‡on m xima que se puede dar al criterio';
                                                   Editable=false ;


    }
}
  keys
{
    key(key1;"Quote Code","Competitor Code","Standard Code")
    {
        SumIndexFields="Score";
                                                   Clustered=true;
    }
}
  fieldgroups
{
}
  
    var
//       StandardQuote@1100286000 :
      StandardQuote: Record 7207305;
//       txtQB000@1100286001 :
      txtQB000: TextConst ESP='Ha sobrepasdo la puntuaci¢n m xima para el criterio.';

    /*begin
    {
      JAV 23/09/19: - Se cambia el caption de la tabla para que sea mas significativo
    }
    end.
  */
}







