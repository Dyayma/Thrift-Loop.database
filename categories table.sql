CREATE TABLE categories_tags (
    tag_id          INTEGER PRIMARY KEY AUTOINCREMENT,
    tag_type        TEXT NOT NULL CHECK (tag_type IN
                        ('category','size','color','condition','type')),
    tag_value       TEXT NOT NULL,
    UNIQUE (tag_type, tag_value)
);


