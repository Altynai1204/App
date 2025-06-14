class Macronutrients {
  final int calories;
  final double proteins;
  final double fats;
  final double carbs;

  Macronutrients({
    required this.calories,
    required this.proteins,
    required this.fats,
    required this.carbs,
  });
}


Macronutrients calculateKcalAndMacros({
  required int age,
  required int height, // в см
  required int weight, // в кг
  required String gender, // 'male' или 'female'
  required double activityLevel, // от 1.2 до 1.7 и выше
  required String goal, // 'weight_loss', 'muscle_gain', 'maintenance', 'recomposition'
}) {
  // 1. Рассчитываем BMR (базальный обмен веществ) по формуле Миффлина-Сан Жеора
  double bmr;
  if (gender.toLowerCase() == 'female') {
    bmr = 10 * weight + 6.25 * height - 5 * age - 161;
  } else {
    bmr = 10 * weight + 6.25 * height - 5 * age + 5;
  }

  // 2. Умножаем BMR на коэффициент активности
  double tdee = bmr * activityLevel;

  // 3. Корректируем калории в зависимости от цели
  double adjustedCalories;
  switch (goal.toLowerCase()) {
    case 'weight_loss':
      adjustedCalories = tdee * 0.8; // минус 20%
      break;
    case 'muscle_gain':
      adjustedCalories = tdee * 1.2; // плюс 20%
      break;
    case 'recomposition':
      adjustedCalories = tdee; // без изменений
      break;
    case 'maintenance':
    default:
      adjustedCalories = tdee;
      break;
  }

  // 4. Задаем процентное распределение КБЖУ по цели
  double proteinPercent;
  double fatPercent;
  double carbPercent;

  switch (goal.toLowerCase()) {
    case 'weight_loss':
      proteinPercent = 0.40;
      fatPercent = 0.35;
      carbPercent = 0.25;
      break;
    case 'recomposition':
      proteinPercent = 0.35;
      fatPercent = 0.30;
      carbPercent = 0.35;
      break;
    case 'muscle_gain':
      proteinPercent = 0.30;
      fatPercent = 0.30;
      carbPercent = 0.40;
      break;
    case 'maintenance':
    default:
      proteinPercent = 0.30;
      fatPercent = 0.20;
      carbPercent = 0.50;
      break;
  }

  // 5. Рассчитываем граммы белков, жиров и углеводов
  double proteins = (adjustedCalories * proteinPercent) / 4;
  double fats = (adjustedCalories * fatPercent) / 9;
  double carbs = (adjustedCalories * carbPercent) / 4;

  return Macronutrients(
    calories: adjustedCalories.round(),
    proteins: proteins,
    fats: fats,
    carbs: carbs,
  );
}