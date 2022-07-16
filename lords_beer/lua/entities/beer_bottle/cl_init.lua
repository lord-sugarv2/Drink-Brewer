include("shared.lua")
function ENT:Draw()
  	self:DrawModel()
	PIXEL.DrawEntOverhead(self, LBeer.Config.Drinks[self:GetIndex()].Name)
end