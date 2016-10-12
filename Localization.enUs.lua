-- enUS Localization
local _, addon = ...

local voipLocales = {
	["/VoIPA"] = "/VoIPA",
	["/voipa"] = "/voipa",
	["/VOIPA"] = "/VOIPA",
	["/Voipa"] = "/Voipa",
	["/va"] = "/va",
	["/vag"] = "/vag",
	["/var"] = "/var",
	["/varw"] = "/varw",
	["Version Date: "] = "Version Date: ",
	["Author: "] = "Author: ",
	["name"] = "|cFF00FF00VoIP Announcer|r",
	["|cff71C671For list of commands type /VoIPA|r"] = "|cff71C671For list of commands type /VoIPA|r",
	[" loaded."] = " loaded.",
	["NOT_GROUP"] = "|cFFFF0000Not in a group!|r",
	["NOT_INSTANCE_GROUP"] = "|cFFFF0000Not in an Instance group!|r",
	["CANNOT_FIND_VOIP"] = "|cFFFF0000No VoIP info set in Guild Info!|r",
	["NO_GUILD"] = "|cFFFF0000Not in a Guild!|r",
	["CANNOT_READ_GINFO"] = "|cFFFF0000Cannot read Guild Info!|r",
	["VOIP_INFO"] = " -- VoIP Info -- ",
	["VoIP"] = "[VoIP]",
	["IP:"] = "IP:",
	["Password:"] = "Password:",
	["|cff71C671VoIP Announcer Slash Commands|r"] = "|cff71C671VoIP Announcer Slash Commands|r",
	["|cff71C671/VoIP options for addon options|r"] = "|cff71C671/VoIP options for addon options|r",
	["|cff71C671/VoIP info for addon info|r"] = "|cff71C671/VoIP info for addon info|r",
	["|cff71C671/va to /say custom VoIP info|r"] = "|cff71C671/va to /say custom VoIP info|r",
	["|cff71C671/vag to print guild VoIP info to guild chat|r"] = "|cff71C671/vag to print guild VoIP info to guild chat|r",
	["|cff71C671/var to print guild VoIP info to raid chat|r"] = "|cff71C671/var to print guild VoIP info to raid chat|r",
	["|cff71C671/varw to print guild VoIP info to raid warning|r"] = "|cff71C671/varw to print guild VoIP info to raid warning|r",
	["Set you personal VoIP Info"] = "Set you personal VoIP Info",
	["Put info here, and in guild info (after a [VoIP] line) in this form:"] = "Put info here, and in guild info (after a [VoIP] line) in this form:",
	["<VoIP Type>"] = "<VoIP Type>",
	["IP: <Ip address>"] = "IP: <Ip address>",
	["Password: <Password>"] = "Password: <Password>",
	["Set VoIP Info"] = "Set VoIP Info",
}

addon:RegisterLocale("enUS", voipLocales)
voipLocales = nil