page 7174671 "Countries/Regions Example Drag"
{
CaptionML=ENU='Countries/Regions',ESP='Pa�ses y regiones';
    SourceTable=9;
    PageType=List;
    
  layout
{
area(content)
{
repeater("table")
{
        
    field("Code";rec."Code")
    {
        
                ToolTipML=ENU='Specifies the country/region of the address.',ESP='Especifica el pa�s o la regi�n de la direcci�n.';
                ApplicationArea=Basic,Suite;
    }
    field("Name";rec."Name")
    {
        
                ToolTipML=ENU='Specifies the country/region of the address.',ESP='Especifica el pa�s o la regi�n de la direcci�n.';
                ApplicationArea=Basic,Suite;
    }
    field("Address Format";rec."Address Format")
    {
        
                ToolTipML=ENU='Specifies the format of the address, which is used on printouts.',ESP='Especifica el formato de direcci�n, que se utilizar� en las impresiones.';
                ApplicationArea=Basic,Suite;
    }
    field("Contact Address Format";rec."Contact Address Format")
    {
        
                ToolTipML=ENU='Specifies where you want the contact name to appear in mailing addresses.',ESP='Especifica d�nde quiere que aparezca el nombre de contacto en las direcciones de env�o.';
                ApplicationArea=Basic,Suite;
    }
    field("EU Country/Region Code";rec."EU Country/Region Code")
    {
        
                ToolTipML=ENU='Specifies the EU code for the country/region you are doing business with.',ESP='Especifica el c�digo de la UE para el pa�s o la regi�n con los que mantiene relaciones comerciales.';
                Visible=FALSE ;
    }
    field("Intrastat Code";rec."Intrastat Code")
    {
        
                ToolTipML=ENU='Specifies an INTRASTAT code for the country/region you are trading with.',ESP='Especifica el c�digo de Intrastat correspondiente al pa�s o la regi�n con los que mantiene relaciones comerciales.';
                Visible=FALSE ;
    }
    field("VAT Registration No. digits";rec."VAT Registration No. digits")
    {
        
                ToolTipML=ENU='Specifies the number of digits in the VAT registration numbers for the country/region.',ESP='Especifica el n�mero de d�gitos del CIF/NIF del pa�s o la regi�n.';
                Visible=FALSE ;
    }
    field("VAT Scheme";rec."VAT Scheme")
    {
        
                ToolTipML=ENU='Specifies the national body that issues the VAT registration number for the country/region in connection with electronic document sending.',ESP='Especifica el organismo nacional que emite el CIF/NIF en el pa�s o la regi�n en relaci�n con el env�o de documentos electr�nicos.';
                ApplicationArea=Basic,Suite;
    }

}

}
area(FactBoxes)
{
    part("DropArea";7174655)
    {
        ;
    }
    part("FilesSP";7174656)
    {
        ;
    }
    systempart(Links;Links)
    {
        
                Visible=FALSE;
    }
    systempart(Notes;Notes)
    {
        
                Visible=FALSE;
    }

}
}actions
{
area(Navigation)
{

group("group2")
{
        CaptionML=ENU='&Country/Region',ESP='&Pa�s/regi�n';
                      Image=CountryRegion ;
    action("action1")
    {
        CaptionML=ENU='VAT Reg. No. Formats',ESP='Formatos CIF/NIF';
                      ToolTipML=ENU='Specify that the tax registration number for an account, such as a customer, corresponds to the standard format for tax registration numbers in an account�s country/region.',ESP='Especifica que el n�mero de registro mercantil de una cuenta, por ejemplo, una cuenta de cliente, se corresponde con el formato est�ndar que se utiliza en los n�meros de registro mercantil del pa�s o la regi�n de la cuenta.';
                      RunObject=Page 575;
RunPageLink="Country/Region Code"=FIELD("Code");
                      Image=NumberSetup 
    ;
    }

}

}
}
  trigger OnOpenPage()    BEGIN
                 //QUONEXT 20.07.17 DRAG&DROP. Actualizaci�n de los ficheros.
                 CurrPage.FilesSP.PAGE.FncGetAllDataOpenPage(DATABASE::"Country/Region");
                 ///FIN QUONEXT 20.07.17
               END;

trigger OnAfterGetCurrRecord()    BEGIN
                        //    /QUONEXT 20.07.17 DRAG&DROP.
                           CurrPage.DropArea.PAGE.SetFilter(Rec);
                           CurrPage.FilesSP.PAGE.SetFilter(Rec);
                           ///FIN QUONEXT 20.07.17
                         END;




    /*begin
    end.
  
*/
}








