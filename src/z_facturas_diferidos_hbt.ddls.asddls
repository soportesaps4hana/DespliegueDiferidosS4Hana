@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Vista de las facturas para diferidos'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Z_FACTURAS_DIFERIDOS_HBT as select distinct from Z_FACTURA_DIFERIDO_HBT
{
    key BillingDocument,
    Producto,
    Descripcion,
    Valor_Neto,
    Canal_de_distribucion_pedido,
    Centro,
    Centro_de_Beneficio,
    Centro_de_Costo,
    Elemento_pep,
    Clase_Condicion,
    Valor_Condicion,
    Solicitante,
    Destinatario_Factura,
    Fecha_de_Inicio,
    Concepto_Diferido,
    Calendario,
    Linea,
    Maestro_diferido,
    Socio,
    Tercero,
    Codigo_Tercero
    
}
