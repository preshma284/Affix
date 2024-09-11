page 7207284 "Cost Database List"
{
  ApplicationArea=All;

    Editable = false;
    CaptionML = ENU = 'Cost Database List', ESP = 'Lista de preciarios';
    InsertAllowed = false;
    SourceTable = 7207271;
    SourceTableView = SORTING("Code")
                    WHERE("Archived" = CONST(false));
    PageType = List;
    CardPageID = "Cost Database Card";
    layout
    {
        area(content)
        {
            repeater("Group")
            {

                field("Code"; rec."Code")
                {

                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Description"; rec."Description")
                {

                    Style = Standard;
                    StyleExpr = TRUE;
                }
                field("Job Classification"; rec."Job Classification")
                {

                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("Date Hight"; rec."Date Hight")
                {

                }
                field("Currency"; rec."Currency")
                {

                }
                field("Type JU"; rec."Type JU")
                {

                }
                field("Type Unit"; rec."Type Unit")
                {

                }
                field("Used for Direct cost"; rec."Used for Direct cost")
                {

                }
                field("Used for Indirect cost"; rec."Used for Indirect cost")
                {

                }

            }

        }
        area(FactBoxes)
        {
            part("part1"; 7207319)
            {
                SubPageLink = "Cost Database Default" = FIELD("Code");
            }
            systempart(Links; Links)
            {
                ;
            }
            systempart(Notes; Notes)
            {
                ;
            }

        }
    }
    actions
    {
        area(Navigation)
        {

            group("group2")
            {
                CaptionML = ENU = 'Cost Database', ESP = 'Preciario';
                action("<Page Cost Database List>")
                {

                    ShortCutKey = 'Shift+F5';
                    CaptionML = ENU = 'Card', ESP = 'Ficha';
                    RunObject = Page 7207284;
                    RunPageLink = "Code" = FIELD("Code");
                    Image = EditLines;
                }

            }
            group("group4")
            {
                CaptionML = ENU = 'Cost Database', ESP = 'Uso';
                action("action2")
                {
                    CaptionML = ESP = 'En Estudios para directos';
                    RunObject = Page 7207362;
                    RunPageLink = "Import Cost Database Direct" = FIELD("Code");
                    Image = Job;
                }
                action("action3")
                {
                    CaptionML = ESP = 'En Estudios para indirectos';
                    RunObject = Page 7207362;
                    RunPageLink = "Import Cost Database Indirect" = FIELD("Code");
                    Image = Job;
                }
                action("action4")
                {
                    CaptionML = ESP = 'En Proyectos para directos';
                    RunObject = Page 7207477;
                    RunPageLink = "Import Cost Database Direct" = FIELD("Code");
                    Image = JobJournal;
                }
                action("action5")
                {
                    CaptionML = ESP = 'En Proyectos para indirectos';
                    RunObject = Page 7207477;
                    RunPageLink = "Import Cost Database Indirect" = FIELD("Code");
                    Image = JobJournal;
                }

            }

        }
        area(Promoted)
        {
            group(Category_New)
            {
                CaptionML = ENU = 'New', ESP = 'Nuevo';
            }
            group(Category_Process)
            {
                CaptionML = ENU = 'Process', ESP = 'Proceso';
            }
            group(Category_Report)
            {
                CaptionML = ENU = 'Reports', ESP = 'informes';
            }
            group(Category_Category4)
            {
                CaptionML = ENU = '4', ESP = '4';
            }
            group(Category_Category5)
            {
                CaptionML = ENU = 'Used', ESP = 'Uso';

                actionref(action2_Promoted; action2)
                {
                }
                actionref(action3_Promoted; action3)
                {
                }
                actionref(action4_Promoted; action4)
                {
                }
                actionref(action5_Promoted; action5)
                {
                }
            }
        }
    }
    /*

      begin
      {
        JAV 18/03/19: - Se a�aden botones para ver los proyectos y estudios donde se ha usado y se cambia el PromotedActionCategoriesML
                      - Se a�ade el campo "Used"
        JAV 09/09/19: - Se cambia el caption del formulario
        JAV 02/10/19: - Se elimina el campo Use y se a�aden los de Directos e indirectos, adem�s de las acciones necesarias para ver los estudios y proyectos donde se han usado ambas
        JAV 14/12/22: - QB 1.12.24 Se a�ade el FactBox de totales
      }
      end.*/


}








