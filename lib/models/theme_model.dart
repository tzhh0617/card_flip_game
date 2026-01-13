import 'package:flutter/material.dart';

class GameTheme {
  final String id;
  final String name;
  final String nameEn;
  final Color color;
  final List<String> characters;
  final int levelCount;

  const GameTheme({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.color,
    required this.characters,
    this.levelCount = 10,
  });

  int get startLevelIndex => _getStartIndex();

  int _getStartIndex() {
    final themes = GameThemes.all;
    int index = 0;
    for (final theme in themes) {
      if (theme.id == id) return index;
      index += theme.levelCount;
    }
    return 0;
  }
}

class GameThemes {
  static const List<GameTheme> all = [
    GameTheme(
      id: 'paw_patrol',
      name: '汪汪队立大功',
      nameEn: 'PAW Patrol',
      color: Color(0xFF2196F3),
      characters: ['阿奇', '毛毛', '小力', '灰灰', '路马', '天天', '莱德', '珠珠'],
    ),
    GameTheme(
      id: 'peppa_pig',
      name: '小猪佩奇',
      nameEn: 'Peppa Pig',
      color: Color(0xFFE91E63),
      characters: ['佩奇', '乔治', '猪妈妈', '猪爸爸', '苏西羊', '丹尼狗', '瑞贝卡', '佩德罗'],
    ),
    GameTheme(
      id: 'bluey',
      name: 'Bluey',
      nameEn: 'Bluey',
      color: Color(0xFF00BCD4),
      characters: ['Bluey', 'Bingo', 'Bandit', 'Chilli', 'Muffin', 'Socks', 'Stripe', 'Trixie'],
    ),
    GameTheme(
      id: 'super_wings',
      name: '超级飞侠',
      nameEn: 'Super Wings',
      color: Color(0xFFFF5722),
      characters: ['乐迪', '多多', '小爱', '酷飞', '包警长', '小青', '胡须爷爷', '金刚'],
    ),
    GameTheme(
      id: 'thomas',
      name: '托马斯小火车',
      nameEn: 'Thomas & Friends',
      color: Color(0xFF4CAF50),
      characters: ['托马斯', '培西', '詹姆士', '高登', '艾米莉', '亨利', '爱德华', '托比'],
    ),
    GameTheme(
      id: 'boonie_bears',
      name: '熊出没',
      nameEn: 'Boonie Bears',
      color: Color(0xFF9C27B0),
      characters: ['熊大', '熊二', '光头强', '吉吉', '毛毛', '蹦蹦', '涂涂', '萝卜头'],
    ),
    GameTheme(
      id: 'robocar_poli',
      name: '变形警车珀利',
      nameEn: 'Robocar Poli',
      color: Color(0xFFFF9800),
      characters: ['珀利', '安巴', '罗伊', '海利', '凯文', '小金', '斯普奇', '波塞冬'],
    ),
    GameTheme(
      id: 'my_little_pony',
      name: '小马宝莉',
      nameEn: 'My Little Pony',
      color: Color(0xFF673AB7),
      characters: ['紫悦', '苹果嘉儿', '珍奇', '柔柔', '云宝', '碧琪', '暮光闪闪', '星光熠熠'],
    ),
    GameTheme(
      id: 'pleasant_goat',
      name: '喜羊羊与灰太狼',
      nameEn: 'Pleasant Goat',
      color: Color(0xFFCDDC39),
      characters: ['喜羊羊', '美羊羊', '懒羊羊', '沸羊羊', '暖羊羊', '灰太狼', '红太狼', '小灰灰'],
    ),
    GameTheme(
      id: 'meng_ji',
      name: '萌鸡小队',
      nameEn: 'Meng Ji',
      color: Color(0xFF009688),
      characters: ['大宇', '朵朵', '欢欢', '麦奇', '美佳妈妈', '刺猬', '松鼠', '蜗牛'],
    ),
  ];

  static GameTheme getById(String id) {
    return all.firstWhere((t) => t.id == id, orElse: () => all.first);
  }

  static GameTheme getByLevelIndex(int levelIndex) {
    int count = 0;
    for (final theme in all) {
      if (levelIndex < count + theme.levelCount) {
        return theme;
      }
      count += theme.levelCount;
    }
    return all.last;
  }
}
