page 7207481 "QB Tables Automatic Dimensions"
{
  ApplicationArea=All;

    CaptionML = ENU = 'Tables Automatic Dimensions', ESP = 'Asistente Configuraci�n Dimensiones Tablas';
    SourceTable = 7206903;
    DelayedInsert = true;
    PageType = Worksheet;
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            field("AuxText"; "AuxText")
            {

                CaptionML = ESP = 'Tablas permitidas';
                Editable = false;
                RowSpan = 2;
            }
            repeater("table1")
            {

                field("Table"; rec."Table")
                {


                    ; trigger OnValidate()
                    BEGIN
                        IF (NOT rec.CheckTable(ListaTablas, rec.Table)) THEN
                            ERROR(Text000);
                    END;


                }
                field("Table Name"; rec."Table Name")
                {

                }
                field("Field No."; rec."Field No.")
                {


                    ; trigger OnValidate()
                    BEGIN
                        IF (rec.Table = DATABASE::Job) AND (rec."Field No." = 1) THEN
                            ERROR(Text001);
                    END;


                }
                field("Caption"; rec."Caption")
                {

                }
                field("New Caption"; rec."New Caption")
                {

                    Editable = FALSE;
                }
                field("MDimension Code"; rec."MDimension Code")
                {

                    ToolTipML = ESP = 'Para el manejo de la Dimensi�n autom�tica, el c�digo de la dimensi�n';
                }
                field("MDimension Prefix"; rec."MDimension Prefix")
                {

                    ToolTipML = ESP = 'Este prefijo se a�ade al valor del campo al crear el nuevo valor de dimensi�n asociado al registro';
                }
                field("MDimension Table"; rec."MDimension Table")
                {

                    ToolTipML = ESP = 'Para el manejo de la Dimensi�n autom�tica, la tabla relacionada';
                }
                field("MDimension Field"; rec."MDimension Field")
                {

                    ToolTipML = ESP = 'Para el manejo de la Dimensi�n autom�tica,  que campo se usa para oa descripci�n del valor de dimensi�n entre los existentes en la tabla relacionada';
                }

            }

        }
    }
    trigger OnOpenPage()
    BEGIN
        rec.CargarTemporal(2, Rec);

        Rec.RESET;
        IF NOT Rec.FINDFIRST THEN;

        ListaTablas[1] := DATABASE::Customer;
        ListaTablas[2] := DATABASE::Vendor;
        ListaTablas[3] := DATABASE::Job;
        ListaTablas[4] := DATABASE::Item;
        ListaTablas[5] := DATABASE::Resource;

        AuxText := rec.TableListToText(ListaTablas);
    END;

    trigger OnClosePage()
    BEGIN
        rec.GuardarTemporal(2, Rec);
    END;



    var
        QBTablesSetup: Record 7206903;
        ListaTablas: ARRAY[50] OF Integer;
        Text000: TextConst ESP = 'Esta tabla no se puede usar para dimensiones autom�ticas';
        Text001: TextConst ESP = 'No puede usar este campo en la tabla de proyectos, ya se usa autom�ticamente';
        AuxText: Text;/*

    begin
    {
      JAV 25/04/22: - QB 1.10.36 Se ajustan las tablas que se pueden utilizar
    }
    end.*/


}








