import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MatchDetailScreen extends StatefulWidget {
  final String time;
  final String date;
  final String title;
  final String teamName;
  final String teamLogo;
  final String subtitle;
  final String location;
  final String fullAddress;
  final String level;
  final String price;
  final List<String> notes;
  final int? maxParticipants;
  final int? currentParticipants;

  const MatchDetailScreen({
    Key? key,
    required this.time,
    required this.date,
    required this.title,
    required this.teamName,
    required this.teamLogo,
    required this.subtitle,
    required this.location,
    required this.fullAddress,
    required this.level,
    required this.price,
    required this.notes,
    this.maxParticipants,
    this.currentParticipants,
  }) : super(key: key);

  @override
  State<MatchDetailScreen> createState() => _MatchDetailScreenState();
}

class _MatchDetailScreenState extends State<MatchDetailScreen> {
  bool isRankingView = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.time} ${widget.date}',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
            Text(
              widget.title,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: DefaultTabController(
        length: 4,
        child: Column(
          children: [
            const TabBar(
              isScrollable: true,
              tabs: [
                Tab(text: 'Chi tiết'),
                Tab(text: 'Người tham gia'),
                Tab(text: 'Thanh toán'),
                Tab(text: 'Trận đấu'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildDetailsTab(),
                  _buildParticipantsTab(),
                  _buildPaymentTab(),
                  _buildMatchesTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchesTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              '2 Sân • 9 người chơi • 9 lượt',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
          ),

          // Filter buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildFilterButton('Xếp hạng', isRankingView, () {
                  setState(() {
                    isRankingView = true;
                  });
                }),
                const SizedBox(width: 8),
                _buildFilterButton('Trận đấu', !isRankingView, () {
                  setState(() {
                    isRankingView = false;
                  });
                }),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Show different content based on selected view
          if (isRankingView) _buildRankingView() else _buildMatchesView(),
        ],
      ),
    );
  }

  Widget _buildMatchesView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Round 1
        _buildRound('Vòng 1', [
          MatchInfo(
            court: 'Sân 9',
            score: '11-7',
            team1: TeamInfo(
              player1: PlayerInfo('Thanh Tâm', 'assets/pickball_player.webp'),
              player2: PlayerInfo('Man Phan', 'assets/pickball_player.webp'),
            ),
            team2: TeamInfo(
              player1:
                  PlayerInfo('Dương Quố...', 'assets/pickball_player.webp'),
              player2: PlayerInfo('Khánh Duy', 'assets/pickball_player.webp'),
              isGrayed: true,
            ),
          ),
          MatchInfo(
            court: 'Sân 10',
            score: '1-11',
            team1: TeamInfo(
              player1: PlayerInfo('Vivian', 'assets/pickball_player.webp'),
              player2: PlayerInfo('Canary', 'assets/pickball_player.webp'),
            ),
            team2: TeamInfo(
              player1:
                  PlayerInfo('Huỳnh Trun...', 'assets/pickball_player.webp'),
              player2: PlayerInfo('Ngọc Minh', 'assets/pickball_player.webp'),
            ),
          ),
        ]),

        // BYES section
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(
                'BYES',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              const Text('Hữu Thuận VNB'),
            ],
          ),
        ),

        // Round 2
        _buildRound('Vòng 2', [
          MatchInfo(
            court: 'Sân 9',
            score: '11-1',
            team1: TeamInfo(
              player1: PlayerInfo('Khánh Duy', 'assets/pickball_player.webp'),
              player2: PlayerInfo('Ngọc Minh', 'assets/pickball_player.webp'),
            ),
            team2: TeamInfo(
              player1: PlayerInfo('Huỳnh Trung', 'assets/pickball_player.webp'),
              player2: PlayerInfo('Man Phan', 'assets/pickball_player.webp'),
              isGrayed: true,
            ),
          ),
          MatchInfo(
            court: 'Sân 10',
            score: '1-11',
            team1: TeamInfo(
              player1: PlayerInfo('Dương Quốc', 'assets/pickball_player.webp'),
              player2: PlayerInfo('Canary', 'assets/pickball_player.webp'),
            ),
            team2: TeamInfo(
              player1: PlayerInfo('Hữu Thuận', 'assets/pickball_player.webp'),
              player2: PlayerInfo('Thanh Tâm', 'assets/pickball_player.webp'),
            ),
          ),
        ]),
      ],
    );
  }

  Widget _buildRankingView() {
    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Spacer(),
              Column(
                children: [
                  const Text(
                    'THẮNG',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  const Text(
                    'HIỆU SỐ',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 40),
            ],
          ),
        ),

        // Ranking list
        ..._buildRankingList(),
      ],
    );
  }

  List<Widget> _buildRankingList() {
    final rankings = [
      RankingInfo(
        rank: 1,
        name: 'Hữu Thuận VNB',
        avatar: 'assets/pickball_player.webp',
        wins: 6,
        totalGames: 8,
        scoreDiff: 32,
      ),
      RankingInfo(
        rank: 2,
        name: 'Thanh Tâm',
        avatar: 'assets/pickball_player.webp',
        wins: 6,
        totalGames: 8,
        scoreDiff: 29,
      ),
      RankingInfo(
        rank: 3,
        name: 'Khánh Duy',
        avatar: 'assets/pickball_player.webp',
        wins: 5,
        totalGames: 8,
        scoreDiff: 25,
      ),
      RankingInfo(
        rank: 4,
        name: 'Ngọc Minh',
        avatar: 'assets/pickball_player.webp',
        wins: 5,
        totalGames: 8,
        scoreDiff: 23,
      ),
      RankingInfo(
        rank: 5,
        name: 'Man Phan',
        avatar: 'assets/pickball_player.webp',
        wins: 5,
        totalGames: 8,
        scoreDiff: 0,
      ),
      RankingInfo(
        rank: 6,
        name: 'Huỳnh Trung Hải Âu',
        avatar: 'assets/pickball_player.webp',
        wins: 4,
        totalGames: 8,
        scoreDiff: 8,
      ),
    ];

    return rankings.map((ranking) => _buildRankingItem(ranking)).toList();
  }

  Widget _buildRankingItem(RankingInfo ranking) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          // Rank number
          SizedBox(
            width: 30,
            child: Text(
              '${ranking.rank}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Avatar and name
          CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage(ranking.avatar),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              ranking.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Stats
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${ranking.wins}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '(${ranking.totalGames})',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(width: 24),
          SizedBox(
            width: 50,
            child: Text(
              ranking.scoreDiff > 0
                  ? '+${ranking.scoreDiff}'
                  : '${ranking.scoreDiff}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey[300]!,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildRound(String title, List<MatchInfo> matches) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: const Icon(Icons.check_circle, color: Colors.blue),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: const Icon(Icons.keyboard_arrow_down),
        ),
        ...matches.map((match) => _buildMatch(match)).toList(),
        const Divider(),
      ],
    );
  }

  Widget _buildMatch(MatchInfo match) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.tv, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text(match.court),
              const Spacer(),
              Text(
                match.score,
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildTeam(match.team1)),
              Expanded(child: _buildTeam(match.team2)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue[900],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Row(
                  children: [
                    Text(
                      'DUPR',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Đã gửi',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTeam(TeamInfo team) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 15,
              backgroundImage: AssetImage(team.player1.avatar),
            ),
            const SizedBox(width: 4),
            CircleAvatar(
              radius: 15,
              backgroundImage: AssetImage(team.player2.avatar),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          team.player1.name,
          style: TextStyle(
            color: team.isGrayed ? Colors.grey : Colors.black,
          ),
        ),
        Text(
          team.player2.name,
          style: TextStyle(
            color: team.isGrayed ? Colors.grey : Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentTab() {
    return Column(
      children: [
        // User info section
        ListTile(
          leading: const CircleAvatar(
            backgroundImage: AssetImage('assets/pic.png'),
          ),
          title: const Text('Tài Nguyễn'),
          subtitle: const Text('Thủ quỹ'),
          trailing: IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            onPressed: () {},
          ),
        ),

        // Payment info section
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'PHÍ THAM GIA',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
              Row(
                children: [
                  const Text(
                    '200000 VND',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Clipboard.setData(const ClipboardData(text: '200000'));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Đã sao chép số tiền')),
                      );
                    },
                    child: const Text('Sao chép'),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              const Text(
                'TIN NHẮN THANH TOÁN',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
              const Row(
                children: [
                  const Expanded(
                    child: Text(
                      'RECLUB - Huu Thuan VNB - 23/11 - 🏆 Round Robin [DUPR Lv 2.75-3.5] Pick Hub Mix POOC (san 9-10)',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              // Bank accounts
              _buildBankAccount(
                'ACB',
                'assets/ba.png',
                'Nguyễn Tấn Tài',
                '39796666668',
              ),
              const Divider(),
              _buildBankAccount(
                'MoMo',
                'assets/ba.png',
                '0949997739',
                '0949997739',
              ),
            ],
          ),
        ),

        const Spacer(),
        // Bottom button
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Đăng biên lai',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBankAccount(String bankName, String logoPath, String accountName,
      String accountNumber) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: bankName == 'ACB' ? Colors.green : Colors.pink,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Image.asset(logoPath),
      ),
      title: Text(
        bankName,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(accountName),
          Text(accountNumber),
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.copy),
        onPressed: () {
          Clipboard.setData(ClipboardData(text: accountNumber));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Đã sao chép số tài khoản $bankName')),
          );
        },
      ),
    );
  }

  Widget _buildDetailsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Club info
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(widget.teamLogo),
            ),
            title: Text(widget.teamName),
            subtitle: Text(widget.subtitle),
          ),

          // Participants avatars
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: (widget.currentParticipants ?? 0) + 1, //
              itemBuilder: (context, index) {
                if (index < (widget.currentParticipants ?? 0)) {
                  return const Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: CircleAvatar(
                      backgroundImage: AssetImage('assets/ava.png'),
                    ),
                  );
                } else {
                  return CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    child: Text(
                        '+${(widget.maxParticipants ?? 0) - (widget.currentParticipants ?? 0)}'), // Thêm null check
                  );
                }
              },
            ),
          ),

          const SizedBox(height: 16),

          // Event details
          _buildDetailItem(
            Icons.calendar_today,
            '${widget.date} lúc ${widget.time}',
            subtitle: '2 tiếng',
            action: TextButton(
              onPressed: () {},
              child: const Text('Thêm vào lịch'),
            ),
          ),

          _buildDetailItem(
            Icons.location_on,
            widget.location,
            subtitle: widget.fullAddress,
            action: TextButton(
              onPressed: () {},
              child: const Text('Hiển thị trong bản đồ'),
            ),
          ),

          _buildDetailItem(
            Icons.sports_tennis,
            widget.level,
          ),

          _buildDetailItem(
            Icons.timer_off,
            'Chặn rời khỏi kèo trước 4 tiếng kèo bắt đầu',
          ),

          _buildDetailItem(
            Icons.attach_money,
            'Mỗi người • ${widget.price}',
            action: TextButton(
              onPressed: () {},
              child: const Text('Thanh toán'),
            ),
          ),

          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue[900],
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Row(
              children: [
                Text(
                  'DUPR',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Vấn đấu sẽ được gửi đến DUPR',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          const Text(
            'Ghi chú',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...widget.notes.map((note) => _buildNote(note)).toList(),
        ],
      ),
    );
  }

  Widget _buildParticipantsTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // DUPR Manager section
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 1,
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue[900],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'DUPR',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Quản lý',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Organizers section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'NGƯỜI TỔ CHỨC • 3',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildOrganizerItem('Tài\nNguyễn', 'assets/pic.png'),
                    _buildOrganizerItem('Huy', 'assets/pic.png'),
                    _buildOrganizerItem('Hảobéby', 'assets/pic.png'),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Participants section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'XÁC NHẬN THAM GIA • ${widget.currentParticipants}/${widget.maxParticipants}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildParticipantsList([
                  'assets/ava.png',
                  'assets/ava.png',
                  'assets/ava.png',
                  'assets/ava.png',
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrganizerItem(String name, String imagePath) {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(imagePath),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.shield,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildParticipantsList(List<String> participantImages) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: participantImages
              .map((image) => CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(image),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildDetailItem(IconData icon, String text,
      {String? subtitle, Widget? action}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: action,
    );
  }

  Widget _buildNote(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(text),
    );
  }
}

// Helper widgets and classes
class PlayerInfo {
  final String name;
  final String avatar;

  PlayerInfo(this.name, this.avatar);
}

class TeamInfo {
  final PlayerInfo player1;
  final PlayerInfo player2;
  final bool isGrayed;

  TeamInfo({
    required this.player1,
    required this.player2,
    this.isGrayed = false,
  });
}

class MatchInfo {
  final String court;
  final String score;
  final TeamInfo team1;
  final TeamInfo team2;

  MatchInfo({
    required this.court,
    required this.score,
    required this.team1,
    required this.team2,
  });
}

class RankingInfo {
  final int rank;
  final String name;
  final String avatar;
  final int wins;
  final int totalGames;
  final int scoreDiff;

  RankingInfo({
    required this.rank,
    required this.name,
    required this.avatar,
    required this.wins,
    required this.totalGames,
    required this.scoreDiff,
  });
}
