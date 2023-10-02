-- BURGER SHOT
	-- Moo Kid's Meal 			$2
	-- Beef Tower 				$6
	-- Meat Stack 				$12
	-- Salad Meal 				$6

-- CLUCKIN' BELL
	-- Cluckin' Little Meal 	$2
	-- Cluckin' Big Meal		$5
	-- Cluckin' Huge Meal   	$10
	-- Salad Meal				$10

-- WELL STACKED PIZZA CO.
	-- Buster 					$2
	-- Double D-Luxe 			$5
	-- Full Rack 				$10
	-- Salad Meal 				$10

RestaurantsConfig = {}

--{x = 1206.3049316406, y = -917.99914550781, z = 43.075248718262},

RestaurantsConfig.foods = {
	['BURGER_SHOT'] = {
		{ name = "Moo Kid's Meal", 	price = 2, 	add = 0.05, img = "assets/img/BURLOW.png" },
		{ name = "Beef Tower", 		price = 6, 	add = 0.2, img = "assets/img/BURMED.png" },
		{ name = "Meat Stack", 		price = 12, add = 0.3, img = "assets/img/BURHIG.png" },
		{ name = "Salad Meal", 		price = 6, 	add = 0.15, img = "assets/img/BURHEAL.png" },
	}
}

RestaurantsConfig.position = {

	-- BURGER SHOT --
	{
		int = 10, -- интерьер
		dim = 1, -- измерение
		blip = 10,
		pickup = 2768, -- пикап
		name = "Burger Shot",
		foods = RestaurantsConfig.foods['BURGER_SHOT'],

		eX = 811, -- позиция входа X
		eY = -1616.2, -- позиция входа Y
		eZ = 13.5, -- позиция входа Z
		
		oX = 363, -- позиция выхода X
		oY = -75, -- позиция выхода Y
		oZ = 1001.5, -- позиция выхода Z
		
		bX = 377,
		bY = -68,
		bZ = 1001.5
	},


	{
		int = 10, -- интерьер
		dim = 2, -- измерение
		blip = 10,
		pickup = 2768, -- пикап
		name = "Burger Shot",
		foods = RestaurantsConfig.foods['BURGER_SHOT'],

		eX = 1206.3049316406, -- позиция входа X
		eY = -917.99914550781, -- позиция входа Y
		eZ = 43.075248718262, -- позиция входа Z
		
		oX = 363, -- позиция выхода X
		oY = -75, -- позиция выхода Y
		oZ = 1001.5, -- позиция выхода Z
		
		bX = 377,
		bY = -68,
		bZ = 1001.5
	},

	{
		int = 10, -- интерьер
		dim = 3, -- измерение
		blip = 10,
		pickup = 2768, -- пикап
		name = "Burger Shot",
		foods = RestaurantsConfig.foods['BURGER_SHOT'],
		
		eX = -2336.5, -- позиция входа X
		eY = -166.8, -- позиция входа Y
		eZ = 35.5, -- позиция входа Z
		
		oX = 363, -- позиция выхода X
		oY = -75, -- позиция выхода Y
		oZ = 1001.5, -- позиция выхода Z
		
		bX = 377,
		bY = -68,
		bZ = 1001.5
	},
	
	--[[
	{
		int = 9, -- интерьер
		dim = 6, -- измерение
		blip = 10, -- 14
		pickup = 2768, -- пикап

		eX = -1816.718261718, -- позиция входа X
		eY = 618.0131835937, -- позиция входа Y
		eZ = 35.171875, -- позиция входа Z
		
		oX = 365, -- позиция выхода X
		oY = -11, -- позиция выхода Y
		oZ = 1001.8, -- позиция выхода Z
		
		bX = 369,
		bY = -6.5,
		bZ = 1001.5
	},
	
	{
		int = 9, -- интерьер
		dim = 8, -- измерение
		blip = 10, -- 14
		pickup = 2768, -- пикап

		eX = 2638, -- позиция входа X
		eY = 1672, -- позиция входа Y
		eZ = 11.2, -- позиция входа Z
		
		oX = 365, -- позиция выхода X
		oY = -11, -- позиция выхода Y
		oZ = 1001.8, -- позиция выхода Z
		
		bX = 369,
		bY = -6.5,
		bZ = 1001.5
	},
	
	{
		int = 9, -- интерьер
		dim = 9, -- измерение
		blip = 10, -- 14
		pickup = 2768, -- пикап

		eX = 2393.3, -- позиция входа X
		eY = 2042, -- позиция входа Y
		eZ = 11, -- позиция входа Z
		
		oX = 365, -- позиция выхода X
		oY = -11, -- позиция выхода Y
		oZ = 1001.8, -- позиция выхода Z
		
		bX = 369,
		bY = -6.5,
		bZ = 1001.5
	},
	
	{
		int = 5, -- интерьер
		dim = 5, -- измерение
		blip = 10, -- 29
		pickup = 2768, -- пикап

		eX = 2105.2, -- позиция входа X
		eY = -1806.5, -- позиция входа Y
		eZ = 13.5, -- позиция входа Z
		
		oX = 372.4, -- позиция выхода X
		oY = -133, -- позиция выхода Y
		oZ = 1001.5, -- позиция выхода Z
		
		bX = 375,
		bY = -119,
		bZ = 1001.5
	}
	]]
}
