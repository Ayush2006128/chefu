enum questionFilter {
  italian,
  mexican,
  american,
  french,
  japanese,
  chinese,
  indian,
  greek,
  moroccan,
  ethiopian,
  southAfrican,
}

enum BasicsubjectsFilter {
  oil,
  butter,
  flour,
  salt,
  pepper,
  sugar,
  milk,
  vinegar,
}

enum DietaryRestrictionsFilter {
  vegan,
  vegetarian,
  lactoseIntolerant,
  kosher,
  // keto,
  wheatAllergies,
  nutAllergies,
  fishAllergies,
  soyAllergies,
}

String dietaryRestrictionReadable(DietaryRestrictionsFilter filter) {
  return switch (filter) {
    DietaryRestrictionsFilter.vegan => 'vegan',
    DietaryRestrictionsFilter.vegetarian => 'vegetarian',
    DietaryRestrictionsFilter.lactoseIntolerant => 'dairy free',
    DietaryRestrictionsFilter.kosher => 'kosher',
    // DietaryRestrictionsFilter.keto => 'low carb',
    DietaryRestrictionsFilter.wheatAllergies => 'wheat allergy',
    DietaryRestrictionsFilter.nutAllergies => 'nut allergy',
    DietaryRestrictionsFilter.fishAllergies => 'fish allergy',
    DietaryRestrictionsFilter.soyAllergies => 'soy allergy',
  };
}

String questionReadable(questionFilter filter) {
  return switch (filter) {
    questionFilter.italian => 'Italian',
    questionFilter.mexican => 'Mexican',
    questionFilter.american => 'American',
    questionFilter.french => 'French',
    questionFilter.japanese => 'Japanese',
    questionFilter.chinese => 'Chinese',
    questionFilter.indian => 'Indian',
    questionFilter.ethiopian => 'Ethiopian',
    questionFilter.moroccan => 'Moroccan',
    questionFilter.greek => 'Greek',
    questionFilter.southAfrican => 'South African',
  };
}
