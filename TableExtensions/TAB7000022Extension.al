tableextension 50230 "QBU Closed Payment OrderExt" extends "Closed Payment Order"
{
  
  
    CaptionML=ENU='Closed Payment Order',ESP='Orden pago cerrada';
    LookupPageID="Closed Payment Orders List";
    DrillDownPageID="Closed Payment Orders List";
  
  fields
{
    field(7207270;"QBU Department";Code[20])
    {
        TableRelation="Dimension Value"."Code";
                                                   CaptionML=ENU='Global Dimension 1 Filter',ESP='Departamento';
                                                   Description='QB 1.07.00 - JAV 26/10/20: - Departamento que lanza la orden de pago';


    }
    field(7207271;"QBU Approval Status";Option)
    {
        OptionMembers="Open","Released","Pending Approval";DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Estado Aprobaci¢n';
                                                   OptionCaptionML=ENU='Open,Released,Pending Approval',ESP='Abierto,Lanzado,Aprobaci¢n pendiente';
                                                   
                                                   Description='QB 1.07.00 - JAV 22/10/20: - Estado de aprobaci¢n';
                                                   Editable=false;


    }
    field(7207272;"QBU OLD_Approval Situation";Option)
    {
        OptionMembers="Pending","Approved","Rejected","Withheld";DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Status',ESP='Situaci¢n de la Aprobaci¢n';
                                                   OptionCaptionML=ESP='Pendiente,Aprobado,Rechazado,Retenido';
                                                   
                                                   Description='###ELIMINAR### no se usa';
                                                   Editable=false;


    }
    field(7207273;"QBU OLD_Approval Coment";Text[80])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Comentario Aprobaci¢n';
                                                   Description='###ELIMINAR### no se usa';
                                                   Editable=false;


    }
    field(7207274;"QBU OLD_Approval Date";Date)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Fecha aprobaci¢n';
                                                   Description='###ELIMINAR### no se usa';
                                                   Editable=false;


    }
    field(7207290;"QBU Confirming";Boolean)
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Confirming';
                                                   Description='JAV 21/09/20: - QB 1.06.15 Si la orden de pagos es de confirming';
                                                   Editable=false;


    }
    field(7207291;"QBU Confirming Line";Code[20])
    {
        TableRelation="QB Confirming Lines";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='L¡nea de confirming';
                                                   Description='QB 1.06.15 - JAV 23/09/20: L¡nea de confirming asociada al banco de la orden de pago';
                                                   Editable=false;


    }
    field(7207335;"QBU Job No.";Code[20])
    {
        DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Job No.',ESP='No. Proyecto';
                                                   Description='QB 1.00 - JAV 08/03/20: - N£mero del proyecto';
                                                   Editable=false;


    }
    field(7207336;"QBU Approval Circuit Code";Code[20])
    {
        TableRelation="QB Approval Circuit Header";
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ENU='Approval Circuit Code',ESP='Circuito de Aprobaci¢n';
                                                   Description='TO-DO Debe pasar el dato de al aprobaci¢n para tenerlo como referencia';


    }
    field(7238177;"QBU Budget item";Code[20])
    {
        TableRelation="Data Piecework For Production"."Piecework Code" WHERE ("Job No."=FIELD("Job No."),
                                                                                                                         "Account Type"=FILTER("Unit"));
                                                   DataClassification=ToBeClassified;
                                                   CaptionML=ESP='Partida Presupuestaria';
                                                   Description='TO-DO Debe pasar el dato de al aprobaci¢n para tenerlo como referencia' ;


    }
}
  keys
{
   // key(key1;"No.")
  //  {
       /* Clustered=true;
 */
   // }
   // key(key2;"Bank Account No.","Posting Date")
  //  {
       /* SumIndexFields="Payment Order Expenses Amt.";
 */
   // }
}
  fieldgroups
{
}
  
    var
//       Text1100000@1000 :
      Text1100000: TextConst ENU='untitled',ESP='sin t¡tulo';
//       ClosedPmtOrd@1100000 :
      ClosedPmtOrd: Record 7000022;
//       ClosedDoc@1100001 :
      ClosedDoc: Record 7000004;
//       BGPOCommentLine@1100002 :
      BGPOCommentLine: Record 7000008;

    


/*
trigger OnDelete();    begin
               ClosedDoc.SETRANGE("Bill Gr./Pmt. Order No.","No.");
               ClosedDoc.DELETEALL;

               BGPOCommentLine.SETRANGE("BG/PO No.","No.");
               BGPOCommentLine.DELETEALL;
             end;

*/



// procedure PrintRecords (ShowRequestForm@1100000 :

/*
procedure PrintRecords (ShowRequestForm: Boolean)
    var
//       CarteraReportSelection@1100001 :
      CarteraReportSelection: Record 7000013;
    begin
      WITH ClosedPmtOrd DO begin
        COPY(Rec);
        CarteraReportSelection.SETRANGE(Usage,CarteraReportSelection.Usage::"Closed Payment Order");
        CarteraReportSelection.SETFILTER("Report ID",'<>0');
        CarteraReportSelection.FIND('-');
        repeat
          REPORT.RUNMODAL(CarteraReportSelection."Report ID",ShowRequestForm,FALSE,ClosedPmtOrd);
        until CarteraReportSelection.NEXT = 0;
      end;
    end;
*/


    
/*
procedure Caption () : Text[100];
    begin
      if "No." = '' then
        exit(Text1100000);
      CALCFIELDS("Bank Account Name");
      exit(STRSUBSTNO('%1 %2',"No.","Bank Account Name"));
    end;

    /*begin
    end.
  */
}





