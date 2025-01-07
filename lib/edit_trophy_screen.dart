import 'package:flutter/material.dart';

class EditTrophyScreen extends StatefulWidget {
  final String number;
  final String currentTitle;
  final String currentDescription;

  const EditTrophyScreen({
    Key? key, 
    required this.number,
    this.currentTitle = '',
    this.currentDescription = '',
  }) : super(key: key);

  @override
  State<EditTrophyScreen> createState() => _EditTrophyScreenState();
}

class _EditTrophyScreenState extends State<EditTrophyScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _changeRecipient = false;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.currentTitle;
    _descriptionController.text = widget.currentDescription;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('SỬA PHẦN THƯỞNG GIẢI ${widget.number}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Trophy icon
            Center(
              child: Icon(
                Icons.emoji_events,
                size: 120,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 32),

            // Title input
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'TÊN PHẦN THƯỞNG',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${_titleController.text.length}/70',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    hintText: 'Á quân',
                    border: OutlineInputBorder(),
                  ),
                  maxLength: 70,
                  buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Description input
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'MÔ TẢ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${_descriptionController.text.length}/150',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    hintText: 'Ví dụ: Phiếu mua hàng, tiền mặt...',
                    border: OutlineInputBorder(),
                  ),
                  maxLength: 150,
                  maxLines: 3,
                  buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Change recipient toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'THAY ĐỔI NGƯỜI NHẬN',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Switch(
                  value: _changeRecipient,
                  onChanged: (value) {
                    setState(() {
                      _changeRecipient = value;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context, {
              'title': _titleController.text,
              'description': _descriptionController.text,
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'LƯU',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}