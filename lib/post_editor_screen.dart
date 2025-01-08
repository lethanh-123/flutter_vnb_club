import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PostEditorScreen extends StatefulWidget {
  final String clubName;

  const PostEditorScreen({
    Key? key,
    required this.clubName,
  }) : super(key: key);

  @override
  State<PostEditorScreen> createState() => _PostEditorScreenState();
}

class _PostEditorScreenState extends State<PostEditorScreen> {
  final TextEditingController _contentController = TextEditingController();
  final List<String> _attachments = [];
  bool _hasContent = false;

  @override
  void initState() {
    super.initState();
    _contentController.addListener(() {
      setState(() {
        _hasContent = _contentController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _attachments.add(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.clubName),
        actions: [
          TextButton(
            onPressed: _hasContent
                ? () {
                    // TODO: Implement post submission
                    Navigator.pop(context);
                  }
                : null,
            child: Text(
              'Đăng',
              style: TextStyle(
                color: _hasContent ? Colors.blue : Colors.grey,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: TextField(
              controller: _contentController,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: 'Viết nội dung bài đăng...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16),
              ),
            ),
          ),
          if (_attachments.isNotEmpty)
            Container(
              height: 100,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _attachments.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Stack(
                      children: [
                        Image.asset(
                          _attachments[index],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () {
                              setState(() {
                                _attachments.removeAt(index);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.image),
                  onPressed: _pickImage,
                ),
                IconButton(
                  icon: const Icon(Icons.format_bold),
                  onPressed: () {
                    // TODO: Implement bold formatting
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.format_italic),
                  onPressed: () {
                    // TODO: Implement italic formatting
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
