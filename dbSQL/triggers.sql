/* LOGGING USER ACTIONS */

CREATE OR REPLACE FUNCTION log_user_activity()
RETURNS TRIGGER AS $$
BEGIN
    CASE TG_TABLE_NAME
        WHEN 'usergames' THEN
            IF (TG_OP = 'INSERT') THEN
                INSERT INTO UserActivityLog (UserID, Activity, LoggedAt)
                VALUES (NEW.UserID, 'Purchased game ID: ' || NEW.GameID, NOW());
            END IF;
            
        WHEN 'reviews' THEN
            IF (TG_OP = 'INSERT') THEN
                INSERT INTO UserActivityLog (UserID, Activity, LoggedAt)
                VALUES (NEW.UserID, 'Posted review for game ID: ' || NEW.GameID, NOW());
            ELSIF (TG_OP = 'UPDATE') THEN
                INSERT INTO UserActivityLog (UserID, Activity, LoggedAt)
                VALUES (NEW.UserID, 'Updated review for game ID: ' || NEW.GameID, NOW());
            ELSIF (TG_OP = 'DELETE') THEN
                INSERT INTO UserActivityLog (UserID, Activity, LoggedAt)
                VALUES (OLD.UserID, 'Deleted review for game ID: ' || OLD.GameID, NOW());
            END IF;
            
        WHEN 'friends' THEN
            IF (TG_OP = 'INSERT') THEN
                INSERT INTO UserActivityLog (UserID, Activity, LoggedAt)
                VALUES (NEW.UserID1, 'Added friend UserID: ' || NEW.UserID2, NOW());
            ELSIF (TG_OP = 'DELETE') THEN
                INSERT INTO UserActivityLog (UserID, Activity, LoggedAt)
                VALUES (OLD.UserID1, 'Removed friend UserID: ' || OLD.UserID2, NOW());
            END IF;
            
        WHEN 'userachievements' THEN
            IF (TG_OP = 'INSERT') THEN
                INSERT INTO UserActivityLog (UserID, Activity, LoggedAt)
                VALUES (NEW.UserID, 'Unlocked achievement ID: ' || NEW.AchievementID, NOW());
            END IF;
    END CASE;
    
    IF (TG_OP = 'DELETE') THEN
        RETURN OLD;
    ELSE
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER log_game_purchase
AFTER INSERT ON UserGames
FOR EACH ROW
EXECUTE FUNCTION log_user_activity();

CREATE TRIGGER log_review_actions
AFTER INSERT OR UPDATE OR DELETE ON Reviews
FOR EACH ROW
EXECUTE FUNCTION log_user_activity();

CREATE TRIGGER log_friendship_actions
AFTER INSERT OR DELETE ON Friends
FOR EACH ROW
EXECUTE FUNCTION log_user_activity();

CREATE TRIGGER log_achievement_unlock
AFTER INSERT ON UserAchievements
FOR EACH ROW
EXECUTE FUNCTION log_user_activity();


/*UPDATE USER CASH BALANCE */

CREATE OR REPLACE FUNCTION update_user_balance()
RETURNS TRIGGER AS $$
DECLARE
    user_balance NUMERIC(10, 2);
BEGIN
    SELECT CashBalance INTO user_balance
    FROM Users
    WHERE UserID = NEW.UserID;

    IF user_balance >= (SELECT Price FROM Games WHERE GameID = NEW.GameID) THEN
        UPDATE Users
        SET CashBalance = CashBalance - (SELECT Price FROM Games WHERE GameID = NEW.GameID)
        WHERE UserID = NEW.UserID;
    ELSE
        RAISE EXCEPTION 'Not enough money to buy';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_balance_trigger
AFTER INSERT ON UserGames
FOR EACH ROW
EXECUTE FUNCTION update_user_balance();


/* ADD GAME FOR USER AFTER PURCHASING */

CREATE OR REPLACE FUNCTION add_user_game()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.TrType = (SELECT TypeID FROM TransactionType WHERE TypeName = 'Purchase') THEN
        INSERT INTO UserGames (UserID, GameID, PurchaseDate)
        VALUES (NEW.UserID, NEW.GameID, CURRENT_DATE);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER add_user_game_trigger
AFTER INSERT ON Transactions
FOR EACH ROW
EXECUTE PROCEDURE add_user_game();