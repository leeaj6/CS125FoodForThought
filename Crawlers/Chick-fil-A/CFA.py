import requests
import json
import re

class ChickFilACrawler():
	"""Grab Chick-Fil-A Nutrition and Pricing info via their mobile application APIs"""

	def __init__(self):
		self.menu_items = []

		self.item_ids = set() # keep track of duplicates since CFA considers sauces as individual and allacart

	def getItems(self) -> None:
		# Get Nutrition Info
		r1 = requests.get(NUTRITION_ENDPOINT, headers=REQUEST_HEADERS)

		dictionary = json.loads(r1.text)

		tagged = {}

		for item in dictionary['items']:
			if item['retailModifiedItemId'] not in self.item_ids:
				item_info = {}
				# Parse Basic Info
				item_info['title'] = item['name']
				item_info['restaurant'] = RESTAURANT_TAG
				# Parse Allergens if available
				try: 
					item_info['allergies'] = re.sub('[^A-Za-z0-9 ]+', '', item['allergenStatement']).split()[1:]
				except:
					item_info['allergies'] = []
				# Parse Nutritional Facts
				nutri_details = {}
				nutri_details['calories'] = item['nutrition']['calories']['total']
				nutri_details['protein'] = item['nutrition']['protein']['amount']['count'] # standard grams unit
				nutri_details['carbs'] = item['nutrition']['carbs']['amount']['count'] # standard grams unit
				nutri_details['sugar'] = item['nutrition']['sugar']['amount']['count'] # standard grams unit
				nutri_details['cholesterol'] = item['nutrition']['cholesterol']['amount']['count'] # standard mg unit
				nutri_details['sodium'] = item['nutrition']['sodium']['amount']['count'] # standard mg unit
				nutri_details['fiber'] = item['nutrition']['fiber']['amount']['count'] # standard grams unit
				nutri_details['fat'] = item['nutrition']['fat']['total']['amount']['count'] # standard grams unit
				nutri_details['transFat'] = item['nutrition']['fat']['transFat']['amount']['count'] # standard grams unit
				nutri_details['saturatedFat'] = item['nutrition']['fat']['saturatedFat']['amount']['count'] # standard grams unit
				item_info['nutrition'] = nutri_details
				# Parse Extras
				try:
					item_info['image_url'] = item['mobileImage'].replace('.webp', '.png')
				except:
					item_info['image_url'] = None
				self.item_ids.add(item['retailModifiedItemId'])
				tagged[item['tag']] = item_info
		# Get Pricing Info
		r2 = requests.get(PRICING_ENDPOINT, headers=REQUEST_HEADERS)

		dictionary = json.loads(r2.text)

		all_items = []

		for i in dictionary['categories']:
			all_items+=i['items']

		for i in dictionary['itemGroups']:
			all_items+=i['items']

		for item in all_items:
			tag = item['tag']
			if tag in tagged:
				current_item = tagged[tag]
				current_item['price'] = item['itemPrice']
				self.menu_items.append(current_item)

		#print(json.dumps(dictionary, indent=4))

		mongoDBQuery = self.exportQuery()

		#print(mongoDBQuery)

	def exportQuery(self) -> str:
		documents = json.dumps(self.menu_items, indent=4)
		query = f"""db.getCollection('{DB_COLLECTION}').insertMany({documents})"""
		with open(RESTAURANT_TAG+'-Query.txt', 'w') as fd:
			fd.write(query)
		return query


if __name__ == '__main__':
	RESTAURANT_TAG = 'CFA'

	REQUEST_HEADERS = {
					    'authority': 'order.api.my.chick-fil-a.com',
					    'upgrade-insecure-requests': '1',
					    'user-agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.141 Safari/537.36',
					    'accept': 'application/json',
					    'sec-fetch-site': 'none',
					    'sec-fetch-mode': 'navigate',
					    'sec-fetch-dest': 'document',
					    'accept-language': 'en-US,en;q=0.9'
					  }
	NUTRITION_ENDPOINT = 'https://order.api.my.chick-fil-a.com/orders/2.0/menu/client/nutrition'
	PRICING_ENDPOINT = 'https://order.api.my.chick-fil-a.com/orders/locations/3.1/03260/menu/client/individual'

	DB_COLLECTION = 'food'

	ChickFilACrawler().getItems()

		