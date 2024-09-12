# Ястремский Ярослав 253502

## Система управления многопользовательской игровой платформой

## Функциональные требования

- Управление учетными записями пользователей
- Каталог игр с возможностью покупки и загрузки
- Система достижений и наград
- Социальные функции (друзья, чаты)
- Облачное сохранение игрового прогресса
- Система рейтинга игроков
- Управление внутриигровыми покупками

## Диаграма таблиц базы данных
![alt text](https://github.com/whiteprincewithobsession/GamingPlatform/blob/main/diagram/diagram.png)

## Сущности базы данных

1. **Users** (Пользователи)
   - `UserID` (INT, PK)
   - `Username` (VARCHAR, уникальное, не null)
   - `Email` (VARCHAR, уникальное, не null)
   - `Password` (VARCHAR, не null)
   - `RegistrationDate` (DATE, не null)

2. **UserProfile** (Профиль пользователя)
   - `UserID` (INT, PK, FK -> Users.UserID)
   - `FullName` (VARCHAR)
   - `Bio` (TEXT)
   - `Avatar` (VARCHAR)
   - `Location` (VARCHAR)
   - `DateOfBirth` (DATE)

3. **Roles** (Роли)
   - `RoleID` (INT, PK)
   - `RoleName` (VARCHAR, уникальное, не null)
   - `Description` (TEXT)

4. **UserRoles** (Связь пользователей и ролей)
   - `UserRoleID` (INT, PK)
   - `UserID` (INT, FK -> Users.UserID, не null)
   - `RoleID` (INT, FK -> Roles.RoleID, не null)

5. **UserActivityLog** (Журнал активности пользователя)
   - `LogID` (INT, PK)
   - `UserID` (INT, FK -> Users.UserID, не null)
   - `Activity` (VARCHAR, не null)
   - `Timestamp` (DATETIME, не null)
   - `AdditionalData` (TEXT)

6. **Games** (Игры)
   - `GameID` (INT, PK)
   - `Title` (VARCHAR, не null)
   - `Description` (TEXT)
   - `ReleaseDate` (DATE)
   - `Developer` (VARCHAR, не null)
   - `Price` (DECIMAL, не null)

7. **UserGames** (Игры пользователей)
   - `UserGameID` (INT, PK)
   - `UserID` (INT, FK -> Users.UserID, не null)
   - `GameID` (INT, FK -> Games.GameID, не null)
   - `PurchaseDate` (DATE, не null)
   - `PlayTime` (INT, не null, default: 0)

8. **Achievements** (Достижения)
   - `AchievementID` (INT, PK)
   - `GameID` (INT, FK -> Games.GameID, не null)
   - `Title` (VARCHAR, не null)
   - `Description` (TEXT)
   - `Points` (INT, не null, default: 0)

9. **UserAchievements** (Достижения пользователей)
   - `UserAchievementID` (INT, PK)
   - `UserID` (INT, FK -> Users.UserID, не null)
   - `AchievementID` (INT, FK -> Achievements.AchievementID, не null)
   - `UnlockDate` (DATETIME, не null)

10. **Friends** (Друзья)
    - `FriendshipID` (INT, PK)
    - `UserID1` (INT, FK -> Users.UserID, не null)
    - `UserID2` (INT, FK -> Users.UserID, не null)
    - `FriendshipDate` (DATE, не null)

11. **ChatMessages** (Сообщения чата)
    - `MessageID` (INT, PK)
    - `SenderID` (INT, FK -> Users.UserID, не null)
    - `ReceiverID` (INT, FK -> Users.UserID, не null)
    - `Content` (TEXT, не null)
    - `SendDate` (DATETIME, не null)

12. **GameProgress** (Игровой прогресс)
    - `ProgressID` (INT, PK)
    - `UserID` (INT, FK -> Users.UserID, не null)
    - `GameID` (INT, FK -> Games.GameID, не null)
    - `SaveData` (TEXT, не null)
    - `LastUpdated` (DATETIME, не null)

13. **Transactions** (Транзакции)
    - `TransactionID` (INT, PK)
    - `UserID` (INT, FK -> Users.UserID, не null)
    - `GameID` (INT, FK -> Games.GameID, nullable)
    - `Amount` (DECIMAL, не null)
    - `Type` (VARCHAR, не null)
    - `Date` (DATETIME, не null)

14. **Reviews** (Отзывы)
    - `ReviewID` (INT, PK)
    - `UserID` (INT, FK -> Users.UserID, не null)
    - `GameID` (INT, FK -> Games.GameID, не null)
    - `Rating` (INT, не null, примечание: 'Значение должно быть от 1 до 5')
    - `Content` (TEXT, не null)
    - `PostDate` (DATETIME, не null)

15. **GameTags** (Теги игр)
    - `TagID` (INT, PK)
    - `GameID` (INT, FK -> Games.GameID, не null)
    - `Tag` (VARCHAR, не null)

## Связи

- Один-ко-многим (One-to-Many):
  - `Users` -> `UserGames`, `UserAchievements`, `Friends`, `ChatMessages`, `GameProgress`, `Transactions`, `Reviews`, `UserActivityLog`
  - `Games` -> `UserGames`, `Achievements`, `GameProgress`, `Transactions`, `Reviews`, `GameTags`

- Многие-ко-многим (Many-to-Many):
  - `Users` -> `Roles` (через таблицу `UserRoles`)

- Один-к-одному (One-to-One):
  - `Users` -> `UserProfile`

Основные функции системы включают управление учетными записями пользователей, каталог игр с возможностью покупки, систему достижений и наград, социальные функции (друзья, чаты), облачное сохранение игрового прогресса, управление внутриигровыми покупками. Также аутентификация пользователей путем сравнения почты и захешированного пароля, регистрация пользователей.

Сущность Users содержит основную информацию о пользователях, такую как имя пользователя, электронную почту, пароль и дату регистрации. Сущность UserProfile связана с Users связью один-к-одному и содержит дополнительную информацию о пользователе, такую как полное имя, биография, аватар, местоположение и дата рождения.

Сущность Roles представляет различные роли, которые могут быть назначены пользователям (например, администратор, модератор, обычный пользователь). Связь между Users и Roles реализована через связующую таблицу UserRoles, что позволяет одному пользователю иметь несколько ролей, а одну роль назначать нескольким пользователям.

Сущность UserActivityLog используется для журналирования действий пользователей, таких как вход в систему, покупка игры, разблокировка достижения и т.д.

Сущность Games содержит информацию об играх, доступных на платформе, включая название, описание, дату выпуска, разработчика и цену.

Сущность UserGames связывает пользователей с купленными ими играми, отслеживая дату покупки и время, проведенное в игре.

Сущности Achievements и UserAchievements представляют систему достижений и наград, где достижения связаны с конкретными играми, а пользователи могут разблокировать эти достижения.

Сущность Friends отслеживает дружеские связи между пользователями, а ChatMessages хранит историю сообщений в чатах.

Сущность GameProgress используется для облачного сохранения игрового прогресса пользователей в различных играх.

Сущность Transactions хранит информацию о транзакциях, таких как покупки игр, внутриигровые покупки и возвраты.

Сущность Reviews позволяет пользователям оставлять отзывы и оценки для игр.

Сущность GameTags используется для хранения тегов, связанных с играми, что может помочь в организации и поиске игр.
