import 'package:converse_ai/tools/authgate.dart';
import 'package:converse_ai/tools/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Gemini.init(
    apiKey: "AIzaSyCcLWJMgkqSXzYNF_ND9qWY1RIhiHYUDKU",
  );
  await Supabase.initialize(
    url: "https://xkuaitfeoxxwrewjenjv.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhrdWFpdGZlb3h4d3Jld2plbmp2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTYzOTA4MjksImV4cCI6MjAzMTk2NjgyOX0.3jZkmzDx6KoYbRs7sxPe9CYIzupQfsL510_umdIgGLU",
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Converse AI',
      darkTheme: ThemeData(
        colorScheme: flexSchemeDark,
        useMaterial3: true,
      ),
      theme: ThemeData(
        colorScheme: flexSchemeLight,
        useMaterial3: true,
      ),
      themeMode: ThemeMode.dark,
      home: const AuthGate(),
      // home: const CreateBot(),
    );
  }
}
