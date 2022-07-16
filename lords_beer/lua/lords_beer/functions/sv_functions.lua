util.AddNetworkString("LBeer:NetworkIngredient")
util.AddNetworkString("LBeer:AddIngredient")
net.Receive("LBeer:AddIngredient", function(len, ply)
    local index, k, ent = net.ReadUInt(32), net.ReadUInt(32), net.ReadEntity()
    if not IsValid(ent) and not LBeer.Config.Drinks[index] or not LBeer.Config.Drinks[index].Ingredients[k] then return end
    if not ent:Available() then DarkRP.notify(ply, 1, 3, "We are currently doing something") return end

    local data = LBeer.Config.Drinks[index].Ingredients[k]
    if ent.tbl[data.name] and ent.tbl[data.name] == data.amount then DarkRP.notify(ply, 1, 3, data.name.." is already maxed!") return end
    ent.tbl[data.name] = (ent.tbl[data.name] and ent.tbl[data.name] + 1) or 1        

    if not ply:canAfford(data.price) then DarkRP.notify(ply, 1, 3, "You cannot afford this!") return end
    ply:addMoney(-data.price)
    DarkRP.notify(ply, 1, 3, "Ingredient purchased")

    ent:SetStage(4)
    ent:SetTime(data.pouringtime)
    ent:SetItemBrewing(data.name)
    timer.Simple(data.pouringtime, function()
        if not IsValid(ent) then return end
        ent:SetStage(1)
        ent:SetTime(0)
        ent:SetItemBrewing("")
    end)

    net.Start("LBeer:NetworkIngredient")
    net.WriteString(data.name)
    net.WriteUInt(ent.tbl[data.name], 32)
    net.WriteEntity(ent)
    net.Broadcast()
end)

util.AddNetworkString("LBeer:Brew")
net.Receive("LBeer:Brew", function(len, ply)
    local index, ent = net.ReadUInt(32), net.ReadEntity()
    if not IsValid(ent) and not LBeer.Config.Drinks[index] then return end
    if not ent:Available() then DarkRP.notify(ply, 1, 3, "We are currently doing something") return end

    if not ent:CanBrew(index) then DarkRP.notify(ply, 1, 3, "All the ingredients are not maxed") return end
    local data = LBeer.Config.Drinks[index]

    ent:SetStage(2)
    ent:SetTime(data.BrewingTime)
    ent:SetItemBrewing(data.Name)
    timer.Simple(data.BrewingTime, function()
        if not IsValid(ent) then return end
        ent:SetStage(3)
        ent:SetTime(data.Cooldown)
        ent:SetItemBrewing("")

        ent:CreateBottles(index, ent:CPPIGetOwner())
        ent:ResetIngredients()
        timer.Simple(data.Cooldown, function()
            if not IsValid(ent) then return end
            ent:SetStage(1)
            ent:SetTime(0)
        end)
    end)
end)