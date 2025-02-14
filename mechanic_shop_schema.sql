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
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Vehicles table
-- Stores information about customer vehicles
-- One customer can have multiple vehicles
CREATE TABLE vehicles (
    vehicle_id SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL REFERENCES customers(customer_id) ON DELETE CASCADE,
    vin VARCHAR(17) UNIQUE NOT NULL,
    make VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL,
    year INTEGER NOT NULL CHECK (year > 1900 AND year <= EXTRACT(YEAR FROM CURRENT_DATE)),
    color VARCHAR(30),
    license_plate VARCHAR(15),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
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
    salary DECIMAL(10,2) NOT NULL CHECK (salary >= 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Service tickets table
-- Main table for service records
-- One vehicle can have multiple service tickets over time
CREATE TABLE service_tickets (
    ticket_id SERIAL PRIMARY KEY,
    vehicle_id INTEGER NOT NULL REFERENCES vehicles(vehicle_id) ON DELETE CASCADE,
    open_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    close_date TIMESTAMP,
    status VARCHAR(20) NOT NULL DEFAULT 'OPEN',
    total_cost DECIMAL(10,2) CHECK (total_cost >= 0),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Service details table
-- Stores specific services performed
-- One ticket can have multiple services
CREATE TABLE service_details (
    service_detail_id SERIAL PRIMARY KEY,
    ticket_id INTEGER NOT NULL REFERENCES service_tickets(ticket_id) ON DELETE CASCADE,
    service_description TEXT NOT NULL,
    service_cost DECIMAL(10,2) NOT NULL CHECK (service_cost >= 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Mechanic assignments table
-- Junction table for mechanics and service tickets
-- Allows multiple mechanics to work on one ticket
-- And one mechanic to work on multiple tickets
CREATE TABLE mechanic_assignments (
    assignment_id SERIAL PRIMARY KEY,
    ticket_id INTEGER NOT NULL REFERENCES service_tickets(ticket_id) ON DELETE CASCADE,
    mechanic_id INTEGER NOT NULL REFERENCES mechanics(mechanic_id) ON DELETE CASCADE,
    assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(ticket_id, mechanic_id)
);

-- Indexes for performance improvement
CREATE INDEX idx_customers_email ON customers(email);
CREATE INDEX idx_vehicles_vin ON vehicles(vin);
CREATE INDEX idx_mechanics_email ON mechanics(email);
CREATE INDEX idx_service_tickets_vehicle_id ON service_tickets(vehicle_id);
CREATE INDEX idx_service_details_ticket_id ON service_details(ticket_id);
CREATE INDEX idx_mechanic_assignments_ticket_id ON mechanic_assignments(ticket_id);
CREATE INDEX idx_mechanic_assignments_mechanic_id ON mechanic_assignments(mechanic_id);

-- Add comments to explain relationships
COMMENT ON TABLE customers IS 'Stores customer information';
COMMENT ON TABLE vehicles IS 'Stores vehicle information, linked to customers';
COMMENT ON TABLE mechanics IS 'Stores mechanic (employee) information';
COMMENT ON TABLE service_tickets IS 'Main service record, linked to vehicles';
COMMENT ON TABLE service_details IS 'Details of services performed';
COMMENT ON TABLE mechanic_assignments IS 'Links mechanics to service tickets (many-to-many)';

-- Relationships explained:
-- 1. One customer can have many vehicles (1:N)
-- 2. One vehicle can have many service tickets (1:N)
-- 3. One service ticket can have many service details (1:N)
-- 4. Many mechanics can work on many service tickets (M:N) through mechanic_assignments
