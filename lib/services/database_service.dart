import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/user.dart';
import '../models/expense.dart';

class DatabaseService {
  static const String _userBoxName = 'users';
  static const String _expenseBoxName = 'expenses';
  static const String _authBoxName = 'auth';
  
  static Future<void> initialize() async {
    await Hive.initFlutter();
    
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(ExpenseAdapter());
    
    await Hive.openBox<User>(_userBoxName);
    await Hive.openBox<Expense>(_expenseBoxName);
    await Hive.openBox(_authBoxName);
  }

  // User Methods
  Future<User?> createUser(String email, String username, String password) async {
    final userBox = Hive.box<User>(_userBoxName);
    
    // Check if email already exists
    if (userBox.values.any((user) => user.email == email)) {
      throw Exception('Email already exists');
    }

    final user = User(
      id: const Uuid().v4(),
      email: email,
      username: username,
      passwordHash: password, // In production, hash the password
    );

    await userBox.put(user.id, user);
    return user;
  }

  Future<User?> login(String email, String password) async {
    final userBox = Hive.box<User>(_userBoxName);
    final user = userBox.values.firstWhere(
      (user) => user.email == email && user.passwordHash == password,
      orElse: () => throw Exception('Invalid credentials'),
    );
    
    if (user != null) {
      final authBox = Hive.box(_authBoxName);
      await authBox.put('currentUserId', user.id);
    }
    
    return user;
  }

  Future<void> logout() async {
    final authBox = Hive.box(_authBoxName);
    await authBox.delete('currentUserId');
  }

  User? getCurrentUser() {
    final authBox = Hive.box(_authBoxName);
    final userId = authBox.get('currentUserId');
    if (userId == null) return null;

    final userBox = Hive.box<User>(_userBoxName);
    return userBox.get(userId);
  }

  // Expense Methods
  Future<List<Expense>> getExpenses(String userId) async {
    final expenseBox = Hive.box<Expense>(_expenseBoxName);
    return expenseBox.values.where((expense) => expense.userId == userId).toList();
  }

  Future<Expense> addExpense(
    String name,
    double amount,
    String category,
    DateTime date,
    String userId, {
    String? invoiceUrl,
  }) async {
    final expenseBox = Hive.box<Expense>(_expenseBoxName);
    
    final expense = Expense(
      id: const Uuid().v4(),
      name: name,
      amount: amount,
      date: date,
      invoiceUrl: invoiceUrl,
      userId: userId,
      category: category,
    );

    await expenseBox.put(expense.id, expense);
    return expense;
  }

  Future<void> deleteExpense(String id) async {
    final expenseBox = Hive.box<Expense>(_expenseBoxName);
    await expenseBox.delete(id);
  }
} 