# Food For Thought
![sample image](https://github.com/GurmanMannUCI/CS125FoodForThought/blob/main/Assets/previewed.png?raw=true)
An IOS application developed for a CS 125 class project. Built using Swift, Python, Flask, and MongoDB.

## Introduction
### Problem
* It’s hard to maintain a healthy and affordable lifestyle
* Other app options don’t account for a monetary budget

### Solution
* Food For Thought is an app that takes your nutritional and monetary budget into account when giving food recommendations

## Building a Personal Model
* Taking contextual inputs from the user
	* Allergies
	* Food Preferences
	* Budget
	* Health (Weight, Height, Age, Gender, Step Goal)
![Allergy Input](https://raw.githubusercontent.com/GurmanMannUCI/CS125FoodForThought/main/Assets/allergies_iphone12promaxpacificblue_portrait.png)
![Cuisine Input](https://github.com/GurmanMannUCI/CS125FoodForThought/blob/main/Assets/cuisines_iphone12promaxpacificblue_portrait.png?raw=true)
![Health Input](https://github.com/GurmanMannUCI/CS125FoodForThought/blob/main/Assets/health_iphone12promaxpacificblue_portrait.png?raw=true)

## Providing Recommendations
* Our recommendation API route takes a JSON payload, based on the user's personal model, that is updated throughout the day as the user consumes items
![Dashboard](https://raw.githubusercontent.com/GurmanMannUCI/CS125FoodForThought/main/Assets/dashboard-used_iphone12promaxpacificblue_portrait.png)
