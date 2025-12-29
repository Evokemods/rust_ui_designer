import 'package:flutter/material.dart';

class BackgroundSettingsDialog extends StatefulWidget {
  final String? currentUrl;

  const BackgroundSettingsDialog({super.key, this.currentUrl});

  @override
  State<BackgroundSettingsDialog> createState() => _BackgroundSettingsDialogState();
}

class _BackgroundSettingsDialogState extends State<BackgroundSettingsDialog> {
  late TextEditingController _urlController;

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController(text: widget.currentUrl ?? '');
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Background Image Settings'),
      content: SizedBox(
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter a URL to an image to use as your background:',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'Image URL',
                hintText: 'https://example.com/rust-screenshot.jpg',
                border: OutlineInputBorder(),
                helperText: 'Use a Rust gameplay screenshot from your server or online',
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                border: Border.all(color: Colors.blue.shade200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb_outline, size: 20, color: Colors.blue.shade700),
                      const SizedBox(width: 8),
                      Text(
                        'Tips for best results:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('• Use a 1920×1080 screenshot for best fit', style: TextStyle(fontSize: 12, color: Colors.black87)),
                  const Text('• Upload to imgur.com or use a direct image URL', style: TextStyle(fontSize: 12, color: Colors.black87)),
                  const Text('• Make sure the URL is publicly accessible', style: TextStyle(fontSize: 12, color: Colors.black87)),
                  const Text('• Image will appear at 30% opacity', style: TextStyle(fontSize: 12, color: Colors.black87)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                border: Border.all(color: Colors.orange.shade200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, size: 20, color: Colors.orange.shade700),
                      const SizedBox(width: 8),
                      Text(
                        'How to get a Rust screenshot:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('1. Press F12 in Rust to take a screenshot', style: TextStyle(fontSize: 12, color: Colors.black87)),
                  const Text('2. Find it in: C:\\Program Files\\Steam\\...\\screenshots', style: TextStyle(fontSize: 12, color: Colors.black87)),
                  const Text('3. Upload to imgur.com and copy the direct link', style: TextStyle(fontSize: 12, color: Colors.black87)),
                  const Text('4. Paste the link here', style: TextStyle(fontSize: 12, color: Colors.black87)),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        if (widget.currentUrl != null)
          TextButton(
            onPressed: () => Navigator.pop(context, ''),
            child: const Text('Clear'),
          ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, _urlController.text.trim());
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
