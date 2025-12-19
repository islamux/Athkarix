String removeSearchDiacritics(String text) {
  return text == null
      ? ''
      : text.replaceAll(RegExp(r'[^\u0621-\u064A\s]'),
          ''); // Removes all characters except Arabic letters and spaces
}

// String removeSearchDiacritics(String text) {
//   if (text == null || text.isEmpty) {
//     return '';
//   }

//   final normalizedText = NFD.characters.from(text); // Normalize to NFD form
//   final diacriticRemoved =
//       removeAllDiacritics(normalizedText); // Remove diacritics
//   return diacriticRemoved.join();
// }

// String removeAllDiacritics(Iterable<String> characters) {
//   return characters
//       .where((char) => !char.codeUnitAt(0).isDiacritic)
//       .toList()
//       .join();
// }

// extension StringExtension on String {
//   bool isDiacritic() {
//     final codeUnit = codeUnitAt(0);
//     return codeUnit >= 0x0300 && codeUnit <= 0x036F; // Common diacritics range
//   }
// }
