String generateApiClass({
  required Map<String, dynamic> textStyleDeclarations,
  required Map<String, dynamic> sizeDeclarations,
  required List<int> availableSizes,
}) =>
    """
    // GENERATED CODE - DO NOT MODIFY BY HAND
    
    import 'dart:math';
    
    import 'package:flutter/material.dart';
    
    class _Lazy<T> {
      late T _value;
      var _isInitialized = false;
    
      T get value => _value;
      
      bool get isInitialized => _isInitialized;
    
      void init(T value) {
        if (!_isInitialized) {
          _value = value;
          _isInitialized = true;
        }
      }
    }

    class Dimens extends InheritedWidget implements _DimensValues {
      final _proxy = _Lazy<_DimensValues>();
    
      Dimens({
        Key? key,
        required Widget child,
      }) : super(key: key, child: child);
    
      static Dimens? maybeOf(BuildContext context) {
        final instance = context.dependOnInheritedWidgetOfExactType<Dimens>();
        if (instance != null && !instance._proxy.isInitialized) {
          instance._proxy.init(_chooseProxy(context));
        }
        return instance;
      }
        
      static Dimens of(BuildContext context) => maybeOf(context)!;
      
      ${_generateChoseProxyMethod(availableSizes)}
      
      @override
      bool updateShouldNotify(InheritedWidget oldWidget) => false;
      
      @override
      TextTheme get textTheme => _proxy.value.textTheme;
    
      ${_buildProxySection(textStyleDeclarations, sizeDeclarations)}
    }
""";

String _generateChoseProxyMethod(List<int> availableSizes) => """
  static _DimensValues _chooseProxy(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenSize = MediaQuery.of(context).size;
    final smallestWidth = min(screenSize.width, screenSize.height);
    
    ${_generateChoseProxyMethodBody(availableSizes)}
  }
""";

String _generateChoseProxyMethodBody(List<int> availableSizes) {
  if (availableSizes.isEmpty == true) {
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
  required bool isFirstBranch,
  required int size,
}) =>
    """
      ${isFirstBranch ? "" : "else "} if (smallestWidth >= $size) {
        return _DimensValuesSw$size(textTheme);
      }
    """;

String generateBaseClass({
  required Map<String, dynamic> textStyleDeclarations,
  required Map<String, dynamic> sizeDeclarations,
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
  required int smallestWidth,
  int? parentSmallestWidth,
  required Map<String, dynamic> textStyleDeclarations,
  required Map<String, dynamic> sizeDeclarations,
}) =>
    """
    class _DimensValuesSw$smallestWidth extends ${_buildParentName(parentSmallestWidth: parentSmallestWidth)} {
      _DimensValuesSw$smallestWidth(TextTheme textTheme) : super(textTheme);
    
      ${_buildTextStyleDeclarations(textStyleDeclarations, isOverride: true)}
      
      ${_buildSizeDeclarations(sizeDeclarations, isOverride: true)}
    }
    """;

String _buildParentName({
  int? parentSmallestWidth,
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
    styles.entries.where((element) => element.value is String).map((e) => _mapStyleEntryToPropertyDeclaration(e, isOverride: isOverride)).join("\n");

String _buildSizeDeclarations(
  Map<String, dynamic> styles, {
  bool isOverride = false,
}) =>
    styles.entries.where((element) => element.value is double).map((e) => _mapSizeEntryToPropertyDeclaration(e, isOverride: isOverride)).join("\n");

String _mapStyleEntryToProxyCall(MapEntry<String, dynamic> e) => "@override TextStyle get ${e.key} => _proxy.value.${e.key};";

String _mapSizeEntryToProxyCall(MapEntry<String, dynamic> e) => "@override double get ${e.key} => _proxy.value.${e.key};";

String _mapStyleEntryToPropertyDeclaration(MapEntry<String, dynamic> e, {required bool isOverride}) => "${isOverride ? "@override" : ""} TextStyle get ${e.key} => textTheme.${e.value};";

String _mapSizeEntryToPropertyDeclaration(MapEntry<String, dynamic> e, {required bool isOverride}) => "${isOverride ? "@override" : ""} final double ${e.key} = ${e.value};";
