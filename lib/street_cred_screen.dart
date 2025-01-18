import 'package:flutter/material.dart';
import 'category_cards.dart';
import 'dupr_ranking_screen.dart';
import 'street_scred.dart';
import 'api_service.dart';

class StreetCredScreen extends StatefulWidget {
  final bool showBottomNav;
  final bool showAppBar;

  const StreetCredScreen({
    Key? key,
    this.showBottomNav = true,
    this.showAppBar = true,
  }) : super(key: key);

  @override
  State<StreetCredScreen> createState() => _StreetCredScreenState();
}

class _StreetCredScreenState extends State<StreetCredScreen> {
  String selectedPeriod = '01/2025';
  List<StreetCred> streetCreds = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _fetchStreetCred();
  }

  Future<void> _fetchStreetCred() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final creds = await ApiService.fetchStreetCred(selectedPeriod);
      setState(() {
        streetCreds = creds;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Widget _buildPeriodButton(String period, {bool isSelected = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: TextButton(
        onPressed: () {
          setState(() {
            selectedPeriod = period;
          });
          _fetchStreetCred();
        },
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
        child: Text(
          period,
          style: TextStyle(
            color: isSelected ? Colors.blue : Colors.grey,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(StreetCred cred) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            cred.getSkillTypeDisplayName(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              for (int i = 0; i < cred.topPlayersAvatars.length && i < 3; i++)
                Padding(
                  padding: EdgeInsets.only(right: i < 2 ? 8 : 0),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: cred.topPlayersAvatars[i] != null
                        ? NetworkImage(cred.topPlayersAvatars[i]!)
                        : const AssetImage('assets/default_avatar.jpg')
                            as ImageProvider,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  cred.fullName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${cred.credPoints}crd',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Location and Category Pills
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Ho Chi Minh City Metropolitan',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.green[400],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Thể thao • Pickleball',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Time Period Selector
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  _buildPeriodButton('01/2025',
                      isSelected: selectedPeriod == '01/2025'),
                  _buildPeriodButton('12/2024',
                      isSelected: selectedPeriod == '12/2024'),
                  _buildPeriodButton('11/2024',
                      isSelected: selectedPeriod == '11/2024'),
                  _buildPeriodButton('YTD',
                      isSelected: selectedPeriod == 'YTD'),
                ],
              ),
            ),

            // Grid of Categories
            if (isLoading)
              const Expanded(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (error != null)
              Expanded(
                child: Center(child: Text('Lỗi: $error')),
              )
            else
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _fetchStreetCred,
                  child: GridView.count(
                    crossAxisCount: 2,
                    padding: const EdgeInsets.all(16),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: streetCreds
                        .map((cred) => _buildCategoryCard(cred))
                        .toList(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
