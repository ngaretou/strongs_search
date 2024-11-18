import 'package:flutter/foundation.dart';
import '../data/strongs_greek_dictionary.dart';
import '../data/strongs_hebrew_dictionary.dart';

// Map<String, Map<String, String>>
// Map<String, Map<String, String>>

class Strongs {
  String id;
  String lemma;
  String lang;
  String? xlit;
  String? pron;
  String? derivation;
  String? strongsDef;
  String? kjvDef;

  Strongs({
    required this.id,
    required this.lemma,
    required this.lang,
    this.xlit,
    this.pron,
    this.derivation,
    this.strongsDef,
    this.kjvDef,
  });
}

Future<List<Strongs>> getData() async {
  List<Strongs> returnMe = [];

  // hebrew
  try {
    strongsHebrewDictionary.forEach((k, v) {
      var strong = Strongs(
          id: k,
          lemma: v['lemma']!,
          lang: 'Heb',
          xlit: v['xlit'],
          pron: v['pron'],
          derivation: v['derivation'],
          strongsDef: v['strongs_def'],
          kjvDef: v['kjv_def']);
      returnMe.add(strong);
    });
  } catch (e) {
    debugPrint(e.toString());
  }

  // "H2":{"lemma":"אַב","xlit":"ʼab","pron":"ab","derivation":"(Aramaic) corresponding to H1 (אָב)","strongs_def":"{father}","kjv_def":"father."},

  // greek

  try {
    strongsGreekDictionary.forEach((k, v) {
      var strong = Strongs(
          id: k,
          lemma: v['lemma']!,
          lang: 'Grk',
          xlit: v['translit'],
          pron: v['pron'],
          derivation: v['derivation'],
          strongsDef: v['strongs_def'],
          kjvDef: v['kjv_def']);
      returnMe.add(strong);
    });
  } catch (e) {
    debugPrint(e.toString());
  }

  // "strongs_def":" to complete fully","derivation":"from G1537 (ἐκ) and G5055 (τελέω);","translit":"ekteléō","lemma":"ἐκτελέω","kjv_def":"finish"

  return returnMe;
}
