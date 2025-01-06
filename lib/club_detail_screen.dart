import 'package:flutter/material.dart';

class ClubDetailScreen extends StatefulWidget {
  final String clubName;
  final String clubLogo;
  final String coverImage;
  final String type;
  final String sport;
  final String level;
  final List<Activity> activities;
  final List<Admin> admins;
  final int memberCount;
  final int activityCount;
  final String schedule;
  final String description;

  const ClubDetailScreen({
    Key? key,
    required this.clubName,
    required this.clubLogo,
    required this.coverImage,
    required this.type,
    required this.sport,
    required this.level,
    required this.activities,
    required this.admins,
    required this.memberCount,
    required this.activityCount,
    required this.schedule,
    required this.description,
  }) : super(key: key);
  @override
  State<ClubDetailScreen> createState() => _ClubDetailScreenState();
}

class _ClubDetailScreenState extends State<ClubDetailScreen> {
  String? selectedSkillLevel;
  bool hasJoinedClub = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar với ảnh cover
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {},
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                widget.coverImage,
                fit: BoxFit.cover,
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Club info header
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(widget.clubLogo),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.clubName,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${widget.type} • ${widget.sport} • ${widget.level}',
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Navigation buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavButton(Icons.people, 'Thành viên'),
                    _buildNavButton(Icons.calendar_today, 'Hoạt động'),
                    _buildNavButton(Icons.photo_library, 'Thư viện'),
                    _buildNavButton(Icons.chat, 'Thảo luận'),
                  ],
                ),

                // Upcoming activities
                if (widget.activities.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: widget.activities.map((activity) {
                        return _buildActivityCard(activity);
                      }).toList(),
                    ),
                  ),

                // Stats
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStat('${widget.memberCount}', 'Thành viên'),
                      _buildStat('${widget.activityCount}', 'Hoạt động'),
                      _buildStat('Mỗi ngày', 'Lịch chơi'),
                    ],
                  ),
                ),

                // Description
                if (widget.description.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      widget.description,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),

                // Admins
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Admins',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: widget.admins.map((admin) {
                          return _buildAdminCard(admin);
                        }).toList(),
                      ),
                    ],
                  ),
                ),

                if (!hasJoinedClub)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _showJoinDialog,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Tham gia CLB',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showJoinDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header với logo và tên CLB
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(widget.clubLogo),
                    radius: 25,
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.clubName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Pickleball • ${widget.memberCount} Thành viên',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Tổ chức bởi
              const Text(
                'ĐƯỢC TỔ CHỨC BỞI',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: widget.admins
                      .map((admin) => Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  backgroundImage: AssetImage(admin.avatarUrl),
                                  radius: 25,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  admin.name,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ),
              const SizedBox(height: 30),

              // Chọn kỹ năng
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Kỹ năng Pickleball của bạn đang ở mức nào? ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: '*',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  'Newbie / 2.0',
                  '2.25',
                  '2.5',
                  '2.75',
                  '3.0',
                  '3.25',
                  '3.5',
                  '3.75',
                  '4.0',
                  '4.25',
                  '4.5',
                  '4.75',
                  '5.0+',
                ]
                    .map((skill) => ChoiceChip(
                          label: Text(skill),
                          selected: selectedSkillLevel == skill,
                          onSelected: (selected) {
                            setState(() {
                              selectedSkillLevel = selected ? skill : null;
                            });
                          },
                          backgroundColor: Colors.grey[200],
                          selectedColor: Colors.blue[100],
                        ))
                    .toList(),
              ),
              const SizedBox(height: 20),

              // Nút tham gia
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: selectedSkillLevel != null
                      ? () {
                          this.setState(() {
                            hasJoinedClub = true;
                          });
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Đã tham gia CLB thành công!'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Tham gia CLB',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey[700]),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: Colors.grey[700]),
        ),
      ],
    );
  }

  Widget _buildActivityCard(Activity activity) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.dayOfWeek,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(activity.time),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                      '${activity.currentParticipants}/${activity.maxParticipants} Đang tham gia'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildAdminCard(Admin admin) {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(admin.avatarUrl),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(
                  Icons.verified,
                  size: 16,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          admin.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          admin.role,
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
      ],
    );
  }
}

class Activity {
  final String dayOfWeek;
  final String time;
  final String title;
  final int currentParticipants;
  final int maxParticipants;

  Activity({
    required this.dayOfWeek,
    required this.time,
    required this.title,
    required this.currentParticipants,
    required this.maxParticipants,
  });
}

class Admin {
  final String name;
  final String role;
  final String avatarUrl;

  Admin({
    required this.name,
    required this.role,
    required this.avatarUrl,
  });
}
