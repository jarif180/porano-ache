import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/views/login_page.dart';
import '../../features/dashboard/presentation/views/tutor_dashboard_page.dart';
import '../../features/dashboard/presentation/views/student_dashboard_page.dart';
import '../../features/students/presentation/views/student_list_page.dart';
import '../../features/students/presentation/views/add_edit_student_page.dart';
import '../../features/students/presentation/views/student_detail_page.dart';
import '../../features/schedule/presentation/views/schedule_page.dart';
import '../../features/schedule/presentation/views/add_edit_schedule_page.dart';
import '../../features/student_portal/presentation/views/my_schedule_page.dart';
import '../../features/attendance/presentation/views/attendance_page.dart';
import '../../features/student_portal/presentation/views/my_attendance_page.dart';
import '../../features/payments/presentation/views/payment_list_page.dart';
import '../../features/payments/presentation/views/record_payment_page.dart';
import '../../features/student_portal/presentation/views/my_payments_page.dart';
import '../../features/makeup_classes/presentation/views/makeup_class_list_page.dart';
import '../../features/makeup_classes/presentation/views/add_makeup_class_page.dart';
import '../../features/student_portal/presentation/views/my_makeup_classes_page.dart';
import '../../features/progress/presentation/views/progress_list_page.dart';
import '../../features/progress/presentation/views/add_progress_note_page.dart';
import '../../features/student_portal/presentation/views/my_progress_page.dart';
import '../../features/settings/presentation/views/settings_page.dart';

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
      GoRoute(
        path: '/schedule',
        name: 'schedule',
        builder: (context, state) => const SchedulePage(),
      ),
      GoRoute(
        path: '/schedule/add',
        name: 'add-schedule',
        builder: (context, state) {
          final dayStr = state.uri.queryParameters['day'];
          final day = dayStr != null ? int.tryParse(dayStr) : null;
          return AddEditSchedulePage(initialDay: day);
        },
      ),
      GoRoute(
        path: '/my-schedule',
        name: 'my-schedule',
        builder: (context, state) => const MySchedulePage(),
      ),
      GoRoute(
        path: '/attendance',
        name: 'attendance',
        builder: (context, state) => const AttendancePage(),
      ),
      GoRoute(
        path: '/my-attendance',
        name: 'my-attendance',
        builder: (context, state) => const MyAttendancePage(),
      ),
      GoRoute(
        path: '/payments',
        name: 'payments',
        builder: (context, state) => const PaymentListPage(),
      ),
      GoRoute(
        path: '/payments/record',
        name: 'record-payment',
        builder: (context, state) => const RecordPaymentPage(),
      ),
      GoRoute(
        path: '/my-payments',
        name: 'my-payments',
        builder: (context, state) => const MyPaymentsPage(),
      ),
      GoRoute(
        path: '/makeup-classes',
        name: 'makeup-classes',
        builder: (context, state) => const MakeupClassListPage(),
      ),
      GoRoute(
        path: '/makeup-classes/add',
        name: 'add-makeup-class',
        builder: (context, state) => const AddMakeupClassPage(),
      ),
      GoRoute(
        path: '/my-makeup-classes',
        name: 'my-makeup-classes',
        builder: (context, state) => const MyMakeupClassesPage(),
      ),
      GoRoute(
        path: '/progress',
        name: 'progress',
        builder: (context, state) => const ProgressListPage(),
      ),
      GoRoute(
        path: '/progress/add',
        name: 'add-progress-note',
        builder: (context, state) => const AddProgressNotePage(),
      ),
      GoRoute(
        path: '/my-progress',
        name: 'my-progress',
        builder: (context, state) => const MyProgressPage(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),
    ],
  );
}
