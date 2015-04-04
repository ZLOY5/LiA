--[[

  -- Send a command to the Player with ID 0 to rebind their 'x' key to change the camera to straight overhead (pitch 90)
  ConsoleCommands:SendToPlayer(0, "bind x dota_camera_pitch_max 90")

  -- Send a command to all Players and NonPlayers (spectators, broadcasters)
  ConsoleCommands:SendToAll("bind x dota_camera_pitch_max 90")

  -- Send a command to all Players but not to NonPlayers
  ConsoleCommands:SendToAllPlayers("bind x dota_camera_pitch_max 90")

  -- Send a command to all NonPlayers (spectators, broadcasters), but not to regular Players
  ConsoleCommands:SendToAllNonPlayers("bind x dota_camera_pitch_max 90")
]]

if ConsoleCommands == nil then
  print ( '[ConsoleCommands] creating ConsoleCommands' )
  ConsoleCommands = {}
  ConsoleCommands.__index = ConsoleCommands
end

function ConsoleCommands:SendToPlayer(pid, command)
  FireGameEvent("console_command", {pid=pid, command=command})
end

function ConsoleCommands:SendToAll(command)
  FireGameEvent("console_command", {pid=-1, command=command})
end

function ConsoleCommands:SendToAllPlayers(command)
  FireGameEvent("console_command", {pid=-2, command=command})
end

function ConsoleCommands:SendToAllNonPlayers(command)
  FireGameEvent("console_command", {pid=-3, command=command})
end