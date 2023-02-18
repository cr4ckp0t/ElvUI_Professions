-------------------------------------------------------------------------------
-- ElvUI Professions Datatext By Crackpot (US, Thrall)
-------------------------------------------------------------------------------
local E, _, V, P, G = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local DT = E:GetModule('DataTexts')
local L = E.Libs.ACL:GetLocale("ElvUI_Professions", false)
local EP = E.Libs.EP

local unpack = _G["unpack"]
local GetProfessionName = _G["GetProfessionName"]
local GetProfessionInfo = _G["GetProfessionInfo"]
local GetProfessions = _G["GetProfessions"]
local IsShiftKeyDown = _G["IsShiftKeyDown"]
local CastSpellByName = _G["CastSpellByName"]

local format = string.format
local join = string.join

local profValues = {}
local displayString = ""
local tooltipString = ""

local function GetProfessionName(index)
	local name, _, _, _, _, _, _, _ = GetProfessionInfo(index)
	return name
end

local function OnEvent(self, event, ...)
	local prof1, prof2, archy, fishing, cooking = GetProfessions()
	lastPanel = self
	if E.db.profdt.prof == "prof1" then
		
		if prof1 ~= nil then
			local name, _, rank, maxRank, _, _, _, _ = GetProfessionInfo(prof1)
			self.text:SetFormattedText(displayString, E.db.profdt.shortLabels == true and name:sub(1, 4) or name, rank, maxRank)
		else
			self.text:SetText(L["No Profession"])
		end
	
	elseif E.db.profdt.prof == "prof2" then
	
		if prof2 ~= nil then
			local name, _, rank, maxRank, _, _, _, _ = GetProfessionInfo(prof2)
			self.text:SetFormattedText(displayString, E.db.profdt.shortLabels == true and name:sub(1, 4) or name, rank, maxRank)
		else
			self.text:SetText(L["No Profession"])
		end
	
	elseif E.db.profdt.prof == "archy" then
	
		if archy ~= nil then
			local name, _, rank, maxRank, _, _, _, _ = GetProfessionInfo(archy)
			self.text:SetFormattedText(displayString, E.db.profdt.shortLabels == true and name:sub(1, 4) or name, rank, maxRank)
		else
			self.text:SetText(L["No Profession"])
		end
	
	elseif E.db.profdt.prof == "fishing" then
	
		if fishing ~= nil then
			local name, _, rank, maxRank, _, _, _, _ = GetProfessionInfo(fishing)
			self.text:SetFormattedText(displayString, E.db.profdt.shortLabels == true and name:sub(1, 4) or name, rank, maxRank)
		else
			self.text:SetText(L["No Profession"])
		end
	
	elseif E.db.profdt.prof == "cooking" then
	
		if cooking ~= nil then
			local name, _, rank, maxRank, _, _, _, _ = GetProfessionInfo(cooking)
			self.text:SetFormattedText(displayString, E.db.profdt.shortLabels == true and name:sub(1, 4) or name, rank, maxRank)
		else
			self.text:SetText(L["No Profession"])
		end
	
	end
end

local function Click(self, button)
	local prof1, prof2, archy, _, cooking = GetProfessions()
	if button == "LeftButton" then
		if IsShiftKeyDown() and archy == nil then return
		elseif not IsShiftKeyDown() and prof1 == nil then return end
		local name, _, _, _, _, _, _, _ = GetProfessionInfo(IsShiftKeyDown() and archy or prof1)
		CastSpellByName(name == L["Mining"] and L["Smelting"] or name)
	elseif button == "RightButton" then
		if IsShiftKeyDown() and cooking == nil then return
		elseif not IsShiftKeyDown() and prof2 == nil then return end
		local name, _, _, _, _, _, _, _ = GetProfessionInfo(IsShiftKeyDown() and cooking or prof2)
		CastSpellByName(name == L["Mining"] and L["Smelting"] or name)
	end
end

local function OnEnter(self)
	DT:SetupTooltip(self)
	
	local prof1, prof2, archy, fishing, cooking = GetProfessions()
	local professions = {}
	
	if prof1 ~= nil then
		local name, texture, rank, maxRank, _, _, _, _ = GetProfessionInfo(prof1)
		professions[#professions + 1] = {
			name	= name,
			texture	= ("|T%s:12:12:1:0|t"):format(texture),
			rank	= rank,
			maxRank	= maxRank
		}
	end
	
	if prof2 ~= nil then
		local name, texture, rank, maxRank, _, _, _, _ = GetProfessionInfo(prof2)
		professions[#professions + 1] = {
			name	= name,
			texture	= ("|T%s:12:12:1:0|t"):format(texture),
			rank	= rank,
			maxRank	= maxRank
		}
	end
	
	if archy ~= nil then
		local name, texture, rank, maxRank, _, _, _, _ = GetProfessionInfo(archy)
		professions[#professions + 1] = {
			name	= name,
			texture	= ("|T%s:12:12:1:0|t"):format(texture),
			rank	= rank,
			maxRank	= maxRank
		}
	end
	
	if fishing ~= nil then
		local name, texture, rank, maxRank, _, _, _, _ = GetProfessionInfo(fishing)
		professions[#professions + 1] = {
			name	= name,
			texture	= ("|T%s:12:12:1:0|t"):format(texture),
			rank	= rank,
			maxRank	= maxRank
		}
	end
	
	if cooking ~= nil then
		local name, texture, rank, maxRank, _, _, _, _ = GetProfessionInfo(cooking)
		professions[#professions + 1] = {
			name	= name,
			texture	= ("|T%s:12:12:1:0|t"):format(texture),
			rank	= rank,
			maxRank	= maxRank
		}
	end
	
	if #professions == 0 then return end	
	sort(professions, function(a, b) return a["name"] < b["name"] end)
	
	for i = 1, #professions do
		DT.tooltip:AddDoubleLine(join("", professions[i].texture, "  ", professions[i].name), tooltipString:format(professions[i].rank, professions[i].maxRank), 1, 1, 1, 1, 1, 1)
	end
	
	if E.db.profdt.hint then
		DT.tooltip:AddLine(" ")
		DT.tooltip:AddDoubleLine(L["Left Click:"], L["Open "] .. GetProfessionName(prof1), 1, 1, 1, 1, 1, 0)
		DT.tooltip:AddDoubleLine(L["Right Click:"], L["Open "] .. GetProfessionName(prof2), 1, 1, 1, 1, 1, 0)
		DT.tooltip:AddDoubleLine(L["Shift + Left Click:"], L["Open Archaeology"], 1, 1, 1, 1, 1, 0)
		DT.tooltip:AddDoubleLine(L["Shift + Right Click:"], L["Open Cooking"], 1, 1, 1, 1, 1, 0)
	end
	
	DT.tooltip:Show()
end

local function ValueColorUpdate(self, hex, r, g, b)
	displayString = join("", "|cffffffff%s:|r ", hex, "%d|r/", hex, "%d|r")
	tooltipString = join("" , hex, "%d|r|cffffffff/|r", hex, "%d|r")
	
	OnEvent(self)
end

P["profdt"] = {
	["prof"] = "prof1",
	["shortenLabels"] = false,
	["hint"] = true,
}

local function InjectOptions()
	if not E.Options.args.Crackpotx then
		E.Options.args.Crackpotx = {
			type = "group",
			order = -2,
			name = L["Plugins by |cff0070deCrackpotx|r"],
			args = {
				thanks = {
					type = "description",
					order = 1,
					name = L["Thanks for using and supporting my work!  -- |cff0070deCrackpotx|r\n\n|cffff0000If you find any bugs, or have any suggestions for any of my addons, please open a ticket at that particular addon's page on CurseForge."],
				},
			},
		}
	elseif not E.Options.args.Crackpotx.args.thanks then
		E.Options.args.Crackpotx.args.thanks = {
			type = "description",
			order = 1,
			name = L["Thanks for using and supporting my work!  -- |cff0070deCrackpotx|r\n\n|cffff0000If you find any bugs, or have any suggestions for any of my addons, please open a ticket at that particular addon's page on CurseForge."],
		}
	end

	E.Options.args.Crackpotx.args.profdt = {
		type = "group",
		name = L["Professions Datatext"],
		get = function(info) return E.db.profdt[info[#info]] end,
		set = function(info, value) E.db.profdt[info[#info]] = value; DT:LoadDataTexts() end,
		args = {
			prof = {
				type = "select",
				order = 1,
				name = L["Professions"],
				desc = L["Select which profession to display."],
				
				values = function()
					local prof1, prof2, archy, fishing, cooking = GetProfessions()
					local profValues = {}
					if prof1 ~= nil then profValues['prof1'] = GetProfessionName(prof1) end
					if prof2 ~= nil then profValues['prof2'] = GetProfessionName(prof2) end
					if archy ~= nil then profValues['archy'] = GetProfessionName(archy) end
					if fishing ~= nil then profValues['fishing'] = GetProfessionName(fishing) end
					if cooking ~= nil then profValues['cooking'] = GetProfessionName(cooking) end
					sort(profValues)
					return profValues
				end,
			},
			shortLabels = {
				type = "toggle",
				order = 2,
				name = L["Shorten Labels"],
				desc = L["Shorten the profession labels in the datatext. For example |cffffff00Engineering|r becomes |cffffff00Eng|r."],
			},
			hint = {
				type = "toggle",
				order = 3,
				name = L["Show Hint"],
				desc = L["Show the hint in the tooltip."],
			},
		},
	}
end

EP:RegisterPlugin(..., InjectOptions)
DT:RegisterDatatext("Professions", nil, {"PLAYER_ENTERING_WORLD", "CHAT_MSG_SKILL", "TRADE_SKILL_LIST_UPDATE", "TRADE_SKILL_DETAILS_UPDATE"}, OnEvent, nil, Click, OnEnter, nil, L["Professions"], nil, ValueColorUpdate)