-- @description Toggle mute for chosen tracks at next bar
-- @author MrZaus
-- @version 0.1
-- @changelog Initial release

ListOfTrackNumbersToToggleMute = {}

function ToggleMuteTrack(track_number)
    -- Validate the track number.  Reaper track numbers are 1-based.
    if not track_number or type(track_number) ~= "number" or track_number < 1 then
        reaper.ShowMessageBox("Invalid track number.  Must be a positive integer.", "Error", 0)
        reaper.ShowConsoleMsg("Error: Invalid track number.\n")
        return
    end

    -- Get the track object using GetTrackByNumber
    local track = reaper.GetTrack(0, track_number - 1) -- Index is 0-based

    if track then
        -- Get the current mute state
        local mute_state = reaper.GetMediaTrackInfo_Value(track, "B_MUTE")

        -- Toggle the mute state (0 becomes 1, 1 becomes 0)
        local new_mute_state = 1 - mute_state
        reaper.SetMediaTrackInfo_Value(track, "B_MUTE", new_mute_state)

        local new_mute_state_text = (new_mute_state == 1) and "muted" or "unmuted"
    else
        reaper.ShowMessageBox("Track " .. track_number .. " not found.", "Error", 0)
        reaper.ShowConsoleMsg("Error: Track " .. track_number .. " not found.\n")
    end
end

function AddTrackNumberToMuteToggleList(track_number)
    -- Validate the track number.  Reaper track numbers are 1-based.
    if not track_number or type(track_number) ~= "number" or track_number < 1 then
        reaper.ShowMessageBox("Invalid track number.  Must be a positive integer.", "Error", 0)
        reaper.ShowConsoleMsg("Error: Invalid track number.\n")
        return
    end
    ListOfTrackNumbersToToggleMute[#ListOfTrackNumbersToToggleMute + 1] = track_number
end

function ToggleMuteTracksInList()
    for i, track_number in ipairs(ListOfTrackNumbersToToggleMute) do
        ToggleMuteTrack(track_number)
        reaper.ShowConsoleMsg("Track " .. track_number .. " mute toggled.\n")
    end
    ListOfTrackNumbersToToggleMute = {}
end

function ExecuteAtNextBar(func, measure)
    if measure ~= nil and StoredMeasure ~= nil then
        return
    end
    if measure ~= nil then StoredMeasure = measure end
    local _, deltaMeasure, _, _, _ = reaper.TimeMap2_timeToBeats( 0, reaper.GetPlayPosition() )
    if StoredMeasure ~= deltaMeasure then
        func()
        StoredMeasure = nil
    end
    if StoredMeasure == nil then return else reaper.defer(function() ExecuteAtNextBar(func) end) end
end
