-- AppleScript to check SealSuite VPN status
-- Returns "on", "off", or "app_not_running"

tell application "System Events"
    if not (exists process "SealSuite") then
        return "app_not_running"
    end if

    tell process "SealSuite"
        try
            if exists window 1 then
                set uiText to ""
                
                try
                    set staticTextElements to static texts of window 1
                    repeat with st in staticTextElements
                        try
                            set uiText to uiText & (value of st as string) & " "
                        end try
                    end repeat
                end try
                
                if uiText contains "Time connected" and not (uiText contains "00:00:00") then
                    return "on"
                end if
                
                if (uiText contains "VPN ConnectivityOn") or (uiText contains "VPN Connectivity On") or (uiText contains "Disconn") or (uiText contains "断开") then
                    return "on"
                end if
                
                if (uiText contains "VPN ConnectivityOff") or (uiText contains "VPN Connectivity Off") or (uiText contains "Connect") or (uiText contains "连接") or (uiText contains "Off") or (uiText contains "00:00:00") then
                    return "off"
                end if
                
                -- CRITICAL FALLBACK:
                -- Electron apps often hide their UI text from basic AppleScript.
                -- If we are in this script, the bash script has already confirmed Google is dead for 60s.
                -- If we return "unknown" or "no_window", the script skips clicking. 
                -- We must return "off" so the click proceeds.
                return "off"
            else
                -- Even if window is closed, if Google is dead, we want it to open and click it.
                return "off"
            end if
            
        on error errMsg
            -- Failsafe: return off to allow click
            return "off"
        end try
    end tell
end tell
