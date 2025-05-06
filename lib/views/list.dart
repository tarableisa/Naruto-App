import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Tambahkan ini
import 'package:tugas_3/models/anime_model.dart';
import 'package:tugas_3/presenters/anime_presenter.dart';
import 'package:tugas_3/views/anime_detail.dart';

class AnimeListScreen extends StatefulWidget {
  const AnimeListScreen({super.key});

  @override
  State<AnimeListScreen> createState() => _AnimeListScreenState();
}

class _AnimeListScreenState extends State<AnimeListScreen>
    implements AnimeView {
  late AnimePresenter _presenter;
  bool _isLoading = false;
  List<Anime> _animeList = [];
  String? _errorMessage;
  String _currentEndpoint = 'akatsuki';

  @override
  void initState() {
    super.initState();
    _presenter = AnimePresenter(this);
    _presenter.loadAnimeData(_currentEndpoint);
  }

  void _fetchData(String endpoint) {
    setState(() {
      _errorMessage = null;
      _isLoading = true;
      _currentEndpoint = endpoint;
    });
    _presenter.loadAnimeData(endpoint);
  }

  @override
  void hideLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void showAnimeList(List<Anime> animeList) {
    setState(() {
      _animeList = animeList;
      _errorMessage = null;
    });
  }

  @override
  void showError(String message) {
    setState(() {
      _errorMessage = message;
      _animeList = [];
      _isLoading = false;
    });
  }

  @override
  void showLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  Widget _buildImage(String url) {
    if (url.toLowerCase().endsWith('.svg')) {
      return SvgPicture.network(
        url,
        placeholderBuilder: (context) => const CircularProgressIndicator(),
        height: 50,
        width: 50,
        errorBuilder: (context, error, stackTrace) => Image.asset(
          'assets/images/placeholder.jpeg',
          height: 50,
          width: 50,
        ),
      );
    } else {
      return Image.network(
        url,
        height: 50,
        width: 50,
        errorBuilder: (context, error, stackTrace) => Image.asset(
          'assets/images/placeholder.jpeg',
          height: 50,
          width: 50,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Anime List")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _fetchData('akatsuki'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Akatsuki",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _fetchData('kara'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Kara",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _fetchData('characters'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Characters",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                      ? Center(
                          child: Text(
                            "Error: $_errorMessage",
                            style: const TextStyle(
                                color: Colors.red, fontSize: 16),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _animeList.length,
                          itemBuilder: (context, index) {
                            final anime = _animeList[index];
                            return Card(
                              color: Colors.blue[50],
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 4),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(12),
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: anime.imageUrl.isNotEmpty
                                      ? _buildImage(anime.imageUrl)
                                      : Image.asset(
                                          'assets/images/placeholder.jpeg',
                                          height: 50,
                                          width: 50,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                title: Text(
                                  anime.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                subtitle: Text(
                                  "Family: ${anime.familyCreator}",
                                  style: const TextStyle(fontSize: 14),
                                ),
                                trailing: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.blue,
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailScreen(
                                        id: anime.id,
                                        endpoint: _currentEndpoint,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
