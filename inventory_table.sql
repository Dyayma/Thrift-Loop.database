CREATE TABLE inventory (
    product_id      INTEGER PRIMARY KEY REFERENCES products(product_id) ON DELETE CASCADE,
    stock_quantity  INTEGER NOT NULL DEFAULT 1,
    last_synced_at  TEXT NOT NULL DEFAULT (datetime('now'))
);
