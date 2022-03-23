import 'package:get/get.dart';
import 'package:spider/translations/ar.dart';
import 'package:spider/translations/en.dart';

class Translation extends Translations{
  @override
  Map<String, Map<String, String>> get keys =>{
    'en':en,
    'ar':ar
  };

}