
class Language {
  final int id;
  final String name;
  final String flag;
  final String langCode;

  Language(this.id, this.name, this.flag, this.langCode);

  static List <Language> langList() {
    return <Language>
    [
      Language(1, 'English', 'U+1F1FA', 'en'),
      Language(2, 'Arabic', 'U+1F1F0', 'ar'),
    ];
  }
}