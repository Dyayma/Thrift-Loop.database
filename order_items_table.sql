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
