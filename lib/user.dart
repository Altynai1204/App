class User {
  final int age;
  final int height;
  final int weight;
  final String gender;
  final double activityLevel;
  final String goal;
  final String diet;
  final String allergies;
  final int calories;
  final double proteins;
  final double fats;
  final double carbs;

  User({
    required this.age,
    required this.height,
    required this.weight,
    required this.gender,
    required this.activityLevel,
    required this.goal,
    required this.diet,
    required this.allergies,
    required this.calories,
    required this.proteins,
    required this.fats,
    required this.carbs,
  });

  Map<String, dynamic> toJson() => {
        "age": age,
        "height": height,
        "weight": weight,
        "gender": gender,
        "activityLevel": activityLevel,
        "goal": goal,
        "diet": diet,
        "allergies": allergies,
        "calories": calories,
        "proteins": proteins,
        "fats": fats,
        "carbs": carbs,
      };
}
