import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class TermsConditionScreen extends StatelessWidget {
  const TermsConditionScreen({super.key});

  static const List<String> _paragraphs = [
    'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.',
    'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.',
    'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.',
    'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.',
    'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,

        title: Text(
          'profile.termsConditions'.tr,
          style: const TextStyle(
            color: Color(0xFF111111),
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
        itemCount: _paragraphs.length,
        separatorBuilder: (context, index) => const SizedBox(height: 28),
        itemBuilder: (context, index) {
          return Text(
            _paragraphs[index],
            style: const TextStyle(
              color: Color(0xFF222222),
              height: 1.45,
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          );
        },
      ),
    );
  }
}
