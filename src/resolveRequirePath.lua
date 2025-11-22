--!strict
local function traverse(from: Instance, segments: { string }, context: string, index: number): ModuleScript
	local segment = segments[index]
	if segment == ".." then
		if from.Parent == nil then
			error(`".." traversed too high from {from:GetFullName()} as part of "{context}"`)
		end

		return traverse(from.Parent, segments, context, index + 1)
	end

	local found = from:FindFirstChild(segment)
	if found == nil then
		error(`Couldn't find {segment} in {from:GetFullName()} as part of "{context}"`)
	end

	if index == #segments then
		if not found:IsA("ModuleScript") then
			error(`{found:GetFullName()} is not a ModuleScript`)
		end

		return found
	end

	return traverse(found, segments, context, index + 1)
end

local function resolveRequirePath(path: string, root: Instance): ModuleScript
	local siblingMatch = path:match("^%./(.-)$")
	if siblingMatch then
		if root.Parent == nil then
			error(`Using "./" require when script has no parent: "{path}"`)
		end

		return traverse(root.Parent, siblingMatch:split("/"), path, 1)
	end

	local afterSelfMatch = path:match("^@self/(.-)$")
	if afterSelfMatch then
		return traverse(root, afterSelfMatch:split("/"), path, 1)
	end

	local afterGameMatch = path:match("^@game/(.-)$")
	if afterGameMatch then
		return traverse(root, afterGameMatch:split("/"), path, 1)
	end

	local piblingMatch = path:match("^%../(.-)$")
	if piblingMatch then
		if root.Parent == nil then
			error(`Using "../" require when script has no parent: "{path}"`)
		end

		if root.Parent.Parent == nil then
			error(`Using "../" require when script has no grandparent: "{path}"`)
		end

		return traverse(root.Parent.Parent, piblingMatch:split("/"), path, 1)
	end

	error(`Couldn't figure out how to handle string require: "{path}"`)
end

return resolveRequirePath
