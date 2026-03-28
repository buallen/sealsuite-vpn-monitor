-- AppleScript to check SealSuite VPN status
-- Returns "on", "off", or "app_not_running"

tell application "System Events"
    if not (exists process "SealSuite") then
        return "app_not_running"
    end if

    tell process "SealSuite"
        try
            if exists window 1 then
                set entireText to (entire contents) as text
                
                -- Priority 1: Check for explicit "Time connected" with non-zero value
                -- This is a very reliable indicator of active connection
                if entireText contains "Time connected" then
                    if not (entireText contains "00:00:00") then
                        return "on"
                    end if
                end if
                
                -- Priority 2: Check for "VPN Connectivity" with "On" or "Off"
                -- Image shows "VPN Connectivity" label and "On" toggle
                if entireText contains "VPN Connectivity" then
                    -- We check for "On" or "Off" specifically in the context of connectivity
                    -- Note: String concatenation in entireText might vary
                    if entireText contains "VPN ConnectivityOn" or entireText contains "VPN Connectivity On" or (entireText contains "VPN Connectivity" and entireText contains "On") then
                        -- Check if "Off" is also present to avoid confusion
                        -- But usually "On" being present after "VPN Connectivity" is strong
                        return "on"
                    else if entireText contains "VPN ConnectivityOff" or entireText contains "VPN Connectivity Off" or (entireText contains "VPN Connectivity" and entireText contains "Off") then
                        return "off"
                    end if
                end if
                
                -- Priority 3: Keywords for on state
                if (entireText contains "Disconn") or (entireText contains "断开") then
                    return "on"
                end if
                
                -- Priority 4: Keywords for off state
                if (entireText contains "Connect") or (entireText contains "连接") or (entireText contains "Off") then
                    return "off"
                end if
                
                -- Priority 5: Defaulting to "unknown" instead of guessing
                return "unknown"
            else
                -- If the main window isn't visible, we can't be sure
                return "no_window"
            end if
        on error errText
            return "error:" & errText
        end try
    end tell
end tell
