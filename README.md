# 📘 Faculty Trigger Lab

## 🧾 Description
This project is a lab assignment for **CSE 210 – Database Systems**.  
It demonstrates the use of **MySQL triggers** to automate employee salary updates based on predefined conditions and to log all salary changes.

---

## 🎯 Objectives
- Create and manage a relational database
- Implement BEFORE UPDATE trigger for salary calculation
- Implement AFTER UPDATE trigger for logging changes
- Automate database operations using triggers

---

## 🗂️ Database Name

faculty_trigger_lab


---

## 🧱 Tables Structure

### 🔹 EMPLOYEE
- EmpID (Primary Key)
- EmpName (NOT NULL)
- BasicSalary
- StartDate
- NoOfPub (CHECK >= 0)
- IncrementRate (DEFAULT 0)
- UpdatedSalary

### 🔹 SALARY_LOG
- LogID (Primary Key, AUTO_INCREMENT)
- EmpID (Foreign Key)
- OldSalary
- NewSalary
- ChangedAt (DEFAULT CURRENT_TIMESTAMP)
- Note

---

## ⚙️ Trigger Logic

### ✅ Salary Increment Policy
- 🔺 20% → Job duration > 1 year AND publications > 4  
- 🔺 10% → Job duration > 1 year AND publications = 2 or 3  
- 🔺 5% → Job duration > 1 year AND publications = 1  
- 🔺 0% → Otherwise  

---

## 🔄 Triggers Used

### 🔹 BEFORE UPDATE Trigger
Automatically:
- Calculates increment rate
- Updates salary

### 🔹 AFTER UPDATE Trigger
Automatically:
- Logs salary changes into SALARY_LOG table

---

## 🧪 Testing
The trigger is tested using multiple UPDATE operations covering all cases:
- High publication
- Medium publication
- Low publication
- No increment case

---

## 📊 Sample Output

### EMPLOYEE Table
| EmpID | Name  | Increment | Updated Salary |
|------|------|----------|----------------|
| 1 | Rahim | 20% | 36000 |
| 3 | Anika | 5% | 36750 |
| 5 | Nabil | 10% | 35200 |
| 4 | Sadia | 0% | 40000 |

---

### SALARY_LOG Table
| LogID | EmpID | OldSalary | NewSalary |
|------|------|----------|----------|
| 1 | 1 | 30000 | 36000 |
| 2 | 3 | 35000 | 36750 |
| 3 | 5 | 32000 | 35200 |

---

## 💻 Technologies Used
- MySQL

---

## 🚀 How to Run
1. Open MySQL / phpMyAdmin
2. Run the SQL script
3. Execute UPDATE queries to test triggers
4. View results using:
   ```sql
   SELECT * FROM EMPLOYEE;
   SELECT * FROM SALARY_LOG;
📌 Author

Annesha Sarker Logno
Student, CSE 210
Green University of Bangladesh
