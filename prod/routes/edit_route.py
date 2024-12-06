from sqlalchemy import text
from datetime import datetime

def update_profile_field(session, user_id, field_name, new_value):
    try:
        update_query = text(f"""
            UPDATE UserProfiles
            SET {field_name} = :new_value
            WHERE UserID = :user_id
        """)
        session.execute(update_query, {
            "new_value": new_value,
            "user_id": user_id
        })

        add_log_query = text("""
            INSERT INTO UserActivityLog 
            (UserID, Activity, LoggedAt)
            VALUES (:user_id, :activity, :timestamp)
        """)
        session.execute(add_log_query, {
            "user_id": user_id,
            "activity": f"Updated {field_name} to '{new_value}'",
            "timestamp": datetime.now()
        })

        session.commit()
        print(f"{field_name} successfully updated!")
    except Exception as e:
        session.rollback()
        print(f"Error updating {field_name}: {e}")