import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';

void main() {
  runApp(FitnessApp());
}

class FitnessApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fitness Tracker',
      theme: ThemeData(primarySwatch: Colors.green),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Stream<StepCount> _stepCountStream;

  int steps = 0;
  int goal = 5000;
  int calories = 0;

  @override
  void initState() {
    super.initState();
    startListening();
  }

  void startListening() {
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onError);
  }

  void onStepCount(StepCount event) {
    setState(() {
      steps = event.steps;
      calories = (steps * 0.04).toInt();
    });
  }

  void onError(error) {
    print("Step Count Error: $error");
  }

  double get progress => steps / goal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fitness Tracker"),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade400, Colors.green.shade900],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // Title
              Text(
                "Today's Steps",
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),

              SizedBox(height: 20),

              // Step Circle
              Container(
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 10)
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      "$steps",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("Steps"),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // Calories Card
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                elevation: 5,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text("Calories Burned",
                          style: TextStyle(fontSize: 18)),
                      SizedBox(height: 10),
                      Text(
                        "$calories kcal",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Goal Card
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                elevation: 5,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text("Daily Goal",
                          style: TextStyle(fontSize: 18)),
                      SizedBox(height: 10),
                      LinearProgressIndicator(
                        value: progress > 1 ? 1 : progress,
                        minHeight: 10,
                      ),
                      SizedBox(height: 10),
                      Text("$steps / $goal steps"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}