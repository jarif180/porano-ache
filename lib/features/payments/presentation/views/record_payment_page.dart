import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/enums/payment_status.dart';
import '../../../students/domain/entities/student_entity.dart';
import '../../../students/presentation/controllers/student_notifier.dart';
import '../controllers/payment_notifier.dart';

class RecordPaymentPage extends ConsumerStatefulWidget {
  const RecordPaymentPage({super.key});

  @override
  ConsumerState<RecordPaymentPage> createState() => _RecordPaymentPageState();
}

class _RecordPaymentPageState extends ConsumerState<RecordPaymentPage> {
  final _formKey = GlobalKey<FormState>();

  StudentEntity? _selectedStudent;
  late TextEditingController _amountController;
  late TextEditingController _notesController;
  PaymentMethod _selectedMethod = PaymentMethod.cash;
  String _selectedMonth = 'নভেম্বর ২০২৬';
  final DateTime _paidDate = DateTime.now();

  final List<String> _months = [
    'নভেম্বর ২০২৬',
    'অক্টোবর ২০২৬',
    'সেপ্টেম্বর ২০২৬',
    'আগস্ট ২০২৬',
    'ডিসেম্বর ২০২৬',
  ];

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _savePayment() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedStudent == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('অনুগ্রহ করে একজন শিক্ষার্থী নির্বাচন করুন')),
        );
        return;
      }

      final amount = double.tryParse(_amountController.text.trim()) ?? 0.0;

      ref.read(paymentNotifierProvider.notifier).recordPayment(
        studentId: _selectedStudent!.id,
        studentName: _selectedStudent!.fullName,
        studentNameBn: _selectedStudent!.fullNameBn,
        amount: amount,
        method: _selectedMethod,
        paidDate: _paidDate,
        month: _selectedMonth,
        notes: _notesController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('পেমেন্ট সফলভাবে রেকর্ড করা হয়েছে!')),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isBn = Localizations.localeOf(context).languageCode == 'bn';
    final studentState = ref.watch(studentListNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(isBn ? 'পেমেন্ট রেকর্ড করুন' : 'Record Payment'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Student Picker
                Text(
                  isBn ? 'শিক্ষার্থী নির্বাচন' : 'Select Student',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryDark),
                ),
                const SizedBox(height: 10),

                studentState.when(
                  loading: () => const LinearProgressIndicator(),
                  error: (e, _) => Text(e.toString()),
                  data: (students) {
                    final activeStudents = students.where((s) => s.isActive).toList();
                    return DropdownButtonFormField<StudentEntity>(
                      value: _selectedStudent,
                      decoration: InputDecoration(
                        labelText: isBn ? 'শিক্ষার্থী' : 'Student',
                        prefixIcon: const Icon(Icons.person_outline),
                      ),
                      items: activeStudents.map((std) {
                        return DropdownMenuItem(
                          value: std,
                          child: Text('${isBn ? std.fullNameBn : std.fullName} (${std.gradeLevel})'),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedStudent = val;
                          if (val != null) {
                            _amountController.text = val.monthlyFee.toStringAsFixed(0);
                          }
                        });
                      },
                      validator: (val) => val == null ? 'শিক্ষার্থী নির্বাচন করুন' : null,
                    );
                  },
                ),
                const SizedBox(height: 16),

                // Amount
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: isBn ? 'পরিশোধিত টাকার পরিমাণ' : 'Amount Paid',
                    prefixIcon: const Icon(Icons.attach_money_outlined),
                    suffixText: '৳',
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'টাকার পরিমাণ দিন';
                    if (double.tryParse(val) == null) return 'সঠিক সংখ্যা দিন';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Month Picker
                DropdownButtonFormField<String>(
                  value: _selectedMonth,
                  decoration: InputDecoration(
                    labelText: isBn ? 'কোন মাসের বেতন' : 'Tuition Month',
                    prefixIcon: const Icon(Icons.calendar_month_outlined),
                  ),
                  items: _months.map((m) {
                    return DropdownMenuItem(value: m, child: Text(m));
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedMonth = val);
                  },
                ),
                const SizedBox(height: 20),

                // Payment Method Selector
                Text(
                  isBn ? 'পেমেন্ট মাধ্যম' : 'Payment Method',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryDark),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: PaymentMethod.values.map((method) {
                    final isSelected = _selectedMethod == method;
                    return ChoiceChip(
                      label: Text(isBn ? method.displayNameBn : method.displayNameEn),
                      selected: isSelected,
                      selectedColor: AppColors.primary,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      onSelected: (selected) {
                        if (selected) setState(() => _selectedMethod = method);
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // Notes
                TextFormField(
                  controller: _notesController,
                  decoration: InputDecoration(
                    labelText: isBn ? 'মন্তব্য (ঐচ্ছিক)' : 'Notes (Optional)',
                    prefixIcon: const Icon(Icons.note_alt_outlined),
                  ),
                ),
                const SizedBox(height: 30),

                ElevatedButton(
                  onPressed: _savePayment,
                  style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                  child: Text(
                    isBn ? 'পেমেন্ট সংরক্ষণ করুন' : 'Save Payment',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
