import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../feature/auth/auth_gate.dart';
import '../../feature/auth/presentation/cubit/auth_cubit.dart';
import '../../feature/auth/presentation/view/login_view.dart';
import '../../feature/collection/presentation/cubit/collection_cubit.dart';
import '../../feature/collection/presentation/view/collection_view.dart';
import '../../feature/location/data/repo/location_repo.dart';
import '../../feature/location/manager/location_cubit.dart';
import '../../feature/location/ui/screen/location_screen.dart';
import '../../feature/search/data/cubits/search_cubit.dart';
import '../../feature/search/ui/view/search_page.dart';
import '../../feature/settings/view/profile_view.dart';
import '../service/service_locator.dart';
import 'constant.dart';
import 'custom_page_route.dart';

class AppRoutes {
  static Route generateRoute(RouteSettings settings) {
    return switch (settings.name) {
      RoutePath.authGate => CustomPageRoute(
        child: const AuthGate(),
      ),

    // LoginView owns AuthCubit for the full OTP flow.
      RoutePath.login => CustomPageRoute(
        child: BlocProvider<AuthCubit>(
          create: (_) => getIt<AuthCubit>(),
          child: const LoginView(),
        ),
      ),

    // CollectionCubit is now fully injected via getIt.
      RoutePath.collection => CustomPageRoute(
        child: BlocProvider<CollectionCubit>(
          create: (_) => getIt<CollectionCubit>(),
          child: const CollectionView(),
        ),
      ),

      RoutePath.searchpage => CustomPageRoute(
        child: BlocProvider<SearchCubit>(
          create: (_) => SearchCubit(),
          child: const SearchPage(),
        ),
      ),

      RoutePath.profile => CustomPageRoute(
        child: const ProfileView(),
      ),

      RoutePath.locationScreen => CustomPageRoute(
        child: BlocProvider<LocationCubit>(
          create: (_) => LocationCubit(getIt<LocationRepo>())..init(),
          child: LocationScreen(),
        ),
      ),

      _ => MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: Center(child: Text('No route defined for this path')),
        ),
      ),
    };
  }
}