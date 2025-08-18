import '../models/usuario.dart';

class AppState {
  static Usuario? usuarioLogado;
  
  static void login(Usuario usuario) {
    usuarioLogado = usuario;
  }
  
  static void logout() {
    // Apenas remove o usuário da sessão, não apaga do banco
    usuarioLogado = null;
  }
  
  static bool get isLogado => usuarioLogado != null;
  
  static void atualizarUsuario(Usuario usuario) {
    if (usuarioLogado?.id == usuario.id) {
      usuarioLogado = usuario;
    }
  }
}