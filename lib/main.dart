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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPageIndex = 0;
  int notifsNum = 2; // Example notification count

  void updateNotifications(int count) {
    setState(() {
      notifsNum = count;
    });
  }

  void readNotifs() {
    setState(() {
      notifsNum = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
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
          HomeNavDest(notifsNum: notifsNum),
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
        // Notifications page
        ListView.builder(
          reverse: true,
          itemCount: 2,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return Align(
                alignment: Alignment.centerRight,
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    'Hello',
                    style: theme.textTheme.bodyLarge!
                        .copyWith(color: theme.colorScheme.onPrimary),
                  ),
                ),
              );
            }
            return Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  'Hi!',
                  style: theme.textTheme.bodyLarge!
                      .copyWith(color: theme.colorScheme.onPrimary),
                ),
              ),
            );
          },
        ),

        // Prayers page
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Card(
                child: ListTile(
                  leading: Icon(Icons.notifications_sharp),
                  title: Text('Notification 1'),
                  subtitle: Text('This is a notification'),
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.notifications_sharp),
                  title: Text('Notification 2'),
                  subtitle: Text('This is a notification'),
                ),
              ),
            ],
          ),
        ),

        // Donate page
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Card(
                child: ListTile(
                  leading: Icon(Icons.notifications_sharp),
                  title: Text('Notification 1'),
                  subtitle: Text('This is a notification'),
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.notifications_sharp),
                  title: Text('Notification 2'),
                  subtitle: Text('This is a notification'),
                ),
              ),
            ],
          ),
        ),

        // More page
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: <Widget>[
              buildCard(context, Icons.book, 'About Us', 'Learn more about Masjid At-Taqwa, our community, and how to contact us!'),
              buildCard(context, Icons.favorite, 'ISGH Donations', 'Zakat, Fitra, Fidya, Cemetery Development, Funeral Services, and Job Networking'),
              buildCard(context, Icons.groups, 'Social Services', 'Counseling, Marriage, Zakat, Funeral, and Medical Services Info'),
              buildCard(context, Icons.volunteer_activism, 'Volunteer Sign-Up Form', 'Help with our community events, services, and charity!'),
              buildCard(context, Icons.diversity_1, 'Marriage Form', 'Host and conduct your marriage ceremony with us'),
              buildCard(context, Icons.restaurant, 'Food Service Form', 'We provide food for Marriage, Aqiqah, Graduation, and more'),
              buildCard(context, Icons.share, 'Social Media', 'Join our Whatsapp group, FaceBook page, or Instagram'),
            ],
          ),
        ),
      ][currentPageIndex],
    );
  }

  Widget buildCard(BuildContext context, IconData icon, String title, String subtitle) {
    return Card(
      child: InkWell(
        onTap: () {
          // Handle card tap
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Tapped on $title')));
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
  final int notifsNum;

  const HomeNavDest({super.key, required this.notifsNum});

  @override
  State<HomeNavDest> createState() => _HomeNavDestState();
}

class _HomeNavDestState extends State<HomeNavDest> {
  @override
  Widget build(BuildContext context) {
    if (widget.notifsNum == 0) {
      return const NavigationDestination(
        selectedIcon: Icon(Icons.home),
        icon: Icon(Icons.home_outlined),
        label: 'Home',
      );
    }
    return NavigationDestination(
      selectedIcon: Badge(
        label: Text(widget.notifsNum.toString()),
        child: const Icon(Icons.home),
      ),
      icon: Badge(
        label: Text(widget.notifsNum.toString()),
        child: const Icon(Icons.home_outlined),
      ),
      label: 'Home',
    );
  }
}

