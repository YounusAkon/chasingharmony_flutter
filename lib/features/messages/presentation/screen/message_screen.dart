import 'package:flutter/material.dart';

class CelysChatScreen extends StatelessWidget {
  const CelysChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      // backgroundColor: Colors.transparent,
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent, // Transparent appbar
      //   elevation: 0,
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
      //     onPressed: () {},
      //   ),
      //   title: const Text(
      //     'CELYS AI',
      //     style: TextStyle(
      //       fontWeight: FontWeight.bold,
      //       fontSize: 18,
      //     ),
      //   ),
      //   centerTitle: true,
      //   actions: [
      //     Padding(
      //       padding: const EdgeInsets.only(right: 16.0),
      //       child: Container(
      //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      //         decoration: BoxDecoration(
      //           color: const Color(0xFF6B4EFF),
      //           borderRadius: BorderRadius.circular(30),
      //         ),
      //         child: const Text(
      //           'Get CELYS +',
      //           style: TextStyle(
      //             fontWeight: FontWeight.w600,
      //             fontSize: 14,
      //           ),
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/image/Profile.png'), // Change path if needed
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              // AI Welcome Bubble
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "Hi! I’m CELYS AI. How can I help you today?\nPlease select a Mode type below or type your situation.",
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
        
              // User Message Bubble
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0, left: 80.0, bottom: 16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6B4EFF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Simplify how meditation works",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
        
              const Spacer(),
        
              // Input Field
              Container(
                margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1F1B33).withOpacity(0.95), // Slight transparency
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'Type a message...',
                          hintStyle: TextStyle(color: Colors.white54),
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFF6B4EFF),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}