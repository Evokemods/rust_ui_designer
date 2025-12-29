import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/designer_state.dart';
import '../models/panel_element.dart';
import '../models/button_element.dart';
import '../models/label_element.dart';
import '../models/image_element.dart';
import '../models/image_button_element.dart';

class ToolboxWidget extends StatelessWidget {
  const ToolboxWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      color: Colors.grey[850],
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Toolbox',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'UI Elements',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          _buildToolButton(
            context,
            icon: Icons.crop_square,
            label: 'Panel',
            onPressed: () => _addPanel(context),
          ),
          const SizedBox(height: 10),
          _buildToolButton(
            context,
            icon: Icons.smart_button,
            label: 'Button',
            onPressed: () => _addButton(context),
          ),
          const SizedBox(height: 10),
          _buildToolButton(
            context,
            icon: Icons.text_fields,
            label: 'Label',
            onPressed: () => _addLabel(context),
          ),
          const SizedBox(height: 10),
          _buildToolButton(
            context,
            icon: Icons.image,
            label: 'Image',
            onPressed: () => _addImage(context),
          ),
          const SizedBox(height: 20),
          const Text(
            'Quick Helpers',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          _buildToolButton(
            context,
            icon: Icons.close,
            label: 'Close Button',
            color: Colors.red[900],
            onPressed: () => _addCloseButton(context),
          ),
          const SizedBox(height: 10),
          _buildToolButton(
            context,
            icon: Icons.arrow_back,
            label: 'Back Button',
            color: Colors.blue[800],
            onPressed: () => _addBackButton(context),
          ),
          const SizedBox(height: 10),
          _buildToolButton(
            context,
            icon: Icons.arrow_forward,
            label: 'Next Button',
            color: Colors.blue[800],
            onPressed: () => _addNextButton(context),
          ),
          const SizedBox(height: 10),
          _buildToolButton(
            context,
            icon: Icons.check,
            label: 'Confirm Button',
            color: Colors.green[800],
            onPressed: () => _addConfirmButton(context),
          ),
          const SizedBox(height: 10),
          _buildToolButton(
            context,
            icon: Icons.cancel,
            label: 'Cancel Button',
            color: Colors.orange[900],
            onPressed: () => _addCancelButton(context),
          ),
          const SizedBox(height: 10),
          _buildToolButton(
            context,
            icon: Icons.image_outlined,
            label: 'Image Button',
            color: Colors.purple[700],
            onPressed: () => _addImageButton(context),
          ),
          const Spacer(),
          const Divider(color: Colors.white24),
          _buildToolButton(
            context,
            icon: Icons.delete,
            label: 'Delete',
            color: Colors.red[700],
            onPressed: () => _deleteSelected(context),
          ),
        ],
      ),
    );
  }

  Widget _buildToolButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    Color? color,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? Colors.grey[700],
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }

  void _addPanel(BuildContext context) {
    var state = context.read<DesignerState>();
    var uuid = const Uuid();

    // Check if root panel exists
    if (state.rootPanel == null) {
      // Create root panel
      var panel = PanelElement(
        id: uuid.v4(),
        anchorMinX: 0.3,
        anchorMinY: 0.3,
        anchorMaxX: 0.7,
        anchorMaxY: 0.7,
        name: state.mainUiName,
      );
      state.addElement(panel);
      state.selectElement(panel.id);
    } else {
      // Create child panel
      var panel = PanelElement(
        id: uuid.v4(),
        parentId: state.rootPanel!.id,
        anchorMinX: 0.1,
        anchorMinY: 0.1,
        anchorMaxX: 0.9,
        anchorMaxY: 0.9,
        name: 'Panel_${uuid.v4().substring(0, 8)}',
      );
      state.addElement(panel);
      state.selectElement(panel.id);
    }
  }

  void _addButton(BuildContext context) {
    var state = context.read<DesignerState>();
    var uuid = const Uuid();

    if (state.rootPanel == null) {
      _showNeedRootPanelDialog(context);
      return;
    }

    var button = ButtonElement(
      id: uuid.v4(),
      parentId: state.selectedElement?.id ?? state.rootPanel!.id,
      anchorMinX: 0.4,
      anchorMinY: 0.45,
      anchorMaxX: 0.6,
      anchorMaxY: 0.55,
      text: 'Button',
      command: 'button.click',
    );

    state.addElement(button);
    state.selectElement(button.id);
  }

  void _addCloseButton(BuildContext context) {
    var state = context.read<DesignerState>();
    var uuid = const Uuid();

    if (state.rootPanel == null) {
      _showNeedRootPanelDialog(context);
      return;
    }

    var button = ButtonElement(
      id: uuid.v4(),
      parentId: state.selectedElement?.id ?? state.rootPanel!.id,
      anchorMinX: 0.92,
      anchorMinY: 0.92,
      anchorMaxX: 0.98,
      anchorMaxY: 0.98,
      text: '×',
      fontSize: 20,
      textColor: const Color(0xFFFFFFFF), // White
      backgroundColor: const Color(0xFFB22222), // CloseButton red
      command: 'ui.close',
    );

    state.addElement(button);
    state.selectElement(button.id);
  }

  void _addBackButton(BuildContext context) {
    var state = context.read<DesignerState>();
    var uuid = const Uuid();

    if (state.rootPanel == null) {
      _showNeedRootPanelDialog(context);
      return;
    }

    var button = ButtonElement(
      id: uuid.v4(),
      parentId: state.selectedElement?.id ?? state.rootPanel!.id,
      anchorMinX: 0.02,
      anchorMinY: 0.02,
      anchorMaxX: 0.12,
      anchorMaxY: 0.10,
      text: '<',
      fontSize: 24,
      textColor: const Color(0xFFFFFFFF), // White
      backgroundColor: const Color(0xFF1976D2), // Blue
      command: 'button.back',
    );

    state.addElement(button);
    state.selectElement(button.id);
  }

  void _addNextButton(BuildContext context) {
    var state = context.read<DesignerState>();
    var uuid = const Uuid();

    if (state.rootPanel == null) {
      _showNeedRootPanelDialog(context);
      return;
    }

    var button = ButtonElement(
      id: uuid.v4(),
      parentId: state.selectedElement?.id ?? state.rootPanel!.id,
      anchorMinX: 0.88,
      anchorMinY: 0.02,
      anchorMaxX: 0.98,
      anchorMaxY: 0.10,
      text: '>',
      fontSize: 24,
      textColor: const Color(0xFFFFFFFF), // White
      backgroundColor: const Color(0xFF1976D2), // Blue
      command: 'button.next',
    );

    state.addElement(button);
    state.selectElement(button.id);
  }

  void _addConfirmButton(BuildContext context) {
    var state = context.read<DesignerState>();
    var uuid = const Uuid();

    if (state.rootPanel == null) {
      _showNeedRootPanelDialog(context);
      return;
    }

    var button = ButtonElement(
      id: uuid.v4(),
      parentId: state.selectedElement?.id ?? state.rootPanel!.id,
      anchorMinX: 0.30,
      anchorMinY: 0.10,
      anchorMaxX: 0.48,
      anchorMaxY: 0.20,
      text: 'Confirm',
      fontSize: 18,
      textColor: const Color(0xFFFFFFFF), // White
      backgroundColor: const Color(0xFF2E7D32), // Green
      command: 'button.confirm',
    );

    state.addElement(button);
    state.selectElement(button.id);
  }

  void _addCancelButton(BuildContext context) {
    var state = context.read<DesignerState>();
    var uuid = const Uuid();

    if (state.rootPanel == null) {
      _showNeedRootPanelDialog(context);
      return;
    }

    var button = ButtonElement(
      id: uuid.v4(),
      parentId: state.selectedElement?.id ?? state.rootPanel!.id,
      anchorMinX: 0.52,
      anchorMinY: 0.10,
      anchorMaxX: 0.70,
      anchorMaxY: 0.20,
      text: 'Cancel',
      fontSize: 18,
      textColor: const Color(0xFFFFFFFF), // White
      backgroundColor: const Color(0xFFE64A19), // Orange-Red
      command: 'button.cancel',
    );

    state.addElement(button);
    state.selectElement(button.id);
  }

  void _addImageButton(BuildContext context) {
    var state = context.read<DesignerState>();
    var uuid = const Uuid();

    if (state.rootPanel == null) {
      _showNeedRootPanelDialog(context);
      return;
    }

    var imageButton = ImageButtonElement(
      id: uuid.v4(),
      parentId: state.selectedElement?.id ?? state.rootPanel!.id,
      anchorMinX: 0.40,
      anchorMinY: 0.40,
      anchorMaxX: 0.60,
      anchorMaxY: 0.60,
      imageUrl: 'https://rustlabs.com/img/items180/wood.png',
      imageUrlClicked: 'https://rustlabs.com/img/items180/stones.png',
      command: 'imagebutton.click',
    );

    state.addElement(imageButton);
    state.selectElement(imageButton.id);
  }

  void _addLabel(BuildContext context) {
    var state = context.read<DesignerState>();
    var uuid = const Uuid();

    if (state.rootPanel == null) {
      _showNeedRootPanelDialog(context);
      return;
    }

    var label = LabelElement(
      id: uuid.v4(),
      parentId: state.selectedElement?.id ?? state.rootPanel!.id,
      anchorMinX: 0.3,
      anchorMinY: 0.45,
      anchorMaxX: 0.7,
      anchorMaxY: 0.55,
      text: 'Label Text',
    );

    state.addElement(label);
    state.selectElement(label.id);
  }

  void _addImage(BuildContext context) {
    var state = context.read<DesignerState>();
    var uuid = const Uuid();

    if (state.rootPanel == null) {
      _showNeedRootPanelDialog(context);
      return;
    }

    var image = ImageElement(
      id: uuid.v4(),
      parentId: state.selectedElement?.id ?? state.rootPanel!.id,
      anchorMinX: 0.4,
      anchorMinY: 0.4,
      anchorMaxX: 0.6,
      anchorMaxY: 0.6,
      imageUrl: 'https://rustlabs.com/img/items180/wood.png',
    );

    state.addElement(image);
    state.selectElement(image.id);
  }

  void _deleteSelected(BuildContext context) {
    var state = context.read<DesignerState>();
    if (state.selectedElementId != null) {
      state.removeElement(state.selectedElementId!);
    }
  }

  void _showNeedRootPanelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Root Panel Required'),
        content: const Text('Please create a root panel first before adding other elements.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
