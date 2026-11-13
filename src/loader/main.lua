local scripts = {[2753915549] = "7ffba6e56861496f9d884a4a2563ffcd"}
local id = scripts[game.PlaceId] or "90695fb80ef865532c9fcf700d589141"
local env = (getgenv and getgenv()) or _G
local sdk = loadstring(game:HttpGet("https://sdkapi-public.luarmor.net/library.lua"))()
sdk.script_id = id
local cache = "lowyx-key.txt"
local function save(key)
    if type(writefile) == "function" then
        pcall(writefile, cache, key)
    end
end
local function clear()
    if type(delfile) == "function" then
        pcall(delfile, cache)
    elseif type(writefile) == "function" then
        pcall(writefile, cache, "")
    end
end
local function accept(key)
    if type(key) ~= "string" or not key:match("^[A-Za-z0-9]+$") or #key ~= 32 then
        return false,"Enter a valid 32-character key.",true
    end
    local ok, status = pcall(sdk.check_key, key)
    if not ok or type(status) ~= "table" then return false,"Key service unavailable. Try again." end
    if status.code == "KEY_VALID" then return true,"Key verified. Starting script..." end
    if status.code == "KEY_HWID_LOCKED" then return false,"Key linked to another device. Reset HWID in Discord." end
    return false, type(status.message) == "string" and status.message or "Invalid key.", status.code == "KEY_INCORRECT" or status.code == "KEY_INVALID" or status.code == "KEY_EXPIRED" or status.code == "KEY_BANNED"
end
local function start(key)
    env.script_key = key
    script_key = key
    task.spawn(function()
        local loaded = pcall(sdk.load_script)
        if not loaded then warn("Lowyx Hub: script startup failed. Try again.") end
    end)
end
local message = "Enter your key to continue."
if type(readfile) == "function" then
    local read, key = pcall(readfile, cache)
    if read and type(key) == "string" and key ~= "" then
        key = key:match("^%s*(.-)%s*$")
        local checked, accepted, result, invalid = pcall(accept, key)
        if checked and accepted then
            start(key)
            return
        end
        if checked then
            message = result or "Enter a new key to continue."
            if invalid then clear() end
        else
            message = "Verification failed. Try again."
        end
    end
end
local ui = loadstring(game:HttpGet("https://raw.githubusercontent.com/r1nhubdev/R1n/refs/heads/main/src/loader/interface.lua"))()
ui:CreateWindow({Title = "Lowyx Hub | Key System", Description = "Key verification"})
local tab = ui:AddTab({Id = "KeySystem", Title = "Access", Icon = "settings"})
local section = tab:AddSection({Id = "Verification", Name = "Verification", Column = 1})
local status = section:AddParagraph({Id = "Status", Name = "Status", Description = message})
local input = section:AddInput({Id = "Key", Name = "Key", Placeholder = "Enter your Luarmor key..."})
local busy = false
section:AddButton({Id = "Verify", Name = "Verify Key", Callback = function()
    if busy then
        return
    end
    busy = true
    status:SetDescription("Verifying...")
    local key = input:Get()
    if type(key) == "string" then key = key:match("^%s*(.-)%s*$") end
    local ok, accepted, message = pcall(accept, key)
    if not ok then busy = false;status:SetDescription("Verification failed. Try again.");return end
    status:SetDescription(message or (accepted and "Key accepted." or "Invalid key."))
    if not accepted then busy = false;return end
    save(key)
    start(key)
    ui:Destroy()
end})
section:AddButton({Id = "GetKey", Name = "Get Key", Callback = function()
    local link = "https://discord.gg/lowyx"
    if type(setclipboard) == "function" and pcall(setclipboard, link) then
        status:SetDescription("Discord link copied: "..link)
    else
        status:SetDescription("Get your key: "..link)
    end
end})
