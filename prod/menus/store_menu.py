from routes.games_route import get_short_info_all_games
from routes.games_route import get_info_all_tags
from routes.games_route import get_game_details
from routes.games_route import buy_game
from routes.games_route import get_user_games
from routes.publisher_route import add_game_to_store

def store_menu(session, user_id, role_name):
    while True:
        print("\n--- Store Menu ---")
        print("1. Show all games")
        print("2. See more about game")
        print("3. Buy game")
        print("4. Read more about tags for games")
        print("5. My games")
        print("6. Back to main menu")
        if role_name == "Publisher":
            print("7. Add new game")
        
        choice = input("Choose an action: ")

        if choice == "1":
            get_short_info_all_games(session)
        elif choice == "2":
            game_id = input("Enter game ID: ")
            try:
                get_game_details(session, int(game_id))
            except ValueError:
                print("Invalid game ID!")
        elif choice == "3":
            game_id = input("Enter game ID: ")
            try:
                buy_game(session, int(game_id), user_id)
            except ValueError:
                print("Invalid game ID!")
        elif choice == "4":
            get_info_all_tags(session)
        elif choice == "5":
            get_user_games(session, user_id)
        elif choice == "6":
            print("Returning to main menu...")
            break
        elif choice == "7" and role_name == "Publisher":
            add_game_to_store(session, user_id)
        else:
            print("Incorrect choice. Try again.")