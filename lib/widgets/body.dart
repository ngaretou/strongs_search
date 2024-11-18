import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../providers/nav_controller.dart';
import '../data/data.dart';

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
            final unaccentedSearchString = removeAccents(strong.xlit!);
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
          results.where((strongs) => strongs.lang == 'heb');
          break;
        case 'grk':
          results.where((strongs) => strongs.lang == 'grk');
          break;
        default:
      }

      setState(() {});
    }

    strongTile(Strongs strong) {
      var heading = Theme.of(context).textTheme.headlineSmall;
      return Card(
        color: Theme.of(context).colorScheme.tertiaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  if (strong.xlit != null)
                    Text(
                      strong.xlit!,
                      style: heading,
                    ),
                  const SizedBox(width: 20),
                  Text(strong.lemma, style: heading),
                ],
              ),
              Row(
                children: [
                  if (strong.strongsDef != null)
                    Expanded(child: Text(strong.strongsDef!)),
                  if (strong.kjvDef != null)
                    Expanded(child: Text(strong.kjvDef!))
                ],
              )
            ],
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
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withOpacity(.3),
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
                      return Padding(
                        padding:
                            const EdgeInsets.only(top: 20.0, right: 8, left: 8),
                        child: Column(
                          children: [
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
                                      SizedBox(
                                        width: 400,
                                        child: TextFormField(
                                          controller: freeTextSearchController,
                                          onFieldSubmitted: (value) => search(),
                                          decoration: InputDecoration(
                                              filled: true,
                                              hintText:
                                                  'Enter your search term',
                                              suffixIcon: IconButton(
                                                onPressed: () =>
                                                    freeTextSearchController
                                                        .clear(),
                                                icon: const Icon(Icons.clear),
                                              )

                                              // The validator receives the text that the user has entered.
                                              ),
                                        ),
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
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  }),
            ),
            if (results.isNotEmpty)
              SliverToBoxAdapter(
                child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 80,
                    shrinkWrap: true,
                    itemBuilder: (context, i) {
                      return strongTile(results[i]);
                    }),
              )
          ],
        ),
      ),
    ));
  }
}

String removeAccents(String input) {
  const Map<String, String> accentsMap = {
    'á': 'a',
    'à': 'a',
    'ä': 'a',
    'â': 'a',
    'ã': 'a',
    'å': 'a',
    'ā': 'a',
    'é': 'e',
    'è': 'e',
    'ë': 'e',
    'ê': 'e',
    'ē': 'e',
    'í': 'i',
    'ì': 'i',
    'ï': 'i',
    'î': 'i',
    'ī': 'i',
    'ó': 'o',
    'ò': 'o',
    'ö': 'o',
    'ô': 'o',
    'õ': 'o',
    'ø': 'o',
    'ō': 'o',
    'ú': 'u',
    'ù': 'u',
    'ü': 'u',
    'û': 'u',
    'ū': 'u',
    'ç': 'c',
    'ñ': 'n',
    'ß': 'ss',
    'Á': 'A',
    'À': 'A',
    'Ä': 'A',
    'Â': 'A',
    'Ã': 'A',
    'Å': 'A',
    'Ā': 'A',
    'É': 'E',
    'È': 'E',
    'Ë': 'E',
    'Ê': 'E',
    'Ē': 'E',
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
    'Ñ': 'N'
  };

  return input.split('').map((char) => accentsMap[char] ?? char).join();
}
