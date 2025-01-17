import 'package:flutter/material.dart';

class CategoryCards extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const CategoryCards({
    Key? key,
    required this.selectedCategory,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildCategoryCard(
            context: context,
            icon: Icons.sports_tennis,
            label: 'Trận đấu',
            isSelected: selectedCategory == 'Trận đấu',
          ),
          _buildCategoryCard(
            context: context,
            icon: null,
            label: 'Xếp hạng',
            isDuprOnly: true,
            isSelected: selectedCategory == 'Xếp hạng',
          ),
          _buildCategoryCard(
            context: context,
            icon: Icons.military_tech,
            label: 'Độ uy tín',
            isSelected: selectedCategory == 'Độ uy tín',
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard({
    required BuildContext context,
    IconData? icon,
    required String label,
    bool isDuprOnly = false,
    bool isSelected = false,
  }) {
    return GestureDetector(
      onTap: () => onCategorySelected(label),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        child: Material(
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? Colors.blue : Colors.white,
          elevation: isSelected ? 0 : 1,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isDuprOnly)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
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
                  )
                else
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: icon != null
                        ? Icon(
                            icon,
                            color: isSelected ? Colors.white : Colors.black,
                            size: 24,
                          )
                        : null,
                  ),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}