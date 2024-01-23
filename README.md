# imin_vice_screen
A Flutter plugin for using imin vice screen sdk in Android

### Resources:

- [Pub Package](https://pub.dev/packages/imin_vice_screen)
- [GitHub Repository](https://github.com/iminsoftware/imin_vice_screen)

#### Platform Support

| Android |
| :-----: | 
|   ✅   |

## Getting Started

## Installation  

```bash
flutter pub add imin_vice_screen
```
or
Make a reference in the “pubspec.yaml” file
```bash
  dependencies:
    imin_vice_screen: ^0.0.1
```

## Just see the example folder!


## How to use:
Use flutter to draw the main and secondary screens, and use the encapsulation capability to communicate the main and secondary screens:

### 1. Distinguish the main screen from the secondary screen at the main entrance:

```dart
void main() {
  var defaultRouteName = window.defaultRouteName;
  if ("viceMain" == defaultRouteName) {
    viceScreenMain(); 
  } else {
    defaultMain();
  }
}

//主屏ui
void defaultMain() {
  runApp(MainApp());
}

//副屏ui
void viceScreenMain() {
  runApp(SubApp());
}
```

### 2. Use the encapsulation capability to communicate the main and secondary screens:

#### 1.1 mainScreen to subScreen
```dart
  import 'package:imin_vice_screen/imin_vice_screen.dart';
  final _iminViceScreenPlugin = IminViceScreen();
 /// 1. send Message
  _iminViceScreenPlugin.sendMsgToViceScreen("data", params: {"params": "123"});
 /// 2. receive subScreen Message
 _iminViceScreenPlugin.mainStream.listen((event) {
    print("mainScreen receive data:${event}");
 })

```
### 1.2 subScreen to mainScreen

```dart
  import 'package:imin_vice_screen/imin_vice_screen.dart';
  final _iminViceScreenPlugin = IminViceScreen();
 /// 1. send Message
  _iminViceScreenPlugin.sendMsgToMainScreen("data", params: {"params": "456"});
 /// 2. receive mainScreen Message
  _iminViceScreenPlugin.viceStream.listen((event) {
    print("mainScreen receive data:${event}");
 })

```

### 1.3 (other Methods)  Obtain whether the current device environment supports dual screens
```dart
   bool isSupportMultipleScreen = await _iminViceScreenPlugin.isMultipleScreen();
    print("isSupportMultipleScreen:$isSupportMultipleScreen");
```

### 1.4 (other Methods)  Determine whether the current application has overlay window permissions
```dart
   bool checkOverlayPermission = await _iminViceScreenPlugin.checkOverlayPermission();
    print("checkOverlayPermission:$checkOverlayPermission");
```

### 1.5 (other Methods)  Apply for an overlay window permission to set the secondary screen as a persistent window
```dart
   await _iminViceScreenPlugin.requestOverlayPermission();
```
### 1.6 (other Methods)  Open and close the secondary screen

```dart
   await _iminViceScreenPlugin.doubleScreenOpen(); /// open
   await _iminViceScreenPlugin.doubleScreenClose(); /// close
```

## 3. After the initialization is complete, the secondary screen is displayed
 android -> values -> attrs.xml  Add configuration

```dart
   <!-- 是否在初始化时自动显示副屏 -->
  <bool name="autoShowSubScreenWhenInit">true</bool> 
```
