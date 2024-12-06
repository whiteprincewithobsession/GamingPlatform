from sqlalchemy import text
from routes.edit_route import update_profile_field
from routes.user_route import view_profile

def edit_profile_menu(session, user_id):
    while True:
        try:
            query = text("""
                SELECT p.FullName, p.Bio, p.Avatar, p.UserLocation, p.DateOfBirth
                FROM UserProfiles p
                WHERE p.UserID = :user_id
            """)
            result = session.execute(query, {"user_id": user_id}).mappings().fetchone()

            if not result:
                print("Профиль не найден.")
                return

            print("\n--- Edit Profile Menu ---")
            print("1. Change Full Name")
            print("2. Change Bio")
            print("3. Change Avatar URL")
            print("4. Change Location")
            print("5. Change Birthdate")
            print("6. View Current Profile")
            print("7. Exit to Main Menu")
            choice = input("Choose an option: ")

            if choice == "1":
                print(f"Current Full Name: {result['fullname']}")
                full_name = input("Enter new full name (or press Enter to skip): ")
                if full_name:
                    update_profile_field(session, user_id, "FullName", full_name)

            elif choice == "2":
                print(f"Current Bio: {result['bio']}")
                bio = input("Enter new bio (or press Enter to skip): ")
                if bio:
                    update_profile_field(session, user_id, "Bio", bio)

            elif choice == "3":
                print(f"Current Avatar URL: {result['avatar']}")
                avatar = input("Enter new avatar URL (or press Enter to skip): ")
                if avatar:
                    update_profile_field(session, user_id, "Avatar", avatar)

            elif choice == "4":
                print(f"Current Location: {result['userlocation']}")
                location = input("Enter new location (or press Enter to skip): ")
                if location:
                    update_profile_field(session, user_id, "UserLocation", location)

            elif choice == "5":
                print(f"Current Birthdate: {result['dateofbirth']}")
                dob = input("Enter new birthdate (YYYY-MM-DD, or press Enter to skip): ")
                if dob:
                    update_profile_field(session, user_id, "DateOfBirth", dob)

            elif choice == "6":
                view_profile(session, user_id)

            elif choice == "7":
                print("Exiting to main menu...")
                break

            else:
                print("Invalid choice. Please try again.")

        except Exception as e:
            session.rollback()
            print(f"Error during profile editing: {e}")