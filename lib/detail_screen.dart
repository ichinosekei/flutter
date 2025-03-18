import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'cat_model.dart';

class DetailScreen extends StatelessWidget {
  final Cat cat;

  const DetailScreen({Key? key, required this.cat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final breed = cat.breed;
    return Scaffold(
      appBar: AppBar(
        title: Text(breed?.name ?? 'Детали кота'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: cat.url,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            const SizedBox(height: 16),
            breed != null
                ? buildBreedDetails(breed)
                : const Text('Информация о породе отсутствует'),
          ],
        ),
      ),
    );
  }

  Widget buildBreedDetails(Breed breed) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Порода: ${breed.name}',
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Темперамент: ${breed.temperament}',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        Text(
          'Происхождение: ${breed.origin}',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
        Text(
          'Описание: ${breed.description}',
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
