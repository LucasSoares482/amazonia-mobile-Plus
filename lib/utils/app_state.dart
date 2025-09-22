import '../models/usuario.dart';

/// Classe que gere o estado global da sessão do utilizador.
/// Contém apenas membros estáticos para acesso global.
class AppState {
  /// O utilizador atualmente autenticado na aplicação.
  static Usuario? usuarioLogado;
  
  /// Realiza o login, definindo o utilizador global.
  static void login(Usuario usuario) {
    usuarioLogado = usuario;
  }
  
  /// Realiza o logout, limpando os dados do utilizador da sessão.
  static void logout() {
    usuarioLogado = null;
  }
  
  /// Verifica se existe um utilizador autenticado.
  static bool get isLogado => usuarioLogado != null;
  
  /// Atualiza os dados do utilizador logado, se o ID corresponder.
  static void atualizarUsuario(Usuario usuario) {
    if (usuarioLogado?.id == usuario.id) {
      usuarioLogado = usuario;
    }
  }
}