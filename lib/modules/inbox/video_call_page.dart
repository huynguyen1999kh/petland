import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as LocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RemoteView;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:petland/modules/inbox/inbox_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:petland/navigator.dart';

import 'app_id.dart';
import 'import/page_builder.dart';


/// MultiChannel Example
class VideoCallPage extends StatefulWidget {
  final String groupId;
  final List<FbInboxUserModel> users;

  const VideoCallPage({Key key, this.groupId, this.users}) : super(key: key);
  static Future navigate(String groupId, List<FbInboxUserModel> users) {
    return navigatorKey.currentState
        .push(pageBuilder(VideoCallPage(groupId: groupId, users: users)));
  }

  @override
  State<StatefulWidget> createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  RtcEngine _engine;
  static final _users = List<int>();
  final _infoStrings = <String>[];
  bool muted = false;
  bool isJoined = false, switchCamera = true, switchRender = true;

  @override
  void dispose() {
    // clear users
    _users?.clear();
    // destroy sdk
    _engine?.leaveChannel();
    _engine?.destroy();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    if (APP_ID.isEmpty) {
      setState(() {
        _infoStrings
            .add("APP_ID missing, please provide your APP_ID in settings.dart");
        _infoStrings.add("Agora Engine is not starting");
      });
      return;
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      await [Permission.microphone, Permission.camera].request();
    }

    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    // set parameters for Agora Engine
    _engine.setParameters('{\"che.video.lowBitRateStreamParameter\"' +
        ':{\"width\":320,\"height\":180,\"frameRate\":15,\"bitRate\":140}}');
    // join channel corresponding to current group
    _engine.joinChannel(null, widget.groupId, null, 0);
  }

  /// Create agora sdk instance and initialze
  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.create(APP_ID);
    await _engine.enableVideo();
    await _engine.startPreview();
    await _engine.setChannelProfile(ChannelProfile.Communication);
    await _engine.setClientRole(ClientRole.Broadcaster);
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    _engine?.setEventHandler(RtcEngineEventHandler(
      joinChannelSuccess: (channel, uid, elapsed) {
        print('joinChannelSuccess $channel $uid $elapsed');
        setState(() {
          isJoined = true;
        });
      },
      userJoined: (uid, elapsed) {
        print('userJoined  $uid $elapsed');
        setState(() {
          _users.add(uid);
        });
      },
      userOffline: (uid, reason) {
        print('userOffline  $uid $reason');
        setState(() {
          _users.removeWhere((element) => element == uid);
        });
      },
      leaveChannel: (stats) {
        print('leaveChannel ${stats.toJson()}');
        setState(() {
          isJoined = false;
          _users.clear();
        });
      },
    ));
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    List<Widget> list = [LocalView.SurfaceView(channelId: widget.groupId)];
    _users.forEach((int uid) => {
          list.add(RemoteView.SurfaceView(uid: uid, channelId: widget.groupId))
        });
    return list;
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    List<Widget> wrappedViews =
        views.map((Widget view) => _videoView(view)).toList();
    return Expanded(
        child: Row(
      children: wrappedViews,
    ));
  }

  /// Video layout wrapper
  Widget _viewRows() {
    List<Widget> views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Container(
            child: Column(
          children: <Widget>[_videoView(views[0])],
        ));
      case 2:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow([views[0]]),
            _expandedVideoRow([views[1]])
          ],
        ));
      case 3:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 3))
          ],
        ));
      case 4:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 4))
          ],
        ));
      default:
    }
    return Container();
  }

  /// Toolbar layout
  Widget _toolbar() {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topRight,
            padding: EdgeInsets.symmetric(vertical: 48),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                RawMaterialButton(
                  onPressed: () => _onToggleMute(),
                  child: Icon(
                    muted ? Icons.mic_off : Icons.mic,
                    color: muted ? Colors.blueAccent : Colors.white,
                    size: 20.0,
                  ),
                  shape: CircleBorder(),
                  elevation: 2.0,
                  fillColor: muted ? Colors.white : Colors.blueAccent,
                  padding: const EdgeInsets.all(12.0),
                ),
                SizedBox(
                  height: 10,
                ),
                RawMaterialButton(
                  onPressed: () => _onSwitchCamera(),
                  child: Icon(
                    Icons.switch_camera,
                    color: Colors.blueAccent,
                    size: 20.0,
                  ),
                  shape: CircleBorder(),
                  elevation: 2.0,
                  fillColor: Colors.white,
                  padding: const EdgeInsets.all(12.0),
                ),
                SizedBox(
                  height: 10,
                ),
                RawMaterialButton(
                  onPressed: () => navigatorKey.currentState.maybePop(),
                  child: Icon(
                    Icons.phone,
                    color: Colors.white,
                    size: 20.0,
                  ),
                  shape: CircleBorder(),
                  elevation: 2.0,
                  fillColor: Colors.red,
                  padding: const EdgeInsets.all(12.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Info panel to show prints
  Widget _panel() {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 48),
        alignment: Alignment.bottomCenter,
        child: FractionallySizedBox(
          heightFactor: 0.5,
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 48),
              child: ListView.builder(
                  reverse: true,
                  itemCount: _infoStrings.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (_infoStrings.length == 0) {
                      return null;
                    }
                    return Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          Flexible(
                              child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 5),
                                  decoration: BoxDecoration(
                                      color: Colors.yellowAccent,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Text(_infoStrings[index],
                                      style:
                                          TextStyle(color: Colors.blueGrey))))
                        ]));
                  })),
        ));
  }

  void _onCallEnd(BuildContext context) {
    Navigator.pop(context);
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() {
    _engine.switchCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
            child: Stack(
          //uncomment _panel for debugging
          children: <Widget>[_viewRows(), _toolbar()],
        )));
  }
}
