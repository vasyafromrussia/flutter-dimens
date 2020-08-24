import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart';

import 'templates.dart';

const _generatedFileName = 'dimens.g.dart';

File generateDimensFile(String outputDirPath) {
  final files = _getSizeFiles();

  final indexOfBaseFile = files.indexWhere(_isBaseFile);

  if (indexOfBaseFile < 0) {
    throw ('File with name \'sizes.json\' which contains base values must exist in assets/sizes directory');
  }

  final availableSizes = {for (final file in files) _extractSizesFromName(file): file}..removeWhere((key, value) => key == null);

  final baseValues = _decodeJson(files.removeAt(indexOfBaseFile));
  final baseStyles = baseValues.containsKey("textStyles") ? baseValues["textStyles"] as Map<String, dynamic> : <String, dynamic>{};
  final baseSizes = baseValues.containsKey("sizes") ? baseValues["sizes"] as Map<String, dynamic> : <String, dynamic>{};
  final baseClasses = _generateBaseClasses(
    availableSizes: availableSizes.keys.toList(),
    textStyleDeclarations: baseStyles,
    sizeDeclarations: baseSizes,
  );

  final availableSizesEntries = availableSizes.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
  final inheritors = [
    for (var i = 0; i < availableSizesEntries.length; i++)
      _generateInheritorClass(
        currentSize: availableSizesEntries[i].key,
        parentSize: i > 0 ? availableSizesEntries[i - 1].key : null,
        file: availableSizesEntries[i].value,
      )
  ].join("\n");

  final result = baseClasses + "\n" + inheritors;
  final dimensFile = File(_buildOutputPath(outputDirPath));

  if (!dimensFile.existsSync()) {
    dimensFile.createSync(recursive: true);
  }

  dimensFile.writeAsStringSync(result);

  return dimensFile;
}

String _buildOutputPath(String outputDirPath) {
  if (outputDirPath?.isNotEmpty == true) {
    return outputDirPath + (outputDirPath.endsWith(Platform.pathSeparator) ? "" : Platform.pathSeparator) + _generatedFileName;
  } else {
    return _generatedFileName;
  }
}

int _extractSizesFromName(File file) {
  final nameParts = basenameWithoutExtension(file.path).split('-').sublist(1);

  if (nameParts.isNotEmpty && nameParts.first.startsWith('sw')) {
    try {
      return int.parse(nameParts.first.substring(2));
    } catch (_) {
      print("Malformed filename: ${file.path}");
    }
  }

  return null;
}

String _generateInheritorClass({
  int currentSize,
  int parentSize,
  File file,
}) {
  final values = _decodeJson(file);
  final styles = values.containsKey("textStyles") ? values["textStyles"] as Map<String, dynamic> : <String, dynamic>{};
  final sizes = values.containsKey("sizes") ? values["sizes"] as Map<String, dynamic> : <String, dynamic>{};
  return generateInheritorWithSmallestWidthRestriction(
    smallestWidth: currentSize,
    parentSmallestWidth: parentSize,
    textStyleDeclarations: styles,
    sizeDeclarations: sizes,
  );
}

String _generateBaseClasses({
  Map<String, dynamic> textStyleDeclarations,
  Map<String, dynamic> sizeDeclarations,
  List<int> availableSizes,
}) =>
    generateApiClass(availableSizes: availableSizes, textStyleDeclarations: textStyleDeclarations, sizeDeclarations: sizeDeclarations) +
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
