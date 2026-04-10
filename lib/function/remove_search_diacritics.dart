String removeSearchDiacritics(String text) {
  if (text.isEmpty) {
    return '';
  }

  return text.replaceAll(RegExp(r'[\u064B-\u065F\u0670]'), '');
}
