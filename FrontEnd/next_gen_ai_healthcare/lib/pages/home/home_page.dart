import 'package:backend_services_repository/backend_service_repositoy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/chat_bloc/chat_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/item_bloc/item_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/create_item_bloc/create_item_bloc.dart';
import 'package:next_gen_ai_healthcare/pages/ai_diagnosis_pages/ai_diagnosis_page.dart';
import 'package:next_gen_ai_healthcare/pages/chat_pages/ai_chatbot.dart';
import 'package:next_gen_ai_healthcare/pages/item_pages/item_page.dart';
import 'package:next_gen_ai_healthcare/pages/item_pages/add_item.dart';
import 'package:next_gen_ai_healthcare/widgets/app_drawer.dart';
import 'package:next_gen_ai_healthcare/widgets/custom_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("HomePage")),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFeatureSection(
                context,
                title: "AI-Powered Diagnosis",
                description: "Get quick AI-based health insights.",
                icon: Icons.medical_information_sharp,
                imagePath: 'assets/images/ai_diagnosis.png',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AiDiagnosisPage(),
                  ),
                ),
              ),
              _buildFeatureSection(
                context,
                title: "Chat with AI",
                description: "Get more insights and information from AI",
                icon: Icons.medical_information_sharp,
                imagePath: 'assets/images/ai_diagnosis.png',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) =>
                          ChatBloc(ChatRequestImp(), ChatRepositoryImp()),
                      child: const AiChatBot(),
                    ),
                  ),
                ),
              ),
              _buildFeatureSection(
                context,
                title: "Rent Medical Instruments",
                description: "Easily rent quality medical tools.",
                icon: Icons.receipt_long_outlined,
                imagePath: 'assets/images/rent_instruments.png',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) =>
                          ItemBloc(retrieveData: RetrieveDataImp()),
                      child: const ItemPage(),
                    ),
                  ),
                ),
              ),
              _buildFeatureSection(
                context,
                title: "Add Medical Instruments",
                description: "List instruments for rent.",
                icon: Icons.add_box_sharp,
                imagePath: 'assets/images/add_instruments.png',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) =>
                          CreateItemBloc(storeData: StoreDataImp()),
                      child: const AddItem(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureSection(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            description,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 5),
          CustomCard(
            title: title,
            icon: icon,
            imagePath: imagePath,
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}
