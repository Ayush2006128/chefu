import 'package:myapp/services/gemini.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/firestore.dart';
import '../../util/filter_chip_enum.dart';
import '../recipes/recipe_model.dart';
import 'prompt_model.dart';

class PromptViewModel extends ChangeNotifier {
  PromptViewModel({
    required this.multiModalModel,
    required this.textModel,
  });

  final GenerativeModel multiModalModel;
  final GenerativeModel textModel;
  bool loadingNewRecipe = false;

  PromptData userPrompt = PromptData.empty();
  TextEditingController promptTextController = TextEditingController();

  String badImageFailure =
      "The requested image does not contain hand writen problem.";

  Recipe? recipe;
  String? _geminiFailureResponse;
  String? get geminiFailureResponse => _geminiFailureResponse;
  set geminiFailureResponse(String? value) {
    _geminiFailureResponse = value;
    notifyListeners();
  }

  void notify() => notifyListeners();

  void addImage(XFile image) {
    userPrompt.images.insert(0, image);
    notifyListeners();
  }

  void addAdditionalPromptContext(String text) {
    final existingInputs = userPrompt.additionalTextInputs;
    userPrompt.copyWith(additionalTextInputs: [...existingInputs, text]);
  }

  void removeImage(XFile image) {
    userPrompt.images.removeWhere((el) => el.path == image.path);
    notifyListeners();
  }

  void resetPrompt() {
    userPrompt = PromptData.empty();
    notifyListeners();
  }

  // Creates an ephemeral prompt with additional text that the user shouldn't be
  // concerned with to send to Gemini, such as formatting.
  PromptData buildPrompt() {
    return PromptData(
      images: userPrompt.images,
      textInput: mainPrompt,
      basicsubjects: userPrompt.selectedBasicsubjects,
      questions: userPrompt.selectedquestions,
      detailLevel: userPrompt.selecteddetailLevel,
      additionalTextInputs: [format],
    );
  }

  Future<void> submitPrompt() async {
    loadingNewRecipe = true;
    notifyListeners();
    // Create an ephemeral PromptData, preserving the user prompt data without
    // adding the additional context to it.
    var model = userPrompt.images.isEmpty ? textModel : multiModalModel;
    final prompt = buildPrompt();

    try {
      final content = await GeminiService.generateContent(model, prompt);

      // handle no image or image of not-food
      if (content.text != null && content.text!.contains(badImageFailure)) {
        geminiFailureResponse = badImageFailure;
      } else {
        recipe = Recipe.fromGeneratedContent(content);
      }
    } catch (error) {
      geminiFailureResponse = 'Failed to reach Gemini. \n\n$error';
      if (kDebugMode) {
        print(error);
      }
      loadingNewRecipe = false;
    }

    loadingNewRecipe = false;
    resetPrompt();
    notifyListeners();
  }

  void saveRecipe() {
    FirestoreService.saveRecipe(recipe!);
  }

  void addBasicsubjects(Set<BasicsubjectsFilter> subjects) {
    userPrompt.selectedBasicsubjects.addAll(subjects);
    notifyListeners();
  }

  void addCategoryFilters(Set<questionFilter> categories) {
    userPrompt.selectedquestions.addAll(categories);
    notifyListeners();
  }

  void addDietaryRestrictionFilter(Set<detailLevelFilter> restrictions) {
    userPrompt.selecteddetailLevel.addAll(restrictions);
    notifyListeners();
  }

  String get mainPrompt {
    return '''
You are a freindly teacher.

I got stuck in this problem.
Help me in solving.
If there are no images attached, or if the image does not contain hand writen problems respond exactly with: $badImageFailure

Just give me the steps to solve.
The question is related to: ${userPrompt.questions},
Level of datail should be: ${userPrompt.detailLevel}
I got this problem following subject: ${userPrompt.subjects}

After providing the explaination, add an descriptions that creatively explains why this problem was easy or hard based on only the concepts used in this problem.  Give me a practice problem to solve similar to this.
Provide a summary of how many times the problems related to this topic appeared in the previos year JEE exam and the some other info.

${promptTextController.text.isNotEmpty ? promptTextController.text : ''}
''';
  }

  final String format = '''
Return the answer as valid JSON using the following structure:
{
  "id": \$uniqueId,
  "title": \$recipeTitle,
  "subjects": \$subjects,
  "description": \$description,
  "steps": \$steps,
  "question": \$questionType,
  "dificulty": \$dificulty,
  "formula": \$formula,
  "otherInfo": {
    "numOfVars": "\$numOfVars",
    "topic": "\$topic",
    "conceptsCoverd": "\$conceptsCoverd",
    "frequentInExams": "\$frequentInExams",
  },
}
  
uniqueId should be unique and of type String. 
title, description, question, dificulty, and formula should be of String type. 
subjects and steps should be of type List<String>.
otherInfo should be of type Map<String, String>.
''';
}
