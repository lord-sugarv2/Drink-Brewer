PIXEL.RegisterFontUnscaled("LBeer:20", "Open Sans Bold", 20)

local function getValue(ent, tbl)
    if not IsValid(ent) and not ent.tbl then return false end
    return (ent.tbl[tbl.name] or 0).."/"..tbl.amount
end

local PANEL = {}
function PANEL:Init()
    self.Selected = 1

    self.ComboBox = self:Add("PIXEL.ComboBox")
    self.ComboBox:Dock(FILL)
    self.ComboBox:SetSizeToText(false)

    for k, v in ipairs(LBeer.Config.Drinks) do
        self.ComboBox:AddChoice(v.Name)
    end
    self.ComboBox:ChooseOptionID(1)
    self:ChooseOption(1)
    LBeer.Menu:Center()

    self.ComboBox.OnSelect = function(s, index, value)
        self:ChooseOption(index)
        self.Selected = index
    end
end

function PANEL:ChooseOption(index)
    if IsValid(self.IngredientPanel) then self.IngredientPanel:Remove() end

    local x, y = LBeer.Menu:GetPos()
    LBeer.Menu:SetPos(x, y)

    self.ComboBox:Dock(TOP)

    self.IngredientPanel = self:Add("DPanel")
    self.IngredientPanel:Dock(FILL)
    self.IngredientPanel.Paint = nil

    self.ScrollPanel = self.IngredientPanel:Add("PIXEL.ScrollPanel")
    self.ScrollPanel:DockMargin(0, 5, 0, 0)
    self.ScrollPanel:Dock(FILL)

    for k, v in ipairs(LBeer.Config.Drinks[index].Ingredients) do
        local panel = self.ScrollPanel:Add("DPanel")
        panel:DockMargin(0, 0, 5, 5)
        panel:Dock(TOP)
        panel:SetTall(70)
        panel.Paint = function(s, w, h)
            PIXEL.DrawRoundedBox(PIXEL.Scale(4), 0, 0, w, h, PIXEL.Colors.Header)
        end

        local name = panel:Add("PIXEL.Label")
        name:DockMargin(PIXEL.Scale(6), 2, 0, 0)
        name:Dock(TOP)
        name:SetText(v.name.." ("..DarkRP.formatMoney(v.price)..")")
        name:SetFont("LBeer:20")
        name:SizeToContents()

        local button = panel:Add("PIXEL.TextButton")
        button:DockMargin(PIXEL.Scale(4), 0, 5, 5)
        button:Dock(FILL)
        button:SetText("")
        local p = button.PaintExtra
        button.PaintExtra = function(s, w, h)
            p(s, w, h)
            local textAlign = s:GetTextAlign()
            local textX = (textAlign == TEXT_ALIGN_CENTER and w / 2) or (textAlign == TEXT_ALIGN_RIGHT and w - s:GetTextSpacing()) or s:GetTextSpacing()

            local val = getValue(self.ent, v)
            PIXEL.DrawSimpleText(val == false and "ERROR" or val, s:GetFont(), textX, h / 2, PIXEL.Colors.PrimaryText, textAlign, TEXT_ALIGN_CENTER)
        end
        button.DoClick = function(s)
            surface.PlaySound("buttons/blip1.wav")
            net.Start("LBeer:AddIngredient")
            net.WriteUInt(index, 32)
            net.WriteUInt(k, 32)
            net.WriteEntity(self.ent)
            net.SendToServer()
        end
    end

    local button = self.ScrollPanel:Add("PIXEL.TextButton")
    button:DockMargin(PIXEL.Scale(4), 0, 10, 5)
    button:Dock(TOP)
    button:SetTall(self.ComboBox:GetTall())
    button:SetText("Brew")
    button.DoClick = function(s)
        surface.PlaySound("buttons/button24.wav")
        net.Start("LBeer:Brew")
        net.WriteUInt(index, 32)
        net.WriteEntity(self.ent)
        net.SendToServer()
    end
end

function PANEL:SetEnt(ent)
    self.ent = ent
end

function PANEL:PerformLayout(w, h)
    h = h - 5
    self.ComboBox:SetTall(h*.125)
end
vgui.Register("LBeer:Menu", PANEL, "EditablePanel")