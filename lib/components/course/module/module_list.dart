import 'package:edu_lab/entities/models/module_model.dart';
import 'package:flutter/material.dart';

class ModuleList extends StatelessWidget {
  final List<ModuleModel> modules;
  final Map<String, bool> expandedModules;
  final Function(String) onToggleExpand;
  final Function(String) goToModule;
  final Function(ModuleModel)? onEditModule;
  final int role;

  const ModuleList({
    super.key,
    required this.modules,
    required this.expandedModules,
    required this.onToggleExpand,
    required this.goToModule,
    this.onEditModule,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          modules.map((module) {
            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  ListTile(
                    title: Text(module.title),
                    subtitle: Text(module.description ?? ''),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (role == 1)
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orange),
                            tooltip: 'Өңдеу',
                            onPressed: () {
                              if (onEditModule != null) {
                                onEditModule!(module);
                              }
                            },
                          ),
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_forward,
                            color: Colors.blue,
                          ),
                          tooltip: 'Тапсырмаларға өту',
                          onPressed: () => goToModule(module.id),
                        ),
                      ],
                    ),
                    onTap: () => onToggleExpand(module.id),
                  ),
                  if (expandedModules[module.id] ?? false)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(module.description ?? 'Сипаттама жоқ'),
                    ),
                ],
              ),
            );
          }).toList(),
    );
  }
}
