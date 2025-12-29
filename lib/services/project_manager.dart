import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

class ProjectManager {
  static Future<bool> saveProject(Map<String, dynamic> projectData) async {
    try {
      String? outputPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Project',
        fileName: 'project.json',
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (outputPath == null) {
        return false;
      }

      File file = File(outputPath);
      String jsonString = const JsonEncoder.withIndent('  ').convert(projectData);
      await file.writeAsString(jsonString);
      return true;
    } catch (e) {
      debugPrint('Error saving project: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>?> loadProject() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        dialogTitle: 'Load Project',
      );

      if (result == null || result.files.single.path == null) {
        return null;
      }

      File file = File(result.files.single.path!);
      String jsonString = await file.readAsString();
      return json.decode(jsonString);
    } catch (e) {
      debugPrint('Error loading project: $e');
      return null;
    }
  }

  static Future<bool> exportCode(String code, String fileName) async {
    try {
      String? outputPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Export Code',
        fileName: fileName.endsWith('.cs') ? fileName : '$fileName.cs',
        type: FileType.custom,
        allowedExtensions: ['cs'],
      );

      if (outputPath == null) {
        return false;
      }

      File file = File(outputPath);
      await file.writeAsString(code);
      return true;
    } catch (e) {
      debugPrint('Error exporting code: $e');
      return false;
    }
  }
}
