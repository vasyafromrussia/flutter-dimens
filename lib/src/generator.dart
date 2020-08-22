import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart';

import 'templates.dart';

String generateDimensFile() {
  final files = _getSizeFiles();

  final indexOfBaseFile = files.indexWhere(_isBaseFile);

  if (indexOfBaseFile < 0) {
    throw ('File with name \'sizes.json\' which contains base values must exist in assets/sizes directory');
  }

  final baseValues = _decodeJson(files.removeAt(indexOfBaseFile));
  final baseStyles = baseValues["textStyles"] as Map<String, dynamic>;
  final baseSizes = baseValues["sizes"] as Map<String, dynamic>;
  final baseClasses = _generateBaseClasses(
    textStyleDeclarations: baseStyles,
    sizeDeclarations: baseSizes,
  );

  final inheritors = files.map((e) {
    final nameParts = basenameWithoutExtension(e.path).split('-').sublist(1);
    if (nameParts.isEmpty) return "";

    if (nameParts.first.startsWith('sw')) {
      try {
        final sw = int.parse(nameParts.first.substring(2));
        final values = _decodeJson(e);
        final styles = values["textStyles"] as Map<String, dynamic>;
        final sizes = values["sizes"] as Map<String, dynamic>;
        return generateInheritorWithSmallestWidthRestriction(
          smallestWidth: sw,
          textStyleDeclarations: styles,
          sizeDeclarations: sizes,
        );
      } catch (_) {
        print("Malformed filename: ${e.path}");
      }

      return "";
    }
  }).join("\n");

  final result = baseClasses + "\n" + inheritors;

//  print(result);

  final dimensFile = File('dimens.dart');

  if (!dimensFile.existsSync()) {
    dimensFile.createSync();
  }

  dimensFile.writeAsStringSync(result);
}

String _generateBaseClasses({
  Map<String, dynamic> textStyleDeclarations,
  Map<String, dynamic> sizeDeclarations,
}) =>
    generateApiClass(textStyleDeclarations: textStyleDeclarations, sizeDeclarations: sizeDeclarations) +
    "\n" +
    generateBaseClass(textStyleDeclarations: textStyleDeclarations, sizeDeclarations: sizeDeclarations);

Map<String, dynamic> _decodeJson(File file) => json.decode(file.readAsStringSync()) as Map<String, dynamic>;

bool _isBaseFile(File file) => basename(file.path) == 'sizes.json';

List<File> _getSizeFiles() => Directory('assets/sizes')
    .listSync()
    .where(
      (element) => element is File,
    )
    .map(
      (element) => element as File,
    )
    .where(
      (e) => basename(e.path).startsWith('sizes') && basename(e.path).endsWith('json'),
    )
    .toList();
