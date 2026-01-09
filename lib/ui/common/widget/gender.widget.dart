import 'package:flutter/material.dart';

enum Gender {
  male,
  female,
  genderless,
  unknown;

  static Gender fromString(String gender) {
    switch (gender.toLowerCase()) {
      case 'male':
        return Gender.male;
      case 'female':
        return Gender.female;
      case 'genderless':
        return Gender.genderless;
      default:
        return Gender.unknown;
    }
  }
}

class GenderWidget extends StatelessWidget {
  final Gender gender;
  final double? width;
  final double? height;

  const GenderWidget({
    Key? key,
    required this.gender,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 36,
      height: height ?? 36,
      decoration: BoxDecoration(
        color: _getColor(gender).withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        _getIcon(gender),
        color: _getColor(gender),
        size: (width ?? 36) * 0.6,
      ),
    );
  }

  Color _getColor(Gender gender) {
    switch (gender) {
      case Gender.male:
        return Colors.blue;
      case Gender.female:
        return Colors.pink;
      case Gender.genderless:
        return Colors.purple;
      case Gender.unknown:
        return Colors.grey;
    }
  }

  IconData _getIcon(Gender gender) {
    switch (gender) {
      case Gender.male:
        return Icons.male;
      case Gender.female:
        return Icons.female;
      case Gender.genderless:
        return Icons.transgender;
      case Gender.unknown:
        return Icons.question_mark;
    }
  }
}
