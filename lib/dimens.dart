library dimens;

import 'package:dimens/src/generator.dart';
import 'dart:io';

void generate() {
  print("Generating file from resources");
  final file = generateDimensFile();

  print("Formatting output");
  final processResult = Process.runSync('dartfmt', ["-l 200", "-w", file.path]);
  print("dartfmt finished with: ${processResult.exitCode}");
  if (processResult.exitCode == 0) {
    print(processResult.stdout);
  } else {
    print(processResult.stderr);
  }
}
