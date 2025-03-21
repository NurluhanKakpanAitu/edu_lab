import 'package:flutter/material.dart';
import 'package:edu_lab/components/shared/video_player.dart';
import 'package:edu_lab/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class ModuleCard extends StatelessWidget {
  final String id;
  final String title;
  final String description;
  final String? videoPath;
  final bool isExpanded;
  final VoidCallback onToggleExpand;
  final VoidCallback onGoToTasks;

  const ModuleCard({
    super.key,
    required this.id,
    required this.title,
    required this.description,
    this.videoPath,
    required this.isExpanded,
    required this.onToggleExpand,
    required this.onGoToTasks,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Module Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
                ),
                TextButton(
                  onPressed: onToggleExpand,
                  child: Text(
                    isExpanded
                        ? localizations.translate('collapse')
                        : localizations.translate('expand'),
                  ),
                ),
              ],
            ),

            if (isExpanded) ...[
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 8),

              // Module Video
              if (videoPath != null)
                videoPath!.startsWith('http')
                    ? TextButton(
                      onPressed: () {
                        launchUrl(Uri.parse(videoPath!));
                      },
                      child: Text(
                        localizations.translate('openVideoLink'),
                        style: const TextStyle(color: Colors.blue),
                      ),
                    )
                    : VideoPlayerWidget(videoUrl: videoPath!),

              const SizedBox(height: 20),

              // Go to Tasks Button
              ElevatedButton(
                onPressed: onGoToTasks,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  localizations.translate('goToTasks'),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
