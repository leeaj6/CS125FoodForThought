import requests
import json
import re

class McDonaldsCrawler():
	"""Grab McDonalds Nutrition and Pricing info via their APIs"""

	def __init__(self):
		self.menu_items = []

	def getItems(self) -> None:
		# Get Nutrition Info
		for categoryId in range(100000, 100009):
			r1 = requests.get(NUTRITION_ENDPOINT+str(categoryId), headers=REQUEST_HEADERS)

			dictionary = json.loads(r1.text)
			#print(json.dumps(dictionary, indent=4))

			print(str(categoryId), "Crawling...", r1.status_code)

			if len(dictionary['category']['items']) > 0:
				for item in dictionary['category']['items']['item']:
					item_info = {}
					# Parse Basic Info
					item_info['title'] = item['item_name']
					item_info['restaurant'] = RESTAURANT_TAG
					# Parse Allergens if available
					try: 
						item_info['allergies'] = re.sub('[^A-Za-z0-9 ]+', '', item['item_allergen'].split('.')[0]).split()
					except:
						item_info['allergies'] = []
					# Parse Nutritional Facts
					nutri_details = {}

					# Create dict for quick lookup
					if len(item['nutrient_facts']) > 0:
						nutrient_facts = {n['nutrient_name_id']: n['value'] for n in item['nutrient_facts']['nutrient']}
						nutri_details['calories'] = nutrient_facts['calories']
						nutri_details['protein'] = nutrient_facts['protein'] # standard grams unit
						nutri_details['carbs'] = nutrient_facts['carbohydrate'] # standard grams unit
						nutri_details['sugar'] = nutrient_facts['sugars'] # standard grams unit
						nutri_details['cholesterol'] = nutrient_facts['cholesterol'] # standard mg unit
						nutri_details['sodium'] = nutrient_facts['sodium'] # standard mg unit
						nutri_details['fiber'] = nutrient_facts['fibre'] # standard grams unit
						nutri_details['fat'] = nutrient_facts['fat'] # standard grams unit
						nutri_details['transFat'] = nutrient_facts['trans_fat'] # standard grams unit
						nutri_details['saturatedFat'] = nutrient_facts['saturated_fat'] # standard grams unit

						item_info['nutrition'] = nutri_details
						# Parse Extras
						try:
							item_info['image_url'] = 'https://www.mcdonalds.com/is/image/content/dam/usa/nfl/nutrition/items/hero/desktop/'+(item['attach_transparent_icon_image']['image_name'].replace('.png', '.jpg'))
						except:
							item_info['image_url'] = None
						self.menu_items.append(item_info)

		mongoDBQuery = self.exportQuery()

	def exportQuery(self) -> str:
		documents = json.dumps(self.menu_items, indent=4)
		query = f"""db.getCollection('{DB_COLLECTION}').insertMany({documents})"""
		with open(RESTAURANT_TAG+'-Query.txt', 'w') as fd:
			fd.write(query)
		return query


if __name__ == '__main__':
	RESTAURANT_TAG = 'MCD'

	REQUEST_HEADERS = {
					    'authority': 'www.mcdonalds.com',
					    'upgrade-insecure-requests': '1',
					    'user-agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.141 Safari/537.36',
					    'accept': 'application/json',
					    'sec-fetch-site': 'none',
					    'sec-fetch-mode': 'navigate',
					    'sec-fetch-dest': 'document',
					    'accept-language': 'en-US,en;q=0.9'
					  }
	NUTRITION_ENDPOINT = 'https://www.mcdonalds.com/wws/json/getCategoryDetails.htm?country=US&language=en&showLiveData=true&coopFilter=true&showNationalCoop=true&categoryId='
	PRICING_ENDPOINT = None

	DB_COLLECTION = 'food'

	McDonaldsCrawler().getItems()

		