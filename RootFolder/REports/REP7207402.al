report 7207402 "Get Order Purchase Job"
{
  
  
    CaptionML=ENU='Get Order Purchase Job',ESP='Traer ped. compra proyecto';
    ProcessingOnly=true;
  
  dataset
{

DataItem("Purchase Header";"Purchase Header")
{

               DataItemTableView=SORTING("Document Type","No.")
                                 WHERE("Document Type"=CONST("Order"));
               ;
DataItem("Purchase Line";"Purchase Line")
{

DataItemLink="Document Type"= FIELD("Document Type"),
                            "Document No."= FIELD("No.") ;
trigger OnPreDataItem();
    BEGIN 
                               SETFILTER("Outstanding Quantity",'>0');
                             END;

trigger OnAfterGetRecord();
    BEGIN 
                                  InsertLine(HeaderJobReception,LastNumLine,0);
                                END;


}
trigger OnPreDataItem();
    BEGIN 
                               // Se busca el £ltimo n£mero de l¡nea
                               LineReceptionJob.SETRANGE("Recept. Document No.",HeaderJobReception."No.");
                               IF LineReceptionJob.FINDLAST THEN
                                 LastNumLine := LineReceptionJob."Line No."
                               ELSE
                                 LastNumLine:=0;
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
//       LineReceptionJob@7001100 :
      LineReceptionJob: Record 7207411;
//       HeaderJobReception@7001101 :
      HeaderJobReception: Record 7207410;
//       LastNumLine@7001102 :
      LastNumLine: Integer;

//     procedure InsertLine (PHeaderJobReception@1100251000 : Record 7207410;var PLastNumLine@1100251001 : Integer;PQuantityReceiveOrigin@1100251003 :
    procedure InsertLine (PHeaderJobReception: Record 7207410;var PLastNumLine: Integer;PQuantityReceiveOrigin: Decimal)
    var
//       LLineReceptionJob@1100251002 :
      LLineReceptionJob: Record 7207411;
    begin
      LLineReceptionJob.INIT;
      LLineReceptionJob."Recept. Document No.":= PHeaderJobReception."No.";
      PLastNumLine := PLastNumLine + 10000;
      LLineReceptionJob."Line No.":=PLastNumLine;
      LLineReceptionJob."Document No.":="Purchase Line"."Document No.";
      LLineReceptionJob."Document Line No.":="Purchase Line"."Line No.";
      LLineReceptionJob.Type:="Purchase Line".Type;
      LLineReceptionJob."No.":="Purchase Line"."No.";
      LLineReceptionJob."Expected Receipt Date":="Purchase Line"."Expected Receipt Date";
      LLineReceptionJob.Description:="Purchase Line".Description;
      LLineReceptionJob."Description 2":="Purchase Line"."Description 2";
      LLineReceptionJob.Quantity:="Purchase Line".Quantity;
      LLineReceptionJob."Outstanding Quantity":="Purchase Line"."Outstanding Quantity";
      LLineReceptionJob."Qty. to Receive":=0;
      LLineReceptionJob."Unit Price (LCY)":="Purchase Line"."Unit Price (LCY)";
      LLineReceptionJob."Shortcut Dimension 1 Code":="Purchase Line"."Shortcut Dimension 1 Code";
      LLineReceptionJob."Shortcut Dimension 2 Code":="Purchase Line"."Shortcut Dimension 2 Code";
      LLineReceptionJob."Job No.":="Purchase Line"."Job No.";
      LLineReceptionJob."Quantity Received":="Purchase Line"."Quantity Received";
      LLineReceptionJob."Currency Code":="Purchase Line"."Currency Code";
      LLineReceptionJob."Unit Cost":="Purchase Line"."Unit Cost";
      LLineReceptionJob."Job Task No." :="Purchase Line"."Job Task No.";
      LLineReceptionJob."Qty. per Unit of Measure":="Purchase Line"."Qty. per Unit of Measure";
      LLineReceptionJob."Unit of Measure Code":="Purchase Line"."Unit of Measure Code";
      LLineReceptionJob."Quantity (Base)" :="Purchase Line"."Quantity (Base)";
      LLineReceptionJob."Outstanding QTy. (Base)":="Purchase Line"."Outstanding Qty. (Base)";
      LLineReceptionJob."Qty. to Receive (Base)":=0;
      LLineReceptionJob."Qty. to Receive" :="Purchase Line"."Qty. Received (Base)";
      LLineReceptionJob."Piecework No.":="Purchase Line"."Piecework No.";
      if PQuantityReceiveOrigin <> 0 then begin
        LLineReceptionJob.VALIDATE("Amount to Receive Origin",PQuantityReceiveOrigin)
      end else
        LLineReceptionJob."Amount to Receive Origin" := LLineReceptionJob."Quantity Received";
      LLineReceptionJob.INSERT;
    end;

//     procedure GetHeaderRecpJob (PHeaderJobReception@1100000 :
    procedure GetHeaderRecpJob (PHeaderJobReception: Record 7207410)
    begin
      HeaderJobReception := PHeaderJobReception
    end;

    /*begin
    end.
  */
  
}



