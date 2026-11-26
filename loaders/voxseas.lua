-- Lowyx Hub | Vox Seas loader
-- Validates a Luarmor key against the Premium and Free scripts, runs the one it unlocks
-- and remembers the key for the next execution.

local Players = game:GetService("Players")
if not game:IsLoaded() then game.Loaded:Wait() end

local SCRIPTS = { -- checked in this order: a premium key always loads premium
    {Name = "Premium", Id = "cd4b1fa92b25e702bb3a6cccb98aa9be"},
    {Name = "Free", Id = "07f307fb9f2cbdfd152567dc3b56fcdf"},
}
local KEY_FOLDER = "LowyxHub"
local KEY_FILE = KEY_FOLDER .. "/key.txt"
local GET_KEY_URL = "https://discord.gg/lowyx"
local INTERFACE_URL = "https://raw.githubusercontent.com/r1nhubdev/R1n/refs/heads/main/LowyxInterface.lua"
local LUARMOR_URL = "https://sdkapi-public.luarmor.net/library.lua"

local MESSAGES = {
    KEY_INCORRECT = "This key does not exist.",
    KEY_INVALID = "Enter a valid key.",
    KEY_EXPIRED = "Your key has expired. Get a new one.",
    KEY_BANNED = "This key is banned.",
    KEY_HWID_LOCKED = "This key is linked to another device. Reset your HWID in our Discord.",
    INVALID_EXECUTOR = "Your executor is not supported.",
    TIME_ERROR = "Your system clock is wrong. Sync it and try again.",
}

local function fetch(url)
    if type(request) == "function" then
        local ok, response = pcall(request, {Url = url, Method = "GET", Headers = {["Cache-Control"] = "no-cache"}})
        if ok and type(response) == "table" and response.StatusCode == 200 then return response.Body end
    end
    return game:HttpGet(url)
end

local luarmor = loadstring(fetch(LUARMOR_URL))()

-- key file ------------------------------------------------------------------
local function readKey()
    local ok, key = pcall(function()
        return isfile(KEY_FILE) and readfile(KEY_FILE) or nil
    end)
    key = ok and type(key) == "string" and key:match("^%s*(%S+)%s*$") or nil
    return key
end

local function saveKey(key)
    pcall(function()
        if not isfolder(KEY_FOLDER) then makefolder(KEY_FOLDER) end
        writefile(KEY_FILE, key)
    end)
end

local function forgetKey()
    pcall(function()
        if isfile(KEY_FILE) then delfile(KEY_FILE) end
    end)
end

-- validation ----------------------------------------------------------------
-- Returns the script the key unlocks, or nil plus the most useful status.
local function validate(key)
    key = tostring(key or ""):match("^%s*(.-)%s*$")
    if key == "" then return nil, {code = "KEY_INVALID"} end
    local best
    for _, script in ipairs(SCRIPTS) do
        luarmor.script_id = script.Id
        local ok, status = pcall(luarmor.check_key, key)
        if ok and type(status) == "table" then
            if status.code == "KEY_VALID" then return script, status end
            -- prefer a specific reason (expired, banned, hwid) over "does not exist"
            if not best or best.code == "KEY_INCORRECT" then best = status end
        elseif not best then
            best = {code = "UNKNOWN_ERROR", message = tostring(status)}
        end
    end
    return nil, best
end

local function describe(status)
    status = status or {}
    return MESSAGES[status.code] or tostring(status.message or status.code or "Could not verify the key.")
end

local function run(script, key)
    getgenv().script_key = key
    script_key = key
    luarmor.script_id = script.Id
    luarmor.load_script()
end

-- saved key: skip the UI when it is still valid ------------------------------
local savedKey = readKey()
local savedMessage
if savedKey then
    local script, status = validate(savedKey)
    if script then
        run(script, savedKey)
        return
    end
    forgetKey()
    savedMessage = "Your saved key is no longer valid: " .. describe(status)
end

-- access UI -----------------------------------------------------------------
local UI = loadstring(fetch(INTERFACE_URL), "@LowyxInterface")()
UI:CreateWindow({Title = "Lowyx Hub", Description = "Vox Seas"})

local tab = UI:AddTab({Id = "Access", Name = "Access", Icon = "info"})
local section = tab:AddSection({Id = "Key", Name = "Key System", Column = 1})
local keyInput = section:AddInput({Id = "Key", Name = "Key", Placeholder = "Paste your key..."})
local status = section:AddParagraph({Id = "Status", Name = "Status",
    Description = savedMessage or "Enter your key and press Verify."})

local busy = false
section:AddButton({Id = "Verify", Name = "Verify", Callback = function()
    if busy then return end
    busy = true
    local key = tostring(keyInput:Get() or ""):match("^%s*(.-)%s*$")
    status:SetDescription("Verifying...")
    local script, result = validate(key)
    if not script then
        status:SetDescription(describe(result))
        busy = false
        return
    end
    saveKey(key)
    status:SetDescription("Key valid (" .. script.Name .. "). Loading...")
    task.wait(0.6)
    UI.Destroy()
    run(script, key)
end})

section:AddButton({Id = "GetKey", Name = "Get Key", Callback = function()
    local copied = pcall(function() setclipboard(GET_KEY_URL) end)
    status:SetDescription(copied and ("Link copied: " .. GET_KEY_URL) or ("Get your key at: " .. GET_KEY_URL))
end})

UI.SelectTab("Access")
