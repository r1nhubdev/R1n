local scripts={}
local id=scripts[game.PlaceId] or "90695fb80ef865532c9fcf700d589141"
local env=(getgenv and getgenv()) or _G
local sdk=loadstring(game:HttpGet("https://sdkapi-public.luarmor.net/library.lua"))()
sdk.script_id=id
local ui=loadstring(game:HttpGet("https://raw.githubusercontent.com/r1nhubdev/R1n/refs/heads/main/src/loader/ui-v3.luau?v=lowyx-getkey-2"))()
local function accept(key)
    if type(key)~="string" or not key:match("^[A-Za-z0-9]+$") or #key~=32 then
        return false,"Enter a valid 32-character key."
    end
    local ok,status=pcall(sdk.check_key,key)
    if not ok or type(status)~="table" then return false,"Key service unavailable. Try again." end
    if status.code=="KEY_VALID" then return true,"Key verified. Starting script..." end
    if status.code=="KEY_HWID_LOCKED" then return false,"Key linked to another device. Reset HWID in Discord." end
    return false,type(status.message)=="string" and status.message or "Invalid key."
end
ui:CreateKeySystem({
    Title="Lowyx Hub | Key System",Placeholder="Enter your Luarmor key...",
    CloseOnSuccess=true,KeyURL="https://discord.gg/lowyx",
    Verify=accept,
    OnGetKey=function()
        local link="https://discord.gg/lowyx"
        if type(setclipboard)=="function" then
            local ok=pcall(setclipboard,link)
            if ok then return "Discord link copied: "..link end
        end
        return "Get your key: "..link
    end,
    OnSuccess=function(key)
        env.script_key=key
        script_key=key
        task.spawn(function()
            local ok,err=pcall(sdk.load_script)
            if not ok then warn("Lowyx Hub: script startup failed: "..tostring(err)) end
        end)
    end,
})
