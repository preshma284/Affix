report 7207307 "Job Worksheet Hist."
{


    ;
    dataset
    {

        DataItem("Worksheet Header Hist."; "Worksheet Header Hist.")
        {

            ;
            Column(DescParteCompuesto; STRSUBSTNO('PROYECTO: %1-%2', "No. Resource /Job", Description))
            {
                //SourceExpr=STRSUBSTNO('PROYECTO: %1-%2',"No. Resource /Job",Description);
            }
            Column(Nrecursoproyecto_Histcabpartesdetrabajo; "Worksheet Header Hist."."No. Resource /Job")
            {
                //SourceExpr="Worksheet Header Hist."."No. Resource /Job";
            }
            Column(Descripcion_Histcabpartesdetrabajo; "Worksheet Header Hist.".Description)
            {
                //SourceExpr="Worksheet Header Hist.".Description;
            }
            Column(Fecharegistro_Histcabpartesdetrabajo; "Worksheet Header Hist."."Posting Date")
            {
                //SourceExpr="Worksheet Header Hist."."Posting Date";
            }
            Column(descripcion; Description)
            {
                //SourceExpr=Description;
            }
            Column(NParte; "Worksheet Header Hist."."No.")
            {
                //SourceExpr="Worksheet Header Hist."."No.";
            }
            Column(COMPANYNAME; COMPANYNAME)
            {
                //SourceExpr=COMPANYNAME;
            }
            DataItem("Worksheet Lines Hist."; "Worksheet Lines Hist.")
            {

                DataItemLink = "Document No." = FIELD("No.");
                Column(HtcoLinPartesDocNo; "Worksheet Lines Hist."."Document No.")
                {
                    //SourceExpr="Worksheet Lines Hist."."Document No.";
                }
                Column(Descripcion_Histlinpartesdetrabajo; "Worksheet Lines Hist.".Description)
                {
                    IncludeCaption = true;
                    //SourceExpr="Worksheet Lines Hist.".Description;
                }
                Column(Nrecurso_Histlinpartesdetrabajo; "Worksheet Lines Hist."."Resource No.")
                {
                    IncludeCaption = true;
                    //SourceExpr="Worksheet Lines Hist."."Resource No.";
                }
                Column(Fechadiadetrabajo_Histlinpartesdetrabajo; "Worksheet Lines Hist."."Work Day Date")
                {
                    IncludeCaption = true;
                    //SourceExpr="Worksheet Lines Hist."."Work Day Date";
                }
                Column(Codtipodetrabajo_Histlinpartesdetrabajo; "Worksheet Lines Hist."."Work Type Code")
                {
                    IncludeCaption = true;
                    //SourceExpr="Worksheet Lines Hist."."Work Type Code";
                }
                Column(Cantidad_Histlinpartesdetrabajo; "Worksheet Lines Hist.".Quantity)
                {
                    IncludeCaption = true;
                    //SourceExpr="Worksheet Lines Hist.".Quantity;
                }
                Column(Preciocoste_Histlinpartesdetrabajo; "Worksheet Lines Hist."."Unit Cost")
                {
                    IncludeCaption = true;
                    //SourceExpr="Worksheet Lines Hist."."Unit Cost";
                }
                Column(Costetotal_Histlinpartesdetrabajo; "Worksheet Lines Hist."."Total Cost")
                {
                    IncludeCaption = true;
                    //SourceExpr="Worksheet Lines Hist."."Total Cost";
                }
                Column(recResourceName; recResource.Name)
                {
                    IncludeCaption = true;
                    //SourceExpr=recResource.Name;
                }
                Column(NParteLin; "Worksheet Lines Hist."."Document No.")
                {
                    IncludeCaption = true;
                    //SourceExpr="Worksheet Lines Hist."."Document No." ;
                }
                trigger OnAfterGetRecord();
                BEGIN

                    IF NOT recResource.GET("Worksheet Lines Hist."."Resource No.") THEN
                        recResource.INIT;
                END;


            }
            trigger OnAfterGetRecord();
            BEGIN

                IF NOT recResource.GET("No. Resource /Job") THEN BEGIN
                    recResource.INIT;
                END ELSE BEGIN
                    IF NOT RecJobDesv.GET(recResource."Jobs Deviation") THEN
                        RecJobDesv.INIT;
                    Description := RecJobDesv.Description;
                END;

                IF NOT recJob.GET("No. Resource /Job") THEN BEGIN
                    recJob.INIT;
                END ELSE BEGIN
                    Description := recJob.Description;
                END;
            END;


        }
    }
    requestpage
    {

        layout
        {
        }
    }
    labels
    {
    }

    var
        //       recResource@7001105 :
        recResource: Record 156;
        //       RecJobDesv@7001104 :
        RecJobDesv: Record 167;
        //       recJob@7001103 :
        recJob: Record 167;
        //       description@7001102 :
        description: Text[250];
        //       COMPANYNAME@7001101 :
        COMPANYNAME: Text[250];
        //       total@7001100 :
        total: Text[50];

    /*begin
    end.
  */

}



