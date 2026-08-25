CREATE TABLE shipments (
    shipment_id     INTEGER PRIMARY KEY AUTOINCREMENT,
    order_id        INTEGER NOT NULL REFERENCES orders(order_id) ON DELETE CASCADE,
    courier_name    TEXT,
    tracking_number TEXT,
    status_update   TEXT,
    updated_at      TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE INDEX idx_shipments_order ON shipments(order_id);
