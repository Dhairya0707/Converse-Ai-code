// ignore_for_file: use_build_context_synchronously, deprecated_member_use, non_constant_identifier_names

import 'package:clipboard/clipboard.dart';
import 'package:converse_ai/screen/about.dart';
import 'package:converse_ai/screen/create.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final supabase = Supabase.instance.client;

  List<dynamic> list = [];
  @override
  void initState() {
    super.initState();
    fetch();
  }

  void show_snack(e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 2),
      showCloseIcon: true,
      content: Text(e.toString()),
    ));
  }

  Future<void> fetch() async {
    await supabase.from("user").select("*, chatbot(*)").then((value) {
      List<dynamic> main = value[0]["chatbot"];
      list.clear();
      for (var i = 0; i < main.length; i++) {
        list.add(main[i]);
      }
      setState(() {});
    });
  }

  Future<void> showAlertDialog(
      BuildContext context, double height, double width) async {
    List<dynamic> noti = [];
    final id = supabase.auth.currentUser!.id;
    await supabase.from("user").select("noti").eq("id", id).then((value) {
      for (var i = 0; i < value[0]["noti"].length; i++) {
        noti.add(value[0]["noti"][i]);
      }
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Notifications"),
          content: SizedBox(
            height: height * 0.6,
            width: width * 0.4,
            child: ListView.builder(
              itemCount: noti.length,
              itemBuilder: (BuildContext context, int index) {
                final msg = noti[index]["msg"];
                final msg2 = noti[index]["msg2"];
                final url = noti[index]["url"];

                return ListTile(
                  leading: const Icon(Icons.new_releases_rounded),
                  onTap: () {
                    launch(url);
                  },
                  title: Text(msg),
                  subtitle: Text(msg2),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(context), // Close dialog on button press
              child: const Text('close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    bool isdek() {
      if (width <= 650) {
        return true;
      } else {
        return false;
      }
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: height * 0.1,
        actions: [
          IconButton(
              onPressed: () async {
                await fetch();
              },
              icon: const Icon(Icons.refresh_rounded))
        ],
        title: Text(
          'Converse AI',
          textScaler: const TextScaler.linear(1.2),
          style: GoogleFonts.truculenta(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Row(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: SizedBox(
                height: height * 0.88,
                // width: width * 0.15,
                width: isdek() ? width * 0.15 : width * 0.2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    isdek()
                        ? Tooltip(
                            message: "Notifications",
                            child: IconButton(
                                onPressed: () async {
                                  await showAlertDialog(context, height, width);
                                },
                                icon: const Icon(Icons.notifications)),
                          )
                        : ListTile(
                            onTap: () async {
                              await showAlertDialog(context, height, width);
                            },
                            title: const Text(
                              "Notifications",
                            ),
                            leading: const Icon(Icons.notifications),
                          ),
                    isdek()
                        ? Tooltip(
                            message: "About App",
                            child: IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const AboutPage()));
                                },
                                icon: const Icon(Icons.error_outline_rounded)),
                          )
                        : ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const AboutPage()));
                            },
                            title: const Text(
                              "About App",
                            ),
                            leading: const Icon(Icons.error_outline_rounded),
                          ),
                    const Spacer(),
                    isdek()
                        ? Tooltip(
                            message: "Sign Out",
                            child: IconButton(
                                onPressed: () {
                                  supabase.auth.signOut();
                                },
                                icon: const Icon(Icons.exit_to_app_rounded)),
                          )
                        : ListTile(
                            onTap: () {
                              supabase.auth.signOut();
                            },
                            title: const Text(
                              "Sign Out",
                            ),
                            leading: const Icon(Icons.exit_to_app_rounded),
                          ),
                    const SizedBox(
                      height: 15,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: height * 0.88,
              width: isdek() ? width * 0.80 : width * 0.75,
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  final id = list[index]["id"];
                  final name = list[index]["name"];
                  final domain = list[index]["domain"];
                  return Card(
                      child: ListTile(
                          title: Text(name),
                          subtitle: Text(id),
                          trailing: IconButton(
                              onPressed: () {
                                String url = domain + id;
                                FlutterClipboard.copy(url)
                                    .then((value) => show_snack("copied url!"));
                              },
                              icon: const Icon(
                                Icons.copy,
                              ))));
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const CreateBot()));
          },
          icon: const Icon(Icons.add),
          label: const Text("Create")),
    );
  }
}
