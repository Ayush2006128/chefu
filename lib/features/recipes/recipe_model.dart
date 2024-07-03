import 'dart:convert';

import 'package:myapp/util/json_parsing.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class Recipe {
  Recipe({
    required this.title,
    required this.id,
    required this.description,
    required this.subjects,
    required this.steps,
    required this.question,
    required this.dificulty,
    required this.formula,
    required this.otherInfo,
    this.rating = -1,
  });

  final String id;
  final String title;
  final String description;
  final List<String> subjects;
  final List<String> steps;
  final String question;
  final List<String> dificulty;
  final String formula;
  final Map<String, dynamic> otherInfo;
  int rating;

  factory Recipe.fromGeneratedContent(GenerateContentResponse content) {
    /// failures should be handled when the response is received
    assert(content.text != null);

    final validJson = cleanJson(content.text!);
    final json = jsonDecode(validJson);

    if (json
        case {
          "subjects": List<dynamic> subjects,
          "steps": List<dynamic> steps,
          "title": String title,
          "id": String id,
          "question": String question,
          "description": String description,
          "formula": String formula,
          "otherInfo": Map<String, dynamic> otherInfo,
          "dificulty": List<dynamic> dificulty,
        }) {
      return Recipe(
          id: id,
          title: title,
          subjects: subjects.map((i) => i.toString()).toList(),
          steps: steps.map((i) => i.toString()).toList(),
          otherInfo: otherInfo,
          dificulty: dificulty.map((i) => i.toString()).toList(),
          question: question,
          formula: formula,
          description: description);
    }

    throw JsonUnsupportedObjectError(json);
  }

  Map<String, Object?> toFirestore() {
    return {
      'id': id,
      'title': title,
      'steps': steps,
      'subjects': subjects,
      'question': question,
      'rating': rating,
      'dificulty': dificulty,
      'otherInfo': otherInfo,
      'formula': formula,
      'description': description,
    };
  }

  factory Recipe.fromFirestore(Map<String, Object?> data) {
    if (data
        case {
          "subjects": List<dynamic> subjects,
          "steps": List<dynamic> steps,
          "title": String title,
          "id": String id,
          "question": String question,
          "description": String description,
          "formula": String formula,
          "otherInfo": Map<String, dynamic> otherInfo,
          "dificulty": List<dynamic> dificulty,
          "rating": int rating
        }) {
      return Recipe(
        id: id,
        title: title,
        subjects: subjects.map((i) => i.toString()).toList(),
        steps: steps.map((i) => i.toString()).toList(),
        otherInfo: otherInfo,
        dificulty: dificulty.map((i) => i.toString()).toList(),
        question: question,
        formula: formula,
        description: description,
        rating: rating,
      );
    }

    throw "Malformed Firestore data";
  }
}
