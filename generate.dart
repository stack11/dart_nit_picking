import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:yaml/yaml.dart';

final removedRules = [
  'always_specify_types',
  'avoid_annotating_with_dynamic',
  'avoid_as',
  'avoid_catches_without_on_clauses',
  'avoid_catching_errors',
  'avoid_classes_with_only_static_members',
  'avoid_final_parameters',
  'avoid_print',
  'diagnostic_describe_all_properties',
  'empty_catches',
  'lines_longer_than_80_chars',
  'no_default_cases',
  'one_member_abstracts',
  'prefer_double_quotes',
  'prefer_relative_imports',
  'unnecessary_final',
  'unnecessary_null_checks',
];

const commitHash = '5b9bc6a';

Future main() async {
  final body = (await http.get(
    Uri.parse(
      'https://raw.githubusercontent.com/dart-lang/linter/$commitHash/example/all.yaml',
    ),
  ))
      .body;
  final document = loadYaml(body);

  var config = '''
analyzer:
  strong-mode:
    implicit-casts: false
    implicit-dynamic: true
  errors:
    flutter_style_todos: ignore
    todo: ignore
  exclude:
    - "lib/generated_plugin_registrant.dart"
    - "lib/l10n/**"
    - "**.g.dart"
    - "**.mocks.dart"
linter:
  rules:
''';

  config += (((document as YamlMap)['linter'] as YamlMap)['rules'] as YamlList)
      .map((final line) => '    $line: ${removedRules.contains(line) ? 'false' : 'true'}')
      .join('\n');
  File('lib/dart.yaml').writeAsStringSync(config);
}
