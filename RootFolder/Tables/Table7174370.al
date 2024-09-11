table 7174370 "QuoFacturae Admin. Center"
{


    ;
    fields
    {
        field(1; "Customer no."; Code[20])
        {
            TableRelation = "Customer"."No.";


            CaptionML = ENU = 'Customer no.', ESP = 'No. cliente';

            trigger OnValidate();
            BEGIN
                IF (Customer.GET("Customer no.")) THEN BEGIN
                    Description := Customer.Name;
                    Address := Customer.Address;
                    "Address 2" := Customer."Address 2";
                    "Post code" := Customer."Post Code";
                    County := Customer.County;
                    Country := Customer."Country/Region Code";
                    City := Customer.City;
                END;
            END;


        }
        field(2; "Type"; Option)
        {
            OptionMembers = "Fiscal","Receiver","Payer","Buyer","Collector","Seller","Payment receiver","Collection receiver","Issuer";
            CaptionML = ENU = 'Type', ESP = 'Tipo';
            OptionCaptionML = ENU = 'Fiscal,Receiver,Payer,Buyer,Collector,Seller,Payment receiver,Collection receiver,Issuer', ESP = 'Fiscal,Receptor,Pagador,Comprador,Cobrador,Vendedor,Receptor del pago,Receptor del cobro,Emisor';



        }
        field(3; "Code"; Code[20])
        {
            CaptionML = ENU = 'Code', ESP = 'C�digo';


        }
        field(4; "Description"; Text[250])
        {
            CaptionML = ENU = 'Description', ESP = 'Descripci�n';


        }
        field(5; "Address"; Text[50])
        {
            CaptionML = ENU = 'Address', ESP = 'Direcci�n';


        }
        field(6; "Address 2"; Text[50])
        {
            CaptionML = ENU = 'Address 2', ESP = 'Direcci�n 2';


        }
        field(7; "Post code"; Code[10])
        {
            TableRelation = "Post Code"."Code";
            CaptionML = ENU = 'Post code', ESP = 'C�d. Postal';


        }
        field(8; "County"; Code[30])
        {
            CaptionML = ENU = 'County', ESP = 'Provincia';
            Description = 'JAV 11/06/21 Se ampl�a de 10 a 30';


        }
        field(9; "Country"; Code[10])
        {
            TableRelation = "Country/Region"."Code";
            CaptionML = ENU = 'Country', ESP = 'Pa�s';


        }
        field(10; "City"; Text[30])
        {

        }
        field(11; "Name"; Text[40])
        {

        }
        field(12; "First Surname"; Text[40])
        {

        }
        field(13; "Second Surname"; Text[40])
        {

        }
    }
    keys
    {
        key(key1; "Customer no.", "Type", "Code")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       Customer@1100286000 :
        Customer: Record 18;

    /*begin
    end.
  */
}







