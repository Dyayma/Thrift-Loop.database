CREATE TABLE product_tags (
    product_id      INTEGER NOT NULL REFERENCES products(product_id) ON DELETE CASCADE,
    tag_id          INTEGER NOT NULL REFERENCES categories_tags(tag_id) ON DELETE CASCADE,
    PRIMARY KEY (product_id, tag_id)
);
