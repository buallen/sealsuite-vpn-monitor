-- AppleScript to toggle SealSuite VPN ON (without stealing focus)
-- This script clicks the VPN toggle in the background

tell application "System Events"
	-- Make sure SealSuite is running
	if not (exists process "SealSuite") then
		tell application "SealSuite" to launch
		delay 2
	end if

	tell process "SealSuite"
		-- DON'T bring to front - work in background
		-- set frontmost to true

		try
			-- Get window position and size WITHOUT activating
			if exists window 1 then
				set windowPos to position of window 1
				set windowX to item 1 of windowPos
				set windowY to item 2 of windowPos

				-- Calibrated toggle position (relative to window)
				-- User calibration: Toggle at (735, 259), Window at (323, 144)
				-- Relative position: X offset = 412, Y offset = 115
				set toggleX to windowX + 412
				set toggleY to windowY + 115

				-- Click the toggle
				do shell script "cliclick c:" & toggleX & "," & toggleY
				delay 0.5
			end if

		on error errMsg
			log "Error clicking VPN toggle: " & errMsg
			return false
		end try
	end tell
end tell

return true
