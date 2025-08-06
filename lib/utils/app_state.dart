import '../models/usuario.dart';

class AppState {
  static Usuario? usuarioLogado;
  
  static void login(Usuario usuario) {
    usuarioLogado = usuario;
  }
  
  static void logout() {
    usuarioLogado = null;
  }
  
  static bool get isLogado => usuarioLogado != null;
}