local info = debug.getinfo(1, 'S');
script_path = info.source:match [[^@?(.*[\/])[^\/]-$]]
dofile(script_path .. 'ToggleMuteAtNextBar-Functions.lua')
AddTrackNumberToMuteToggleList(1)
local _, measure, _, _, _ = reaper.TimeMap2_timeToBeats(0, reaper.GetPlayPosition())
ExecuteAtNextBar(ToggleMuteTracksInList, measure)
