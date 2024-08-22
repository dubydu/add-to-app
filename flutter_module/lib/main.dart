import 'package:flutter/material.dart';
import 'package:flutter_module/screen/conversation_screen.dart';

/// Main entry
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MyApp(initialRoute: '/'),
  );
}

/// Conversation entry
@pragma('vm:entry-point')
void entryConversationScreen() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MyApp(initialRoute: '/conversation'),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.initialRoute});

  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const MyHomePage(),
        '/conversation': (context) => const ConversationScreen(),
      },
      initialRoute: initialRoute,
      theme: ThemeData(primarySwatch: Colors.teal),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Text('Flutter Module'),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push<void>(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) =>
                          const ConversationScreen(),
                    ),
                  );
                },
                child: const Text('Open Conversation'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
