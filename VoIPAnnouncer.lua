-- VoIP Announcer v 1.0.13

VoIPsave = VoIPsave or "Test VoIP Info"
local CF = CreateFrame
local addonName, addon = ...
_G[addonName] = addon

addon.L = addon.L or setmetatable({}, {
    __index = function(t, k)
        rawset(t, k, k)
        return k
    end,
    __newindex = function(t, k, v)
        if v == true then
            rawset(t, k, k)
        else
            rawset(t, k, v)
        end
    end,
})

function addon:RegisterLocale(locale, tbl)
    if locale == "enUS" or locale == GetLocale() then
        for k,v in pairs(tbl) do
            if v == true then
                self.L[k] = k
            elseif type(v) == "string" then
                self.L[k] = v
            else
                self.L[k] = k
            end
        end
	end
end

local L = addon.L

local voipFrame = CF("Frame", "voipFrame")

SLASH_VOIPA1 = L["/VoIPA"] or L["/voipa"] or L["/VOIPA"] or L["/Voipa"]
SLASH_VOIPA_VA1 = L["/va"]
SLASH_VOIPA_VAG1 = L["/vag"]
SLASH_VOIPA_VAR1 = L["/var"]
SLASH_VOIPA_VARW1 = L["/varw"]

local addon_name = "voipannouncer"
local vaEvents_table = {}

vaEvents_table.eventFrame = CF("Frame")
vaEvents_table.eventFrame:RegisterEvent("ADDON_LOADED")

vaEvents_table.eventFrame:SetScript("OnEvent", function(self, event, ...)
	vaEvents_table.eventFrame[event](self, ...)
end)

function vaEvents_table.eventFrame:ADDON_LOADED(AddOn)
--	print(AddOn)
	if AddOn ~= addon_name then
		return
	end


	vaEvents_table.eventFrame:UnregisterEvent("ADDON_LOADED")

	ChatFrame1:AddMessage(GetAddOnMetadata(addon_name, "Title") .. " " .. GetAddOnMetadata(addon_name, "Version") .. L[" loaded."])
	ChatFrame1:AddMessage(L["|cff71C671For list of commands type /VoIPA|r"])

	vaInitialize()
end

function vaInitialize()
	vaOptionsInit()
end

function vaOptionsInit()
	local vaOptions = CF("Frame", nil, InterfaceOptionsFramePanelContainer)
	local panelWidth = InterfaceOptionsFramePanelContainer:GetWidth()
	local wideWidth = panelWidth - 40
	vaOptions:SetWidth(wideWidth)
	vaOptions:Hide()
	vaOptions.name = "|cff00ff00VoIP Announcer|r"
	vaOptionsBG= { edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = true, edgeSize = 16 }

	-- Special thanks to Ro for inspiration for the overall structure of this options panel (and the title/version/description code)
	local function createfont(fontName, r, g, b, anchorPoint, relativeto, relativePoint, cx, cy, xoff, yoff, text)
		local font = vaOptions:CreateFontString(nil, "BACKGROUND", fontName)
			font:SetJustifyH("LEFT")
			font:SetJustifyV("TOP")
			if type(r) == "string" then -- r is text, not position
				text = r
			else
				if r then
					font:SetTextColor(r, g, b, 1)
				end
				font:SetSize(cx, cy)
				font:SetPoint(anchorPoint, relativeto, relativePoint, xoff, yoff)
		end
		font:SetText(text)
		return font
	end

	local title = createfont("SystemFont_OutlineThick_WTF", GetAddOnMetadata(addon_name, "Title"))
	title:SetPoint("TOPLEFT", 16, -16)
	local ver = createfont("SystemFont_Huge1", GetAddOnMetadata(addon_name, "Version"))
	ver:SetPoint("BOTTOMLEFT", title, "BOTTOMRIGHT", 4, 0)
	local date = createfont("GameFontNormalLarge", L["Version Date: "] .. GetAddOnMetadata(addon_name, "X-Date"))
	date:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -6)
	local author = createfont("GameFontNormal", L["Author: "] .. GetAddOnMetadata(addon_name, "Author"))
	author:SetPoint("TOPLEFT", date, "BOTTOMLEFT", 0, -6)
	local desc = createfont("GameFontHighlight", GetAddOnMetadata(addon_name, "Notes"))
	desc:SetPoint("TOPLEFT", author, "BOTTOMLEFT", 0, -6)

	-- Personal VoIP Set Frame
	local vaPerVoipFrame = CF("Frame", "perVoipFrame", vaOptions, "BackdropTemplate")
	vaPerVoipFrame:SetPoint("TOPLEFT", desc, "BOTTOMLEFT", 0, -8)
	vaPerVoipFrame:SetBackdrop(vaOptionsBG)
	vaPerVoipFrame:SetSize(450, 250)

	local perVoipTitle = createfont("GameFontNormalLarge", L["Set you personal VoIP Info"])
	perVoipTitle:SetPoint("TOP", vaPerVoipFrame, "TOP", 0, -8)
	local perVoipDesc = createfont("GameFontNormal", L["Put info here, and in guild info (after a [VoIP] line) in this form:"])
	perVoipDesc:SetPoint("TOP", perVoipTitle, "BOTTOM", 0, -14)
	local perVoipDesc2 = createfont("GameFontNormal", L["<VoIP Type>"])
	perVoipDesc2:SetPoint("TOP", perVoipDesc, "BOTTOM", 0, -12)
	local perVoipDesc3 = createfont("GameFontNormal", L["IP: <Ip address>"])
	perVoipDesc3:SetPoint("TOPLEFT", perVoipDesc2, "BOTTOMLEFT", 0, -2)
	local perVoipDesc4 = createfont("GameFontNormal", L["Password: <Password>"])
	perVoipDesc4:SetPoint("TOPLEFT", perVoipDesc3, "BOTTOMLEFT", 0, -2)

	-- EditBox
	local perVoipTextFrame = CF("Frame", "perVoipTextFrame", vaPerVoipFrame, "BackdropTemplate")
	perVoipTextFrame:SetSize(300, 70)
	perVoipTextFrame:SetPoint("TOP", perVoipDesc4, "BOTTOM", -30, -20)
	perVoipTextFrame:SetBackdrop(vaOptionsBG)

	local vaScroll = CF("ScrollFrame", "vaScroll", perVoipTextFrame, "UIPanelScrollFrameTemplate")
	vaScroll:SetPoint("TOPLEFT", perVoipTextFrame, "TOPLEFT", 10, -10)
	vaScroll:SetPoint("BOTTOMRIGHT", perVoipTextFrame, "BOTTOMRIGHT", -30, 10)
	vaScroll:SetWidth(perVoipTextFrame:GetWidth())
	
	local vaTextBox = CF("EditBox", "vaTextBox", vaScroll)
	vaTextBox:SetWidth(vaScroll:GetWidth() - 20)
	vaTextBox:SetFontObject("GameFontNormal")
	vaTextBox:SetAutoFocus(false)
	vaTextBox:SetMultiLine(true)
	vaTextBox:EnableMouse(true)
	vaTextBox:SetMaxLetters(999)

	vaScroll:SetScrollChild(vaTextBox)

	local vaSetBtn = CF("Button", "SetVoIPInfo", vaPerVoipFrame, "OptionsButtonTemplate")
	vaSetBtn:SetSize(95, 30)
	vaSetBtn:SetPoint("TOP", perVoipTextFrame, "BOTTOM", 0, -8)

	vaSetBtn:SetScript("OnClick", function(self) VoIPsave = vaTextBox:GetText() end)

	local vaSetText = vaSetBtn:CreateFontString(nil, "ARTWORK")
	isValid = vaSetText:SetFontObject("GameFontNormal")
	vaSetText:SetPoint("CENTER", vaSetBtn, "CENTER", 0, 0)
	vaSetBtn.text = vaSetText
	vaSetBtn.text:SetText(L["Set VoIP Info"])

	function vaOptions.okay()
--		print(vaTextBox:GetText())
		VoIPsave = vaTextBox:GetText()
		vaOptions:Hide()
	end

	function vaOptions.cancel()
		vaTextBox:SetText(VoIPsave)
		vaOptions:Hide()
	end

	function vaOptions.refresh()
		vaTextBox:SetText(VoIPsave)
	end
	
	InterfaceOptions_AddCategory(vaOptions)
end

function vaError(msg)
	ChatFrame1:AddMessage(L["name"] .. " " .. msg)
end

function vaInstanceMessage(channel)
	voipInfo, voipIP, voipPass = vaGuildInfo()

	local partyGroup = IsInGroup("LE_PARTY_CATEGORY_HOME")
	local instanceGroup = IsInGroup("LE_PARTY_CATEGORY_INSTANCE")
	local raidGroup = UnitInRaid("player")

	if partyGroup == false then
		vaError(L["NOT_GROUP"])
		return nil
	elseif instanceGroup == false then
		vaError(L["NOT_INSTANCE_GROUP"])
		return nil
	end

	if voipInfo and raidGroup ~= nil then
		SendChatMessage(L["VOIP_INFO"], channel)
		SendChatMessage(voipInfo, channel)
		SendChatMessage(voipIP, channel)
		SendChatMessage(voipPass, channel)
	elseif voipInfo and partyGroup == true then
		SendChatMessage(L["VOIP_INFO"], "PARTY")
		SendChatMessage(voipInfo, "PARTY")
		SendChatMessage(voipIP, "PARTY")
		SendChatMessage(voipPass, "PARTY")
	end
end

function vaGuildMessage(channel)
	voipInfo, voipIP, voipPass = vaGuildInfo()

	if IsInGuild() and voipInfo then
		SendChatMessage(L["VOIP_INFO"], channel)
		SendChatMessage(voipInfo, channel)
		SendChatMessage(voipIP, channel)
		SendChatMessage(voipPass, channel)
	end
end

function vaMessage(channel)
	local voip = VoIPsave
	local ip = L["IP:"]
	local pass = L["Password:"]
	local members = GetNumGroupMembers()	
	local instanceGroup = IsInGroup("LE_PARTY_CATEGORY_INSTANCE")

	if partyGroup == false then
		vaError(L["NOT_GROUP"])
		return nil
	end

	local ipStart, ipEnd = strfind(voip, ip, 1, true)
	
	if members < 6 and instanceGroup ~= true then
		if VoIPsave then
			if ipStart == nil then
				SendChatMessage(L["VOIP_INFO"], "PARTY")
				SendChatMessage(voip, "PARTY")
			else
				local passStart, passEnd = strfind(voip, pass, 1, true)

				local voipIP
				local voipPass

				voipIP = strsub(voip, ipStart)
				voipPass = strsub(voip, passStart)

				SendChatMessage(L["VOIP_INFO"], "PARTY")
				SendChatMessage(voip, "PARTY")
				SendChatMessage(voipIP, "PARTY")
				SendChatMessage(voipPass, "PARTY")
			end
		end
	elseif members < 6 then
		if VoIPsave then
			if ipStart == nil then
				SendChatMessage(L["VOIP_INFO"], "PARTY")
				SendChatMessage(voip, "PARTY")
			else
				local passStart, passEnd = strfind(voip, pass, 1, true)

				local voipIP
				local voipPass

				voipIP = strsub(voip, ipStart)
				voipPass = strsub(voip, passStart)

				SendChatMessage(L["VOIP_INFO"], "PARTY")
				SendChatMessage(voip, "PARTY")
				SendChatMessage(voipIP, "PARTY")
				SendChatMessage(voipPass, "PARTY")
			end
		end
	elseif members > 5 then
		if VoIPsave then
			if ipStart == nil then
				SendChatMessage(L["VOIP_INFO"], channel)
				SendChatMessage(voip, channel)
			else
				local passStart, passEnd = strfind(voip, pass, 1, true)

				local voipIP
				local voipPass

				voipIP = strsub(voip, ipStart)
				voipPass = strsub(voip, passStart)

				SendChatMessage(L["VOIP_INFO"], channel)
				SendChatMessage(voip, channel)
				SendChatMessage(voipIP, channel)
				SendChatMessage(voipPass, channel)
			end
		end
	end
end

function vaGuildInfo()
	local voip = L["VoIP"]
	local ip = L["IP:"]
	local pass = L["Password:"]

	if IsInGuild() == nil then
		vaError(L["NO_GUILD"])
		return nil
	end

	local guildInfo = GetGuildInfoText()
	if guildInfo == nil or guildInfo == "" then
		vaError(L["CANNOT_READ_GINFO"])
		return nil
	end

	local voipStart, voipEnd = strfind(guildInfo, voip, 1, true)
--	print(voipStart .. ", " .. voipEnd)
	if not voipStart then
		vaError(L["CANNOT_FIND_VOIP"])
		return nil
	end

	local ipStart, ipEnd = strfind(guildInfo, ip, 1, true)
	local passStart, passEnd = strfind(guildInfo, pass, 1, true)

	local voipInfo
	local voipIP
	local voipPass

	voipInfo = strsub(guildInfo, voipEnd + 2)
	voipIP = strsub(guildInfo, ipStart)
	voipPass = strsub(guildInfo, passStart)

--	print(voipInfo .. ", " .. voipIP .. ", " .. voipPass)
	return voipInfo, voipIP, voipPass
end

function SlashCmdList.VOIPA(msg) -- info and other slash commands list
	if msg == "options" then
		InterfaceOptionsFrame_OpenToCategory("|cff00ff00VoIP Announcer|r");
	elseif msg == "info" then
		vaInfo()
	else
		ChatFrame1:AddMessage(L["|cff71C671VoIP Announcer Slash Commands|r"])
		ChatFrame1:AddMessage(L["|cff71C671/VoIP options for addon options|r"])
		ChatFrame1:AddMessage(L["|cff71C671/VoIP info for addon info|r"])
		ChatFrame1:AddMessage(L["|cff71C671/va to /say custom VoIP info|r"])
		ChatFrame1:AddMessage(L["|cff71C671/vag to print guild VoIP info to guild chat|r"])
		ChatFrame1:AddMessage(L["|cff71C671/var to print guild VoIP info to raid chat|r"])
		ChatFrame1:AddMessage(L["|cff71C671/varw to print guild VoIP info to raid warning|r"])
	end
end

function SlashCmdList.VOIPA_VA(msg, editbox) -- custom voip
	vaMessage("INSTANCE_CHAT")
end

function SlashCmdList.VOIPA_VAG(msg, editbox) -- guild voip
	vaGuildMessage("GUILD")
end

function SlashCmdList.VOIPA_VAR(msg, editbox) -- instance voip
	vaInstanceMessage("RAID")
end

function SlashCmdList.VOIPA_VARW(msg, editbox) -- Raid Warning voip
	vaInstanceMessage("RAID_WARNING")
end

function vaInfo()
	ChatFrame1:AddMessage(GetAddOnMetadata(addon_name, "Title") .. " " .. GetAddOnMetadata(addon_name, "Version"))
	ChatFrame1:AddMessage(GetAddOnMetadata(addon_name, "Author"))
	ChatFrame1:AddMessage(GetAddOnMetadata(addon_name, "Notes"))
end