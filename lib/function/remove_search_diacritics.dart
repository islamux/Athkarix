String removeSearchDiacritics(String text) {
  return text == null
      ? ''
      : text.replaceAll(RegExp(r'[^\u0621-\u064A\s]'),
          ''); // Removes all characters except Arabic letters and spaces
}
