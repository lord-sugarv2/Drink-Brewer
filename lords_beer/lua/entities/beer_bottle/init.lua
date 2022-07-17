AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_junk/garbage_glassbottle003a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:GetPhysicsObject():Wake()
	self:SetUseType(SIMPLE_USE)
	self:DrawShadow(false)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)

	self:SetHealth(LBeer.Config.Bottles.HP)
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

function ENT:Use(ply)
	local data = LBeer.Config.Drinks[self:GetIndex()]
	if not data then self:Remove() return end
	if LBeer.Config.Bottles.HPCap > ply:Health() then
		ply:SetHealth(math.min(ply:Health()+data.HP, LBeer.Config.Bottles.HPCap))
	end

	data.CustomServer(data, ply)
	ply:SetNWInt("LBeer:DrunkSeverity", data.DrunkSeverity)
	timer.Create("LBeer:"..ply:SteamID(), data.DrunkTime, 1, function()
		ply:SetNWInt("LBeer:DrunkSeverity", 0)
	end)

	self:Remove()
end
