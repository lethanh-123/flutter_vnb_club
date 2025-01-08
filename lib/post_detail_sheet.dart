import 'package:flutter/material.dart';

class PostDetailSheet extends StatefulWidget {
  final String clubName;
  final String authorName;
  final String postTime;

  const PostDetailSheet({
    Key? key,
    required this.clubName,
    required this.authorName,
    required this.postTime,
  }) : super(key: key);

  @override
  State<PostDetailSheet> createState() => _PostDetailSheetState();
}

class _PostDetailSheetState extends State<PostDetailSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Tab bar
              TabBar(
                controller: _tabController,
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Thông tin bài',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.comment_outlined),
                        const SizedBox(width: 8),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('0'),
                            Text(
                              'Bình luận',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.thumb_up_outlined),
                        const SizedBox(width: 8),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('0'),
                            Text(
                              'React',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Tab content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Thông tin bài đăng tab
                    ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(16),
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            backgroundImage: AssetImage('assets/pic.png'),
                          ),
                          title: Text(widget.clubName),
                          trailing: const Icon(Icons.chevron_right),
                        ),
                        const Divider(),
                        ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.person_outline),
                          ),
                          title: const Text('TÁC GIẢ'),
                          subtitle: Text('${widget.authorName} • Chủ sở hữu'),
                        ),
                        const Divider(),
                        ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.public),
                          ),
                          title: const Text('QUYỀN RIÊNG TƯ BÀI VIẾT'),
                          subtitle: const Text('Tất cả mọi người có thể xem'),
                        ),
                        const Divider(),
                        ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.access_time),
                          ),
                          title: const Text('THỜI ĐIỂM'),
                          subtitle: Text(widget.postTime),
                        ),
                        const Divider(),
                        const Text(
                          'Tùy chỉnh',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.share_outlined),
                          title: const Text('Chia sẻ bài viết'),
                          onTap: () {},
                        ),
                        ListTile(
                          leading: const Icon(Icons.report_problem_outlined),
                          title: const Text(
                            'Báo cáo bài viết',
                            style: TextStyle(color: Colors.red),
                          ),
                          onTap: () {},
                        ),
                      ],
                    ),
                    // Bình luận tab
                    const Center(child: Text('Chưa có bình luận nào')),
                    // React tab
                    const Center(child: Text('Chưa có react nào')),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}