# Project 10 - WakyZzz

## WakyZzz is an iOS app, used for learning iOS on OpenClassrooms.com

## Context

Imagine that you are a part of a development agency. There are numerous projects in progress at the same time, deadlines are shifting, and priorities change. Your team lead tells you that one of the clients requires that their app be completed ASAP. The original developer is no longer with the company, and everyone else has too much on their plates, so the only person who can help is YOU!
The client also intends to continue development in-house after the completion of the current development phase. Therefore, they require the code to be in perfect form and accompanied by technical documentation.
You fetch the source code from the Repository. It’s a fancy alarm clock app called "WakyZzz". It's primary views are drafted. You realize that the app was definitely created in a hurry because there aren't any unit tests and it doesn’t even have comments.
Your team lead vaguely remembers what the project was about and helps you identify the app requirements.


## App Requirements

The app must allow the user to set, modify, and delete multiple alarms. Each alarm entry may be set on ‘repeat mode’ for any day of the week.
When the alarm goes off, the user will have an option to "snooze" the alarm. After each "snooze" action, the alarm will pause for 1 minute, and then it will ring at a higher volume. After a user requests to snooze 2 times, the app will play an "evil" alarm sound (you are encouraged to choose your own sound).
Here's a twist! When the "evil" sounds starts playing, the only way to turn if off is to execute a given task.  In our case, it will be a random act of kindness.
A Random Act of Kindness will be selected from a list of preset items, such as:
* Message a friend asking how they are doing
* Connect with a family member by expressing a kind thought

The user then will be presented with an option to mark the task as "completed" or promise to do it later.
If the user choses a "promise" option, the app will set up a local notification to remind the user of the promise.


## Message from the client

Luckily, in addition to what you managed to gather in house, you got a message from the client that indicates some errors in current implementations as well as missing functionality:

> “Hello awesome team!
> Here are a number of things we’ve discovered that need resolution:
> When clicking on + icon to add a new alarm, the view should present 8am set by default, however, it show an incorrect value.
> When clicking on ‘Delete’ option on a row action for an existing alarm, the app is crashing.
> After adding a new alam, the new alarm is being appended at the end of the list, however, it should be inserted according to the alarm time, so that the list appears in ascending order sorted by alarm times.
> After editing the time in an existing alarm, the time gets updated, however the alarm keeps its original position on the list even if the new time requires change of order.
> The alarms have not been implemented at all, they must be set accordingly to the user’s indications:
> * current enabled alarms for the indicated days of the week
> * when user disables/enables existing alarms
> * after user adds a new alarm
> * after user modifies an existing alarm
> * after user deletes an  existing alarm
> There’s also no implementation for the random act of kindness request. The feature is missing all the supporting code unfortunately.
> We are hoping you’ll be able to assist us with the remaining tasks and we can handle it from there within our new in-house team of developers.
> Thank you for all your amazing work and we look forward to the update.
> Cheers,
> Joe, Founder of FunkyStartupWithAnAwesomeIdea.”

## Skills

* Produce technical and functional documentation for the application
* Complete a suite of unit and integration tests to reflect changes made
* Correct application faults reported by the customer
* Provide feature enhancements requested by the customer