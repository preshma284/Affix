table 7207270 "QB Comment Line"
{
  
  
    CaptionML=ENU='QB Comment Line',ESP='L¡neas comentario QB';
    LookupPageID="Quobuilding Comment List";
    DrillDownPageID="Quobuilding Comment WorkSheet";
  
  fields
{
    field(1;"Document Type";Option)
    {
        OptionMembers="Sheet","Sheet Hist.","Receipt","Receipt Hist.","Measure","Measure Hist.","Regular","Certification","Certi. Hist.","Reestimation","Quotes Comparative","Rest. Hist.","Cost","Cost Hist.","Invoiced","Invoiced Hist.","Process","Jobs Units","JU Jobs Costs","Vendor Evaluation","Records","Elements","ExternalSheet","ExternalSheetHist","ServiceOrder";CaptionML=ENU='Document Type',ESP='Tipo documento';
                                                   OptionCaptionML=ENU='Share,Share Hist.,Receipt,Receipt Hist.,Measure,Measure Hist.,Regular,Certification,Certi. Hist.,Reestimation,Quotes Comparative,Rest. Hist.,Cost,Cost Hist.,Invoiced,Invoiced Hist.,Process,Jobs Units,JU Jobs Costs,Vendor Evaluation,Records,Elements,External Sheet,External Sheet Hist,Service ORder',ESP='Partes,Hist. Partes,Albar.,Hist. Albar,Medici¢n,Hist. Med.,Regular.,Certificaci¢n,Hist. Certif.,Reestimaci¢n,Comparativo oferta,Hist. Reest,,,Costes,Hist. Costes,Fact.,Hist. Fact,Tramite,Unidades de obra,UO Costes proyectos,Evaluaci¢n proveedor,Expedientes,Elementos,Partes de Externos,Hist. Partes de Externos,Orden de Servicio';
                                                   
                                                   Description='We added a new option process';


    }
    field(2;"No.";Code[20])
    {
        CaptionML=ENU='No.',ESP='No.';


    }
    field(3;"Line No.";Integer)
    {
        CaptionML=ENU='Line No.',ESP='No. l¡nea';


    }
    field(4;"Date";Date)
    {
        CaptionML=ENU='Date',ESP='Fecha';


    }
    field(5;"Code";Code[20])
    {
        CaptionML=ENU='Code',ESP='C¢digo';


    }
    field(6;"Comment";Text[80])
    {
        CaptionML=ENU='Comment',ESP='Comentario'; ;


    }
}
  keys
{
    key(key1;"Document Type","No.","Line No.")
    {
        Clustered=true;
    }
}
  fieldgroups
{
}
  

    procedure SetUpNewLine ()
    var
//       QuobuildingCommentLine@7001100 :
      QuobuildingCommentLine: Record 7207270;
    begin
      QuobuildingCommentLine.SETRANGE("No.","No.");
      if not QuobuildingCommentLine.FINDFIRST then
        Date := WORKDATE;
    end;

    /*begin
    end.
  */
}







