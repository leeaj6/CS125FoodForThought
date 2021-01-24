# Food for Thought API Docs

### List All Foods

**Definition**

`GET /api/v1/foods`

**Response**

- `200 OK` on success

```json
{
    "success": true,
    "count": 11,
    "data": [
        {
            "_id": {
                "$oid": "600ceff0ca6f77a343750c34"
            },
            "title": "Individual Chicken Finger",
            "restaurant": "RAC",
            "allergies": [
                "Eggs",
                "Milk",
                "Wheat"
            ],
            "nutrition": {
                "calories": 130,
                "protein": 13,
                "carbs": 5,
                "sugar": 0,
                "cholesterol": 40,
                "sodium": 190,
                "fiber": 0,
                "fat": 6,
                "transFat": 0,
                "saturatedFat": 1
            },
            "image_url": null,
            "price": 1.39
        }
    ]
}
```

### List All Foods From A Restaurant

**Definition**

`GET /api/v1/foods/restaurant/<string:restaurant>`

**Response**

- `200 OK` on success

```json
{
    "success": true,
    "count": 11,
    "restaurant": "RAC",
    "data": [
        {
            "_id": {
                "$oid": "600ceff0ca6f77a343750c34"
            },
            "title": "Individual Chicken Finger",
            "restaurant": "RAC",
            "allergies": [
                "Eggs",
                "Milk",
                "Wheat"
            ],
            "nutrition": {
                "calories": 130,
                "protein": 13,
                "carbs": 5,
                "sugar": 0,
                "cholesterol": 40,
                "sodium": 190,
                "fiber": 0,
                "fat": 6,
                "transFat": 0,
                "saturatedFat": 1
            },
            "image_url": null,
            "price": 1.39
        }
        ...
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
    "count": 5,
    "data": [
        {
            "_id": {
                "$oid": "600ceff0ca6f77a343750c3c"
            },
            "title": "Box Combo",
            "restaurant": "RAC",
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
                "$oid": "600ceff0ca6f77a343750c3d"
            },
            "title": "Caniac Combo",
            "restaurant": "RAC",
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
                "$oid": "600ceff0ca6f77a343750c3a"
            },
            "title": "Kids Combo",
            "restaurant": "RAC",
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
                "$oid": "600ceff0ca6f77a343750c3e"
            },
            "title": "Chicken Sandwich Combo",
            "restaurant": "RAC",
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
                "$oid": "600ceff0ca6f77a343750c3b"
            },
            "title": "3 Finger Combo",
            "restaurant": "RAC",
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