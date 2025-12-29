import 'package:flutter/material.dart';
import '../models/anchor_preset.dart';

/// A visual anchor preset selector similar to Unity's RectTransform anchor widget.
///
/// Displays a grid of clickable anchor presets that allows users to quickly
/// set common anchor configurations instead of manually entering values.
class AnchorSelectorWidget extends StatelessWidget {
  final double currentMinX;
  final double currentMinY;
  final double currentMaxX;
  final double currentMaxY;
  final Function(AnchorPreset) onPresetSelected;

  const AnchorSelectorWidget({
    super.key,
    required this.currentMinX,
    required this.currentMinY,
    required this.currentMaxX,
    required this.currentMaxY,
    required this.onPresetSelected,
  });

  @override
  Widget build(BuildContext context) {
    final currentPreset = AnchorPresets.getCurrentPreset(
      currentMinX,
      currentMinY,
      currentMaxX,
      currentMaxY,
    );

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.anchor, size: 16, color: Colors.blue[300]),
              const SizedBox(width: 8),
              Text(
                'Anchor Preset',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            currentPreset?.name ?? 'Custom',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 12),

          // Point Anchors Grid (3x3)
          _buildPointAnchorsGrid(currentPreset),

          const SizedBox(height: 12),

          // Stretch Anchors
          _buildStretchAnchors(currentPreset),
        ],
      ),
    );
  }

  Widget _buildPointAnchorsGrid(AnchorPreset? currentPreset) {
    final pointPresets = AnchorPresets.allPresets[AnchorPresetCategory.point]!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Position Anchors',
          style: TextStyle(
            color: Colors.white60,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.all(4),
          child: Column(
            children: [
              // Top Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildPresetButton(pointPresets[0], currentPreset, Icons.north_west),
                  _buildPresetButton(pointPresets[1], currentPreset, Icons.north),
                  _buildPresetButton(pointPresets[2], currentPreset, Icons.north_east),
                ],
              ),
              const SizedBox(height: 4),
              // Middle Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildPresetButton(pointPresets[3], currentPreset, Icons.west),
                  _buildPresetButton(pointPresets[4], currentPreset, Icons.center_focus_strong),
                  _buildPresetButton(pointPresets[5], currentPreset, Icons.east),
                ],
              ),
              const SizedBox(height: 4),
              // Bottom Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildPresetButton(pointPresets[6], currentPreset, Icons.south_west),
                  _buildPresetButton(pointPresets[7], currentPreset, Icons.south),
                  _buildPresetButton(pointPresets[8], currentPreset, Icons.south_east),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStretchAnchors(AnchorPreset? currentPreset) {
    final stretchPresets = AnchorPresets.allPresets[AnchorPresetCategory.stretch]!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Stretch Anchors',
          style: TextStyle(
            color: Colors.white60,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),

        // Horizontal Stretch (Top, Middle, Bottom)
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.all(4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildPresetButton(stretchPresets[0], currentPreset, Icons.height, iconRotation: 90),
              _buildPresetButton(stretchPresets[1], currentPreset, Icons.height, iconRotation: 90),
              _buildPresetButton(stretchPresets[2], currentPreset, Icons.height, iconRotation: 90),
            ],
          ),
        ),

        const SizedBox(height: 4),

        // Vertical Stretch (Left, Center, Right) and Full
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.all(4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildPresetButton(stretchPresets[3], currentPreset, Icons.height),
              _buildPresetButton(stretchPresets[4], currentPreset, Icons.height),
              _buildPresetButton(stretchPresets[5], currentPreset, Icons.height),
              _buildPresetButton(stretchPresets[6], currentPreset, Icons.fullscreen),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPresetButton(
    AnchorPreset preset,
    AnchorPreset? currentPreset,
    IconData icon, {
    double iconRotation = 0,
  }) {
    final isSelected = preset == currentPreset;

    return Tooltip(
      message: preset.description,
      child: InkWell(
        onTap: () => onPresetSelected(preset),
        borderRadius: BorderRadius.circular(4),
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue[700] : Colors.grey[800],
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: isSelected ? Colors.blue[300]! : Colors.white24,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Transform.rotate(
            angle: iconRotation * 3.14159 / 180,
            child: Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : Colors.white60,
            ),
          ),
        ),
      ),
    );
  }
}
