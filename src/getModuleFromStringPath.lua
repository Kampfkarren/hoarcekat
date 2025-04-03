local function getModuleFromStringPath(path: string, root: Instance): ModuleScript
	local pathTraceback = if root then `in: {root:GetFullName()}` else ""

	if typeof(path) == "Instance" then
		if path:IsA("ModuleScript") then
			return path
		else
			error(`Attempted to require a {path.ClassName} {pathTraceback}`, 2)
		end
	end
	if typeof(path) ~= "string" then
		error(`Attempted to require a {typeof(path)} {pathTraceback}`, 2)
	end

	local parts = string.split(path, "/")
	local current = root.Parent

	if #parts == 0 then
		error(`Invalid relative path: {path} {pathTraceback}`, 2)
	end

	if parts[1] ~= "." and parts[1] ~= ".." then
		error(`Invalid path start: "{parts[1]}" in {path} {pathTraceback}`, 2)
	end

	for i, part in parts do
		if part == "" then
			error(`Double slashes are not allowed in path: {path} {pathTraceback}`, 2)
		end

		if part == ".." then
			local parent = current.Parent
			if parent == nil then
				error(`No parent found for: {current} {pathTraceback}`, 2)
			end
			current = parent
		elseif part == "." then
			-- do nothing
		else
			local child = current:FindFirstChild(part)
			if child == nil then
				error(`Unknown script "{part}" inside: {current} {pathTraceback}`, 2)
			end
			current = child
		end
	end

	if not current:IsA("ModuleScript") then
		local initFile = current:FindFirstChild("init") or current:FindFirstChild("Init")
		if initFile == nil then
			error(`No init file found inside: {current} {pathTraceback}`, 2)
		end
		current = initFile
	end
	return current
end

return getModuleFromStringPath
