import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Authscreen extends StatefulWidget {
  const Authscreen({super.key});

  @override
  State<Authscreen> createState() => _AuthscreenState();
}

class _AuthscreenState extends State<Authscreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final supabase = Supabase.instance.client;
    double cheight() {
      if (height <= 1080 && height >= 720) {
        // return 200;
        return 300;
      }
      if (height >= 0 && height <= 719) {
        return 250;
        // return 150;
      } else {
        return 280;
        // return 180;
      }
    }

    double cwidth() {
      if (width <= 480) {
        return 300;
      }
      if (width <= 767 && width >= 481) {
        return 360;
      }
      if (width <= 1023 && width >= 768) {
        return 410;
      } else {
        return 450;
      }
    }

    return Scaffold(
      body: Center(
        child: SizedBox(
          width: cwidth(),
          height: cheight(),
          child: Card(
            // color: Colors.white,
            elevation: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 10, right: 20, left: 20),
                  child: Text("Welcome to Converse AI",
                      textScaler: const TextScaler.linear(1.8),
                      style:
                          GoogleFonts.truculenta(fontWeight: FontWeight.w600)),
                ),
                const Divider(
                  thickness: 2,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, right: 5, left: 5),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9)),
                    // elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            "Sign in to start creating and sharing your own AI-powered chatbots.",
                            softWrap: true,
                            style:
                                GoogleFonts.inter(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: FilledButton.icon(
                        onPressed: () async {
                          await supabase.auth
                              .signInWithOAuth(OAuthProvider.google);
                          final data = {
                            "name":
                                "${supabase.auth.currentUser!.userMetadata!["username"]}",
                            "email": supabase.auth.currentUser!.email,
                            "uuid": supabase.auth.currentUser!.id,
                            "avatar_url":
                                "${supabase.auth.currentUser!.userMetadata!["avatar_url"]}",
                          };
                          await supabase.from('user').insert(data);
                        },
                        icon: SvgPicture.asset(
                          "asset/icon/google.svg",
                          height: cheight() * 0.2,
                        ),
                        label: Text(
                          "Sign in with Google",
                          textScaler: const TextScaler.linear(1.1),
                          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
                        )),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
