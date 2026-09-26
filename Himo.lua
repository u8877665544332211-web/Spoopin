local game_id = 6035872082

if getgenv().HI_I_HAVE_BALL_CANCER == true or game.GameId ~= game_id then
	return
end

pcall(function() getgenv().HI_I_HAVE_BALL_CANCER = true end)
if not game:IsLoaded() then game.Loaded:Wait() end

if not LPH_OBFUSCATED then
	local DevApiKey = "ba17cd54606f49e16cee758e5930652b46128d6f09caf3dfa798e2b9bb8eaa44"
	local ScriptId = "43853841615976269471" -- Your script ID
	local Key = isfile("Aetherea/key.txt") and readfile("Aetherea/key.txt") or ""

	LPH_ENCNUM = function(toEncrypt, ...)
		assert(type(toEncrypt) == "number" and #{...} == 0, "LPH_ENCNUM only accepts a single double or integer as an argument.")
		return toEncrypt
	end
	LPH_NUMENC = LPH_ENCNUM

	LPH_ENCSTR = function(toEncrypt, ...)
		assert(type(toEncrypt) == "string" and #{...} == 0, "LPH_ENCSTR only accepts a single string as an argument.")
		return toEncrypt
	end
	LPH_STRENC = LPH_ENCSTR

	LPH_ENCFUNC = function(toEncrypt, encKey, decKey, ...)
		assert(type(toEncrypt) == "function" and type(encKey) == "string" and #{...} == 0, "LPH_ENCFUNC accepts a function, constant string, and string variable as arguments.")
		return toEncrypt
	end
	LPH_FUNCENC = LPH_ENCFUNC

	LPH_JIT = function(f, ...)
		assert(type(f) == "function" and #{...} == 0, "LPH_JIT only accepts a single function as an argument.")
		return f
	end
	LPH_JIT_MAX = LPH_JIT

	LPH_NO_VIRTUALIZE = function(f, ...)
		assert(type(f) == "function" and #{...} == 0, "LPH_NO_VIRTUALIZE only accepts a single function as an argument.")
		return f
	end

	LPH_NO_UPVALUES = function(f, ...)
		assert(type(setfenv) == "function", "LPH_NO_UPVALUES can only be used on Lua versions with getfenv & setfenv")
		assert(type(f) == "function" and #{...} == 0, "LPH_NO_UPVALUES only accepts a single function as an argument.")
		return f
	end

	LPH_CRASH = function(...)
		assert(#{...} == 0, "LPH_CRASH does not accept any arguments.")
		error("LPH_CRASH called")
	end

	LP_BLACKLIST = function(s, ...)
		assert(#{...} == 0, "LP_BLACKLIST only accepts 1 argument.")
		assert(type(s) == "string", "LP_BLACKLIST requires 1 string argument.")
		error("LP_BLACKLIST called: " .. s)
	end

	LP_VMIFY = function(f, ...)
		assert(type(f) == "function" and #{...} == 0, "LP_VMIFY only accepts a single function as an argument.")
		return f
	end

	LP_INIT = function(f, ...)
		assert(type(f) == "function" and #{...} == 0, "LP_INIT only accepts a single function as an argument.")
		task.spawn(f)
	end

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

	LP_SAVE_VALUE = function(key, value, overwrite)
		assert(type(key) == "string", "LP_SAVE_VALUE requires a string as first argument.")
		assert(type(value) ~= "string" and type(value) ~= "number" and type(value) ~= "boolean", "LP_SAVE_VALUE requires a string, number or boolean as second argument.")
	end

	LP_GET_VALUE = function(key)
		assert(type(key) == "string", "LP_GET_VALUE requires a string key.")
	end

	LP_DELETE_VALUE = function(key)
		assert(type(key) == "string", "LP_DELETE_VALUE requires a string key.")
	end
end

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
            Headers = {
                ["Content-Type"] = "application/json"
            }
        }).Body
        queueteleport(script)
	end
end)

--[[
    Bypass :shush:
]]

pcall(LPH_NO_VIRTUALIZE(function()
    local bypassed = false

    local kKickNames = {
        "Kick",
        "kick"
    }

    local kProtectedProperties = {
        Enabled = true,
        Disabled = false
    }

    local kSlotMap = {
        [69]  = 2,
        [138] = 3,
        [207] = 4,
        [276] = 5,
        [345] = 6,
        [414] = 7,
    }

    local kFilledSub = {
        1,
        2,
        3,
        4,
        5
    }

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
    local client_id
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

            if not dotPos then
                return false
            end

            if not colonPos then
                return true
            end

            return dotPos < colonPos
        end

        local function TracebackLines(str, lvl)
            local pos = lvl
            return function()
                if not pos then
                    return nil
                end
                local p1, p2 = string.find(str, "\r?\n", pos)
                local line
                if p1 then
                    line = str:sub(pos, p1 - 1)
                    pos = p2 + 1
                else
                    line = str:sub(pos)
                    pos = nil
                end
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

            if typeof(StackLevel) ~= "number" or not tonumber(StackLevel) then
                StackLevel = 1
            else
                StackLevel = math.floor(tonumber(StackLevel))
            end

            for Line in TracebackLines(Traceback, StackLevel) do
                if not ValidTraceback(Line) then
                    continue
                end

                table.insert(NewTraceback, Line)
            end

            return table.concat(NewTraceback, "\n") .. "\n"
        end)

        local old_dbg_info;
        old_dbg_info = hookfunction(getrenv().debug.info, function(...)
            local ToInspect, LevelOrInfo, _ThreadInfo = ...

            if
                checkcaller()
                or typeof(ToInspect) == "function"
                or typeof(ToInspect) == "thread"
                or not pcall(function(LevelOrInfo)
                    old_dbg_info(function() end, LevelOrInfo)
                end, LevelOrInfo)
            then
                return old_dbg_info(...)
            end

            ToInspect = math.floor(ToInspect)

            local ReconstructedConstructedStack = {}
            for Level = 2, max_stack_depth do
                local Function, Source, Line, Name, NumberOfArgs, Varargs = old_dbg_info(Level, "fslna")

                if not Function or not Source or not Line or not Name then
                    break
                end

                if isexecutorclosure(Function) and not hidden_fn[Function] then
                    continue
                end

                table.insert(ReconstructedConstructedStack, {
                    f = Function,
                    s = Source,
                    l = Line,
                    n = Name,
                    a = { NumberOfArgs, Varargs },
                })
            end

            local InfoLevel = ReconstructedConstructedStack[ToInspect + 1]

            if not InfoLevel then
                return old_dbg_info(3e4, LevelOrInfo)
            end

            local ReturnResult = {}
            for idx, info in string.split(LevelOrInfo, "") do
                local Value = InfoLevel[info]

                if typeof(Value) == "table" then
                    for _, v in Value do
                        table.insert(ReturnResult, v)
                    end

                    continue
                end

                table.insert(ReturnResult, Value)
            end

            return table.unpack(ReturnResult, 1, #ReturnResult)
        end)

        local old_getfenv;
        old_getfenv = hookfunction(getrenv().getfenv, function(...)
            if checkcaller() then
                return old_getfenv(...)
            end

            local ToInspect: (...any) -> (...any) | number = ...

            local Success, ResultingEnv = pcall(function()
                if typeof(ToInspect) == "number" and ToInspect >= 0 then
                    return old_getfenv(ToInspect + 3)
                end

                return old_getfenv(ToInspect)
            end)

            if not Success then
                if typeof(ToInspect) == "number" and ToInspect >= 0 then
                    return old_getfenv(ToInspect + 3)
                end

                return old_getfenv(ToInspect)
            end

            if ToInspect == nil or typeof(ToInspect) == "function" then
                return ResultingEnv
            end

            ToInspect = math.floor(ToInspect)

            local ReconstructedConstructedStack = {}
            for Level = 1, max_stack_depth do
                local StackInfoSuccess, Data = pcall(function()
                    return {
                        Environement = old_getfenv(Level + 3),
                        Function = old_dbg_info(Level + 3, "f"),
                    }
                end)

                if not StackInfoSuccess or not Data then
                    break
                end

                local Environement = Data.Environement
                local Function = Data.Function

                if typeof(Environement["getgenv"]) == "function" and isexecutorclosure(Environement["getgenv"]) then
                    if shared.Hooking.IncludeInStackFunctions[Function] then
                        Environement = setmetatable(ResultingEnv, {
                            __index = getrenv()
                        })
                    else
                        continue
                    end
                end

                table.insert(ReconstructedConstructedStack, Environement)
            end

            local InfoLevel = ReconstructedConstructedStack[ToInspect + 1]

            if not InfoLevel then
                return old_getfenv(3e4)
            end

            return InfoLevel
        end)
    end

    setstackhidden = setstackhidden or function(fn_or_level, hidden)
        assert(typeof(hidden) == "boolean", "hidden must be boolean")

        local ok, fn = pcall(function()
            if typeof(fn_or_level) == "number" then
                return debug.info(fn_or_level + 2, "f")
            end
            return fn_or_level
        end)

        assert(ok and fn, "invalid argument #1 to 'setstackhidden'")
        hidden_fn[fn] = not hidden
    end

    local TrustedFunctions = setmetatable({}, {
        __mode = "k"
    })

    local function TrustFunction(fn)
        if type(fn) == "function" then
            TrustedFunctions[fn] = true
        end

        return fn
    end

    local function IsTrustedFunction(fn)
        return TrustedFunctions[fn] == true
    end

    local SafeHook = function(hookfn, ...)
        local args = {...}
        local func, inst, metamethod, detour

        if hookfn == hookmetamethod then
            inst = args[1]
            metamethod = args[2]
            detour = args[3]
        else
            func = args[1]
            detour = args[2]
        end

        local original_func

        if hookfn == hookfunction and iscclosure(func) then
            detour = newcclosure(detour)
        end

        if not iscclosure(detour) then
            detour = newcclosure(detour)
        end

        setstackhidden(detour, true)

        local ok, _ = pcall(function()
            TrustFunction(detour)
                    
            if hookfn == hookmetamethod then
                original_func = hookfn(inst, metamethod, detour)
            else
                original_func = hookfn(func, detour)
            end
        end)

        if not ok then
            LocalPlayer:Kick("[AethSec]: Bypass failed! n1")
        end

        return original_func
    end

    local SafeCall = function(func, ...)
        if checkcaller() then
            return func(...)
        end

        local old = getthreadidentity()
        if old ~= 2 then
            setthreadidentity(2)
        end

        local result = {func(...)}

        if old ~= 2 then
            setthreadidentity(old)
        end

        return table.unpack(result)
    end

    local monitor_conn = ScriptContext.Error:Connect(TrustFunction(function(message, stack, _)
        message = tostring(message)
        stack = tostring(stack)
        if stack:find("PlayerScripts.Controllers.MiscellaneousController") and message:find("attempt to index number with number") then
            LocalPlayer:Kick("[AethSec]: Bypass failed! n2")
        end
    end))

    local oldindex; oldindex = SafeHook(hookmetamethod, ac_script, "__index", function(t, k)
        local is_caller = not bypassed and checkcaller()
        if t == ac_script and not is_caller and kProtectedProperties[k] ~= nil then
            return kProtectedProperties[k]
        end
        if checkcaller() then
            return oldindex(t, k)
        end
        return SafeCall(oldindex, t, k)
    end)

    local oldnewindex; oldnewindex = SafeHook(hookmetamethod, ac_script, "__newindex", function(t, k, v)
        local is_caller = not bypassed and checkcaller()
        if t == ac_script and not is_caller and kProtectedProperties[k] ~= nil then
            kProtectedProperties[k] = v
            if k == "Enabled" then
                kProtectedProperties["Disabled"] = not v
            end

            if k == "Disabled" then
                kProtectedProperties["Enabled"] = not v
            end
            return
        end
        if checkcaller() then
            return oldnewindex(t, k, v)
        end
        return SafeCall(oldnewindex, t, k, v)
    end)

    client_id = ""
    last = tick()

    local oldfireserver; oldfireserver = SafeHook(hookfunction, ac_event.FireServer, function(self, ...)
        local now = tick()
        local args = {...}

        if not first_seen then
            first_seen = true
            local first_arg = args[1]

            if type(first_arg) == "table" and #first_arg >= 1 and (type(first_arg[1]) == "string" or type(first_arg[1]) == "number") then
                client_id = tostring(first_arg[1])
            else
                client_id = client_id or ""
            end

            last = tick()
            samples = 1
            hijack_ready = true

            local res = SafeCall(oldfireserver, self, ...)
            return res
        end

        local interval = now - (last or now)

        if interval > 0 then
            if samples == 0 then
                expected_interval = interval
            else
                expected_interval = ema_alpha * interval + (1 - ema_alpha) * expected_interval
            end

            samples = samples + 1

            if expected_interval < min_interval then
                expected_interval = min_interval
            end
        end

        local res = SafeCall(oldfireserver, self, ...)
        last = tick()

        return res
    end)

    local BuildSubTable = function()
        local num_empty = math.random(1, 5)
        local empty_map = {}
        local empty_slots = {7}
        empty_map[7] = true

        while #empty_slots < num_empty do
            local slot = math.random(1, 6)
            if not empty_map[slot] then
                empty_map[slot] = true
                table.insert(empty_slots, slot)
            end
        end

        table.sort(empty_slots)

        local result = {}
        for i = 1, 7 do
            if empty_map[i] then
                result[i] = {}
            else
                result[i] = kFilledSub
            end
        end

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
                if type(payload[i]) ~= "table" then
                    continue
                end

                local candidate = payload[i]

                if type(inner_index) == "number" and candidate[inner_index] ~= nil then
                    derived = candidate[inner_index]
                    break
                else
                    derived = candidate
                    break
                end
            end

            if derived == nil then
                derived = {}
            end
        end

        local written = {}
        local kSlotMapRef = kSlotMap

        for _, value in ipairs(mask) do
            local slot = kSlotMapRef[value]
            if slot and not written[slot] then
                t[slot] = derived
                written[slot] = true
            end
        end

        return t
    end

    local BuildPayload = function(challenge, mask)
        local sub_table, empty_slots = BuildSubTable()
        local total_idx = math.random(1, 8)
        local payload = {client_id, buffer.tostring(challenge)}
        local extra_strings = math.random(0, 2)

        for _ = 1, extra_strings do
            payload[#payload + 1] = ""
        end

        while #payload < (total_idx - 1) do
            payload[#payload + 1] = math.random(5, 100000)
        end

        payload[#payload + 1] = sub_table

        local t = {
            payload,
            {},
            nil,
            nil,
            nil,
            nil,
            nil
        }
        return ApplyTransforms(t, mask, empty_slots)
    end

    task.spawn(function()
        getfenv().script = ac_script
        while not hijack_ready do
            task.wait()
        end

        ac_script.Enabled = false

        ac_event.OnClientEvent:Connect(function(...)
            last = tick()

            local remote = Instance.new("RemoteEvent", nil)
            remote:FireServer()

            local t = {...}
            local challenge = t[1]
            local index = t[2]
            local mask = t[3]

            if typeof(challenge) ~= "buffer" or type(index) ~= "number" or type(mask) ~= "table" then
                LocalPlayer:Kick("[AethSec]: Bypass failed! n3")
            end

            local payload = BuildPayload(challenge, mask)
            task.defer(function()
                local since_last = tick() - (last or 0)
                local desired_wait = expected_interval - since_last
                
                if desired_wait > 0 then
                    task.wait(desired_wait)
                end
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
        if type(func) ~= "function" then return end
            
        local oldfunc; oldfunc = SafeHook(hookfunction, func, function(self, ...)
            if self == LocalPlayer and not checkcaller() then
                return nil
            end
            return oldfunc(self, ...)
        end)
    end

    for _, conn in ipairs(getconnections(ScriptContext.Error)) do
        if not conn.Function then continue end
        if IsTrustedFunction(conn.Function) then continue end
        SafeHook(hookfunction, conn.Function, function(...)
            return nil
        end)
    end

    SafeHook(hookfunction, ScriptContext.Error.Connect, function(...)
        return nil
    end)

    while not bypassed do
        task.wait(0.5)
    end
    task.wait(1)
end))

local NamecallDispatcher = {
    Hooks = {},
    Original = nil,
}

function NamecallDispatcher:Register(callback)
    self.Hooks[#self.Hooks + 1] = callback
    return #self.Hooks
end

function NamecallDispatcher:Unregister(index)
    table.remove(self.Hooks, index)
end

function NamecallDispatcher:Clear()
    table.clear(self.Hooks)
    table.clear(self.OrderedHooks)
end

function NamecallDispatcher:CallOriginal(object, ...)
    if self.Original then
        return self.Original(object, ...)
    end

    return nil
end

NamecallDispatcher.Original = hookmetamethod(game, "__namecall", newcclosure(LPH_NO_VIRTUALIZE(function(object, ...)
    local hooks = NamecallDispatcher.Hooks
    local count = #hooks

    if count == 0 then
        return NamecallDispatcher.Original(object, ...)
    end

    local method = getnamecallmethod()

    for i = 1, count do
        local result = hooks[i](object, method, ...)

        if result ~= nil and result ~= false then
            if result == true then
                return nil
            end

            return result
        end
    end

    return NamecallDispatcher.Original(object, ...)
end)))

local kConstants = {
    kBaseFolderName = "Aetherea",
    kBaseURL = "https://aetherea.lol/",

    kAethereaLogo = 1000000000,
    kLucideHome = 1,
    kLucideUser = 2,
    kLucideHeart = 64,
    kLucideClipboard = 69,
    kLucideCheckCircle = 29,
    kLucideCrosshair = 77,
    kLucideEye = 36,
    kLucideView = 78,
    kLucideSparkles = 76,
    kLucideSettings = 14,
    kLucideGlobe = 79,
    kLucideUnlock = 39,
    kLucideRainbow = 80,
    kLucideSmartphone = 81,
    kLucideList = 82,
    kLucideStar = 62,
    kLucideSearch = 4,
    kLucideBox = 83,
    kLucideCircleDollarSign = 84,
    kLucideVolume2 = 61,
    kLucideX = 5,
    kLucideCloud = 50,
    kLucideCat = 85,

    kCharmEloMap = {
        ["Unranked"] = -1,
        ["Bronze 1"] = 0,
        ["Bronze 2"] = 200,
        ["Bronze 3"] = 400,
        ["Silver 1"] = 600,
        ["Silver 2"] = 800,
        ["Silver 3"] = 1000,
        ["Gold 1"] = 1200,
        ["Gold 2"] = 1400,
        ["Gold 3"] = 1600,
        ["Platinum 1"] = 1800,
        ["Platinum 2"] = 2000,
        ["Platinum 3"] = 2200,
        ["Diamond 1"] = 2400,
        ["Diamond 2"] = 2600,
        ["Diamond 3"] = 2800,
        ["Onyx 1"] = 3000,
        ["Onyx 2"] = 3200,
        ["Onyx 3"] = 3400,
        ["Nemesis"] = 3600,
        ["Archnemesis"] = 3600,
    },

    kSeasonNameMap = {
        [0] = "Zero",
	    [1] = "Warp",
	    [2] = "Polar",
	    [3] = "Fame",
        ["Zero"] = 0,
	    ["Warp"] = 1,
	    ["Polar"] = 2,
	    ["Fame"] = 3,
    },

    kSeasonToggleMap = {
        [0] = "s0_charm",
        [1] = "s1_charm",
        [2] = "s2_charm",
        [3] = "s3_charm",
    },

    kFunctionsUsed = {
        "cloneref",
        "gethui",
        "isfolder",
        "makefolder",
        "isfile",
        "readfile",
        "writefile",
        "getcustomasset",
        "hookmetamethod",
        "hookfunction",
        "getcallingscript",
        "newcclosure",
        "getconnections",
        "checkcaller",
        "queueteleport",
        "getgenv",
        "base64decode"
    },

    kCosmeticTypes = {
        "Skin",
        "Wrap",
        "Charm",
        "Finisher"
    },

    kCosmeticRarities = {
        "Common",
        "Rare",
        "Legendary",
        "Mythical",
        "Unique",
        "Unobtainable"
    },

    kSoundMods = {
        "None",
        "Use Asset Id",
        "Use URL",
        "Bameware",
        "Bell",
        "Bubble",
        "Click",
        "Pop",
        "Rust",
        "Fart",
        "Big",
        "Vine",
        "Bruh",
        "Skeet",
        "Neverlose",
        "Fatality",
        "Bonk",
        "Minecraft",
    },

    kSoundModsMap = {
        ["Bameware"] = "ShootSounds/bameware.mp3",
        ["Bell"] = "ShootSounds/bell.mp3",
        ["Bubble"] = "ShootSounds/bubble.mp3",
        ["Click"] = "ShootSounds/click.mp3",
        ["Pop"] = "ShootSounds/pop.mp3",
        ["Rust"] = "ShootSounds/rust.mp3",
        ["Fart"] = "ShootSounds/fart.mp3",
        ["Big"] = "ShootSounds/big.mp3",
        ["Vine"] = "ShootSounds/vine.mp3",
        ["Bruh"] = "ShootSounds/bruh.mp3",
        ["Skeet"] = "ShootSounds/skeet.mp3",
        ["Neverlose"] = "ShootSounds/neverlose.mp3",
        ["Fatality"] = "ShootSounds/fatality.mp3",
        ["Bonk"] = "ShootSounds/bonk.mp3",
        ["Minecraft"] = "ShootSounds/minecraft.mp3",
    },

    kCharmRanks = {
        "Use Spoofed ELO",
        "Unranked",
        "Bronze 1",
        "Bronze 2",
        "Bronze 3",
        "Silver 1",
        "Silver 2",
        "Silver 3",
        "Gold 1",
        "Gold 2",
        "Gold 3",
        "Platinum 1",
        "Platinum 2",
        "Platinum 3",
        "Diamond 1",
        "Diamond 2",
        "Diamond 3",
        "Onyx 1",
        "Onyx 2",
        "Onyx 3",
        "Nemesis",
        "Archnemesis",
    },

    kOriginalHitmarkers = {
        kill_layer1 = "rbxassetid://16537449730",
        kill_layer2 = "rbxassetid://16537337310",
        hit = "rbxassetid://13110130082",
    },

    kShootSemanticKeys = {
        "Shoot",
        "Shoot1",
        "Shoot2",
        "Shoot3",
        "Shoot4",
        "FinalShoot",
        "EmptyShoot",
        "AltShoot",
        "AltShoot1",
        "ChargeShoot",
        "ChargeShootRelease",
    },

    kReloadSemanticKeys = {
        "Reload",
        "EmptyReload",
        "EmptyReloadStart",
        "EmptyReloadEnd",
        "ReloadInsert",
        "ReloadFinish",
        "TacticalReload",
    },

    kLootboxNames = {
        "Skin Case",
        "Skin Case 2",
        "Skin Case 3",
        "Wrap Box",
        "Wrap Box 2",
        "Wrap Box 3",
        "Charm Capsule",
        "Finisher Pack",
        "Finisher Pack 2",
        "Spooky Skin Case",
        "Haunted Chest",
        "Festive Skin Case",
        "Jolly Chest",
        "Festive Wrap Box",
        "Festive Wrap Box 2",
        "Goodie Bag",
        "Prime Goodie Bag",
        "Weapon Crate",
        "Standard Weapon Crate",
        "Prime Weapon Crate",
        "Contraband Weapon Crate",
    },

    kItemTypes = {
        "Skin",
        "Wrap",
        "Charm",
        "Finisher",
        "Emote"
    },

    kDuelResults = {
        "Victory",
        "Defeat"
    },

    kDuelMaps = {
        "Village",
        "Iceberg",
        "Backrooms",
        "Arena",
        "Dimension",
        "Bridge",
        "Museum",
        "Graveyard",
        "Studio",
        "Playground",
        "Splash",
        "Chess",
        "Construction",
        "Station",
        "Onyx",
        "Crossroads",
        "Docks",
        "Westown",
        "Big Arena",
        "Big Onyx",
        "Big Splash",
        "Big Backrooms",
        "Big Crossroads",
        "Big Graveyard",
        "Big Station",
        "Shooting Range",
        "Battleground",
        "Legacy Backrooms",
        "Legacy Big Splash",
        "Legacy Splash",
        "Legacy Docks",
        "Legacy Onyx",
        "Legacy Crossroads",
        "Legacy Battleground",
        "Baseplate",
        "Boss Arena",
        "Obby",
        "Zombie Tower",
        "Spleef",
        "Sandbox",
        "Factory",
    },

    kMaterialList = {
        "Asphalt",
        "Basalt",
        "Brick",
        "Cardboard",
        "Carpet",
        "CeramicTiles",
        "ClayRoofTiles",
        "Cobblestone",
        "Concrete",
        "CorrodedMetal",
        "CrackedLava",
        "DiamondPlate",
        "Fabric",
        "Foil",
        "ForceField",
        "Glacier",
        "Glass",
        "Ground",
        "Ice",
        "LeafyGrass",
        "Leather",
        "Limestone",
        "Marble",
        "Metal",
        "Mud",
        "Neon",
        "Pavement",
        "Pebble",
        "Plaster",
        "Plastic",
        "Rock",
        "RoofShingles",
        "Rubber",
        "Salt",
        "Sand",
        "Sandstone",
        "Slate",
        "SmoothPlastic",
        "Snow",
        "Wood",
        "WoodPlanks",
    },

    kMaterialMap = {
        ["Asphalt"] = Enum.Material.Asphalt,
        ["Basalt"] = Enum.Material.Basalt,
        ["Brick"] = Enum.Material.Brick,
        ["Cardboard"] = Enum.Material.Cardboard,
        ["Carpet"] = Enum.Material.Carpet,
        ["CeramicTiles"] = Enum.Material.CeramicTiles,
        ["ClayRoofTiles"] = Enum.Material.ClayRoofTiles,
        ["Cobblestone"] = Enum.Material.Cobblestone,
        ["Concrete"] = Enum.Material.Concrete,
        ["CorrodedMetal"] = Enum.Material.CorrodedMetal,
        ["CrackedLava"] = Enum.Material.CrackedLava,
        ["DiamondPlate"] = Enum.Material.DiamondPlate,
        ["Fabric"] = Enum.Material.Fabric,
        ["Foil"] = Enum.Material.Foil,
        ["ForceField"] = Enum.Material.ForceField,
        ["Glacier"] = Enum.Material.Glacier,
        ["Glass"] = Enum.Material.Glass,
        ["Ground"] = Enum.Material.Ground,
        ["Ice"] = Enum.Material.Ice,
        ["LeafyGrass"] = Enum.Material.LeafyGrass,
        ["Leather"] = Enum.Material.Leather,
        ["Limestone"] = Enum.Material.Limestone,
        ["Marble"] = Enum.Material.Marble,
        ["Metal"] = Enum.Material.Metal,
        ["Mud"] = Enum.Material.Mud,
        ["Neon"] = Enum.Material.Neon,
        ["Pavement"] = Enum.Material.Pavement,
        ["Pebble"] = Enum.Material.Pebble,
        ["Plaster"] = Enum.Material.Plaster,
        ["Plastic"] = Enum.Material.Plastic,
        ["Rock"] = Enum.Material.Rock,
        ["RoofShingles"] = Enum.Material.RoofShingles,
        ["Rubber"] = Enum.Material.Rubber,
        ["Salt"] = Enum.Material.Salt,
        ["Sand"] = Enum.Material.Sand,
        ["Sandstone"] = Enum.Material.Sandstone,
        ["Slate"] = Enum.Material.Slate,
        ["SmoothPlastic"] = Enum.Material.SmoothPlastic,
        ["Snow"] = Enum.Material.Snow,
        ["Wood"] = Enum.Material.Wood,
        ["WoodPlanks"] = Enum.Material.WoodPlanks,
    },

    kWordList = {
        "late",
        "couple",
        "economic",
        "obscure",
        "landscape",
        "spot",
        "college",
        "rainbow",
        "leg",
        "mixture",
        "frank",
        "commitment",
        "draft",
        "motivation",
        "fuss",
        "settle",
        "jelly",
        "confine",
        "pin",
        "modernize",
        "velvet",
        "quarter",
        "physical",
        "differ",
        "dish",
        "aisle",
        "happen",
        "council",
        "appeal",
        "depart",
        "urgency",
        "vessel",
    },

    kCameraStates = {
        "FirstPerson",
        "ThirdPerson",
        "ThirdPersonMirrored",
        "ThirdPersonUnlockedMouse",
        "CustomFreecam"
    },

    kSkyboxList = {
        "None",
        "Use Custom",
        "Aurora",
        "Battlerock",
        "Beach Bowl",
        "Buoy Base",
        "Clockwork",
        "Dark Matter",
        "Flash Black",
        "Ghostly",
        "Good Egg",
        "Melty Molten",
        "Shiverburn",
        "Spin Dig",
        "Sweet Mystery"
    },

    kSkyboxMap = {
        ["None"] = {
            skybox_back = "rbxassetid://14147881792",
            skybox_down = "rbxassetid://14147882149",
            skybox_front = "rbxassetid://14147882761",
            skybox_left = "rbxassetid://14147883091",
            skybox_right = "rbxassetid://14147882405",
            skybox_up = "rbxassetid://14147881297",
            sun_texture = "rbxasset://sky/sun.jpg",
            moon_texture = "rbxasset://sky/moon.jpg",
        },
        ["Aurora"] = {
            skybox_back = "rbxassetid://116533337330584",
            skybox_down = "rbxassetid://80054106187171",
            skybox_front = "rbxassetid://94459139270943",
            skybox_left = "rbxassetid://116368999680791",
            skybox_right = "rbxassetid://125758104196312",
            skybox_up = "rbxassetid://107060226443967",
            sun_texture = "rbxasset://sky/sun.jpg",
            moon_texture = "rbxasset://sky/moon.jpg",
        },
        ["Battlerock"] = {
            skybox_back = "rbxassetid://131136284306917",
            skybox_down = "rbxassetid://89505977207531",
            skybox_front = "rbxassetid://140099243548102",
            skybox_left = "rbxassetid://121676169821100",
            skybox_right = "rbxassetid://97183886241447",
            skybox_up = "rbxassetid://107128620201556",
            sun_texture = "rbxasset://sky/sun.jpg",
            moon_texture = "rbxasset://sky/moon.jpg",
        },
        ["Beach Bowl"] = {
            skybox_back = "rbxassetid://81804134601271",
            skybox_down = "rbxassetid://92395364196932",
            skybox_front = "rbxassetid://81804134601271",
            skybox_left = "rbxassetid://81804134601271",
            skybox_right = "rbxassetid://81804134601271",
            skybox_up = "rbxassetid://119089964803065",
            sun_texture = "rbxasset://sky/sun.jpg",
            moon_texture = "rbxasset://sky/moon.jpg",
        },
        ["Buoy Base"] = {
            skybox_back = "rbxassetid://135017685421888",
            skybox_down = "rbxassetid://76610044495625",
            skybox_front = "rbxassetid://89675413438577",
            skybox_left = "rbxassetid://138307087837279",
            skybox_right = "rbxassetid://136723547010707",
            skybox_up = "rbxassetid://83404878914838",
            sun_texture = "rbxasset://sky/sun.jpg",
            moon_texture = "rbxasset://sky/moon.jpg",
        },
        ["Clockwork"] = {
            skybox_back = "rbxassetid://86284761193226",
            skybox_down = "rbxassetid://111425663631622",
            skybox_front = "rbxassetid://115606366886873",
            skybox_left = "rbxassetid://127287488325060",
            skybox_right = "rbxassetid://126844150113423",
            skybox_up = "rbxassetid://74510789204352",
            sun_texture = "rbxasset://sky/sun.jpg",
            moon_texture = "rbxasset://sky/moon.jpg",
        },
        ["Dark Matter"] = {
            skybox_back = "rbxassetid://97629693450922",
            skybox_down = "rbxassetid://97898396690232",
            skybox_front = "rbxassetid://134755033418084",
            skybox_left = "rbxassetid://118219143707956",
            skybox_right = "rbxassetid://114940065588775",
            skybox_up = "rbxassetid://95430908943263",
            sun_texture = "rbxasset://sky/sun.jpg",
            moon_texture = "rbxasset://sky/moon.jpg",
        },
        ["Flash Black"] = {
            skybox_back = "rbxassetid://78426835654353",
            skybox_down = "rbxassetid://6213218651",
            skybox_front = "rbxassetid://71970982976722",
            skybox_left = "rbxassetid://78426835654353",
            skybox_right = "rbxassetid://78426835654353",
            skybox_up = "rbxassetid://138004866371717",
            sun_texture = "rbxasset://sky/sun.jpg",
            moon_texture = "rbxasset://sky/moon.jpg",
        },
        ["Ghostly"] = {
            skybox_back = "rbxassetid://111506743048183",
            skybox_down = "rbxassetid://86198196348228",
            skybox_front = "rbxassetid://86265514167302",
            skybox_left = "rbxassetid://100257959405445",
            skybox_right = "rbxassetid://71935101953120",
            skybox_up = "rbxassetid://132011089223498",
            sun_texture = "rbxasset://sky/sun.jpg",
            moon_texture = "rbxasset://sky/moon.jpg",
        },
        ["Good Egg"] = {
            skybox_back = "rbxassetid://94681381933012",
            skybox_down = "rbxassetid://75843838469806",
            skybox_front = "rbxassetid://97891957473259",
            skybox_left = "rbxassetid://102971518965494",
            skybox_right = "rbxassetid://94588890960775",
            skybox_up = "rbxassetid://127368871569815",
            sun_texture = "rbxasset://sky/sun.jpg",
            moon_texture = "rbxasset://sky/moon.jpg",
        },
        ["Melty Molten"] = {
            skybox_back = "rbxassetid://131463907527649",
            skybox_down = "rbxassetid://116154164311420",
            skybox_front = "rbxassetid://113077689016278",
            skybox_left = "rbxassetid://79984367513909",
            skybox_right = "rbxassetid://82395195737484",
            skybox_up = "rbxassetid://117530106700350",
            sun_texture = "rbxasset://sky/sun.jpg",
            moon_texture = "rbxasset://sky/moon.jpg",
        },
        ["Shiverburn"] = {
            skybox_back = "rbxassetid://113636030839991",
            skybox_down = "rbxassetid://118027268179499",
            skybox_front = "rbxassetid://76405010847029",
            skybox_left = "rbxassetid://112044353352688",
            skybox_right = "rbxassetid://121078604572355",
            skybox_up = "rbxassetid://132486295432727",
            sun_texture = "rbxasset://sky/sun.jpg",
            moon_texture = "rbxasset://sky/moon.jpg",
        },
        ["Spin Dig"] = {
            skybox_back = "rbxassetid://124211111366754",
            skybox_down = "rbxassetid://120491795220431",
            skybox_front = "rbxassetid://130119279111055",
            skybox_left = "rbxassetid://70742671331562",
            skybox_right = "rbxassetid://76516826791940",
            skybox_up = "rbxassetid://100229310567751",
            sun_texture = "rbxasset://sky/sun.jpg",
            moon_texture = "rbxasset://sky/moon.jpg",
        },
        ["Sweet Mystery"] = {
            skybox_back = "rbxassetid://107264897520277",
            skybox_down = "rbxassetid://135637946277638",
            skybox_front = "rbxassetid://135705252786048",
            skybox_left = "rbxassetid://119667604517747",
            skybox_right = "rbxassetid://75904303027092",
            skybox_up = "rbxassetid://97011146822716",
            sun_texture = "rbxasset://sky/sun.jpg",
            moon_texture = "rbxasset://sky/moon.jpg",
        },
        ["Terrace Dome"] = {
            skybox_back = "rbxassetid://98684100016510",
            skybox_down = "rbxassetid://108354040356521",
            skybox_front = "rbxassetid://95723629635852",
            skybox_left = "rbxassetid://106269064939837",
            skybox_right = "rbxassetid://136234415079744",
            skybox_up = "rbxassetid://75385962780878",
            sun_texture = "rbxasset://sky/sun.jpg",
            moon_texture = "rbxasset://sky/moon.jpg",
        },
    },

    kLightingStyles = {
        "Realistic",
        "Soft"
    },

    kLightingStyleMap = {
        ["Realistic"] = Enum.LightingStyle.Realistic,
        ["Soft"] = Enum.LightingStyle.Soft
    },

    kWeatherTypes = {
        "Rain",
        "Snow",
        "Thunder"
    },

    kAmbienceTypes = {
        "Rain",
        "City",
        "Windy Day",
        "Thunder",
        "Forest Rain Night",
        "Light Rain And Thunder"
    },

    kAmbienceMap = {
        ["Rain"] = "rbxassetid://9112858162",
        ["City"] = "rbxassetid://238385471",
        ["Windy Day"] = "rbxassetid://159798309",
        ["Thunder"] = "rbxassetid://9064263922",
        ["Forest Rain Night"] = "rbxassetid://5356133579",
        ["Light Rain And Thunder"] = "rbxassetid://9120018695",
    },

    kViewmodelDisable = {
        "None",
        "sway",
        "tilt",
        "bobbing",
        "muzzle flash",
        "idle animation",
        "jump animation",
        "slide animation",
        "equip animation",
        "shoot animation",
        "aiming animation",
        "sprint animation"
    },

    kGunIgnoreList = {
        "None",
        "Katana",
        "Riot Shield"
    },

    kCharacterAnims = {
        "Default",
        "Zombie",
        "Oldschool",
        "Bubbly",
        "Elder",
        "Ninja",
        "Vampire",
        "Stylish",
        "Levitation",
        "Superhero",
        "Werewolf",
        "Knight",
        "Pirate"
    },

    kCharacterAnimsMap = {
        ["Default"] = {
            idle = "http://www.roblox.com/asset/?id=507766388",
            walk = "rbxassetid://10921541949",
            run = "rbxassetid://10899968825",
            jump = "http://www.roblox.com/asset/?id=507765000",
            fall = "http://www.roblox.com/asset/?id=507767968",
            climb = "http://www.roblox.com/asset/?id=507765644",
        },
        ["Zombie"] = {
            idle = "http://www.roblox.com/asset/?id=10921344533",
            walk = "http://www.roblox.com/asset/?id=10921355261",
            run = "http://www.roblox.com/asset/?id=616163682",
            jump = "http://www.roblox.com/asset/?id=10921351278",
            fall = "http://www.roblox.com/asset/?id=10921350320",
            climb = "http://www.roblox.com/asset/?id=10921343576",
        },
        ["Oldschool"] = {
            idle = "http://www.roblox.com/asset/?id=10921230744",
            walk = "http://www.roblox.com/asset/?id=10921244891",
            run = "http://www.roblox.com/asset/?id=10921240218",
            jump = "http://www.roblox.com/asset/?id=10921242013",
            fall = "http://www.roblox.com/asset/?id=10921241244",
            climb = "http://www.roblox.com/asset/?id=10921229866",
        },
        ["Bubbly"] = {
            idle = "http://www.roblox.com/asset/?id=10921054344",
            walk = "http://www.roblox.com/asset/?id=10980888364",
            run = "http://www.roblox.com/asset/?id=10921057244",
            jump = "http://www.roblox.com/asset/?id=10921062673",
            fall = "http://www.roblox.com/asset/?id=10921061530",
            climb = "http://www.roblox.com/asset/?id=10921053544",
        },
        ["Elder"] = {
            idle = "http://www.roblox.com/asset/?id=10921101664",
            walk = "http://www.roblox.com/asset/?id=10921111375",
            run = "http://www.roblox.com/asset/?id=10921104374",
            jump = "http://www.roblox.com/asset/?id=10921107367",
            fall = "http://www.roblox.com/asset/?id=10921105765",
            climb = "http://www.roblox.com/asset/?id=10921100400",
        },
        ["Ninja"] = {
            idle = "http://www.roblox.com/asset/?id=10921155160",
            walk = "http://www.roblox.com/asset/?id=10921162768",
            run = "http://www.roblox.com/asset/?id=10921157929",
            jump = "http://www.roblox.com/asset/?id=10921160088",
            fall = "http://www.roblox.com/asset/?id=10921159222",
            climb = "http://www.roblox.com/asset/?id=10921154678",
        },
        ["Vampire"] = {
            idle = "http://www.roblox.com/asset/?id=10921315373",
            walk = "http://www.roblox.com/asset/?id=10921326949",
            run = "http://www.roblox.com/asset/?id=10921320299",
            jump = "http://www.roblox.com/asset/?id=10921322186",
            fall = "http://www.roblox.com/asset/?id=10921321317",
            climb = "http://www.roblox.com/asset/?id=10921314188",
        },
        ["Stylish"] = {
            idle = "http://www.roblox.com/asset/?id=10921272275",
            walk = "http://www.roblox.com/asset/?id=10921283326",
            run = "http://www.roblox.com/asset/?id=10921276116",
            jump = "http://www.roblox.com/asset/?id=10921279832",
            fall = "http://www.roblox.com/asset/?id=10921278648",
            climb = "http://www.roblox.com/asset/?id=10921271391",
        },
        ["Levitation"] = {
            idle = "http://www.roblox.com/asset/?id=10921132962",
            walk = "http://www.roblox.com/asset/?id=10921140719",
            run = "http://www.roblox.com/asset/?id=10921135644",
            jump = "http://www.roblox.com/asset/?id=10921137402",
            fall = "http://www.roblox.com/asset/?id=10921136539",
            climb = "http://www.roblox.com/asset/?id=10921132092",
        },
        ["Superhero"] = {
            idle = "http://www.roblox.com/asset/?id=10921288909",
            walk = "http://www.roblox.com/asset/?id=10921298616",
            run = "http://www.roblox.com/asset/?id=10921291831",
            jump = "http://www.roblox.com/asset/?id=10921294559",
            fall = "http://www.roblox.com/asset/?id=10921293373",
            climb = "http://www.roblox.com/asset/?id=10921286911",
        },
        ["Werewolf"] = {
            idle = "http://www.roblox.com/asset/?id=10921330408",
            walk = "http://www.roblox.com/asset/?id=10921342074",
            run = "http://www.roblox.com/asset/?id=10921336997",
            jump = "http://www.roblox.com/asset/?id=1083218792",
            fall = "http://www.roblox.com/asset/?id=10921337907",
            climb = "http://www.roblox.com/asset/?id=10921329322",
        },
        ["Knight"] = {
            idle = "http://www.roblox.com/asset/?id=10921117521",
            walk = "http://www.roblox.com/asset/?id=10921127095",
            run = "http://www.roblox.com/asset/?id=10921121197",
            jump = "http://www.roblox.com/asset/?id=10921123517",
            fall = "http://www.roblox.com/asset/?id=10921122579",
            climb = "http://www.roblox.com/asset/?id=10921116196",
        },
        ["Pirate"] = {
            idle = "http://www.roblox.com/asset/?id=750781874",
            walk = "http://www.roblox.com/asset/?id=750785693",
            run = "http://www.roblox.com/asset/?id=750783738",
            jump = "http://www.roblox.com/asset/?id=750782230",
            fall = "http://www.roblox.com/asset/?id=750780242",
            climb = "http://www.roblox.com/asset/?id=750779899",
        },
    },

    kLerpPos = {
        "None",
        "Target",
        "Barrel"
    },

    kTargetList = {
        "FOV",
        "Visible",
    },

    kBodyParts = {
        "Head",
        "HumanoidRootPart",
        "UpperTorso",
        "LowerTorso",
        "LeftFoot",
        "LeftLowerLeg",
        "LeftUpperLeg",
        "RightFoot",
        "RightLowerLeg",
        "RightUpperLeg",
        "LeftHand",
        "LeftLowerArm",
        "LeftUpperArm",
        "RightHand",
        "RightLowerArm",
        "RightUpperArm",
    },
    
    kCheckScoped = {
        "None",
        "Sniper",
        "Crossbow"
    },
    
    kPitchOptions = {
        "None",
        "Offset",
        "Custom",
        "Random",
        "Look Up",
        "Look Down",
    },

    kYawOptions = {
        "None",
        "Offset",
        "Custom",
        "Random",
        "Spin",
        "Jitter",
        "Backwards",
    },
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
    InspectBackpackReward = require(LocalPlayer.PlayerScripts:FindFirstChild("Modules"):WaitForChild("Prompts"):WaitForChild("InspectBackpackReward")),
    LootboxEffect = require(LocalPlayer.PlayerScripts:FindFirstChild("Modules"):WaitForChild("Functions"):WaitForChild("LootboxEffect")),
    MonetizationController = require(LocalPlayer.PlayerScripts:FindFirstChild("Controllers"):WaitForChild("MonetizationController")),
    MonetizationLibrary = require(services.ReplicatedStorage:FindFirstChild("Modules"):WaitForChild("MonetizationLibrary")),
    SendChat = require(LocalPlayer.PlayerScripts:FindFirstChild("Modules"):WaitForChild("Functions"):WaitForChild("SendChat")),
    CameraController = require(LocalPlayer.PlayerScripts:FindFirstChild("Controllers"):WaitForChild("CameraController")),
    DuelLibrary = require(services.ReplicatedStorage:FindFirstChild("Modules"):WaitForChild("DuelLibrary")),
    Gun = require(LocalPlayer.PlayerScripts:FindFirstChild("Modules"):WaitForChild("ItemTypes"):WaitForChild("Gun")),
    Melee = require(LocalPlayer.PlayerScripts:FindFirstChild("Modules"):WaitForChild("ItemTypes"):WaitForChild("Melee")),
    Throwable = require(LocalPlayer.PlayerScripts:FindFirstChild("Modules"):WaitForChild("ItemTypes"):WaitForChild("Throwable")),
    Flashbang = require(LocalPlayer.PlayerScripts:FindFirstChild("Modules"):WaitForChild("Items"):WaitForChild("Flashbang")),
    SmokeClouds = require(LocalPlayer.PlayerScripts:FindFirstChild("Modules"):WaitForChild("GameComponents"):WaitForChild("SmokeClouds")),
    Utility = require(services.ReplicatedStorage:FindFirstChild("Modules"):WaitForChild("Utility")),
    OutOfBoundsMachine = require(services.ReplicatedStorage:FindFirstChild("Modules"):WaitForChild("OutOfBoundsMachine")),
    MechanicsController = require(LocalPlayer.PlayerScripts:FindFirstChild("Controllers"):WaitForChild("MechanicsController")),
    Knife = require(LocalPlayer.PlayerScripts:FindFirstChild("Modules"):WaitForChild("Items"):WaitForChild("Knife")),
    ClientEntity = require(LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses:FindFirstChild("ClientEntity")),
}

task.spawn(function()
    local fc = LocalPlayer.PlayerScripts:FindFirstChild("Controllers"):WaitForChild("FighterController")
    if fc then
        pcall(function()
            modules.FighterController = require(fc)
        end)
    end
end)

while not modules.FighterController do task.wait(0.5) end

local shoot_anim_names  = {}  -- [name] = true
local reload_anim_names = {}  -- [name] = true

local states = {
    target = nil,
    target_part = nil,
    server_cf = nil,
    is_reloading = false,
    screen_gui = Instance.new("ScreenGui"),
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
        fov_mid_color = Color3.fromRGB(255, 255, 255),
        fov_end_color = Color3.fromRGB(255, 255, 255),

        fov_outline_start_color = Color3.fromRGB(0, 0, 0),
        fov_outline_mid_color = Color3.fromRGB(0, 0, 0),
        fov_outline_end_color = Color3.fromRGB(0, 0, 0),

        fov_transparency = 0,
        fov_outline_transparency = 0,

        fov_position = { ["None"] = true },

        blocking = {},
    },
    legit_state = {
        silent_aim = {
            enabled = false,
            hit_chance = 100,
            manipulation = false,
            visualize = false,
        },
        triggerbot = {
            enabled = false,
            shoot_delay = 0,
            check_scoped = { "Sniper", "Crossbow" },

            triggerbot_shot_started = Instance.new("BindableEvent"),
            triggerbot_shot_finished = Instance.new("BindableEvent"),
            triggerbot_active = false,
        }
    },
    rage_state = {
        weapons = {
            no_recoil = false,
            no_spread = false,
            full_auto = false,
            firerate = 100,
        },
        pluggwalk = {
            enabled = false,
        },
        misc = {
            anti_tripmine = false,
            tp_throwables = false,
        },
        rage_bot = {
            enabled = false,
            void_spam = false,
            hide = 0.25,
            attack = 0.1,
            shoot_attempts = 1,
            attack_mode = "Gun",
            preferred = "Primary",
            hit_notifications = true,
            rage_hud = true,

            sync_void_state = Instance.new("BindableEvent"),
        },
        anti_aim = {
            enabled = false,
            pitch = "None",
            pitch_angle = 0,
            yaw = "None",
            yaw_angle = 0,
            jitter_angle = 20,
            speed = 10,
            underground = false,
        },
        movement = {
            fly = false,
            velocity = false,
            slide_boost = false,
            double_jump_height = false,
            infinite_double_jump = false,

            fly_speed = 50,
            velocity_speed = 50,
            slide_boost_value = 1,
            double_jump_height_value = 1,
        }
    },
    visuals_state = {
        visuals_enabled = false,
        teammates = false,
        team_colors = false,
        target_highlights = false,
        box_filled = false,
        tracer_origin = "Bottom",
        outlines = {
            Box = false,
            Skeletons = false,
            Chams = false,
            Health = false,
            Name = false,
            Tracers = false,
            Weapon = false,
            Distance = false
        },
        trails = {
            Bullets = false,
            Throwables = false,
        },
        max_distance = 150,
        cham_material = "ForceField",
        cham_texture = 0,
        viewmodel = {
            disable = { "None" },
            override_fps = false,
            fps_multi = 60,
            chams = false,
            cham_material = "ForceField",
            cham_texture = 0,
            cham_transparency = 0,
            offset = false,
            x_offset = 0,
            y_offset = 0,
            z_offset = 0,

            appearance = false,
            color = Color3.fromRGB(181, 126, 220),
            transparency = 0,
            material = "ForceField",
            wireframe = false,
            no_textures = false,
            no_clothes = false,

            appearance_cache = {},
            wireframe_cache = {},

            vm_cham_model = nil,
            vm_cham_model_name = nil,
            vm_cham_connections = {},
            vm_cham_parts = {},
        },
        animations = {
            char_anims = "Default"
        },
        skybox = {
            skybox_value = "None",
            skybox_back = "",
            skybox_down = "",
            skybox_front = "",
            skybox_left = "",
            skybox_right = "",
            skybox_up = "",
            sun_texture = "",
            moon_texture = "",
            star_count = 3000,
            sun_angular_size = 21,
            moon_angular_size = 11,
            clocktime = services.Lighting.ClockTime,

            auto_rotate = false,
            auto_rotate_conn = nil,
            auto_rotate_speed = 1
        },
        crosshair = {
            enabled = false,
            fill_color = Color3.fromRGB(255, 255, 255),
            outline_color = Color3.fromRGB(0, 0, 0),
            rotation = 0,
            rotation_speed = 0.5,
            bounce = 0,
            bounce_speed = 0.1,
            offset = 5,
            length = 20,
            thickness = 2,
            lerp = 1,
            position = { "None" },
        },
        colors = {
            enemy_box_fill_color = Color3.fromRGB(106, 13, 173),
            enemy_box_outline_color = Color3.fromRGB(181, 126, 220),
            enemy_tracer_color = Color3.fromRGB(131, 38, 198),
            enemy_chams_fill_color = Color3.fromRGB(106, 13, 173),

            friendly_box_outline_color = Color3.fromRGB(120, 180, 255),
            friendly_box_fill_color = Color3.fromRGB(50, 138, 220),
            friendly_chams_fill_color = Color3.fromRGB(50, 138, 220),
            friendly_tracer_color = Color3.fromRGB(50, 138, 220),

            trail_color = Color3.fromRGB(181, 126, 220),
            viewmodel_chams_color = Color3.fromRGB(181, 126, 220),
            target_highlight_color = Color3.fromRGB(255, 255, 255),

            chams_fill_transparency = 0,
            tracer_transparency = 1,
        },
        sunrays = {
            sunrays_enabled = false,
            sunrays_intensity = 0.25,
            sunrays_spread = 1,
        },
        camera = {
            state_changer = false,
            camera_state = "ThirdPerson",

            anti_flashbang = false,
            anti_smoke = false,

            camera_fov = modules.CameraController._base_fov,
            camera_resolution = 1,
        },
        lighting = {
            ambient_color = services.Lighting.Ambient,
            outdoor_ambient_color = services.Lighting.OutdoorAmbient,
            shift_top = services.Lighting.ColorShift_Top,
            shift_bottom = services.Lighting.ColorShift_Bottom,
            exposure = services.Lighting.ExposureCompensation,
            brightness = services.Lighting.Brightness,
            shadow_softness = services.Lighting.ShadowSoftness,
            diffuse_scale = services.Lighting.EnvironmentDiffuseScale,
            specular_scale = services.Lighting.EnvironmentSpecularScale,
            global_shadows = services.Lighting.GlobalShadows,
            lighting_style = "Realistic"
        },
        atmosphere = {
            density = 0.255,
            offset = 0.2,
            color = Color3.fromRGB(140, 196, 231),
            decay = Color3.fromRGB(92, 60, 13),
            glare = 0,
            haze = 1.82,
        },
        color_correction = {
            enabled = true,
            brightness = 0,
            contrast = 0,
            saturation = 0,
            tint_color = Color3.fromRGB(255, 255, 255)
        },
        weather = {
            enabled = false,
            type = "Rain",
            rate = 1,
            timescale = 1,

            thunder_active = false,
            thunder_loop = nil,
        },
        ambience = {
            enabled = false,
            type = "Rain",
            volume = 0.5
        }
    },

    skinchanger_state = {
        constructing_weapon = nil,
        viewing_profile = nil,
        last_used_weapon = nil,
        fake_owned = modules.PlayerDataController:Get("CosmeticInventory"),
        fake_weapon_owned = modules.PlayerDataController:Get("WeaponInventory"),
        equipped = {},
        placed_object_map = {},
        favorites = modules.PlayerDataController:Get("FavoritedCosmetics"),
        
        general_unlocker = {
            unlock_type = "Skin",
            unlock_rarity = "Common",
        },

        specific_unlocker = {
            unlock_type = "Skin",
            cosmetic_name = "",
            weapon_name = "",
        },

        equip_unlocker = {
            unlock_type = "Skin",
            cosmetic_name = "",
            weapon_name = "",
            inverted = false,
        },

        shoot_sound = {
            sound_value = "",
            sound_asset_id = nil,
            sound_url = "",
            sound_volume = 50,
            sound_pitch = 10,
        },

        reload_sound = {
            sound_value = "",
            sound_asset_id = nil,
            sound_url = "",
            sound_volume = 50,
            sound_pitch = 10,
        },

        hit_sound = {
            sound_value = "",
            sound_asset_id = nil,
            sound_url = "",
            sound_volume = 50,
            sound_pitch = 10,
        },

        crit_sound = {
            sound_value = "",
            sound_asset_id = nil,
            sound_url = "",
            sound_volume = 50,
            sound_pitch = 10,
        },

        death_sound = {
            sound_value = "",
            sound_asset_id = nil,
            sound_url = "",
            sound_volume = 50,
            sound_pitch = 10,
        },

        kill_sound = {
            sound_value = "",
            sound_asset_id = nil,
            sound_url = "",
            sound_volume = 50,
            sound_pitch = 10,
        },
    },

    spoofer_state = {
        device = "Desktop",
        old_device = tostring(modules.ControlsController.CurrentControls),
        spoof_device = false,
        device_spam = false,
        spam_rate = 1,

        display_name_value = LocalPlayer.DisplayName,
        username_value = LocalPlayer.Name,
        display_name = false,
        username = false,
        name_spoof_conn = {},

        avatar_userid = LocalPlayer.UserId,
        spoof_avatar = false,
        thumb_spoof_conn = {},

        anonymous_mode = false,
        fake_names = {},
        anon_connections = {},

        leaderboard = {
            elo_value = 0,
            streak_value = LocalPlayer:GetAttribute("StatisticDuelsWinStreak"),
            kills_value = 0,
            wins_value = 0,
            level_value = LocalPlayer:GetAttribute("Level"),

            old_streak_value = LocalPlayer:GetAttribute("StatisticDuelsWinStreak"),
            old_level_value = LocalPlayer:GetAttribute("Level"),

            ELO = false,
            Streak = false,
            Kills = false,
            Wins = false,
            Level = false,
        },

        badges = {
            Premium = false,
            Verified = false,
            Influencer = false,
            Admin = false
        },

        charm = {
            charm_rank = "Use Spoofed ELO",
            arch_rank = 1,
            s0_charm = false,
            s1_charm = false,
            s2_charm = false,
            s3_charm = false
        },

        currency = {
            weapon_keys = false,
            unlock_tokens = false,
            event_currency = false,
            glory = false,
            skin_tickets = false,

            weapon_keys_value = modules.PlayerDataController:Get("WeaponKeys"),
            unlock_tokens_value = modules.PlayerDataController:Get("UnlockTokens"),
            event_currency_value = modules.PlayerDataController:Get("EventCurrency"),
            glory_value = modules.PlayerDataController:Get("Glory"),
            skin_tickets_value = modules.PlayerDataController:Get("SkinTickets")
        },

        duel_history = {
            duel_history_value = modules.PlayerDataController:Get("DuelHistory"),
            logged_elo_events = modules.PlayerDataController:Get("LoggedELOEvents"),

            match_index = 1,
            mode = "Ranked",
            result = "Victory",
            map = "Factory",
            team1score = 5,
            team2score = 0,

            dueler_index = 1,
            username = "",
            display_name = "",

            kills = 15,
            deaths = 2,
            assists = 6,
            damage = 5000,
            elo = 2000,
            elo_change = 35,
        },

        marketplace = {
            fake_bundles_owned = modules.PlayerDataController:Get("GamepassBundlesClaimed"),
            fake_gift_robux_spent = modules.PlayerDataController:Get("GiftRobuxSpentProgress"),
            fake_gift_rewards_claimed = modules.PlayerDataController:Get("GiftRobuxSpentRewardsClaimed"),

            fake_robux = false,
            robux_amount = 0,
            fake_gifting = false
        }
    },

    inventory_state = {
        fake_owned = modules.PlayerDataController:Get("UnclaimedRewards"),

        specific = {
            lootbox_name = "Skin Case",
            quantity = 1,
            weapon_name = "",
            new_entry = false
        },

        bulk = {
            quantity = 1,
        },

        delete = {
            backpack_entry = "",
            quantity = 1
        },

        inject = {
            item_type = "Skin",
            weapon_name = "",
            cosmetic_name = "",
            stack_duplicates = false
        }
    }
}

local ui_objects = {

}

local caches = {
    asset_cache = {},
    sound_cache = {},
    objectid_to_weapon_cache = {},
    image_cache = {}
}

local ChangeLogs = tostring(request({
    Url = kConstants.kBaseURL .. "rivals_changelog.txt",
    Method = "GET",
    Headers = {
        ["Content-Type"] = "application/json"
    }
}).Body)

local EspInterface = loadstring(request({
    Url = kConstants.kBaseURL .. "Sense.luau",
    Method = "GET",
    Headers = {
        ["Content-Type"] = "application/json"
    }
}).Body)()

local Library = loadstring(request({
    Url = kConstants.kBaseURL .. "AethereaUI.luau",
    Method = "GET",
    Headers = {
        ["Content-Type"] = "application/json"
    }
}).Body)()

if EspInterface == nil or Library == nil then
	warn("Failed to load sources")
	getgenv().HI_I_HAVE_BALL_CANCER = nil
	return
end

EspInterface.GetWeapon = LPH_NO_VIRTUALIZE(function(player)
    local fighter = modules.FighterController:GetFighter(player)
    if not fighter then
        return "Unknown"
    end

    local equippedItem = fighter.EquippedItem
    if not equippedItem then
        return "Unknown"
    end

    return equippedItem.Name
end)

EspInterface.IsFriendly = LPH_NO_VIRTUALIZE(function(player)
    local our_team = LocalPlayer:GetAttribute("TeamID")
    local their_team = player:GetAttribute("TeamID")

    return their_team and their_team == our_team
end)

EspInterface.GetTeamColor = LPH_NO_VIRTUALIZE(function(player)
    local teams = rawget(modules.DuelLibrary, "TeamsByID")
    local team = rawget(teams, player:GetAttribute("TeamID"))

    return team and rawget(team, "Color") or rawget(modules.DuelLibrary, "EMPTY_TEAM_COLOR")
end)

EspInterface.Load()

--[[
    Extra Assets
]]

local Assets = {}

local function EnsureFolder(path)
    if isfolder and not isfolder(path) then
        makefolder(path)
    end
end

function Assets.Register(id, url)
    local ext = url:match("%.([%w]+)$")

    if not ext then
        ext = "dat"
    end

    caches.asset_cache[tostring(id)] = {
        url = url,
        uri = nil,
        extension = ext
    }
end

function Assets.Preload()
    local has_gca = type(getcustomasset) == "function"
    local has_fs = type(writefile) == "function"
        and type(readfile) == "function"
        and type(isfile) == "function"

    EnsureFolder(kConstants.kBaseFolderName)
    EnsureFolder(kConstants.kBaseFolderName .. "/assets")

    for id, entry in pairs(caches.asset_cache) do
        if entry.uri then
            continue
        end

        local file_path = string.format(
            "%s/assets/%s.%s",
            kConstants.kBaseFolderName,
            id,
            entry.extension
        )

        if has_gca and has_fs then
            if not isfile(file_path) then
                local ok, body = pcall(function()
                    return http_get(entry.url)
                end)

                if ok and body and #body > 0 then
                    writefile(file_path, body)
                end
            end

            if isfile(file_path) then
                local ok, asset = pcall(getcustomasset, file_path)

                if ok then
                    entry.uri = asset
                end
            end
        end

        entry.uri = entry.uri or ("rbxassetid://" .. id)
    end
end

function Assets.Get(id)
    local entry = caches.asset_cache[tostring(id)]

    if not entry then
        return ""
    end

    return entry.uri or ("rbxassetid://" .. tostring(id))
end

for _, path in pairs(kConstants.kSoundModsMap) do
    local name = path:match("([^/]+)%.")
    local url = kConstants.kBaseURL .. path

    Assets.Register("sound_" .. name, url)
end
Assets.Preload()

--[[
    Main Logic
]]

local Connections = {}

local function Bind(name, signal, fn)
    if Connections[name] then
        Connections[name]:Disconnect()
    end
    Connections[name] = signal:Connect(fn)
end

local function Unbind(name)
    if Connections[name] then
        Connections[name]:Disconnect()
        Connections[name] = nil
    end
end

if modules.EnumLibrary and modules.EnumLibrary.WaitForEnumBuilder then
    pcall(function()
        modules.EnumLibrary:WaitForEnumBuilder()
    end)
end

if modules.PlayerDataController and modules.PlayerDataController.WaitUntilLoaded then
    pcall(function()
        modules.PlayerDataController:WaitUntilLoaded()
    end)
end

local frozen = false
local org_cam = modules.CameraController.Update
modules.CameraController.Update = LPH_NO_VIRTUALIZE(function(self, ...)
    if frozen then
        return
    end

    return org_cam(self, ...)
end)

local function FreezeCamera()
    frozen = true
end

local function UnfreezeCamera()
    frozen = false
end

local orig_startrl = modules.Gun.StartReloading
modules.Gun.StartReloading = LPH_NO_VIRTUALIZE(function(u21, p22, p23, p24, p25)
    states.is_reloading = true
    task.delay(u21.Info.ReloadLength + 0.1, function()
        states.is_reloading = false
    end)

    return orig_startrl(u21, p22, p23, p24, p25)
end)

pcall(function()
    states.screen_gui.Name = ""
    states.screen_gui.Parent = gethui()
    states.screen_gui.IgnoreGuiInset = true
end)

--[[
    Server CF
]]

local server_cf_sync = true

pcall(LPH_JIT_MAX(function()
    local real
    local real_lin_vel
    local real_ang_vel

    services.RunService:BindToRenderStep(tostring(math.random(100000, 999999)), 0, LPH_NO_VIRTUALIZE(function()
        local root = LocalChar and LocalChar.PrimaryPart
        if not root or not root.Parent or not real then
            return
        end

        root.AssemblyLinearVelocity = real_lin_vel or Vector3.zero
        root.AssemblyAngularVelocity = real_ang_vel or Vector3.zero
        root.CFrame = real
    end))

    services.RunService.PostSimulation:Connect(LPH_NO_VIRTUALIZE(function()
        local root = LocalChar and LocalChar.PrimaryPart
        if not root or not root.Parent then
            return
        end

        real = root.CFrame
        real_lin_vel = root.AssemblyLinearVelocity
        real_ang_vel = root.AssemblyAngularVelocity

        if server_cf_sync then
            states.server_cf = real
        end

        root.CFrame = states.server_cf
    end))
end))

local function ServerCFDesync()
    server_cf_sync = false
end

local function ServerCFSync()
    server_cf_sync = true
end

--[[
    OOB Exploit
]]

local oob_remote = services.ReplicatedStorage:FindFirstChild("Remotes").Replication.Fighter.OutOfBounds
if not oob_remote then
    LocalPlayer:Kick("Couldn't initialize Aetherea.")
end

NamecallDispatcher:Register(LPH_JIT_MAX(function(self, method, ...)
    if method ~= "FireServer" or self ~= oob_remote then
        return false
    end

    return true
end))

modules.OutOfBoundsMachine.IsOutOfBounds = function()
    return false
end

modules.OutOfBoundsMachine.Update = LPH_NO_VIRTUALIZE(function()
    return
end)

modules.GameplayUtility.GetOOBWarnDelay = function()
    return 9999
end

modules.GameplayUtility.GetOOBKillDelay = function()
    return 9999
end

modules.GameplayUtility.IsWithinOOBPart = function()
    return
end

--[[
    Targeting
]]

GetMuzzlePos = LPH_JIT_MAX(function()
    local vms = workspace:FindFirstChild("ViewModels")
    if not vms then
        return nil
    end

    local first_person = vms:FindFirstChild("FirstPerson")
    if not first_person then
        return nil
    end

    local player_name = LocalPlayer.Name
    for _, model in pairs(first_person:GetChildren()) do
        if not model:IsA("Model") or not model.Name:find("^" .. player_name) then
            continue
        end

        local item_visual = model:FindFirstChild("ItemVisual")
        if not item_visual then
            continue
        end

        local body = item_visual:FindFirstChild("Body")
        if not body then
            continue
        end

        local body_primary = body:FindFirstChild("BodyPrimary")
        if not body_primary then
            continue
        end

        local muzzle = body_primary:FindFirstChild("_muzzle")
        if muzzle and muzzle:IsA("Attachment") then
            return muzzle.WorldPosition
        end
    end

    return nil
end)

WorldToScreen = LPH_NO_VIRTUALIZE(function(world_position)
    local screen_point, on_screen = workspace.CurrentCamera:WorldToViewportPoint(world_position)
    return Vector2.new(screen_point.X, screen_point.Y), on_screen, screen_point.Z
end)

SetTarget = LPH_NO_VIRTUALIZE(function(player, part)
    states.target = player
    states.target_part = part
    EspInterface.SetTarget(player)
end)

pcall(function()
    task.wait(3)
    task.spawn(function()
        local katana_path = LocalPlayer.PlayerScripts.Modules.Items:FindFirstChild("Katana", true)
        local riot_path = LocalPlayer.PlayerScripts.Modules.Items:FindFirstChild("Riot Shield", true)
        local katana = require(katana_path)
        local riot = require(riot_path)

        if katana and type(katana) == "table" and katana.StartAiming then
            local old = katana.StartAiming
            katana.StartAiming = function(self, force)
                if not table.find(states.targeting_state.ignore, "Katana") then
                    return old(self, force)
                end

                local fighter = self.ClientFighter
                local player = fighter and fighter.Player
                if player then
                    states.targeting_state.blocking[player.Name] = true
                    local dur = self.Info.DeflectDuration or 0.6
                    task.delay(dur, function()
                        states.targeting_state.blocking[player.Name] = nil
                    end)
                end
                return old(self, force)
            end
        end

        if riot and type(riot) == "table" and riot._UpdateUnequippedViewModel then
            local old = riot._UpdateUnequippedViewModel
            riot._UpdateUnequippedViewModel = function(self, ...)
                if not table.find(states.targeting_state.ignore, "Riot Shield") then
                    return old(self, ...)
                end

                local was_on_back = self._shieldOnBack
                local fighter = self.ClientFighter
                local player = fighter and fighter.Player
                local on_back = not (self.IsEquipped or fighter:IsActuallyFirstPerson()) and not fighter:Get("IsHiddenByEmotes")

                if was_on_back ~= on_back then
                    self._shieldOnBack = on_back

                    if on_back then
                        states.targeting_state.blocking[player.Name] = true
                    else
                        states.targeting_state.blocking[player.Name] = nil
                    end
                end
                return old(self, ...)
            end
        end
    end)

    local fov_frame = Instance.new("Frame")
    fov_frame.Name = ""
    fov_frame.Parent = states.screen_gui
    fov_frame.AnchorPoint = Vector2.new(0.5, 0.5)
    fov_frame.Position = UDim2.fromScale(0.5, 0.5)
    fov_frame.Size = UDim2.fromScale(1, 1)
    fov_frame.BackgroundTransparency = 1
    fov_frame.BorderSizePixel = 0
    fov_frame.ZIndex = 1

    local fov_circle_inline = Instance.new("Frame")
    fov_circle_inline.Name = ""
    fov_circle_inline.Parent = fov_frame
    fov_circle_inline.AnchorPoint = Vector2.new(0.5, 0.5)
    fov_circle_inline.BackgroundTransparency = 1
    fov_circle_inline.ZIndex = 1

    local fov_circle_inline_stroke = Instance.new("UIStroke")
    fov_circle_inline_stroke.Name = ""
    fov_circle_inline_stroke.Parent = fov_circle_inline
    fov_circle_inline_stroke.Color = Color3.new(1, 1, 1)
    fov_circle_inline_stroke.Thickness = 1

    local fov_circle_inline_grad = Instance.new("UIGradient")
    fov_circle_inline_grad.Name = ""
    fov_circle_inline_grad.Parent = fov_circle_inline_stroke

    local fov_circle = Instance.new("Frame")
    fov_circle.Name = ""
    fov_circle.Parent = fov_frame
    fov_circle.AnchorPoint = Vector2.new(0.5, 0.5)
    fov_circle.ZIndex = 2

    local fov_circle_stroke = Instance.new("UIStroke")
    fov_circle_stroke.Name = ""
    fov_circle_stroke.Parent = fov_circle
    fov_circle_stroke.Color = Color3.new(1, 1, 1)
    fov_circle_stroke.Thickness = 1

    local fov_circle_grad = Instance.new("UIGradient")
    fov_circle_grad.Name = ""
    fov_circle_grad.Parent = fov_circle_stroke

    local fov_circle_fill =  Instance.new("UIGradient")
    fov_circle_fill.Name = ""
    fov_circle_fill.Parent = fov_circle

    local fov_circle_outline =  Instance.new("Frame")
    fov_circle_outline.Name = ""
    fov_circle_outline.Parent = fov_frame
    fov_circle_outline.AnchorPoint = Vector2.new(0.5, 0.5)
    fov_circle_outline.BackgroundTransparency = 1
    fov_circle_outline.ZIndex = 3

    local fov_circle_outline_stroke = Instance.new("UIStroke")
    fov_circle_outline_stroke.Name = ""
    fov_circle_outline_stroke.Parent = fov_circle_outline
    fov_circle_outline_stroke.Color = Color3.new(1, 1, 1)
    fov_circle_outline_stroke.Thickness = 1

    local fov_circle_outline_grad = Instance.new("UIGradient")
    fov_circle_outline_grad.Name = ""
    fov_circle_outline_grad.Parent = fov_circle_outline_stroke

    local circle_mod = Instance.new("UICorner")
    circle_mod.Name = ""
    circle_mod.Parent = fov_circle_inline
    circle_mod.CornerRadius = UDim.new(1, 0)
    circle_mod:Clone().Parent = fov_circle
    circle_mod:Clone().Parent = fov_circle_outline

    local camera = workspace.CurrentCamera
    local raycast_params = RaycastParams.new()
    raycast_params.FilterType = Enum.RaycastFilterType.Exclude
    raycast_params.IgnoreWater = true
    raycast_params.FilterDescendantsInstances = {
        LocalPlayer.Character
    }
    LocalPlayer.CharacterAdded:Connect(function(char)
        raycast_params.FilterDescendantsInstances = {char}
    end)

    local wallcheck_cache = {}
    local wallcheck_cache_ttl = 0.15

    local WallCheck = LPH_NO_VIRTUALIZE(function(character, part)
        if not states.targeting_state.wallcheck then
            return true
        end

        local char_cache = wallcheck_cache[character]
        if not char_cache then
            char_cache = {}
            wallcheck_cache[character] = char_cache
        end

        local now = os.clock()
        local cached = char_cache[part]
        if cached and (now - cached.time) < wallcheck_cache_ttl then
            return cached.value
        end

        local origin = camera.CFrame.Position
        local result = workspace:Raycast(origin, part.Position - origin, raycast_params)
        local passed = not result or result.Instance:IsDescendantOf(character)

        char_cache[part] = {
            time = now,
            value = passed,
        }

        return passed
    end)

    local FindBestTarget = LPH_JIT_MAX(function()
        local origin = camera.CFrame.Position
        
        local best_part
        local best_player
        local best_distance = math.huge

        for _, player in services.Players:GetPlayers() do
            if player == LocalPlayer then
                continue
            end

            local character = player.Character
            if not character then
                continue
            end
            
            local root = character:FindFirstChild("HumanoidRootPart")
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if not root or not humanoid or humanoid.Health <= 0 then
                continue
            end

            local their_team = player:GetAttribute("TeamID")
            if their_team and their_team == LocalPlayer:GetAttribute("TeamID") then
                continue
            end

            if states.targeting_state.blocking[player.Name] then
                continue
            end

            local root_dist = (root.Position - origin).Magnitude
            if root_dist > (states.targeting_state.max_distance + 6) then
                continue
            end

            local closest_part = nil
            local closest = math.huge

            if states.targeting_state.target == "Closest Part" then
                for _, part_name in states.targeting_state.include_parts do
                    if type(part_name) ~= "string" then
                        continue
                    end

                    local part = character:FindFirstChild(part_name)
                    if not part or not part:IsA("BasePart") then
                        continue
                    end

                    local world_dist = (part.Position - origin).Magnitude
                    if world_dist > states.targeting_state.max_distance then
                        continue
                    end

                    local screen, visible = camera:WorldToViewportPoint(part.Position)
                    if not visible and screen.Z <= 0 then
                        continue
                    end

                    local dx = screen.X - fov_circle.Position.X.Offset
                    local dy = screen.Y - fov_circle.Position.Y.Offset
                    local screen_dist = dx * dx + dy * dy
                    local radius_sq = states.targeting_state.radius * states.targeting_state.radius

                    if states.targeting_state.target_group == "FOV" and screen_dist > radius_sq then
                        continue
                    end

                    local score = (screen_dist * states.targeting_state.weight_ratio) + (world_dist * (1 - states.targeting_state.weight_ratio))

                    if score < closest then
                        closest = score
                        closest_part = part
                    end
                end
            else
                local part = character:FindFirstChild(states.targeting_state.target)
                if part and part:IsA("BasePart") then
                    local world_dist = (part.Position - origin).Magnitude

                    if world_dist <= states.targeting_state.max_distance then
                        local screen, visible = camera:WorldToViewportPoint(part.Position)

                        if visible or screen.Z > 0 then
                            local dx = screen.X - fov_circle.Position.X.Offset
                            local dy = screen.Y - fov_circle.Position.Y.Offset
                            local screen_dist = dx * dx + dy * dy
                            local radius_sq = states.targeting_state.radius * states.targeting_state.radius

                            if states.targeting_state.target_group ~= "FOV" or screen_dist <= radius_sq then
                                closest = (screen_dist * states.targeting_state.weight_ratio) + (world_dist * (1 - states.targeting_state.weight_ratio))
                                closest_part = part
                            end
                        end
                    end
                end
            end

            if not closest_part or closest >= best_distance then
                continue
            end

            if not WallCheck(character, closest_part) then
                continue
            end

            best_distance = closest
            best_player = player
            best_part = closest_part
        end

        return best_player, best_part
    end)

    local pending_player
    local pending_part
    local pending_time = 0

    local current_player
    local current_part
    local current_lost_time = 0

    local next_search = 0
    local current_pos = UDim2.fromOffset((camera.ViewportSize / 2).X, (camera.ViewportSize / 2).Y)
    local target_scan_interval = 0.03

    services.RunService.RenderStepped:Connect(LPH_NO_VIRTUALIZE(function()
        local now = os.clock()
        local state = states.targeting_state

        if not (states.legit_state.silent_aim.enabled or states.rage_state.rage_bot.enabled or states.legit_state.triggerbot.enabled or state.show_fov) then
            if current_player then
                current_player = nil
                current_part = nil
                current_lost_time = 0
                SetTarget(nil, nil)
            end
            fov_frame.Visible = false
            return
        end

        fov_frame.Visible = state.show_fov

        local target_pos = UDim2.fromOffset((camera.ViewportSize / 2).X, (camera.ViewportSize / 2).Y)
        if state.fov_position["Barrel"] and not states.target_part then
            local muzzle_pos = GetMuzzlePos()
            if muzzle_pos then
                local screenPos, on_screen = WorldToScreen(muzzle_pos)
                if on_screen then
                    target_pos = UDim2.fromOffset(screenPos.X, screenPos.Y)
                else
                    target_pos = UDim2.fromOffset((camera.ViewportSize / 2).X, (camera.ViewportSize / 2).Y)
                end
            end
        end

        if state.fov_position["Target"] and states.target_part then
            local hitbox_pos = states.target_part.Position
            if hitbox_pos then
                local screenPos, on_screen = WorldToScreen(hitbox_pos)
                if on_screen then
                    target_pos = UDim2.fromOffset(screenPos.X, screenPos.Y)
                else
                    target_pos = UDim2.fromOffset((camera.ViewportSize / 2).X, (camera.ViewportSize / 2).Y)
                end
            end
        end

        if state.fov_lerp and state.fov_lerp > 0 then
            current_pos = current_pos:Lerp(target_pos, state.fov_lerp)
        else
            current_pos = target_pos
        end

        local radius = state.radius
        local transparency = state.fov_transparency
        local rotation = state.fov_rotation
        local rot_speed = state.fov_rotation_speed * 0.5
        if state.fov_rotation_speed > 0 then
            rotation = (state.fov_rotation + now * rot_speed * 360) % 360
        end

        local color_start = state.fov_start_color
        local color_mid = state.fov_mid_color
        local color_end = state.fov_end_color

        local outline_transparency = state.fov_outline_transparency
        local outline_color_start = state.fov_outline_start_color
        local outline_color_mid = state.fov_outline_mid_color
        local outline_color_end = state.fov_outline_end_color

        fov_circle_inline.Position = current_pos
        fov_circle_inline.Size = UDim2.fromOffset((radius * 2) - 2, (radius * 2) - 2)
        fov_circle_inline.Visible = state.fov_outline
        fov_circle_inline_stroke.Transparency = outline_transparency
        fov_circle_inline_grad.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, outline_color_start), ColorSequenceKeypoint.new(0.5, outline_color_mid), ColorSequenceKeypoint.new(1, outline_color_end)}
        fov_circle_inline_grad.Rotation = rotation

        fov_circle.Position = current_pos
        fov_circle.Size = UDim2.fromOffset(radius * 2, radius * 2)
        fov_circle.Visible = state.show_fov
        fov_circle.BackgroundTransparency = state.fov_fill and math.clamp(0.35 + (transparency * 0.65), 0, 1) or 1
        fov_circle_stroke.Transparency = transparency
        fov_circle_grad.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, color_start), ColorSequenceKeypoint.new(0.5, color_mid), ColorSequenceKeypoint.new(1, color_end)}
        fov_circle_grad.Rotation = rotation
        fov_circle_fill.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, color_start), ColorSequenceKeypoint.new(0.5, color_mid), ColorSequenceKeypoint.new(1, color_end)}
        fov_circle_fill.Rotation = rotation

        fov_circle_outline.Position = current_pos
        fov_circle_outline.Size = UDim2.fromOffset((radius * 2) + 2, (radius * 2) + 2)
        fov_circle_outline.Visible = state.fov_outline
        fov_circle_outline_stroke.Transparency = outline_transparency
        fov_circle_outline_grad.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, outline_color_start), ColorSequenceKeypoint.new(0.5, outline_color_mid), ColorSequenceKeypoint.new(1, outline_color_end)}
        fov_circle_outline_grad.Rotation = rotation

        if now < next_search then
            return
        end

        next_search = now + math.max(state.reaction_time / 1000, target_scan_interval)

        local best_player, best_part = FindBestTarget()

        if best_player ~= pending_player or best_part ~= pending_part then
            pending_player = best_player
            pending_part = best_part
            pending_time = now
            return
        end

        if best_player then
            current_lost_time = 0

            if current_player ~= best_player or current_part ~= best_part then
                if now - pending_time >= state.reaction_time / 1000 then
                    current_player = best_player
                    current_part = best_part
                    SetTarget(best_player, best_part)
                end
            end

            return
        end

        if not current_player then
            current_lost_time = 0
            return
        end

        if state.forget_time <= 0 then
            current_player = nil
            current_part = nil
            SetTarget(nil, nil)
            return
        end

        if current_lost_time == 0 then
            current_lost_time = now
            return
        end

        if now - current_lost_time >= state.forget_time then
            current_player = nil
            current_part = nil
            current_lost_time = 0
            SetTarget(nil, nil)
        end
    end))
end)

--[[
    Legit
]]

local candidates = {
    Vector3.new(5, 3, 5),
    Vector3.new(-5, 3, 5),
    Vector3.new(5, 3, -5),
    Vector3.new(-5, 3, -5),

    Vector3.new(0, 5, 8),
    Vector3.new(0, 5, -8),
}

local overlap_params = OverlapParams.new()
overlap_params.FilterType = Enum.RaycastFilterType.Exclude

local ray_
