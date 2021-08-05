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
  CounterBloc() : super(CounterInitialize());

  @override
  Stream<CounterState> mapEventToState(CounterEvent event) async* {
    if (event is CounterInit) {}
    if (event is CounterCreate) {
      try {
        yield CounterLoading();
        Counter counter = Counter.createFromJson({});
        Box<Counter> countersBox = Hive.box<Counter>('myZikirCountersBox');
        countersBox.put(counter.id, counter);
        yield CounterLoaded(counter: counter);
      } catch (err) {
        yield CounterError(message: err.toString());
      }
    }
    if (event is CounterGetAll) {
      try {
        yield CounterLoading();
        Box<Counter> countersBox = Hive.box<Counter>('myZikirCountersBox');
        List<Counter> counters = [];
        for (var i = 0; i < countersBox.length; i++) {
          Counter? tempCounter = countersBox.getAt(i);
          if (tempCounter != null) {
            counters.add(tempCounter);
          }
        }
        yield CounterLoaded(counters: counters);
      } catch (err) {
        yield CounterError(message: err.toString());
      }
    }
    if (event is CounterGetByIndex) {
      try {
        yield CounterLoading();
        Box<Counter> countersBox = Hive.box<Counter>('myZikirCountersBox');
        Counter counter = countersBox.get(event.index) ?? Counter.fromJson({});
        yield CounterLoaded(counter: counter);
      } catch (err) {
        yield CounterError(message: err.toString());
      }
    }
    if (event is CounterGetById) {
      try {
        yield CounterLoading();
        Box<Counter> countersBox = Hive.box<Counter>('myZikirCountersBox');
        Counter counter = countersBox.get(event.id) ?? Counter.fromJson({});
        yield CounterLoaded(counter: counter);
      } catch (err) {
        yield CounterError(message: err.toString());
      }
    }
    if (event is CounterIncrement) {
      try {
        yield CounterLoading();
        event.counter.counter = (event.counter.counter ?? 0) + 1;
        if ((event.counter.counter ?? 0) > (event.counter.limiter ?? 1)) {
          event.counter.limiter = event.counter.counter;
        }
        event.counter.updatedAt = DateTime.now();
        event.counter.histories
            ?.add(CounterHistory(counter: 1, dateTime: DateTime.now()));
        playSound(event.counter);
        lightVibrate(event.counter);
        Counter.saveCounter(counter: event.counter);
        yield CounterLoaded(counter: event.counter);
      } catch (err) {
        yield CounterError(message: err.toString());
      }
    }
    if (event is CounterDecrement) {
      try {
        yield CounterLoading();
        if ((event.counter.counter ?? 0) > 0) {
          event.counter.counter = (event.counter.counter ?? 0) - 1;
          event.counter.updatedAt = DateTime.now();
          event.counter.histories?.removeLast();
          Counter.saveCounter(counter: event.counter);
        }
        yield CounterLoaded(counter: event.counter);
      } catch (err) {
        yield CounterError(message: err.toString());
      }
    }
    if (event is CounterReset) {
      try {
        yield CounterLoading();
        event.counter.counter = 0;
        event.counter.updatedAt = DateTime.now();
        event.counter.histories?.clear();
        Counter.saveCounter(counter: event.counter);
        yield CounterLoaded(counter: event.counter);
      } catch (err) {
        yield CounterError(message: err.toString());
      }
    }
    if (event is CounterToggleVibration) {
      try {
        yield CounterLoading();
        event.counter.isVibrationOn =
            event.counter.isVibrationOn ? false : true;
        event.counter.updatedAt = DateTime.now();
        lightVibrate(event.counter);
        Counter.saveCounter(counter: event.counter);
        yield CounterLoaded(counter: event.counter);
      } catch (err) {
        yield CounterError(message: err.toString());
      }
    }
    if (event is CounterToggleSound) {
      try {
        yield CounterLoading();
        event.counter.isSoundOn = event.counter.isSoundOn ? false : true;
        event.counter.updatedAt = DateTime.now();
        playSound(event.counter);
        Counter.saveCounter(counter: event.counter);
        yield CounterLoaded(counter: event.counter);
      } catch (err) {
        yield CounterError(message: err.toString());
      }
    }
    if (event is CounterUpdate) {
      try {
        yield CounterLoading();
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
            yield counterValidateState;
          } else {
            counter.name = event.title;
            counter.description = event.description;
            counter.counter = event.counter;
            counter.limiter =
                (event.counter > event.limiter ? event.counter : event.limiter);
            counter.counterTheme = event.counterTheme;
            Counter.saveCounter(counter: counter);
            yield CounterSaved(counter: counter);
          }
        } else {
          yield CounterError(message: 'Counter Not Found.');
        }
        yield CounterLoaded(counter: counter);
      } catch (err) {
        yield CounterError(message: err.toString());
      }
    }
    if (event is CounterDelete) {
      try {
        yield CounterLoading();
        Box<Counter> countersBox = Hive.box<Counter>('myZikirCountersBox');
        countersBox.delete(event.id);
        yield CounterDeleted();
        yield CounterLoaded();
      } catch (err) {
        yield CounterError(message: err.toString());
      }
    }
    if (event is CounterGetWeekReport) {
      // try {
      yield CounterLoading();
      Box<Counter> countersBox = Hive.box<Counter>('myZikirCountersBox');
      List<Counter> counters = [];
      for (var i = 0; i < countersBox.length; i++) {
        Counter? tempCounter = countersBox.getAt(i);
        if (tempCounter != null) {
          counters.add(tempCounter);
        }
      }
      yield CounterLoaded(
          targetDateTime: event.dateTime,
          weekBarChartData: Counter.getWeekReport(
              counters: counters, dateTime: event.dateTime));
      // } catch (e) {
      //   yield CounterError(message: e.toString());
      // }
    }
    if (event is CounterGetMonthReport) {
      try {
        yield CounterLoading();
        Box<Counter> countersBox = Hive.box<Counter>('myZikirCountersBox');
        List<Counter> counters = [];
        for (var i = 0; i < countersBox.length; i++) {
          Counter? tempCounter = countersBox.getAt(i);
          if (tempCounter != null) {
            counters.add(tempCounter);
          }
        }
        yield CounterLoaded(
            targetDateTime: event.dateTime,
            monthBarChartData: Counter.getMonthReport(
                counters: counters, dateTime: event.dateTime));
      } catch (e) {
        yield CounterError(message: e.toString());
      }
    }
    if (event is CounterGetYearReport) {
      try {
        yield CounterLoading();
        Box<Counter> countersBox = Hive.box<Counter>('myZikirCountersBox');
        List<Counter> counters = [];
        for (var i = 0; i < countersBox.length; i++) {
          Counter? tempCounter = countersBox.getAt(i);
          if (tempCounter != null) {
            counters.add(tempCounter);
          }
        }
        yield CounterLoaded(
            targetDateTime: event.dateTime,
            monthBarChartData: Counter.getYearReport(
                counters: counters, dateTime: event.dateTime));
      } catch (e) {
        yield CounterError(message: e.toString());
      }
    }
    if (event is CounterGetDayReport) {
      try {
        yield CounterLoading();
        Box<Counter> countersBox = Hive.box<Counter>('myZikirCountersBox');
        List<Counter> counters = [];
        for (var i = 0; i < countersBox.length; i++) {
          Counter? tempCounter = countersBox.getAt(i);
          if (tempCounter != null) {
            counters.add(tempCounter);
          }
        }
        yield CounterLoaded(
            targetDateTime: event.dateTime,
            dayBarChartData: Counter.getDayReport(
                counters: counters, dateTime: event.dateTime));
      } catch (e) {
        yield CounterError(message: e.toString());
      }
    }
    if (event is CounterDayReportPrev) {
      try {
        yield CounterLoading();
        Box<Counter> countersBox = Hive.box<Counter>('myZikirCountersBox');
        DateTime prevDateTime =
            event.currentDateTime.subtract(Duration(days: 1));
        List<Counter> counters = [];
        for (var i = 0; i < countersBox.length; i++) {
          Counter? tempCounter = countersBox.getAt(i);
          if (tempCounter != null) {
            counters.add(tempCounter);
          }
        }
        yield CounterLoaded(
            dayBarChartData: Counter.getDayReport(
                counters: counters, dateTime: prevDateTime),
            targetDateTime: prevDateTime);
      } catch (e) {
        yield (CounterError(message: e.toString()));
      }
    }
    if (event is CounterDayReportNext) {
      try {
        yield CounterLoading();
        Box<Counter> countersBox = Hive.box<Counter>('myZikirCountersBox');
        DateTime nextDateTime = event.currentDateTime.add(Duration(days: 1));
        List<Counter> counters = [];
        for (var i = 0; i < countersBox.length; i++) {
          Counter? tempCounter = countersBox.getAt(i);
          if (tempCounter != null) {
            counters.add(tempCounter);
          }
        }
        yield CounterLoaded(
            dayBarChartData: Counter.getDayReport(
                counters: counters, dateTime: nextDateTime),
            targetDateTime: nextDateTime);
      } catch (e) {
        yield (CounterError(message: e.toString()));
      }
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

  void playSound(Counter counter) async {
    if (counter.isSoundOn) {
      Soundpool pool = Soundpool.fromOptions(
          options: SoundpoolOptions(streamType: StreamType.notification));
      int soundId = await rootBundle
          .load(
              "assets/sounds/zapsplat_technology_studio_speaker_active_power_switch_click_005_68877.mp3")
          .then((ByteData soundData) {
        return pool.load(soundData);
      });
      await pool.play(soundId);
    }
  }

  void lightVibrate(Counter counter) async {
    // Choose from any of these available methods
    bool canVibrate = await Vibrate.canVibrate;
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
}
