import 'package:chatme/customwidgets/textstylescustom.dart';
import 'package:chatme/networking/firebase_storage_repo.dart';
import 'package:chatme/networking/servicos_firebase_auth.dart';
import 'package:chatme/networking/servicos_firestore_database.dart';
import 'package:chatme/telas/telamensagens.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constantes.dart';

Container customAppbar(
    {@required String titulo,
    String userEmail,
    Widget imagemAvatar,
    IconData iconePrefixo,
    @required IconData iconeSufixo,
    Function onTapp,
    Function onTap2}) {
  return Container(
    color: Colors.white12,
    padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            InkWell(
              onTap: onTapp,
              child: Icon(
                iconePrefixo,
                color: Colors.white,
              ),
            ),
            imagemAvatar == null
                ? FutureBuilder(
                    future: FirebaseStorageRepo()
                        .obterUserAvatar(user: userEmail, diametro: 28.0),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done)
                        return Container(
                          child: snapshot.data,
                        );
                      else if (snapshot.connectionState ==
                          ConnectionState.waiting)
                        return Container(
                          child: CircularProgressIndicator(),
                        );
                      return Container();
                    },
                  )
                : imagemAvatar,
          ],
        ),
        Text(
          titulo,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        customIconButton(
          cor: Colors.white,
          icone: iconeSufixo,
          tamanho: 35.0,
          onPress: onTap2,
        ),
      ],
    ),
  );
}

IconButton customIconButton(
    {IconData icone, double tamanho, Function onPress, Color cor}) {
  return IconButton(
    icon: Icon(icone),
    color: cor,
    splashColor: corUserMsg,
    highlightColor: Colors.transparent,
    iconSize: tamanho,
    onPressed: onPress,
  );
}

Column contactoAvatar(
    {@required BuildContext contexto,
    @required Widget avatar,
    String nomeDestino,
    String meuUsername,
    double diametro}) {
  return Column(
    children: <Widget>[
      InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          Navigator.pushReplacementNamed(contexto, TelaMensagens.id,
              arguments: {'nome': nomeDestino, 'avatar': avatar});
          ServicosFirestoreDatabase().criarSalaChat(meuUsername, nomeDestino);
        },
        child: CircleAvatar(
          radius: diametro == null ? diametro = 28.0 : diametro,
          child: avatar,
        ),
      ),
      SizedBox(
        height: 5.0,
      ),
      Text(
        nomeDestino == null ? nomeDestino = '' : nomeDestino,
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
    {@required CircleAvatar imagemAvatar,
    @required String nome,
    String ultimaMsg,
    String horas,
    BuildContext context}) {
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
        leading: imagemAvatar,
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
          maxLines: 1,
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
    InkWell(
      splashColor: Colors.transparent,
      onTap: () {},
      child: Container(
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 28,
          child: Icon(Icons.add, color: Colors.white),
        ),
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
  Key chave,
  bool esconderTexto,
  IconData icone,
  String textoHint,
  double padHorizontal,
  double padVertical,
  Function onChange,
  TextInputType textInput,
  TextEditingController control,
  Color corDoTexto,
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
          key: chave,
          controller: control,
          keyboardType: textInput == null ? TextInputType.text : textInput,
          cursorColor: Colors.white,
          textAlignVertical: TextAlignVertical.center,
          style: textFieldStyle(
            tamanho: 14.0,
            cor: corDoTexto == null ? corDoTexto = Colors.white : corDoTexto,
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

Container salaChatCard(
    {@required BuildContext context,
    @required bool enviadoPorMim,
    @required String textoMensagem,
    @required String horas,
    @required String remetente}) {
  return Container(
    padding: enviadoPorMim
        ? const EdgeInsets.only(left: 50.0, bottom: 10.0, right: 4.0)
        : const EdgeInsets.only(right: 50.0, bottom: 10.0, left: 4.0),
    child: Column(
      crossAxisAlignment:
          enviadoPorMim ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment:
              enviadoPorMim ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Flexible(
              child: Container(
                decoration: ShapeDecoration(
                  color: enviadoPorMim ? Colors.black38 : corUserMsg,
                  shape: RoundedRectangleBorder(
                    borderRadius: enviadoPorMim
                        ? BorderRadius.only(
                            topLeft: Radius.circular(50.0),
                            topRight: Radius.circular(50.0),
                            bottomLeft: Radius.circular(50.0),
                          )
                        : BorderRadius.only(
                            topRight: Radius.circular(50.0),
                            topLeft: Radius.circular(50.0),
                            bottomRight: Radius.circular(50.0),
                          ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    '$textoMensagem',
                    textAlign: TextAlign.justify,
                    style: textFieldStyle(
                      tamanho: 14,
                      fontWeight: FontWeight.w500,
                      cor: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: enviadoPorMim
              ? const EdgeInsets.only(
                  right: 12.0,
                  top: 2.0,
                )
              : const EdgeInsets.only(
                  left: 12.0,
                  top: 2.0,
                ),
          child: Align(
            alignment:
                enviadoPorMim ? Alignment.bottomRight : Alignment.bottomLeft,
            child: Text(
              enviadoPorMim ? horas : '$remetente $horas',
              style: textFieldStyle(
                tamanho: 14,
                cor: Colors.white24,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        )
      ],
    ),
  );
}

mostrarAvatar(String userAvatar) {
  if (userAvatar != null) {
    final avatar =
        FirebaseStorageRepo().obterUserAvatar(user: userAvatar, diametro: 20.0);
    return avatar;
  }
}

Padding textfieldFlutuante(
    {BuildContext context, String useremail, String destinatario}) {
  TextEditingController mensagem = TextEditingController();
  return Padding(
    padding:
        const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 10.0, top: 6.0),
    child: TextField(
      keyboardType: TextInputType.multiline,
      maxLines: null,
      controller: mensagem,
      style: textFieldStyle(
        tamanho: 16,
        cor: Colors.white,
      ),
      decoration: InputDecoration(
        hintText: 'Escreva uma mensagem...',
        hintStyle: textFieldStyle(
          tamanho: 16,
          cor: Colors.white30,
        ),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              InkWell(
                splashColor: Colors.transparent,
                child: FaIcon(
                  FontAwesomeIcons.images,
                  size: 28.0,
                  color: Colors.white,
                ),
                onTap: () async {
                  //TODO: aceder à galeria
                },
              ),
              SizedBox(
                width: 18.0,
              ),
              IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.paperPlane,
                  size: 28.0,
                  color: Colors.white,
                ),
                onPressed: () async {
                  String _passarUserName = await ServicosFirestoreDatabase()
                      .getMeuUsername(useremail);
                  String textoMensagem = mensagem.text;
                  if (textoMensagem.length < 1 || textoMensagem.isEmpty) {
                    Scaffold.of(context).showSnackBar(
                        snackBarAviso('Não envie mensagens em branco.'));
                  } else {
                    String email =
                        await ServicosFirebaseAuth().obterUtilizador();
                    ServicosFirestoreDatabase().enviarMensagem(
                        _passarUserName, textoMensagem, email, destinatario);
                    mensagem.clear();
                  }
                },
              ),
            ],
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.0),
          borderSide: BorderSide(
            color: Colors.white,
            width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.0),
          borderSide: BorderSide(
            color: Colors.white,
            width: 2.0,
          ),
        ),
      ),
    ),
  );
}

SnackBar snackBarAviso(String aviso) {
  return SnackBar(
    backgroundColor: Colors.black87,
    content: Text(
      aviso,
      style: textFieldStyle(
        tamanho: 16,
        cor: Colors.white,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}
