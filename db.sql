-- Create the LibraryManagement database if it doesn't exist
CREATE DATABASE IF NOT EXISTS LibraryManagement;

-- Use the LibraryManagement database
USE LibraryManagement;

-- Avoid error
DROP TABLE IF EXISTS Records;
DROP TABLE IF EXISTS Books;
DROP TABLE IF EXISTS Borrowers;
DROP PROCEDURE IF EXISTS CalculateBorrowPrice;

-- Create Books table
CREATE TABLE Books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(50) NOT NULL,
    category VARCHAR(50),
    ISBN VARCHAR(20) UNIQUE,
    quantity_available INT,
    publication_year INT
);

-- Create Borrowers table
CREATE TABLE Borrowers (
    borrower_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100),
    address VARCHAR(255),
    phone_number VARCHAR(20)
);

-- Create Records table
CREATE TABLE Records (
    record_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT,
    borrower_id INT,
    borrow_date DATE,
    return_date DATE,
    due_return_date DATE,
    returned BOOLEAN DEFAULT 0,
    CONSTRAINT fk_book
        FOREIGN KEY (book_id)
        REFERENCES Books(book_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_borrower
        FOREIGN KEY (borrower_id)
        REFERENCES Borrowers(borrower_id)
        ON DELETE CASCADE
);

-- returned value set as 1 when return date exists
DELIMITER //
CREATE TRIGGER set_returned_after_return_date
BEFORE UPDATE ON Records
FOR EACH ROW
BEGIN
    IF NEW.return_date IS NOT NULL THEN
        SET NEW.returned = 1;
    END IF;
END;
//
DELIMITER ;

-- Insert books
INSERT INTO Books (title, author, category, ISBN, quantity_available, publication_year) VALUES
('Harry Potter and the Philosopher''s Stone', 'J.K. Rowling', 'Fantasy', '9780590353403', 10, 1997),
('The Shining', 'Stephen King', 'Horror', '9780307743657', 7, 1977),
('Pride and Prejudice', 'Jane Austen', 'Romance', '9780141439518', 5, 1813),
('And Then There Were None', 'Agatha Christie', 'Mystery', '9780007136834', 8, 1939),
('1984', 'George Orwell', 'Dystopian', '9780452284234', 12, 1949),
('To Kill a Mockingbird', 'Harper Lee', 'Fiction', '9780061120084', 9, 1960),
('The Catcher in the Rye', 'J.D. Salinger', 'Coming-of-age', '9780316769488', 6, 1951),
('The Great Gatsby', 'F. Scott Fitzgerald', 'Classics', '9780743273565', 7, 1925),
('The Hobbit', 'J.R.R. Tolkien', 'Fantasy', '9780345339683', 10, 1937),
('The Da Vinci Code', 'Dan Brown', 'Thriller', '9780307474278', 11, 2003);

-- Insert borrowers
INSERT INTO Borrowers (first_name, last_name, email, address, phone_number) VALUES
('John', 'Doe', 'john.doe@example.com', '123 Main St, City, Country', '123-456-7890'),
('Jane', 'Smith', 'jane.smith@example.com', '456 Elm St, City, Country', '987-654-3210'),
('Michael', 'Johnson', 'michael.johnson@example.com', '789 Oak St, City, Country', '456-789-0123'),
('Emily', 'Brown', 'emily.brown@example.com', '101 Pine St, City, Country', '321-654-0987'),
('William', 'Garcia', 'william.garcia@example.com', '246 Maple St, City, Country', '789-012-3456'),
('Emma', 'Martinez', 'emma.martinez@example.com', '369 Oak St, City, Country', '654-321-0987'),
('James', 'Hernandez', 'james.hernandez@example.com', '852 Pine St, City, Country', '012-345-6789'),
('Olivia', 'Lopez', 'olivia.lopez@example.com', '963 Elm St, City, Country', '543-210-9876');

-- Insert records
INSERT INTO Records (book_id, borrower_id, borrow_date, return_date, due_return_date, returned) VALUES
(1, 1, '2024-03-01', '2024-03-05', '2024-03-08', 1),
(2, 2, '2024-03-10', '2024-03-12', '2024-03-17', 1),
(3, 1, '2024-03-15', '2024-03-20', '2024-03-22', 1),
(4, 3, '2024-03-05', '2024-03-10', '2024-03-12', 1),
(5, 4, '2024-03-12', NULL, '2024-03-19', 0),
(1, 2, '2024-03-20', NULL, '2024-03-27', 0),
(3, 3, '2024-03-25', '2024-04-10', '2024-04-01', 1),
(2, 4, '2024-03-30', NULL, '2024-04-06', 0);
