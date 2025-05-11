import 'package:athkarix/core/data/model/model_list/athkar_massa_list_model.dart';
import 'package:athkarix/core/data/model/athkar_model.dart';
import 'package:athkarix/core/data/model/model_list/athkar_sabah_list_model.dart';
import 'package:athkarix/core/data/model/model_list/dua_men_quran_list.dart';
import 'package:athkarix/core/data/model/model_list/dua_men_sunnah_list.dart';
import 'package:athkarix/core/data/model/model_list/estigfar_list_model.dart';
import 'package:athkarix/core/data/model/model_list/hamd_list_model.dart';
import 'package:athkarix/core/data/model/model_list/salat_ala_rasoul_list_model.dart';
import 'package:athkarix/function/remove_search_diacritics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'custom_search_result.dart';

class SearchAnalytics {
  static void logSearch(String query, int resultCount) {
    // Log search metrics
    print('Search: $query, Results: $resultCount');
  }

  static void logSearchResult(String query, AthkarModel selected) {
    // Log which results users click on
    print('Selected: ${selected.duaText} from search: $query');
  }
}

class DataSearch extends SearchDelegate {
  final stt.SpeechToText speechToText = stt.SpeechToText();
  final Map<String, bool> _filters = {
    'athkarSabah': true,
    'athkarMassa': true,
    'duaQuran': true,
    'duaSunnah': true,
    'estigfar': true,
    'hamd': true,
    'salatAlaRasoul': true,
  };

  Widget _buildFilterChips() {
    return Wrap(
      spacing: 8.0,
      children: _filters.keys.map((String key) {
        return FilterChip(
          label: Text(key),
          selected: _filters[key]!,
          onSelected: (bool selected) {
            _filters[key] = selected;
          },
        );
      }).toList(),
    );
  }

  final List<AthkarModel> athkar = [
    ...athkarSabahList,
    ...athkarMassaList,
    ...duaMenQuranList,
    ...duaMenSunnahList,
    ...estigfarList,
    ...hamdList,
    ...salatAlaRasoulAllahList,
  ];
  final List<String> _searchHistory = [];

  Future<void> startVoiceSearch() async {
    try {
      // Implement voice recognition
      // Use speech_to_text package
      final String result = await speechToText.listen(
        locale: 'ar_SA', // Arabic locale
      );
      query = result;
      showResults(context);
    } catch (e) {
      print('Voice search error: $e');
    }
  }

  @override
  String get searchFieldLabel => "إبحث";

  @override
  TextStyle get searchFieldStyle => const TextStyle(fontSize: 17);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => close(context, null),
        ),
        IconButton(
          icon: const Icon(Icons.mic),
          onPressed: startVoiceSearch,
        ),
      ],
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text(query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return ListView.builder(
        itemCount: _searchHistory.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.history),
            title: Text(_searchHistory[index]),
            onTap: () {
              query = _searchHistory[index];
              showResults(context);
            },
            trailing: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchHistory.removeAt(index);
              },
            ),
          );
        },
      );
    }
    final String queryWithoutDiacritics =
        removeSearchDiacritics(query.toLowerCase());
    final List<AthkarModel> filteredAthkar = query.isEmpty
        ? athkar
        : athkar.where((element) {
            final String duaTextWithoutDiacritics =
                removeSearchDiacritics(element.duaText!.toLowerCase());
            return duaTextWithoutDiacritics.contains(queryWithoutDiacritics);
          }).toList();

    return ListView.separated(
      itemCount: filteredAthkar.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final AthkarModel athkarModel = filteredAthkar[index];
        return InkWell(
          onTap: () {
            Get.to(() => CustomSearchResultPage(athkar: athkarModel));
          },
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Text('${athkarModel.duaText}'),
            ),
          ),
        );
      },
    );
  }
}
