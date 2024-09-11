page 7174392 "QM MasterData Setup Tables"
{
  ApplicationArea=All;

CaptionML=ENU='Master Data Companyes',ESP='Master Data Tablas';
    SourceTable=7174392;
    DelayedInsert=true;
    PageType=Worksheet;
    
  layout
{
area(content)
{
repeater("table")
{
        
    field("Table No.";rec."Table No.")
    {
        
    }
    field("GetTableCaption";rec."GetTableCaption")
    {
        
                Editable=false ;
    }
    field("Sync";rec."Sync")
    {
        
                Editable=edTable ;
    }
    field("HaveDefaultDimension(rec.Table No.)";rec.HaveDefaultDimension(rec."Table No."))
    {
        
                CaptionML=ESP='Tiene dimensiones';
                ToolTipML=ESP='Este campo inidca si la tabla tiene registros de dimensiones predeterminadas en la empresa Master';
                Editable=false ;
    }
    field("Dimensions";rec."Dimensions")
    {
        
                ToolTipML=ESP='Si se desean sincronizar las dimensiones por defecto asociadas a la tabla';
                Editable=edTable ;
    }
    field("Txt001";Txt001)
    {
        
                CaptionML=ESP='Campos';
                Editable=false;
                
                              ;trigger OnAssistEdit()    BEGIN
                               IF (rec."Is Default Dimension Table") THEN
                                 ERROR('No puede modificar la tabla de dimensiones por defecto');

                               QMMasterDataTableField.RESET;
                               QMMasterDataTableField.SETRANGE("Table No.", Rec."Table No.");

                               CLEAR(QMMasterDataSetupFields);
                               QMMasterDataSetupFields.SetType(0);
                               QMMasterDataSetupFields.SETTABLEVIEW(QMMasterDataTableField);
                               QMMasterDataSetupFields.RUNMODAL;

                               rec.InsertDefaultDimension;
                             END;


    }
    field("Modification in Destination";rec."Modification in Destination")
    {
        
    }

}

}
}actions
{
area(Processing)
{


}
}
  trigger OnOpenPage()    BEGIN
                 rec.InsertDefaultDimension;
               END;

trigger OnClosePage()    BEGIN
                  rec.InsertDefaultDimension;
                END;

trigger OnAfterGetRecord()    BEGIN
                       edTable := (NOT Rec."Is Default Dimension Table");
                     END;

trigger OnNewRecord(BelowxRec: Boolean)    BEGIN
                  rec.Sync := TRUE;    //Si creo un nuevo registro, marco por defecto que es obligatorio
                END;



    var
      QMMasterDataTableField : Record 7174393;
      QMMasterDataSetupFields : Page 7174393;
      Txt000 : TextConst ESP='Esta tabla no se puede usar para campos obligatorios';
      Txt001 : TextConst ESP='Campos';
      edTable : Boolean;

    /*begin
    end.
  
*/
}









