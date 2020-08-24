import 'package:args/args.dart';
import 'package:dimens/dimens.dart' as api;

abstract class _Args {
  static const outputDir = 'output-dir';
  static const format = 'format';
}

void main(List<String> arguments) {
  final parser = ArgParser()
    ..addOption(_Args.outputDir, abbr: 'o')
    ..addFlag(_Args.format, abbr: 'f', defaultsTo: false);
  final argResult = parser.parse(arguments);

  api.generate(
    outputDirPath: argResult[_Args.outputDir] as String,
    formatOutput: argResult[_Args.format] as bool,
  );
}
