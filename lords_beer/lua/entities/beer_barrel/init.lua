AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_c17/oildrum001.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:GetPhysicsObject():Wake()
	self:SetUseType(SIMPLE_USE)

	self:SetStage(1)
	self:SetHealth(LBeer.Config.Barrel.HP)
	self.tbl = {}
	self.Time = CurTime()
end

function ENT:Destruct()
	local vPoint = self:GetPos()
	local effect_explode = ents.Create("env_explosion")

	if not IsValid(effect_explode) then return end
	effect_explode:SetPos(vPoint)
	effect_explode:Spawn()
	effect_explode:Fire("Explode", 0, 0)

	self:Remove()
end

function ENT:OnTakeDamage(dmg)
	if (not self.m_bApplyingDamage) then
		self.m_bApplyingDamage = true
		
		self:SetHealth((self:Health() or 100) - dmg:GetDamage())
		if self:Health() <= 0 then
			if not IsValid(self) then return end
			self:Destruct()
		end
		
		self.m_bApplyingDamage = false
	end
end

util.AddNetworkString("LBeer:Menu")
function ENT:Use(ply)
	net.Start("LBeer:Menu")
	net.WriteEntity(self)
	net.Send(ply)
end

function ENT:Think()
	if CurTime() > self.Time then
		self:SetTime(math.max(self:GetTime()-1, 0))

		self.Time = CurTime() + 1
	end
end

function ENT:CanBrew(index)
    for k, v in ipairs(LBeer.Config.Drinks[index].Ingredients) do
        if not self.tbl[v.name] or self.tbl[v.name] < v.amount then return false end
    end
	return true
end

util.AddNetworkString("LBeer:ResetIngredients")
function ENT:ResetIngredients(index)
    self.tbl = {}

	net.Start("LBeer:ResetIngredients")
	net.WriteEntity(self)
	net.Broadcast()
end

function ENT:Available()
	if self:GetStage() == 1 then return true end
	return false
end

function ENT:CreateBottles(index, ply)
	local data = LBeer.Config.Drinks[index]
	for i = 1, data.BottlesPerBatch do
		local beer = ents.Create("beer_bottle")
		beer:SetPos(self:GetPos() + Vector(0, 0, 100))
		beer:SetIndex(index)
		beer:Spawn()

		if ply then
			beer:CPPISetOwner(ply)
		end
	end
end