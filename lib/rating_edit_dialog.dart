import 'package:flutter/material.dart';

class RatingEditDialog extends StatefulWidget {
  final double initialRating;
  final Function(double) onSave;

  const RatingEditDialog({
    Key? key,
    required this.initialRating,
    required this.onSave,
  }) : super(key: key);

  @override
  State<RatingEditDialog> createState() => _RatingEditDialogState();
}

class _RatingEditDialogState extends State<RatingEditDialog> {
  late double _currentRating;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Chỉnh sửa trình độ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () {
                    setState(() {
                      if (_currentRating > 1.0) {
                        _currentRating -= 0.25;
                      }
                    });
                  },
                ),
                const SizedBox(width: 16),
                Text(
                  _currentRating.toStringAsFixed(2),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () {
                    setState(() {
                      if (_currentRating < 5.0) {
                        _currentRating += 0.25;
                      }
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Hủy'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    widget.onSave(_currentRating);
                    Navigator.pop(context);
                  },
                  child: const Text('Lưu'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}