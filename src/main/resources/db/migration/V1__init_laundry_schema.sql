-- ==========================================
-- 1. TABEL CUSTOMERS
-- ==========================================
CREATE TABLE IF NOT EXISTS customers (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Index untuk pencarian berdasarkan nama dan nomor telepon pelanggan
CREATE INDEX IF NOT EXISTS idx_customers_phone ON customers(phone);
CREATE INDEX IF NOT EXISTS idx_customers_name ON customers(name);


-- ==========================================
-- 2. TABEL SERVICES
-- ==========================================
CREATE TABLE IF NOT EXISTS services (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price NUMERIC(12, 2) NOT NULL CHECK (price >= 0),
    unit VARCHAR(20) NOT NULL -- Contoh: 'per_kg', 'per_pcs', 'per_meter'
);

-- Index untuk pencarian layanan
CREATE INDEX IF NOT EXISTS idx_services_name ON services(name);


-- ==========================================
-- 3. TABEL USERS (Menjamin integritas relasi user_id)
-- ==========================================
CREATE TABLE IF NOT EXISTS users (
    id BIGSERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(150),
    phone_number VARCHAR(20),
    last_login_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP WITH TIME ZONE
);


-- ==========================================
-- 4. TABEL ORDERS
-- ==========================================
CREATE TABLE IF NOT EXISTS orders (
    id BIGSERIAL PRIMARY KEY,
    customer_id BIGINT NOT NULL,
    user_id BIGINT,
    status VARCHAR(30) NOT NULL DEFAULT 'PENDING', 
    -- Status valid: 'PENDING', 'IN_PROGRESS', 'READY', 'COMPLETED', 'CANCELLED'
    total_price NUMERIC(12, 2) NOT NULL DEFAULT 0.00 CHECK (total_price >= 0),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    
    CONSTRAINT fk_orders_customer 
        FOREIGN KEY (customer_id) 
        REFERENCES customers(id) 
        ON DELETE RESTRICT,
        
    CONSTRAINT fk_orders_user 
        FOREIGN KEY (user_id) 
        REFERENCES users(id) 
        ON DELETE SET NULL
);

-- Index untuk mempermudah query filter status dan tanggal pesanan
CREATE INDEX IF NOT EXISTS idx_orders_customer_id ON orders(customer_id);
CREATE INDEX IF NOT EXISTS idx_orders_status ON orders(status);
CREATE INDEX IF NOT EXISTS idx_orders_created_at ON orders(created_at);


-- ==========================================
-- 5. TABEL ORDER_ITEMS
-- ==========================================
CREATE TABLE IF NOT EXISTS order_items (
    id BIGSERIAL PRIMARY KEY,
    order_id BIGINT NOT NULL,
    service_id BIGINT NOT NULL,
    qty NUMERIC(8, 2) NOT NULL CHECK (qty > 0), -- Menggunakan NUMERIC agar mendukung pecahan (misal: 2.5 kg)
    subtotal NUMERIC(12, 2) NOT NULL CHECK (subtotal >= 0),
    
    CONSTRAINT fk_order_items_order 
        FOREIGN KEY (order_id) 
        REFERENCES orders(id) 
        ON DELETE CASCADE,
        
    CONSTRAINT fk_order_items_service 
        FOREIGN KEY (service_id) 
        REFERENCES services(id) 
        ON DELETE RESTRICT
);

-- Index relasi order_items
CREATE INDEX IF NOT EXISTS idx_order_items_order_id ON order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_order_items_service_id ON order_items(service_id);


-- ==========================================
-- 6. TABEL PAYMENTS
-- ==========================================
CREATE TABLE IF NOT EXISTS payments (
    id BIGSERIAL PRIMARY KEY,
    order_id BIGINT NOT NULL,
    amount NUMERIC(12, 2) NOT NULL CHECK (amount > 0),
    method VARCHAR(30) NOT NULL, -- Contoh: 'CASH', 'TRANSFER', 'QRIS'
    paid_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    
    CONSTRAINT fk_payments_order 
        FOREIGN KEY (order_id) 
        REFERENCES orders(id) 
        ON DELETE CASCADE
);

-- Index relasi payments
CREATE INDEX IF NOT EXISTS idx_payments_order_id ON payments(order_id);
