-- ============================================================
-- ThriftLoop Database Schema
-- Designed to map directly onto the DFD Level 1 data stores
-- (D1-D5) and support every process (1.0-8.0) and use case
-- in the Context/Level-1 DFD and Use Case Diagram.
-- Dialect: SQLite (portable; minor tweaks needed for Postgres/MySQL)
-- ============================================================

PRAGMA foreign_keys = ON;

-- ============================================================
-- D1 - USERS
-- Stores buyer and seller account information, credentials,
-- and roles. Read/written by 1.0 Manage User Accounts.
-- ============================================================
CREATE TABLE users (
    user_id         INTEGER PRIMARY KEY AUTOINCREMENT,
    role            TEXT NOT NULL CHECK (role IN ('buyer','seller')),
    username        TEXT NOT NULL UNIQUE,
    email           TEXT NOT NULL UNIQUE,
    password_hash   TEXT NOT NULL,
    full_name       TEXT,
    phone           TEXT,
    address_line    TEXT,           -- shipping/pickup address for buyer or seller
    created_at      TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at      TEXT NOT NULL DEFAULT (datetime('now'))
);

-- ============================================================
-- D3 - CATEGORIES/TAGS
-- Stores category and tag values (size, color, type, condition)
-- used by 2.0 to classify listings and by 3.0 to filter results.
-- ============================================================
CREATE TABLE categories_tags (
    tag_id          INTEGER PRIMARY KEY AUTOINCREMENT,
    tag_type        TEXT NOT NULL CHECK (tag_type IN
                        ('category','size','color','condition','type')),
    tag_value       TEXT NOT NULL,
    UNIQUE (tag_type, tag_value)
);

-- ============================================================
-- D2 - PRODUCTS
-- Stores product listing details (name, description, price,
-- images, status). Created by 2.0; read by 3.0, 6.0, 8.0.
-- ============================================================
CREATE TABLE products (
    product_id      INTEGER PRIMARY KEY AUTOINCREMENT,
    seller_id       INTEGER NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    name            TEXT NOT NULL,
    description     TEXT,
    price_cents     INTEGER NOT NULL,
    image_url       TEXT,
    status          TEXT NOT NULL DEFAULT 'active' CHECK (status IN
                        ('active','sold_out','removed')),
    created_at      TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at      TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE INDEX idx_products_seller ON products(seller_id);
CREATE INDEX idx_products_status ON products(status);

CREATE TABLE product_tags (
    product_id      INTEGER NOT NULL REFERENCES products(product_id) ON DELETE CASCADE,
    tag_id          INTEGER NOT NULL REFERENCES categories_tags(tag_id) ON DELETE CASCADE,
    PRIMARY KEY (product_id, tag_id)
);

-- ============================================================
-- D5 - INVENTORY
-- Stores current stock quantity per product. Checked by 4.0
-- before checkout, adjusted automatically by 6.0 Sync Inventory.
-- ============================================================
CREATE TABLE inventory (
    product_id      INTEGER PRIMARY KEY REFERENCES products(product_id) ON DELETE CASCADE,
    stock_quantity  INTEGER NOT NULL DEFAULT 1,
    last_synced_at  TEXT NOT NULL DEFAULT (datetime('now'))
);

-- ------------------------------------------------------------
-- CART ITEMS (working state for 4.0 Manage Cart and Checkout)
-- ------------------------------------------------------------
CREATE TABLE cart_items (
    cart_item_id    INTEGER PRIMARY KEY AUTOINCREMENT,
    buyer_id        INTEGER NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    product_id      INTEGER NOT NULL REFERENCES products(product_id) ON DELETE CASCADE,
    quantity        INTEGER NOT NULL DEFAULT 1,
    added_at        TEXT NOT NULL DEFAULT (datetime('now')),
    UNIQUE (buyer_id, product_id)
);

-- ============================================================
-- D4 - ORDERS
-- Stores order records: items purchased, payment status,
-- shipping status. Updated by 4.0, 5.0, and 7.0; summarized by 8.0.
-- ============================================================
CREATE TABLE orders (
    order_id        INTEGER PRIMARY KEY AUTOINCREMENT,
    buyer_id        INTEGER NOT NULL REFERENCES users(user_id),
    order_total_cents INTEGER NOT NULL,
    payment_status  TEXT NOT NULL DEFAULT 'pending' CHECK (payment_status IN
                        ('pending','paid','failed','refunded')),
    shipping_status TEXT NOT NULL DEFAULT 'awaiting_shipment' CHECK (shipping_status IN
                        ('awaiting_shipment','shipped','in_transit','delivered','cancelled')),
    created_at      TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at      TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE INDEX idx_orders_buyer ON orders(buyer_id);

CREATE TABLE order_items (
    order_item_id   INTEGER PRIMARY KEY AUTOINCREMENT,
    order_id        INTEGER NOT NULL REFERENCES orders(order_id) ON DELETE CASCADE,
    product_id      INTEGER NOT NULL REFERENCES products(product_id),
    seller_id       INTEGER NOT NULL REFERENCES users(user_id),
    quantity        INTEGER NOT NULL DEFAULT 1,
    price_cents     INTEGER NOT NULL
);

CREATE INDEX idx_order_items_order  ON order_items(order_id);
CREATE INDEX idx_order_items_seller ON order_items(seller_id);

-- ------------------------------------------------------------
-- PAYMENTS (exchange between 5.0 and the Payment Gateway)
-- ------------------------------------------------------------
CREATE TABLE payments (
    payment_id      INTEGER PRIMARY KEY AUTOINCREMENT,
    order_id        INTEGER NOT NULL REFERENCES orders(order_id) ON DELETE CASCADE,
    gateway_reference TEXT,
    amount_cents    INTEGER NOT NULL,
    response_status TEXT NOT NULL CHECK (response_status IN
                        ('confirmed','failed')),
    processed_at    TEXT NOT NULL DEFAULT (datetime('now'))
);

-- ------------------------------------------------------------
-- SHIPMENTS (exchange between 7.0 and the Courier/Shipping Provider)
-- ------------------------------------------------------------
CREATE TABLE shipments (
    shipment_id     INTEGER PRIMARY KEY AUTOINCREMENT,
    order_id        INTEGER NOT NULL REFERENCES orders(order_id) ON DELETE CASCADE,
    courier_name    TEXT,
    tracking_number TEXT,
    status_update   TEXT,
    updated_at      TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE INDEX idx_shipments_order ON shipments(order_id);

-- ============================================================
-- SEED DATA
-- ============================================================
INSERT INTO categories_tags (tag_type, tag_value) VALUES
    ('category', 'Tops'),
    ('category', 'Bottoms'),
    ('category', 'Outerwear'),
    ('category', 'Footwear'),
    ('category', 'Accessories'),
    ('size', 'XS'), ('size', 'S'), ('size', 'M'), ('size', 'L'), ('size', 'XL'),
    ('condition', 'New with tags'),
    ('condition', 'Like new'),
    ('condition', 'Good'),
    ('condition', 'Fair'),
    ('condition', 'Worn');
