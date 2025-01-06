import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.time} ${widget.date}'),
        centerTitle: true,
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
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tabs
                  DefaultTabController(
                    length: 4,
                    child: TabBar(
                      isScrollable: true,
                      tabs: const [
                        Tab(text: 'Chi tiết'),
                        Tab(text: 'Người tham gia'),
                        Tab(text: 'Trận đấu'),
                        Tab(text: 'Nhắn tin'),
                      ],
                    ),
                  ),

                  // Team info
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage(widget.teamLogo),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.teamName,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                widget.subtitle,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text('Xem lịch'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.blue,
                            side: const BorderSide(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Participants
                  if (widget.maxParticipants != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey[300],
                            child: const Icon(Icons.person_outline),
                          ),
                          const SizedBox(width: 8),
                          ...List.generate(5, (index) => Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: CircleAvatar(
                              backgroundColor: Colors.grey[300],
                              child: const Icon(Icons.person_outline),
                            ),
                          )),
                        ],
                      ),
                    ),

                  // Match details
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Date and time
                        Row(
                          children: [
                            const Icon(Icons.calendar_today),
                            const SizedBox(width: 8),
                            Text(
                              'Thứ bảy ${widget.date} lúc ${widget.time}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        Text('${widget.notes[0]}'), // Duration

                        const SizedBox(height: 16),
                        // Location
                        Row(
                          children: [
                            const Icon(Icons.location_on),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.location,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  widget.fullAddress,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text('Hiển thị trong bản đồ'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.blue,
                          ),
                        ),

                        const SizedBox(height: 16),
                        // Level
                        Row(
                          children: [
                            const Icon(Icons.sports_tennis),
                            const SizedBox(width: 8),
                            Text(
                              'Giao hữu • ${widget.level}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),
                        // Price
                        Row(
                          children: [
                            const Icon(Icons.attach_money),
                            const SizedBox(width: 8),
                            Text(
                              'Mỗi người • ${widget.price}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),
                        // Notes
                        const Text(
                          'Ghi chú',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...widget.notes.map((note) => Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Row(
                            children: [
                              const Icon(Icons.access_time, size: 16),
                              const SizedBox(width: 8),
                              Text(note),
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom buttons
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Text('Chat với host'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Yêu cầu tham gia'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
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
}