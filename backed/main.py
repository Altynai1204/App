import requests
from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)
API_KEY = "2ecbb41246b64a1cb8fd828f3832962f"

MEAL_SPLIT = {
    "breakfast": 0.25,
    "snack1": 0.10,
    "lunch": 0.30,
    "snack2": 0.10,
    "dinner": 0.25,
}

def get_recipes_for_meal(user_data, max_calories, max_proteins, max_fats, max_carbs, number=5):
    diet = user_data.get("diet", "")
    allergies = user_data.get("allergies", "").replace(" ", "")

    url = "https://api.spoonacular.com/recipes/complexSearch"
    params = {
        "number": number,
        "addRecipeNutrition": True,
        "diet": diet,
        "intolerances": allergies,
        "maxCalories": int(max_calories * 1.1),
        "apiKey": API_KEY
    }

    response = requests.get(url, params=params)
    data = response.json()
    results = data.get("results", [])

    suitable_recipes = []
    for recipe in results:
        nutrients = recipe.get("nutrition", {}).get("nutrients", [])
        cal = next((n for n in nutrients if n["name"] == "Calories"), {"amount": 0})["amount"]
        prot = next((n for n in nutrients if n["name"] == "Protein"), {"amount": 0})["amount"]
        fat = next((n for n in nutrients if n["name"] == "Fat"), {"amount": 0})["amount"]
        carb = next((n for n in nutrients if n["name"] == "Carbohydrates"), {"amount": 0})["amount"]

        if (
            cal <= max_calories * 1.2 and
            prot <= max_proteins * 1.2 and
            fat <= max_fats * 1.2 and
            carb <= max_carbs * 1.2
        ):
            suitable_recipes.append({
                "title": recipe["title"],
                "calories": round(cal, 1),
                "protein": round(prot, 1),
                "fat": round(fat, 1),
                "carbs": round(carb, 1),
                "image": recipe.get("image", "")
            })

    return suitable_recipes[:3]  # отдаем максимум 3 варианта

@app.route("/plan", methods=["POST"])
def plan():
    user_data = request.get_json()
    total_calories = user_data.get("calories", 2000)
    total_proteins = user_data.get("proteins", 100)
    total_fats = user_data.get("fats", 70)
    total_carbs = user_data.get("carbs", 250)

    plan_5_days = []
    for day in range(5):
        day_plan = {}
        for meal, fraction in MEAL_SPLIT.items():
            cal_target = total_calories * fraction
            prot_target = total_proteins * fraction
            fat_target = total_fats * fraction
            carb_target = total_carbs * fraction

            recipes = get_recipes_for_meal(user_data, cal_target, prot_target, fat_target, carb_target, number=5)
            day_plan[meal] = recipes if recipes else []
        plan_5_days.append(day_plan)

    return jsonify({"5_day_plan": plan_5_days})

if __name__ == "__main__":
    app.run(debug=True)

