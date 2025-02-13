# Mechanic Shop Database Schema

This project contains a professional SQL database schema design for a mechanic shop management system. The schema includes tables for managing customers, vehicles, service tickets, mechanics, and their relationships.

## Schema Structure

The database includes the following main entities:

- **Customers**: Store customer contact information
- **Vehicles**: Track vehicles associated with customers
- **Mechanics**: Manage mechanic (employee) information
- **Service Tickets**: Record service requests and status
- **Service Details**: Store specific service information
- **Mechanic Assignments**: Track which mechanics work on which services

## Relationships

- One customer can have multiple vehicles
- One vehicle can have multiple service tickets
- Multiple mechanics can work on a single service ticket
- One service ticket can have multiple service details

## Getting Started

1. Create a new database in your PostgreSQL instance
2. Run the schema.sql file to create all necessary tables
3. The schema includes appropriate foreign key constraints and indexes

## License

This project is licensed under the MIT License - see the LICENSE file for details.
