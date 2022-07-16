ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Beer Barrel"
ENT.Author = "Lord Sugar"
ENT.Category = "Custom Beer System"
ENT.Spawnable = true

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "owning_ent")

/*

Stages:
1 - Just sit there
2 - Brewing
3 - Cooldown
4 - Pouring

*/
	self:NetworkVar("Int", 0, "Stage")
	self:NetworkVar("Int", 1, "Time")
	self:NetworkVar("String", 0, "ItemBrewing")
end