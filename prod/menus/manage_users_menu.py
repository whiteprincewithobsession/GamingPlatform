from routes.admin_route import show_all_users, delete_user, assign_role

def manage_users(session):
    print("\n--- Manage users ---")
    print("1. Show all users")
    print("2. Delete user")
    print("3. Assign role")
    print("4. Back")

    choice = input("Выберите действие: ")
    if choice == "1":
        show_all_users(session)
    elif choice == "2":
        delete_user(session)
    elif choice == "3":
        assign_role(session)
    elif choice == "4":
        return
    else:
        print("Incorrect input. Try again.")