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
    final smallestWidth = min(screenSize.width, screenSize.height);
    final proxy = _chooseProxy(smallestWidth, textTheme);
    return Dimens._(key: key, child: child, proxy: proxy);
  }

  static Dimens of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<Dimens>();

  static _DimensValues _chooseProxy(double smallestWidth, TextTheme textTheme) {
    return _DimensValues(textTheme);
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

  @override
  TextTheme get textTheme => proxy.textTheme;

  @override
  TextStyle get videoPlayerEndOfCourseTitleStyle => proxy.videoPlayerEndOfCourseTitleStyle;

  @override
  double get videoPlayerEndOfCourseSpacing => proxy.videoPlayerEndOfCourseSpacing;

  @override
  double get a => proxy.a;
}

class _DimensValues {
  final TextTheme textTheme;

  const _DimensValues(this.textTheme);

  TextStyle get videoPlayerEndOfCourseTitleStyle => textTheme.headline5;

  final double videoPlayerEndOfCourseSpacing = 32.0;
  final double a = 100.0;
}
