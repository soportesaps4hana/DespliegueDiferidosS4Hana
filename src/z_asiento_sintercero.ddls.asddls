@Metadata.ignorePropagatedAnnotations: true
define view entity Z_ASIENTO_SINTERCERO as select from I_JournalEntry as asiento 
join I_JournalEntryItem as linea 
    on asiento.AccountingDocument = linea.AccountingDocument
    and asiento.CompanyCode = linea.CompanyCode
    and asiento.FiscalYear = linea.FiscalYear
    left outer join I_SupplierInvoiceAPI01 as factura
    on factura.SupplierInvoiceWthnFiscalYear = asiento.OriginalReferenceDocument
    and factura.CompanyCode = linea.CompanyCode
{

   
     key asiento.CompanyCode,
     key asiento.FiscalYear,
     key asiento.AccountingDocument,
     key linea.LedgerGLLineItem,
     factura.SupplierInvoice as ReferenceDocument, 
     case asiento.AccountingDocumentType
        when 'KP' then linea.Supplier
     else factura.InvoicingParty 
     end as SoldToParty,
     linea.YY1_HBTTercero_COB,
     linea.YY1_HBT_Tercero_S4_COB,
     asiento.ReferenceDocumentType,
     asiento.AccountingDocumentType
}
where asiento.ReferenceDocumentType = 'RMRP' and linea.YY1_HBT_Tercero_S4_COB = ''

group by     
    asiento.CompanyCode,
    asiento.FiscalYear,
    asiento.AccountingDocument,
    linea.LedgerGLLineItem,
    factura.SupplierInvoice,
    factura.InvoicingParty,
    linea.YY1_HBTTercero_COB,
    linea.YY1_HBT_Tercero_S4_COB,
    asiento.ReferenceDocumentType,
    asiento.AccountingDocumentType,
    linea.Supplier

union all  select from I_JournalEntry as asiento 
join I_JournalEntryItem as linea 
    on asiento.AccountingDocument = linea.AccountingDocument
    and asiento.CompanyCode = linea.CompanyCode
    and asiento.FiscalYear = linea.FiscalYear
join I_BillingDocument as factura
    on factura.BillingDocument = linea.ReferenceDocument

{
  key asiento.CompanyCode,
  key asiento.FiscalYear,
  key asiento.AccountingDocument,
  key linea.LedgerGLLineItem,
  linea.ReferenceDocument,
  factura.SoldToParty,
  linea.YY1_HBTTercero_COB,
  linea.YY1_HBT_Tercero_S4_COB,
  asiento.ReferenceDocumentType,
  asiento.AccountingDocumentType
}
where (linea.ReferenceDocumentType = 'VBRK' and linea.YY1_HBT_Tercero_S4_COB = '' )
group by 
  asiento.CompanyCode,
  asiento.FiscalYear,
  asiento.AccountingDocument,
  linea.LedgerGLLineItem,
  linea.ReferenceDocument,
  factura.SoldToParty,
  linea.YY1_HBTTercero_COB,
  linea.YY1_HBT_Tercero_S4_COB,
  asiento.ReferenceDocumentType,
  asiento.AccountingDocumentType

union all select from I_JournalEntry as asiento
    join I_JournalEntryItem as linea 
      on asiento.AccountingDocument = linea.AccountingDocument
      and asiento.CompanyCode = linea.CompanyCode
      and asiento.FiscalYear = linea.FiscalYear
    join I_GoodsMovementCube as factura
      on factura.MaterialDocument = linea.ReferenceDocument
      and (asiento.AccountingDocumentType = 'WA' or asiento.AccountingDocumentType = 'WL' or asiento.AccountingDocumentType = 'WE' )
{
  key asiento.CompanyCode,
  key asiento.FiscalYear,
  key asiento.AccountingDocument,
  key linea.LedgerGLLineItem,
  linea.ReferenceDocument,
  case asiento.AccountingDocumentType
    when 'WA' then linea.YY1_HBT_Tercero_S4_COB
    when 'WL' then factura.Customer
    when 'WE' then factura.Supplier
    else null
  end as SoldToParty,
  linea.YY1_HBTTercero_COB,
  linea.YY1_HBT_Tercero_S4_COB,
  asiento.ReferenceDocumentType,
  asiento.AccountingDocumentType
}
where (asiento.ReferenceDocumentType = 'MKPF' and linea.YY1_HBT_Tercero_S4_COB = '')
group by
  asiento.CompanyCode,
  asiento.FiscalYear,
  asiento.AccountingDocument,
  linea.LedgerGLLineItem,
  linea.ReferenceDocument,
  linea.YY1_HBTTercero_COB,
  linea.YY1_HBT_Tercero_S4_COB,
  asiento.ReferenceDocumentType,
  asiento.AccountingDocumentType, 
  factura.Customer,
  factura.Supplier

union all select from I_JournalEntry as asiento 
join I_JournalEntryItem as linea 
    on asiento.AccountingDocument = linea.AccountingDocument
    and asiento.CompanyCode = linea.CompanyCode
    and asiento.FiscalYear = linea.FiscalYear

{

     key asiento.CompanyCode,
     key asiento.FiscalYear,
     key asiento.AccountingDocument,
     key linea.LedgerGLLineItem,
     linea.ReferenceDocument as ReferenceDocument,
     case asiento.AccountingDocumentType
        when 'KZ' then linea.Supplier
        when 'SU' then linea.Supplier
        when 'DR' then linea.Customer
        when 'DZ' then linea.Customer
     else linea.YY1_HBT_Tercero_S4_COB 
     end as SoldToParty, 
     linea.YY1_HBTTercero_COB,
     linea.YY1_HBT_Tercero_S4_COB,
     asiento.ReferenceDocumentType,
     asiento.AccountingDocumentType
}
where asiento.ReferenceDocumentType = 'BKPFF' and linea.YY1_HBT_Tercero_S4_COB = '' and (asiento.AccountingDocumentType <> 'SA' and asiento.AccountingDocumentType <> 'RT' and asiento.AccountingDocumentType <> 'AB') 

group by     
    asiento.CompanyCode,
    asiento.FiscalYear,
    asiento.AccountingDocument,
    linea.LedgerGLLineItem,
    linea.ReferenceDocument,
    linea.YY1_HBTTercero_COB,
    linea.YY1_HBT_Tercero_S4_COB,
    asiento.ReferenceDocumentType,
    asiento.AccountingDocumentType,
    linea.Supplier,
    linea.Customer


union all  select from I_JournalEntry as asiento 
join I_JournalEntryItem as linea 
    on asiento.AccountingDocument = linea.AccountingDocument
    and asiento.CompanyCode = linea.CompanyCode
    and asiento.FiscalYear = linea.FiscalYear

{

   
     key asiento.CompanyCode,
     key asiento.FiscalYear,
     key asiento.AccountingDocument,
     key linea.LedgerGLLineItem,
     linea.ReferenceDocument as ReferenceDocument,
     case asiento.AccountingDocumentType
        when 'DR' then linea.Customer
        when 'ZP' then linea.Supplier
    else null
    end as SoldToParty, 
     linea.YY1_HBTTercero_COB,
     linea.YY1_HBT_Tercero_S4_COB,
     asiento.ReferenceDocumentType,
     asiento.AccountingDocumentType
     

}
where asiento.ReferenceDocumentType = 'BKPF' and linea.YY1_HBT_Tercero_S4_COB = ''

group by     
    asiento.CompanyCode,
    asiento.FiscalYear,
    asiento.AccountingDocument,
    linea.LedgerGLLineItem,
    linea.ReferenceDocument,
    linea.YY1_HBTTercero_COB,
    linea.YY1_HBT_Tercero_S4_COB,
    asiento.ReferenceDocumentType,
    asiento.AccountingDocumentType,
    linea.Customer,
    linea.Supplier
    
union all select from I_JournalEntry as asiento 
join I_JournalEntryItem as linea 
    on asiento.AccountingDocument = linea.AccountingDocument
    and asiento.CompanyCode = linea.CompanyCode
    and asiento.FiscalYear = linea.FiscalYear

{

   
     key asiento.CompanyCode,
     key asiento.FiscalYear,
     key asiento.AccountingDocument,
     key linea.LedgerGLLineItem,
     linea.ReferenceDocument as ReferenceDocument,
     linea.Customer as SoldToParty,
     linea.YY1_HBTTercero_COB,
     linea.YY1_HBT_Tercero_S4_COB,
     asiento.ReferenceDocumentType,
     asiento.AccountingDocumentType
     

}
where asiento.ReferenceDocumentType = 'CATS' and linea.YY1_HBT_Tercero_S4_COB = ''

group by     
    asiento.CompanyCode,
    asiento.FiscalYear,
    asiento.AccountingDocument,
    linea.LedgerGLLineItem,
    linea.ReferenceDocument,
    linea.YY1_HBTTercero_COB,
    linea.YY1_HBT_Tercero_S4_COB,
    asiento.ReferenceDocumentType,
    asiento.AccountingDocumentType,
    linea.Customer
       

union all select from I_JournalEntry as asiento 
join I_JournalEntryItem as linea 
    on asiento.AccountingDocument = linea.AccountingDocument
    and asiento.CompanyCode = linea.CompanyCode
    and asiento.FiscalYear = linea.FiscalYear

{

   
     key asiento.CompanyCode,
     key asiento.FiscalYear,
     key asiento.AccountingDocument,
     key linea.LedgerGLLineItem,
     linea.ReferenceDocument as ReferenceDocument,
     linea.YY1_HBT_Tercero_S4_COB as SoldToParty,
     linea.YY1_HBTTercero_COB,
     linea.YY1_HBT_Tercero_S4_COB,
     asiento.ReferenceDocumentType,
     asiento.AccountingDocumentType
     

}
where asiento.ReferenceDocumentType = 'AMBU' and linea.YY1_HBT_Tercero_S4_COB = ''

group by     
    asiento.CompanyCode,
    asiento.FiscalYear,
    asiento.AccountingDocument,
    linea.LedgerGLLineItem,
    linea.ReferenceDocument,
    linea.YY1_HBTTercero_COB,
    linea.YY1_HBT_Tercero_S4_COB,
    asiento.ReferenceDocumentType,
    asiento.AccountingDocumentType,
    linea.Customer
    
union all select from I_JournalEntry as asiento 
join I_JournalEntryItem as linea 
    on asiento.AccountingDocument = linea.AccountingDocument
    and asiento.CompanyCode = linea.CompanyCode
    and asiento.FiscalYear = linea.FiscalYear

{

   
     key asiento.CompanyCode,
     key asiento.FiscalYear,
     key asiento.AccountingDocument,
     key linea.LedgerGLLineItem,
     linea.ReferenceDocument as ReferenceDocument,
     linea.YY1_HBT_Tercero_S4_COB as SoldToParty,
     linea.YY1_HBTTercero_COB,
     linea.YY1_HBT_Tercero_S4_COB,
     asiento.ReferenceDocumentType,
     asiento.AccountingDocumentType
     

}
where asiento.ReferenceDocumentType = 'PRCHG' and linea.YY1_HBT_Tercero_S4_COB = ''

group by     
    asiento.CompanyCode,
    asiento.FiscalYear,
    asiento.AccountingDocument,
    linea.LedgerGLLineItem,
    linea.ReferenceDocument,
    linea.YY1_HBTTercero_COB,
    linea.YY1_HBT_Tercero_S4_COB,
    asiento.ReferenceDocumentType,
    asiento.AccountingDocumentType

union all select from I_JournalEntry as asiento 
join I_JournalEntryItem as linea 
    on asiento.AccountingDocument = linea.AccountingDocument
    and asiento.CompanyCode = linea.CompanyCode
    and asiento.FiscalYear = linea.FiscalYear

{

   
     key asiento.CompanyCode,
     key asiento.FiscalYear,
     key asiento.AccountingDocument,
     key linea.LedgerGLLineItem,
     linea.ReferenceDocument as ReferenceDocument,
     linea.YY1_HBT_Tercero_S4_COB as SoldToParty,
     linea.YY1_HBTTercero_COB,
     linea.YY1_HBT_Tercero_S4_COB,
     asiento.ReferenceDocumentType,
     asiento.AccountingDocumentType
     

}
where asiento.ReferenceDocumentType = 'AS91' and linea.YY1_HBT_Tercero_S4_COB = ''

group by     
    asiento.CompanyCode,
    asiento.FiscalYear,
    asiento.AccountingDocument,
    linea.LedgerGLLineItem,
    linea.ReferenceDocument,
    linea.YY1_HBTTercero_COB,
    linea.YY1_HBT_Tercero_S4_COB,
    asiento.ReferenceDocumentType,
    asiento.AccountingDocumentType
    
union all select from I_JournalEntry as asiento 
join I_JournalEntryItem as linea 
    on asiento.AccountingDocument = linea.AccountingDocument
    and asiento.CompanyCode = linea.CompanyCode
    and asiento.FiscalYear = linea.FiscalYear

{

   
     key asiento.CompanyCode,
     key asiento.FiscalYear,
     key asiento.AccountingDocument,
     key linea.LedgerGLLineItem,
     linea.ReferenceDocument as ReferenceDocument,
     case asiento.AccountingDocumentType
        when 'DZ' then linea.Customer
        when 'KZ' then linea.Supplier
    else null
    end as SoldToParty,
     linea.YY1_HBTTercero_COB,
     linea.YY1_HBT_Tercero_S4_COB,
     asiento.ReferenceDocumentType,
     asiento.AccountingDocumentType
     

}
where asiento.ReferenceDocumentType = 'CAJO' and linea.YY1_HBT_Tercero_S4_COB = ''

group by     
    asiento.CompanyCode,
    asiento.FiscalYear,
    asiento.AccountingDocument,
    linea.LedgerGLLineItem,
    linea.ReferenceDocument,
    linea.YY1_HBTTercero_COB,
    linea.YY1_HBT_Tercero_S4_COB,
    asiento.ReferenceDocumentType,
    asiento.AccountingDocumentType,
    linea.Customer,
    linea.Supplier
    
union all select from I_JournalEntry as asiento 
join I_JournalEntryItem as linea 
    on asiento.AccountingDocument = linea.AccountingDocument
    and asiento.CompanyCode = linea.CompanyCode
    and asiento.FiscalYear = linea.FiscalYear

{

   
     key asiento.CompanyCode,
     key asiento.FiscalYear,
     key asiento.AccountingDocument,
     key linea.LedgerGLLineItem,
     linea.ReferenceDocument as ReferenceDocument,
     case asiento.AccountingDocumentType
        when 'RR' then linea.Customer
        when 'CO' then linea.Customer
     else null
     end as SoldToParty,
     linea.YY1_HBTTercero_COB,
     linea.YY1_HBT_Tercero_S4_COB,
     asiento.ReferenceDocumentType,
     asiento.AccountingDocumentType
     

}
where asiento.ReferenceDocumentType = 'COBK' and linea.YY1_HBT_Tercero_S4_COB = ''

group by     
    asiento.CompanyCode,
    asiento.FiscalYear,
    asiento.AccountingDocument,
    linea.LedgerGLLineItem,
    linea.ReferenceDocument,
    linea.YY1_HBTTercero_COB,
    linea.YY1_HBT_Tercero_S4_COB,
    asiento.ReferenceDocumentType,
    asiento.AccountingDocumentType,
    linea.Customer
    
union all select from I_JournalEntry as asiento 
join I_JournalEntryItem as linea 
    on asiento.AccountingDocument = linea.AccountingDocument
    and asiento.CompanyCode = linea.CompanyCode
    and asiento.FiscalYear = linea.FiscalYear

{

   
     key asiento.CompanyCode,
     key asiento.FiscalYear,
     key asiento.AccountingDocument,
     key linea.LedgerGLLineItem,
     linea.ReferenceDocument as ReferenceDocument,
     linea.YY1_HBT_Tercero_S4_COB as SoldToParty,
     linea.YY1_HBTTercero_COB,
     linea.YY1_HBT_Tercero_S4_COB,
     asiento.ReferenceDocumentType,
     asiento.AccountingDocumentType
     

}
where asiento.ReferenceDocumentType = 'MYDLT' and linea.YY1_HBT_Tercero_S4_COB = ''
