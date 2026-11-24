class LetterWord {
  final String id;
  final String title;

  const LetterWord({required this.id, required this.title});
}

class Alphabets {
  String name;
  String smallName;
  String sound;
  String image1;
  String image1Title;
  String image2;
  String image2Title;
  String image3;
  String image3Title;
  String image4;
  String image4Title;

  Alphabets(
      {required this.name,
      required this.smallName,
      required this.sound,
      required this.image1,
      required this.image1Title,
      required this.image2,
      required this.image2Title,
      required this.image3,
      required this.image3Title,
      required this.image4,
      required this.image4Title});

  List<LetterWord> get words {
    return [
      LetterWord(id: image1, title: image1Title),
      LetterWord(id: image2, title: image2Title),
      LetterWord(id: image3, title: image3Title),
      LetterWord(id: image4, title: image4Title),
    ].where((word) => word.id.isNotEmpty || word.title.isNotEmpty).toList();
  }
}
