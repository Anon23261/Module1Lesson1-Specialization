-- Mechanic Shop Database Schema

-- Customers table
-- Stores basic customer information
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15) NOT NULL,
    address TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Vehicles table
-- Stores information about customer vehicles
-- One customer can have multiple vehicles
CREATE TABLE vehicles (
    vehicle_id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(customer_id),
    vin VARCHAR(17) UNIQUE NOT NULL,
    make VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL,
    year INTEGER NOT NULL,
    color VARCHAR(30),
    license_plate VARCHAR(15),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Mechanics table
-- Stores basic mechanic (employee) information
CREATE TABLE mechanics (
    mechanic_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15) NOT NULL,
    address TEXT NOT NULL,
    hire_date DATE NOT NULL,
    salary DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Service tickets table
-- Main table for service records
-- One vehicle can have multiple service tickets over time
CREATE TABLE service_tickets (
    ticket_id SERIAL PRIMARY KEY,
    vehicle_id INTEGER REFERENCES vehicles(vehicle_id),
    open_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    close_date TIMESTAMP,
    status VARCHAR(20) NOT NULL DEFAULT 'OPEN',
    total_cost DECIMAL(10,2),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Service details table
-- Stores specific services performed
-- One ticket can have multiple services
CREATE TABLE service_details (
    service_detail_id SERIAL PRIMARY KEY,
    ticket_id INTEGER REFERENCES service_tickets(ticket_id),
    service_description TEXT NOT NULL,
    service_cost DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Mechanic assignments table
-- Junction table for mechanics and service tickets
-- Allows multiple mechanics to work on one ticket
-- And one mechanic to work on multiple tickets
CREATE TABLE mechanic_assignments (
    assignment_id SERIAL PRIMARY KEY,
    ticket_id INTEGER REFERENCES service_tickets(ticket_id),
    mechanic_id INTEGER REFERENCES mechanics(mechanic_id),
    assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(ticket_id, mechanic_id)
);

-- Add comments to explain relationships
COMMENT ON TABLE customers IS 'Stores customer information';
COMMENT ON TABLE vehicles IS 'Stores vehicle information, linked to customers';
COMMENT ON TABLE mechanics IS 'Stores mechanic (employee) information';
COMMENT ON TABLE service_tickets IS 'Main service record, linked to vehicles';
COMMENT ON TABLE service_details IS 'Details of services performed';
COMMENT ON TABLE mechanic_assignments IS 'Links mechanics to service tickets (many-to-many)';

/*
Relationships explained:
1. One customer can have many vehicles (1:N)
2. One vehicle can have many service tickets (1:N)
3. One service ticket can have many service details (1:N)
4. Many mechanics can work on many service tickets (M:N) through mechanic_assignments
*/
