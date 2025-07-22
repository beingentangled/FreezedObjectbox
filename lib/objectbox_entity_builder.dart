// lib/objectbox_entity_builder.dart

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'objectbox_entity_generator.dart';

Builder objectBoxEntityBuilder(BuilderOptions options) =>
    PartBuilder([ObjectBoxEntityGenerator()], '.objectbox_entity.dart');
