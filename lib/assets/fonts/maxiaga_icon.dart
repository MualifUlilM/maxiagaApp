import 'package:flutter/widgets.dart';

class MaxiagaIcon{
  static const IconData aki = const _MaxiagaIconData(0xe900);
  static const IconData ban = const _MaxiagaIconData(0xe903);
  static const IconData oli = const _MaxiagaIconData(0xe9013);
  static const IconData servis = const _MaxiagaIconData(0xe917);
  // bottom bar
  static const IconData history = const _MaxiagaIconData(0xe904);
  static const IconData home = const _MaxiagaIconData(0xe908);
  static const IconData konsul = const _MaxiagaIconData(0xe909);
  static const IconData produk = const _MaxiagaIconData(0xe916);
  // like and liked
  static const IconData like = const _MaxiagaIconData(0xe90e);
  static const IconData liked = const _MaxiagaIconData(0xe90d);
  // mobil dan motor
  static const IconData mobil = const _MaxiagaIconData(0xe90f);
  static const IconData motor = const _MaxiagaIconData(0xe912);
  // posisi
  static const IconData position = const _MaxiagaIconData(0xe914);
}

class _MaxiagaIconData extends IconData {
  const _MaxiagaIconData (int codePoint)
    : super(
      codePoint,
      fontFamily: 'MaxiagaIcons',
      fontPackage: 'maxiaga_icon'
    );
}