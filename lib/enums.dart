library enums;

// 打印机状态
enum LCDCommand {
  initLCD(1),
  wakeLCD(2),
  sleepLCD(3),
  cleanScreenLCD(4);

  final int state;
  const LCDCommand(this.state);
}
