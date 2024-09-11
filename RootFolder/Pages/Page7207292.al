page 7207292 "Piecework Setup"
{
  ApplicationArea=All;

    CaptionML = ENU = 'Piecework Setup', ESP = 'Conf. unidades de obra';
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = 7207279;
    PageType = Card;

    layout
    {
        area(content)
        {
            group("General")
            {

                group("group18")
                {

                    CaptionML = ENU = 'Defaut Values import', ESP = 'N� Serie';
                    field("Series Measure No."; rec."Series Measure No.")
                    {

                    }
                    field("Series Hist. Measure No."; rec."Series Hist. Measure No.")
                    {

                    }
                    field("Series Certification No."; rec."Series Certification No.")
                    {

                    }
                    field("Series Hist. Certification No."; rec."Series Hist. Certification No.")
                    {

                    }
                    field("Series Jobs Reception No."; rec."Series Jobs Reception No.")
                    {

                    }

                }
                group("group24")
                {

                    CaptionML = ENU = 'Defaut Values import', ESP = 'Datos por defecto';
                    field("% Management Application"; rec."% Management Application")
                    {

                        ToolTipML = ESP = 'Se utiliza en el c�lculo de la Obra en curso';
                    }
                    field("% Appl. Tecnique Approval"; rec."% Appl. Tecnique Approval")
                    {

                        ToolTipML = ESP = 'Se utiliza en el c�lculo de la Obra en curso';
                    }

                }
                group("group27")
                {

                    CaptionML = ESP = 'Objetivos';
                    field("Objective % Low"; rec."Objective % Low")
                    {

                    }
                    field("Objective % Medium"; rec."Objective % Medium")
                    {

                    }
                    field("Objective % High"; rec."Objective % High")
                    {

                    }

                }

            }
            group("group31")
            {

                CaptionML = ESP = 'BC3';
                group("group32")
                {

                    CaptionML = ENU = 'Defaut Values import', ESP = 'Grupos Contables';
                    field("G.C. Resource PRESTO"; rec."G.C. Resource PRESTO")
                    {

                    }
                    field("G.C. Item PRESTO"; rec."G.C. Item PRESTO")
                    {

                    }
                    field("G.C. Stock PRESTO"; rec."G.C. Stock PRESTO")
                    {

                    }
                    field("G.R. BAT Product PRESTO"; rec."G.R. BAT Product PRESTO")
                    {

                        CaptionML = ENU = 'du', ESP = 'G.C. IVA producto PRESTO';
                    }
                    field("Cta. Generic Bill of Item No."; rec."Cta. Generic Bill of Item No.")
                    {

                    }

                }
                group("group38")
                {

                    CaptionML = ENU = 'Defaut Values import', ESP = 'Conceptos Anal�ticos';
                    field("CA Resource Sub"; rec."CA Resource Sub")
                    {

                        ToolTipML = ESP = 'Este valor se usar� cuando no est� informado el de materiales, el de mano de obra o el de equipamiento';
                    }
                    field("CA PRESTO Item"; rec."CA PRESTO Item")
                    {

                    }
                    field("CA PRESTO Resource"; rec."CA PRESTO Resource")
                    {

                    }
                    field("CA PRESTO Machinery"; rec."CA PRESTO Machinery")
                    {

                    }
                    field("CA PRESTO Account"; rec."CA PRESTO Account")
                    {

                    }

                }
                group("group44")
                {

                    CaptionML = ENU = 'Defaut Values import', ESP = 'Valores por defecto al importar';
                    field("PRESTO Default Create"; rec."PRESTO Default Create")
                    {

                    }
                    field("Minimum difference for notice"; rec."Minimum difference for notice")
                    {

                    }
                    group("group47")
                    {

                        CaptionML = ENU = 'Defaut Values import', ESP = 'Coste';
                        field("PRESTO Skip Cost"; rec."PRESTO Skip Cost")
                        {

                        }
                        field("Skip Cost Meditions"; rec."Skip Cost Meditions")
                        {

                        }
                        field("Default Porcentual Cost"; rec."Default Porcentual Cost")
                        {

                        }
                        field("Default Cost Without Decom."; rec."Default Cost Without Decom.")
                        {

                        }
                        field("Default Cost Aux W/Dec."; rec."Default Cost Aux W/Dec.")
                        {

                        }

                    }
                    group("group53")
                    {

                        CaptionML = ENU = 'Defaut Values import', ESP = 'Venta';
                        field("PRESTO Skip Sales"; rec."PRESTO Skip Sales")
                        {

                        }
                        field("Skip Sales Meditions"; rec."Skip Sales Meditions")
                        {

                        }
                        field("Default Porcentual Sales"; rec."Default Porcentual Sales")
                        {

                        }
                        field("Default Sales Without Decom."; rec."Default Sales Without Decom.")
                        {

                        }
                        field("Default Sales Aux W/Dec."; rec."Default Sales Aux W/Dec.")
                        {

                        }
                        field("Resource Difference"; rec."Resource Difference")
                        {

                        }
                        field("Resource No Bill Item"; rec."Resource No Bill Item")
                        {

                        }
                        field("Resource Update Budget"; rec."Resource Update Budget")
                        {

                            ToolTipML = ENU = 'Recurso para importar los porcentuales cargados en el presupuesto', ESP = 'Recurso para importar los porcentuales cargados en el presupuesto';
                        }

                    }

                }

            }

        }
    }
    trigger OnOpenPage()
    BEGIN
        Rec.RESET;
        IF NOT Rec.GET THEN BEGIN
            Rec.INIT;
            Rec.INSERT;
        END;
    END;


    /*

        begin
        {
          JAV 01/03/19: - Se a�aden los campos 100 y 101 para valores por defecto al importar BC3
          JAV 28/11/22: - QB 1.12.24 Mejoras en las carga de los BC3. Se a�aden los campos 103 a 106
          AML 24/03/23 A�adido campo rec."Resource Difference"
        }
        end.*/


}








