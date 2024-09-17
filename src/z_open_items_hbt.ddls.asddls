@AbapCatalog.sqlViewName: 'Z_OPEN_ITEM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gestión de partidas abiertas'
define view Z_OPEN_ITEMS_HBT
    with parameters p_customer : z_customer_type
 as select from I_OperationalAcctgDocItem as open
 join I_JournalEntryItem as linea
    on open.AccountingDocument = linea.InvoiceReference
    and open.FiscalYear = linea.InvoiceReferenceFiscalYear
    and open.CompanyCode = linea.CompanyCode
 join I_JournalEntry as asiento 
    on linea.AccountingDocument = asiento.AccountingDocument
    and linea.FiscalYear = asiento.FiscalYear
    and linea.CompanyCode = asiento.CompanyCode
{

key linea.AccountingDocument,
key open.CompanyCode,
key linea.LedgerGLLineItem,
key open.FiscalYear,
linea.FiscalYear as LineFiscalYear,
linea.InvoiceReferenceFiscalYear,
linea.TransactionCurrency,
linea.InvoiceReference,
linea.ClearingJournalEntry,
linea.Customer,
cast(asiento.ExchangeRate  * 1000 as abap.dec(20,0) ) as exchange,
cast( linea.AmountInCompanyCodeCurrency * 100 as abap.dec(20,0)  ) as AmountInCompanyCodeCurrency,
cast( linea.AmountInTransactionCurrency  as abap.dec(20,0)  ) as AmountInTransactionCurrency
}

where (linea.Customer = $parameters.p_customer and linea.ClearingJournalEntry = '')
group by 
linea.AccountingDocument,
open.CompanyCode,
linea.LedgerGLLineItem,
open.FiscalYear,
linea.FiscalYear,
linea.InvoiceReferenceFiscalYear,
linea.TransactionCurrency,
linea.InvoiceReference,
linea.Customer,
linea.AmountInCompanyCodeCurrency,
 linea.AmountInTransactionCurrency,
asiento.ExchangeRate,
linea.ClearingJournalEntry
