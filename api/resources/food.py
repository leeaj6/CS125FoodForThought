from flask import Response, request
from database.models import Food
from flask_restful import Resource
import json
import os
import markdown

# All foods
class AllFoods(Resource):
    def get(self):
        food = Food.objects().to_json()
        resp_dict = json.loads(food)
        return {
    			"success": True,
    			"count": len(resp_dict),
    			"data": resp_dict
    			}, 200

# Foods based on restaurant
class Restaurant(Resource):
    def get(self, restaurant):
        try:
            food = Food.objects(restaurant=restaurant).to_json()
            resp_dict = json.loads(food)
            return {
	    			"success": True,
	    			"count": len(resp_dict),
	    			"restaurant": restaurant,
	    			"data": resp_dict
	    			}, 200
        except Exception as e:
            raise e

# Foods based on keywords
class SearchFood(Resource):
    def post(self):
        try:
            body = request.json
            print(body)
            if body:
            	food = Food.objects(__raw__={ 
                                                '$text': {'$search' : body['query'] }
                                            }
                                    ).order_by('$text_score').to_json()
            	resp_dict = json.loads(food)
            	return {
            			"success": True,
            			"count": len(resp_dict),
            			"data": resp_dict
            			}, 200
            else:
            	return {"error": "Invalid Search"}, 400
        except Exception as e:
            raise e

# Recommendation System Route
class RecommendFood(Resource):
    def post(self):
        try:
            body = request.json
            #print(body)
            if body:
                recommendation_params = {}
                for filter_p in body.keys():
                    if filter_p == 'allergies' and len(body['allergies']) > 0:
                        # add check if any of the allergies given are in the dish
                        recommendation_params['allergies'] = {'$nin': body['allergies']}
                    elif filter_p == 'nutrition':
                        for n in body['nutrition'].keys():
                            # if it is a negative daily value set 0
                            if body['nutrition'][n] <= 0 or (n == 'protein' and body['nutrition'][n] < 10):
                                if n == 'protein':
                                    body['nutrition'][n] = 20 # anything sub 20 grams protein
                                else:
                                    body['nutrition'][n] = 0
                            recommendation_params['nutrition.'+n] = {'$lte': body['nutrition'][n]}
                    elif filter_p == 'budget':
                        recommendation_params['price'] = {'$lte': body['budget']}
                    elif filter_p == 'preferences' and len(body['preferences']) > 0:
                        recommendation_params['cuisine'] = {'$in': body['preferences']}
                    elif filter_p == 'breakfast':
                        recommendation_params['breakfast'] = {'$eq': body['breakfast']}
                #print(json.dumps(recommendation_params, indent=4))
                food = Food.objects(__raw__=recommendation_params).order_by('-nutrition.protein', '+nutrition.fat', '+nutrition.calories', '+nutrition.sodium', '+nutrition.sugar', '+nutrition.cholesterol', '+price').to_json()
                resp_dict = json.loads(food)
                #print(json.dumps(resp_dict, indent=4))
                return {
                        "success": True,
                        "count": len(resp_dict),
                        "data": resp_dict
                        }, 200
            else:
                return {"error": "Invalid Query"}, 400
        except Exception as e:
            raise e
