//Table obsolete in page
page 51556 "Social Listening Setup"
{
CaptionML=ENU='Social Engagement Setup',ESP='Configuraci�n de Social Engagement';
    ApplicationArea=Suite;
    InsertAllowed=false;
    DeleteAllowed=false;
    // SourceTable=870;
    PageType=Card;
    UsageCategory=Administration;
    
  layout
{
// area(content)
// {
// group("Control2")
// {
        
//                 CaptionML=ENU='General',ESP='General';
// group("Control10")
// {
        
//                 InstructionalTextML=ENU='If you do not already have a subscription, sign up at Microsoft Social Engagement. After signing up, you will receive a Social Engagement Server URL.',
//                                      ESP='Si a�n no tiene una suscripci�n, inscr�base en Microsoft Social Engagement. Despu�s de inscribirse, recibir� una direcci�n URL del servidor de Social Engagement.';
//     field("SignupLbl";"SignupLbl")
//     {
        
//                 DrillDown=true;
//                 ToolTipML=ENU='Specifies a link to the sign-up page for Microsoft Social Engagement.',ESP='Especifica un v�nculo que lleva a la p�gina de registro de Microsoft Social Engagement.';
//                 ApplicationArea=Suite;
//                 Editable=FALSE;
                

//                 ShowCaption=false ;trigger OnDrillDown()    BEGIN
//                               HYPERLINK(rec."Signup URL");
//                             END;


//     }
//     field("Social Listening URL";rec."Social Listening URL")
//     {
        
//                 CaptionML=ENU='Social Engagement URL',ESP='URL de Social Engagement';
//                 ToolTipML=ENU='Specifies the URL for the Microsoft Social Engagement subscription.',ESP='Especifica la direcci�n URL de la suscripci�n de Microsoft Social Engagement.';
//                 ApplicationArea=Suite;
//     }
//     field("Solution ID";rec."Solution ID")
//     {
        
//                 ToolTipML=ENU='Specifies the Solution ID assigned for Microsoft Social Engagement. This field cannot be edited.',ESP='Especifica el id. de soluci�n asignado a Microsoft Social Engagement. Este campo no se puede editar.';
//                 ApplicationArea=Suite;
//                 Editable=FALSE ;
//     }

// }
// group("Control9")
// {
        
//                 InstructionalTextML=ENU='I agree to the terms of the applicable Microsoft Social Engagement License or Subscription Agreement.',
//                                      ESP='Acepto las condiciones de la licencia o del acuerdo de suscripci�n aplicables de Microsoft Social Engagement.' ;
//     field("TermsOfUseLbl";"TermsOfUseLbl")
//     {
        
//                 ToolTipML=ENU='Specifies a link to the Terms of Use for Microsoft Social Engagement.',ESP='Especifica un v�nculo a las Condiciones de uso de Microsoft Social Engagement.';
//                 ApplicationArea=Suite;
//                 Editable=FALSE;
                

//                 ShowCaption=false ;trigger OnDrillDown()    BEGIN
//                               HYPERLINK(rec."Terms of Use URL");
//                             END;


//     }
//     field("Accept License Agreement";rec."Accept License Agreement")
//     {
        
//                 ToolTipML=ENU='Specifies acceptance of the license agreement for using Microsoft Social Engagement. This field is mandatory for activating Microsoft Social Engagement.',ESP='Especifica la aceptaci�n del contrato de licencia para utilizar Microsoft�Social�Engagement. Este campo es obligatorio para activar Microsoft�Social�Engagement.';
//                 ApplicationArea=Suite;
//     }

// }

// }
// group("Control8")
// {
        
//                 CaptionML=ENU='Show Social Media Insights for',ESP='Mostrar datos de Medios sociales para';
//     field("Show on Items";rec."Show on Items")
//     {
        
//                 CaptionML=ENU='Items',ESP='Productos';
//                 ToolTipML=ENU='Specifies the list of items that you trade in.',ESP='Especifica la lista de productos que se comercializan.';
//                 ApplicationArea=Suite;
//     }
//     field("Show on Customers";rec."Show on Customers")
//     {
        
//                 CaptionML=ENU='Customers',ESP='Clientes';
//                 ToolTipML=ENU='Specifies whether to enable Microsoft Social Engagement for customers. Selecting Show on Customers will enable a fact box on the Customers list page and on the Customer card.',ESP='Especifica si se habilita Microsoft Social Engagement para clientes. Al seleccionar Mostrar en Clientes, se habilitar� un cuadro informativo en la p�gina de lista Clientes y en la ficha Cliente.';
//                 ApplicationArea=Suite;
//     }
//     field("Show on Vendors";rec."Show on Vendors")
//     {
        
//                 CaptionML=ENU='Vendors',ESP='Proveedores';
//                 ToolTipML=ENU='Specifies whether to enable Microsoft Social Engagement for vendors. Selecting Show on Vendors will enable a fact box on the Vendors list page and on the Vendor card.',ESP='Especifica si se habilita Microsoft Social Engagement para proveedores. Al seleccionar Mostrar en Proveedores, se habilitar� un cuadro informativo en la p�gina de lista Proveedores y en la ficha Proveedor.';
//                 ApplicationArea=Suite;
//     }

// }

// }
}actions
{
area(Navigation)
{

    action("Action14")
    {
        CaptionML=ENU='Users',ESP='Usuarios';
                      ToolTipML=ENU='Open the list of users that are registered in the system.',ESP='Abre la lista de usuarios registrados en el sistema.';
                      ApplicationArea=Suite;
                      Promoted=true;
                      // Enabled=rec."Social Listening URL" <> '';
                      PromotedIsBig=true;
                      Image=Users;
                      PromotedCategory=Process;
                      
                                
    trigger OnAction()    VAR
                                 SocialListeningMgt : Codeunit 50455;
                               BEGIN
                                 HYPERLINK(SocialListeningMgt.MSLUsersURL);
                               END;


    }

}
}
  

trigger OnOpenPage()    VAR
                 ApplicationAreaMgmtFacade : Codeunit 9179;
               BEGIN
                 ApplicationAreaMgmtFacade.CheckAppAreaOnlyBasic;

                //  Rec.RESET;
                //  IF NOT Rec.GET THEN BEGIN
                //    Rec.INIT;
                //    Rec.INSERT(TRUE);
                //  END;
               END;



    var
      TermsOfUseLbl : TextConst ENU='Microsoft Social Engagement Terms of Use',ESP='Condiciones de uso de Microsoft Social Engagement';
      SignupLbl : TextConst ENU='Sign up for Microsoft Social Engagement',ESP='Inscripci�n a Microsoft Social Engagement';

    /*begin
    end.
  
*/
}




