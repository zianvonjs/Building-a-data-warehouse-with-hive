# 项目名：datawarehouse_spark

## 项目简介

本项目旨在构建一个基于Apache Hive的数据仓库，面向电商业务场景，实现销售和客户数据的全流程ETL与分析。数据从MySQL通过datax导入到HDFS，利用Spark（Scala）完成数据清洗和格式转换，最后存储于Hive表中进行分析。项目部署于AWS EC2实例，借助Docker容器实现环境隔离和快速搭建。

## 项目架构

        +---------------------+
        |   MySQL 数据库源   |
        +---------------------+
                  |
                  | ① 使用 datax 导出数据
                  v
        +---------------------+
        |     Hadoop HDFS     |
        +---------------------+
                  |
        +---------+---------+
        |                   |
        |                   |
  ② Hive 外部表     ③ Spark（Scala）
        |                   |
        v                   v
 Hive SQL 分析        数据清洗与转换（生成 Parquet 文件）
                            |
                            v
                    Parquet 格式数据
                            |
                            v
                      Hive 内部表
                            |
                            v
                   Hive SQL 分析查询


架构包括：
- 数据源：MySQL关系型数据库
- 数据导入：datax导入MySQL数据至HDFS
- 数据存储：HDFS存储原始数据，Hive建表存储结构化数据
- 数据处理：Spark（Scala）进行数据转换，生成Parquet文件
- 分析查询：Hive执行SQL分析报表
- 部署环境：AWS EC2

## 技术栈

- 编程语言：SQL, Python3
- 大数据组件：Hive,Hadoop,datax,HDFS,Spark
- 虚拟机：VMware,MOBAXterm
- 云服务：AWS EC2

## 项目步骤

### 1. 启动VMware虚拟机

- 启动VMware上装了Linux系统的虚拟机,部署Hadoop、Hive、Spark等大数据组件，是整个数据仓库项目的运行平台。

### 2. 启动MOBAXterm

- 运行MOBAXterm,远程终端工具，可以通过SSH连接到你的Linux虚拟机，方便你在本地进行远程操作、文件传输和命令行管理。
- 为后续的数据导入、处理和分析搭建好基础环境，确保你可以顺利远程管理和操作Linux虚拟机上的大数据服务。

### 3. 创建MySQL表并导入数据

- 在MySQL中创建电商相关表（示例SQL见`mysql_code/mysql_create&insert.sql`）
- 导入样例数据
- 创建相关视图（示例SQL见`mysql_code/views creation in mysql.sql`）
- 这些视图 简化了 SQL 查询逻辑，避免每次分析数据都手动写复杂的 JOIN，对开发报表、做数据分析或做数仓ETL都非常有帮助。

- 表数据量统计
1. customer_test - 301
2. individual_test - 300
3. ccard - 311
4. store - 701
5. salesterritory - 10
6. salesperson - 17
7. salesorderheader - 1076
8. salesorderdetail - 2410
9. specialoffer - 16
  
### 4. 使用datax导入数据到HDFS

v_salesorderheader_demo从mysql导入hdfs
```json
{
  "job": {
    "setting": {
      "speed": {
        "channel": 2
      }
    },
    "content": [
      {
        "reader": {
          "name": "mysqlreader",
          "parameter": {
            "username": "root",
            "password": "hadoop",
            "splitPk": "SalesOrderID",
            "column": [
              "SalesOrderID",
              "OrderDate",
              "DueDate",
              "ShipDate",
              "Status",
              "SalesOrderNumber",
              "PurchaseOrderNumber",
              "AccountNumber",
              "CustomerID",
              "ContactID",
              "BillToAddressID",
              "ShipToAddressID",
              "ShipMethodID",
              "CreditCardID",
              "CreditCardApprovalCode",
              "CurrencyRateID",
              "SubTotal",
              "TaxAmt",
              "Freight",
              "TotalDue",
              "Comment",
              "SalesPersonID",
              "TerritoryID",
              "territory",
              "CountryRegionCode",
              "ModifiedDate"
            ],
            "connection": [
              {
                "table": [
                  "v_salesorderheader_demo"
                ],
                "jdbcUrl": [
                  "jdbc:mysql://192.168.5.100:3306/zianvonjs?useUnicode=true&characterEncoding=utf8&useSSL=false"
                ]
              }
            ]
          }
        },
        "writer": {
          "name": "hdfswriter",
          "parameter": {
            "defaultFS": "hdfs://node100:9000",
            "fileName": "salesorderheader.orc",
            "fieldDelimiter": "\t",
            "fileType": "orc",
            "path": "/zianvonjs_ds/v_salesorderheader_demo/",
            "column": [
              { "name": "SalesOrderID", "type": "bigint" },
              { "name": "OrderDate", "type": "string" },
              { "name": "DueDate", "type": "string" },
              { "name": "ShipDate", "type": "string" },
              { "name": "Status", "type": "int" },
              { "name": "SalesOrderNumber", "type": "string" },
              { "name": "PurchaseOrderNumber", "type": "string" },
              { "name": "AccountNumber", "type": "string" },
              { "name": "CustomerID", "type": "bigint" },
              { "name": "ContactID", "type": "bigint" },
              { "name": "BillToAddressID", "type": "bigint" },
              { "name": "ShipToAddressID", "type": "bigint" },
              { "name": "ShipMethodID", "type": "bigint" },
              { "name": "CreditCardID", "type": "bigint" },
              { "name": "CreditCardApprovalCode", "type": "string" },
              { "name": "CurrencyRateID", "type": "bigint" },
              { "name": "SubTotal", "type": "double" },
              { "name": "TaxAmt", "type": "double" },
              { "name": "Freight", "type": "double" },
              { "name": "TotalDue", "type": "double" },
              { "name": "Comment", "type": "string" },
              { "name": "SalesPersonID", "type": "bigint" },
              { "name": "TerritoryID", "type": "bigint" },
              { "name": "territory", "type": "string" },
              { "name": "CountryRegionCode", "type": "string" },
              { "name": "ModifiedDate", "type": "string" }
            ],
            "writeMode": "truncate",
            "compression": "none"
          }
        }
      }
    ]
  }
}
```

v_salesorderdetails_demo从mysql导入hdfs
```json
{
  "job": {
    "setting": {
      "speed": {
        "channel": 2
      }
    },
    "content": [
      {
        "reader": {
          "name": "mysqlreader",
          "parameter": {
            "username": "root",
            "password": "hadoop",
            "splitPk": "SalesOrderID",
            "column": [
              "SalesOrderDetailID",
              "SalesOrderID",
              "CarrierTrackingNumber",
              "OrderQty",
              "ProductID",
              "UnitPrice",
              "UnitPriceDiscount",
              "LineTotal",
              "SpecialOfferID",
              "Description",
              "DiscountPct",
              "Type",
              "Category",
              "ModifiedDate"
            ],
            "connection": [
              {
                "table": [
                  "v_salesorderdetails_demo"
                ],
                "jdbcUrl": [
                  "jdbc:mysql://192.168.5.100:3306/zianvonjs?useUnicode=true&characterEncoding=utf8&useSSL=false"
                ]
              }
            ]
          }
        },
        "writer": {
          "name": "hdfswriter",
          "parameter": {
            "defaultFS": "hdfs://node100:9000",
            "fileName": "salesorderdetails.orc",
            "fieldDelimiter": "\t",
            "fileType": "orc",
            "path": "/zianvonjs_ds/v_salesorderdetails_demo/",
            "column": [
              { "name": "SalesOrderDetailID", "type": "bigint" },
              { "name": "SalesOrderID", "type": "bigint" },
              { "name": "CarrierTrackingNumber", "type": "string" },
              { "name": "OrderQty", "type": "bigint" },
              { "name": "ProductID", "type": "bigint" },
              { "name": "UnitPrice", "type": "double" },
              { "name": "UnitPriceDiscount", "type": "double" },
              { "name": "LineTotal", "type": "double" },
              { "name": "SpecialOfferID", "type": "bigint" },
              { "name": "Description", "type": "string" },
              { "name": "DiscountPct", "type": "double" },
              { "name": "Type", "type": "string" },
              { "name": "Category", "type": "string" },
              { "name": "ModifiedDate", "type": "string" }
            ],
            "writeMode": "truncate",
            "compression": "none"
          }
        }
      }
    ]
  }
}
```

v_stores从mysql导入hdfs
```json
{
  "job": {
    "setting": {
      "speed": {
        "channel": 2
      }
    },
    "content": [
      {
        "reader": {
          "name": "mysqlreader",
          "parameter": {
            "username": "root",
            "password": "hadoop",
            "splitPk": "CustomerID",
            "column": [
              "CustomerID",
              "Name",
              "SalesPersonID",
              "Demographics",
              "TerritoryID",
              "SalesQuota",
              "CommissionPct",
              "SalesYTD",
              "SalesLastYear",
              "ModifiedDate"
            ],
            "connection": [
              {
                "table": [
                  "v_stores"
                ],
                "jdbcUrl": [
                  "jdbc:mysql://192.168.5.100:3306/zianvonjs?useUnicode=true&characterEncoding=utf8&useSSL=false"
                ]
              }
            ]
          }
        },
        "writer": {
          "name": "hdfswriter",
          "parameter": {
            "defaultFS": "hdfs://node100:9000",
            "fileName": "vstores.orc",
            "fieldDelimiter": "\t",
            "fileType": "orc",
            "path": "/zianvonjs_ds/v_stores/",
            "column": [
              { "name": "CustomerID", "type": "bigint" },
              { "name": "Name", "type": "string" },
              { "name": "SalesPersonID", "type": "bigint" },
              { "name": "Demographics", "type": "string" },
              { "name": "TerritoryID", "type": "bigint" },
              { "name": "SalesQuota", "type": "double" },
              { "name": "CommissionPct", "type": "double" },
              { "name": "SalesYTD", "type": "double" },
              { "name": "SalesLastYear", "type": "double" },
              { "name": "ModifiedDate", "type": "string" }
            ],
            "writeMode": "truncate",
            "compression": "none"
          }
        }
      }
    ]
  }
}

```

v_customer从mysql导入hdfs
```json
{
  "job": {
    "setting": {
      "speed": {
        "channel": 2
      }
    },
    "content": [
      {
        "reader": {
          "name": "mysqlreader",
          "parameter": {
            "username": "root",
            "password": "hadoop",
            "splitPk": "CustomerID",
            "column": [
              "CustomerID",
              "AccountNumber",
              "CustomerType",
              "Demographics",
              "TerritoryID",
              "ModifiedDate"
            ],
            "connection": [
              {
                "table": [
                  "v_customer"
                ],
                "jdbcUrl": [
                  "jdbc:mysql://192.168.5.100:3306/zianvonjs?useUnicode=true&characterEncoding=utf8&useSSL=false"
                ]
              }
            ]
          }
        },
        "writer": {
          "name": "hdfswriter",
          "parameter": {
            "defaultFS": "hdfs://node100:9000",
            "fileName": "vcustomer.orc",
            "fieldDelimiter": "\t",
            "fileType": "orc",
            "path": "/zianvonjs_ds/v_customer/",
            "column": [
              { "name": "CustomerID", "type": "bigint" },
              { "name": "AccountNumber", "type": "string" },
              { "name": "CustomerType", "type": "string" },
              { "name": "Demographics", "type": "string" },
              { "name": "TerritoryID", "type": "bigint" },
              { "name": "ModifiedDate", "type": "string" }
            ],
            "writeMode": "truncate",
            "compression": "none"
          }
        }
      }
    ]
  }
}
```

ccard从mysql导入hdfs
```json
{
  "job": {
    "setting": {
      "speed": {
        "channel": 2
      }
    },
    "content": [
      {
        "reader": {
          "name": "mysqlreader",
          "parameter": {
            "username": "root",
            "password": "hadoop",
            "splitPk": "CreditCardID",
            "column": [
              "CreditCardID",
              "CardType",
              "CardNumber",
              "ExpMonth",
              "ExpYear",
              "ModifiedDate"
            ],
            "connection": [
              {
                "table": [
                  "ccard"
                ],
                "jdbcUrl": [
                  "jdbc:mysql://192.168.5.100:3306/zianvonjs?useUnicode=true&characterEncoding=utf8&useSSL=false"
                ]
              }
            ]
          }
        },
        "writer": {
          "name": "hdfswriter",
          "parameter": {
            "defaultFS": "hdfs://node100:9000",
            "fileName": "ccard.orc",
            "fieldDelimiter": "\t",
            "fileType": "orc",
            "path": "/zianvonjs_ds/creditcard/",
            "column": [
              { "name": "CreditCardID", "type": "bigint" },
              { "name": "CardType", "type": "string" },
              { "name": "CardNumber", "type": "string" },
              { "name": "ExpMonth", "type": "bigint" },
              { "name": "ExpYear", "type": "bigint" },
              { "name": "ModifiedDate", "type": "string" }
            ],
            "writeMode": "truncate",
            "compression": "none"
          }
        }
      }
    ]
  }
}
```

# 虚拟机命令行窗口中检查数据是否成功导入

hdfs dfs -ls -R /zianvonjs_ds/

### 5. Hive建表并加载数据

```hql
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
```

### 6. Spark数据处理及转换（示例Scala代码）

val spark = SparkSession.builder.appName("DataWarehouse").enableHiveSupport().getOrCreate()

val salesRawDF = spark.read.option("header","false").csv("/user/hive/warehouse/sales_raw")
val salesDF = salesRawDF.selectExpr("_c0 as order_id", "_c1 as product_id", "_c2 as quantity", "_c3 as price", "_c4 as order_date")

salesDF.write.mode("overwrite").parquet("/user/hive/warehouse/sales_parquet")

spark.sql("""
  CREATE EXTERNAL TABLE IF NOT EXISTS sales (
    order_id INT,
    product_id INT,
    quantity INT,
    price DOUBLE,
    order_date STRING
  )
  STORED AS PARQUET
  LOCATION '/user/hive/warehouse/sales_parquet'
""")
### 7. Hive数据分析示例
sql
Copy
Edit
SELECT product_id, SUM(quantity) AS total_quantity, SUM(quantity * price) AS total_revenue
FROM sales
GROUP BY product_id
ORDER BY total_revenue DESC
LIMIT 10;

运行项目
准备AWS EC2环境，启动Docker服务

运行docker-compose启动相关大数据服务

按顺序执行MySQL建表、数据导入、Sqoop导入、Hive建表、Spark数据转换等步骤

通过Hive CLI或Beeline执行分析SQL

技术难点与解决方案
数据导入性能：调整Sqoop参数，合理配置mappers数量

数据格式优化：使用Parquet格式提高存储和查询效率

环境搭建复杂度：采用Docker容器降低环境依赖，提高复用性和可移植性

分布式计算调优：Spark作业调整并行度和内存设置优化性能

后续拓展
集成Azkaban实现定时调度和任务依赖管理

增加实时数据流处理，结合Kafka和Spark Streaming

加入数据可视化组件（如Apache Superset或Grafana）

设计更加复杂的数据模型，支持更多维度分析