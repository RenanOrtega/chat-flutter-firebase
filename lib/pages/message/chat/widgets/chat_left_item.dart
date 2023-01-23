import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/entities/entities.dart';

Widget ChatLefttItem(MessageContent item) {
  return Container(
    padding: EdgeInsets.only(top: 10.w, left: 15.w, right: 15.w, bottom: 10.w),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 230.w,
            minHeight: 40.w,
          ),
          child: Container(
            margin: EdgeInsets.only(right: 10.w, top: 0.w),
            padding: EdgeInsets.only(top: 10.w, left: 10.w, right: 10.w),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(100, 120, 110, 100),
                  Color.fromARGB(100, 100, 90, 100),
                  Color.fromARGB(100, 80, 70, 100),
                  Color.fromARGB(100, 60, 50, 100),
                ],
                transform: GradientRotation(90),
              ),
              borderRadius: BorderRadius.all(Radius.circular(10.w)),
            ),
            child: item.type == "text"
                ? Text("${item.content}")
                : ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 90.w,
                    ),
                    child: GestureDetector(
                      onTap: () {},
                      child: CachedNetworkImage(
                        imageUrl: "${item.content}",
                      ),
                    ),
                  ),
          ),
        )
      ],
    ),
  );
}
