enum TileType {
  register_company,
  manage_company,
  companies_summary,
}

String titleForType(TileType type) {
  switch (type) {
    case TileType.register_company:
      return 'Cadastrar nova empresa';
    case TileType.manage_company:
      return 'Gerenciar uma empresa';
    case TileType.companies_summary:
      return 'Empresas cadastradas';
  }
}

String getNavigationRoute(TileType type) {
  switch (type) {
    case TileType.register_company:
      return('/register_company');
    case TileType.manage_company:
      return('/manage_company');
    case TileType.companies_summary:
      return('/companies_summary');
  }
}