import 'dart:math';

class Azbuka {
  final _random = new Random();
  late List<AzbukaItem> list;

  Azbuka() {
    list = [];
    list.add(new AzbukaItem("A", "a"));

    list.add(new AzbukaItem("Б", "B"));
    list.add(new AzbukaItem("б", "b"));

    list.add(new AzbukaItem("В", "V"));
//    list.add(new AzbukaItem("в", "v"));

    list.add(new AzbukaItem("Г", "g"));
//    list.add(new AzbukaItem("г", "g"));

    list.add(new AzbukaItem("Д", "D"));
//    list.add(new AzbukaItem("д", "d"));

    list.add(new AzbukaItem("Ё", "Jo"));
    list.add(new AzbukaItem("ё", "jo"));

    list.add(new AzbukaItem("Ж", "Ž"));
//    list.add(new AzbukaItem("ж", "ž"));

    list.add(new AzbukaItem("З", "Z"));
//    list.add(new AzbukaItem("з", "z"));

    list.add(new AzbukaItem("И", "I"));
//    list.add(new AzbukaItem("и", "i"));

    list.add(new AzbukaItem("Й", "J"));
//    list.add(new AzbukaItem("й", "j"));

    list.add(new AzbukaItem("Л", "L"));

    list.add(new AzbukaItem("Н", "N"));
//    list.add(new AzbukaItem("н", "n"));

    list.add(new AzbukaItem("П", "P"));
//    list.add(new AzbukaItem("п", "p"));

    list.add(new AzbukaItem("Р", "R"));
    list.add(new AzbukaItem("p", "r"));

    list.add(new AzbukaItem("С", "S"));
//    list.add(new AzbukaItem("c", "s"));

    list.add(new AzbukaItem("У", "U"));
//    list.add(new AzbukaItem("у", "u"));

    list.add(new AzbukaItem("Ф", "F"));
//    list.add(new AzbukaItem("ф", "f"));

    list.add(new AzbukaItem("X", "Ch"));
//    list.add(new AzbukaItem("x", "ch"));

    list.add(new AzbukaItem("Ц", "C"));
//    list.add(new AzbukaItem("ц", "c"));

    list.add(new AzbukaItem("Ч", "Č"));
//    list.add(new AzbukaItem("ч", "č"));

    list.add(new AzbukaItem("Ш", "Š"));
//    list.add(new AzbukaItem("ш", "š"));

    list.add(new AzbukaItem("Щ", "šč"));

    list.add(new AzbukaItem("Ы", "Y"));
//    list.add(new AzbukaItem("ы", "y"));

    list.add(new AzbukaItem("Э", "E"));
//    list.add(new AzbukaItem("э", "e"));

    list.add(new AzbukaItem("Ю", "Ju"));

    list.add(new AzbukaItem("Я", "Ja"));
  }

  AzbukaItem getRandom() {
    return list[_random.nextInt(list.length)];
  }
}

class AzbukaItem {
  final String _azbuka;
  final String _latin;

  AzbukaItem(this._azbuka, this._latin);

  String get latin => _latin;

  String get azbuka => _azbuka;
}
