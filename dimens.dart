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
    
      @override TextStyle get videoPlayerEndOfCourseTitleStyle => proxy.videoPlayerEndOfCourseTitleStyle;
@override double get videoPlayerEndOfCourseSpacing => proxy.videoPlayerEndOfCourseSpacing;
    }

    class _DimensValues {
      final TextTheme textTheme;
    
      const _DimensValues(this.textTheme);
      
       TextStyle get videoPlayerEndOfCourseTitleStyle => textTheme.headline5;
      
       final double videoPlayerEndOfCourseSpacing = 32.0;
    }
    
    class _DimensSw320 extends _DimensValues {
      _DimensSw320(TextTheme textTheme) : super(textTheme);
    
      @override TextStyle get videoPlayerEndOfCourseTitleStyle => textTheme.headline6;
      
      @override final double videoPlayerEndOfCourseSpacing = 24.0;
    }
    