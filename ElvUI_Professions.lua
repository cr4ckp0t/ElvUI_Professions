-------------------------------------------------------------------------------
-- ElvUI Professions Datatext By Crackpot (US, Thrall)
-------------------------------------------------------------------------------
local E, _, V, P, G = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local DT = E:GetModule('DataTexts')
local L = E.Libs.ACL:GetLocale("ElvUI_Professions", false)
local EP = E.Libs.EP
local ACH = E.Libs.ACH

local GetProfessionInfo = _G.GetProfessionInfo
local GetProfessions = _G.GetProfessions
local IsShiftKeyDown = _G.IsShiftKeyDown
local CastSpellByName = _G.CastSpellByName

local format = format
local tinsert = tinsert
local sort = sort
local wipe = wipe
local strjoin = strjoin
local strsub = strsub

local professions = {}
local displayString = ''
local tooltipString = ''
local textureString = '|T%s:16:16:0:0:64:64:4:60:4:60|t'

local function GetProfessionName(prof)
	return professions[prof] and professions[prof].name or ''
end

local function sortedPairs(t, f)
	local a = {}
	for n in pairs(t) do tinsert(a, n) end
	sort(a, f)
	local i = 0
	local iter = function()
		i = i + 1
		if a[i] == nil then return nil
		else return a[i], t[a[i]]
		end
	end
	return iter
end

local function OnEvent(self)
	wipe(professions)
	local prof1, prof2, archy, fishing, cooking = GetProfessions()
	local order = 1

	if prof1 then
		local name, texture, rank, maxRank = GetProfessionInfo(prof1)
		professions['prof1'] = { order = order + 1, name = name, texture = format(textureString, texture), rank = rank, maxRank = maxRank }
		order = order + 1
	end

	if prof2 then
		local name, texture, rank, maxRank = GetProfessionInfo(prof2)
		professions['prof2'] = { order = order + 1, name = name, texture = format(textureString, texture), rank = rank, maxRank = maxRank }
		order = order + 1
	end

	if archy then
		local name, texture, rank, maxRank = GetProfessionInfo(archy)
		professions['archy'] = { order = order + 1, name = name, texture = format(textureString, texture), rank = rank, maxRank = maxRank }
		order = order + 1
	end

	if fishing then
		local name, texture, rank, maxRank = GetProfessionInfo(fishing)
		professions['fishing'] = { order = order + 1, name = name, texture = format(textureString, texture), rank = rank, maxRank = maxRank }
		order = order + 1
	end

	if cooking then
		local name, texture, rank, maxRank = GetProfessionInfo(cooking)
		professions['cooking'] = { order = order + 1, name = name, texture = format(textureString, texture), rank = rank, maxRank = maxRank }
	end

	local data = professions[E.db.profdt.prof]

	if data then
		if E.db.profdt.showSkill then
			self.text:SetFormattedText(displayString, E.db.profdt.shortLabels == true and strsub(data.name, 1, 4) or data.name, data.rank, data.maxRank)
		else 
			self.text:SetFormattedText(displayNoSkill, E.db.profdt.shortLabels == true and strsub(data.name, 1, 4) or data.name)
		end
	else
		self.text:SetText(L["No Profession"])
	end
end

local function OnClick(_, button)
	local data
	if button == "LeftButton" then
		data = IsShiftKeyDown() and professions['archy'] or professions['prof1']
	else
		data = IsShiftKeyDown() and professions['cooking'] or professions['prof2']
	end

	if data and data.name then
		CastSpellByName(data.name == L["Mining"] and L["Smelting"] or data.name == L["Herbalism"] and L["Herbalism Journal"] or data.name)
	end
end

local function OnEnter()
	DT.tooltip:ClearLines()

	for _, data in sortedPairs(professions, function(a, b) return professions[a].order < professions[b].order end) do
		DT.tooltip:AddDoubleLine(strjoin('', data.texture, ' ', data.name), format(tooltipString, data.rank, data.maxRank), 1, 1, 1, 1, 1, 1)
	end

	if E.db.profdt.hint then
		DT.tooltip:AddLine(' ')
		DT.tooltip:AddDoubleLine(L["Left Click:"], L["Open "] .. GetProfessionName('prof1'), 1, 1, 1, 1, 1, 0)
		DT.tooltip:AddDoubleLine(L["Right Click:"], L["Open "] .. GetProfessionName('prof2'), 1, 1, 1, 1, 1, 0)
		DT.tooltip:AddDoubleLine(L["Shift + Left Click:"], L["Open Archaeology"], 1, 1, 1, 1, 1, 0)
		DT.tooltip:AddDoubleLine(L["Shift + Right Click:"], L["Open Cooking"], 1, 1, 1, 1, 1, 0)
	end

	DT.tooltip:Show()
end

local function SettingsUpdate(self, hex, r, g, b)
	displayString = strjoin('', '|cffffffff%s:|r ', hex, '%d|r/', hex, '%d|r')
	displayNoSkill = strjoin('', hex, '%s|r')
	tooltipString = strjoin('' , hex, '%d|r|cffffffff/|r', hex, '%d|r')
end

P.profdt = {
	prof = "prof1",
	shortenLabels = false,
	showSkill = true,
	hint = true,
}

local function InjectOptions()
	if not E.Options.args.Crackpotx then
		E.Options.args.Crackpotx = ACH:Group(L["Plugins by |cff0070deCrackpotx|r"])
	end
	if not E.Options.args.Crackpotx.args.thanks then
		E.Options.args.Crackpotx.args.thanks = ACH:Description(L["Thanks for using and supporting my work!  -- |cff0070deCrackpotx|r\n\n|cffff0000If you find any bugs, or have any suggestions for any of my addons, please open a ticket at that particular addon's page on CurseForge."], 1)
	end

	E.Options.args.Crackpotx.args.profdt = ACH:Group(L["Professions Datatext"], nil, nil, nil, function(info) return E.db.profdt[info[#info]] end, function(info, value) E.db.profdt[info[#info]] = value; DT:ForceUpdate_DataText('Professions') end)
	E.Options.args.Crackpotx.args.profdt.args.prof = ACH:Select(L["Professions"], L["Select which profession to display."], 1, function() local profValues = {}; for id, data in pairs(professions) do profValues[id] = data.name end return profValues end)
	E.Options.args.Crackpotx.args.profdt.args.shortLabels = ACH:Toggle(L["Shorten Labels"], L["Shorten the profession labels in the datatext. For example |cffffff00Engineering|r becomes |cffffff00Eng|r."], 2)
	E.Options.args.Crackpotx.args.profdt.args.showSkill = ACH:Toggle(L["Include Skill Level"], L["Include the skill level in the datatext text."], 3)
	E.Options.args.Crackpotx.args.profdt.args.hint = ACH:Toggle(L["Show Hint"], L["Show the hint in the tooltip."], 4)
end

EP:RegisterPlugin(..., InjectOptions)
DT:RegisterDatatext('Professions', L["Plugins by |cff0070deCrackpotx|r"], { 'CHAT_MSG_SKILL', 'TRADE_SKILL_LIST_UPDATE', 'TRADE_SKILL_DETAILS_UPDATE' }, OnEvent, nil, OnClick, OnEnter, nil, L["Professions"], nil, SettingsUpdate)
