import 'dart:io';
import 'package:chat_app/model/contact.dart';
import 'package:chat_app/model/story_model.dart';
import 'package:chat_app/widgets/like_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Story extends StatelessWidget {
  const Story({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<StoryModel>('stories').listenable(),
      builder: (context, Box<StoryModel> box, _) {
        if (box.isEmpty) {
          return const Center(child: Text("No stories available"));
        }
        List<StoryModel> stories = box.values.toList().reversed.toList();

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: stories.length,
          itemBuilder: (context, index) {
            return _buildStoryItem(context, stories[index]);
          },
        );
      },
    );
  }

  // Constructs each Story item
  Widget _buildStoryItem(BuildContext context, StoryModel story) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User info
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(currentUser.avatarUrl),
                radius: 24,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    story.username,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    story.timestamp,
                    style: const TextStyle(
                      fontSize: 12,
                      color: CupertinoColors.inactiveGray,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(CupertinoIcons.ellipsis),
                onPressed: () {
                  // More options logic
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Text content
          Text(story.text),
          const SizedBox(height: 10),
          // Image content
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: FutureBuilder<ImageProvider>(
              future: _loadImage(story.imageUrl),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    width: double.infinity,
                    height: 180,
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) {
                  // Error case, show default image
                  return Image.asset(
                    'images/avatar2.jpg', // Default image path
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                  );
                } else {
                  return Image(
                    image: snapshot.data!,
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 10),
          // Likes and comments
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(CupertinoIcons.hand_thumbsup_fill,
                    color: Colors.blue, size: 18),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(CupertinoIcons.heart_fill,
                    color: Colors.red, size: 18),
              ),
              const SizedBox(width: 8),
              Text(
                '${story.likes} K',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                '${story.comments} comments',
                style: const TextStyle(
                  color: CupertinoColors.inactiveGray,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Interaction buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const LikeButtonWithAnimation(),
              _buildActionButton(
                icon: CupertinoIcons.chat_bubble_text,
                label: 'Comment',
              ),
              _buildActionButton(
                icon: CupertinoIcons.bell,
                label: 'Share',
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Load image function
  Future<ImageProvider> _loadImage(String imagePath) async {
    // Check if image exists in files; if not, try loading from assets
    if (await File(imagePath).exists()) {
      return FileImage(File(imagePath));
    } else {
      return AssetImage(imagePath); // Try loading from assets if file not found
    }
  }

  // Action button builder
  Widget _buildActionButton(
      {required IconData icon, required String label, Color? color}) {
    return TextButton.icon(
      style: TextButton.styleFrom(
        foregroundColor: color ?? Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: CupertinoColors.systemGrey3),
        ),
      ),
      onPressed: () {
        // Button logic
      },
      icon: Icon(icon, size: 18, color: color ?? Colors.black),
      label: Text(
        label,
        style: TextStyle(
          color: color ?? Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
