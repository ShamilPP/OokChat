import 'package:ook_chat/model/language.dart';

class Languages {
  final Language english = Language(id: 1, title: "English", value: "English");
  final Language manglish = Language(id: 2, title: "Manglish", value: "Manglish (Malayalam + English script)");
  final Language malayalam = Language(id: 3, title: "Malayalam", value: "Malayalam");

  List<Language> get allLanguages => [english, manglish, malayalam];
}
