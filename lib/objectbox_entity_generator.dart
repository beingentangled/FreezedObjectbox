// lib/objectbox_entity_generator.dart

import 'dart:async';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:analyzer/dart/element/element.dart';

class ObjectBoxEntityGenerator extends Generator {
  @override
  FutureOr<String?> generate(LibraryReader library, BuildStep buildStep) async {
    final output = StringBuffer();

    for (final element in library.classes) {
      // Check for @freezed annotation
      final isFreezed = element.metadata.any((m) =>
          m.element?.enclosingElement?.name == 'freezed' ||
          m.element?.enclosingElement?.name == 'Freezed');
      if (!isFreezed) continue;

      final className = element.name;
      final entityName = '${className}Entity';

      output.writeln("import 'package:objectbox/objectbox.dart';");
      output.writeln("import '${buildStep.inputId.uri.pathSegments.last}';");
      output.writeln('');
      output.writeln('@Entity()');
      output.writeln('class $entityName {');
      output.writeln('  @Id()');
      output.writeln('  int id = 0;');

      for (final field in element.fields) {
        if (field.isStatic) continue;
        if (field.name == 'id') continue;
        output.writeln('  ${field.type} ${field.name};');
      }

      // Constructor
      output.write('\n  $entityName({this.id = 0');
      for (final field in element.fields) {
        if (field.isStatic || field.name == 'id') continue;
        output.write(', required this.${field.name}');
      }
      output.writeln('});');

      // fromModel
      output.writeln(
          '\n  factory $entityName.fromModel($className model) => $entityName(');
      output.writeln('    id: model.id,');
      for (final field in element.fields) {
        if (field.isStatic || field.name == 'id') continue;
        output.writeln('    ${field.name}: model.${field.name},');
      }
      output.writeln('  );');

      // toModel
      output.writeln('\n  $className toModel() => $className(');
      output.writeln('    id: id,');
      for (final field in element.fields) {
        if (field.isStatic || field.name == 'id') continue;
        output.writeln('    ${field.name}: ${field.name},');
      }
      output.writeln('  );');

      output.writeln('}');
      output.writeln('');
    }

    return output.isEmpty ? null : output.toString();
  }
}
