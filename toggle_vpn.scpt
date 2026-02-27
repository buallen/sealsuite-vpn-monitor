-- AppleScript to toggle SealSuite VPN ON
-- This script uses GUI automation to click the VPN toggle button

tell application "System Events"
	-- Make sure SealSuite is running
	if not (exists process "SealSuite") then
		tell application "SealSuite" to activate
		delay 2
	end if

	tell process "SealSuite"
		-- Bring SealSuite to front
		set frontmost to true
		delay 0.5

		try
			-- Look for the VPN Connectivity toggle switch
			-- The exact UI hierarchy may vary, so we'll try multiple methods

			-- Method 1: Look for window and toggle by accessibility
			if exists window 1 then
				tell window 1
					-- Look for the toggle button or switch labeled "VPN Connectivity"
					-- This might be a checkbox, button, or switch element

					-- Try to find and click the switch if it's in "Off" state
					set toggleFound to false

					-- Check for various UI element types
					repeat with i from 1 to (count of buttons)
						try
							set buttonName to name of button i
							if buttonName contains "VPN" or buttonName contains "Off" then
								click button i
								set toggleFound to true
								exit repeat
							end if
						end try
					end repeat

					-- If button method didn't work, try checkboxes
					if not toggleFound then
						repeat with i from 1 to (count of checkboxes)
							try
								set cbValue to value of checkbox i
								if cbValue is 0 then
									-- Checkbox is off, click it
									click checkbox i
									set toggleFound to true
									exit repeat
								end if
							end try
						end repeat
					end if

					-- If still not found, try generic UI elements
					if not toggleFound then
						-- Try clicking at approximate coordinates where toggle usually is
						-- Based on the screenshot: toggle is on the right side
						set windowPosition to position of window 1
						set windowSize to size of window 1

						-- Calculate approximate position (right side, near top)
						set toggleX to (item 1 of windowPosition) + (item 1 of windowSize) - 100
						set toggleY to (item 2 of windowPosition) + 240

						-- Use mouse click at coordinates
						do shell script "cliclick c:" & toggleX & "," & toggleY
					end if
				end tell
			end if

		on error errMsg
			log "Error clicking VPN toggle: " & errMsg
			return false
		end try
	end tell
end tell

return true
