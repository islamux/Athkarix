class AssmaHussnaModel {
  final int id;
  final String name;
  final String text;

  AssmaHussnaModel({
    required this.id,
    required this.name,
    required this.text,
  });

  // Factory constructor to create an instance from JSON
  factory AssmaHussnaModel.fromJson(Map<String, dynamic> json) {
    return AssmaHussnaModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      text: json['text'] ?? '',
    );
  }

  // Method to convert the instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'text': text,
    };
  }

  // Override toString for debugging
  @override
  String toString() {
    return 'AssmaHussnaModel(id: $id, name: $name, text: ${text.substring(0, text.length > 50 ? 50 : text.length)}...)';
  }

  // Override equality operators for comparison
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AssmaHussnaModel &&
        other.id == id &&
        other.name == name &&
        other.text == text;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ text.hashCode;
}
