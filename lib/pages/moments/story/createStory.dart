import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateStory extends StatefulWidget {
  const CreateStory({super.key});

  @override
  _CreateStoryState createState() => _CreateStoryState();
}

class _CreateStoryState extends State<CreateStory> {
  bool _showButtons = false;
  bool _isImageScaled = false; // Controls the zoom effect

  Future<void> _pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      print('Selected image from gallery: ${image.path}');
    }
  }

  Future<void> _pickImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      print('Captured image from camera: ${image.path}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Story'),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(CupertinoIcons.back),
        ),
        trailing: GestureDetector(
          onTap: () {
            print("Story submitted!");
          },
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
                const CupertinoTextField(
                  placeholder: 'this moment，say something。。。',
                  padding: EdgeInsets.symmetric(vertical: 12),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                // Image Preview with Long Press Gesture and Zoom + Blur Animation
                GestureDetector(
                  onLongPressStart: (_) {
                    setState(() {
                      _showButtons = true;
                      _isImageScaled = true; // Scale up the image
                    });
                  },
                  onLongPressEnd: (_) {
                    setState(() {
                      _isImageScaled = false; // Scale down the image
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
                      // Zooming image
                      AnimatedScale(
                        scale: _isImageScaled
                            ? 1.2
                            : 1.0, // Zoom factor when scaled
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        child: Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: const DecorationImage(
                              image: AssetImage('images/avatar2.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
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
                          });
                          print("Cancel icon tapped!");
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
                          print("Confirm icon tapped!");
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage('images/avatar2.jpg'),
                    ),
                    const SizedBox(width: 10),
                    const Text('@ 海小宝', style: TextStyle(fontSize: 16)),
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
