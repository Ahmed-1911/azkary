class Azkar {
  final String id;
  final String arabicText;
  final String? translation;
  final String? reference;
  final String? audioUrl;
  final int repeatCount;
  final int? virtue;

  const Azkar({
    required this.id,
    required this.arabicText,
    this.translation,
    this.reference,
    this.audioUrl,
    required this.repeatCount,
    this.virtue,
  });

  factory Azkar.fromJson(Map<String, dynamic> json) {
    return Azkar(
      id: json['id'] as String,
      arabicText: json['arabicText'] as String,
      translation: json['translation'] as String?,
      reference: json['reference'] as String?,
      audioUrl: json['audioUrl'] as String?,
      repeatCount: json['repeatCount'] as int,
      virtue: json['virtue'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'arabicText': arabicText,
      'translation': translation,
      'reference': reference,
      'audioUrl': audioUrl,
      'repeatCount': repeatCount,
      'virtue': virtue,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Azkar &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
} 