import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:go_router/go_router.dart';
import 'package:phraso/features/languages/pages/language_page.dart';
import 'package:phraso/features/languages/pages/language_search_page.dart';
import 'package:phraso/features/phrases/pages/phrase_search_page.dart';
import 'package:phraso/features/planner/pages/add_activities_page.dart';
import 'package:phraso/features/planner/pages/create_plan.dart';
import 'package:phraso/features/planner/pages/planned_days_page.dart';
import 'package:phraso/features/planner/pages/planner_page.dart';
import 'package:phraso/features/root/pages/root_page.dart';
import 'package:phraso/features/types_of_phrases/pages/top_page.dart';
import 'package:phraso/models/itinerary_model.dart';
import 'package:phraso/models/language_model.dart';
import 'package:phraso/models/top_model.dart';
import 'package:phraso/router/state_notifier.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../features/auth/pages/login_page.dart';
import '../features/auth/pages/register_page.dart';
import '../features/auth/repository/auth_repository.dart';

enum AppRoutes {
  root,
  login,
  register,
  languages,
  types_of_phrases,
  phrases,
  planner,
  trip,
  addTrip,
  languageSearch,
  phraseSearch,
  itinerary,
  edit_activities,
}

final routerProvider = riverpod.Provider<GoRouter>((ref) {
  final AuthRepository authRepository = ref.watch(authRepositoryProvider);
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
          path: "/login",
          name: AppRoutes.login.name,
          builder: (context, state) => const LoginPage(),
          routes: [
            GoRoute(
              path: "register",
              name: AppRoutes.register.name,
              builder: (context, state) => const RegisterPage(),
            ),
          ]),
      GoRoute(
        path: '/',
        name: AppRoutes.root.name,
        builder: (context, state) => const RootPage(),
      ),
      GoRoute(
          path: '/languages',
          name: AppRoutes.languages.name,
          builder: (context, state) => const Languagepage(),
          routes: [
            GoRoute(
                path: 'types_of_phrases/:languageName',
                name: AppRoutes.types_of_phrases.name,
                builder: (context, state) {
                  final LanguageModel languageModel =
                      state.extra as LanguageModel;
                  final String languageName =
                      state.pathParameters['languageName']!;

                  return TypesOfPhrases(
                    language: languageModel,
                    languageName: languageName,
                  );
                },
                routes: [
                  GoRoute(
                    path: 'search/:langId',
                    name: AppRoutes.phraseSearch.name,
                    builder: (context, state) {
                      final String langId = state.pathParameters['langId']!;
                      return PhraseSearchPage(langId: langId);
                    },
                  )
                ]),
            GoRoute(
              path: 'search',
              name: AppRoutes.languageSearch.name,
              pageBuilder: (context, state) => MaterialPage(
                key: state.pageKey,
                fullscreenDialog: true,
                child: const LanguageSearchPage(),
              ),
            )
          ]),
      GoRoute(
          path: '/planner',
          name: AppRoutes.planner.name,
          builder: (context, state) => const Plannerpage(),
          routes: [
            GoRoute(
              path: 'addTrip',
              name: AppRoutes.addTrip.name,
              builder: (context, state) {
                return const CreateTrip();
              },
            ),
            GoRoute(
                path: ':itineraryId',
                name: AppRoutes.itinerary.name,
                builder: (context, state) {
                  state.pathParameters['itineraryId']!;

                  return PlannedDaysPage(
                      itineraryModel: state.extra as ItineraryModel);
                },
                routes: [
                  GoRoute(
                    path: ':day_id',
                    name: AppRoutes.edit_activities.name,
                    builder: (context, state) {
                      final String? day_id = state.pathParameters['day_id']!;

                      final String? tripId =
                          state.pathParameters['itineraryId']!;

                      final DateTime dayDate = state.extra as DateTime;

                      return AddActivitiesPage(
                          tripId: tripId!, day_id: day_id!, dayDate: dayDate);
                    },
                  )
                ])
          ])
    ],
    redirect: (context, state) async {
      final User? session = Supabase.instance.client.auth.currentUser;
      final isAuth = session != null;

      final isHome = state.fullPath == '/';

      if (isHome) {
        return isAuth ? '/' : '/login';
      }

      final isLoggingIn = state.fullPath == '/login';
      final isRegister = state.fullPath == '/login/register';

      if (isLoggingIn) return isAuth ? '/' : null;

      if (isRegister) {
        if (isAuth) {
          return '/';
        } else {
          return null;
        }
      }

      return isAuth ? null : '/';
    },
    refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges),
  );
});
