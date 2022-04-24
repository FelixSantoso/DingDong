import 'package:ding_dong/models/chat.dart';
import 'package:ding_dong/screen/home/chat_tile.dart';
import 'package:ding_dong/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ChatList extends StatefulWidget {
  final String myId;
  bool isPressed;
  ChatList({Key? key, required this.myId, required this.isPressed})
      : super(key: key);

  @override
  State<ChatList> createState() => ChatListState();
}

class ChatListState extends State<ChatList> {
  final ScrollController _scrollController = ScrollController();
  final itemScrollController = ItemScrollController();
  final itemPositionListener = ItemPositionsListener.create();

  bool alreadyBottom = false;

  _srollToEnd() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: Duration(microseconds: 100), curve: Curves.easeOut);
    alreadyBottom = true;
  }

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance
        ?.addPostFrameCallback((timeStamp) => _srollToEnd());
    // if (_scrollController.hasClients) {
    //   if (_scrollController.position.atEdge) {
    //     if (_scrollController.position.pixels == 0) {
    //       if (alreadyBottom == false) {
    //         SchedulerBinding.instance
    //             ?.addPostFrameCallback((timeStamp) => _srollToEnd());
    //       }
    //     } else {
    //       SchedulerBinding.instance
    //           ?.addPostFrameCallback((timeStamp) => _srollToEnd());
    //     }
    //   }
    // }
    // if (widget.isPressed == true) {
    //   if (_scrollController.hasClients) {
    //     if (_scrollController.position.atEdge) {
    //       if (_scrollController.position.pixels == 0) {
    //         SchedulerBinding.instance
    //             ?.addPostFrameCallback((timeStamp) => _srollToEnd());
    //         setState(() {
    //           widget.isPressed = false;
    //         });
    //         print('${widget.isPressed}');
    //       }
    //     } else {
    //       SchedulerBinding.instance
    //           ?.addPostFrameCallback((timeStamp) => _srollToEnd());
    //       setState(() {
    //         widget.isPressed = false;
    //       });
    //       print('${widget.isPressed}');
    //     }
    //   }
    // }

    final chat = Provider.of<List<Chat>>(context);

    // return KeyboardDismissOnTap(
    //   child: widget.myId.isNotEmpty
    //       ? ScrollablePositionedList.builder(
    //           shrinkWrap: true,
    //           itemScrollController: itemScrollController,
    //           itemPositionsListener: itemPositionListener,
    //           itemCount: chat.length,
    //           itemBuilder: (context, index) {
    //             return ChatTile(chat: chat[index], myId: widget.myId);
    //           })
    //       : const Loading2(),
    //);
    return KeyboardDismissOnTap(
        child: widget.myId.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                controller: _scrollController,
                itemCount: chat.length,
                itemBuilder: (context, index) {
                  return ChatTile(
                    chat: chat[index],
                    myId: widget.myId,
                  );
                },
              )
            : const Loading2());
  }
}
