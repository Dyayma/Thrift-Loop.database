CREATE TABLE cart_items (
    cart_item_id    INTEGER PRIMARY KEY AUTOINCREMENT,
    buyer_id        INTEGER NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    product_id      INTEGER NOT NULL REFERENCES products(product_id) ON DELETE CASCADE,
    quantity        INTEGER NOT NULL DEFAULT 1,
    added_at        TEXT NOT NULL DEFAULT (datetime('now')),
    UNIQUE (buyer_id, product_id)
);
