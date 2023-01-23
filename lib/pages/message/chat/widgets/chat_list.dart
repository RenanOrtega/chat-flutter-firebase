import 'package:chat_flutter_firebase/pages/message/chat/widgets/chat_left_item.dart';
import 'package:chat_flutter_firebase/pages/message/chat/widgets/chat_right_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../common/values/values.dart';
import '../controller.dart';

class ChatList extends GetView<ChatController> {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        color: AppColors.chatbg,
        padding: EdgeInsets.only(bottom: 50.h),
        child: CustomScrollView(
          reverse: true,
          controller: controller.messageScrolling,
          slivers: [
            SliverPadding(
              padding: EdgeInsets.symmetric(vertical: 0.w, horizontal: 0.w),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                  var item = controller.state.messageContentList[index];

                  if (controller.userId == item.uid) {
                    return ChatRightItem(item);
                  }
                  return ChatLefttItem(item);
                }, childCount: controller.state.messageContentList.length),
              ),
            )
          ],
        ),
      ),
    );
  }
}
