cpu = manager.machine.devices[":maincpu"]
mem = cpu.spaces["program"]

address = 0x108231

PCs = {}

function on_memory_read(offset, data, mask)
	local tag = mem:read_range(0x108110, 0x108117, 8)

	local pc = tonumber(tostring(cpu.state["PC"], 16))

	if PCs[pc] == nil then
		PCs[pc] = true
		-- print(
		-- 	string.format("tag: %s, offset: %x, data: %x, mask: %x, pc: %s", tag, offset, data, mask, cpu.state["PC"])
		-- )
		print(string.format("%s - %s", tag, cpu.state["PC"]))
	end
end

mem_handler = mem:install_read_tap(address - 1, address, "reads", on_memory_read)
