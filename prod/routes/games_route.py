from sqlalchemy import text
from datetime import datetime
import uuid

def get_games_with_tags(session):
    query = text("""
        SELECT g.Title, string_agg(t.TagName, ', ') AS Tags
        FROM Games g
        LEFT JOIN GameTags gt ON g.GameID = gt.GameID
        LEFT JOIN Tags t ON gt.TagID = t.TagID
        GROUP BY g.Title;
    """)

    result = session.execute(query)
    games_with_tags = result.fetchall()

    return [{"Title": title, "Tags": tags} for title, tags in games_with_tags]

def get_short_info_all_games(session):
    query = text("""
        SELECT 
            g.GameID,  -- Добавляем GameID в выборку
            g.Title, 
            string_agg(t.TagName, ', ') AS Tags, 
            g.Price, 
            g.ViewRestriction AS restr
        FROM Games g
        LEFT JOIN GameTags gt ON g.GameID = gt.GameID
        LEFT JOIN Tags t ON gt.TagID = t.TagID
        GROUP BY g.GameID, g.Title, g.Price, g.ViewRestriction
        ORDER BY g.GameID;
    """)    
    result = session.execute(query).mappings().fetchall()

    if not result:
        print("\n--- No games found ---")
        return []

    print("\n--- All games ---")
    print(f"{'GameID':<10} {'Title':<30} {'Tags':<50} {'Price':<10} {'Restriction':<15}")
    print("-" * 120)
    
    for row in result:
        game_id = row['gameid']
        title = row['title'] if row['title'] is not None else "Unknown"
        tags = row['tags'] if row['tags'] is not None else "No tags"
        price = f"{row['price']:.2f}" if row['price'] is not None else "0.00"
        restriction = "18+" if row['restr'] else "Any age"

        print(f"{game_id:<10} {title:<30} {tags:<50} {price:<10} {restriction:<15}")
        

def get_info_all_tags(session):
    query = text("""
        SELECT tagname, tagdescription FROM Tags
    """)    
    result = session.execute(query).mappings().fetchall()
    
    if not result:
        print("\n--- No tags found ---")
        return []
    
    print(f"{'Tag Name':<30} {'Description':<50}")
    print("-" * 80)    
    for row in result:
        tag_name = row['tagname'] if row['tagname'] is not None else "Unknown"
        tag_description = row['tagdescription'] if row['tagdescription'] is not None else "No description"
        
        print(f"{tag_name:<30} {tag_description:<50}")


def get_game_details(session, game_id):
    game_query = text("""
        SELECT Title, GameDescription, ReleaseDate, Developer, Price, ViewRestriction
        FROM Games
        WHERE GameID = :game_id
    """)  
    achievements_query = text("""
        SELECT Title, Overview, Points
        FROM Achievements
        WHERE GameID = :game_id
    """)
    
    try:
        game_result = session.execute(game_query, {"game_id": game_id}).mappings().first()
        
        if not game_result:
            print("Game not found!")
            return
        
        print("\n--- Game Details ---")
        print(f"Title: {game_result['title']}")
        print(f"Description: {game_result['gamedescription']}")
        print(f"Release Date: {game_result['releasedate']}")
        print(f"Developer: {game_result['developer']}")
        print(f"Price: ${game_result['price']:.2f}")
        print(f"Age Restriction: {'18+' if game_result['viewrestriction'] else 'Any age'}")
        
        achievements_result = session.execute(achievements_query, {"game_id": game_id}).mappings().fetchall()
        
        if achievements_result:
            print("\n--- Achievements ---")
            for achievement in achievements_result:
                print(f"Title: {achievement['title']}")
                print(f"Overview: {achievement['overview']}")
                print(f"Points: {achievement['points']}")
                print("---")
        else:
            print("\nNo achievements found for this game.")
        
    except Exception as e:
        print(f"An error occurred: {e}")

def buy_game(session, game_id, user_id):
    owned_query = text("""
        SELECT 1 FROM UserGames
        WHERE UserID = :user_id AND GameID = :game_id
    """)
    
    if session.execute(owned_query, {"user_id": user_id, "game_id": game_id}).first():
        print("\nYou already own this game!")
        return

    user_query = text("""
        SELECT 
            u.Username,
            u.CashBalance,
            EXTRACT(YEAR FROM AGE(CURRENT_DATE, up.DateOfBirth)) as age
        FROM Users u
        JOIN UserProfiles up ON u.UserID = up.UserID
        WHERE u.UserID = :user_id
    """)
    
    user_info = session.execute(user_query, {"user_id": user_id}).mappings().first()
    
    if not user_info:
        print("\nUser information not found!")
        return

    game_query = text("""
        SELECT Title, Price, ViewRestriction
        FROM Games
        WHERE GameID = :game_id
    """)
    
    game_info = session.execute(game_query, {"game_id": game_id}).mappings().first()
    
    if not game_info:
        print("\nGame not found!")
        return

    print(f"\nYou are about to buy '{game_info['title']}'")
    print(f"Price: ${game_info['price']:.2f}")
    
    if game_info['viewrestriction'] and user_info['age'] < 18:
        print("Sorry, you must be 18 or older to buy this game.")
        return

    if user_info['cashbalance'] < game_info['price']:
        print("Insufficient funds to purchase this game.")
        print(f"Your balance: ${user_info['cashbalance']:.2f}")
        return

    confirm = input("\nDo you want to proceed with the purchase? (yes/no): ")
    if confirm.lower() == 'yes':
        print(user_info['cashbalance'], game_info['price'])

        try:
            
            add_game_query = text("""
                INSERT INTO UserGames (UserID, GameID, PurchaseDate, PlayTime)
                VALUES (:user_id, :game_id, CURRENT_DATE, 0)
            """)
            
            add_log_query = text("""
                INSERT INTO UserActivityLog (UserID, Activity, LoggedAt)
                VALUES (:user_id, :activity, :timestamp)
            """)
            
            add_transaction_query = text("""
                INSERT INTO Transactions 
                (TransactionCode, UserID, GameID, Amount, TrType, TransactionTime)
                VALUES (:tr_code, :user_id, :game_id, :amount, 
                (SELECT TypeID FROM TransactionType WHERE TypeName = 'Purchase'), :tr_time)
            """)

            session.execute(add_game_query, {
                "user_id": user_id,
                "game_id": game_id
            })
            
            session.execute(add_log_query, {
                "user_id": user_id,
                "activity": f"Purchased game: {game_info['title']}",
                "timestamp": datetime.now()
            })
            
            session.execute(add_transaction_query, {
                "tr_code": str(uuid.uuid4()),
                "user_id": user_id,
                "game_id": game_id,
                "amount": game_info['price'],
                "tr_time": datetime.now()
            })

            session.commit()
            
            updated_balance_query = text("""
                SELECT CashBalance 
                FROM Users 
                WHERE UserID = :user_id
            """)
            
            new_balance = session.execute(updated_balance_query, {
                "user_id": user_id
            }).scalar()
            
            print(f"\nSuccessfully purchased '{game_info['title']}'!")
            print(f"New balance: ${new_balance:.2f}")
            
        except Exception as e:
            session.rollback()
            if "Not enough money to buy" in str(e):
                print("Insufficient funds to purchase this game.")
            else:
                print(f"Error during purchase: {e}")
    else:
        print("\nPurchase cancelled.")
        
        
def get_user_games(session, user_id):
    query = text("""
        SELECT 
            g.GameID,
            g.Title,
            ug.PurchaseDate,
            ug.PlayTime,
            string_agg(t.TagName, ', ') AS Tags,
            g.ViewRestriction
        FROM UserGames ug
        JOIN Games g ON ug.GameID = g.GameID
        LEFT JOIN GameTags gt ON g.GameID = gt.GameID
        LEFT JOIN Tags t ON gt.TagID = t.TagID
        WHERE ug.UserID = :user_id
        GROUP BY g.GameID, g.Title, ug.PurchaseDate, ug.PlayTime, g.ViewRestriction
        ORDER BY ug.PurchaseDate DESC
    """)
    
    result = session.execute(query, {"user_id": user_id}).mappings().fetchall()
    
    if not result:
        print("\nYou don't have any games yet!")
        return
    
    print("\n--- Your Games ---")
    print(f"{'GameID':<10} {'Title':<30} {'Purchase Date':<15} {'Play Time':<15} {'Tags':<40} {'Restriction':<10}")
    print("-" * 120)
    
    for game in result:
        game_id = game['gameid']
        title = game['title']
        purchase_date = game['purchasedate'].strftime('%Y-%m-%d')
        
        play_time = game['playtime']
        hours = play_time // 3600
        minutes = (play_time % 3600) // 60
        play_time_str = f"{hours}h {minutes}m"
        
        tags = game['tags'] if game['tags'] else "No tags"
        restriction = "18+" if game['viewrestriction'] else "Any age"
        
        print(f"{game_id:<10} {title:<30} {purchase_date:<15} {play_time_str:<15} {tags:<40} {restriction:<10}")