import csv
import os
from flask import Flask, request, jsonify

app = Flask(__name__)
CSV_FILE = 'students.csv'
FIELDS = ['id', 'first_name', 'last_name', 'age']

def read_students():
    if not os.path.exists(CSV_FILE):
        return []
    with open(CSV_FILE, mode='r', newline='', encoding='utf-8') as f:
        return list(csv.DictReader(f))

def write_students(students):
    with open(CSV_FILE, mode='w', newline='', encoding='utf-8') as f:
        writer = csv.DictWriter(f, fieldnames=FIELDS)
        writer.writeheader()
        writer.writerows(students)

@app.route('/students', methods=['GET'])
def get_students():
    last_name = request.args.get('last_name')
    students = read_students()
    
    if last_name:
        filtered = [s for s in students if s['last_name'].lower() == last_name.lower()]
        if not filtered:
            return jsonify({"error": "Student with this last name not found"}), 404
        return jsonify(filtered)
    
    return jsonify(students)

@app.route('/students/<int:student_id>', methods=['GET'])
def get_student_by_id(student_id):
    students = read_students()
    student = next((s for s in students if int(s['id']) == student_id), None)
    if not student:
        return jsonify({"error": "Student ID not found"}), 404
    return jsonify(student)

@app.route('/students', methods=['POST'])
def create_student():
    data = request.json
    if not data:
        return jsonify({"error": "No data provided"}), 400
    
    required = ['first_name', 'last_name', 'age']
    if not all(k in data for k in required) or len(data) != 3:
        return jsonify({"error": "Missing or extra fields"}), 400

    students = read_students()
    new_id = max([int(s['id']) for s in students], default=0) + 1
    new_student = {
        'id': str(new_id),
        'first_name': data['first_name'],
        'last_name': data['last_name'],
        'age': str(data['age'])
    }
    students.append(new_student)
    write_students(students)
    return jsonify(new_student), 201

@app.route('/students/<int:student_id>', methods=['PUT'])
def update_student_put(student_id):
    data = request.json
    required = ['first_name', 'last_name', 'age']
    if not data or not all(k in data for k in required) or len(data) != 3:
        return jsonify({"error": "Invalid fields"}), 400

    students = read_students()
    for s in students:
        if int(s['id']) == student_id:
            s.update({'first_name': data['first_name'], 'last_name': data['last_name'], 'age': str(data['age'])})
            write_students(students)
            return jsonify(s)
    return jsonify({"error": "Student ID not found"}), 404

@app.route('/students/<int:student_id>', methods=['PATCH'])
def update_student_patch(student_id):
    data = request.json
    if not data or 'age' not in data or len(data) != 1:
        return jsonify({"error": "Only 'age' field is allowed"}), 400

    students = read_students()
    for s in students:
        if int(s['id']) == student_id:
            s['age'] = str(data['age'])
            write_students(students)
            return jsonify(s)
    return jsonify({"error": "Student ID not found"}), 404

@app.route('/students/<int:student_id>', methods=['DELETE'])
def delete_student(student_id):
    students = read_students()
    new_list = [s for s in students if int(s['id']) != student_id]
    if len(new_list) == len(students):
        return jsonify({"error": "Student ID not found"}), 404
    
    write_students(new_list)
    return jsonify({"message": f"Student {student_id} deleted successfully"})

if __name__ == '__main__':
    if not os.path.exists(CSV_FILE):
        write_students([])
    app.run(debug=True)
