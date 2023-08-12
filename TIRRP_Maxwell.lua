if not doesDirectoryExist('moonloader/config') then createDirectory('moonloader/config') end
script_name('[MaxMenu]')
script_author('Maxwell')
script_description('March 2022')

script_version('1.1')
script_version_number(2)

require "lib.moonloader"


local events 			= require 'lib.samp.events'
local imgui 			= require 'imgui'
local KEY 				= require 'vkeys'
local mem 				= require 'memory'
local samem 			= require 'SAMemory'
local inicfg 			= require 'inicfg'
local encoding 			= require 'encoding'

local dlstatus = require 'moonloader'.download_status

local updatesavaliable = false
local updateLoaded = false

encoding.default = 'CP1251'
u8 = encoding.UTF8
samem.require 'CTrain'

local CategoryOptions = 0
local DialogOptions = 0

-------------------------------------------------------

local settings = inicfg.load(
{
	sensfix = {
		enabled = false,
		aimglobal = 1.0,
		aimdeagle = 1.0,
		aimmp5 = 1.0,
		aimassault = 1.0,
		aimshotgun = 1.0,
		aimsniper =  1.0,

		firedeagle = 1.0,
		firemp5 = 1.0,
		fireassault = 1.0,
		fireshotgun = 1.0,
		firesniper =  1.0,
	},
	anticheat = {
		tagos = false,
	},
}, 'tirrp_maxmenu\\config')

function FileSettings()
	while true do wait(0)
		mainini = inicfg.load({
			sensfix = {
				enabled = cb_show_sens_enable,
				aimglobal = cb_show_aim_global,
				aimdeagle = cb_show_aim_deagle,
				aimmp5 = cb_show_aim_mp5,
				aimassault = cb_show_aim_assault,
				aimshotgun = cb_show_aim_shotgun,
				aimsniper =  cb_show_aim_sniper,

				firedeagle = cb_show_fire_deagle,
				firemp5 = cb_show_fire_mp5,
				fireassault = cb_show_fire_assault,
				fireshotgun = cb_show_fire_shotgun,
				firesniper =  cb_show_fire_sniper,
			},
			anticheat = {
				tagos = cb_show_tagos,
			},
		}, 'tirrp_maxmenu\\config')
	end
end

function SaveSettings()
	inicfg.save(settings, 'tirrp_maxmenu\\config')
end

function apply_custom_style()
	imgui.SwitchContext()
	local style = imgui.GetStyle()
	local colors = style.Colors
	local clr = imgui.Col
	local ImVec4 = imgui.ImVec4


	style.WindowRounding = 2.0
	style.WindowTitleAlign = imgui.ImVec2(0.5, 0.84)
	style.ChildWindowRounding = 2.0
	style.FrameRounding = 2.0
	style.ItemSpacing = imgui.ImVec2(5.0, 4.0)
	style.ScrollbarSize = 13.0
	style.ScrollbarRounding = 0
	style.GrabMinSize = 8.0
	style.GrabRounding = 1.0
	-- style.Alpha =
	-- style.WindowPadding =
	-- style.WindowMinSize =
	-- style.FramePadding =
	-- style.ItemInnerSpacing =
	-- style.TouchExtraPadding =
	-- style.IndentSpacing =
	-- style.ColumnsMinSpacing = ?
	-- style.ButtonTextAlign =
	-- style.DisplayWindowPadding =
	-- style.DisplaySafeAreaPadding =
	-- style.AntiAliasedLines =
	-- style.AntiAliasedShapes =
	-- style.CurveTessellationTol =

	colors[clr.Text]                   = ImVec4(1.00, 1.00, 1.00, 1.00)
	colors[clr.TextDisabled]           = ImVec4(0.50, 0.50, 0.50, 1.00)
	colors[clr.WindowBg]               = ImVec4(0.06, 0.06, 0.06, 0.94)
	colors[clr.ChildWindowBg]          = ImVec4(1.00, 1.00, 1.00, 0.00)
	colors[clr.PopupBg]                = ImVec4(0.08, 0.08, 0.08, 0.94)
	colors[clr.ComboBg]                = colors[clr.PopupBg]
	colors[clr.Border]                 = ImVec4(0.43, 0.43, 0.50, 0.50)
	colors[clr.BorderShadow]           = ImVec4(0.00, 0.00, 0.00, 0.00)
	colors[clr.FrameBg]                = ImVec4(0.16, 0.29, 0.48, 0.54)
	colors[clr.FrameBgHovered]         = ImVec4(0.26, 0.59, 0.98, 0.40)
	colors[clr.FrameBgActive]          = ImVec4(0.26, 0.59, 0.98, 0.67)
	colors[clr.TitleBg]                = ImVec4(0.04, 0.04, 0.04, 1.00)
	colors[clr.TitleBgActive]          = ImVec4(0.16, 0.29, 0.48, 1.00)
	colors[clr.TitleBgCollapsed]       = ImVec4(0.00, 0.00, 0.00, 0.51)
	colors[clr.MenuBarBg]              = ImVec4(0.14, 0.14, 0.14, 1.00)
	colors[clr.ScrollbarBg]            = ImVec4(0.02, 0.02, 0.02, 0.53)
	colors[clr.ScrollbarGrab]          = ImVec4(0.31, 0.31, 0.31, 1.00)
	colors[clr.ScrollbarGrabHovered]   = ImVec4(0.41, 0.41, 0.41, 1.00)
	colors[clr.ScrollbarGrabActive]    = ImVec4(0.51, 0.51, 0.51, 1.00)
	colors[clr.CheckMark]              = ImVec4(0.26, 0.59, 0.98, 1.00)
	colors[clr.SliderGrab]             = ImVec4(0.24, 0.52, 0.88, 1.00)
	colors[clr.SliderGrabActive]       = ImVec4(0.26, 0.59, 0.98, 1.00)
	colors[clr.Button]                 = ImVec4(0.26, 0.59, 0.98, 0.40)
	colors[clr.ButtonHovered]          = ImVec4(0.26, 0.59, 0.98, 1.00)
	colors[clr.ButtonActive]           = ImVec4(0.06, 0.53, 0.98, 1.00)
	colors[clr.Header]                 = ImVec4(0.26, 0.59, 0.98, 0.31)
	colors[clr.HeaderHovered]          = ImVec4(0.26, 0.59, 0.98, 0.80)
	colors[clr.HeaderActive]           = ImVec4(0.26, 0.59, 0.98, 1.00)
	colors[clr.Separator]              = colors[clr.Border]
	colors[clr.SeparatorHovered]       = ImVec4(0.26, 0.59, 0.98, 0.78)
	colors[clr.SeparatorActive]        = ImVec4(0.26, 0.59, 0.98, 1.00)
	colors[clr.ResizeGrip]             = ImVec4(0.26, 0.59, 0.98, 0.25)
	colors[clr.ResizeGripHovered]      = ImVec4(0.26, 0.59, 0.98, 0.67)
	colors[clr.ResizeGripActive]       = ImVec4(0.26, 0.59, 0.98, 0.95)
	colors[clr.CloseButton]            = ImVec4(0.41, 0.41, 0.41, 0.50)
	colors[clr.CloseButtonHovered]     = ImVec4(0.98, 0.39, 0.36, 1.00)
	colors[clr.CloseButtonActive]      = ImVec4(0.98, 0.39, 0.36, 1.00)
	colors[clr.PlotLines]              = ImVec4(0.61, 0.61, 0.61, 1.00)
	colors[clr.PlotLinesHovered]       = ImVec4(1.00, 0.43, 0.35, 1.00)
	colors[clr.PlotHistogram]          = ImVec4(0.90, 0.70, 0.00, 1.00)
	colors[clr.PlotHistogramHovered]   = ImVec4(1.00, 0.60, 0.00, 1.00)
	colors[clr.TextSelectedBg]         = ImVec4(0.26, 0.59, 0.98, 0.35)
	colors[clr.ModalWindowDarkening]   = ImVec4(0.80, 0.80, 0.80, 0.35)
end

do
show_main_window = imgui.ImBool(false)

local cb_show_sens_enable = imgui.ImBool(settings.sensfix.enabled)
local cb_show_aim_global = imgui.ImFloat(settings.sensfix.aimglobal)
local cb_show_aim_sniper = imgui.ImFloat(settings.sensfix.aimsniper)
local cb_show_aim_deagle = imgui.ImFloat(settings.sensfix.aimdeagle)
local cb_show_aim_assault = imgui.ImFloat(settings.sensfix.aimassault)
local cb_show_aim_shotgun = imgui.ImFloat(settings.sensfix.aimshotgun)
local cb_show_aim_mp5 = imgui.ImFloat(settings.sensfix.aimmp5)

local cb_show_fire_sniper = imgui.ImFloat(settings.sensfix.firesniper)
local cb_show_fire_deagle = imgui.ImFloat(settings.sensfix.firedeagle)
local cb_show_fire_assault = imgui.ImFloat(settings.sensfix.fireassault)
local cb_show_fire_shotgun = imgui.ImFloat(settings.sensfix.fireshotgun)
local cb_show_fire_mp5 = imgui.ImFloat(settings.sensfix.firemp5)

local cb_show_tagos = imgui.ImBool(settings.anticheat.tagos)


function MainMenu(bx, by)
	local windows_x, window_y = 580, 400
	local button_count = 7

	local border_x = (bx * button_count)
	local border_y = 40

	local button_x = bx + 5
	local button_y = by

	if border_x > windows_x then
		border_x = border_x - windows_x
	end

	if button_x > border_x then
		button_x = button_x - border_x
	end

	local Border_Size = imgui.ImVec2(border_x, border_y)
	local Button_Size = imgui.ImVec2(button_x, button_y)
	

	imgui.BeginChild("Menu##1", Border_Size, true)
		if imgui.Button("Anti Cheat", Button_Size) then
			CategoryOptions = 0
		end
		imgui.SameLine()
		if imgui.Button("Sensfix", Button_Size) then
			CategoryOptions = 1
		end
	imgui.EndChild()
end

function OptionMenu(bx,by)
	local windows_x, window_y = 580, 400
	local button_count = 7
	local border_x = (bx * button_count)
	local border_y = by

	if border_x > windows_x then
		border_x = border_x - windows_x
	end

	if CategoryOptions == 0 and DialogOptions == 0 then
		imgui.BeginChild("Option##1", imgui.ImVec2(border_x,border_y), true)
			if imgui.Checkbox('Tagos', cb_show_tagos) then
				settings.anticheat.tagos = cb_show_tagos.v
			end
		imgui.EndChild()
	end
	if CategoryOptions == 1 and DialogOptions == 0 then
		str1 = 0.2
		str2 = 1.0
		str3 = '%.2f'
    	imgui.BeginChild("Option##2", imgui.ImVec2(border_x,border_y), true)
			if imgui.Checkbox('Sensitivity Fix', cb_show_sens_enable) then
				settings.sensfix.enabled = cb_show_sens_enable.v
			end
    		if imgui.SliderFloat('global##', cb_show_aim_global, str1, str2, str3) then
				settings.sensfix.aimglobal = cb_show_aim_global.v
			end
			imgui.Text("Aim:")
			if imgui.SliderFloat('deagle##', cb_show_aim_deagle, str1, str2, str3) then
				settings.sensfix.aimdeagle = cb_show_aim_deagle.v
			end
			if imgui.SliderFloat('mp5##', cb_show_aim_mp5, str1, str2, str3) then
				settings.sensfix.aimmp5 = cb_show_aim_mp5.v
			end
			if imgui.SliderFloat('shotgun##', cb_show_aim_shotgun, str1, str2, str3) then
				settings.sensfix.aimshotgun = cb_show_aim_shotgun.v
			end
			if imgui.SliderFloat('assault##', cb_show_aim_assault, str1, str2, str3) then
				settings.sensfix.aimassault = cb_show_aim_assault.v
			end
			if imgui.SliderFloat('sniper##', cb_show_aim_sniper, str1, str2, str3) then
				settings.sensfix.aimsniper = cb_show_aim_sniper.v
			end

			imgui.Text("Fire:")
			if imgui.SliderFloat('Deagle##', cb_show_fire_deagle, str1, str2, str3) then
				settings.sensfix.firedeagle = cb_show_fire_deagle.v
			end
			if imgui.SliderFloat('Mp5##', cb_show_fire_mp5, str1, str2, str3) then
				settings.sensfix.firemp5 = cb_show_fire_mp5.v
			end
			if imgui.SliderFloat('Shotgun##', cb_show_fire_shotgun, str1, str2, str3) then
				settings.sensfix.fireshotgun = cb_show_fire_shotgun.v
			end
			if imgui.SliderFloat('Assault##', cb_show_fire_assault, str1, str2, str3) then
				settings.sensfix.fireassault = cb_show_fire_assault.v
			end
			if imgui.SliderFloat('Sniper##', cb_show_fire_sniper, str1, str2, str3) then
				settings.sensfix.firesniper = cb_show_fire_sniper.v
			end
    	imgui.EndChild()
    end
end

function imgui.OnDrawFrame()
	local sw, sh = getScreenResolution()
	local BorderSizeX, BorderSizeY = 80, 20
	-- Main Window
	if show_main_window.v then
		local windows_x, window_y = 580, 400
		-- center
		imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(windows_x, window_y), imgui.Cond.FirstUseEver)

		imgui.Begin('Main Window', show_main_window, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse)

		MainMenu(BorderSizeX, BorderSizeY)
		OptionMenu(BorderSizeX + 380, BorderSizeY + 280)
		imgui.End()
	end
end
end

apply_custom_style()

-- SAMP Events
function events.onBulletSync(playerid, data)
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
    if not isSampAvailable() then return end

	if sampIsPlayerConnected(data.targetId) and data.targetId < 1000 and settings.anticheat.tagos then
		if not (isLineOfSightClear(data.origin.x, data.origin.y, data.origin.z, data.target.x, data.target.y, data.target.z, true, false, false, true, false)) then
			sampAddChatMessage('{FFFFFF}['..playerid..']'..sampGetPlayerNickname(playerid)..' -> ['..data.targetId..']'..sampGetPlayerNickname(data.targetId)..' | Tagos ')
		end
	end
end

--------------------

function sensa(slot0)
	mem.setfloat(11987996, slot0 / 1000, false)
	mem.setfloat(11987992, slot0 / 1000, false)
end

function checkupdates(json)
	local fpath = os.tmpname()
	if doesFileExist(fpath) then os.remove(fpath) end
	downloadUrlToFile(json, fpath, function(_, status, _, _)
		if status == dlstatus.STATUSEX_ENDDOWNLOAD then
			if doesFileExist(fpath) then
				local f = io.open(fpath, 'r')
				if f then
					local info = decodeJson(f:read('*a'))
					local updateversion = info.version_num
					f:close()
					os.remove(fpath)
					if updateversion > thisScript().version_num then
						updatesavaliable = true
						updateLoaded = true
						sampAddChatMessage(u8:decode('[MaxMenu]: Update Available. Current Version: {9932cc}'..thisScript().version..'{FFFFFF}, Update Version: {9932cc}'..info.version..'{FFFFFF}.'), -1)
						return true
					else
						updatesavaliable = false
						updateLoaded = true
						sampAddChatMessage(u8:decode('[MaxMenu]: Thank you for Downloading this Mod, your File is up to date..'), -1)
					end
				else
					updatesavaliable = false
					sampAddChatMessage(u8:decode('[MaxMenu]: Error checking the Version..'), -1)
				end
			end
		end
	end)
end

function ApplyAntiCheat()
	while true do wait(0)
		-- Infinite Run
		mem.setint8(0xB7CEE4, not isCharInWater(PLAYER_PED) and 0, false)
		mem.setint8(0x96916E, 0, false)

		-- Infinite Oxygen
		mem.setint8(0x96916E, 0, false)

		-- WallHack
		local pStSet = sampGetServerSettingsPtr()
		mem.setfloat(pStSet + 39, 40.0)
		mem.setint8(pStSet + 47, 1)
		mem.setint8(pStSet + 56, 1)

		-- No Spread
		mem.setfloat(0x8D2E64, 0.95999997854233)
	end
end

function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end

	checkupdates('https://raw.githubusercontent.com/MaxwellQue/MaxMenu/master/version.json')

	while not updateLoaded do wait(1000) end
	while updatesavaliable do wait(1000) end

	lua_thread.create(FileSettings)
	-- lua_thread.create(ApplyAntiCheat)

	sampAddChatMessage('{00ff00}[MaxMenu]: {FFFFFF}Loaded!')
	sampAddChatMessage('{00ff00}[MaxMenu]: {FFFFFF}Keybind: {00FF00}2')

    while true do
		if wasKeyPressed(KEY.VK_2) and not (sampIsChatInputActive() or sampIsDialogActive()) then
			SaveSettings()
			show_main_window.v = not show_main_window.v
		end
		imgui.Process = show_main_window.v

		-- SensFix
		weap = getCurrentCharWeapon(PLAYER_PED)

		if settings.sensfix.enabled then
			if isKeyDown(KEY.VK_LBUTTON) then
				if weap == 33 or weap == 34 then
					sensa(settings.sensfix.firesniper)
				elseif weap == 22 or weap == 23 or weap == 24 then
					sensa(settings.sensfix.firedeagle)
				elseif weap == 30 or weap == 31 then
					sensa(settings.sensfix.fireassault)
				elseif weap == 27 or weap == 28 or weap == 29 then
					sensa(settings.sensfix.firemp5)
				elseif weap == 25 or weap == 26 or weap == 27 then
					sensa(settings.sensfix.fireshotgun)
				end
			elseif isKeyDown(KEY.VK_RBUTTON) then
				if weap == 33 or weap == 34 then
					sensa(settings.sensfix.aimsniper)
				elseif weap == 22 or weap == 23 or weap == 24 then
					sensa(settings.sensfix.aimdeagle)
				elseif weap == 30 or weap == 31 then
					sensa(settings.sensfix.aimassault)
				elseif weap == 27 or weap == 28 or weap == 29 then
					sensa(settings.sensfix.aimmp5)
				elseif weap == 25 or weap == 26 or weap == 27 then
					sensa(settings.sensfix.aimshotgun)
				end
			else
				sensa(settings.sensfix.aimglobal)
			end
		end
		wait(0)
    end
end
