#code gotten online, http client connection to spoonacular api using my rapid api key
import http.client
import json

def QueryData():
    #empty list of all the items
    menu_items = []
    conn = http.client.HTTPSConnection("spoonacular-recipe-food-nutrition-v1.p.rapidapi.com")
    
    headers = {
        'x-rapidapi-key': "27ef6c008fmsh051a1f772714affp14143cjsneccf3179bd5b",
        'x-rapidapi-host': "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com"
        }
    #connection get request query for coffee with optional parameters
    conn.request("GET", "/food/menuItems/search?query=Starbucks&offset=0&number=100&minCalories=0&maxCalories=5000&minProtein=0&maxProtein=100&minFat=0&maxFat=100&minCarbs=0&maxCarbs=100", headers=headers)
    
    #get response 
    res = conn.getresponse()
    #filter and turn data into a dictionary using json.loads
    data = json.loads(res.read().decode("utf-8"))
    
    #create empty id menu list.
    starbucks_id_list = []
    #go through each menu item that is a coffee
    for item in data["menuItems"]:
        #if menu item comes from restaurant Chain Starbucks, add id to id_list.
        if item["restaurantChain"] == "Starbucks":
            starbucks_id_list.append(item["id"])
    print(starbucks_id_list)
    #print(starbucks_id_list)
    #go through the list and make a menu item info request
    for id in starbucks_id_list:
        
        #empty dict of nutrient details
        nutri_details = dict()
        conn.request("GET", "/food/menuItems/"+str(id), headers=headers)
        #get response 
        res = conn.getresponse()
        #filter and turn data into a dictionary using json.loads
        data = json.loads(res.read().decode("utf-8"))
        nutrient_facts = data["nutrition"]["nutrients"]
        item_info = dict()
        item_info['title'] = data["title"]
        item_info['restaurant'] = "Starbucks"
        #change manually 
        item_info["cuisine"]= "American"
        item_info['allergies'] = []
        #list of nutrients, used in list
        nutrient_list = ["calories","protein","carbohydrates",
                         "sugar","sodium","fiber","trans fat",
                         "fat","saturated fat","cholesterol"]
        for nutrient_fact in nutrient_facts:
            #fact is in the nutrient list, add to nutrient detal
            if nutrient_fact["name"].lower() in nutrient_list:
                #cards treated as name carb
                if nutrient_fact['name'].lower() == "carbohydrates":
                    nutri_details['carbs'] = nutrient_fact['amount']
                else:
                    nutri_details[nutrient_fact['name'].lower()] = nutrient_fact['amount']
                item_info['nutrition'] = nutri_details
        if len(data['images']) > 0:
            item_info['image_url'] = data['images'][0]
        else:
            item_info['image_url'] = None
        item_info['price'] = data['price']
        print(item_info)
        menu_items.append(item_info)
    return menu_items
        

def exportQuery(menu_items) -> str:
        documents = json.dumps(menu_items, indent=4)
        query = f"""db.getCollection('{DB_COLLECTION}').insertMany({documents})"""
        with open("Starbucks"+'-Query.txt', 'w') as fd:
            fd.write(query)
        return query
    
if __name__ == "__main__":
    menu_items = QueryData()
    DB_COLLECTION = 'food'
    exportQuery(menu_items)
    
    