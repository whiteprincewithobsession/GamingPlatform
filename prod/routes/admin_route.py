from sqlalchemy import text

def show_all_users(session):
    query = text("""
        SELECT u.UserID, u.Username, u.Email, r.RoleName
        FROM Users u
        LEFT JOIN UserProfiles p ON u.UserID = p.UserID
        LEFT JOIN Roles r ON p.RoleID = r.RoleID
        ORDER BY u.UserID
    """)
    result = session.execute(query).mappings().fetchall()

    print("\n--- Users ---")
    for user in result:
        print(f"ID: {user['userid']} | Username: {user['username']} | Email: {user['email']} | Role: {user['rolename']}")


def delete_user(session):
    user_id = input("Enter ID of user to delete: ")
    try:
        query = text("""
            DELETE FROM Friends WHERE UserID1 = :user_id OR UserID2 = :user_id;
            DELETE FROM UserAchievements WHERE UserID = :user_id;
            DELETE FROM UserGames WHERE UserID = :user_id;
            DELETE FROM UserActivityLog WHERE UserID = :user_id;
            DELETE FROM ChatMessages WHERE SenderID = :user_id OR ReceiverID = :user_id;
            DELETE FROM GameProgress WHERE UserID = :user_id;
            DELETE FROM Transactions WHERE UserID = :user_id;
            DELETE FROM Reviews WHERE UserID = :user_id;
            DELETE FROM UserProfiles WHERE UserID = :user_id;
            DELETE FROM Users WHERE UserID = :user_id;
        """)
        session.execute(query, {"user_id": user_id})
        session.commit()
        print("User successfully deleted.")
    except Exception as e:
        session.rollback()
        print(f"Error occured in delete_user: {e}")
  
        
def assign_role(session):
    user_id = input("Enter ID of user to assign a role: ")

    query_roles = text("SELECT RoleID, RoleName FROM Roles ORDER BY RoleID")
    roles = session.execute(query_roles).mappings().fetchall()

    if not roles:
        print("No roles available.")
        return
    
    print("\n--- Available Roles ---")
    for role in roles:
        print(f"RoleID: {role['roleid']} | RoleName: {role['rolename']}")

    role_id = input("Enter RoleID to assign to the user: ")

    try:
        check_user_query = text("SELECT UserID FROM Users WHERE UserID = :user_id")
        user = session.execute(check_user_query, {"user_id": user_id}).mappings().fetchone()

        if not user:
            print(f"User with ID {user_id} does not exist.")
            return

        query_assign_role = text("""
            UPDATE UserProfiles 
            SET RoleID = :role_id
            WHERE UserID = :user_id
        """)

        session.execute(query_assign_role, {"role_id": role_id, "user_id": user_id})
        session.commit()
        print(f"Role successfully assigned to user with ID {user_id}.")
    except Exception as e:
        session.rollback()
        print(f"Error occurred in assign_role: {e}")