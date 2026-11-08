local scripts={[2753915549]="7ffba6e56861496f9d884a4a2563ffcd",[4442272183]="7ffba6e56861496f9d884a4a2563ffcd",[7449423635]="7ffba6e56861496f9d884a4a2563ffcd",[7633926880]="90695fb80ef865532c9fcf700d589141",[79091703265657]="7ffba6e56861496f9d884a4a2563ffcd",[85211729168715]="7ffba6e56861496f9d884a4a2563ffcd",[100117331123089]="7ffba6e56861496f9d884a4a2563ffcd",[106198175232796]="c713d9eb1adc628624fbe525f7fcb337",[108194354348181]="90695fb80ef865532c9fcf700d589141",[114234929420007]="90695fb80ef865532c9fcf700d589141"}
local id=scripts[game.PlaceId] or "90695fb80ef865532c9fcf700d589141"
local env=(getgenv and getgenv()) or _G
local sdk=loadstring(game:HttpGet("https://sdkapi-public.luarmor.net/library.lua"))()
sdk.script_id=id
local ui=loadstring(game:HttpGet("https://raw.githubusercontent.com/r1nhubdev/R1n/refs/heads/main/src/loader/ui-v3.luau"))()
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
    Title="R1n Hub | Key System",Placeholder="Enter your Luarmor key...",
    SaveKey=true,AutoLoad=true,HideMain=true,CloseOnSuccess=true,
    KeyURL="https://discord.gg/r1nhub",
    Verify=accept,
    OnVerified=function(key)
        env.script_key=key
        script_key=key
        task.spawn(function()
            local ok,err=pcall(sdk.load_script)
            if not ok then warn("R1n Hub: script startup failed: "..tostring(err)) end
        end)
    end,
})
