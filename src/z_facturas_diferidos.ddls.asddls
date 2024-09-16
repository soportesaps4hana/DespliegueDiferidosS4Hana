@AbapCatalog.sqlViewName: 'ZDIFESQL'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Vista facturas diferido'
define view Z_FACTURAS_DIFERIDOS as select from I_BillingDocumentItem          as Lineas
  -- inner join YY1_HBTCONDIFEDET_HBTCONDIF as conceptos on Lineas.YY1_U_ConceptoDif_BDI = conceptos.U_CodConc
    inner join            I_BillingDocument              as Encabezado on Lineas.BillingDocument = Encabezado.BillingDocument
    inner join            I_BillingDocumentItemPrcgElmnt as Precios    on  Precios.BillingDocument          = Lineas.BillingDocument
                                                                       and Precios.ConditionRateValue       > 0
                                                                       and Precios.ConditionCalculationType = 'C' and Precios.ConditionCategory is initial
    inner join            I_BillingDocumentPartner       as Socios     on Socios.BillingDocument = Encabezado.BillingDocument
    inner join            I_Customer                     as cliente    on Socios.AddressID = cliente.AddressID
    --left outer join       Z_FACT_DIFERIDO_PR             as Facturas   on Facturas.Codigo <> Encabezado.BillingDocument
{
  key Encabezado.BillingDocument,
      Lineas.Product                                                                                   as Producto,
      Lineas.BillingDocumentItemText                                                                   as Descripcion,
      (Lineas.BillingQuantity  * (Lineas.NetAmount * 100))                                             as Valor_Neto,

      Lineas.SalesOrderDistributionChannel                                                             as Canal_de_distribucion_pedido,
      Lineas.SalesOrganization                                                                         as Centro,
      Lineas.ProfitCenter                                                                              as Centro_de_Beneficio,
      case when Lineas.CostCenter is initial
      then '0'
      else Lineas.CostCenter
      end                                                                                              as Centro_de_Costo,

      Lineas.WBSElement                                                                                as Elemento_pep,

      Precios.ConditionType                                                                            as Clase_Condicion,
      Precios.ConditionRateValue                                                                       as Valor_Condicion,


      concat(concat(concat(cliente.StreetName , ''),cliente.CityName),concat(', ',cliente.PostalCode)) as Solicitante,
      concat(concat(concat(cliente.StreetName , ''),cliente.CityName),concat(', ',cliente.PostalCode)) as Destinatario_Factura,
      Lineas.YY1_U_FechaInicio_BDI                                                                     as Fecha_de_Inicio,
      Lineas.YY1_U_ConceptoDif_BDI                                                                     as Concepto_Diferido,
      Lineas.YY1_U_Calendario_BDI                                                                      as Calendario



}

where
  Lineas.YY1_U_ConceptoDif_BDI is not initial 
  --and Precios.ConditionBaseValue >0

  
