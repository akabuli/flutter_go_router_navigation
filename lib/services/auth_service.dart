class AuthService {
  static bool _isAuthenticated = false;

  static bool get isAuthenticated => _isAuthenticated;

  static void login() {
    _isAuthenticated = true;
  }

  static void logout() {
    _isAuthenticated = false;
  }
}
