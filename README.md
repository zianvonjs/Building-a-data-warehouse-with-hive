# Building a Data Warehouse with Hive on AWS

## 项目简介
本项目旨在构建一个基于Apache Hive的数据仓库，面向电商业务场景，实现销售和客户数据的全流程ETL与分析。数据从MySQL通过Sqoop导入到HDFS，利用Spark（Scala）完成数据清洗和格式转换，最后存储于Hive表中进行分析。项目部署于AWS EC2实例，借助Docker容器实现环境隔离和快速搭建。

## 项目架构
![架构图](https://github.com/laijupjoy/Building-a-data-warehouse-with-hive/assets/87544051/a3134c16-95dd-4b6d-9042-40057d6ae198)

架构包括：
- 数据源：MySQL关系型数据库
- 数据导入：Sqoop导入MySQL数据至HDFS
- 数据存储：HDFS存储原始数据，Hive建表存储结构化数据
- 数据处理：Spark（Scala）进行数据转换，生成Parquet文件
- 分析查询：Hive执行SQL分析报表
- 部署环境：AWS EC2 + Docker

## 技术栈
- 编程语言：SQL, Scala
- 大数据组件：Hive, Hadoop HDFS, Sqoop, Spark
- 容器技术：Docker, Docker Compose
- 云服务：AWS EC2

## 项目步骤

### 1. 启动AWS EC2实例
- 创建并登录AWS EC2 Linux实例
- 安装Docker及Docker Compose环境

### 2. 启动Docker容器环境
- 编写docker-compose.yml配置Hive、Hadoop、Spark和MySQL容器
- 运行 `docker-compose up -d` 启动服务

### 3. 创建MySQL表并导入数据
- 在MySQL中创建电商相关表（示例SQL见`mysql/schema.sql`）
- 导入样例数据

### 4. 使用Sqoop导入数据到HDFS
```bash
sqoop import \
--connect jdbc:mysql://<mysql_host>:3306/<database> \
--username <user> --password <password> \
--table <table_name> \
--target-dir /user/hive/warehouse/<table_name> \
--fields-terminated-by ',' \
--lines-terminated-by '\n' \
--num-mappers 1
```
### 5. Hive建表并加载数据
```sql
CREATE EXTERNAL TABLE IF NOT EXISTS sales_raw (
  order_id INT,
  product_id INT,
  quantity INT,
  price DOUBLE,
  order_date STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/user/hive/warehouse/sales_raw';
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