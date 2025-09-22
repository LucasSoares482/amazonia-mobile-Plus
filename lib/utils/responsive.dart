import 'package:flutter/material.dart';

/// Classe de utilitários para ajudar a criar layouts responsivos.
/// Contém apenas membros estáticos.
class Responsive {
  /// Verifica se a largura do ecrã corresponde a um dispositivo móvel.
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  /// Verifica se a largura do ecrã corresponde a um tablet.
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 1200;

  /// Verifica se a largura do ecrã corresponde a um desktop.
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;

  /// Retorna a largura total do ecrã.
  static double width(BuildContext context) =>
      MediaQuery.of(context).size.width;

  /// Retorna a altura total do ecrã.
  static double height(BuildContext context) =>
      MediaQuery.of(context).size.height;

  /// Retorna um tamanho de fonte adaptado ao tipo de ecrã.
  static double fontSize(BuildContext context, {
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet ?? mobile * 1.2;
    return desktop ?? mobile * 1.5;
  }

  /// Retorna um padding adaptado ao tipo de ecrã.
  static EdgeInsets padding(BuildContext context) {
    if (isMobile(context)) return const EdgeInsets.all(16);
    if (isTablet(context)) return const EdgeInsets.all(24);
    return const EdgeInsets.all(32);
  }

  /// Retorna o número de colunas para um GridView adaptado ao ecrã.
  static int gridCount(BuildContext context) {
    if (isMobile(context)) return 2;
    if (isTablet(context)) return 3;
    return 4;
  }

  /// Retorna uma largura máxima para conteúdo centralizado.
  static double maxWidth(BuildContext context) {
    if (isMobile(context)) return double.infinity;
    if (isTablet(context)) return 600;
    return 800;
  }
}