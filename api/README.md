# Food for Thought API Docs

### List All Foods (Example is truncated)

**Definition**

`GET /api/v1/foods`

**Response**

- `200 OK` on success

```json
{
    "success": true,
    "count": 291,
    "data": [
        {
            "_id": {
                "$oid": "600e6c2287995719ada449f2"
            },
            "title": "Chick-fil-A® Chicken Biscuit",
            "restaurant": "CFA",
            "breakfast": true,
            "cuisine": [
                "American",
                "Fast Food"
            ],
            "allergies": [
                "Egg",
                "Milk",
                "Soy",
                "Wheat"
            ],
            "nutrition": {
                "calories": 460,
                "protein": 19,
                "carbs": 45,
                "sugar": 6,
                "cholesterol": 45,
                "sodium": 1510,
                "fiber": 2,
                "fat": 23,
                "transFat": 0,
                "saturatedFat": 8
            },
            "image_url": "https://www.cfacdn.com/img/order/menu/Mobile/Breakfast/Menu%20Item/Edited_400x280/ChickenBiscuit_mobile.png",
            "price": 3.19
        }
    ]
}
```

### List All Foods From A Restaurant (Example is truncated)

**Definition**

`GET /api/v1/foods/restaurant/<string:restaurant>`

**Response**

- `200 OK` on success

```json
{
    "success": true,
    "count": 4,
    "restaurant": "CFG",
    "data": [
        {
            "_id": {
                "$oid": "600e72dc87995719ada44b11"
            },
            "title": "Atlantic Salmon",
            "restaurant": "CFG",
            "breakfast": false,
            "cuisine": [
                "American",
                "Seafood"
            ],
            "allergies": [
                "Fish"
            ],
            "nutrition": {
                "calories": 340,
                "protein": 22,
                "carbs": 0,
                "sugar": 0,
                "cholesterol": 130,
                "sodium": 360,
                "fiber": 0,
                "fat": 13,
                "transFat": 0,
                "saturatedFat": 3
            },
            "image_url": null,
            "price": 12.79
        }
    ]
}
```

## Search Foods By Keywords

`POST /api/v1/foods/search`

**Request JSON Body**

```json
    {"query": "box combo"}
```

**Response**

- `400` if no JSON payload
- `200 OK` on success

```json
{
    "success": true,
    "count": 6,
    "data": [
        {
            "_id": {
                "$oid": "600e6cdb87995719ada44b0c"
            },
            "title": "Box Combo",
            "restaurant": "RAC",
            "breakfast": false,
            "cuisine": [
                "American",
                "Fast Food"
            ],
            "allergies": [
                "Egg",
                "Fish",
                "Milk",
                "Soy",
                "Wheat"
            ],
            "nutrition": {
                "calories": 1250,
                "protein": 61,
                "carbs": 97,
                "sugar": 16,
                "cholesterol": 170,
                "sodium": 2130,
                "fiber": 0,
                "fat": 68,
                "transFat": 0.5,
                "saturatedFat": 11
            },
            "image_url": null,
            "price": 8.35
        },
        {
            "_id": {
                "$oid": "600e6cdb87995719ada44b0d"
            },
            "title": "Caniac Combo",
            "restaurant": "RAC",
            "breakfast": false,
            "cuisine": [
                "American",
                "Fast Food"
            ],
            "allergies": [
                "Egg",
                "Fish",
                "Milk",
                "Soy",
                "Wheat"
            ],
            "nutrition": {
                "calories": 1790,
                "protein": 89,
                "carbs": 124,
                "sugar": 21,
                "cholesterol": 255,
                "sodium": 3160,
                "fiber": 0,
                "fat": 104,
                "transFat": 1,
                "saturatedFat": 16
            },
            "image_url": null,
            "price": 12.53
        },
        {
            "_id": {
                "$oid": "600e6cdb87995719ada44b0a"
            },
            "title": "Kids Combo",
            "restaurant": "RAC",
            "breakfast": false,
            "cuisine": [
                "American",
                "Fast Food"
            ],
            "allergies": [
                "Egg",
                "Fish",
                "Milk",
                "Soy",
                "Wheat"
            ],
            "nutrition": {
                "calories": 630,
                "protein": 29,
                "carbs": 38,
                "sugar": 5,
                "cholesterol": 85,
                "sodium": 1100,
                "fiber": 0,
                "fat": 40,
                "transFat": 0,
                "saturatedFat": 6
            },
            "image_url": null,
            "price": 4.99
        },
        {
            "_id": {
                "$oid": "600e72dc87995719ada44b12"
            },
            "title": "Salmon & Swai Combo",
            "restaurant": "CFG",
            "breakfast": false,
            "cuisine": [
                "American",
                "Seafood"
            ],
            "allergies": [
                "Fish"
            ],
            "nutrition": {
                "calories": 330,
                "protein": 22,
                "carbs": 2,
                "sugar": 0,
                "cholesterol": 140,
                "sodium": 720,
                "fiber": 0,
                "fat": 11,
                "transFat": 0,
                "saturatedFat": 3
            },
            "image_url": null,
            "price": 12.29
        },
        {
            "_id": {
                "$oid": "600e6cdb87995719ada44b0e"
            },
            "title": "Chicken Sandwich Combo",
            "restaurant": "RAC",
            "breakfast": false,
            "cuisine": [
                "American",
                "Fast Food"
            ],
            "allergies": [
                "Egg",
                "Fish",
                "Milk",
                "Soy",
                "Wheat"
            ],
            "nutrition": {
                "calories": 1080,
                "protein": 52,
                "carbs": 103,
                "sugar": 13,
                "cholesterol": 120,
                "sodium": 1700,
                "fiber": 0,
                "fat": 54,
                "transFat": 0.5,
                "saturatedFat": 8
            },
            "image_url": null,
            "price": 7.42
        },
        {
            "_id": {
                "$oid": "600e6cdb87995719ada44b0b"
            },
            "title": "3 Finger Combo",
            "restaurant": "RAC",
            "breakfast": false,
            "cuisine": [
                "American",
                "Fast Food"
            ],
            "allergies": [
                "Egg",
                "Fish",
                "Milk",
                "Soy",
                "Wheat"
            ],
            "nutrition": {
                "calories": 1020,
                "protein": 47,
                "carbs": 81,
                "sugar": 9,
                "cholesterol": 125,
                "sodium": 1640,
                "fiber": 0,
                "fat": 56,
                "transFat": 0.5,
                "saturatedFat": 9
            },
            "image_url": null,
            "price": 7.42
        }
    ]
}
```

## Food Recommendation

`POST /api/v1/foods/recommendations`

**Request JSON Body**

```json
    {
        "allergies": ["Egg", "Milk", "Wheat"],
        "budget": 9.0,
        "preferences": ["Mexican"],
        "nutrition": {
            "calories": 200
        },
        "breakfast": true
    }
```

**Response**

- `400` if Invalid Query
- `200 OK` on success

```json
{
    "success": true,
    "count": 1,
    "data": [
        {
            "_id": {
                "$oid": "60301d7926af4af5952982d6"
            },
            "title": "Hash Brown",
            "restaurant": "TacoBell",
            "breakfast": true,
            "cuisine": [
                "Mexican",
                "Fast Food"
            ],
            "allergies": [],
            "nutrition": {
                "calories": 160,
                "protein": 1,
                "carbs": 13,
                "sugar": 0,
                "cholesterol": 0,
                "sodium": 270,
                "fiber": 2,
                "fat": 12,
                "transFat": 0,
                "saturatedFat": 1
            },
            "image_url": null,
            "price": 1.29
        }
    ]
}
```
