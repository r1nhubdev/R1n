local scripts = {}
local id = scripts[game.PlaceId] or "90695fb80ef865532c9fcf700d589141"
local env = (getgenv and getgenv()) or _G
local sdk = loadstring(game:HttpGet("https://sdkapi-public.luarmor.net/library.lua"))()
sdk.script_id = id
local ui = loadstring(game:HttpGet("https://raw.githubusercontent.com/r1nhubdev/R1n/refs/heads/main/src/loader/interface.lua"))()
local function accept(key)
    if type(key) ~= "string" or not key:match("^[A-Za-z0-9]+$") or #key ~= 32 then
        return false,"Enter a valid 32-character key."
    end
    local ok, status = pcall(sdk.check_key, key)
    if not ok or type(status) ~= "table" then return false,"Key service unavailable. Try again." end
    if status.code == "KEY_VALID" then return true,"Key verified. Starting script..." end
    if status.code == "KEY_HWID_LOCKED" then return false,"Key linked to another device. Reset HWID in Discord." end
    return false, type(status.message) == "string" and status.message or "Invalid key."
end
ui:CreateWindow({Title = "Lowyx Hub | Key System", Description = "Key verification"})
local tab = ui:AddTab({Id = "KeySystem", Title = "Access", Icon = "settings"})
local section = tab:AddSection({Id = "Verification", Name = "Verification", Column = 1})
local status = section:AddParagraph({Id = "Status", Name = "Status", Description = "Enter your key to continue."})
local input = section:AddInput({Id = "Key", Name = "Key", Placeholder = "Enter your Luarmor key..."})
local busy = false
section:AddButton({Id = "Verify", Name = "Verify Key", Callback = function()
    if busy then
        return
    end
    busy = true
    status:SetDescription("Verifying...")
    local key = input:Get()
    local ok, accepted, message = pcall(accept, key)
    if not ok then busy = false;status:SetDescription("Verification failed. Try again.");return end
    status:SetDescription(message or (accepted and "Key accepted." or "Invalid key."))
    if not accepted then busy = false;return end
    env.script_key = key
    script_key = key
    task.spawn(function()
        local loaded, err = pcall(sdk.load_script)
        if not loaded then warn("Lowyx Hub: script startup failed: "..tostring(err)) end
    end)
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
