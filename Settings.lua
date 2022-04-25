local Data = {}
local DataFunctions = {}
local Http = game:GetService("HttpService")

function Data.new(name, data)
	if not isfolder(name) then
		makefolder(name)
	end

	return setmetatable({
		Data = isfile(name.."/settings.json") and Http:JSONDecode(readfile(name.."/Settings.json")) or data,
		FolderName = name
	}, {
		__index = DataFunctions
	})
end

function DataFunctions:Set(name, value)
	self.Data[name] = value
	writefile(self.FolderName.."/Settings.json", Http:JSONEncode(self.Data))
end

function DataFunctions:Get(name)
	return self.Data[name]
end

return Data
