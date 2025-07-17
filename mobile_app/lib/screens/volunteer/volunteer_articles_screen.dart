import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class VolunteerArticlesScreen extends StatefulWidget {
  const VolunteerArticlesScreen({Key? key}) : super(key: key);

  @override
  State<VolunteerArticlesScreen> createState() => _VolunteerArticlesScreenState();
}

class _VolunteerArticlesScreenState extends State<VolunteerArticlesScreen> {
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final FocusNode _descriptionFocusNode = FocusNode();
  
  List<File> _selectedImages = [];
  bool _isBold = false;
  bool _isItalic = false;
  bool _isUnderline = false;
  
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _topicController.dispose();
    _descriptionController.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImages.add(File(image.path));
      });
    }
  }

  Future<void> _pickImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _selectedImages.add(File(image.path));
      });
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.photo_library, color: Colors.blue),
              title: Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage();
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt, color: Colors.blue),
              title: Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImageFromCamera();
              },
            ),
            ListTile(
              leading: Icon(Icons.link, color: Colors.blue),
              title: Text('Add Image URL'),
              onTap: () {
                Navigator.pop(context);
                _showImageUrlDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showImageUrlDialog() {
    final TextEditingController urlController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Image URL'),
        content: TextField(
          controller: urlController,
          decoration: InputDecoration(
            hintText: 'Enter image URL',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (urlController.text.isNotEmpty) {
                // Handle URL image (you might want to validate and load it)
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Image URL added')),
                );
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Widget _buildFormattingToolbar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildFormattingButton(
            icon: Icons.format_bold,
            isActive: _isBold,
            onPressed: () => setState(() => _isBold = !_isBold),
          ),
          _buildFormattingButton(
            icon: Icons.format_italic,
            isActive: _isItalic,
            onPressed: () => setState(() => _isItalic = !_isItalic),
          ),
          _buildFormattingButton(
            icon: Icons.format_underlined,
            isActive: _isUnderline,
            onPressed: () => setState(() => _isUnderline = !_isUnderline),
          ),
          VerticalDivider(width: 20, thickness: 1),
          _buildFormattingButton(
            icon: Icons.format_list_bulleted,
            isActive: false,
            onPressed: () {
              // Handle bullet list
            },
          ),
          _buildFormattingButton(
            icon: Icons.format_list_numbered,
            isActive: false,
            onPressed: () {
              // Handle numbered list
            },
          ),
          _buildFormattingButton(
            icon: Icons.image,
            isActive: false,
            onPressed: _showImagePickerOptions,
          ),
        ],
      ),
    );
  }

  Widget _buildFormattingButton({
    required IconData icon,
    required bool isActive,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: isActive ? Colors.blue.withOpacity(0.1) : Colors.transparent,
      borderRadius: BorderRadius.circular(4),
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: onPressed,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Icon(
            icon,
            size: 18,
            color: isActive ? Colors.blue : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'New Article',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Article Details',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16),
            
            // Topic Field
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: TextField(
                controller: _topicController,
                decoration: InputDecoration(
                  hintText: 'Topic',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 16),
            
            // Description Field with Formatting Toolbar
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                children: [
                  // Formatting Toolbar
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      border: Border(
                        bottom: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                    child: _buildFormattingToolbar(),
                  ),
                  
                  // Text Field
                  TextField(
                    controller: _descriptionController,
                    focusNode: _descriptionFocusNode,
                    maxLines: 6,
                    decoration: InputDecoration(
                      hintText: 'Description',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16),
                    ),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: _isBold ? FontWeight.bold : FontWeight.normal,
                      fontStyle: _isItalic ? FontStyle.italic : FontStyle.normal,
                      decoration: _isUnderline ? TextDecoration.underline : TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
            
            // Selected Images Display
            if (_selectedImages.isNotEmpty) ...[
              SizedBox(height: 16),
              Text(
                'Selected Images',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              Container(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _selectedImages.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 120,
                      margin: EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              _selectedImages[index],
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () => _removeImage(index),
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.close,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
            
            SizedBox(height: 24),
            
            // Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle publish
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Article published!')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Publish',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Handle save draft
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Draft saved!')),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey[600],
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      side: BorderSide(color: Colors.grey[300]!),
                    ),
                    child: Text(
                      'Save Draft',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}