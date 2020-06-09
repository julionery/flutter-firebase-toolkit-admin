import 'package:flutter/material.dart';
import 'package:toolkit_app_company/blocs/login_bloc.dart';
import 'package:toolkit_app_company/pages/home_page.dart';
import 'package:toolkit_app_company/widgets/input_field.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _loginBloc = LoginBloc();

  @override
  void initState() {
    super.initState();
    
    _loginBloc.outState.listen((state){
      switch(state){
        case LoginState.SUCCESS:
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context)=>HomePage())
          );
          break;
        case LoginState.FAIL:
          showDialog(
            context: context,
            builder: (context)=>AlertDialog(
              title: Text("Error..."),
              content: Text("Você não possui os privilégios necessários."),
            )
          );
          break;
        case LoginState.IDLE:
        case LoginState.LOADING:
      }
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: StreamBuilder<LoginState>(
        stream: _loginBloc.outState,
        initialData: LoginState.LOADING,
        builder: (context, snapshot) {
          print(snapshot.data);
          switch(snapshot.data){
            case LoginState.LOADING:
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.redAccent),
                ),
              );
              break;
            case LoginState.SUCCESS:
            case LoginState.IDLE:
            case LoginState.FAIL:
              return Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(),
                  SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Icon(
                            Icons.store_mall_directory,
                            color: Colors.redAccent,
                            size: 160,
                          ),
                          InputField(
                            icon: Icons.person_outline,
                            hint: "Usuário",
                            obscure: false,
                            stream: _loginBloc.outEmail,
                            onChanged: _loginBloc.changeEmail,
                          ),
                          InputField(
                            icon: Icons.lock_outline,
                            hint: "Senha",
                            obscure: true,
                            stream: _loginBloc.outPassword,
                            onChanged: _loginBloc.changePassword,
                          ),
                          SizedBox(height: 25,),
                          StreamBuilder<bool>(
                              stream: _loginBloc.outSubmitValid,
                              builder: (context, snapshot) {
                                return SizedBox(
                                  height: 50,
                                  child: RaisedButton(
                                    color: Colors.redAccent,
                                    child: Text("Entrar"),
                                    onPressed: snapshot.hasData ? _loginBloc.submit : null,
                                    textColor: Colors.white,
                                    disabledColor: Colors.redAccent.withAlpha(140),
                                  ),
                                );
                              }
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
              break;
          }
        }
      ),
    );
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }


}
