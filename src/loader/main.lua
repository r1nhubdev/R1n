local scripts = {[2753915549] = "7ffba6e56861496f9d884a4a2563ffcd", [104067066727140] = "07f307fb9f2cbdfd152567dc3b56fcdf", [114234929420007] = "90695fb80ef865532c9fcf700d589141"}
local universes = {[994732206] = "7ffba6e56861496f9d884a4a2563ffcd", [7174773198] = "07f307fb9f2cbdfd152567dc3b56fcdf", [7633926880] = "90695fb80ef865532c9fcf700d589141"}
local id = universes[game.GameId] or scripts[game.PlaceId]
if not id then
    warn("Lowyx Hub: this game is not supported.")
    return
end
local env = (getgenv and getgenv()) or _G
local sdk = loadstring(game:HttpGet("https://sdkapi-public.luarmor.net/library.lua"))()
sdk.script_id = id
local cache = "lowyx-key.txt"
local function save(key)
    if type(writefile) ~= "function" then return false end
    local written = pcall(writefile, cache, key)
    if not written then return false end
    if type(readfile) ~= "function" then return true end
    local read, saved = pcall(readfile, cache)
    return read and saved == key
end
local function clear()
    if type(delfile) == "function" then
        pcall(delfile, cache)
    elseif type(writefile) == "function" then
        pcall(writefile, cache, "")
    end
end
local function normalize(key)
    if type(key) ~= "string" then return nil end
    key = key:gsub("\194\160", ""):gsub("\239\187\191", "")
    key = key:gsub("\226\128[\139-\141]", ""):gsub("%s+", "")
    return key
end
local function accept(key)
    if type(key) ~= "string" or not key:match("^[A-Za-z0-9]+$") or #key ~= 32 then
        return false,"Enter a valid 32-character key.",true
    end
    local ok, status = pcall(sdk.check_key, key)
    if not ok or type(status) ~= "table" then return false,"Key service unavailable. Try again." end
    if status.code == "KEY_VALID" then return true,"Key verified. Starting script..." end
    if status.code == "KEY_HWID_LOCKED" then
        return false,"This key is linked to another executor or device. Free key: reset HWID on the original ad key page. Premium key: reset HWID in Discord.",false,"KEY_HWID_LOCKED"
    end
    local messages = {
        KEY_INCORRECT = "Luarmor could not find this key. Copy the complete key from the Lowyx key page and try again. [KEY_INCORRECT]",
        KEY_INVALID = "Enter the complete 32-character key. [KEY_INVALID]",
        KEY_EXPIRED = "This key has expired. Get a new key and enter it below. [KEY_EXPIRED]",
        KEY_BANNED = "This key is blocked. Contact support. [KEY_BANNED]",
    }
    return false, messages[status.code] or (type(status.message) == "string" and status.message or "Key verification failed."),
        status.code == "KEY_INCORRECT" or status.code == "KEY_INVALID" or status.code == "KEY_EXPIRED" or status.code == "KEY_BANNED", status.code
end
local function start(key, remember)
    env.script_key = key
    script_key = key
    if remember and not save(key) then
        warn("Lowyx Hub: this executor could not save the key. You may need to enter it again.")
    end
    task.spawn(function()
        local loaded, result = pcall(sdk.load_script)
        if not loaded or result == false then
            warn("Lowyx Hub: script startup failed. Try again.")
            return
        end
    end)
end
local message = "Enter your key to continue."
if type(readfile) == "function" then
    local read, key = pcall(readfile, cache)
    if read and type(key) == "string" and key ~= "" then
        key = normalize(key)
        local checked, accepted, result, invalid, code = pcall(accept, key)
        if checked and accepted then
            start(key)
            return
        end
        if checked then
            message = code == "KEY_HWID_LOCKED"
                and "The saved key belongs to another executor or device. Enter your newly obtained key below."
                or result or "Enter a new key to continue."
            if invalid then
                clear()
                message = "Your saved key is no longer valid. Paste a newly obtained key below and click Verify Key."
            end
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
    local key = normalize(input:Get())
    local ok, accepted, message = pcall(accept, key)
    if not ok then busy = false;status:SetDescription("Verification failed. Try again.");return end
    status:SetDescription(message or (accepted and "Key accepted." or "Invalid key."))
    if not accepted then busy = false;return end
    start(key, true)
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
