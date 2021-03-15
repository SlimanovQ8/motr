import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SetLocalization {
  final Locale locale;

  SetLocalization(this.locale);
  static SetLocalization of(BuildContext context) {
    return Localizations.of<SetLocalization>(context, SetLocalization);
  }
  static const LocalizationsDelegate <SetLocalization> localizationsDelegate = _GetLocalizationDeligate();
  Map <String, String> _localizedValues;

  Future load() async {
    String jsonStringValues = await rootBundle.loadString("lib/lang/${locale.languageCode}.json");
    Map <String, dynamic> mappedJson = json.decode(jsonStringValues);
    _localizedValues = mappedJson.map((key, value) => MapEntry(key, value.toString()));

  }

  String getTranslateValue(String key)
  {
    return _localizedValues[key];
  }
}

class _GetLocalizationDeligate extends LocalizationsDelegate <SetLocalization> {
  @override
  const _GetLocalizationDeligate();
  bool isSupported(Locale locale) {
    // TODO: implement isSupported
    return ['en', 'ar'].contains(locale.languageCode);
    throw UnimplementedError();
  }

  @override
  Future<SetLocalization> load(Locale locale) async {
    // TODO: implement load
    SetLocalization localization = new SetLocalization(locale);
    await localization.load();
    return localization;
    throw UnimplementedError();
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<SetLocalization> old) {
    // TODO: implement shouldReload
    return false;
    throw UnimplementedError();
  }
  
}