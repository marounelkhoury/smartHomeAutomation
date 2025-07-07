class SmartPlug {
  final int id;
  final String name;
  bool status;

  SmartPlug({required this.id, required this.name, this.status = false});
}