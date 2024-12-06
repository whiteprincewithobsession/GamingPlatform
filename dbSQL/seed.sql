INSERT INTO Users (Username, Email, UserPassword, RegistrationDate, CashBalance)
VALUES
    ('admin', 'admin@admin.com', 'green837', '2009-01-12', 500),
    ('rosto4eks', 'aboba@gmail.com', '2281337', '2023-04-29', 0.01),
    ('pashkk_a', 'ppetrov228@bk.ru', 'pashaKrasyov', '2023-08-12', 5000.50),
    ('JasonStatham', 'jsonstatham@gmail.com', 'StathamFilms', '2019-01-15', 11.11),
    ('egrFOREACH', 'forinov@gmail.com', 'easyPassword12', '2022-02-05', 0.00),
    ('ded1ns1de', 'ivan_matsur@yahoo.com', 'password123!@', '2021-04-18', 642.00),
    ('stanislavSluma', 'bekarev_stanislav@company.org', 'Secur3P@ssword', '2023-02-28', 175.50),
    ('tokyoGul', 'anton_gulis@gmail.com', 'mypassword456', '2019-08-10', 2500.00),
    ('shershen', 'shershen_shershnev@outlook.com', 'P@ssw0rdSecure', '2022-07-02', 95.40),
    ('ekstremumSTRWEB', 'yarik02022005@mail.ru', 'Realmadrid22', '2020-12-31', 1.23);

INSERT INTO Roles (RoleName, FullDescription)
VALUES
    ('Admin', 'Full access to the system, including user management and configuration settings.'),
    ('Moderator', 'Monitor user-generated content, but cannot create or delete'),
    ('User', 'Default roots of user, to use platform'),
    ('Support', 'Provide assistance and troubleshoot user issues'),
    ('Publisher', 'Responsible for publishing and distributing games, managing game releases, and promoting game titles.');

INSERT INTO UserProfiles (UserID, RoleID, FullName, Bio, Avatar, UserLocation, DateOfBirth)
VALUES
    ((SELECT UserID FROM Users WHERE Username = 'admin' AND Email = 'admin@admin.com'), 1, 'Admin User', 'System Administrator', 'admin.png', 'New York, USA', '1985-05-15'),
    ((SELECT UserID FROM Users WHERE Username = 'rosto4eks' AND Email = 'aboba@gmail.com'), 2, 'Rostislav Sergeev', 'BNTU cafeteria №2', 'rosto4eks.jpg', 'Minsk, Belarus', '2005-01-14'),
    ((SELECT UserID FROM Users WHERE Username = 'pashkk_a' AND Email = 'ppetrov228@bk.ru'), 2, 'Pavel Krasiviy', 'I have 256 hours in 1 day', 'pashkk_a.png', 'Minsk, Belarus', '2005-09-21'),
    ((SELECT UserID FROM Users WHERE Username = 'JasonStatham' AND Email = 'jsonstatham@gmail.com'), 5, 'Jason Statham', 'The best Actor in the world', 'jasonstatham.jpg', 'Los Angeles, USA', '1967-07-26'),
    ((SELECT UserID FROM Users WHERE Username = 'egrFOREACH' AND Email = 'forinov@gmail.com'), 3, 'Egor Forinov', 'Software Engineer', 'egrforeach.png', 'Minsk, Belarus', '2005-09-22'),
    ((SELECT UserID FROM Users WHERE Username = 'ded1ns1de' AND Email = 'ivan_matsur@yahoo.com'), 3, 'Ivan Matsur', 'Infinity cash everyday', 'ded1ns1de.jpg', 'Varshava, Poland', '2005-05-03'),
    ((SELECT UserID FROM Users WHERE Username = 'stanislavSluma' AND Email = 'bekarev_stanislav@company.org'), 4, 'Stanislav Bekarev', 'Skipped all lectures', 'stanislavsluma.png', 'Minsk, Belarus', '2005-01-24'),
    ((SELECT UserID FROM Users WHERE Username = 'tokyoGul' AND Email = 'anton_gulis@gmail.com'), 5, 'Anton Gulis', 'Publisher of Tokyo Ghoul games', 'tokyogul.jpg', 'Tokyo, Japan', '2005-03-29'),
    ((SELECT UserID FROM Users WHERE Username = 'shershen' AND Email = 'shershen_shershnev@outlook.com'), 4, 'Egor Shershnev', 'I love Agenda Calendar', 'shershen.png', 'Minsk, Belarus', '2005-12-01'),
    ((SELECT UserID FROM Users WHERE Username = 'ekstremumSTRWEB' AND Email = 'yarik02022005@mail.ru'), 3, 'Yaroslav Ekstremskiy', '6500 mmr', 'ekstremumstrweb.jpg', 'Minsk, Belarus', '2005-02-02');

INSERT INTO Games (Title, GameDescription, ReleaseDate, Developer, Price, ViewRestriction)
VALUES
    ('Cyberpunk 2077', 'An open-world, action-adventure story set in Night City, a megalopolis obsessed with power, glamour and body modification.', '2020-12-10', 'CD Projekt Red', 59.99, TRUE),
    ('The Last of Us Part II', 'After a prologue, the game picks up five years after the events of The Last of Us, with Ellie and Joel living in a community in Jackson, Wyoming.', '2020-06-19', 'Naughty Dog', 49.99, TRUE),
    ('Red Dead Redemption 2', 'A story of outlaw Arthur Morgan and the Van der Linde gang as they rob, fight and steal their way across the vast and rugged heart of America.', '2018-10-26', 'Rockstar Games', 39.99, TRUE),
    ('God of War', 'After wiping out the gods of Mount Olympus, Kratos moves on to the frigid lands of Midgard in the realm of Norse gods and monsters.', '2018-04-20', 'Sony Santa Monica', 29.99, TRUE),
    ('Horizon Zero Dawn', 'As Horizon Zero Dawns protagonist Aloy, you explore a post-apocalyptic world overrun by robotic creatures and uncover the secrets of an ancient civilization.', '2017-02-28', 'Guerrilla Games', 19.99, FALSE),
    ('Uncharted 4: A Thiefs End', 'Several years after his last adventure, retired fortune hunter Nathan Drake is forced back into the world of thieves.', '2016-05-10', 'Naughty Dog', 24.99, TRUE),
    ('The Witcher 3: Wild Hunt', 'As the professional monster slayer Geralt of Rivia, you hunt deadly beasts and navigate the intense political turmoil found throughout this world.', '2015-05-19', 'CD Projekt Red', 29.99, TRUE),
    ('Grand Theft Auto V', 'When a young street hustler, a retired bank robber, and a terrifying psychopath find themselves entangled with some of the most frightening and deranged elements of the criminal underworld, the U.S. government, and the entertainment industry, they must pull off a series of dangerous heists to survive in a ruthless city in which they can trust nobody, least of all each other.', '2013-09-17', 'Rockstar Games', 29.99, TRUE),
    ('The Last of Us', 'A brutal journey across a post-pandemic United States, as survivors Joel and Ellie fight to survive and uncover the truth behind the fungal outbreak.', '2013-06-14', 'Naughty Dog', 19.99, FALSE),
    ('Portal 2', 'You awake from a long sleep to find yourself in a renovated Aperture Science testing facility. Guided by the friendly computer system GLaDOS, you must complete a series of tests to escape the facility.', '2011-04-19', 'Valve Corporation', 9.99, FALSE);

INSERT INTO UserGames (UserID, GameID, PurchaseDate, PlayTime)
VALUES
    ((SELECT UserID FROM Users WHERE Username = 'admin' AND Email = 'admin@admin.com'), 1, '2020-12-15', 50),
    ((SELECT UserID FROM Users WHERE Username = 'rosto4eks' AND Email = 'aboba@gmail.com'), 2, '2020-06-25', 120),
    ((SELECT UserID FROM Users WHERE Username = 'pashkk_a' AND Email = 'ppetrov228@bk.ru'), 3, '2018-11-01', 200),
    ((SELECT UserID FROM Users WHERE Username = 'JasonStatham' AND Email = 'jsonstatham@gmail.com'), 4, '2018-05-01', 80),
    ((SELECT UserID FROM Users WHERE Username = 'egrFOREACH' AND Email = 'forinov@gmail.com'), 5, '2017-03-10', 150),
    ((SELECT UserID FROM Users WHERE Username = 'ded1ns1de' AND Email = 'ivan_matsur@yahoo.com'), 6, '2016-06-01', 60),
    ((SELECT UserID FROM Users WHERE Username = 'stanislavSluma' AND Email = 'bekarev_stanislav@company.org'), 7, '2015-06-01', 300),
    ((SELECT UserID FROM Users WHERE Username = 'tokyoGul' AND Email = 'anton_gulis@gmail.com'), 8, '2013-10-01', 400),
    ((SELECT UserID FROM Users WHERE Username = 'shershen' AND Email = 'shershen_shershnev@outlook.com'), 9, '2013-07-01', 180),
    ((SELECT UserID FROM Users WHERE Username = 'ekstremumSTRWEB' AND Email = 'yarik02022005@mail.ru'), 10, '2011-05-01', 100);

INSERT INTO Achievements (GameID, Title, Overview, Points)
VALUES
    ((SELECT GameID FROM Games WHERE Title = 'Cyberpunk 2077'), 'Night City Legend', 'Complete the main story and all side jobs.', 100),
    ((SELECT GameID FROM Games WHERE Title = 'Cyberpunk 2077'), 'The Relic', 'Retrieve the Relic from Konpeki Plaza.', 25),
    ((SELECT GameID FROM Games WHERE Title = 'The Last of Us Part II'), 'Survivor', 'Complete the game on any difficulty setting.', 50),
    ((SELECT GameID FROM Games WHERE Title = 'The Last of Us Part II'), 'Grounded', 'Complete the game on Grounded difficulty.', 100),
    ((SELECT GameID FROM Games WHERE Title = 'Red Dead Redemption 2'), 'Lending a Hand', 'Complete the main story and all Stranger missions.', 75),
    ((SELECT GameID FROM Games WHERE Title = 'Red Dead Redemption 2'), 'The Survivalist', 'Craft every weapon in the game.', 50),
    ((SELECT GameID FROM Games WHERE Title = 'God of War'), 'God of War', 'Complete the main story.', 100),
    ((SELECT GameID FROM Games WHERE Title = 'God of War'), 'Realm Shift', 'Travel to all realms.', 50),
    ((SELECT GameID FROM Games WHERE Title = 'Horizon Zero Dawn'), 'Seeker', 'Uncover all of the Ancient Vessels.', 75),
    ((SELECT GameID FROM Games WHERE Title = 'Horizon Zero Dawn'), 'Thunderjaw Hunter', 'Override a Thunderjaw.', 25);

INSERT INTO UserAchievements (UserID, AchievementID, UnlockDate)
VALUES
    ((SELECT UserID FROM Users WHERE Username = 'admin' AND Email = 'admin@admin.com'), (SELECT AchievementID FROM Achievements WHERE Title = 'Night City Legend'), '2021-01-15'),
    ((SELECT UserID FROM Users WHERE Username = 'rosto4eks' AND Email = 'aboba@gmail.com'), (SELECT AchievementID FROM Achievements WHERE Title = 'Survivor'), '2020-07-10'),
    ((SELECT UserID FROM Users WHERE Username = 'pashkk_a' AND Email = 'ppetrov228@bk.ru'), (SELECT AchievementID FROM Achievements WHERE Title = 'Lending a Hand'), '2019-02-01'),
    ((SELECT UserID FROM Users WHERE Username = 'JasonStatham' AND Email = 'jsonstatham@gmail.com'), (SELECT AchievementID FROM Achievements WHERE Title = 'God of War'), '2018-06-01'),
    ((SELECT UserID FROM Users WHERE Username = 'egrFOREACH' AND Email = 'forinov@gmail.com'), (SELECT AchievementID FROM Achievements WHERE Title = 'Seeker'), '2017-05-20'),
    ((SELECT UserID FROM Users WHERE Username = 'ded1ns1de' AND Email = 'ivan_matsur@yahoo.com'), (SELECT AchievementID FROM Achievements WHERE Title = 'The Relic'), '2021-01-01'),
    ((SELECT UserID FROM Users WHERE Username = 'stanislavSluma' AND Email = 'bekarev_stanislav@company.org'), (SELECT AchievementID FROM Achievements WHERE Title = 'The Survivalist'), '2019-03-15'),
    ((SELECT UserID FROM Users WHERE Username = 'tokyoGul' AND Email = 'anton_gulis@gmail.com'), (SELECT AchievementID FROM Achievements WHERE Title = 'Grounded'), '2020-08-20'),
    ((SELECT UserID FROM Users WHERE Username = 'shershen' AND Email = 'shershen_shershnev@outlook.com'), (SELECT AchievementID FROM Achievements WHERE Title = 'Realm Shift'), '2018-07-10'),
    ((SELECT UserID FROM Users WHERE Username = 'ekstremumSTRWEB' AND Email = 'yarik02022005@mail.ru'), (SELECT AchievementID FROM Achievements WHERE Title = 'Thunderjaw Hunter'), '2017-06-15');


INSERT INTO UserAchievements (UserID, AchievementID, UnlockDate)
SELECT u.UserID, a.AchievementID, '2021-01-15'::DATE
FROM Users u
JOIN UserGames ug ON u.UserID = ug.UserID
JOIN Games g ON ug.GameID = g.GameID
JOIN Achievements a ON g.GameID = a.GameID
WHERE u.Username = 'admin' AND u.Email = 'admin@admin.com' AND a.Title = 'Night City Legend'

UNION ALL

SELECT u.UserID, a.AchievementID, '2020-07-10'::DATE
FROM Users u
JOIN UserGames ug ON u.UserID = ug.UserID
JOIN Games g ON ug.GameID = g.GameID
JOIN Achievements a ON g.GameID = a.GameID
WHERE u.Username = 'rosto4eks' AND u.Email = 'aboba@gmail.com' AND a.Title = 'Survivor'

UNION ALL

SELECT u.UserID, a.AchievementID, '2019-02-01'::DATE
FROM Users u
JOIN UserGames ug ON u.UserID = ug.UserID
JOIN Games g ON ug.GameID = g.GameID
JOIN Achievements a ON g.GameID = a.GameID
WHERE u.Username = 'pashkk_a' AND u.Email = 'ppetrov228@bk.ru' AND a.Title = 'Lending a Hand'

UNION ALL

SELECT u.UserID, a.AchievementID, '2018-06-01'::DATE
FROM Users u
JOIN UserGames ug ON u.UserID = ug.UserID
JOIN Games g ON ug.GameID = g.GameID
JOIN Achievements a ON g.GameID = a.GameID
WHERE u.Username = 'JasonStatham' AND u.Email = 'jsonstatham@gmail.com' AND a.Title = 'God of War'

UNION ALL

SELECT u.UserID, a.AchievementID, '2017-05-20'::DATE
FROM Users u
JOIN UserGames ug ON u.UserID = ug.UserID
JOIN Games g ON ug.GameID = g.GameID
JOIN Achievements a ON g.GameID = a.GameID
WHERE u.Username = 'egrFOREACH' AND u.Email = 'forinov@gmail.com' AND a.Title = 'Seeker';


INSERT INTO Friends (UserID1, UserID2)
SELECT
    (SELECT UserID FROM Users WHERE Username = 'admin' AND Email = 'admin@admin.com'),
    (SELECT UserID FROM Users WHERE Username = 'rosto4eks' AND Email = 'aboba@gmail.com')
UNION ALL
SELECT
    (SELECT UserID FROM Users WHERE Username = 'admin' AND Email = 'admin@admin.com'),
    (SELECT UserID FROM Users WHERE Username = 'pashkk_a' AND Email = 'ppetrov228@bk.ru')
UNION ALL
SELECT
    (SELECT UserID FROM Users WHERE Username = 'rosto4eks' AND Email = 'aboba@gmail.com'),
    (SELECT UserID FROM Users WHERE Username = 'JasonStatham' AND Email = 'jsonstatham@gmail.com')
UNION ALL
SELECT
    (SELECT UserID FROM Users WHERE Username = 'pashkk_a' AND Email = 'ppetrov228@bk.ru'),
    (SELECT UserID FROM Users WHERE Username = 'egrFOREACH' AND Email = 'forinov@gmail.com')
UNION ALL
SELECT
    (SELECT UserID FROM Users WHERE Username = 'JasonStatham' AND Email = 'jsonstatham@gmail.com'),
    (SELECT UserID FROM Users WHERE Username = 'ded1ns1de' AND Email = 'ivan_matsur@yahoo.com')
UNION ALL
SELECT
    (SELECT UserID FROM Users WHERE Username = 'egrFOREACH' AND Email = 'forinov@gmail.com'),
    (SELECT UserID FROM Users WHERE Username = 'stanislavSluma' AND Email = 'bekarev_stanislav@company.org')
UNION ALL
SELECT
    (SELECT UserID FROM Users WHERE Username = 'ded1ns1de' AND Email = 'ivan_matsur@yahoo.com'),
    (SELECT UserID FROM Users WHERE Username = 'tokyoGul' AND Email = 'anton_gulis@gmail.com')
UNION ALL
SELECT
    (SELECT UserID FROM Users WHERE Username = 'stanislavSluma' AND Email = 'bekarev_stanislav@company.org'),
    (SELECT UserID FROM Users WHERE Username = 'shershen' AND Email = 'shershen_shershnev@outlook.com')
UNION ALL
SELECT
    (SELECT UserID FROM Users WHERE Username = 'tokyoGul' AND Email = 'anton_gulis@gmail.com'),
    (SELECT UserID FROM Users WHERE Username = 'ekstremumSTRWEB' AND Email = 'yarik02022005@mail.ru')
UNION ALL
SELECT
    (SELECT UserID FROM Users WHERE Username = 'shershen' AND Email = 'shershen_shershnev@outlook.com'),
    (SELECT UserID FROM Users WHERE Username = 'admin' AND Email = 'admin@admin.com');


INSERT INTO ChatMessages (SenderID, ReceiverID, Content, SendDate)
VALUES
    ((SELECT UserID FROM Users WHERE Username = 'admin' AND Email = 'admin@admin.com'), (SELECT UserID FROM Users WHERE Username = 'rosto4eks' AND Email = 'aboba@gmail.com'), 'Здарова', CURRENT_TIMESTAMP),
    ((SELECT UserID FROM Users WHERE Username = 'rosto4eks' AND Email = 'aboba@gmail.com'), (SELECT UserID FROM Users WHERE Username = 'admin' AND Email = 'admin@admin.com'), 'Зач ты здороваешься, ты сидишь рядом со мной', CURRENT_TIMESTAMP),
    ((SELECT UserID FROM Users WHERE Username = 'pashkk_a' AND Email = 'ppetrov228@bk.ru'), (SELECT UserID FROM Users WHERE Username = 'JasonStatham' AND Email = 'jsonstatham@gmail.com'), 'Здравствуйте, когда новый фильми?', CURRENT_TIMESTAMP),
    ((SELECT UserID FROM Users WHERE Username = 'JasonStatham' AND Email = 'jsonstatham@gmail.com'), (SELECT UserID FROM Users WHERE Username = 'pashkk_a' AND Email = 'ppetrov228@bk.ru'), 'Да.', CURRENT_TIMESTAMP),
    ((SELECT UserID FROM Users WHERE Username = 'egrFOREACH' AND Email = 'forinov@gmail.com'), (SELECT UserID FROM Users WHERE Username = 'ded1ns1de' AND Email = 'ivan_matsur@yahoo.com'), 'Какую пару можно скипнуть?', CURRENT_TIMESTAMP),
    ((SELECT UserID FROM Users WHERE Username = 'ded1ns1de' AND Email = 'ivan_matsur@yahoo.com'), (SELECT UserID FROM Users WHERE Username = 'egrFOREACH' AND Email = 'forinov@gmail.com'), 'Я не с твоей спецухи', CURRENT_TIMESTAMP),
    ((SELECT UserID FROM Users WHERE Username = 'stanislavSluma' AND Email = 'bekarev_stanislav@company.org'), (SELECT UserID FROM Users WHERE Username = 'tokyoGul' AND Email = 'anton_gulis@gmail.com'), 'Ты на пары идешь?', CURRENT_TIMESTAMP),
    ((SELECT UserID FROM Users WHERE Username = 'tokyoGul' AND Email = 'anton_gulis@gmail.com'), (SELECT UserID FROM Users WHERE Username = 'stanislavSluma' AND Email = 'bekarev_stanislav@company.org'), 'Пары?', CURRENT_TIMESTAMP),
    ((SELECT UserID FROM Users WHERE Username = 'shershen' AND Email = 'shershen_shershnev@outlook.com'), (SELECT UserID FROM Users WHERE Username = 'ekstremumSTRWEB' AND Email = 'yarik02022005@mail.ru'), 'Когда агенду запускаем?', CURRENT_TIMESTAMP),
    ((SELECT UserID FROM Users WHERE Username = 'ekstremumSTRWEB' AND Email = 'yarik02022005@mail.ru'), (SELECT UserID FROM Users WHERE Username = 'shershen' AND Email = 'shershen_shershnev@outlook.com'), 'Не надо пж', CURRENT_TIMESTAMP);

INSERT INTO Reviews (UserID, GameID, Rating, Content, PostDate)
VALUES
    (1, 1, 9, 'Крутая игра, мне понравилось', CURRENT_TIMESTAMP),
    (2, 2, 7, 'Неплохо, но ожидал большего за 50$', CURRENT_TIMESTAMP),
    (3, 3, 10, 'Шедевр! Одна из лучших игр, в которые я играл', CURRENT_TIMESTAMP),
    (4, 1, 6, 'Средненько, но терпимо', CURRENT_TIMESTAMP),
    (5, 4, 8, 'Достаточно сыро сделано, жду баг-фикса, чтобы получить удовольствие от игры', CURRENT_TIMESTAMP);

INSERT INTO Reviews (UserID, GameID, Rating, PostDate)
VALUES
    (6, 2, 5, CURRENT_TIMESTAMP);

INSERT INTO Reviews (UserID, GameID, Rating, Content, PostDate)
VALUES
    (7, 5, 10, 'Лучшая игра! Советую пройти', CURRENT_TIMESTAMP);

INSERT INTO GameProgress (UserID, GameID, SaveData, LastUpdated)
SELECT
    u.UserID,
    ug.GameID,
    'SaveData1',
    CURRENT_TIMESTAMP
FROM Users u
JOIN UserGames ug ON u.UserID = ug.UserID
WHERE u.Username = 'admin' AND u.Email = 'admin@admin.com'

UNION ALL

SELECT
    u.UserID,
    ug.GameID,
    'SaveData2',
    CURRENT_TIMESTAMP
FROM Users u
JOIN UserGames ug ON u.UserID = ug.UserID
WHERE u.Username = 'rosto4eks' AND u.Email = 'aboba@gmail.com'

UNION ALL

SELECT
    u.UserID,
    ug.GameID,
    'SaveData3',
    CURRENT_TIMESTAMP
FROM Users u
JOIN UserGames ug ON u.UserID = ug.UserID
WHERE u.Username = 'pashkk_a' AND u.Email = 'ppetrov228@bk.ru'

UNION ALL

SELECT
    u.UserID,
    ug.GameID,
    'SaveData4',
    CURRENT_TIMESTAMP
FROM Users u
JOIN UserGames ug ON u.UserID = ug.UserID
WHERE u.Username = 'JasonStatham' AND u.Email = 'jsonstatham@gmail.com'

UNION ALL

SELECT
    u.UserID,
    ug.GameID,
    'SaveData5',
    CURRENT_TIMESTAMP
FROM Users u
JOIN UserGames ug ON u.UserID = ug.UserID
WHERE u.Username = 'egrFOREACH' AND u.Email = 'forinov@gmail.com';


INSERT INTO TransactionType (TypeName)
VALUES
    ('Purchase'),
    ('Refund'),
    ('Discount'),
    ('Gift Card'),
    ('Chargeback');

INSERT INTO Transactions (TransactionCode, UserID, GameID, Amount, TrType, TransactionTime)
SELECT
    gen_random_uuid(),
    u.UserID,
    ug.GameID,
    g.Price,
    (SELECT TypeID FROM TransactionType WHERE TypeName = 'Purchase'),
    CURRENT_TIMESTAMP
FROM Users u
JOIN UserGames ug ON u.UserID = ug.UserID
JOIN Games g ON ug.GameID = g.GameID
WHERE u.Username = 'admin' AND u.Email = 'admin@admin.com'

UNION ALL

SELECT
    gen_random_uuid(),
    u.UserID,
    ug.GameID,
    -10,
    (SELECT TypeID FROM TransactionType WHERE TypeName = 'Refund'),
    CURRENT_TIMESTAMP - INTERVAL '1 DAY'
FROM Users u
JOIN UserGames ug ON u.UserID = ug.UserID
JOIN Games g ON ug.GameID = g.GameID
WHERE u.Username = 'rosto4eks' AND u.Email = 'aboba@gmail.com'

UNION ALL

SELECT
    gen_random_uuid(),
    u.UserID,
    ug.GameID,
    g.Price * 0.8,
    (SELECT TypeID FROM TransactionType WHERE TypeName = 'Discount'),
    CURRENT_TIMESTAMP - INTERVAL '2 DAYS'
FROM Users u
JOIN UserGames ug ON u.UserID = ug.UserID
JOIN Games g ON ug.GameID = g.GameID
WHERE u.Username = 'pashkk_a' AND u.Email = 'ppetrov228@bk.ru'

UNION ALL

SELECT
    gen_random_uuid(),
    u.UserID,
    ug.GameID,
    50,
    (SELECT TypeID FROM TransactionType WHERE TypeName = 'Gift Card'),
    CURRENT_TIMESTAMP - INTERVAL '3 DAYS'
FROM Users u
JOIN UserGames ug ON u.UserID = ug.UserID
JOIN Games g ON ug.GameID = g.GameID
WHERE u.Username = 'JasonStatham' AND u.Email = 'jsonstatham@gmail.com'

UNION ALL

SELECT
    gen_random_uuid(),
    u.UserID,
    ug.GameID,
    -20,
    (SELECT TypeID FROM TransactionType WHERE TypeName = 'Chargeback'),
    CURRENT_TIMESTAMP - INTERVAL '4 DAYS'
FROM Users u
JOIN UserGames ug ON u.UserID = ug.UserID
JOIN Games g ON ug.GameID = g.GameID
WHERE u.Username = 'egrFOREACH' AND u.Email = 'forinov@gmail.com';

INSERT INTO Tags (TagName, TagDescription)
VALUES
    ('Action', 'Games focused on combat, physical challenges, and fast-paced gameplay.'),
    ('Adventure', 'Games that emphasize exploration, puzzle-solving, and storytelling.'),
    ('RPG', 'Role-playing games with character development, quests, and immersive worlds.'),
    ('Strategy', 'Games that require careful planning, resource management, and tactical decisions.'),
    ('Shooter', 'Games centered around ranged combat and shooting mechanics.'),
    ('Platformer', 'Games that involve jumping between platforms and navigating obstacles.'),
    ('Puzzle', 'Games that challenge the player''s problem-solving and logical thinking skills.'),
    ('Survival', 'Games that focus on resource management, crafting, and surviving in harsh environments.'),
    ('Horror', 'Games designed to create an atmosphere of fear, tension, and suspense.'),
    ('Indie', 'Games developed by independent studios, often with unique or experimental gameplay.');


INSERT INTO GameTags (TagID, GameID)
SELECT t.TagID, g.GameID
FROM Tags t
CROSS JOIN Games g
WHERE t.TagName = 'Action' AND g.Title IN ('Cyberpunk 2077', 'The Last of Us Part II', 'God of War', 'Uncharted 4: A Thief''s End')

UNION ALL

SELECT t.TagID, g.GameID
FROM Tags t
CROSS JOIN Games g
WHERE t.TagName = 'Adventure' AND g.Title IN ('Red Dead Redemption 2', 'Horizon Zero Dawn', 'The Witcher 3: Wild Hunt')

UNION ALL

SELECT t.TagID, g.GameID
FROM Tags t
CROSS JOIN Games g
WHERE t.TagName = 'RPG' AND g.Title IN ('Cyberpunk 2077', 'Red Dead Redemption 2', 'The Witcher 3: Wild Hunt')

UNION ALL

SELECT t.TagID, g.GameID
FROM Tags t
CROSS JOIN Games g
WHERE t.TagName = 'Shooter' AND g.Title IN ('Cyberpunk 2077', 'The Last of Us Part II')

UNION ALL

SELECT t.TagID, g.GameID
FROM Tags t
CROSS JOIN Games g
WHERE t.TagName = 'Survival' AND g.Title = 'The Last of Us'

UNION ALL

SELECT t.TagID, g.GameID
FROM Tags t
CROSS JOIN Games g
WHERE t.TagName = 'Puzzle' AND g.Title = 'Portal 2'

UNION ALL

SELECT t.TagID, g.GameID
FROM Tags t
CROSS JOIN Games g
WHERE t.TagName = 'Indie' AND g.Title = 'Portal 2';

INSERT INTO UserActivityLog (UserID, Activity, LoggedAt)
VALUES
    (1, 'Purchased game "Cyberpunk 2077"', '2020-12-15 00:00:00'),
    (2, 'Purchased game "The Last of Us Part II"', '2020-06-25 00:00:00'),
    (3, 'Purchased game "Red Dead Redemption 2"', '2018-11-01 00:00:00'),
    (4, 'Unlocked achievement "God of War" in "God of War"', '2018-06-01 00:00:00'),
    (5, 'Unlocked achievement "Seeker" in "Horizon Zero Dawn"', '2017-05-20 00:00:00'),
    (6, 'Unlocked achievement "The Relic" in "Cyberpunk 2077"', '2021-01-01 00:00:00'),
    (7, 'Purchased game "The Witcher 3: Wild Hunt"', '2015-06-01 00:00:00'),
    (8, 'Purchased game "Grand Theft Auto V"', '2013-10-01 00:00:00'),
    (9, 'Purchased game "The Last of Us"', '2013-07-01 00:00:00'),
    (10, 'Purchased game "Portal 2"', '2011-05-01 00:00:00'),
    (10, 'Unlocked achievement "Thunderjaw Hunter" in "Horizon Zero Dawn"', '2017-06-15 00:00:00');