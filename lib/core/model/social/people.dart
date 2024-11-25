class People {
  const People(
      {required this.name,
      required this.image,
      required this.lastVisited,
      required this.viewed,
      required this.id});
  final String name;
  final String image;
  final DateTime lastVisited;
  final bool viewed;
  final String id;
}
