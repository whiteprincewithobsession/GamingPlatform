/* ALL USER GAMES AND TIME SPENT */

CREATE VIEW user_game_playtime AS
SELECT u.Username, g.Title, ug.PurchaseDate, ug.PlayTime
FROM Users u
JOIN UserGames ug ON u.UserID = ug.UserID
JOIN Games g ON ug.GameID = g.GameID;

/* REVIEW INFORMATION */

CREATE VIEW game_reviews AS
SELECT u.Username, g.Title, r.Rating, r.Content, r.PostDate
FROM Reviews r
JOIN Users u ON r.UserID = u.UserID
JOIN Games g ON r.GameID = g.GameID;

/* GAME ACHIEVEMENTS OF USERS */

CREATE VIEW vw_user_achievements AS
SELECT u.Username, g.Title, a.Title AS AchievementTitle, ua.UnlockDate
FROM Users u
JOIN UserAchievements ua ON u.UserID = ua.UserID
JOIN Achievements a ON ua.AchievementID = a.AchievementID
JOIN Games g ON a.GameID = g.GameID;