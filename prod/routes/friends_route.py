from sqlalchemy import text
from datetime import datetime

def get_friends_list(session, user_id):
    query = text("""
        SELECT 
            u.UserID,
            u.Username,
            up.FullName,
            f.Status,
            CASE 
                WHEN f.UserID1 = :user_id THEN 'Outgoing'
                ELSE 'Incoming'
            END as request_type
        FROM Friends f
        JOIN Users u ON (f.UserID1 = u.UserID OR f.UserID2 = u.UserID)
        JOIN UserProfiles up ON u.UserID = up.UserID
        WHERE (f.UserID1 = :user_id OR f.UserID2 = :user_id)
            AND u.UserID != :user_id
    """)
    
    result = session.execute(query, {"user_id": user_id}).mappings().fetchall()
    
    if not result:
        print("\nYou don't have any friends or pending requests!")
        return []
    
    print("\n--- Your Friends and Requests ---")
    print(f"{'UserID':<10} {'Username':<20} {'Full Name':<30} {'Status':<15}")
    print("-" * 75)
    
    for friend in result:
        status_str = f"{friend['status']}"
        if friend['status'] == 'PENDING':
            status_str += f" ({friend['request_type']})"
        print(f"{friend['userid']:<10} {friend['username']:<20} {friend['fullname']:<30} {status_str:<15}")
    
    return result

def add_friend(session, user_id):
    username = input("Enter username of the person you want to add as friend: ")
    
    query = text("""
        SELECT UserID FROM Users 
        WHERE Username = :username AND UserID != :user_id
    """)
    
    result = session.execute(query, {
        "username": username,
        "user_id": user_id
    }).first()
    
    if not result:
        print("User not found or you're trying to add yourself!")
        return
    
    friend_id = result[0]
    
    check_query = text("""
        SELECT Status, UserID1, UserID2 
        FROM Friends 
        WHERE (UserID1 = :user_id AND UserID2 = :friend_id)
           OR (UserID1 = :friend_id AND UserID2 = :user_id)
    """)
    
    existing = session.execute(check_query, {
        "user_id": user_id,
        "friend_id": friend_id
    }).first()
    
    if existing:
        if existing.Status == 'ACCEPTED':
            print("You are already friends!")
        elif existing.Status == 'PENDING':
            if existing.UserID1 == user_id:
                print("You already sent a friend request to this user!")
            else:
                print("This user already sent you a friend request! Check your pending requests.")
        return
    
    try:
        add_query = text("""
            INSERT INTO Friends (UserID1, UserID2, Status)
            VALUES (:user_id, :friend_id, 'PENDING')
        """)
        
        session.execute(add_query, {
            "user_id": user_id,
            "friend_id": friend_id
        })
        
        session.commit()
        print(f"Friend request sent to {username}!")
    except Exception as e:
        session.rollback()
        print(f"Error sending friend request: {e}")

def handle_friend_request(session, user_id):
    query = text("""
        SELECT 
            u.UserID,
            u.Username,
            up.FullName
        FROM Friends f
        JOIN Users u ON f.UserID1 = u.UserID
        JOIN UserProfiles up ON u.UserID = up.UserID
        WHERE f.UserID2 = :user_id 
        AND f.Status = 'PENDING'
    """)
    
    requests = session.execute(query, {"user_id": user_id}).mappings().fetchall()
    
    if not requests:
        print("\nNo pending friend requests!")
        return
    
    print("\n--- Pending Friend Requests ---")
    print(f"{'UserID':<10} {'Username':<20} {'Full Name':<30}")
    print("-" * 60)
    
    for req in requests:
        print(f"{req['userid']:<10} {req['username']:<20} {req['fullname']:<30}")
    
    requester_id = input("\nEnter UserID to accept/reject (or 0 to cancel): ")
    try:
        requester_id = int(requester_id)
        if requester_id == 0:
            return
        
        if not any(req['userid'] == requester_id for req in requests):
            print("Invalid UserID!")
            return
        
        action = input("Do you want to accept this request? (yes/no): ").lower()
        if action not in ['yes', 'no']:
            print("Invalid choice!")
            return
        
        status = 'ACCEPTED' if action == 'yes' else 'REJECTED'
        
        update_query = text("""
            UPDATE Friends 
            SET Status = :status
            WHERE UserID1 = :requester_id AND UserID2 = :user_id
        """)
        
        session.execute(update_query, {
            "status": status,
            "requester_id": requester_id,
            "user_id": user_id
        })
        
        session.commit()
        print(f"Friend request {status.lower()}!")
        
    except ValueError:
        print("Invalid UserID!")
    except Exception as e:
        session.rollback()
        print(f"Error handling friend request: {e}")

def send_message(session, user_id):
    query = text("""
        SELECT 
            u.UserID,
            u.Username,
            up.FullName
        FROM Friends f
        JOIN Users u ON (f.UserID1 = u.UserID OR f.UserID2 = u.UserID)
        JOIN UserProfiles up ON u.UserID = up.UserID
        WHERE ((f.UserID1 = :user_id AND f.UserID2 = u.UserID)
           OR (f.UserID2 = :user_id AND f.UserID1 = u.UserID))
           AND f.Status = 'ACCEPTED'
           AND u.UserID != :user_id
    """)
    
    friends = session.execute(query, {"user_id": user_id}).mappings().fetchall()
    
    if not friends:
        print("\nYou don't have any confirmed friends to message!")
        return
    
    print("\n--- Your Friends ---")
    print(f"{'UserID':<10} {'Username':<20} {'Full Name':<30}")
    print("-" * 60)
    
    for friend in friends:
        print(f"{friend['userid']:<10} {friend['username']:<20} {friend['fullname']:<30}")
    
    friend_id = input("\nEnter UserID to message: ")
    try:
        friend_id = int(friend_id)
        if not any(friend['userid'] == friend_id for friend in friends):
            print("You can only send messages to confirmed friends!")
            return
        
        message = input("Enter your message: ")
        if not message.strip():
            print("Message cannot be empty!")
            return
        
        query = text("""
            CALL SendMessage(:sender_id, :receiver_id, :content)
        """)
        
        session.execute(query, {
            "sender_id": user_id,
            "receiver_id": friend_id,
            "content": message
        })
        
        session.commit()
        print("Message sent successfully!")
    except ValueError:
        print("Invalid UserID!")
    except Exception as e:
        session.rollback()
        print(f"Error sending message: {e}")
        
def view_messages(session, user_id):
    query = text("""
        SELECT 
            u.UserID,
            u.Username,
            up.FullName
        FROM Friends f
        JOIN Users u ON (f.UserID1 = u.UserID OR f.UserID2 = u.UserID)
        JOIN UserProfiles up ON u.UserID = up.UserID
        WHERE ((f.UserID1 = :user_id AND f.UserID2 = u.UserID)
           OR (f.UserID2 = :user_id AND f.UserID1 = u.UserID))
           AND f.Status = 'ACCEPTED'
           AND u.UserID != :user_id
    """)
    
    friends = session.execute(query, {"user_id": user_id}).mappings().fetchall()
    
    if not friends:
        print("\nYou don't have any confirmed friends to view messages!")
        return
    
    print("\n--- Your Friends ---")
    print(f"{'UserID':<10} {'Username':<20} {'Full Name':<30}")
    print("-" * 60)
    
    for friend in friends:
        print(f"{friend['userid']:<10} {friend['username']:<20} {friend['fullname']:<30}")
    
    friend_id = input("\nEnter UserID to view chat history: ")
    try:
        friend_id = int(friend_id)
        if not any(friend['userid'] == friend_id for friend in friends):
            print("You can only view messages with confirmed friends!")
            return
        
        messages_query = text("""
            SELECT 
                m.MessageID,
                sender.Username as sender_name,
                m.Content,
                m.SendDate
            FROM ChatMessages m
            JOIN Users sender ON m.SenderID = sender.UserID
            WHERE (m.SenderID = :user_id AND m.ReceiverID = :friend_id)
               OR (m.SenderID = :friend_id AND m.ReceiverID = :user_id)
            ORDER BY m.SendDate DESC
            LIMIT 20
        """)
        
        messages = session.execute(messages_query, {
            "user_id": user_id,
            "friend_id": friend_id
        }).mappings().fetchall()
        
        if not messages:
            print("\nNo messages found!")
            return
        
        print("\n--- Chat History (Last 20 messages) ---")
        print("-" * 80)
        for message in messages:
            timestamp = message['senddate'].strftime('%Y-%m-%d %H:%M:%S')
            print(f"[{timestamp}] {message['sender_name']}: {message['content']}")
            
    except ValueError:
        print("Invalid UserID!")
    except Exception as e:
        print(f"Error viewing messages: {e}")


def remove_friend(session, user_id):
    query = text("""
        SELECT 
            u.UserID,
            u.Username,
            up.FullName
        FROM Friends f
        JOIN Users u ON (f.UserID1 = u.UserID OR f.UserID2 = u.UserID)
        JOIN UserProfiles up ON u.UserID = up.UserID
        WHERE ((f.UserID1 = :user_id AND f.UserID2 = u.UserID)
           OR (f.UserID2 = :user_id AND f.UserID1 = u.UserID))
           AND f.Status = 'ACCEPTED'
           AND u.UserID != :user_id
    """)
    
    friends = session.execute(query, {"user_id": user_id}).mappings().fetchall()
    
    if not friends:
        print("\nYou don't have any confirmed friends to remove!")
        return
    
    print("\n--- Your Friends ---")
    print(f"{'UserID':<10} {'Username':<20} {'Full Name':<30}")
    print("-" * 60)
    
    for friend in friends:
        print(f"{friend['userid']:<10} {friend['username']:<20} {friend['fullname']:<30}")
    
    friend_id = input("\nEnter UserID to remove from friends (or 0 to cancel): ")
    try:
        friend_id = int(friend_id)
        if friend_id == 0:
            return
        
        if not any(friend['userid'] == friend_id for friend in friends):
            print("Invalid UserID! You can only remove confirmed friends.")
            return
        
        confirm = input(f"Are you sure you want to remove this person from your friends? (yes/no): ").lower()
        if confirm != 'yes':
            print("Operation canceled.")
            return
        
        delete_query = text("""
            DELETE FROM Friends 
            WHERE (UserID1 = :user_id AND UserID2 = :friend_id)
               OR (UserID1 = :friend_id AND UserID2 = :user_id)
        """)
        
        session.execute(delete_query, {
            "user_id": user_id,
            "friend_id": friend_id
        })
        
        session.commit()
        print("Friend removed successfully!")
    except ValueError:
        print("Invalid UserID!")
    except Exception as e:
        session.rollback()
        print(f"Error removing friend: {e}")