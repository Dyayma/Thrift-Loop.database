CREATE TABLE payments (
    payment_id      INTEGER PRIMARY KEY AUTOINCREMENT,
    order_id        INTEGER NOT NULL REFERENCES orders(order_id) ON DELETE CASCADE,
    gateway_reference TEXT,
    amount_cents    INTEGER NOT NULL,
    response_status TEXT NOT NULL CHECK (response_status IN ('confirmed','failed')),
    processed_at    TEXT NOT NULL DEFAULT (datetime('now'))
);
