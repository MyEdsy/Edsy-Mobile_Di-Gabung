import 'package:flutter/material.dart';
import 'package:school_apps/screens/features/guru/sub_menu_quiz/quiz/component/form_input_quiz.dart';

import '../../../../../../size_config.dart';

class BodyInputQuiz extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      children: [
        SizedBox(height: SizeConfig.screenHeight * 0.01), // 4%
        FormInputQuiz(),
        SizedBox(height: SizeConfig.screenHeight * 0.08),
        SizedBox(height: getProportionateScreenHeight(20)),
      ],
    );
  }
}