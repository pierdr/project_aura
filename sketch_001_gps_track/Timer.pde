// Learning Processing
// Daniel Shiffman
// http://www.learningprocessing.com
/**
 * @modified by Pierluigi Dalla Rosa
 */
class Timer {
 
  int savedTime; // When Timer started
  int totalTime; // How long Timer should last
  private String action;
  boolean active=false;
  
  Timer(int tempTotalTime, String action) {
    totalTime = tempTotalTime;
    this.action=action;
    start();
  }
  
  // Starting the timer
  void start() {
    //set the timer active
    active=true;
    // When the timer starts it stores the current time in milliseconds.
    savedTime = millis(); 
  }
  
  // The function isFinished() returns true if 5,000 ms have passed. 
  // The work of the timer is farmed out to this method.
  boolean isFinished() { 
    // Check how much time has passed
    int passedTime = millis()- savedTime;
    if (passedTime > totalTime) {
      active=false;
      return true;
    } else {
      return false;
    }
  }
  
  String getAction()
  {
    return action;
  }
  //The function notify if the timer is running
  //if you want to bring the last active state you have to call isRunning before isFinished
  boolean isRunning()
  {
    return active;
  }
}

