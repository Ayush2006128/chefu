import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/util/filter_chip_enum.dart';

class PromptData {
  PromptData({
    required this.images,
    required this.textInput,
    Set<BasicsubjectsFilter>? basicsubjects,
    Set<questionFilter>? questions,
    Set<DietaryRestrictionsFilter>? dietaryRestrictions,
    List<String>? additionalTextInputs,
  })  : additionalTextInputs = additionalTextInputs ?? [],
        selectedBasicsubjects = basicsubjects ?? {},
        selectedquestions = questions ?? {},
        selectedDietaryRestrictions = dietaryRestrictions ?? {};

  PromptData.empty()
      : images = [],
        additionalTextInputs = [],
        selectedBasicsubjects = {},
        selectedquestions = {},
        selectedDietaryRestrictions = {},
        textInput = '';

  String get questions {
    return selectedquestions.map((catFilter) => catFilter.name).join(",");
  }

  String get subjects {
    return selectedBasicsubjects
        .map((ingredient) => ingredient.name)
        .join(", ");
  }

  String get dietaryRestrictions {
    return selectedDietaryRestrictions
        .map((restriction) => restriction.name)
        .join(", ");
  }

  List<XFile> images;
  String textInput;
  List<String> additionalTextInputs;
  Set<BasicsubjectsFilter> selectedBasicsubjects;
  Set<questionFilter> selectedquestions;
  Set<DietaryRestrictionsFilter> selectedDietaryRestrictions;

  PromptData copyWith({
    List<XFile>? images,
    String? textInput,
    List<String>? additionalTextInputs,
    Set<BasicsubjectsFilter>? basicsubjects,
    Set<questionFilter>? questionSelections,
    Set<DietaryRestrictionsFilter>? dietaryRestrictions,
  }) {
    return PromptData(
      images: images ?? this.images,
      textInput: textInput ?? this.textInput,
      additionalTextInputs: additionalTextInputs ?? this.additionalTextInputs,
      basicsubjects: basicsubjects ?? selectedBasicsubjects,
      questions: questionSelections ?? selectedquestions,
      dietaryRestrictions: dietaryRestrictions ?? selectedDietaryRestrictions,
    );
  }
}
