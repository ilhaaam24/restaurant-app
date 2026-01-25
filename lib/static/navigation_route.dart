enum NavigationRoute {
  mainRoute("/"),
  detailRoute("/detail"),
  searchRoute("/search");

  const NavigationRoute(this.path);
  final String path;
}
