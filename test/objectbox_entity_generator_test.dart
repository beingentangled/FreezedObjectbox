import 'package:source_gen_test/source_gen_test.dart';
import 'package:test/test.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:build_test/build_test.dart';
import 'package:freezed_to_objectbox/objectbox_entity_generator.dart';

void main() {
  initializeBuildLogTracking();

  group('ObjectBoxEntityGenerator', () {
    test('generates entity for simple Freezed model', () async {
      const source = r'''
class Person {
  final int id;
  final String name;
  final int age;

  Person({
    required this.id,
    required this.name,
    required this.age,
  });
}
''';

      final builder =
          SharedPartBuilder([ObjectBoxEntityGenerator()], 'objectbox_entity');

      final expectedOutputs = {
        'freezed_to_objectbox|lib/person.g.objectbox_entity.dart':
            decodedMatches(allOf([
          contains('@Entity()'),
          contains('class PersonEntity'),
          contains('int id = 0;'),
          contains('String name;'),
          contains('int age;'),
          contains('factory PersonEntity.fromModel(Person model)'),
          contains('Person toModel()'),
        ])),
      };

      await testBuilder(
        builder,
        {
          'freezed_to_objectbox|lib/person.dart': source,
        },
        outputs: expectedOutputs,
      );
    });
  });
}
