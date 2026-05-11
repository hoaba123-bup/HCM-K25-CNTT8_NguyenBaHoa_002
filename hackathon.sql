
CREATE DATABASE store_system;

USE store_system;

-- =========================================
-- CÂU 1 TẠO BẢNG
-- =========================================

-- =========================================
-- TẠO BẢNG CATEGORY
-- =========================================
CREATE TABLE Category (
	category_id VARCHAR(10) PRIMARY KEY,
	category_name VARCHAR(100) NOT NULL UNIQUE,
	description TEXT
);
-- =========================================
-- TẠO BẢNG PRODUCT
-- =========================================
CREATE TABLE Product (
	product_id VARCHAR(10) PRIMARY KEY,
	product_name VARCHAR(150) NOT NULL,
	price DECIMAL(10,2) NOT NULL,
	status VARCHAR(50) NOT NULL DEFAULT 'Available',
	category_id VARCHAR(10) NOT NULL,

	CONSTRAINT fk_product_category
	FOREIGN KEY (category_id)
	REFERENCES Category(category_id)
);
-- =========================================
-- TẠO BẢNG ORDERS
-- =========================================
CREATE TABLE Orders (
	order_id INT PRIMARY KEY AUTO_INCREMENT,
	order_date DATETIME NOT NULL,
	total_amount DECIMAL(15,2) NOT NULL,
	customer_name VARCHAR(100)
);
-- =========================================
-- TẠO BẢNG ORDER_DETAIL
-- =========================================
CREATE TABLE Order_detail (
	detail_id INT PRIMARY KEY AUTO_INCREMENT,
	order_id INT NOT NULL,
	product_id VARCHAR(10) NOT NULL, 
	quantity INT NOT NULL,
	subtotal DECIMAL(12,2) NOT NULL,

	CONSTRAINT fk_orderdetail_order
	FOREIGN KEY (order_id)
	REFERENCES Orders(order_id),

	CONSTRAINT fk_orderdetail_product
	FOREIGN KEY (product_id)
	REFERENCES Product(product_id)
);
-- =========================================
-- CÂU 2: THÊM DỮ LIỆU CHO BẢNG
-- =========================================

-- =========================================
-- THÊM DỮ LIỆU CHO BẢNG CATEGORY
-- =========================================
INSERT INTO Category VALUES
	('C01','Coffee','All type of coffee beans and brews'),
	('C02','Tea & Fruit','Fresh fruit juices and tea'),
	('C03','Bakery','Cakes and pastries');
    
-- =========================================
-- THÊM DỮ LIỆU CHO BẢNG PRODUCT
-- =========================================
INSERT INTO Product VALUES
	('P001','Espresso',35000.00,'Available','C01'),
	('P002','Matcha Latte',45000.00,'Available','C02'),
	('P003','Tiramisu',55000.00,'Available','C03'),
	('P004','Cold Brew',50000.00,'Out of Stock','C01'),
	('P005','Croissant',30000.00,'Available','C03');
    
-- =========================================
-- THÊM DỮ LIỆU CHO BẢNG ORDERS
-- =========================================
INSERT INTO Orders(order_date, total_amount, customer_name) VALUES
	('2025-01-01 08:30:00',80000.00,'Mr.An'),
	('2025-01-01 09:15:00',45000.00,'Mr.Hoa'),
	('2025-01-02 14:00:00',140000.00,'Mr.Binh'),
	('2025-01-03 10:00:00',35000.00,'Anonymous'),
	('2025-01-03 11:20:00',90000.00,'Mr.Lan');

-- =========================================
-- THÊM DỮ LIỆU CHO BẢNG ORDER_DETAIL
-- =========================================
INSERT INTO Order_detail(order_id, product_id, quantity, subtotal) VALUES
	(1,'P001',1, 35000.00 ),
	(1,'P004',1, 50000.00 ),
	(3,'P002',3, 135000.00 ),
	(3,'P001',2, 70000.00 ),
	(5,'P003',2, 110000.00 );
    
-- =========================================
-- CÂU 3: CẬP NHẬT TRẠNG THÁI SẢN PHẨM
-- =========================================
SET SQL_SAFE_UPDATES = 0;
UPDATE Product
SET status = 'Available'
WHERE product_name = 'Cold Brew';

-- =========================================
-- CÂU 4: TĂNG GIÁ 10% CHO DANH MỤC C03
-- =========================================
UPDATE Product
SET price = price + price * 0.1
WHERE category_id = 'C03';


-- =========================================
-- CÂU 5: XÓA CHI TIẾT ĐƠN HÀNG KHÔNG HỢP LỆ
-- =========================================
DELETE FROM Order_detail
WHERE quantity = 0
OR subtotal < 50000;


-- =========================================
-- CÂU 6: HIỂN THỊ SẢN PHẨM CÒN HÀNG
-- =========================================
SELECT product_id, 
       product_name,
	   price
FROM Product
WHERE price >= 40000
AND status = 'Available';


-- =========================================
-- CÂU 7: TÌM KHÁCH HÀNG BẮT ĐẦU BẰNG 'M'
-- =========================================
SELECT order_id,
       order_date, 
	   customer_name
FROM Orders
WHERE customer_name LIKE 'M%';


-- =========================================
-- CÂU 8: SẮP XẾP SẢN PHẨM THEO GIÁ GIẢM DẦN
-- =========================================
SELECT product_name, 
       price
FROM Product
ORDER BY price DESC;


-- =========================================
-- CÂU 9: LẤY 3 ĐƠN HÀNG MỚI NHẤT
-- =========================================
SELECT *
FROM Orders
ORDER BY order_date DESC
LIMIT 3;


-- =========================================
-- CÂU 10: LẤY 3 SẢN PHẨM BẮT ĐẦU TỪ VỊ TRÍ THỨ 3
-- =========================================
SELECT *
FROM Product
LIMIT 3 OFFSET 2;


-- =========================================
-- CÂU 11: HIỂN THỊ SẢN PHẨM VÀ DANH MỤC
-- =========================================
SELECT p.product_name, 
       p.price,
	   c.category_name
FROM Product p
JOIN Category c
ON p.category_id = c.category_id;

-- =========================================
-- CÂU 12: LIỆT KÊ DANH MỤC VÀ SẢN PHẨM
-- =========================================
SELECT c.category_name,
       p.product_name
FROM Category c
LEFT JOIN Product p
    ON p.category_id = c.category_id;


-- =========================================
-- CÂU 13: TÍNH TỔNG DOANH THU THEO TỪNG NGÀY
-- =========================================
SELECT DATE(order_date) AS order_day,
       SUM(total_amount) AS total_revenue
FROM Orders
GROUP BY DATE(order_date);

-- =========================================
-- CÂU 14: ĐƠN HÀNG CÓ TỪ 2 SẢN PHẨM TRỞ LÊN
-- =========================================
SELECT order_id, 
	   COUNT(product_id) AS count_product
FROM Order_detail
GROUP BY order_id
HAVING COUNT(product_id) >= 2;


-- =========================================
-- CÂU 15: SẢN PHẨM CÓ GIÁ LỚN HƠN GIÁ TRUNG BÌNH
-- =========================================
SELECT product_name,
	   price
FROM Product
WHERE price > (
	SELECT AVG(price)
    FROM Product
);


-- =========================================
-- CÂU 16: KHÁCH HÀNG ĐÃ MUA SẢN PHẨM P002
-- =========================================
SELECT DISTINCT o.customer_name
FROM Order_detail od
JOIN Orders o
ON od.order_id = o.order_id
WHERE od.product_id = 'P002';


-- =========================================
-- CÂU 17: HIỂN THỊ CHI TIẾT ĐƠN HÀNG
-- =========================================
SELECT 
	o.order_id,
    o.order_date,
    p.product_name,
    od.quantity,
    od.subtotal
FROM Order_detail od
JOIN Orders o
ON od.order_id = o.order_id
JOIN Product p
ON od.product_id = p.product_id;
