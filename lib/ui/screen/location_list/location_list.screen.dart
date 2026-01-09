import 'package:flutter/material.dart';
import 'package:ygroup/data/entity/location.entity.dart';
import 'package:ygroup/data/repository/location.repository.dart';

class LocationListScreen extends StatefulWidget {
  const LocationListScreen({Key? key}) : super(key: key);

  @override
  State<LocationListScreen> createState() => _LocationListScreenState();
}

class _LocationListScreenState extends State<LocationListScreen> {
  late ScrollController _scrollController;
  final List<Location> _locations = [];
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
        final newLocations =
            await LocationRepository.getLocationList(page: _page);
        setState(() {
          _locations.addAll(newLocations);
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
          "Locations",
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
        itemCount: _locations.length + (_isLoading ? 1 : 0),
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          if (index < _locations.length) {
            final location = _locations[index];
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    location.name,
                    style: const TextStyle(
                      color: _accentColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildLabel("Type:", location.type),
                      const SizedBox(width: 16),
                      _buildLabel("Dimension:", location.dimension),
                    ],
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

  Widget _buildLabel(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
