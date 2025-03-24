class Translation {
  String? kz;
  String? ru;
  String? en;

  Translation({this.kz, this.ru, this.en});

  Translation.fromJson(Map<String, dynamic> json) {
    kz = json['kz'];
    ru = json['ru'];
    en = json['en'];
  }

  String? getTranslation(String locale) {
    switch (locale) {
      case 'kk':
        return kz;
      case 'ru':
        return ru;
      case 'en':
        return en;
      default:
        return en;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['kz'] = kz;
    data['ru'] = ru;
    data['en'] = en;
    return data;
  }
}
