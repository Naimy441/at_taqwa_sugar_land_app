import 'package:flutter/material.dart';

void main() {
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

  void markAsRead(int index) {
    setState(() {
      if (!updates[index]["isRead"]) {
        updates[index]["isRead"] = true;
        widget.onReadUpdate();
      }
    });
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
          onTap: () => markAsRead(index),
        );
      },
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
              'Construction, Dawah, Dome, Education, Iftar, Pantry, Ramadan, Sports, Weekend Classes, and Youth Programs!'),
          buildCard(context, Icons.shopping_bag, 'Payments',
              'Make a payment for Quran Classes or Sports'),
          buildCard(context, Icons.tv, 'TV Advertisement Fee',
              'Help spread Masjid At-Taqwa\'s message and values'),
          buildCard(context, Icons.group_add, 'ISGH Membership',
              'Enjoy the benefits of membership while supporting an important and compelling cause'), 
          buildCard(context, Icons.approval, 'Zakat',
              'Donate your Zakat for various causes'),
          buildCard(context, Icons.calendar_month, 'Fitra',
              'Donate your Fitra for Ramadan'),
          buildCard(context, Icons.business, 'Fidya',
              'Donate Fidya for missed fasts in Ramadan'),
          buildCard(context, Icons.location_city, 'Cemetery Development',
              'Contribute towards our cemetery development'),
          buildCard(context, Icons.departure_board, 'Funeral Services',
              'Support our funeral services'),
          buildCard(context, Icons.work, 'Job Networking',
              'Help connect community members with job opportunities'),
        ],
      ),
    );
  }

  Widget buildCard(
      BuildContext context, IconData icon, String title, String subtitle) {
    return Card(
      child: InkWell(
        onTap: () {
          // Handle card tap
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Tapped on $title')));
        },
        child: ListTile(
          leading: Icon(icon),
          title: Text(title),
          subtitle: Text(subtitle),
        ),
      ),
    );
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
              'Learn more about Masjid At-Taqwa, our community, and how to contact us!'),
          buildCard(context, Icons.favorite, 'ISGH Donations',
              'Zakat, Fitra, Fidya, Cemetery Development, Funeral Services, and Job Networking'),
          buildCard(context, Icons.groups, 'Social Services',
              'Counseling, Marriage, Zakat, Funeral, and Medical Services Info'),
          buildCard(context, Icons.volunteer_activism, 'Volunteer Sign-Up Form',
              'Help with our community events, services, and charity!'),
          buildCard(context, Icons.diversity_1, 'Marriage Form',
              'Host and conduct your marriage ceremony with us'),
          buildCard(context, Icons.restaurant, 'Food Service Form',
              'We provide food for Marriage, Aqiqah, Graduation, and more'),
          buildCard(context, Icons.share, 'Social Media',
              'Join our Whatsapp group, FaceBook page, or Instagram'),
        ],
      ),
    );
  }

  Widget buildCard(
      BuildContext context, IconData icon, String title, String subtitle) {
    return Card(
      child: InkWell(
        onTap: () {
          // Handle card tap
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Tapped on $title')));
        },
        child: MouseRegion(
          onEnter: (event) => print('Hovering over $title'),
          onExit: (event) => print('Stopped hovering over $title'),
          child: ListTile(
            leading: Icon(icon),
            title: Text(title),
            subtitle: Text(subtitle),
          ),
        ),
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
