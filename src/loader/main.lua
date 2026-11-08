local scripts={[7633926880]="90695fb80ef865532c9fcf700d589141",[108194354348181]="90695fb80ef865532c9fcf700d589141",[114234929420007]="90695fb80ef865532c9fcf700d589141"}
local id=scripts[game.PlaceId] or "90695fb80ef865532c9fcf700d589141"
local env=(getgenv and getgenv()) or _G
local key=script_key or env.script_key
if type(key)~="string" or #key~=32 then warn("R1n Hub: set script_key to your Luarmor key first.");return end
env.script_key=key
script_key=key
local api=loadstring(game:HttpGet("https://sdkapi-public.luarmor.net/library.lua"))()
api.script_id=id
return api.load_script()
