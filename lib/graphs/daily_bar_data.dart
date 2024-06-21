import 'package:budget_app/graphs/daily_individual_bar.dart';

class DailyBarData
{
  final double mondayAmount;
  final double tuesdayAmount;
  final double wednesdayAmount;
  final double thursdayAmount;
  final double fridayAmount;
  final double saturdayAmount;
  final double sundayAmount;

  DailyBarData({
    required this.mondayAmount,
    required this.tuesdayAmount,
    required this.wednesdayAmount,
    required this.thursdayAmount,
    required this.fridayAmount,
    required this.saturdayAmount,
    required this.sundayAmount
});

  List<DailyIndividualBar> barData = [];

  void initializeBarData()
  {
    barData = [
      //Monday
      DailyIndividualBar(x: 0, y: mondayAmount),

      //Tuesday
      DailyIndividualBar(x: 1, y: tuesdayAmount),

      //Wednesday
      DailyIndividualBar(x: 2, y: wednesdayAmount),

      //Thursday
      DailyIndividualBar(x: 3, y: thursdayAmount),

      //Friday
      DailyIndividualBar(x: 4, y: fridayAmount),

      //Saturday
      DailyIndividualBar(x: 5, y: saturdayAmount),

      //Sunday
      DailyIndividualBar(x: 6, y: sundayAmount)
    ];
  }
}