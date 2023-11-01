import 'package:athkarix/core/data/model/athkar_massa_list_model.dart';
import 'package:athkarix/core/data/model/athkar_model.dart';
import 'package:athkarix/core/data/model/athkar_sabah_list_model.dart';
import 'package:athkarix/core/data/model/dua_men_quran_list.dart';
import 'package:athkarix/core/data/model/dua_men_sunnah_list.dart';
import 'package:athkarix/core/data/model/estigfar_list_model.dart';
import 'package:athkarix/core/data/model/hamd_list_model.dart';
import 'package:athkarix/core/data/model/salat_ala_rasoul_list_model.dart';
import 'package:athkarix/function/remove_search_diacritics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'custom_search_result.dart';

class DataSearch extends SearchDelegate {
  final List<AthkarModel> athkar = [
    ...athkarSabahList,
    ...athkarMassaList,
    ...duaMenQuranList,
    ...duaMenSunnahList,
    ...estigfarList,
    ...hamdList,
    ...salatAlaRasoulAllahList,
  ];

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
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text(query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
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
