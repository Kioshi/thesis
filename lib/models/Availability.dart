enum AvailabilityState
{
  Open,
  Closed,
  FullyBooked,
  TimeSlotAvailable,
  TimeSlotAlternativePossible,
  TimeSlotUnavailable
}


class Availability {
  List<NormalDay> normalDays;
  List<SpecialDay> specialDays;

  Availability({this.normalDays, this.specialDays});

  Availability.fromJson(Map<String, dynamic> json) {
    if (json['normalDays'] != null) {
      normalDays = new List<NormalDay>();
      json['normalDays'].forEach((v) {
        normalDays.add(new NormalDay.fromJson(v));
      });
    }
    if (json['specialDays'] != null) {
      specialDays = new List<SpecialDay>();
      json['specialDays'].forEach((v) {
        specialDays.add(new SpecialDay.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.normalDays != null) {
      data['normalDays'] = this.normalDays.map((v) => v.toJson()).toList();
    }
    if (this.specialDays != null) {
      data['specialDays'] = this.specialDays.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NormalDay {
  int daysMask;
  int openFrom;
  int openTill;
  bool open;

  NormalDay({this.daysMask, this.openFrom, this.openTill, this.open});

  NormalDay.fromJson(Map<String, dynamic> json) {
    daysMask = json['daysMask'];
    openFrom = json['openFrom'];
    openTill = json['openTill'];
    open = json['open'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['daysMask'] = this.daysMask;
    data['openFrom'] = this.openFrom;
    data['openTill'] = this.openTill;
    data['open'] = this.open;
    return data;
  }
}

class SpecialDay {
  List<String> dates;
  int openFrom;
  int openTill;
  bool open;

  SpecialDay({this.dates, this.openFrom, this.openTill, this.open});

  SpecialDay.fromJson(Map<String, dynamic> json) {
    dates = json['dates'].cast<String>();
    openFrom = json['openFrom'];
    openTill = json['openTill'];
    open = json['open'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dates'] = this.dates;
    data['openFrom'] = this.openFrom;
    data['openTill'] = this.openTill;
    data['open'] = this.open;
    return data;
  }
}