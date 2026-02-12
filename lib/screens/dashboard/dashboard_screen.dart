import 'package:flutter/material.dart';
import '../../core/constants/strings.dart';
import '../../widgets/info_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Widget dashboardCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    String route,
  ) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: InfoCard(
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor:
                  Theme.of(context).primaryColor.withOpacity(0.1),
              child: Icon(icon,
                  color: Theme.of(context).primaryColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style:
                          const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text(AppStrings.appName)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            dashboardCard(
              context,
              AppStrings.uploadContract,
              "Analyze a new lease contract",
              Icons.upload_file,
              '/upload',
            ),
            dashboardCard(
              context,
              AppStrings.myAnalyses,
              "View previous analyses",
              Icons.description,
              '/analyses',
            ),
            dashboardCard(
              context,
              AppStrings.negotiationAssistant,
              "AI negotiation help",
              Icons.chat,
              '/negotiation',
            ),
            dashboardCard(
              context,
              AppStrings.vinCheck,
              "Vehicle history & info",
              Icons.directions_car,
              '/vin',
            ),
          ],
        ),
      ),
    );
  }
}
