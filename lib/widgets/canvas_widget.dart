import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/designer_state.dart';
import '../models/ui_element.dart';
import '../models/panel_element.dart';
import '../models/button_element.dart';
import '../models/label_element.dart';
import '../models/image_element.dart';
import '../models/image_button_element.dart';

class CanvasWidget extends StatefulWidget {
  const CanvasWidget({super.key});

  @override
  State<CanvasWidget> createState() => _CanvasWidgetState();
}

class _CanvasWidgetState extends State<CanvasWidget> {
  static const double canvasWidth = 1920;  // Standard HD resolution for UI design
  static const double canvasHeight = 1080;

  String? _resizingElementId;
  String? _draggingElementId;
  Offset? _dragStartPos;
  Offset? _resizeStartPos;
  Map<String, double>? _originalAnchors;

  // Snap to grid helper - snaps to 5% intervals (0.05)
  double _snapToGrid(double value) {
    const gridInterval = 0.05; // 5% grid
    return (value / gridInterval).round() * gridInterval;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900],
      child: Center(
        child: Consumer<DesignerState>(
          builder: (context, state, child) {
            return AspectRatio(
              aspectRatio: 16 / 9,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double scale = constraints.maxWidth / canvasWidth;

                  return Container(
                    width: constraints.maxWidth,
                    height: constraints.maxWidth / (16 / 9),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      border: Border.all(color: Colors.white24, width: 2),
                    ),
                    child: ClipRect(
                      child: Stack(
                        children: [
                          // Rust in-game background (under everything else)
                          if (state.showRustBackground)
                            Positioned.fill(
                              child: state.backgroundImageUrl != null && state.backgroundImageUrl!.isNotEmpty
                                  ? Opacity(
                                      opacity: 0.3,
                                      child: Image.network(
                                        state.backgroundImageUrl!,
                                        fit: BoxFit.cover,
                                        loadingBuilder: (context, child, loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value: loadingProgress.expectedTotalBytes != null
                                                  ? loadingProgress.cumulativeBytesLoaded /
                                                      loadingProgress.expectedTotalBytes!
                                                  : null,
                                            ),
                                          );
                                        },
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            color: Colors.grey[700],
                                            child: const Center(
                                              child: Text(
                                                'Failed to load background image.\nCheck URL in settings.',
                                                style: TextStyle(color: Colors.white54),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  : Container(
                                      color: Colors.grey[700],
                                      child: const Center(
                                        child: Text(
                                          'No background image set.\nClick the image icon to configure.',
                                          style: TextStyle(color: Colors.white54, fontSize: 16),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                            ),

                          // Empty state guide
                          if (state.elements.isEmpty)
                            Center(
                              child: Container(
                                padding: const EdgeInsets.all(32),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.touch_app, size: 64, color: Colors.white24),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Quick Start Guide',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      '1. Click "Panel" in the toolbox to create a root panel',
                                      style: TextStyle(color: Colors.white60, fontSize: 16),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      '2. Add Buttons, Labels, or Images',
                                      style: TextStyle(color: Colors.white60, fontSize: 16),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      '3. Click elements to select and edit properties',
                                      style: TextStyle(color: Colors.white60, fontSize: 16),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      '4. Click Export Code when done',
                                      style: TextStyle(color: Colors.white60, fontSize: 16),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Click the ? icon in the toolbar for full help',
                                      style: TextStyle(color: Colors.white38, fontSize: 14),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          // Render all elements
                          ...state.elements.map((element) {
                            return _buildElement(element, state, scale);
                          }),

                          // Grid overlay (on top)
                          IgnorePointer(
                            child: CustomPaint(
                              size: Size(constraints.maxWidth, constraints.maxWidth / (16 / 9)),
                              painter: GridPainter(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildElement(UiElement element, DesignerState state, double scale) {
    bool isSelected = state.selectedElementId == element.id;

    // Calculate actual pixel dimensions
    double widthPx = (element.anchorMaxX - element.anchorMinX) * canvasWidth * scale;
    double heightPx = (element.anchorMaxY - element.anchorMinY) * canvasHeight * scale;

    return Positioned(
      left: element.anchorMinX * canvasWidth * scale,
      top: (1 - element.anchorMaxY) * canvasHeight * scale,
      width: widthPx,
      height: heightPx,
      child: Stack(
        children: [
          // Element content - handles clicking and dragging
          GestureDetector(
            onTap: () {
              state.selectElement(element.id);
            },
            onPanStart: (details) {
              _draggingElementId = element.id;
              _dragStartPos = details.localPosition;
              _originalAnchors = {
                'minX': element.anchorMinX,
                'minY': element.anchorMinY,
                'maxX': element.anchorMaxX,
                'maxY': element.anchorMaxY,
              };
            },
            onPanUpdate: (details) {
              if (_draggingElementId == element.id && _dragStartPos != null && _originalAnchors != null) {
                double dx = details.localPosition.dx - _dragStartPos!.dx;
                double dy = details.localPosition.dy - _dragStartPos!.dy;

                double deltaX = dx / (canvasWidth * scale);
                double deltaY = -dy / (canvasHeight * scale);

                double newMinX = (_originalAnchors!['minX']! + deltaX).clamp(0.0, 1.0);
                double newMaxX = (_originalAnchors!['maxX']! + deltaX).clamp(0.0, 1.0);
                double newMinY = (_originalAnchors!['minY']! + deltaY).clamp(0.0, 1.0);
                double newMaxY = (_originalAnchors!['maxY']! + deltaY).clamp(0.0, 1.0);

                // Snap to grid
                newMinX = _snapToGrid(newMinX);
                newMaxX = _snapToGrid(newMaxX);
                newMinY = _snapToGrid(newMinY);
                newMaxY = _snapToGrid(newMaxY);

                // Ensure element stays within bounds
                if (newMinX >= 0 && newMaxX <= 1) {
                  element.anchorMinX = newMinX;
                  element.anchorMaxX = newMaxX;
                }
                if (newMinY >= 0 && newMaxY <= 1) {
                  element.anchorMinY = newMinY;
                  element.anchorMaxY = newMaxY;
                }

                state.updateElement(element.id, element.clone());
              }
            },
            onPanEnd: (details) {
              _draggingElementId = null;
              _dragStartPos = null;
              _originalAnchors = null;
            },
            child: Container(
              decoration: BoxDecoration(
                color: _getElementColor(element),
                border: isSelected
                    ? Border.all(color: Colors.blue, width: 2)
                    : null,
              ),
              child: Center(
                child: _getElementContent(element),
              ),
            ),
          ),

          // Visual warnings and tips
          ..._buildVisualWarnings(element, widthPx, heightPx, isSelected),

          // Dimension labels when selected
          if (isSelected) _buildDimensionLabels(element, widthPx, heightPx),

          // Resize handles - on top, only for resizing
          if (isSelected) ...[
            _buildResizeHandle(Alignment.topLeft, element, state, scale),
            _buildResizeHandle(Alignment.topRight, element, state, scale),
            _buildResizeHandle(Alignment.bottomLeft, element, state, scale),
            _buildResizeHandle(Alignment.bottomRight, element, state, scale),
          ],
        ],
      ),
    );
  }

  Widget _buildResizeHandle(Alignment alignment, UiElement element, DesignerState state, double scale) {
    return Align(
      alignment: alignment,
      child: GestureDetector(
        onPanStart: (details) {
          _resizingElementId = element.id;
          _resizeStartPos = details.localPosition;
          _originalAnchors = {
            'minX': element.anchorMinX,
            'minY': element.anchorMinY,
            'maxX': element.anchorMaxX,
            'maxY': element.anchorMaxY,
          };
        },
        onPanUpdate: (details) {
          if (_resizingElementId == element.id && _originalAnchors != null && _resizeStartPos != null) {
            double dx = (details.localPosition.dx - _resizeStartPos!.dx) / (canvasWidth * scale);
            double dy = -(details.localPosition.dy - _resizeStartPos!.dy) / (canvasHeight * scale);

            if (alignment == Alignment.bottomRight) {
              double newMaxX = (_originalAnchors!['maxX']! + dx).clamp(_originalAnchors!['minX']! + 0.05, 1.0);
              double newMinY = (_originalAnchors!['minY']! + dy).clamp(0.0, _originalAnchors!['maxY']! - 0.05);
              element.anchorMaxX = _snapToGrid(newMaxX);
              element.anchorMinY = _snapToGrid(newMinY);
            } else if (alignment == Alignment.topRight) {
              double newMaxX = (_originalAnchors!['maxX']! + dx).clamp(_originalAnchors!['minX']! + 0.05, 1.0);
              double newMaxY = (_originalAnchors!['maxY']! + dy).clamp(_originalAnchors!['minY']! + 0.05, 1.0);
              element.anchorMaxX = _snapToGrid(newMaxX);
              element.anchorMaxY = _snapToGrid(newMaxY);
            } else if (alignment == Alignment.bottomLeft) {
              double newMinX = (_originalAnchors!['minX']! + dx).clamp(0.0, _originalAnchors!['maxX']! - 0.05);
              double newMinY = (_originalAnchors!['minY']! + dy).clamp(0.0, _originalAnchors!['maxY']! - 0.05);
              element.anchorMinX = _snapToGrid(newMinX);
              element.anchorMinY = _snapToGrid(newMinY);
            } else if (alignment == Alignment.topLeft) {
              double newMinX = (_originalAnchors!['minX']! + dx).clamp(0.0, _originalAnchors!['maxX']! - 0.05);
              double newMaxY = (_originalAnchors!['maxY']! + dy).clamp(_originalAnchors!['minY']! + 0.05, 1.0);
              element.anchorMinX = _snapToGrid(newMinX);
              element.anchorMaxY = _snapToGrid(newMaxY);
            }

            state.updateElement(element.id, element.clone());
          }
        },
        onPanEnd: (details) {
          _resizingElementId = null;
          _resizeStartPos = null;
          _originalAnchors = null;
        },
        child: Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: Colors.blue,
            border: Border.all(color: Colors.white, width: 2),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 3,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getElementColor(UiElement element) {
    if (element is PanelElement) {
      return element.backgroundColor;
    } else if (element is ButtonElement) {
      return element.backgroundColor;
    } else if (element is LabelElement && element.backgroundColor != null) {
      return element.backgroundColor!;
    }
    return Colors.transparent;
  }

  List<Widget> _buildVisualWarnings(UiElement element, double widthPx, double heightPx, bool isSelected) {
    List<Widget> warnings = [];

    // Check if image box has extreme aspect ratio
    if (element is ImageElement || element is ImageButtonElement) {
      double aspectRatio = widthPx / heightPx;

      // Warn if very wide or very tall (might indicate mismatched proportions)
      if (aspectRatio > 4 || aspectRatio < 0.25) {
        warnings.add(
          Positioned(
            top: 2,
            left: 2,
            child: Tooltip(
              message: 'Unusual box proportions. Image will letterbox/pillarbox to fit.',
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(33, 150, 243, 0.9),
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: const [
                    BoxShadow(color: Colors.black45, blurRadius: 4),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.info, size: 14, color: Colors.white),
                    SizedBox(width: 4),
                    Text(
                      'Check aspect ratio',
                      style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    }

    return warnings;
  }

  Widget _buildDimensionLabels(UiElement element, double widthPx, double heightPx) {
    // Calculate dimensions in anchor coordinates (0-1 range as percentages)
    double widthPercent = (element.anchorMaxX - element.anchorMinX) * 100;
    double heightPercent = (element.anchorMaxY - element.anchorMinY) * 100;

    return Positioned(
      bottom: -20,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          '${widthPercent.toStringAsFixed(1)}% × ${heightPercent.toStringAsFixed(1)}%',
          style: const TextStyle(color: Colors.white, fontSize: 10),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget? _getElementContent(UiElement element) {
    if (element is ButtonElement) {
      return Text(
        element.text,
        style: TextStyle(
          color: element.textColor,
          fontSize: element.fontSize.toDouble(),
        ),
        textAlign: TextAlign.center,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      );
    } else if (element is LabelElement) {
      return Text(
        element.text,
        style: TextStyle(
          color: element.textColor,
          fontSize: element.fontSize.toDouble(),
        ),
        textAlign: element.textAlign,
        maxLines: 5,
        overflow: TextOverflow.ellipsis,
      );
    } else if (element is ImageElement) {
      return Image.network(
        element.imageUrl,
        fit: BoxFit.contain,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                  : null,
              color: Colors.blue,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.broken_image, color: Colors.red[300], size: 24),
              const SizedBox(height: 4),
              Text(
                'Failed to load',
                style: TextStyle(color: Colors.red[300], fontSize: 10),
                textAlign: TextAlign.center,
              ),
            ],
          );
        },
      );
    } else if (element is ImageButtonElement) {
      // Show the normal image (not clicked) in the designer
      return Stack(
        children: [
          Image.network(
            element.imageUrl,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                      : null,
                  color: Colors.blue,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.broken_image, color: Colors.red[300], size: 24),
                  const SizedBox(height: 4),
                  Text(
                    'Failed to load',
                    style: TextStyle(color: Colors.red[300], fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            },
          ),
          // Show indicator that it's a button
          Positioned(
            top: 2,
            right: 2,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.purple[700],
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(Icons.touch_app, size: 12, color: Colors.white),
            ),
          ),
        ],
      );
    }
    return null;
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final thinPaint = Paint()
      ..color = Colors.white.withAlpha((0.08 * 255).round())
      ..strokeWidth = 0.5;

    final mediumPaint = Paint()
      ..color = Colors.white12
      ..strokeWidth = 0.5;

    final thickPaint = Paint()
      ..color = Colors.white24
      ..strokeWidth = 1.0;

    // Grid aligned to 1280x720 (Rust's reference) with 5% intervals (0.05 anchor coordinates)
    const gridDivisions = 20; // 20 divisions = 5% each

    final gridWidth = size.width / gridDivisions;
    final gridHeight = size.height / gridDivisions;

    // Draw vertical lines
    for (int i = 0; i <= gridDivisions; i++) {
      double x = i * gridWidth;
      Paint linePaint;

      // Thickest lines at 0%, 50%, 100%
      if (i == 0 || i == gridDivisions || i == gridDivisions ~/ 2) {
        linePaint = thickPaint;
      }
      // Medium lines at 10%, 20%, 30%, 40%, 60%, 70%, 80%, 90% (every other 10%)
      else if (i % 4 == 0) {
        linePaint = mediumPaint;
      }
      // Thin lines at 5%, 15%, 25%, etc. (5% intervals)
      else {
        linePaint = thinPaint;
      }

      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        linePaint,
      );
    }

    // Draw horizontal lines
    for (int i = 0; i <= gridDivisions; i++) {
      double y = i * gridHeight;
      Paint linePaint;

      // Thickest lines at 0%, 50%, 100%
      if (i == 0 || i == gridDivisions || i == gridDivisions ~/ 2) {
        linePaint = thickPaint;
      }
      // Medium lines at 10%, 20%, 30%, 40%, 60%, 70%, 80%, 90%
      else if (i % 4 == 0) {
        linePaint = mediumPaint;
      }
      // Thin lines at 5%, 15%, 25%, etc.
      else {
        linePaint = thinPaint;
      }

      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        linePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
