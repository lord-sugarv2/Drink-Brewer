LBeer.Config.Barrel = {
    TopText = "Brewer",
    HP = 300,
}

LBeer.Config.Bottles = {
    HP = 25,
    HPCap = 200,
}

LBeer.Config.Drinks = {
    {
        Name = "Beer", -- Name of the drink
        HP = 100, -- How would hp it gives you
        DrunkTime = 6, -- How long you stay drunk for set to 0 to disable the effect
        DrunkSeverity = 1, -- 0: Disable, 1: Low, 2: Medium, 3: High
        BrewingTime = 2, -- Time it takes to brew in seconds
        Cooldown = 10, -- Cooldown after making the bottle between you can start buying another ingredient
        BottlesPerBatch = 4, -- How many bottles you get per batch
        CustomServer = function(data, ply) -- data return this drinks table so data.Name would = "Beer"
        end,
        Ingredients = {
            {
                name = "Water", -- Name of ingredient
                amount = 1, -- Amount needed to buy for the drink
                price = 150, -- Price of the ingredient
                pouringtime = 0,
            },
            {
                name = "Malt",
                amount = 1,
                price = 50,
                pouringtime = 0,
            },
            {
                name = "Hops",
                amount = 1,
                price = 75,
                pouringtime = 0,
            },
            {
                name = "Yeast",
                amount = 1,
                price = 64,
                pouringtime = 0,
            },
        },
    },
    {
        Name = "Wine", -- Name of the drink
        HP = 100, -- How would hp it gives you
        DrunkTime = 4, -- How long you stay drunk for set to 0 to disable the effect
        DrunkSeverity = 3, -- The strength of the drunkness effect
        BrewingTime = 2, -- Time it takes to brew in seconds
        Cooldown = 10, -- Cooldown after making the bottle between you can start buying another ingredient
        BottlesPerBatch = 4, -- How many bottles you get per batch
        CustomServer = function() -- custom code that gets called on server on use
        end,
        Ingredients = {
            {
                name = "Grape Juice", -- Name of ingredient
                amount = 1, -- Amount needed to buy for the drink
                price = 150, -- Price of the ingredient
                pouringtime = 3,
            },
            {
                name = "Sugar",
                amount = 1,
                price = 50,
                pouringtime = 2,
            },
            {
                name = "Water",
                amount = 1,
                price = 75,
                pouringtime = 4,
            },
            {
                name = "Yeast",
                amount = 1,
                price = 64,
                pouringtime = 1,
            },
            {
                name = "Flavour",
                amount = 3,
                price = 82,
                pouringtime = 2,
            },
        },
    },
}