import 'package:backend_services_repository/backend_service_repositoy.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/auth_bloc/auth_bloc.dart';
import 'package:next_gen_ai_healthcare/blocs/theme_bloc/theme_bloc.dart';
import 'package:next_gen_ai_healthcare/firebase_options.dart';
import 'package:next_gen_ai_healthcare/pages/auth/splash_page.dart';
import 'package:next_gen_ai_healthcare/simple_bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ChatsAdapter());
  Hive.registerAdapter(AiRequestModelAdapter());
  Hive.registerAdapter(UserAdapter());
  await Hive.openBox<Chats>('chats');
  await Hive.openBox<User>('user');
  await Hive.openBox('settings');
  Bloc.observer = SimpleBlocObserver();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyApp(
    authentication: AuthenticationImp(),
  ));
}

class MyApp extends StatelessWidget {
  final AuthenticationImp authentication;
  const MyApp({super.key, required this.authentication});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => authentication,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) =>
                AuthBloc(authentication: context.read<AuthenticationImp>()),
          ),
          BlocProvider<ThemeBloc>(
            create: (context) => ThemeBloc(LocalThemeData()),
          ),
        ],
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, themeState) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: themeState.theme,
              home: const SplashPage(),
            );
          },
        ),
      ),
    );
  }
}


/* TODO:
### **Must-Have Features:**  
1. **Item Details Page** – Show item details like name, description, rental price, and availability.  
2. **Search & Filters** – Allow users to search and filter items based on category, availability, or location.  
3. **Borrowing Process Enhancement** – Instead of just marking an item as borrowed, consider:  
   - Request & approval system (so the lender approves before it's marked as borrowed).  
   - Setting rental duration.  
4. **Chat or Messaging System** – So borrowers and lenders can discuss terms.  
5. **Notifications** – Send push notifications when an item request is made, accepted, or due.  
6. **User Profile & History** – Show users their borrowed/lent items, rental history, and profile info.  
7. **Reviews & Ratings** – Let borrowers rate lenders and vice versa for trust-building.  
8. **Payment Integration (Optional)** – If rentals involve payments, integrate a system like Stripe or PayPal.  
9. **Item Return & Completion Flow** – A way for the borrower to confirm the return and the lender to mark it as completed.  

Do any of these sound like something you’d want to add next? 🚀*/