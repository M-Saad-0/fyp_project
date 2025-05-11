import 'package:backend_services_repository/backend_service_repositoy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/chat_bloc/chat_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/hero_bloc/hero_bloc_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/item_bloc/item_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/create_item_bloc/create_item_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/review_bloc/review_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/symptoms_bloc/symptoms_bloc.dart';
import 'package:next_gen_ai_healthcare/pages/ai_diagnosis_pages/ai_diagnosis_page.dart';
import 'package:next_gen_ai_healthcare/pages/chat_pages/ai_chatbot.dart';
import 'package:next_gen_ai_healthcare/pages/item_pages/item_detail_page.dart';
import 'package:next_gen_ai_healthcare/pages/item_pages/item_page.dart';
import 'package:next_gen_ai_healthcare/pages/item_pages/add_item.dart';
import 'package:next_gen_ai_healthcare/widgets/ai_prognosis.dart';
import 'package:next_gen_ai_healthcare/widgets/app_drawer.dart';
import 'package:next_gen_ai_healthcare/widgets/custom_card.dart';

class HomePage extends StatefulWidget {
  final User user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController pageController;
  double currentPage = 0;
  @override
  void initState() {
    pageController = PageController();
    context.read<HeroBlocBloc>().add(MoreHeroItemsRequired(
        setNo: 5,
        location: widget.user.location ??
            {
              'coordinates': [0, 0]
            }));
    pageController.addListener(() {
      if (pageController.hasClients) {
        currentPage = pageController.page!;
      }
      setState(() {});
    });
    super.initState();
  }

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
              BlocBuilder<HeroBlocBloc, HeroBlocState>(
                builder: (context, state) {
                  switch (state) {
                    case HeroLoadingState():
                      return const Center(child: CircularProgressIndicator());
                    case HeroErrorState():
                      return const Center(child: Text("Error loading items"));
                    case HeroSuccessState():
                      final items = state.items;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Discover nearby items tailored to your needs",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 250,
                            width: MediaQuery.of(context).size.width,
                            child: PageView.builder(
                              onPageChanged: (index) {
                                setState(() {
                                  currentPage = index.toDouble();
                                });
                              },
                              controller: pageController,
                              itemCount: items.length,
                              itemBuilder: (context, index) {
                                final item = items[index];
                                return Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Stack(
                                      children: [
                                        SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.network(item.images[0],
                                                fit: BoxFit.fitWidth),
                                          ),
                                        ),
                                        Positioned(
                                          right: -5,
                                          bottom: 40,
                                          child: Container(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              item.itemName,
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: -10,
                                          bottom: 10,
                                          child: TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          BlocProvider<
                                                              ReviewBloc>(
                                                            create: (context) => ReviewBloc(
                                                                reviewOps:
                                                                    ReviewOps())
                                                              ..add(FetchReviewEvent(
                                                                  itemId: state
                                                                      .items[
                                                                          index]
                                                                      .itemId)),
                                                            child: ItemDetailPage(
                                                                item:
                                                                    state.items[
                                                                        index]),
                                                          )));
                                            },
                                            child: const Text("View Details"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ...List.generate(state.items.length, (index) {
                                  return IconButton(
                                    icon: Icon(
                                      Icons.coronavirus,
                                      size: index == (currentPage.round())
                                          ? 12
                                          : 10,
                                      color: index == (currentPage.round())
                                          ? Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                          : Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withOpacity(0.4),
                                    ),
                                    onPressed: () {
                                      pageController.jumpToPage(index);
                                    },
                                  );
                                })
                              ],
                            ),
                          )
                        ],
                      );
                    default:
                      return const Center(child: Text("No items available"));
                  }
                },
              ),
              _buildFeatureSection(
                context,
                title: "AI-Powered Diagnosis",
                description: "Get quick AI-based health insights.",
                icon: Icons.medical_information_sharp,
                imagePath: 'assets/images/ai_diagnosis.png',
                onTap: () {
                  AiPrognosis().predictDisease([
                    'itching',
                    'skin_rash',
                    'nodal_skin_eruptions',
                    'continuous_sneezing',
                    'shivering',
                    'chills',
                    'joint_pain',
                    'stomach_pain',
                    'acidity',
                    'ulcers_on_tongue',
                  ]);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => SymptomsBloc(aiPrognosis: AiPrognosis()),
                        child: const AiDiagnosisPage(),
                      ),
                    ),
                  );
                },
              ),
              _buildFeatureSection(
                context,
                title: "Chat with AI",
                description: "Get more insights and information from AI",
                icon: Icons.medical_information_sharp,
                imagePath: 'assets/images/ai_chat.png',
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
