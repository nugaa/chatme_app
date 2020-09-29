import 'package:flutter/widgets.dart';

class TelaPrimeiroLogin extends StatefulWidget {
  static const String id = 'tela_primeiro_login';
  @override
  _TelaPrimeiroLoginState createState() => _TelaPrimeiroLoginState();
}

class _TelaPrimeiroLoginState extends State<TelaPrimeiroLogin> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Text('OLÁ'),
      ),
    );
  }
}
