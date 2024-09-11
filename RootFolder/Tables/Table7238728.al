table 7238728 "QB_PurchaseHeaderExt."
{


    CaptionML = ENU = 'Purchase Header Ext', ESP = 'Cab. Compra Ext';

    fields
    {
        field(1; "Record Id"; RecordID)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Id. Registro';


        }
        field(2; "Document Type"; Option)
        {
            OptionMembers = "Quote","Order","Invoice","Credit Memo","Blanket Order","Return Order";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Document Type', ESP = 'Tipo documento';
            OptionCaptionML = ENU = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order', ESP = 'Oferta,Pedido,Factura,Abono,Pedido abierto,Devoluci�n';

            Description = 'QRE 1.00.00 15454';


        }
        field(3; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'No.', ESP = 'N�';
            Description = 'QRE 1.00.00 15454';


        }
        field(4; "QB_Buy-from Vendor No."; Code[20])
        {
            TableRelation = Vendor WHERE("QB Employee" = CONST(false));


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Buy-from Vendor No.', ESP = 'Compra a-N� proveedor';
            Description = 'QRE 1.00.00 15454';

            trigger OnValidate();
            VAR
                //                                                                 StandardCodesMgt@1000 :
                StandardCodesMgt: Codeunit 170;
            BEGIN
            END;


        }
        field(118; "QB_Applies-to ID"; Code[50])
        {


            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Applies-to ID', ESP = 'Liq. por id.';
            Description = 'QRE 1.00.00 15454';

            trigger OnValidate();
            VAR
                //                                                                 TempVendLedgEntry@1000 :
                TempVendLedgEntry: Record 25 TEMPORARY;
                //                                                                 VendEntrySetApplID@1001 :
                VendEntrySetApplID: Codeunit "Vend. Entry-SetAppl.ID";
            BEGIN
            END;


        }
        field(7238177; "QB_Budget item"; Code[20])
        {


            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Partida Presupuestaria';
            Description = 'QRE';

            trigger OnValidate();
            VAR
                //                                                                 PurchHeader@1100286005 :
                PurchHeader: Record 38;
                //                                                                 Job@1100286003 :
                Job: Record 167;
                //                                                                 PurchaseLine@1100286002 :
                PurchaseLine: Record 39;
                //                                                                 DimensionValue@1100286001 :
                DimensionValue: Record 349;
                //                                                                 FunctionQB@1100286000 :
                FunctionQB: Codeunit 7207272;
                //                                                                 Text001@1100286004 :
                Text001: TextConst ESP = '�Desea traspasar el campo %1 a las l�neas del documento?';
            BEGIN
            END;


        }
        field(7238179; "QB_Classif Code 1"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'C�d Clasif1';
            Description = 'QRE 1.00.00 15454  -- ELIMINAR hay que usar JOB de la tabla amestra';


        }
        field(7238260; "QB_Expense Interface Entry No."; BigInteger)
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Expense Interface Entry No.', ESP = 'N� mov. interfaz gastos';
            Description = 'QRE 1.00.00 15454';


        }
        field(7238261; "QB_Cod. Fact. Gastos"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'C�d. Fact. Gastos';
            Description = 'QRE 1.00.00 15452';


        }
        field(7238262; "QB_inREGE"; Boolean)
        {
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'REGE';
            Description = 'QRE 1.00.00 15452';


        }
        field(7238263; "QB_Tipo ID Externo"; Option)
        {
            OptionMembers = " ","ADEA","Portal proveedores","IBI","Docuware";
            DataClassification = ToBeClassified;
            CaptionML = ESP = 'Tipo ID Externo';
            OptionCaptionML = ESP = '" ,ADEA,Portal proveedores,IBI,Docuware"';

            Description = 'QRE 1.00.00 15452';
            Editable = false;


        }
        field(7238264; "QB_Validacion Portal Proveedor"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'QRE 1.00.00 15452';


        }
        field(7238266; "QB_coCertificacion"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Certification code', ESP = 'C�d. Certificaci�n';
            Description = 'QRE 1.00.00 15452';
            Editable = false;


        }
        field(7238272; "QB_DevengoIVAdifretenciones"; Option)
        {
            OptionMembers = "No aplicar en devolucin","Aplicar en devolución";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'VAT accrual deferred retentions', ESP = 'Devengo IVA dif. retenciones';
            OptionCaptionML = ENU = 'Do not apply in return,Apply in return', ESP = 'No aplicar en devoluci�n,Aplicar en devoluci�n';

            Description = 'QRE 1.00.00 15452   -- ELIMINAR debe usarse nuestro m�dulo de retenciones';


        }
        field(7238320; "ID Usuario"; Code[50])
        {
            TableRelation = "User Setup"."User ID";
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'User ID', ESP = 'ID Usuario';
            Description = 'QRE 1.00.00 15454';


        }
    }
    keys
    {
        key(key1; "Record Id")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }

    var
        //       Text1100000007@1100286024 :
        Text1100000007: TextConst ENU = 'Payment method for retentions must not be set as if creating receivables. Select a payment method set as accounts payment process.', ESP = 'La forma de pago para las retenciones no debe estar configurada como crea efectos. Seleccione una forma de pago configurada como circuito de pagos.';
        //       Text1100000042@1100286021 :
        Text1100000042: TextConst ENU = 'Purchase %1 %2 already exists for this vendor.', ESP = 'El documento de compra %1 %2 ya existe para este proveedor.';
        //       Text1100000006@1100286025 :
        Text1100000006: TextConst ENU = 'You cannot assign a payment method that does not generate a portfolio if the Accrued VAT deferred retentions field has the Apply in return value in the purchases and payments setting.', ESP = 'No se puede asignar una forma de pago que no genere cartera, si el campo Devengo IVA dif. retenciones tiene el valor Aplicar en devoluci�n en la configuraci�n de compras y pagos.';
        //       TextShebel001@1100286026 :
        TextShebel001: TextConst ENU = 'Retention base should always be positive.', ESP = 'La base de la retenci�n siempre debe ser positiva.';
        //       Text1100000005@1100286027 :
        Text1100000005: TextConst ENU = 'The retention base by security cannot be greater than the total invoice amount excluding VAT.', ESP = 'La base de retenciones por garant�a no puede ser mayor al importe total sin IVA de la factura.';
        //       Text1100000000@1100286032 :
        Text1100000000: TextConst ENU = 'Unable to generate invoices to portfolio with multiple maturities.', ESP = 'No se puede generar m�ltiples vencimientos con esta forma de pago. Seleccione una forma de pago configurada como Crea efectos o Circuito de pagos.';
        //       Text1100000001@1100286031 :
        Text1100000001: TextConst ENU = 'The percentage cannot be higher than 100%', ESP = 'El porcentaje no puede ser superior al 100%';
        //       Text1100000002@1100286030 :
        Text1100000002: TextConst ENU = 'The percentage cannot be negative', ESP = 'El porcentaje no puede ser negativo';
        //       Text1100000003@1100286029 :
        Text1100000003: TextConst ENU = 'end date cannot be before start date.', ESP = 'La fecha final no puede ser inferior a la fecha inicial.';
        //       Text1100000004@1100286028 :
        Text1100000004: TextConst ENU = 'The same date must be specified for the start and end date.', ESP = 'Se debe especificar el mismo n�mero de d�a para la fecha inicial y final.';
        //       Text50000@1100286033 :
        Text50000: TextConst ENU = 'The %1 choosen %2 must be, at least, in 1 line of the %3', ESP = 'El %1 elegido %2 debe estar al menos en una l�nea de %3';
        //       Text1100000008@1100286072 :
        Text1100000008: TextConst ENU = 'Portfolio invoices or expenses cannot be settled if the payment method of the payments generates a portfolio.', ESP = 'No se pueden liquidar facturas de cartera o efectos si la forma de pago del abono genera cartera.';
        //       Text1100000009@1100286071 :
        Text1100000009: TextConst ENU = 'Cannot be modified as it is associated with certification %1', ESP = 'No puede modificarse al estar asociada a la certificaci�n %1';
        //       Text1100000010@1100286070 :
        Text1100000010: TextConst ENU = 'end date cannot be before start date.', ESP = 'La fecha final no puede ser inferior a la fecha inicial.';
        //       Text1100000011@1100286069 :
        Text1100000011: TextConst ENU = '%1 field cannot be modified to associate the invoice with certification %2.', ESP = 'No puede modificarse el campo %1 al estar asociada la factura a la certificaci�n %2.';
        //       Text1100000012@1100286068 :
        Text1100000012: TextConst ENU = 'Invoices associated with a certification must be removed from the actual certification.', ESP = 'Las facturas asociadas a una certificaci�n deben ser eliminados desde la propia certificaci�n.';
        //       Text1100000013@1100286067 :
        Text1100000013: TextConst ENU = 'Unable to apply a Method of Payment that generates portfolio to the retention money when VAT is applied to these retentions.', ESP = 'No se puede aplicar una Forma de Pago que genere cartera a las Retenciones de Garantia cuando se aplica IVA a dichas Retenciones.';
        //       Text1100000014@1100286066 :
        Text1100000014: TextConst ESP = 'No puede modificarse %1 %2 al haber sido aprobado.';
        //       Text1100000015@1100286065 :
        Text1100000015: TextConst ESP = 'Ha marcado movimiento %1 que tiene IVA Diferido asociado para liquidar, �desea continuar?';
        //       Text1100000016@1100286064 :
        Text1100000016: TextConst ESP = 'Al liquidar un documento con IVA diferido, el abono que quiere registrar debe llevar IVA normal.';
        //       Text1100000017@1100286063 :
        Text1100000017: TextConst ESP = 'Proceso abortado para respetar la advertencia.';
        //       Text1100000018@1100286062 :
        Text1100000018: TextConst ESP = 'No se puede liquidar por diario, o desde los movimientos de proveedor un documento agrupado con IVA diferido.';
        //       Text1100000019@1100286061 :
        Text1100000019: TextConst ENU = 'There are no works to select', ESP = 'No existen Obras para seleccionar';
        //       Text1100000020@1100286060 :
        Text1100000020: TextConst ENU = 'Offers construction can only be Product Lines', ESP = 'Las ofertas de Construccion solo pueden tener l�neas de Productos';
        //       Text1100000021@1100286059 :
        Text1100000021: TextConst ENU = 'Construction offers can not Products Services', ESP = 'Las ofertas de Construccion no pueden tener Productos de Servicios';
        //       Text1100000022@1100286058 :
        Text1100000022: TextConst ENU = 'Can not mark %1 as %2% to inform the Field %3', ESP = 'No se puede marcar %1 como %2 al tener informado el campo %3';
        //       Text1100000023@1100286057 :
        Text1100000023: TextConst ESP = 'No se puede modificar el campo %1 al estar creado el documento como %2';
        //       Text1100000024@1100286056 :
        Text1100000024: TextConst ESP = 'Al cambiar la fecha de la factura se revisar�n todas las l�neas de la misma para comprobar si existen periodificaciones pendientes para la combinaci�n Inmueble - Partida. �Desea realizar esta comprobaci�n?';
        //       Text1100000025@1100286055 :
        Text1100000025: TextConst ESP = 'Se han encontrado m�s una l�nea de gastos periodificables reclacionados con el Inmueble: %1, C�d. Partida: %2, Anualidad: %3. Debe seleccionar el concepto en la l�nea %4 de forma manual.';
        //       Text1100000026@1100286054 :
        Text1100000026: TextConst ESP = 'Se han eliminado los conceptos de periodificaci�n del inmueble: %1, C�d. Partida: %2 en la l�nea %3. Revise las cuentas para comprobar que son las correctas.';
        //       Text1100000027@1100286053 :
        Text1100000027: TextConst ENU = 'Can not mark %1 as %2% to inform the Field %3', ESP = 'No se puede marcar %1 al tener informado el campo %2';
        //       Text1100000028@1100286052 :
        Text1100000028: TextConst ESP = 'No se puede modificar %1 al estar marcado %2 como %3';
        //       Text1100000029@1100286051 :
        Text1100000029: TextConst ENU = 'There advance payments unsettled, remember to apply them.', ESP = 'Existen Anticipos pendientes de liquidar, recuerde liquidarlos.';
        //       Text1100000030@1100286050 :
        Text1100000030: TextConst ESP = 'La fecha de devengo no puede ser superior a la fecha de emisi�n del documento.';
        //       Text1100000031@1100286049 :
        Text1100000031: TextConst ESP = 'No existe configuraci�n para el Usuario %1';
        //       Text1100000032@1100286048 :
        Text1100000032: TextConst ESP = 'El Usuario %1 no tiene permisos para borrar Facturas relacionadas con el proceso de Alta de Activos Fijos';
        //       Text1100000033@1100286047 :
        Text1100000033: TextConst ESP = 'Esta factura es intracomunitaria y si procede a su anulaci�n se producir�n saltos en el n� de autofacturas. �Desea continuar?';
        //       Text1100000034@1100286046 :
        Text1100000034: TextConst ENU = 'Deleting this document will cause a gap in the number series for receipts. ', ESP = 'Si modifica %1, se provocar� una discontinuidad en la numeraci�n de la serie de autofacturas. �Desea continuar?';
        //       Text1100000035@1100286045 :
        Text1100000035: TextConst ESP = '%1 %2 se va a liquidar contra %3 %4';
        //       Text1100000036@1100286044 :
        Text1100000036: TextConst ESP = 'La Forma de pago seleccionada no debe tener %1';
        //       Text1100000037@1100286043 :
        Text1100000037: TextConst ESP = 'Existen documentos seleccionados para liquidar contra la Factura %1 y el proveedor %2 que se desmarcar�n, �desea continuar?';
        //       Text1100000038@1100286042 :
        Text1100000038: TextConst ESP = 'No existen Anticipos seleccionados para liquidar';
        //       Text1100000039@1100286041 :
        Text1100000039: TextConst ESP = 'No existen anticipos pendientes marcados para liquidar por Id.';
        //       Text1100000040@1100286040 :
        Text1100000040: TextConst ESP = 'Existen anticipos marcados para liquidar por Id contra proveedores distintos a %1';
        //       Text1100000041@1100286039 :
        Text1100000041: TextConst ESP = 'No se puede seleccionar un Anticipo que ha sido distribuido entre Inmuebles';
        //       Text1100000053@1100286038 :
        Text1100000053: TextConst ESP = 'No tiene permisos para eliminar una factura importada ADEA';
        //       Text1100000054@1100286037 :
        Text1100000054: TextConst ESP = 'No tiene permisos para modificar el campo %1 en una factura importada ADEA';
        //       Text1100000055@1100286036 :
        Text1100000055: TextConst ESP = 'Se dispone a modificar una factura importada ADEA, �desea continuar?';
        //       Text1100000056@1100286035 :
        Text1100000056: TextConst ESP = 'Se dispone a eliminar una factura importada ADEA, �desea continuar?';
        //       Text1100000057@1100286034 :
        Text1100000057: TextConst ESP = 'Proceso abortado por el usuario';
        //       Text018@1100286098 :
        Text018: TextConst ENU = 'You must delete the existing purchase lines before you can change %1.', ESP = 'Se deben eliminar las l�neas de compra existentes antes de cambiar %1.';
        //       Text019@1100286097 :
        Text019: TextConst ENU = 'You have changed %1 on the purchase header, but it has not been changed on the existing purchase lines.\', ESP = 'Se ha modificado %1 en la cab. compra, pero no se ha modificado en las l�neas de compra existentes.\';
        //       Text020@1100286096 :
        Text020: TextConst ENU = 'You must update the existing purchase lines manually.', ESP = 'Debe actualizar las l�neas de compra existentes manualmente.';
        //       Text021@1100286095 :
        Text021: TextConst ENU = 'The change may affect the exchange rate used on the price calculation of the purchase lines.', ESP = 'El cambio puede afectar al tipo de cambio utilizado en el c�lculo del precio de las l�neas de compras.';
        //       Text022@1100286094 :
        Text022: TextConst ENU = 'Do you want to update the exchange rate?', ESP = '�Confirma que desea modificar el tipo de cambio?';
        //       Text023@1100286093 :
        Text023: TextConst ENU = 'You cannot delete this document. Your identification is set up to process from %1 %2 only.', ESP = 'No puede borrar este documento. Su identificaci�n est� configurada s�lo para procesar %1 %2.';
        //       Text025@1100286092 :
        Text025: TextConst ENU = 'You have modified the %1 field. Note that the recalculation of VAT may cause penny differences, so you must check the amounts afterwards. ', ESP = 'Ha modificado el campo %1. El nuevo c�lculo de IVA puede tener alguna diferencia, por lo que deber�a comprobar los importes. ';
        //       Text027@1100286091 :
        Text027: TextConst ENU = 'Do you want to update the %2 field on the lines to reflect the new value of %1?', ESP = '�Confirma que desea actualizar el %2 campo en la l�neas para reflejar el nuevo valor de %1?';
        //       Text028@1100286090 :
        Text028: TextConst ENU = 'Your identification is set up to process from %1 %2 only.', ESP = 'Su identificaci�n est� configurada para procesar s�lo desde %1 %2.';
        //       Text029@1100286089 :
        Text029:
// "%1 = Document No."
TextConst ENU = 'Deleting this document will cause a gap in the number series for return shipments. An empty return shipment %1 will be created to fill this gap in the number series.\\Do you want to continue?', ESP = 'Si elimina este documento, se provocar� una discontinuidad en los n�meros de serie de los env�os devoluci�n. Se crear� un env�o devoluci�n en blanco %1 para corregir esta discontinuidad en los n�meros de serie.\\�Desea continuar?';
        //       Text032@1100286088 :
        Text032: TextConst ENU = 'You have modified %1.\\', ESP = 'Ha modificado %1.\\';
        //       Text033@1100286087 :
        Text033: TextConst ENU = 'Do you want to update the lines?', ESP = '�Confirma que desea actualizar las l�neas?';
        //       Text034@1100286086 :
        Text034: TextConst ENU = 'You cannot change the %1 when the %2 has been filled in.', ESP = 'No puede cambiar %1 despu�s de introducir datos en %2.';
        //       Text037@1100286085 :
        Text037: TextConst ENU = 'Contact %1 %2 is not related to vendor %3.', ESP = 'Contacto %1 %2 no est� relacionado con proveedor %3.';
        //       Text038@1100286084 :
        Text038: TextConst ENU = 'Contact %1 %2 is related to a different company than vendor %3.', ESP = 'Contacto %1 %2 est� relacionado con una empresa diferente al proveedor %3.';
        //       Text039@1100286083 :
        Text039: TextConst ENU = 'Contact %1 %2 is not related to a vendor.', ESP = 'Contacto %1 %2 no est� relacionado con un proveedor.';
        //       Text040@1100286082 :
        Text040: TextConst ENU = 'You can not change the %1 field because %2 %3 has %4 = %5 and the %6 has already been assigned %7 %8.', ESP = 'No puede cambiar el campo %1 porque %2 %3 tiene %4 = %5 y ya se ha asignado el %6 a %7 %8.';
        //       Text041@1100286081 :
        Text041: TextConst ENU = 'The purchase %1 %2 has item tracking. Do you want to delete it anyway?', ESP = 'El valor %1 %2 de compras tiene seguimiento de productos. �Desea eliminarlo de todas maneras?';
        //       Text042@1100286080 :
        Text042: TextConst ENU = 'You must cancel the approval process if you wish to change the %1.', ESP = 'Debe cancelar el proceso de aprobaci�n si desea cambiar el %1.';
        //       Text044@1100286079 :
        Text044: TextConst ENU = 'Do you want to print prepayment credit memo %1?', ESP = '�Desea imprimir el abono prepago %1?';
        //       Text045@1100286078 :
        Text045: TextConst ENU = 'Deleting this document will cause a gap in the number series for prepayment invoices. An empty prepayment invoice %1 will be created to fill this gap in the number series.\\Do you want to continue?', ESP = 'Si elimina el documento, se provocar� una discontinuidad en la numeraci�n de la serie de facturas de prepago. Se crear� una factura prepago en blanco %1 para completar este error en las series num�ricas.\\�Desea continuar?';
        //       Text046@1100286077 :
        Text046: TextConst ENU = 'Deleting this document will cause a gap in the number series for prepayment credit memos. An empty prepayment credit memo %1 will be created to fill this gap in the number series.\\Do you want to continue?', ESP = 'Si elimina el documento, se provocar� una discontinuidad en la numeraci�n de la serie de abonos de prepago. Se crear� un abono prepago en blanco %1 para completar este error en las series num�ricas.\\�Desea continuar?';
        //       Text049@1100286076 :
        Text049: TextConst ENU = '%1 is set up to process from %2 %3 only.', ESP = 'Se ha configurado %1 para procesar s�lo desde %2 %3.';
        //       Text050@1100286075 :
        Text050: TextConst ENU = 'Reservations exist for this order. These reservations will be canceled if a date conflict is caused by this change.\\Do you want to continue?', ESP = 'Existen reservas para este pedido. Dichas reservas se cancelar�n si este cambio provoca un conflicto de fechas.\\�Desea continuar?';
        //       Text051@1100286074 :
        Text051: TextConst ENU = 'You may have changed a dimension.\\Do you want to update the lines?', ESP = 'Puede que haya cambiado una dimensi�n.\\�Desea actualizar las l�neas?';
        //       Text052@1100286073 :
        Text052: TextConst ENU = 'The %1 field on the purchase order %2 must be the same as on sales order %3.', ESP = 'El campo %1 del pedido de compra %2 debe ser igual al del pedido de venta %3.';
        //       Text053@1100286023 :
        Text053: TextConst ENU = 'There are unposted prepayment amounts on the document of type %1 with the number %2.', ESP = 'Hay importes prepago sin registrar en el documento de tipo %1 con el n�mero %2.';
        //       Text054@1100286100 :
        Text054: TextConst ENU = 'There are unpaid prepayment invoices that are related to the document of type %1 with the number %2.', ESP = 'Hay facturas prepago sin pagar relacionadas con el documento de tipo %1 con el n�mero %2.';
        //       Text055@1100286099 :
        Text055: TextConst ESP = 'El proveedor de pago no puede ser el mismo que el proveedor de la factura';
        //       Text69@1100286102 :
        Text69: TextConst ESP = 'Se han limpiado los campos de liquidaci�n, si desea l�quidar alg�n movimiento, vuelva a indicar los campos';
        //       DuplicatedCaptionsNotAllowedErr@1100286105 :
        DuplicatedCaptionsNotAllowedErr: TextConst ENU = 'Field captions must not be duplicated when using this method. Use UpdatePurchLinesByFieldNo instead.', ESP = 'No se deben duplicar t�tulos de campo cuando se utiliza este m�todo. Use UpdatePurchLinesByFieldNo en su lugar.';
        //       Text50001@1100286119 :
        Text50001: TextConst ENU = 'The invoice has linked commissions. Once invoice is deleted, commissions wil be unpaid, do you want to continue?', ESP = 'La factura tiene comisiones vinculadas. Al eliminar la factura, se desvincular�n las comisiones, �desea continuar?';
        //       Text50002@1100286118 :
        Text50002: TextConst ENU = 'There are commissions payments unsettled, remember to apply them.', ESP = 'Existen Comisiones pendientes de liquidar, recuerde liquidarlas.';
        //       Text50003@1100286117 :
        Text50003: TextConst ENU = 'There aren''t commissions supervised for this salesperson', ESP = 'No hay comisiones supervisadas asociadas al vendedor.';
        //       Text50004@1100286116 :
        Text50004: TextConst ENU = 'There is already the order %1 with the Purchase File No. %2', ESP = 'Ya existe el pedido %1 con este n�mero de expediente %2';
        //       Text50005@1100286115 :
        Text50005: TextConst ENU = 'There is, at least, 1 line which setup dones''t exists for this new %1. All the lines that don''t have the new setup will be deleted', ESP = 'Existe, al menos, 1 l�nea cuya configuraci�n no pertenece al nuevo %1 y se eliminar�n todas las l�neas que no lo cumplan.';
        //       Text50006@1100286114 :
        Text50006: TextConst ENU = 'There isn''t any setup of purchase code for this purchaser %1 and Cod Clasif1 %2', ESP = 'No existe configuraci�n de c�digo de compra para este comprador %1 y cod clasif1 %2';
        //       Text50007@1100286113 :
        Text50007: TextConst ENU = 'The order has been approved and cannot be deleted. You must end it or cancel it by sendin thehive file.', ESP = 'El pedido ha sido aprobado y no se puede eliminar. Debe finalizarlo o cancelarlo enviando a archivo.';
        //       Text50008@1100286112 :
        Text50008: TextConst ENU = 'The order has been canceled, finalized or deleted. You have to recover it manually', ESP = 'El pedido %1 ha sido cancelado, finalizado o eliminado. Debe recuperarlo manualmente.';
        //       Text50009@1100286111 :
        Text50009: TextConst ENU = 'The order %1 has not exit', ESP = 'El pedido %1 no existe.';
        //       Text50010@1100286110 :
        Text50010: TextConst ENU = 'There are already lines wiht Purchase Code setup and you cannot modify the Cod Clasif 1', ESP = 'Ya existen l�neas con c�digos de compra configurados y no puede modificar Cod Calsif 1';
        //       Text50011@1100286109 :
        Text50011: TextConst ENU = 'You cannot user the Purchaser Code %1 assigned to the vendor. It will be empty.', ESP = 'No puede utilizar el Cod. comprador %1 asignado al proveedor. Se dejar� en blanco';
        //       Text50012@1100286108 :
        Text50012: TextConst ENU = 'The invoice lines associated to others orders are going to be deleted. Do you want to continue?', ESP = 'Se van a eliminar las l�neas de la factura asociadas a otros pedidos. �Desea continuar?';
        //       Text50013@1100286107 :
        Text50013: TextConst ENU = 'You cannot change the Purchaser code in the invoice because it has orders in the lines', ESP = 'No puede cambiar el comprador porque la factura tiene pedidos asociados en las l�neas';
        //       Text50014@1100286106 :
        Text50014: TextConst ENU = 'You have to delete the lines with Purchase code before change the Purchaser Code', ESP = 'Debe eliminar las l�neas con C�digo de compra asociado para poder cambiar el c�digo de comprador';

    //     procedure Read (PurchaseHeader@1100286000 :
    procedure Read(PurchaseHeader: Record 38): Boolean;
    begin
        //Busca un registro, si no existe lo inicializa, retorna encontrado o no
        Rec.RESET;
        Rec.SETRANGE("Record Id", PurchaseHeader.RECORDID);
        if not Rec.FINDFIRST then begin
            Rec.INIT;
            Rec."Record Id" := PurchaseHeader.RECORDID;
            /*To Be Tested*/
            //Rec."Document Type" := PurchaseHeader."Document Type";
            Rec."Document Type" := ConvertDocumentTypeToOption(PurchaseHeader."Document Type");
            Rec."No." := PurchaseHeader."No.";
            Rec."QB_Buy-from Vendor No." := PurchaseHeader."Buy-from Vendor No.";
            Rec."QB_Applies-to ID" := PurchaseHeader."Applies-to ID";
            exit(FALSE);
        end;
        exit(TRUE)
    end;

    //Added method to handle enum type to option
    procedure ConvertDocumentTypeToOption(DocumentType: Enum "Purchase Document Type"): Option;
    var
        optionValue: Option "Quote","Order","Invoice","Credit Memo","Blanket Order","Return Order";
    begin
        case DocumentType of
            DocumentType::"Quote":
                optionValue := optionValue::"Quote";
            DocumentType::"Order":
                optionValue := optionValue::"Order";
            DocumentType::"Invoice":
                optionValue := optionValue::"Invoice";
            DocumentType::"Credit Memo":
                optionValue := optionValue::"Credit Memo";
            DocumentType::"Blanket Order":
                optionValue := optionValue::"Blanket Order";
            DocumentType::"Return Order":
                optionValue := optionValue::"Return Order";
            else
                Error('Invalid Document Type: %1', DocumentType);
        end;

        exit(optionValue);
    end;

    procedure Save()
    begin
        //Guarda el registro
        if not Rec.MODIFY then
            Rec.INSERT(TRUE);
    end;

    /*begin
    end.
  */
}







