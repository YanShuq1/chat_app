import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hive/hive.dart';
import 'package:chat_app/model/story_model.dart';

class CreateStory extends StatefulWidget {
  const CreateStory({super.key});

  @override
  _CreateStoryState createState() => _CreateStoryState();
}

class _CreateStoryState extends State<CreateStory> {
  bool _showButtons = false;
  bool _isImageScaled = false;
  String _storyText = '';
  String? _selectedImagePath;

  @override
  void initState() {
    super.initState();
    _initializeHive();
  }

  Future<void> _initializeHive() async {
    //await Hive.openBox<StoryModel>('stories');
  }

  Future<void> _pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImagePath = image.path;
      });
    }
  }

  Future<void> _pickImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _selectedImagePath = image.path;
      });
    }
  }

  Future<void> _submitStory() async {
    if (_storyText.isEmpty || _selectedImagePath == null) return;

    var box = Hive.box<StoryModel>('stories');
    var newStory = StoryModel(
      username: '海小宝',
      avatarUrl: 'images/avatar2.jpg',
      timestamp: DateTime.now().toString(),
      text: _storyText,
      imageUrl: _selectedImagePath!,
      likes: 0,
      comments: 0,
    );
    await box.add(newStory);
    Navigator.pop(context); // Close the CreateStory page
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Create Story'),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(CupertinoIcons.back),
        ),
        trailing: GestureDetector(
          onTap: _submitStory,
          child: const Icon(CupertinoIcons.check_mark),
        ),
      ),
      child: Stack(
        children: [
          SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 120),
                CupertinoTextField(
                  placeholder: 'this moment, say something...',
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  textAlign: TextAlign.center,
                  onChanged: (text) {
                    setState(() {
                      _storyText = text;
                    });
                  },
                ),
                const SizedBox(height: 20),
                // Image Preview with Long Press Gesture and Zoom + Blur Animation
                GestureDetector(
                  onLongPressStart: (_) {
                    setState(() {
                      _showButtons = true;
                      _isImageScaled = true;
                    });
                  },
                  onLongPressEnd: (_) {
                    setState(() {
                      _isImageScaled = false;
                    });
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Background blur effect
                      AnimatedOpacity(
                        opacity: _isImageScaled ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 200),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            width: double.infinity,
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      // Zooming image or default background
                      Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: _selectedImagePath == null
                              ? Colors.grey[300]
                              : null,
                          image: _selectedImagePath != null
                              ? DecorationImage(
                                  image: FileImage(File(_selectedImagePath!)),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: _selectedImagePath == null
                            ? const Center(
                                child: Text(
                                  'tell your story...',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                          color:
                                              Color.fromARGB(82, 128, 175, 225),
                                          offset: Offset(1, 1),
                                          blurRadius: 4),
                                    ],
                                  ),
                                ),
                              )
                            : null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // Conditional Confirm and Cancel Icons
                if (_showButtons)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CupertinoButton(
                        onPressed: () {
                          setState(() {
                            _showButtons = false;
                            _selectedImagePath = null; // Reset image selection
                          });
                        },
                        padding: EdgeInsets.zero,
                        child:
                            const Icon(CupertinoIcons.xmark_circle, size: 30),
                      ),
                      const SizedBox(width: 40),
                      CupertinoButton(
                        onPressed: () {
                          setState(() {
                            _showButtons = false;
                          });
                          // print("Confirm icon tapped!");
                        },
                        padding: EdgeInsets.zero,
                        child: const Icon(CupertinoIcons.check_mark_circled,
                            size: 30),
                      ),
                    ],
                  ),
                const SizedBox(height: 20),
                // Image and Camera Icons with onTap functionality
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CupertinoButton(
                        onPressed: _pickImageFromGallery,
                        padding: EdgeInsets.zero,
                        child: const Icon(CupertinoIcons.photo,
                            size: 30, color: Colors.blue),
                      ),
                      const SizedBox(width: 30),
                      CupertinoButton(
                        onPressed: _pickImageFromCamera,
                        padding: EdgeInsets.zero,
                        child: const Icon(CupertinoIcons.camera,
                            size: 30, color: Colors.blue),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 120),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage('images/avatar2.jpg'),
                    ),
                    SizedBox(width: 10),
                    Text('@ 海小宝', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
