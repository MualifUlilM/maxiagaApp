import 'package:flutter/widgets.dart';

class ExIcon{
  static const IconData facebook = const _ExIconData(0xe900);
  static const IconData google = const _ExIconData(0xe901);
  static const IconData twitter = const _ExIconData(0xe902);
}

class _ExIconData extends IconData{
  const _ExIconData(int codeData)
  :super(
    codeData,
    fontFamily: 'ExIcon',
    fontPackage: 'extern_icon',
  );
}