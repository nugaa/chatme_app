import 'package:chatme/customwidgets/textstylescustom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constantes.dart';

Row customAppbar({@required String titulo}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      CircleAvatar(
        radius: 28,
        //TODO: imagem muda consoante utilizador
        backgroundImage: AssetImage('images/foto.jpg'),
      ),
      Text(
        //TODO: texto muda dependendo da tela
        'Minhas Mensagens',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      customIconButton(
        cor: Colors.white,
        icone: Icons.menu,
        tamanho: 35.0,
        onPress: () {
          //TODO: DEFINIÇÕES DE CONTA
        },
      ),
    ],
  );
}

IconButton customIconButton(
    {IconData icone, double tamanho, Function onPress, Color cor}) {
  return IconButton(
    icon: Icon(icone),
    color: cor,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    iconSize: tamanho,
    onPressed: onPress,
  );
}

Column contactoAvatar({String imagempath, String nome}) {
  return Column(
    children: <Widget>[
      CircleAvatar(
        radius: 28,
        //TODO: imagem muda consoante utilizador
        backgroundImage: AssetImage(imagempath),
      ),
      SizedBox(
        height: 5.0,
      ),
      Text(
        nome,
        style: textFieldStyle(
          tamanho: 12.0,
          cor: Colors.white,
        ),
      ),
    ],
  );
}

Column msgAvatar({String imagempath, Color cor}) {
  return Column(
    children: <Widget>[
      CircleAvatar(
        radius: 28,
        //TODO: imagem muda consoante utilizador
        backgroundImage: AssetImage(imagempath),
        child: Align(
          alignment: Alignment.bottomRight,
          child: Icon(
            Icons.brightness_1,
            color: cor,
            size: 16.0,
          ),
        ),
      ),
    ],
  );
}

Card mensagemCard(
    {@required String imagemPath,
    @required String nome,
    String ultimaMsg,
    String horas}) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(50.0),
        bottomLeft: Radius.circular(50.0),
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 6.0,
      ),
      child: ListTile(
        leading: msgAvatar(
          imagempath: imagemPath,
          cor: corOnline,
        ),
        title: Text(
          nome,
          style: textFieldStyle(
            tamanho: 16.0,
            fontWeight: FontWeight.bold,
            cor: Colors.white,
          ),
        ),
        subtitle: Text(
          ultimaMsg,
          style: textFieldStyle(
            tamanho: 14.0,
            fontWeight: FontWeight.normal,
            cor: Colors.white,
          ),
        ),
        trailing: Text(
          horas,
          style: textFieldStyle(
            tamanho: 16.0,
            fontWeight: FontWeight.normal,
            cor: Colors.white,
          ),
        ),
      ),
    ),
  );
}

Column novoContacto = Column(
  children: <Widget>[
    Container(
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 28,
        child: Icon(Icons.add, color: Colors.white),
      ),
    ),
    SizedBox(
      height: 5.0,
    ),
    Text(
      'Novo',
      style: textFieldStyle(
        tamanho: 12.0,
        cor: Colors.white,
      ),
    )
  ],
);

Padding textFieldCustom({
  bool esconderTexto,
  IconData icone,
  String textoHint,
  double padHorizontal,
  double padVertical,
  Function onChange,
  TextInputType textInput,
  TextEditingController control,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(
        horizontal:
            padHorizontal == null ? padHorizontal = 12.0 : padHorizontal,
        vertical: padVertical == null ? padVertical = 6.0 : padVertical),
    child: Container(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 2.0,
            color: corUserMsg,
          ),
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 35.0,
        ),
        child: TextField(
          controller: control,
          keyboardType: textInput == null ? TextInputType.text : textInput,
          cursorColor: Colors.white,
          textAlignVertical: TextAlignVertical.center,
          style: textFieldStyle(
            tamanho: 14.0,
            cor: Colors.white,
          ),
          obscureText: esconderTexto,
          decoration: InputDecoration(
            prefixIcon: Icon(
              icone,
              color: corUserMsg,
            ),
            hintText: textoHint,
            hintStyle: textFieldStyle(
              tamanho: 14.0,
              cor: Colors.white,
            ),
            border: InputBorder.none,
          ),
          onChanged: onChange,
        ),
      ),
    ),
  );
}

OutlineButton outlineButtonCustom({String texto, Function onPress}) {
  return OutlineButton(
    highlightedBorderColor: corBotao,
    color: corBotao,
    splashColor: corBotao,
    borderSide: BorderSide(
      width: 2.0,
      color: corBotao,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Text(
        texto,
        style: textFieldStyle(tamanho: 16.0, cor: corBotao),
      ),
    ),
    onPressed: onPress,
  );
}

Row separador = Row(
  children: <Widget>[
    Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
        ),
        child: Divider(
          thickness: 1.0,
          color: corUserMsg,
        ),
      ),
    ),
    Text(
      'OU',
      style: textFieldStyle(
        tamanho: 16,
        cor: corUserMsg,
        fontWeight: FontWeight.bold,
      ),
    ),
    Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 8.0,
        ),
        child: Divider(
          thickness: 1.0,
          color: corUserMsg,
        ),
      ),
    ),
  ],
);
