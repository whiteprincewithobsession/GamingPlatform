from routes.friends_route import get_friends_list, add_friend, \
    send_message, view_messages, handle_friend_request, remove_friend

def social_menu(session, user_id):
    while True:
        print("\n--- Social Menu ---")
        print("1. View Friends List")
        print("2. Add Friend")
        print("3. Handle Friend Requests")
        print("4. Send Message")
        print("5. View Chat History")
        print("6. Remove Friend")  
        print("7. Back to Main Menu")
        
        choice = input("Choose an action: ")
        
        if choice == "1":
            get_friends_list(session, user_id)
        elif choice == "2":
            add_friend(session, user_id)
        elif choice == "3":
            handle_friend_request(session, user_id)
        elif choice == "4":
            send_message(session, user_id)
        elif choice == "5":
            view_messages(session, user_id)
        elif choice == "6": 
            remove_friend(session, user_id)
        elif choice == "7":
            print("Returning to main menu...")
            break
        else:
            print("Incorrect choice. Try again.")