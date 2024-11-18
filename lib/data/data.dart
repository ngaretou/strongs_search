import '../data/strongs_greek_dictionary.dart';
import '../data/strongs_hebrew_dictionary.dart';

// Map<String, Map<String, String>>
// Map<String, Map<String, String>>

class Strongs {
  String id;
  String xlit;
  String pron;
  String derivation;
  String strongsDef;
  String kjvDef;

  Strongs({
    required this.id,
    required this.xlit,
    required this.pron,
    required this.derivation,
    required this.strongsDef,
    required this.kjvDef,
  });

  factory Strongs.fromMap(Map<String, Map<String, String>> data) {
    var keys = data.keys;
    var values = data.values.first;

    return Strongs(
        id: keys.first,
        xlit: values['xlit']!,
        pron: values['pron']!,
        derivation: values['derivation']!,
        strongsDef: values['strongsDef']!,
        kjvDef: values['kjvDef']!);
  }
}

getData() async {
  Map<String, Map<String, String>> allEntries = {};

  allEntries.addAll(strongsHebrewDictionary);
  allEntries.addAll(strongsGreekDictionary);

  allEntries.forEach((k, v) => Strongs(
      id: k,
      xlit: v['xlit']!,
      pron: v['pron']!,
      derivation: v['derivation']!,
      strongsDef: v['strongsDef']!,
      kjvDef: v['kjvDef']!));
}
