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
