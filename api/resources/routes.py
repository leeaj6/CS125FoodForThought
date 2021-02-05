from .food import AllFoods, Restaurant, SearchFood

def initialize_routes(api):
	api.add_resource(AllFoods, '/api/v1/foods')
	api.add_resource(Restaurant, '/api/v1/foods/restaurant/<restaurant>')
	api.add_resource(SearchFood, '/api/v1/foods/search')