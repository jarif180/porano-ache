import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/views/login_page.dart';
import '../../features/dashboard/presentation/views/tutor_dashboard_page.dart';
import '../../features/dashboard/presentation/views/student_dashboard_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/tutor-dashboard',
        name: 'tutor-dashboard',
        builder: (context, state) => const TutorDashboardPage(),
      ),
      GoRoute(
        path: '/student-dashboard',
        name: 'student-dashboard',
        builder: (context, state) => const StudentDashboardPage(),
      ),
    ],
  );
}
