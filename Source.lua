local O = "Accent"
local aa = game:GetService("TweenService")
local p = game:GetService("UserInputService")
local ao = game:GetService("GuiService")
local ab = game:GetService("RunService")
local H = game:GetService("HttpService")
local I = game:GetService("Players")
local J = I.LocalPlayer
local e = { Flags = {}, Windows = {} }

local function n(b, c)
    local a = {}
    if type(b) == "string" then
        a.Name = b
    elseif type(b) == "table" then
        for k, v in pairs(b) do a[k] = v end
    end
    for k, v in pairs(c or {}) do
        if a[v] == nil and a[k] ~= nil then a[v] = a[k] end
    end
    if a.Range then
        a.Min = a.Min or a.Range[1]
        a.Max = a.Max or a.Range[2]
    end
    return a
end

local ac
local function q(g, b, a, d, h, f)
    a._type = h
    a._frame = d
    a._listeners = a._listeners or {}
    local c = g and g.Window
    if b.Flag then
        e.Flags[b.Flag] = a
        if c then
            c.Flags[b.Flag] = a
            f = f or "Callback"
            local orig = b[f]
            b[f] = function(...)
                if type(orig) == "function" then orig(...) end
                c:_autoSave()
            end
        end
    end
    function a:Destroy()
        if a._destroyed then return end
        a._destroyed = true
        for _, fn in ipairs(a._listeners) do fn() end
        a._listeners = {}
        if b.Flag then
            if e.Flags[b.Flag] == a then e.Flags[b.Flag] = nil end
            if c and c.Flags[b.Flag] == a then c.Flags[b.Flag] = nil end
        end
        if c then c._controlsDirty = true end
        if d then d:Destroy() end
    end
    if d then ac(a, d, b) end
    return a
end

local K = {"Background","Surface","Surface2","Surface3","Stroke","StrokeHover",O,"AccentDark","Text","Muted","Glow","Warning","Success","Error"}
local function d(a, b, c) return Color3.fromRGB(a, b, c) end

local ap = {
    Warning = d(240,176,108),
    Success = d(150,220,170),
    Error = d(240,120,120)
}

local function x(a)
    for k, v in pairs(ap) do
        if a[k] == nil then a[k] = v end
    end
    return a
end

e.Themes = {
    Default = x{
        Background = d(10,10,10), Surface = d(15,15,15), Surface2 = d(20,20,20), Surface3 = d(30,30,30),
        Stroke = d(50,50,50), StrokeHover = d(100,100,100), Accent = d(255,255,255), AccentDark = d(0,0,0),
        Text = d(255,255,255), Muted = d(180,180,180), Glow = d(255,255,255)
    },
    Midnight = x{
        Background = d(14,16,22), Surface = d(18,21,28), Surface2 = d(22,25,34), Surface3 = d(36,41,54),
        Stroke = d(32,36,48), StrokeHover = d(70,80,104), Accent = d(150,180,255), AccentDark = d(12,16,28),
        Text = d(226,230,240), Muted = d(122,131,153), Glow = d(210,220,240)
    },
    Moss = x{
        Background = d(15,18,15), Surface = d(19,23,19), Surface2 = d(23,28,23), Surface3 = d(37,44,37),
        Stroke = d(33,40,33), StrokeHover = d(72,88,72), Accent = d(176,222,170), AccentDark = d(14,22,14),
        Text = d(228,234,227), Muted = d(121,136,119), Glow = d(214,230,212)
    },
    Ember = x{
        Background = d(20,16,13), Surface = d(25,20,16), Surface2 = d(30,24,19), Surface3 = d(46,37,30),
        Stroke = d(42,34,27), StrokeHover = d(96,76,58), Accent = d(255,190,140), AccentDark = d(28,18,10),
        Text = d(240,232,226), Muted = d(146,129,113), Glow = d(240,222,208)
    },
    Rose = x{
        Background = d(21,14,17), Surface = d(26,18,21), Surface2 = d(31,21,25), Surface3 = d(48,34,40),
        Stroke = d(44,30,36), StrokeHover = d(100,66,80), Accent = d(255,170,195), AccentDark = d(30,12,18),
        Text = d(240,228,232), Muted = d(149,124,133), Glow = d(240,214,222)
    },
    Mono = x{
        Background = d(16,16,17), Surface = d(20,20,21), Surface2 = d(24,24,26), Surface3 = d(40,40,43),
        Stroke = d(36,36,39), StrokeHover = d(80,80,86), Accent = d(230,230,235), AccentDark = d(18,18,20),
        Text = d(232,232,236), Muted = d(130,130,136), Glow = d(220,220,226)
    }
}

e.Theme = table.clone(e.Themes.Default)
e.ThemeName = "Default"
e.Assets = {
    Shadow = "rbxassetid://6014261993",
    Glow = "rbxassetid://8992230677",
    Logo = "rbxassetid://103859712365480"
}

local E
local function P()
    if E ~= nil then return E end
    local ok, res = pcall(function()
        local src = game:HttpGet("https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/lucide/dist/Icons.lua")
        return loadstring(src)()
    end)
    if ok and type(res) == "table" then
        E = res
    else
        E = false
        warn("[AirFlow] lucide icons unavailable: " .. tostring(res))
    end
    return E
end

local aq = {
    ValleySans = {
        Regular = "https://raw.githubusercontent.com/HelsinkiTypeStudio/valley-sans/main/fonts/ttf/ValleySans-Regular.ttf",
        Medium = "https://raw.githubusercontent.com/HelsinkiTypeStudio/valley-sans/main/fonts/ttf/ValleySans-Medium.ttf",
        SemiBold = "https://raw.githubusercontent.com/HelsinkiTypeStudio/valley-sans/main/fonts/ttf/ValleySans-SemiBold.ttf"
    }
}

local ad = {
    Regular = {400, Enum.FontWeight.Regular},
    Medium = {500, Enum.FontWeight.Medium},
    SemiBold = {600, Enum.FontWeight.SemiBold},
    Bold = {700, Enum.FontWeight.Bold}
}

function e:LoadFont(b)
    local ftype = "function"
    b = n(b, {})
    if type(writefile) ~= ftype or type(isfile) ~= ftype or typeof(getcustomasset) ~= ftype then
        warn("[AirFlow] custom fonts need writefile, isfile and getcustomasset")
        return false
    end
    local name = b.Name or "CustomFont"
    local weights = b.Weights or aq[name]
    if type(weights) ~= "table" then
        warn("[AirFlow] no font weights for " .. name)
        return false
    end
    local folder = b.Folder or "AirFlowFonts"
    pcall(function()
        if type(isfolder) == "function" and type(makefolder) == "function" and not isfolder(folder) then
            makefolder(folder)
        end
    end)
    local faces = {}
    for weightName, url in pairs(weights) do
        local weightInfo = ad[weightName]
        if weightInfo then
            local path = folder .. "/" .. name .. "-" .. weightName .. ".ttf"
            local ok = true
            if not isfile(path) then
                ok = pcall(function() writefile(path, game:HttpGet(url)) end)
            end
            if ok then
                table.insert(faces, {name = weightName, weight = weightInfo[1], style = "normal", assetId = getcustomasset(path)})
            else
                warn("[AirFlow] could not download " .. weightName .. " weight of " .. name)
            end
        end
    end
    if #faces == 0 then return false end
    local jsonPath = folder .. "/" .. name .. ".json"
    if not pcall(function() writefile(jsonPath, H:JSONEncode({name = name, faces = faces})) end) then
        return false
    end
    local asset = getcustomasset(jsonPath)
    local function makeFont(weightName, fallback)
        local weightInfo = ad[weightName]
        if weightInfo and weights[weightName] then
            return Font.new(asset, weightInfo[2])
        end
        return fallback
    end
    e.Fonts.Regular = makeFont("Regular", e.Fonts.Regular)
    e.Fonts.Medium = makeFont("Medium", makeFont("Regular", e.Fonts.Medium))
    e.Fonts.Bold = makeFont("SemiBold", makeFont("Bold", e.Fonts.Bold))
    return true
end

function e:PreloadIcons() return P() ~= false end

local function ar(a)
    if typeof(a) == "table" then return a.Image, a.RectOffset, a.RectSize end
    if type(a) ~= "string" then return nil end
    if a:find("^rbxassetid://") or a:find("^rbxasset://") or a:find("^http") then return a end
    local iconName = a:gsub("^lucide:", "")
    local icons = P()
    if not icons then return nil end
    local icon = icons.Icons and icons.Icons[iconName] or icons[iconName]
    if type(icon) == "table" then
        local image = icon.Image
        if type(image) == "number" then image = "rbxassetid://" .. tostring(image) end
        local spritesheet = icons.Spritesheets and icons.Spritesheets[tostring(image)] or image
        return spritesheet, icon.ImageRectPosition, icon.ImageRectSize
    elseif type(icon) == "string" then
        return icon
    end
    warn("[AirFlow] unknown lucide icon: " .. iconName)
    return nil
end

local Q = "rbxasset://fonts/families/BuilderSans.json"
e.Fonts = {
    Regular = Font.new(Q, Enum.FontWeight.Regular),
    Medium = Font.new(Q, Enum.FontWeight.Medium),
    Bold = Font.new(Q, Enum.FontWeight.SemiBold)
}

local a = e.Theme
local v = e.Assets
local j = e.Fonts
local m = p.TouchEnabled and not p.KeyboardEnabled
e.Touch = m

local R = m and 54 or 48
local y = m and 70 or 64
local S = m and 40 or 34
local t = m and 34 or 28
local ae = {}

local function b(inst, props, dur, style, dir)
    dur = dur or 0.2
    if dur <= 0 then
        for k, val in pairs(props) do inst[k] = val end
        return nil
    end
    style = style or Enum.EasingStyle.Quart
    dir = dir or Enum.EasingDirection.Out
    local key = dur .. style.Name .. dir.Name
    local info = ae[key]
    if not info then
        info = TweenInfo.new(dur, style, dir)
        ae[key] = info
    end
    local tw = aa:Create(inst, info, props)
    tw:Play()
    return tw
end

local function c(cls, props, children)
    local inst = Instance.new(cls)
    for k, val in pairs(props) do
        if k ~= "Parent" then inst[k] = val end
    end
    if children then
        for _, child in ipairs(children) do child.Parent = inst end
    end
    if props.Parent then inst.Parent = props.Parent end
    return inst
end

local function g(inst, radius)
    return c("UICorner", {CornerRadius = radius or UDim.new(0, 8), Parent = inst})
end

local function i(inst, color, trans, thick)
    return c("UIStroke", {
        Color = color or a.Stroke, Transparency = trans or 0, Thickness = thick or 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = inst
    })
end

local function o(inst, l, r, t, b)
    return c("UIPadding", {
        PaddingLeft = UDim.new(0, l or 0), PaddingRight = UDim.new(0, r or 0),
        PaddingTop = UDim.new(0, t or 0), PaddingBottom = UDim.new(0, b or 0), Parent = inst
    })
end

local function f(props)
    local defaults = {
        BackgroundTransparency = 1, TextColor3 = a.Text, TextSize = 14, FontFace = j.Bold,
        TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center,
        TextTruncate = Enum.TextTruncate.AtEnd
    }
    for k, val in pairs(props) do defaults[k] = val end
    return c("TextLabel", defaults)
end

local function z(inst, size, pos, trans, rot)
    local glow = c("ImageLabel", {
        AnchorPoint = Vector2.new(0.5, 0.5), Position = pos, Size = size, BackgroundTransparency = 1,
        Image = v.Glow, ImageColor3 = a.Glow, ImageTransparency = trans, ZIndex = 0, Parent = inst
    })
    c("UIGradient", {
        Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), a.Accent),
        Rotation = rot or 90, Parent = glow
    })
    return glow
end

local function T(inst)
    return c("Frame", {
        Position = UDim2.fromOffset(0, 0), Size = UDim2.new(1, 0, 0, 1),
        BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 0.93,
        BorderSizePixel = 0, ZIndex = 0, Parent = inst
    })
end

local function u(img, icon)
    local image, rectPos, rectSize = ar(icon)
    if not image then return end
    img.Image = image
    img.ImageRectOffset = rectPos or Vector2.zero
    img.ImageRectSize = rectSize or Vector2.zero
end

local function as()
    local hui
    pcall(function() if typeof(gethui) == "function" then hui = gethui() end end)
    if typeof(hui) == "Instance" then return hui end
    local core
    pcall(function()
        core = game:GetService("CoreGui")
        local probe = Instance.new("Folder")
        probe.Parent = core
        probe:Destroy()
    end)
    if core then return core end
    return J:WaitForChild("PlayerGui")
end

local af, ag = nil, Vector2.zero
local function s()
    local now = time()
    if af ~= now then
        af = now
        ag = ao:GetGuiInset()
    end
    return p:GetMouseLocation() - ag
end

local function r(input) return input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch end
local function U(input) return input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch end

local function A(parent, icon, color, pos)
    local holder = c("Frame", {AnchorPoint = Vector2.new(0, 0.5), Position = pos, Size = UDim2.fromOffset(16, 16), BackgroundTransparency = 1, Parent = parent})
    local img = c("ImageLabel", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ImageColor3 = color, ScaleType = Enum.ScaleType.Fit, Parent = holder})
    u(img, icon)
    return holder, img
end

local function ah(parent, anchorX, offsetX)
    local holder = c("Frame", {AnchorPoint = Vector2.new(anchorX, 0.5), Position = UDim2.new(anchorX, offsetX, 0.5, 0), Size = UDim2.fromOffset(18, 18), BackgroundTransparency = 1, Parent = parent})
    local chevron = {}
    local img = c("ImageLabel", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(16, 16), BackgroundTransparency = 1, ImageColor3 = a.Muted, ScaleType = Enum.ScaleType.Fit, Parent = holder})
    u(img, "chevron-down")
    if img.Image ~= "" then
        function chevron:Set(open)
            b(img, {Rotation = open and 180 or 0, ImageColor3 = open and a.Accent or a.Muted}, 0.3, Enum.EasingStyle.Quint)
        end
        return chevron
    end
    img:Destroy()
    local function makeArrow(rot, trans)
        return f({AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(18, 18), Text = "›", TextSize = 22, TextXAlignment = Enum.TextXAlignment.Center, TextColor3 = a.Muted, TextTransparency = trans, Rotation = rot, Parent = holder})
    end
    local arr1 = makeArrow(90, 0)
    local arr2 = makeArrow(270, 1)
    function chevron:Set(open)
        b(arr1, {TextTransparency = open and 1 or 0}, 0.2)
        b(arr2, {TextTransparency = open and 0 or 1, TextColor3 = open and a.Accent or a.Muted}, 0.2)
    end
    return chevron
end

local V = {}
local function at(btn, color)
    local mouse = s()
    local size = math.max(btn.AbsoluteSize.X, btn.AbsoluteSize.Y) * 2.2
    local ripple = table.remove(V)
    if not ripple then
        ripple = c("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), BorderSizePixel = 0})
        g(ripple, UDim.new(1, 0))
    end
    ripple.BackgroundColor3 = color or a.Accent
    ripple.Position = UDim2.fromOffset(mouse.X - btn.AbsolutePosition.X, mouse.Y - btn.AbsolutePosition.Y)
    ripple.Size = UDim2.fromOffset(0, 0)
    ripple.BackgroundTransparency = 0.82
    ripple.ZIndex = btn.ZIndex + 1
    ripple.Parent = btn
    b(ripple, {Size = UDim2.fromOffset(size, size), BackgroundTransparency = 1}, 0.55)
    task.delay(0.55, function()
        if ripple.Parent ~= btn then return end
        ripple.Parent = nil
        if #V < 4 then table.insert(V, ripple) else ripple:Destroy() end
    end)
end

local function w(stroke)
    if not stroke then return end
    b(stroke, {Color = a.Accent, Transparency = 0.2}, 0.08)
    task.delay(0.12, function() b(stroke, {Color = a.Stroke, Transparency = 0}, 0.35) end)
end

local function L(btn, stroke)
    btn.MouseEnter:Connect(function() b(stroke, {Color = a.StrokeHover}, 0.12) end)
    btn.MouseLeave:Connect(function() b(stroke, {Color = a.Stroke}, 0.25) end)
end

local au = {
    [Enum.KeyCode.LeftControl] = "LCtrl", [Enum.KeyCode.RightControl] = "RCtrl",
    [Enum.KeyCode.LeftShift] = "LShift", [Enum.KeyCode.RightShift] = "RShift",
    [Enum.KeyCode.LeftAlt] = "LAlt", [Enum.KeyCode.RightAlt] = "RAlt",
    [Enum.KeyCode.Return] = "Enter", [Enum.KeyCode.Escape] = "Esc", [Enum.KeyCode.Backspace] = "Backspace"
}

local function W(key)
    if key == nil then return "None" end
    return au[key] or key.Name
end

local function F(val)
    if typeof(val) == "EnumItem" then return val end
    if type(val) ~= "string" or val == "" or val == "None" then return nil end
    local ok, key = pcall(function() return Enum.KeyCode[val] end)
    if ok then return key end
    warn("[AirFlow] unknown key name: " .. val)
    return nil
end

local function l(fn, ...)
    if type(fn) ~= "function" then return end
    local ok, err = pcall(fn, ...)
    if not ok then warn("[AirFlow] callback error: " .. tostring(err)) end
end

local function ai(min, max, step)
    if max < min then min, max = max, min end
    if not step or step <= 0 then step = 1 end
    local decimals = 0
    while decimals < 6 do
        local scaled = step * 10 ^ decimals
        if math.abs(scaled - math.floor(scaled + 0.5)) < 1e-9 then break end
        decimals = decimals + 1
    end
    local fmt = "%." .. decimals .. "f"
    return {
        snap = function(v)
            v = math.floor(v / step + 0.5) * step
            v = tonumber(string.format(fmt, v)) or v
            return math.clamp(v, min, max)
        end,
        format = function(v) return string.format(fmt, v) end
    }
end

local function G(tab, cls, height, props)
    local frame = {
        Size = UDim2.new(1, 0, 0, height), BackgroundColor3 = Color3.fromRGB(15, 15, 15),
        BackgroundTransparency = 0.2, BorderSizePixel = 0,
        LayoutOrder = tab:_nextOrder(), Parent = tab.List
    }
    if cls == "TextButton" then
        frame.AutoButtonColor = false
        frame.Text = ""
    end
    local inst = c(cls, frame)
    inst:SetAttribute("NoDrag", true)
    g(inst)
    local stroke = i(inst, a.Stroke)
    return inst, stroke
end

local function M(inst, title, desc, rightPad)
    local titleLbl, descLbl
    if desc then
        local yPos = (y - 38) / 2
        titleLbl = f({Name = "Title", Position = UDim2.fromOffset(14, yPos), Size = UDim2.new(1, -(14 + rightPad), 0, 18), Text = title, Parent = inst})
        descLbl = f({Name = "Desc", Position = UDim2.fromOffset(14, yPos + 20), Size = UDim2.new(1, -(14 + rightPad), 0, 17), Text = desc, TextSize = 13, FontFace = j.Regular, TextColor3 = a.Muted, Parent = inst})
    else
        titleLbl = f({Name = "Title", Position = UDim2.fromOffset(14, 0), Size = UDim2.new(1, -(14 + rightPad), 1, 0), Text = title, Parent = inst})
    end
    return titleLbl, descLbl
end

local function B(tab, props, defaults, cls, hasRight, fallbackName)
    props = n(props, defaults)
    local height = props.Desc and y or R
    local inst, stroke = G(tab, cls or "Frame", height, props)
    L(inst, stroke)
    local titleLbl, descLbl
    if hasRight then
        titleLbl, descLbl = M(inst, props.Name or fallbackName, props.Desc, hasRight)
    end
    return props, inst, stroke, height, titleLbl, descLbl
end

local function N(titleLbl, descLbl, rightPad)
    if titleLbl then titleLbl.Size = UDim2.new(1, -(14 + rightPad), titleLbl.Size.Y.Scale, titleLbl.Size.Y.Offset) end
    if descLbl then descLbl.Size = UDim2.new(1, -(14 + rightPad), 0, descLbl.Size.Y.Offset) end
end

ac = function(api, frame, props)
    local function find(name) return frame:FindFirstChild(name, true) end
    if api.SetTitle == nil then
        function api:SetTitle(t)
            local lbl = find("Title")
            if lbl then lbl.Text = tostring(t) end
        end
    end
    if api.SetDesc == nil then
        function api:SetDesc(t)
            local lbl = find("Desc")
            if lbl then lbl.Text = tostring(t) else warn("[AirFlow] SetDesc needs the element to be created with a Desc") end
        end
    end
    api.Visible = true
    function api:SetVisible(v)
        api.Visible = v ~= false
        frame.Visible = api.Visible
    end
    api.Locked = false
    local lockOverlay, lockLabel
    function api:SetLocked(locked, reason)
        api.Locked = locked == true
        if api.Locked and type(api.SetOpen) == "function" then api:SetOpen(false) end
        if not lockOverlay then
            if not api.Locked then return end
            lockOverlay = c("TextButton", {
                Name = "Lock", Size = UDim2.fromScale(1, 1), BackgroundColor3 = a.Background,
                BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 20, Parent = frame
            })
            g(lockOverlay)
            local pill = c("Frame", {
                AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0),
                Size = UDim2.fromOffset(0, t), AutomaticSize = Enum.AutomaticSize.X,
                BackgroundColor3 = a.Surface, BorderSizePixel = 0, ZIndex = 21, Parent = lockOverlay
            })
            g(pill, UDim.new(0, 6))
            i(pill)
            o(pill, 8, 10)
            c("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center,
                SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6), Parent = pill
            })
            local lockIcon = c("ImageLabel", {
                Size = UDim2.fromOffset(14, 14), BackgroundTransparency = 1, ImageColor3 = a.Muted,
                ScaleType = Enum.ScaleType.Fit, LayoutOrder = 1, ZIndex = 22, Parent = pill
            })
            u(lockIcon, "lock")
            lockLabel = f({
                Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, TextSize = 12,
                TextColor3 = a.Muted, TextTruncate = Enum.TextTruncate.None, LayoutOrder = 2, ZIndex = 22, Parent = pill
            })
        end
        lockLabel.Text = reason or "Locked"
        lockOverlay.Visible = api.Locked
        lockOverlay.BackgroundTransparency = api.Locked and 0.35 or 1
    end
    if props.Locked then api:SetLocked(true, props.LockedReason) end
    if props.Visible == false then api:SetVisible(false) end
end

local k = {}
k.__index = k
function k:_nextOrder()
    self._order = self._order + 1
    return self._order
end

function k:Section(name)
    if type(name) == "table" then name = name.Name or name.Title or "" end
    local holder = c("Frame", {
        Size = UDim2.new(1, 0, 0, 28), BackgroundTransparency = 1,
        LayoutOrder = self:_nextOrder(), Parent = self.List
    })
    local title = f({
        Position = UDim2.fromOffset(2, 8), Size = UDim2.new(0, 0, 0, 16),
        AutomaticSize = Enum.AutomaticSize.X, Text = string.upper(name),
        TextSize = 12, TextColor3 = a.Muted, TextTruncate = Enum.TextTruncate.None, Parent = holder
    })
    local line = c("Frame", {
        AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0, 16),
        Size = UDim2.new(1, -12, 0, 1), BackgroundColor3 = a.Stroke, BorderSizePixel = 0, Parent = holder
    })
    local win = self.Window
    local function update()
        line.Size = UDim2.new(1, -(title.AbsoluteSize.X / win.Scale.Scale + 14), 0, 1)
    end
    title:GetPropertyChangedSignal("AbsoluteSize"):Connect(update)
    task.defer(update)
    return q(self, {}, {Set = function(_self, val) title.Text = string.upper(val) end}, holder, "Section")
end

function k:Divider()
    local line = c("Frame", {
        Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = a.Stroke,
        BorderSizePixel = 0, LayoutOrder = self:_nextOrder(), Parent = self.List
    })
    return q(self, {}, {}, line, "Divider")
end

function k:Label(props)
    props = n(props, {Name = "Text", Title = "Text"})
    local lbl = f({
        Size = UDim2.new(1, 0, 0, 18), Text = props.Text or "", TextSize = 13, FontFace = j.Regular,
        TextColor3 = props.Color or a.Muted, LayoutOrder = self:_nextOrder(), Parent = self.List
    })
    o(lbl, 2)
    local api = {
        Set = function(_self, val) lbl.Text = tostring(val) end,
        Get = function() return lbl.Text end
    }
    if type(props.Update) == "function" then
        local rate = math.max(tonumber(props.UpdateRate) or 1, 0.05)
        local alive = true
        api._listeners = api._listeners or {}
        table.insert(api._listeners, function() alive = false end)
        task.spawn(function()
            while alive and lbl.Parent do
                local ok, res = pcall(props.Update)
                if ok and res ~= nil then
                    lbl.Text = tostring(res)
                elseif not ok then
                    warn("[AirFlow] label update error: " .. tostring(res))
                end
                task.wait(rate)
            end
        end)
        function api:SetUpdateRate(newRate)
            rate = math.max(tonumber(newRate) or rate, 0.05)
        end
    end
    return q(self, props, api, lbl, "Label")
end

function k:Paragraph(props)
    props = n(props, {Title = "Name"})
    local container = G(self, "Frame", 0, props)
    container.AutomaticSize = Enum.AutomaticSize.Y
    o(container, 14, 14, 11, 12)
    c("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4), Parent = container})
    f({Name = "Title", Size = UDim2.new(1, 0, 0, 14), Text = props.Name or "", LayoutOrder = 1, Parent = container})
    local content = f({
        Name = "Content", Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        Text = props.Content or "", TextSize = 13, FontFace = j.Regular, TextColor3 = a.Muted,
        TextWrapped = true, TextTruncate = Enum.TextTruncate.None, TextYAlignment = Enum.TextYAlignment.Top,
        LayoutOrder = 2, Parent = container
    })
    return q(self, props, {Set = function(_self, val) content.Text = tostring(val) end, Get = function() return content.Text end}, container, "Paragraph")
end

local av = {Primary = O, Danger = "Error"}

function k:Button(props)
    props = n(props, {Title = "Name", Description = "Desc"})
    local styleName = av[props.Style]
    local isStyled = styleName ~= nil
    local height = props.Desc and y or R
    local btn, stroke = G(self, "TextButton", height, props)
    btn.ClipsDescendants = true
    if isStyled then
        btn.BackgroundColor3 = a[styleName]
        btn.BackgroundTransparency = 0.12
        stroke.Color = a[styleName]
        stroke.Transparency = 0.4
        btn.MouseEnter:Connect(function()
            b(btn, {BackgroundTransparency = 0}, 0.12)
            b(stroke, {Transparency = 0}, 0.12)
        end)
        btn.MouseLeave:Connect(function()
            b(btn, {BackgroundTransparency = 0.12}, 0.25)
            b(stroke, {Transparency = 0.4}, 0.25)
        end)
    else
        L(btn, stroke)
    end
    local textColor = isStyled and a.AccentDark or a.Text
    local iconOffset = 0
    if props.Icon then
        A(btn, props.Icon, isStyled and a.AccentDark or a.Accent, UDim2.new(0, 14, 0.5, 0))
        iconOffset = 26
    end
    local titleLbl = M(btn, props.Name or "Button", props.Desc, 30)
    if iconOffset > 0 then
        for _, child in ipairs(btn:GetChildren()) do
            if child:IsA("TextLabel") then
                child.Position = child.Position + UDim2.fromOffset(iconOffset, 0)
                child.Size = child.Size - UDim2.fromOffset(iconOffset, 0)
            end
        end
    end
    if isStyled then
        for _, child in ipairs(btn:GetChildren()) do
            if child:IsA("TextLabel") then child.TextColor3 = textColor end
        end
    end
    A(btn, "chevron-right", isStyled and a.AccentDark or a.Muted, UDim2.new(1, -30, 0.5, 0))
    btn.MouseButton1Click:Connect(function()
        at(btn, isStyled and a.AccentDark or a.Accent)
        l(props.Callback)
    end)
    local api = {}
    function api:SetText(t) titleLbl.Text = tostring(t) end
    api.SetTitle = api.SetText
    return q(self, props, api, btn, "Button")
end

function k:Toggle(defaults)
    local props, toggle, stroke = B(self, defaults, {Title = "Name", Description = "Desc", CurrentValue = "Default", Value = "Default"}, "TextButton", 56, "Toggle")
    local track = c("Frame", {
        AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -14, 0.5, 0),
        Size = m and UDim2.fromOffset(44, 24) or UDim2.fromOffset(36, 20),
        BackgroundColor3 = a.Surface3, BorderSizePixel = 0, Parent = toggle
    })
    g(track, UDim.new(1, 0))
    i(track, a.Stroke)
    local thumb = c("Frame", {
        AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 3, 0.5, 0),
        Size = m and UDim2.fromOffset(18, 18) or UDim2.fromOffset(14, 14),
        BackgroundColor3 = a.Muted, BorderSizePixel = 0, Parent = track
    })
    g(thumb, UDim.new(1, 0))
    local glow = c("ImageLabel", {
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.new(1, 24, 1, 24), BackgroundTransparency = 1, Image = v.Glow,
        ImageColor3 = a.Accent, ImageTransparency = 1, ZIndex = 0, Parent = track
    })
    local state = {Value = defaults.Default == true}
    local function render(animate)
        local on = state.Value
        local dur = animate and 0.25 or 0
        b(track, {BackgroundColor3 = on and a.Accent or a.Surface3}, dur)
        b(glow, {ImageTransparency = on and 0.75 or 1}, dur)
        local thumbSize = m and 18 or 14
        b(thumb, {
            Position = on and UDim2.new(0, (m and 44 or 36) - 3 - thumbSize, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
        }, dur, Enum.EasingStyle.Back)
        b(thumb, {BackgroundColor3 = on and a.AccentDark or a.Muted}, dur)
        if animate then
            b(thumb, {Size = UDim2.fromOffset(thumbSize + 4, thumbSize - 2)}, 0.08)
            task.delay(0.08, function()
                b(thumb, {Size = UDim2.fromOffset(thumbSize, thumbSize)}, 0.2, Enum.EasingStyle.Back)
            end)
        end
    end
    local ignoreClick = false
    function state:Set(val, silent)
        val = val == true
        if val == state.Value then return end
        state.Value = val
        render(true)
        if not ignoreClick then w(stroke) end
        if not silent then l(defaults.Callback, val) end
    end
    function state:Get() return state.Value end
    render(false)
    toggle.MouseButton1Click:Connect(function()
        ignoreClick = true
        state:Set(not state.Value)
        ignoreClick = false
    end)
    local api = q(self, defaults, state, toggle, "Toggle")
    if state.Value then l(defaults.Callback, true) end
    return api
end

function k:Slider(defaults)
    local props = n(defaults, {
        Title = "Name", Description = "Desc",
        CurrentValue = "Default", Value = "Default", Increment = "Step"
    })
    local min = math.min(props.Min or 0, props.Max or 100)
    local max = math.max(props.Min or 0, props.Max or 100)
    local step = props.Step or 1
    local suffix = props.Suffix or ""
    local fmt = ai(min, max, step)
    local height = y + (props.Desc and 18 or 0)
    local holder, stroke = G(self, "Frame", height, props)
    L(holder, stroke)
    f({Name = "Title", Position = UDim2.fromOffset(14, 12), Size = UDim2.new(1, -120, 0, 18), Text = props.Name or "Slider", Parent = holder})
    if props.Desc then
        f({Name = "Desc", Position = UDim2.fromOffset(14, 31), Size = UDim2.new(1, -28, 0, 17), Text = props.Desc, TextSize = 13, FontFace = j.Regular, TextColor3 = a.Muted, Parent = holder})
    end
    local valueBox = c("Frame", {
        AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -10, 0, 9),
        Size = UDim2.fromOffset(40, 24), BackgroundColor3 = a.Surface,
        BorderSizePixel = 0, ClipsDescendants = true, Parent = holder
    })
    g(valueBox, UDim.new(0, 6))
    local valueBoxStroke = i(valueBox)
    local valLabel = f({
        Size = UDim2.new(1, 0, 1, 0), TextSize = 13, TextColor3 = a.Accent,
        TextXAlignment = Enum.TextXAlignment.Center, TextTruncate = Enum.TextTruncate.None, Parent = valueBox
    })
    local input = c("TextBox", {
        Position = UDim2.fromOffset(9, 0), Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X,
        BackgroundTransparency = 1, Text = "", TextColor3 = a.Text, TextSize = 13, FontFace = j.Medium,
        TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false, Visible = false, Parent = valueBox
    })
    c("UISizeConstraint", {MinSize = Vector2.new(14, 0), Parent = input})
    local suffixLbl = f({
        Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, Text = suffix,
        TextSize = 13, TextColor3 = a.Accent, TextTruncate = Enum.TextTruncate.None, Visible = false, Parent = valueBox
    })
    local clickBtn = c("TextButton", {
        Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "",
        AutoButtonColor = false, ZIndex = 2, Parent = valueBox
    })
    local editing = false
    local function resizeBox(instant)
        local w
        if editing then
            w = 9 + input.AbsoluteSize.X / self.Window.Scale.Scale + suffixLbl.TextBounds.X + 9
            suffixLbl.Position = UDim2.fromOffset(9 + input.AbsoluteSize.X / self.Window.Scale.Scale, 0)
        else
            w = valLabel.TextBounds.X + 18
        end
        w = math.max(w, 36)
        if instant then valueBox.Size = UDim2.fromOffset(w, 24)
        else b(valueBox, {Size = UDim2.fromOffset(w, 24)}, 0.2) end
    end
    valLabel:GetPropertyChangedSignal("TextBounds"):Connect(function() if not editing then resizeBox(false) end end)
    input:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() if editing then resizeBox(false) end end)
    local track = c("Frame", {
        Position = UDim2.new(0, 14, 0, height - 18), Size = UDim2.new(1, -28, 0, 5),
        BackgroundColor3 = a.Surface3, BorderSizePixel = 0, Parent = holder
    })
    g(track, UDim.new(1, 0))
    local fill = c("Frame", {Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = a.Accent, BorderSizePixel = 0, Parent = track})
    g(fill, UDim.new(1, 0))
    local glow = c("ImageLabel", {
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 0, 0.5, 0),
        Size = UDim2.fromOffset(28, 28), BackgroundTransparency = 1, Image = v.Glow,
        ImageColor3 = a.Accent, ImageTransparency = 0.85, ZIndex = 2, Parent = track
    })
    local knob = c("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 0, 0.5, 0),
        Size = UDim2.fromOffset(12, 12), BackgroundColor3 = a.Accent,
        BorderSizePixel = 0, ZIndex = 3, Parent = track
    })
    g(knob, UDim.new(1, 0))
    local trackBtn = c("TextButton", {
        Position = UDim2.new(0, 8, 0, height - (m and 37 or 31)),
        Size = UDim2.new(1, -16, 0, m and 40 or 28),
        BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 4, Parent = holder
    })
    local state = {Value = math.clamp(props.Default or min, min, max)}
    local dragging = false
    clickBtn.MouseEnter:Connect(function() b(valueBoxStroke, {Color = a.StrokeHover}, 0.12) end)
    clickBtn.MouseLeave:Connect(function() if not input:IsFocused() then b(valueBoxStroke, {Color = a.Stroke}, 0.2) end end)
    clickBtn.MouseButton1Click:Connect(function()
        editing = true
        input.Text = fmt.format(state.Value)
        valLabel.Visible = false
        input.Visible = true
        suffixLbl.Visible = suffix ~= ""
        clickBtn.Visible = false
        b(valueBoxStroke, {Color = a.StrokeHover}, 0.12)
        input:CaptureFocus()
        task.defer(resizeBox, false)
    end)
    input.FocusLost:Connect(function()
        local num = tonumber(input.Text)
        editing = false
        input.Visible = false
        suffixLbl.Visible = false
        valLabel.Visible = true
        clickBtn.Visible = true
        b(valueBoxStroke, {Color = a.Stroke}, 0.2)
        if num then state:Set(num) end
        resizeBox(false)
    end)
    trackBtn.MouseEnter:Connect(function()
        if not dragging then b(glow, {ImageTransparency = 0.78, Size = UDim2.fromOffset(34, 34)}, 0.15) end
    end)
    trackBtn.MouseLeave:Connect(function()
        if not dragging then b(glow, {ImageTransparency = 0.85, Size = UDim2.fromOffset(28, 28)}, 0.2) end
    end)
    local snap = fmt.snap
    local function ratio() return max - min == 0 and 0 or (state.Value - min) / (max - min) end
    local function visual(r, dur, style)
        style = style or Enum.EasingStyle.Linear
        b(fill, {Size = UDim2.new(r, 0, 1, 0)}, dur, style)
        b(knob, {Position = UDim2.new(r, 0, 0.5, 0)}, dur, style)
        b(glow, {Position = UDim2.new(r, 0, 0.5, 0)}, dur, style)
    end
    local function updateLabel(dur)
        visual(ratio(), dur)
        valLabel.Text = fmt.format(state.Value) .. suffix
    end
    local function pulse(dir)
        local r = ratio()
        local w = math.max(track.AbsoluteSize.X, 1)
        local d = (r >= dir and 1 or -1) * (5 / w)
        visual(math.clamp(r + d, 0, 1), 0.22, Enum.EasingStyle.Quint)
        task.delay(0.22, function() if not dragging then visual(ratio(), 0.18, Enum.EasingStyle.Quint) end end)
        valLabel.Text = fmt.format(state.Value) .. suffix
    end
    local function pressVisual()
        b(knob, {Size = UDim2.fromOffset(14, 12)}, 0.08)
        b(glow, {Size = UDim2.fromOffset(32, 32), ImageTransparency = 0.78}, 0.12)
        task.delay(0.1, function()
            b(knob, {Size = UDim2.fromOffset(12, 12)}, 0.25, Enum.EasingStyle.Quint)
            b(glow, {Size = UDim2.fromOffset(28, 28), ImageTransparency = 0.85}, 0.25)
        end)
    end
    function state:Set(val, silent)
        val = snap(tonumber(val) or min)
        if val == state.Value then return end
        local r = ratio()
        state.Value = val
        if dragging then updateLabel(0.05)
        else pulse(r) pressVisual() w(stroke) end
        if not silent then l(props.Callback, val) end
    end
    function state:Get() return state.Value end
    local function onTrackClick(pos)
        local w = track.AbsoluteSize.X
        if w <= 0 then return end
        local r = math.clamp((pos - track.AbsolutePosition.X) / w, 0, 1)
        state:Set(min + (max - min) * r)
    end
    trackBtn.InputBegan:Connect(function(input)
        if r(input) then
            dragging = true
            b(knob, {Size = UDim2.fromOffset(16, 16)}, 0.15, Enum.EasingStyle.Back)
            b(glow, {Size = UDim2.fromOffset(44, 44), ImageTransparency = 0.7}, 0.15)
            onTrackClick(s().X)
        end
    end)
    self.Window:_listen("Changed", function(input)
        if dragging and U(input) then onTrackClick(s().X) end
    end, self)
    self.Window:_listen("Ended", function(input)
        if dragging and r(input) then
            dragging = false
            b(knob, {Size = UDim2.fromOffset(12, 12)}, 0.2)
            b(glow, {Size = UDim2.fromOffset(28, 28), ImageTransparency = 0.85}, 0.2)
            l(props.OnRelease, state.Value)
        end
    end, self)
    state.Value = snap(state.Value)
    updateLabel(0)
    task.defer(resizeBox, true)
    return q(self, props, state, holder, "Slider")
end

function k:Dropdown(defaults)
    local props = n(defaults, {
        Title = "Name", Description = "Desc", CurrentOption = "Default",
        Value = "Default", MultipleOptions = "Multi", Values = "Options"
    })
    if props.Multi and type(props.Default) ~= "table" and props.Default ~= nil then
        props.Default = {props.Default}
    elseif not props.Multi and type(props.Default) == "table" then
        props.Default = props.Default[1]
    end
    local multi = props.Multi == true
    local options = props.Options or {}
    local holder, stroke, height
    local api, inst, lbl, h
    holder, api, stroke, height = B(self, props, {}, "Frame", nil, nil)
    holder.ClipsDescendants = true
    local clickable = c("TextButton", {Size = UDim2.new(1, 0, 0, height), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, Parent = holder})
    local titleLbl, descLbl = M(clickable, props.Name or "Dropdown", props.Desc, 180)
    local viewBox = c("Frame", {
        AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0),
        Size = UDim2.fromOffset(60, t), BackgroundColor3 = a.Surface,
        BorderSizePixel = 0, ClipsDescendants = true, Parent = clickable
    })
    g(viewBox, UDim.new(0, 6))
    local viewStroke = i(viewBox)
    local viewLabel = f({
        Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -34, 1, 0),
        TextColor3 = a.Muted, TextSize = 13, TextTruncate = Enum.TextTruncate.None,
        ClipsDescendants = true, Parent = viewBox
    })
    local chevron = ah(viewBox, 1, -6)
    local measureLbl, text = f({
        Size = UDim2.fromOffset(0, t), AutomaticSize = Enum.AutomaticSize.X,
        TextSize = 13, Visible = false, Parent = viewBox
    }), ""
    local function truncate(str)
        measureLbl.Text = str
        if measureLbl.TextBounds.X <= 146 then return str end
        local len = utf8.len(str)
        local function cut(n)
            if not len then return str:sub(1, n) end
            return str:sub(1, (utf8.offset(str, n + 1) or #str + 1) - 1)
        end
        local lo, hi = 0, (len or #str) - 1
        while lo < hi do
            local mid = math.ceil((lo + hi) / 2)
            measureLbl.Text = cut(mid) .. ".."
            if measureLbl.TextBounds.X <= 146 then lo = mid else hi = mid - 1 end
        end
        return cut(lo) .. ".."
    end
    local function resizeView(instant)
        local w = math.clamp(viewLabel.TextBounds.X + 10 + 34, 60, 190)
        N(titleLbl, descLbl, w + 20)
        if instant then viewBox.Size = UDim2.fromOffset(w, t)
        else b(viewBox, {Size = UDim2.fromOffset(w, t)}, 0.2) end
    end
    viewLabel:GetPropertyChangedSignal("TextBounds"):Connect(function() resizeView(false) end)
    local optionsFrame = c("Frame", {
        Position = UDim2.new(0, 10, 0, height), Size = UDim2.new(1, -20, 0, 0),
        BackgroundTransparency = 1, Parent = holder
    })
    c("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4), Parent = optionsFrame})
    local state = {Open = false}
    local selected = {}
    local items = {}
    local searchText = ""
    local searchAfter = props.SearchAfter or 6
    local placeholder = props.Placeholder or "None"
    local searchBox = c("Frame", {
        Size = UDim2.new(1, 0, 0, S), BackgroundColor3 = a.Surface, BackgroundTransparency = 1,
        BorderSizePixel = 0, LayoutOrder = 0, Visible = false, Parent = optionsFrame
    })
    g(searchBox, UDim.new(0, 6))
    local searchStroke = i(searchBox, a.Stroke, 1)
    local searchInput = c("TextBox", {
        Position = UDim2.fromOffset(12, 0), Size = UDim2.new(1, -20, 1, 0), BackgroundTransparency = 1,
        Text = "", PlaceholderText = "Search", PlaceholderColor3 = a.Muted, TextColor3 = a.Text,
        TextSize = 13, FontFace = j.Regular, TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false, TextTransparency = 1, Parent = searchBox
    })
    local function matches(opt)
        return searchText == "" or string.find(string.lower(tostring(opt)), searchText, 1, true) ~= nil
    end
    if multi then
        for _, opt in ipairs(props.Default or {}) do selected[opt] = true end
    elseif props.Default ~= nil then
        selected[props.Default] = true
    end
    local function getCurrent()
        if multi then
            local res = {}
            for _, opt in ipairs(options) do if selected[opt] then table.insert(res, opt) end end
            return res
        end
        for _, opt in ipairs(options) do if selected[opt] then return opt end end
        return nil
    end
    local function render()
        local current = getCurrent()
        if multi then
            local res = {}
            for _, opt in ipairs(current) do res[#res + 1] = tostring(opt) end
            text = #res > 0 and table.concat(res, ", ") or placeholder
        else
            text = current ~= nil and tostring(current) or placeholder
        end
        viewLabel.Text = truncate(text)
        for opt, item in pairs(items) do
            local on = selected[opt] == true
            if item.On ~= on then
                item.On = on
                b(item.Label, {TextColor3 = on and a.Text or a.Muted}, 0.15)
                if state.Open then
                    b(item.Check, {ImageTransparency = on and 0 or 1}, 0.15)
                    b(item.CheckScale, {Scale = on and 1 or 0.6}, on and 0.3 or 0.15, on and Enum.EasingStyle.Back or Enum.EasingStyle.Quint)
                end
            end
        end
    end
    local function countVisible()
        local n = 0
        for _, opt in ipairs(options) do if matches(opt) then n = n + 1 end end
        return n
    end
    local function filterItems()
        for opt, item in pairs(items) do item.Frame.Visible = matches(opt) end
    end
    local function targetHeight()
        local n = countVisible() + (searchBox.Visible and 1 or 0)
        return height + n * (S + 4) + 8
    end
    local function toggleOpen(open)
        state.Open = open
        searchBox.Visible = #options > searchAfter
        if not open then
            searchText = ""
            searchInput.Text = ""
            filterItems()
        end
        b(holder, {Size = UDim2.new(1, 0, 0, open and targetHeight() or height)}, 0.3, Enum.EasingStyle.Quint)
        b(searchBox, {BackgroundTransparency = open and 0 or 1}, 0.2)
        b(searchStroke, {Transparency = open and 0 or 1}, 0.2)
        b(searchInput, {TextTransparency = open and 0 or 1}, 0.2)
        chevron:Set(open)
        b(viewStroke, {Color = open and a.StrokeHover or a.Stroke}, 0.2)
        local function prepareItem(item)
            if not item.Stroke then item.Stroke = i(item.Frame, a.Stroke, 1) end
            local on = open and item.On
            b(item.Check, {ImageTransparency = on and 0 or 1}, 0.18)
            item.CheckScale.Scale = on and 1 or 0.6
            b(item.Label, {TextTransparency = open and 0 or 1}, 0.18)
            b(item.Stroke, {Transparency = open and 0 or 1}, 0.18)
            b(item.Frame, {BackgroundTransparency = open and 0 or 1}, 0.18)
        end
        if open then
            local gen = (state._openGeneration or 0) + 1
            state._openGeneration = gen
            task.spawn(function()
                local first = true
                for _, opt in ipairs(options) do
                    local item = items[opt]
                    if item and item.Frame.Visible then
                        if not first then
                            task.wait(0.025)
                            if state._openGeneration ~= gen or not state.Open then return end
                        end
                        first = false
                        prepareItem(item)
                    end
                end
            end)
        else
            local gen = (state._openGeneration or 0) + 1
            state._openGeneration = gen
            local vis = {}
            for _, opt in ipairs(options) do
                local item = items[opt]
                if item and item.Frame.Visible then table.insert(vis, item) end
            end
            task.spawn(function()
                for i = #vis, 1, -1 do
                    prepareItem(vis[i])
                    if i > 1 then
                        task.wait(0.015)
                        if state._openGeneration ~= gen or state.Open then return end
                    end
                end
            end)
        end
    end
    local function rebuild()
        local indexMap = {}
        for i, opt in ipairs(options) do indexMap[opt] = i end
        for opt, item in pairs(items) do
            if not indexMap[opt] then item.Frame:Destroy() items[opt] = nil end
        end
        for i, opt in ipairs(options) do
            local existing = items[opt]
            if existing then
                existing.Frame.LayoutOrder = i
                continue
            end
            local row = c("TextButton", {
                Size = UDim2.new(1, 0, 0, S), BackgroundColor3 = a.Surface, BackgroundTransparency = 1,
                Text = "", AutoButtonColor = false, LayoutOrder = i, Parent = optionsFrame
            })
            g(row, UDim.new(0, 6))
            local check = c("ImageLabel", {
                AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0),
                Size = UDim2.fromOffset(14, 14), BackgroundTransparency = 1, ImageColor3 = a.Accent,
                ImageTransparency = 1, ScaleType = Enum.ScaleType.Fit, Parent = row
            })
            u(check, "check")
            local checkScale = c("UIScale", {Scale = 0.6, Parent = check})
            local label = f({
                Position = UDim2.fromOffset(12, -1), Size = UDim2.new(1, -36, 1, 0),
                Text = tostring(opt), TextSize = 13, TextColor3 = a.Muted, TextTransparency = 1, Parent = row
            })
            row.MouseEnter:Connect(function()
                b(label, {TextColor3 = a.Text}, 0.15)
                local item = items[opt]
                if item and item.Stroke then b(item.Stroke, {Color = a.StrokeHover}, 0.12) end
            end)
            row.MouseLeave:Connect(function()
                b(label, {TextColor3 = selected[opt] and a.Text or a.Muted}, 0.2)
                local item = items[opt]
                if item and item.Stroke then b(item.Stroke, {Color = a.Stroke}, 0.2) end
            end)
            row.MouseButton1Click:Connect(function()
                if selected[opt] then selected[opt] = nil
                else
                    if not multi then selected = {} end
                    selected[opt] = true
                end
                render()
                l(props.Callback, getCurrent())
                if false then if not multi then end end
            end)
            items[opt] = {Frame = row, Label = label, Check = check, CheckScale = checkScale, Stroke = nil, On = nil}
        end
        filterItems()
        if state.Open then holder.Size = UDim2.new(1, 0, 0, targetHeight()) end
    end
    function state:Set(val, silent)
        selected = {}
        if multi then
            for _, v in ipairs(type(val) == "table" and val or {val}) do selected[v] = true end
        elseif val ~= nil then
            selected[val] = true
        end
        render()
        w(stroke)
        if not silent then l(props.Callback, getCurrent()) end
    end
    function state:Get() return getCurrent() end
    function state:Refresh(newOptions, keepSelection)
        options = newOptions or {}
        if not keepSelection then selected = {} end
        rebuild()
        render()
        if state.Open then toggleOpen(true) end
    end
    function state:SetOpen(open) toggleOpen(open == true) end
    clickable.MouseButton1Click:Connect(function() toggleOpen(not state.Open) end)
    searchInput:GetPropertyChangedSignal("Text"):Connect(function()
        searchText = string.lower(searchInput.Text)
        filterItems()
        if state.Open then b(holder, {Size = UDim2.new(1, 0, 0, targetHeight())}, 0.2, Enum.EasingStyle.Quint) end
    end)
    rebuild()
    render()
    task.defer(resizeView, true)
    return q(self, props, state, holder, "Dropdown")
end

function k:Input(defaults)
    local props, holder, stroke, height, titleLbl, descLbl = B(self, defaults, {
        Title = "Name", Description = "Desc", PlaceholderText = "Placeholder", CurrentValue = "Default", Value = "Default"
    }, "Frame", 160, "Input")
    local box = c("Frame", {
        AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0),
        Size = UDim2.fromOffset(170, 30), BackgroundColor3 = a.Surface, BorderSizePixel = 0, Parent = holder
    })
    g(box, UDim.new(0, 6))
    local boxStroke = i(box)
    local icon = props.Icon
    if icon then A(box, icon, a.Muted, UDim2.new(0, 8, 0.5, 0)) end
    local maxLen = tonumber(props.MaxLength)
    local function limit(t)
        t = tostring(t or "")
        if maxLen and #t > maxLen then return t:sub(1, maxLen) end
        return t
    end
    local input = c("TextBox", {
        Position = UDim2.fromOffset(icon and 30 or 8, 0), Size = UDim2.new(1, icon and -38 or -16, 1, 0),
        BackgroundTransparency = 1, Text = limit(props.Default), PlaceholderText = props.Placeholder or "",
        PlaceholderColor3 = a.Muted, TextColor3 = a.Text, TextSize = 14, FontFace = j.Regular,
        TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = props.ClearOnFocus == true,
        TextTruncate = Enum.TextTruncate.None, ClipsDescendants = true, Parent = box
    })
    box.ClipsDescendants = true
    local focused = false
    local basePad = (icon and 30 or 8) + 8
    local function resize(instant)
        local avail = holder.AbsoluteSize.X / self.Window.Scale.Scale
        local maxW = math.clamp(avail - 14 - 110 - 20, 100, 200)
        local txt = input.Text
        local bounds = input.TextBounds.X
        if #txt == 0 then bounds = math.min(input.TextBounds.X, 90) end
        local w = math.clamp(bounds + basePad + 12, 90, maxW) + (focused and 8 or 0)
        w = math.min(w, maxW + 8)
        N(titleLbl, descLbl, w + 20)
        if instant then box.Size = UDim2.fromOffset(w, 30)
        else b(box, {Size = UDim2.fromOffset(w, 30)}, 0.18) end
    end
    holder:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() resize(true) end)
    input:GetPropertyChangedSignal("Text"):Connect(function()
        local limited = limit(input.Text)
        if limited ~= input.Text then input.Text = limited return end
        resize(false)
        if input:IsFocused() then l(props.OnChanged, input.Text) end
    end)
    input:GetPropertyChangedSignal("TextBounds"):Connect(function() resize(false) end)
    task.defer(resize, true)
    input.Focused:Connect(function()
        focused = true
        b(boxStroke, {Color = a.StrokeHover}, 0.15)
        resize(false)
    end)
    input.FocusLost:Connect(function(enter)
        focused = false
        b(boxStroke, {Color = a.Stroke}, 0.15)
        resize(false)
        if props.Numeric and not tonumber(input.Text) then input.Text = "" return end
        l(props.Callback, input.Text, enter)
    end)
    local api = {}
    function api:Set(val, silent)
        input.Text = limit(val)
        w(stroke)
        if not silent then l(props.Callback, input.Text, false) end
    end
    function api:Get() return input.Text end
    function api:SetPlaceholder(ph) input.PlaceholderText = tostring(ph) end
    return q(self, props, api, holder, "Input")
end

function k:Keybind(defaults)
    local props, holder, stroke, height, titleLbl, descLbl = B(self, defaults, {
        Title = "Name", Description = "Desc", CurrentKeybind = "Default", Value = "Default"
    }, "Frame", 110, "Keybind")
    props.Default = F(props.Default)
    local isHold = props.Mode == "Hold"
    local btn = c("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0),
        Size = UDim2.fromOffset(44, t), BackgroundColor3 = a.Surface, BorderSizePixel = 0,
        Text = "", AutoButtonColor = false, ClipsDescendants = true, Parent = holder
    })
    g(btn, UDim.new(0, 6))
    local btnStroke = i(btn)
    local btnLabel = f({
        Size = UDim2.new(1, 0, 1, 0), TextSize = 13, TextColor3 = a.Muted,
        TextXAlignment = Enum.TextXAlignment.Center, TextTruncate = Enum.TextTruncate.None, Parent = btn
    })
    local state = {Value = props.Default, Listening = false, Held = false}
    local function resize(instant)
        local w = math.max(btnLabel.TextBounds.X + 20, m and 44 or 36)
        N(titleLbl, descLbl, w + 20)
        if instant then btn.Size = UDim2.fromOffset(w, t)
        else b(btn, {Size = UDim2.fromOffset(w, t)}, 0.2) end
    end
    btnLabel:GetPropertyChangedSignal("TextBounds"):Connect(function() resize(false) end)
    local function render()
        btnLabel.Text = state.Listening and "..." or W(state.Value)
        b(btnStroke, {Color = state.Listening and a.StrokeHover or a.Stroke}, 0.15)
        b(btnLabel, {TextColor3 = state.Listening and a.Accent or a.Muted}, 0.15)
    end
    local function releaseHold()
        if state.Held then
            state.Held = false
            l(props.Callback, false)
        end
    end
    function state:Set(val, silent)
        local wasListening = state.Listening
        releaseHold()
        val = F(val)
        state.Value = val
        state.Listening = false
        render()
        if not wasListening then w(stroke) end
        if not silent then l(props.OnChanged, val) end
    end
    btn.MouseButton1Click:Connect(function()
        state.Listening = not state.Listening
        render()
    end)
    self.Window:_listen("Began", function(input, processed)
        if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
        if state.Listening and p:GetFocusedTextBox() then
            state.Listening = false
            render()
            return
        end
        if state.Listening then
            self.Window._consumedKey = input.KeyCode
            self.Window._consumedAt = os.clock()
            if input.KeyCode == Enum.KeyCode.Escape then
                state.Listening = false
                render()
            elseif input.KeyCode == Enum.KeyCode.Backspace or input.KeyCode == Enum.KeyCode.Delete then
                state:Set(nil)
            else
                state:Set(input.KeyCode)
            end
            return
        end
        if processed or state.Locked or state.Value == nil or input.KeyCode ~= state.Value then return end
        if isHold then
            state.Held = true
            l(props.Callback, true)
        else
            l(props.Callback, input.KeyCode)
        end
    end, self)
    if isHold then
        self.Window:_listen("Ended", function(input)
            if input.KeyCode == state.Value then releaseHold() end
        end, self)
    end
    render()
    task.defer(resize, true)
    function state:Get() return state.Value end
    return q(self, props, state, holder, "Keybind", "OnChanged")
end

function k:ColorPicker(defaults)
    local holder, stroke, height, titleLbl, descLbl = B(self, defaults, {
        Title = "Name", Description = "Desc", Color = "Default", CurrentValue = "Default", Value = "Default"
    }, "Frame", nil, nil)
    holder.ClipsDescendants = true
    local clickable = c("TextButton", {
        Size = UDim2.new(1, 0, 0, height), BackgroundTransparency = 1,
        Text = "", AutoButtonColor = false, Parent = holder
    })
    M(clickable, props.Name or "Color", props.Desc, 90)
    local preview = c("Frame", {
        AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -34, 0.5, 0),
        Size = UDim2.fromOffset(36, 20), BorderSizePixel = 0, Parent = clickable
    })
    preview:SetAttribute("AirflowNoTheme", true)
    g(preview, UDim.new(0, 6))
    i(preview, a.Stroke)
    local chevron = ah(clickable, 1, -12)
    local expanded = c("Frame", {
        Position = UDim2.fromOffset(14, height + 2), Size = UDim2.new(1, -28, 0, 156),
        BackgroundTransparency = 1, Visible = false, Parent = holder
    })
    local gradientBox = c("TextButton", {
        Size = UDim2.new(1, -30, 0, 110), BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0, Text = "", AutoButtonColor = false, ClipsDescendants = true, Parent = expanded
    })
    g(gradientBox, UDim.new(0, 6))
    local hueGradient = c("UIGradient", {Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.new(1, 0, 0)), Parent = gradientBox})
    local saturationBox = c("Frame", {Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0), BorderSizePixel = 0, Parent = gradientBox})
    c("UIGradient", {Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0)}), Rotation = 90, Parent = saturationBox})
    local picker = c("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(10, 10),
        BackgroundTransparency = 1, ZIndex = 3, Parent = gradientBox
    })
    g(picker, UDim.new(1, 0))
    i(picker, Color3.new(1, 1, 1), 0, 2)
    local hueStrip = c("TextButton", {
        AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 0),
        Size = UDim2.fromOffset(14, 110), BorderSizePixel = 0, Text = "", AutoButtonColor = false, Parent = expanded
    })
    g(hueStrip, UDim.new(0, 6))
    c("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(0.1667, Color3.fromRGB(255, 255, 0)),
            ColorSequenceKeypoint.new(0.3333, Color3.fromRGB(0, 255, 0)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
            ColorSequenceKeypoint.new(0.6667, Color3.fromRGB(0, 0, 255)),
            ColorSequenceKeypoint.new(0.8333, Color3.fromRGB(255, 0, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
        }), Rotation = 90, Parent = hueStrip
    })
    local hueIndicator = c("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0, 0),
        Size = UDim2.fromOffset(18, 5), BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0, ZIndex = 3, Parent = hueStrip
    })
    g(hueIndicator, UDim.new(1, 0))
    i(hueIndicator, a.AccentDark, 0.4)
    local hexBox = c("Frame", {
        Position = UDim2.fromOffset(6, 122), Size = UDim2.fromOffset(118, 28),
        BackgroundColor3 = a.Surface, BorderSizePixel = 0, Parent = expanded
    })
    g(hexBox, UDim.new(0, 6))
    local hexStroke = i(hexBox)
    local hexInput = c("TextBox", {
        Position = UDim2.fromOffset(14, 0), Size = UDim2.new(1, -24, 1, 0), BackgroundTransparency = 1,
        Text = "", TextTruncate = Enum.TextTruncate.None, ClipsDescendants = false, TextColor3 = a.Text,
        TextSize = 13, FontFace = j.Regular, TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false, Parent = hexBox
    })
    local rgbLabel = f({
        Position = UDim2.fromOffset(134, 122), Size = UDim2.new(1, -134, 0, 28),
        TextXAlignment = Enum.TextXAlignment.Right, TextSize = 13, FontFace = j.Regular,
        TextColor3 = a.Muted, Parent = expanded
    })
    local state = {Open = false}
    local initColor = props.Default
    if type(initColor) == "string" then
        local ok, c = pcall(Color3.fromHex, initColor)
        initColor = ok and c or nil
    end
    if typeof(initColor) ~= "Color3" then initColor = a.Accent end
    local hue, sat, val = Color3.toHSV(initColor)
    local dragging
    local function toHex(c) return string.format("#%02X%02X%02X", math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5), math.floor(c.B * 255 + 0.5)) end
    local function render(anim)
        local c = Color3.fromHSV(hue, sat, val)
        state.Value = c
        preview.BackgroundColor3 = c
        hueGradient.Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.fromHSV(hue, 1, 1))
        b(picker, {Position = UDim2.fromScale(sat, 1 - val)}, anim, Enum.EasingStyle.Linear)
        b(hueIndicator, {Position = UDim2.new(0.5, 0, hue, 0)}, anim, Enum.EasingStyle.Linear)
        if not hexInput:IsFocused() then hexInput.Text = toHex(c) end
        rgbLabel.Text = string.format("RGB %d, %d, %d", math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5), math.floor(c.B * 255 + 0.5))
    end
    local function apply(anim, silent)
        render(anim)
        if not silent then l(props.Callback, state.Value) end
    end
    function state:Set(val, silent)
        if type(val) == "string" then
            local ok, c = pcall(Color3.fromHex, val)
            val = ok and c or nil
        end
        if typeof(val) ~= "Color3" then
            warn("[AirFlow] ColorPicker:Set expects a Color3 or hex string")
            return
        end
        hue, sat, val = Color3.toHSV(val)
        apply(0.25, silent)
        w(stroke)
    end
    function state:Get() return state.Value end
    local function toggleOpen(open)
        state.Open = open
        b(holder, {Size = UDim2.new(1, 0, 0, open and height + 168 or height)}, 0.35, Enum.EasingStyle.Quint)
        chevron:Set(open)
        if open then expanded.Visible = true
        else task.delay(0.35, function() if not state.Open then expanded.Visible = false end end) end
    end
    function state:SetOpen(open) toggleOpen(open == true) end
    clickable.MouseButton1Click:Connect(function() toggleOpen(not state.Open) end)
    local function pickSV(pos)
        sat = math.clamp((pos.X - gradientBox.AbsolutePosition.X) / gradientBox.AbsoluteSize.X, 0, 1)
        val = 1 - math.clamp((pos.Y - gradientBox.AbsolutePosition.Y) / gradientBox.AbsoluteSize.Y, 0, 1)
        apply(0.04)
    end
    local function pickHue(pos)
        hue = math.clamp((pos.Y - hueStrip.AbsolutePosition.Y) / hueStrip.AbsoluteSize.Y, 0, 0.999)
        apply(0.04)
    end
    gradientBox.InputBegan:Connect(function(input)
        if r(input) then
            dragging = "sv"
            b(picker, {Size = UDim2.fromOffset(14, 14)}, 0.15, Enum.EasingStyle.Back)
            pickSV(s())
        end
    end)
    hueStrip.InputBegan:Connect(function(input)
        if r(input) then
            dragging = "hue"
            b(hueIndicator, {Size = UDim2.fromOffset(20, 7)}, 0.15, Enum.EasingStyle.Back)
            pickHue(s())
        end
    end)
    self.Window:_listen("Changed", function(input)
        if not dragging or not U(input) then return end
        local pos = s()
        if dragging == "sv" then pickSV(pos) else pickHue(pos) end
    end, self)
    self.Window:_listen("Ended", function(input)
        if dragging and r(input) then
            dragging = nil
            b(picker, {Size = UDim2.fromOffset(10, 10)}, 0.2)
            b(hueIndicator, {Size = UDim2.fromOffset(18, 5)}, 0.2)
        end
    end, self)
    hexInput.Focused:Connect(function() b(hexStroke, {Color = a.StrokeHover}, 0.15) end)
    hexInput.FocusLost:Connect(function()
        b(hexStroke, {Color = a.Stroke}, 0.15)
        local r, g, b = hexInput.Text:match("^%s*#?(%x%x)(%x%x)(%x%x)%s*$")
        if r then state:Set(Color3.fromRGB(tonumber(r, 16), tonumber(g, 16), tonumber(b, 16)))
        else hexInput.Text = toHex(state.Value) end
    end)
    render(0)
    return q(self, props, state, holder, "ColorPicker")
end

function k:Stepper(defaults)
    local props, holder, stroke, height, titleLbl, descLbl = B(self, defaults, {
        Title = "Name", Description = "Desc", CurrentValue = "Default", Value = "Default", Increment = "Step"
    }, "Frame", 150, "Stepper")
    local min = math.min(props.Min or 0, props.Max or 100)
    local max = math.max(props.Min or 0, props.Max or 100)
    local step = props.Step or 1
    local suffix = props.Suffix or ""
    local fmt = ai(min, max, step)
    local box = c("Frame", {
        AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0),
        Size = UDim2.fromOffset(0, t), AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = a.Surface, BorderSizePixel = 0, Parent = holder
    })
    g(box, UDim.new(0, 6))
    local boxStroke = i(box)
    c("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = Enum.VerticalAlignment.Center, Parent = box})
    local function makeBtn(txt, order)
        local btn = c("TextButton", {
            Size = UDim2.fromOffset(t, t), BackgroundTransparency = 1, Text = txt,
            TextColor3 = a.Muted, TextSize = 18, FontFace = j.Medium, AutoButtonColor = false,
            LayoutOrder = order, Parent = box
        })
        btn.MouseEnter:Connect(function() b(btn, {TextColor3 = a.Accent}, 0.12) end)
        btn.MouseLeave:Connect(function() b(btn, {TextColor3 = a.Muted}, 0.2) end)
        return btn
    end
    local minusBtn = makeBtn("−", 1)
    local valLabel = f({
        Size = UDim2.new(0, 30, 1, 0), TextSize = 13, TextColor3 = a.Accent,
        TextXAlignment = Enum.TextXAlignment.Center, TextTruncate = Enum.TextTruncate.None,
        LayoutOrder = 2, Parent = box
    })
    local plusBtn = makeBtn("+", 3)
    local function resizeLabel(instant)
        local w = math.max(valLabel.TextBounds.X + 12, 30)
        if instant then valLabel.Size = UDim2.new(0, w, 1, 0)
        else b(valLabel, {Size = UDim2.new(0, w, 1, 0)}, 0.2) end
    end
    valLabel:GetPropertyChangedSignal("TextBounds"):Connect(function() resizeLabel(false) end)
    box:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        N(titleLbl, descLbl, box.AbsoluteSize.X / self.Window.Scale.Scale + 20)
    end)
    local state = {Value = math.clamp(props.Default or min, min, max)}
    local snap = fmt.snap
    local holding = false
    local function render()
        valLabel.Text = fmt.format(state.Value) .. suffix
        b(minusBtn, {TextTransparency = state.Value <= min and 0.6 or 0}, 0.15)
        b(plusBtn, {TextTransparency = state.Value >= max and 0.6 or 0}, 0.15)
    end
    function state:Set(val, silent)
        val = snap(tonumber(val) or min)
        if val == state.Value then return end
        state.Value = val
        render()
        if not holding then w(stroke) end
        if not silent then l(props.Callback, val) end
    end
    function state:Get() return state.Value end
    local function stepBy(dir)
        holding = true
        state:Set(state.Value + dir * step)
        holding = false
        b(boxStroke, {Color = a.StrokeHover}, 0.08)
        task.delay(0.12, function() b(boxStroke, {Color = a.Stroke}, 0.2) end)
    end
    local HOLD_DELAY = 0.4
    local REPEAT_RATE = 0.07
    local function hookHold(btn, dir)
        local count = 0
        local pressed = false
        btn.InputBegan:Connect(function(input)
            if not r(input) then return end
            count = count + 1
            local myCount = count
            pressed = true
            stepBy(dir)
            task.delay(HOLD_DELAY, function()
                while pressed and count == myCount and not state.Locked and not state._destroyed and btn.Parent do
                    stepBy(dir)
                    task.wait(REPEAT_RATE)
                end
            end)
        end)
        btn.InputEnded:Connect(function(input) if r(input) then pressed = false end end)
        btn.MouseLeave:Connect(function() pressed = false end)
    end
    hookHold(minusBtn, -1)
    hookHold(plusBtn, 1)
    render()
    task.defer(resizeLabel, true)
    return q(self, props, state, holder, "Stepper")
end

function k:Progress(defaults)
    defaults = n(defaults, {Title = "Name", Description = "Desc", CurrentValue = "Default", Value = "Default"})
    local holder, stroke = G(self, "Frame", defaults.Desc and y + 10 or R + 10, defaults)
    L(holder, stroke)
    local yPos = defaults.Desc and (y - 38) / 2 - 2 or 12
    f({Name = "Title", Position = UDim2.fromOffset(14, yPos), Size = UDim2.new(1, -110, 0, 18), Text = defaults.Name or "Progress", Parent = holder})
    if defaults.Desc then
        f({Name = "Desc", Position = UDim2.fromOffset(14, yPos + 20), Size = UDim2.new(1, -110, 0, 17), Text = defaults.Desc, TextSize = 13, FontFace = j.Regular, TextColor3 = a.Muted, Parent = holder})
    end
    local percentLbl = f({
        AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -14, 0, yPos),
        Size = UDim2.fromOffset(90, 18), TextXAlignment = Enum.TextXAlignment.Right,
        TextSize = 13, TextColor3 = a.Accent, Parent = holder
    })
    local track = c("Frame", {Position = UDim2.new(0, 14, 1, -16), Size = UDim2.new(1, -28, 0, 5), BackgroundColor3 = a.Surface3, BorderSizePixel = 0, Parent = holder})
    g(track, UDim.new(1, 0))
    local fill = c("Frame", {Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = defaults.Color or a.Accent, BorderSizePixel = 0, Parent = track})
    g(fill, UDim.new(1, 0))
    local state = {Value = math.clamp(defaults.Default or 0, 0, 1)}
    local formatFn = defaults.Format
    local function render(anim)
        local v = state.Value
        b(fill, {Size = UDim2.new(v, 0, 1, 0)}, anim, Enum.EasingStyle.Quint)
        if type(formatFn) == "function" then percentLbl.Text = tostring(formatFn(v))
        else percentLbl.Text = string.format("%d%%", math.floor(v * 100 + 0.5)) end
    end
    function state:Set(val, silent)
        val = math.clamp(tonumber(val) or 0, 0, 1)
        if val == state.Value then return end
        state.Value = val
        render(0.35)
        if not silent then l(defaults.Callback, val) end
    end
    function state:Get() return state.Value end
    function state:SetColor(c) fill.BackgroundColor3 = c end
    render(0)
    return q(self, defaults, state, holder, "Progress")
end

function k:ConfigManager(defaults)
    defaults = n(defaults, {})
    local win = self.Window
    local api = {}
    self:Section(defaults.Name or "Configs")
    local nameInput = self:Input({
        Name = "Config name",
        Placeholder = win.ConfigName,
        Callback = function(txt, enter) if enter and #txt > 0 then api:Save(txt) end end
    })
    local listDrop = self:Dropdown({
        Name = "Saved configs",
        Options = win:ListConfigs(),
        Default = win.ConfigName,
        Callback = function(val) if val then nameInput:Set(val, true) end end
    })
    function api:Refresh() listDrop:Refresh(win:ListConfigs(), true) end
    function api:Save(name)
        name = name or listDrop:Get() or win.ConfigName
        local ok, err = win:SaveConfig(name)
        api:Refresh()
        if ok then listDrop:Set(win.ConfigName, true) end
        win:Notify({
            Title = ok and "Config saved" or "Save failed",
            Content = ok and win.ConfigName or tostring(err),
            Type = ok and "Success" or "Error", Duration = 3
        })
    end
    function api:Load(name)
        name = name or listDrop:Get()
        if not name then return end
        local ok, err = win:LoadConfig(name)
        win:Notify({
            Title = ok and "Config loaded" or "Load failed",
            Content = ok and name or tostring(err),
            Type = ok and "Success" or "Error", Duration = 3
        })
    end
    function api:Delete(name)
        name = name or listDrop:Get()
        if not name then return end
        local ok, err = win:DeleteConfig(name)
        api:Refresh()
        win:Notify({
            Title = ok and "Config deleted" or "Delete failed",
            Content = ok and name or tostring(err),
            Type = ok and "Info" or "Error", Duration = 3
        })
    end
    self:Button({
        Name = "Save",
        Desc = "Writes every flagged element to the selected name",
        Icon = "save", Style = "Primary",
        Callback = function()
            local name = nameInput:Get()
            api:Save(#name > 0 and name or nil)
        end
    })
    self:Button({Name = "Load", Icon = "folder-open", Callback = function() api:Load() end})
    self:Button({
        Name = "Delete", Icon = "trash-2",
        Callback = function()
            local name = listDrop:Get()
            if not name then return end
            win:Confirm({
                Title = "Delete config",
                Content = "Remove " .. name .. "? This cannot be undone.",
                Icon = "trash-2", ConfirmText = "Delete",
                Callback = function() api:Delete(name) end
            })
        end
    })
    self:Toggle({
        Name = "Auto save",
        Desc = "Save whenever a flagged element changes",
        Default = win._autoSaveEnabled,
        Callback = function(val) win:SetAutoSave(val) end
    })
    return api
end

function k:ThemePicker(props)
    props = n(props, {Title = "Name", Description = "Desc"})
    local cb = props.Callback
    return self:Dropdown({
        Name = props.Name or "Theme",
        Desc = props.Desc,
        Options = e:GetThemes(),
        Default = e.ThemeName,
        Flag = props.Flag,
        Callback = function(val)
            if val then e:SetTheme(val) end
            l(cb, val)
        end
    })
end

local aw = {Select = true}
function k:Select() self.Window:SelectTab(self) end

for name, fn in pairs(table.clone(k)) do
    if type(fn) == "function" and name:sub(1, 1) ~= "_" and name:sub(1, 6) ~= "Create" and not aw[name] then
        k["Create" .. name] = fn
    end
end

function e.Window(ac, k)
    local H, q, I, M, J, B = "AirflowUI", "Frame", "CanvasGroup", "UIListLayout", "AbsoluteSize", "table"
    k = n(k, {Name = "Title", LoadingSubtitle = "Subtitle", ToggleUIKeybind = "Keybind"})
    if k.Theme ~= nil then e:SetTheme(k.Theme) end
    local V = k.Size or UDim2.fromOffset(640, 480)
    local N = F(k.Keybind) or Enum.KeyCode.RightControl
    local d = setmetatable({
        Tabs = {}, Flags = {}, CurrentTab = nil, Open = true, Keybind = N,
        _connections = {}, _controls = {}, _inputListeners = {Began = {}, Changed = {}, Ended = {}, Render = {}},
        _frameSteps = {}, _destroyed = false
    }, h)
    local function C(a) return function(...) for _, fn in ipairs(d._inputListeners[a]) do fn(...) end end end
    local X = C("Render")
    table.insert(d._connections, ab.RenderStepped:Connect(function(a)
        X(a)
        for _, step in ipairs(d._frameSteps) do step(a) end
    end))
    table.insert(d._connections, p.InputBegan:Connect(C("Began")))
    table.insert(d._connections, p.InputChanged:Connect(C("Changed")))
    table.insert(d._connections, p.InputEnded:Connect(C("Ended")))
    local s = c("ScreenGui", {Name = k.Name or H, IgnoreGuiInset = true, ResetOnSpawn = false, DisplayOrder = 999, ZIndexBehavior = Enum.ZIndexBehavior.Sibling})
    d.Gui = s
    local y = c(q, {Name = "Window", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = V, BackgroundTransparency = 1, Parent = s})
    d.Root = y
    local O = c("UIScale", {Parent = y})
    d.Scale = O
    local P = c("ImageLabel", {
        Position = UDim2.fromOffset(-25, -25), Size = UDim2.new(1, 50, 1, 50), BackgroundTransparency = 1,
        Image = v.Shadow, ImageColor3 = Color3.new(0, 0, 0), ImageTransparency = 0.6,
        ScaleType = Enum.ScaleType.Slice, SliceCenter = Rect.new(49, 49, 450, 450), Parent = y
    })
    d.Shadow = P
    local l = c(I, {Name = "Body", Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.fromRGB(10, 10, 10), BackgroundTransparency = 0.45, BorderSizePixel = 0, Parent = y})
    d.Body = l
    g(l, UDim.new(0, 10))
    d.BodyStroke = i(l, a.Stroke)
    T(l)
    z(l, UDim2.fromOffset(500, 180), UDim2.new(0.5, 0, 1, 8), 0.86, 270)
    z(l, UDim2.fromOffset(130, 60), UDim2.new(0, -10, 1, -10), 0.75, 90)
    z(l, UDim2.fromOffset(520, 240), UDim2.new(1, -14, 0, 10), 0.92, 90)
    local D = c(q, {Name = "Sidebar", Size = UDim2.new(0, 170, 1, 0), BackgroundColor3 = Color3.fromRGB(0, 0, 0), BackgroundTransparency = 0, Parent = l})
    c(q, {Position = UDim2.new(0, 170, 0, 0), Size = UDim2.new(0, 2, 1, 0), BackgroundColor3 = Color3.fromRGB(40, 40, 40), BorderSizePixel = 0, Parent = l})
    local K = c(q, {Name = "Header", Size = UDim2.new(1, 0, 0, 72), BackgroundTransparency = 1, Parent = D})
    local Q = c("ImageLabel", {Position = UDim2.fromOffset(22, 27), Size = UDim2.fromOffset(30, 28), BackgroundTransparency = 1, Image = "", ImageColor3 = a.Accent, ScaleType = Enum.ScaleType.Fit, Parent = K})
    u(Q, k.Icon or v.Logo)
    d._logo = Q
    d._titleLabel = f({Position = UDim2.fromOffset(60, 25), Size = UDim2.new(1, -70, 0, 20), Text = k.Title or "Airflow", TextSize = 20, Parent = K})
    d._subtitleLabel = f({Position = UDim2.fromOffset(60, 45), Size = UDim2.new(1, -70, 0, 14), Text = k.Subtitle or "", TextSize = 13, FontFace = j.Regular, TextColor3 = a.Muted, Parent = K})
    local t = c("ScrollingFrame", {
        Name = "Tabs", Position = UDim2.fromOffset(0, 80), Size = UDim2.new(1, 0, 1, -116),
        BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 0,
        AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(), Parent = D
    })
    d.TabList = t
    if m then t:SetAttribute("NoDrag", true) end
    o(t, 16, 16, 4, 4)
    c(M, {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4), Parent = t})
    local E = c(q, {AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.fromOffset(6, 0), Size = UDim2.fromOffset(3, 18), BackgroundColor3 = a.Accent, BorderSizePixel = 0, Visible = false, ZIndex = 2, Parent = D})
    g(E, UDim.new(1, 0))
    d.Indicator = E
    local R = t.CanvasPosition.Y
    table.insert(d._frameSteps, function()
        local yPos = t.CanvasPosition.Y
        if yPos == R or not d.CurrentTab or not d._introDone then return end
        R = yPos
        local targetY = d:_indicatorY(d.CurrentTab)
        local top = t.Position.Y.Offset
        local bottom = top + t.AbsoluteSize.Y / d.Scale.Scale
        E.Visible = targetY > top and targetY < bottom
        E.Position = UDim2.fromOffset(6, targetY)
    end)
    local UserFrame = c("Frame", {Size = UDim2.new(1, -16, 0, 42), Position = UDim2.new(0, 8, 1, -50), BackgroundTransparency = 1, Parent = D})
    local Avatar = c("ImageLabel", {Size = UDim2.fromOffset(32, 32), Position = UDim2.new(0, 0, 0.5, -16), BackgroundColor3 = a.Surface2, Parent = UserFrame})
    g(Avatar, UDim.new(1, 0))
    i(Avatar, a.Stroke)
    task.spawn(function()
        local ok, img = pcall(function() return I:GetUserThumbnailAsync(J.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size60x60) end)
        if ok and img then Avatar.Image = img end
    end)
    local UserName = f({Position = UDim2.fromOffset(40, 6), Size = UDim2.new(1, -40, 0, 16), Text = J.DisplayName, TextSize = 13, FontFace = j.Bold, TextColor3 = a.Text, Parent = UserFrame})
    local UserTag = f({Position = UDim2.fromOffset(40, 22), Size = UDim2.new(1, -40, 0, 14), Text = "@" .. J.Name, TextSize = 12, FontFace = j.Regular, TextColor3 = a.Muted, Parent = UserFrame})
    d._keyChipLabel = f({Text = "", Visible = false})
    d._rebindingKey = false
    local G = c(q, {Name = "Content", Position = UDim2.fromOffset(171, 0), Size = UDim2.new(1, -171, 1, 0), BackgroundTransparency = 1, ClipsDescendants = true, Parent = l})
    d.Content = G
    d._outLayer = c(I, {Name = "TransitionOut", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Visible = false, ZIndex = 2, Parent = G})
    d._inLayer = c(I, {Name = "TransitionIn", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Visible = false, ZIndex = 3, Parent = G})
    local w = c("TextButton", {AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -14, 0, 14), Size = UDim2.fromOffset(34, 34), BackgroundColor3 = a.Surface2, BackgroundTransparency = 1, Text = "×", TextColor3 = a.Muted, TextSize = 28, FontFace = j.Bold, AutoButtonColor = false, ZIndex = 5, Parent = G})
    o(w, 0, 0, 1, 0)
    g(w, UDim.new(0, 8))
    w.MouseEnter:Connect(function() b(w, {BackgroundTransparency = 0, TextColor3 = a.Text}, 0.15) end)
    w.MouseLeave:Connect(function() b(w, {BackgroundTransparency = 1, TextColor3 = a.Muted}, 0.2) end)
    w.MouseButton1Click:Connect(function() d:Toggle(false) end)
    local gearBtn = c("TextButton", {AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -56, 0, 14), Size = UDim2.fromOffset(34, 34), BackgroundColor3 = a.Surface2, BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 5, Parent = G})
    o(gearBtn, 0, 0, 1, 0)
    g(gearBtn, UDim.new(0, 8))
    i(gearBtn, a.Stroke, 1)
    local gearIcon = c("ImageLabel", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(18, 18), BackgroundTransparency = 1, ImageColor3 = a.Muted, ScaleType = Enum.ScaleType.Fit, Parent = gearBtn})
    u(gearIcon, "settings")
    gearBtn.MouseEnter:Connect(function() b(gearBtn, {BackgroundTransparency = 0}, 0.15) b(gearIcon, {ImageColor3 = a.Text}, 0.15) end)
    gearBtn.MouseLeave:Connect(function() b(gearBtn, {BackgroundTransparency = 1}, 0.2) b(gearIcon, {ImageColor3 = a.Muted}, 0.2) end)
    local settingsOverlay = c("Frame", {Name = "SettingsOverlay", Size = UDim2.new(0, 320, 1, 0), Position = UDim2.new(1, 0, 0, 0), BackgroundColor3 = Color3.fromRGB(10, 10, 10), BorderSizePixel = 0, Visible = false, ZIndex = 10, Parent = l})
    i(settingsOverlay, a.Stroke, 0)
    local settingsScroll = c("ScrollingFrame", {Size = UDim2.new(1, 0, 1, -70), Position = UDim2.new(0, 0, 0, 70), BackgroundTransparency = 1, ScrollBarThickness = 2, ScrollBarImageColor3 = a.Accent, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, Parent = settingsOverlay})
    o(settingsScroll, 16, 16, 10, 24)
    c("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8), Parent = settingsScroll})
    local settingsOpen = false
    gearBtn.MouseButton1Click:Connect(function()
        settingsOpen = not settingsOpen
        settingsOverlay.Visible = true
        if settingsOpen then
            b(settingsOverlay, {Position = UDim2.new(1, -320, 0, 0)}, 0.3, Enum.EasingStyle.Quint)
            b(gearIcon, {ImageColor3 = a.Accent}, 0.2)
        else
            b(settingsOverlay, {Position = UDim2.new(1, 0, 0, 0)}, 0.3, Enum.EasingStyle.Quint)
            b(gearIcon, {ImageColor3 = a.Muted}, 0.2)
            task.delay(0.3, function() if not settingsOpen then settingsOverlay.Visible = false end end)
        end
    end)
    local fakeTab = setmetatable({List = settingsScroll, Window = d, _order = 0}, k)
    function d:Settings() return fakeTab end
    local L = c(q, {Name = "Notifications", AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -20, 1, -20), Size = UDim2.new(0, 280, 1, -40), BackgroundTransparency = 1, Parent = s})
    local function aa() L.Size = UDim2.new(0, math.min(280, s.AbsoluteSize.X - 40), 1, -40) end
    table.insert(d._connections, s:GetPropertyChangedSignal(J):Connect(aa))
    c(M, {SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = Enum.VerticalAlignment.Bottom, Padding = UDim.new(0, 4), Parent = L})
    d.NotifyHolder = L
    d._notifyOrder = 0
    d._toasts = {}
    d.MaxNotifications = k.MaxNotifications or 4
    d._controlsDirty = true
    table.insert(d._connections, l.DescendantAdded:Connect(function() d._controlsDirty = true end))
    table.insert(d._connections, l.DescendantRemoving:Connect(function() d._controlsDirty = true end))
    d:_enableDrag()
    d.MaxSize = k.MaxSize
    d.KeepOnScreen = k.KeepOnScreen ~= false
    d:_enableResize(k.MinSize or Vector2.new(480, 360))
    local A = k.ConfigurationSaving
    if type(A) == B and A.Enabled ~= false then
        d.ConfigFolder = A.FolderName or H
        d.ConfigName = A.FileName or "default"
        d._autoSaveEnabled = A.AutoSave == true
    else
        d.ConfigFolder = H
        d.ConfigName = "default"
        d._autoSaveEnabled = false
    end
    table.insert(d._connections, p.InputBegan:Connect(function(inp, gp)
        if gp then return end
        if d._rebindingKey then
            if inp.UserInputType == Enum.UserInputType.Keyboard and inp.KeyCode ~= Enum.KeyCode.Unknown then
                if inp.KeyCode == Enum.KeyCode.Escape then
                    d._rebindingKey = false
                    d._keyChipLabel.Text = W(d.Keybind)
                    b(d._keyChipLabel, {TextColor3 = a.Muted}, 0.15)
                else
                    d._rebindingKey = false
                    d:SetKeybind(inp.KeyCode)
                    b(d._keyChipLabel, {TextColor3 = a.Muted}, 0.15)
                    d._consumedKey = inp.KeyCode
                    d._consumedAt = os.clock()
                end
            end
            return
        end
        if inp.KeyCode == Enum.KeyCode.Escape and d._dialog and d._dialog.Dismissable then
            d._dialog.Cancel()
            return
        end
        if inp.UserInputType == Enum.UserInputType.Keyboard and inp.KeyCode == d.Keybind then
            task.defer(function()
                local chk = d._consumedKey == inp.KeyCode and os.clock() - (d._consumedAt or 0) < 0.2
                d._consumedKey = nil
                if not chk and not d._destroyed then d:Toggle(not d.Open) end
            end)
        end
    end))
    pcall(function() if typeof(syn) == "table" and typeof(syn.protect_gui) == "function" then syn.protect_gui(s) end end)
    s.Parent = k.Parent or as()
    O.Scale = 0.9
    l.GroupTransparency = 1
    P.ImageTransparency = 1
    d.BodyStroke.Transparency = 1
    y.Visible = false
    d:_fitToScreen(true)
    table.insert(d._connections, s:GetPropertyChangedSignal(J):Connect(function()
        d:_fitToScreen()
        d:_clampToScreen()
    end))
    if k.OpenButton ~= nil and k.OpenButton ~= false or k.OpenButton == nil and m then
        d:_createOpenButton(type(k.OpenButton) == B and k.OpenButton or {})
    end
    d._introDone = false
    table.insert(e.Windows, d)
    if k.Home then d:_buildHome(type(k.Home) == B and k.Home or {}) end
    local r = k.Loading
    if type(r) == B then
        k.LoadingDuration = r.Duration or k.LoadingDuration
        k.LoadingText = r.Text or r.Subtitle or k.LoadingText
        k.LoadingSteps = r.Steps or k.LoadingSteps
        k.LoadingTitle = r.Title or k.LoadingTitle
        r = r.Enabled ~= false
    end
    if r == false then task.defer(function() d:_playIntro() end)
    else d:_showLoader(k) end
    return d
end

e.CreateWindow = e.Window

local function C(a, b, d)
    local hex = a[b]:ToHex()
    local mapped = d[hex]
    if mapped then a[b] = mapped end
end

local function aC(a, d)
    local changed = false
    local keys = {}
    for i, kp in ipairs(a.Color.Keypoints) do
        local mapped = d[kp.Value:ToHex()]
        if mapped then changed = true end
        keys[i] = ColorSequenceKeypoint.new(kp.Time, mapped or kp.Value)
    end
    if changed then a.Color = ColorSequence.new(keys) end
end

local function aD(a, b)
    if a:GetAttribute("AirflowNoTheme") then return end
    if a:IsA("GuiObject") then C(a, "BackgroundColor3", b) end
    if a:IsA("TextLabel") or a:IsA("TextButton") or a:IsA("TextBox") then C(a, "TextColor3", b) end
    if a:IsA("TextBox") then C(a, "PlaceholderColor3", b) end
    if a:IsA("ImageLabel") or a:IsA("ImageButton") then C(a, "ImageColor3", b) end
    if a:IsA("ScrollingFrame") then C(a, "ScrollBarImageColor3", b) end
    if a:IsA("UIStroke") then C(a, "Color", b)
    elseif a:IsA("UIGradient") then aC(a, b) end
end

local function aj(a)
    for _, win in ipairs(e.Windows) do
        if win.Gui and win.Gui.Parent then
            for _, obj in ipairs(win.Gui:GetDescendants()) do aD(obj, a) end
        end
    end
end

local function ak(a)
    if type(a) == "string" then
        local theme = e.Themes[a]
        if not theme then warn("[AirFlow] unknown theme: " .. a) return nil end
        return table.clone(theme), a
    elseif type(a) == "table" then
        local base = e.Themes[a.Base or "Default"] or e.Themes.Default
        local theme = table.clone(base)
        for _, key in ipairs(K) do
            if typeof(a[key]) == "Color3" then theme[key] = a[key] end
        end
        return theme, a.Name or "Custom"
    end
    warn("[AirFlow] SetTheme expects a theme name or a table of colours")
    return nil
end

function e:GetThemes()
    local list = {}
    for name in pairs(e.Themes) do if name ~= "Default" then table.insert(list, name) end end
    table.sort(list)
    table.insert(list, 1, "Default")
    return list
end

function e:AddTheme(name, colors)
    assert(type(name) == "string" and name ~= "", "AddTheme needs a name")
    local theme = ak(colors)
    if theme then e.Themes[name] = theme end
    return theme ~= nil
end

local X = 0
function e:SetTheme(g)
    local theme, name = ak(g)
    if not theme then return false end
    local old, cache = {}, {}
    for _, kp in ipairs(K) do cache[theme[kp]:ToHex()] = true end
    for _, kp in ipairs(K) do
        local before, after = a[kp], theme[kp]
        local hex = before:ToHex()
        if before ~= after and old[hex] == nil then old[hex] = after end
    end
    for _, kp in ipairs(K) do a[kp] = theme[kp] end
    e.ThemeName = name
    aj(old)
    X = X + 1
    local gen = X
    local filtered = {}
    for kp, col in pairs(old) do if not cache[kp] then filtered[kp] = col end end
    task.delay(0.6, function() if gen == X then aj(filtered) end end)
    return true
end

function e:Notify(props)
    local win = e.Windows[#e.Windows]
    if win then return win:Notify(props) end
end

function e:Confirm(props)
    local win = e.Windows[#e.Windows]
    if win then return win:Confirm(props) end
end

function e:Dialog(props)
    local win = e.Windows[#e.Windows]
    if win then return win:Dialog(props) end
end

local function D(a, c)
    local pos, size = c.AbsolutePosition, c.AbsoluteSize
    return a.X >= pos.X and a.X <= pos.X + size.X and a.Y >= pos.Y and a.Y <= pos.Y + size.Y
end

local function aE(c, b, d)
    local a = c
    while a and a ~= b and a:IsA("GuiObject") do
        if not a.Visible then return false end
        local c = a.Parent
        if c and c ~= b and c:IsA("GuiObject") and (c.ClipsDescendants or c:IsA("ScrollingFrame")) and not D(d, c) then
            return false
        end
        a = c
    end
    return true
end

function h:_refreshControls()
    local list = {}
    for _, obj in ipairs(self.Body:GetDescendants()) do
        if obj:IsA("GuiButton") or obj:IsA("TextBox") or obj:GetAttribute("NoDrag") then table.insert(list, obj) end
    end
    self._controls = list
    self._controlsDirty = false
end

function h:_overControl(a)
    if self._dialog then return true end
    if self._controlsDirty then self:_refreshControls() end
    for _, ctrl in ipairs(self._controls) do
        if ctrl.Parent and D(a, ctrl) and aE(ctrl, self.Body, a) then return true end
    end
    return false
end

function h:_overOverlay(a)
    if self._grip and D(a, self._grip) then return true end
    if self.OpenButton and self.OpenButton.Visible and D(a, self.OpenButton) then return true end
    for _, obj in ipairs(self.NotifyHolder:GetChildren()) do
        if obj:IsA("GuiObject") and D(a, obj) then return true end
    end
    return false
end

function h:_enableDrag()
    local dragging = false
    local dragOffset = Vector2.zero
    local mouse
    local function winPos()
        local root = self.Root
        return root.AbsolutePosition + root.AbsoluteSize * root.AnchorPoint - self.Gui.AbsolutePosition
    end
    table.insert(self._connections, p.InputBegan:Connect(function(e)
        if not r(e) then return end
        if not self.Open or not self.Root.Visible then return end
        local pos = s()
        if not D(pos, self.Body) or self:_overControl(pos) or self:_overOverlay(pos) then return end
        dragging = true
        dragOffset = pos - winPos()
    end))
    table.insert(self._connections, p.InputEnded:Connect(function(e)
        if not dragging then return end
        if r(e) then dragging, mouse = false, nil self:_clampToScreen() end
    end))
    table.insert(self._frameSteps, function(dt)
        if not dragging then return end
        mouse = s() - dragOffset
        local current = winPos()
        local alpha = 1 - math.exp(-dt * 45)
        local target = current:Lerp(mouse, alpha)
        self.Root.Position = UDim2.fromOffset(target.X, target.Y)
    end)
end

local function al(a, d, e)
    if not a.Visible and not e then return end
    a.Visible = false
    task.delay(d, function()
        if not a.Parent then return end
        local scale = c("UIScale", {Scale = 0.94, Parent = a})
        a.Visible = true
        b(scale, {Scale = 1}, 0.4, Enum.EasingStyle.Back)
        task.delay(0.4, function() scale:Destroy() end)
    end)
end

function h:_revealCards(a, c)
    if a._revealed then return end
    a._revealed = true
    local delay = 0
    for _, obj in ipairs(a.List:GetChildren()) do
        if obj:IsA("GuiObject") then
            al(obj, (c or 0) + delay * 0.035)
            delay = delay + 1
        end
    end
end

function h:_playIntro(c)
    if self._introDone then return end
    self._introDone = true
    task.delay(1, function() self._autoSaveReady = true end)
    local root, body, shadow, scale = self.Root, self.Body, self.Shadow, self.Scale
    if self.CurrentTab then self:_revealCards(self.CurrentTab, c and 0.15 or 0.25) end
    root.Visible = true
    if c then
        scale.Scale = self._fitScale or 1
        root.Position = UDim2.fromScale(0.5, 0.5)
        b(body, {GroupTransparency = 0}, 0.3)
        b(self.BodyStroke, {Transparency = 0}, 0.3)
        b(shadow, {ImageTransparency = 0.6}, 0.3)
    else
        root.Position = UDim2.new(0.5, 0, 0.5, 24)
        b(scale, {Scale = self._fitScale or 1}, 0.5, Enum.EasingStyle.Back)
        b(root, {Position = UDim2.fromScale(0.5, 0.5)}, 0.5, Enum.EasingStyle.Quint)
        b(body, {GroupTransparency = 0}, 0.35)
        b(self.BodyStroke, {Transparency = 0}, 0.35)
    end
    if not c then b(shadow, {ImageTransparency = 0.6}, 0.5) end
    for i, tab in ipairs(self.Tabs) do al(tab._button, 0.1 + i * 0.05, true) end
    self.Indicator.Visible = false
    task.delay(0.15 + #self.Tabs * 0.05, function()
        if self.CurrentTab then self:_placeIndicator(self.CurrentTab) end
    end)
end

function h:_showLoader(e)
    local m = e.LoadingDuration or 1.6
    local w = self.Gui
    local loader = c("CanvasGroup", {
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 16),
        Size = UDim2.fromOffset(300, 132), BackgroundColor3 = a.Background, BorderSizePixel = 0,
        GroupTransparency = 1, ZIndex = 10, Parent = w
    })
    local corner = g(loader, UDim.new(0, 12))
    local stroke = i(loader, a.Stroke, 1)
    T(loader)
    z(loader, UDim2.fromOffset(320, 140), UDim2.new(1, -20, 0, -20), 0.85, 90)
    z(loader, UDim2.fromOffset(240, 100), UDim2.new(0, 10, 1, 10), 0.9, 270)
    local scale = c("UIScale", {Scale = 0.92, Parent = loader})
    local shadow = c("ImageLabel", {
        Position = UDim2.fromOffset(-25, -25), Size = UDim2.new(1, 50, 1, 50), BackgroundTransparency = 1,
        Image = v.Shadow, ImageColor3 = Color3.new(0, 0, 0), ImageTransparency = 1,
        ScaleType = Enum.ScaleType.Slice, SliceCenter = Rect.new(49, 49, 450, 450), ZIndex = 0, Parent = loader
    })
    local iconHolder = c("Frame", {Position = UDim2.fromOffset(24, 26), Size = UDim2.fromOffset(40, 40), BackgroundTransparency = 1, Parent = loader})
    local icon = c("ImageLabel", {
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(0.5, 0.5), Rotation = -14, BackgroundTransparency = 1,
        ImageColor3 = a.Accent, ImageTransparency = 1, ScaleType = Enum.ScaleType.Fit, Parent = iconHolder
    })
    u(icon, e.Icon or v.Logo)
    task.delay(0.15, function()
        b(icon, {Size = UDim2.fromScale(0.85, 0.85), Rotation = 0}, 0.6, Enum.EasingStyle.Back)
        b(icon, {ImageTransparency = 0}, 0.4)
    end)
    f({Position = UDim2.fromOffset(78, 30), Size = UDim2.new(1, -100, 0, 22), Text = e.LoadingTitle or e.Title or "Airflow", TextSize = 20, Parent = loader})
    local stepLbl = f({Position = UDim2.fromOffset(78, 52), Size = UDim2.new(1, -100, 0, 16), Text = e.LoadingText or e.Subtitle or "Loading", TextSize = 13, FontFace = j.Regular, TextColor3 = a.Muted, Parent = loader})
    local barBg = c("Frame", {Position = UDim2.new(0, 24, 1, -30), Size = UDim2.new(1, -48, 0, 4), BackgroundColor3 = a.Surface3, BorderSizePixel = 0, ClipsDescendants = true, Parent = loader})
    g(barBg, UDim.new(1, 0))
    local barFill = c("Frame", {Size = UDim2.fromScale(0, 1), BackgroundColor3 = a.Accent, BorderSizePixel = 0, Parent = barBg})
    g(barFill, UDim.new(1, 0))
    local shimmer = c("Frame", {Position = UDim2.fromScale(-0.4, 0), Size = UDim2.fromScale(0.4, 1), BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 0.6, BorderSizePixel = 0, ZIndex = 2, Parent = barBg})
    c("UIGradient", {Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0), NumberSequenceKeypoint.new(1, 1)}), Parent = shimmer})
    b(loader, {GroupTransparency = 0, Position = UDim2.fromScale(0.5, 0.5)}, 0.4, Enum.EasingStyle.Quint)
    b(scale, {Scale = 1}, 0.5, Enum.EasingStyle.Back)
    b(shadow, {ImageTransparency = 0.6}, 0.4)
    local shimmerTw = aa:Create(shimmer, TweenInfo.new(1.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1), {Position = UDim2.fromScale(1, 0)})
    shimmerTw:Play()
    b(barFill, {Size = UDim2.fromScale(0.85, 1)}, m * 0.8, Enum.EasingStyle.Quart)
    task.spawn(P)
    local steps = e.LoadingSteps or {"Preparing interface", "Loading icons", "Almost there"}
    for i, txt in ipairs(steps) do
        task.delay(m * (i - 1) / #steps, function() if loader.Parent then stepLbl.Text = txt end end)
    end
    task.delay(m, function()
        b(barFill, {Size = UDim2.fromScale(1, 1)}, 0.25, Enum.EasingStyle.Quint)
        task.delay(0.25, function()
            shimmerTw:Cancel()
            for _, obj in ipairs(loader:GetChildren()) do
                if obj:IsA("TextLabel") then b(obj, {TextTransparency = 1}, 0.15) end
            end
            for _, obj in ipairs(iconHolder:GetChildren()) do b(obj, {ImageTransparency = 1}, 0.15) end
            b(barBg, {BackgroundTransparency = 1}, 0.15)
            b(barFill, {BackgroundTransparency = 1}, 0.15)
            b(shimmer, {BackgroundTransparency = 1}, 0.1)
            local fs = self._fitScale or 1
            local sz = self.Root.Size
            b(loader, {Size = UDim2.fromOffset(sz.X.Offset * fs, sz.Y.Offset * fs), Position = UDim2.fromScale(0.5, 0.5)}, 0.5, Enum.EasingStyle.Quint)
            b(corner, {CornerRadius = UDim.new(0, 10)}, 0.5, Enum.EasingStyle.Quint)
            b(scale, {Scale = 1}, 0.5, Enum.EasingStyle.Quint)
            task.delay(0.28, function()
                self:_playIntro(true)
                b(loader, {GroupTransparency = 1}, 0.25)
                b(stroke, {Transparency = 1}, 0.2)
                b(shadow, {ImageTransparency = 1}, 0.2)
            end)
            task.delay(0.6, function() loader:Destroy() end)
        end)
    end)
end

function h:_fitToScreen(d)
    local size = self.Gui.AbsoluteSize
    if size.X == 0 or size.Y == 0 then return end
    local rootSize = self.Root.Size
    local scale = math.min(1, (size.X - 24) / math.max(rootSize.X.Offset, 1), (size.Y - 24) / math.max(rootSize.Y.Offset, 1))
    self._fitScale = math.max(scale, 0.45)
    if self._introDone and self.Open then
        if d then self.Scale.Scale = self._fitScale
        else b(self.Scale, {Scale = self._fitScale}, 0.2) end
    end
end

function h:_clampToScreen()
    if not self.KeepOnScreen then return end
    local guiSize = self.Gui.AbsoluteSize
    local root = self.Root
    local half = root.AbsoluteSize / 2
    local center = root.AbsolutePosition + half - self.Gui.AbsolutePosition
    local clamped = Vector2.new(
        math.clamp(center.X, math.min(half.X, guiSize.X / 2), math.max(guiSize.X - half.X, guiSize.X / 2)),
        math.clamp(center.Y, math.min(half.Y, guiSize.Y / 2), math.max(guiSize.Y - half.Y, guiSize.Y / 2))
    )
    if (clamped - center).Magnitude > 0.5 then
        b(root, {Position = UDim2.fromOffset(clamped.X, clamped.Y)}, 0.25, Enum.EasingStyle.Quint)
    end
end

function h:_createOpenButton(props)
    local gui = self.Gui
    local btn = c("TextButton", {
        AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 14),
        Size = UDim2.fromOffset(0, 40), AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = a.Background, BorderSizePixel = 0, Text = "", AutoButtonColor = false,
        ZIndex = 30, Parent = gui
    })
    g(btn, UDim.new(1, 0))
    i(btn, a.Stroke)
    o(btn, 12, 16)
    local icon = c("ImageLabel", {
        AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 0.5, 0),
        Size = UDim2.fromOffset(20, 20), BackgroundTransparency = 1, ImageColor3 = a.Accent,
        ScaleType = Enum.ScaleType.Fit, ZIndex = 31, Parent = btn
    })
    u(icon, props.Icon or v.Logo)
    f({Position = UDim2.fromOffset(28, 0), Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, Text = props.Title or "Airflow", TextSize = 13, TextTruncate = Enum.TextTruncate.None, ZIndex = 31, Parent = btn})
    self.OpenButton = btn
    local dragging, moved = false, false
    local startPos, btnOffset = Vector2.zero, Vector2.zero
    btn.InputBegan:Connect(function(input)
        if r(input) then
            dragging, moved = true, false
            btnOffset = s() - btn.AbsolutePosition
        end
    end)
    table.insert(self._connections, p.InputChanged:Connect(function(input)
        if not dragging then return end
        if U(input) then
            local pos = s()
            if (pos - btnOffset).Magnitude > 4 then moved = true end
            if not moved then return end
            local rel = pos - btnOffset - gui.AbsolutePosition
            btn.AnchorPoint = Vector2.new(0, 0)
            btn.Position = UDim2.fromOffset(math.clamp(rel.X, 0, math.max(gui.AbsoluteSize.X - btn.AbsoluteSize.X, 0)), math.clamp(rel.Y, 0, math.max(gui.AbsoluteSize.Y - btn.AbsoluteSize.Y, 0)))
        end
    end))
    table.insert(self._connections, p.InputEnded:Connect(function(input)
        if dragging and r(input) then
            dragging = false
            if not moved then self:Toggle() end
        end
    end))
end

function h:_enableResize(minSize)
    local maxSize = self.MaxSize or Vector2.new(math.huge, math.huge)
    local grip = c("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(1, 4, 1, 4),
        Size = UDim2.fromOffset(32, 32), BackgroundTransparency = 1, Active = true,
        ZIndex = 20, Parent = self.Root
    })
    self._grip = grip
    local icon = c("ImageLabel", {
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, -16, 0.5, -16),
        Size = UDim2.fromOffset(96, 96), BackgroundTransparency = 1,
        Image = "rbxassetid://120997033468887", ImageColor3 = a.Accent, ImageTransparency = 0.8,
        ZIndex = 20, Parent = grip
    })
    local resizing = false
    local startSize = self.Root.Size
    local startMouse = Vector2.zero
    local newSize
    grip.InputBegan:Connect(function(input)
        if r(input) then
            resizing = true
            startSize = self.Root.Size
            startMouse = s()
            b(icon, {ImageTransparency = 0.35}, 0.1)
        end
    end)
    grip.MouseEnter:Connect(function() if not resizing then b(icon, {ImageTransparency = 0.35}, 0.1) end end)
    grip.MouseLeave:Connect(function() if not resizing then b(icon, {ImageTransparency = 0.8}, 0.17) end end)
    table.insert(self._connections, p.InputEnded:Connect(function(input)
        if resizing and r(input) then
            resizing = false
            b(icon, {ImageTransparency = 0.8}, 0.17)
            if newSize then
                self.Root.Size = UDim2.fromOffset(newSize.X, newSize.Y)
                newSize = nil
            end
            self:_fitToScreen()
            self:_clampToScreen()
        end
    end))
    table.insert(self._frameSteps, function(dt)
        if not resizing then return end
        local delta = (s() - startMouse) / self.Scale.Scale
        newSize = Vector2.new(math.clamp(startSize.X.Offset + delta.X * 2, minSize.X, maxSize.X), math.clamp(startSize.Y.Offset + delta.Y * 2, minSize.Y, maxSize.Y))
        local current = Vector2.new(self.Root.Size.X.Offset, self.Root.Size.Y.Offset)
        local alpha = 1 - math.exp(-dt * 35)
        local lerped = current:Lerp(newSize, alpha)
        lerped = Vector2.new(math.floor(lerped.X + 0.5), math.floor(lerped.Y + 0.5))
        if lerped ~= current then self.Root.Size = UDim2.fromOffset(lerped.X, lerped.Y) end
    end)
end

local function aF(a)
    a = tostring(a or ""):gsub('[%c/\\:%*%?"<>|]', ""):gsub("%.%.+", "."):gsub("^[%s%.]+", ""):gsub("[%s%.]+$", "")
    if a == "" then return nil end
    return a
end

local function Y(b, c)
    local name = aF(c)
    if not name then return nil, "invalid config name" end
    return b.ConfigFolder .. "/" .. name .. ".json", name
end

local function Z()
    local ft = "function"
    return type(writefile) == ft and type(readfile) == ft and type(isfile) == ft
end

local function aG(a)
    if type(isfolder) == "function" and type(makefolder) == "function" and not isfolder(a) then
        makefolder(a)
    end
end

local function aH(c)
    local t = c._type
    local v = c:Get()
    if t == "Keybind" then return {Type = t, Value = v and v.Name or nil}
    elseif t == "ColorPicker" then return {Type = t, Value = {v.R, v.G, v.B}} end
    return {Type = t, Value = v}
end

local function aI(b, e, c)
    local t = b._type
    local v = e.Value
    if t == "Keybind" then b:Set(F(v), c)
    elseif t == "ColorPicker" then if type(v) == "table" then b:Set(Color3.new(v[1], v[2], v[3]), c) end
    elseif v ~= nil then b:Set(v, c) end
end

function h:SaveConfig(e)
    if not Z() then return false, "file API unavailable" end
    local path, name = Y(self, e or self.ConfigName)
    if not path then return false, name end
    local data = {}
    for kp, ctrl in pairs(self.Flags) do
        if ctrl._type and type(ctrl.Get) == "function" then data[kp] = aH(ctrl) end
    end
    local ok, err = pcall(function()
        aG(self.ConfigFolder)
        writefile(path, H:JSONEncode(data))
    end)
    if ok then self.ConfigName = name end
    return ok, err
end

function h:LoadConfig(a, e)
    if not Z() then return false, "file API unavailable" end
    local path, name = Y(self, a or self.ConfigName)
    if not path then return false, name end
    a = name
    if not isfile(path) then return false, "no config named " .. a end
    local ok, data = pcall(function() return H:JSONDecode(readfile(path)) end)
    if not ok or type(data) ~= "table" then return false, "config is not valid JSON" end
    local autosave = self._autoSaveEnabled
    self._autoSaveEnabled = false
    for kp, entry in pairs(data) do
        local ctrl = self.Flags[kp]
        if ctrl and type(ctrl.Set) == "function" and type(entry) == "table" and entry.Type == ctrl._type then
            local success, err = pcall(aI, ctrl, entry, e == true)
            if not success then warn("[AirFlow] could not load flag " .. tostring(kp) .. ": " .. tostring(err)) end
        end
    end
    self._autoSaveEnabled = autosave
    self._autoSaveReady = true
    self.ConfigName = a
    return true
end

function h:DeleteConfig(c)
    if not Z() or type(delfile) ~= "function" then return false, "file API unavailable" end
    local path, name = Y(self, c)
    if not path then return false, name end
    if not isfile(path) then return false, "no config named " .. name end
    local ok, err = pcall(delfile, path)
    return ok, err
end

function h:ListConfigs()
    local list = {}
    if type(listfiles) ~= "function" or type(isfolder) ~= "function" or not isfolder(self.ConfigFolder) then return list end
    for _, file in ipairs(listfiles(self.ConfigFolder)) do
        local name = file:match("([^/\\]+)%.json$")
        if name then table.insert(list, name) end
    end
    table.sort(list)
    return list
end

function h:SetAutoSave(a) self._autoSaveEnabled = a == true end

function h:_autoSave()
    if not self._autoSaveEnabled or self._destroyed or not self._autoSaveReady then return end
    if self._autoSavePending then return end
    self._autoSavePending = true
    task.delay(0.5, function()
        self._autoSavePending = false
        if not self._destroyed then self:SaveConfig(self.ConfigName) end
    end)
end

local function aJ(e, g, h)
    local holder = c("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, -10), Size = UDim2.fromOffset(200, 70), BackgroundTransparency = 1, Parent = e})
    local icon = c("ImageLabel", {AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 0), Size = UDim2.fromOffset(26, 26), BackgroundTransparency = 1, ImageColor3 = a.Muted, ImageTransparency = 0.15, ScaleType = Enum.ScaleType.Fit, Parent = holder})
    u(icon, g)
    local lbl = f({Position = UDim2.fromOffset(0, 36), Size = UDim2.new(1, 0, 0, 16), Text = h, TextSize = 13, FontFace = j.Regular, TextColor3 = a.Muted, TextXAlignment = Enum.TextXAlignment.Center, Parent = holder})
    return holder, lbl, icon
end

local function aK(e, h, d, j)
    local card = c("Frame", {Size = UDim2.new(0.5, -4, 0, 62), BackgroundColor3 = a.Surface2, BorderSizePixel = 0, LayoutOrder = h, Parent = e})
    g(card)
    i(card)
    card:SetAttribute("NoDrag", true)
    if d then A(card, d, a.Muted, UDim2.new(0, 14, 0, 21)) end
    f({Position = UDim2.fromOffset(d and 36 or 14, 12), Size = UDim2.new(1, -(d and 50 or 28), 0, 16), Text = j, TextSize = 12, TextColor3 = a.Muted, Parent = card})
    return f({Position = UDim2.fromOffset(14, 34), Size = UDim2.new(1, -28, 0, 18), Text = "…", TextSize = 15, Parent = card})
end

local am = setmetatable({}, {__mode = "k"})
local function an(c)
    local cache = {}
    local function track(inst, prop)
        local orig = am[inst]
        if orig == nil then orig = inst[prop] am[inst] = orig end
        table.insert(cache, {inst, prop, orig})
    end
    local function walk(inst)
        for _, obj in ipairs(inst:GetChildren()) do
            if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then track(obj, "TextTransparency")
            elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then track(obj, "ImageTransparency")
            elseif obj:IsA("UIStroke") then track(obj, "Transparency")
            elseif obj:IsA("Frame") then track(obj, "BackgroundTransparency") end
            walk(obj)
        end
    end
    if c:IsA("Frame") then track(c, "BackgroundTransparency") end
    walk(c)
    for _, item in ipairs(cache) do item[1][item[2]] = 1 b(item[1], {[item[2]] = item[3]}, 0.28) end
end

local function aL(a, c)
    c = c or 0
    a.GroupTransparency = 1
    a.Position = UDim2.fromOffset(0, c + 14)
    a.Visible = true
    b(a, {GroupTransparency = 0, Position = UDim2.fromOffset(0, c)}, 0.32, Enum.EasingStyle.Quint)
end

function h:_buildHome(d)
    local e, n, p, w = "Frame", "UIListLayout", "NoDrag", "Executor"
    local m = self:Tab({Name = d.Name or "Home", Desc = d.Desc, Icon = d.Icon or "house"})
    local q = m.List
    local x = d.Pages or d.Tabs
    local r = {}
    local s
    if type(x) == "table" and #x > 0 then
        s = c(e, {Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 1, LayoutOrder = 1, Parent = q})
        c(n, {FillDirection = Enum.FillDirection.Horizontal, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6), Parent = s})
    end
    local greeting = d.Greeting
    if greeting == nil then
        local hr = tonumber(os.date("%H")) or 12
        local part = hr < 12 and "morning" or (hr < 18 and "afternoon" or "evening")
        greeting = "Good " .. part .. "."
    end
    local h = c(e, {Size = UDim2.new(1, 0, 0, 58), BackgroundColor3 = a.Surface2, BorderSizePixel = 0, LayoutOrder = 2, Parent = q})
    h:SetAttribute(p, true)
    g(h)
    i(h)
    local z = c("ImageLabel", {Position = UDim2.fromOffset(12, 11), Size = UDim2.fromOffset(36, 36), BackgroundColor3 = a.Surface, BorderSizePixel = 0, Parent = h})
    g(z, UDim.new(0, 8))
    i(z)
    task.spawn(function()
        local ok, img = pcall(function() return I:GetUserThumbnailAsync(J.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100) end)
        if ok and img then z.Image = img end
    end)
    f({Position = UDim2.fromOffset(58, 11), Size = UDim2.new(1, -72, 0, 18), Text = (d.Welcome or "Hello, ") .. J.DisplayName, TextSize = 15, Parent = h})
    f({Position = UDim2.fromOffset(58, 30), Size = UDim2.new(1, -72, 0, 16), Text = greeting, TextSize = 13, FontFace = j.Regular, TextColor3 = a.Muted, Parent = h})
    local t = c(e, {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, LayoutOrder = 3, Parent = q})
    c(n, {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8), Parent = t})
    if d.Sections ~= false then
        local b = c(e, {Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1, LayoutOrder = 1, Parent = t})
        local g = f({Position = UDim2.fromOffset(2, 6), Size = UDim2.new(0, 0, 0, 16), AutomaticSize = Enum.AutomaticSize.X, Text = string.upper(d.SectionName or "System info"), TextSize = 12, TextColor3 = a.Muted, TextTruncate = Enum.TextTruncate.None, Parent = b})
        local i = c(e, {AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0, 14), Size = UDim2.new(1, -12, 0, 1), BackgroundColor3 = a.Stroke, BorderSizePixel = 0, Parent = b})
        local function h() i.Size = UDim2.new(1, -(g.AbsoluteSize.X / self.Scale.Scale + 14), 0, 1) end
        g:GetPropertyChangedSignal("AbsoluteSize"):Connect(h)
        task.defer(h)
    end
    local C = c(e, {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, LayoutOrder = 2, Parent = t})
    c("UIGridLayout", {CellSize = UDim2.new(0.5, -4, 0, 62), CellPadding = UDim2.fromOffset(8, 8), SortOrder = Enum.SortOrder.LayoutOrder, Parent = C})
    local statsList = d.Stats or {"FPS", "Ping", w, "Game", "Region", "Time"}
    local statMap = {}
    for _, stat in ipairs(statsList) do statMap[stat] = true end
    local idx = 0
    local function addStat(name, icon, label)
        if not statMap[name] then return nil end
        idx = idx + 1
        return aK(C, idx, icon, label)
    end
    local fpsCard = addStat("FPS", "activity", "FPS")
    local pingCard = addStat("Ping", "wifi", "Ping")
    local execCard = addStat(w, "terminal", w)
    local gameCard = addStat("Game", "gamepad-2", "Game")
    local regionCard = addStat("Region", "globe", "Server region")
    local timeCard = addStat("Time", "clock", "Time of day")
    local playersCard = addStat("Players", "users", "Players")
    local uptimeCard = addStat("Uptime", "timer", "Session")
    if execCard then execCard.Text = ax() end
    if gameCard then gameCard.Text = "Loading" task.spawn(function() gameCard.Text = ay() end) end
    if regionCard then regionCard.Text = "Loading" aA(function(val) regionCard.Text = val end) end
    local frames = 0
    local startClock = os.clock()
    self:_listen("Render", function() frames = frames + 1 end)
    task.spawn(function()
        while not self._destroyed and m.List.Parent and m._page.Parent do
            if not self.Open or self.CurrentTab ~= m then
                frames = 0
                task.wait(1)
                continue
            end
            if fpsCard then fpsCard.Text = tostring(frames) end
            frames = 0
            if pingCard then
                local ok, ping = pcall(function() return math.floor(J:GetNetworkPing() * 1000) end)
                pingCard.Text = (ok and ping or 0) .. " ms"
            end
            if timeCard then timeCard.Text = os.date(d.TimeFormat or "%H:%M") end
            if playersCard then playersCard.Text = #I:GetPlayers() .. " / " .. I.MaxPlayers end
            if uptimeCard then
                local el = math.floor(os.clock() - startClock)
                uptimeCard.Text = string.format("%d:%02d", math.floor(el / 60), el % 60)
            end
            task.wait(1)
        end
    end)
    table.insert(r, {Title = d.SectionName or "Details", Icon = d.TabIcon or "layout-grid", Frame = t})
    if s then
        for h, page in ipairs(x) do
            local d = c(e, {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Visible = false, LayoutOrder = 3, Parent = q})
            c(n, {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8), Parent = d})
            if type(page.Content) == "string" then
                local h = c(e, {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = a.Surface2, BorderSizePixel = 0, LayoutOrder = 1, Parent = d})
                h:SetAttribute(p, true)
                g(h)
                i(h)
                o(h, 14, 14, 12, 14)
                f({Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Text = page.Content, TextSize = 13, FontFace = j.Regular, TextColor3 = a.Muted, TextWrapped = true, TextTruncate = Enum.TextTruncate.None, TextYAlignment = Enum.TextYAlignment.Top, Parent = h})
            end
            if type(page.Entries) == "table" then
                for m, entry in ipairs(page.Entries) do
                    local h = c(e, {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = a.Surface2, BorderSizePixel = 0, LayoutOrder = m, Parent = d})
                    h:SetAttribute(p, true)
                    g(h)
                    i(h)
                    o(h, 14, 14, 12, 14)
                    c(n, {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4), Parent = h})
                    local l = c(e, {Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1, LayoutOrder = 1, Parent = h})
                    f({Size = UDim2.new(1, -70, 1, 0), Text = entry.Title or entry.Version or "Update", TextSize = 14, Parent = l})
                    if entry.Date or entry.Tag then
                        local d = c(e, {AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.fromOffset(0, 20), AutomaticSize = Enum.AutomaticSize.X, BackgroundColor3 = a.Surface, BorderSizePixel = 0, Parent = l})
                        g(d, UDim.new(0, 5))
                        i(d)
                        o(d, 8, 8)
                        f({Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, Text = entry.Tag or entry.Date, TextSize = 11, TextColor3 = a.Muted, TextTruncate = Enum.TextTruncate.None, Parent = d})
                    end
                    local k = entry.Content or entry.Body
                    if type(entry.Changes) == "table" then k = "• " .. table.concat(entry.Changes, "\n• ") end
                    if k then
                        f({Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Text = k, TextSize = 13, FontFace = j.Regular, TextColor3 = a.Muted, TextWrapped = true, TextTruncate = Enum.TextTruncate.None, TextYAlignment = Enum.TextYAlignment.Top, LayoutOrder = 2, Parent = h})
                    end
                end
            end
            if type(page.Build) == "function" then
                l(page.Build, d)
                for _, obj in ipairs(d:GetChildren()) do if obj:IsA("GuiObject") then obj:SetAttribute(p, true) end end
            end
            table.insert(r, {Title = page.Name or page.Title or "Page", Icon = page.Icon, Frame = d})
        end
        local d = {}
        local function k(c, e)
            local changed = self._homeIndex ~= c
            self._homeIndex = c
            h.Visible = c == 1
            if c == 1 and changed and not e then an(h) end
            for i, page in ipairs(r) do
                local active = i == c
                local j = page.Frame
                j.Visible = active
                if active and changed and not e then
                    for _, obj in ipairs(j:GetChildren()) do if obj:IsA("GuiObject") then an(obj) end end
                end
                local item = d[i]
                if item then
                    b(item.Frame, {BackgroundTransparency = active and 0 or 1}, 0.15)
                    b(item.Stroke, {Transparency = active and 0 or 1}, 0.15)
                    b(item.Label, {TextColor3 = active and a.Text or a.Muted}, 0.15)
                    if item.Icon then b(item.Icon, {ImageColor3 = active and a.Accent or a.Muted}, 0.15) end
                end
            end
        end
        for h, page in ipairs(r) do
            local e = c("TextButton", {Size = UDim2.fromOffset(0, 32), AutomaticSize = Enum.AutomaticSize.X, BackgroundColor3 = a.Surface2, BackgroundTransparency = 1, Text = "", AutoButtonColor = false, LayoutOrder = h, Parent = s})
            g(e, UDim.new(0, 7))
            local m = i(e, a.Stroke, 1)
            o(e, 12, 12)
            local j
            if page.Icon then
                j = c("ImageLabel", {AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 0.5, 0), Size = UDim2.fromOffset(14, 14), BackgroundTransparency = 1, ImageColor3 = a.Muted, ScaleType = Enum.ScaleType.Fit, Parent = e})
                u(j, page.Icon)
            end
            local n = f({Position = UDim2.fromOffset(j and 20 or 0, 0), Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, Text = page.Title, TextSize = 13, TextColor3 = a.Muted, TextTruncate = Enum.TextTruncate.None, Parent = e})
            d[h] = {Frame = e, Stroke = m, Label = n, Icon = j}
            e.MouseEnter:Connect(function() if self._homeIndex ~= h then b(e, {BackgroundTransparency = 0.4}, 0.12) b(m, {Transparency = 0.5}, 0.12) end end)
            e.MouseLeave:Connect(function() if self._homeIndex ~= h then b(e, {BackgroundTransparency = 1}, 0.2) b(m, {Transparency = 1}, 0.2) end end)
            e.MouseButton1Click:Connect(function() k(h) end)
        end
        k(1)
    end
    m._order = 10
    self.Home = m
    return m
end

function h:Tab(props, iconFallback)
    props = n(props, {Title = "Name", Description = "Desc"})
    if iconFallback ~= nil and props.Icon == nil then props.Icon = iconFallback end
    local tab = setmetatable({Name = props.Name or "Tab", Window = self, _order = 0}, k)
    local btn = c("TextButton", {Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = a.Surface2, BackgroundTransparency = 1, Text = "", AutoButtonColor = false, LayoutOrder = #self.Tabs + 1, Parent = self.TabList})
    g(btn)
    local stroke = i(btn, a.Stroke, 1)
    tab._button = btn
    local hasIcon = props.Icon ~= nil
    if hasIcon then
        local icon = c("ImageLabel", {AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 12, 0.5, 0), Size = UDim2.fromOffset(16, 16), BackgroundTransparency = 1, ImageColor3 = a.Muted, ScaleType = Enum.ScaleType.Fit, Parent = btn})
        u(icon, props.Icon)
        tab._icon = icon
    end
    tab._label = f({Position = UDim2.fromOffset(hasIcon and 36 or 14, 0), Size = UDim2.new(1, -(hasIcon and 44 or 22), 1, 0), Text = tab.Name, TextColor3 = a.Text, Parent = btn})
    local page = c("Frame", {Name = tab.Name, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Visible = false, Parent = self.Content})
    tab._page = page
    f({Position = UDim2.fromOffset(24, 20), Size = UDim2.new(1, -72, 0, 24), Text = tab.Name, TextSize = 22, Parent = page})
    if props.Desc then
        f({Position = UDim2.fromOffset(24, 44), Size = UDim2.new(1, -72, 0, 16), Text = props.Desc, TextSize = 13, FontFace = j.Regular, TextColor3 = a.Muted, Parent = page})
    end
    local listY = props.Desc and 70 or 58
    local list = c("ScrollingFrame", {
        Position = UDim2.fromOffset(0, listY), Size = UDim2.new(1, 0, 1, -listY),
        BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 2,
        ScrollBarImageColor3 = a.Accent, ScrollBarImageTransparency = 0.5,
        AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(), Parent = page
    })
    o(list, 24, 24, 2, 24)
    if m then list:SetAttribute("NoDrag", true) end
    c("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8), Parent = list})
    tab.List = list
    local emptyState, count = aJ(page, props.Icon or "layout-grid", props.EmptyText or "Nothing here yet"), 0
    list.ChildAdded:Connect(function(obj) if obj:IsA("GuiObject") then count = count + 1 emptyState.Visible = false end end)
    list.ChildRemoved:Connect(function(obj) if obj:IsA("GuiObject") then count = math.max(count - 1, 0) emptyState.Visible = count <= 0 end end)
    emptyState.Visible = true
    btn.MouseEnter:Connect(function() if self.CurrentTab ~= tab then b(btn, {BackgroundTransparency = 0.4}, 0.12) b(stroke, {Transparency = 0.5}, 0.12) end end)
    btn.MouseLeave:Connect(function() if self.CurrentTab ~= tab then b(btn, {BackgroundTransparency = 1}, 0.2) b(stroke, {Transparency = 1}, 0.2) end end)
    btn.MouseButton1Click:Connect(function() self:SelectTab(tab) end)
    tab._stroke = stroke
    if not self._introDone then btn.Visible = false end
    table.insert(self.Tabs, tab)
    if #self.Tabs == 1 then
        task.defer(function() if not self.CurrentTab then self:SelectTab(tab) end end)
    end
    return tab
end

h.CreateTab = h.Tab

function h:Dialog(props)
    props = n(props, {Text = "Content", Message = "Content"})
    if self._dialog then self._dialog.Close() end
    local d = 18
    local backdrop = c("TextButton", {Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 40, Parent = self.Body})
    local box = c("TextButton", {
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 10),
        Size = UDim2.fromOffset(300, 120), BackgroundColor3 = a.Background, BackgroundTransparency = 1,
        BorderSizePixel = 0, Text = "", AutoButtonColor = false, ZIndex = 41, Parent = backdrop
    })
    g(box, UDim.new(0, 10))
    local boxStroke = i(box, a.Stroke, 1)
    local boxScale = c("UIScale", {Scale = 0.94, Parent = box})
    local faders = {}
    local iconPad = 0
    if props.Icon then
        local holder, icon = A(box, props.Icon, a.Accent, UDim2.new(0, d, 0, d + 9))
        icon.ImageTransparency = 1
        holder.ZIndex = 42
        icon.ZIndex = 42
        table.insert(faders, {icon, "ImageTransparency", 0})
        iconPad = 24
    end
    local titleLbl = f({Position = UDim2.fromOffset(d + iconPad, d), Size = UDim2.new(1, -(d * 2 + iconPad), 0, 18), Text = props.Title or "Are you sure?", TextSize = 15, TextTransparency = 1, ZIndex = 42, Parent = box})
    table.insert(faders, {titleLbl, "TextTransparency", 0})
    local contentH = 0
    if props.Content then
        local content = f({Position = UDim2.fromOffset(d, d + 24), Size = UDim2.new(1, -d * 2, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Text = props.Content, TextSize = 13, FontFace = j.Regular, TextColor3 = a.Muted, TextWrapped = true, TextTransparency = 1, TextTruncate = Enum.TextTruncate.None, TextYAlignment = Enum.TextYAlignment.Top, ZIndex = 42, Parent = box})
        table.insert(faders, {content, "TextTransparency", 0})
        contentH = math.max(content.TextBounds.Y, 16) + 6
        content:GetPropertyChangedSignal("TextBounds"):Connect(function()
            local newH = math.max(content.TextBounds.Y, 16) + 6
            if newH ~= contentH then
                contentH = newH
                box.Size = UDim2.fromOffset(300, d + 24 + contentH + 12 + 34 + d)
                local row = box:FindFirstChild("ButtonRow")
                if row then row.Position = UDim2.fromOffset(d, d + 24 + contentH + 12) end
            end
        end)
    end
    local row = c("Frame", {Name = "ButtonRow", Position = UDim2.fromOffset(d, d + 24 + contentH + 12), Size = UDim2.new(1, -d * 2, 0, 34), BackgroundTransparency = 1, ZIndex = 42, Parent = box})
    c("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Right, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8), Parent = row})
    box.Size = UDim2.fromOffset(300, d + 24 + contentH + 12 + 34 + d)
    local api, closed = {}, false
    function api.Close()
        if closed then return end
        closed = true
        if self._dialog == api then self._dialog = nil end
        b(backdrop, {BackgroundTransparency = 1}, 0.18)
        b(box, {BackgroundTransparency = 1, Position = UDim2.new(0.5, 0, 0.5, 8)}, 0.18, Enum.EasingStyle.Quint)
        b(boxScale, {Scale = 0.96}, 0.18, Enum.EasingStyle.Quint)
        b(boxStroke, {Transparency = 1}, 0.12)
        for _, item in ipairs(faders) do b(item[1], {[item[2]] = 1}, 0.12) end
        task.delay(0.2, function() backdrop:Destroy() end)
    end
    for q, btnProps in ipairs(props.Buttons or {}) do
        local primary = btnProps.Variant == "Primary"
        local btn = c("TextButton", {
            Size = UDim2.fromOffset(0, 34), AutomaticSize = Enum.AutomaticSize.X,
            BackgroundColor3 = primary and a.Accent or a.Surface2, BackgroundTransparency = 1,
            BorderSizePixel = 0, Text = "", AutoButtonColor = false, ClipsDescendants = true,
            LayoutOrder = q, ZIndex = 43, Parent = row
        })
        g(btn, UDim.new(0, 7))
        local stroke = i(btn, primary and a.Accent or a.Stroke, 1)
        o(btn, 14, 14)
        local lbl = f({Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, Text = btnProps.Title or btnProps.Name or "OK", TextSize = 13, TextColor3 = primary and a.AccentDark or a.Text, TextXAlignment = Enum.TextXAlignment.Center, TextTransparency = 1, ZIndex = 44, Parent = btn})
        local baseBg = primary and 0.12 or 0
        local baseStroke = primary and 0.4 or 0
        table.insert(faders, {btn, "BackgroundTransparency", baseBg})
        table.insert(faders, {stroke, "Transparency", baseStroke})
        table.insert(faders, {lbl, "TextTransparency", 0})
        btn.MouseEnter:Connect(function()
            if closed then return end
            if primary then
                b(btn, {BackgroundTransparency = 0}, 0.12)
                b(stroke, {Transparency = 0}, 0.12)
            else
                b(stroke, {Color = a.StrokeHover}, 0.12)
            end
        end)
        btn.MouseLeave:Connect(function()
            if closed then return end
            if primary then
                b(btn, {BackgroundTransparency = baseBg}, 0.2)
                b(stroke, {Transparency = baseStroke}, 0.2)
            else
                b(stroke, {Color = a.Stroke}, 0.2)
            end
        end)
        btn.MouseButton1Click:Connect(function()
            api.Close()
            l(btnProps.Callback)
        end)
    end
    function api.Cancel()
        if closed then return end
        api.Close()
        l(props.OnCancel)
    end
    api.Dismissable = props.CloseOnBackdrop ~= false
    if api.Dismissable then backdrop.MouseButton1Click:Connect(api.Cancel) end
    self._dialog = api
    b(backdrop, {BackgroundTransparency = 0.45}, 0.25)
    b(box, {BackgroundTransparency = 0, Position = UDim2.fromScale(0.5, 0.5)}, 0.3, Enum.EasingStyle.Quint)
    b(boxStroke, {Transparency = 0}, 0.25)
    b(boxScale, {Scale = 1}, 0.4, Enum.EasingStyle.Back)
    for _, item in ipairs(faders) do b(item[1], {[item[2]] = item[3]}, 0.25) end
    return api
end

function h:Confirm(props)
    props = n(props, {Text = "Content", Message = "Content"})
    return self:Dialog({
        Title = props.Title or "Are you sure?",
        Content = props.Content,
        Icon = props.Icon,
        OnCancel = props.OnCancel,
        Buttons = {
            {Title = props.CancelText or "Cancel", Callback = props.OnCancel},
            {Title = props.ConfirmText or "Confirm", Variant = "Primary", Callback = props.Callback}
        }
    })
end

function h:_listen(evt, fn, owner)
    local list = self._inputListeners[evt]
    table.insert(list, fn)
    local function unsub()
        for i, item in ipairs(list) do
            if item == fn then
                table.remove(list, i)
                break
            end
        end
    end
    if owner then
        owner._listeners = owner._listeners or {}
        table.insert(owner._listeners, unsub)
    end
    return unsub
end

function h:_indicatorY(tab)
    local list = self.TabList
    local scale = self.Scale.Scale
    return (tab._button.AbsolutePosition.Y - list.AbsolutePosition.Y + tab._button.AbsoluteSize.Y / 2) / scale + list.Position.Y.Offset
end

function h:_placeIndicator(tab)
    local ind = self.Indicator
    local yPos = self:_indicatorY(tab)
    if not ind.Visible then
        ind.Visible = true
        ind.Position = UDim2.fromOffset(6, yPos)
        ind.Size = UDim2.fromOffset(3, 0)
    end
    b(ind, {Position = UDim2.fromOffset(6, yPos), Size = UDim2.fromOffset(3, 18)}, 0.35, Enum.EasingStyle.Back)
end

function h:SelectTab(tab)
    if type(tab) == "string" then
        for _, t in ipairs(self.Tabs) do
            if t.Name == tab then
                tab = t
                break
            end
        end
    end
    if type(tab) ~= "table" or self.CurrentTab == tab then return end
    local prev = self.CurrentTab
    self.CurrentTab = tab
    self:_settleTransition()
    local gen = (self._transitionGeneration or 0) + 1
    self._transitionGeneration = gen
    if prev then
        b(prev._button, {BackgroundTransparency = 1}, 0.2)
        b(prev._stroke, {Transparency = 1}, 0.2)
        b(prev._label, {TextColor3 = a.Muted}, 0.2)
        if prev._icon then b(prev._icon, {ImageColor3 = a.Muted}, 0.2) end
        local out = self._outLayer
        prev._page.Parent = out
        self._outPage = prev._page
        out.GroupTransparency = 0
        out.Position = UDim2.fromOffset(0, 0)
        out.Visible = true
        b(out, {GroupTransparency = 1, Position = UDim2.fromOffset(0, -10)}, 0.18)
        task.delay(0.18, function() if self._transitionGeneration == gen then self:_settleOut() end end)
    end
    b(tab._button, {BackgroundTransparency = 0, BackgroundColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
    b(tab._stroke, {Transparency = 1}, 0.2)
    b(tab._label, {TextColor3 = Color3.fromRGB(0, 0, 0)}, 0.2)
    if tab._icon then b(tab._icon, {ImageColor3 = a.Accent}, 0.2) end
    self:_placeIndicator(tab)
    local page = tab._page
    page.Position = UDim2.fromOffset(0, 0)
    page.Visible = true
    page.Parent = self._inLayer
    self._inPage = page
    aL(self._inLayer)
    task.delay(0.32, function() if self._transitionGeneration == gen then self:_settleIn() end end)
end

function h:_settleOut()
    local page = self._outPage
    if page then
        page.Parent = self.Content
        page.Visible = false
        self._outPage = nil
    end
    self._outLayer.Visible = false
end

function h:_settleIn()
    local page = self._inPage
    if page then
        page.Parent = self.Content
        page.Position = UDim2.fromOffset(0, 0)
        self._inPage = nil
    end
    self._inLayer.Visible = false
end

function h:_settleTransition()
    self:_settleOut()
    self:_settleIn()
end

function h:Toggle(open)
    if not self._introDone then return end
    if open == nil then open = not self.Open end
    if open == self.Open then return end
    self.Open = open
    if open then
        self.Root.Visible = true
        b(self.Scale, {Scale = self._fitScale or 1}, 0.4, Enum.EasingStyle.Back)
        b(self.Body, {GroupTransparency = 0}, 0.25)
        b(self.BodyStroke, {Transparency = 0}, 0.25)
        b(self.Shadow, {ImageTransparency = 0.6}, 0.3)
    else
        b(self.Scale, {Scale = (self._fitScale or 1) * 0.94}, 0.2, Enum.EasingStyle.Quint)
        b(self.Body, {GroupTransparency = 1}, 0.16)
        b(self.BodyStroke, {Transparency = 1}, 0.12)
        b(self.Shadow, {ImageTransparency = 1}, 0.16)
        task.delay(0.2, function() if not self.Open then self.Root.Visible = false end end)
    end
end

function h:SetKeepOnScreen(val)
    self.KeepOnScreen = val ~= false
    if self.KeepOnScreen then self:_clampToScreen() end
end

function h:SetKeybind(key)
    key = F(key)
    if not key then return end
    self.Keybind = key
    self._keyChipLabel.Text = W(key)
end

function h:SetTitle(t) self._titleLabel.Text = tostring(t) end
function h:SetSubtitle(t) self._subtitleLabel.Text = tostring(t) end
function h:SetIcon(icon) u(self._logo, icon) end

function h:Notify(props)
    props = n(props, {Text = "Content", Message = "Content", Image = "Icon"})
    local duration = props.Duration or 4
    local colorType = aB[props.Type]
    local color = colorType and a[colorType] or a.Accent
    local textColor = colorType and props.Type ~= "Info" and color or a.Text
    self._notifyOrder = self._notifyOrder + 1
    local holder = c("Frame", {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1, LayoutOrder = self._notifyOrder, Parent = self.NotifyHolder})
    local wrapper = c("Frame", {Position = UDim2.fromOffset(320, 0), Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = holder})
    local shadow = c("ImageLabel", {Position = UDim2.fromOffset(-20, -20), Size = UDim2.new(1, 40, 1, 40), BackgroundTransparency = 1, Image = v.Shadow, ImageColor3 = Color3.new(0, 0, 0), ImageTransparency = 1, ScaleType = Enum.ScaleType.Slice, SliceCenter = Rect.new(49, 49, 450, 450), ZIndex = 0, Parent = wrapper})
    local toast = c("CanvasGroup", {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = a.Background, BorderSizePixel = 0, GroupTransparency = 1, Parent = wrapper})
    g(toast, UDim.new(0, 10))
    local stroke = i(toast, a.Stroke)
    T(toast)
    z(toast, UDim2.fromOffset(260, 120), UDim2.new(1, -10, 0, -10), 0.86, 90)
    local content = c("Frame", {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = toast})
    o(content, 16, 16, 14, 24)
    local iconPad = 0
    local accent = c("Frame", {Position = UDim2.fromOffset(0, 14), Size = UDim2.new(0, 2, 1, -28), BackgroundColor3 = color, BorderSizePixel = 0, Parent = toast})
    g(accent, UDim.new(1, 0))
    if props.Icon then
        A(content, props.Icon, color, UDim2.new(0, 0, 0, 8))
        iconPad = 24
    end
    f({Position = UDim2.fromOffset(iconPad, 0), Size = UDim2.new(1, -28 - iconPad, 0, 16), Text = props.Title or "Notification", TextSize = 14, TextColor3 = textColor, Parent = content})
    local closeBtn = c("TextButton", {AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 6, 0, -5), Size = UDim2.fromOffset(24, 24), BackgroundTransparency = 1, Text = "×", TextColor3 = a.Muted, TextSize = 22, FontFace = j.Bold, AutoButtonColor = false, Parent = content})
    closeBtn.MouseEnter:Connect(function() b(closeBtn, {TextColor3 = a.Text}, 0.15) end)
    closeBtn.MouseLeave:Connect(function() b(closeBtn, {TextColor3 = a.Muted}, 0.2) end)
    if props.Content then
        f({Position = UDim2.fromOffset(iconPad, 21), Size = UDim2.new(1, -iconPad, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Text = props.Content, TextSize = 13, FontFace = j.Regular, TextColor3 = a.Muted, TextWrapped = true, TextTruncate = Enum.TextTruncate.None, TextYAlignment = Enum.TextYAlignment.Top, Parent = content})
    end
    local barBg = c("Frame", {AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 16, 1, -8), Size = UDim2.new(1, -32, 0, 3), BackgroundColor3 = a.Surface3, BorderSizePixel = 0, Parent = toast})
    g(barBg, UDim.new(1, 0))
    local barFill = c("Frame", {Size = UDim2.fromScale(1, 1), BackgroundColor3 = color, BorderSizePixel = 0, Parent = barBg})
    g(barFill, UDim.new(1, 0))
    task.defer(function() if holder.Parent then b(holder, {Size = UDim2.new(1, 0, 0, toast.AbsoluteSize.Y)}, 0.3, Enum.EasingStyle.Quint) end end)
    b(wrapper, {Position = UDim2.fromOffset(0, 0)}, 0.5, Enum.EasingStyle.Back)
    b(toast, {GroupTransparency = 0}, 0.3)
    b(shadow, {ImageTransparency = 0.6}, 0.4)
    b(barFill, {Size = UDim2.fromScale(0, 1)}, duration, Enum.EasingStyle.Linear)
    local dismissed = false
    local function dismiss()
        if dismissed then return end
        dismissed = true
        for i, fn in ipairs(self._toasts) do
            if fn == dismiss then
                table.remove(self._toasts, i)
                break
            end
        end
        b(wrapper, {Position = UDim2.fromOffset(320, 0)}, 0.3, Enum.EasingStyle.Quint)
        b(toast, {GroupTransparency = 1}, 0.2)
        b(stroke, {Transparency = 1}, 0.15)
        b(shadow, {ImageTransparency = 1}, 0.2)
        task.delay(0.22, function()
            holder.ClipsDescendants = true
            b(holder, {Size = UDim2.new(1, 0, 0, -4)}, 0.22, Enum.EasingStyle.Quint)
            task.delay(0.24, function() holder:Destroy() end)
        end)
    end
    task.delay(duration, dismiss)
    closeBtn.MouseButton1Click:Connect(dismiss)
    table.insert(self._toasts, dismiss)
    while #self._toasts > self.MaxNotifications do
        local first = table.remove(self._toasts, 1)
        first()
    end
    return {Dismiss = dismiss}
end

function h:Destroy()
    if self._destroyed then return end
    self._destroyed = true
    for i, win in ipairs(e.Windows) do
        if win == self then
            table.remove(e.Windows, i)
            break
        end
    end
    for _, conn in ipairs(self._connections) do conn:Disconnect() end
    self._connections = {}
    for kp, ctrl in pairs(self.Flags) do
        if e.Flags[kp] == ctrl then e.Flags[kp] = nil end
    end
    self.Flags = {}
    b(self.Scale, {Scale = 0.9}, 0.2)
    b(self.Body, {GroupTransparency = 1}, 0.2)
    b(self.BodyStroke, {Transparency = 1}, 0.12)
    b(self.Shadow, {ImageTransparency = 1}, 0.2)
    task.delay(0.22, function() self.Gui:Destroy() end)
end

return e
