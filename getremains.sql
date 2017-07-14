SELECT        TOP (100) PERCENT
 dbo.LOT.ID_GOODS, 					
 dbo.GOODS.NAME, 					
 dbo.PRODUCER.NAME AS prod_name, 			
 dbo.COUNTRY.NAME AS cnt_name, 				
 dbo.LOT.QUANTITY_REM, 				
 dbo.LOT.PRICE_SAL, 					
 EXTERNAL_BARCODE = (select top 1 code from BAR_CODE where BAR_CODE.id_goods = dbo.lot.id_goods and DATE_DELETED IS null  ) , 
 dbo.LOT.INTERNAL_BARCODE, 				
 dbo.STORE.NAME AS Sklad, 				
 dbo.GOODS.IMPORTANT,  				
 dbo.SERIES.BEST_BEFORE, 				
 dbo.SERIES.SERIES_NUMBER , 			
 dbo.LOT.PRICE_PROD,					
  dbo.LOT.PRICE_SUP, 					
 dbo.LOT.PVAT_SUP, 					
 dbo.LOT.VAT_SUP, 					
 dbo.LOT.VAT_SAL, 				
 dbo.LOT.PVAT_SAL, 					
 dbo.LOT.REGISTER_PRICE, 				
 dbo.LOT.VAT_SUP, 
 dbo.SCALING_RATIO.DENOMINATOR, 		
 dbo.SCALING_RATIO.NUMERATOR, 				
 dbo.REG_CERT.NAME AS Cert, 				
 dbo.CONTRACTOR.NAME as Contractor						
FROM					 dbo.LOT INNER JOIN
                         dbo.GOODS ON dbo.LOT.ID_GOODS = dbo.GOODS.ID_GOODS INNER JOIN
                         dbo.PRODUCER ON dbo.GOODS.ID_PRODUCER = dbo.PRODUCER.ID_PRODUCER INNER JOIN
                         dbo.STORE ON dbo.LOT.ID_STORE = dbo.STORE.ID_STORE INNER JOIN
                         dbo.SCALING_RATIO ON dbo.LOT.ID_SCALING_RATIO = dbo.SCALING_RATIO.ID_SCALING_RATIO AND 
                         dbo.GOODS.ID_GOODS = dbo.SCALING_RATIO.ID_GOODS LEFT OUTER JOIN
                         dbo.SERIES ON dbo.LOT.ID_SERIES = dbo.SERIES.ID_SERIES AND dbo.GOODS.ID_GOODS = dbo.SERIES.ID_GOODS LEFT OUTER JOIN
                         dbo.REG_CERT ON dbo.LOT.ID_REG_CERT_GLOBAL = dbo.REG_CERT.ID_REG_CERT_GLOBAL LEFT OUTER JOIN
                         dbo.COUNTRY ON dbo.PRODUCER.ID_COUNTRY = dbo.COUNTRY.ID_COUNTRY LEFT OUTER JOIN
                         dbo.CONTRACTOR ON dbo.STORE.ID_CONTRACTOR= dbo.CONTRACTOR.ID_CONTRACTOR
WHERE        (dbo.LOT.QUANTITY_REM > 0) 
and (dbo.CONTRACTOR.NAME like '%!Contractor!%'   )
ORDER BY dbo.GOODS.NAME
