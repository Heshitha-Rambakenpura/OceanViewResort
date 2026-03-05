# Ocean View Resort Management System

## Project Overview
A web-based Hotel Management System built with Java EE for managing guest reservations, payments, and hotel operations.

## Technologies Used
- Java 17
- Maven
- MySQL 8.0
- Apache Tomcat 9
- JSP / Servlets
- JSTL

## Design Patterns Used
- Singleton Pattern - DatabaseConnection
- DAO Pattern - All database operations
- Strategy Pattern - Payment processing (Cash, Card, Online Transfer)
- MVC Pattern - Overall architecture

## System Features
- Role-based login (Admin, Receptionist, Finance)
- Guest Registration with NIC/Passport validation
- Room and Room Type Management
- Reservation Management
- Payment Processing (Cash, Card, Online Transfer)
- Bill Generation and Printing
- Income Reports with CSV Export
- Audit Logs
- User Management

## Login Credentials
| Role | Username | Password |
|------|----------|----------|
| Admin | admin | admin123 |
| Receptionist | receptionist1 | recep123 |
| Finance | finance1 | finance123 |

## Database Setup
1. Open MySQL Workbench
2. Run sql/database_setup.sql
3. Update credentials in DatabaseConnection.java

## How to Run
1. Open project in IntelliJ IDEA
2. Run Maven clean and compile
3. Copy classes to WEB-INF/classes
4. Deploy to Tomcat 9
5. Access at http://localhost:8080/OceanViewResort
