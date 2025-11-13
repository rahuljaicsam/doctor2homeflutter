import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doctor2home_app/providers/auth_provider.dart';
import 'package:doctor2home_app/providers/location_provider.dart';
import 'package:doctor2home_app/providers/booking_provider.dart';
import 'package:doctor2home_app/screens/splash_screen.dart';
import 'package:doctor2home_app/screens/auth/login_screen.dart';
import 'package:doctor2home_app/screens/auth/register_screen.dart';
import 'package:doctor2home_app/screens/home/home_screen.dart';
import 'package:doctor2home_app/screens/doctor/doctor_list_screen.dart';
import 'package:doctor2home_app/screens/booking/booking_screen.dart';
import 'package:doctor2home_app/screens/profile/profile_screen.dart';
import 'package:doctor2home_app/screens/map_screen.dart';
import 'package:doctor2home_app/screens/active_bookings_screen.dart';
import 'package:doctor2home_app/screens/booking_history_screen.dart';
import 'package:doctor2home_app/utils/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => LocationProvider()),
        ChangeNotifierProvider(create: (context) => BookingProvider()),
      ],
      child: MaterialApp(
        title: 'Doctor2Home',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.home, // Start with home screen for demo
        routes: {
          AppRoutes.splash: (context) => const SplashScreen(),
          AppRoutes.login: (context) => const LoginScreen(),
          AppRoutes.register: (context) => const RegisterScreen(),
          AppRoutes.home: (context) => const HomeScreen(),
          AppRoutes.doctorList: (context) => const DoctorListScreen(),
          AppRoutes.booking: (context) => const BookingScreen(),
          AppRoutes.activeBookings: (context) => const ActiveBookingsScreen(),
          AppRoutes.bookingHistory: (context) => const BookingHistoryScreen(),
          AppRoutes.profile: (context) => const ProfileScreen(),
          AppRoutes.map: (context) => const MapScreen(),
        },
      ),
    );
  }
}
