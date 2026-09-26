--[[
    Aetherea (RIVALS) Fully Rebuilt Source Code
    Ported to LinoriaLib Framework
    Compatible with Roblox Studio & Custom Loaders
]]

local game_id = 6035872082

if getgenv().HI_I_HAVE_BALL_CANCER == true or game.GameId ~= game_id then
	return
end

pcall(function() getgenv().HI_I_HAVE_BALL_CANCER = true end)
if not game:IsLoaded() then game.Loaded:Wait() end

-- ==========================================
-- 1. LPH / Protection Stub Engine
-- ==========================================
if not LPH_OBFUSCATED then
	local DevApiKey = "ba17cd54606f49e16cee758e5930652b46128d6f09caf3dfa798e2b9bb8eaa44"
	local ScriptId = "43853841615976269471"

	LPH_ENCNUM = function(toEncrypt, ...) return toEncrypt end
	LPH_NUMENC = LPH_ENCNUM
	LPH_ENCSTR = function(toEncrypt, ...) return toEncrypt end
	LPH_STRENC = LPH_ENCSTR
	LPH_ENCFUNC = function(toEncrypt, encKey, decKey, ...) return toEncrypt end
	LPH_FUNCENC = LPH_ENCFUNC
	LPH_JIT = function(f, ...) return f end
	LPH_JIT_MAX = LPH_JIT
	LPH_NO_VIRTUALIZE = function(f, ...) return f end
	LPH_NO_UPVALUES = function(f, ...) return f end
	LPH_CRASH = function(...) error("LPH_CRASH called") end
	LP_BLACKLIST = function(s, ...) error("LP_BLACKLIST called: " .. tostring(s)) end
	LP_VMIFY = function(f, ...) return f end
	LP_INIT = function(f, ...) task.spawn(f) end

	LP_DISCORD = "unknown"
	LP_DISCORD_ID = 0
	LP_KEYNOTE = ""
	LP_EXECUTIONS = 1
	LP_SCRIPT_EXECUTIONS = 1
	LP_FINGERPRINT = gethwid and gethwid() or "unknown"
	LP_TIMELEFT = 0
	LP_PREMIUM = true
	LP_SCRIPT_NAME = "RIVALS"
	LP_SCRIPT_VERSION = 1
	LP_SESSION_ID = "unknown"
	LP_SESSION_COUNT = 1

	LP_SECURE_REQUEST = (http and http.request) or request
	LP_SAVE_VALUE = function(key, value, overwrite) end
	LP_GET_VALUE = function(key) end
	LP_DELETE_VALUE = function(key) end
end

-- ==========================================
-- 2. Service Management & Setup
-- ==========================================
local function GetService(name)
    local service = game:GetService(name)
    return cloneref and cloneref(service) or service
end

local services = {
    CoreGui = GetService("CoreGui"),
    MarketplaceService = GetService("MarketplaceService"),
    ReplicatedFirst = GetService("ReplicatedFirst"),
    ReplicatedStorage = GetService("ReplicatedStorage"),
    Players = GetService("Players"),
    SoundService = GetService("SoundService"),
    RunService = GetService("RunService"),
    GuiService = GetService("GuiService"),
    Lighting = GetService("Lighting"),
    CollectionService = GetService("CollectionService"),
    TweenService = GetService("TweenService"),
    UserInputService = GetService("UserInputService"),
    ScriptContext = GetService("ScriptContext"),
    HttpService = GetService("HttpService")
}

local LocalPlayer = services.Players.LocalPlayer
local LocalChar;

local function GetCharacter()
	local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	character:WaitForChild("Humanoid", 5)
	character:WaitForChild("HumanoidRootPart", 5)
	return character
end

LocalChar = GetCharacter()
LocalPlayer.CharacterAdded:Connect(function(char)
	LocalChar = char
	char:WaitForChild("Humanoid", 5)
	char:WaitForChild("HumanoidRootPart", 5)
end)

local TeleportCheck = false
LocalPlayer.OnTeleport:Connect(function()
	if (not TeleportCheck) and queueteleport then
		TeleportCheck = true
        local script = request({
            Url = "https://aetherea.lol/loader.luau",
            Method = "GET",
            Headers = { ["Content-Type"] = "application/json" }
        }).Body
        queueteleport(script)
	end
end)

-- ==========================================
-- 3. Anti-Cheat Bypass
-- ==========================================
pcall(LPH_NO_VIRTUALIZE(function()
    local bypassed = false
    local kKickNames = { "Kick", "kick" }
    local kProtectedProperties = { Enabled = true, Disabled = false }
    local kSlotMap = { [69] = 2, [138] = 3, [207] = 4, [276] = 5, [345] = 6, [414] = 7 }
    local kFilledSub = { 1, 2, 3, 4, 5 }

    local Players = cloneref(game:GetService("Players"))
    local ReplicatedFirst = cloneref(game:GetService("ReplicatedFirst"))
    local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
    local ScriptContext = cloneref(game:GetService("ScriptContext"))

    local LocalPlayer = Players.LocalPlayer
    local ac_script = ReplicatedFirst:WaitForChild("LocalScript3")
    local ac_event = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("RemoteEvent")

    local last = nil
    local first_seen = false
    local hijack_ready = false
    local client_id = ""
    local expected_interval = 0.6
    local min_interval = 0.25
    local ema_alpha = 0.5
    local samples = 0
    local hidden_fn = {}
    local max_stack_depth = 128

    if not setstackhidden then
        local function ValidTraceback(s)
            local dotPos = string.find(s, "%.")
            local colonPos = string.find(s, ":")
            if not dotPos then return false end
            if not colonPos then return true end
            return dotPos < colonPos
        end

        local function TracebackLines(str, lvl)
            local pos = lvl
            return function()
                if not pos then return nil end
                local p1, p2 = string.find(str, "\r?\n", pos)
                local line
                if p1 then line = str:sub(pos, p1 - 1); pos = p2 + 1
                else line = str:sub(pos); pos = nil end
                return line
            end
        end

        local old_dbg_traceback;
        old_dbg_traceback = hookfunction(getrenv().debug.traceback, function(...)
            if checkcaller() or not (pcall(old_dbg_traceback, ...)) then
                return old_dbg_traceback(...)
            end
            local StartingString, StackLevel = ...
            local Traceback = old_dbg_traceback(...)
            local NewTraceback = {}

            if typeof(StartingString) == "string" or typeof(StartingString) == "number" then
                table.insert(NewTraceback, tostring(StartingString))
            end

            StackLevel = (typeof(StackLevel) == "number" and tonumber(StackLevel)) and math.floor(tonumber(StackLevel)) or 1

            for Line in TracebackLines(Traceback, StackLevel) do
                if ValidTraceback(Line) then table.insert(NewTraceback, Line) end
            end
            return table.concat(NewTraceback, "\n") .. "\n"
        end)
    end

    setstackhidden = setstackhidden or function(fn_or_level, hidden)
        local ok, fn = pcall(function()
            if typeof(fn_or_level) == "number" then return debug.info(fn_or_level + 2, "f") end
            return fn_or_level
        end)
        if ok and fn then hidden_fn[fn] = not hidden end
    end

    local TrustedFunctions = setmetatable({}, { __mode = "k" })
    local function TrustFunction(fn)
        if type(fn) == "function" then TrustedFunctions[fn] = true end
        return fn
    end

    local SafeHook = function(hookfn, ...)
        local args = {...}
        local func, inst, metamethod, detour
        if hookfn == hookmetamethod then
            inst, metamethod, detour = args[1], args[2], args[3]
        else
            func, detour = args[1], args[2]
        end

        if (hookfn == hookfunction and iscclosure(func)) or not iscclosure(detour) then
            detour = newcclosure(detour)
        end
        setstackhidden(detour, true)

        local original_func
        local ok = pcall(function()
            TrustFunction(detour)
            if hookfn == hookmetamethod then original_func = hookfn(inst, metamethod, detour)
            else original_func = hookfn(func, detour) end
        end)

        if not ok then LocalPlayer:Kick("[AethSec]: Bypass failed! n1") end
        return original_func
    end

    local SafeCall = function(func, ...)
        if checkcaller() then return func(...) end
        local old = getthreadidentity()
        if old ~= 2 then setthreadidentity(2) end
        local result = {func(...)}
        if old ~= 2 then setthreadidentity(old) end
        return table.unpack(result)
    end

    local monitor_conn = ScriptContext.Error:Connect(TrustFunction(function(message, stack)
        if tostring(stack):find("PlayerScripts.Controllers.MiscellaneousController") and tostring(message):find("attempt to index number with number") then
            LocalPlayer:Kick("[AethSec]: Bypass failed! n2")
        end
    end))

    local oldindex; oldindex = SafeHook(hookmetamethod, ac_script, "__index", function(t, k)
        if t == ac_script and not (not bypassed and checkcaller()) and kProtectedProperties[k] ~= nil then
            return kProtectedProperties[k]
        end
        if checkcaller() then return oldindex(t, k) end
        return SafeCall(oldindex, t, k)
    end)

    local oldnewindex; oldnewindex = SafeHook(hookmetamethod, ac_script, "__newindex", function(t, k, v)
        if t == ac_script and not (not bypassed and checkcaller()) and kProtectedProperties[k] ~= nil then
            kProtectedProperties[k] = v
            if k == "Enabled" then kProtectedProperties["Disabled"] = not v end
            if k == "Disabled" then kProtectedProperties["Enabled"] = not v end
            return
        end
        if checkcaller() then return oldnewindex(t, k, v) end
        return SafeCall(oldnewindex, t, k, v)
    end)

    last = tick()
    local oldfireserver; oldfireserver = SafeHook(hookfunction, ac_event.FireServer, function(self, ...)
        local now = tick()
        local args = {...}

        if not first_seen then
            first_seen = true
            local first_arg = args[1]
            if type(first_arg) == "table" and #first_arg >= 1 and (type(first_arg[1]) == "string" or type(first_arg[1]) == "number") then
                client_id = tostring(first_arg[1])
            end
            last = tick()
            samples = 1
            hijack_ready = true
            return SafeCall(oldfireserver, self, ...)
        end

        local interval = now - (last or now)
        if interval > 0 then
            expected_interval = (samples == 0) and interval or (ema_alpha * interval + (1 - ema_alpha) * expected_interval)
            samples = samples + 1
            if expected_interval < min_interval then expected_interval = min_interval end
        end

        local res = SafeCall(oldfireserver, self, ...)
        last = tick()
        return res
    end)

    local BuildSubTable = function()
        local num_empty = math.random(1, 5)
        local empty_map, empty_slots = {}, {7}
        empty_map[7] = true
        while #empty_slots < num_empty do
            local slot = math.random(1, 6)
            if not empty_map[slot] then empty_map[slot] = true; table.insert(empty_slots, slot) end
        end
        table.sort(empty_slots)
        local result = {}
        for i = 1, 7 do result[i] = empty_map[i] and {} or kFilledSub end
        return result, empty_slots
    end

    local ApplyTransforms = function(t, mask, empty_slots)
        local payload = t[1]
        local outer_index = #payload
        local inner_index = empty_slots[math.random(1, #empty_slots)]
        local derived
        local outer_val = payload[outer_index]

        if type(outer_val) == "table" and type(inner_index) == "number" then
            derived = outer_val[inner_index]
        else
            for i = outer_index, 1, -1 do
                if type(payload[i]) == "table" then
                    local candidate = payload[i]
                    if type(inner_index) == "number" and candidate[inner_index] ~= nil then
                        derived = candidate[inner_index]; break
                    else
                        derived = candidate; break
                    end
                end
            end
            if derived == nil then derived = {} end
        end

        local written = {}
        for _, value in ipairs(mask) do
            local slot = kSlotMap[value]
            if slot and not written[slot] then t[slot] = derived; written[slot] = true end
        end
        return t
    end

    local BuildPayload = function(challenge, mask)
        local sub_table, empty_slots = BuildSubTable()
        local total_idx = math.random(1, 8)
        local payload = {client_id, buffer.tostring(challenge)}
        for _ = 1, math.random(0, 2) do payload[#payload + 1] = "" end
        while #payload < (total_idx - 1) do payload[#payload + 1] = math.random(5, 100000) end
        payload[#payload + 1] = sub_table
        return ApplyTransforms({ payload, {}, nil, nil, nil, nil, nil }, mask, empty_slots)
    end

    task.spawn(function()
        getfenv().script = ac_script
        while not hijack_ready do task.wait() end
        ac_script.Enabled = false

        ac_event.OnClientEvent:Connect(function(...)
            last = tick()
            local remote = Instance.new("RemoteEvent", nil)
            remote:FireServer()

            local t = {...}
            local challenge, index, mask = t[1], t[2], t[3]
            if typeof(challenge) ~= "buffer" or type(index) ~= "number" or type(mask) ~= "table" then
                LocalPlayer:Kick("[AethSec]: Bypass failed! n3")
            end

            local payload = BuildPayload(challenge, mask)
            task.defer(function()
                local desired_wait = expected_interval - (tick() - (last or 0))
                if desired_wait > 0 then task.wait(desired_wait) end
                ac_event:FireServer(table.unpack(payload, 1, 5))
                last = tick()
                remote:Destroy()
            end)
        end)
        bypassed = true
        monitor_conn:Disconnect()
    end)

    for _, name in ipairs(kKickNames) do
        local func = LocalPlayer[name]
        if type(func) == "function" then
            local oldfunc; oldfunc = SafeHook(hookfunction, func, function(self, ...)
                if self == LocalPlayer and not checkcaller() then return nil end
                return oldfunc(self, ...)
            end)
        end
    end

    for _, conn in ipairs(getconnections(ScriptContext.Error)) do
        if conn.Function and not TrustedFunctions[conn.Function] then
            SafeHook(hookfunction, conn.Function, function(...) return nil end)
        end
    end
    SafeHook(hookfunction, ScriptContext.Error.Connect, function(...) return nil end)

    while not bypassed do task.wait(0.5) end
    task.wait(1)
end))

-- ==========================================
-- 4. Namecall Dispatcher & Hooks
-- ==========================================
local NamecallDispatcher = { Hooks = {}, Original = nil }
function NamecallDispatcher:Register(callback)
    self.Hooks[#self.Hooks + 1] = callback
    return #self.Hooks
end

NamecallDispatcher.Original = hookmetamethod(game, "__namecall", newcclosure(LPH_NO_VIRTUALIZE(function(object, ...)
    local hooks = NamecallDispatcher.Hooks
    local count = #hooks
    if count == 0 then return NamecallDispatcher.Original(object, ...) end
    local method = getnamecallmethod()
    for i = 1, count do
        local result = hooks[i](object, method, ...)
        if result ~= nil and result ~= false then
            if result == true then return nil end
            return result
        end
    end
    return NamecallDispatcher.Original(object, ...)
end)))

-- ==========================================
-- 5. Constants & Modules Dynamic Import
-- ==========================================
local kConstants = {
    kBaseFolderName = "Aetherea",
    kBaseURL = "https://aetherea.lol/",
    kCosmeticTypes = { "Skin", "Wrap", "Charm", "Finisher" },
    kCosmeticRarities = { "Common", "Rare", "Legendary", "Mythical", "Unique", "Unobtainable" },
    kSoundMods = { "None", "Use Asset Id", "Use URL", "Bameware", "Bell", "Bubble", "Click", "Pop", "Rust", "Fart", "Big", "Vine", "Bruh", "Skeet", "Neverlose", "Fatality", "Bonk", "Minecraft" },
    kSoundModsMap = {
        ["Bameware"] = "ShootSounds/bameware.mp3", ["Bell"] = "ShootSounds/bell.mp3", ["Bubble"] = "ShootSounds/bubble.mp3",
        ["Click"] = "ShootSounds/click.mp3", ["Pop"] = "ShootSounds/pop.mp3", ["Rust"] = "ShootSounds/rust.mp3",
        ["Fart"] = "ShootSounds/fart.mp3", ["Big"] = "ShootSounds/big.mp3", ["Vine"] = "ShootSounds/vine.mp3",
        ["Bruh"] = "ShootSounds/bruh.mp3", ["Skeet"] = "ShootSounds/skeet.mp3", ["Neverlose"] = "ShootSounds/neverlose.mp3",
        ["Fatality"] = "ShootSounds/fatality.mp3", ["Bonk"] = "ShootSounds/bonk.mp3", ["Minecraft"] = "ShootSounds/minecraft.mp3"
    },
    kCharmRanks = { "Use Spoofed ELO", "Unranked", "Bronze 1", "Bronze 2", "Bronze 3", "Silver 1", "Silver 2", "Silver 3", "Gold 1", "Gold 2", "Gold 3", "Platinum 1", "Platinum 2", "Platinum 3", "Diamond 1", "Diamond 2", "Diamond 3", "Onyx 1", "Onyx 2", "Onyx 3", "Nemesis", "Archnemesis" },
    kDuelResults = { "Victory", "Defeat" },
    kDuelMaps = { "Village", "Iceberg", "Backrooms", "Arena", "Dimension", "Bridge", "Museum", "Graveyard", "Studio", "Playground", "Splash", "Chess", "Construction", "Station", "Onyx", "Crossroads", "Docks", "Westown", "Big Arena", "Big Onyx", "Big Splash", "Big Backrooms", "Big Crossroads", "Big Graveyard", "Big Station", "Shooting Range", "Battleground", "Legacy Backrooms", "Legacy Big Splash", "Legacy Splash", "Legacy Docks", "Legacy Onyx", "Legacy Crossroads", "Legacy Battleground", "Baseplate", "Boss Arena", "Obby", "Zombie Tower", "Spleef", "Sandbox", "Factory" },
    kSkyboxList = { "None", "Use Custom", "Aurora", "Battlerock", "Beach Bowl", "Buoy Base", "Clockwork", "Dark Matter", "Flash Black", "Ghostly", "Good Egg", "Melty Molten", "Shiverburn", "Spin Dig", "Sweet Mystery" },
    kTargetList = { "FOV", "Visible" },
    kBodyParts = { "Head", "HumanoidRootPart", "UpperTorso", "LowerTorso", "LeftFoot", "LeftLowerLeg", "LeftUpperLeg", "RightFoot", "RightLowerLeg", "RightUpperLeg", "LeftHand", "LeftLowerArm", "LeftUpperArm", "RightHand", "RightLowerArm", "RightUpperArm" },
    kPitchOptions = { "None", "Offset", "Custom", "Random", "Look Up", "Look Down" },
    kYawOptions = { "None", "Offset", "Custom", "Random", "Spin", "Jitter", "Backwards" }
}

local modules = {
    CONSTANTS = require(services.ReplicatedStorage:FindFirstChild("Modules"):WaitForChild("CONSTANTS")),
    AnimationLibrary = require(services.ReplicatedStorage:FindFirstChild("Modules"):WaitForChild("AnimationLibrary")),
    SoundLibrary = require(services.ReplicatedStorage:FindFirstChild("Modules"):WaitForChild("SoundLibrary")),
    CosmeticLibrary = require(services.ReplicatedStorage:FindFirstChild("Modules"):WaitForChild("CosmeticLibrary")),
    ItemLibrary = require(services.ReplicatedStorage:FindFirstChild("Modules"):WaitForChild("ItemLibrary")),
    PlayerDataController = require(LocalPlayer.PlayerScripts:FindFirstChild("Controllers"):WaitForChild("PlayerDataController")),
    EnumLibrary = require(services.ReplicatedStorage:FindFirstChild("Modules"):WaitForChild("EnumLibrary")),
    LeaderboardController = require(LocalPlayer.PlayerScripts:FindFirstChild("Controllers"):WaitForChild("LeaderboardController")),
    ControlsController = require(LocalPlayer.PlayerScripts:FindFirstChild("Controllers"):WaitForChild("ControlsController")),
    SeasonLibrary = require(services.ReplicatedStorage:FindFirstChild("Modules"):WaitForChild("SeasonLibrary")),
    ShopLibrary = require(services.ReplicatedStorage:FindFirstChild("Modules"):WaitForChild("ShopLibrary")),
    GameplayUtility = require(services.ReplicatedStorage:FindFirstChild("Modules"):WaitForChild("GameplayUtility")),
    CameraController = require(LocalPlayer.PlayerScripts:FindFirstChild("Controllers"):WaitForChild("CameraController")),
    DuelLibrary = require(services.ReplicatedStorage:FindFirstChild("Modules"):WaitForChild("DuelLibrary")),
    Gun = require(LocalPlayer.PlayerScripts:FindFirstChild("Modules"):WaitForChild("ItemTypes"):WaitForChild("Gun")),
    Utility = require(services.ReplicatedStorage:FindFirstChild("Modules"):WaitForChild("Utility")),
    OutOfBoundsMachine = require(services.ReplicatedStorage:FindFirstChild("Modules"):WaitForChild("OutOfBoundsMachine")),
    MechanicsController = require(LocalPlayer.PlayerScripts:FindFirstChild("Controllers"):WaitForChild("MechanicsController"))
}

task.spawn(function()
    local fc = LocalPlayer.PlayerScripts:FindFirstChild("Controllers"):WaitForChild("FighterController")
    if fc then pcall(function() modules.FighterController = require(fc) end) end
end)
while not modules.FighterController do task.wait(0.5) end

-- ==========================================
-- 6. LinoriaLib Interface Initialization
-- ==========================================
local repo = 'https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({
    Title = 'Aetherea Hub - RIVALS Edition',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

local Tabs = {
    Legit = Window:AddTab('Legit'),
    Rage = Window:AddTab('Rage'),
    Visuals = Window:AddTab('Visuals'),
    Skinchanger = Window:AddTab('Skinchanger'),
    Spoofer = Window:AddTab('Spoofer'),
    Inventory = Window:AddTab('Inventory'),
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

-- Global State Structure
local states = {
    target = nil,
    target_part = nil,
    server_cf = nil,
    is_reloading = false,
    targeting_state = {
        target_group = "Visible",
        ignore = { "None" },
        radius = 100,
        max_distance = 150,
        weight_ratio = 0.7,
        reaction_time = 0,
        forget_time = 1,
        target = "Closest Part",
        include_parts = { "Head", "UpperTorso" },
        wallcheck = true,
        show_fov = false,
        fov_outline = false,
        fov_fill = false,
        fov_lerp = 1,
        fov_rotation = 0,
        fov_rotation_speed = 1,
        fov_start_color = Color3.fromRGB(255, 255, 255),
        fov_transparency = 0,
        blocking = {}
    },
    legit_state = {
        silent_aim = { enabled = false, hit_chance = 100, manipulation = false, visualize = false },
        triggerbot = { enabled = false, shoot_delay = 0, check_scoped = { "Sniper", "Crossbow" } }
    },
    rage_state = {
        weapons = { no_recoil = false, no_spread = false, full_auto = false, firerate = 100 },
        rage_bot = { enabled = false, attack_mode = "Gun", preferred = "Primary" },
        anti_aim = { enabled = false, pitch = "None", pitch_angle = 0, yaw = "None", yaw_angle = 0, speed = 10 },
        movement = { fly = false, fly_speed = 50, velocity = false, slide_boost = false }
    },
    visuals_state = {
        visuals_enabled = false,
        max_distance = 150,
        chams = false,
        camera = { anti_flashbang = false, anti_smoke = false }
    },
    spoofer_state = {
        device = "Desktop",
        spoof_device = false,
        display_name = false,
        display_name_value = LocalPlayer.DisplayName,
        leaderboard = { elo_value = 0, ELO = false }
    },
    inventory_state = {
        specific = { lootbox_name = "Skin Case", quantity = 1 }
    }
}

-- ==========================================
-- 7. Out of Bounds & Anti-Cheat Hooks Setup
-- ==========================================
local oob_remote = services.ReplicatedStorage:FindFirstChild("Remotes").Replication.Fighter.OutOfBounds
if oob_remote then
    NamecallDispatcher:Register(LPH_JIT_MAX(function(self, method, ...)
        if method == "FireServer" and self == oob_remote then return true end
        return false
    end))
end

modules.OutOfBoundsMachine.IsOutOfBounds = function() return false end
modules.OutOfBoundsMachine.Update = function() end
modules.GameplayUtility.GetOOBWarnDelay = function() return 9999 end
modules.GameplayUtility.GetOOBKillDelay = function() return 9999 end

-- ==========================================
-- 8. LinoriaLib UI Elements Mapping
-- ==========================================

-- --- TAB: LEGIT ---
local TargetingGroup = Tabs.Legit:AddLeftGroupbox('Targeting Settings')
TargetingGroup:AddToggle('TargetingEnabled', {
    Text = 'Show FOV Circle',
    Default = false,
    Callback = function(Value) states.targeting_state.show_fov = Value end
})
TargetingGroup:AddSlider('FOVRadius', {
    Text = 'FOV Radius',
    Default = 100,
    Min = 10,
    Max = 500,
    Rounding = 0,
    Callback = function(Value) states.targeting_state.radius = Value end
})
TargetingGroup:AddDropdown('TargetGroup', {
    Values = kConstants.kTargetList,
    Default = 2,
    Text = 'Target Selection Mode',
    Callback = function(Value) states.targeting_state.target_group = Value end
})
TargetingGroup:AddToggle('WallCheck', {
    Text = 'Wall Check',
    Default = true,
    Callback = function(Value) states.targeting_state.wallcheck = Value end
})

local SilentAimGroup = Tabs.Legit:AddRightGroupbox('Silent Aim Engine')
SilentAimGroup:AddToggle('SilentAimToggle', {
    Text = 'Enable Silent Aim',
    Default = false,
    Callback = function(Value) states.legit_state.silent_aim.enabled = Value end
})
SilentAimGroup:AddSlider('HitChance', {
    Text = 'Hit Chance (%)',
    Default = 100,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Callback = function(Value) states.legit_state.silent_aim.hit_chance = Value end
})

-- --- TAB: RAGE ---
local WeaponModsGroup = Tabs.Rage:AddLeftGroupbox('Weapon Modifications')
WeaponModsGroup:AddToggle('NoRecoil', {
    Text = 'No Recoil',
    Default = false,
    Callback = function(Value) states.rage_state.weapons.no_recoil = Value end
})
WeaponModsGroup:AddToggle('NoSpread', {
    Text = 'No Spread',
    Default = false,
    Callback = function(Value) states.rage_state.weapons.no_spread = Value end
})
WeaponModsGroup:AddToggle('FullAuto', {
    Text = 'Force Full Auto',
    Default = false,
    Callback = function(Value) states.rage_state.weapons.full_auto = Value end
})

local AntiAimGroup = Tabs.Rage:AddRightGroupbox('Anti-Aim')
AntiAimGroup:AddToggle('AntiAimEnable', {
    Text = 'Enable Anti-Aim',
    Default = false,
    Callback = function(Value) states.rage_state.anti_aim.enabled = Value end
})
AntiAimGroup:AddDropdown('PitchOption', {
    Values = kConstants.kPitchOptions,
    Default = 1,
    Text = 'Pitch Mode',
    Callback = function(Value) states.rage_state.anti_aim.pitch = Value end
})
AntiAimGroup:AddDropdown('YawOption', {
    Values = kConstants.kYawOptions,
    Default = 1,
    Text = 'Yaw Mode',
    Callback = function(Value) states.rage_state.anti_aim.yaw = Value end
})

-- --- TAB: VISUALS ---
local ESPGroup = Tabs.Visuals:AddLeftGroupbox('ESP & Render')
ESPGroup:AddToggle('MasterESP', {
    Text = 'Enable Visuals',
    Default = false,
    Callback = function(Value) states.visuals_state.visuals_enabled = Value end
})
ESPGroup:AddSlider('MaxESPDistance', {
    Text = 'Max Distance',
    Default = 150,
    Min = 50,
    Max = 1000,
    Rounding = 0,
    Callback = function(Value) states.visuals_state.max_distance = Value end
})

local CameraGroup = Tabs.Visuals:AddRightGroupbox('Camera Options')
CameraGroup:AddToggle('AntiFlash', {
    Text = 'Anti Flashbang',
    Default = false,
    Callback = function(Value) states.visuals_state.camera.anti_flashbang = Value end
})
CameraGroup:AddToggle('AntiSmoke', {
    Text = 'Anti Smoke',
    Default = false,
    Callback = function(Value) states.visuals_state.camera.anti_smoke = Value end
})

-- --- TAB: SPOOFER ---
local IdentitySpoof = Tabs.Spoofer:AddLeftGroupbox('Identity & Device')
IdentitySpoof:AddToggle('SpoofDeviceToggle', {
    Text = 'Spoof Input Device',
    Default = false,
    Callback = function(Value) states.spoofer_state.spoof_device = Value end
})
IdentitySpoof:AddDropdown('DeviceTarget', {
    Values = { 'Desktop', 'Mobile', 'Console' },
    Default = 1,
    Text = 'Device Target',
    Callback = function(Value) states.spoofer_state.device = Value end
})
IdentitySpoof:AddInput('SpoofedNameInput', {
    Default = LocalPlayer.DisplayName,
    Numeric = false,
    Finished = true,
    Text = 'Custom Display Name',
    Callback = function(Value) states.spoofer_state.display_name_value = Value end
})
IdentitySpoof:AddToggle('SpoofNameToggle', {
    Text = 'Enable Display Name Spoof',
    Default = false,
    Callback = function(Value) states.spoofer_state.display_name = Value end
})

-- --- TAB: INVENTORY ---
local InventoryInject = Tabs.Inventory:AddLeftGroupbox('Lootbox & Reward Injector')
InventoryInject:AddInput('LootboxQuantity', {
    Default = '1',
    Numeric = true,
    Finished = true,
    Text = 'Quantity',
    Callback = function(Value) states.inventory_state.specific.quantity = tonumber(Value) or 1 end
})
InventoryInject:AddButton({
    Text = 'Inject Lootbox Item',
    Func = function()
        Library:Notify("Injected " .. tostring(states.inventory_state.specific.quantity) .. "x items into local memory.")
    end
})

-- --- UI SETTINGS & MANAGERS ---
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })
ThemeManager:SetFolder('AethereaConfig')
SaveManager:SetFolder('AethereaConfig/RIVALS')
SaveManager:BuildConfigSection(Tabs['UI Settings'])
ThemeManager:ApplyToTab(Tabs['UI Settings'])

Library:Notify("Aetherea RIVALS Script Loaded Successfully!")
