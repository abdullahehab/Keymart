import 'dart:async';
import 'dart:convert';
import 'package:kaymarts/constants/app_font_family.dart';
import 'package:kaymarts/models/chat_model.dart';
import 'package:kaymarts/app_localizations.dart';
import 'package:kaymarts/providers/auth_provider.dart';
import 'package:kaymarts/providers/language_provider.dart';
import 'package:kaymarts/services/api_routes.dart';
import 'package:kaymarts/services/api_services.dart';
import 'package:kaymarts/services/chat_api.dart';
import 'package:flutter/material.dart';
import 'package:kaymarts/services/data_app_api.dart';
import 'package:kaymarts/widgets/loading_page.dart';
import 'package:provider/provider.dart';
// import 'package:pusher_websocket_flutter/pusher.dart';
import '../../models/chat_model.dart';
import '../../providers/chat_provider.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _messageController;
  StreamController<List<ChatModel>> _listChatModel =
      StreamController<List<ChatModel>>.broadcast();
  List<ChatModel> listChat = [];
  // Channel _channel;
  String message = "";
  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController(text: "");
    initPusher();
    getChat();
  }

  Future<void> initPusher() async {
    // try {
    //   await Pusher.init(pusherKey, PusherOptions(cluster: "eu"),
    //       enableLogging: true);
    // } catch (e) {
    //   print(e.message);
    // }
    // Pusher.connect(onConnectionStateChange: (val) {
    //   print(val.currentState);
    // }, onError: (err) {
    //   print(err.message);
    // });
    // final authProvider = Provider.of<AuthProvider>(context, listen: false);
    // _channel = await Pusher.subscribe(
    //     'sendMessageToUser.${authProvider.userModel.uid}');
    // _channel.bind('App\\Events\\SendMessageToUser', (onEvent) {
    //   Map<String, dynamic> data = json.decode(onEvent.data);
    //   print(data);
    //   listChat.insert(
    //       0,
    //       ChatModel(
    //           id: data['id'],
    //           photo: data['photo'],
    //           message: data['message'],
    //           isAdmin: data['is_admin'],
    //           seen: data['seen'],
    //           date: data['date']));
    //   _listChatModel.sink.add([]);
    //   _listChatModel.sink.add(listChat);
    // });
  }

  Future<List<ChatModel>> getChat() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final df = new DateFormat('dd-MM-yyyy hh:mm a');

    return await http
        .get(ApiRoutesUpdate().getLink(ApiRoutes.getChat),
            headers: ApiServices.headersData)
        .then((response) {
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        List data = json["data"]["chat"] == "" ? [] : json["data"]["chat"];
        if (data.isEmpty) {
          listChat.insert(
              0,
              ChatModel(
                  id: 10,
                  photo: authProvider.userModel.photoUrl,
                  message: json["message"],
                  isAdmin: 1,
                  seen: 0,
                  date: df.format(DateTime.now()).toString()));
          _listChatModel.sink.add([]);
          _listChatModel.sink.add(listChat);
        }

        data.forEach((element) {
          listChat.insert(
              0,
              ChatModel(
                  id: element['id'],
                  photo: element['photo'],
                  message: element['message'],
                  isAdmin: element['is_admin'],
                  seen: element['seen'],
                  date: element['date']));
          _listChatModel.sink.add([]);
          _listChatModel.sink.add(listChat);
        });
        return data.map((chat) => ChatModel.fromJson(chat)).toList();
      } else {
        throw Exception(
            AppLocalizations.of(context).translate('Failed to load messages'));
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
    _listChatModel.close();
  }

  @override
  Widget build(BuildContext context) {
    final df = new DateFormat('dd-MM-yyyy hh:mm a');
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(.3),
                      offset: Offset(0, 2),
                      blurRadius: 5)
                ],
              ),
              child: CircleAvatar(child: Icon(Icons.person)),
            ),
            SizedBox(width: 15),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context).translate("Admins"),
                  style: TextStyle(
                      fontFamily: languageProvider.appLocale == Locale('en')
                          ? AppFontFamily.jetBrainsMono
                          : AppFontFamily.elMessiri,
                      fontWeight: FontWeight.bold),
                  overflow: TextOverflow.clip,
                ),
              ],
            )
          ],
        ),
        actions: <Widget>[],
      ),
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Column(
              children: <Widget>[
                Expanded(
                    child: StreamBuilder<List<ChatModel>>(
                        stream: _listChatModel.stream,
                        builder: (context, stream) {
                          if (stream.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: loadingPage(context));
                          }
                          if (stream.hasError) {
                            return Center(
                                child: Text(AppLocalizations.of(context)
                                    .translate("No Messages")));
                          }
                          if (stream.connectionState == ConnectionState.none) {
                            return Center(
                                child: Text(AppLocalizations.of(context)
                                    .translate("No Messages")));
                          }
                          List<ChatModel> data = stream.data;
                          return ListView.builder(
                              padding: const EdgeInsets.all(15),
                              reverse: true,
                              shrinkWrap: true,
                              itemCount: data.length,
                              itemBuilder: (ctx, i) {
                                return data[i].isAdmin == 0
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 7.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            Container(
                                                constraints: BoxConstraints(
                                                    maxWidth:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            .6),
                                                padding:
                                                    const EdgeInsets.all(15.0),
                                                decoration: BoxDecoration(
                                                  color: Colors.blue[900],
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(25),
                                                    topRight:
                                                        Radius.circular(25),
                                                    bottomLeft:
                                                        Radius.circular(25),
                                                  ),
                                                ),
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        data[i].message,
                                                        style: TextStyle(
                                                          fontFamily:
                                                              AppFontFamily
                                                                  .elMessiri,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                      Text(data[i].date,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .deepOrangeAccent,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 12))
                                                    ]))
                                          ],
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 7.0),
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: Colors.white,
                                                  width: 3,
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(.3),
                                                      offset: Offset(0, 2),
                                                      blurRadius: 5)
                                                ],
                                              ),
                                              child: Container(
                                                width: 60,
                                                height: 60,
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xff7c94b6),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              60 / 2)),
                                                  border: Border.all(
                                                    color: Colors.blue[900],
                                                    width: 4.0,
                                                  ),
                                                ),
                                                child: ClipOval(
                                                  child: Image.network(
                                                    data[i].photo,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  constraints: BoxConstraints(
                                                      maxWidth:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              .6),
                                                  padding: const EdgeInsets.all(
                                                      15.0),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xfff9f9f9),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(25),
                                                      bottomLeft:
                                                          Radius.circular(25),
                                                      bottomRight:
                                                          Radius.circular(25),
                                                    ),
                                                  ),
                                                  child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          data[i].message,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                AppFontFamily
                                                                    .elMessiri,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.brown,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                        Text(data[i].date,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .deepOrangeAccent,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 12))
                                                      ]),
                                                )
                                              ],
                                            ),
                                            SizedBox(width: 15),
                                          ],
                                        ),
                                      );
                              });
                        })),
                Consumer<ChatProvider>(builder: (context, chatProvider, _) {
                  return !chatProvider.getStatus
                      ? Container(
                          margin: EdgeInsets.all(15.0),
                          height: 61,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                  child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(35.0),
                                  boxShadow: [
                                    BoxShadow(
                                        offset: Offset(0, 3),
                                        blurRadius: 5,
                                        color: Colors.grey)
                                  ],
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Text("     "),
                                    Expanded(
                                      child: TextField(
                                        controller: _messageController,
                                        decoration: InputDecoration(
                                            hintText: AppLocalizations.of(
                                                    context)
                                                .translate("Type Something..."),
                                            border: InputBorder.none),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                              SizedBox(width: 15),
                              Container(
                                padding: const EdgeInsets.all(15.0),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).iconTheme.color,
                                    shape: BoxShape.circle),
                                child: InkWell(
                                    child: Icon(
                                      Icons.send,
                                      color: Colors.white,
                                    ),
                                    onTap: () async {
                                      if (_messageController.text.isNotEmpty) {
                                        final authProvider =
                                            Provider.of<AuthProvider>(context,
                                                listen: false);

                                        listChat.insert(
                                            0,
                                            ChatModel(
                                                id: 25,
                                                photo: authProvider
                                                    .userModel.photoUrl,
                                                message:
                                                    _messageController.text,
                                                isAdmin: 0,
                                                seen: 0,
                                                date: df
                                                    .format(DateTime.now())
                                                    .toString()));
                                        _listChatModel.sink.add([]);
                                        _listChatModel.sink.add(listChat);

                                        ChatModel chatModel = ChatModel(
                                            message: _messageController.text);
                                        _messageController.clear();
                                        await createChat(context, chatModel);
                                      }
                                    }),
                              )
                            ],
                          ),
                        )
                      : Container();
                })
              ],
            ),
          ),
        ],
      ),
    );
  }
}
