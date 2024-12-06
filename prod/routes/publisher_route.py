from datetime import datetime
from sqlalchemy import text

def add_game_to_store(session, user_id):
    role_check_query = text("""
        SELECT r.RoleName 
        FROM UserProfiles up
        JOIN Roles r ON up.RoleID = r.RoleID
        WHERE up.UserID = :user_id
    """)
    
    user_role = session.execute(role_check_query, {"user_id": user_id}).scalar()
    
    if user_role != 'Publisher':
        print("You do not have permission to add games to the store.")
        return
    
    try:
        print("\n--- Add New Game ---")        
        title = input("Enter game title: ").strip()
        description = input("Enter game description: ").strip()
        
        unique_title_query = text("""
            SELECT COUNT(*) FROM Games WHERE Title = :title
        """)
        title_count = session.execute(unique_title_query, {"title": title}).scalar()
        
        if title_count > 0:
            print("A game with this title already exists.")
            return
        
        while True:
            try:
                release_date_str = input("Enter release date (YYYY-MM-DD): ")
                release_date = datetime.strptime(release_date_str, "%Y-%m-%d").date()
                break
            except ValueError:
                print("Invalid date format. Use YYYY-MM-DD.")
        
        developer = input("Enter developer name: ").strip()
        
        while True:
            try:
                price = float(input("Enter game price: "))
                if price < 0:
                    print("Price cannot be negative.")
                    continue
                break
            except ValueError:
                print("Invalid price. Please enter a number.")
        
        while True:
            view_restriction_input = input("Is this game 18+? (yes/no): ").lower()
            if view_restriction_input in ['yes', 'no']:
                view_restriction = view_restriction_input == 'yes'
                break
            print("Please enter 'yes' or 'no'.")
        
        add_game_query = text("""
            INSERT INTO Games (Title, GameDescription, ReleaseDate, Developer, Price, ViewRestriction)
            VALUES (:title, :description, :release_date, :developer, :price, :view_restriction)
            RETURNING GameID
        """)
        
        game_result = session.execute(add_game_query, {
            "title": title,
            "description": description,
            "release_date": release_date,
            "developer": developer,
            "price": price,
            "view_restriction": view_restriction
        })
        
        new_game_id = game_result.scalar()
        
        print("\nAdd tags for the game (enter 'done' when finished):")
        while True:
            tag_name = input("Enter tag name: ").strip()
            
            if tag_name.lower() == 'done':
                break
            
            tag_query = text("""
                SELECT TagID FROM Tags WHERE TagName = :tag_name
            """)
            tag_result = session.execute(tag_query, {"tag_name": tag_name}).fetchone()
            
            if not tag_result:
                tag_desc = input("Input description for tag:")
                create_tag_query = text("""
                    INSERT INTO Tags (TagName, TagDescription)
                    VALUES (:tag_name, :tag_desc)
                    RETURNING TagID
                """)
                tag_id = session.execute(create_tag_query, {"tag_name": tag_name}).scalar()
            else:
                tag_id = tag_result[0]
            
            link_tag_query = text("""
                INSERT INTO GameTags (TagID, GameID)
                VALUES (:tag_id, :game_id)
            """)
            session.execute(link_tag_query, {
                "tag_id": tag_id,
                "game_id": new_game_id
            })
        
        print("\nAdd achievements for the game (enter 'done' when finished):")
        while True:
            achievement_title = input("Enter achievement title: ").strip()
            
            if achievement_title.lower() == 'done':
                break
            
            achievement_overview = input("Enter achievement overview: ").strip()
            
            while True:
                try:
                    achievement_points = int(input("Enter achievement points: "))
                    break
                except ValueError:
                    print("Please enter a valid number of points.")
            
            add_achievement_query = text("""
                INSERT INTO Achievements (GameID, Title, Overview, Points)
                VALUES (:game_id, :title, :overview, :points)
            """)
            session.execute(add_achievement_query, {
                "game_id": new_game_id,
                "title": achievement_title,
                "overview": achievement_overview,
                "points": achievement_points
            })
        
        log_query = text("""
            INSERT INTO UserActivityLog (UserID, Activity, LoggedAt)
            VALUES (:user_id, :activity, :timestamp)
        """)
        session.execute(log_query, {
            "user_id": user_id,
            "activity": f"Added new game: {title}",
            "timestamp": datetime.now()
        })
        
        session.commit()
        
        print(f"\nGame '{title}' successfully added to the store!")
        
    except Exception as e:
        session.rollback()
        print(f"Error adding game: {e}")
