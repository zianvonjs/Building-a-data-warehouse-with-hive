## Building a data warehouse with hive
Building a complete data warehouse for an e-commerce application to perform Apache Hive analytics on various datasets using big data tools like Apache Sqoop, Apache Spark, and HDFS. In order to achieve this task, we utilize the various services provided by AWS

## Tech Stack

Language: SQL, Scala

Services: AWS EC2, Docker, Sqoop, Hive, Spark, HDFS and Docker

## Approach

Create an AWS EC2 instance and launch it

Create docker images using the docker-compose file on the EC2 machine

Create the tables in MySQL relational databasemanagement system

Load the data from MySQL into HDFS storage using Sqoop commands

Move the data from HDFS to Hive

Extract customer information from data using Scala code and store it as a parquet file

Move the parquet file from Spark to Hive

Create tables in Hive and load the data from parquet files into tables

Perform Hive analytics on sales and Customer data
