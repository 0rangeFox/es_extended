local Charset = {}

for i = 48,  57 do table.insert(Charset, string.char(i)) end
for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

local _print = print

print = function(...)

  local args = {...}
  local str  = '[^4esx^7]'

  for i=1, #args, 1 do
    str = str .. ' ' .. tostring(args[i])
  end

  _print(str)

end

-- Be careful with this, use it for some config file parsing and such
ESX.EvalFile = function(resource, file, env)

  env        = env or {}
  env._G     = env
  local code = LoadResourceFile(resource, file)

  load(code, code, 't', env)()

  return env

end

ESX.GetRandomString = function(length)
	math.randomseed(GetGameTimer())

	if length > 0 then
		return ESX.GetRandomString(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end

ESX.GetConfig = function()
	return Config
end

ESX.GetWeapon = function(weaponName)
	weaponName = string.upper(weaponName)

	for k,v in ipairs(Config.Weapons) do
		if v.name == weaponName then
			return k, v
		end
	end
end

ESX.GetWeaponFromHash = function(weaponHash)
	for k,v in ipairs(Config.Weapons) do
		if v.hash == weaponHash then
			return v
		end
	end
end

ESX.GetWeaponList = function()
	return Config.Weapons
end

ESX.GetWeaponLabel = function(weaponName)
	weaponName = string.upper(weaponName)

	for k,v in ipairs(Config.Weapons) do
		if v.name == weaponName then
			return v.label
		end
	end
end

ESX.GetWeaponComponent = function(weaponName, weaponComponent)
	weaponName = string.upper(weaponName)
	local weapons = Config.Weapons

	for k,v in ipairs(Config.Weapons) do
		if v.name == weaponName then
			for k2,v2 in ipairs(v.components) do
				if v2.name == weaponComponent then
					return v2
				end
			end
		end
	end
end

ESX.DumpTable = function(table, nb)
	if nb == nil then
		nb = 0
	end

	if type(table) == 'table' then
		local s = ''
		for i = 1, nb + 1, 1 do
			s = s .. "    "
		end

		s = '{\n'
		for k,v in pairs(table) do
			if type(k) ~= 'number' then k = '"'..k..'"' end
			for i = 1, nb, 1 do
				s = s .. "    "
			end
			s = s .. '['..k..'] = ' .. ESX.DumpTable(v, nb + 1) .. ',\n'
		end

		for i = 1, nb, 1 do
			s = s .. "    "
		end

		return s .. '}'
	else
		return tostring(table)
	end
end

ESX.Round = function(value, numDecimalPlaces)
	return ESX.Math.Round(value, numDecimalPlaces)
end
