// pageextension 50293 MyExtension9506 extends "Session List"//2000000110
// {
// layout
// {


// }

// actions
// {
// addafter("Event")
// {
// group("Action1100286001")
// {
//         CaptionML=ENU='Event',ESP='Cerrar';
//     action("Action1100286000")
//     {
//         CaptionML=ENU='Subscriptions',ESP='Cerrar Sesion';
//                       ToolTipML=ENU='Show event subscriptions.',ESP='Permite mostrar las suscripciones a eventos.';
//                       ApplicationArea=All;
//                       Promoted=true;
//                       Image=Close;
//                       PromotedCategory=Category7;
                      
                                
//     trigger OnAction()    BEGIN
//                                  IF NOT CONFIRM(txtQB000,TRUE) THEN
//                                    ERROR(txtQB001);
//                                  STOPSESSION(rec."Session ID");
//                                  MESSAGE(txtQB002);
//                                END;


// }
// }
// }

// }

// //trigger

// //trigger

// var
//       DebuggerManagement : Codeunit 9500;
//       CanDebugNextSession : Boolean ;
//       CanDebugSelectedSession : Boolean ;
//       FullSQLTracingStarted : Boolean ;
//       IsDebugging : Boolean;
//       IsDebugged : Boolean;
//       IsSQLTracing : Boolean;
//       IsRowSessionActive : Boolean;
//       SessionIdText : Text;
//       ClientTypeText : Text;
//       txtQB000 : TextConst ESP='¨Desea cerrar la sesi¢n seleccionada?';
//       txtQB001 : TextConst ESP='Operaci¢n cancelada.';
//       txtQB002 : TextConst ESP='Sesi¢n cerrada.';

    

// //procedure

// //procedure
// }

