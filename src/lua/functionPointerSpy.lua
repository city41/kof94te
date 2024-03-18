cpu = manager.machine.devices[":maincpu"]
mem = cpu.spaces["program"]

address = 0x108584

function on_write(offset, data, mask)
	print(string.format("offset: %x, data: %x, mask: %x, pc: %s", offset, data, mask, cpu.state["PC"]))
end

handler = mem:install_write_tap(address, address + 3, "write", on_write)
