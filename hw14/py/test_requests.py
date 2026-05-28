import requests
import json

BASE_URL = "http://127.0.0"

def log_result(f, title, response):
    output = f"\n--- {title} ---\nStatus: {response.status_code}\nData: {response.text}\n"
    print(output)
    f.write(output)

with open('results.txt', 'w', encoding='utf-8') as f:
    # 1. Retrieve all existing students
    log_result(f, "GET ALL STUDENTS (START)", requests.get(BASE_URL))

    # 2. Create three students
    s1 = {"first_name": "Ivan", "last_name": "Ivanov", "age": 20}
    s2 = {"first_name": "Petro", "last_name": "Petrov", "age": 22}
    s3 = {"first_name": "Olga", "last_name": "Sydorenko", "age": 19}
    
    for i, s in enumerate([s1, s2, s3], 1):
        log_result(f, f"POST STUDENT {i}", requests.post(BASE_URL, json=s))

    # 3. Retrieve all
    log_result(f, "GET ALL STUDENTS", requests.get(BASE_URL))

    # 4. PATCH second student age
    log_result(f, "PATCH STUDENT 2 AGE", requests.patch(f"{BASE_URL}/2", json={"age": 25}))

    # 5. GET second student
    log_result(f, "GET STUDENT 2", requests.get(f"{BASE_URL}/2"))

    # 6. PUT third student
    updated_s3 = {"first_name": "Oksana", "last_name": "Melnyk", "age": 21}
    log_result(f, "PUT STUDENT 3", requests.put(f"{BASE_URL}/3", json=updated_s3))

    # 7. GET third student
    log_result(f, "GET STUDENT 3", requests.get(f"{BASE_URL}/3"))

    # 8. Retrieve all
    log_result(f, "GET ALL STUDENTS (BEFORE DELETE)", requests.get(BASE_URL))

    # 9. DELETE first student
    log_result(f, "DELETE STUDENT 1", requests.delete(f"{BASE_URL}/1"))

    # 10. Retrieve all
    log_result(f, "GET ALL STUDENTS (FINAL)", requests.get(BASE_URL))
