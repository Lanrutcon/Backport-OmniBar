--------------
-- Implementing missing functions for Cataclysm
-- CHANGES: Lanrutcon
--------------

local classTable = { "WARRIOR", "PALADIN", "HUNTER", "ROGUE", "PRIEST", "DEATHKNIGHT", "SHAMAN", "MAGE", "WARLOCK", "DRUID" };
local specTable = {
	{"ARMS", "FURY", "PROTECTION"},
	{"HOLY", "PROTECTION", "RETRIBUTION"},
	{"BEAST MASTERY", "MARKSMANSHIP", "SURVIVAL"},
	{"ASSASSINATION", "COMBAT", "SUBTLETY"},
	{"DISCIPLINE", "HOLY", "SHADOW"},
	{"BLOOD", "FROST", "UNHOLY"},
	{"ELEMENTAL", "ENHANCEMENT", "RESTORATION"},
	{"ARCANE", "FIRE", "FROST"},
	{"AFFLICTION", "DEMONOLOGY", "DESTRUCTION"},
	{"BALANCE", "FERAL COMBAT", "RESTORATION"}
}

local function GetClassInfoByID(classID)
	return classID, classTable[classID];
end

local function GetNumSpecializationsForClassID(classID)
	return #specTable[classID];
end

local function GetSpecializationInfoForClassID(classID, i)
	return (classID-1)*3+i, specTable[classID][i];
end

local function GetCooldownTimes(cooldownFrame)
	return cooldownFrame.startTime, cooldownFrame.duration;
end

function orderByTimeLeft()
	table.sort(_G["OmniBar"].active, function(x, y)
		if x.cooldown.finish > y.cooldown.finish then
			return false;
		else --if x.cooldown.finish < y.cooldown.finish then
			return true;
		end
	end)
end

----------------------
-- END OF CHANGES
----------------------


-- OmniBar by Jordon

local addonName, L = ...

local cooldowns = {
	--DEATH KNIGHT - RE-CHECK
	[47476]  = { default = true,  duration = 120,  class = "DEATHKNIGHT" },                                   -- Strangulate
	[47481]  = { default = true, duration = 60,  class = "DEATHKNIGHT", specID = { 18 } },                 -- Gnaw (Ghoul)
	[47482]  = { default = true, duration = 30,  class = "DEATHKNIGHT", specID = { 18 } },                 -- Leap (Ghoul)
	[47528]  = { default = true,  duration = 10,  class = "DEATHKNIGHT" },                                   -- Mind Freeze
	[48707]  = { default = true, duration = 45,  class = "DEATHKNIGHT" },                                   -- Anti-Magic Shell
	[48743]  = { default = true, duration = 120, class = "DEATHKNIGHT" },                                   -- Death Pact
	[48792]  = { default = true, duration = 180, class = "DEATHKNIGHT" },                                   -- Icebound Fortitude
	[49028]  = { default = true, duration = 90,  class = "DEATHKNIGHT", specID = { 16 } },                 -- Dancing Rune Weapon
	[49039]  = { default = true, duration = 120, class = "DEATHKNIGHT" },                                   -- Lichborne
	[49576]  = { default = true, duration = 25,  class = "DEATHKNIGHT" },                                   -- Death Grip
	[51052]  = { default = true, duration = 120, class = "DEATHKNIGHT" },                                   -- Anti-Magic Zone
	[51271]  = { default = true, duration = 60,  class = "DEATHKNIGHT", specID = { 17 } },                 -- Pillar of Frost
	[55233]  = { default = true, duration = 60,  class = "DEATHKNIGHT", specID = { 16 } },                 -- Vampiric Blood
	[77606]  = { default = true, duration = 60,  class = "DEATHKNIGHT" },                                   -- Dark Simulacrum
	[91802]  = { default = true,  duration = 30,  class = "DEATHKNIGHT", specID = { 252 } },                 -- Shambling Rush
	[96268]  = { default = true, duration = 30,  class = "DEATHKNIGHT" },                                   -- Death's Advance
	
	
	--PALADIN - RE-CHECK
	[498]    = { default = true, duration = 30,  class = "PALADIN" },                                       -- Divine Protection
	[642]    = { default = true, duration = 300, class = "PALADIN" },                                       -- Divine Shield
	[853]    = { default = true, duration = 40,  class = "PALADIN" },                                       -- Hammer of Justice
	[1022]   = { default = true, duration = 300, class = "PALADIN", charges = 2 },                          -- Hand of Protection
	[1044]   = { default = true, duration = 25,  class = "PALADIN", charges = 2 },                          -- Hand of Freedom
	[6940]   = { default = true, duration = { default = 90, [65] = 110 }, class = "PALADIN", charges = 2 }, -- Hand of Sacrifice
	[20066]  = { default = true, duration = 60,  class = "PALADIN" },                                       -- Repentance
	[31821]  = { default = true, duration = 120, class = "PALADIN", specID = { 65 } },                      -- Aura Mastery
	[31884]  = { default = true, duration = 180, class = "PALADIN" },                                       -- Avenging Wrath
	[96231]  = { default = true,  duration = 10,  class = "PALADIN" },                                       -- Rebuke
	
	
	--WARRIOR - RE-CHECK
	[100]    = { default = true, duration = 12, class = "WARRIOR", specID = { 1, 3 } },                      -- Charge
	[871]    = { default = true, duration = 180, class = "WARRIOR", specID = { 3 } },                      -- Shield Wall
	[1719]   = { default = true, duration = 300, class = "WARRIOR", specID = { 1, 2 } },                  -- Recklessness
	[3411]   = { default = true, duration = 30,  class = "WARRIOR" },                                       -- Intervene
	[5246]   = { default = true, duration = 120,  class = "WARRIOR" },                                       -- Intimidating Shout
	[6544]   = { default = true, duration = 60,  class = "WARRIOR" },                                       -- Heroic Leap
	[6552]   = { default = true, duration = 10,  class = "WARRIOR" },                                       -- Pummel
	[18499]  = { default = true, duration = 24,  class = "WARRIOR" },                                       -- Berserker Rage
	[23920]  = { default = true, duration = 25,  class = "WARRIOR" },                                       -- Spell Reflection
	[46968]  = { default = true, duration = 24,  class = "WARRIOR" },                                       -- Shockwave
	
	
	--DRUID
	[99]     = { default = true, duration = 30,  class = "DRUID" },                                         -- Disorienting Roar
	[5211]   = { default = true, duration = 50,  class = "DRUID" },                                         -- Bash
	[22812]  = { default = true, duration = 60,  class = "DRUID", specID = { 28, 29, 30 } },             -- Barkskin
	[33891]  = { default = true, duration = 180, class = "DRUID", specID = { 30 } },                       -- Incarnation: Tree of Life
	[50334]  = { default = true, duration = 180, class = "DRUID", specID = { 29, 29 } },                  -- Berserk
	[61336]  = { default = true, duration = 180, class = "DRUID", specID = { 29, 29 }, charges = 2 },     -- Survival Instincts
	[78675]  = { default = true,  duration = 60,  class = "DRUID", specID = { 28 } },                       -- Solar Beam
	[80965]	 = { default = true,  duration = 10,  class = "DRUID", specID = { 29, 29 } },                  -- Skull Bash
	[29166]  = { default = true,  duration = 180,  class = "DRUID" },											--Innervate
--[[
	[102280] = { default = true, duration = 30,  class = "DRUID" },                                         -- Displacer Beast
	[102342] = { default = true, duration = 60,  class = "DRUID", specID = { 105 } },                       -- Ironbark
	[102359] = { default = true, duration = 30,  class = "DRUID" },                                         -- Mass Entanglement
	[102543] = { default = true, duration = 180, class = "DRUID", specID = { 103 } },                       -- Incarnation: King of the Jungle
	[102560] = { default = true, duration = 180, class = "DRUID", specID = { 102 } },                       -- Incarnation: Chosen of Elune
	[108291] = { default = true, duration = 360, class = "DRUID" },                                         -- Heart of the Wild (Balance)
		[108292] = { parent = 108291 },                                                                      -- Heart of the Wild (Feral)
		[108293] = { parent = 108291 },                                                                      -- Heart of the Wild (Guardian)
		[108294] = { parent = 108291 },                                                                      -- Heart of the Wild (Resto)
	[112071] = { default = true, duration = 180, class = "DRUID", specID = { 28 } },                       -- Celestial Alignment
	[124974] = { default = true, duration = 90,  class = "DRUID" },                                         -- Nature's Vigil
	[132158] = { default = true, duration = 60,  class = "DRUID", specID = { 28 } },                       -- Nature's Swiftness
	[132469] = { default = true, duration = 30,  class = "DRUID" },                                         -- Typhoon
]]--	
	
	--PRIEST - DONE
	[8122]   = { default = true, duration = 23,  class = "PRIEST" },                                        -- Psychic Scream
	[15487]  = { default = true, duration = 45, class = "PRIEST", specID = { 15 } },               		  -- Silence
	[33206]  = { default = true, duration = 180, class = "PRIEST", specID = { 13 } },                      -- Pain Suppression
	[47585]  = { default = true, duration = 75, class = "PRIEST", specID = { 15 } },                      -- Dispersion
	[47788]  = { default = true, duration = 180, class = "PRIEST", specID = { 14 } },                      -- Guardian Spirit
	[64044]  = { default = true, duration = 90,  class = "PRIEST", specID = { 15 } },                      -- Psychic Horror
	[73325]  = { default = true, duration = 90,  class = "PRIEST" },                                        -- Leap of Faith
	
	
	--WARLOCK - RE-CHECK
	[5484]   = { default = true, duration = 32,  class = "WARLOCK" },                                       -- Howl of Terror
	[6360]   = { default = true, duration = 25,  class = "WARLOCK" },                                       -- Whiplash
	[6789]   = { default = true, duration = 90,  class = "WARLOCK" },                                       -- Mortal Coil
	[19505]  = { default = true, duration = 15,  class = "WARLOCK" },                                       -- Devour Magic (Felhunter)
	[30283]  = { default = true, duration = 20,  class = "WARLOCK" },                                       -- Shadowfury
	[48020]  = { default = true, duration = 26,  class = "WARLOCK" },                                       -- Demonic Portal
	[89766]  = { default = true, duration = 30,  class = "WARLOCK" },                                       -- Axe Toss
	[19647]  = { default = true,  duration = 24,  class = "WARLOCK" },                                       -- Spell Lock
	[77801]  = { default = true, duration = 120, class = "WARLOCK", charges = 2 },                          -- Dark Soul
		[113858] = { parent = 77801 },                                                                       -- Dark Soul: Instability
		[113860] = { parent = 77801 },                                                                       -- Dark Soul: Misery
		[113861] = { parent = 77801 },                                                                       -- Dark Soul: Knowledge
	
	
	--SHAMAN - RE-CHECK
	[8143]   = { default = true, duration = 60,  class = "SHAMAN" },                                        -- Tremor Totem
	[8177]   = { default = true, duration = 22,  class = "SHAMAN" },                                        -- Grounding Totem
	[30823]  = { default = true, duration = 60,  class = "SHAMAN", specID = { 20 } },                 -- Shamanistic Rage
	[51490]  = { default = true, duration = 45,  class = "SHAMAN", specID = { 19 } },                 -- Thunderstorm
	[51514]  = { default = true, duration = 35,  class = "SHAMAN" },                                        -- Hex
	[57994]  = { default = true,  duration = 6,  class = "SHAMAN" },                                        -- Wind Shear
	[98008]  = { default = true, duration = 180, class = "SHAMAN" },                                        -- Spirit Link Totem
	
	
	--HUNTER - RE-CHECK
	[1499]   = { default = true, duration = { default = 20, [7] = 30, [8] = 30 }, class = "HUNTER" },   -- Freezing Trap
	    [60192] = { parent = 1499 },                                                                         -- Freezing Trap (Trap Launcher)
	[13813]  = { default = true, duration = { default = 20, [7] = 30, [8] = 30 }, class = "HUNTER" },   -- Explosive Trap
	    [82939] = { parent = 13813 },                                                                        -- Explosive Trap (Trap Launcher)
	[19263]  = { default = true, duration = 110, class = "HUNTER", charges = 2 },                           -- Deterrence
	[19386]  = { default = true, duration = 45,  class = "HUNTER" },                                        -- Wyvern Sting
	[19574]  = { default = true, duration = 60,  class = "HUNTER", specID = { 7 } },                      -- Bestial Wrath
	[53480]  = { default = true, duration = 60,  class = "HUNTER" },                                        -- Roar of Sacrifice
	
	
	--MAGE - RE-CHECK
	[66]     = { default = true, duration = 300, class = "MAGE" },                                          -- Invisibility
	[1953]   = { default = true, duration = 15,  class = "MAGE" },                                          -- Blink
	[2139]   = { default = true, duration = 24,  class = "MAGE" },                                          -- Counterspell
	[11129]  = { default = true, duration = 45,  class = "MAGE", specID = { 23 } },                         -- Combustion
	[11958]  = { default = true, duration = 480, class = "MAGE" },                                          -- Cold Snap
	[12043]  = { default = true, duration = 90,  class = "MAGE", specID = { 22 } },                         -- Presence of Mind
	[12472]  = { default = true, duration = 180, class = "MAGE", specID = { 24 } },                         -- Icy Veins
	[31661]  = { default = true, duration = 20,  class = "MAGE", specID = { 23 } },                         -- Dragon's Breath
	[44572]  = { default = true, duration = 30,  class = "MAGE", specID = { 24 } },                         -- Deep Freeze
	[45438]  = { default = true, duration = 300, class = "MAGE" },                                          -- Ice Block
	[84714]  = { default = true, duration = 60,  class = "MAGE", specID = { 24 } },                         -- Frozen Orb
	[82676]  = { default = true, duration = 120,  class = "MAGE" },                                          -- Ring of Frost
	
	
	--ROGUE - RE-CHECK
	[408]    = { default = true, duration = 20,  class = "ROGUE" },                                         -- Kidney Shot
	[1766]   = { default = true, duration = 10,  class = "ROGUE" },                                         -- Kick
	[1856]   = { default = true, duration = 120, class = "ROGUE" },        							       -- Vanish
	[2094]   = { default = true, duration = 120, class = "ROGUE" },                                         -- Blind
	[2983]   = { default = true, duration = 60,  class = "ROGUE" },                                         -- Sprint
	[5277]   = { default = true, duration = 180, class = "ROGUE" },                                         -- Evasion
	[13750]  = { default = true, duration = 180, class = "ROGUE", specID = { 11 } },                       -- Adrenaline Rush
	[14185]  = { default = true, duration = 300, class = "ROGUE" },                                         -- Preparation
	[31224]  = { default = true, duration = 90,  class = "ROGUE" },                                         -- Cloak of Shadows
	[36554]  = { default = true, duration = 24,  class = "ROGUE" },                                         -- Shadow Step
	[51690]  = { default = true, duration = 120, class = "ROGUE", specID = { 11} },                        -- Killing Spree
	[51713]  = { default = true, duration = 60,  class = "ROGUE", specID = { 12 } },                       -- Shadow Dance
	[74001]  = { default = true, duration = 90, class = "ROGUE" },                                         -- Combat Readiness
	[76577]  = { default = true, duration = 180, class = "ROGUE" },                                         -- Smoke Bomb
}

local order = {
	["DEATHKNIGHT"] = 1,
	["PALADIN"] = 2,
	["WARRIOR"] = 3,
	["DRUID"] = 4,
	["PRIEST"] = 5,
	["WARLOCK"] = 6,
	["SHAMAN"] = 7,
	["HUNTER"] = 8,
	["MAGE"] = 9,
	["ROGUE"] = 10,
}

local resets = {
	--[[ Summon Felhunter
	     - Spell Lock
	  ]]
	[691] = { 19647 },

	--[[ Cold Snap
	     - Ice Block
	     - Presence of Mind
	     - Dragon's Breath
	  ]]
	[11958] = { 45438, 12043, 31661 },

	--[[ Preparation
	     - Sprint
	     - Vanish
	     - Evasion
	  ]]
	[14185] = { 2983, 1856, 5277 },

}

-- Defaults
local defaults = {
	size                 = 40,
	columns              = 8,
	padding              = 2,
	locked               = false,
	center               = false,
	border               = true,
	noHighlightTarget    = false,
	noHighlightFocus     = true,
	growUpward           = true,
	showUnused           = false,
	adaptive             = false,
	unusedAlpha          = 0.45,
	swipeAlpha           = 0.65,
	noCooldownCount      = false,
	noArena              = false,
	noRatedBattleground  = false,
	noBattleground       = false,
	noWorld              = false,
	noAshran             = false,
	noMultiple           = false,
	noGlow               = false,
	noTooltips           = false,
}

local OmniBar

local Masque = LibStub and LibStub("Masque", true)

local SETTINGS_VERSION = 2

local MAX_DUPLICATE_ICONS = 5

local BASE_ICON_SIZE = 36

local ASHRAN_MAP_ID = 978

StaticPopupDialogs["OMNIBAR_CONFIRM_RESET"] = {
	text = CONFIRM_RESET_SETTINGS,
	button1 = YES,
	button2 = NO,
	OnAccept = function()
		OmniBar_Reset(OmniBar)
		if OmniBarOptions then OmniBarOptions:refresh() end

		-- Refresh the cooldowns
		i = 1
		while _G["OmniBarOptionsPanel" .. i] do
			_G["OmniBarOptionsPanel" .. i]:refresh()
			i = i + 1
		end
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	enterClicksFirstButton = true
}

for spellID,_ in pairs(cooldowns) do
	local name, _, icon = GetSpellInfo(spellID)
	cooldowns[spellID].icon = icon
	cooldowns[spellID].name = name
end

-- create a lookup table to translate spec names into IDs
local specNames = {}
for classID = 1, MAX_CLASSES do
	local _, classToken = GetClassInfoByID(classID)
	specNames[classToken] = {}
	for i = 1, GetNumSpecializationsForClassID(classID) do
		local id, name = GetSpecializationInfoForClassID(classID, i)
		specNames[classToken][name] = id
	end
end

local function IsHostilePlayer(unit)
	if not unit then return end
	local reaction = UnitReaction("player", unit)
	if not reaction then return end -- out of range
	return UnitIsPlayer(unit) and reaction < 4 and not UnitIsPossessed(unit)
end

function OmniBar_ShowAnchor(self)
	if self.disabled or self.settings.locked or #self.active > 0 then
		self.anchor:Hide()
	else
		self.anchor:Show()
	end
end

function OmniBar_CreateIcon(self)
	if InCombatLockdown() then return end
	self.numIcons = self.numIcons + 1
	local f = CreateFrame("Button", self:GetName().."Icon"..self.numIcons, self.anchor, "OmniBarButtonTemplate")
	table.insert(self.icons, f)
end

local function SpellBelongsToSpec(spellID, specID)
	if not specID then return true end
	if not cooldowns[spellID].specID then return true end
	for i = 1, #cooldowns[spellID].specID do
		if cooldowns[spellID].specID[i] == specID then return true end
	end
	return false
end

function OmniBar_AddIconsByClass(self, class, sourceGUID, specID)
	for spellID, spell in pairs(cooldowns) do
		if OmniBar_IsSpellEnabled(self, spellID) and spell.class == class and SpellBelongsToSpec(spellID, specID) then
			OmniBar_AddIcon(self, spellID, sourceGUID, nil, true, specID)
		end
	end
end

local function IconIsSource(iconGUID, guid)
	if not guid then return end
	if string.len(iconGUID) == 1 then
		-- arena target
		return UnitGUID("arena"..iconGUID) == guid
	end
	return iconGUID == guid
end

function OmniBar_UpdateBorders(self)
	for i = 1, #self.active do
		local border
		local guid = self.active[i].sourceGUID
		if guid then
			if not self.settings.noHighlightFocus and IconIsSource(guid, UnitGUID("focus")) then
				self.active[i].FocusTexture:SetAlpha(1)
				border = true
			else
				self.active[i].FocusTexture:SetAlpha(0)
			end
			if not self.settings.noHighlightTarget and IconIsSource(guid, UnitGUID("target")) then
				self.active[i].FocusTexture:SetAlpha(0)
				self.active[i].TargetTexture:SetAlpha(1)
				border = true
			else
				self.active[i].TargetTexture:SetAlpha(0)
			end
		else
			local class = select(2, UnitClass("focus"))
			if not self.settings.noHighlightFocus and class and IsHostilePlayer("focus") and class == self.active[i].class then
				self.active[i].FocusTexture:SetAlpha(1)
				border = true
			else
				self.active[i].FocusTexture:SetAlpha(0)
			end
			class = select(2, UnitClass("target"))
			if not self.settings.noHighlightTarget and class and IsHostilePlayer("target") and class == self.active[i].class then
				self.active[i].FocusTexture:SetAlpha(0)
				self.active[i].TargetTexture:SetAlpha(1)
				border = true
			else
				self.active[i].TargetTexture:SetAlpha(0)
			end
		end

		-- Set dim
		--self.active[i]:SetAlpha(self.settings.unusedAlpha and self.active[i].cooldown:GetCooldownTimes() == 0 and not border and
		--	self.settings.unusedAlpha or 1)
	end
end

function OmniBar_UpdateArenaSpecs(self)
	if self.zone ~= "arena" then return end
	for i = 1, 5 do
		local specID = GetArenaOpponentSpec(i)
		if specID and specID > 0 then
			local name = GetUnitName("arena"..i, true)
			if name then self.specs[name] = specID end
		end
	end
end

function OmniBar_OnEvent(self, event, ...)
	if event == "ADDON_LOADED" then
		local name = ...
		if name ~= addonName then return end
		self:UnregisterEvent("ADDON_LOADED")
		OmniBar = self
		self.icons = {}
		self.active = {}
		self.cooldowns = cooldowns
		self.detected = {}
		self.specs = {}
		self.BASE_ICON_SIZE = BASE_ICON_SIZE
		self.numIcons = 0
		self:RegisterForDrag("LeftButton")

		-- Load the settings
		OmniBar_LoadSettings(self)

		-- Create the icons
		for spellID,_ in pairs(cooldowns) do
			if OmniBar_IsSpellEnabled(self, spellID) then
				OmniBar_CreateIcon(self)
			end
		end

		-- Create the duplicate icons
		for i = 1, MAX_DUPLICATE_ICONS do
			OmniBar_CreateIcon(self)
		end

		OmniBar_ShowAnchor(self)
		OmniBar_RefreshIcons(self)
		OmniBar_UpdateIcons(self)
		OmniBar_Center(self)

		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		self:RegisterEvent("PLAYER_ENTERING_WORLD")
		self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
		self:RegisterEvent("PLAYER_TARGET_CHANGED")
		self:RegisterEvent("PLAYER_FOCUS_CHANGED")
		self:RegisterEvent("PLAYER_REGEN_DISABLED")
		self:RegisterEvent("ARENA_OPPONENT_UPDATE")
		self:RegisterEvent("UPDATE_BATTLEFIELD_SCORE")

		-- Add Options Panel category
		local frame = CreateFrame("Frame", "OmniBarOptions")
		frame:SetScript("OnShow", function(self)
			if not self.init then
				LoadAddOn("OmniBar_Options")
				self:refresh()
				-- Refresh the cooldowns
				i = 1
				while _G["OmniBarOptionsPanel" .. i] do
					_G["OmniBarOptionsPanel" .. i]:refresh()
					i = i + 1
				end
				self.init = true
			end
		end)
		frame.name = addonName
		InterfaceOptions_AddCategory(frame)

	elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local _, event, _, sourceGUID, sourceName, sourceFlags, _,_,_,_,_, spellID = ...
		if self.disabled then return end
		if event == "SPELL_CAST_SUCCESS" and bit.band(sourceFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) ~= 0 then
			if cooldowns[spellID] then
				OmniBar_UpdateArenaSpecs(self)
				OmniBar_AddIcon(self, spellID, sourceGUID, sourceName)
			end

			-- Check if we need to reset any cooldowns
			if resets[spellID] then
				for i = 1, #self.active do
					if self.active[i] and self.active[i].spellID and self.active[i].sourceGUID and self.active[i].sourceGUID == sourceGUID and self.active[i].cooldown:IsVisible() then
						-- cooldown belongs to this source
						for j = 1, #resets[spellID] do
							if resets[spellID][j] == self.active[i].spellID then
								self.active[i].cooldown:Hide()
								OmniBar_CooldownFinish(self.active[i].cooldown, true)
								return
							end
						end
					end
				end
			end
		end

	elseif event == "PLAYER_ENTERING_WORLD" then
		OmniBar_OnEvent(self, "ZONE_CHANGED_NEW_AREA")
		wipe(self.detected)
		wipe(self.specs)
		if self.zone == "arena" then OmniBar_OnEvent(self, "ARENA_OPPONENT_UPDATE") end

	elseif event == "ZONE_CHANGED_NEW_AREA" then
		local _, zone = IsInInstance()
		if zone == "none" then
			SetMapToCurrentZone()
			zone = GetCurrentMapAreaID()
		end
		local rated = IsRatedBattleground()
		self.disabled = (zone == "arena" and self.settings.noArena) or
			(rated and self.settings.noRatedBattleground) or
			(zone == "pvp" and self.settings.noBattleground and not rated) or
			(zone == ASHRAN_MAP_ID and self.settings.noAshran) or 
			(zone ~= "arena" and zone ~= "pvp" and zone ~= ASHRAN_MAP_ID and self.settings.noWorld)
		self.zone = zone
		OmniBar_LoadPosition(self)
		OmniBar_RefreshIcons(self)
		OmniBar_UpdateIcons(self)
		OmniBar_ShowAnchor(self)

	elseif event == "UPDATE_BATTLEFIELD_SCORE" then
		for i = 1, GetNumBattlefieldScores() do
			local name, _,_,_,_,_,_,_, classToken, _,_,_,_,_,_, talentSpec = GetBattlefieldScore(i)
			if name and specNames[classToken] and specNames[classToken][talentSpec] then
				self.specs[name] = specNames[classToken][talentSpec]
			end
		end

	--CHANGES:Lanrutcon: MoP functions that can't be implemented (e.g. "GetArenaOpponentSpec") commented
	--elseif event == "ARENA_PREP_OPPONENT_SPECIALIZATIONS" or event == "ARENA_OPPONENT_UPDATE" then
	--	for i = 1, 5 do
	--		local specID = GetArenaOpponentSpec(i)
	--		if specID and specID > 0 then
	--			-- only add icons if show unused is checked
	--			if not self.settings.showUnused then return end
	--			if not self.detected[i] then
	--				local class = select(7, GetSpecializationInfoByID(specID))
	--				OmniBar_AddIconsByClass(self, class, i, specID)
	--				self.detected[i] = class
	--			end
	--		end
	--	end

	elseif event == "PLAYER_TARGET_CHANGED" or event == "PLAYER_FOCUS_CHANGED" or event == "PLAYER_REGEN_DISABLED" then
		-- update icon borders
		OmniBar_UpdateBorders(self)

		-- we don't need to add in arena
		if self.zone == "arena" then return end

		-- only add icons if show adaptive is checked
		if not self.settings.showUnused or not self.settings.adaptive then return end

		-- only add icons when we're in combat
		if event == "PLAYER_TARGET_CHANGED" and not InCombatLockdown() then return end

		local unit = "playertarget"
		if IsHostilePlayer(unit) then
			local guid = UnitGUID(unit)
			local _, class = UnitClass(unit)
			if class then
				if self.detected[guid] then return end
				self.detected[guid] = class
				OmniBar_AddIconsByClass(self, class)
			end
		end
	end
end

function OmniBar_LoadSettings(self, specific)
	if (not OmniBarDB) or (not OmniBarDB.version) or OmniBarDB.version ~= SETTINGS_VERSION then
		OmniBarDB = { version = SETTINGS_VERSION, Default = {} }
		for k,v in pairs(defaults) do
			OmniBarDB.Default[k] = v
		end
	end
	local profile = UnitName("player").." - "..GetRealmName()
	if specific then
		OmniBarDB[profile] = nil
		if specific ~= 0 then
			-- Copy the current settings
			OmniBarDB[profile] = {}
			for a,b in pairs(OmniBarDB.Default) do
				if type(b) == "table" then
					OmniBarDB[profile][a] = {}
					for c,d in pairs(b) do
						if type(d) == "table" then
							OmniBarDB[profile][a][c] = {}
							for e,f in pairs(d) do
								OmniBarDB[profile][a][c][e] = f
							end
						else
							OmniBarDB[profile][a][c] = d
						end
					end
				else
					OmniBarDB[profile][a] = b
				end
			end
		end
	end
	self.profile = OmniBarDB[profile] and profile or "Default"
	self.settings = OmniBarDB[self.profile]

	self.settings.cooldowns = self.settings.cooldowns or {}

	-- Set the scale
	self.container:SetScale(self.settings.size/BASE_ICON_SIZE)

	-- Refresh if we toggled specific
	if specific then
		OmniBar_LoadPosition(self)
		OmniBar_RefreshIcons(self)
		OmniBar_UpdateIcons(self)
		OmniBar_Center(self)
	end	
end

function OmniBar_Reset(self)
	local profile = UnitName("player").." - "..GetRealmName()
	OmniBarDB.Default = {}
	for k,v in pairs(defaults) do
		OmniBarDB.Default[k] = v
	end
	OmniBarDB[profile] = nil
	OmniBar_LoadSettings(self, 0)
end

function OmniBar_SavePosition(self)
	local point, _, relativePoint, xOfs, yOfs = self:GetPoint()
	if not self.settings.position then 
		self.settings.position = {}
	end
	self.settings.position.point = point
	self.settings.position.relativePoint = relativePoint
	self.settings.position.xOfs = xOfs
	self.settings.position.yOfs = yOfs
end

function OmniBar_LoadPosition(self)
	self:ClearAllPoints()
	if self.settings.position then
		self:SetPoint(self.settings.position.point, UIParent, self.settings.position.relativePoint,
			self.settings.position.xOfs, self.settings.position.yOfs)
	else
		self:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	end
end

function OmniBar_IsSpellEnabled(self, spellID)
	if not spellID then return end
	-- Check for an explicit rule
	if self.settings.cooldowns and self.settings.cooldowns[spellID] then
		if self.settings.cooldowns[spellID].enabled then
			return true
		end
	elseif cooldowns[spellID].default then
		-- Not user-set, but a default cooldown
		return true
	end
end

function OmniBar_Center(self)
	local parentWidth = UIParent:GetWidth()
	local clamp = self.settings.center and (1 - parentWidth)/2 or 0
	self:SetClampRectInsets(clamp, -clamp, 0, 0)
	clamp = self.settings.center and (self.anchor:GetWidth() - parentWidth)/2 or 0
	self.anchor:SetClampRectInsets(clamp, -clamp, 0, 0)
end

function OmniBar_CooldownFinish(self, force)
	local icon = self:GetParent()
	if icon.cooldown and GetCooldownTimes(icon.cooldown) and GetCooldownTimes(icon.cooldown) > 0 and not force then return end -- not complete
	local charges = icon.charges
	if charges then
		charges = charges - 1
		if charges > 0 then
			-- remove a charge
			icon.charges = charges
			icon.Count:SetText(charges)
			OmniBar_StartCooldown(icon:GetParent():GetParent(), icon, GetTime())
			return
		end
	end

	local bar = icon:GetParent():GetParent()

	local flash = icon.flashAnim
	local newItemGlowAnim = icon.newitemglowAnim

	--if flash:IsPlaying() or newItemGlowAnim:IsPlaying() then
	--	flash:Stop()
	--	newItemGlowAnim:Stop()
	--end

	if not bar.settings.showUnused then
		icon:Hide()
	else
		if icon.TargetTexture:GetAlpha() == 0 and
			icon.FocusTexture:GetAlpha() == 0 and
			bar.settings.unusedAlpha then
				icon:SetAlpha(bar.settings.unusedAlpha)
		end
	end
	bar:StopMovingOrSizing()
	OmniBar_Position(bar)
end

function OmniBar_RefreshIcons(self)
	-- Hide all the icons
	for i = 1, self.numIcons do
		if self.icons[i].MasqueGroup then
			--self.icons[i].MasqueGroup:Delete()
			self.icons[i].MasqueGroup = nil
		end
		self.icons[i].TargetTexture:SetAlpha(0)
		self.icons[i].FocusTexture:SetAlpha(0)
		self.icons[i].flash:SetAlpha(0)
		self.icons[i].NewItemTexture:SetAlpha(0)
		self.icons[i].cooldown:SetCooldown(0, 0)
		self.icons[i].cooldown:Hide()
		self.icons[i]:Hide()
	end
	wipe(self.active)

	if self.disabled then return end

	if self.settings.showUnused and not self.settings.adaptive then
		for spellID,_ in pairs(cooldowns) do
			if OmniBar_IsSpellEnabled(self, spellID) then
				OmniBar_AddIcon(self, spellID, nil, nil, true)
			end
		end
	end
	OmniBar_Position(self)
end

function OmniBar_StartCooldown(self, icon, start)
	icon.cooldown:SetCooldown(start, icon.duration)
	icon.cooldown.startTime = start;
	icon.cooldown.duration = icon.duration;
	icon.cooldown.finish = start + icon.duration
	--icon.cooldown:SetSwipeColor(0, 0, 0, self.settings.swipeAlpha or 0.65)
	icon:SetAlpha(1)
	
	--CHANGES:Lanrutcon:Setting a timer for each cooldown
	icon.totalElapsed = 0;
	icon:SetScript("OnUpdate", function(self, elapsed)
		self.totalElapsed = self.totalElapsed + elapsed;
		if(self.totalElapsed > self.cooldown.duration) then
			self.totalElapsed = 0;
			self:Hide();
			self:SetScript("OnUpdate", nil);
		end
	end);
	
	orderByTimeLeft();
	OmniBar_Position(self);
end


function OmniBar_AddIcon(self, spellID, sourceGUID, sourceName, init, test, specID)
	-- Check for parent spellID
	local originalSpellID = spellID
	if cooldowns[spellID].parent then spellID = cooldowns[spellID].parent end

	if not OmniBar_IsSpellEnabled(self, spellID) then return end

	local icon, duplicate

	-- Try to reuse a visible frame
	for i = 1, #self.active do
		if self.active[i].spellID == spellID then
			duplicate = true
			-- check if we can use this icon, but not when initializing arena opponents
			if not init or self.zone ~= "arena" then
				-- use icon if not bound to a sourceGUID
				if not self.active[i].sourceGUID then
					duplicate = nil
					icon = self.active[i]
					break
				end

				-- if it's the same source, reuse the icon
				if sourceGUID and IconIsSource(self.active[i].sourceGUID, sourceGUID) then
					duplicate = nil
					icon = self.active[i]
					break
				end

			end
		end
	end

	-- We couldn't find a visible frame to reuse, try to find an unused
	if not icon then
		if self.settings.noMultiple and duplicate then return end
		for i = 1, #self.icons do
			if not self.icons[i]:IsVisible() then
				icon = self.icons[i]
				icon.specID = nil
				break
			end
		end
	end

	-- We couldn't find a frame to use
	if not icon then return end

	local now = GetTime()

	if specID then
		icon.specID = specID
	else
		if sourceName and sourceName ~= COMBATLOG_FILTER_STRING_UNKNOWN_UNITS and self.specs[sourceName] then
			icon.specID = self.specs[sourceName]
		end
	end

	icon.class = cooldowns[spellID].class
	icon.sourceGUID = sourceGUID
	icon.icon:SetTexture(cooldowns[spellID].icon)
	icon.spellID = spellID
	icon.added = now

	if icon.charges and cooldowns[originalSpellID].charges and icon:IsVisible() then
		local start, duration = GetCooldownTimes(icon.cooldown)
		if icon.cooldown.finish and icon.cooldown.finish - GetTime() > 1 then
			-- add a charge
			local charges = icon.charges + 1
			icon.charges = charges
			icon.Count:SetText(charges)
			if not self.settings.noGlow then
				icon.flashAnim:Play()
				icon.newitemglowAnim:Play()
			end
			return icon
		end
	elseif cooldowns[originalSpellID].charges then
		icon.charges = 1
		icon.Count:SetText("1")
	else
		icon.charges = nil
		--icon.Count:SetText(nil)
	end
	
	if cooldowns[originalSpellID].duration then
		if type(cooldowns[originalSpellID].duration) == "table" then
			if icon.specID and cooldowns[originalSpellID].duration[icon.specID] then
				icon.duration = cooldowns[originalSpellID].duration[icon.specID]
			else
				icon.duration = cooldowns[originalSpellID].duration.default
			end
		else
			icon.duration = cooldowns[originalSpellID].duration
		end
	else -- child doesn't have a custom duration, use parent
		if type(cooldowns[spellID].duration) == "table" then
			if icon.specID and cooldowns[spellID].duration[icon.specID] then
				icon.duration = cooldowns[spellID].duration[icon.specID]
			else
				icon.duration = cooldowns[spellID].duration.default
			end
		else
			icon.duration = cooldowns[spellID].duration
		end
	end

	-- We don't want duration to be too long if we're just testing
	if test then icon.duration = math.random(5,30) end

	-- Masque
	if Masque then
		icon.MasqueGroup = Masque:Group("OmniBar", cooldowns[spellID].name)
		icon.MasqueGroup:AddButton(icon, {
			FloatingBG = false,
			Icon = icon.icon,
			Cooldown = icon.cooldown,
			Flash = false,
			Pushed = false,
			Normal = icon:GetNormalTexture(),
			Disabled = false,
			Checked = false,
			Border = _G[icon:GetName().."Border"],
			AutoCastable = false,
			Highlight = false,
			Hotkey = false,
			Count = false,
			Name = false,
			Duration = false,
			AutoCast = false,
		})
	end

	icon:Show()

	if not init then
		OmniBar_StartCooldown(self, icon, now)
		if not self.settings.noGlow then
			icon.flashAnim:Play()
			icon.newitemglowAnim:Play()
		end
	end

	return icon
end

function OmniBar_UpdateIcons(self)
	for i = 1, self.numIcons do
		-- Set show text
		--self.icons[i].cooldown:SetHideCountdownNumbers(self.settings.noCooldownCount and true or false)
		self.icons[i].cooldown.noCooldownCount = self.settings.noCooldownCount and true

		-- Set swipe alpha
		--self.icons[i].cooldown:SetSwipeColor(0, 0, 0, self.settings.swipeAlpha or 0.65)

		-- Set border
		if self.settings.border then
			self.icons[i].icon:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
		else
			self.icons[i].icon:SetTexCoord(0.07, 0.9, 0.07, 0.9)
		end

		-- Set dim
		self.icons[i]:SetAlpha(self.settings.unusedAlpha and GetCooldownTimes(self.icons[i].cooldown) == 0 and
			self.settings.unusedAlpha or 1)

		-- Masque
		if self.icons[i].MasqueGroup then self.icons[i].MasqueGroup:ReSkin() end

	end
end

function OmniBar_Test(self)
	self.disabled = nil
	OmniBar_RefreshIcons(self)
	for k,v in pairs(cooldowns) do
		OmniBar_AddIcon(self, k, nil, nil, nil, true)
	end
end

local function ExtractDigits(str)
	if not str then return 0 end
	if type(str) == "number" then return str end
	local num = str:gsub("%D", "")
	return tonumber(num) or 0
end

function OmniBar_Position(self)
	local numActive = #self.active
	if numActive == 0 then
		-- Show the anchor if needed
		OmniBar_ShowAnchor(self)
		return
	end

	-- Keep cooldowns together by class
	if self.settings.showUnused then
		table.sort(self.active, function(a, b)
			local x, y = ExtractDigits(a.sourceGUID), ExtractDigits(b.sourceGUID)
			if a.class == b.class then
				if x < y then return true end
				if x == y then return a.spellID < b.spellID end
			end
			return order[a.class] < order[b.class]
		end)
	else
		-- if we aren't showing unused, just sort by added time
		--table.sort(self.active, function(a, b) return a.added == b.added and a.spellID < b.spellID or a.added < b.added end)
	end

	local count, rows = 0, 1
	local grow = self.settings.growUpward and 1 or -1
	local padding = self.settings.padding and self.settings.padding or 0
	for i = 1, numActive do
		if self.settings.locked then
			self.active[i]:EnableMouse(false)
		else
			self.active[i]:EnableMouse(true)
		end
		self.active[i]:ClearAllPoints()
		local columns = self.settings.columns and self.settings.columns > 0 and self.settings.columns < numActive and
			self.settings.columns or numActive
		if i > 1 then
			count = count + 1
			if count >= columns then
				self.active[i]:SetPoint("CENTER", OmniBarIcons, "CENTER", (-BASE_ICON_SIZE-padding)*(columns-1)/2, (BASE_ICON_SIZE+padding)*rows*grow)
				count = 0
				rows = rows + 1
			else
				self.active[i]:SetPoint("TOPLEFT", self.active[i-1], "TOPRIGHT", padding, 0)
			end
			
		else
			self.active[i]:SetPoint("CENTER", OmniBarIcons, "CENTER", (-BASE_ICON_SIZE-padding)*(columns-1)/2, 0)
		end
	end
	OmniBar_ShowAnchor(self)
end

SLASH_OmniBar1 = "/ob"
SLASH_OmniBar2 = "/omnibar"
SlashCmdList.OmniBar = function(msg)
	local cmd, arg1 = string.split(" ", string.lower(msg))

	if cmd == "lock" or cmd == "unlock" then
		OmniBar.settings.locked = cmd == "lock" and true or false
		OmniBar_Position(OmniBar)
		if OmniBarOptionsPanelLock then OmniBarOptionsPanelLock:SetChecked(OmniBar.settings.locked) end

	elseif cmd == "reset" then
		StaticPopup_Show("OMNIBAR_CONFIRM_RESET")

	elseif cmd == "test" then
		OmniBar_Test(OmniBar)

	else
		if LoadAddOn("OmniBar_Options") then
			InterfaceOptionsFrame_OpenToCategory(addonName)
			InterfaceOptionsFrame_OpenToCategory(addonName)
		end

	end

end