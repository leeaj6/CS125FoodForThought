from .db import db

"""
Example Model
    {
        "title": "Hand Tossed Crust: Pepperoni Pizza (Large 1 Slice)",
        "restaurant": "DOM",
        "breakfast": false,
        "cuisine": [
            "Pizza", 
            "Italian", 
            "Fast Food"
        ],
        "allergies": [
            "Milk",
            "Wheat"
        ],
        "nutrition": {
            "calories": 300.0,
            "protein": 12.0,
            "carbs": 34.0,
            "sugar": 3.0,
            "cholesterol": 30.0,
            "sodium": 700.0,
            "fiber": 2.0,
            "fat": 12.5,
            "transFat": 0.0,
            "saturatedFat": 5.5
        },
        "image_url": null,
        "price": 1.39
    }
"""

class Nutrition(db.EmbeddedDocument):
	calories = db.FloatField(required=True, unique=False)
	protein = db.FloatField(required=True, unique=False)
	carbs = db.FloatField(required=True, unique=False)
	sugar = db.FloatField(required=True, unique=False)
	cholesterol = db.FloatField(required=True, unique=False)
	sodium = db.FloatField(required=True, unique=False)
	fiber = db.FloatField(required=True, unique=False)
	fat = db.FloatField(required=True, unique=False)
	transFat = db.FloatField(required=True, unique=False)
	saturatedFat = db.FloatField(required=True, unique=False)

class Food(db.Document):
    title = db.StringField(required=True, unique=False)
    restaurant = db.StringField(required=True, unique=False)
    breakfast = db.BooleanField(required=True, unique=False)
    cuisine = db.ListField(db.StringField(), required=True)
    allergies = db.ListField(db.StringField(), required=True)
    nutrition = db.EmbeddedDocumentField(Nutrition)
    image_url = db.StringField(required=False, unique=False)
    price = db.FloatField(required=False, unique=False)
