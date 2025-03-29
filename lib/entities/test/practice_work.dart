class PracticeWork {
  late String id;
  late String title;
  late String? description;
  late String? imagePath;

  PracticeWork({
    required this.id,
    required this.title,
    required this.description,
    this.imagePath,
  });

  PracticeWork.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    imagePath = json['imagePath'];
  }
}
