import 'package:flutter/material.dart';
import 'package:r10_quiz/config/colors.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const AppHeader({Key? key, this.title = 'R10 Quiz Wheel'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      elevation: 2,
      backgroundColor: AppColors.header,
      actions: [IconButton(icon: const Icon(Icons.circle),
      onPressed: (){
        Navigator.pushNamed(context, '/settings');
      },
        )
      ],
    );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

