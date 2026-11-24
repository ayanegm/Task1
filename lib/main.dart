import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ContactApp());
}

class Contact {
  final int id;
  final String name;
  final String email;
  final String phone;

  Contact({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
  });
}

class ContactService extends ChangeNotifier {
  static final instace = ContactService._();
  ContactService._();
  final List<Contact> _contacts = [
    Contact(id: 1, name: 'Ali', email: 'ali@gamil.com', phone: '010234567'),
    Contact(id: 2, name: 'Mo', email: 'mo@gamil.com', phone: '010234567'),
  ];
  List<Contact> get contacts => List.unmodifiable(_contacts);
  Contact? findId(int id) {
    try {
      return _contacts.firstWhere((element) => element.id == id);
    } catch (_) {
      return null;
    }
  }

  void add(Contact c) {
    _contacts.add(c);
    notifyListeners();
  }

  void delete(int id) {
    _contacts.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  int get nextId => _contacts.isEmpty
      ? 1
      : _contacts
                .map((c) => c.id)
                .reduce((value, element) => value > element ? value : element) +
            1;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(initialRoute: 'home');
  }
}

class ContactApp extends StatelessWidget {
  const ContactApp({super.key});
  static final _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'contacts',
        builder: (context, state) => const ContactListScreen(),
        routes: [
          GoRoute(
            path: '/add',
            name: 'add-contact',
            builder: (context, state) => const AddContactScreen(),
          ),
          GoRoute(
            path: '/settings',
            name: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: ':id',
            name: 'contacts-details',
            builder: (context, state) {
              final id = int.tryParse(state.pathParameters['id'] ?? '');
              if (id == null) {
                return const Scaffold(
                  body: Center(child: Text('Invalid contact ID')),
                );
              }
              return ContactsDetailsScreen(contactId: id);
            },
          ),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Contact App',
      theme: ThemeData(primarySwatch: Colors.teal),
      routerConfig: _router,
    );
  }
}

class ContactListScreen extends StatelessWidget {
  const ContactListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        actions: [
          IconButton(
            onPressed: () => context.push('/settings'),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: ContactService.instace,
        builder: (context, child) {
          final contacts = ContactService.instace.contacts;
          if (contacts.isEmpty) {
            return const Center(child: Text('No Contacts Yet!!!'));
          }
          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final c = contacts[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text(c.name.isNotEmpty ? c.name[0] : '?'),
                ),
                title: Text(c.name),
                subtitle: Text(c.phone),
                onTap: () => context.push('/contacts/${c.id}'),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await context.push<Contact>('/add');
          if (result != null) {
            ContactService.instace.add(result);
            if (!context.mounted) return;
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('${result.name} is added')));
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ContactsDetailsScreen extends StatelessWidget {
  final int contactId;
  const ContactsDetailsScreen({super.key, required this.contactId});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ContactService.instace,
      builder: (context, _) {
        final contact = ContactService.instace.findId(contactId);
        if (contact == null) {
          return Scaffold(
            body: Center(child: Text('the contact was not existed')),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(contact.name),
            actions: [
              IconButton(
                onPressed: () {
                  ContactService.instace.delete(contactId);
                  context.pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('deleted successfully')),
                  );
                },
                icon: Icon(Icons.delete),
              ),
            ],
          ),
          body: Padding(
            padding: EdgeInsetsGeometry.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(contact.name),
                SizedBox(height: 10),
                Text(contact.email),
                SizedBox(height: 10),
                Text(contact.phone),
                SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }
}

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({super.key});

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();

    super.dispose();
  }

  void save() {
    if (_nameCtrl.text.isEmpty || _phoneCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('please fill hte empty textFields')),
      );
      return;
    }
    context.pop(
      Contact(
        id: ContactService.instace.nextId,
        name: _nameCtrl.text,
        email: _emailCtrl.text,
        phone: _phoneCtrl.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('adding new contact'),
        actions: [IconButton(onPressed: save, icon: const Icon(Icons.check))],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _nameCtrl,
              decoration: InputDecoration(labelText: 'name'),
            ),
            TextField(
              controller: _phoneCtrl,
              decoration: InputDecoration(labelText: 'phone'),
            ),
            TextField(
              controller: _emailCtrl,
              decoration: InputDecoration(labelText: 'email'),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('setting')),
      body: ListView(
        children: [
          ListTile(
            title: Text('About the app'),
            subtitle: Text('version 1.0.0'),
          ),
          SwitchListTile(
            value: true,
            onChanged: (_) {},
            title: Text('notifications'),
          ),
        ],
      ),
    );
  }
}
