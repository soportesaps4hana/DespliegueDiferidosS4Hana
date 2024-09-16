@AbapCatalog.sqlViewName: 'Z_FACT_NOTAC_HBT'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Vista facturas diferido nota credito'
define view Z_FACTURA_NOTACREDITO_HBT as select from I_BillingDocumentItem         as Lineas
    inner join            I_BillingDocument              as Encabezado on Lineas.BillingDocument = Encabezado.BillingDocument
    inner join            I_BillingDocumentItemPrcgElmnt as Precios    on  Precios.BillingDocument          = Lineas.BillingDocument                                                                                 
    inner join            I_BillingDocumentPartner       as Socios     on Socios.BillingDocument = Lineas.BillingDocument
    inner join            I_Customer                     as Cliente    on Cliente.Customer = Socios.Customer
    inner join            I_PartnerFunction              as funcion    on funcion.PartnerFunction = Socios.PartnerFunction
   
   
{
  key Encabezado.BillingDocument,
      Lineas.Product                                                                                   as Producto,
      Lineas.BillingDocumentItemText                                                                   as Descripcion,
      (Lineas.BillingQuantity  * (Lineas.NetAmount * 100))                                             as Valor_Neto,

      Lineas.SalesOrderDistributionChannel                                                             as Canal_de_distribucion_pedido,
      Lineas.SalesOrganization                                                                         as Centro,
      Lineas.ProfitCenter                                                                              as Centro_de_Beneficio,
      Lineas.CostCenter
                                                                                                       as Centro_de_Costo,

      Lineas.WBSElementInternalID                                                                      as Elemento_pep,

      Precios.ConditionType                                                                            as Clase_Condicion,
      Precios.ConditionRateValue                                                                       as Valor_Condicion,


      Lineas.SoldToParty                                                                               as Solicitante,
      Lineas.BillToParty                                                                               as Destinatario_Factura,
      Lineas.YY1_U_FechaInicio_BDI                                                                     as Fecha_de_Inicio,
      Lineas.YY1_U_ConceptoDif_BDI                                                                     as Concepto_Diferido,
      Lineas.YY1_U_Calendario_BDI                                                                      as Calendario,
      Lineas.BillingDocumentItem                                                                       as Linea,
      Lineas.YY1_U_MaestroDiferido_BDI                                                                 as Maestro_diferido,
      Socios.Customer                                                                                  as Socio,
      Cliente.BPCustomerFullName                                                                       as Tercero,
      Socios.Customer                                                                                  as Codigo_Tercero,
      Encabezado.BillingDocumentCategory                                                               as Clase,
      Encabezado.BillingDocumentType                                                                   as Tipo
      
      --Cliente.                                                                                       as Socio
      --Facturas.Codigo
      
        

}

where
  Lineas.YY1_U_ConceptoDif_BDI is not initial
  and Encabezado.BillingDocumentType = 'G2'
  and funcion.PartnerFunction = 'RE'
  --and Lineas.BillingDocument = '0090000516'
