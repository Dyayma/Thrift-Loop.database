CREATE TABLE users (
    user_id         INTEGER PRIMARY KEY AUTOINCREMENT,
    role            TEXT NOT NULL CHECK (role IN ('buyer','seller')),
    username        TEXT NOT NULL UNIQUE,
    email           TEXT NOT NULL UNIQUE,
    password_hash   TEXT NOT NULL,
    full_name       TEXT,
    phone           TEXT,
    address_line    TEXT,
    created_at      TEXT NOT NULL DEFAULT (datetime('now')),
    updated_at      TEXT NOT NULL DEFAULT (datetime('now'))
);
