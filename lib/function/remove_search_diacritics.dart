String removeSearchDiacritics(String text) {
  if (text.isEmpty) return '';
  
  // Handle both partial and exact matches
  final normalized = text
    .replaceAll(RegExp(r'[^\u0621-\u064A\s]'), '')  // Remove non-Arabic characters
    .replaceAll(/\s+/g, ' ')  // Normalize spaces
    .trim();
    
  return normalized;
}

// Add scoring function for better matches
int getSearchScore(String query, String content) {
  final normalizedQuery = removeSearchDiacritics(query);
  final normalizedContent = removeSearchDiacritics(content);
  
  // Exact match gets highest score
  if (normalizedContent == normalizedQuery) return 100;
  // Word boundary match gets medium score
  if (normalizedContent.contains(" $normalizedQuery ")) return 75;
  // Partial match gets lower score
  if (normalizedContent.contains(normalizedQuery)) return 50;
  return 0;
}
