local abbreviation = vwep.info.abbreviation
local color = vwep.info.color

surface.CreateFont(abbreviation .. ".HUDFont", {
    font = "Arial",
    size = 24,
    weight = 800,
    antialias = true,
    shadow = false
})

surface.CreateFont(abbreviation .. ".HUDFontSmall", {
    font = "Arial",
    size = 18,
    weight = 800,
    antialias = true,
    shadow = false
})

local w, h
hook.Add("HUDPaint", abbreviation .. ".HUDPaint", function()
    local ply = LocalPlayer()
    if ( !IsValid(ply) ) then return end
    if ( !ply:GetNWBool(abbreviation .. ".DevMode", false) ) then return end

    local font = abbreviation .. ".HUDFont"
    local smallFont = abbreviation .. ".HUDFontSmall"
    
    draw.SimpleTextOutlined(abbreviation .. " Developer Mode", font, 10, 10, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, color_black)

    local weapon = ply:GetActiveWeapon()
    if ( !IsValid(weapon) ) then
        draw.SimpleTextOutlined("No weapon equipped.", smallFont, 10, 30, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, color_black)
        return 
    elseif ( !weapon.IsVWEP ) then
        draw.SimpleTextOutlined("Weapon is not a VWep.", smallFont, 10, 30, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, color_black)
        return
    end

    surface.SetFont(smallFont)

    local y = 30
    for k, v in SortedPairs(weapon:GetTable()) do
        if ( isstring(v) and string.len(v) > 0 ) then
            w, h = surface.GetTextSize(k .. ": ")
            draw.SimpleTextOutlined(k .. ": ", smallFont, 10, y, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, color_black)
            draw.SimpleTextOutlined(v, smallFont, 10 + w, y, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, color_black)
            y = y + 15
        elseif ( isnumber(v) ) then
            w, h = surface.GetTextSize(k .. ": ")
            draw.SimpleTextOutlined(k .. ": ", smallFont, 10, y, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, color_black)
            draw.SimpleTextOutlined(tostring(v), smallFont, 10 + w, y, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, color_black)
            y = y + 15
        elseif ( isbool(v) ) then
            w, h = surface.GetTextSize(k .. ": ")
            draw.SimpleTextOutlined(k .. ": ", smallFont, 10, y, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, color_black)
            draw.SimpleTextOutlined(v and "true" or "false", smallFont, 10 + w, y, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, color_black)
            y = y + 15
        end
    end
end)