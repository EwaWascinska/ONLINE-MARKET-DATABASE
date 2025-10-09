# E-commerce Database for a Building Supplies Store

![SQL](https://img.shields.io/badge/Language-SQL-blue)
![PL/SQL](https://img.shields.io/badge/Language-PL/SQL-orange)
![Database](https://img.shields.io/badge/Database-Oracle-red)

## 📖 Project Overview

This project is a comprehensive database solution designed for an online store specializing in building, renovation, and decorative materials. Developed as a university project for a Databases course, it models the core functionalities of a modern e-commerce platform.

The database is designed to manage and store critical business data, including:
* **Product Catalog:** Detailed information about products and their categorization.
* **Inventory Management:** Real-time tracking of product stock levels across multiple warehouses.
* **Customer Data:** Secure storage of customer information.
* **Order Processing:** Management of the entire order lifecycle, from placement to fulfillment.
* **Promotions and Discounts:** A flexible system for creating and applying promotional codes.
* **Business Analytics:** A suite of views to analyze sales trends, customer behavior, and financial performance.

The system is automated with triggers to handle business logic, ensuring data integrity and reducing manual intervention.

---

## Database Schema

The database is structured around key e-commerce entities. The relational model ensures data integrity and efficient querying.

**Core Entities:**
* `PRODUKT` (Product)
* `KLIENT` (Customer)
* `ZAMOWIENIE` (Order)
* `PRACOWNIK` (Employee)
* `MAGAZYN` (Warehouse)
* `PROMOCJA` (Promotion)

For a detailed visualization, please see the Entity-Relationship Diagrams below.

*(Suggestion: Add the ERD images from page 3 of your PDF to an `img` folder in your repository and link them here.)*

**Logical Model**
<img width="2345" height="1058" alt="obraz" src="https://github.com/user-attachments/assets/e439d9f7-e97b-4a11-a070-1a1e58470968" />


**Relational Model**
<img width="2608" height="1295" alt="obraz" src="https://github.com/user-attachments/assets/ab509f1b-d6a4-4a10-96ea-217d716a4e2c" />


---

## Key Features

This database isn't just for storage; it's packed with automated logic and analytical tools.

####  автоматическое управление запасами
* **Real-time Stock Updates:** Triggers automatically decrease stock levels when an order is placed and increase them if an order is canceled.
* **Stock Validation:** The system prevents orders from being placed if there is not enough product in stock, raising a clear error message.
* **Multi-Warehouse Logic:** Stock is drawn from different warehouses sequentially. Canceled orders return stock to the primary warehouse by default.

#### Dynamic Order Processing
* **Automatic Value Calculation:** The total value of an order is calculated automatically, applying valid promotional codes to eligible products.
* **Promotion Validation:** The system checks if a promotion is active and if the products in the cart are part of the promotion before applying a discount.

#### Business Intelligence and Reporting
A collection of SQL Views provide ready-to-use reports for business analysis:
* `magazyn_zawartosc`: Monitors the contents and stock levels of each warehouse.
* `szczegoly_zamowienia`: Tracks the status and details of every order.
* `dzialy_statystyka_sprzedazy`: Provides sales statistics for each product department.
* `statystyka_zakupow_klientow`: Analyzes the purchasing behavior of each customer.
* `sprzedaz_kwartalna`: Summarizes sales data on a quarterly basis.
* `przychody_kwartalne`: Calculates quarterly revenue and profit by factoring in warehouse and employee costs.

#### Data Integrity and Management
* **Stored Procedure (`przyjmij_dostawe`):** A dedicated procedure to handle incoming product deliveries, which correctly updates existing stock or creates new inventory records.
* **Sequences:** Automatic primary key generation for new records, ensuring uniqueness without manual input.

---

## Technologies Used

* **Database:** Oracle Database
* **Languages:** SQL, PL/SQL
* **Tools:** Oracle SQL Developer, Data Modeler

---

## Setup and Usage

To set up the database, execute the SQL scripts in the following order.

#### 1. Prerequisites
* An active Oracle Database instance.
* A tool to connect to the database, such as Oracle SQL Developer.

#### 2. Installation
Run the scripts in the specified order to ensure all dependencies are met.

1.  **`01_schema.sql`**: Creates all tables, sequences, and constraints.
2.  **`02_logic.sql`**: Deploys the triggers and the stored procedure.
3.  **`03_views.sql`**: Creates the reporting views.
4.  **`04_data.sql`**: Populates the database with sample data.

#### 3. Uninstallation
To remove all database objects created by this project, run the `uninstall.sql` script.
* **`uninstall.sql`**: Drops all tables, sequences, views, and procedures.

---

## 👩‍💻 Author

* **Ewa Waścińska**

This project was created for the "Databases" course led by mgr inż. Józef Woźniak.
