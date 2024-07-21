class ChatPageArguments {
  final String peerId;
  final String peerAvatar;
  final String peerNickname;
  final String token;
  final num callMinuteCast;

  ChatPageArguments({
    required this.peerId,
    required this.peerAvatar,
    required this.token,
    required this.peerNickname,
    required this.callMinuteCast,
  });
}
