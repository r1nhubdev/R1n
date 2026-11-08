local libraryEnvironment=((getgenv or getfenv) :: any)()
local previousLibrary=libraryEnvironment.R1nUI
if previousLibrary and type(previousLibrary.Destroy)=="function" then pcall(previousLibrary.Destroy) end
local runtimeHost=getfenv().STATE
local cleanupCallbacks={}
local runtimeDestroyed=false
local function destroyRuntime()
    if runtimeDestroyed then return end
    runtimeDestroyed=true
    for index=#cleanupCallbacks,1,-1 do pcall(cleanupCallbacks[index]) end
    table.clear(cleanupCallbacks)
end
local STATE={}
function STATE.onCleanup(callback)
    if runtimeDestroyed then pcall(callback) else table.insert(cleanupCallbacks,callback) end
end
function STATE.connect(signal,callback)
    local connection=signal:Connect(callback)
    STATE.onCleanup(function() connection:Disconnect() end)
    return connection
end
if runtimeHost and type(runtimeHost.onCleanup)=="function" then runtimeHost.onCleanup(destroyRuntime) end

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local camera = workspace.CurrentCamera
local uiFont = Font.new("rbxasset://fonts/families/Roboto.json", Enum.FontWeight.Medium)

local spec = HttpService:JSONDecode([==[
{"class":"ScreenGui","children":[{"class":"Frame","children":[{"class":"UICorner","children":[],"properties":{"Name":"UICorner","Archivable":true,"CornerRadius":{"value":[0,8],"type":"UDim"}}},{"class":"UIShadow","children":[],"properties":{"Offset":{"value":[0,0,0,0],"type":"UDim2"},"Transparency":0.5,"Name":"UIShadow","BlurRadius":{"value":[0,20],"type":"UDim"},"Color":{"value":[0,0,0],"type":"Color3"},"Archivable":true}},{"class":"Frame","children":[{"class":"UICorner","children":[],"properties":{"Name":"UICorner","Archivable":true,"CornerRadius":{"value":[0,8],"type":"UDim"}}},{"class":"UIShadow","children":[],"properties":{"Offset":{"value":[0,0,0,0],"type":"UDim2"},"Transparency":0.5,"Name":"UIShadow","BlurRadius":{"value":[0,20],"type":"UDim"},"Color":{"value":[0,0,0],"type":"Color3"},"Archivable":true}}],"properties":{"Visible":true,"AutomaticSize":{"value":["AutomaticSize","None"],"type":"EnumItem"},"Active":false,"ClipsDescendants":false,"BorderColor3":{"value":[0,0,0],"type":"Color3"},"LayoutOrder":0,"BackgroundColor3":{"value":[0.05098039656877518,0.05098039656877518,0.05098039656877518],"type":"Color3"},"Rotation":0,"AnchorPoint":{"value":[0,0],"type":"Vector2"},"BorderSizePixel":0,"Name":"Frame","Position":{"value":[0,0,0,0],"type":"UDim2"},"BackgroundTransparency":0,"ZIndex":1,"Archivable":true,"Size":{"value":[0,198,0,542],"type":"UDim2"}}},{"class":"Frame","children":[{"class":"UIShadow","children":[],"properties":{"Offset":{"value":[0,0,0,0],"type":"UDim2"},"Transparency":0.5,"Name":"UIShadow","BlurRadius":{"value":[0,20],"type":"UDim"},"Color":{"value":[0,0,0],"type":"Color3"},"Archivable":true}},{"class":"UICorner","children":[],"properties":{"Name":"UICorner","Archivable":true,"CornerRadius":{"value":[0,8],"type":"UDim"}}},{"class":"Frame","children":[{"class":"UICorner","children":[],"properties":{"Name":"UICorner","Archivable":true,"CornerRadius":{"value":[0,8],"type":"UDim"}}},{"class":"UIShadow","children":[],"properties":{"Offset":{"value":[0,0,0,0],"type":"UDim2"},"Transparency":0.5,"Name":"UIShadow","BlurRadius":{"value":[0,20],"type":"UDim"},"Color":{"value":[0,0,0],"type":"Color3"},"Archivable":true}}],"properties":{"Visible":true,"AutomaticSize":{"value":["AutomaticSize","None"],"type":"EnumItem"},"Active":false,"ClipsDescendants":false,"BorderColor3":{"value":[0,0,0],"type":"Color3"},"LayoutOrder":0,"BackgroundColor3":{"value":[0,0,0],"type":"Color3"},"Rotation":0,"AnchorPoint":{"value":[0,0],"type":"Vector2"},"BorderSizePixel":0,"Name":"Frame","Position":{"value":[0.08365018665790558,0,0.28289473056793215,0],"type":"UDim2"},"BackgroundTransparency":0,"ZIndex":1,"Archivable":true,"Size":{"value":[0,24,0,23],"type":"UDim2"}}},{"class":"Frame","children":[{"class":"UICorner","children":[],"properties":{"Name":"UICorner","Archivable":true,"CornerRadius":{"value":[0,8],"type":"UDim"}}},{"class":"UIShadow","children":[],"properties":{"Offset":{"value":[0,0,0,0],"type":"UDim2"},"Transparency":0.5,"Name":"UIShadow","BlurRadius":{"value":[0,20],"type":"UDim"},"Color":{"value":[0,0,0],"type":"Color3"},"Archivable":true}}],"properties":{"Visible":true,"AutomaticSize":{"value":["AutomaticSize","None"],"type":"EnumItem"},"Active":false,"ClipsDescendants":false,"BorderColor3":{"value":[0,0,0],"type":"Color3"},"LayoutOrder":0,"BackgroundColor3":{"value":[0,0,0],"type":"Color3"},"Rotation":0,"AnchorPoint":{"value":[0,0],"type":"Vector2"},"BorderSizePixel":0,"Name":"Frame","Position":{"value":[0.08365018665790558,0,0.5,0],"type":"UDim2"},"BackgroundTransparency":0,"ZIndex":1,"Archivable":true,"Size":{"value":[0,24,0,23],"type":"UDim2"}}},{"class":"Frame","children":[{"class":"UICorner","children":[],"properties":{"Name":"UICorner","Archivable":true,"CornerRadius":{"value":[0,8],"type":"UDim"}}},{"class":"UIShadow","children":[],"properties":{"Offset":{"value":[0,0,0,0],"type":"UDim2"},"Transparency":0.5,"Name":"UIShadow","BlurRadius":{"value":[0,20],"type":"UDim"},"Color":{"value":[0,0,0],"type":"Color3"},"Archivable":true}}],"properties":{"Visible":true,"AutomaticSize":{"value":["AutomaticSize","None"],"type":"EnumItem"},"Active":false,"ClipsDescendants":false,"BorderColor3":{"value":[0,0,0],"type":"Color3"},"LayoutOrder":0,"BackgroundColor3":{"value":[0.15294118225574494,0.2980392277240753,0.6313725709915161],"type":"Color3"},"Rotation":0,"AnchorPoint":{"value":[0,0],"type":"Vector2"},"BorderSizePixel":0,"Name":"Frame","Position":{"value":[0.19771863520145417,0,0.5,0],"type":"UDim2"},"BackgroundTransparency":0,"ZIndex":1,"Archivable":true,"Size":{"value":[0,24,0,23],"type":"UDim2"}}},{"class":"Frame","children":[{"class":"UICorner","children":[],"properties":{"Name":"UICorner","Archivable":true,"CornerRadius":{"value":[0,8],"type":"UDim"}}},{"class":"UIShadow","children":[],"properties":{"Offset":{"value":[0,0,0,0],"type":"UDim2"},"Transparency":0.5,"Name":"UIShadow","BlurRadius":{"value":[0,20],"type":"UDim"},"Color":{"value":[0,0,0],"type":"Color3"},"Archivable":true}}],"properties":{"Visible":true,"AutomaticSize":{"value":["AutomaticSize","None"],"type":"EnumItem"},"Active":false,"ClipsDescendants":false,"BorderColor3":{"value":[0,0,0],"type":"Color3"},"LayoutOrder":0,"BackgroundColor3":{"value":[0,0,0],"type":"Color3"},"Rotation":0,"AnchorPoint":{"value":[0,0],"type":"Vector2"},"BorderSizePixel":0,"Name":"Frame","Position":{"value":[0.08365018665790558,0,0.6973684430122376,0],"type":"UDim2"},"BackgroundTransparency":0,"ZIndex":1,"Archivable":true,"Size":{"value":[0,24,0,23],"type":"UDim2"}}},{"class":"Frame","children":[{"class":"UICorner","children":[],"properties":{"Name":"UICorner","Archivable":true,"CornerRadius":{"value":[0,8],"type":"UDim"}}},{"class":"UIShadow","children":[],"properties":{"Offset":{"value":[0,0,0,0],"type":"UDim2"},"Transparency":0.5,"Name":"UIShadow","BlurRadius":{"value":[0,20],"type":"UDim"},"Color":{"value":[0,0,0],"type":"Color3"},"Archivable":true}}],"properties":{"Visible":true,"AutomaticSize":{"value":["AutomaticSize","None"],"type":"EnumItem"},"Active":false,"ClipsDescendants":false,"BorderColor3":{"value":[0,0,0],"type":"Color3"},"LayoutOrder":0,"BackgroundColor3":{"value":[0.15294118225574494,0.2980392277240753,0.6313725709915161],"type":"Color3"},"Rotation":0,"AnchorPoint":{"value":[0,0],"type":"Vector2"},"BorderSizePixel":0,"Name":"Frame","Position":{"value":[0.19771863520145417,0,0.6973684430122376,0],"type":"UDim2"},"BackgroundTransparency":0,"ZIndex":1,"Archivable":true,"Size":{"value":[0,24,0,23],"type":"UDim2"}}}],"properties":{"Visible":true,"AutomaticSize":{"value":["AutomaticSize","None"],"type":"EnumItem"},"Active":false,"ClipsDescendants":false,"BorderColor3":{"value":[0,0,0],"type":"Color3"},"LayoutOrder":0,"BackgroundColor3":{"value":[0.05882353335618973,0.05882353335618973,0.05882353335618973],"type":"Color3"},"Rotation":0,"AnchorPoint":{"value":[0,0],"type":"Vector2"},"BorderSizePixel":0,"Name":"Frame","Position":{"value":[0.2769607901573181,0,0.042435422539711,0],"type":"UDim2"},"BackgroundTransparency":0,"ZIndex":1,"Archivable":true,"Size":{"value":[0,263,0,152],"type":"UDim2"}}},{"class":"Frame","children":[{"class":"UIShadow","children":[],"properties":{"Offset":{"value":[0,0,0,0],"type":"UDim2"},"Transparency":0.5,"Name":"UIShadow","BlurRadius":{"value":[0,20],"type":"UDim"},"Color":{"value":[0,0,0],"type":"Color3"},"Archivable":true}},{"class":"UICorner","children":[],"properties":{"Name":"UICorner","Archivable":true,"CornerRadius":{"value":[0,8],"type":"UDim"}}}],"properties":{"Visible":true,"AutomaticSize":{"value":["AutomaticSize","None"],"type":"EnumItem"},"Active":false,"ClipsDescendants":false,"BorderColor3":{"value":[0,0,0],"type":"Color3"},"LayoutOrder":0,"BackgroundColor3":{"value":[0.05882353335618973,0.05882353335618973,0.05882353335618973],"type":"Color3"},"Rotation":0,"AnchorPoint":{"value":[0,0],"type":"Vector2"},"BorderSizePixel":0,"Name":"Frame","Position":{"value":[0.6361068487167358,0,0.04428044334053993,0],"type":"UDim2"},"BackgroundTransparency":0,"ZIndex":1,"Archivable":true,"Size":{"value":[0,263,0,494],"type":"UDim2"}}},{"class":"Frame","children":[{"class":"UIShadow","children":[],"properties":{"Offset":{"value":[0,0,0,0],"type":"UDim2"},"Transparency":0.5,"Name":"UIShadow","BlurRadius":{"value":[0,20],"type":"UDim"},"Color":{"value":[0,0,0],"type":"Color3"},"Archivable":true}},{"class":"UICorner","children":[],"properties":{"Name":"UICorner","Archivable":true,"CornerRadius":{"value":[0,8],"type":"UDim"}}},{"class":"Frame","children":[{"class":"UICorner","children":[],"properties":{"Name":"UICorner","Archivable":true,"CornerRadius":{"value":[0,8],"type":"UDim"}}},{"class":"UIShadow","children":[],"properties":{"Offset":{"value":[0,0,0,0],"type":"UDim2"},"Transparency":0.5,"Name":"UIShadow","BlurRadius":{"value":[0,20],"type":"UDim"},"Color":{"value":[0,0,0],"type":"Color3"},"Archivable":true}}],"properties":{"Visible":true,"AutomaticSize":{"value":["AutomaticSize","None"],"type":"EnumItem"},"Active":false,"ClipsDescendants":false,"BorderColor3":{"value":[0,0,0],"type":"Color3"},"LayoutOrder":0,"BackgroundColor3":{"value":[0,0,0],"type":"Color3"},"Rotation":0,"AnchorPoint":{"value":[0,0],"type":"Vector2"},"BorderSizePixel":0,"Name":"Frame","Position":{"value":[0.5779460668563843,0,0.2591463327407837,0],"type":"UDim2"},"BackgroundTransparency":0,"ZIndex":1,"Archivable":true,"Size":{"value":[0,65,0,14],"type":"UDim2"}}}],"properties":{"Visible":true,"AutomaticSize":{"value":["AutomaticSize","None"],"type":"EnumItem"},"Active":false,"ClipsDescendants":false,"BorderColor3":{"value":[0,0,0],"type":"Color3"},"LayoutOrder":0,"BackgroundColor3":{"value":[0.05882353335618973,0.05882353335618973,0.05882353335618973],"type":"Color3"},"Rotation":0,"AnchorPoint":{"value":[0,0],"type":"Vector2"},"BorderSizePixel":0,"Name":"Frame","Position":{"value":[0.2769607901573181,0,0.3505535125732422,0],"type":"UDim2"},"BackgroundTransparency":0,"ZIndex":1,"Archivable":true,"Size":{"value":[0,263,0,328],"type":"UDim2"}}},{"class":"TextLabel","children":[],"properties":{"LayoutOrder":0,"FontFace":{"value":["rbxasset://fonts/families/JosefinSans.json","Regular","Normal"],"type":"Font"},"LineHeight":1,"Active":false,"TextTransparency":0,"AnchorPoint":{"value":[0,0],"type":"Vector2"},"BorderSizePixel":0,"TextTruncate":{"value":["TextTruncate","None"],"type":"EnumItem"},"Name":"TextLabel","ZIndex":1,"Archivable":true,"Size":{"value":[0,200,0,50],"type":"UDim2"},"TextWrapped":false,"RichText":false,"TextXAlignment":{"value":["TextXAlignment","Center"],"type":"EnumItem"},"ClipsDescendants":false,"BorderColor3":{"value":[0,0,0],"type":"Color3"},"Text":"R1nHub.","TextSize":19,"TextColor3":{"value":[1,1,1],"type":"Color3"},"Rotation":0,"Visible":true,"BackgroundTransparency":1,"Position":{"value":[-0.011378002353012562,0,0.016605166718363763,0],"type":"UDim2"},"AutomaticSize":{"value":["AutomaticSize","None"],"type":"EnumItem"},"TextYAlignment":{"value":["TextYAlignment","Center"],"type":"EnumItem"},"TextScaled":false,"BackgroundColor3":{"value":[1,1,1],"type":"Color3"}}},{"class":"TextLabel","children":[],"properties":{"LayoutOrder":0,"FontFace":{"value":["rbxasset://fonts/families/JosefinSans.json","Regular","Normal"],"type":"Font"},"LineHeight":1,"Active":false,"TextTransparency":0,"AnchorPoint":{"value":[0,0],"type":"Vector2"},"BorderSizePixel":0,"TextTruncate":{"value":["TextTruncate","None"],"type":"EnumItem"},"Name":"TextLabel","ZIndex":1,"Archivable":true,"Size":{"value":[0,58,0,26],"type":"UDim2"},"TextWrapped":false,"RichText":false,"TextXAlignment":{"value":["TextXAlignment","Center"],"type":"EnumItem"},"ClipsDescendants":false,"BorderColor3":{"value":[0,0,0],"type":"Color3"},"Text":"xyz","TextSize":24,"TextColor3":{"value":[0.2980392277240753,0.545098066329956,1],"type":"Color3"},"Rotation":0,"Visible":true,"BackgroundTransparency":1,"Position":{"value":[0.14538559317588807,0,0.03874538838863373,0],"type":"UDim2"},"AutomaticSize":{"value":["AutomaticSize","None"],"type":"EnumItem"},"TextYAlignment":{"value":["TextYAlignment","Center"],"type":"EnumItem"},"TextScaled":false,"BackgroundColor3":{"value":[1,1,1],"type":"Color3"}}},{"class":"TextLabel","children":[],"properties":{"LayoutOrder":0,"FontFace":{"value":["rbxasset://fonts/families/JosefinSans.json","Regular","Normal"],"type":"Font"},"LineHeight":1,"Active":false,"TextTransparency":0,"AnchorPoint":{"value":[0,0],"type":"Vector2"},"BorderSizePixel":0,"TextTruncate":{"value":["TextTruncate","None"],"type":"EnumItem"},"Name":"TextLabel","ZIndex":1,"Archivable":true,"Size":{"value":[0,200,0,50],"type":"UDim2"},"TextWrapped":false,"RichText":false,"TextXAlignment":{"value":["TextXAlignment","Center"],"type":"EnumItem"},"ClipsDescendants":false,"BorderColor3":{"value":[0,0,0],"type":"Color3"},"Text":"Section","TextSize":16,"TextColor3":{"value":[0.6745098233222961,0.6745098233222961,0.6745098233222961],"type":"Color3"},"Rotation":0,"Visible":true,"BackgroundTransparency":1,"Position":{"value":[0.20733249187469483,0,0.029520295560359956,0],"type":"UDim2"},"AutomaticSize":{"value":["AutomaticSize","None"],"type":"EnumItem"},"TextYAlignment":{"value":["TextYAlignment","Center"],"type":"EnumItem"},"TextScaled":false,"BackgroundColor3":{"value":[1,1,1],"type":"Color3"}}},{"class":"TextLabel","children":[],"properties":{"LayoutOrder":0,"FontFace":{"value":["rbxasset://fonts/families/JosefinSans.json","Regular","Normal"],"type":"Font"},"LineHeight":1,"Active":false,"TextTransparency":0,"AnchorPoint":{"value":[0,0],"type":"Vector2"},"BorderSizePixel":0,"TextTruncate":{"value":["TextTruncate","None"],"type":"EnumItem"},"Name":"TextLabel","ZIndex":1,"Archivable":true,"Size":{"value":[0,200,0,50],"type":"UDim2"},"TextWrapped":false,"RichText":false,"TextXAlignment":{"value":["TextXAlignment","Center"],"type":"EnumItem"},"ClipsDescendants":false,"BorderColor3":{"value":[0,0,0],"type":"Color3"},"Text":"Section","TextSize":16,"TextColor3":{"value":[0.6745098233222961,0.6745098233222961,0.6745098233222961],"type":"Color3"},"Rotation":0,"Visible":true,"BackgroundTransparency":1,"Position":{"value":[0.5663716793060303,0,0.029520295560359956,0],"type":"UDim2"},"AutomaticSize":{"value":["AutomaticSize","None"],"type":"EnumItem"},"TextYAlignment":{"value":["TextYAlignment","Center"],"type":"EnumItem"},"TextScaled":false,"BackgroundColor3":{"value":[1,1,1],"type":"Color3"}}},{"class":"TextLabel","children":[],"properties":{"LayoutOrder":0,"FontFace":{"value":["rbxasset://fonts/families/JosefinSans.json","Regular","Normal"],"type":"Font"},"LineHeight":1,"Active":false,"TextTransparency":0,"AnchorPoint":{"value":[0,0],"type":"Vector2"},"BorderSizePixel":0,"TextTruncate":{"value":["TextTruncate","None"],"type":"EnumItem"},"Name":"TextLabel","ZIndex":1,"Archivable":true,"Size":{"value":[0,200,0,50],"type":"UDim2"},"TextWrapped":false,"RichText":false,"TextXAlignment":{"value":["TextXAlignment","Center"],"type":"EnumItem"},"ClipsDescendants":false,"BorderColor3":{"value":[0,0,0],"type":"Color3"},"Text":"Section","TextSize":16,"TextColor3":{"value":[0.6745098233222961,0.6745098233222961,0.6745098233222961],"type":"Color3"},"Rotation":0,"Visible":true,"BackgroundTransparency":1,"Position":{"value":[0.20733249187469483,0,0.3505535125732422,0],"type":"UDim2"},"AutomaticSize":{"value":["AutomaticSize","None"],"type":"EnumItem"},"TextYAlignment":{"value":["TextYAlignment","Center"],"type":"EnumItem"},"TextScaled":false,"BackgroundColor3":{"value":[1,1,1],"type":"Color3"}}},{"class":"TextLabel","children":[],"properties":{"LayoutOrder":0,"FontFace":{"value":["rbxasset://fonts/families/JosefinSans.json","Regular","Normal"],"type":"Font"},"LineHeight":1,"Active":false,"TextTransparency":0,"AnchorPoint":{"value":[0,0],"type":"Vector2"},"BorderSizePixel":0,"TextTruncate":{"value":["TextTruncate","None"],"type":"EnumItem"},"Name":"TextLabel","ZIndex":1,"Archivable":true,"Size":{"value":[0,123,0,43],"type":"UDim2"},"TextWrapped":false,"RichText":false,"TextXAlignment":{"value":["TextXAlignment","Center"],"type":"EnumItem"},"ClipsDescendants":false,"BorderColor3":{"value":[0,0,0],"type":"Color3"},"Text":"Example Toggle","TextSize":16,"TextColor3":{"value":[0.6745098233222961,0.6745098233222961,0.6745098233222961],"type":"Color3"},"Rotation":0,"Visible":true,"BackgroundTransparency":1,"Position":{"value":[0.3440000116825104,0,0.10499999672174454,0],"type":"UDim2"},"AutomaticSize":{"value":["AutomaticSize","None"],"type":"EnumItem"},"TextYAlignment":{"value":["TextYAlignment","Center"],"type":"EnumItem"},"TextScaled":false,"BackgroundColor3":{"value":[1,1,1],"type":"Color3"}}},{"class":"TextLabel","children":[],"properties":{"LayoutOrder":0,"FontFace":{"value":["rbxasset://fonts/families/JosefinSans.json","Regular","Normal"],"type":"Font"},"LineHeight":1,"Active":false,"TextTransparency":0,"AnchorPoint":{"value":[0,0],"type":"Vector2"},"BorderSizePixel":0,"TextTruncate":{"value":["TextTruncate","None"],"type":"EnumItem"},"Name":"TextLabel","ZIndex":1,"Archivable":true,"Size":{"value":[0,123,0,50],"type":"UDim2"},"TextWrapped":false,"RichText":false,"TextXAlignment":{"value":["TextXAlignment","Center"],"type":"EnumItem"},"ClipsDescendants":false,"BorderColor3":{"value":[0,0,0],"type":"Color3"},"Text":"Example Toggle","TextSize":16,"TextColor3":{"value":[0.6745098233222961,0.6745098233222961,0.6745098233222961],"type":"Color3"},"Rotation":0,"Visible":true,"BackgroundTransparency":1,"Position":{"value":[0.38199999928474429,0,0.1589999943971634,0],"type":"UDim2"},"AutomaticSize":{"value":["AutomaticSize","None"],"type":"EnumItem"},"TextYAlignment":{"value":["TextYAlignment","Center"],"type":"EnumItem"},"TextScaled":false,"BackgroundColor3":{"value":[1,1,1],"type":"Color3"}}},{"class":"ImageLabel","children":[],"properties":{"LayoutOrder":0,"Active":false,"AnchorPoint":{"value":[0,0],"type":"Vector2"},"Image":"rbxassetid://91258823950878","ZIndex":1,"Archivable":true,"Size":{"value":[0,25,0,23],"type":"UDim2"},"Visible":true,"ScaleType":{"value":["ScaleType","Stretch"],"type":"EnumItem"},"AutomaticSize":{"value":["AutomaticSize","None"],"type":"EnumItem"},"ClipsDescendants":false,"BorderColor3":{"value":[0,0,0],"type":"Color3"},"SliceCenter":{"value":[0,0,0,0],"type":"Rect"},"ImageTransparency":0,"ImageColor3":{"value":[0.6235294342041016,0.6235294342041016,0.6235294342041016],"type":"Color3"},"Rotation":0,"ResampleMode":{"value":["ResamplerMode","Default"],"type":"EnumItem"},"BackgroundTransparency":1,"Position":{"value":[0.381795197725296,0,0.23800738155841828,0],"type":"UDim2"},"SliceScale":1,"Name":"ImageLabel","BorderSizePixel":0,"BackgroundColor3":{"value":[1,1,1],"type":"Color3"}}},{"class":"TextLabel","children":[],"properties":{"LayoutOrder":0,"FontFace":{"value":["rbxasset://fonts/families/JosefinSans.json","Regular","Normal"],"type":"Font"},"LineHeight":1,"Active":false,"TextTransparency":0,"AnchorPoint":{"value":[0,0],"type":"Vector2"},"BorderSizePixel":0,"TextTruncate":{"value":["TextTruncate","None"],"type":"EnumItem"},"Name":"TextLabel","ZIndex":1,"Archivable":true,"Size":{"value":[0,123,0,50],"type":"UDim2"},"TextWrapped":false,"RichText":false,"TextXAlignment":{"value":["TextXAlignment","Center"],"type":"EnumItem"},"ClipsDescendants":false,"BorderColor3":{"value":[0,0,0],"type":"Color3"},"Text":"Example Toggle","TextSize":16,"TextColor3":{"value":[0.6745098233222961,0.6745098233222961,0.6745098233222961],"type":"Color3"},"Rotation":0,"Visible":true,"BackgroundTransparency":1,"Position":{"value":[0.421999990940094,0,0.2150000035762787,0],"type":"UDim2"},"AutomaticSize":{"value":["AutomaticSize","None"],"type":"EnumItem"},"TextYAlignment":{"value":["TextYAlignment","Center"],"type":"EnumItem"},"TextScaled":false,"BackgroundColor3":{"value":[1,1,1],"type":"Color3"}}},{"class":"Frame","children":[{"class":"UIShadow","children":[],"properties":{"Offset":{"value":[0,0,0,0],"type":"UDim2"},"Transparency":0.5,"Name":"UIShadow","BlurRadius":{"value":[0,20],"type":"UDim"},"Color":{"value":[0,0,0],"type":"Color3"},"Archivable":true}},{"class":"UICorner","children":[],"properties":{"Name":"UICorner","Archivable":true,"CornerRadius":{"value":[0,8],"type":"UDim"}}}],"properties":{"Visible":true,"AutomaticSize":{"value":["AutomaticSize","None"],"type":"EnumItem"},"Active":false,"ClipsDescendants":false,"BorderColor3":{"value":[0,0,0],"type":"Color3"},"LayoutOrder":0,"BackgroundColor3":{"value":[0.05882353335618973,0.05882353335618973,0.05882353335618973],"type":"Color3"},"Rotation":0,"AnchorPoint":{"value":[0,0],"type":"Vector2"},"BorderSizePixel":0,"Name":"Frame","Position":{"value":[0.302245169878006,0,0.4243542551994324,0],"type":"UDim2"},"BackgroundTransparency":0,"ZIndex":1,"Archivable":true,"Size":{"value":[0,223,0,30],"type":"UDim2"}}},{"class":"TextLabel","children":[],"properties":{"LayoutOrder":0,"FontFace":{"value":["rbxasset://fonts/families/JosefinSans.json","Regular","Normal"],"type":"Font"},"LineHeight":1,"Active":false,"TextTransparency":0,"AnchorPoint":{"value":[0,0],"type":"Vector2"},"BorderSizePixel":0,"TextTruncate":{"value":["TextTruncate","None"],"type":"EnumItem"},"Name":"TextLabel","ZIndex":1,"Archivable":true,"Size":{"value":[0,200,0,50],"type":"UDim2"},"TextWrapped":false,"RichText":false,"TextXAlignment":{"value":["TextXAlignment","Center"],"type":"EnumItem"},"ClipsDescendants":false,"BorderColor3":{"value":[0,0,0],"type":"Color3"},"Text":"Select Option...","TextSize":15,"TextColor3":{"value":[0.6745098233222961,0.6745098233222961,0.6745098233222961],"type":"Color3"},"Rotation":0,"Visible":true,"BackgroundTransparency":1,"Position":{"value":[0.26042982935905459,0,0.40590405464172366,0],"type":"UDim2"},"AutomaticSize":{"value":["AutomaticSize","None"],"type":"EnumItem"},"TextYAlignment":{"value":["TextYAlignment","Center"],"type":"EnumItem"},"TextScaled":false,"BackgroundColor3":{"value":[1,1,1],"type":"Color3"}}},{"class":"ImageLabel","children":[],"properties":{"LayoutOrder":0,"Active":false,"AnchorPoint":{"value":[0,0],"type":"Vector2"},"Image":"rbxassetid://93978254092335","ZIndex":1,"Archivable":true,"Size":{"value":[0,19,0,21],"type":"UDim2"},"Visible":true,"ScaleType":{"value":["ScaleType","Stretch"],"type":"EnumItem"},"AutomaticSize":{"value":["AutomaticSize","None"],"type":"EnumItem"},"ClipsDescendants":false,"BorderColor3":{"value":[0,0,0],"type":"Color3"},"SliceCenter":{"value":[0,0,0,0],"type":"Rect"},"ImageTransparency":0,"ImageColor3":{"value":[0.6235294342041016,0.6235294342041016,0.6235294342041016],"type":"Color3"},"Rotation":0,"ResampleMode":{"value":["ResamplerMode","Default"],"type":"EnumItem"},"BackgroundTransparency":1,"Position":{"value":[0.5524652600288391,0,0.4317343235015869,0],"type":"UDim2"},"SliceScale":1,"Name":"ImageLabel","BorderSizePixel":0,"BackgroundColor3":{"value":[1,1,1],"type":"Color3"}}},{"class":"TextLabel","children":[],"properties":{"LayoutOrder":0,"FontFace":{"value":["rbxasset://fonts/families/JosefinSans.json","Regular","Normal"],"type":"Font"},"LineHeight":1,"Active":false,"TextTransparency":0,"AnchorPoint":{"value":[0,0],"type":"Vector2"},"BorderSizePixel":0,"TextTruncate":{"value":["TextTruncate","None"],"type":"EnumItem"},"Name":"TextLabel","ZIndex":1,"Archivable":true,"Size":{"value":[0,123,0,43],"type":"UDim2"},"TextWrapped":false,"RichText":false,"TextXAlignment":{"value":["TextXAlignment","Center"],"type":"EnumItem"},"ClipsDescendants":false,"BorderColor3":{"value":[0,0,0],"type":"Color3"},"Text":"Example Slider","TextSize":16,"TextColor3":{"value":[0.6745098233222961,0.6745098233222961,0.6745098233222961],"type":"Color3"},"Rotation":0,"Visible":true,"BackgroundTransparency":1,"Position":{"value":[0.30354487895965578,0,0.4795387387275696,0],"type":"UDim2"},"AutomaticSize":{"value":["AutomaticSize","None"],"type":"EnumItem"},"TextYAlignment":{"value":["TextYAlignment","Center"],"type":"EnumItem"},"TextScaled":false,"BackgroundColor3":{"value":[1,1,1],"type":"Color3"}}},{"class":"TextLabel","children":[],"properties":{"LayoutOrder":0,"FontFace":{"value":["rbxasset://fonts/families/JosefinSans.json","Medium","Normal"],"type":"Font"},"LineHeight":1,"Active":false,"TextTransparency":0,"AnchorPoint":{"value":[0,0],"type":"Vector2"},"BorderSizePixel":0,"TextTruncate":{"value":["TextTruncate","None"],"type":"EnumItem"},"Name":"TextLabel","ZIndex":1,"Archivable":true,"Size":{"value":[0,43,0,23],"type":"UDim2"},"TextWrapped":false,"RichText":false,"TextXAlignment":{"value":["TextXAlignment","Center"],"type":"EnumItem"},"ClipsDescendants":false,"BorderColor3":{"value":[0,0,0],"type":"Color3"},"Text":"100","TextSize":12,"TextColor3":{"value":[0.6745098233222961,0.6745098233222961,0.6745098233222961],"type":"Color3"},"Rotation":0,"Visible":true,"BackgroundTransparency":1,"Position":{"value":[0.5512009859085083,0,0.49815496802330019,0],"type":"UDim2"},"AutomaticSize":{"value":["AutomaticSize","None"],"type":"EnumItem"},"TextYAlignment":{"value":["TextYAlignment","Center"],"type":"EnumItem"},"TextScaled":false,"BackgroundColor3":{"value":[1,1,1],"type":"Color3"}}},{"class":"Frame","children":[{"class":"UIShadow","children":[],"properties":{"Offset":{"value":[0,0,0,0],"type":"UDim2"},"Transparency":0.5,"Name":"UIShadow","BlurRadius":{"value":[0,20],"type":"UDim"},"Color":{"value":[0,0,0],"type":"Color3"},"Archivable":true}},{"class":"UICorner","children":[],"properties":{"Name":"UICorner","Archivable":true,"CornerRadius":{"value":[0,8],"type":"UDim"}}}],"properties":{"Visible":true,"AutomaticSize":{"value":["AutomaticSize","None"],"type":"EnumItem"},"Active":false,"ClipsDescendants":false,"BorderColor3":{"value":[0,0,0],"type":"Color3"},"LayoutOrder":0,"BackgroundColor3":{"value":[0.05882353335618973,0.05882353335618973,0.05882353335618973],"type":"Color3"},"Rotation":0,"AnchorPoint":{"value":[0,0],"type":"Vector2"},"BorderSizePixel":0,"Name":"Frame","Position":{"value":[0.302245169878006,0,0.5571955442428589,0],"type":"UDim2"},"BackgroundTransparency":0,"ZIndex":1,"Archivable":true,"Size":{"value":[0,223,0,30],"type":"UDim2"}}},{"class":"TextLabel","children":[],"properties":{"LayoutOrder":0,"FontFace":{"value":["rbxasset://fonts/families/JosefinSans.json","Regular","Normal"],"type":"Font"},"LineHeight":1,"Active":false,"TextTransparency":0,"AnchorPoint":{"value":[0,0],"type":"Vector2"},"BorderSizePixel":0,"TextTruncate":{"value":["TextTruncate","None"],"type":"EnumItem"},"Name":"TextLabel","ZIndex":1,"Archivable":true,"Size":{"value":[0,200,0,50],"type":"UDim2"},"TextWrapped":false,"RichText":false,"TextXAlignment":{"value":["TextXAlignment","Center"],"type":"EnumItem"},"ClipsDescendants":false,"BorderColor3":{"value":[0,0,0],"type":"Color3"},"Text":"Button","TextSize":15,"TextColor3":{"value":[0.6745098233222961,0.6745098233222961,0.6745098233222961],"type":"Color3"},"Rotation":0,"Visible":true,"BackgroundTransparency":1,"Position":{"value":[0.31605562567710879,0,0.5387454032897949,0],"type":"UDim2"},"AutomaticSize":{"value":["AutomaticSize","None"],"type":"EnumItem"},"TextYAlignment":{"value":["TextYAlignment","Center"],"type":"EnumItem"},"TextScaled":false,"BackgroundColor3":{"value":[1,1,1],"type":"Color3"}}},{"class":"Frame","children":[{"class":"UIShadow","children":[],"properties":{"Offset":{"value":[0,0,0,0],"type":"UDim2"},"Transparency":0.5,"Name":"UIShadow","BlurRadius":{"value":[0,20],"type":"UDim"},"Color":{"value":[0,0,0],"type":"Color3"},"Archivable":true}},{"class":"UICorner","children":[],"properties":{"Name":"UICorner","Archivable":true,"CornerRadius":{"value":[0,8],"type":"UDim"}}}],"properties":{"Visible":true,"AutomaticSize":{"value":["AutomaticSize","None"],"type":"EnumItem"},"Active":false,"ClipsDescendants":false,"BorderColor3":{"value":[0,0,0],"type":"Color3"},"LayoutOrder":0,"BackgroundColor3":{"value":[0.05882353335618973,0.05882353335618973,0.05882353335618973],"type":"Color3"},"Rotation":0,"AnchorPoint":{"value":[0,0],"type":"Vector2"},"BorderSizePixel":0,"Name":"Frame","Position":{"value":[0.6612843871116638,0,0.10885608941316605,0],"type":"UDim2"},"BackgroundTransparency":0,"ZIndex":1,"Archivable":true,"Size":{"value":[0,224,0,123],"type":"UDim2"}}},{"class":"TextLabel","children":[],"properties":{"LayoutOrder":0,"FontFace":{"value":["rbxasset://fonts/families/JosefinSans.json","Regular","Normal"],"type":"Font"},"LineHeight":1,"Active":false,"TextTransparency":0,"AnchorPoint":{"value":[0,0],"type":"Vector2"},"BorderSizePixel":0,"TextTruncate":{"value":["TextTruncate","None"],"type":"EnumItem"},"Name":"TextLabel","ZIndex":1,"Archivable":true,"Size":{"value":[0,123,0,43],"type":"UDim2"},"TextWrapped":false,"RichText":false,"TextXAlignment":{"value":["TextXAlignment","Center"],"type":"EnumItem"},"ClipsDescendants":false,"BorderColor3":{"value":[0,0,0],"type":"Color3"},"Text":"Example Paragraph","TextSize":15,"TextColor3":{"value":[0.6745098233222961,0.6745098233222961,0.6745098233222961],"type":"Color3"},"Rotation":0,"Visible":true,"BackgroundTransparency":1,"Position":{"value":[0.6815474033355713,0,0.10500000417232514,0],"type":"UDim2"},"AutomaticSize":{"value":["AutomaticSize","None"],"type":"EnumItem"},"TextYAlignment":{"value":["TextYAlignment","Center"],"type":"EnumItem"},"TextScaled":false,"BackgroundColor3":{"value":[1,1,1],"type":"Color3"}}},{"class":"TextLabel","children":[],"properties":{"LayoutOrder":0,"FontFace":{"value":["rbxasset://fonts/families/JosefinSans.json","Regular","Normal"],"type":"Font"},"LineHeight":1,"Active":false,"TextTransparency":0,"AnchorPoint":{"value":[0,0],"type":"Vector2"},"BorderSizePixel":0,"TextTruncate":{"value":["TextTruncate","None"],"type":"EnumItem"},"Name":"TextLabel","ZIndex":1,"Archivable":true,"Size":{"value":[0,123,0,43],"type":"UDim2"},"TextWrapped":false,"RichText":false,"TextXAlignment":{"value":["TextXAlignment","Center"],"type":"EnumItem"},"ClipsDescendants":false,"BorderColor3":{"value":[0,0,0],"type":"Color3"},"Text":"Content Pararaph...","TextSize":15,"TextColor3":{"value":[0.8509804606437683,0.8509804606437683,0.8509804606437683],"type":"Color3"},"Rotation":0,"Visible":true,"BackgroundTransparency":1,"Position":{"value":[0.6815474033355713,0,0.1455904096364975,0],"type":"UDim2"},"AutomaticSize":{"value":["AutomaticSize","None"],"type":"EnumItem"},"TextYAlignment":{"value":["TextYAlignment","Center"],"type":"EnumItem"},"TextScaled":false,"BackgroundColor3":{"value":[1,1,1],"type":"Color3"}}},{"class":"ImageLabel","children":[],"properties":{"LayoutOrder":0,"Active":false,"AnchorPoint":{"value":[0,0],"type":"Vector2"},"Image":"rbxassetid://112658790795028","ZIndex":1,"Archivable":true,"Size":{"value":[0,37,0,33],"type":"UDim2"},"Visible":true,"ScaleType":{"value":["ScaleType","Stretch"],"type":"EnumItem"},"AutomaticSize":{"value":["AutomaticSize","None"],"type":"EnumItem"},"ClipsDescendants":false,"BorderColor3":{"value":[0,0,0],"type":"Color3"},"SliceCenter":{"value":[0,0,0,0],"type":"Rect"},"ImageTransparency":0,"ImageColor3":{"value":[1,1,1],"type":"Color3"},"Rotation":0,"ResampleMode":{"value":["ResamplerMode","Default"],"type":"EnumItem"},"BackgroundTransparency":1,"Position":{"value":[0.024020226672291757,0,0.025830257683992387,0],"type":"UDim2"},"SliceScale":1,"Name":"ImageLabel","BorderSizePixel":0,"BackgroundColor3":{"value":[1,1,1],"type":"Color3"}}},{"class":"ImageLabel","children":[],"properties":{"LayoutOrder":0,"Active":false,"AnchorPoint":{"value":[0,0],"type":"Vector2"},"Image":"rbxassetid://94653344254614","ZIndex":1,"Archivable":true,"Size":{"value":[0,28,0,28],"type":"UDim2"},"Visible":true,"ScaleType":{"value":["ScaleType","Stretch"],"type":"EnumItem"},"AutomaticSize":{"value":["AutomaticSize","None"],"type":"EnumItem"},"ClipsDescendants":false,"BorderColor3":{"value":[0,0,0],"type":"Color3"},"SliceCenter":{"value":[0,0,0,0],"type":"Rect"},"ImageTransparency":0,"ImageColor3":{"value":[0.6235294342041016,0.6235294342041016,0.6235294342041016],"type":"Color3"},"Rotation":0,"ResampleMode":{"value":["ResamplerMode","Default"],"type":"EnumItem"},"BackgroundTransparency":1,"Position":{"value":[0.029077118262648584,0,0.12177121639251709,0],"type":"UDim2"},"SliceScale":1,"Name":"ImageLabel","BorderSizePixel":0,"BackgroundColor3":{"value":[1,1,1],"type":"Color3"}}},{"class":"TextLabel","children":[],"properties":{"LayoutOrder":0,"FontFace":{"value":["rbxasset://fonts/families/JosefinSans.json","Regular","Normal"],"type":"Font"},"LineHeight":1,"Active":false,"TextTransparency":0,"AnchorPoint":{"value":[0,0],"type":"Vector2"},"BorderSizePixel":0,"TextTruncate":{"value":["TextTruncate","None"],"type":"EnumItem"},"Name":"TextLabel","ZIndex":1,"Archivable":true,"Size":{"value":[0,117,0,43],"type":"UDim2"},"TextWrapped":false,"RichText":false,"TextXAlignment":{"value":["TextXAlignment","Center"],"type":"EnumItem"},"ClipsDescendants":false,"BorderColor3":{"value":[0,0,0],"type":"Color3"},"Text":"Example Tab","TextSize":16,"TextColor3":{"value":[0.6745098233222961,0.6745098233222961,0.6745098233222961],"type":"Color3"},"Rotation":0,"Visible":true,"BackgroundTransparency":1,"Position":{"value":[0.06367888301610947,0,0.11553504317998886,0],"type":"UDim2"},"AutomaticSize":{"value":["AutomaticSize","None"],"type":"EnumItem"},"TextYAlignment":{"value":["TextYAlignment","Center"],"type":"EnumItem"},"TextScaled":false,"BackgroundColor3":{"value":[1,1,1],"type":"Color3"}}},{"class":"Frame","children":[{"class":"UIShadow","children":[],"properties":{"Offset":{"value":[0,0,0,0],"type":"UDim2"},"Transparency":0.5,"Name":"UIShadow","BlurRadius":{"value":[0,20],"type":"UDim"},"Color":{"value":[0,0,0],"type":"Color3"},"Archivable":true}},{"class":"UICorner","children":[],"properties":{"Name":"UICorner","Archivable":true,"CornerRadius":{"value":[0,8],"type":"UDim"}}},{"class":"TextLabel","children":[],"properties":{"LayoutOrder":0,"FontFace":{"value":["rbxasset://fonts/families/JosefinSans.json","Regular","Normal"],"type":"Font"},"LineHeight":1,"Active":false,"TextTransparency":0,"AnchorPoint":{"value":[0,0],"type":"Vector2"},"BorderSizePixel":0,"TextTruncate":{"value":["TextTruncate","None"],"type":"EnumItem"},"Name":"TextLabel","ZIndex":1,"Archivable":true,"Size":{"value":[0,117,0,43],"type":"UDim2"},"TextWrapped":false,"RichText":false,"TextXAlignment":{"value":["TextXAlignment","Center"],"type":"EnumItem"},"ClipsDescendants":false,"BorderColor3":{"value":[0,0,0],"type":"Color3"},"Text":"Selected Tab","TextSize":16,"TextColor3":{"value":[0.9058824181556702,0.9058824181556702,0.9058824181556702],"type":"Color3"},"Rotation":0,"Visible":true,"BackgroundTransparency":1,"Position":{"value":[0.19897300004959107,0,-0.01050808560103178,0],"type":"UDim2"},"AutomaticSize":{"value":["AutomaticSize","None"],"type":"EnumItem"},"TextYAlignment":{"value":["TextYAlignment","Center"],"type":"EnumItem"},"TextScaled":false,"BackgroundColor3":{"value":[1,1,1],"type":"Color3"}}}],"properties":{"Visible":true,"AutomaticSize":{"value":["AutomaticSize","None"],"type":"EnumItem"},"Active":false,"ClipsDescendants":false,"BorderColor3":{"value":[0,0,0],"type":"Color3"},"LayoutOrder":0,"BackgroundColor3":{"value":[0.05882353335618973,0.05882353335618973,0.05882353335618973],"type":"Color3"},"Rotation":0,"AnchorPoint":{"value":[0,0],"type":"Vector2"},"BorderSizePixel":0,"Name":"Frame","Position":{"value":[0.015763776376843454,0,0.1947566568851471,0],"type":"UDim2"},"BackgroundTransparency":0,"ZIndex":1,"Archivable":true,"Size":{"value":[0,170,0,38],"type":"UDim2"}}},{"class":"ImageLabel","children":[],"properties":{"LayoutOrder":0,"Active":false,"AnchorPoint":{"value":[0,0],"type":"Vector2"},"Image":"rbxassetid://94653344254614","ZIndex":1,"Archivable":true,"Size":{"value":[0,28,0,28],"type":"UDim2"},"Visible":true,"ScaleType":{"value":["ScaleType","Stretch"],"type":"EnumItem"},"AutomaticSize":{"value":["AutomaticSize","None"],"type":"EnumItem"},"ClipsDescendants":false,"BorderColor3":{"value":[0,0,0],"type":"Color3"},"SliceCenter":{"value":[0,0,0,0],"type":"Rect"},"ImageTransparency":0,"ImageColor3":{"value":[0.8156863451004028,0.8156863451004028,0.8156863451004028],"type":"Color3"},"Rotation":0,"ResampleMode":{"value":["ResamplerMode","Default"],"type":"EnumItem"},"BackgroundTransparency":1,"Position":{"value":[0.0278128944337368,0,0.20295202732086183,0],"type":"UDim2"},"SliceScale":1,"Name":"ImageLabel","BorderSizePixel":0,"BackgroundColor3":{"value":[1,1,1],"type":"Color3"}}},{"class":"Frame","children":[{"class":"UIShadow","children":[],"properties":{"Offset":{"value":[0,0,0,0],"type":"UDim2"},"Transparency":0.5,"Name":"UIShadow","BlurRadius":{"value":[0,20],"type":"UDim"},"Color":{"value":[0,0,0],"type":"Color3"},"Archivable":true}},{"class":"UICorner","children":[],"properties":{"Name":"UICorner","Archivable":true,"CornerRadius":{"value":[0,8],"type":"UDim"}}}],"properties":{"Visible":true,"AutomaticSize":{"value":["AutomaticSize","None"],"type":"EnumItem"},"Active":false,"ClipsDescendants":false,"BorderColor3":{"value":[0,0,0],"type":"Color3"},"LayoutOrder":0,"BackgroundColor3":{"value":[0.05882353335618973,0.05882353335618973,0.05882353335618973],"type":"Color3"},"Rotation":0,"AnchorPoint":{"value":[0,0],"type":"Vector2"},"BorderSizePixel":0,"Name":"Frame","Position":{"value":[0.302245169878006,0,0.6254612803459168,0],"type":"UDim2"},"BackgroundTransparency":0,"ZIndex":1,"Archivable":true,"Size":{"value":[0,223,0,30],"type":"UDim2"}}},{"class":"TextLabel","children":[],"properties":{"LayoutOrder":0,"FontFace":{"value":["rbxasset://fonts/families/JosefinSans.json","Regular","Normal"],"type":"Font"},"LineHeight":1,"Active":false,"TextTransparency":0,"AnchorPoint":{"value":[0,0],"type":"Vector2"},"BorderSizePixel":0,"TextTruncate":{"value":["TextTruncate","None"],"type":"EnumItem"},"Name":"TextLabel","ZIndex":1,"Archivable":true,"Size":{"value":[0,200,0,50],"type":"UDim2"},"TextWrapped":false,"RichText":false,"TextXAlignment":{"value":["TextXAlignment","Center"],"type":"EnumItem"},"ClipsDescendants":false,"BorderColor3":{"value":[0,0,0],"type":"Color3"},"Text":"Example Input...","TextSize":15,"TextColor3":{"value":[0.6745098233222961,0.6745098233222961,0.6745098233222961],"type":"Color3"},"Rotation":0,"Visible":true,"BackgroundTransparency":1,"Position":{"value":[0.254108726978302,0,0.607011079788208,0],"type":"UDim2"},"AutomaticSize":{"value":["AutomaticSize","None"],"type":"EnumItem"},"TextYAlignment":{"value":["TextYAlignment","Center"],"type":"EnumItem"},"TextScaled":false,"BackgroundColor3":{"value":[1,1,1],"type":"Color3"}}}],"properties":{"Visible":true,"AutomaticSize":{"value":["AutomaticSize","None"],"type":"EnumItem"},"Active":false,"ClipsDescendants":false,"BorderColor3":{"value":[0,0,0],"type":"Color3"},"LayoutOrder":0,"BackgroundColor3":{"value":[0.05098039656877518,0.05098039656877518,0.05098039656877518],"type":"Color3"},"Rotation":0,"AnchorPoint":{"value":[0,0],"type":"Vector2"},"BorderSizePixel":0,"Name":"Frame","Position":{"value":[0.1676432192325592,0,0.10147058963775635,0],"type":"UDim2"},"BackgroundTransparency":0,"ZIndex":1,"Archivable":true,"Size":{"value":[0,791,0,542],"type":"UDim2"}}}],"properties":{"Enabled":true,"Name":"ScreenGui","DisplayOrder":0,"ResetOnSpawn":true,"IgnoreGuiInset":false,"Archivable":true,"ZIndexBehavior":{"value":["ZIndexBehavior","Sibling"],"type":"EnumItem"}}}
]==])

local function decode(value)
    if type(value) ~= "table" or not value.type then
        return value
    end
    local data = value.value
    if value.type == "Color3" then
        return Color3.new(data[1], data[2], data[3])
    elseif value.type == "Vector2" then
        return Vector2.new(data[1], data[2])
    elseif value.type == "UDim" then
        return UDim.new(data[1], data[2])
    elseif value.type == "UDim2" then
        return UDim2.new(data[1], data[2], data[3], data[4])
    elseif value.type == "Rect" then
        return Rect.new(data[1], data[2], data[3], data[4])
    elseif value.type == "Font" then
        return Font.new(data[1], (Enum.FontWeight :: any)[data[2]], (Enum.FontStyle :: any)[data[3]])
    elseif value.type == "EnumItem" then
        return Enum[(string.gsub(data[1], "^Enum%.", ""))][data[2]]
    end
    return nil
end

local propertyErrors = {}
local function rebuild(node)
    local object = Instance.new(node.class)
    for name, rawValue in pairs(node.properties) do
        local value = decode(rawValue)
        if value ~= nil then
            local ok, err = pcall(function()
                object[name] = value
            end)
            if not ok then
                table.insert(propertyErrors, node.class .. "." .. name .. ": " .. tostring(err))
            end
        end
    end
    for _, childNode in ipairs(node.children) do
        rebuild(childNode).Parent = object
    end
    return object
end

local gui = rebuild(spec)
local function useRoboto(object)
    if object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then object.FontFace=uiFont end
end
for _,object in ipairs(gui:GetDescendants()) do useRoboto(object) end
STATE.connect(gui.DescendantAdded,useRoboto)
local function fitFixedText(object)
    if not (object:IsA("TextLabel") or object:IsA("TextButton")) or object.Text=="" then return end
    object.FontFace=uiFont
    object.TextTruncate=Enum.TextTruncate.None
    object.TextWrapped=false
    local constraint=object:FindFirstChild("RuntimeTextFit")
    if not constraint then
        constraint=Instance.new("UITextSizeConstraint")
        constraint.Name="RuntimeTextFit"
        constraint.Parent=object
    end
    constraint.MinTextSize=1
    constraint.MaxTextSize=math.max(1,object.TextSize)
    object.TextScaled=true
end
gui.Name = "R1nStudioLive"
gui.ResetOnSpawn = false
gui.DisplayOrder = 1000
local window = gui:FindFirstChildWhichIsA("Frame")
assert(window, "The Studio window is missing")
local originalDesignSize=window.Size
window.Size=UDim2.fromOffset(originalDesignSize.X.Offset-31,originalDesignSize.Y.Offset)

for _,object in ipairs(window:GetChildren()) do
    if object:IsA("TextLabel") and object.Text=="R1nHub." then
        object.Name="RuntimeBrandTitle"
        object.Visible=false
        object.Position=UDim2.fromOffset(56,12)
        object.Size=UDim2.fromOffset(130,33)
        object.RichText=true
        object.Text='R1nHub.<font color="#3A84F5">xyz</font>'
        object.TextSize=19
        object.TextColor3=Color3.fromRGB(235,235,235)
        object.TextXAlignment=Enum.TextXAlignment.Left
        object.TextYAlignment=Enum.TextYAlignment.Center
        fitFixedText(object)
    elseif object:IsA("TextLabel") and object.Text=="xyz" then
        object.Visible=false
    elseif object:IsA("ImageLabel") and object.Position.X.Scale>.02 and object.Position.X.Scale<.027 and object.Position.Y.Scale<.06 then
        object.Name="RuntimeBrandIcon"
        object.AnchorPoint=Vector2.zero
        object.Position=UDim2.fromOffset(12,10)
        object.Size=UDim2.fromOffset(36,36)
        object.ScaleType=Enum.ScaleType.Fit
    end
end
window.AnchorPoint = Vector2.new(0.5, 0.5)
window.Position = UDim2.fromScale(0.5, 0.5)

local scale = Instance.new("UIScale")
scale.Name = "RuntimeScale"
scale.Parent = window
local requestedScale = 1
local function windowViewport()
    local size=gui.AbsoluteSize
    if size.X>0 and size.Y>0 then return size end
    camera=workspace.CurrentCamera
    return camera and camera.ViewportSize or Vector2.new(1280,720)
end
local function maximumScale(viewport)
    return math.max(.01,math.min(1.6,
        (viewport.X-16)/math.max(1,window.Size.X.Offset),
        (viewport.Y-16)/math.max(1,window.Size.Y.Offset)))
end
local clampingWindow=false
local function clampWindow()
    if clampingWindow then return end
    clampingWindow=true
    local viewport=windowViewport()
    local width=window.Size.X.Offset*scale.Scale
    local height=window.Size.Y.Offset*scale.Scale
    local margin=8
    local anchor=window.AnchorPoint
    local minX=margin+width*anchor.X
    local minY=margin+height*anchor.Y
    local maxX=math.max(minX,viewport.X-margin-width*(1-anchor.X))
    local maxY=math.max(minY,viewport.Y-margin-height*(1-anchor.Y))
    local position=window.Position
    local x=math.clamp(position.X.Scale*viewport.X+position.X.Offset,minX,maxX)
    local y=math.clamp(position.Y.Scale*viewport.Y+position.Y.Offset,minY,maxY)
    window.Position=UDim2.fromOffset(x,y)
    clampingWindow=false
end
local function updateScale()
    camera=workspace.CurrentCamera
    scale.Scale=math.min(requestedScale,maximumScale(windowViewport()))
    clampWindow()
end
updateScale()

local dragArea = Instance.new("TextButton")
dragArea.Name = "RuntimeDragArea"
dragArea.Size = UDim2.fromOffset(60, 56)
dragArea.BackgroundTransparency = 1
dragArea.BorderSizePixel = 0
dragArea.AutoButtonColor = false
dragArea.Text = ""
dragArea.ZIndex = 10
dragArea.Parent = window

local resizeGrip = Instance.new("TextButton")
resizeGrip.Name = "RuntimeResizeGrip"
resizeGrip.AnchorPoint = Vector2.new(1, 1)
resizeGrip.Position = UDim2.new(1, 0, 1, 0)
resizeGrip.Size = UDim2.fromOffset(22, 22)
resizeGrip.BackgroundTransparency = 1
resizeGrip.BorderSizePixel = 0
resizeGrip.AutoButtonColor = false
resizeGrip.Text = ""
resizeGrip.ZIndex = 10
resizeGrip.Parent = window

local hiddenMenus = {}
for _, candidate in ipairs(CoreGui:GetChildren()) do
    if candidate:IsA("ScreenGui") and candidate.Enabled then
        local hide = candidate.Name == "R1nStudioTemplate"
        if not hide then
            for _, descendant in ipairs(candidate:GetDescendants()) do
                if descendant:IsA("TextLabel") and descendant.Text:find("32 days left", 1, true) then
                    hide = true
                    break
                end
            end
        end
        if hide then
            candidate.Enabled = false
            table.insert(hiddenMenus, candidate)
        end
    end
end

local parented = pcall(function() gui.Parent = CoreGui end)
if not parented then
    gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
end

local connections = {}
local function connect(signal, callback)
    local connection = signal:Connect(callback)
    table.insert(connections, connection)
end
if camera then
    connect(camera:GetPropertyChangedSignal("ViewportSize"), updateScale)
end
connect(gui:GetPropertyChangedSignal("AbsoluteSize"),updateScale)
connect(window:GetPropertyChangedSignal("Position"),clampWindow)
connect(window:GetPropertyChangedSignal("Size"),updateScale)
connect(scale:GetPropertyChangedSignal("Scale"),clampWindow)
connect(workspace:GetPropertyChangedSignal("CurrentCamera"),function()
    camera=workspace.CurrentCamera
    if camera then connect(camera:GetPropertyChangedSignal("ViewportSize"),updateScale) end
    updateScale()
end)
updateScale()

local gesture
local function beginGesture(mode, input)
    if gesture or (input.UserInputType ~= Enum.UserInputType.MouseButton1
        and input.UserInputType ~= Enum.UserInputType.Touch) then
        return
    end
    updateScale()
    gesture = {
        mode = mode,
        input = input,
        pointer = input.Position,
        position = window.Position,
        scale = scale.Scale,
    }
end
connect(dragArea.InputBegan, function(input) beginGesture("drag", input) end)
connect(resizeGrip.InputBegan, function(input) beginGesture("resize", input) end)
connect(UserInputService.InputChanged, function(input)
    local current = gesture
    if not current then return end
    if current.input.UserInputType == Enum.UserInputType.Touch then
        if input ~= current.input then return end
    elseif input.UserInputType ~= Enum.UserInputType.MouseMovement then
        return
    end

    local delta = input.Position - current.pointer
    local viewport = windowViewport()
    if current.mode == "drag" then
        local x=viewport.X*current.position.X.Scale+current.position.X.Offset+delta.X
        local y=viewport.Y*current.position.Y.Scale+current.position.Y.Offset+delta.Y
        window.Position=UDim2.fromOffset(x,y)
        clampWindow()
        return
    end

    local width = window.Size.X.Offset
    local height = window.Size.Y.Offset
    local change = ((delta.X * width + delta.Y * height)
        / (width * width + height * height)) * 0.5
    local limit = maximumScale(viewport)
    requestedScale = math.clamp(current.scale + change, math.min(0.72, limit), limit)
    scale.Scale = requestedScale
    local widthChange = window.Size.X.Offset * (requestedScale - current.scale)
    local heightChange = window.Size.Y.Offset * (requestedScale - current.scale)
    window.Position = UDim2.new(current.position.X.Scale,
        current.position.X.Offset + widthChange / 2,
        current.position.Y.Scale,
        current.position.Y.Offset + heightChange / 2)
    clampWindow()
end)
connect(UserInputService.InputEnded, function(input)
    if gesture and (input == gesture.input or
        (gesture.input.UserInputType == Enum.UserInputType.MouseButton1
            and input.UserInputType == Enum.UserInputType.MouseButton1)) then
        gesture = nil
    end
end)

local env=((getgenv or getfenv) :: any)()
local accent=Color3.fromRGB(58,132,245)
local dim=Color3.fromRGB(172,172,172)
local bright=Color3.fromRGB(235,235,235)
local changed=Instance.new("BindableEvent")
changed.Name="ComponentChanged"
changed.Parent=gui
local function animate(object,properties,duration)
    local tween=TweenService:Create(object,TweenInfo.new(duration or .18,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),properties)
    tween:Play()
    return tween
end
local function directLabel(value,index)
    local found={}
    for _,child in ipairs(window:GetChildren()) do
        if child:IsA("TextLabel") and child.Text==value then table.insert(found,child) end
    end
    table.sort(found,function(a,b) return a.Position.Y.Scale<b.Position.Y.Scale end)
    return found[index or 1]
end
local function frameAt(parent,x,y)
    for _,child in ipairs(parent:GetChildren()) do
        if child:IsA("Frame") and math.abs(child.Position.X.Scale-x)<.001 and math.abs(child.Position.Y.Scale-y)<.001 then return child end
    end
    return nil
end
local function hit(name,position,size,parent)
    local button=Instance.new("TextButton")
    button.Name=name; button.Position=position; button.Size=size
    button.BackgroundTransparency=1; button.Text=""; button.AutoButtonColor=false
    button.ZIndex=5; button.Parent=parent or window
    return button
end
local function report(id,value)
    gui:SetAttribute(id,type(value)=="table" and HttpService:JSONEncode(value) or value)
    changed:Fire(id,value)
end
local baseConfig={
    Tabs={
        {Id="Example",Name="Example Tab",Icon="rbxassetid://94653344254614",Show={"Top","Right"}},
        {Id="Selected",Name="Selected Tab",Icon="rbxassetid://94653344254614",Show={"Top","Middle","Right"}},
        {Id="Extras",Name="Extras",Icon="rbxassetid://81973586053257",Show={"Middle","Right"}},
        {Id="Settings",Name="Settings",Icon="rbxassetid://80758916183665",Show={"Top","Middle"}},
    },
    Sections={
        Left={Name="Section"},
        Right={Name="Section"},
    },
    Components={
        Toggle1={Type="Toggle",Name="Example Toggle",Default=false},
        Toggle2={Type="Toggle",Name="Example Toggle",Default=false},
        Toggle3={Type="Toggle",Name="Example Toggle",Default=false},
        Dropdown={Type="Dropdown",Name="Select Option...",Options={"Option 1","Option 2","Option 3"},Default="Option 1"},
        Slider={Type="Slider",Name="Example Slider",Min=0,Max=100,Step=1,Default=100},
        Button={Type="Button",Name="Button",Text="Button"},
        Textbox={Type="Input",Name="Example Input...",Placeholder="Example Input...",Default=""},
        Paragraph={Type="Paragraph",Name="Example Paragraph",Description="Content Pararaph..."},
    },
}
local config=baseConfig
if type(config)~="table" or type(config.Components)~="table" then config=baseConfig end
if type(config.Tabs)~="table" then config.Tabs={} end
for _,defaultTab in ipairs(baseConfig.Tabs) do
    local found=false
    for _,tab in ipairs(config.Tabs) do if tab.Id==defaultTab.Id then found=true; if tab.Show==nil then tab.Show=table.clone(defaultTab.Show) end; break end end
    if not found then table.insert(config.Tabs,defaultTab) end
end
env.R1nUIConfig=config
local setters={}
local values={}
local paragraph=directLabel("Content Pararaph...")
local paragraphCard=frameAt(window,.63610685,.04428044)
local paragraphInner=frameAt(window,.66128439,.10885609)
local paragraphTitle=directLabel("Example Paragraph")
local function fitParagraph()
    if not paragraph or not paragraphCard then return end
    local h=window.Size.Y.Offset
    local paragraphTop=paragraph.Position.Y.Scale*h+paragraph.Position.Y.Offset
    local innerTop=paragraphInner and paragraphInner.Position.Y.Scale*h or 0
    local cardTop=paragraphCard.Position.Y.Scale*h
    local innerHeight=math.max(123,math.ceil(paragraphTop-innerTop+paragraph.TextBounds.Y+16))
    if paragraphInner then paragraphInner.Size=UDim2.fromOffset(224,innerHeight) end
    paragraphCard.Size=UDim2.fromOffset(263,math.max(494,math.ceil(innerTop-cardTop+innerHeight+12)))
end
if paragraph and paragraphCard then
    paragraph.Position=UDim2.new(paragraphCard.Position.X.Scale,36,paragraphCard.Position.Y.Scale,75)
    paragraph.Size=UDim2.fromOffset(195,24)
    paragraph.AutomaticSize=Enum.AutomaticSize.Y
    paragraph.TextWrapped=true
    paragraph.TextXAlignment=Enum.TextXAlignment.Left
    paragraph.TextYAlignment=Enum.TextYAlignment.Top
    if paragraphTitle then
        paragraphTitle.Position=UDim2.new(paragraphCard.Position.X.Scale,36,paragraphTitle.Position.Y.Scale,0)
        paragraphTitle.Size=UDim2.fromOffset(195,paragraphTitle.Size.Y.Offset)
        paragraphTitle.TextXAlignment=Enum.TextXAlignment.Left
    end
    connect(paragraph:GetPropertyChangedSignal("TextBounds"),fitParagraph)
    connect(window:GetPropertyChangedSignal("Size"),fitParagraph)
    fitParagraph()
end
local topCard=frameAt(window,.27696079,.04243542)
local toggleLabels={}
if topCard then
    for index,y in ipairs({.28289473,.5,.69736844}) do
        local indicator=frameAt(topCard,.08365019,y)
        local label=directLabel("Example Toggle",index)
        if indicator and label then
            toggleLabels[index]=label
            local check=Instance.new("CanvasGroup")
            check.Name="RuntimeToggleCheck"..index
            check.AnchorPoint=Vector2.new(.5,.5)
            check.Position=UDim2.fromScale(.5,.5)
            check.Size=UDim2.fromOffset(16,16)
            check.BackgroundTransparency=1
            check.GroupTransparency=1
            check.ZIndex=indicator.ZIndex+1
            check.Parent=indicator
            local iconScale=Instance.new("UIScale")
            iconScale.Scale=.65; iconScale.Parent=check
            for _,shape in ipairs({{"Short",4,10,7,4,45},{"Long",9,8,13,4,-45}}) do
                local segment=Instance.new("Frame")
                segment.Name=shape[1]
                segment.AnchorPoint=Vector2.new(.5,.5)
                segment.Position=UDim2.fromOffset(shape[2],shape[3])
                segment.Size=UDim2.fromOffset(shape[4],shape[5])
                segment.Rotation=shape[6]
                segment.BackgroundColor3=Color3.new(0,0,0)
                segment.BorderSizePixel=0
                segment.ZIndex=check.ZIndex+1
                segment.Parent=check
                local corner=Instance.new("UICorner")
                corner.CornerRadius=UDim.new(1,0)
                corner.Parent=segment
            end
            local button=hit("RuntimeToggle"..index,indicator.Position,indicator.Size,topCard)
            local id="Toggle"..index
            setters[id]=function(value)
                value=value==true
                values[id]=value
                animate(indicator,{BackgroundColor3=value and accent or Color3.new(0,0,0)})
                animate(check,{GroupTransparency=value and 0 or 1},.13)
                if value then iconScale.Scale=.55 end
                animate(iconScale,{Scale=value and 1 or .65},.2)
                label.TextColor3=dim
                report(id,value)
                return true
            end
            connect(button.Activated,function() setters[id](not values[id]) end)
        end
    end
end
local dropdownFrame=frameAt(window,.30224517,.42435426)
local dropdownText=directLabel("Select Option...")
local dropdownMenu
local setDropdownOptions
local dropdownOptions={}
local dropdownOpen=false
if dropdownFrame and dropdownText then
    dropdownText.Position=UDim2.new(dropdownFrame.Position.X.Scale,12,dropdownFrame.Position.Y.Scale,-10)
    dropdownText.Size=UDim2.fromOffset(180,50)
    dropdownText.TextXAlignment=Enum.TextXAlignment.Left
    dropdownMenu=Instance.new("Frame")
    dropdownMenu.Name="RuntimeDropdownMenu"
    dropdownMenu.Position=UDim2.new(dropdownFrame.Position.X.Scale,0,dropdownFrame.Position.Y.Scale,32)
    dropdownMenu.Size=UDim2.fromOffset(223,0)
    dropdownMenu.BackgroundColor3=Color3.fromRGB(21,21,23)
    dropdownMenu.BorderSizePixel=0
    dropdownMenu.ClipsDescendants=true
    dropdownMenu.Visible=false
    dropdownMenu.ZIndex=8
    dropdownMenu.Parent=window
    local corner=Instance.new("UICorner")
    corner.CornerRadius=UDim.new(0,6); corner.Parent=dropdownMenu
    local function setOpen(open)
        dropdownOpen=open
        dropdownMenu.Visible=open
        dropdownMenu.Size=UDim2.fromOffset(223,open and #dropdownOptions*29+4 or 0)
    end
    local function setOptions(options)
        for _,child in ipairs(dropdownMenu:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
        table.clear(dropdownOptions)
        for index,option in ipairs(type(options)=="table" and options or {}) do
            option=tostring(option)
            table.insert(dropdownOptions,option)
            local item=Instance.new("TextButton")
            item.Name="RuntimeOption"..index
            item.Position=UDim2.fromOffset(4,(index-1)*29+2)
            item.Size=UDim2.new(1,-8,0,28)
            item.BackgroundTransparency=1
            item.Text="  "..option
            item.TextXAlignment=Enum.TextXAlignment.Left
            item.TextColor3=bright
            item.TextSize=15
            item.FontFace=dropdownText.FontFace
            item.ZIndex=9
            item.Parent=dropdownMenu
            connect(item.Activated,function() setters.Dropdown(option); setOpen(false) end)
        end
        setOpen(false)
    end
    setters.Dropdown=function(value)
        if not table.find(dropdownOptions,value) then return false end
        values.Dropdown=value
        dropdownText.Text=value
        report("Dropdown",value)
        return true
    end
    local opener=hit("RuntimeDropdown",dropdownFrame.Position,dropdownFrame.Size,window)
    connect(opener.Activated,function() setOpen(not dropdownOpen) end)
    setDropdownOptions=setOptions
end
local middleCard=frameAt(window,.27696079,.35055351)
local sliderTrack=middleCard and frameAt(middleCard,.57794607,.25914633)
local sliderValue=directLabel("100")
local sliderLabel=directLabel("Example Slider")
local sliderMin,sliderMax,sliderStep=0,100,1
if middleCard then middleCard.Size=UDim2.fromOffset(263,328) end
if sliderTrack and sliderValue then
    sliderTrack.Position=UDim2.fromOffset(152,85)
    sliderValue.Visible=false
    local number=Instance.new("TextBox")
    number.Name="RuntimeSliderValue"
    number.Position=sliderValue.Position; number.Size=sliderValue.Size
    number.BackgroundTransparency=1; number.BorderSizePixel=0
    number.FontFace=sliderValue.FontFace; number.TextSize=sliderValue.TextSize
    number.TextColor3=bright; number.TextXAlignment=Enum.TextXAlignment.Center
    number.ClearTextOnFocus=false; number.ZIndex=5; number.Parent=window
    local fill=Instance.new("Frame")
    fill.Name="RuntimeSliderFill"; fill.BackgroundColor3=accent
    fill.BorderSizePixel=0; fill.Parent=sliderTrack
    local corner=Instance.new("UICorner")
    corner.CornerRadius=UDim.new(0,7); corner.Parent=fill
    setters.Slider=function(value)
        value=tonumber(value)
        if not value then return false end
        value=math.clamp(sliderMin+math.floor((value-sliderMin)/sliderStep+.5)*sliderStep,sliderMin,sliderMax)
        values.Slider=value
        fill.Size=UDim2.fromScale(sliderMax>sliderMin and (value-sliderMin)/(sliderMax-sliderMin) or 0,1)
        number.Text=string.format("%g",value)
        report("Slider",value)
        return true
    end
    local sliderHit=hit("RuntimeSlider",sliderTrack.Position,sliderTrack.Size,middleCard)
    local dragging=false
    local function fromX(x)
        local ratio=math.clamp((x-sliderTrack.AbsolutePosition.X)/math.max(sliderTrack.AbsoluteSize.X,1),0,1)
        setters.Slider(sliderMin+(sliderMax-sliderMin)*ratio)
    end
    connect(sliderHit.InputBegan,function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=true; fromX(input.Position.X) end
    end)
    connect(UserInputService.InputChanged,function(input)
        if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then fromX(input.Position.X) end
    end)
    connect(UserInputService.InputEnded,function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=false end
    end)
    connect(number.FocusLost,function() if not setters.Slider(number.Text) then number.Text=tostring(values.Slider) end end)
end
local actionFrame=frameAt(window,.30224517,.55719554)
local actionLabel=directLabel("Button")
if actionFrame then
    local actionHit=hit("RuntimeButton",actionFrame.Position,actionFrame.Size,window)
    local normal=actionFrame.BackgroundColor3
    connect(actionHit.Activated,function()
        values.Button=(values.Button or 0)+1
        report("ButtonPresses",values.Button)
        animate(actionFrame,{BackgroundColor3=Color3.fromRGB(32,34,40)},.1)
        task.delay(.14,function() if actionFrame.Parent then animate(actionFrame,{BackgroundColor3=normal},.2) end end)
    end)
end
local inputFrame=frameAt(window,.30224517,.62546128)
local inputLabel=directLabel("Example Input...")
local input
if inputFrame and inputLabel then
    inputLabel.Visible=false
    inputFrame.ClipsDescendants=true
    input=Instance.new("TextBox")
    input.Name="RuntimeTextbox"
    input.Position=UDim2.new(inputFrame.Position.X.Scale,8,inputFrame.Position.Y.Scale,6)
    input.Size=UDim2.fromOffset(207,18)
    input.BackgroundTransparency=1; input.BorderSizePixel=0
    input.ClearTextOnFocus=false; input.FontFace=inputLabel.FontFace
    input.TextSize=inputLabel.TextSize; input.TextColor3=bright
    input.PlaceholderColor3=dim; input.PlaceholderText="Example Input..."
    input.TextXAlignment=Enum.TextXAlignment.Left
    input.TextYAlignment=Enum.TextYAlignment.Top
    input.TextWrapped=true; input.MultiLine=true
    input.TextTruncate=Enum.TextTruncate.None
    input.ZIndex=5; input.Parent=window
    local textService=game:GetService("TextService")
    local revision=0
    local function fit()
        if not middleCard then return end
        revision+=1
        local token=revision
        local params=Instance.new("GetTextBoundsParams")
        params.Text=input.Text~="" and input.Text or "A"
        params.Font=input.FontFace; params.Size=input.TextSize; params.Width=input:GetAttribute("AvailableWidth") or 207
        local ok,bounds=pcall(function() return textService:GetTextBoundsAsync(params) end)
        params:Destroy()
        if token~=revision or not input.Parent then return end
        local fieldHeight=math.max(30,math.ceil((ok and bounds.Y or input.TextBounds.Y)+12))
        inputFrame.Size=UDim2.fromOffset(223,fieldHeight)
        input.Size=UDim2.fromOffset(207,fieldHeight-12)
        local h=window.Size.Y.Offset
        middleCard.Size=UDim2.fromOffset(263,math.max(328,math.ceil(inputFrame.Position.Y.Scale*h+fieldHeight-middleCard.Position.Y.Scale*h+18)))
    end
    setters.Textbox=function(value)
        input.Text=tostring(value or "")
        values.Textbox=input.Text
        report("Textbox",input.Text)
        task.spawn(fit)
        return true
    end
    connect(input:GetPropertyChangedSignal("Text"),function() values.Textbox=input.Text; report("Textbox",input.Text); task.spawn(fit) end)
    connect(window:GetPropertyChangedSignal("Size"),function() task.spawn(fit) end)
    task.spawn(fit)
end
local exampleTab=directLabel("Example Tab")
local selectedFrame=frameAt(window,.01576378,.19475666)
local selectedTab=selectedFrame and selectedFrame:FindFirstChildWhichIsA("TextLabel")
local exampleIcon,selectedIcon,rightSectionTitle
for _,child in ipairs(window:GetChildren()) do
    if child:IsA("ImageLabel") and math.abs(child.Position.X.Scale-.02907712)<.001 then exampleIcon=child
    elseif child:IsA("ImageLabel") and math.abs(child.Position.X.Scale-.02781289)<.001 then selectedIcon=child
    elseif child:IsA("TextLabel") and child.Text=="Section" and child.Position.X.Scale>.5 then rightSectionTitle=child end
end
local tabEntries={}
local tabVisualScale=1.15
local selectedIconColor=Color3.fromRGB(91,143,255)
local function setTabIconGlow(entry,active)
    for _,tween in ipairs(entry.GlowTweens or {}) do tween:Cancel() end
    entry.GlowTweens={}
    if entry.Icon then entry.Icon.ImageColor3=active and bright or dim end
    if entry.Halo then
        entry.Halo.ImageTransparency=1
        for _,child in ipairs(entry.Halo:GetChildren()) do child:Destroy() end
    end
end
STATE.onCleanup(function()
    for _,entry in pairs(tabEntries) do
        for _,tween in ipairs(entry.GlowTweens or {}) do tween:Cancel() end
    end
end)
local tabSelectionBox,tabSelectionTween
local function moveTabSelection(entry)
    local target=entry.Background
    if tabSelectionBox then tabSelectionBox.Visible=true end
    if not tabSelectionBox then
        local rail
        for _,child in ipairs(window:GetChildren()) do
            if child:IsA("Frame") and child.Position==UDim2.fromOffset(0,0) and (child.Size.X.Offset==198 or child.Name=="RuntimeSidebar") then
                child.Name="RuntimeSidebar"
                child.Size=UDim2.new(0,60,child.Size.Y.Scale,child.Size.Y.Offset)
                rail=child; break
            end
        end
        tabSelectionBox=Instance.new("Frame")
        tabSelectionBox.Name="MovingTabSelection"
        tabSelectionBox.BackgroundColor3=Color3.fromRGB(18,18,18)
        tabSelectionBox.BorderSizePixel=0
        tabSelectionBox.ZIndex=1
        tabSelectionBox.Position=target.Position
        tabSelectionBox.Size=target.Size
        local selectionScale=Instance.new("UIScale")
        selectionScale.Name="TabVisualScale"
        selectionScale.Scale=tabVisualScale
        selectionScale.Parent=tabSelectionBox
        local corner=Instance.new("UICorner")
        corner.CornerRadius=UDim.new(0,8)
        corner.Parent=tabSelectionBox
        tabSelectionBox.Parent=rail or window
        return
    end
    if tabSelectionTween then tabSelectionTween:Cancel() end
    local distance=math.abs(target.Position.Y.Offset-tabSelectionBox.Position.Y.Offset)
    if distance<.1 and tabSelectionBox.Size==target.Size then
        tabSelectionBox.Position=target.Position
        return
    end
    local duration=math.clamp(.2+distance/1000,.2,.38)
    tabSelectionTween=TweenService:Create(tabSelectionBox,TweenInfo.new(duration,Enum.EasingStyle.Quart,Enum.EasingDirection.InOut),{
        Position=target.Position,Size=target.Size,
    })
    tabSelectionTween:Play()
end
STATE.onCleanup(function() if tabSelectionTween then tabSelectionTween:Cancel() end end)
local contentGroups={Top={},Middle={},Right={}}
for _,child in ipairs(window:GetChildren()) do
    if child:IsA("GuiObject") and child~=dragArea and child~=resizeGrip then
        local x,y=child.Position.X.Scale,child.Position.Y.Scale
        if child==rightSectionTitle then
            table.insert(contentGroups.Right,child)
        elseif x>.2 and x<.63 then
            table.insert(y<.35 and contentGroups.Top or contentGroups.Middle,child)
        elseif x>=.63 or child==rightSectionTitle then
            table.insert(contentGroups.Right,child)
        end
    end
end

local filledPages={}
local filledConnections={}
local filledHost
local filledDrag
local filledKeys={}
local filledPopup
local filledSetters={}
local function filledConnect(signal,fn)
    local c=signal:Connect(fn)
    table.insert(filledConnections,c)
end
local function closeFilledPopup()
    if filledPopup then
        local previous=filledPopup
        filledPopup=nil
        if previous.Card.Parent then previous.Card.ZIndex=1 end
        if previous.DestroyOnClose then previous.Menu:Destroy() else previous.Menu.Visible=false end
    end
end
local function copyConfig(kind,overrides)
    local result=table.clone(config.Components[kind] or {})
    for key,value in pairs(overrides or {}) do result[key]=value end
    return result
end
local function sourcePosition(object)
    return Vector2.new(object.Position.X.Scale*originalDesignSize.X.Offset+object.Position.X.Offset,
        object.Position.Y.Scale*originalDesignSize.Y.Offset+object.Position.Y.Offset)
end
local function cloneStudioGroup(group,parent)
    local source=group=="Top" and topCard or group=="Middle" and middleCard or paragraphCard
    local origin=sourcePosition(source)
    local card=source:Clone()
    card.Name="Original"..group.."Section"
    card.Position=UDim2.fromOffset(0,0)
    card.Visible=true
    card.Parent=parent
    for _,object in ipairs(contentGroups[group]) do
        if object~=source and object~=inputLabel and object~=sliderValue and object~=dropdownMenu then
            local clone=object:Clone()
            local point=sourcePosition(object)-origin
            clone.Position=UDim2.fromOffset(point.X,point.Y)
            clone.Visible=true
            clone.Parent=card
        end
    end
    return card
end
local function bindStudioGroup(card,group,prefix,settings)
    local function register(name,set)
        local id=prefix.."."..name
        filledSetters[id]=set
        setters[id]=set
        return function(value) values[id]=value; changed:Fire(id,value) end,id
    end
    if group=="Top" then
        local labels={}
        for _,child in ipairs(card:GetChildren()) do
            if child:IsA("TextLabel") and child.Text~="Section" and child.Size.X.Offset==123 then table.insert(labels,child) end
        end
        table.sort(labels,function(a,b) return a.Position.Y.Offset<b.Position.Y.Offset end)
        for index=1,3 do
            local name="Toggle"..index
            local spec=copyConfig(name,settings and settings[name])
            local button=card:FindFirstChild("RuntimeToggle"..index)
            if button and (not settings or not settings.__Only or settings.__Only==name) then
                local indicator
                for _,child in ipairs(card:GetChildren()) do
                    if child:IsA("Frame") and child.Position==button.Position and child.Size==button.Size then indicator=child; break end
                end
                if indicator then
                    local check=indicator:FindFirstChild("RuntimeToggleCheck"..index)
                    local enabled=spec.Default==true
                    local publish
                    local function set(value)
                        enabled=value==true
                        if indicator:GetAttribute("SwitchBuilt") then
                            indicator:SetAttribute("Enabled",enabled)
                        else
                            indicator.BackgroundColor3=enabled and accent or Color3.new(0,0,0)
                            if check then check.GroupTransparency=enabled and 0 or 1; local sc=check:FindFirstChildWhichIsA("UIScale"); if sc then sc.Scale=enabled and 1 or .65 end end
                        end
                        if labels[index] then labels[index].TextColor3=dim end
                        if publish then publish(enabled) end
                        return true
                    end
                    local id
                    publish,id=register(name,set)
                    if labels[index] then labels[index].Text=spec.Name or "Example Toggle" end
                    filledConnect(button.Activated,function() set(not enabled) end)
                    set(values[id]==nil and enabled or values[id])
                end
            end
        end
    elseif group=="Middle" then
        local slider=copyConfig("Slider",settings and settings.Slider)
        local fill=card:FindFirstChild("RuntimeSliderFill",true)
        local sliderHit=card:FindFirstChild("RuntimeSlider",true)
        local number=card:FindFirstChild("RuntimeSliderValue",true)
        local minimum=tonumber(slider.Min) or 0
        local maximum=math.max(minimum,tonumber(slider.Max) or 100)
        local step=math.max(.000001,tonumber(slider.Step) or 1)
        if fill and sliderHit and number and (not settings.__Only or settings.__Only=="Slider") then
            fill.BackgroundColor3=Color3.new(1,1,1)
            local sliderGradient=fill:FindFirstChild("ActiveToggleGradient")
            if not sliderGradient then
                sliderGradient=Instance.new("UIGradient")
                sliderGradient.Name="ActiveToggleGradient"
                sliderGradient.Parent=fill
            end
            sliderGradient.Color=ColorSequence.new(Color3.fromRGB(111,132,199),Color3.fromRGB(65,84,139))
            local publish,current
            local function set(value)
                value=tonumber(value)
                if not value or value~=value then return false end
                current=math.clamp(minimum+math.floor((value-minimum)/step+.5)*step,minimum,maximum)
                fill.Size=UDim2.fromScale(maximum>minimum and (current-minimum)/(maximum-minimum) or 0,1)
                number.Text=string.format("%g",current)
                if publish then publish(current) end
                return true
            end
            local id
            publish,id=register("Slider",set)
            set(values[id] or slider.Default or minimum)
            local track=fill.Parent
            local function pointer(x)
                set(minimum+(maximum-minimum)*math.clamp((x-track.AbsolutePosition.X)/math.max(1,track.AbsoluteSize.X),0,1))
            end
            filledConnect(sliderHit.InputBegan,function(input)
                if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
                    local scroll=card:FindFirstAncestorWhichIsA("ScrollingFrame")
                    filledDrag={Input=input,Pointer=pointer,Scroll=scroll,Scrolling=scroll and scroll.ScrollingEnabled}
                    if scroll then scroll.ScrollingEnabled=false end
                    pointer(input.Position.X)
                end
            end)
            filledConnect(number.FocusLost,function() if not set(number.Text) then number.Text=tostring(current) end end)
        end
        local button=card:FindFirstChild("RuntimeButton",true)
        if button and (not settings.__Only or settings.__Only=="Button") then
            local count=0
            local publish=register("Button",function(value) count=tonumber(value) or 0; return true end)
            filledConnect(button.Activated,function() count+=1; publish(count) end)
        end
        local input=card:FindFirstChild("RuntimeTextbox",true)
        local textSpec=copyConfig("Textbox",settings and settings.Textbox)
        if input and (not settings.__Only or settings.__Only=="Textbox") then
            local inputBackground
            for _,child in ipairs(card:GetChildren()) do
                if child:IsA("Frame") and child.Size.X.Offset==223 and math.abs(child.Position.Y.Offset-input.Position.Y.Offset+6)<1 then inputBackground=child; break end
            end
            input.PlaceholderText=textSpec.Placeholder or textSpec.Name or "Example Input..."
            local revision=0
            local baseHeight=settings.__Only=="Textbox" and 30 or card.Size.Y.Offset
            local function fit()
                revision+=1
                local token=revision
                local params=Instance.new("GetTextBoundsParams")
                params.Text=input.Text~="" and input.Text or "A"
                params.Font=input.FontFace; params.Size=input.TextSize; params.Width=input:GetAttribute("AvailableWidth") or 207
                local ok,bounds=pcall(function() return (game:GetService("TextService") :: any):GetTextBoundsAsync(params) end)
                params:Destroy()
                if token~=revision or not input.Parent then return end
                local height=math.max(18,math.ceil(ok and bounds.Y or input.TextBounds.Y))
                input.Size=UDim2.fromOffset(input:GetAttribute("AvailableWidth") or 207,height)
                if inputBackground then inputBackground.Size=UDim2.fromOffset((input:GetAttribute("AvailableWidth") or 207)+16,height+12) end
                card.Size=UDim2.fromOffset(card:GetAttribute("AvailableWidth") or 263,math.max(baseHeight,input.Position.Y.Offset+height+20))
            end
            local publish
            local function set(value) input.Text=tostring(value or ""); if publish then publish(input.Text) end; task.spawn(fit); return true end
            local id
            publish,id=register("Textbox",set)
            filledConnect(input:GetPropertyChangedSignal("Text"),function() publish(input.Text); task.spawn(fit) end)
            set(values[id] or textSpec.Default or "")
        end
        local dropSpec=copyConfig("Dropdown",settings and settings.Dropdown)
        local opener=card:FindFirstChild("RuntimeDropdown",true)
        local text
        for _,child in ipairs(card:GetChildren()) do
            if child:IsA("TextLabel") and child.Size.X.Offset==180 then text=child
            elseif child:IsA("TextLabel") and child.Text==(config.Components.Slider.Name or "Example Slider") then child.Text=slider.Name or child.Text end
        end
        if opener and text and (not settings.__Only or settings.__Only=="Dropdown") then
            local menu=Instance.new("ScrollingFrame")
            menu.Name="OriginalDropdownOptions"
            menu.BackgroundColor3=dropdownMenu.BackgroundColor3
            menu.BorderSizePixel=0
            menu.ScrollBarThickness=0
            menu.ClipsDescendants=true
            menu.ZIndex=85
            for _,decoration in ipairs(dropdownMenu:GetChildren()) do if not decoration:IsA("GuiObject") then decoration:Clone().Parent=menu end end
            menu.Position=UDim2.new(opener.Position.X.Scale,opener.Position.X.Offset,opener.Position.Y.Scale,opener.Position.Y.Offset+32)
            menu.Visible=false; menu.Parent=card
            local options={}
            local seen={}
            for _,option in ipairs(dropSpec.Options or {}) do
                option=tostring(option)
                if not seen[option] then seen[option]=true; table.insert(options,option) end
            end
            local multi=dropSpec.Type=="MultiDropdown" or dropSpec.Multi==true
            local publish
            local selected={}
            local buttons={}
            local function draw()
                for index,option in ipairs(options) do
                    local item=buttons[index]
                    if item then
                        local chosen=table.find(selected,option)~=nil
                        item.Text=(chosen and "  ? " or "  ")..option
                        item.TextColor3=chosen and Color3.fromRGB(150,173,233) or bright
                        item:SetAttribute("Selected",chosen)
                    end
                end
            end
            local function set(value)
                if multi then
                    if type(value)~="table" then return false end
                    local nextSelection={}
                    for _,option in ipairs(value) do
                        if not table.find(options,option) then return false end
                        if not table.find(nextSelection,option) then table.insert(nextSelection,option) end
                    end
                    selected=nextSelection
                    text.Text=#selected>0 and table.concat(selected,", ") or dropSpec.Placeholder or dropSpec.Name or "Select..."
                    if type(publish)=="function" then publish(table.clone(selected)) end
                else
                    if not table.find(options,value) then return false end
                    selected={value}; text.Text=tostring(value)
                    if type(publish)=="function" then publish(value) end
                end
                draw()
                return true
            end
            local id
            publish,id=register("Dropdown",set)
            text.Text=dropSpec.Placeholder or dropSpec.Name or "Select..."
            local initial=values[id]
            if initial==nil then initial=dropSpec.Default end
            if multi then
                local valid={}
                for _,option in ipairs(type(initial)=="table" and initial or {}) do if table.find(options,option) then table.insert(valid,option) end end
                set(valid)
            elseif not set(initial) then values[id]=nil end
            menu.Size=UDim2.fromOffset(223,math.min(#options*29+4,178))
            menu.CanvasSize=UDim2.fromOffset(0,#options*29+4)
            for index,option in ipairs(options) do
                local item=Instance.new("TextButton")
                item.Name="Option"..index
                item.Position=UDim2.fromOffset(4,(index-1)*29+2)
                item.Size=UDim2.new(1,-8,0,28)
                item.BackgroundTransparency=1; item.Text="  "..option
                item.FontFace=text.FontFace; item.TextSize=15; item.TextColor3=bright
                item.TextXAlignment=Enum.TextXAlignment.Left; item.ZIndex=86
                item.Parent=menu; buttons[index]=item
                fitFixedText(item)
                filledConnect(item.Activated,function()
                    if multi then
                        local nextSelection=table.clone(selected)
                        local at=table.find(nextSelection,option)
                        if at then table.remove(nextSelection,at) else table.insert(nextSelection,option) end
                        set(nextSelection)
                    else set(option); closeFilledPopup() end
                end)
            end
            draw()
            local function placeMenu()
                local factor=math.max(scale.Scale,.001)
                local point=(opener.AbsolutePosition-window.AbsolutePosition)/factor
                local width=opener.AbsoluteSize.X/factor
                local height=math.min(#options*29+4,178,window.Size.Y.Offset-16)
                local y=point.Y+opener.AbsoluteSize.Y/factor+4
                if y+height>window.Size.Y.Offset-8 then y=point.Y-height-4 end
                menu.Size=UDim2.fromOffset(width,height)
                menu.Position=UDim2.fromOffset(math.clamp(point.X,8,math.max(8,window.Size.X.Offset-width-8)),math.clamp(y,8,math.max(8,window.Size.Y.Offset-height-8)))
            end
            filledConnect(opener.Activated,function()
                local open=not menu.Visible
                closeFilledPopup()
                if open then
                    menu.Parent=window; placeMenu(); menu.Visible=true
                    filledPopup={Menu=menu,Card=card,OwnerButton=opener}
                end
            end)
            filledConnect(game:GetService("RunService").RenderStepped,function() if menu.Parent==window and menu.Visible then placeMenu() end end)
            filledConnect(card.Destroying,function() if menu.Parent==window then menu:Destroy() end end)
        end
    end
end
connect(UserInputService.InputBegan,function(input)
    if not filledPopup or filledPopup.DestroyOnClose then return end
    if input.KeyCode==Enum.KeyCode.Escape then closeFilledPopup(); return end
    if input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch then return end
    local function inside(object)
        if not object then return false end
        local p,s=object.AbsolutePosition,object.AbsoluteSize
        return input.Position.X>=p.X and input.Position.X<=p.X+s.X and input.Position.Y>=p.Y and input.Position.Y<=p.Y+s.Y
    end
    if not inside(filledPopup.Menu) and not inside(filledPopup.OwnerButton) then closeFilledPopup() end
end)
local pickerDrag
local colorSetters={}
local function attachColorPicker(row,props,prefix,componentName)
    local swatch
    for _,child in ipairs(row:GetChildren()) do
        if child:IsA("Frame") and (child:GetAttribute("ColorSwatch") or child.Position.X.Offset==62 and child.Size.X.Offset==24) then swatch=child; break end
    end
    if not swatch then return end
    local id=prefix.."."..componentName..".Color"
    local color=typeof(values[id])=="Color3" and values[id] or typeof(props.Color)=="Color3" and props.Color or swatch.BackgroundColor3
    local h,s,v=color:ToHSV()
    local panel,area,shadeCursor,hueCursor,hex
    local function setColor(value)
        if typeof(value)~="Color3" then return false end
        color=value
        h,s,v=color:ToHSV()
        values[id]=color
        swatch.BackgroundColor3=color
        if panel and panel.Parent then
            area.BackgroundColor3=Color3.fromHSV(h,1,1)
            shadeCursor.Position=UDim2.fromScale(s,1-v)
            hueCursor.Position=UDim2.new(.5,0,h,0)
            hex.Text="#"..color:ToHex():upper()
        end
        changed:Fire(id,color)
        if type(props.ColorCallback)=="function" then props.ColorCallback(color) end
        return true
    end
    colorSetters[id]=setColor
    swatch.BackgroundColor3=color
    values[id]=color
    local button=Instance.new("TextButton")
    button.Name="ColorPickerButton"
    button.Text=""; button.BackgroundTransparency=1
    button.AutoButtonColor=false
    button.Position=swatch.Position; button.Size=swatch.Size
    button.ZIndex=6; button.Parent=row
    local function make(className,properties,parent)
        local object=Instance.new(className)
        for key,value in pairs(properties) do object[key]=value end
        object.Parent=parent
        return object
    end
    local function place()
        local factor=math.max(scale.Scale,.001)
        local position=(swatch.AbsolutePosition-window.AbsolutePosition)/factor
        local size=swatch.AbsoluteSize/factor
        local x=position.X+size.X+9
        if x+194>window.Size.X.Offset-8 then x=position.X-203 end
        panel.Position=UDim2.fromOffset(math.clamp(x,8,math.max(8,window.Size.X.Offset-202)),math.clamp(position.Y,8,math.max(8,window.Size.Y.Offset-202)))
    end
    filledConnect(button.Activated,function()
        local wasOpen=panel and panel.Parent
        closeFilledPopup()
        if wasOpen then return end
        panel=make("Frame",{Name="ColorPickerPopup",Size=UDim2.fromOffset(194,194),BackgroundColor3=Color3.fromRGB(17,17,19),BorderSizePixel=0,ZIndex=100},window)
        make("UICorner",{CornerRadius=UDim.new(0,8)},panel)
        make("UIStroke",{Color=Color3.fromRGB(49,49,55),Thickness=1,Transparency=.25},panel)
        area=make("Frame",{Name="SaturationValue",Position=UDim2.fromOffset(10,10),Size=UDim2.fromOffset(148,148),BackgroundColor3=Color3.fromHSV(h,1,1),BorderSizePixel=0,ZIndex=101},panel)
        local white=make("Frame",{Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,ZIndex=102},area)
        make("UIGradient",{Transparency=NumberSequence.new(0,1)},white)
        local black=make("Frame",{Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.new(0,0,0),BorderSizePixel=0,ZIndex=103},area)
        make("UIGradient",{Rotation=90,Transparency=NumberSequence.new(1,0)},black)
        shadeCursor=make("Frame",{Name="ShadeCursor",AnchorPoint=Vector2.new(.5,.5),Size=UDim2.fromOffset(8,8),BackgroundTransparency=1,BorderSizePixel=0,ZIndex=106},area)
        make("UICorner",{CornerRadius=UDim.new(1,0)},shadeCursor)
        make("UIStroke",{Color=Color3.new(1,1,1),Thickness=2},shadeCursor)
        local hue=make("Frame",{Name="Hue",Position=UDim2.fromOffset(168,10),Size=UDim2.fromOffset(16,148),BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,ZIndex=101},panel)
        local points={}
        for i=0,6 do table.insert(points,ColorSequenceKeypoint.new(i/6,Color3.fromHSV(i/6,1,1))) end
        make("UIGradient",{Rotation=90,Color=ColorSequence.new(points)},hue)
        hueCursor=make("Frame",{Name="HueCursor",AnchorPoint=Vector2.new(.5,.5),Size=UDim2.new(1,4,0,4),BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,ZIndex=106},hue)
        hex=make("TextBox",{Name="Hex",Position=UDim2.fromOffset(10,166),Size=UDim2.fromOffset(174,20),BackgroundColor3=Color3.fromRGB(10,10,12),BorderSizePixel=0,ClearTextOnFocus=false,FontFace=inputLabel.FontFace,TextSize=13,TextColor3=bright,ZIndex=106},panel)
        local function update(input,which)
            if not panel or not panel.Parent then return end
            if which=="Hue" then
                h=math.clamp((input.Position.Y-hue.AbsolutePosition.Y)/math.max(1,hue.AbsoluteSize.Y),0,1)
            else
                s=math.clamp((input.Position.X-area.AbsolutePosition.X)/math.max(1,area.AbsoluteSize.X),0,1)
                v=1-math.clamp((input.Position.Y-area.AbsolutePosition.Y)/math.max(1,area.AbsoluteSize.Y),0,1)
            end
            local nextH,nextS,nextV=h,s,v
            setColor(Color3.fromHSV(h,s,v))
            h,s,v=nextH,nextS,nextV
            shadeCursor.Position=UDim2.fromScale(s,1-v)
            area.BackgroundColor3=Color3.fromHSV(h,1,1)
            hueCursor.Position=UDim2.new(.5,0,h,0)
        end
        for _,entry in ipairs({{area,"Shade"},{hue,"Hue"}}) do
            local hit=make("TextButton",{Name="PickerHit",Size=UDim2.fromScale(1,1),Text="",BackgroundTransparency=1,ZIndex=105},entry[1])
            hit.InputBegan:Connect(function(input)
                if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
                    pickerDrag={Input=input,Update=function(nextInput) update(nextInput,entry[2]) end}
                    update(input,entry[2])
                end
            end)
        end
        hex.FocusLost:Connect(function()
            local text=hex.Text:gsub("#","")
            if text:match("^%x%x%x%x%x%x$") then setColor(Color3.fromHex(text)) else hex.Text="#"..color:ToHex():upper() end
        end)
        filledPopup={Menu=panel,Card=row,DestroyOnClose=true,OwnerButton=button}
        place()
        setColor(color)
        panel.Destroying:Connect(function() pickerDrag=nil end)
    end)
    filledConnect(game:GetService("RunService").RenderStepped,function()
        if panel and panel.Parent and panel.Visible then place() end
    end)
end
connect(UserInputService.InputChanged,function(input)
    if pickerDrag and (input==pickerDrag.Input or input.UserInputType==Enum.UserInputType.MouseMovement) then pickerDrag.Update(input) end
end)
connect(UserInputService.InputEnded,function(input)
    if pickerDrag and (input==pickerDrag.Input or input.UserInputType==Enum.UserInputType.MouseButton1) then pickerDrag=nil end
end)
connect(UserInputService.InputBegan,function(input)
    if not filledPopup or not filledPopup.DestroyOnClose then return end
    if input.KeyCode==Enum.KeyCode.Escape then closeFilledPopup(); return end
    if input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch then return end
    local owner=filledPopup.OwnerButton
    if owner then
        local p,s=owner.AbsolutePosition,owner.AbsoluteSize
        if input.Position.X>=p.X and input.Position.X<=p.X+s.X and input.Position.Y>=p.Y and input.Position.Y<=p.Y+s.Y then return end
    end
    local panel=filledPopup.Menu
    local p,s=panel.AbsolutePosition,panel.AbsoluteSize
    if input.Position.X<p.X or input.Position.X>p.X+s.X or input.Position.Y<p.Y or input.Position.Y>p.Y+s.Y then closeFilledPopup() end
end)

local createOriginalComponent
local widenComponentRow
local settingsActions={}
local settingsPopup
local settingsPanels={}
local function closeSettingsPopup()
    closeFilledPopup()
    if settingsPopup then settingsPopup.Panel.Visible=false; settingsPopup=nil end
end
local function attachSettingsPanel(row,props,prefix,componentName)
    local icon
    for _,child in ipairs(row:GetChildren()) do if child:IsA("ImageLabel") then icon=child; break end end
    if not icon then return end
    local ownerId=prefix.."."..componentName
    local menuConfig=props.SettingsConfig or {}
    local panelWidth=math.clamp(tonumber(menuConfig.Width) or 263,263,math.max(263,window.Size.X.Offset-16))
    local button=Instance.new("TextButton")
    button.Name="SettingsButton"
    button.Text=""; button.BackgroundTransparency=1
    button.Position=icon.Position; button.Size=icon.Size
    button.AutoButtonColor=false; button.ZIndex=7; button.Parent=row
    local panel=Instance.new("Frame")
    panel.Name="ComponentSettings_"..ownerId:gsub("%W","_")
    panel:SetAttribute("Owner",ownerId)
    panel.Size=UDim2.fromOffset(panelWidth,100)
    panel.BackgroundColor3=menuConfig.BackgroundColor3 or Color3.fromRGB(15,15,17)
    panel.BorderSizePixel=0; panel.Visible=false; panel.ZIndex=70; panel.Parent=window
    table.insert(settingsPanels,panel)
    local corner=Instance.new("UICorner")
    corner.CornerRadius=UDim.new(0,8); corner.Parent=panel
    local stroke=Instance.new("UIStroke")
    stroke.Color=menuConfig.BorderColor3 or Color3.fromRGB(46,46,52); stroke.Transparency=.35; stroke.Parent=panel
    local heading=Instance.new("TextLabel")
    heading.Name="Title"; heading.BackgroundTransparency=1
    heading.Position=UDim2.fromOffset(16,4); heading.Size=UDim2.fromOffset(panelWidth-32,28)
    heading.FontFace=uiFont; heading.TextSize=14; heading.TextColor3=dim
    heading.TextXAlignment=Enum.TextXAlignment.Left
    heading.Text=menuConfig.Title or props.SettingsTitle or props.Name or "Settings"
    heading.Parent=panel; fitFixedText(heading)
    local body=Instance.new("ScrollingFrame")
    body.Name="Components"; body.Position=UDim2.fromOffset(0,34)
    body.Size=UDim2.new(1,0,1,-42)
    body.BackgroundTransparency=1; body.BorderSizePixel=0
    body.AutomaticCanvasSize=Enum.AutomaticSize.Y; body.CanvasSize=UDim2.fromOffset(0,0)
    body.ScrollBarThickness=2; body.ScrollBarImageColor3=Color3.fromRGB(55,55,63)
    body.Parent=panel
    local layout=Instance.new("UIListLayout")
    layout.Padding=UDim.new(0,2); layout.SortOrder=Enum.SortOrder.LayoutOrder; layout.Parent=body
    local function fit()
        if not panel.Parent then return end
        local h=42
        for _,child in ipairs(body:GetChildren()) do if child:IsA("GuiObject") then h+=child.Size.Y.Offset+2 end end
        panel.Size=UDim2.fromOffset(panelWidth,math.min(math.max(68,h),tonumber(menuConfig.MaxHeight) or window.Size.Y.Offset-16,window.Size.Y.Offset-16))
    end
    for index,component in ipairs(props.Settings or {}) do
        component.Id=component.Id or "setting"..index
        local nestedPrefix=prefix..".Settings."..component.Id
        local nestedRow,nestedType=createOriginalComponent(body,component,nestedPrefix)
        if widenComponentRow then widenComponentRow(nestedRow,panelWidth) end
        nestedRow.LayoutOrder=index
        filledConnect(nestedRow:GetPropertyChangedSignal("Size"),fit)
        if type(component.Callback)=="function" then
            local id=nestedPrefix.."."..nestedType..(component.Type=="ColorPicker" and ".Color" or "")
            filledConnect(changed.Event,function(changedId,value) if changedId==id then component.Callback(value) end end)
        end
    end
    fit()
    local function place()
        local factor=math.max(scale.Scale,.001)
        local point=(icon.AbsolutePosition-window.AbsolutePosition)/factor
        local width=icon.AbsoluteSize.X/factor
        local gap=tonumber(menuConfig.Gap) or 9
        local x=point.X+width+gap
        if menuConfig.Side=="Left" or x+panelWidth>window.Size.X.Offset-8 then x=point.X-panelWidth-gap end
        panel.Position=UDim2.fromOffset(math.clamp(x,8,math.max(8,window.Size.X.Offset-panelWidth-8)),math.clamp(point.Y,8,math.max(8,window.Size.Y.Offset-panel.Size.Y.Offset-8)))
    end
    local function openPanel()
        closeSettingsPopup()
        fit(); place(); panel.Visible=true
        settingsPopup={Panel=panel,Button=button,Place=place}
        return true
    end
    settingsActions[ownerId]={Open=openPanel,Close=function()
        if settingsPopup and settingsPopup.Panel==panel then closeSettingsPopup() else panel.Visible=false end
        return true
    end,Toggle=function() if panel.Visible then closeSettingsPopup(); return true end; return openPanel() end}
    filledConnect(button.Activated,function()
        if panel.Visible then closeSettingsPopup() else openPanel() end
    end)
end
connect(game:GetService("RunService").RenderStepped,function()
    if settingsPopup then settingsPopup.Place() end
end)
connect(UserInputService.InputBegan,function(input)
    if not settingsPopup then return end
    if input.KeyCode==Enum.KeyCode.Escape then closeSettingsPopup(); return end
    if input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch then return end
    local function inside(object)
        local p,s=object.AbsolutePosition,object.AbsoluteSize
        return input.Position.X>=p.X and input.Position.X<=p.X+s.X and input.Position.Y>=p.Y and input.Position.Y<=p.Y+s.Y
    end
    if inside(settingsPopup.Panel) or inside(settingsPopup.Button) or filledPopup and inside(filledPopup.Menu) then return end
    closeSettingsPopup()
end)

local controlDescriptions={
    ["Auto farm"]="Farm using the selected mode.",
    ["Auto collect"]="Collect available drops automatically.",
    ["Auto equip"]="Equip the selected item automatically.",
    ["Sprint"]="Enable faster character movement.",
    ["Double jump"]="Allow an additional jump in the air.",
    ["Camera lock"]="Keep the camera focused on your target.",
    ["Show players"]="Display player markers in the world.",
    ["Show objects"]="Display markers for nearby objects.",
    ["Show markers"]="Show the configured world markers.",
    ["Animations"]="Use smooth interface transitions.",
    ["Sound effects"]="Play sounds for interface actions.",
    ["Show shortcuts"]="Display available keyboard shortcuts.",
    ["Attack range"]="Maximum distance for selecting targets.",
    ["Walk speed"]="Choose your character's movement speed.",
    ["View distance"]="Maximum distance for visible world markers.",
    ["Interface scale"]="Adjust the size of the interface.",
}
createOriginalComponent=function(parent,props,prefix)
    local kind=props.Type or "Toggle"
    if kind=="Toggle" or kind=="ColorToggle" or kind=="IconToggle" or kind=="Slider" then
        local automatic=controlDescriptions[props.Name] or (kind=="Slider" and "Drag the bar or enter a number to adjust the value." or "Enable or disable this option.")
        if props.Description==automatic then props.Description=nil end
    end
    local componentName=kind=="Toggle" and "Toggle1" or (kind=="ColorToggle" or kind=="ColorPicker") and "Toggle2" or kind=="IconToggle" and "Toggle3" or kind=="Input" and "Textbox" or kind=="MultiDropdown" and "Dropdown" or kind
    local group=(componentName:find("Toggle") and "Top") or (kind=="Paragraph" and "Right") or "Middle"
    local row=cloneStudioGroup(group,parent)
    row.Name=props.Id or componentName
    row.BackgroundTransparency=1
    local settings={__Only=componentName,[componentName]=props}
    bindStudioGroup(row,group,prefix,settings)
    local originalHeight=row.Size.Y.Offset
    local target=({Toggle1=55,Toggle2=87,Toggle3=118,Dropdown=55,Slider=91,Button=127,Textbox=164})[componentName]
    local kept={}
    local minY,maxY=math.huge,0
    local menu
    for _,child in ipairs(row:GetChildren()) do
        if child:IsA("GuiObject") then
            local x=child.Position.X.Scale*263+child.Position.X.Offset
            local y=child.Position.Y.Scale*originalHeight+child.Position.Y.Offset
            local h=child.Size.Y.Scale*originalHeight+child.Size.Y.Offset
            local center=y+h/2
            local keep=kind=="Paragraph" and child~=rightSectionTitle and center>30
                or target and math.abs(center-target)<15
            if child.Name=="OriginalDropdownOptions" then keep=true; menu=child end
            if keep then
                child.Position=UDim2.fromOffset(x,y)
                table.insert(kept,child)
                if child~=menu then minY=math.min(minY,y); maxY=math.max(maxY,y+h) end
            else child:Destroy() end
        elseif child:IsA("UIShadow") then child:Destroy() end
    end
    if minY==math.huge then minY=0 end
    for _,child in ipairs(kept) do child.Position=child.Position-UDim2.fromOffset(0,minY) end
    local height=math.max(30,maxY-minY)
    row.Size=UDim2.fromOffset(263,height)
    row:SetAttribute("ComponentType",kind)
    row:SetAttribute("ComponentId",prefix.."."..componentName)
    if kind=="Input" then
        local box=row:FindFirstChild("RuntimeTextbox",true)
        if box then
            local initial=box.Size.Y.Offset
            filledConnect(box:GetPropertyChangedSignal("Size"),function()
                row.Size=UDim2.fromOffset(row:GetAttribute("AvailableWidth") or 263,math.max(height,box.Position.Y.Offset+box.Size.Y.Offset+6))
            end)
        end
    elseif kind=="Paragraph" then
        for _,child in ipairs(row:GetChildren()) do
            if child:IsA("TextLabel") then
                if child.Size.Y.Offset==43 then child.Text=props.Name or "Information"
                else child.Text=props.Description or ""; child.TextWrapped=true end
            end
        end
    end
    for _,child in ipairs(row:GetChildren()) do
        if child:IsA("TextLabel") and kind=="Button" then child.Text=props.Text or props.Name or "Run"
        elseif child:IsA("TextLabel") and kind=="Slider" and child.Size.X.Offset==123 then child.Text=props.Name or "Value" end
    end
    
    if kind~="Paragraph" then
        row.Size=UDim2.fromOffset(263,34)
        for _,child in ipairs(row:GetChildren()) do
            if child:IsA("GuiObject") and child~=menu then
                local h=child.Size.Y.Scale*originalHeight+child.Size.Y.Offset
                if child:IsA("TextLabel") then
                    h=28
                    child.Size=UDim2.fromOffset(math.max(20,245-child.Position.X.Offset),h)
                    child.TextWrapped=false
                    child.TextTruncate=Enum.TextTruncate.None
                    child.TextXAlignment=Enum.TextXAlignment.Left
                    child.TextYAlignment=Enum.TextYAlignment.Center
                    if kind=="Slider" then child.Size=UDim2.fromOffset(110,h)
                    elseif kind=="Dropdown" then child.Size=UDim2.fromOffset(180,h)
                    elseif kind=="Button" then
                        child.Position=UDim2.fromOffset(20,child.Position.Y.Offset)
                        child.Size=UDim2.fromOffset(223,h)
                        child.TextXAlignment=Enum.TextXAlignment.Center
                    end
                end
                if child.Name=="RuntimeSliderValue" then child.Size=UDim2.fromOffset(34,24); h=24 end
                if child.Name=="RuntimeTextbox" then h=math.max(18,child.Size.Y.Offset) end
                child.Position=UDim2.fromOffset(child.Position.X.Offset,17-h/2)
            end
        end
        if menu then menu.Position=UDim2.fromOffset(menu.Position.X.Offset,36) end
        if kind=="Input" then
            local box=row:FindFirstChild("RuntimeTextbox",true)
            if box then row.Size=UDim2.fromOffset(263,math.max(34,box.Size.Y.Offset+14)) end
        end
    else
        local heading,body,background
        for _,child in ipairs(row:GetChildren()) do
            if child:IsA("TextLabel") then
                if child.Size.Y.Offset==43 then heading=child else body=child end
            elseif child:IsA("Frame") then background=child end
        end
        if heading and body then
            heading.Position=UDim2.fromOffset(36,8)
            heading.Size=UDim2.fromOffset(195,20)
            heading.TextXAlignment=Enum.TextXAlignment.Left
            heading.TextYAlignment=Enum.TextYAlignment.Top
            body.Position=UDim2.fromOffset(36,32)
            body.Size=UDim2.fromOffset(195,0)
            body.AutomaticSize=Enum.AutomaticSize.Y
            body.TextYAlignment=Enum.TextYAlignment.Top
            local function fitParagraphRow()
                if not row.Parent then return end
                local h=math.max(68,32+body.TextBounds.Y/math.max(scale.Scale,.001)+12)
                row.Size=UDim2.fromOffset(row:GetAttribute("AvailableWidth") or 263,h+6)
                if background then background.Position=UDim2.fromOffset(20,0); background.Size=UDim2.fromOffset((row:GetAttribute("AvailableWidth") or 263)-39,h) end
            end
            filledConnect(body:GetPropertyChangedSignal("TextBounds"),fitParagraphRow)
            task.defer(fitParagraphRow)
        end
    end
    for _,child in ipairs(row:GetChildren()) do
        if child:IsA("TextLabel") then
            if kind~="Paragraph" then fitFixedText(child) end
        end
    end
    if kind=="Paragraph" then
        for _,child in ipairs(row:GetChildren()) do
            if child:IsA("TextLabel") and child.Size.Y.Offset==20 then fitFixedText(child) end
        end
    end
    if kind=="Button" then
        local hit=row:FindFirstChild("RuntimeButton")
        if hit then
            local visual=Instance.new("Frame")
            visual.Name="ButtonVisual"
            visual.BackgroundTransparency=1
            visual.AnchorPoint=Vector2.new(.5,.5)
            visual.Position=UDim2.fromScale(.5,.5)
            visual.Size=UDim2.fromScale(1,1)
            visual.Parent=row
            local background,label
            for _,child in ipairs(row:GetChildren()) do
                if child~=visual and child~=hit and child:IsA("GuiObject") then
                    child.Parent=visual
                    if child:IsA("Frame") then background=child elseif child:IsA("TextLabel") then label=child end
                end
            end
            local pressScale=Instance.new("UIScale")
            pressScale.Name="PressScale"
            pressScale.Parent=visual
            local originalColor=background and background.BackgroundColor3
            local hover=false
            local scaleTween,colorTween
            local pressVersion=0
            local function draw(pressed)
                if scaleTween then scaleTween:Cancel() end
                scaleTween=TweenService:Create(pressScale,TweenInfo.new(pressed and .07 or .18,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Scale=pressed and .96 or 1})
                scaleTween:Play()
                if background then
                    if colorTween then colorTween:Cancel() end
                    colorTween=TweenService:Create(background,TweenInfo.new(.12),{BackgroundColor3=pressed and Color3.fromRGB(38,43,55) or hover and Color3.fromRGB(24,26,32) or originalColor})
                    colorTween:Play()
                end
                if label then label.TextColor3=pressed and Color3.new(1,1,1) or bright end
            end
            filledConnect(hit.MouseButton1Down,function() pressVersion+=1; draw(true) end)
            filledConnect(hit.MouseButton1Up,function() pressVersion+=1; draw(false) end)
            filledConnect(hit.Activated,function()
                pressVersion+=1
                local version=pressVersion
                draw(true)
                task.delay(.07,function() if visual.Parent and pressVersion==version then draw(false) end end)
            end)
            filledConnect(hit.MouseEnter,function() hover=true; draw(false) end)
            filledConnect(hit.MouseLeave,function() hover=false; pressVersion+=1; draw(false) end)
        end
    end
    if kind=="Slider" then
        local fill=row:FindFirstChild("RuntimeSliderFill",true)
        local sliderHit=row:FindFirstChild("RuntimeSlider")
        local number=row:FindFirstChild("RuntimeSliderValue")
        local nameLabel=row:FindFirstChildWhichIsA("TextLabel")
        if fill and sliderHit and number and nameLabel then
            local track=fill.Parent
            local revision=0
            local function fitSlider()
                revision+=1
                local token=revision
                local params=Instance.new("GetTextBoundsParams")
                params.Text=nameLabel.Text
                params.Font=nameLabel.FontFace
                params.Size=nameLabel.TextSize
                params.Width=10000
                local ok,bounds=pcall(function() return (game:GetService("TextService") :: any):GetTextBoundsAsync(params) end)
                params:Destroy()
                if token~=revision or not row.Parent then return end
                local left=nameLabel.Position.X.Offset
                local right=number.Position.X.Offset-8
                local maximumLabel=math.max(1,right-left-10-60)
                local textWidth=math.clamp(math.ceil(ok and bounds.X or nameLabel.TextBounds.X/math.max(scale.Scale,.001)),1,maximumLabel)
                nameLabel.Size=UDim2.fromOffset(textWidth,28)
                local start=left+textWidth+10
                local width=math.max(1,right-start)
                track.Position=UDim2.fromOffset(start,10)
                track.Size=UDim2.fromOffset(width,14)
                sliderHit.Position=UDim2.fromOffset(start,4)
                sliderHit.Size=UDim2.fromOffset(width,26)
            end
            for _,property in ipairs({"Text","TextSize","FontFace"}) do
                filledConnect(nameLabel:GetPropertyChangedSignal(property),function() task.spawn(fitSlider) end)
            end
            task.spawn(fitSlider)
        end
    end
    if kind=="Toggle" or kind=="ColorToggle" or kind=="IconToggle" then
        local indicator
        local button=row:FindFirstChild("Runtime"..componentName)
        for _,child in ipairs(row:GetChildren()) do
            if child:IsA("Frame") and child.Position.X.Offset==21 and child.Size.X.Offset==24 then indicator=child; break end
        end
        if indicator and button then
            for _,child in ipairs(indicator:GetChildren()) do child:Destroy() end
            indicator.Name="ToggleTrack"
            indicator.Position=UDim2.fromOffset(21,7)
            indicator.Size=UDim2.fromOffset(36,20)
            indicator.BorderSizePixel=0
            local corner=Instance.new("UICorner")
            corner.CornerRadius=UDim.new(1,0); corner.Parent=indicator
            local trackGradient=Instance.new("UIGradient")
            trackGradient.Color=ColorSequence.new(Color3.fromRGB(111,132,199),Color3.fromRGB(65,84,139))
            trackGradient.Parent=indicator
            local thumb=Instance.new("Frame")
            thumb.Name="ToggleThumb"
            thumb.AnchorPoint=Vector2.new(0,.5)
            thumb.Size=UDim2.fromOffset(14,14)
            thumb.BorderSizePixel=0
            thumb.ZIndex=indicator.ZIndex+1
            thumb.Parent=indicator
            local thumbCorner=Instance.new("UICorner")
            thumbCorner.CornerRadius=UDim.new(1,0); thumbCorner.Parent=thumb
            button.Position=UDim2.fromOffset(21,4)
            button.Size=UDim2.fromOffset(36,26)
            for _,child in ipairs(row:GetChildren()) do
                if child:IsA("GuiObject") and child~=indicator and child~=button and child.Position.X.Offset>=52 then
                    child.Position=child.Position+UDim2.fromOffset(10,0)
                    if child:IsA("TextLabel") then child.Size=child.Size-UDim2.fromOffset(10,0) end
                end
            end
            local trackTween,thumbTween
            local function render(instant)
                local enabled=indicator:GetAttribute("Enabled")==true
                local trackColor=enabled and Color3.new(1,1,1) or Color3.fromRGB(10,10,12)
                trackGradient.Enabled=enabled
                local position=UDim2.new(enabled and 1 or 0,enabled and -17 or 3,.5,0)
                local thumbColor=enabled and Color3.fromRGB(5,6,10) or Color3.fromRGB(91,91,96)
                if trackTween then trackTween:Cancel() end
                if thumbTween then thumbTween:Cancel() end
                if instant then
                    indicator.BackgroundColor3=trackColor
                    thumb.Position=position; thumb.BackgroundColor3=thumbColor
                else
                    trackTween=TweenService:Create(indicator,TweenInfo.new(.16,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{BackgroundColor3=trackColor})
                    thumbTween=TweenService:Create(thumb,TweenInfo.new(.18,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Position=position,BackgroundColor3=thumbColor})
                    trackTween:Play(); thumbTween:Play()
                end
            end
            indicator:SetAttribute("Enabled",values[prefix.."."..componentName]==true)
            indicator:SetAttribute("SwitchBuilt",true)
            filledConnect(indicator:GetAttributeChangedSignal("Enabled"),function() render(false) end)
            render(true)
        end
    end
    if kind=="ColorPicker" then
        local remove={}
        for _,child in ipairs(row:GetChildren()) do
            if child:IsA("TextButton") and child.Name=="RuntimeToggle2" or child:IsA("Frame") and child.Position.X.Offset==21 then
                table.insert(remove,child)
            elseif child:IsA("Frame") and child.Position.X.Offset==52 and child.Size.X.Offset==24 then
                child:SetAttribute("ColorSwatch",true)
                child.Position=UDim2.fromOffset(220,5)
            elseif child:IsA("TextLabel") then
                child.Position=UDim2.fromOffset(21,3)
                child.Size=UDim2.fromOffset(189,28)
                child.Text=props.Name or "Color"
            end
        end
        for _,child in ipairs(remove) do child:Destroy() end
    end
    if kind=="ColorToggle" or kind=="IconToggle" or kind=="ColorPicker" then attachColorPicker(row,props,prefix,componentName) end
    if kind=="IconToggle" then
        if type(props.Settings)=="table" and props.Settings.Components then
            local nested=props.Settings
            props.SettingsConfig=props.SettingsConfig or {}
            for key,value in pairs(nested) do if key~="Components" then props.SettingsConfig[key]=value end end
            props.Settings=nested.Components
        end
        attachSettingsPanel(row,props,prefix,componentName)
    end
    local isToggle=kind=="Toggle" or kind=="ColorToggle" or kind=="IconToggle"
    if isToggle then
        local track=row:FindFirstChild("ToggleTrack")
        local toggleButton=row:FindFirstChild("Runtime"..componentName)
        local nameLabel=row:FindFirstChildWhichIsA("TextLabel")
        local swatch,settingsIcon
        for _,child in ipairs(row:GetChildren()) do
            if child:IsA("Frame") and child~=track and child.Size.X.Offset==24 then swatch=child end
            if child:IsA("ImageLabel") then settingsIcon=child end
        end
        local right=244
        if settingsIcon then
            right-=settingsIcon.Size.X.Offset
            settingsIcon.Position=UDim2.fromOffset(right,5)
            local settingsButton=row:FindFirstChild("SettingsButton")
            if settingsButton then settingsButton.Position=settingsIcon.Position; settingsButton.Size=settingsIcon.Size end
            right-=8
        end
        if swatch then
            right-=24
            swatch.Position=UDim2.fromOffset(right,5)
            local pickerButton=row:FindFirstChild("ColorPickerButton")
            if pickerButton then pickerButton.Position=swatch.Position; pickerButton.Size=swatch.Size end
            right-=8
        end
        if track then
            right-=track.Size.X.Offset
            track.Position=UDim2.fromOffset(right,7)
            if toggleButton then toggleButton.Position=UDim2.fromOffset(right,4); toggleButton.Size=UDim2.fromOffset(track.Size.X.Offset,26) end
        end
        if nameLabel then
            nameLabel.Position=UDim2.fromOffset(21,3)
            nameLabel.Size=UDim2.fromOffset(math.max(1,right-31),28)
            nameLabel.TextXAlignment=Enum.TextXAlignment.Left
        end
    end
    return row,componentName
end

widenComponentRow=function(row,width)
    local extra=width-263
    row:SetAttribute("AvailableWidth",width)
    row.Size=UDim2.fromOffset(width,row.Size.Y.Offset)
    if extra==0 then return end
    local kind=row:GetAttribute("ComponentType")
    local isToggle=kind=="Toggle" or kind=="ColorToggle" or kind=="IconToggle"
    for _,child in ipairs(row:GetChildren()) do
        if child:IsA("GuiObject") then
            if child.Name=="Description" then
                child.Size=UDim2.fromOffset(child.Size.X.Offset+extra,child.Size.Y.Offset)
            elseif isToggle then
                if child:IsA("TextLabel") then child.Size=UDim2.fromOffset(child.Size.X.Offset+extra,child.Size.Y.Offset)
                else child.Position=child.Position+UDim2.fromOffset(extra,0) end
            elseif kind=="Slider" then
                if child.Name=="RuntimeSliderValue" then child.Position=child.Position+UDim2.fromOffset(extra,0)
                elseif child:IsA("Frame") or child.Name=="RuntimeSlider" then child.Size=UDim2.fromOffset(child.Size.X.Offset+extra,child.Size.Y.Offset) end
            elseif kind=="Dropdown" or kind=="MultiDropdown" then
                if child:IsA("ImageLabel") then child.Position=child.Position+UDim2.fromOffset(extra,0)
                else child.Size=UDim2.fromOffset(child.Size.X.Offset+extra,child.Size.Y.Offset) end
            elseif kind=="Input" then
                child.Size=UDim2.fromOffset(child.Size.X.Offset+extra,child.Size.Y.Offset)
                if child:IsA("TextBox") then child:SetAttribute("AvailableWidth",207+extra) end
            elseif kind=="Button" then
                if child.Name=="ButtonVisual" then
                    for _,visual in ipairs(child:GetChildren()) do if visual:IsA("GuiObject") then visual.Size=UDim2.fromOffset(visual.Size.X.Offset+extra,visual.Size.Y.Offset) end end
                else child.Size=UDim2.fromOffset(child.Size.X.Offset+extra,child.Size.Y.Offset) end
            elseif kind=="Paragraph" then
                child.Size=UDim2.fromOffset(child.Size.X.Offset+extra,child.Size.Y.Offset)
            elseif kind=="ColorPicker" then
                if child:IsA("TextLabel") then child.Size=UDim2.fromOffset(child.Size.X.Offset+extra,child.Size.Y.Offset)
                else child.Position=child.Position+UDim2.fromOffset(extra,0) end
            end
        end
    end
end
local hubSections={
    {"Farming","Combat","Rewards","Travel","Inventory","Session"},
    {"Movement","Character","Camera","Abilities","Recovery","Shortcuts"},
    {"Locations","Map","Objects","Events","Tracking","Server"},
    {"Appearance","Interface","Notifications","Profiles","Performance","Configuration"},
}
local hubNames={"Main","Player","World","Settings"}
local hubIcons={"rbxassetid://98755624629571","rbxassetid://94653344254614","rbxassetid://81973586053257","rbxassetid://80758916183665"}
local hubComponentNames={
    {Toggle="Auto farm",ColorToggle="Auto collect",IconToggle="Auto equip",Slider="Attack range",Input="Target name",Dropdown="Farm mode",Button="Start session",Paragraph="Session status"},
    {Toggle="Sprint",ColorToggle="Double jump",IconToggle="Camera lock",Slider="Walk speed",Input="Character preset",Dropdown="Movement mode",Button="Apply preset",Paragraph="Character status"},
    {Toggle="Show players",ColorToggle="Show objects",IconToggle="Show markers",Slider="View distance",Input="Find location",Dropdown="Target location",Button="Refresh world",Paragraph="World status"},
    {Toggle="Animations",ColorToggle="Sound effects",IconToggle="Show shortcuts",Slider="Interface scale",Input="Profile name",Dropdown="Theme",Button="Save profile",Paragraph="Profile status"},
}
local hubPatterns={
    {"Toggle","Dropdown","Slider","Button","Input"},
    {"Slider","ColorToggle","IconToggle","Input","Button"},
    {"Paragraph","Toggle","Dropdown","Button","ColorToggle"},
    {"Dropdown","Input","Toggle","Slider","IconToggle"},
    {"IconToggle","Button","Slider","ColorToggle","Input"},
    {"Input","ColorToggle","Button","Dropdown","Toggle"},
}
local function buildFilledTabs()
    closeSettingsPopup()
    for _,panel in ipairs(settingsPanels) do panel:Destroy() end
    table.clear(settingsPanels)
    table.clear(settingsActions)
    if filledDrag and filledDrag.Scroll then filledDrag.Scroll.ScrollingEnabled=filledDrag.Scrolling end
    filledDrag=nil
    for _,connection in ipairs(filledConnections) do connection:Disconnect() end
    table.clear(filledConnections)
    for id in pairs(filledSetters) do setters[id]=nil end
    table.clear(filledSetters)
    table.clear(colorSetters)
    table.clear(filledPages)
    if filledHost then filledHost:Destroy() end
    filledHost=Instance.new("Frame")
    filledHost.Name="OriginalComponentPages"
    filledHost.BackgroundTransparency=1
    filledHost.Position=UDim2.fromOffset(68,24)
    filledHost.Size=UDim2.new(1,-92,1,-42)
    filledHost.Parent=window
    local usedTabs={}
    for _,tab in ipairs(config.Tabs) do usedTabs[tab.Id]=true end
    for id,entry in pairs(tabEntries) do
        local visible=usedTabs[id]==true
        entry.Background.Visible=visible
        if entry.Label then entry.Label.Visible=false end
        if entry.Icon then entry.Icon.Visible=visible end
        local hitName=id=="Example" and "RuntimeTabExample" or id=="Selected" and "RuntimeTabSelected" or "RuntimeTab"..id
        local tabHit=window:FindFirstChild(hitName) or window:FindFirstChild("LibraryTabHit"..id)
        if tabHit then tabHit.Visible=visible end
    end
    local tabOffset=62
    local tabDescriptions={Example="Farm, combat and rewards",Selected="Movement and character",Extras="Locations and world",Settings="Interface and profiles"}
    for tabIndex,tab in ipairs(config.Tabs or {}) do
        if tab.Description==nil and tabDescriptions[tab.Id] then tab.Description=tabDescriptions[tab.Id] end
        if type(tab.Description)=="string" then
            local count=utf8.len(tab.Description)
            if count and count>32 then
                local nextByte=utf8.offset(tab.Description,33)
                tab.Description=tab.Description:sub(1,nextByte-1)
            elseif not count then tab.Description=tab.Description:sub(1,32) end
        end
        local hasDescription=false
        local tabHeight=34
        local demoIndex=(tabIndex-1)%4+1
        if not tab.LibrarySections then
            tab.Name=hubNames[demoIndex]
            tab.Icon=hubIcons[demoIndex]
            tab.LibrarySections={}
            for sectionIndex,name in ipairs(hubSections[demoIndex]) do
                local section={Id="section"..sectionIndex,Name=name,Column=(sectionIndex+tabIndex)%2+1,Order=math.ceil(sectionIndex/2),Components={}}
                for componentIndex,kind in ipairs(hubPatterns[(sectionIndex+tabIndex-2)%#hubPatterns+1]) do
                    local props={Id="control"..componentIndex,Type=kind,Name=hubComponentNames[demoIndex][kind]}
                    if kind=="Slider" then props.Min=demoIndex==2 and 16 or 0; props.Max=demoIndex==3 and 1000 or 100; props.Step=1; props.Default=demoIndex==2 and 16 or 50
                    elseif kind=="Input" then props.Placeholder=demoIndex==4 and "My profile" or "Enter a name..."; props.Default=""
                    elseif kind=="Dropdown" then
                        props.Options=demoIndex==1 and {"Nearest","Selected","All targets"} or demoIndex==2 and {"Default","Sprint","Custom"} or demoIndex==3 and {"Spawn","Town","Arena","Dungeon"} or {"Dark","Midnight","Classic"}
                    elseif kind=="Button" then props.Text=demoIndex==1 and "Start" or demoIndex==2 and "Apply" or demoIndex==3 and "Refresh" or "Save"
                    elseif kind=="Paragraph" then props.Description=demoIndex==1 and "Choose a farming mode and configure the controls for this session." or demoIndex==2 and "Configure movement, camera and character preferences." or demoIndex==3 and "Choose locations and configure visible world markers." or "Your interface preferences are stored in this profile." end
                    table.insert(section.Components,props)
                end
                table.insert(tab.LibrarySections,section)
            end
        end
        if not tab.MultiDropdownAdded and ({Example=true,Selected=true,Extras=true,Settings=true})[tab.Id] and tab.LibrarySections[1] then
            local names={Example="Farming targets",Selected="Enabled abilities",Extras="Visible markers",Settings="Notifications"}
            local options={Example={"Mobs","Bosses","Drops","Quests"},Selected={"Sprint","Double jump","Camera lock"},Extras={"Players","Objects","Locations","Events"},Settings={"Errors","Warnings","Success","Rewards"}}
            table.insert(tab.LibrarySections[1].Components,{Id="multi_selection",Type="MultiDropdown",Name=names[tab.Id],Options=options[tab.Id],Default={options[tab.Id][1]}})
            tab.MultiDropdownAdded=true
        end
        local entry=tabEntries[tab.Id]
        if not entry then
            local y=62+(tabIndex-1)*43
            local background=selectedFrame:Clone()
            background.Name="LibraryTab"..tab.Id
            background.Position=UDim2.fromOffset(12,y)
            for _,child in ipairs(background:GetChildren()) do if child:IsA("TextLabel") then child:Destroy() end end
            background.Parent=window
            local text=exampleTab:Clone()
            text.Position=UDim2.fromOffset(58,y-2); text.ZIndex=2; text.Parent=window
            local icon=selectedIcon and selectedIcon:Clone()
            if icon then icon.Position=UDim2.fromOffset(23,y+8); icon.ZIndex=2; icon.Parent=window end
            local button=hit("LibraryTabHit"..tab.Id,background.Position,background.Size,window)
            connect(button.Activated,function() if env.R1nUI then env.R1nUI.SelectTab(tab.Id) end end)
            entry={Background=background,Label=text,Icon=icon}
            tabEntries[tab.Id]=entry
        end
        if entry then
            local y=tabOffset
            local background=entry.Background
            background.Visible=true
            if entry.Icon then entry.Icon.Visible=true end
            background.Position=UDim2.fromOffset(5,y)
            background.Size=UDim2.fromOffset(44,tabHeight)
            local visualScale=background:FindFirstChild("TabVisualScale")
            if not visualScale then
                visualScale=Instance.new("UIScale")
                visualScale.Name="TabVisualScale"
                visualScale.Parent=background
            end
            visualScale.Scale=tabVisualScale
            background.BackgroundColor3=Color3.fromRGB(18,18,18)
            background.BackgroundTransparency=1
            background.ZIndex=2
            for _,child in ipairs(background:GetChildren()) do if child:IsA("UIShadow") then child:Destroy() end end
            entry.Label.Parent=background
            entry.Label.Visible=false
            entry.Label.Position=UDim2.fromOffset(44,hasDescription and 6 or 0)
            entry.Label.Size=UDim2.fromOffset(124,hasDescription and 20 or 38)
            entry.Label.AnchorPoint=Vector2.zero
            entry.Label.Text=tab.Name or tab.Id
            entry.Label.TextSize=16
            entry.Label.TextXAlignment=Enum.TextXAlignment.Left
            entry.Label.TextYAlignment=Enum.TextYAlignment.Center
            entry.Label.TextWrapped=false
            entry.Label.TextTruncate=Enum.TextTruncate.None
            fitFixedText(entry.Label)
            entry.Label.ZIndex=2
            local tabDescription=background:FindFirstChild("RuntimeTabDescription")
            if not tabDescription then
                tabDescription=Instance.new("TextLabel")
                tabDescription.Name="RuntimeTabDescription"
                tabDescription.BackgroundTransparency=1
                tabDescription.Parent=background
            end
            tabDescription.Visible=false
            tabDescription.Text=hasDescription and tab.Description or ""
            tabDescription.FontFace=uiFont
            tabDescription.TextSize=13
            tabDescription.TextColor3=Color3.fromRGB(118,122,134)
            tabDescription.Position=UDim2.fromOffset(44,22)
            tabDescription.Size=UDim2.fromOffset(124,16)
            tabDescription.TextXAlignment=Enum.TextXAlignment.Left
            tabDescription.TextYAlignment=Enum.TextYAlignment.Center
            tabDescription.ZIndex=2
            fitFixedText(tabDescription)
            tabDescription.TextWrapped=false
            if entry.Icon then
                entry.Icon.Parent=background
                entry.Icon.Position=UDim2.fromOffset(13,(tabHeight-18)/2)
                entry.Icon.Size=UDim2.fromOffset(18,18)
                entry.Icon.AnchorPoint=Vector2.zero
                entry.Icon.Image=tab.Icon or ""
                entry.Icon.ZIndex=2
                local halo=background:FindFirstChild("SelectedIconHalo")
                if not halo then
                    halo=Instance.new("ImageLabel")
                    halo.Name="SelectedIconHalo"
                    halo.BackgroundTransparency=1
                    halo.Parent=background
                end
                halo.Image=entry.Icon.Image
                halo.ImageRectOffset=entry.Icon.ImageRectOffset
                halo.ImageRectSize=entry.Icon.ImageRectSize
                halo.ImageColor3=selectedIconColor
                halo.ImageTransparency=1
                halo.Position=entry.Icon.Position-UDim2.fromOffset(4,4)
                halo.Size=entry.Icon.Size+UDim2.fromOffset(8,8)
                halo.ZIndex=1
                entry.Halo=halo
                for _,child in ipairs(halo:GetChildren()) do child:Destroy() end
                entry.GlowShadow=nil
            end
            local hitName=tab.Id=="Example" and "RuntimeTabExample" or tab.Id=="Selected" and "RuntimeTabSelected" or "RuntimeTab"..tab.Id
            local tabHit=window:FindFirstChild(hitName) or window:FindFirstChild("LibraryTabHit"..tab.Id)
            if tabHit then
                tabHit.Position=background.Position; tabHit.Size=UDim2.fromOffset(background.Size.X.Offset*tabVisualScale,background.Size.Y.Offset*tabVisualScale)
                if not tabHit:GetAttribute("LibraryHoverBound") then
                    tabHit:SetAttribute("LibraryHoverBound",true)
                    connect(tabHit.MouseEnter,function()
                        background.BackgroundTransparency=gui:GetAttribute("SelectedTab")==tab.Id and 1 or .65
                    end)
                    connect(tabHit.MouseLeave,function()
                        background.BackgroundTransparency=1
                    end)
                end
            end
        end
        tabOffset+=tabHeight*tabVisualScale+1
        local page=Instance.new("Frame")
        page.Name=tab.Id; page.BackgroundTransparency=1; page.Size=UDim2.fromScale(1,1)
        page.Visible=false; page.Parent=filledHost
        filledPages[tab.Id]=page
        local columns={}
        local columnWidth=math.floor((window.Size.X.Offset-92-16)/2)
        local sectionWidth=columnWidth-3
        for index=1,2 do
            local column=Instance.new("ScrollingFrame")
            column.Name="Column"..index; column.BackgroundTransparency=1; column.BorderSizePixel=0
            column.Position=UDim2.fromOffset((index-1)*(columnWidth+16),0)
            column.Size=UDim2.new(0,columnWidth,1,0)
            column.CanvasSize=UDim2.fromOffset(0,0)
            column.AutomaticCanvasSize=Enum.AutomaticSize.Y
            column.ScrollBarThickness=0; column.ScrollBarImageColor3=Color3.fromRGB(45,45,45)
            column.Parent=page
            local layout=Instance.new("UIListLayout")
            layout.Padding=UDim.new(0,14); layout.SortOrder=Enum.SortOrder.LayoutOrder; layout.Parent=column
            local padding=Instance.new("UIPadding")
            padding.PaddingBottom=UDim.new(0,18); padding.Parent=column
            columns[index]=column
        end
        for sectionIndex,section in ipairs(tab.LibrarySections) do
            local card=topCard:Clone()
            card.Name=section.Id or "Section"..sectionIndex
            card.Visible=true
            for _,child in ipairs(card:GetChildren()) do if child:IsA("GuiObject") then child:Destroy() end end
            card.Position=UDim2.fromOffset(0,0)
            card.Size=UDim2.fromOffset(sectionWidth,0)
            card.AutomaticSize=Enum.AutomaticSize.Y
            card.LayoutOrder=section.Order or sectionIndex
            card.Parent=columns[section.Column==2 and 2 or 1]
            local layout=Instance.new("UIListLayout")
            layout.SortOrder=Enum.SortOrder.LayoutOrder; layout.Padding=UDim.new(0,2); layout.Parent=card
            local padding=Instance.new("UIPadding")
            padding.PaddingBottom=UDim.new(0,10); padding.Parent=card
            local title=rightSectionTitle:Clone()
            title.Name="SectionTitle"; title.Text=section.Name or "Section"
            title.Position=UDim2.fromOffset(0,0); title.Size=UDim2.fromOffset(sectionWidth,28)
            title.LayoutOrder=0; title.Visible=true; title.TextXAlignment=Enum.TextXAlignment.Left; title.Parent=card
            local titlePadding=Instance.new("UIPadding")
            titlePadding.PaddingLeft=UDim.new(0,18); titlePadding.Parent=title
            fitFixedText(title)
            for index,props in ipairs(section.Components or {}) do
                props.Id=props.Id or "control"..index
                local prefix=tab.Id.."."..card.Name.."."..props.Id
                if props.Type=="IconToggle" and props.Settings==nil then
                    props.Settings={
                        {Id="enabled",Type="Toggle",Name="Enabled",Default=true},
                        {Id="intensity",Type="Slider",Name="Intensity",Min=0,Max=100,Default=50},
                        {Id="mode",Type="Dropdown",Name="Mode",Options={"Balanced","Fast","Eco"}},
                        {Id="color",Type="ColorPicker",Name="Accent color",Color=accent},
                    }
                end
                local row,componentName=createOriginalComponent(card,props,prefix)
                widenComponentRow(row,sectionWidth)
                row.LayoutOrder=index
                if type(props.Callback)=="function" then
                    local id=prefix.."."..componentName..(props.Type=="ColorPicker" and ".Color" or "")
                    filledConnect(changed.Event,function(changedId,value) if changedId==id then props.Callback(value) end end)
                end
            end
        end
    end
end

connect(UserInputService.InputChanged,function(input)
    if filledDrag and (input==filledDrag.Input or input.UserInputType==Enum.UserInputType.MouseMovement) then filledDrag.Pointer(input.Position.X) end
end)
connect(UserInputService.InputEnded,function(input)
    if filledDrag and (input==filledDrag.Input or input.UserInputType==Enum.UserInputType.MouseButton1) then
        if filledDrag.Scroll then filledDrag.Scroll.ScrollingEnabled=filledDrag.Scrolling end
        filledDrag=nil
    end
end)
STATE.onCleanup(function()
    for _,connection in ipairs(filledConnections) do connection:Disconnect() end
end)

local function selectTab(id)
    closeSettingsPopup()
    if not filledPages[id] then return false end
    local entry=tabEntries[id]
    if not entry then return false end
    for key,item in pairs(tabEntries) do
        local active=key==id
        item.Background.BackgroundTransparency=1
        item.Label.TextColor3=active and bright or dim
        setTabIconGlow(item,active)
    end
    moveTabSelection(entry)
    local shown={}
    for _,tab in ipairs(config.Tabs or {}) do
        if tab.Id==id then
            for _,group in ipairs(tab.Show or {"Top","Middle","Right"}) do shown[group]=true end
            break
        end
    end
    for group,objects in pairs(contentGroups) do
        for _,object in ipairs(objects) do
            if object~=inputLabel and object~=sliderValue and object~=dropdownMenu then object.Visible=shown[group]==true end
        end
    end
    if dropdownMenu then dropdownMenu.Visible=false; dropdownOpen=false end
    for key,page in pairs(filledPages) do page.Visible=key==id end
    if filledPages[id] then
        for _,objects in pairs(contentGroups) do
            for _,object in ipairs(objects) do object.Visible=false end
        end
    end
    gui:SetAttribute("SelectedTab",id)
    changed:Fire("Tab",id)
    return true
end
if exampleTab and selectedTab and selectedFrame then
    exampleTab.Position=UDim2.new(0,58,exampleTab.Position.Y.Scale,exampleTab.Position.Y.Offset)
    selectedTab.Position=UDim2.new(0,46,selectedTab.Position.Y.Scale,selectedTab.Position.Y.Offset)
    exampleTab.TextXAlignment=Enum.TextXAlignment.Left
    selectedTab.TextXAlignment=Enum.TextXAlignment.Left
    for _,icon in ipairs({exampleIcon,selectedIcon}) do
        if icon then icon.Size=UDim2.fromOffset(22,22); icon.Position=icon.Position+UDim2.fromOffset(3,6) end
    end
    local exampleFrame=selectedFrame:Clone()
    exampleFrame.Name="RuntimeTabBackgroundExample"
    exampleFrame.Position=UDim2.fromOffset(12,62)
    exampleFrame.BackgroundTransparency=1
    local copiedLabel=exampleFrame:FindFirstChildWhichIsA("TextLabel")
    if copiedLabel then copiedLabel:Destroy() end
    exampleFrame.Parent=window
    exampleTab.ZIndex=2
    if exampleIcon then exampleIcon.ZIndex=2 end
    tabEntries.Example={Background=exampleFrame,Label=exampleTab,Icon=exampleIcon}
    tabEntries.Selected={Background=selectedFrame,Label=selectedTab,Icon=selectedIcon}
    for index,tab in ipairs(config.Tabs or {}) do
        if tab.Id~="Example" and tab.Id~="Selected" then
            local y=62+(index-1)*43
            local background=selectedFrame:Clone()
            background.Name="RuntimeTabBackground"..tab.Id
            background.Position=UDim2.fromOffset(12,y)
            background.BackgroundTransparency=1
            local copied=background:FindFirstChildWhichIsA("TextLabel")
            if copied then copied:Destroy() end
            background.Parent=window
            local tabLabel=exampleTab:Clone()
            tabLabel.Name="RuntimeTabLabel"..tab.Id
            tabLabel.Text=tab.Name or tab.Id
            tabLabel.Position=UDim2.fromOffset(58,y-2)
            tabLabel.ZIndex=2
            tabLabel.Parent=window
            local icon=selectedIcon and selectedIcon:Clone()
            if icon then
                icon.Name="RuntimeTabIcon"..tab.Id
                icon.Position=UDim2.fromOffset(23,y+8)
                icon.Image=tab.Icon or ""
                icon.ZIndex=2
                icon.Parent=window
            end
            tabEntries[tab.Id]={Background=background,Label=tabLabel,Icon=icon}
            local tabHit=hit("RuntimeTab"..tab.Id,background.Position,background.Size,window)
            connect(tabHit.Activated,function() selectTab(tab.Id) end)
        end
    end
    local exampleHit=hit("RuntimeTabExample",UDim2.fromOffset(12,62),UDim2.fromOffset(170,38),window)
    local selectedHit=hit("RuntimeTabSelected",selectedFrame.Position,selectedFrame.Size,window)
    connect(exampleHit.Activated,function() selectTab("Example") end)
    connect(selectedHit.Activated,function() selectTab("Selected") end)
end
local function apply()
    for i=1,3 do
        local spec=config.Components["Toggle"..i]
        if spec and toggleLabels[i] then
            toggleLabels[i].Text=spec.Name or "Example Toggle"
            if values["Toggle"..i]==nil then setters["Toggle"..i](spec.Default) end
        end
    end
    local drop=config.Components.Dropdown
    if drop and dropdownMenu then
        setDropdownOptions(drop.Options)
        if dropdownText then dropdownText.Text=drop.Name or "Select Option..." end
        if not setters.Dropdown(values.Dropdown) then setters.Dropdown(drop.Default or drop.Options[1]) end
    end
    local slider=config.Components.Slider
    if slider and setters.Slider then
        if sliderLabel then sliderLabel.Text=slider.Name or "Example Slider" end
        sliderMin=tonumber(slider.Min) or 0
        sliderMax=math.max(sliderMin,tonumber(slider.Max) or 100)
        sliderStep=math.max(.000001,tonumber(slider.Step) or 1)
        setters.Slider(values.Slider or slider.Default or sliderMin)
    end
    local box=config.Components.Textbox
    if box and input then
        input.PlaceholderText=box.Placeholder or box.Name or "Example Input..."
        if values.Textbox==nil then setters.Textbox(box.Default) end
    end
    local note=config.Components.Paragraph
    if note then
        if paragraphTitle then paragraphTitle.Text=note.Name or "Example Paragraph" end
        if paragraph then paragraph.Text=note.Description or "" end
    end
    local button=config.Components.Button
    if button and actionLabel then actionLabel.Text=button.Text or button.Name or "Button" end
    for _,tab in ipairs(config.Tabs or {}) do
        local entry=tabEntries[tab.Id]
        if entry then
            entry.Label.Text=tab.Name or tab.Id
            if entry.Icon and type(tab.Icon)=="string" then entry.Icon.Image=tab.Icon end
        end
    end
    if rightSectionTitle and config.Sections.Right then rightSectionTitle.Text=config.Sections.Right.Name or "Section" end
end
local originalApply=apply
apply=function()
    originalApply()
    buildFilledTabs()
    local selected=gui:GetAttribute("SelectedTab")
    if not selected or not filledPages[selected] then selected=config.Tabs[1] and config.Tabs[1].Id end
    if selected then selectTab(selected) else
        for _,objects in pairs(contentGroups) do for _,object in ipairs(objects) do object.Visible=false end end
        if tabSelectionBox then tabSelectionBox.Visible=false end
    end
end
local api={Gui=gui,Config=config,Changed=changed.Event,Apply=apply,SelectTab=selectTab}
function api.GetValue(id) local value=values[id]; return type(value)=="table" and table.clone(value) or value end
function api.SetColor(id,color)
    local setter=colorSetters[id] or colorSetters[id..".Color"]
    return setter and setter(color) or false
end
function api.GetColor(id) return values[id..".Color"] or values[id] end
function api.SetValue(id,value) return setters[id] and setters[id](value) or false end
function api.Show() gui.Enabled=true; window.Visible=true; return api end
function api.Hide() closeSettingsPopup(); window.Visible=false; return api end
function api.Toggle() if window.Visible then return api.Hide() else return api.Show() end end
function api.SetScale(value) requestedScale=math.max(.1,tonumber(value) or 1); updateScale(); return api end
function api.GetScale() return scale.Scale end
function api.SetLogo(image) window.RuntimeBrandIcon.Image=tostring(image); return api end

local function componentHandle(props,prefix)
    local suffix=props.Type=="Toggle" and "Toggle1" or (props.Type=="ColorToggle" or props.Type=="ColorPicker") and "Toggle2" or props.Type=="IconToggle" and "Toggle3" or props.Type=="Input" and "Textbox" or props.Type=="MultiDropdown" and "Dropdown" or props.Type
    local id=prefix.."."..suffix
    local handle={Config=props,Id=id,ColorId=id..".Color"}
    function handle:Set(value) if props.Type=="ColorPicker" then return api.SetColor(id,value) end; return api.SetValue(id,value) end
    function handle:Get() if props.Type=="ColorPicker" then return api.GetColor(id) end; return api.GetValue(id) end
    function handle:SetColor(value) return api.SetColor(id,value) end
    function handle:GetColor() return api.GetColor(id) end
    function handle:SetDescription(text)
        props.Description=tostring(text or "")
        api.Apply()
        return self
    end
    function handle:SetName(name) props.Name=tostring(name); api.Apply(); return self end
    function handle:SetCallback(callback) assert(callback==nil or type(callback)=="function","Callback must be a function"); props.Callback=callback; api.Apply(); return self end
    function handle:SetOptions(options) assert(type(options)=="table","Options must be an array"); props.Options=table.clone(options); api.Apply(); return self end
    function handle:SetRange(minimum,maximum,step)
        assert(type(minimum)=="number" and type(maximum)=="number" and maximum>=minimum,"Invalid slider range")
        props.Min=minimum; props.Max=maximum; props.Step=step or props.Step; api.Apply(); return self
    end
    function handle:Configure(options) for key,value in pairs(options) do if key~="Id" and key~="Type" then props[key]=value end end; api.Apply(); return self end
    if props.Type=="IconToggle" then
        function handle:ConfigureSettings(options)
            props.SettingsConfig=props.SettingsConfig or {}
            for key,value in pairs(options or {}) do props.SettingsConfig[key]=value end
            api.Apply(); return self
        end
        function handle:SetSettings(components,options)
            assert(type(components)=="table","Settings components must be an array")
            props.Settings=components
            if options then props.SettingsConfig=options end
            api.Apply(); return self
        end
        function handle:ClearSettings() return self:SetSettings({}) end
        function handle:RemoveSetting(settingId)
            for index,component in ipairs(props.Settings or {}) do if component.Id==settingId then table.remove(props.Settings,index); api.Apply(); return true end end
            return false
        end
        function handle:OpenSettings() return settingsActions[id] and settingsActions[id].Open() or false end
        function handle:CloseSettings() return settingsActions[id] and settingsActions[id].Close() or false end
        function handle:ToggleSettings() return settingsActions[id] and settingsActions[id].Toggle() or false end
        function handle:AddComponent(settings)
            settings=settings or {}
            props.Settings=props.Settings or {}
            settings.Id=settings.Id or "setting"..(#props.Settings+1)
            table.insert(props.Settings,settings)
            api.Apply()
            return componentHandle(settings,prefix..".Settings."..settings.Id)
        end
        for _,kind in ipairs({"Toggle","Slider","Dropdown","MultiDropdown","ColorPicker","ColorToggle","Input","Button","Paragraph"}) do
            handle["Add"..kind]=function(self,settings) settings=settings or {}; settings.Type=kind; return self:AddComponent(settings) end
        end
    end
    return handle
end
local function sectionBuilder(tab,section)
    local builder={Config=section}
    function builder:AddComponent(props)
        assert(type(props)=="table","Component settings must be a table")
        props.Id=props.Id or "control"..(#section.Components+1)
        if props.Type=="IconToggle" and props.Settings==nil then props.Settings={} end
        table.insert(section.Components,props)
        api.Apply()
        return componentHandle(props,tab.Id.."."..section.Id.."."..props.Id)
    end
    for _,kind in ipairs({"Toggle","ColorToggle","IconToggle","Slider","Dropdown","MultiDropdown","ColorPicker","Input","Button","Paragraph"}) do
        builder["Add"..kind]=function(self,props)
            props=props or {}; props.Type=kind
            return self:AddComponent(props)
        end
    end
    return builder
end
function api:GetComponent(id)
    local function find(components,parentPrefix)
        for index,props in ipairs(components or {}) do
            local prefix=parentPrefix.."."..(props.Id or "control"..index)
            local handle=componentHandle(props,prefix)
            if id==prefix or id==handle.Id then return handle end
            local nested=find(props.Settings,prefix..".Settings")
            if nested then return nested end
        end
        return nil
    end
    for _,tab in ipairs(config.Tabs) do
        for index,section in ipairs(tab.LibrarySections or {}) do
            local handle=find(section.Components,tab.Id.."."..(section.Id or "section"..index))
            if handle then return handle end
        end
    end
    return nil
end
function api:GetTab(id)
    for _,tab in ipairs(config.Tabs) do
        if tab.Id==id or tab.Name==id then
            local builder={Config=tab}
            function builder:SetDescription(text)
                tab.Description=tostring(text or "")
                api.Apply()
                return self
            end
            function builder:AddSection(settings)
                settings=settings or {}
                tab.LibrarySections=tab.LibrarySections or {}
                settings.Id=settings.Id or "section"..(#tab.LibrarySections+1)
                settings.Name=settings.Name or "Section"
                settings.Components=settings.Components or {}
                table.insert(tab.LibrarySections,settings)
                api.Apply()
                return sectionBuilder(tab,settings)
            end
            return builder
        end
    end
    return nil
end
function api:AddTab(settings)
    settings=settings or {}
    settings.Id=settings.Id or "tab"..(#config.Tabs+1)
    assert(not self:GetTab(settings.Id),"Tab Id already exists")
    settings.Name=settings.Name or settings.Id
    settings.LibrarySections=settings.LibrarySections or {}
    table.insert(config.Tabs,settings)
    api.Apply()
    return self:GetTab(settings.Id)
end
local keySystemSpec=HttpService:JSONDecode([==[{"class":"ScreenGui","children":[{"class":"Frame","children":[{"class":"UICorner","children":[],"properties":{"Name":"UICorner","Archivable":true,"CornerRadius":{"value":[0,8],"type":"UDim"}}},{"class":"UIShadow","children":[],"properties":{"Enabled":true,"Transparency":0.5,"Name":"UIShadow","BlurRadius":{"value":[0,20],"type":"UDim"},"Color":{"value":[0,0,0],"type":"Color3"},"ZIndex":-1,"Archivable":true,"Offset":{"value":[0,0,0,0],"type":"UDim2"}}},{"class":"ImageLabel","children":[],"properties":{"ImageColor3":{"value":[1,1,1],"type":"Color3"},"Active":false,"AnchorPoint":{"value":[0,0],"type":"Vector2"},"Image":"rbxassetid://112658790795028","ImageRectSize":{"value":[0,0],"type":"Vector2"},"ZIndex":1,"Archivable":true,"Size":{"value":[0,47,0,42],"type":"UDim2"},"ScaleType":{"value":["ScaleType","Stretch"],"type":"EnumItem"},"ClipsDescendants":false,"Visible":true,"ImageTransparency":0,"Rotation":0,"ImageRectOffset":{"value":[0,0],"type":"Vector2"},"Name":"ImageLabel","Position":{"value":[0.022012578323483467,0,0.02601156011223793,0],"type":"UDim2"},"BackgroundTransparency":1,"AutomaticSize":{"value":["AutomaticSize","None"],"type":"EnumItem"},"BorderSizePixel":0,"BackgroundColor3":{"value":[1,1,1],"type":"Color3"}}},{"class":"TextLabel","children":[],"properties":{"Visible":true,"TextWrapped":false,"Active":false,"TextTransparency":0,"AnchorPoint":{"value":[0,0],"type":"Vector2"},"TextTruncate":{"value":["TextTruncate","None"],"type":"EnumItem"},"TextColor3":{"value":[0.7960785031318665,0.7960785031318665,0.7960785031318665],"type":"Color3"},"ZIndex":1,"Archivable":true,"Size":{"value":[0,114,0,50],"type":"UDim2"},"FontFace":{"value":["rbxasset://fonts/families/Roboto.json","Medium","Normal"],"type":"Font"},"RichText":false,"BackgroundTransparency":1,"ClipsDescendants":false,"BorderSizePixel":0,"Text":"Key System","TextXAlignment":{"value":["TextXAlignment","Center"],"type":"EnumItem"},"TextSize":22,"Rotation":0,"Name":"TextLabel","Position":{"value":[0.38666194677352905,0,0.17901727557182312,0],"type":"UDim2"},"AutomaticSize":{"value":["AutomaticSize","None"],"type":"EnumItem"},"TextYAlignment":{"value":["TextYAlignment","Center"],"type":"EnumItem"},"TextScaled":false,"BackgroundColor3":{"value":[1,1,1],"type":"Color3"}}},{"class":"TextBox","children":[{"class":"UICorner","children":[],"properties":{"Name":"UICorner","Archivable":true,"CornerRadius":{"value":[0,8],"type":"UDim"}}},{"class":"UIShadow","children":[],"properties":{"Enabled":true,"Transparency":0.5,"Name":"UIShadow","BlurRadius":{"value":[0,20],"type":"UDim"},"Color":{"value":[0,0,0],"type":"Color3"},"ZIndex":-1,"Archivable":true,"Offset":{"value":[0,0,0,0],"type":"UDim2"}}}],"properties":{"Visible":true,"TextWrapped":true,"Active":true,"TextTransparency":0,"TextColor3":{"value":[1,1,1],"type":"Color3"},"MultiLine":false,"AnchorPoint":{"value":[0,0],"type":"Vector2"},"ClearTextOnFocus":true,"PlaceholderColor3":{"value":[0.5,0.5,0.5],"type":"Color3"},"TextTruncate":{"value":["TextTruncate","None"],"type":"EnumItem"},"PlaceholderText":"Input Key...","ZIndex":1,"Archivable":true,"Size":{"value":[0,375,0,29],"type":"UDim2"},"FontFace":{"value":["rbxasset://fonts/families/SourceSansPro.json","Regular","Normal"],"type":"Font"},"RichText":false,"BackgroundTransparency":0,"ClipsDescendants":false,"BorderSizePixel":0,"Text":"","TextXAlignment":{"value":["TextXAlignment","Center"],"type":"EnumItem"},"TextSize":21,"Rotation":0,"Name":"TextBox","Position":{"value":[0.1293037086725235,0,0.33827465772628784,0],"type":"UDim2"},"AutomaticSize":{"value":["AutomaticSize","None"],"type":"EnumItem"},"TextYAlignment":{"value":["TextYAlignment","Center"],"type":"EnumItem"},"TextScaled":false,"BackgroundColor3":{"value":[0.06666667014360428,0.06666667014360428,0.06666667014360428],"type":"Color3"}}},{"class":"Frame","children":[{"class":"UICorner","children":[],"properties":{"Name":"UICorner","Archivable":true,"CornerRadius":{"value":[0,8],"type":"UDim"}}},{"class":"UIShadow","children":[],"properties":{"Enabled":true,"Transparency":0.5,"Name":"UIShadow","BlurRadius":{"value":[0,20],"type":"UDim"},"Color":{"value":[0,0,0],"type":"Color3"},"ZIndex":-1,"Archivable":true,"Offset":{"value":[0,0,0,0],"type":"UDim2"}}}],"properties":{"Visible":true,"BackgroundColor3":{"value":[0.07058823853731155,0.07058823853731155,0.07058823853731155],"type":"Color3"},"Active":false,"AutomaticSize":{"value":["AutomaticSize","None"],"type":"EnumItem"},"AnchorPoint":{"value":[0,0],"type":"Vector2"},"BorderSizePixel":0,"BackgroundTransparency":0,"Rotation":0,"Name":"Frame","Position":{"value":[0.1293037086725235,0,0.45422518253326416,0],"type":"UDim2"},"ClipsDescendants":false,"ZIndex":1,"Archivable":true,"Size":{"value":[0,182,0,28],"type":"UDim2"}}},{"class":"Frame","children":[{"class":"UICorner","children":[],"properties":{"Name":"UICorner","Archivable":true,"CornerRadius":{"value":[0,8],"type":"UDim"}}},{"class":"UIShadow","children":[],"properties":{"Enabled":true,"Transparency":0.5,"Name":"UIShadow","BlurRadius":{"value":[0,20],"type":"UDim"},"Color":{"value":[0,0,0],"type":"Color3"},"ZIndex":-1,"Archivable":true,"Offset":{"value":[0,0,0,0],"type":"UDim2"}}}],"properties":{"Visible":true,"BackgroundColor3":{"value":[0.07058823853731155,0.07058823853731155,0.07058823853731155],"type":"Color3"},"Active":false,"AutomaticSize":{"value":["AutomaticSize","None"],"type":"EnumItem"},"AnchorPoint":{"value":[0,0],"type":"Vector2"},"BorderSizePixel":0,"BackgroundTransparency":0,"Rotation":0,"Name":"Frame","Position":{"value":[0.5082655549049377,0,0.45422518253326416,0],"type":"UDim2"},"ClipsDescendants":false,"ZIndex":1,"Archivable":true,"Size":{"value":[0,183,0,28],"type":"UDim2"}}},{"class":"Frame","children":[{"class":"UICorner","children":[],"properties":{"Name":"UICorner","Archivable":true,"CornerRadius":{"value":[0,8],"type":"UDim"}}},{"class":"UIShadow","children":[],"properties":{"Enabled":true,"Transparency":0.5,"Name":"UIShadow","BlurRadius":{"value":[0,20],"type":"UDim"},"Color":{"value":[0,0,0],"type":"Color3"},"ZIndex":-1,"Archivable":true,"Offset":{"value":[0,0,0,0],"type":"UDim2"}}}],"properties":{"Visible":true,"BackgroundColor3":{"value":[0.07058823853731155,0.07058823853731155,0.07058823853731155],"type":"Color3"},"Active":false,"AutomaticSize":{"value":["AutomaticSize","None"],"type":"EnumItem"},"AnchorPoint":{"value":[0,0],"type":"Vector2"},"BorderSizePixel":0,"BackgroundTransparency":0,"Rotation":0,"Name":"Frame","Position":{"value":[0.1293037086725235,0,0.5747132301330566,0],"type":"UDim2"},"ClipsDescendants":false,"ZIndex":1,"Archivable":true,"Size":{"value":[0,375,0,28],"type":"UDim2"}}},{"class":"TextLabel","children":[],"properties":{"Visible":true,"TextWrapped":false,"Active":false,"TextTransparency":0,"AnchorPoint":{"value":[0,0],"type":"Vector2"},"TextTruncate":{"value":["TextTruncate","None"],"type":"EnumItem"},"TextColor3":{"value":[0.7960785031318665,0.7960785031318665,0.7960785031318665],"type":"Color3"},"ZIndex":1,"Archivable":true,"Size":{"value":[0,114,0,50],"type":"UDim2"},"FontFace":{"value":["rbxasset://fonts/families/Roboto.json","Medium","Normal"],"type":"Font"},"RichText":false,"BackgroundTransparency":1,"ClipsDescendants":false,"BorderSizePixel":0,"Text":"Verify Key","TextXAlignment":{"value":["TextXAlignment","Center"],"type":"EnumItem"},"TextSize":15,"Rotation":0,"Name":"TextLabel","Position":{"value":[0.19619280099868774,0,0.41925862431526184,0],"type":"UDim2"},"AutomaticSize":{"value":["AutomaticSize","None"],"type":"EnumItem"},"TextYAlignment":{"value":["TextYAlignment","Center"],"type":"EnumItem"},"TextScaled":false,"BackgroundColor3":{"value":[1,1,1],"type":"Color3"}}},{"class":"TextLabel","children":[],"properties":{"Visible":true,"TextWrapped":false,"Active":false,"TextTransparency":0,"AnchorPoint":{"value":[0,0],"type":"Vector2"},"TextTruncate":{"value":["TextTruncate","None"],"type":"EnumItem"},"TextColor3":{"value":[0.7960785031318665,0.7960785031318665,0.7960785031318665],"type":"Color3"},"ZIndex":1,"Archivable":true,"Size":{"value":[0,114,0,50],"type":"UDim2"},"FontFace":{"value":["rbxasset://fonts/families/Roboto.json","Medium","Normal"],"type":"Font"},"RichText":false,"BackgroundTransparency":1,"ClipsDescendants":false,"BorderSizePixel":0,"Text":"Get Key","TextXAlignment":{"value":["TextXAlignment","Center"],"type":"EnumItem"},"TextSize":15,"Rotation":0,"Name":"TextLabel","Position":{"value":[0.575558602809906,0,0.4188823401927948,0],"type":"UDim2"},"AutomaticSize":{"value":["AutomaticSize","None"],"type":"EnumItem"},"TextYAlignment":{"value":["TextYAlignment","Center"],"type":"EnumItem"},"TextScaled":false,"BackgroundColor3":{"value":[1,1,1],"type":"Color3"}}},{"class":"TextLabel","children":[],"properties":{"Visible":true,"TextWrapped":false,"Active":false,"TextTransparency":0,"AnchorPoint":{"value":[0,0],"type":"Vector2"},"TextTruncate":{"value":["TextTruncate","None"],"type":"EnumItem"},"TextColor3":{"value":[0.7960785031318665,0.7960785031318665,0.7960785031318665],"type":"Color3"},"ZIndex":1,"Archivable":true,"Size":{"value":[0,114,0,50],"type":"UDim2"},"FontFace":{"value":["rbxasset://fonts/families/Roboto.json","Medium","Normal"],"type":"Font"},"RichText":false,"BackgroundTransparency":1,"ClipsDescendants":false,"BorderSizePixel":0,"Text":"Buy Premium","TextXAlignment":{"value":["TextXAlignment","Center"],"type":"EnumItem"},"TextSize":15,"Rotation":0,"Name":"TextLabel","Position":{"value":[0.38706591725349426,0,0.5397467613220215,0],"type":"UDim2"},"AutomaticSize":{"value":["AutomaticSize","None"],"type":"EnumItem"},"TextYAlignment":{"value":["TextYAlignment","Center"],"type":"EnumItem"},"TextScaled":false,"BackgroundColor3":{"value":[1,1,1],"type":"Color3"}}},{"class":"Frame","children":[{"class":"UICorner","children":[],"properties":{"Name":"UICorner","Archivable":true,"CornerRadius":{"value":[0,8],"type":"UDim"}}},{"class":"UIShadow","children":[],"properties":{"Enabled":true,"Transparency":0.5,"Name":"UIShadow","BlurRadius":{"value":[0,20],"type":"UDim"},"Color":{"value":[0.12941177189350128,0.12941177189350128,0.12941177189350128],"type":"Color3"},"ZIndex":-1,"Archivable":true,"Offset":{"value":[0,0,0,0],"type":"UDim2"}}}],"properties":{"Visible":true,"BackgroundColor3":{"value":[0,0,0],"type":"Color3"},"Active":false,"AutomaticSize":{"value":["AutomaticSize","None"],"type":"EnumItem"},"AnchorPoint":{"value":[0,0],"type":"Vector2"},"BorderSizePixel":0,"BackgroundTransparency":0,"Rotation":0,"Name":"Frame","Position":{"value":[0.3224948048591614,0,0.6921278238296509,0],"type":"UDim2"},"ClipsDescendants":false,"ZIndex":1,"Archivable":true,"Size":{"value":[0,23,0,22],"type":"UDim2"}}},{"class":"TextLabel","children":[],"properties":{"Visible":true,"TextWrapped":false,"Active":false,"TextTransparency":0,"AnchorPoint":{"value":[0,0],"type":"Vector2"},"TextTruncate":{"value":["TextTruncate","None"],"type":"EnumItem"},"TextColor3":{"value":[0.7960785031318665,0.7960785031318665,0.7960785031318665],"type":"Color3"},"ZIndex":1,"Archivable":true,"Size":{"value":[0,66,0,29],"type":"UDim2"},"FontFace":{"value":["rbxasset://fonts/families/Roboto.json","Medium","Normal"],"type":"Font"},"RichText":false,"BackgroundTransparency":1,"ClipsDescendants":false,"BorderSizePixel":0,"Text":"Save Key","TextXAlignment":{"value":["TextXAlignment","Center"],"type":"EnumItem"},"TextSize":15,"Rotation":0,"Name":"TextLabel","Position":{"value":[0.3668991029262543,0,0.6806045770645142,0],"type":"UDim2"},"AutomaticSize":{"value":["AutomaticSize","None"],"type":"EnumItem"},"TextYAlignment":{"value":["TextYAlignment","Center"],"type":"EnumItem"},"TextScaled":false,"BackgroundColor3":{"value":[1,1,1],"type":"Color3"}}},{"class":"Frame","children":[{"class":"UICorner","children":[],"properties":{"Name":"UICorner","Archivable":true,"CornerRadius":{"value":[0,8],"type":"UDim"}}},{"class":"UIShadow","children":[],"properties":{"Enabled":true,"Transparency":0.5,"Name":"UIShadow","BlurRadius":{"value":[0,20],"type":"UDim"},"Color":{"value":[0.12941177189350128,0.12941177189350128,0.12941177189350128],"type":"Color3"},"ZIndex":-1,"Archivable":true,"Offset":{"value":[0,0,0,0],"type":"UDim2"}}}],"properties":{"Visible":true,"BackgroundColor3":{"value":[0,0,0],"type":"Color3"},"Active":false,"AutomaticSize":{"value":["AutomaticSize","None"],"type":"EnumItem"},"AnchorPoint":{"value":[0,0],"type":"Vector2"},"BorderSizePixel":0,"BackgroundTransparency":0,"Rotation":0,"Name":"Frame","Position":{"value":[0.5082655549049377,0,0.6921278238296509,0],"type":"UDim2"},"ClipsDescendants":false,"ZIndex":1,"Archivable":true,"Size":{"value":[0,23,0,22],"type":"UDim2"}}},{"class":"TextLabel","children":[],"properties":{"Visible":true,"TextWrapped":false,"Active":false,"TextTransparency":0,"AnchorPoint":{"value":[0,0],"type":"Vector2"},"TextTruncate":{"value":["TextTruncate","None"],"type":"EnumItem"},"TextColor3":{"value":[0.7960785031318665,0.7960785031318665,0.7960785031318665],"type":"Color3"},"ZIndex":1,"Archivable":true,"Size":{"value":[0,66,0,29],"type":"UDim2"},"FontFace":{"value":["rbxasset://fonts/families/Roboto.json","Medium","Normal"],"type":"Font"},"RichText":false,"BackgroundTransparency":1,"ClipsDescendants":false,"BorderSizePixel":0,"Text":"Auto Load","TextXAlignment":{"value":["TextXAlignment","Center"],"type":"EnumItem"},"TextSize":15,"Rotation":0,"Name":"TextLabel","Position":{"value":[0.5640000104904175,0,0.6779999732971191,0],"type":"UDim2"},"AutomaticSize":{"value":["AutomaticSize","None"],"type":"EnumItem"},"TextYAlignment":{"value":["TextYAlignment","Center"],"type":"EnumItem"},"TextScaled":false,"BackgroundColor3":{"value":[1,1,1],"type":"Color3"}}}],"properties":{"Visible":true,"BackgroundColor3":{"value":[0.05098039656877518,0.05098039656877518,0.05098039656877518],"type":"Color3"},"Active":false,"AutomaticSize":{"value":["AutomaticSize","None"],"type":"EnumItem"},"AnchorPoint":{"value":[0,0],"type":"Vector2"},"BorderSizePixel":0,"BackgroundTransparency":0,"Rotation":0,"Name":"Frame","Position":{"value":[0.3116861879825592,0,0.35735294222831726,0],"type":"UDim2"},"ClipsDescendants":false,"ZIndex":1,"Archivable":true,"Size":{"value":[0,506,0,315],"type":"UDim2"}}}],"properties":{"Enabled":true,"Name":"ScreenGui","DisplayOrder":0,"ResetOnSpawn":true,"IgnoreGuiInset":false,"Archivable":true,"ZIndexBehavior":{"value":["ZIndexBehavior","Sibling"],"type":"EnumItem"}}}]==])

local keySystems={}
local keySystemCount=0
local function createV3KeyStorage(options, storeId)
    if options.Storage then return options.Storage end
    local path = "R1nHUb/Key/key.txt"
    return {
        Read = function()
            if type(readfile) ~= "function" then return nil end
            local ok, text = pcall(readfile,path)
            if not ok then return nil end
            if type(text) ~= "string" or text == "" then return nil end
            return {
                SaveKey=true,
                AutoLoad=true,
                Key=text,
            }
        end,
        Write = function(record)
            if type(writefile) ~= "function" then error("Local key storage is unavailable.") end
            for _, folder in ipairs({"R1nHUb", "R1nHUb/Key"}) do
                if type(isfolder) == "function" and not isfolder(folder) and type(makefolder) == "function" then makefolder(folder) end
            end
            writefile(path,record.SaveKey==true and type(record.Key)=="string" and record.Key or "")
        end,
    }
end

function api:CreateKeySystem(options)
    options=options or {}
    keySystemCount+=1
    local configKey=table.clone(options)
    local keyGui=rebuild(keySystemSpec)
    keyGui.Name="R1nKeySystem"..keySystemCount
    keyGui.ResetOnSpawn=false
    keyGui.DisplayOrder=gui.DisplayOrder+10
    local keyWindow=keyGui:FindFirstChildWhichIsA("Frame")
    keyWindow.Name="KeySystemWindow"
    keyWindow.AnchorPoint=Vector2.new(.5,.5)
    keyWindow.Position=UDim2.fromScale(.5,.5)
    keyWindow.Active=true
    local keyScale=Instance.new("UIScale")
    keyScale.Name="ResponsiveScale"; keyScale.Parent=keyWindow
    local localConnections={}
    local disposed,busy=false,false
    local dragging,dragInput,startPointer,startPosition
    local preferences={SaveKey=options.SaveKey~=false,AutoLoad=options.AutoLoad~=false}
    local storeId=tostring(options.StorageId or "default")
    configKey.Storage=createV3KeyStorage(configKey,storeId)
    env.R1nUIKeyStore=type(env.R1nUIKeyStore)=="table" and env.R1nUIKeyStore or {}
    local verified=Instance.new("BindableEvent")
    verified.Name="Verified"; verified.Parent=keyGui
    local events=Instance.new("BindableEvent")
    events.Name="Changed"; events.Parent=keyGui
    local labels={}
    local keyInput=keyWindow:FindFirstChildWhichIsA("TextBox")
    keyInput.Name="KeyInput"
    keyInput.ClearTextOnFocus=false
    for _,child in ipairs(keyWindow:GetChildren()) do if child:IsA("TextLabel") then labels[child.Text]=child end end
    local title=labels["Key System"]
    title.Name="Title"
    local status=Instance.new("TextLabel")
    status.Name="Status"; status.BackgroundTransparency=1
    status.Position=UDim2.new(.1293037,0,.82,0)
    status.Size=UDim2.fromOffset(375,34)
    status.FontFace=uiFont; status.TextSize=13
    status.TextColor3=dim; status.Text=""; status.TextWrapped=true
    status.TextYAlignment=Enum.TextYAlignment.Top
    status.Parent=keyWindow
    local controller={Gui=keyGui,Window=keyWindow,Config=configKey,Verified=verified.Event,Changed=events.Event}
    local function on(signal,callback) table.insert(localConnections,signal:Connect(callback)) end
    local function setStatus(text,success)
        status.Text=tostring(text or "")
        status.TextColor3=success==true and Color3.fromRGB(125,192,151) or success==false and Color3.fromRGB(228,135,135) or dim
    end
    local function bounds()
        local viewport=keyGui.AbsoluteSize
        if viewport.X<=0 or viewport.Y<=0 then return windowViewport() end
        return viewport
    end
    local fitting=false
    local function fit()
        if disposed or fitting then return end
        fitting=true
        local viewport=bounds()
        keyScale.Scale=math.max(.01,math.min(tonumber(configKey.Scale) or 1,1.4,(viewport.X-16)/506,(viewport.Y-16)/315))
        local half=Vector2.new(506,315)*keyScale.Scale/2
        local position=keyWindow.Position
        keyWindow.Position=UDim2.fromOffset(
            math.clamp(viewport.X*position.X.Scale+position.X.Offset,half.X+8,math.max(half.X+8,viewport.X-half.X-8)),
            math.clamp(viewport.Y*position.Y.Scale+position.Y.Offset,half.Y+8,math.max(half.Y+8,viewport.Y-half.Y-8)))
        fitting=false
    end
    local function persist()
        local record={SaveKey=preferences.SaveKey,AutoLoad=preferences.AutoLoad,Key=preferences.SaveKey and keyInput.Text or nil}
        env.R1nUIKeyStore[storeId]=record
        if configKey.Storage and type(configKey.Storage.Write)=="function" then
            local ok,message=pcall(configKey.Storage.Write,record)
            controller.LastStorageError=not ok and tostring(message) or nil
            return ok,message
        end
        return true
    end
    local loaded=env.R1nUIKeyStore[storeId]
    if configKey.Storage and type(configKey.Storage.Read)=="function" then
        local ok,value=pcall(configKey.Storage.Read)
        if ok and type(value)=="table" then loaded=value end
    end
    if type(loaded)=="table" then
        if options.SaveKey==nil then preferences.SaveKey=loaded.SaveKey==true end
        if options.AutoLoad==nil then preferences.AutoLoad=loaded.AutoLoad==true end
    end
    keyInput.Text=options.Key or (preferences.SaveKey and type(loaded)=="table" and type(loaded.Key)=="string" and loaded.Key) or ""
    local buttons={}
    local function buttonFrame(label)
        local center=sourcePosition(label)
        
        center=Vector2.new(label.Position.X.Scale*506+label.Position.X.Offset+label.Size.X.Offset/2,label.Position.Y.Scale*315+label.Position.Y.Offset+label.Size.Y.Offset/2)
        local best,distance
        for _,child in ipairs(keyWindow:GetChildren()) do
            if child:IsA("Frame") and child.Size.X.Offset>=180 then
                local p=Vector2.new(child.Position.X.Scale*506+child.Position.X.Offset+child.Size.X.Offset/2,child.Position.Y.Scale*315+child.Position.Y.Offset+child.Size.Y.Offset/2)
                local d=(p-center).Magnitude
                if not distance or d<distance then best=child; distance=d end
            end
        end
        return best
    end
    local function attachButton(role,label,callback)
        local frame=buttonFrame(label)
        local button=Instance.new("TextButton")
        button.Name=role.."Button"
        button.Position=frame.Position; button.Size=frame.Size
        button.Text=""; button.BackgroundTransparency=1; button.AutoButtonColor=false
        button.ZIndex=5; button.Parent=keyWindow
        buttons[role]=button
        local original=frame.BackgroundColor3
        local flash=0
        on(button.Activated,function()
            flash+=1
            local token=flash
            animate(frame,{BackgroundColor3=Color3.fromRGB(36,40,51)},.06)
            task.delay(.1,function() if not disposed and token==flash then animate(frame,{BackgroundColor3=original},.18) end end)
            callback()
        end)
        fitFixedText(label)
    end
    local optionDraw={}
    local function attachOption(role,label)
        local targetX=role=="SaveKey" and .3224948 or .50826555
        local frame
        for _,child in ipairs(keyWindow:GetChildren()) do
            if child:IsA("Frame") and child.Size.X.Offset==23 and math.abs(child.Position.X.Scale-targetX)<.001 then frame=child; break end
        end
        local x=role=="SaveKey" and 144 or 259
        local labelWidth=role=="SaveKey" and 66 or 72
        frame.Name=role.."Checkbox"
        frame.Position=UDim2.fromOffset(x,218)
        frame.Size=UDim2.fromOffset(23,23)
        local corner=frame:FindFirstChildWhichIsA("UICorner")
        if corner then corner.CornerRadius=UDim.new(0,7) end
        label.Position=UDim2.fromOffset(x+31,215)
        label.Size=UDim2.fromOffset(labelWidth,29)
        label.TextXAlignment=Enum.TextXAlignment.Left
        label.TextYAlignment=Enum.TextYAlignment.Center
        label.TextSize=15
        local check=Instance.new("CanvasGroup")
        check.Name=role.."Check"
        check.BackgroundTransparency=1
        check.AnchorPoint=Vector2.new(.5,.5)
        check.Position=UDim2.fromScale(.5,.5)
        check.Size=UDim2.fromOffset(16,16)
        check.GroupTransparency=1
        check.ZIndex=2
        check.Parent=frame
        local iconScale=Instance.new("UIScale")
        iconScale.Name="IconScale"; iconScale.Scale=.65; iconScale.Parent=check
        for _,shape in ipairs({{"Short",4,10,7,4,45},{"Long",9,8,13,4,-45}}) do
            local segment=Instance.new("Frame")
            segment.Name=shape[1]
            segment.AnchorPoint=Vector2.new(.5,.5)
            segment.Position=UDim2.fromOffset(shape[2],shape[3])
            segment.Size=UDim2.fromOffset(shape[4],shape[5])
            segment.Rotation=shape[6]
            segment.BackgroundColor3=Color3.new(0,0,0)
            segment.BorderSizePixel=0; segment.ZIndex=3; segment.Parent=check
            local rounded=Instance.new("UICorner")
            rounded.CornerRadius=UDim.new(1,0); rounded.Parent=segment
        end
        local button=Instance.new("TextButton")
        button.Name=role.."Button"
        button.Position=UDim2.fromOffset(x,215)
        button.Size=UDim2.fromOffset(31+labelWidth,29)
        button.Text=""; button.BackgroundTransparency=1; button.ZIndex=5; button.Parent=keyWindow
        local backgroundTween,fadeTween,popTween
        optionDraw[role]=function()
            local enabled=preferences[role]
            if backgroundTween then backgroundTween:Cancel() end
            if fadeTween then fadeTween:Cancel() end
            if popTween then popTween:Cancel() end
            backgroundTween=TweenService:Create(frame,TweenInfo.new(.18,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{BackgroundColor3=enabled and Color3.fromRGB(111,132,199) or Color3.new(0,0,0)})
            fadeTween=TweenService:Create(check,TweenInfo.new(.13),{GroupTransparency=enabled and 0 or 1})
            if enabled then iconScale.Scale=.55 end
            popTween=TweenService:Create(iconScale,TweenInfo.new(enabled and .24 or .14,enabled and Enum.EasingStyle.Back or Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Scale=enabled and 1 or .65})
            backgroundTween:Play(); fadeTween:Play(); popTween:Play()
        end
        on(button.Activated,function()
            preferences[role]=not preferences[role]
            optionDraw[role]()
            persist()
            events:Fire(role,preferences[role])
        end)
        optionDraw[role]()
    end
    function controller:Verify()
        if disposed or busy then return false,"Verification already running." end
        local key=keyInput.Text:match("^%s*(.-)%s*$")
        if key=="" then setStatus("Enter a key first.",false); return false,"Empty key" end
        if type(configKey.Verify)~="function" then setStatus("Key verification is not configured.",false); return false,"No verifier" end
        busy=true
        labels["Verify Key"].Text="Checking..."
        setStatus("Checking key...")
        local ok,valid,message=pcall(configKey.Verify,key,self)
        if disposed then return false,"Closed" end
        busy=false
        labels["Verify Key"].Text=configKey.VerifyText or "Verify Key"
        if not ok then setStatus("Unable to verify the key. Try again.",false); return false,"Verification error" end
        valid=valid==true
        setStatus(message or (valid and "Key verified." or "Invalid key."),valid)
        if valid then
            persist()
            verified:Fire(key)
            if type(configKey.OnVerified)=="function" then pcall(configKey.OnVerified,key,self) end
            if configKey.ShowMainOnSuccess then api.Show() end
            if configKey.CloseOnSuccess~=false then self:Hide() end
        end
        return valid,message
    end
    local function linkAction(callback,url,message)
        if type(callback)=="function" then
            local ok,result=pcall(callback,controller)
            if not ok then setStatus("Unable to complete this action.",false) elseif type(result)=="string" then setStatus(result) end
        elseif type(url)=="string" and url~="" and type(setclipboard)=="function" then
            setclipboard(url); setStatus(message)
        else setStatus("This action is not configured.",false) end
    end
    attachButton("Verify",labels["Verify Key"],function() task.spawn(function() controller:Verify() end) end)
    attachButton("GetKey",labels["Get Key"],function() linkAction(configKey.OnGetKey,configKey.KeyURL,"Key link copied.") end)
    attachButton("Premium",labels["Buy Premium"],function() linkAction(configKey.OnPremium,configKey.PremiumURL,"Premium link copied.") end)
    attachOption("SaveKey",labels["Save Key"])
    attachOption("AutoLoad",labels["Auto Load"])
    function controller:Show() if disposed then return false end; keyGui.Enabled=true; keyWindow.Visible=true; fit(); if configKey.HideMain then api.Hide() end; return self end
    function controller:Hide() if disposed then return false end; keyGui.Enabled=false; dragging=false; return self end
    function controller:SetKey(value) keyInput.Text=tostring(value or ""); if preferences.SaveKey then persist() end; return self end
    function controller:GetKey() return keyInput.Text end
    function controller:SetVerifier(callback) assert(type(callback)=="function","Verify must be a function"); configKey.Verify=callback; return self end
    function controller:SetStatus(text,success) setStatus(text,success); return self end
    function controller:SetTitle(text) configKey.Title=tostring(text); title.Text=configKey.Title; return self end
    function controller:SetPlaceholder(text) keyInput.PlaceholderText=tostring(text); return self end
    function controller:SetScale(value) configKey.Scale=tonumber(value) or 1; fit(); return self end
    function controller:SetSaveKey(value) preferences.SaveKey=value==true; optionDraw.SaveKey(); persist(); return self end
    function controller:SetAutoLoad(value) preferences.AutoLoad=value==true; optionDraw.AutoLoad(); persist(); return self end
    function controller:GetSettings() return {SaveKey=preferences.SaveKey,AutoLoad=preferences.AutoLoad} end
    function controller:Configure(settings)
        for key,value in pairs(settings or {}) do configKey[key]=value end
        title.Text=configKey.Title or "Key System"
        keyInput.PlaceholderText=configKey.Placeholder or "Input Key..."
        labels["Verify Key"].Text=configKey.VerifyText or "Verify Key"
        labels["Get Key"].Text=configKey.GetKeyText or "Get Key"
        labels["Buy Premium"].Text=configKey.PremiumText or "Buy Premium"
        fit()
        return self
    end
    function controller:Destroy()
        if disposed then return end
        disposed=true; dragging=false
        for _,connection in ipairs(localConnections) do connection:Disconnect() end
        keySystems[self]=nil
        keyGui:Destroy()
    end
    on(keyInput:GetPropertyChangedSignal("Text"),function() if preferences.SaveKey then persist() end end)
    on(keyInput.FocusLost,function(enter) if enter then task.spawn(function() controller:Verify() end) end end)
    on(keyWindow.InputBegan,function(input)
        if input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch then return end
        if input.Position.Y>keyWindow.AbsolutePosition.Y+60*keyScale.Scale then return end
        dragging=true; dragInput=input; startPointer=input.Position; startPosition=keyWindow.Position
    end)
    on(UserInputService.InputChanged,function(input)
        if not dragging or input~=dragInput and input.UserInputType~=Enum.UserInputType.MouseMovement then return end
        local delta=input.Position-startPointer
        keyWindow.Position=UDim2.fromOffset(startPosition.X.Offset+delta.X,startPosition.Y.Offset+delta.Y)
        fit()
    end)
    on(UserInputService.InputEnded,function(input) if input==dragInput or input.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end end)
    on(UserInputService.WindowFocusReleased,function() dragging=false end)
    on(keyGui:GetPropertyChangedSignal("AbsoluteSize"),fit)
    on(keyWindow:GetPropertyChangedSignal("Position"),fit)
    on(keyGui.Destroying,function() controller:Destroy() end)
    keySystems[controller]=true
    STATE.onCleanup(function() controller:Destroy() end)
    local ok=pcall(function() keyGui.Parent=CoreGui end)
    if not ok then keyGui.Parent=Players.LocalPlayer:WaitForChild("PlayerGui") end
    controller:Configure(options)
    if options.Visible==false then controller:Hide() else controller:Show() end
    if preferences.AutoLoad and keyInput.Text~="" and type(configKey.Verify)=="function" then task.defer(function() controller:Verify() end) end
    return controller
end
function api:CloseKeySystems()
    local list={}
    for controller in pairs(keySystems) do table.insert(list,controller) end
    for _,controller in ipairs(list) do controller:Destroy() end
end

local function installV3WindowControls(UI)
    if UI.FloatingToggle and UI.FloatingToggle.Parent then
        if UI.FitToScreen then UI.FitToScreen() end
        return
    end
    local Input = game:GetService("UserInputService")
    local main, panel = UI.Gui, UI.Window
    local links = {}
    local disposed, resizing = false, false
    local function link(signal, callback)
        table.insert(links, signal:Connect(callback))
    end
    local root = Instance.new("ScreenGui")
    root.Name = "R1nUIv3FloatingToggle"
    root.ResetOnSpawn = false
    root.IgnoreGuiInset = main.IgnoreGuiInset
    root.DisplayOrder = math.min(2147483647, main.DisplayOrder+1)
    root.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    root.Enabled = main.Enabled
    root.Parent = main.Parent
    local button = Instance.new("ImageButton")
    button.Name = "FloatingToggle"
    button.BackgroundColor3 = Color3.fromRGB(15,15,18)
    button.BorderSizePixel = 0
    button.AutoButtonColor = false
    button.Image = ""
    button.Active = true
    button.Position = UDim2.new(0,12,0.5,-28)
    button.Size = UDim2.fromOffset(56,56)
    button.Parent = root
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1,0)
    corner.Parent = button
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(45,48,58)
    stroke.Transparency = .2
    stroke.Thickness = 1
    stroke.Parent = button
    local icon = Instance.new("ImageLabel")
    icon.Name = "WindowIcon"
    icon.BackgroundTransparency = 1
    icon.AnchorPoint = Vector2.new(.5,.5)
    icon.Position = UDim2.fromScale(.5,.5)
    icon.Size = UDim2.fromScale(.66,.66)
    icon.ScaleType = Enum.ScaleType.Fit
    icon.Parent = button
    local brand = panel:FindFirstChild("RuntimeBrandIcon")
    local function syncIcon()
        if brand then
            icon.Image = brand.Image
            icon.ImageColor3 = brand.ImageColor3
            icon.ImageRectOffset = brand.ImageRectOffset
            icon.ImageRectSize = brand.ImageRectSize
        end
    end
    syncIcon()
    if brand then
        for _, property in ipairs({"Image","ImageColor3","ImageRectOffset","ImageRectSize"}) do link(brand:GetPropertyChangedSignal(property),syncIcon) end
    end
    local function viewport()
        local size = root.AbsoluteSize
        if size.X>0 and size.Y>0 then return size end
        local camera = workspace.CurrentCamera
        return camera and camera.ViewportSize or Vector2.new(1280,720)
    end
    local function fitButton()
        local size = viewport()
        local diameter = math.min(math.clamp(math.min(size.X,size.Y)*.085,48,64),math.max(1,math.min(size.X,size.Y)-16))
        button.Size = UDim2.fromOffset(diameter,diameter)
        local p = button.Position
        button.Position = UDim2.fromOffset(
            math.clamp(p.X.Scale*size.X+p.X.Offset,8,math.max(8,size.X-diameter-8)),
            math.clamp(p.Y.Scale*size.Y+p.Y.Offset,8,math.max(8,size.Y-diameter-8)))
    end
    local function fitWindow()
        if disposed or resizing then return end
        resizing = true
        local size = viewport()
        local width,height = math.max(1,panel.Size.X.Offset),math.max(1,panel.Size.Y.Offset)
        UI.SetScale(math.max(.01,math.min(1.6,size.X*.92/width,size.Y*.88/height)))
        fitButton()
        resizing = false
    end
    link(root:GetPropertyChangedSignal("AbsoluteSize"),fitWindow)
    link(main:GetPropertyChangedSignal("Enabled"),function() root.Enabled=main.Enabled end)
    link(main.AncestryChanged,function() if not disposed then root.Parent=main.Parent end end)
    local cameraLink
    local function bindCamera()
        if cameraLink then cameraLink:Disconnect() end
        local camera = workspace.CurrentCamera
        cameraLink = camera and camera:GetPropertyChangedSignal("ViewportSize"):Connect(fitWindow)
        fitWindow()
    end
    link(workspace:GetPropertyChangedSignal("CurrentCamera"),bindCamera)
    local drag, moved, suppressUntil = nil,false,0
    link(button.InputBegan,function(input)
        if drag or (input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch) then return end
        drag = {Input=input,Pointer=input.Position,Position=button.Position}
        moved = false
    end)
    link(Input.InputChanged,function(input)
        if not drag then return end
        if drag.Input.UserInputType==Enum.UserInputType.Touch then
            if input~=drag.Input then return end
        elseif input.UserInputType~=Enum.UserInputType.MouseMovement then return end
        local delta = input.Position-drag.Pointer
        if delta.Magnitude>6 then moved=true end
        if not moved then return end
        local bounds = viewport()
        local start = drag.Position
        button.Position = UDim2.fromOffset(
            start.X.Scale*bounds.X+start.X.Offset+delta.X,
            start.Y.Scale*bounds.Y+start.Y.Offset+delta.Y)
        fitButton()
    end)
    link(Input.InputEnded,function(input)
        if not drag then return end
        if input~=drag.Input and not (drag.Input.UserInputType==Enum.UserInputType.MouseButton1 and input.UserInputType==Enum.UserInputType.MouseButton1) then return end
        if moved then suppressUntil=os.clock()+.25 end
        drag = nil
    end)
    link(Input.WindowFocusReleased,function() drag=nil; moved=false; suppressUntil=os.clock()+.25 end)
    link(button.Activated,function()
        if moved or os.clock()<suppressUntil then return end
        UI.Toggle()
    end)
    local function cleanup()
        if disposed then return end
        disposed = true
        for _, connection in ipairs(links) do connection:Disconnect() end
        if cameraLink then cameraLink:Disconnect() end
        root:Destroy()
    end
    link(main.Destroying,cleanup)
    UI.FloatingToggle = button
    UI.FloatingGui = root
    UI.FitToScreen = fitWindow
    bindCamera()
end

function api:CreateWindow(options)
    options=options or {}
    if options.Clear~=false then
        config.Tabs={}
        table.clear(values)
        gui:SetAttribute("SelectedTab",nil)
    end
    gui.Name=tostring(options.Name or "R1nUIv3")
    if options.Logo then self.SetLogo(options.Logo) end
    if options.Scale then self.SetScale(options.Scale) end
    self.Apply()
    if options.Visible==false then self.Hide() else self.Show() end
    installV3WindowControls(self)
    if self.FloatingGui then
        self.FloatingGui.Parent = gui.Parent
        self.FloatingGui.Enabled = gui.Enabled
    end
    return self
end
api.Version="3"
api.Window=window
local function createNotifications()

local env=((getgenv or getfenv) :: any)()
local TweenService=game:GetService("TweenService")
local TextService=game:GetService("TextService")
local Players=game:GetService("Players")
local previous=env.R1nUINotifications
if previous and type(previous.Destroy)=="function" then previous:Destroy() end

local Module={}
local active={}
local links={}
local disposed=false
local nextOrder=0
local font=Font.new("rbxasset://fonts/families/Roboto.json",Enum.FontWeight.Medium)
local colors={
    Info=Color3.fromRGB(111,132,199),
    Success=Color3.fromRGB(117,183,145),
    Warning=Color3.fromRGB(211,174,105),
    Error=Color3.fromRGB(210,119,130),
}
local function make(className,properties,parent)
    local object=Instance.new(className)
    for key,value in pairs(properties) do object[key]=value end
    object.Parent=parent
    return object
end
local function tween(object,properties,time)
    local animation=TweenService:Create(object,TweenInfo.new(time or .22,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),properties)
    animation:Play()
    return animation
end
local root=make("ScreenGui",{Name="R1nNotifications",ResetOnSpawn=false,DisplayOrder=1100,ZIndexBehavior=Enum.ZIndexBehavior.Sibling},nil)
local parented=pcall(function() root.Parent=game:GetService("CoreGui") end)
if not parented then root.Parent=Players.LocalPlayer:WaitForChild("PlayerGui") end
local stack=make("Frame",{Name="NotificationStack",AnchorPoint=Vector2.new(1,1),Position=UDim2.new(1,-18,1,-18),Size=UDim2.new(0,320,1,-36),BackgroundTransparency=1,ClipsDescendants=false},root)
make("UIListLayout",{Padding=UDim.new(0,8),SortOrder=Enum.SortOrder.LayoutOrder,VerticalAlignment=Enum.VerticalAlignment.Bottom},stack)

local function notify(options)
    assert(not disposed,"The notification module was destroyed")
    if type(options)=="string" then options={Content=options} end
    options=table.clone(options or {})
    options.Content=options.Content or options.Message or options.Text or ""
    options.Title=options.Title or "R1n Hub"
    options.Duration=options.Duration==nil and 5 or math.max(0,tonumber(options.Duration) or 5)
    nextOrder+=1
    local closed=false
    local revision=0
    local timerRevision=0
    local timerTween
    local localConnections={}
    local holder=make("Frame",{Name="Notification"..nextOrder,BackgroundTransparency=1,Size=UDim2.fromOffset(320,76),LayoutOrder=nextOrder},stack)
    local card=make("CanvasGroup",{Name="Card",Size=UDim2.fromScale(1,1),Position=UDim2.new(1,24,0,0),BackgroundColor3=Color3.fromRGB(14,14,16),BorderSizePixel=0,GroupTransparency=1,ClipsDescendants=true},holder)
    make("UICorner",{CornerRadius=UDim.new(0,8)},card)
    make("UIStroke",{Color=Color3.fromRGB(38,39,45),Transparency=.4,Thickness=1},card)
    local accent=make("Frame",{Name="Accent",Position=UDim2.fromOffset(0,12),Size=UDim2.new(0,2,1,-24),BackgroundColor3=colors.Info,BorderSizePixel=0},card)
    make("UICorner",{CornerRadius=UDim.new(1,0)},accent)
    local defaultIcon="rbxassetid://112658790795028"
    local ui=env.R1nUI
    local brand=ui and ui.Gui and ui.Gui:FindFirstChild("RuntimeBrandIcon",true)
    if brand then defaultIcon=brand.Image end
    local icon=make("ImageLabel",{Name="Icon",Position=UDim2.fromOffset(14,14),Size=UDim2.fromOffset(24,24),Image=options.Icon or defaultIcon,BackgroundTransparency=1,ScaleType=Enum.ScaleType.Fit},card)
    local title=make("TextLabel",{Name="Title",Position=UDim2.fromOffset(49,11),Size=UDim2.fromOffset(235,22),BackgroundTransparency=1,FontFace=font,TextSize=15,TextScaled=true,TextWrapped=false,TextTruncate=Enum.TextTruncate.None,TextXAlignment=Enum.TextXAlignment.Left,TextColor3=Color3.fromRGB(228,230,238),Text=tostring(options.Title)},card)
    make("UITextSizeConstraint",{MinTextSize=1,MaxTextSize=15},title)
    local contentScroll=make("ScrollingFrame",{Name="Content",Position=UDim2.fromOffset(49,36),Size=UDim2.fromOffset(257,30),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=0,CanvasSize=UDim2.fromOffset(0,0),ScrollingDirection=Enum.ScrollingDirection.Y},card)
    local content=make("TextLabel",{Name="Message",BackgroundTransparency=1,FontFace=font,TextSize=13,TextWrapped=true,TextTruncate=Enum.TextTruncate.None,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,TextColor3=Color3.fromRGB(151,155,167),Text=tostring(options.Content),Size=UDim2.fromOffset(257,30)},contentScroll)
    local closeButton=make("TextButton",{Name="Close",Text="×",FontFace=font,TextSize=18,TextColor3=Color3.fromRGB(126,131,145),BackgroundTransparency=1,AutoButtonColor=false,AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,-6,0,6),Size=UDim2.fromOffset(24,24)},card)
    local progressTrack=make("Frame",{Name="LifetimeTrack",Position=UDim2.new(0,10,1,-2),Size=UDim2.new(1,-20,0,2),BackgroundColor3=Color3.fromRGB(24,26,33),BorderSizePixel=0},card)
    local progress=make("Frame",{Name="Lifetime",Size=UDim2.fromScale(1,1),BackgroundColor3=colors.Info,BorderSizePixel=0},progressTrack)
    local handle={Frame=holder,Config=options}
    local function on(signal,callback) table.insert(localConnections,signal:Connect(callback)) end
    function handle:Close()
        if closed then return false end
        closed=true; revision+=1; timerRevision+=1
        if timerTween then timerTween:Cancel() end
        local index=table.find(active,self)
        if index then table.remove(active,index) end
        for _,connection in ipairs(localConnections) do connection:Disconnect() end
        if not disposed and holder.Parent then
            tween(card,{GroupTransparency=1,Position=UDim2.new(1,24,0,0)},.18)
            task.delay(.16,function()
                if disposed or not holder.Parent then return end
                tween(holder,{Size=UDim2.fromOffset(holder.Size.X.Offset,0)},.14)
                task.delay(.15,function() if holder.Parent then holder:Destroy() end end)
            end)
        else holder:Destroy() end
        if type(options.OnClose)=="function" then task.spawn(options.OnClose) end
        return true
    end
    local function fit()
        if closed or disposed then return end
        revision+=1
        local token=revision
        local viewport=root.AbsoluteSize
        local width=math.clamp(tonumber(options.Width) or 320,180,math.max(180,viewport.X-36))
        if viewport.X<216 then width=math.max(1,viewport.X-16) end
        local textWidth=math.max(1,width-63)
        local params=Instance.new("GetTextBoundsParams")
        params.Text=content.Text~="" and content.Text or "A"
        params.Font=font; params.Size=13; params.Width=textWidth
        local ok,bounds=pcall(function() return TextService:GetTextBoundsAsync(params) end)
        params:Destroy()
        if closed or disposed or token~=revision then return end
        local textHeight=content.Text~="" and math.ceil(ok and bounds.Y or content.TextBounds.Y) or 0
        local shownHeight=math.min(textHeight,math.max(20,math.min(150,viewport.Y*.35-48)))
        holder.Size=UDim2.fromOffset(width,math.max(54,shownHeight+50))
        title.Size=UDim2.fromOffset(math.max(1,width-85),22)
        content.Size=UDim2.fromOffset(textWidth,textHeight)
        contentScroll.Size=UDim2.fromOffset(textWidth,shownHeight)
        contentScroll.CanvasSize=UDim2.fromOffset(0,textHeight)
        accent.BackgroundColor3=options.Color or colors[options.Type or "Info"] or colors.Info
        progress.BackgroundColor3=accent.BackgroundColor3
        icon.Image=options.Icon or defaultIcon
    end
    local function restartTimer()
        timerRevision+=1
        local token=timerRevision
        if timerTween then timerTween:Cancel() end
        progress.Size=UDim2.fromScale(1,1)
        local duration=math.max(0,tonumber(options.Duration) or 5)
        progressTrack.Visible=duration>0
        if duration<=0 then return end
        timerTween=TweenService:Create(progress,TweenInfo.new(duration,Enum.EasingStyle.Linear),{Size=UDim2.fromScale(0,1)})
        timerTween:Play()
        task.delay(duration,function() if not closed and not disposed and timerRevision==token then handle:Close() end end)
    end
    function handle:Update(changes)
        if closed or disposed then return false end
        if type(changes)=="string" then changes={Content=changes} end
        for key,value in pairs(changes or {}) do options[key]=value end
        if changes and changes.Message and not changes.Content then options.Content=changes.Message end
        title.Text=tostring(options.Title or "R1n Hub")
        content.Text=tostring(options.Content or "")
        task.spawn(fit)
        if changes and changes.Duration~=nil then restartTimer() end
        return self
    end
    on(closeButton.Activated,function() handle:Close() end)
    on(root:GetPropertyChangedSignal("AbsoluteSize"),function() task.spawn(fit) end)
    if type(options.OnClick)=="function" then
        on(card.InputBegan,function(input)
            if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then task.spawn(options.OnClick,handle) end
        end)
    end
    table.insert(active,handle)
    while #active>4 do active[1]:Close() end
    task.spawn(fit)
    tween(card,{GroupTransparency=0,Position=UDim2.fromOffset(0,0)},.28)
    restartTimer()
    return handle
end

function Module:Notify(options) return notify(options) end
function Module:Clear()
    local copy=table.clone(active)
    for _,handle in ipairs(copy) do handle:Close() end
end
function Module:Attach(ui)
    assert(type(ui)=="table","Pass the R1n UI library")
    local oldNotify,oldClear=ui.Notify,ui.ClearNotifications
    local function show(selfOrOptions,options)
        return notify(options or (selfOrOptions~=ui and selfOrOptions or {}))
    end
    local function clear() self:Clear() end
    ui.Notify=show; ui.ClearNotifications=clear
    table.insert(links,{UI=ui,Notify=show,Clear=clear,OldNotify=oldNotify,OldClear=oldClear})
    return ui
end
function Module:Destroy()
    if disposed then return end
    disposed=true
    for _,handle in ipairs(table.clone(active)) do handle:Close() end
    root:Destroy()
    for _,link in ipairs(links) do
        if link.UI.Notify==link.Notify then link.UI.Notify=link.OldNotify end
        if link.UI.ClearNotifications==link.Clear then link.UI.ClearNotifications=link.OldClear end
    end
    if env.R1nUINotifications==self then env.R1nUINotifications=nil end
end
env.R1nUINotifications=Module
if type(env.R1nUI)=="table" then Module:Attach(env.R1nUI) end
local hostState=STATE
if hostState and type(hostState.onCleanup)=="function" then hostState.onCleanup(function() Module:Destroy() end) end
return Module

end
local notifications=createNotifications()
notifications:Attach(api)
api.Notifications=notifications
installV3WindowControls(api)
function api.Destroy() destroyRuntime() end
config.Tabs={}
config.KeySystem={Enabled=false}
env.R1nUIConfig=config
env.R1nUI=api
apply()
gui.Enabled=false

gui:SetAttribute("Ready",true)
STATE.onCleanup(function()
    for _,connection in ipairs(connections) do connection:Disconnect() end
    if env.R1nUI==api then env.R1nUI=nil end
    gui:Destroy()
    for _,candidate in ipairs(hiddenMenus) do if candidate.Parent then candidate.Enabled=true end end
end)

return api
