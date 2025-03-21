import 'package:edu_lab/components/course/module/module_card.dart';
import 'package:edu_lab/entities/course/module.dart';
import 'package:flutter/material.dart';

class ModuleList extends StatelessWidget {
  final List<Module> modules;
  final Map<String, bool> expandedModules;
  final Function(String) onToggleExpand;
  final Function(String) onGoToTasks;
  final Locale locale;

  const ModuleList({
    super.key,
    required this.modules,
    required this.expandedModules,
    required this.onToggleExpand,
    required this.onGoToTasks,
    required this.locale,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: modules.length,
      itemBuilder: (context, index) {
        final module = modules[index];
        final isExpanded = expandedModules[module.id] ?? false;

        return ModuleCard(
          id: module.id,
          title:
              module.title?.getTranslation(locale.languageCode) ?? 'No Title',
          description:
              module.description?.getTranslation(locale.languageCode) ??
              'No Description',
          videoPath: module.videoPath,
          isExpanded: isExpanded,
          onToggleExpand: () => onToggleExpand(module.id),
          onGoToTasks: () => onGoToTasks(module.id),
        );
      },
    );
  }
}
