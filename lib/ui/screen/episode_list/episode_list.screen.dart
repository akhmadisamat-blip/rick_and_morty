import 'package:flutter/material.dart';
import 'package:ygroup/data/entity/episode.entity.dart';
import 'package:ygroup/data/repository/episode.repository.dart';

class EpisodeListScreen extends StatefulWidget {
  const EpisodeListScreen({Key? key}) : super(key: key);

  @override
  State<EpisodeListScreen> createState() => _EpisodeListScreenState();
}

class _EpisodeListScreenState extends State<EpisodeListScreen> {
  late ScrollController _scrollController;
  final List<Episode> _episodes = [];
  int _page = 1;
  bool _isLoading = false;
  static const Color _backgroundColor = Color(0xFF24282F);
  static const Color _accentColor = Color(0xFF97CE4C);
  static const Color _cardColor = Color(0xFF3C3E44);

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _loadData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadData();
    }
  }

  Future<void> _loadData() async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });
      try {
        final newEpisodes = await EpisodeRepository.getEpisodeList(page: _page);
        setState(() {
          _episodes.addAll(newEpisodes);
          _page++;
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: _backgroundColor,
        title: const Text(
          "Episodes",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Divider(color: _accentColor, height: 1),
        ),
      ),
      body: ListView.separated(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: _episodes.length + (_isLoading ? 1 : 0),
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          if (index < _episodes.length) {
            final episode = _episodes[index];
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border(left: BorderSide(color: _accentColor, width: 4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    episode.episode,
                    style: const TextStyle(
                      color: _accentColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    episode.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    episode.airDate,
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(_accentColor),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
