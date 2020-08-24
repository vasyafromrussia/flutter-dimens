# dimens

Android-like dimens generator

## Overview

Dimens allows you to manage dimension resources and text styles.

## Usage

Add dev dependency to your `pubspec.yaml`.

```yaml
dev_dependencies:
  dimens: any
```

Create `sizes.json` file under `assets/sizes` directory in your project.

Here you can declare two objects: 
- `textStyles` for text styles definitions
- `sizes` for dimension definitions

```json
{
  "textStyles": {
    "defaultHeadline": "headline6"
  },
  "sizes": {
    "defaultSpacing": 24.0
  }
}
```

Then you can define another file for particular screen configuration (only smallest width 
is supported now), like `size-sw320.json`. You can override some values here, and these values
will be used on devices with smallest width larger or equal 320lp.

```json
{
  "textStyles": {
    "defaultHeadline": "headline5"
  },
  "sizes": {
    "defaultSpacing": 32.0
  }
}
``` 

Now run `flutter pub run dimens`. It will generate `dimens.g.dart` file containing `InheritedWidget` 
called `Dimens`. Just place this widget at the top of your widget tree. Then you can access
appropriate for your screen resource like this:

```dart
// ...
Widget build(BuildContext) => Container(
  height: Dimens.of(context).defaultSpacing,
);
``` 

## Command arguments

Command supports following arguments:

| Argument | Abbreviation | Type  |  Description |
| ------------ | ------------ | ------------ | ------------ |
| `--output-dir`  |  `-o` | string  | Directory in which output file will be generated. If not presented file is generated in the root of your project.  |
| `--format`  | `-f`  | bool  | Set to true if you want to apply `dartfmt` to output file. False by default.  |
