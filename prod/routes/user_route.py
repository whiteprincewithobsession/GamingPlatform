from sqlalchemy import text
from datetime import date, datetime
import uuid
import getpass
import hashlib
import re

def is_valid_email(email):
    email_regex = re.compile(
        r'^(([0-9A-Za-z][-0-9A-Za-z\.]*[0-9A-Za-z])|' 
        r'([0-9А-Яа-я][-0-9А-Яа-я\.]*[0-9А-Яа-я]))@'  
        r'([A-Za-z0-9][-A-Za-z0-9]*\.)+'
        r'[A-Za-z]{2,}$', re.UNICODE
    )
    return re.match(email_regex, email) is not None

def get_roles(session):
    query = text("SELECT RoleID, RoleName FROM Roles")
    roles = session.execute(query).fetchall()
    return roles

def hash_password(password):
    return hashlib.sha256(password.encode()).hexdigest()

def get_users_with_game_counts(session):
    query = text("""
        SELECT u.UserID, u.Username, COUNT(ug.GameID) AS GameCount
        FROM Users u
        LEFT JOIN Usergames ug ON u.UserID = ug.UserID
        GROUP BY u.UserID, u.Username
        ORDER BY GameCount DESC;
    """)

    result = session.execute(query)
    users = result.fetchall()

    return [
        {"UserID": user_id, "Username": username, "GameCount": game_count}
        for user_id, username, game_count in users
    ]
    
def register_user(session):
    username = input("Enter your username: ")
    while True:
            email = input("Enter email: ")
            if is_valid_email(email):
                break
            else:
                print("Invalid email format. Please try again.")    
    password = getpass.getpass("Enter password: ")
    password_hash = hash_password(password)
    role_id = 3
    full_name = input("Enter full name: ")
    bio = input("Enter some bio about you: ")
    avatar = input("Enter URL of your photo (if none - skip): ")
    location = input("Enter your country: ")
    dob = input("Enter your birthdate (YYYY-MM-DD): ")

    try:
        query_users = text("""
            INSERT INTO Users (Username, Email, UserPassword, RegistrationDate, CashBalance)
            VALUES (:username, :email, :password_hash, :reg_date, :cash_balance)
            RETURNING UserID
        """)
        result = session.execute(
            query_users, {
                "username": username,
                "email": email,
                "password_hash": password_hash,
                "reg_date": date.today(),
                "cash_balance": 100.00
            }
        )
        user_id = result.fetchone()[0]
        query_profiles = text("""
            INSERT INTO UserProfiles (UserID, RoleID, FullName, Bio, Avatar, UserLocation, DateOfBirth)
            VALUES (:user_id, :role_id, :full_name, :bio, :avatar, :location, :dob)
        """)
        session.execute(
            query_profiles, {
                "user_id": user_id,
                "role_id": role_id,
                "full_name": full_name,
                "bio": bio,
                "avatar": avatar if avatar else None,
                "location": location,
                "dob": dob
            }
        )

        session.commit()
        print("Succesfully registered!")
    except Exception as e:
        session.rollback()
        print(f"Error occured in register_user: {e}")

def authenticate_user(session):
    email = input("Enter email: ")
    password = getpass.getpass("Enter password: ")
    password_hash = hash_password(password)

    query = text("""
        SELECT u.UserID, u.Username, u.Email, p.RoleID, r.RoleName
        FROM Users u
        LEFT JOIN UserProfiles p ON u.UserID = p.UserID
        LEFT JOIN Roles r ON p.RoleID = r.RoleID
        WHERE u.Email = :email AND u.UserPassword = :password_hash
    """)
    
    result = session.execute(query, {"email": email, "password_hash": password_hash}).mappings().fetchone()

    if result:
        if 'username' in result and 'rolename' in result:
            print(f"\nWelcome, {result['username']}!")  
            print(f"Your role: {result['rolename']}") 
            return result["userid"], result["rolename"]  
        else:
            print("Missing required fields in the query result.")
            return None, None
    else:
        print("Incorrect email or password.")
        return None, None
    
def view_profile(session, user_id):
    query = text("""
        SELECT u.Username, u.Email, u.RegistrationDate, u.CashBalance,
               p.FullName, p.Bio, p.Avatar, p.UserLocation, p.DateOfBirth,
               r.RoleName
        FROM Users u
        LEFT JOIN UserProfiles p ON u.UserID = p.UserID
        LEFT JOIN Roles r ON p.RoleID = r.RoleID
        WHERE u.UserID = :user_id
    """)
    result = session.execute(query, {"user_id": user_id}).mappings().fetchone()

    if result:
        print("\n--- Your profile ---")
        print(f"Username: {result['username']}")
        print(f"Email: {result['email']}")
        print(f"Registration date: {result['registrationdate']}")
        print(f"Cash balance: {result['cashbalance']:.2f}$")
        print(f"Full name: {result['fullname']}")
        print(f"Bio: {result['bio']}")
        print(f"Avatar: {result['avatar']}")
        print(f"Location: {result['userlocation']}")
        print(f"Birthdate: {result['dateofbirth']}")
        print(f"Role: {result['rolename']}")
    else:
        print("Cant find profile.")
        
def add_balance(session, user_id):
    while True:
        try:
            print("\n--- Add Balance ---")
            current_balance_query = text("""
                SELECT CashBalance FROM Users 
                WHERE UserID = :user_id
            """)
            current_balance = session.execute(current_balance_query, {"user_id": user_id}).scalar()
            
            print(f"Current balance: ${current_balance:.2f}")
            
            amount = float(input("Enter amount to add (or 0 to cancel): "))
            
            if amount == 0:
                print("Balance replenishment cancelled.")
                break
            
            if amount < 0:
                print("Amount must be positive.")
                continue
            
            add_balance_query = text("""
                UPDATE Users 
                SET CashBalance = CashBalance + :amount 
                WHERE UserID = :user_id
            """)
            
            add_transaction_query = text("""
                INSERT INTO Transactions 
                (TransactionCode, UserID, GameID, Amount, TrType, TransactionTime)
                VALUES (
                    :tr_code, 
                    :user_id, 
                    (SELECT GameID FROM Games LIMIT 1), 
                    :amount, 
                    (SELECT TypeID FROM TransactionType WHERE TypeName = 'Replenishment'), 
                    :tr_time
                )
            """)
            
            add_log_query = text("""
                INSERT INTO UserActivityLog 
                (UserID, Activity, LoggedAt)
                VALUES (:user_id, :activity, :timestamp)
            """)
            
            session.execute(add_balance_query, {
                "user_id": user_id,
                "amount": amount
            })
            
            session.execute(add_transaction_query, {
                "tr_code": str(uuid.uuid4()),
                "user_id": user_id,
                "amount": amount,
                "tr_time": datetime.now()
            })
            
            session.execute(add_log_query, {
                "user_id": user_id,
                "activity": f"Replenished balance by ${amount:.2f}",
                "timestamp": datetime.now()
            })
            
            session.commit()
            
            print(f"\nSuccessfully added ${amount:.2f} to your balance.")
            
            new_balance_query = text("""
                SELECT CashBalance FROM Users 
                WHERE UserID = :user_id
            """)
            new_balance = session.execute(new_balance_query, {"user_id": user_id}).scalar()
            
            print(f"New balance: ${new_balance:.2f}")
            break
        
        except ValueError:
            print("Invalid input. Please enter a valid number.")
        except Exception as e:
            session.rollback()
            print(f"Error during balance replenishment: {e}")
