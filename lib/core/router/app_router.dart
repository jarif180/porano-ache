import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/views/login_page.dart';
import '../../features/dashboard/presentation/views/tutor_dashboard_page.dart';
import '../../features/dashboard/presentation/views/student_dashboard_page.dart';
import '../../features/students/presentation/views/student_list_page.dart';
import '../../features/students/presentation/views/add_edit_student_page.dart';
import '../../features/students/presentation/views/student_detail_page.dart';

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
      GoRoute(
        path: '/students',
        name: 'students',
        builder: (context, state) => const StudentListPage(),
      ),
      GoRoute(
        path: '/students/add',
        name: 'add-student',
        builder: (context, state) => const AddEditStudentPage(),
      ),
      GoRoute(
        path: '/students/edit/:id',
        name: 'edit-student',
        builder: (context, state) {
          final id = state.pathParameters['id'];
          return AddEditStudentPage(studentId: id);
        },
      ),
      GoRoute(
        path: '/students/detail/:id',
        name: 'student-detail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return StudentDetailPage(studentId: id);
        },
      ),
    ],
  );
}
