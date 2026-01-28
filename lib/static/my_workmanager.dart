enum MyWorkmanager {
  oneOff("restaurant-task.app", "restaurant-task.app"),
  periodic("restaurant-periodic.app", "restaurant-periodic.app");

  final String uniqueName;
  final String taskName;

  const MyWorkmanager(this.uniqueName, this.taskName);
}
