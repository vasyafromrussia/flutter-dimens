// @dart=2.9

String generateApiClass({
  Map<String, dynamic> textStyleDeclarations,
  Map<String, dynamic> sizeDeclarations,
  List<int> availableSizes,
}) =>
    """
    // GENERATED CODE - DO NOT MODIFY BY HAND
    // @dart=2.9
    
    import 'dart:math';
    
    import 'package:flutter/material.dart';
    
    // ignore_for_file: must_be_immutable
    class Dimens extends InheritedWidget implements _DimensValues {
      _DimensValues _proxy;
    
      Dimens({
        Key key,
        Widget child,
      }) : super(key: key, child: child);
    
      static Dimens of(BuildContext context) {
        final instance = context.dependOnInheritedWidgetOfExactType<Dimens>();
        if (instance._proxy == null) {
          instance._init(context);
        }
        return instance;
      }
      
      void _init(BuildContext context) {
        final textTheme = Theme.of(context).textTheme;
        final screenSize = MediaQuery.of(context).size;
        final smallestWidth = min(screenSize.width, screenSize.height);
        _proxy = _chooseProxy(smallestWidth, textTheme);
      }
      
      ${_generateChoseProxyMethod(availableSizes)}
      
      @override
      bool updateShouldNotify(InheritedWidget oldWidget) => false;
      
      @override
      TextTheme get textTheme => _proxy.textTheme;
    
      ${_buildProxySection(textStyleDeclarations, sizeDeclarations)}
    }
""";

String _generateChoseProxyMethod(List<int> availableSizes) => """
  static _DimensValues _chooseProxy(double smallestWidth, TextTheme textTheme) {
    ${_generateChoseProxyMethodBody(availableSizes)}
  }
""";

String _generateChoseProxyMethodBody(List<int> availableSizes) {
  if (availableSizes?.isEmpty == true) {
    return "return _DimensValues(textTheme);";
  } else {
    final sizes = List.of(availableSizes, growable: false)..sort((a, b) => b.compareTo(a));
    final conditionalBranches = [for (var i = 0; i < sizes.length; i++) _generateChoseProxyMethodBodyConditionBranch(isFirstBranch: i == 0, size: sizes[i])].join("\n");
    final defaultBranch = """
      else {
        return _DimensValues(textTheme);
      }
    """;
    return conditionalBranches + "\n" + defaultBranch;
  }
}

String _generateChoseProxyMethodBodyConditionBranch({
  bool isFirstBranch,
  int size,
}) =>
    """
      ${isFirstBranch ? "" : "else "} if (smallestWidth >= $size) {
        return _DimensValuesSw$size(textTheme);
      }
    """;

String generateBaseClass({
  Map<String, dynamic> textStyleDeclarations,
  Map<String, dynamic> sizeDeclarations,
}) =>
    """
    class _DimensValues {
      final TextTheme textTheme;
    
      const _DimensValues(this.textTheme);
      
      ${_buildTextStyleDeclarations(textStyleDeclarations)}
      
      ${_buildSizeDeclarations(sizeDeclarations)}
    }
    """;

String generateInheritorWithSmallestWidthRestriction({
  int smallestWidth,
  int parentSmallestWidth,
  Map<String, dynamic> textStyleDeclarations,
  Map<String, dynamic> sizeDeclarations,
}) =>
    """
    class _DimensValuesSw$smallestWidth extends ${_buildParentName(smallestWidth: smallestWidth, parentSmallestWidth: parentSmallestWidth)} {
      _DimensValuesSw$smallestWidth(TextTheme textTheme) : super(textTheme);
    
      ${_buildTextStyleDeclarations(textStyleDeclarations, isOverride: true)}
      
      ${_buildSizeDeclarations(sizeDeclarations, isOverride: true)}
    }
    """;

String _buildParentName({
  int smallestWidth,
  int parentSmallestWidth,
}) {
  final suffix = parentSmallestWidth != null ? "Sw$parentSmallestWidth" : "";
  return "_DimensValues$suffix";
}

String _buildProxySection(
  Map<String, dynamic> styles,
  Map<String, dynamic> sizes,
) =>
    styles.entries.where((element) => element.value is String).map(_mapStyleEntryToProxyCall).join("\n") +
    "\n" +
    sizes.entries.where((element) => element.value is double).map(_mapSizeEntryToProxyCall).join("\n");

String _buildTextStyleDeclarations(
  Map<String, dynamic> styles, {
  bool isOverride = false,
}) =>
    styles.entries.where((element) => element.value is String).map((e) => _mapStyleEntryToPropertyDeclaration(e, isOverride)).join("\n");

String _buildSizeDeclarations(
  Map<String, dynamic> styles, {
  bool isOverride = false,
}) =>
    styles.entries.where((element) => element.value is double).map((e) => _mapSizeEntryToPropertyDeclaration(e, isOverride)).join("\n");

String _mapStyleEntryToProxyCall(MapEntry<String, dynamic> e) => "@override TextStyle get ${e.key} => _proxy.${e.key};";

String _mapSizeEntryToProxyCall(MapEntry<String, dynamic> e) => "@override double get ${e.key} => _proxy.${e.key};";

String _mapStyleEntryToPropertyDeclaration(MapEntry<String, dynamic> e, [bool isOverride]) => "${isOverride ? "@override" : ""} TextStyle get ${e.key} => textTheme.${e.value};";

String _mapSizeEntryToPropertyDeclaration(MapEntry<String, dynamic> e, [bool isOverride]) => "${isOverride ? "@override" : ""} final double ${e.key} = ${e.value};";
