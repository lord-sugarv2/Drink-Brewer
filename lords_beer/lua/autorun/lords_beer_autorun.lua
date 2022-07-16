LBeer = LBeer or {}
LBeer.Config = LBeer.Config or {}

Lords = Lords or {}
Lords.GameConfigs = Lords.GameConfigs or {}

hook.Add("PIXEL.UI.FullyLoaded", "LBeer:Loaded", function()
    PIXEL.LoadDirectoryRecursive("lords_beer")
end)