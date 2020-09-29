import 'package:chatme/constantes.dart';

class CompararRegex {
  bool validarEmail({String email}) {
    String padrao = regexpEmail;
    RegExp regExp = new RegExp(padrao);
    return regExp.hasMatch(email);
  }
}
