import 'package:flutter/material.dart';
import 'package:ygroup/data/entity/character.entity.dart';
import 'package:ygroup/data/entity/episode.entity.dart';
import 'package:ygroup/data/repository/character.repository.dart';
import 'package:ygroup/ui/common/widget/gender.widget.dart';
import 'package:ygroup/ui/common/widget/ui_utils.dart';

class CharacterScreen extends StatefulWidget {
  final Character character;

  const CharacterScreen({Key? key, required this.character}) : super(key: key);

  @override
  State<CharacterScreen> createState() => _CharacterScreenState();
}

class _CharacterScreenState extends State<CharacterScreen> {
  // Rick and Morty Wiki Colors
  static const Color _backgroundColor = Color(0xFF24282F);
  static const Color _accentColor = Color(0xFF97CE4C);
  static const Color _cardColor = Color(0xFF3C3E44);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  verticalSpace(20),
                  _buildSectionTitle('Info'),
                  verticalSpace(10),
                  _buildInfoCards(),
                  verticalSpace(20),
                  _buildSectionTitle('Episodes'),
                  verticalSpace(10),
                ],
              ),
            ),
          ),
          _buildEpisodesList(),
          SliverPadding(padding: EdgeInsets.only(bottom: 20)),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 350.0,
      pinned: true,
      backgroundColor: _backgroundColor,
      iconTheme: const IconThemeData(color: _accentColor),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          widget.character.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            shadows: [Shadow(color: Colors.black, blurRadius: 4)],
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              widget.character.image,
              fit: BoxFit.cover,
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Color(0xAA24282F),
                    _backgroundColor
                  ],
                  stops: [0.5, 0.8, 1.0],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatusIndicator(),
              verticalSpace(8),
              Text(
                "${widget.character.species} • ${widget.character.type.isEmpty ? 'Unknown Type' : widget.character.type}",
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        GenderWidget(
          gender: Gender.fromString(widget.character.gender),
          width: 50,
          height: 50,
        ),
      ],
    );
  }

  Widget _buildStatusIndicator() {
    Color statusColor;
    if (widget.character.isAlive) {
      statusColor = Colors.greenAccent;
    } else if (widget.character.status == "Dead") {
      statusColor = Colors.redAccent;
    } else {
      statusColor = Colors.grey;
    }

    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: statusColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: statusColor.withOpacity(0.6),
                blurRadius: 8,
                spreadRadius: 2,
              )
            ],
          ),
        ),
        horizontalSpace(8),
        Text(
          widget.character.status,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: _accentColor,
      ),
    );
  }

  Widget _buildInfoCards() {
    return Column(
      children: [
        _buildInfoTile("Origin", widget.character.origin.name, Icons.public),
        verticalSpace(10),
        _buildInfoTile("Last Known Location", widget.character.location.name,
            Icons.location_on),
      ],
    );
  }

  Widget _buildInfoTile(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white54, size: 24),
          horizontalSpace(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEpisodesList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final url = widget.character.episode[index];
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: _cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border(left: BorderSide(color: _accentColor, width: 4)),
              ),
              child: FutureBuilder<Episode>(
                future: CharacterRepository.getEpisode(url: url),
                builder: (context, state) {
                  if (state.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(_accentColor),
                      ),
                    );
                  }
                  if (state.hasData && state.data != null) {
                    // Assuming EpisodeItem can be styled or we use a custom tile here directly
                    // For now, wrapping the existing item or rebuilding it to fit the theme
                    // Since I don't see EpisodeItem source, I'll assume it returns a widget.
                    // To enforce theme, verify EpisodeItem later, but here I'll try to just show minimal info.
                    // Actually, let's use the existing Widget but maybe wrap it?
                    // The existing code used EpisodeItem(episode: episode).
                    // Let's use it but note that it might have light theme text.
                    // If it does, we might need to refactor EpisodeItem too.
                    // For now, I'll implement a custom tile consistent with this screen
                    // OR assume EpisodeItem is flexible. Based on typical patterns, it's better to
                    // build a simple custom tile here to guarantee the look.
                    final episode = state.data!;
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      title: Text(
                        episode.episode, // e.g., "S01E01"
                        style: const TextStyle(
                          color: _accentColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        "${episode.name}\n${episode.airDate}",
                        style: const TextStyle(color: Colors.white70),
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: const Icon(Icons.play_circle_outline,
                          color: Colors.white54),
                    );
                  }
                  return const Center(
                      child: Icon(Icons.error, color: Colors.redAccent));
                },
              ),
            ),
          );
        },
        childCount: widget.character.episode.length,
      ),
    );
  }
}
