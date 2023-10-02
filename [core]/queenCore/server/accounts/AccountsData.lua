ACCOUNTS_TABLE_NAME = "accounts"

local ACCOUNTS_TABLE = {
	-- Номер поля
	{name = "ID", type = "INTEGER", option = "PRIMARY KEY"},

	-- Идентификатор пользователя
	{name = "user_id", type = "TEXT", option = "NOT NULL UNIQUE"},
	-- Имя пользователя
	{name = "username", type = "TEXT"},

	-- Онлайн
	{name = "online", type = "INTEGER"},

	-- Количество минут, проведённых в игре
	{name = "playtime", type = "INTEGER"},

	-- Приглашение
	{name = "username_invited", type = "TEXT"},

	-- Дата регистрации
	{name = "register_time", type = "INTEGER"},
	-- IP при регистрации
	{name = "register_ip", type = "TEXT"},
	-- Serial при регистрации
	{name = "register_serial", type = "TEXT"},

	-- Дата последней активности
	{name = "lastseen_time", type = "INTEGER"},
	-- IP последней авторизации
	{name = "lastseen_ip", type = "TEXT"},
	-- Serial последней авторизации
	{name = "lastseen_serial", type = "TEXT"},

	-- Адрес эл. почты
	{name = "email", type = "TEXT"},
	-- Валидность эл. почты
	{name = "email_valid", type = "INTEGER"}
}

Accounts = {}

function Accounts.setup()
	local db = Database.getConnection()
	dbExec(db, "CREATE TABLE IF NOT EXISTS "..ACCOUNTS_TABLE_NAME.." ("..Database.createTable(ACCOUNTS_TABLE)..") ")
end

function Accounts.updateLastseen(player, username, isOnline)
	local db = Database.getConnection()

	local serial = getPlayerSerial(player)
	local ip = getPlayerIP(player)
	local time = exports.queenUtils.getRealDate()

	local account = getPlayerAccount(player)
	if not account then
		return outputDebugString("Accounts.getData: Не удалось получить account.", 1)
	end

	dbExec(db, "UPDATE "..ACCOUNTS_TABLE_NAME.." SET online = ?, lastseen_time = ?, lastseen_ip = ?, lastseen_serial = ? WHERE username = ?",
		isOnline,
		time,
		ip,
		serial,
		tostring(username)
	)

end

function Accounts.addAccount(player, username, email)
	local db = Database.getConnection()

	local serial = getPlayerSerial(player)
	local ip = getPlayerIP(player)
	local time = exports.queenUtils.getRealDate()

	local user_id = "id"..tonumber(#getAccounts() + 1)

	dbExec(db, "INSERT INTO `"..ACCOUNTS_TABLE_NAME.."` (`user_id`, `username`, `register_time`, `register_ip`, `register_serial`, `email`) VALUES ('"..user_id.."', '"..username.."', '"..time.."', '"..ip.."', '"..serial.."', '"..email.."');")
end

-- Получение данных аккаунта
function Accounts.getData(player)
	local db = Database.getConnection()

	if not isElement(player) then 
		return outputDebugString("Accounts.getData: Не удалось получить player.", 1)
	end

	local account = getPlayerAccount(player)
	if not account then
		return outputDebugString("Accounts.getData: Не удалось получить account.", 1)
	end

	local result = dbPoll(dbQuery(db, "SELECT * FROM "..ACCOUNTS_TABLE_NAME.." WHERE username = ?", getAccountName(account)), -1)

	return result[1]
end