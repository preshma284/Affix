page 7207487 "Vendor Quality Data Status FB"
{
CaptionML=ENU='Vendor Quality Data Status FB',ESP='Estad. Datos Calidad Prov.';
    SourceTable=7207418;
    PageType=CardPart;
  layout
{
area(content)
{
group("group101")
{
        
                CaptionML=ESP='Evaluaciones';
    field("No. of Evaluations";rec."No. of Evaluations")
    {
        
    }
    field("Last Evaluation Date";rec."Last Evaluation Date")
    {
        
                CaptionML=ENU='Date of Last Evaluation',ESP='élt. evaluaci¢n';
    }
    field("Evaluations Average Rating";rec."Evaluations Average Rating")
    {
        
                CaptionML=ENU='Average Rating',ESP='Puntuaci¢n media';
    }
    field("Last Evaluation Observations";rec."Last Evaluation Observations")
    {
        
                CaptionML=ENU='Evaluation Observations',ESP='Observaciones';
    }
    field("Average Clasification";rec."Average Clasification")
    {
        
                CaptionML=ESP='Clasificaci¢n';
    }

}
group("group107")
{
        
                CaptionML=ESP='Punt. Manual';
    field("Date Last Reviews";rec."Date Last Reviews")
    {
        
                CaptionML=ENU='Date Last Reviews',ESP='élt. revisi¢n';
    }
    field("Review Score";rec."Review Score")
    {
        
                CaptionML=ENU='Average Review Score',ESP='Puntuaci¢n';
    }
    field("Comments Latest Reviews";rec."Comments Latest Reviews")
    {
        
                CaptionML=ENU='Comments Latest Reviews',ESP='Observaciones';
    }
    field("Clasification Review";rec."Clasification Review")
    {
        
                CaptionML=ESP='Clasificaci¢n';
    }

}
group("group112")
{
        
                CaptionML=ESP='Final';
    field("Punctuation end";rec."Punctuation end")
    {
        
                CaptionML=ESP='Puntuaci¢n';
    }
    field("Clasification end";rec."Clasification end")
    {
        
                CaptionML=ESP='Clasificaci¢n';
    }

}
group("group115")
{
        
                CaptionML=ESP='De todas las actividades';
    field("Total Average Punctuation";rec."Total Average Punctuation")
    {
        
                CaptionML=ESP='Puntuaci¢n';
    }
    field("CodesEvaluation.GetClasification(rec.Total Average Punctuation)";CodesEvaluation.GetClasification(rec."Total Average Punctuation"))
    {
        
                CaptionML=ESP='Clasificaci¢n';
    }

}

}
}
  
    var
      CodesEvaluation : Record 7207422;/*

    begin
    {
      JAV 17/08/19: - Se cambia la forma de realizas las evaluaciones de los proveedores y el c lculo de las puntuaciones de las mismas
    }
    end.*/
  

}







