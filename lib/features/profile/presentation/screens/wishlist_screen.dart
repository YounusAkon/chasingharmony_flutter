import 'package:chasingharmony_fluttere/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.authBackground,
      appBar: AppBar(
        backgroundColor: AppColors.authBackground,
        elevation: 0,
        foregroundColor: AppColors.authHeading,
        centerTitle: true,
        title: const Text(
          'Wishlist',
          style: TextStyle(
            color: AppColors.authHeading,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE5E5E5)),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 6,
              ),
              leading: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0F0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.favorite_border_rounded,
                  color: AppColors.authPrimaryRed,
                ),
              ),
              title: const Text(
                'Emergency Medical Kit',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.authHeading,
                ),
              ),
              subtitle: const Text(
                'Added to your wishlist',
                style: TextStyle(fontSize: 13, color: AppColors.authSubtitle),
              ),
              trailing: const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF8E8E8E),
              ),
              onTap: () {},
            ),
          );
        },
        separatorBuilder: (_, index) => const SizedBox(height: 10),
        itemCount: 5,
      ),
    );
  }
}
