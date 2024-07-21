import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gouantum/screens/calls/data/models/call_model.dart';
import 'package:gouantum/screens/calls/shared/theme.dart';
import 'package:intl/intl.dart';

class CallItemView extends StatelessWidget {
  final CallModel callModel;
  const CallItemView({
    super.key,
    required this.callModel,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      subtitle: Text('${callModel.status}'),
      title: Row(
        children: [
          callModel.otherUser!.avatar.isNotEmpty
              ? CircleAvatar(
                  backgroundColor: defaultColor,
                  radius: 55.0,
                  backgroundImage: CachedNetworkImageProvider(
                    callModel.otherUser!.avatar,
                  ),
                )
              : const Icon(Icons.person),
          const SizedBox(
            width: 10.0,
          ),
          Expanded(child: Text(callModel.otherUser!.name)),
          Text(
            DateFormat('dd/MM/yyyy HH:mm:ss').format(
              DateTime.fromMillisecondsSinceEpoch(
                callModel.createAt!.toInt(),
              ),
            ),
            style: Theme.of(context).textTheme.bodySmall,
          )
        ],
      ),
    );
  }
}
