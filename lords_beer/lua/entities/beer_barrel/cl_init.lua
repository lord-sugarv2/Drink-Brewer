include("shared.lua")

function ENT:Draw()
  	self:DrawModel()

	local ply = LocalPlayer()
	local pos = self:GetPos()

	local angle = self:GetAngles()
	local eyeAngle = ply:EyeAngles()

	angle:RotateAroundAxis(angle:Forward(), 90)
	angle:RotateAroundAxis(angle:Right(), -90)

  	local eyeAngle = LocalPlayer():EyeAngles()
	local stage = self:GetStage()
	if stage == 1 then
		PIXEL.DrawEntOverhead(self, LBeer.Config.Barrel.TopText)
	elseif stage == 2 then
		PIXEL.DrawEntOverhead(self, "Brewing "..((self:GetItemBrewing() == "") and "ERROR" or self:GetItemBrewing()).." ("..self:GetTime().."s)")
	elseif stage == 3 then
		PIXEL.DrawEntOverhead(self, "Cooldown ("..self:GetTime().."s)")
	elseif stage == 4 then
		PIXEL.DrawEntOverhead(self, "Pouring "..((self:GetItemBrewing() == "") and "ERROR" or self:GetItemBrewing()).." ("..self:GetTime().."s)")
	else
		PIXEL.DrawEntOverhead(self, "ERROR")
	end
end

function ENT:Initialize()
	self.tbl = {}
end