create external table sales_order_header (
`SalesOrderID` int,          
`OrderDate` timestamp,             
`DueDate` timestamp,               
`ShipDate` timestamp,              
`Status` int,                
`SalesOrderNumber` string,      
`PurchaseOrderNumber` string,   
`AccountNumber` string,         
`CustomerID` int,            
`ContactID` int,           
`BillToAddressID`int,       
`ShipToAddressID` int,       
`ShipMethodID` int,          
`CreditCardID` int,          
`CreditCardApprovalCode` string,
`CurrencyRateID` int,        
`SubTotal` double,              
`TaxAmt` double,                
`Freight` double,               
`TotalDue` double,              
`Comment` string,              
`SalesPersonID` int, 
`TerritoryID` int,
`territory` string,
`CountryRegionCode` string ,
`ModifiedDate` timestamp
)
STORED AS ORC
LOCATION 'hdfs://node100:9000/zianvonjs_ds/v_salesorderheader_demo';


create external table customer_test (
`CustomerID` int,
`AccountNumber`  string,
`CustomerType` varchar(1),
`Demographics` string, 
`TerritoryID` int,
`ModifiedDate` timestamp
)
STORED AS ORC
LOCATION 'hdfs://node100:9000/zianvonjs_ds/v_customer';

create external table sales_order_details (
`SalesOrderDetailID` int,    
`SalesOrderID` int,
`CarrierTrackingNumber` string, 
`OrderQty` int,              
`ProductID` int,             
`UnitPrice` double,             
`UnitPriceDiscount` double,     
`LineTotal` double,       
`SpecialOfferID` int , 
`Description` string,
`DiscountPct` double,
`Type` string,
`Category` string,
`ModifiedDate` timestamp  
)
STORED AS ORC
LOCATION 'hdfs://node100:9000/zianvonjs_ds/v_salesorderdetails_demo';

create external table store_details (
`CustomerID` int,
`Name` string,
`SalesPersonID` int,
`Demographics` string,
`TerritoryID` int,
`SalesQuota` double,
`CommissionPct` double,
`SalesYTD` double,
`SalesLastYear` double,
`ModifiedDate` timestamp  
)
STORED AS ORC
LOCATION 'hdfs://node100:9000/zianvonjs_ds/v_stores';

create table creditcard (
`creditcardid` int,
`cardtype` string,
`cardnumber` string,
`expmonth` int,
`expyear` int,
`modifieddate` timestamp
)
STORED AS ORC
LOCATION 'hdfs://node100:9000/zianvonjs_ds/creditcard';


select * from customer_test;
select CustomerID,Demographics from customer_test;