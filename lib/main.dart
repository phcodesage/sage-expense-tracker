import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sage_expense_tracker/screens/wallet_screen.dart';
import 'package:sage_expense_tracker/models/expense.dart';
import 'package:sage_expense_tracker/screens/profile_screen.dart';
import 'package:sage_expense_tracker/screens/onboarding_screen.dart';
import 'package:sage_expense_tracker/screens/splash_screen.dart';
import 'package:sage_expense_tracker/widgets/circle_reveal_clipper.dart';
import 'package:sage_expense_tracker/widgets/searchable_currency_dropdown.dart';

enum Currency {
  AED('AED', 'د.إ'),
  AUD('AUD', 'A\$'),
  BGN('BGN', 'лв'),
  BRL('BRL', 'R\$'),
  CAD('CAD', 'C\$'),
  CHF('CHF', 'CHF'),
  CNY('CNY', '¥'),
  CZK('CZK', 'Kč'),
  DKK('DKK', 'kr'),
  EUR('EUR', '€'),
  GBP('GBP', '£'),
  HKD('HKD', 'HK\$'),
  HRK('HRK', 'kn'),
  HUF('HUF', 'Ft'),
  IDR('IDR', 'Rp'),
  ILS('ILS', '₪'),
  INR('INR', '₹'),
  ISK('ISK', 'kr'),
  JPY('JPY', '¥'),
  KRW('KRW', '₩'),
  MXN('MXN', 'Mex\$'),
  MYR('MYR', 'RM'),
  NOK('NOK', 'kr'),
  NZD('NZD', 'NZ\$'),
  PHP('PHP', '₱'),
  PLN('PLN', 'zł'),
  RON('RON', 'lei'),
  RUB('RUB', '₽'),
  SEK('SEK', 'kr'),
  SGD('SGD', 'S\$'),
  THB('THB', '฿'),
  TRY('TRY', '₺'),
  USD('USD', '\$'),
  ZAR('ZAR', 'R');

  final String code;
  final String symbol;
  const Currency(this.code, this.symbol);

  static Currency fromCode(String code) {
    return Currency.values.firstWhere(
      (currency) => currency.code == code,
      orElse: () => Currency.PHP, // Default to PHP if code not found
    );
  }

  static String getSymbol(String code) {
    return fromCode(code).symbol;
  }
}

enum ExpenseCategory {
  food('Food', Icons.restaurant, Colors.orange),
  transport('Transport', Icons.directions_bus, Colors.blue),
  utilities('Utilities', Icons.bolt, Colors.yellow),
  internet('Internet', Icons.wifi, Colors.green),
  water('Water', Icons.water_drop, Colors.lightBlue),
  electricity('Electricity', Icons.lightbulb, Colors.amber),
  entertainment('Entertainment', Icons.movie, Colors.purple),
  netflix('Netflix', Icons.play_circle_filled, Colors.red),
  youtube('YouTube', Icons.play_arrow, Colors.red),
  spotify('Spotify', Icons.music_note, Colors.green),
  subscriptions('Subscriptions', Icons.subscriptions, Colors.indigo),
  chatGPT('ChatGPT', Icons.psychology, Colors.teal),
  claude('Claude', Icons.smart_toy, Colors.deepPurple),
  cursor('Cursor', Icons.code, Colors.blueGrey),
  shopping('Shopping', Icons.shopping_bag, Colors.pink),
  health('Health', Icons.favorite, Colors.red),
  education('Education', Icons.school, Colors.brown),
  rent('Rent', Icons.home, Colors.deepOrange),
  others('Others', Icons.more_horiz, Colors.grey);

  final String name;
  final IconData icon;
  final Color color;
  const ExpenseCategory(this.name, this.icon, this.color);
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sage Expense Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0097A7),
          primary: const Color(0xFF0097A7),
          secondary: const Color(0xFFFFC67D),
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<Expense> _mockExpenses = [
    Expense(
      name: 'Upwork',
      amount: 850.00,
      date: DateTime.now(),
      userId: 'user_id',
      currency: 'PHP',
    ),
    Expense(
      name: 'Transfer',
      amount: -85.00,
      date: DateTime.now().subtract(const Duration(days: 1)),
      userId: 'user_id',
      currency: 'PHP',
    ),
    Expense(
      name: 'Paypal',
      amount: 1406.00,
      date: DateTime(2022, 1, 30),
      userId: 'user_id',
      currency: 'PHP',
    ),
    Expense(
      name: 'Youtube',
      amount: -11.99,
      date: DateTime(2022, 1, 16),
      userId: 'user_id',
      currency: 'PHP',
    ),
  ];

  double _balance = 2256.00; // Initial balance

  void _addExpense(Expense expense) {
    setState(() {
      _mockExpenses = [expense, ..._mockExpenses];
      // Subtract the expense amount from balance
      _balance -= expense.amount;
    });
  }

  // Add method to add balance
  void _addBalance(double amount) {
    setState(() {
      _balance += amount;
      // Add it as an income transaction
      _mockExpenses = [
        Expense(
          name: 'Balance Added',
          amount: amount,
          date: DateTime.now(),
          userId: 'user_id',
          currency: 'PHP',
        ),
        ..._mockExpenses
      ];
    });
  }

  double get _totalBalance => _mockExpenses.fold(
        0,
        (sum, expense) => sum + expense.amount,
      );

  void _showAddBalanceDialog(BuildContext context) {
    final TextEditingController amountController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add Balance',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'AMOUNT',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Text(
                        Currency.PHP.symbol,
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: amountController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: '0.00',
                          ),
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final amount = double.tryParse(amountController.text);
                      if (amount != null && amount > 0) {
                        _addBalance(amount);
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Add Balance',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _getExpenseIcon(String expenseName) {
    final category = ExpenseCategory.values.firstWhere(
      (cat) => cat.name == expenseName,
      orElse: () => ExpenseCategory.others,
    );
    return category.icon;
  }

  Color _getExpenseColor(String expenseName) {
    final category = ExpenseCategory.values.firstWhere(
      (cat) => cat.name == expenseName,
      orElse: () => ExpenseCategory.others,
    );
    return category.color;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0097A7),
              Color(0xFFFFC67D),
            ],
          ),
        ),
        child: Column(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Balance',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${Currency.PHP.symbol}${_balance.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFF0097A7),
                                Color(0xFFFFC67D),
                              ],
                            ),
                          ),
                          child: FloatingActionButton(
                            mini: true,
                            onPressed: () => _showAddBalanceDialog(context),
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildBalanceItem(
                          icon: Icons.arrow_downward,
                          label: 'Income',
                          amount: '${Currency.PHP.symbol}2,256.00',
                        ),
                        _buildBalanceItem(
                          icon: Icons.arrow_upward,
                          label: 'Expenses',
                          amount: '${Currency.PHP.symbol}96.99',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: ListView.builder(
                  itemCount: _mockExpenses.length,
                  itemBuilder: (context, index) {
                    final expense = _mockExpenses[index];
                    return ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          _getExpenseIcon(expense.name),
                          color: _getExpenseColor(expense.name),
                        ),
                      ),
                      title: Text(expense.name),
                      subtitle: Text(DateFormat('MMM dd, yyyy').format(expense.date)),
                      trailing: Text(
                        '${expense.amount > 0 ? '+' : ''}${Currency.getSymbol(expense.currency)}${expense.amount.abs().toStringAsFixed(2)}',
                        style: TextStyle(
                          color: expense.amount > 0 ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0097A7),
              Color(0xFFFFC67D),
            ],
          ),
        ),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return Material(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Theme.of(context).colorScheme.primary,
                            Theme.of(context).colorScheme.secondary,
                          ],
                        ),
                      ),
                      child: AddExpenseScreen(
                        onExpenseAdded: _addExpense,
                      ),
                    ),
                  );
                },
                transitionDuration: const Duration(milliseconds: 300),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  final screenSize = MediaQuery.of(context).size;
                  final fabPosition = MediaQuery.of(context).size.height - 80;
                  
                  return Stack(
                    children: [
                      child,
                      AnimatedBuilder(
                        animation: animation,
                        builder: (context, child) {
                          return ClipPath(
                            clipper: CircleRevealClipper(
                              center: Offset(
                                screenSize.width / 2,
                                fabPosition,
                              ),
                              radius: animation.value * screenSize.height * 1.5,
                            ),
                            child: child,
                          );
                        },
                        child: child,
                      ),
                    ],
                  );
                },
              ),
            );
          },
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 32,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: BottomAppBar(
          elevation: 0,
          color: Colors.transparent,
          shape: const CircularNotchedRectangle(),
          notchMargin: 8,
          child: SizedBox(
            height: 60,
            child: Row(
              children: [
                const SizedBox(width: 24),
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _selectedIndex = 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.home_outlined,
                          color: _selectedIndex == 0 
                              ? Theme.of(context).colorScheme.primary 
                              : Colors.grey,
                        ),
                        Text(
                          'Home',
                          style: TextStyle(
                            color: _selectedIndex == 0 
                                ? Theme.of(context).colorScheme.primary 
                                : Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(flex: 2),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() => _selectedIndex = 1);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WalletScreen(),
                        ),
                      ).then((_) => setState(() => _selectedIndex = 0));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.account_balance_wallet_outlined,
                          color: _selectedIndex == 1 
                              ? Theme.of(context).colorScheme.primary 
                              : Colors.grey,
                        ),
                        Text(
                          'Wallet',
                          style: TextStyle(
                            color: _selectedIndex == 1 
                                ? Theme.of(context).colorScheme.primary 
                                : Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() => _selectedIndex = 2);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileScreen(),
                        ),
                      ).then((_) => setState(() => _selectedIndex = 0));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person_outline,
                          color: _selectedIndex == 2 
                              ? Theme.of(context).colorScheme.primary 
                              : Colors.grey,
                        ),
                        Text(
                          'Profile',
                          style: TextStyle(
                            color: _selectedIndex == 2 
                                ? Theme.of(context).colorScheme.primary 
                                : Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceItem({
    required IconData icon,
    required String label,
    required String amount,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
            Text(
              amount,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class AddExpenseScreen extends StatefulWidget {
  final Function(Expense)? onExpenseAdded;

  const AddExpenseScreen({
    super.key,
    this.onExpenseAdded,
  });

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  ExpenseCategory _selectedCategory = ExpenseCategory.food;
  Currency _selectedCurrency = Currency.PHP;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutQuint,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    _animationController.reverse().then((_) {
                      Navigator.of(context).pop();
                    });
                  },
                ),
                title: const Text(
                  'Add Expense',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'NAME',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildCategorySelector(),
                        const SizedBox(height: 20),
                        const Text(
                          'CURRENCY',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildCurrencySelector(),
                        const SizedBox(height: 20),
                        const Text(
                          'AMOUNT',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildAmountField(),
                        const SizedBox(height: 20),
                        const Text(
                          'DATE',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildDatePicker(),
                        const SizedBox(height: 32),
                        _buildAddButton(),
                      ],
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

  Widget _buildCategorySelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<ExpenseCategory>(
          value: _selectedCategory,
          isExpanded: true,
          items: ExpenseCategory.values.map((category) {
            return DropdownMenuItem(
              value: category,
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: category.color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      category.icon,
                      color: category.color,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    category.name,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (ExpenseCategory? value) {
            if (value != null) {
              setState(() {
                _selectedCategory = value;
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildCurrencySelector() {
    return SearchableCurrencyDropdown(
      value: _selectedCurrency,
      onChanged: (Currency? value) {
        if (value != null) {
          setState(() {
            _selectedCurrency = value;
          });
        }
      },
    );
  }

  Widget _buildAmountField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(
            _selectedCurrency.symbol,
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: '0.00',
              ),
              style: const TextStyle(fontSize: 18),
            ),
          ),
          TextButton(
            onPressed: () {
              _amountController.clear();
              setState(() {});
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          setState(() {
            _selectedDate = picked;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(
              DateFormat('EEE, dd MMM yyyy').format(_selectedDate),
              style: const TextStyle(fontSize: 16),
            ),
            const Spacer(),
            const Icon(Icons.calendar_today, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _handleAddExpense,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Add Expense',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _handleAddExpense() {
    if (_amountController.text.isNotEmpty) {
      final amount = -(double.tryParse(_amountController.text) ?? 0.0); // Make it negative
      final expense = Expense(
        name: _selectedCategory.name,
        amount: amount, // This will be negative
        date: _selectedDate,
        userId: 'user_id',
        currency: _selectedCurrency.code,
      );
      
      if (widget.onExpenseAdded != null) {
        widget.onExpenseAdded!(expense);
      }
      Navigator.pop(context);
    }
  }
}
