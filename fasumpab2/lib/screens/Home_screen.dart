import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fasumpab2/screens/AddPost_screen.dart';
import 'package:fasumpab2/screens/SignIn_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SignInScreen()));
  }

  void _showCategoryFilter () async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
            'Fasum',
        style: TextStyle(
          color: Colors.green[600],
          fontWeight: FontWeight.bold,
        ),
        ),
        actions: [
          IconButton(
              onPressed: _showCategoryFilter,
              icon: const Icon(Icons.filter_list),
              tooltip: 'Filter by category',
          ),
          IconButton(
            onPressed: () {
              signOut(context);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
                  .collection('posts')
                  .orderBy('createdAt', descending: true)
                  snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final posts = snapshot.data!.docs.where((doc) {
              final data = doc.data();
              final category = data['category']??'Lainnya';
              return selectedCategory == null || category == selectedCategory;
            }).toList();

            if (posts.isEmpty) {
              return const Center(child: Text('Tidak ada Laporan Untuk Kategori ini.'
              ));
            }
              return ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final data = posts[index].data();
                  final imageBase64 = data['image'];
                  final description = data['description'];
                  final createdAtStr = data['createdAt'];
                  final fullName = data['fullName'];
                  final Latitude = data['Latitude'];
                  final Longtitude = data['Longtitude'];
                  final category = data['category']??'Lainnya';
                  final createdAt = DateTime.parse(createdAtStr);

                  String heroTag = 'fasum-image -${createdAt.millisecondsSinceEpoch}';

                  return InkWell(
                    onTap: () {},
                    child: Card(
                      elevation: 1,
                      color: Theme.of(context).colorScheme.surfaceContainerLow,
                      shadowColor: Theme.of(context).colorScheme.shadow,
                      margin: const EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(),
                          if (imageBase64 != null)
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(10),
                              ),
                              child: Hero(
                                tag: heroTag,
                                child: Image.memory(
                                  base64Decode(imageBase64),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 200,
                            ),
                          ),
                            ),
                        ],
                      ),
                    )

                  );
                },
              );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddPostScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}