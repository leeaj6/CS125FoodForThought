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
            if body:
            	food = Food.objects(__raw__={ '$text': {'$search' : body['query'] } }).to_json()
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

class RecommendFood(Resource):
    def post(self):
        try:
            body = request.json
            if body:
                recommendation_params = {}
                for filter_p in body.keys():
                    if filter_p == 'allergies':
                        recommendation_params['allergies'] = {'$nin': body['allergies']}
                    elif filter_p == 'nutrition':
                        for n in body['nutrition'].keys():
                            recommendation_params['nutrition.'+n] = {'$lte': body['nutrition'][n]}
                    elif filter_p == 'budget':
                        recommendation_params['price'] = {'$lte': body['budget']}
                    elif filter_p == 'preferences':
                        recommendation_params['cuisine'] = {'$in': body['preferences']}
                    elif filter_p == 'breakfast':
                        recommendation_params['breakfast'] = {'$eq': body['breakfast']}
                food = Food.objects(__raw__=recommendation_params).to_json()
                resp_dict = json.loads(food)
                return {
                        "success": True,
                        "count": len(resp_dict),
                        "data": resp_dict
                        }, 200
            else:
                return {"error": "Invalid Query"}, 400
        except Exception as e:
            raise e
