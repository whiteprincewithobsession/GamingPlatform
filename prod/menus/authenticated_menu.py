from menus.manage_users_menu import manage_users
from routes.user_route import view_profile
from menus.store_menu import store_menu
from menus.social_menu import social_menu
from menus.edit_profile_menu import edit_profile_menu
from routes.user_route import add_balance

def authenticated_menu(session, user_id, role_name):
    while True:
        print("\n--- User Menu ---")
        print("1. View Profile")
        print("2. Edit Profile")
        print("3. Game Store")
        print("4. Social")
        print("5. Donate Money")
        print("6. Logout")
        if role_name == "Admin":
            print("7. Manage Users")
        choice = input("Choose an action: ")

        if choice == "1":
            view_profile(session, user_id)
        elif choice == "2":
            edit_profile_menu(session, user_id)
        elif choice == "3":
            store_menu(session, user_id, role_name)
        elif choice == "4":
            social_menu(session, user_id)
        elif choice == "5":
            add_balance(session, user_id)
        elif choice == "7" and role_name == "Admin":
            manage_users(session)
        elif choice == "6":
            print("Logging out...")
            break
        else:
            print("Incorrect choice. Try again.")