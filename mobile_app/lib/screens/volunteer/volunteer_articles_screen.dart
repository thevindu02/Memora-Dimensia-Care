import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../services/api_constants.dart';

class VolunteerArticlesScreen extends StatefulWidget {
  const VolunteerArticlesScreen({Key? key}) : super(key: key);

  @override
  State<VolunteerArticlesScreen> createState() =>
      _VolunteerArticlesScreenState();
}

class _VolunteerArticlesScreenState extends State<VolunteerArticlesScreen> {
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  final FocusNode _descriptionFocusNode = FocusNode();

  List<File> _selectedImages = [];
  bool _isBold = false;
  bool _isItalic = false;
  bool _isUnderline = false;
  bool _isLoading = false;
  String? _selectedCategory;
  List<String> _categories = [];
  List<int> _categoryIds = [];
  int? _selectedCategoryId;
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _topicController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchCategories();
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
              leading: Icon(Icons.photo_library, color: Color(0xFF2B3F99)),
              title: Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage();
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt, color: Color(0xFF2B3F99)),
              title: Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImageFromCamera();
              },
            ),
            ListTile(
              leading: Icon(Icons.link, color: Color(0xFF2B3F99)),
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
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Image URL added')));
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
      color: isActive ? Color(0xFFA0C4FD).withOpacity(0.3) : Colors.transparent,
      borderRadius: BorderRadius.circular(4),
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: onPressed,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Icon(
            icon,
            size: 18,
            color: isActive ? Color(0xFF2B3F99) : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  void _clearForm() {
    _topicController.clear();
    _descriptionController.clear();
    _tagsController.clear();
    setState(() {
      _selectedImages.clear();
      _selectedCategory = null;
      _selectedCategoryId = null;
      _isBold = false;
      _isItalic = false;
      _isUnderline = false;
    });
  }

  Future<void> submitArticle({required bool draft}) async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
    });
    
    final int volunteerId = 1; // TODO: Get this from your login/session!
    
    String? uploadedImageUrl;
    
    // Upload image to backend if one is selected
    if (_selectedImages.isNotEmpty) {
      uploadedImageUrl = await _uploadImageToBackend(_selectedImages.first);
      if (uploadedImageUrl == null) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image. Please try again.')),
        );
        return;
      }
    }

    final String url = '${ApiConstants.baseUrl}/api/articles';

    final Map<String, dynamic> articleData = {
      "volunteerId": volunteerId,
      "draft": draft,
      "title": _topicController.text,
      "summary": _descriptionController.text,
      "content": _descriptionController.text,
      "imageUrl": uploadedImageUrl ?? "", // Use uploaded image URL
      "category": _selectedCategory ?? "",
      "tags": _tagsController.text,
      "categoryId": _selectedCategoryId,
    };

    print("Submitting: " + jsonEncode(articleData));

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(articleData),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Article submitted!')));
      _clearForm();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed: ${response.body}')));
    }
  }

  Future<String?> _uploadImageToBackend(File imageFile) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiConstants.baseUrl}/api/upload/image'),
      );
      
      // Add the image file to the request
      request.files.add(
        await http.MultipartFile.fromPath(
          'image', // This should match the backend parameter name
          imageFile.path,
        ),
      );
      
      // Add additional fields if needed
      request.fields['type'] = 'article';
      request.fields['volunteerId'] = '1'; // TODO: Get from session
      
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        // Backend should return the uploaded file URL or path
        return responseData['imageUrl'] ?? responseData['filePath'];
      } else {
        print('Image upload failed: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> fetchCategories() async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/api/categories'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        _categories = data
            .map<String>((cat) => cat['categoryName'] as String)
            .toList();
        _categoryIds = data
            .map<int>((cat) => cat['categoryId'] as int)
            .toList();
      });
    } else {
      // Handle error
      print('Failed to load categories');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF2B3F99)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Create Article', style: TextStyle(color: Color(0xFF2B3F99))),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Article Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2B3F99),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Category Dropdown
                  Text(
                    'Category',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2B3F99),
                    ),
                  ),
                  SizedBox(height: 6),
                  SizedBox(
                    width: double.infinity,
                    child: DropdownButtonFormField<int>(
                      value: _selectedCategoryId,
                      items: List.generate(_categories.length, (index) {
                        return DropdownMenuItem(
                          value: _categoryIds[index],
                          child: Text(_categories[index]),
                        );
                      }),
                      onChanged: (val) =>
                          setState(() => _selectedCategoryId = val),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                      validator: (val) =>
                          val == null ? 'Please select a category' : null,
                      isExpanded: true,
                      icon: Icon(Icons.arrow_drop_down),
                      hint: Text(
                        'Select Category',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Topic Field
                  Text('Title', style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2B3F99),
                  )),
                  SizedBox(height: 6),
                  TextFormField(
                    controller: _topicController,
                    decoration: InputDecoration(
                      hintText: 'Enter article title',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(16),
                    ),
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Title is required' : null,
                  ),
                  SizedBox(height: 16),
                  // Tags Field
                  Text('Tags', style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2B3F99),
                  )),
                  SizedBox(height: 6),
                  TextFormField(
                    controller: _tagsController,
                    decoration: InputDecoration(
                      hintText: 'Comma separated (e.g. health, memory, tips)',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(16),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Description Field with Formatting Toolbar
                  Text(
                    'Content',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2B3F99),
                    ),
                  ),
                  SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      children: [
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
                        TextFormField(
                          controller: _descriptionController,
                          focusNode: _descriptionFocusNode,
                          maxLines: 6,
                          decoration: InputDecoration(
                            hintText: 'Write your article content here...',
                            hintStyle: TextStyle(color: Colors.grey[500]),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(16),
                          ),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: _isBold
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontStyle: _isItalic
                                ? FontStyle.italic
                                : FontStyle.normal,
                            decoration: _isUnderline
                                ? TextDecoration.underline
                                : TextDecoration.none,
                          ),
                          validator: (val) => val == null || val.isEmpty
                              ? 'Content is required'
                              : null,
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
                          onPressed: _isLoading
                              ? null
                              : () => submitArticle(draft: false),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF2B3F99),
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
                          onPressed: _isLoading
                              ? null
                              : () => submitArticle(draft: true),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Color(0xFF2B3F99),
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            side: BorderSide(color: Color(0xFFA0C4FD)),
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
                  SizedBox(height: 12),
                  Center(
                    child: TextButton.icon(
                      onPressed: _isLoading ? null : _clearForm,
                      icon: Icon(Icons.clear, color: Color(0xFF2B3F99)),
                      label: Text(
                        'Clear Form',
                        style: TextStyle(color: Color(0xFF2B3F99)),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.2),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
