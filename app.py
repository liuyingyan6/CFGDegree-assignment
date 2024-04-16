from flask import Flask, jsonify, request
from db_utils import execute_query, fetch_query

app = Flask(__name__)

# Get all books
@app.route('/books', methods=['GET'])
def get_books():
    query = "SELECT * FROM Books"
    books = fetch_query(query)
    return jsonify(books)

# Add a new book
@app.route('/books', methods=['POST'])
def add_book():
    data = request.get_json()
    query = "INSERT INTO Books (title, author, category, ISBN, quantity_available, publication_year) VALUES (%s, %s, %s, %s, %s, %s)"
    values = (data['title'], data['author'], data['category'], data['ISBN'], data['quantity_available'], data['publication_year'])
    execute_query(query, values)
    return jsonify({"message": "Book added successfully"})

# Get all borrowers
@app.route('/borrowers', methods=['GET'])
def get_borrowers():
    query = "SELECT * FROM Borrowers"
    borrowers = fetch_query(query)
    return jsonify(borrowers)

# Add a new borrower
@app.route('/borrowers', methods=['POST'])
def add_borrower():
    data = request.get_json()
    query = "INSERT INTO Borrowers (first_name, last_name, email, address, phone_number) VALUES (%s, %s, %s, %s, %s)"
    values = (data['first_name'], data['last_name'], data['email'], data['address'], data['phone_number'])
    execute_query(query, values)
    return jsonify({"message": "Borrower added successfully"})

if __name__ == '__main__':
    app.run(debug=True)
