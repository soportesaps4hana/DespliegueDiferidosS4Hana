@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Balance por terceros HBT'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Z_BALANCE_PRUEBA_TERCEROS_HBT
  with parameters
    FechaInicio : datum,
    FechaFin    : datum

  as select from    Z_ARBOL_PUC                                                    as Arbol
    left outer join Z_DEBITOS_CREDITOS_AUX (FechaInicial : $parameters.FechaInicio , FechaFinal : $parameters.FechaFin
                    )                                                              as Nivel1       on Arbol.Cuenta = Nivel1.GLAccount
    left outer join Z_DEBITOS_CREDITOS_AUX_N2 (FechaInicial : $parameters.FechaInicio , FechaFinal : $parameters.FechaFin
                    )                                                              as Nivel2       on Arbol.Cuenta = Nivel2.GLAccount


    left outer join Z_DEBITOS_CREDITOS_AUX_N3 (FechaInicial : $parameters.FechaInicio , FechaFinal : $parameters.FechaFin
                    )                                                              as Nivel3       on Arbol.Cuenta = Nivel3.GLAccount


    left outer join Z_DEBITOS_CREDITOS_AUX_N4 (FechaInicial : $parameters.FechaInicio , FechaFinal : $parameters.FechaFin
                    )                                                              as Nivel4       on Arbol.Cuenta = Nivel4.GLAccount


    left outer join Z_DEBITOS_CREDITOS_AUX_N5 (FechaInicial : $parameters.FechaInicio , FechaFinal : $parameters.FechaFin
                    )                                                              as Nivel5       on Arbol.Cuenta = Nivel5.GLAccount


    left outer join Z_DEBITOS_CREDITOS_AUX_N6 (FechaInicial : $parameters.FechaInicio , FechaFinal : $parameters.FechaFin
                    )                                                              as Nivel6       on Arbol.Cuenta = Nivel6.GLAccount
    left outer join Z_DEBITOS_CREDITOS_AUX_N7 (FechaInicial : $parameters.FechaInicio , FechaFinal : $parameters.FechaFin
                    )                                                              as Nivel7       on Arbol.Cuenta = Nivel7.GLAccount

    left outer join Z_DEBITOS_CREDITOS_AUX_N8 (FechaInicial : $parameters.FechaInicio , FechaFinal : $parameters.FechaFin
                    )                                                              as Nivel8       on Arbol.Cuenta = Nivel8.GLAccount

    left outer join Z_SALDOS_INICIALES_N1( FechaInicial: $parameters.FechaInicio ) as SaldosNivel1 on Arbol.Cuenta = SaldosNivel1.GLAccount

    left outer join Z_SALDOS_INICIALES_N2( FechaInicial: $parameters.FechaInicio ) as SaldosNivel2 on Arbol.Cuenta = SaldosNivel2.GLAccount
    left outer join Z_SALDOS_INICIALES_N3( FechaInicial: $parameters.FechaInicio ) as SaldosNivel3 on Arbol.Cuenta = SaldosNivel3.GLAccount
    left outer join Z_SALDOS_INICIALES_N4( FechaInicial: $parameters.FechaInicio ) as SaldosNivel4 on Arbol.Cuenta = SaldosNivel4.GLAccount
    left outer join Z_SALDOS_INICIALES_N5( FechaInicial: $parameters.FechaInicio ) as SaldosNivel5 on Arbol.Cuenta = SaldosNivel5.GLAccount
    left outer join Z_SALDOS_INICIALES_N6( FechaInicial: $parameters.FechaInicio ) as SaldosNivel6 on Arbol.Cuenta = SaldosNivel6.GLAccount

{
  key Arbol.Cuenta,
      Arbol.DigitoC,
      Arbol.Longitud,
      Arbol.Nivel_Cuenta,
      
      case when  Arbol.DigitoC = '008' and Arbol.Nombre_Cajon is null
      then 'Otros Gastos'
      when Arbol.DigitoC = '007' and Arbol.Nombre_Cajon is null
      then 'Costos de Produccion o de Operacion'
       when  Arbol.DigitoC = '006' and Arbol.Nombre_Cajon is null
      then 'Costos'
       when Arbol.DigitoC = '005' and Arbol.Nombre_Cajon is null
      then 'Gastos'
       when  Arbol.DigitoC = '004' and Arbol.Nombre_Cajon is null
      then 'Ingresos'
       when  Arbol.DigitoC = '003' and Arbol.Nombre_Cajon is null
      then 'Patrimonio'
       when  Arbol.DigitoC = '002' and Arbol.Nombre_Cajon is null
      then 'Pasivo'
       when  Arbol.DigitoC = '001' and Arbol.Nombre_Cajon is null
      then 'Activo'
       when Arbol.DigitoC = '009' and Arbol.Nombre_Cajon is null
      then '#9'
      else Arbol.Nombre_Cajon end as Nombre_Cajon ,

      case when  Arbol.Longitud = 3
      then SaldosNivel1.SI_Niv1
      when  Arbol.Longitud = 4
      then SaldosNivel2.SI_Niv2
        when  Arbol.Longitud = 5
        then SaldosNivel3.SI_Niv3
          when  Arbol.Longitud = 6
          then SaldosNivel4.SI_Niv4
            when  Arbol.Longitud = 7
            then SaldosNivel5.SI_Niv5
                   when  Arbol.Longitud = 8
                   then SaldosNivel6.SI_Niv6

      else 0
      end  as SaldoInicial,


      case when  Arbol.Longitud = 3
      then sum(Nivel1.DebitoAux)
      when Arbol.Longitud = 4
      then sum(Nivel2.DebitoAux)
        when Arbol.Longitud = 5
      then sum(Nivel3.DebitoAux)
        when Arbol.Longitud = 6
      then sum(Nivel4.DebitoAux)
        when Arbol.Longitud = 7
      then sum(Nivel5.DebitoAux)
          when Arbol.Longitud = 8
      then sum(Nivel6.DebitoAux)
        when Arbol.Longitud = 9
      then sum(Nivel7.DebitoAux)
       when Arbol.Longitud = 10
      then sum(Nivel8.DebitoAux)
      else 0
      end  as Debito,


      case when  Arbol.Longitud = 3
       then sum(Nivel1.CreditoAux)
        when Arbol.Longitud = 4
         then sum(Nivel2.CreditoAux)
             when Arbol.Longitud = 5
         then sum(Nivel3.CreditoAux)
           when Arbol.Longitud = 6
         then sum(Nivel4.CreditoAux)
           when Arbol.Longitud = 7
         then sum(Nivel5.CreditoAux)
              when Arbol.Longitud = 8
         then sum(Nivel6.CreditoAux)
          when Arbol.Longitud = 9
          then sum(Nivel7.CreditoAux)
              when Arbol.Longitud = 10
          then sum(Nivel8.CreditoAux)
       else 0
       end as Credito,


      case when Arbol.Longitud = 10
      then  Nivel8.AccountingDocument
      when Arbol.Longitud = 9
      then Nivel7.AccountingDocument
      else ''
      end  as AccountingDocument,

      case when Arbol.Longitud = 10
      then  Nivel8.LedgerGLLineItem
      when Arbol.Longitud = 9
      then  Nivel7.LedgerGLLineItem
      when Arbol.Longitud = 8
      then  Nivel6.LedgerGLLineItem
      else '0'
      end  as Linea,
      
      
      case when Arbol.Longitud = 10
      then Nivel8.Ref1
      when Arbol.Longitud = 9
      then Nivel7.Ref1
      when Arbol.Longitud = 8
      then Nivel6.Ref1
      else ''
      end  as NIT,


      case when Arbol.Longitud = 10
      then Nivel8.Ref2
      when Arbol.Longitud = 9
      then Nivel7.Ref2
         when Arbol.Longitud = 8
      then Nivel6.Ref2
      else ''
      end  as Codigo,


      case when Arbol.Longitud = 10
      then Nivel8.Ref3
      when Arbol.Longitud = 9
      then Nivel7.Ref3
        when Arbol.Longitud = 8
      then Nivel6.Ref3
      else ''
      end  as Nombre,


      case when Arbol.Longitud = 10
      then Nivel8.PostingDate
      when Arbol.Longitud = 9
      then Nivel7.PostingDate
      else ''
      end  as PostingDate,


      case when Arbol.Longitud = 10
      then  Nivel8.CompanyCode
      when Arbol.Longitud = 9
      then Nivel7.CompanyCode
      else Arbol.Company
      end  as CompanyCode,


      case when Arbol.Longitud = 10
      then  cast(Nivel8.FiscalYear as abap.int4)
      when Arbol.Longitud = 9
      then  cast(Nivel7.FiscalYear as abap.int4)
      else 0
      end  as FiscalYear,

      case when Arbol.Longitud = 10
      then  cast(Nivel8.FiscalPeriod as abap.int4)
      when Arbol.Longitud = 9
      then cast(Nivel7.FiscalPeriod as abap.int4)
      else 0
      end  as FiscalPeriod,

      case when Arbol.Longitud = 10
      then  Nivel8.TransactionCurrency
      when Arbol.Longitud = 9
      then Nivel7.TransactionCurrency
      else ''
      end  as TransactionCurrency,

      case when Arbol.Longitud = 10
      then  Nivel8.Centro
      when Arbol.Longitud = 9
      then Nivel7.Centro
      else ''
      end  as Centro,

      case when Arbol.Longitud = 10
      then  Nivel8.ProfitCenter
      when Arbol.Longitud = 9
      then Nivel7.ProfitCenter
      else ''
      end  as ProfitCenter,


      case when Arbol.Longitud = 10
      then  Nivel8.PartnerProfitCenter
      when Arbol.Longitud = 9
      then Nivel7.PartnerProfitCenter
      else ''
      end  as PartnerProfitCenter,

      case when Arbol.Longitud = 10
      then  Nivel8.CostCenter
      when Arbol.Longitud = 9
      then Nivel7.CostCenter
      else ''
      end  as CostCenter,

      case when Arbol.Longitud = 10
      then  Nivel8.TaxCode
      when Arbol.Longitud = 9
      then Nivel7.TaxCode
      else ''
      end  as TaxCode,

      case when Arbol.Longitud = 10
      then  cast(Nivel8.ReferenceDocumentItem as abap.int4)
      when Arbol.Longitud = 9
      then cast(Nivel7.ReferenceDocumentItem as abap.int4)
      else 0
      end  as ReferenceDocumentItem





}


group by
  Arbol.Cuenta,
  Arbol.DigitoC,
  Arbol.Longitud,
  Arbol.Nivel_Cuenta,
  Arbol.Nombre_Cajon,

  SaldosNivel1.SI_Niv1,
  SaldosNivel2.SI_Niv2,
  SaldosNivel3.SI_Niv3,
  SaldosNivel4.SI_Niv4,
  SaldosNivel5.SI_Niv5,
  SaldosNivel6.SI_Niv6,
  Nivel8.Ref1,
  Nivel7.Ref1,
  Nivel6.Ref1,
  Nivel8.Ref2,
  Nivel7.Ref2,
  Nivel6.Ref2,
  Nivel8.Ref3,
  Nivel7.Ref3,
  Nivel6.Ref3,
  Nivel8.PostingDate,
  Nivel7.PostingDate,
  Nivel8.CompanyCode,
  Nivel7.CompanyCode,
  Arbol.Company,
  Nivel8.FiscalYear,
  Nivel7.FiscalYear,
  Nivel8.FiscalPeriod,
  Nivel7.FiscalPeriod,
  Nivel8.TransactionCurrency,
  Nivel7.TransactionCurrency,
  Nivel8.Centro,
  Nivel7.Centro,
  Nivel8.ProfitCenter,
  Nivel7.ProfitCenter,
  Nivel8.PartnerProfitCenter,
  Nivel7.PartnerProfitCenter,
  Nivel7.AccountingDocument,
  Nivel8.AccountingDocument,
  Nivel8.CostCenter,
  Nivel7.CostCenter,
  Nivel8.TaxCode,
  Nivel7.TaxCode,
  Nivel8.ReferenceDocumentItem,
  Nivel7.ReferenceDocumentItem,
  Nivel8.LedgerGLLineItem,
  Nivel7.LedgerGLLineItem,
  Nivel6.LedgerGLLineItem
