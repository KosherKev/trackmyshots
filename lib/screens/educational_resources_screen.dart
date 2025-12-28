import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackmyshots/services/app_state.dart';
import 'package:trackmyshots/screens/educational_detail_screen.dart';
import 'package:trackmyshots/screens/marketplace_screen.dart';
import 'package:trackmyshots/widgets/standard_card.dart';

class EducationalResourcesScreen extends StatefulWidget {
  const EducationalResourcesScreen({super.key});

  @override
  State<EducationalResourcesScreen> createState() => _EducationalResourcesScreenState();
}

class _EducationalResourcesScreenState extends State<EducationalResourcesScreen> {
  // int _currentIndex = 3; // Managed by MainScreen

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back, color: Colors.black),
        //   onPressed: () => Navigator.pop(context),
        // ),
        title: const Text(
          'Educational Resources',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.black),
            onPressed: () {
              Navigator.pushNamed(context, '/reminders');
            },
          ),
        ],
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          final vaccines = appState.vaccines;
          
          return StandardScreenContainer(
            children: [
              StandardCard(
                text: 'Vaccine Purpose',
                leading: const Icon(
                  Icons.article_outlined,
                  color: Color(0xFF0066B3),
                  size: 28,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EducationalDetailScreen.vaccinePurpose(context),
                    ),
                  );
                },
              ),
              StandardCard(
                text: 'Potential Side Effects',
                leading: const Icon(
                  Icons.warning_amber_outlined,
                  color: Color(0xFF0066B3),
                  size: 28,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EducationalDetailScreen.sideEffects(context),
                    ),
                  );
                },
              ),
              StandardCard(
                text: 'Importance of Adherence',
                leading: const Icon(
                  Icons.verified_outlined,
                  color: Color(0xFF0066B3),
                  size: 28,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EducationalDetailScreen.adherenceImportance(context),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Recommended',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              StandardCard(
                text: 'Baby Essentials & Medicines',
                leading: const Icon(
                  Icons.shopping_bag_outlined,
                  color: Color(0xFF0066B3),
                  size: 28,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MarketplaceScreen(),
                    ),
                  );
                },
              ),
              StandardCard(
                text: 'Skin Care for Newborns',
                leading: const Icon(
                  Icons.child_care,
                  color: Color(0xFF0066B3),
                  size: 28,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EducationalDetailScreen.newbornSkinCare(context),
                    ),
                  );
                },
              ),
              StandardCard(
                text: 'Immunization Overview',
                leading: const Icon(
                  Icons.vaccines_outlined,
                  color: Color(0xFF0066B3),
                  size: 28,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EducationalDetailScreen.immunizationOverview(context),
                    ),
                  );
                },
              ),
              
              if (vaccines.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
                  child: Text(
                    'Vaccine Guide',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0066B3),
                    ),
                  ),
                ),
                ...vaccines.map((vaccine) => StandardCard(
                  text: vaccine.name,
                  leading: const Icon(Icons.vaccines, color: Color(0xFF0066B3), size: 28),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EducationalDetailScreen.forVaccine(context, vaccine),
                      ),
                    );
                  },
                )),
              ],
              
              const SizedBox(height: 100), // Space for bottom nav
            ],
          );
        },
      ),
    );
  }
}
