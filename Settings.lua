local Http = game:GetService("HttpService")
local Data = {}

function table_merge(...)
    local tables_to_merge = { ... }

    local result = tables_to_merge[1]

    for i = 2, #tables_to_merge do
        local from = tables_to_merge[i]
        
        for k, v in pairs(from) do
            if type(k) == "number" then
                table.insert(result, v)
            elseif type(k) == "string" then
                if type(v) == "table" then
                    result[k] = result[k] or {}
                    result[k] = table_merge(result[k], v)
                else
                    result[k] = v
                end
            end
        end
    end

    return result
end

local function init(FolderName, Dict)
    if not isfolder(FolderName) then
        makefolder(FolderName)
    end
    
    local savedData = isfile(FolderName.."/data.json") and Http:JSONDecode(readfile(FolderName.."/data.json"))
    
    if savedData then
        Data = table_merge(savedData, Dict)
    else
        Data = Dict
    end
    
    return setmetatable({}, {
        __index = function(self, idx)
            return Data[idx]
        end,
        
        __newindex = function(self, idx, newv)
            Data[idx] = newv
            writefile(FolderName.."/data.json", Http:JSONEncode(Data))
        end
    });
end

return init
