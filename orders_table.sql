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
