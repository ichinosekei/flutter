import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'cat_api_service.dart';
import 'cat_model.dart';
import 'detail_screen.dart';
import 'like_button.dart';
import 'dislike_button.dart';

void main() {
  runApp(const CatApp());
}

class CatApp extends StatelessWidget {
  const CatApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CatsTunder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CatHomePage(),
    );
  }
}

class CatHomePage extends StatefulWidget {
  const CatHomePage({Key? key}) : super(key: key);

  @override
  CatHomePageState createState() => CatHomePageState();
}

class CatHomePageState extends State<CatHomePage> {
  Cat? currentCat;
  int likeCount = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchNewCat();
  }


  Future<void> fetchNewCat() async {
    setState(() {
      isLoading = true;
    });
    Cat? cat = await CatApiService.fetchRandomCat();
    setState(() {
      currentCat = cat;
      isLoading = false;
    });
  }

  void handleLike() {
    setState(() {
      likeCount++;
    });
    fetchNewCat();
  }

  void handleDislike() {
    fetchNewCat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CatsTinder'),
      ),
      body: isLoading || currentCat == null
          ? const Center(child: CircularProgressIndicator())
          : GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(cat: currentCat!),
                  ),
                );
              },
              child: Dismissible(
                key: UniqueKey(),
                direction: DismissDirection.horizontal,
                onDismissed: (direction) {
                  if (direction == DismissDirection.startToEnd) {
                    handleLike();
                  } else if (direction == DismissDirection.endToStart) {
                    handleDislike();
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: CachedNetworkImage(
                          imageUrl: currentCat!.url,
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Порода: ${currentCat!.breed?.name ?? 'Неизвестно'}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Лайков: $likeCount',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        LikeButton(onPressed: handleLike),
                        DislikeButton(onPressed: handleDislike),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
    );
  }
}
