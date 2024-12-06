from database_connection import session
from routes.user_route import register_user, authenticate_user
from menus.authenticated_menu import authenticated_menu

def main():

    while True:
        print("\n--- Main Menu ---")
        print("1. Register")
        print("2. Login")
        print("3. Exit")
        choice = input("Choose an action: ")

        if choice == "1":
            register_user(session)
        elif choice == "2":
            user_id, role_name = authenticate_user(session)
            if user_id:
                authenticated_menu(session, user_id, role_name)
        elif choice == "3":
            print("Exiting the program.")
            break
        else:
            print("Incorrect choice. Try again.")


if __name__ == "__main__":
    main()