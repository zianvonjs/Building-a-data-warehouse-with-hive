## Building a data warehouse with hive 
Building a complete data warehouse for an e-commerce application to perform Apache Hive analytics on various datasets using big data tools like Apache Sqoop, Apache Spark, and HDFS. In order to achieve this task, we utilize the various services provided by AWS

## Architecture

<img width="557" alt="hive warehouse" src="https://github.com/laijupjoy/Building-a-data-warehouse-with-hive/assets/87544051/a3134c16-95dd-4b6d-9042-40057d6ae198">

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
