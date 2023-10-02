USERS_TABLE_NAME = "users"

local USERS_TABLE = {
	-- Номер поля
	{name = "ID", type = "INTEGER", option = "PRIMARY KEY"},

	-- Идентификатор пользователя
	{name = "user_id", type = "TEXT", option = "NOT NULL UNIQUE"},

	-- Количество игровой валюты
	{name = "user_money", type = "INTEGER", option = "NOT NULL"},

	-- Количество донат валюты
	{name = "user_donate", type = "INTEGER", option = "NOT NULL"},

	-- Местоположение
	{name = "user_location", type = "BLOB", option = "NOT NULL"},

	-- Интерьер
	{name = "user_int", type = "INTEGER", option = "NOT NULL"},

	-- Измерение
	{name = "user_dim", type = "INTEGER", option = "NOT NULL"},

	-- Уровень здоровья
	{name = "user_hp", type = "INTEGER", option = "NOT NULL"},

	-- Уровень голода
	{name = "user_eat", type = "INTEGER", option = "NOT NULL"},

	-- Пол
	{name = "user_sex", type = "TEXT", option = "NOT NULL"},

	-- Скин
	{name = "user_skin", type = "INTEGER", option = "NOT NULL"},

	-- Уровень
	{name = "user_lvl", type = "INTEGER", option = "NOT NULL"},
	-- Опыт
	{name = "user_exp", type = "INTEGER", option = "NOT NULL"},

	-- Организация
	{name = "user_organization", type = "TEXT"},
}

Users = {}

function Users.setup()
	local db = Database.getConnection()
	dbExec(db, "CREATE TABLE IF NOT EXISTS "..USERS_TABLE_NAME.." ("..Database.createTable(USERS_TABLE)..") ")

	--dbExec(db, "ALTER TABLE "..USERS_TABLE_NAME.." ADD COLUMN `user_eat` INTEGER;")
end

function Users.addUser(player, userid, username, characterData)
	local db = Database.getConnection()
	
	local startKit = exports.queenShared.getPlayerStartSettings()
	local playerLocation = toJSON({x = characterData.city.x, y = characterData.city.y, z = characterData.city.z})
	dbExec(db, "INSERT INTO `"..USERS_TABLE_NAME.."` (`user_id`, `user_money`, `user_donate`, `user_location`, `user_int`, `user_dim`, `user_hp`, `user_eat`, `user_sex`, `user_skin`, `user_lvl`, `user_exp`) VALUES ('"..userid.."', '"..startKit.cash.."', '"..startKit.donate.."', '"..playerLocation.."', '0', '0', '100', '100', '"..characterData.sex.."', '"..characterData.skin.."', '"..startKit.lvl.."', '0');")
end

-- Получение данных пользователя
function Users.getUserData(user_id)
	local db = Database.getConnection()

	local result = dbPoll(dbQuery(db, "SELECT * FROM "..USERS_TABLE_NAME.." WHERE user_id = ?", tostring(user_id)), -1)

	return result[1]
end


