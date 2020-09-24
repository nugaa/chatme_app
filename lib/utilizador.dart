class Utilizador {
  String _nome;
  String _email;
  String _password;
  String _passverifica;

  String get passverifica => _passverifica;

  set passverifica(String value) {
    _passverifica = value;
  }

  String get password => _password;

  set password(String value) {
    _password = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }
}
