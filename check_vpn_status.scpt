-- AppleScript to check SealSuite VPN status
-- Returns "on" or "off" based on the time connected display

tell application "System Events"
	if not (exists process "SealSuite") then
		return "app_not_running"
	end if

	tell process "SealSuite"
		try
			if exists window 1 then
				tell window 1
					-- When VPN is OFF, the time shows "00:00:00"
					-- When VPN is ON, it shows actual time like "02:58:43"
					set entireText to entire contents as text

					-- Look for "00:00:00" which indicates VPN is off
					if entireText contains "00:00:00" then
						return "off"
					end if

					-- Look for "Off" text near VPN
					if entireText contains "Off" then
						return "off"
					end if

					-- If we find "On" text, VPN is likely on
					if entireText contains "On" then
						return "on"
					end if
				end tell
			end if
		on error errMsg
			return "error:" & errMsg
		end try
	end tell
end tell

-- If we can't determine, assume it's on to avoid false triggers
return "unknown"
