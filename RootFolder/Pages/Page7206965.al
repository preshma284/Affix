page 7206965 "QB Tables Mandatory Fields"
{
  ApplicationArea=All;

CaptionML=ENU='Tables Mandatory Fields',ESP='Asistente Configuraci�n Campos Obligatorios';
    SourceTable=7206903;
    DelayedInsert=true;
    PageType=Worksheet;
    SourceTableTemporary=true;
    
  layout
{
area(content)
{
    field("AuxText";"AuxText")
    {
        
                CaptionML=ESP='Tablas permitidas';
                Editable=false ;
    }
repeater("table1")
{
        
    field("Table";rec."Table")
    {
        
                
                            ;trigger OnValidate()    BEGIN
                             IF (NOT rec.CheckTable(ListaTablas, rec.Table)) THEN
                               ERROR(Txt000);
                           END;


    }
    field("Table Name";rec."Table Name")
    {
        
    }
    field("Field No.";rec."Field No.")
    {
        
    }
    field("Caption";rec."Caption")
    {
        
    }
    field("New Caption";rec."New Caption")
    {
        
                Editable=FALSE ;
    }
    field("Mandatory Field";rec."Mandatory Field")
    {
        
    }

}

}
}
  trigger OnOpenPage()    BEGIN
                 rec.CargarTemporal(1,Rec);
                 Rec.RESET;
                 IF NOT Rec.FINDFIRST THEN;

                 ListaTablas[1] := DATABASE::Customer;
                 ListaTablas[2] := DATABASE::Vendor;
                 ListaTablas[3] := DATABASE::Job;
                 ListaTablas[4] := DATABASE::Item;
                 ListaTablas[5] := DATABASE::Resource;

                 AuxText := rec.TableListToText(ListaTablas);
               END;

trigger OnClosePage()    BEGIN
                  rec.GuardarTemporal(1,Rec);
                END;

trigger OnNewRecord(BelowxRec: Boolean)    BEGIN
                  rec."Mandatory Field" := TRUE;    //Si creo un nuevo registro, marco por defecto que es obligatorio
                END;



    var
      QBTablesSetup : Record 7206903;
      ListaTablas : ARRAY [50] OF Integer;
      Txt000 : TextConst ESP='Esta tabla no se puede usar para campos obligatorios';
      i : Integer;
      AuxText : Text;
      Object : Record 2000000001;
      rRef : RecordRef;

    /*begin
    end.
  
*/
}









