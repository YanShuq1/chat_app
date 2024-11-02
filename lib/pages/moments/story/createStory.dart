import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateStory extends StatelessWidget {
  const CreateStory({super.key});

  Future<void> _pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      print('Selected image from gallery: ${image.path}');
      // You can add further processing for the selected image
    }
  }

  Future<void> _pickImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      print('Captured image from camera: ${image.path}');
      // You can add further processing for the captured image
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Story'),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context); // Go back to the previous screen
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
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
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
            Container(
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
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CupertinoButton(
                  onPressed: () {
                    print("Cancel icon tapped!");
                  },
                  padding: EdgeInsets.zero,
                  child: const Icon(CupertinoIcons.xmark_circle, size: 30),
                ),
                const SizedBox(width: 40),
                CupertinoButton(
                  onPressed: () {
                    print("Confirm icon tapped!");
                  },
                  padding: EdgeInsets.zero,
                  child:
                      const Icon(CupertinoIcons.check_mark_circled, size: 30),
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
                        size: 40, color: Colors.purple),
                  ),
                  const SizedBox(width: 30),
                  CupertinoButton(
                    onPressed: _pickImageFromCamera,
                    padding: EdgeInsets.zero,
                    child: const Icon(CupertinoIcons.camera,
                        size: 40, color: Colors.purple),
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
    );
  }
}
