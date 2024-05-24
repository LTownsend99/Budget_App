import 'package:budget_app/graphs/individual_bar.dart';

class BarData
{
  final double mondayAmount;
  final double tuesdayAmount;
  final double wednesdayAmount;
  final double thursdayAmount;
  final double fridayAmount;
  final double saturdayAmount;
  final double sundayAmount;

  BarData({
    required this.mondayAmount,
    required this.tuesdayAmount,
    required this.wednesdayAmount,
    required this.thursdayAmount,
    required this.fridayAmount,
    required this.saturdayAmount,
    required this.sundayAmount
});

  List<IndividualBar> barData = [];

  void initializeBarData()
  {
    barData = [
      //Monday
      IndividualBar(x: 0, y: mondayAmount),

      //Tuesday
      IndividualBar(x: 1, y: tuesdayAmount),

      //Wednesday
      IndividualBar(x: 2, y: wednesdayAmount),

      //Thursday
      IndividualBar(x: 3, y: thursdayAmount),

      //Friday
      IndividualBar(x: 4, y: fridayAmount),

      //Saturday
      IndividualBar(x: 5, y: saturdayAmount),

      //Sunday
      IndividualBar(x: 6, y: sundayAmount)
    ];
  }
}