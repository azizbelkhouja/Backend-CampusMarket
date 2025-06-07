USE campusmarket_db;

CREATE TABLE `user` (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(255),
    mobile VARCHAR(20),
    role ENUM('ROLE_ADMIN', 'ROLE_CUSTOMER', 'ROLE_SELLER') DEFAULT 'ROLE_CUSTOMER'
);

CREATE TABLE address (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    locality VARCHAR(255),
    address TEXT,
    city VARCHAR(100),
    state VARCHAR(100),
    pin_code VARCHAR(20),
    mobile VARCHAR(20),
    user_id BIGINT NOT NULL,
    CONSTRAINT fk_user FOREIGN KEY(user_id) REFERENCES `user`(id) ON DELETE CASCADE
);

CREATE TABLE coupon (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(50) UNIQUE NOT NULL,
    discount_percentage DOUBLE,
    validity_start_date DATE,
    validity_end_date DATE,
    minimum_order_value DOUBLE,
    is_active BOOLEAN DEFAULT TRUE
);

CREATE TABLE user_used_coupon (
    user_id BIGINT NOT NULL,
    coupon_id BIGINT NOT NULL,
    PRIMARY KEY (user_id, coupon_id),
    CONSTRAINT fk_user_coupon_user FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_user_coupon_coupon FOREIGN KEY(coupon_id) REFERENCES coupon(id) ON DELETE CASCADE
);

CREATE TABLE seller (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    seller_name VARCHAR(255),
    displayed_name VARCHAR(255) UNIQUE,
    mobile VARCHAR(20),
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255),
    
    -- BankDetails fields
    account_number VARCHAR(50),
    account_holder_name VARCHAR(255),
    iban VARCHAR(50),
	
    pickupaddress VARCHAR(255) NOT NULL,

    fiscal_code VARCHAR(100) UNIQUE,

    -- Enums
    role ENUM('ROLE_ADMIN', 'ROLE_CUSTOMER', 'ROLE_SELLER') DEFAULT 'ROLE_SELLER',
    is_email_verified BOOLEAN DEFAULT FALSE,
    account_status ENUM('PENDING_VERIFICATION', 'ACTIVE', 'SUSPENDED', 'DEACTIVATED', 'BANNED', 'CLOSED') DEFAULT 'PENDING_VERIFICATION'
);

CREATE TABLE seller_report (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,

    -- Foreign key linking each report to a unique seller
    seller_id BIGINT UNIQUE,
    CONSTRAINT fk_seller_report_seller FOREIGN KEY (seller_id)
        REFERENCES seller(id)
        ON DELETE CASCADE,

    total_earnings BIGINT DEFAULT 0,
    total_sales BIGINT DEFAULT 0,
    total_refunds BIGINT DEFAULT 0,
    total_tax BIGINT DEFAULT 0,
    net_earnings BIGINT DEFAULT 0,
    total_orders INT DEFAULT 0,
    canceled_orders INT DEFAULT 0,
    total_transactions INT DEFAULT 0
);

CREATE TABLE category (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    category_id VARCHAR(255) UNIQUE NOT NULL,
    parent_category_id BIGINT,
    level INT NOT NULL,
    FOREIGN KEY (parent_category_id) REFERENCES category(id)
);

CREATE TABLE product (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255),
    description TEXT,
    mrp_price INT,
    selling_price INT,
    discount_percent INT,
    quantity INT,
    color VARCHAR(50),
    num_ratings INT,
    category_id BIGINT,
    seller_id BIGINT,
    created_at DATETIME,
    sizes VARCHAR(255),
    in_stock BOOLEAN,
    FOREIGN KEY (category_id) REFERENCES category(id),
    FOREIGN KEY (seller_id) REFERENCES seller(id)
);

CREATE TABLE product_images (
	PRIMARY KEY (product_id, images),
    product_id BIGINT,
    images VARCHAR(255),
    FOREIGN KEY (product_id) REFERENCES product(id)
);

CREATE TABLE orders (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    `order_id` VARCHAR(255),
    user_id BIGINT,
    seller_id BIGINT,
    shipping_address_id BIGINT,
    total_mrp_price DOUBLE,
    total_selling_price INT,
    discount INT,
    order_status VARCHAR(50),
    total_item INT,
    
    -- paymentDetails
    payment_status VARCHAR(50),
    stripe_payment_link_id VARCHAR(255),
    stripe_payment_link_reference_id VARCHAR(255),
    stripe_payment_link_status VARCHAR(255),
    stripe_payment_id_zwsp VARCHAR(255),
    payment_details_status VARCHAR(50),
	payment_id VARCHAR(255),
    
    order_date DATETIME,
    deliver_date DATETIME,
    FOREIGN KEY (user_id) REFERENCES user(id),
    FOREIGN KEY (shipping_address_id) REFERENCES address(id)
);

CREATE TABLE order_item (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    order_id BIGINT,
    product_id BIGINT,
    size VARCHAR(50),
    quantity INT,
    mrp_price INT,
    selling_price INT,
    user_id BIGINT,
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES product(id)
);

CREATE TABLE review (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    review_text TEXT,
    rating DOUBLE,
    product_id BIGINT,
    user_id BIGINT,
    created_at DATETIME NOT NULL,
    FOREIGN KEY (product_id) REFERENCES product(id),
    FOREIGN KEY (user_id) REFERENCES user(id)
);

CREATE TABLE review_product_images (
	PRIMARY KEY (review_id, product_images),
    review_id BIGINT,
    product_images VARCHAR(255),
    FOREIGN KEY (review_id) REFERENCES review(id)
);

CREATE TABLE wishlist (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES user(id)
);

CREATE TABLE payment_information (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    cardholder_name VARCHAR(255) NOT NULL,
    card_number VARCHAR(255) NOT NULL,
    expiration_date DATE NOT NULL,
    cvv VARCHAR(3) NOT NULL
);

CREATE TABLE payment_order (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    amount BIGINT NOT NULL,
    status ENUM('PENDING', 'SUCCESS', 'FAILED') DEFAULT 'PENDING',
    payment_method ENUM('STRIPE') NOT NULL,
    payment_link_id VARCHAR(255),
    user_id BIGINT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES user(id)
);

CREATE TABLE transaction (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    customer_id BIGINT NOT NULL,
    order_id BIGINT NOT NULL,
    seller_id BIGINT NOT NULL,
    date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES user(id),
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (seller_id) REFERENCES seller(id)
);

CREATE TABLE home_category (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    image VARCHAR(255),
    category_id VARCHAR(255) NOT NULL,
    section ENUM('ELECTRONICS_CATEGORY', 'GRID', 'SHOP_BY_CATEGORY', 'DEALS') NOT NULL
);

CREATE TABLE deal (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    discount INT NOT NULL,
    category_id BIGINT NOT NULL,
    FOREIGN KEY (category_id) REFERENCES home_category(id)
);

CREATE TABLE cart (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    total_selling_price DOUBLE NOT NULL,
    total_item INT NOT NULL,
    total_mrp_price INT NOT NULL,
    discount INT NOT NULL,
    coupon_code VARCHAR(255),
    coupon_price INT,
    FOREIGN KEY (user_id) REFERENCES user(id)
);

CREATE TABLE cart_item (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    cart_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    size VARCHAR(255),
    quantity INT NOT NULL,
    mrp_price INT NOT NULL,
    selling_price INT NOT NULL,
    user_id BIGINT NOT NULL,
    FOREIGN KEY (cart_id) REFERENCES cart(id),
    FOREIGN KEY (product_id) REFERENCES product(id),
    FOREIGN KEY (user_id) REFERENCES user(id)
);

CREATE TABLE notification (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    recipient_id BIGINT,
    message VARCHAR(255),
    sent_at TIMESTAMP,
    read_status BOOLEAN,
    FOREIGN KEY (recipient_id) REFERENCES user(id)
);

CREATE TABLE payouts (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    seller_id BIGINT,
    amount BIGINT,
    status VARCHAR(50) DEFAULT 'PENDING',
    date TIMESTAMP,
    FOREIGN KEY (seller_id) REFERENCES seller(id)
);

CREATE TABLE verification_code (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    otp VARCHAR(10),
    email VARCHAR(100),
    user_id BIGINT,
    seller_id BIGINT,
    FOREIGN KEY (user_id) REFERENCES user(id),
    FOREIGN KEY (seller_id) REFERENCES seller(id)
);

CREATE TABLE password_reset_token (
    id INT AUTO_INCREMENT PRIMARY KEY,
    token VARCHAR(100) NOT NULL,
    user_id BIGINT,
    expiry_date TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES user(id)
);



INSERT INTO user (password, email, full_name, mobile, role) VALUES
('pass123', 'john@example.com', 'John Doe', '1234567890', 'ROLE_CUSTOMER'),
('secret', 'jane@example.com', 'Jane Smith', '0987654321', 'ROLE_CUSTOMER'),
('adminpass', 'admin@example.com', 'Admin User', '1112223333', 'ROLE_ADMIN'),
('sellerpass', 'seller@example.com', 'Seller User', '1122334455', 'ROLE_SELLER');

INSERT INTO address (name, locality, address, city, state, pin_code, mobile, user_id) VALUES
('Home', 'Green Park', '123 Main St', 'New York', 'NY', '10001', '1234567890', 1),
('Work', 'Downtown', '456 Elm St', 'New York', 'NY', '10002', '1234567890', 1),
('Home', 'Old Town', '789 Oak St', 'Chicago', 'IL', '60601', '0987654321', 2),
('Home', 'Lakeview', '101 River Rd', 'Chicago', 'IL', '60602', '1122334455', 4);

INSERT INTO coupon (code, discount_percentage, validity_start_date, validity_end_date, minimum_order_value, is_active) VALUES
('WELCOME10', 10.0, '2025-01-01', '2025-12-31', 50.0, true),
('SAVE20', 20.0, '2025-01-01', '2025-06-30', 100.0, true),
('EXPIRED5', 5.0, '2024-01-01', '2024-12-31', 20.0, false),
('BLACKFRIDAY50', 50.0, '2025-11-01', '2025-11-30', 200.0, true);

INSERT INTO user_used_coupon (user_id, coupon_id) VALUES
(1, 1),  -- John used WELCOME10
(1, 2),  -- John used SAVE20
(2, 1),  -- Jane used WELCOME10
(3, 3),  -- Admin used EXPIRED5
(4, 4);  -- Seller used BLACKFRIDAY50

INSERT INTO seller (
    seller_name, displayed_name, mobile, email, password, 
    account_number, account_holder_name, iban,
    pickupaddress, fiscal_code, role, is_email_verified, account_status
) VALUES (
    'Luigi Seller', 'Lui', '3399988776', 'luigi@example.com', 'securepass',
    'IT60X0542811101000000123456', 'Luigi Rossi', 'IT60X0542811101000000123456',
    'Via sagrat, 1', 'RSSLGU80A01H501Z', 'ROLE_SELLER', TRUE, 'ACTIVE'
);

-- Assume seller with ID 1 already exists
INSERT INTO seller_report (
    seller_id, total_earnings, total_sales, total_refunds,
    total_tax, net_earnings, total_orders, canceled_orders, total_transactions
) VALUES (
    1, 100000, 80000, 5000,
    2000, 73000, 120, 5, 130
);

INSERT INTO category (name, category_id, parent_category_id, level) VALUES
('Electronics', 'CAT_ELEC', NULL, 1),
('Phones', 'CAT_PHONE', 1, 2);

INSERT INTO product (title, description, mrp_price, selling_price, discount_percent, quantity, color, num_ratings, category_id, seller_id, created_at, sizes, in_stock) VALUES
('iPhone 14', 'Latest iPhone model', 1200, 999, 17, 20, 'Black', 5, 2, 1, NOW(), 'S,M,L', true);

INSERT INTO product_images (product_id, images) VALUES
(1, 'iphone14-front.jpg'),
(1, 'iphone14-back.jpg');

INSERT INTO orders (order_id, user_id, seller_id, shipping_address_id, total_mrp_price, total_selling_price, discount, order_status, total_item, payment_status, order_date, deliver_date, payment_id, stripe_payment_link_id, stripe_payment_link_reference_id, stripe_payment_link_status, stripe_payment_id_zwsp, payment_details_status) VALUES
('ORD12345', 1, 1, 1, 1200.00, 999, 201, 'PLACED', 1, 'PENDING', NOW(), NOW() + INTERVAL 7 DAY, 'PAY123', 'LINK123', 'REF123', 'created', 'STRIPEPAYID', 'PENDING');

INSERT INTO order_item (order_id, product_id, size, quantity, mrp_price, selling_price, user_id) VALUES
(1, 1, 'M', 1, 1200, 999, 1);

INSERT INTO review (review_text, rating, product_id, user_id, created_at) VALUES
('Great product, fast shipping!', 4.5, 1, 1, NOW());

INSERT INTO review_product_images (review_id, product_images) VALUES
(1, 'review-img1.jpg'),
(1, 'review-img2.jpg');

INSERT INTO wishlist (user_id) VALUES
(1),
(2);

INSERT INTO payment_information (cardholder_name, card_number, expiration_date, cvv) VALUES
('John Doe', '1234567812345678', '2025-12-01', '123'),
('Jane Smith', '9876543298765432', '2026-05-01', '456');

INSERT INTO payment_order (amount, status, payment_method, payment_link_id, user_id) VALUES
(1000, 'PENDING', 'STRIPE', 'link123', 1),
(500, 'SUCCESS', 'STRIPE', 'link456', 2);

INSERT INTO transaction (customer_id, order_id, seller_id) VALUES
(1, 1, 1),
(2, 2, 2);


INSERT INTO home_category (name, image, category_id, section)
VALUES 
('Electronics', 'electronics.jpg', 'electronics123', 'ELECTRONICS_CATEGORY'),
('Fashion', 'fashion.jpg', 'fashion123', 'GRID'),
('Home Appliances', 'home_appliances.jpg', 'home123', 'SHOP_BY_CATEGORY'),
('Deals', 'deals.jpg', 'deals123', 'DEALS');

INSERT INTO deal (discount, category_id)
VALUES 
(15, 1), 
(20, 2), 
(10, 3);

INSERT INTO cart (user_id, total_selling_price, total_item, total_mrp_price, discount, coupon_code, coupon_price)
VALUES 
(1, 1000.00, 3, 1200, 15, 'DISCOUNT10', 100),
(2, 2000.00, 5, 2500, 20, 'DISCOUNT20', 200);

INSERT INTO cart_item (cart_id, product_id, size, quantity, mrp_price, selling_price, user_id)
VALUES 
(1, 1, 'M', 2, 500, 450, 1),
(1, 2, 'L', 1, 700, 650, 1),
(2, 3, 'S', 2, 300, 270, 2),
(2, 4, 'M', 3, 500, 450, 2);

INSERT INTO notification (recipient_id, message, sent_at, read_status)
VALUES
(1, 'You have a new message from the admin.', '2025-05-04 10:30:00', FALSE),
(2, 'Your order has been shipped!', '2025-05-04 11:15:00', TRUE);

INSERT INTO payouts (seller_id, amount, status, data)
VALUES
(1, 500, 'PENDING', '2025-05-04 12:00:00'),
(2, 300, 'SUCCESS', '2025-05-04 12:30:00');

INSERT INTO verification_code (otp, email, user_id, seller_id)
VALUES
('123456', 'user1@example.com', 1, NULL),
('654321', 'seller1@example.com', NULL, 1);

INSERT INTO password_reset_token (token, user_id, expiry_date)
VALUES
('abc123', 1, '2025-05-05 23:59:59'),
('xyz789', 2, '2025-05-06 23:59:59');
