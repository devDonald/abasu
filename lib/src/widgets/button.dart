import 'package:abasu/src/styles/base.dart';
import 'package:abasu/src/styles/buttons.dart';
import 'package:abasu/src/styles/colors.dart';
import 'package:abasu/src/styles/text.dart';
import 'package:flutter/material.dart';

class AppButton extends StatefulWidget {
  final String buttonText;
  final ButtonType buttonType;
  final void Function() onPressed;

  AppButton({@required this.buttonText, this.buttonType, this.onPressed});

  @override
  _AppButtonState createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    TextStyle fontStyle;
    Color buttonColor;

    switch (widget.buttonType) {
      case ButtonType.Straw:
        fontStyle = TextStyles.buttonTextLight;
        buttonColor = AppColors.green;
        break;
      case ButtonType.LightBlue:
        fontStyle = TextStyles.buttonTextLight;
        buttonColor = AppColors.lightblue;
        break;
      case ButtonType.DarkBlue:
        fontStyle = TextStyles.buttonTextLight;
        buttonColor = AppColors.darkblue;
        break;
      case ButtonType.DarkGreen:
        fontStyle = TextStyles.buttonTextLight;
        buttonColor = AppColors.green;
        break;
      case ButtonType.Disabled:
        fontStyle = TextStyles.buttonTextLight;
        buttonColor = AppColors.lightgray;
        break;
      case ButtonType.DarkGray:
        fontStyle = TextStyles.buttonTextLight;
        buttonColor = AppColors.darkgray;
        break;
      default:
        fontStyle = TextStyles.buttonTextLight;
        buttonColor = AppColors.lightblue;
        break;
    }

    return AnimatedContainer(
      padding: EdgeInsets.only(
          top: (pressed)
              ? BaseStyles.listFieldVertical + BaseStyles.animationOffset
              : BaseStyles.listFieldVertical,
          bottom: (pressed)
              ? BaseStyles.listFieldVertical - BaseStyles.animationOffset
              : BaseStyles.listFieldVertical,
          left: BaseStyles.listFieldHorizontal,
          right: BaseStyles.listFieldHorizontal),
      child: GestureDetector(
        child: Container(
          height: ButtonStyles.buttonHeight,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: BorderRadius.circular(BaseStyles.borderRadius),
              boxShadow:
                  pressed ? BaseStyles.boxShadowPressed : BaseStyles.boxShadow),
          child: Center(
              child: Text(
            widget.buttonText,
            style: fontStyle,
          )),
        ),
        onTapDown: (details) {
          setState(() {
            if (widget.buttonType != ButtonType.Disabled) pressed = !pressed;
          });
        },
        onTapUp: (details) {
          setState(() {
            if (widget.buttonType != ButtonType.Disabled) pressed = !pressed;
          });
        },
        onTap: () {
          if (widget.buttonType != ButtonType.Disabled) {
            widget.onPressed();
          }
        },
      ),
      duration: Duration(milliseconds: 20),
    );
  }
}

enum ButtonType { LightBlue, Straw, Disabled, DarkGray, DarkBlue, DarkGreen }

//Primary Button

//Social Button

class NotificationsCounter extends StatefulWidget {
  const NotificationsCounter({
    this.onTap,
    this.count,
  });
  final Function onTap;
  final int count;

  @override
  _NotificationsCounterState createState() => _NotificationsCounterState();
}

class _NotificationsCounterState extends State<NotificationsCounter> {
  @override
  void initState() {
    checkIfNottification(); //call this when recieved notti
    super.initState();
  }

  int counter = 310;
  String counter100 = '99';
  bool isNottiCount = true;
  bool isCountAbove100 = false;
  checkIfNottification() {
    if (widget.count <= 0) {
      setState(() {
        isNottiCount = false;
      });
    }
    if (widget.count >= 100) {
      setState(() {
        isCountAbove100 = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 15.0),
      // padding: EdgeInsets.all(8.0),
      width: 36.5,
      height: 36.5,
      child: Material(
        shape: CircleBorder(),
        clipBehavior: Clip.hardEdge,
        color: kGreyColor.withOpacity(0.05),
        child: Container(
          padding: EdgeInsets.all(0),
          child: InkWell(
            child: Center(
              child: Stack(
                children: <Widget>[
                  Icon(
                    Icons.notifications,
                    size: 30.0,
                    color: Colors.black,
                  ),
                  Positioned(
                    left: 10,
                    child: isNottiCount
                        ? Container(
                            width: 21.5,
                            height: 21.5,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.red,
                              ),
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(0.5),
                                child: Text(
                                  isCountAbove100
                                      ? counter100
                                      : widget.count.toString(),
                                  style: TextStyle(
                                    color: kWhiteColor,
                                    fontWeight: kBold,
                                    fontSize: 10.0,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(),
                  ),
                ],
              ),
            ),
            onTap: widget.onTap,
          ),
        ),
      ),
    );
  }
}

class ChatCounter extends StatefulWidget {
  const ChatCounter({
    this.onTap,
    this.count,
  });
  final Function onTap;
  final int count;

  @override
  _NotificationsCounterState createState() => _NotificationsCounterState();
}

class _ChatCounterState extends State<ChatCounter> {
  @override
  void initState() {
    checkIfNottification(); //call this when recieved notti
    super.initState();
  }

  int counter = 310;
  String counter100 = '99';
  bool isNottiCount = true;
  bool isCountAbove100 = false;
  checkIfNottification() {
    if (widget.count <= 0) {
      setState(() {
        isNottiCount = false;
      });
    }
    if (widget.count >= 100) {
      setState(() {
        isCountAbove100 = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 15.0),
      // padding: EdgeInsets.all(8.0),
      width: 36.5,
      height: 36.5,
      child: Material(
        shape: CircleBorder(),
        clipBehavior: Clip.hardEdge,
        color: kGreyColor.withOpacity(0.05),
        child: Container(
          padding: EdgeInsets.all(0),
          child: InkWell(
            child: Center(
              child: Stack(
                children: <Widget>[
                  Icon(
                    Icons.chat,
                    size: 30.0,
                  ),
                  Positioned(
                    left: 10,
                    child: isNottiCount
                        ? Container(
                            width: 21.5,
                            height: 21.5,
                            decoration: BoxDecoration(
                              color: kButtonsOrange,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: kWhiteColor,
                              ),
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(0.5),
                                child: Text(
                                  isCountAbove100
                                      ? counter100
                                      : widget.count.toString(),
                                  style: TextStyle(
                                    color: kWhiteColor,
                                    fontWeight: kBold,
                                    fontSize: 10.0,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(),
                  ),
                ],
              ),
            ),
            onTap: widget.onTap,
          ),
        ),
      ),
    );
  }
}

//AppBar Icons
class AppBarIcon extends StatelessWidget {
  const AppBarIcon({
    this.onTap,
    this.icon,
  });
  final Function onTap;
  final Widget icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 15.0),
      width: 36.5,
      height: 36.5,
      child: Material(
        shape: CircleBorder(),
        clipBehavior: Clip.hardEdge,
        color: kGreyColor.withOpacity(0.05),
        child: InkWell(
          child: icon,
          onTap: onTap,
        ),
      ),
    );
  }
}

class AttachedPhotoButton extends StatelessWidget {
  const AttachedPhotoButton({
    Key key,
    this.onTap,
    this.color,
  }) : super(key: key);
  final Function onTap;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Row(
          children: <Widget>[
            Icon(
              Icons.photo,
              size: 12.0,
              color: color ?? kGreyColor,
            ),
            SizedBox(width: 5.0),
            Text(
              'View Attached Photo',
              style: TextStyle(
                fontSize: 9.0,
                color: color ?? kGreyColor, //
              ),
            ),
          ],
        ),
      ),
    );
  }
}
//outline button

class DiscussOutlineButton extends StatelessWidget {
  const DiscussOutlineButton({
    Key key,
    @required this.child,
    @required this.onTap,
  }) : super(key: key);
  final Function onTap;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(
          left: 8.0,
          right: 8.0,
          top: 14.0,
          bottom: 14.0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(
            color: kGreyColor,
          ),
        ),
        child: child,
      ),
    );
  }
}

//popUpButton
class JanguAskPopUpMenu extends StatelessWidget {
  const JanguAskPopUpMenu({
    Key key,
    this.onSelect,
  }) : super(key: key);
  final Function onSelect;
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) {
        var list = List<PopupMenuEntry<Object>>();
        list.add(
          PopupMenuItem(
            child: Row(
              children: [
                Icon(
                  Icons.edit,
                  size: 17,
                  color: kGreyColor,
                ),
                SizedBox(width: 8),
                Text(
                  "Edit",
                  style: TextStyle(
                    color: kGreyColor,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
            value: 1,
          ),
        );
        list.add(
          PopupMenuDivider(
            height: 8,
          ),
        );
        list.add(
          PopupMenuItem(
            child: Row(
              children: [
                Icon(
                  Icons.delete,
                  size: 17,
                  color: kGreyColor,
                ),
                SizedBox(width: 8),
                Text(
                  "Delete",
                  style: TextStyle(
                    color: kGreyColor,
                    fontSize: 17,
                  ),
                )
              ],
            ),
            value: 2,
          ),
        );
        return list;
      },
      icon: Icon(
        Icons.more_horiz,
        size: 20,
        color: kGreyColor,
      ),
      onSelected: onSelect,
    );
  }
}

//pop up delete only
class JanguAskDeleteDialog extends StatelessWidget {
  const JanguAskDeleteDialog({
    Key key,
    this.onSelect,
  }) : super(key: key);
  final Function onSelect;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) {
        var list = List<PopupMenuEntry<Object>>();
        list.add(
          PopupMenuItem(
            child: Row(
              children: [
                Icon(
                  Icons.delete,
                  size: 17,
                  color: kGreyColor,
                ),
                SizedBox(width: 8),
                Text(
                  "Delete",
                  style: TextStyle(
                    color: kGreyColor,
                    fontSize: 17,
                  ),
                )
              ],
            ),
            value: 2,
          ),
        );
        return list;
      },
      icon: Icon(
        Icons.more_horiz,
        size: 20,
        color: kGreyColor,
      ),
      onSelected: onSelect,
    );
  }
}
//Top NAvBar titles

class AbasuNavBrand extends StatelessWidget {
  const AbasuNavBrand({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AbasuLogo(
      width: 15.0,
      height: 18.6,
    );
  }
}

class EventButton extends StatelessWidget {
  const EventButton({
    Key key,
    this.icon,
    this.title,
    this.onTap,
  }) : super(key: key);
  final IconData icon;
  final String title;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      margin: EdgeInsets.only(
        top: 8.5,
        bottom: 8.5,
      ),
      padding: EdgeInsets.only(left: 15.0),
      decoration: BoxDecoration(
        color: kButtonsOrange,
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: [
          BoxShadow(
            color: kShadowColor,
            offset: Offset(0.0, 2.5),
            blurRadius: 7.5,
          ),
        ],
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          child: Row(
            children: <Widget>[
              Icon(
                icon,
                color: kWhiteColor,
              ),
              SizedBox(width: 9.2),
              Text(
                title,
                style: TextStyle(
                  color: kWhiteColor,
                  fontSize: 15.0,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
