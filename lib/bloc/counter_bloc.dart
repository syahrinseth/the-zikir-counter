import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:the_zikir_app/data/models/counter.dart';
import 'package:the_zikir_app/event/counter_event.dart';
import 'package:the_zikir_app/state/counter_state.dart';
import 'package:soundpool/soundpool.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  Soundpool pool = Soundpool.fromOptions(
      options: SoundpoolOptions(streamType: StreamType.notification));
  late int soundId;
  Soundpool poolSuccess = Soundpool.fromOptions(
      options: SoundpoolOptions(streamType: StreamType.notification));
  late int soundIdSuccess;
  late bool canVibrate;
  CounterBloc() : super(CounterInitialize()) {
    on<CounterInit>(counterInit);
    on<CounterPlaySound>(counterPlaySound);
    on<CounterCreate>(counterCreate);
    on<CounterGetAll>(counterGetAll);
    on<CounterGetByIndex>(counterGetByIndex);
    on<CounterGetById>(counterGetById);
    on<CounterIncrement>(counterIncrement);
    on<CounterDecrement>(counterDecrement);
    on<CounterReset>(counterReset);
    on<CounterToggleVibration>(counterToggleVibration);
    on<CounterToggleSound>(counterToggleSound);
    on<CounterUpdate>(counterUpdate);
    on<CounterDelete>(counterDelete);
    on<CounterGetWeekReport>(counterGetWeekReport);
    on<CounterGetMonthReport>(counterGetMonthReport);
    on<CounterGetYearReport>(counterGetYearReport);
    on<CounterGetDayReport>(counterGetDayReport);
    on<CounterDayReportPrev>(counterDayReportPrev);
    on<CounterDayReportNext>(counterDayReportNext);
    on<CounterGoalAchieved>(counterGoalAchieved);
    on<CounterPlayGoalAchievementSound>(counterPlayGoalAchievementSound);
  }

  void counterInit(CounterInit event, Emitter<CounterState> emit) async {
    try {
      soundId = await loadSound();
      soundIdSuccess = await loadSound(soundName: 'success');
      canVibrate = await Vibrate.canVibrate;
    } catch (e) {
      emit(CounterError(message: e.toString()));
    }
  }

  void counterPlaySound(CounterPlaySound event, Emitter<CounterState> emit) {
    try {
      playSound();
    } catch (e) {
      emit(CounterError(message: e.toString()));
    }
  }

  void counterCreate(CounterCreate event, Emitter<CounterState> emit) {
    try {
      emit(CounterLoading());
      Counter counter = Counter.createFromJson({});
      Box<Counter> countersBox = Hive.box<Counter>('myZikirCountersBox');
      countersBox.put(counter.id, counter);
      emit(CounterLoaded(counter: counter));
    } catch (err) {
      emit(CounterError(message: err.toString()));
    }
  }

  void counterGetAll(CounterGetAll event, Emitter<CounterState> emit) {
    try {
      emit(CounterLoading());
      Box<Counter> countersBox = Hive.box<Counter>('myZikirCountersBox');
      List<Counter> counters = [];
      for (var i = 0; i < countersBox.length; i++) {
        Counter? tempCounter = countersBox.getAt(i);
        if (tempCounter != null) {
          counters.add(tempCounter);
        }
        counters.sort((a, b) {
          return b.updatedAt!.compareTo(a.updatedAt ?? DateTime.now());
        });
      }
      emit(CounterLoaded(counters: counters));
    } catch (err) {
      emit(CounterError(message: err.toString()));
    }
  }

  void counterGetByIndex(CounterGetByIndex event, Emitter<CounterState> emit) {
    try {
      emit(CounterLoading());
      Box<Counter> countersBox = Hive.box<Counter>('myZikirCountersBox');
      Counter counter = countersBox.get(event.index) ?? Counter.fromJson({});
      emit(CounterLoaded(counter: counter));
    } catch (err) {
      emit(CounterError(message: err.toString()));
    }
  }

  void counterGetById(CounterGetById event, Emitter<CounterState> emit) {
    try {
      emit(CounterLoading());
      Box<Counter> countersBox = Hive.box<Counter>('myZikirCountersBox');
      Counter counter = countersBox.get(event.id) ?? Counter.fromJson({});
      emit(CounterLoaded(counter: counter));
    } catch (err) {
      emit(CounterError(message: err.toString()));
    }
  }

  void counterIncrement(CounterIncrement event, Emitter<CounterState> emit) {
    try {
      emit(CounterLoading());
      event.counter.counter = (event.counter.counter ?? 0) + 1;
      event.counter.histories
          ?.add(CounterHistory(counter: 1, dateTime: DateTime.now()));
      event.counter.updatedAt = DateTime.now();
      playSound(counter: event.counter);
      lightVibrate(event.counter);
      Counter.saveCounter(counter: event.counter);
      emit(CounterLoaded(counter: event.counter));
    } catch (err) {
      emit(CounterError(message: err.toString()));
    }
  }

  void counterGoalAchieved(
      CounterGoalAchieved event, Emitter<CounterState> emit) {
    try {
      emit(CounterLoading());
      event.counter.goalAchieved = true;
      Counter.saveCounter(counter: event.counter);
      emit(CounterLoaded(counter: event.counter));
    } catch (err) {
      emit(CounterError(message: err.toString()));
    }
  }

  void counterDecrement(CounterDecrement event, Emitter<CounterState> emit) {
    try {
      emit(CounterLoading());
      if ((event.counter.counter ?? 0) > 0) {
        event.counter.counter = (event.counter.counter ?? 0) - 1;
        event.counter.updatedAt = DateTime.now();
        event.counter.histories?.removeLast();
        Counter.saveCounter(counter: event.counter);
      }
      emit(CounterLoaded(counter: event.counter));
    } catch (err) {
      emit(CounterError(message: err.toString()));
    }
  }

  void counterReset(CounterReset event, Emitter<CounterState> emit) {
    try {
      emit(CounterLoading());
      event.counter.counter = 0;
      event.counter.updatedAt = DateTime.now();
      event.counter.histories?.clear();
      Counter.saveCounter(counter: event.counter);
      emit(CounterLoaded(counter: event.counter));
    } catch (err) {
      emit(CounterError(message: err.toString()));
    }
  }

  void counterToggleVibration(
      CounterToggleVibration event, Emitter<CounterState> emit) {
    try {
      emit(CounterLoading());
      event.counter.isSoundOn = event.counter.isSoundOn ? false : true;
      event.counter.updatedAt = DateTime.now();
      playSound(counter: event.counter);
      Counter.saveCounter(counter: event.counter);
      emit(CounterLoaded(counter: event.counter));
    } catch (err) {
      emit(CounterError(message: err.toString()));
    }
  }

  void counterToggleSound(
      CounterToggleSound event, Emitter<CounterState> emit) {
    try {
      emit(CounterLoading());
      event.counter.isSoundOn = event.counter.isSoundOn ? false : true;
      event.counter.updatedAt = DateTime.now();
      playSound(counter: event.counter);
      Counter.saveCounter(counter: event.counter);
      emit(CounterLoaded(counter: event.counter));
    } catch (err) {
      emit(CounterError(message: err.toString()));
    }
  }

  void counterUpdate(CounterUpdate event, Emitter<CounterState> emit) {
    try {
      emit(CounterLoading());
      Box<Counter> countersBox = Hive.box<Counter>('myZikirCountersBox');
      Counter? counter = countersBox.get(event.id);
      if (counter != null) {
        CounterState? counterValidateState = validateInput(
            event.title ?? '',
            event.description ?? '',
            event.counter,
            event.limiter,
            event.counterTheme);
        if (counterValidateState is CounterError) {
          emit(counterValidateState);
        } else {
          // counter.histories?.clear();
          if (counter.counter != event.counter) {
            int tempCount = event.counter - (counter.counter ?? 0);
            if (tempCount >= 0) {
              for (var i = 0; i < tempCount; i++) {
                counter.histories
                    ?.add(CounterHistory(counter: 1, dateTime: DateTime.now()));
              }
            } else {
              tempCount = 0 - tempCount;
              for (var i = 0; i < tempCount; i++) {
                if (counter.histories!.isNotEmpty) {
                  counter.histories?.removeLast();
                }
              }
            }
          }
          counter.name = event.title;
          counter.description = event.description;
          counter.counter = event.counter;
          counter.limiter = event.limiter;
          counter.goalAchieved =
              (counter.counter ?? 0) >= (counter.limiter ?? 1) ? true : false;
          counter.counterTheme = event.counterTheme;
          counter.updatedAt = DateTime.now();
          Counter.saveCounter(counter: counter);
          emit(CounterSaved(counter: counter));
        }
      } else {
        emit(CounterError(message: 'Counter Not Found.'));
      }
      emit(CounterLoaded(counter: counter));
    } catch (err) {
      emit(CounterError(message: err.toString()));
    }
  }

  void counterDelete(CounterDelete event, Emitter<CounterState> emit) {
    try {
      emit(CounterLoading());
      Box<Counter> countersBox = Hive.box<Counter>('myZikirCountersBox');
      countersBox.delete(event.id);
      emit(CounterDeleted());
      emit(CounterLoaded());
    } catch (err) {
      emit(CounterError(message: err.toString()));
    }
  }

  void counterGetWeekReport(
      CounterGetWeekReport event, Emitter<CounterState> emit) {
    try {
      emit(CounterLoading());
      Box<Counter> countersBox = Hive.box<Counter>('myZikirCountersBox');
      List<Counter> counters = [];
      for (var i = 0; i < countersBox.length; i++) {
        Counter? tempCounter = countersBox.getAt(i);
        if (tempCounter != null) {
          counters.add(tempCounter);
        }
      }
      emit(CounterLoaded(
          targetDateTime: event.dateTime,
          weekDetailChartData: Counter.getWeekDetailReport(
              counters: counters,
              dateTime: event.dateTime,
              profileState: event.profileState),
          weekBarChartData: Counter.getWeekReport(
              counters: counters,
              dateTime: event.dateTime,
              profileState: event.profileState),
          totalDhikrs: Counter.getWeekReportTotal(
              counters: counters, dateTime: event.dateTime)));
    } catch (e) {
      emit(CounterError(message: e.toString()));
    }
  }

  void counterGetMonthReport(
      CounterGetMonthReport event, Emitter<CounterState> emit) {
    try {
      emit(CounterLoading());
      Box<Counter> countersBox = Hive.box<Counter>('myZikirCountersBox');
      List<Counter> counters = [];
      for (var i = 0; i < countersBox.length; i++) {
        Counter? tempCounter = countersBox.getAt(i);
        if (tempCounter != null) {
          counters.add(tempCounter);
        }
      }
      emit(CounterLoaded(
          targetDateTime: event.dateTime,
          monthDetailChartData: Counter.getMonthDetailReport(
              counters: counters,
              dateTime: event.dateTime,
              profileState: event.profileState),
          monthBarChartData: Counter.getMonthReport(
              counters: counters,
              dateTime: event.dateTime,
              profileState: event.profileState),
          totalDhikrs: Counter.getMonthReportTotal(
              counters: counters, dateTime: event.dateTime)));
    } catch (e) {
      emit(CounterError(message: e.toString()));
    }
  }

  void counterGetYearReport(
      CounterGetYearReport event, Emitter<CounterState> emit) {
    try {
      emit(CounterLoading());
      Box<Counter> countersBox = Hive.box<Counter>('myZikirCountersBox');
      List<Counter> counters = [];
      for (var i = 0; i < countersBox.length; i++) {
        Counter? tempCounter = countersBox.getAt(i);
        if (tempCounter != null) {
          counters.add(tempCounter);
        }
      }
      emit(CounterLoaded(
          targetDateTime: event.dateTime,
          yearDetailChartData: Counter.getYearDetailReport(
              counters: counters,
              dateTime: event.dateTime,
              profileState: event.profileState),
          yearBarChartData: Counter.getYearReport(
              counters: counters,
              dateTime: event.dateTime,
              profileState: event.profileState),
          totalDhikrs: Counter.getYearReportTotal(
              counters: counters, dateTime: event.dateTime)));
    } catch (e) {
      emit(CounterError(message: e.toString()));
    }
  }

  void counterGetDayReport(
      CounterGetDayReport event, Emitter<CounterState> emit) {
    try {
      emit(CounterLoading());
      Box<Counter> countersBox = Hive.box<Counter>('myZikirCountersBox');
      List<Counter> counters = [];
      for (var i = 0; i < countersBox.length; i++) {
        Counter? tempCounter = countersBox.getAt(i);
        if (tempCounter != null) {
          counters.add(tempCounter);
        }
      }
      emit(CounterLoaded(
          targetDateTime: event.dateTime,
          dayDetailChartData: Counter.getDayDetailReport(
              counters: counters,
              dateTime: event.dateTime,
              profileState: event.profileState),
          dayBarChartData: Counter.getDayReport(
              counters: counters,
              dateTime: event.dateTime,
              profileState: event.profileState),
          totalDhikrs: Counter.getDayReportTotal(
              counters: counters, dateTime: event.dateTime)));
    } catch (e) {
      emit(CounterError(message: e.toString()));
    }
  }

  void counterDayReportPrev(
      CounterDayReportPrev event, Emitter<CounterState> emit) {
    try {
      emit(CounterLoading());
      Box<Counter> countersBox = Hive.box<Counter>('myZikirCountersBox');
      DateTime prevDateTime = event.currentDateTime.subtract(Duration(days: 1));
      List<Counter> counters = [];
      for (var i = 0; i < countersBox.length; i++) {
        Counter? tempCounter = countersBox.getAt(i);
        if (tempCounter != null) {
          counters.add(tempCounter);
        }
      }
      emit(CounterLoaded(
          dayDetailChartData: Counter.getDayDetailReport(
              counters: counters,
              dateTime: prevDateTime,
              profileState: event.profileState),
          dayBarChartData: Counter.getDayReport(
              counters: counters,
              dateTime: prevDateTime,
              profileState: event.profileState),
          targetDateTime: prevDateTime,
          totalDhikrs: Counter.getDayReportTotal(
              counters: counters, dateTime: prevDateTime)));
    } catch (e) {
      emit(CounterError(message: e.toString()));
    }
  }

  void counterDayReportNext(
      CounterDayReportNext event, Emitter<CounterState> emit) {
    try {
      emit(CounterLoading());
      Box<Counter> countersBox = Hive.box<Counter>('myZikirCountersBox');
      DateTime nextDateTime = event.currentDateTime.add(Duration(days: 1));
      List<Counter> counters = [];
      for (var i = 0; i < countersBox.length; i++) {
        Counter? tempCounter = countersBox.getAt(i);
        if (tempCounter != null) {
          counters.add(tempCounter);
        }
      }
      emit(CounterLoaded(
          dayBarChartData: Counter.getDayReport(
              counters: counters,
              dateTime: nextDateTime,
              profileState: event.profileState),
          dayDetailChartData: Counter.getDayDetailReport(
              counters: counters,
              dateTime: nextDateTime,
              profileState: event.profileState),
          targetDateTime: nextDateTime,
          totalDhikrs: Counter.getDayReportTotal(
              counters: counters, dateTime: nextDateTime)));
    } catch (e) {
      emit(CounterError(message: e.toString()));
    }
  }

  void counterPlayGoalAchievementSound(
      CounterPlayGoalAchievementSound event, Emitter<CounterState> emit) async {
    try {
      await poolSuccess.play(soundIdSuccess);
      // lightVibrate(event.counter);
    } catch (err) {
      emit(CounterError(message: err.toString()));
    }
  }

  CounterState? validateInput(String title, String description, int zikirCount,
      int limiter, String counterTheme) {
    // if (limiter < (zikirCount)) {
    //   return CounterError(
    //       message: 'Please put the limiter higher than the actual count.');
    // }
    return null;
  }

  void playSound({Counter? counter}) async {
    if (counter?.isSoundOn ?? true) {
      await pool.play(soundId);
    }
  }

  void lightVibrate(Counter counter) async {
    // Choose from any of these available methods
    if (canVibrate && counter.isVibrationOn) {
      var _type = FeedbackType.heavy;
      Vibrate.feedback(_type);
    }
  }

  void showDialog(
    BuildContext context, {
    required String title,
    required String content,
    required Function onOk,
  }) {}

  Future<int> loadSound({String soundName = 'click'}) async {
    if (soundName == 'click') {
      int soundId = await rootBundle
          .load(
              "assets/sounds/zapsplat_technology_studio_speaker_active_power_switch_click_005_68877.mp3")
          .then((ByteData soundData) {
        return pool.load(soundData);
      });
      return soundId;
    } else {
      int soundId = await rootBundle
          .load("assets/sounds/mixkit-achievement-bell-600.wav")
          .then((ByteData soundData) {
        return poolSuccess.load(soundData);
      });
      return soundId;
    }
  }
}
