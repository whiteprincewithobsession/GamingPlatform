/* ADD GAME ACHIEVEMENT */

CREATE OR REPLACE PROCEDURE AddAchievement(
    p_game_id INTEGER,
    p_title VARCHAR(63),
    p_overview TEXT,
    p_points INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Achievements (GameID, Title, Overview, Points)
    VALUES (p_game_id, p_title, p_overview, p_points);
END;
$$;


/* SEND MESSAGE */

CREATE OR REPLACE PROCEDURE SendMessage(
    p_sender_id INTEGER,
    p_receiver_id INTEGER,
    p_content TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO ChatMessages (SenderID, ReceiverID, Content, SendDate)
    VALUES (p_sender_id, p_receiver_id, p_content, CURRENT_TIMESTAMP);
END;
$$;

/* REGISTER NEW USER */

CREATE OR REPLACE PROCEDURE RegisterUser(
    p_username TEXT,
    p_email TEXT,
    p_password TEXT,
    p_fullname VARCHAR(127),
    p_bio TEXT,
    p_avatar VARCHAR(255),
    p_location VARCHAR(63),
    p_dob DATE
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Users (Username, Email, UserPassword, RegistrationDate)
    VALUES (p_username, p_email, p_password, CURRENT_DATE);

    INSERT INTO UserProfiles (UserID, FullName, Bio, Avatar, UserLocation, DateOfBirth)
    VALUES ((SELECT UserID FROM Users WHERE Email = p_email),
            p_fullname, p_bio, p_avatar, p_location, p_dob);
END;
$$;

/* SAVE GAME PROGRESS */

CREATE OR REPLACE PROCEDURE SaveGameProgress(
    p_user_id INTEGER,
    p_game_id INTEGER,
    p_save_data TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM UserGames WHERE UserID = p_user_id AND GameID = p_game_id)
    THEN
        INSERT INTO GameProgress (UserID, GameID, SaveData, LastUpdated)
        VALUES (p_user_id, p_game_id, p_save_data, CURRENT_TIMESTAMP)
        ON CONFLICT (UserID, GameID) DO UPDATE
        SET SaveData = p_save_data, LastUpdated = CURRENT_TIMESTAMP;
    ELSE
        RAISE EXCEPTION 'This account does not have access to this game';
    END IF;
END;
$$;