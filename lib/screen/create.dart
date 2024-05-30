// ignore_for_file: unnecessary_string_interpolations, non_constant_identifier_names, use_build_context_synchronously, invalid_return_type_for_catch_error
import 'dart:convert';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:markdown_widget/widget/markdown_block.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreateBot extends StatefulWidget {
  const CreateBot({super.key});

  @override
  State<CreateBot> createState() => _CreateBotState();
}

class _CreateBotState extends State<CreateBot> {
  TextEditingController name = TextEditingController();
  TextEditingController creator = TextEditingController();
  TextEditingController personality = TextEditingController();
  TextEditingController tone = TextEditingController();
  TextEditingController purpose = TextEditingController();
  TextEditingController core_fetures = TextEditingController();
  TextEditingController response_style = TextEditingController();
  TextEditingController fallback = TextEditingController();
  TextEditingController chat = TextEditingController();
  TextEditingController url = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode node = FocusNode();
  final supabase = Supabase.instance.client;
  bool mobileshow = false;

  @override
  void initState() {
    super.initState();
    onload();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  final gemini = Gemini.instance;

  List<Content> chatlist = [
    Content(parts: [
      Parts(
          text:
              '''You are Converse AI, an assistant designed to help users create their own custom chatbots. Guide users by asking for the chatbot's name, creator, personality type, tone, purpose, core feature, response style, and fallback response. Suggest ideas for each property. Always respond in JSON format: For normal conversation: {"text":"[response]","done":false}} Once all inputs are collected and confirmed: {"text":"[summary]", "done":true}, give every ans in this form if also user just general talk then ans in this form in that text filed all other blacks, after final tell user to click on create button, and tell user that your filed will be automatic fillup'''),
    ], role: 'user'),
  ];

  List<dynamic> viewmsg = [];
  String share_url = "";

  void show_snack(e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 2),
      showCloseIcon: true,
      content: Text(e.toString()),
    ));
  }

//just change chalist first prompt for the onload do not have to chnage anythiing in this
  void onload() {
    try {
      viewmsg.insert(0, {
        "role": "model",
        "msg": "Thinkking...!",
      });
      gemini.chat(chatlist).then((value) {
        String? txtvalue = value!.content!.parts!.last.text;
        final js = jsonDecode(txtvalue!);
        final msg = js["text"];
        // final done = js["done"];
        viewmsg.removeAt(0);

        viewmsg.insert(0, {
          "role": "model",
          "msg": msg,
        });
        chatlist.add(
          Content(parts: [Parts(text: "$txtvalue")], role: 'model'),
        );

        setState(() {
          node.requestFocus();
        });
      });
    } catch (e) {
      show_snack(e);
    }
  }

  void filldetails(String str) {
    // String data =
    //     '''That's a great fallback response! 'Jokebuddy' will be polite and apologetic when it can't help. 😊Now, let's do a quick recap of the information Name: JokebuddyCreator: DhairyaPersonality: FriendlyTone: Dank and funnyPurpose: To provide dank and funny jokesCore Feature: Funny and easy-to-understand jokesResponse Style: FunnyFallback Response: Apologetic and tries to helpAre there any changes you'd like to make before we create your chatbot?''';

    String data2 =
        'Extract the relevant information from the input text and convert it into a JSON form with the following fields: chatbot_name, creator, personality, tone, purpose, core_features, response_style, and fallback_response. just one ans for all filed ';
    String finalstr = "$str + $data2";
    try {
      gemini.text(finalstr).then((value) {
        String fstr = value!.output!;
        String jsonstr = fstr
            .substring(3, fstr.length - 3)
            .replaceAll("json", " ")
            .replaceAll("JSON", " ");
        final js = jsonDecode(jsonstr);
        name.text = js["chatbot_name"];
        creator.text = js["creator"];
        personality.text = js["personality"];
        tone.text = js["tone"];
        purpose.text = js["purpose"];
        core_fetures.text = js["core_features"];
        response_style.text = js["response_style"];
        fallback.text = js["fallback_response"];
        show_snack("Details filled !");
      }).catchError((e) => show_snack("something error : $e "));
    } catch (e) {
      show_snack(e);
    }
  }

  void sendmsg() async {
    if (chat.text.isNotEmpty) {
      try {
        viewmsg.insert(0, {"role": "user", "msg": chat.text});
        chatlist.add(
          Content(parts: [Parts(text: chat.text)], role: 'user'),
        );
        viewmsg.insert(0, {
          "role": "model",
          "msg": "Thinkking...!",
        });
        chat.clear();
        setState(() {});
        gemini.chat(chatlist).then((value) {
          String? txtvalue = value!.content!.parts!.last.text;
          viewmsg.removeAt(0);

          final js = jsonDecode(txtvalue!);
          final msg = js["text"];
          final done = js["done"];
          if (done == true) {
            filldetails(msg);
          }

          viewmsg.insert(0, {"role": "model", "msg": msg});
          chatlist.add(
            Content(parts: [Parts(text: txtvalue)], role: 'model'),
          );

          setState(() {
            node.requestFocus();
          });
        });

        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeIn,
        );
      } catch (e) {
        show_snack(e);
      }
    } else {
      show_snack("Enter you Input !");
    }
  }

  void showAlertDialog(BuildContext context, String title, bool bot) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(bot
              ? '''For a more effective bot, provide detailed information in each text input field to ensure accurate customization and optimal performance.'''
              : '''Explore our innovative Chatbot Helper tool designed to support your bot-building journey. \nPlease note that this feature is experimental as we continuously refine its capabilities based on user feedback. \nYour insights are valuable in shaping the future of the Chatbot Helper tool.\nReview your details carefully before finalizing for a successful bot creation experience. '''),
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

  void setdata() {
    try {
      name.text = "travel";
      creator.text = "dhairya";
      personality.text = "guide";
      tone.text = "funny";
      purpose.text = "give info about place";
      core_fetures.text = "give info about place";
      response_style.text = "formal";
      fallback.text = "sorry";
    } catch (e) {
      show_snack(e);
    }
  }

  Future<void> create(double height) async {
    if (name.text.isNotEmpty &&
        creator.text.isNotEmpty &&
        personality.text.isNotEmpty &&
        tone.text.isNotEmpty &&
        tone.text.isNotEmpty &&
        purpose.text.isNotEmpty &&
        core_fetures.text.isNotEmpty &&
        response_style.text.isNotEmpty &&
        fallback.text.isNotEmpty) {
      final table = supabase.from("chatbot");

      final data = {
        'name': name.text,
        'creator': creator.text,
        'personality': personality.text,
        'tone': tone.text,
        'purpose': purpose.text,
        "core_feature": core_fetures.text,
        "response_style": response_style.text,
        "fallback_response": fallback.text,
      };

      try {
        await table.insert(data);
        table
            .select("id")
            .eq('name', name.text)
            .eq('creator', creator.text)
            .eq('personality', personality.text)
            .eq("response_style", response_style.text)
            .eq("fallback_response", fallback.text)
            .then((value) {
          if (value.isNotEmpty) {
            final id = value[0]["id"];
            final domain = value[0]["domain"];
            String share = domain + id;
            url.text = share;
            share_url = share;
          }
        });
        show_snack("created successfully");
      } catch (e) {
        show_snack(e);
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Creating Your Custom Chatbot"),
            content: Center(
              child: TextField(
                enabled: true,
                controller: url,
                decoration: InputDecoration(
                    filled: true,
                    helperText:
                        "share this url with friends of your own chat-bot !",
                    suffix: IconButton(
                        onPressed: () {
                          FlutterClipboard.copy(share_url)
                              .then((value) => show_snack("copied!"));
                        },
                        icon: const Icon(Icons.copy_rounded))),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                }, // Close dialog on button press
                child: const Text('Exit'),
              ),
            ],
          );
        },
      );
    } else {
      show_snack("Fill all the dateils");
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    bool mobile() {
      if (width <= 700) {
        setState(() {});
        return true;
      } else {
        setState(() {});
        return false;
      }
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: height * 0.1,
        actions: [
          mobile()
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      mobileshow = !mobileshow;
                    });
                  },
                  icon: mobileshow
                      ? const Tooltip(
                          message: "Close Chatbot helper",
                          child: Icon(Icons.close_rounded))
                      : const Tooltip(
                          message: "Open Chatbot helper",
                          child: Icon(Icons.message_rounded)))
              : const Text(""),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: FilledButton(
                onPressed: () async {
                  await create(height);
                },
                child: const Text(
                  "Create",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
          ),
        ],
        title: Text(
          'Create Own Bot',
          textScaler: const TextScaler.linear(1.2),
          style: GoogleFonts.truculenta(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: mobile()
            ? Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text("Use Desktop for better experience")],
                  ),
                  Visibility(
                    visible: !mobileshow,
                    child: Center(
                      child: first(height * 0.9, width * 0.9),
                    ),
                  ),
                  Visibility(
                    visible: mobileshow,
                    child: Center(
                      child: second(height * 0.85, width * 0.9),
                    ),
                  ),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  first(height * 0.88, width * 0.6),
                  second(height * 0.88, width * 0.35)
                ],
              ),
      ),
    );
  }

  Widget input(
      String placeholed, String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
            filled: true, hintText: placeholed, helperText: hint),
      ),
    );
  }

  Widget chatbubble(context, index, viewmg) {
    String msg = viewmsg[index]["msg"];
    String role = viewmsg[index]["role"];

    bool check() {
      if (role == "user") {
        return true;
      } else {
        return false;
      }
    }

    return Padding(
      padding: check()
          ? const EdgeInsets.only(left: 50, right: 10, top: 5, bottom: 5)
          : const EdgeInsets.only(left: 10, right: 50, top: 5, bottom: 5),
      child: Center(
        child: Align(
          alignment: check() ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
              padding:
                  const EdgeInsets.only(top: 6, bottom: 6, right: 10, left: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: check()
                      // ? const Color(0xff8b9dc3)
                      ? const Color(0xff55acee)
                      : const Color(0xff3b5998)),
              // : const Color(0xff3b5998)),
              child: MarkdownBlock(
                data: msg,
              )),
        ),
      ),
    );
  }

  Widget serachbar() {
    return SearchBar(
      focusNode: node,
      elevation: const MaterialStatePropertyAll(0),
      onSubmitted: (txt) {
        sendmsg();
      },
      controller: chat,
      trailing: [
        IconButton(
            onPressed: () {
              sendmsg();
            },
            icon: const CircleAvatar(child: Icon(Icons.send)))
      ],
    );
  }

  Widget first(height, width) {
    return Card(
      child: SizedBox(
        height: height,
        width: width,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Fill-up the Deatils",
                      textScaler: TextScaler.linear(1.2),
                    ),
                    IconButton(
                        onPressed: () {
                          showAlertDialog(
                              context, "Fill Up Details Guide", true);
                        },
                        icon: const Icon(Icons.error_outline_outlined))
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                input("Enter the name of your chatbot*",
                    "ex. travel-bot, code-buddy", name),
                input("Enter your name*", "ex. John, Smith", creator),
                input("Enter the personality type of your chatbot*",
                    "ex. Friendly, Professional", personality),
                input("Enter the tone of your chatbot*", "ex. Casual, Formal",
                    tone),
                input(
                    "Enter the primary purpose of your chatbot*",
                    "ex. Providing information of travel, code examples",
                    purpose),
                input(
                    "Enter the core feature of your chatbot*",
                    "ex. Answering travel queries, Scheduling appointments",
                    core_fetures),
                input("Enter the response style of your chatbot*",
                    "ex. Short, Detailed", response_style),
                input("Enter the fallback response of your chatbot*",
                    "ex. I'm sorry, I didn't get that. ", fallback),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget second(height, width) {
    return Card(
      child: SizedBox(
        width: width,
        height: height,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, right: 20, left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Converse AI helping bot",
                      textScaler: const TextScaler.linear(1.5),
                      style:
                          GoogleFonts.truculenta(fontWeight: FontWeight.w600)),
                  IconButton(
                      onPressed: () {
                        showAlertDialog(
                            context, "Converse Helper Guide", false);
                      },
                      icon: const Icon(Icons.error_outline_outlined))
                ],
              ),
            ),
            const Divider(
              thickness: 2,
            ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                reverse: true,
                itemCount: viewmsg.length,
                itemBuilder: (BuildContext context, int index) {
                  return chatbubble(context, index, viewmsg);
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
                padding: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
                child: serachbar()),
            const Padding(
              padding: EdgeInsets.only(bottom: 5, top: 5, right: 15, left: 15),
              child: Text(
                "This is an experimental feature.Please review your details carefully",
                textScaler: TextScaler.linear(0.7),
              ),
            )
          ],
        ),
      ),
    );
  }
}
