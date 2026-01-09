import 'package:flutter/material.dart';
import 'package:ygroup/data/entity/character.entity.dart';
import 'package:ygroup/data/repository/character.repository.dart';
import 'package:ygroup/ui/common/widget/ui_utils.dart';
import 'package:ygroup/ui/screen/character_list/widget/character_item.widget.dart';

class CharacterListScreen extends StatefulWidget {
  const CharacterListScreen({Key? key}) : super(key: key);

  @override
  State<CharacterListScreen> createState() => _CharacterListScreenState();
}

class _CharacterListScreenState extends State<CharacterListScreen> {
  late ScrollController _scrollController;
  final TextEditingController _searchController = TextEditingController();

  final List<Character> _characters = [];
  int _page = 1;
  bool _isLoading = false;

  // Filter State
  String _searchQuery = "";
  String? _filterStatus;
  String? _filterGender;

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
    _searchController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadData();
    }
  }

  Future<void> _loadData({bool refresh = false}) async {
    if (refresh) {
      setState(() {
        _page = 1;
        _characters.clear();
      });
    }

    // Stop if already loading
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final newCharacters = await CharacterRepository.getCharacterList(
        page: _page,
        name: _searchQuery,
        status: _filterStatus,
        gender: _filterGender,
      );

      setState(() {
        _characters.addAll(newCharacters);
        _page++;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged(String query) {
    if (_searchQuery != query) {
      _searchQuery = query;
      // Debounce could be added here, but for now direct trigger
      _loadData(refresh: true);
    }
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Filter Characters",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  verticalSpace(20),
                  const Text("Status",
                      style: TextStyle(
                          color: _accentColor, fontWeight: FontWeight.w600)),
                  verticalSpace(10),
                  Wrap(
                    spacing: 10,
                    children: ["Alive", "Dead", "unknown"].map((status) {
                      final isSelected = _filterStatus == status;
                      return FilterChip(
                        label: Text(status),
                        selected: isSelected,
                        onSelected: (selected) {
                          setModalState(() {
                            _filterStatus = selected ? status : null;
                          });
                        },
                        backgroundColor: _backgroundColor,
                        selectedColor: _accentColor.withOpacity(0.5),
                        checkmarkColor: _accentColor,
                        labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.white70),
                      );
                    }).toList(),
                  ),
                  verticalSpace(20),
                  const Text("Gender",
                      style: TextStyle(
                          color: _accentColor, fontWeight: FontWeight.w600)),
                  verticalSpace(10),
                  Wrap(
                    spacing: 10,
                    children: ["Male", "Female", "Genderless", "unknown"]
                        .map((gender) {
                      final isSelected = _filterGender == gender;
                      return FilterChip(
                        label: Text(gender),
                        selected: isSelected,
                        onSelected: (selected) {
                          setModalState(() {
                            _filterGender = selected ? gender : null;
                          });
                        },
                        backgroundColor: _backgroundColor,
                        selectedColor: _accentColor.withOpacity(0.5),
                        checkmarkColor: _accentColor,
                        labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.white70),
                      );
                    }).toList(),
                  ),
                  verticalSpace(30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _loadData(refresh: true);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _accentColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text(
                        "Apply Filters",
                        style: TextStyle(
                            color: _backgroundColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            backgroundColor: _backgroundColor,
            floating: true,
            pinned: true,
            title: const Text(
              "The Rick and Morty",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            centerTitle: true,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(70.0),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: _cardColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: TextField(
                          controller: _searchController,
                          onSubmitted: _onSearchChanged,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: "Search character...",
                            hintStyle: TextStyle(color: Colors.white38),
                            prefixIcon: Icon(Icons.search, color: _accentColor),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                          ),
                        ),
                      ),
                    ),
                    horizontalSpace(10),
                    Container(
                      decoration: BoxDecoration(
                        color: _cardColor,
                        borderRadius: BorderRadius.circular(15),
                        border: (_filterStatus != null || _filterGender != null)
                            ? Border.all(color: _accentColor)
                            : null,
                      ),
                      child: IconButton(
                        icon:
                            const Icon(Icons.filter_list, color: _accentColor),
                        onPressed: _showFilterDialog,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final character = _characters[index];
                  return CharacterItem(character: character);
                },
                childCount: _characters.length,
              ),
            ),
          ),
          if (_isLoading)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(_accentColor),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
