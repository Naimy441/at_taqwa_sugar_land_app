import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationSettings().init(); // Initialize shared preferences and default settings
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple, // Example primary color
        textTheme: const  TextTheme(
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          titleMedium: TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ),
      home: const AtTaqwaApp(title: 'Flutter Demo Home Page'),
    );
  }
}

class AtTaqwaApp extends StatefulWidget {
  const AtTaqwaApp({super.key, required this.title});

  final String title;

  @override
  State<AtTaqwaApp> createState() => _AtTaqwaAppState();
}

class _AtTaqwaAppState extends State<AtTaqwaApp> {
  int currentPageIndex = 0;
  int unreadUpdatesCount = 5; // Example unread updates count

  void markUpdateAsRead() {
    setState(() {
      if (unreadUpdatesCount > 0) {
        unreadUpdatesCount--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: const Color.fromARGB(255, 66, 216, 151),
        selectedIndex: currentPageIndex,
        destinations: <Widget>[
          HomeNavDest(unreadUpdatesCount: unreadUpdatesCount),
          const NavigationDestination(
            icon: Icon(Icons.mosque),
            label: 'Prayers',
          ),
          const NavigationDestination(
            icon: Icon(Icons.paid),
            label: 'Donate',
          ),
          const NavigationDestination(
            icon: Icon(Icons.more_horiz),
            label: 'More',
          ),
        ],
      ),
      body: <Widget>[
        UpdatesPage(
          unreadUpdatesCount: unreadUpdatesCount,
          onReadUpdate: markUpdateAsRead,
        ),
        const PrayersPage(),
        const DonatePage(),
        const MorePage(),
      ][currentPageIndex],
    );
  }
}

class UpdatesPage extends StatefulWidget {
  final int unreadUpdatesCount;
  final VoidCallback onReadUpdate;

  const UpdatesPage({super.key, required this.unreadUpdatesCount, required this.onReadUpdate});

  @override
  State<UpdatesPage> createState() => _UpdatesPageState();
}

class _UpdatesPageState extends State<UpdatesPage> {
  List<Map<String, dynamic>> updates = [
    {"title": "Event 1", "description": "Details about event 1", "isRead": false},
    {"title": "Event 2", "description": "Details about event 2", "isRead": false},
    {"title": "Announcement 1", "description": "Details about announcement 1", "isRead": false},
    {"title": "Event 3", "description": "Details about event 3", "isRead": false},
    {"title": "Announcement 2", "description": "Details about announcement 2", "isRead": false},
  ];

  void navigateToDetailPage(int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateDetailPage(
          title: updates[index]["title"],
          description: updates[index]["description"],
          markAsRead: () {
            setState(() {
              if (!updates[index]["isRead"]) {
                updates[index]["isRead"] = true;
                widget.onReadUpdate(); // Update parent widget state
              }
            });
          },
        ),
      ),
    );

    // Handle result if needed after returning from UpdateDetailPage
    if (result != null) {
      // Handle any returned data
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: updates.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(updates[index]["title"]),
          subtitle: Text(updates[index]["description"]),
          tileColor: updates[index]["isRead"]
              ? Colors.grey[300]
              : Theme.of(context).colorScheme.primary.withOpacity(0.1),
          onTap: () => navigateToDetailPage(index), // Navigate to detail page
        );
      },
    );
  }
}

class UpdateDetailPage extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback markAsRead;

  const UpdateDetailPage({required this.title, required this.description, required this.markAsRead});

  @override
  Widget build(BuildContext context) {
    // Schedule markAsRead callback to execute after current frame is built
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      markAsRead(); // This ensures markAsRead is called after the build phase
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Text(
              description,
              style: TextStyle(fontSize: 16),
            ),
            // You can add more details or components here if needed
          ],
        ),
      ),
    );
  }
}


class PrayersPage extends StatelessWidget {
  const PrayersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Today\'s Prayer Times',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 8.0),
                  buildPrayerTime(context, 'Fajr', '4:30 AM'),
                  buildPrayerTime(context, 'Dhuhr', '1:00 PM'),
                  buildPrayerTime(context, 'Asr', '5:00 PM'),
                  buildPrayerTime(context, 'Maghrib', '7:30 PM'),
                  buildPrayerTime(context, 'Isha', '9:00 PM'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPrayerTime(BuildContext context, String prayerName, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            prayerName,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            time,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}

class DonatePage extends StatelessWidget {
  const DonatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: <Widget>[
          buildCard(context, Icons.redeem, 'Masjid At-Taqwa General Fund',
              'Construction, Dawah, Dome, Education, Iftar, Pantry, Ramadan, Sports, Weekend Classes, and Youth Programs!',
              'https://host.nxt.blackbaud.com/donor-form?svcid=tcs&formId=a50e1762-fa5a-4a32-b006-163c687e5784&envid=p-IvDmnzGcgkekewX1eX757g&zone=usa'),
          buildCard(context, Icons.shopping_bag, 'Payments',
              'Make a payment for Quran Classes or Sports',
              'https://host.nxt.blackbaud.com/donor-form/?svcid=tcs&formId=10588fe8-aa29-46b5-a24d-5182dd747d07&envid=p-IvDmnzGcgkekewX1eX757g&zone=usa'),
          buildCard(context, Icons.tv, 'TV Advertisement Fee',
              'Help spread Masjid At-Taqwa\'s message and values',
              'https://host.nxt.blackbaud.com/donor-form/?svcid=tcs&formId=4bd0d348-054a-4d2d-ac14-7635d1385003&envid=p-IvDmnzGcgkekewX1eX757g&zone=usa'),
          buildCard(context, Icons.group_add, 'ISGH Membership',
              'Enjoy the benefits of membership while supporting an important and compelling cause',
              'https://community.isgh.org/membership'), 
          buildCard(context, Icons.approval, 'Zakat',
              'Donate your Zakat for various causes',
              'https://isgh.org/zakat'),
          buildCard(context, Icons.calendar_month, 'Fitra',
              'Donate your Fitra for Ramadan',
              'http://isgh.org/fitra'),
          buildCard(context, Icons.business, 'Fidya',
              'Donate Fidya for missed fasts in Ramadan',
              'https://isgh.org/fidya'),
          buildCard(context, Icons.location_city, 'Cemetery Development',
              'Contribute towards our cemetery development',
              'https://isgh.org/cemetery/'),
          buildCard(context, Icons.departure_board, 'Funeral Services',
              'Support our funeral services',
              'https://isgh.org/funeral-services-fund/'),
          buildCard(context, Icons.work, 'Job Networking',
              'Help connect community members with job opportunities',
              'https://isgh.org/isgh-job-networking/'),
        ],
      ),
    );
  }

 Widget buildCard(BuildContext context, IconData icon, String title, String subtitle, String url) {
    return Card(
      child: InkWell(
        onTap: () {
          _launchURL(url);
        },
        child: ListTile(
          leading: Icon(icon),
          title: Text(title),
          subtitle: Text(subtitle),
        ),
      ),
    );
  }

  _launchURL(url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}


class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: <Widget>[
          buildCard(context, Icons.book, 'About Us',
              'Learn more about Masjid At-Taqwa, our community, and how to contact us!', 
              null),
          buildCard(context, Icons.groups, 'Social Services',
              'Counseling, Marriage, Zakat, Funeral, and Medical Services Info',
              'https://masjidattaqwa.com/#social'),
          buildCard(context, Icons.volunteer_activism, 'Volunteer Sign-Up Form',
              'Help with our community events, services, and charity!',
              'https://masjidattaqwa.com/#volunteer'),
          buildCard(context, Icons.diversity_1, 'Marriage Form',
              'Host and conduct your marriage ceremony with us',
              'https://masjidattaqwa.com/#marriage'),
          buildCard(context, Icons.restaurant, 'Food Service Form',
              'We provide food for Marriage, Aqiqah, Graduation, and more',
              'https://masjidattaqwa.com/#food'),
          buildCard(context, Icons.share, 'Social Media',
              'Join our Whatsapp group, FaceBook page, or Instagram',
              null),
          buildCard(context, Icons.settings, 'Settings',
              'Manage Notifications',
              null),
          buildCard(context, Icons.shield_outlined, 'Admin Login',
              'One-time Use',
              null),
        ],
      ),
    );
  }

  Widget buildCard(BuildContext context, IconData icon, String title, String subtitle, String? url) {
  return Card(
    child: InkWell(
      onTap: () {
        if (url != null) {
          _launchURL(url);
        } else {
          _navigateToPage(context, title);
        }
      },
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    ),
  );
}

  _launchURL(url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  void _navigateToPage(BuildContext context, String title) {
    // Implement navigation logic based on the title or any other condition
    switch (title) {
      case 'About Us':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AboutUsPage()),
        );
        break;
      case 'Social Media':
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SocialMediaPage()),
          );
        break;
      case 'Settings':
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SettingsPage()),
          );
        break;
      case 'Admin Login':
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdminLoginPage()),
          );
        break;
      // Add cases for other pages as needed
      default:
        // Handle default case or do nothing
        break;
    }
  }
}

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Masjid At-Taqwa',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'Learn more about Masjid At-Taqwa, our community, and how to contact us!',
                textAlign: TextAlign.center,
              ),
              // Add more widgets as needed to describe your about us page
            ],
          ),
        ),
      ),
    );
  }
}

class SocialMediaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Social Media'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildSocialCard(context, Icons.facebook, 'Facebook', 'Visit our Facebook page'),
            buildSocialCard(context, Icons.chat_bubble, 'Instagram', 'Follow us on Instagram'),
          ],
        ),
      ),
    );
  }

  Widget buildSocialCard(BuildContext context, IconData icon, String title, String subtitle) {
    String url;
    switch (title) {
      case 'Facebook':
        url = 'https://www.facebook.com/Masjid-At-Taqwa-Synott-Islamic-Center-104223072278615';
        break;
      case 'Instagram':
        url = 'https://instagram.com/synottislamiccenter';
        break;
      default:
        throw 'Invalid social media platform';
    }

    return Card(
      child: InkWell(
        onTap: () {
          _launchURL(url);
        },
        child: ListTile(
          leading: Icon(icon),
          title: Text(title),
          subtitle: Text(subtitle),
        ),
      ),
    );
  }

    _launchURL(url) async {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        throw 'Could not launch $url';
      }
    }
}

class NotificationSettings {
  static final NotificationSettings _instance = NotificationSettings._internal();
  factory NotificationSettings() => _instance;
  NotificationSettings._internal();

  static const List<String> categories = [
    'Fajr', 'Sunrise', 'Dhuhr', 'Asr', 'Maghrib', 'Isha', 'Regular Updates', 'Important Updates'
  ];

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    initializeDefaultSettings();
  }

  void saveSetting(String category, String option) {
    _prefs?.setString(category, option);
  }

  String getSetting(String category) {
    return _prefs?.getString(category) ?? 'Beep'; // Default to 'Beep'
  }

  void initializeDefaultSettings() {
    for (String category in categories) {
      if (!_prefs!.containsKey(category)) {
        _prefs?.setString(category, 'Beep');
      }
    }
  }
}

class NotificationSettingsBottomSheet extends StatefulWidget {
  final String category;

  NotificationSettingsBottomSheet({required this.category});

  @override
  _NotificationSettingsBottomSheetState createState() =>
      _NotificationSettingsBottomSheetState();
}

class _NotificationSettingsBottomSheetState
    extends State<NotificationSettingsBottomSheet> {
  String? selectedOption;

  @override
  void initState() {
    super.initState();
    selectedOption = NotificationSettings().getSetting(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Text(
            'Notification Settings for ${widget.category}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: getRadioListTiles(),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.green.shade700),
                padding: MaterialStateProperty.all<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
              ),
              onPressed: () {
                // Save the settings using shared preferences
                NotificationSettings().saveSetting(widget.category, selectedOption!);
                Navigator.pop(context);
              },
              child: Text(
                'Save',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> getRadioListTiles() {
    List<Widget> tiles = [];
    if (widget.category == 'Regular Updates' || widget.category == 'Important Updates' || widget.category == 'Sunrise') {
      tiles.addAll([
        RadioListTile<String>(
          title: const Text('Disable'),
          value: 'Disable',
          groupValue: selectedOption,
          onChanged: (value) {
            setState(() {
              selectedOption = value;
            });
          },
        ),
        RadioListTile<String>(
          title: const Text('Silence'),
          value: 'Silence',
          groupValue: selectedOption,
          onChanged: (value) {
            setState(() {
              selectedOption = value;
            });
          },
        ),
        RadioListTile<String>(
          title: const Text('Beep'),
          value: 'Beep',
          groupValue: selectedOption,
          onChanged: (value) {
            setState(() {
              selectedOption = value;
            });
          },
        ),
      ]);
    } else {
      tiles.addAll([
        RadioListTile<String>(
          title: const Text('Disable'),
          value: 'Disable',
          groupValue: selectedOption,
          onChanged: (value) {
            setState(() {
              selectedOption = value;
            });
          },
        ),
        RadioListTile<String>(
          title: const Text('Silence'),
          value: 'Silence',
          groupValue: selectedOption,
          onChanged: (value) {
            setState(() {
              selectedOption = value;
            });
          },
        ),
        RadioListTile<String>(
          title: const Text('Beep'),
          value: 'Beep',
          groupValue: selectedOption,
          onChanged: (value) {
            setState(() {
              selectedOption = value;
            });
          },
        ),
        RadioListTile<String>(
          title: const Text('Athan'),
          value: 'Athan',
          groupValue: selectedOption,
          onChanged: (value) {
            setState(() {
              selectedOption = value;
            });
          },
        ),
        RadioListTile<String>(
          title: const Text('Full Athan'),
          value: 'Full Athan',
          groupValue: selectedOption,
          onChanged: (value) {
            setState(() {
              selectedOption = value;
            });
          },
        ),
      ]);
    }
    return tiles;
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Scrollbar(
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            NotificationCategoryTile(
              title: 'Prayer Times',
              options: ['Fajr', 'Sunrise', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'],
            ),
            SizedBox(height: 20),
            NotificationCategoryTile(
              title: 'Updates',
              options: ['Regular Updates', 'Important Updates'],
            ),
            // Add more widgets as needed
          ],
        ),
      ),
    );
  }
}

class NotificationCategoryTile extends StatelessWidget {
  final String title;
  final List<String> options;

  NotificationCategoryTile({required this.title, required this.options});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Column(
          children: options.map((option) {
            return ListTile(
              title: Text(option),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return NotificationSettingsBottomSheet(
                      category: option,
                    );
                  },
                );
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}


class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({Key? key}) : super(key: key);

  @override
  _AdminLoginPageState createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _login() {
    setState(() {
      _isLoading = true;
    });

    // Simulate a login process. Replace with your actual login logic.
    Future.delayed(const Duration(seconds: 2), () {
      // Check username and password here
      String username = _usernameController.text.trim();
      String password = _passwordController.text.trim();

      // Example of simple validation - replace with your actual validation logic
      if (username == 'admin' && password == 'password') {
        // Navigate to AdminDashboard or perform desired action
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminDashboard()),
        );
      } else {
        // Handle invalid login
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Invalid Credentials'),
              content: Text('Please enter correct username and password.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }

      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 24.0),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    child: Text('Login'),
                  ),
          ],
        ),
      ),
    );
  }
}

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
      ),
      body: Center(
        child: Text('Welcome, Admin!'),
      ),
    );
  }
}

class HomeNavDest extends StatefulWidget {
  final int unreadUpdatesCount;

  const HomeNavDest({super.key, required this.unreadUpdatesCount});

  @override
  State<HomeNavDest> createState() => _HomeNavDestState();
}

class _HomeNavDestState extends State<HomeNavDest> {
  @override
  Widget build(BuildContext context) {
    if (widget.unreadUpdatesCount == 0) {
      return const NavigationDestination(
        selectedIcon: Icon(Icons.home),
        icon: Icon(Icons.home_outlined),
        label: 'Home',
      );
    }
    return NavigationDestination(
      selectedIcon: Badge(
        label: Text(widget.unreadUpdatesCount.toString()),
        child: const Icon(Icons.home),
      ),
      icon: Badge(
        label: Text(widget.unreadUpdatesCount.toString()),
        child: const Icon(Icons.home_outlined),
      ),
      label: 'Home',
    );
  }
}
