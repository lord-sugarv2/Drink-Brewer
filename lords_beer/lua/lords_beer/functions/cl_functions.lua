net.Receive("LBeer:Menu", function()
    if IsValid(LBeer.Menu) then LBeer.Menu:Remove() end
    if #LBeer.Config.Drinks <= 0 then notification.AddLegacy("There are no drinks available!", 1, 3) return end

    LBeer.Menu = vgui.Create("PIXEL.Frame")
    LBeer.Menu:SetSize(300, 350)
    LBeer.Menu:SetTitle("Barrel Brewing")
    LBeer.Menu:MakePopup()
    LBeer.Menu:SetSizable(true)

    local panel = LBeer.Menu:Add("LBeer:Menu")
    panel:Dock(FILL)
    panel:SetEnt(net.ReadEntity())
end)

net.Receive("LBeer:NetworkIngredient", function()
    local name, amount, ent = net.ReadString(), net.ReadUInt(32), net.ReadEntity()
    ent.tbl[name] = amount
end)

net.Receive("LBeer:ResetIngredients", function()
    local ent = net.ReadEntity()
    ent.tbl = {}
end)

local DrunkEffect = Material("vgui/wave.png")
hook.Add("HUDPaint", "Beer:DrawDrunk", function()
    local bool = LocalPlayer():GetNWInt("LBeer:DrunkSeverity")
    if bool == 1 then
        DrawMotionBlur(0.4, 0.4, 0.05)
    elseif bool == 2 then
        DrawMotionBlur(0.4, 0.5, 0.1)
    elseif bool == 3 then
        DrawMotionBlur(0.4, 0.6, 0.2)  
    end
end)