import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:morango/firebase_options.dart';
import 'package:morango/models/device.dart';
import 'package:morango/services/web.dart';
import 'package:shared_preferences/shared_preferences.dart';


// chave global para navegar entre as telas
final navigatorKey = GlobalKey<NavigatorState>();

void main() async{
  
  
  //garante que o firebase esteja inicializado
  WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  
//Firebase messages
  FirebaseMessaging messaging = FirebaseMessaging.instance;
 String? token = await messaging.getToken();
   NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

 // Verifica se o usuario autorizou as mensagens PUSH
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('[main#autorizouMensagem] SIM PERMITIU');
     _startPushNotificationHandler(messaging);
  } else if (settings.authorizationStatus==AuthorizationStatus.provisional) {

    print('[main#autorizouMensagem] PERMITIU PROVISORIAMENTE ');
    _startPushNotificationHandler(messaging);
  }else {
    print('[main#autorizouMensagem] NAO PERMITIU - NEGADA!!!');

  }
  
  runApp(const MyApp());


}


void _startPushNotificationHandler(FirebaseMessaging messaging) async{
      final Logger logger = Logger();
    String? token = await messaging.getToken();
    logger.i('[#startPushNotificationHandler] TOKEN: $token');
    setPushToken(token);

    //Quando o app estiver aberto
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      logger.i('[#startPushNotificationHandler] Recebeu foreground (app Aberto)!');
      print('dados da mensagem: ${message.data}');

      if (message.notification != null) {
        print('msg tambem veio com uma notificacao: ${message.notification}');
      }
    });

    //Quando o app estiver fechado
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Terminou
    var dadosRecebidos = await FirebaseMessaging.instance.getInitialMessage();
    if (dadosRecebidos!.data.isNotEmpty) {
      if (dadosRecebidos.data['message'] != null) {
        showMyDialog(dadosRecebidos.data['message']);

      }

    }


}




//Envia o token para o servidor
void setPushToken(String? token) async {

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? prefsToken = prefs.getString('pushToken');
  bool? prefsSent = prefs.getBool('tokenSent');

  print('Prefs token - $prefsToken');

  if(prefsToken != token || (prefsToken == token && prefsSent == false)) {
    print('Enviando o token para o servidor');

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String? brand;
    String? model;

    // Mostrar os vários tipos de tratamento que existem
    // https://github.com/fluttercommunity/plus_plugins/blob/main/packages/device_info_plus/device_info_plus/example/lib/main.dart

    if(Platform.isAndroid) {

      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      print('Running on ${androidInfo.model}');  // e.g. "Moto G (4)"

      model = androidInfo.model;
      brand = androidInfo.brand;
    } else {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      print('Running on ${iosInfo.utsname.machine}');  // e.g. "iPod7,1"

      model = iosInfo.utsname.machine;
      brand = 'Apple';
    }


    Device device = Device(token: token, brand: brand, model: model);
    sendDevice(device);
  }
}

//listener para mensagens em background
// quando voltar a funcionar, verificar se o token mudou e enviar para o servidor
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async{
  
  print("---------------------------------");
  print('[main#autorizouMensagem] Mensagem recebida em background: ${message.notification}');
  return Future<void>.value();

}






void showMyDialog(String message){
  //botao
  Widget okButton = OutlinedButton(
    onPressed: () {
      //Passa o contexto do navigatorKey que vai ser preenchido no futuro.
      Navigator.pop(navigatorKey.currentContext!);
    },
    child: const Text('OK'),
  );

  AlertDialog alerta = AlertDialog(
    title: const Text('Promoção Imperdível'),
    content: Text(message),
    actions: [
      okButton,
    ],
  );

  //Empurrando o contexto pra dentro.
  showDialog(context: navigatorKey.currentContext!, builder: (BuildContext context){
    return alerta;

  });

}









class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Raiz do app
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Morango',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Morango '),
      navigatorKey: navigatorKey,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Colors.green[300],

        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Voce apertou o botão essa quantidade de vezes:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.backup_table),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


