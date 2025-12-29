import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/project_manager.dart';

class ExportDialog extends StatelessWidget {
  final String codeSnippet;
  final String completePlugin;
  final String fileName;

  const ExportDialog({
    super.key,
    required this.codeSnippet,
    required this.completePlugin,
    required this.fileName,
  });

  @override
  Widget build(BuildContext context) {
    return _ExportDialogStateful(
      codeSnippet: codeSnippet,
      completePlugin: completePlugin,
      fileName: fileName,
    );
  }
}

class _ExportDialogStateful extends StatefulWidget {
  final String codeSnippet;
  final String completePlugin;
  final String fileName;

  const _ExportDialogStateful({
    required this.codeSnippet,
    required this.completePlugin,
    required this.fileName,
  });

  @override
  State<_ExportDialogStateful> createState() => _ExportDialogStatefulState();
}

class _ExportDialogStatefulState extends State<_ExportDialogStateful> {
  bool _showCompletePlugin = true; // Default to complete plugin

  @override
  Widget build(BuildContext context) {
    String displayedCode = _showCompletePlugin ? widget.completePlugin : widget.codeSnippet;

    return Dialog(
      child: Theme(
        data: ThemeData.light(),
        child: Container(
          width: 900,
          height: 700,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Export C# Code',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              // Tab selector
              Row(
                children: [
                  Expanded(
                    child: SegmentedButton<bool>(
                      segments: const [
                        ButtonSegment<bool>(
                          value: true,
                          label: Text('Complete Plugin File'),
                          icon: Icon(Icons.file_copy),
                        ),
                        ButtonSegment<bool>(
                          value: false,
                          label: Text('Code Snippet Only'),
                          icon: Icon(Icons.code),
                        ),
                      ],
                      selected: {_showCompletePlugin},
                      onSelectionChanged: (Set<bool> newSelection) {
                        setState(() {
                          _showCompletePlugin = newSelection.first;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              // Info text
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Text(
                  _showCompletePlugin
                    ? '✅ Complete plugin with all using statements, namespace, and class structure. Ready to use!'
                    : '⚠️ Code snippet only - for pasting into an existing plugin class',
                  style: TextStyle(fontSize: 12, color: Colors.blue[900]),
                ),
              ),
              const SizedBox(height: 15),

              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: SingleChildScrollView(
                    child: SelectableText(
                      displayedCode,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => _copyToClipboard(context, displayedCode),
                    icon: const Icon(Icons.copy),
                    label: const Text('Copy to Clipboard'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () => _saveToFile(context, displayedCode),
                    icon: const Icon(Icons.save),
                    label: Text(_showCompletePlugin ? 'Save Complete Plugin' : 'Save Snippet'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _copyToClipboard(BuildContext context, String code) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Code copied to clipboard!')),
    );
  }

  Future<void> _saveToFile(BuildContext context, String code) async {
    bool success = await ProjectManager.exportCode(code, widget.fileName);
    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Code exported successfully!')),
      );
      Navigator.pop(context);
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Export cancelled or failed')),
      );
    }
  }
}
