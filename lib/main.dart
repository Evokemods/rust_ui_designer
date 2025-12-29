import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/designer_state.dart';
import 'screens/designer_screen.dart';

void main() {
  runApp(const RustUIDesignerApp());
}

class RustUIDesignerApp extends StatelessWidget {
  const RustUIDesignerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DesignerState(),
      child: MaterialApp(
        title: 'Rust UI Designer',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        home: const DesignerScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
