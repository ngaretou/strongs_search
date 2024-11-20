import 'package:flutter/material.dart';
import '../data/data.dart';
import 'package:url_launcher/url_launcher.dart';

// Main body view, mainly a pageview builder
class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  TextEditingController freeTextSearchController = TextEditingController();

  List<Strongs> allStrongs = [];
  List<Strongs> results = [];

  String searchType = 'start'; // middle or end
  String searchScript = 'xlit'; // or orig
  String searchLang = 'both'; // heb or grk

  bool showResults = false;
  // PageController pageController = PageController();
  final formKey = GlobalKey<FormState>();
  late Future<List<Strongs>> datainit;
  // int? currentIndex;

  @override
  void initState() {
    datainit = getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void search() async {
      // first beginning, middle, or end of word:
      String txt = '';
      switch (searchType) {
        case 'start':
          txt = '\\b${freeTextSearchController.value.text}';
          break;
        case 'middle':
          txt = '\\B${freeTextSearchController.value.text}\\B';
          break;
        case 'end':
          txt = '${freeTextSearchController.value.text}\\b';
          break;
        default:
      }

      RegExp search = RegExp(txt);

      results.clear();

      List<Strongs> tempresults = [];

      // choose whether we're searching transliterated or original script
      switch (searchScript) {
        case 'xlit':
          tempresults = allStrongs.where((strong) {
            final unaccentedSearchString = removeAccents(strong.xlit!);
            return search.hasMatch(unaccentedSearchString);
          }).toList();
          break;
        case 'orig':
          tempresults = allStrongs.where((strong) {
            final unaccentedSearchString = removeAccents(strong.lemma);
            return search.hasMatch(unaccentedSearchString);
          }).toList();
          break;
        default:
      }

      // intermediate results
      results.addAll(tempresults);

      // now filter by language if necessary
      switch (searchLang) {
        case 'both':
          break;
        case 'heb':
          results.removeWhere((strongs) => strongs.lang == 'Grk');
          break;
        case 'grk':
          results.removeWhere((strongs) => strongs.lang == 'Heb');
          break;
        default:
      }

      setState(() {});
    }

    strongTile(Strongs strong) {
      var heading = Theme.of(context).textTheme.headlineSmall;
      return GestureDetector(
        onTap: () async {
          String lang = '';
          String num = strong.id.substring(1);

          if (strong.lang == 'Heb') {
            lang = 'hebrew';
          } else {
            lang = 'greek';
          }

          String url = 'https://biblehub.com/$lang/$num.htm';
          if (await canLaunchUrl(Uri.parse(url))) {
            await launchUrl(Uri.parse(url), mode: LaunchMode.platformDefault);
          } else {
            throw 'Could not launch $url';
          }
        },
        child: Card(
          color: Theme.of(context).colorScheme.tertiaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SizedBox(
                  width: 250,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (strong.xlit != null)
                        Text(
                          strong.xlit!,
                          style: heading,
                        ),
                      const SizedBox(height: 10),
                      Text(strong.lemma, style: heading),
                    ],
                  ),
                ),
                SizedBox(
                  width: 40,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (strong.strongsDef != null)
                        (Text(
                          'Strong\'s definition:',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .copyWith(fontStyle: FontStyle.italic),
                        )),
                      if (strong.strongsDef != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, bottom: 12),
                          child: (Text(strong.strongsDef!)),
                        ),
                      if (strong.kjvDef != null)
                        (Text(
                          'KJV definition:',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .copyWith(fontStyle: FontStyle.italic),
                        )),
                      if (strong.kjvDef != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: (Text(strong.kjvDef!)),
                        )
                    ],
                  ),
                ),
                SizedBox(
                  width: 40,
                ),
                Column(
                  children: [
                    Text(strong.id),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    }

    return Expanded(
        child: ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(10),
        // bottomLeft: Radius.circular(10),
      ),
      child: Container(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: FutureBuilder(
                    future: datainit,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        allStrongs.clear();
                        allStrongs.addAll(snapshot.data!);
                        return Column(
                          children: [
                            SizedBox(height: 20),
                            Form(
                              key: formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // FilledButton(
                                      //     onPressed: () {
                                      //       List<String> charsinmap = [];
                                      //       // get existing chars in map
                                      //       accentsMap.forEach((k, v) {
                                      //         charsinmap.add(k);
                                      //         charsinmap.add(v);
                                      //       });
                                      //       Set<String> charsinmaptoset =
                                      //           charsinmap.toSet();
                                      //       List<String> listchars =
                                      //           charsinmaptoset.toList();

                                      //       // now get all chars in the transliterations
                                      //       List<String> allcharsinstrongs = [];
                                      //       for (var strong in allStrongs) {
                                      //         allcharsinstrongs.addAll(
                                      //             strong.xlit!.characters);
                                      //       }
                                      //       Set<String> allcharsinstrongsset =
                                      //           allcharsinstrongs.toSet();
                                      //       List<String> liststrongs =
                                      //           allcharsinstrongsset.toList();

                                      //       liststrongs.removeWhere((letter) =>
                                      //           listchars.contains(letter));

                                      //       for (var letter in liststrongs) {
                                      //         // ignore: avoid_print
                                      //         print(letter);
                                      //       }
                                      //     },
                                      //     child: Text('data test')),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 400,
                                            child: TextFormField(
                                              controller:
                                                  freeTextSearchController,
                                              onEditingComplete: () => search(),
                                              onFieldSubmitted: (value) =>
                                                  search(),
                                              decoration: InputDecoration(
                                                  filled: true,
                                                  hintText:
                                                      'Enter your search term',
                                                  suffixIcon: IconButton(
                                                    onPressed: () =>
                                                        freeTextSearchController
                                                            .clear(),
                                                    icon:
                                                        const Icon(Icons.clear),
                                                  )

                                                  // The validator receives the text that the user has entered.
                                                  ),
                                            ),
                                          ),
                                          IconButton(
                                              onPressed: search,
                                              icon: Icon(
                                                  Icons.arrow_circle_right))
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  SegmentedButton<String>(
                                    segments: const [
                                      ButtonSegment<String>(
                                          value: 'start',
                                          label: Text('Beginning of Word')),
                                      ButtonSegment<String>(
                                          value: 'middle',
                                          label: Text('Middle of Word')),
                                      ButtonSegment<String>(
                                          value: 'end',
                                          label: Text('End of Word'))
                                    ],
                                    selected: {searchType},
                                    onSelectionChanged: (Set<String> incoming) {
                                      setState(() {
                                        searchType = incoming.first;
                                      });
                                    },
                                  ),
                                  SizedBox(height: 20),
                                  SegmentedButton<String>(
                                    segments: const [
                                      ButtonSegment<String>(
                                          value: 'xlit',
                                          label: Text('Transliterated text')),
                                      ButtonSegment<String>(
                                          value: 'orig',
                                          label: Text('Original script')),
                                    ],
                                    selected: {searchScript},
                                    onSelectionChanged: (Set<String> incoming) {
                                      setState(() {
                                        searchScript = incoming.first;
                                      });
                                    },
                                  ),
                                  SizedBox(height: 20),
                                  SegmentedButton<String>(
                                    segments: const [
                                      ButtonSegment<String>(
                                          value: 'both', label: Text('Both')),
                                      ButtonSegment<String>(
                                          value: 'heb',
                                          label: Text('Hebrew only')),
                                      ButtonSegment<String>(
                                          value: 'grk',
                                          label: Text('Greek only'))
                                    ],
                                    selected: {searchLang},
                                    onSelectionChanged: (Set<String> incoming) {
                                      setState(() {
                                        searchLang = incoming.first;
                                      });
                                    },
                                  ),
                                  SizedBox(height: 20),
                                  if (results.isNotEmpty)
                                    Align(
                                        alignment: Alignment.centerRight,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 8.0, bottom: 8),
                                          child:
                                              Text('${results.length} results'),
                                        )),
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                    }),
              ),
              if (results.isNotEmpty)
                SliverToBoxAdapter(
                  child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: results.length,
                      shrinkWrap: true,
                      itemBuilder: (context, i) {
                        return strongTile(results[i]);
                      }),
                )
            ],
          ),
        ),
      ),
    ));
  }
}

String removeAccents(String input) {
  return input.split('').map((char) => accentsMap[char] ?? char).join();
}

const Map<String, String> accentsMap = {
  'ʼ': '',
  'ʻ': '',
  '’': '',
  '-': '',
  'á': 'a',
  'à': 'a',
  'ä': 'a',
  'â': 'a',
  'ã': 'a',
  'å': 'a',
  'ā': 'a',
  'ă': 'a',
  'é': 'e',
  'è': 'e',
  'ë': 'e',
  'ê': 'e',
  'ḗ': 'e',
  'ē': 'e',
  'ᵉ': 'e',
  'ĕ': 'e',
  'ḕ': 'e',
  'í': 'i',
  'ì': 'i',
  'ï': 'i',
  'î': 'i',
  'ī': 'i',
  'ḯ': 'i',
  'ó': 'o',
  'ò': 'o',
  'ö': 'o',
  'ô': 'o',
  'õ': 'o',
  'ø': 'o',
  'ō': 'o',
  'ṓ': 'o',
  'ŏ': 'o',
  'ṑ': 'o',
  'ú': 'u',
  'ù': 'u',
  'ü': 'u',
  'û': 'u',
  'ū': 'u',
  'ç': 'c',
  'ý': 'y',
  'ŷ': 'y',
  'ÿ': 'y',
  'ñ': 'n',
  'ß': 'ss',
  'Á': 'A',
  'À': 'A',
  'Ä': 'A',
  'Â': 'A',
  'Ã': 'A',
  'Å': 'A',
  'Ā': 'A',
  'Ă': 'A',
  'É': 'E',
  'È': 'E',
  'Ë': 'E',
  'Ê': 'E',
  'Ē': 'E',
  'Ḗ': 'E',
  'Ĕ': 'E',
  'Í': 'I',
  'Ì': 'I',
  'Ï': 'I',
  'Î': 'I',
  'Ī': 'I',
  'Ó': 'O',
  'Ò': 'O',
  'Ö': 'O',
  'Ô': 'O',
  'Õ': 'O',
  'Ø': 'O',
  'Ō': 'O',
  'Ú': 'U',
  'Ù': 'U',
  'Ü': 'U',
  'Û': 'U',
  'Ū': 'U',
  'Ç': 'C',
  'Ñ': 'N',
  'ṭ': 't',
  'Ṭ': 'T',
  'ˢ': 's'
};
