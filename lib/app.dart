import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';

import 'screens/dashboard/dashboard_screen.dart';
import 'screens/upload/upload_screen.dart';
import 'screens/upload/loading_screen.dart';
import 'screens/analysis/analysis_result_screen.dart';
import 'screens/analysis/my_analyses_screen.dart';
import 'screens/negotiation/negotiation_screen.dart';
import 'screens/vin/vin_check_screen.dart';
import 'screens/vin/vin_report_screen.dart';
import 'screens/vin/full_vin_report_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "ContractAI",
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const DashboardScreen(),
        '/upload': (context) => const UploadScreen(),
        '/loading': (context) => const LoadingScreen(),
        '/result': (context) => const AnalysisResultScreen(),
        '/analyses': (context) => const MyAnalysesScreen(),
        '/negotiation': (context) => const NegotiationScreen(),
        '/vin': (context) => const VinCheckScreen(),
        '/vinReport': (context) => const VinReportScreen(),
        '/fullVinReport': (context) => const FullVinReportScreen(),
      },
    );
  }
}
