/* MOST QUERRIES CAN BE SUPPLEMENTED BY OFFSETTING COMMAND */

/* ALL GAMES WITH ALL TAGS COMPLETE */

SELECT g.Title, string_agg(t.TagName, ', ') AS Tags
FROM Games g
LEFT JOIN GameTags gt ON g.GameID = gt.GameID
LEFT JOIN Tags t ON gt.TagID = t.TagID
GROUP BY g.Title;

/* ALL ACHIEVEMENTS IN GAME COMPLETE */

SELECT a.Title, a.Overview, a.Points
FROM Achievements a
JOIN Games g ON a.GameID = g.GameID
WHERE g.Title = 'God of War';

/* AMOUNT OF GAMES ON ACCOUNT OF SIGNLE USER COMPLETE */

SELECT u.UserID, u.Username, COUNT(ug.GameID) AS GameCount
FROM Users u
LEFT JOIN Usergames ug ON u.UserID = ug.UserID
GROUP BY u.UserID, u.Username
ORDER BY GameCount DESC;

/* ALL USER FRIENDS COMPLETE */

SELECT u.Username
FROM Users u
JOIN Friends f ON u.UserID = f.UserID1 OR u.UserID = f.UserID2
WHERE (f.UserID1 = (SELECT UserID FROM Users WHERE Username = 'ded1ns1de')
   OR f.UserID2 = (SELECT UserID FROM Users WHERE Username = 'ded1ns1de'))
  AND u.UserID <> (SELECT UserID FROM Users WHERE Username = 'ded1ns1de');

/* DELETE FRIEND COMPLETE */

DELETE FROM Friends
WHERE (UserID1 = :user1_id AND UserID2 = :user2_id)
   OR (UserID1 = :user2_id AND UserID2 = :user1_id);

/* ALL USER TRANSACTIONS */

SELECT t.TransactionCode, g.Title, t.Amount, tt.TypeName, t.TransactionTime
FROM Transactions t
JOIN Users u ON t.UserID = u.UserID
JOIN Games g ON t.GameID = g.GameID
JOIN TransactionType tt ON t.TrType = tt.TypeID
WHERE u.Username = 'egrFOREACH'
ORDER BY t.TransactionTime DESC;

/* LAST 10 CHAT MESSAGES FROM 2 USERS */
SELECT u.Username AS Sender, cm.Content, cm.SendDate
FROM ChatMessages cm
JOIN Users u ON cm.SenderID = u.UserID
WHERE (cm.SenderID = (SELECT UserID FROM Users WHERE Username = 'admin')
   AND cm.ReceiverID = (SELECT UserID FROM Users WHERE Username = 'rosto4eks'))
   OR (cm.SenderID = (SELECT UserID FROM Users WHERE Username = 'rosto4eks')
   AND cm.ReceiverID = (SELECT UserID FROM Users WHERE Username = 'admin'))
ORDER BY cm.SendDate DESC
LIMIT 10;

/* ALL USERS AND THEIR ROLES */

SELECT u.Username, r.RoleName, up.FullName, up.Bio, up.UserLocation, up.DateOfBirth
FROM Users u
JOIN UserProfiles up ON u.UserID = up.UserID
JOIN Roles r ON up.RoleID = r.   RoleID;

/* ALL USERS BOUGTH SPECIFIC GAME */

SELECT u.Username
FROM Users u
JOIN UserGames ug ON u.UserID = ug.UserID
JOIN Games g ON ug.GameID = g.GameID
WHERE g.Title = 'God of War';

/* AUTHORIZATION */

SELECT UserID, Username, Email
FROM Users
WHERE Email = 'forinov@gmail.com'
  AND UserPassword = 'easyPassword12';

/* CHANGE PASSWORD */

UPDATE Users
SET UserPassword = 'NewPassword'
WHERE UserID = 5;

/* CHECK UNIQUE EMAIL */

SELECT EXISTS (
    SELECT 1
    FROM Users
    WHERE Email = 'forinov@gmail.com'
) AS EmailExists;

/* ALL USER ACTIVITIES */

SELECT u.Username, ual.Activity, ual.LoggedAt
FROM UserActivityLog ual
JOIN Users u ON ual.UserID = u.UserID
WHERE u.Username = 'ekstremumSTRWEB'
ORDER BY ual.LoggedAt DESC;

/* DELETE GAME */

DELETE FROM Games
 WHERE GameID = 1337228;

/* CREATE TRANSACTION */

INSERT INTO Transactions (TransactionCode, UserID, GameID, Amount, TrType, TransactionTime)
VALUES (
    (gen_random_uuid()),
    (SELECT UserID FROM Users WHERE Username = 'rosto4eks'),
    (SELECT GameID FROM Games WHERE Title = 'Horizon Zero Dawn'),
    (SELECT Price FROM Games WHERE Title = 'Horizon Zero Dawn'),
    1,
    CURRENT_TIMESTAMP
);