String generateApiClass({
  Map<String, dynamic> textStyleDeclarations,
  Map<String, dynamic> sizeDeclarations,
}) =>
    """
    import 'dart:math';
    
    import 'package:flutter/material.dart';
    
    // ignore_for_file: must_be_immutable
    class Dimens extends InheritedWidget implements _DimensValues {
      final _DimensValues proxy;
    
      Dimens._({
        Key key,
        Widget child,
        this.proxy,
      }) : super(key: key, child: child);
    
      factory Dimens.build({
        Key key,
        @required BuildContext context,
        @required Widget child,
      }) {
        final textTheme = Theme.of(context).textTheme;
        final screenSize = MediaQuery.of(context).size;
        final isSmallScreen = min(screenSize.width, screenSize.height) <= 320;
    
        final proxy = isSmallScreen ? _DimensSw320(textTheme) : _DimensValues(textTheme);
        return Dimens._(key: key, child: child, proxy: proxy);
      }
    
      static Dimens of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<Dimens>();
      
      @override
      bool updateShouldNotify(InheritedWidget oldWidget) => false;
      
      @override
      TextTheme get textTheme => proxy.textTheme;
    
      ${_buildProxySection(textStyleDeclarations, sizeDeclarations)}
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
  Map<String, dynamic> textStyleDeclarations,
  Map<String, dynamic> sizeDeclarations,
}) =>
    """
    class _DimensSw$smallestWidth extends _DimensValues {
      _DimensSw$smallestWidth(TextTheme textTheme) : super(textTheme);
    
      ${_buildTextStyleDeclarations(textStyleDeclarations, isOverride: true)}
      
      ${_buildSizeDeclarations(sizeDeclarations, isOverride: true)}
    }
    """;

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

String _mapStyleEntryToProxyCall(MapEntry<String, dynamic> e) => "@override TextStyle get ${e.key} => proxy.${e.key};";

String _mapSizeEntryToProxyCall(MapEntry<String, dynamic> e) => "@override double get ${e.key} => proxy.${e.key};";

String _mapStyleEntryToPropertyDeclaration(MapEntry<String, dynamic> e, [bool isOverride]) => "${isOverride ? "@override" : ""} TextStyle get ${e.key} => textTheme.${e.value};";

String _mapSizeEntryToPropertyDeclaration(MapEntry<String, dynamic> e, [bool isOverride]) => "${isOverride ? "@override" : ""} final double ${e.key} = ${e.value};";
