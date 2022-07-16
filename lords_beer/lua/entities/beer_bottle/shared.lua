ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Beer Bottle"
ENT.Author = "Lord Sugar"
ENT.Category = "Custom Beer System"
ENT.Spawnable = false

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "owning_ent")
	self:NetworkVar("Int", 0, "Index")
end