page 7206964 "QB Tables Captions"
{
  ApplicationArea=All;

CaptionML=ENU='Tables Captions',ESP='Asistente Configuraci�n Descripciones de campos';
    InsertAllowed=false;
    DeleteAllowed=false;
    SourceTable=7206903;
    DelayedInsert=true;
    PageType=Worksheet;
    SourceTableTemporary=true;
    
  layout
{
area(content)
{
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
        
                
                            ;trigger OnValidate()    BEGIN
                             IF (NOT rec.CheckField(ListaTablas, ListaCampos, rec.Table, rec."Field No.")) THEN
                               ERROR(Txt001);
                           END;


    }
    field("Languaje";rec."Languaje")
    {
        
    }
    field("Caption";rec."Caption")
    {
        
    }
    field("New Caption";rec."New Caption")
    {
        
    }

}

}
}
  


trigger OnOpenPage()    BEGIN
                 rec.CargarTemporal(0,Rec);

                 //Crea los registros de los campos que se pueden traducir si no existen
                 //Customer
                 CreateData(     18, 7207284, '');  //Categor�a
                 CreateData(     18, 7207306, '');  //Sub-Categor�a
                 //Vendor
                 CreateData(     23, 7207286, '');  //Categor�a
                 //Jobs
                 CreateData(    167,      20, '');  //QB 1.11.02 C�d.Responsable
                 CreateData(    167, 7207305, '');  //           Importe adjudicado
                 CreateData(    167, 7207312, '');  //QB 1.11.02 Clasificaci�n
                 CreateData(    167, 7207320, '');  //           Gastos generales / Otros
                 CreateData(    167, 7207321, '');  //           Beneficio industrial
                 CreateData(    167, 7207322, '');  //           Coeficiente baja
                 CreateData(    167, 7207338, '');  //QB 1.11.02 Director de obra
                 CreateData(    167, 7207365, '');  //           Importe Contrato
                 CreateData(    167, 7207390, '');  //QB 1.11.02 Tipo de oferta
                 CreateData(    167, 7207391, '');  //QB 1.11.02 Income Statement Responsible
                 CreateData(    167, 7207492, '');  //QB 1.11.02 Fase del proyecto
                 CreateData(    167, 7207494, '');  //QB 1.11.02 Project Management
                 CreateData(    167, 7207505, '');  //           Importe Adjudicado (DL)

                 //Data piecework for production
                 CreateData(7207386,       2, '');
                 CreateData(7207386,       6, '');
                 CreateData(7207386,       7, '');
                 CreateData(7207386,       8, '');
                 CreateData(7207386,      10, '');
                 CreateData(7207386,      17, '');
                 CreateData(7207386,      23, '');
                 CreateData(7207386,      24, '');
                 CreateData(7207386,      40, '');
                 CreateData(7207386,      41, '');
                 CreateData(7207386,      42, '');
                 CreateData(7207386,      43, '');
                 CreateData(7207386,      49, '');
                 CreateData(7207386,      60, '');
                 CreateData(7207386,      64, '');
                 CreateData(7207386,      71, 'PEC');
                 CreateData(7207386,      90, 'PEM');
                 CreateData(7207386,      94, '');
                 CreateData(7207386,     103, 'Importe a PEM');
                 CreateData(7207386,     107, '');
                 CreateData(7207386,     115, 'Importe a PEC');
                 CreateData(7207386,     120, '');
                 CreateData(7207386,     121, '');
                 CreateData(7207386,     126, '');
                 CreateData(7207386,     127, '');
                 CreateData(7207386,     134, '');
                 CreateData(7207386, 7000003, '');

                 //Pedidos de servicio
                 CreateData(7206967,      11, ''); //En Inesco es 'Precio Venta'
                 CreateData(7206967,      17, ''); //En Inesco es 'Precio Contrato'
                 CreateData(7206967,   50002, ''); //En Inesco es 'Precio Ejecuci�n'
                 CreateData(7206967,   50003, ''); //En Inesco es 'Precio Adjudicaci�n'
                 CreateData(7206967,   50004, ''); //En Inesco es 'Imp.Coef.Adjudicaci�n'
                 CreateData(7206969,      11, ''); //En Inesco es 'Precio Venta'
                 CreateData(7206969,      17, ''); //En Inesco es 'Precio Contrato'
                 CreateData(7206969,   50002, ''); //En Inesco es 'Precio Ejecuci�n'
                 CreateData(7206969,   50003, ''); //En Inesco es 'Precio Adjudicaci�n'
                 CreateData(7206969,   50004, ''); //En Inesco es 'Imp.Coef.Adjudicaci�n'

                 Rec.RESET;
                 IF NOT Rec.FINDFIRST THEN;
               END;

trigger OnClosePage()    BEGIN
                  rec.GuardarTemporal(0,Rec);
                END;

trigger OnAfterGetRecord()    BEGIN
                       enPage := (rec."New Caption" <> '');
                     END;



    var
      QBTablesSetup : Record 7206903;
      ListaTablas : ARRAY [100] OF Integer;
      ListaCampos : ARRAY [100] OF Integer;
      i : Integer;
      Txt000 : TextConst ESP='Esta tabla no se puede usar para descripciones de campos';
      Txt001 : TextConst ESP='Este campo no se puede usar para descripciones de campos';
      enPage : Boolean;

    LOCAL procedure CreateData(pTabla : Integer;pCampo : Integer;pDefault : Text);
    begin
      Rec.INIT;
      rec.Table := pTabla;
      Rec.VALIDATE("Field No.", pCampo);
      rec."New Caption" := pDefault;      //JAV 14/09/22: - QB 1.11.02 Se a�ade un valor por defecto
      if not Rec.INSERT then;

      i+=1;
      ListaTablas[i] := pTabla;
      ListaCampos[i] := pCampo;
    end;

    // begin
    /*{
      JAV 14/09/22: - QB 1.11.02 Se a�ade la p�gina relacionada y un valor por defecto
    }*///end
}









