# ETL Sales Data Pipeline
### Overview

This project demonstrates a Python based ETL pipeline that reads JSON files containing sales and customer data, performs extensive data cleaning and transformation, and loads the structured data into a SQL Server database.

The pipeline also includes robust error handling, logging, and incremental data loading to ensure reliability and data consistency.

## ETL Workflow
### Extract

Reads data from two JSON files:

- sales_data.json

- customer_data.json

- Logs any file read errors.

- Converts the data into Pandas DataFrames.

### Transform

- Cleans and validates customer and sales data:

- Removes missing or invalid customer_id entries.

- Converts all dates to standard datetime format.

- Fills missing loyalty_points with 0.

- Calculates total_price = quantity × product.price.

- Cleans customer_name by:

- Removing numeric digits (e.g., "John Smith 2" → "John Smith").

- Removing invalid/special characters and truncating names longer than 100 characters.

- Validates email and replaces invalid ones with invalid_email@example.com.

- Corrects malformed customer_id values using regex.

- Formats customer_id to always have a 3-digit suffix (e.g., "C01" → "C001").

- Extracts product information into a separate DataFrame.

- Removes duplicate product records.

### Load

Connects to SQL Server using pyodbc.

Automatically creates tables if they don’t exist:

- Products

- Customers

- Transactions

- Inserts new records only — skipping duplicates to maintain incremental consistency.

- Commits transactions safely and closes the database connection.

### Incremental Load Logic

The ETL script supports incremental data loading, ensuring that:

- Existing records are not re-inserted (checked using primary keys).

- Each insert operation validates the record against the database.

Duplicates are logged into etl_error_log.txt with details like:

- Skipping duplicate customer_id: CUST101
- Skipping duplicate transaction_id: TXN245

### Logging and Error Handling

The script creates a logs/etl_error_log.txt file to record:

- File read errors

- Database connection failures

- Invalid or missing data

- Duplicate entries

- Data transformation issues

### Database Schema
- Products
  
| Column           | Type          |
| :--------------- | :------------ |
| product_id       | VARCHAR(50)   |
| product_name     | VARCHAR(255)  |
| product_category | VARCHAR(255)  |
| price            | DECIMAL(10,2) |

- Customers

| Column         | Type          |
| :------------- | :------------ |
| customer_id    | VARCHAR(50)   |
| customer_name  | VARCHAR(1000) |
| email          | VARCHAR(500)  |
| region         | VARCHAR(50)   |
| join_date      | DATETIME2     |
| loyalty_points | INT           |

- Transactions
  
| Column         | Type          |
| :------------- | :------------ |
| transaction_id | VARCHAR(50)   |
| customer_id    | VARCHAR(50)   |
| product_id     | VARCHAR(50)   |
| quantity       | INT           |
| discount       | DECIMAL(5,2)  |
| date           | DATETIME      |
| region         | VARCHAR(50)   |
| total_price    | DECIMAL(10,2) |

- Indexes are created on customer_id, product_id, region, and date for optimized queries.

### Customers Table

<img width="1114" height="542" alt="image" src="https://github.com/user-attachments/assets/720f30af-59a8-45dc-acf3-52616e48d8ed" />

### Products Table

<img width="434" height="155" alt="image" src="https://github.com/user-attachments/assets/6827a6dc-9f6c-4241-991b-6253590b000d" />

### Transactions Table

<img width="830" height="424" alt="image" src="https://github.com/user-attachments/assets/b3b95ec8-2c3f-4eb3-a30d-968b39e08a1a" />

## SQL Analytical Queries – Sales Insights Dashboard
### Overview

This SQL script provides analytical insights on the sales dataset processed through the ETL pipeline.

### Query 1: Total Sales by Region and Category

<img width="973" height="319" alt="image" src="https://github.com/user-attachments/assets/e021c921-c35e-403a-8498-ec037810db9f" />

### Query 2: Top 5 products by total revenue

<img width="1001" height="149" alt="image" src="https://github.com/user-attachments/assets/9f9b8f55-4cf1-4df6-b66a-7c1c7c5fd408" />

### Query 3: Monthly Sales Trend

<img width="1081" height="325" alt="image" src="https://github.com/user-attachments/assets/add75138-bb84-4326-bb5f-5a0bcf5fbf90" />

### Query 4: Average Discount Percentage per Region

<img width="1093" height="125" alt="image" src="https://github.com/user-attachments/assets/ad6003fd-84b8-4283-8221-768617de574d" />

### Query 5: Number of transactions with total_value > $1000

<img width="1250" height="54" alt="image" src="https://github.com/user-attachments/assets/3eae61ce-1d94-492a-91e8-6fb3e63027a5" />

## SSIS ETL Package – JSON to SQL Server Pipeline
### Overview

An SSIS based ETL pipeline designed to read JSON data, validate and transform it using SQL scripts, and load it into a SQL Server database efficiently.

The package leverages a Foreach Loop Container to iterate over multiple input files and a Data Flow Task that performs extraction from JSON and loading into the target database via OLE DB components.

<img width="482" height="203" alt="FinalForeach" src="https://github.com/user-attachments/assets/787bbef7-8473-4f65-b6dd-a337dfffecb1" />

<img width="259" height="212" alt="DataFlow" src="https://github.com/user-attachments/assets/dbe8192b-717c-49f0-b708-f2cb4f475473" />

## Control Flow – Foreach Loop Container

### Explanation:

- The Foreach Loop Container iterates through a folder containing multiple JSON files.

- The FilePath variable (@[User::FilePath]) dynamically updates with each file name during iteration.

- Inside the loop, the Data Flow Task executes to process each file sequentially.

## Data Flow – OLE DB Source to OLE DB Destination

### Explanation:

- OLE DB Source executes a parameterized SQL script that reads and validates JSON data.

- OLE DB Destination inserts the cleaned data into the SQL Server target table (Customers).

- Each execution handles one file at a time and logs progress automatically.

## Pipeline Design Summary
### Control Flow (Orchestration Layer)

- The Foreach Loop Container iterates through every file in a directory.

- Dynamically assigns the full file path to a package variable @[User::FilePath].

- Calls the Data Flow Task for each file to ensure atomic processing and error isolation.

### Data Flow (Processing Layer)

- Executes the SQL query dynamically using the current file path.

- Extracts and cleans JSON data using OPENROWSET and OPENJSON.

- Inserts the final structured data into the Customers table via OLE DB Destination.

### SSIS ETL Pipeline Output in SQL

<img width="1208" height="524" alt="image" src="https://github.com/user-attachments/assets/5c5114ef-19ef-41d3-88bb-203b9886a213" />
