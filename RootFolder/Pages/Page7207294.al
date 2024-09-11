page 7207294 "OLD_QB Tables Sincronization"
{
    CaptionML = ENU = 'QB Tables Setup', ESP = 'Conf. Tablas para QB';
    SaveValues = true;
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = 7206903;
    PageType = Worksheet;

    layout
    {
        area(content)
        {
            repeater("table1")
            {

                field("Table"; rec."Table")
                {

                    Editable = FALSE;
                }
                field("Field No."; rec."Field No.")
                {

                    Editable = FALSE;
                }
                field("Caption"; rec."Caption")
                {

                }
                field("OLD_Not editable in destinatio"; rec."OLD_Not editable in destinatio")
                {

                }

            }

        }
    }
    actions
    {
        area(Processing)
        {

            action("action1")
            {
                CaptionML = ESP = 'Todos a SI';
                Image = Approve;

                trigger OnAction()
                BEGIN
                    QBTablesSetup.INIT;
                    QBTablesSetup.SETRANGE(Table, Tabla);
                    QBTablesSetup.MODIFYALL("OLD_Not editable in destinatio", TRUE);
                END;


            }
            action("action2")
            {
                CaptionML = ESP = 'Todos a NO';
                Image = Cancel;


                trigger OnAction()
                BEGIN
                    QBTablesSetup.INIT;
                    QBTablesSetup.SETRANGE(Table, Tabla);
                    QBTablesSetup.MODIFYALL("OLD_Not editable in destinatio", FALSE);
                END;


            }

        }
        area(Promoted)
        {
            group(Category_Process)
            {
                actionref(action1_Promoted; action1)
                {
                }
                actionref(action2_Promoted; action2)
                {
                }
            }
        }
    }

    trigger OnOpenPage()
    BEGIN
        Txt := Rec.GETFILTER(Table);
        EVALUATE(Tabla, Txt);
        CreateNews;
        //JAV 30/11/21: - QB 1.10.03 Quitar campos que no se pueden sincronizar
        DeleteFields;
    END;

    trigger OnClosePage()
    BEGIN
        //JAV 30/11/21: - QB 1.10.03 Quitar campos que no se pueden sincronizar
        DeleteFields;

        //Eliminar los registros vacios
        rec.DeleteEmpty;
    END;



    var
        tbFields: Record 2000000041;
        QBTablesSetup: Record 7206903;
        Tabla: Integer;
        Txt: Text;

    LOCAL procedure CreateNews();
    begin
        tbFields.RESET;
        tbFields.SETRANGE(TableNo, Tabla);
        tbFields.SETRANGE(Class, tbFields.Class::Normal);
        if (tbFields.FINDSET(FALSE)) then
            repeat
                //JAV 30/11/21: - QB 1.10.03 Saltarse campos que no se pueden sincronizar
                if not (tbFields.Type IN [tbFields.Type::BLOB, tbFields.Type::GUID, tbFields.Type::Media, tbFields.Type::MediaSet, tbFields.Type::TableFilter]) then begin
                    QBTablesSetup.INIT;
                    QBTablesSetup.Table := Tabla;
                    QBTablesSetup."Field No." := tbFields."No.";
                    if not QBTablesSetup.INSERT then;
                end;
            until (tbFields.NEXT = 0);
    end;

    LOCAL procedure DeleteFields();
    begin
        //JAV 30/11/21: - QB 1.10.03 Quitar campos que no se pueden sincronizar, por si se han colado
        QBTablesSetup.RESET;
        QBTablesSetup.SETRANGE(Table, Tabla);
        if (QBTablesSetup.FINDSET(TRUE)) then
            repeat
                //Si ya no existe el campo elimino el registro (por seguridad)
                if not tbFields.GET(QBTablesSetup.Table, QBTablesSetup."Field No.") then
                    QBTablesSetup.DELETE;

                //Estos campos no los tratamos
                if (tbFields.Type IN [tbFields.Type::BLOB, tbFields.Type::GUID, tbFields.Type::Media, tbFields.Type::MediaSet, tbFields.Type::TableFilter]) then
                    QBTablesSetup.DELETE;

                //Por si acaso solo campos no calculados
                if (tbFields.Class <> tbFields.Class::Normal) then
                    QBTablesSetup.DELETE;

            until (QBTablesSetup.NEXT = 0);
    end;

    // begin
    /*{
      JAV 30/11/21: - QB 1.10.03 Quitar campos que no se pueden sincronizar, por si se han colado
    }*///end
}







