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
      "The recipe request either does not contain images, or does not contain images of food items. I cannot recommend a recipe.";

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
      dietaryRestrictions: userPrompt.selectedDietaryRestrictions,
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

  void addDietaryRestrictionFilter(
      Set<DietaryRestrictionsFilter> restrictions) {
    userPrompt.selectedDietaryRestrictions.addAll(restrictions);
    notifyListeners();
  }

  String get mainPrompt {
    return '''
You are a rubber duck who is an teacher and JEE topper
Given an image of a problem related to engineering, STEM, or physics, chemistry, or maths
explain the problem but do not provide the solution.
you should only respond with the problem description.
and you can give me step by step instructions to solve the problem.
image should contain handwriting of the problem
${promptTextController.text.isNotEmpty ? promptTextController.text : ''}
''';
  }

  final String format = '''
Return the answer as valid JSON using the following structure:
{
  "id": \$uniqueId,
  "title": \$title,
  "subject": \$subject,
  "description": \$description,
  "steps": \$steps,
  "quetion": \$quetionType,
}
  
uniqueId should be unique and of type String.
title should be of type String.
subject should be of type String.
description should be of type String.
steps should be of type String.
quetionType should be of type String.
all should be UTF-16 encoded.
''';
}
