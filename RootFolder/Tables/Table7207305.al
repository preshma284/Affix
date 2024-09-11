table 7207305 "Standard/Quote"
{
  
  
    CaptionML=ENU='Offer criteria',ESP='Criterios de la oferta';
    LookupPageID="Standard/Quote";
    DrillDownPageID="Standard/Quote";
  
  fields
{
    field(1;"Quote Code";Code[20])
    {
        CaptionML=ESP='Cod. oferta';


    }
    field(2;"Standard Code";Code[10])
    {
        TableRelation="Award Criterion"."Code";
                                                   

                                                   CaptionML=ESP='Cod. criterio';

trigger OnValidate();
    BEGIN 
                                                                AwardCriterion.GET("Standard Code");
                                                                "Standard Description" := AwardCriterion.Description;

                                                                //JAV 13/08/19: - Se crean en los competidores las nuevas opciones
                                                                IF ("Standard Code" <> xRec."Standard Code") THEN BEGIN 
                                                                  SetStandardCompetition("Quote Code", "Standard Code");
                                                                  DeleteStandardCompetition("Quote Code", xRec."Standard Code");
                                                                END;
                                                              END;


    }
    field(3;"Standard Description";Text[80])
    {
        CaptionML=ESP='Descripci¢n';


    }
    field(4;"Maximun Score";Decimal)
    {
        CaptionML=ESP='Puntuaci¢n m xima';


    }
}
  keys
{
    key(key1;"Quote Code","Standard Code")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  
    var
//       AwardCriterion@7001100 :
      AwardCriterion: Record 7207302;
//       Text001@7001101 :
      Text001: TextConst ENU='The score can not be greater than the maximum.',ESP='La puntuaci¢n no puede ser mayor que el m ximo.';

    

trigger OnDelete();    begin
               //JAV 13/08/19: - Se borran en el delete los competidores
               DeleteStandardCompetition("Quote Code", "Standard Code");
             end;



// procedure SetStandardCompetition (Quote@1100286002 : Code[20];Standard@1100286003 :
procedure SetStandardCompetition (Quote: Code[20];Standard: Code[20])
    var
//       StandardCompetition1@1100286004 :
      StandardCompetition1: Record 7207306;
//       StandardCompetition2@1100286000 :
      StandardCompetition2: Record 7207306;
    begin
      StandardCompetition1.RESET;
      StandardCompetition1.SETRANGE("Quote Code", Quote);
      if (StandardCompetition1.FINDSET) then
        repeat
          StandardCompetition2.INIT;
          StandardCompetition2."Quote Code" := Quote;
          StandardCompetition2."Competitor Code" := StandardCompetition1."Competitor Code";
          StandardCompetition2."Standard Code" := Standard;
          if (not StandardCompetition2.INSERT) then ;
        until (StandardCompetition1.NEXT = 0);
    end;

//     procedure DeleteStandardCompetition (Quote@1100286002 : Code[20];Standard@1100286003 :
    procedure DeleteStandardCompetition (Quote: Code[20];Standard: Code[20])
    var
//       StandardCompetition@1100286000 :
      StandardCompetition: Record 7207306;
    begin
      StandardCompetition.RESET;
      StandardCompetition.SETRANGE("Quote Code", Quote);
      StandardCompetition.SETRANGE("Standard Code", Standard);
      StandardCompetition.DELETEALL;
    end;

    /*begin
    //{
//      JAV 13/08/19: - Se crean en los competidores las nuevas opciones
//                    - Se borran en el delete los competidores
//                    - Se elimina de la key el "Standard text"
//      JAV 23/09/19: - Se cambia el caption de la tabla para que sea mas significativo
//    }
    end.
  */
}







