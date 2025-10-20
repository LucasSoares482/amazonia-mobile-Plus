import '../models/usuario.dart';
import '../core/session_manager.dart';

/// Classe que gere o estado global da sessão do utilizador.
/// Contém apenas membros estáticos para acesso global.
class AppState {
  /// O utilizador atualmente autenticado na aplicação.
  static Usuario? usuarioLogado;

  /// Inicializa o estado restaurando a sessão previamente persistida.
  static Future<void> initialize() async {
    usuarioLogado = await SessionManager.loadSession();
  }
  
  /// Realiza o login, definindo o utilizador global.
  static Future<void> login(Usuario usuario) async {
    usuarioLogado = usuario;
    await SessionManager.saveSession(usuario);
  }
  
  /// Realiza o logout, limpando os dados do utilizador da sessão.
  static Future<void> logout() async {
    usuarioLogado = null;
    await SessionManager.clearSession();
  }
  
  /// Verifica se existe um utilizador autenticado.
  static bool get isLogado => usuarioLogado != null;
  
  /// Atualiza os dados do utilizador logado, se o ID corresponder.
  static Future<void> atualizarUsuario(Usuario usuario) async {
    if (usuarioLogado?.id == usuario.id) {
      usuarioLogado = usuario;
      await SessionManager.saveSession(usuario);
    }
  }
}
