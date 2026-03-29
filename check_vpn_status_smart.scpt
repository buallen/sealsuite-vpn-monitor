-- Smart AppleScript to check SealSuite VPN status
-- It brings the app to the front, checks the UI, and returns focus.

tell application "System Events"
    if not (exists process "SealSuite") then
        return "app_not_running"
    end if
    
    -- Save current active application
    set previousApp to name of first application process whose frontmost is true
end tell

-- Bring SealSuite to the front to ensure UI elements are rendered and readable
tell application "SealSuite" to activate
delay 1 -- Wait for UI to render

tell application "System Events"
    tell process "SealSuite"
        try
            if exists window 1 then
                set uiText to ""
                
                -- Collect all static text
                try
                    set staticTextElements to static texts of window 1
                    repeat with uiElement in staticTextElements
                        try
                            set uiText to uiText & (value of uiElement as string) & " "
                        end try
                    end repeat
                end try
                
                -- Check state
                set vpnState to "unknown"
                
                if uiText contains "Time connected" and not (uiText contains "00:00:00") then
                    set vpnState to "on"
                else if (uiText contains "VPN ConnectivityOn") or (uiText contains "VPN Connectivity On") or (uiText contains "Disconn") or (uiText contains "断开") then
                    set vpnState to "on"
                else if (uiText contains "VPN ConnectivityOff") or (uiText contains "VPN Connectivity Off") or (uiText contains "Connect") or (uiText contains "连接") or (uiText contains "Off") or (uiText contains "00:00:00") then
                    set vpnState to "off"
                else
                    -- Fallback if UI text is completely empty or unreadable
                    set vpnState to "off"
                end if
                
                -- Return focus to the previous app
                if previousApp is not "SealSuite" and previousApp is not "" then
                    tell application previousApp to activate
                end if
                
                return vpnState
            else
                -- Return focus to the previous app
                if previousApp is not "SealSuite" and previousApp is not "" then
                    tell application previousApp to activate
                end if
                return "off" -- No window, but we need to toggle it
            end if
            
        on error
            -- Return focus to the previous app
            if previousApp is not "SealSuite" and previousApp is not "" then
                tell application previousApp to activate
            end if
            return "off"
        end try
    end tell
end tell
