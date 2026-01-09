import 'package:flutter/material.dart';
import 'package:ygroup/data/entity/character.entity.dart';
import 'package:ygroup/ui/common/widget/gender.widget.dart';
import 'package:ygroup/ui/common/widget/ui_utils.dart';
import 'package:ygroup/ui/screen/character/charapter.screen.dart';

class CharacterItem extends StatelessWidget {
  final Character character;

  const CharacterItem({Key? key, required this.character}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CharacterScreen(character: character),
          ),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30.0,
              backgroundImage: NetworkImage(character.image),
              backgroundColor: Colors.grey,
            ),
            horizontalSpace(10),
            Expanded(
                child: Text(
              character.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            )),
            horizontalSpace(10),
            GenderWidget(
              gender: Gender.fromString(character.gender),
              width: 30,
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
