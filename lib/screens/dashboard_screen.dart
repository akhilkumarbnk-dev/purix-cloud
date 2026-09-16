import 'package:flutter/material.dart';
import 'package:purix_academy/config/theme.dart';
import 'package:purix_academy/models/user_model.dart';
import 'package:purix_academy/services/local_storage_service.dart';
import 'package:purix_academy/utils/helpers.dart';
import 'package:purix_academy/screens/subject_screen.dart';
import 'package:purix_academy/screens/profile_screen.dart';
import 'package:purix_academy/screens/free_section_screen.dart';
import 'package:purix_academy/widgets/core_module_card.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _localStorageService = LocalStorageService();
  UserModel? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final user = await _localStorageService.getUser();
    setState(() {
      _user = user;
      _isLoading = false;
    });
  }

  void _launchWhatsApp() async {
    final whatsappUrl = 'https://wa.me/916201161834?text=Hi%20Purix%20Academy';
    if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
      await launchUrl(Uri.parse(whatsappUrl), mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppTheme.backgroundColor,
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(AppTheme.primaryColor),
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    // Header
                    Container(
                      padding: EdgeInsets.all(AppTheme.spacingL),
                      color: AppTheme.backgroundColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${AppHelpers.getGreeting()}, ${_user?.name ?? "Student"}',
                                    style: AppTheme.headingMedium,
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    _user?.selectedClass ?? 'Class 8',
                                    style: AppTheme.bodySmall.copyWith(
                                      color: AppTheme.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const ProfileScreen(),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppTheme.primaryColor.withOpacity(0.2),
                                  ),
                                  child: Center(
                                    child: Text(
                                      _user?.name?[0].toUpperCase() ?? 'S',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: AppTheme.spacingL),

                          // Welcome Card
                          Container(
                            padding: EdgeInsets.all(AppTheme.spacingL),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppTheme.primaryColor.withOpacity(0.3),
                              ),
                              borderRadius: BorderRadius.circular(12),
                              color: AppTheme.surfaceColor,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'PURIX ACADEMY',
                                  style: AppTheme.bodySmall.copyWith(
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Target: 95+',
                                  style: AppTheme.bodyMedium.copyWith(
                                    color: AppTheme.tertiaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Core Modules
                    Padding(
                      padding: EdgeInsets.all(AppTheme.spacingL),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CORE MODULES',
                            style: AppTheme.bodySmall.copyWith(
                              color: AppTheme.textSecondaryColor,
                              fontSize: 12,
                              letterSpacing: 2,
                            ),
                          ),
                          SizedBox(height: AppTheme.spacingM),
                          GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            mainAxisSpacing: AppTheme.spacingM,
                            crossAxisSpacing: AppTheme.spacingM,
                            children: [
                              CoreModuleCard(
                                title: 'MCQ TEST',
                                icon: Icons.help_outline,
                                color: AppTheme.primaryColor,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => SubjectScreen(
                                        type: 'MCQ',
                                        selectedClass: _user?.selectedClass ?? 'Class 8',
                                      ),
                                    ),
                                  );
                                },
                              ),
                              CoreModuleCard(
                                title: 'PRACTICE SETS',
                                icon: Icons.assessment,
                                color: AppTheme.tertiaryColor,
                                onTap: () {},
                              ),
                              CoreModuleCard(
                                title: 'PURIX NOTES',
                                icon: Icons.description,
                                color: AppTheme.secondaryColor,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => SubjectScreen(
                                        type: 'Notes',
                                        selectedClass: _user?.selectedClass ?? 'Class 8',
                                      ),
                                    ),
                                  );
                                },
                              ),
                              CoreModuleCard(
                                title: 'FREE MATRIX',
                                icon: Icons.star,
                                color: AppTheme.primaryColor,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => FreeSectionScreen(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Pro Pass Card
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppTheme.spacingL),
                      child: Container(
                        padding: EdgeInsets.all(AppTheme.spacingL),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppTheme.tertiaryColor.withOpacity(0.5),
                          ),
                          borderRadius: BorderRadius.circular(12),
                          color: AppTheme.tertiaryColor.withOpacity(0.05),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: AppTheme.tertiaryColor,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'PURIX PRO PASS',
                                      style: AppTheme.bodyMedium.copyWith(
                                        color: AppTheme.tertiaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.tertiaryColor.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    '₹599',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.tertiaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: AppTheme.spacingM),
                            Text(
                              'Unlock all locked tests, complete formula sheets & chapter assignment banks',
                              style: AppTheme.bodySmall.copyWith(
                                color: AppTheme.textSecondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: AppTheme.spacingL),

                    // Help Button
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppTheme.spacingL),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: _launchWhatsApp,
                          icon: const Icon(Icons.message),
                          label: const Text('HELP DESK'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.tertiaryColor.withOpacity(0.2),
                            foregroundColor: AppTheme.tertiaryColor,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: AppTheme.spacingL),
                  ],
                ),
              ),
      ),
    );
  }
}