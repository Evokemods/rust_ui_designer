import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/designer_state.dart';

class PageTabsWidget extends StatelessWidget {
  const PageTabsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DesignerState>(
      builder: (context, state, child) {
        return Container(
          height: 40,
          color: Colors.grey[850],
          child: Row(
            children: [
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.pages.length,
                  itemBuilder: (context, index) {
                    final page = state.pages[index];
                    final isSelected = index == state.currentPageIndex;

                    return GestureDetector(
                      onTap: () => state.setCurrentPage(index),
                      onSecondaryTapDown: (details) {
                        _showPageContextMenu(context, state, index, details.globalPosition);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.grey[700] : Colors.transparent,
                          border: Border(
                            right: BorderSide(color: Colors.white10),
                            bottom: BorderSide(
                              color: isSelected ? Colors.blue : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              page.name,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.white70,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                            if (state.pages.length > 1) ...[
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () => _confirmDeletePage(context, state, index),
                                child: Icon(
                                  Icons.close,
                                  size: 14,
                                  color: isSelected ? Colors.white70 : Colors.white38,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Add new page button
              InkWell(
                onTap: () => state.addPage(),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: const Icon(Icons.add, color: Colors.white70, size: 20),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPageContextMenu(BuildContext context, DesignerState state, int index, Offset position) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(position.dx, position.dy, position.dx, position.dy),
      items: [
        PopupMenuItem(
          child: const Text('Rename'),
          onTap: () {
            Future.delayed(Duration.zero, () {
              if (context.mounted) {
                _showRenameDialog(context, state, index);
              }
            });
          },
        ),
        if (state.pages.length > 1)
          PopupMenuItem(
            child: const Text('Delete'),
            onTap: () {
              Future.delayed(Duration.zero, () {
                if (context.mounted) {
                  _confirmDeletePage(context, state, index);
                }
              });
            },
          ),
      ],
    );
  }

  void _showRenameDialog(BuildContext context, DesignerState state, int index) {
    final controller = TextEditingController(text: state.pages[index].name);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename Page'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Page Name',
            hintText: 'Enter page name',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                state.renamePage(index, controller.text.trim());
              }
              Navigator.pop(context);
            },
            child: const Text('Rename'),
          ),
        ],
      ),
    );
  }

  void _confirmDeletePage(BuildContext context, DesignerState state, int index) {
    if (state.pages.length <= 1) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Page'),
        content: Text('Are you sure you want to delete "${state.pages[index].name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              state.removePage(index);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
