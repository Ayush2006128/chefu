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

enum detailLevelFilter {
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

String dietaryRestrictionReadable(detailLevelFilter filter) {
  return switch (filter) {
    detailLevelFilter.vegan => 'vegan',
    detailLevelFilter.vegetarian => 'vegetarian',
    detailLevelFilter.lactoseIntolerant => 'dairy free',
    detailLevelFilter.kosher => 'kosher',
    // detailLevelFilter.keto => 'low carb',
    detailLevelFilter.wheatAllergies => 'wheat allergy',
    detailLevelFilter.nutAllergies => 'nut allergy',
    detailLevelFilter.fishAllergies => 'fish allergy',
    detailLevelFilter.soyAllergies => 'soy allergy',
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
