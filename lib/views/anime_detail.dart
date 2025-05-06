import 'package:flutter/material.dart';
import 'package:tugas_3/network/base_network.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DetailScreen extends StatefulWidget {
  final int id;
  final String endpoint;
  const DetailScreen({super.key, required this.id, required this.endpoint});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _detailData;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchDetailData();
  }

  Future<void> _fetchDetailData() async {
    try {
      final data = await BaseNetwork.getDetailData(widget.endpoint, widget.id);
      setState(() {
        _detailData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = (_detailData != null &&
            _detailData!['images'] != null &&
            _detailData!['images'].isNotEmpty)
        ? _detailData!['images'][0]
        : null;

    Widget imageWidget;

    if (imageUrl != null && imageUrl.endsWith('.svg')) {
      imageWidget = SvgPicture.network(
        imageUrl,
        placeholderBuilder: (context) =>
            Image.asset('assets/images/placeholder.jpeg', height: 200),
        height: 200,
      );
    } else if (imageUrl != null) {
      imageWidget = Image.network(
        imageUrl,
        errorBuilder: (context, error, stackTrace) =>
            Image.asset('assets/images/placeholder.jpeg', height: 200),
        height: 200,
      );
    } else {
      imageWidget = Image.asset('assets/images/placeholder.jpeg', height: 200);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Detail"),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text("Error $_errorMessage"))
              : _detailData != null
                  ? SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: imageWidget,
                          ),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                )
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Name: ${_detailData!['name']}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "Kekkei Genkai: ${_detailData!['personal']["kekkeiGenaki"] ?? 'Empty'}",
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "Titles: ${_detailData!['personal']['titles']}",
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "Family: ${_detailData!['family']?['creator'] ?? 'No Family Info'}",
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "Debut: ${_detailData!['debut'] ?? 'No Debut Info'}",
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : Center(child: Text("No Data Available")),
    );
  }
}
