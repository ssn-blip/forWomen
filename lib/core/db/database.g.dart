// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $CycleLogsTable extends CycleLogs
    with TableInfo<$CycleLogsTable, CycleLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CycleLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _flowMeta = const VerificationMeta('flow');
  @override
  late final GeneratedColumn<int> flow = GeneratedColumn<int>(
    'flow',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _symptomsMeta = const VerificationMeta(
    'symptoms',
  );
  @override
  late final GeneratedColumn<String> symptoms = GeneratedColumn<String>(
    'symptoms',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
    'synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    startDate,
    endDate,
    flow,
    symptoms,
    note,
    synced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cycle_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<CycleLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    }
    if (data.containsKey('flow')) {
      context.handle(
        _flowMeta,
        flow.isAcceptableOrUnknown(data['flow']!, _flowMeta),
      );
    }
    if (data.containsKey('symptoms')) {
      context.handle(
        _symptomsMeta,
        symptoms.isAcceptableOrUnknown(data['symptoms']!, _symptomsMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('synced')) {
      context.handle(
        _syncedMeta,
        synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CycleLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CycleLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      ),
      flow: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}flow'],
      ),
      symptoms: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}symptoms'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      synced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced'],
      )!,
    );
  }

  @override
  $CycleLogsTable createAlias(String alias) {
    return $CycleLogsTable(attachedDatabase, alias);
  }
}

class CycleLog extends DataClass implements Insertable<CycleLog> {
  final int id;
  final DateTime startDate;
  final DateTime? endDate;

  /// 출혈량 1(적음)~3(많음)
  final int? flow;

  /// 증상/메모 (쉼표 구분 태그 + 자유 메모)
  final String? symptoms;
  final String? note;
  final bool synced;
  const CycleLog({
    required this.id,
    required this.startDate,
    this.endDate,
    this.flow,
    this.symptoms,
    this.note,
    required this.synced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['start_date'] = Variable<DateTime>(startDate);
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    if (!nullToAbsent || flow != null) {
      map['flow'] = Variable<int>(flow);
    }
    if (!nullToAbsent || symptoms != null) {
      map['symptoms'] = Variable<String>(symptoms);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  CycleLogsCompanion toCompanion(bool nullToAbsent) {
    return CycleLogsCompanion(
      id: Value(id),
      startDate: Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      flow: flow == null && nullToAbsent ? const Value.absent() : Value(flow),
      symptoms: symptoms == null && nullToAbsent
          ? const Value.absent()
          : Value(symptoms),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      synced: Value(synced),
    );
  }

  factory CycleLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CycleLog(
      id: serializer.fromJson<int>(json['id']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
      flow: serializer.fromJson<int?>(json['flow']),
      symptoms: serializer.fromJson<String?>(json['symptoms']),
      note: serializer.fromJson<String?>(json['note']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
      'flow': serializer.toJson<int?>(flow),
      'symptoms': serializer.toJson<String?>(symptoms),
      'note': serializer.toJson<String?>(note),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  CycleLog copyWith({
    int? id,
    DateTime? startDate,
    Value<DateTime?> endDate = const Value.absent(),
    Value<int?> flow = const Value.absent(),
    Value<String?> symptoms = const Value.absent(),
    Value<String?> note = const Value.absent(),
    bool? synced,
  }) => CycleLog(
    id: id ?? this.id,
    startDate: startDate ?? this.startDate,
    endDate: endDate.present ? endDate.value : this.endDate,
    flow: flow.present ? flow.value : this.flow,
    symptoms: symptoms.present ? symptoms.value : this.symptoms,
    note: note.present ? note.value : this.note,
    synced: synced ?? this.synced,
  );
  CycleLog copyWithCompanion(CycleLogsCompanion data) {
    return CycleLog(
      id: data.id.present ? data.id.value : this.id,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      flow: data.flow.present ? data.flow.value : this.flow,
      symptoms: data.symptoms.present ? data.symptoms.value : this.symptoms,
      note: data.note.present ? data.note.value : this.note,
      synced: data.synced.present ? data.synced.value : this.synced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CycleLog(')
          ..write('id: $id, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('flow: $flow, ')
          ..write('symptoms: $symptoms, ')
          ..write('note: $note, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, startDate, endDate, flow, symptoms, note, synced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CycleLog &&
          other.id == this.id &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.flow == this.flow &&
          other.symptoms == this.symptoms &&
          other.note == this.note &&
          other.synced == this.synced);
}

class CycleLogsCompanion extends UpdateCompanion<CycleLog> {
  final Value<int> id;
  final Value<DateTime> startDate;
  final Value<DateTime?> endDate;
  final Value<int?> flow;
  final Value<String?> symptoms;
  final Value<String?> note;
  final Value<bool> synced;
  const CycleLogsCompanion({
    this.id = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.flow = const Value.absent(),
    this.symptoms = const Value.absent(),
    this.note = const Value.absent(),
    this.synced = const Value.absent(),
  });
  CycleLogsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime startDate,
    this.endDate = const Value.absent(),
    this.flow = const Value.absent(),
    this.symptoms = const Value.absent(),
    this.note = const Value.absent(),
    this.synced = const Value.absent(),
  }) : startDate = Value(startDate);
  static Insertable<CycleLog> custom({
    Expression<int>? id,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<int>? flow,
    Expression<String>? symptoms,
    Expression<String>? note,
    Expression<bool>? synced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (flow != null) 'flow': flow,
      if (symptoms != null) 'symptoms': symptoms,
      if (note != null) 'note': note,
      if (synced != null) 'synced': synced,
    });
  }

  CycleLogsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? startDate,
    Value<DateTime?>? endDate,
    Value<int?>? flow,
    Value<String?>? symptoms,
    Value<String?>? note,
    Value<bool>? synced,
  }) {
    return CycleLogsCompanion(
      id: id ?? this.id,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      flow: flow ?? this.flow,
      symptoms: symptoms ?? this.symptoms,
      note: note ?? this.note,
      synced: synced ?? this.synced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (flow.present) {
      map['flow'] = Variable<int>(flow.value);
    }
    if (symptoms.present) {
      map['symptoms'] = Variable<String>(symptoms.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CycleLogsCompanion(')
          ..write('id: $id, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('flow: $flow, ')
          ..write('symptoms: $symptoms, ')
          ..write('note: $note, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }
}

class $BbtLogsTable extends BbtLogs with TableInfo<$BbtLogsTable, BbtLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BbtLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _temperatureMeta = const VerificationMeta(
    'temperature',
  );
  @override
  late final GeneratedColumn<double> temperature = GeneratedColumn<double>(
    'temperature',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
    'synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [id, date, temperature, note, synced];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bbt_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<BbtLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('temperature')) {
      context.handle(
        _temperatureMeta,
        temperature.isAcceptableOrUnknown(
          data['temperature']!,
          _temperatureMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_temperatureMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('synced')) {
      context.handle(
        _syncedMeta,
        synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BbtLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BbtLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      temperature: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}temperature'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      synced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced'],
      )!,
    );
  }

  @override
  $BbtLogsTable createAlias(String alias) {
    return $BbtLogsTable(attachedDatabase, alias);
  }
}

class BbtLog extends DataClass implements Insertable<BbtLog> {
  final int id;
  final DateTime date;
  final double temperature;
  final String? note;
  final bool synced;
  const BbtLog({
    required this.id,
    required this.date,
    required this.temperature,
    this.note,
    required this.synced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['temperature'] = Variable<double>(temperature);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  BbtLogsCompanion toCompanion(bool nullToAbsent) {
    return BbtLogsCompanion(
      id: Value(id),
      date: Value(date),
      temperature: Value(temperature),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      synced: Value(synced),
    );
  }

  factory BbtLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BbtLog(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      temperature: serializer.fromJson<double>(json['temperature']),
      note: serializer.fromJson<String?>(json['note']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'temperature': serializer.toJson<double>(temperature),
      'note': serializer.toJson<String?>(note),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  BbtLog copyWith({
    int? id,
    DateTime? date,
    double? temperature,
    Value<String?> note = const Value.absent(),
    bool? synced,
  }) => BbtLog(
    id: id ?? this.id,
    date: date ?? this.date,
    temperature: temperature ?? this.temperature,
    note: note.present ? note.value : this.note,
    synced: synced ?? this.synced,
  );
  BbtLog copyWithCompanion(BbtLogsCompanion data) {
    return BbtLog(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      temperature: data.temperature.present
          ? data.temperature.value
          : this.temperature,
      note: data.note.present ? data.note.value : this.note,
      synced: data.synced.present ? data.synced.value : this.synced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BbtLog(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('temperature: $temperature, ')
          ..write('note: $note, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, temperature, note, synced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BbtLog &&
          other.id == this.id &&
          other.date == this.date &&
          other.temperature == this.temperature &&
          other.note == this.note &&
          other.synced == this.synced);
}

class BbtLogsCompanion extends UpdateCompanion<BbtLog> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<double> temperature;
  final Value<String?> note;
  final Value<bool> synced;
  const BbtLogsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.temperature = const Value.absent(),
    this.note = const Value.absent(),
    this.synced = const Value.absent(),
  });
  BbtLogsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required double temperature,
    this.note = const Value.absent(),
    this.synced = const Value.absent(),
  }) : date = Value(date),
       temperature = Value(temperature);
  static Insertable<BbtLog> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<double>? temperature,
    Expression<String>? note,
    Expression<bool>? synced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (temperature != null) 'temperature': temperature,
      if (note != null) 'note': note,
      if (synced != null) 'synced': synced,
    });
  }

  BbtLogsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<double>? temperature,
    Value<String?>? note,
    Value<bool>? synced,
  }) {
    return BbtLogsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      temperature: temperature ?? this.temperature,
      note: note ?? this.note,
      synced: synced ?? this.synced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (temperature.present) {
      map['temperature'] = Variable<double>(temperature.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BbtLogsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('temperature: $temperature, ')
          ..write('note: $note, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }
}

class $TestLogsTable extends TestLogs with TableInfo<$TestLogsTable, TestLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TestLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _resultMeta = const VerificationMeta('result');
  @override
  late final GeneratedColumn<String> result = GeneratedColumn<String>(
    'result',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ratioMeta = const VerificationMeta('ratio');
  @override
  late final GeneratedColumn<double> ratio = GeneratedColumn<double>(
    'ratio',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
    'synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    kind,
    result,
    photoPath,
    ratio,
    note,
    synced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'test_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<TestLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('result')) {
      context.handle(
        _resultMeta,
        result.isAcceptableOrUnknown(data['result']!, _resultMeta),
      );
    } else if (isInserting) {
      context.missing(_resultMeta);
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    if (data.containsKey('ratio')) {
      context.handle(
        _ratioMeta,
        ratio.isAcceptableOrUnknown(data['ratio']!, _ratioMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('synced')) {
      context.handle(
        _syncedMeta,
        synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TestLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TestLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      result: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}result'],
      )!,
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      ),
      ratio: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}ratio'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      synced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced'],
      )!,
    );
  }

  @override
  $TestLogsTable createAlias(String alias) {
    return $TestLogsTable(attachedDatabase, alias);
  }
}

class TestLog extends DataClass implements Insertable<TestLog> {
  final int id;
  final DateTime date;

  /// 'pregnancy'(임신테스트) | 'ovulation'(배란테스트)
  final String kind;

  /// 'positive' | 'negative' | 'faint'(희미) | 'unknown'
  final String result;

  /// 촬영(또는 크롭) 사진 로컬 경로
  final String? photoPath;

  /// 자동 분석 진하기 비율 T/C (0~1+, 사진 분석 시). 없으면 수동 입력.
  final double? ratio;
  final String? note;
  final bool synced;
  const TestLog({
    required this.id,
    required this.date,
    required this.kind,
    required this.result,
    this.photoPath,
    this.ratio,
    this.note,
    required this.synced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['kind'] = Variable<String>(kind);
    map['result'] = Variable<String>(result);
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    if (!nullToAbsent || ratio != null) {
      map['ratio'] = Variable<double>(ratio);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  TestLogsCompanion toCompanion(bool nullToAbsent) {
    return TestLogsCompanion(
      id: Value(id),
      date: Value(date),
      kind: Value(kind),
      result: Value(result),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      ratio: ratio == null && nullToAbsent
          ? const Value.absent()
          : Value(ratio),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      synced: Value(synced),
    );
  }

  factory TestLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TestLog(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      kind: serializer.fromJson<String>(json['kind']),
      result: serializer.fromJson<String>(json['result']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      ratio: serializer.fromJson<double?>(json['ratio']),
      note: serializer.fromJson<String?>(json['note']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'kind': serializer.toJson<String>(kind),
      'result': serializer.toJson<String>(result),
      'photoPath': serializer.toJson<String?>(photoPath),
      'ratio': serializer.toJson<double?>(ratio),
      'note': serializer.toJson<String?>(note),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  TestLog copyWith({
    int? id,
    DateTime? date,
    String? kind,
    String? result,
    Value<String?> photoPath = const Value.absent(),
    Value<double?> ratio = const Value.absent(),
    Value<String?> note = const Value.absent(),
    bool? synced,
  }) => TestLog(
    id: id ?? this.id,
    date: date ?? this.date,
    kind: kind ?? this.kind,
    result: result ?? this.result,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
    ratio: ratio.present ? ratio.value : this.ratio,
    note: note.present ? note.value : this.note,
    synced: synced ?? this.synced,
  );
  TestLog copyWithCompanion(TestLogsCompanion data) {
    return TestLog(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      kind: data.kind.present ? data.kind.value : this.kind,
      result: data.result.present ? data.result.value : this.result,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      ratio: data.ratio.present ? data.ratio.value : this.ratio,
      note: data.note.present ? data.note.value : this.note,
      synced: data.synced.present ? data.synced.value : this.synced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TestLog(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('kind: $kind, ')
          ..write('result: $result, ')
          ..write('photoPath: $photoPath, ')
          ..write('ratio: $ratio, ')
          ..write('note: $note, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, date, kind, result, photoPath, ratio, note, synced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TestLog &&
          other.id == this.id &&
          other.date == this.date &&
          other.kind == this.kind &&
          other.result == this.result &&
          other.photoPath == this.photoPath &&
          other.ratio == this.ratio &&
          other.note == this.note &&
          other.synced == this.synced);
}

class TestLogsCompanion extends UpdateCompanion<TestLog> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<String> kind;
  final Value<String> result;
  final Value<String?> photoPath;
  final Value<double?> ratio;
  final Value<String?> note;
  final Value<bool> synced;
  const TestLogsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.kind = const Value.absent(),
    this.result = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.ratio = const Value.absent(),
    this.note = const Value.absent(),
    this.synced = const Value.absent(),
  });
  TestLogsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required String kind,
    required String result,
    this.photoPath = const Value.absent(),
    this.ratio = const Value.absent(),
    this.note = const Value.absent(),
    this.synced = const Value.absent(),
  }) : date = Value(date),
       kind = Value(kind),
       result = Value(result);
  static Insertable<TestLog> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<String>? kind,
    Expression<String>? result,
    Expression<String>? photoPath,
    Expression<double>? ratio,
    Expression<String>? note,
    Expression<bool>? synced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (kind != null) 'kind': kind,
      if (result != null) 'result': result,
      if (photoPath != null) 'photo_path': photoPath,
      if (ratio != null) 'ratio': ratio,
      if (note != null) 'note': note,
      if (synced != null) 'synced': synced,
    });
  }

  TestLogsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<String>? kind,
    Value<String>? result,
    Value<String?>? photoPath,
    Value<double?>? ratio,
    Value<String?>? note,
    Value<bool>? synced,
  }) {
    return TestLogsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      kind: kind ?? this.kind,
      result: result ?? this.result,
      photoPath: photoPath ?? this.photoPath,
      ratio: ratio ?? this.ratio,
      note: note ?? this.note,
      synced: synced ?? this.synced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (result.present) {
      map['result'] = Variable<String>(result.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (ratio.present) {
      map['ratio'] = Variable<double>(ratio.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TestLogsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('kind: $kind, ')
          ..write('result: $result, ')
          ..write('photoPath: $photoPath, ')
          ..write('ratio: $ratio, ')
          ..write('note: $note, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }
}

class $PregnanciesTable extends Pregnancies
    with TableInfo<$PregnanciesTable, Pregnancy> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PregnanciesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _lastPeriodStartMeta = const VerificationMeta(
    'lastPeriodStart',
  );
  @override
  late final GeneratedColumn<DateTime> lastPeriodStart =
      GeneratedColumn<DateTime>(
        'last_period_start',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _dueDateOverrideMeta = const VerificationMeta(
    'dueDateOverride',
  );
  @override
  late final GeneratedColumn<DateTime> dueDateOverride =
      GeneratedColumn<DateTime>(
        'due_date_override',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
    'synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    lastPeriodStart,
    dueDateOverride,
    status,
    createdAt,
    note,
    synced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pregnancies';
  @override
  VerificationContext validateIntegrity(
    Insertable<Pregnancy> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('last_period_start')) {
      context.handle(
        _lastPeriodStartMeta,
        lastPeriodStart.isAcceptableOrUnknown(
          data['last_period_start']!,
          _lastPeriodStartMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastPeriodStartMeta);
    }
    if (data.containsKey('due_date_override')) {
      context.handle(
        _dueDateOverrideMeta,
        dueDateOverride.isAcceptableOrUnknown(
          data['due_date_override']!,
          _dueDateOverrideMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('synced')) {
      context.handle(
        _syncedMeta,
        synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Pregnancy map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Pregnancy(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      lastPeriodStart: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_period_start'],
      )!,
      dueDateOverride: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date_override'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      synced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced'],
      )!,
    );
  }

  @override
  $PregnanciesTable createAlias(String alias) {
    return $PregnanciesTable(attachedDatabase, alias);
  }
}

class Pregnancy extends DataClass implements Insertable<Pregnancy> {
  final int id;

  /// 마지막 생리 시작일 (주차/출산예정일 계산 기준)
  final DateTime lastPeriodStart;

  /// 사용자가 직접 지정한 출산 예정일 (없으면 LMP+280일 사용)
  final DateTime? dueDateOverride;

  /// 'active'(진행) | 'completed'(출산) | 'ended'(종료)
  final String status;
  final DateTime createdAt;
  final String? note;
  final bool synced;
  const Pregnancy({
    required this.id,
    required this.lastPeriodStart,
    this.dueDateOverride,
    required this.status,
    required this.createdAt,
    this.note,
    required this.synced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['last_period_start'] = Variable<DateTime>(lastPeriodStart);
    if (!nullToAbsent || dueDateOverride != null) {
      map['due_date_override'] = Variable<DateTime>(dueDateOverride);
    }
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  PregnanciesCompanion toCompanion(bool nullToAbsent) {
    return PregnanciesCompanion(
      id: Value(id),
      lastPeriodStart: Value(lastPeriodStart),
      dueDateOverride: dueDateOverride == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDateOverride),
      status: Value(status),
      createdAt: Value(createdAt),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      synced: Value(synced),
    );
  }

  factory Pregnancy.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Pregnancy(
      id: serializer.fromJson<int>(json['id']),
      lastPeriodStart: serializer.fromJson<DateTime>(json['lastPeriodStart']),
      dueDateOverride: serializer.fromJson<DateTime?>(json['dueDateOverride']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      note: serializer.fromJson<String?>(json['note']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'lastPeriodStart': serializer.toJson<DateTime>(lastPeriodStart),
      'dueDateOverride': serializer.toJson<DateTime?>(dueDateOverride),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'note': serializer.toJson<String?>(note),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  Pregnancy copyWith({
    int? id,
    DateTime? lastPeriodStart,
    Value<DateTime?> dueDateOverride = const Value.absent(),
    String? status,
    DateTime? createdAt,
    Value<String?> note = const Value.absent(),
    bool? synced,
  }) => Pregnancy(
    id: id ?? this.id,
    lastPeriodStart: lastPeriodStart ?? this.lastPeriodStart,
    dueDateOverride: dueDateOverride.present
        ? dueDateOverride.value
        : this.dueDateOverride,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    note: note.present ? note.value : this.note,
    synced: synced ?? this.synced,
  );
  Pregnancy copyWithCompanion(PregnanciesCompanion data) {
    return Pregnancy(
      id: data.id.present ? data.id.value : this.id,
      lastPeriodStart: data.lastPeriodStart.present
          ? data.lastPeriodStart.value
          : this.lastPeriodStart,
      dueDateOverride: data.dueDateOverride.present
          ? data.dueDateOverride.value
          : this.dueDateOverride,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      note: data.note.present ? data.note.value : this.note,
      synced: data.synced.present ? data.synced.value : this.synced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Pregnancy(')
          ..write('id: $id, ')
          ..write('lastPeriodStart: $lastPeriodStart, ')
          ..write('dueDateOverride: $dueDateOverride, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('note: $note, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    lastPeriodStart,
    dueDateOverride,
    status,
    createdAt,
    note,
    synced,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Pregnancy &&
          other.id == this.id &&
          other.lastPeriodStart == this.lastPeriodStart &&
          other.dueDateOverride == this.dueDateOverride &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.note == this.note &&
          other.synced == this.synced);
}

class PregnanciesCompanion extends UpdateCompanion<Pregnancy> {
  final Value<int> id;
  final Value<DateTime> lastPeriodStart;
  final Value<DateTime?> dueDateOverride;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<String?> note;
  final Value<bool> synced;
  const PregnanciesCompanion({
    this.id = const Value.absent(),
    this.lastPeriodStart = const Value.absent(),
    this.dueDateOverride = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.note = const Value.absent(),
    this.synced = const Value.absent(),
  });
  PregnanciesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime lastPeriodStart,
    this.dueDateOverride = const Value.absent(),
    this.status = const Value.absent(),
    required DateTime createdAt,
    this.note = const Value.absent(),
    this.synced = const Value.absent(),
  }) : lastPeriodStart = Value(lastPeriodStart),
       createdAt = Value(createdAt);
  static Insertable<Pregnancy> custom({
    Expression<int>? id,
    Expression<DateTime>? lastPeriodStart,
    Expression<DateTime>? dueDateOverride,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<String>? note,
    Expression<bool>? synced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lastPeriodStart != null) 'last_period_start': lastPeriodStart,
      if (dueDateOverride != null) 'due_date_override': dueDateOverride,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (note != null) 'note': note,
      if (synced != null) 'synced': synced,
    });
  }

  PregnanciesCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? lastPeriodStart,
    Value<DateTime?>? dueDateOverride,
    Value<String>? status,
    Value<DateTime>? createdAt,
    Value<String?>? note,
    Value<bool>? synced,
  }) {
    return PregnanciesCompanion(
      id: id ?? this.id,
      lastPeriodStart: lastPeriodStart ?? this.lastPeriodStart,
      dueDateOverride: dueDateOverride ?? this.dueDateOverride,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      note: note ?? this.note,
      synced: synced ?? this.synced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (lastPeriodStart.present) {
      map['last_period_start'] = Variable<DateTime>(lastPeriodStart.value);
    }
    if (dueDateOverride.present) {
      map['due_date_override'] = Variable<DateTime>(dueDateOverride.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PregnanciesCompanion(')
          ..write('id: $id, ')
          ..write('lastPeriodStart: $lastPeriodStart, ')
          ..write('dueDateOverride: $dueDateOverride, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('note: $note, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }
}

class $RemindersTable extends Reminders
    with TableInfo<$RemindersTable, Reminder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RemindersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nextTriggerMeta = const VerificationMeta(
    'nextTrigger',
  );
  @override
  late final GeneratedColumn<DateTime> nextTrigger = GeneratedColumn<DateTime>(
    'next_trigger',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repeatMeta = const VerificationMeta('repeat');
  @override
  late final GeneratedColumn<String> repeat = GeneratedColumn<String>(
    'repeat',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('none'),
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
    'synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    kind,
    title,
    body,
    nextTrigger,
    repeat,
    enabled,
    synced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminders';
  @override
  VerificationContext validateIntegrity(
    Insertable<Reminder> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    }
    if (data.containsKey('next_trigger')) {
      context.handle(
        _nextTriggerMeta,
        nextTrigger.isAcceptableOrUnknown(
          data['next_trigger']!,
          _nextTriggerMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nextTriggerMeta);
    }
    if (data.containsKey('repeat')) {
      context.handle(
        _repeatMeta,
        repeat.isAcceptableOrUnknown(data['repeat']!, _repeatMeta),
      );
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    if (data.containsKey('synced')) {
      context.handle(
        _syncedMeta,
        synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Reminder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Reminder(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      ),
      nextTrigger: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_trigger'],
      )!,
      repeat: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}repeat'],
      )!,
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
      synced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced'],
      )!,
    );
  }

  @override
  $RemindersTable createAlias(String alias) {
    return $RemindersTable(attachedDatabase, alias);
  }
}

class Reminder extends DataClass implements Insertable<Reminder> {
  final int id;

  /// 'medication'(약) | 'checkup'(검진) | 'custom'(일정)
  final String kind;
  final String title;
  final String? body;

  /// 다음 알림 시각
  final DateTime nextTrigger;

  /// 반복 규칙: 'none' | 'daily' | 'weekly'
  final String repeat;
  final bool enabled;
  final bool synced;
  const Reminder({
    required this.id,
    required this.kind,
    required this.title,
    this.body,
    required this.nextTrigger,
    required this.repeat,
    required this.enabled,
    required this.synced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['kind'] = Variable<String>(kind);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || body != null) {
      map['body'] = Variable<String>(body);
    }
    map['next_trigger'] = Variable<DateTime>(nextTrigger);
    map['repeat'] = Variable<String>(repeat);
    map['enabled'] = Variable<bool>(enabled);
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  RemindersCompanion toCompanion(bool nullToAbsent) {
    return RemindersCompanion(
      id: Value(id),
      kind: Value(kind),
      title: Value(title),
      body: body == null && nullToAbsent ? const Value.absent() : Value(body),
      nextTrigger: Value(nextTrigger),
      repeat: Value(repeat),
      enabled: Value(enabled),
      synced: Value(synced),
    );
  }

  factory Reminder.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Reminder(
      id: serializer.fromJson<int>(json['id']),
      kind: serializer.fromJson<String>(json['kind']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String?>(json['body']),
      nextTrigger: serializer.fromJson<DateTime>(json['nextTrigger']),
      repeat: serializer.fromJson<String>(json['repeat']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'kind': serializer.toJson<String>(kind),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String?>(body),
      'nextTrigger': serializer.toJson<DateTime>(nextTrigger),
      'repeat': serializer.toJson<String>(repeat),
      'enabled': serializer.toJson<bool>(enabled),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  Reminder copyWith({
    int? id,
    String? kind,
    String? title,
    Value<String?> body = const Value.absent(),
    DateTime? nextTrigger,
    String? repeat,
    bool? enabled,
    bool? synced,
  }) => Reminder(
    id: id ?? this.id,
    kind: kind ?? this.kind,
    title: title ?? this.title,
    body: body.present ? body.value : this.body,
    nextTrigger: nextTrigger ?? this.nextTrigger,
    repeat: repeat ?? this.repeat,
    enabled: enabled ?? this.enabled,
    synced: synced ?? this.synced,
  );
  Reminder copyWithCompanion(RemindersCompanion data) {
    return Reminder(
      id: data.id.present ? data.id.value : this.id,
      kind: data.kind.present ? data.kind.value : this.kind,
      title: data.title.present ? data.title.value : this.title,
      body: data.body.present ? data.body.value : this.body,
      nextTrigger: data.nextTrigger.present
          ? data.nextTrigger.value
          : this.nextTrigger,
      repeat: data.repeat.present ? data.repeat.value : this.repeat,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      synced: data.synced.present ? data.synced.value : this.synced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Reminder(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('nextTrigger: $nextTrigger, ')
          ..write('repeat: $repeat, ')
          ..write('enabled: $enabled, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, kind, title, body, nextTrigger, repeat, enabled, synced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Reminder &&
          other.id == this.id &&
          other.kind == this.kind &&
          other.title == this.title &&
          other.body == this.body &&
          other.nextTrigger == this.nextTrigger &&
          other.repeat == this.repeat &&
          other.enabled == this.enabled &&
          other.synced == this.synced);
}

class RemindersCompanion extends UpdateCompanion<Reminder> {
  final Value<int> id;
  final Value<String> kind;
  final Value<String> title;
  final Value<String?> body;
  final Value<DateTime> nextTrigger;
  final Value<String> repeat;
  final Value<bool> enabled;
  final Value<bool> synced;
  const RemindersCompanion({
    this.id = const Value.absent(),
    this.kind = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.nextTrigger = const Value.absent(),
    this.repeat = const Value.absent(),
    this.enabled = const Value.absent(),
    this.synced = const Value.absent(),
  });
  RemindersCompanion.insert({
    this.id = const Value.absent(),
    required String kind,
    required String title,
    this.body = const Value.absent(),
    required DateTime nextTrigger,
    this.repeat = const Value.absent(),
    this.enabled = const Value.absent(),
    this.synced = const Value.absent(),
  }) : kind = Value(kind),
       title = Value(title),
       nextTrigger = Value(nextTrigger);
  static Insertable<Reminder> custom({
    Expression<int>? id,
    Expression<String>? kind,
    Expression<String>? title,
    Expression<String>? body,
    Expression<DateTime>? nextTrigger,
    Expression<String>? repeat,
    Expression<bool>? enabled,
    Expression<bool>? synced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kind != null) 'kind': kind,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (nextTrigger != null) 'next_trigger': nextTrigger,
      if (repeat != null) 'repeat': repeat,
      if (enabled != null) 'enabled': enabled,
      if (synced != null) 'synced': synced,
    });
  }

  RemindersCompanion copyWith({
    Value<int>? id,
    Value<String>? kind,
    Value<String>? title,
    Value<String?>? body,
    Value<DateTime>? nextTrigger,
    Value<String>? repeat,
    Value<bool>? enabled,
    Value<bool>? synced,
  }) {
    return RemindersCompanion(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      title: title ?? this.title,
      body: body ?? this.body,
      nextTrigger: nextTrigger ?? this.nextTrigger,
      repeat: repeat ?? this.repeat,
      enabled: enabled ?? this.enabled,
      synced: synced ?? this.synced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (nextTrigger.present) {
      map['next_trigger'] = Variable<DateTime>(nextTrigger.value);
    }
    if (repeat.present) {
      map['repeat'] = Variable<String>(repeat.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RemindersCompanion(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('nextTrigger: $nextTrigger, ')
          ..write('repeat: $repeat, ')
          ..write('enabled: $enabled, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }
}

class $WeightLogsTable extends WeightLogs
    with TableInfo<$WeightLogsTable, WeightLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeightLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
    'synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [id, date, weightKg, note, synced];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weight_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeightLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    } else if (isInserting) {
      context.missing(_weightKgMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('synced')) {
      context.handle(
        _syncedMeta,
        synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WeightLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeightLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      synced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced'],
      )!,
    );
  }

  @override
  $WeightLogsTable createAlias(String alias) {
    return $WeightLogsTable(attachedDatabase, alias);
  }
}

class WeightLog extends DataClass implements Insertable<WeightLog> {
  final int id;
  final DateTime date;
  final double weightKg;
  final String? note;
  final bool synced;
  const WeightLog({
    required this.id,
    required this.date,
    required this.weightKg,
    this.note,
    required this.synced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['weight_kg'] = Variable<double>(weightKg);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  WeightLogsCompanion toCompanion(bool nullToAbsent) {
    return WeightLogsCompanion(
      id: Value(id),
      date: Value(date),
      weightKg: Value(weightKg),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      synced: Value(synced),
    );
  }

  factory WeightLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeightLog(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      weightKg: serializer.fromJson<double>(json['weightKg']),
      note: serializer.fromJson<String?>(json['note']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'weightKg': serializer.toJson<double>(weightKg),
      'note': serializer.toJson<String?>(note),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  WeightLog copyWith({
    int? id,
    DateTime? date,
    double? weightKg,
    Value<String?> note = const Value.absent(),
    bool? synced,
  }) => WeightLog(
    id: id ?? this.id,
    date: date ?? this.date,
    weightKg: weightKg ?? this.weightKg,
    note: note.present ? note.value : this.note,
    synced: synced ?? this.synced,
  );
  WeightLog copyWithCompanion(WeightLogsCompanion data) {
    return WeightLog(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      note: data.note.present ? data.note.value : this.note,
      synced: data.synced.present ? data.synced.value : this.synced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeightLog(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('weightKg: $weightKg, ')
          ..write('note: $note, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, weightKg, note, synced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeightLog &&
          other.id == this.id &&
          other.date == this.date &&
          other.weightKg == this.weightKg &&
          other.note == this.note &&
          other.synced == this.synced);
}

class WeightLogsCompanion extends UpdateCompanion<WeightLog> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<double> weightKg;
  final Value<String?> note;
  final Value<bool> synced;
  const WeightLogsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.note = const Value.absent(),
    this.synced = const Value.absent(),
  });
  WeightLogsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required double weightKg,
    this.note = const Value.absent(),
    this.synced = const Value.absent(),
  }) : date = Value(date),
       weightKg = Value(weightKg);
  static Insertable<WeightLog> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<double>? weightKg,
    Expression<String>? note,
    Expression<bool>? synced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (weightKg != null) 'weight_kg': weightKg,
      if (note != null) 'note': note,
      if (synced != null) 'synced': synced,
    });
  }

  WeightLogsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<double>? weightKg,
    Value<String?>? note,
    Value<bool>? synced,
  }) {
    return WeightLogsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      weightKg: weightKg ?? this.weightKg,
      note: note ?? this.note,
      synced: synced ?? this.synced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeightLogsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('weightKg: $weightKg, ')
          ..write('note: $note, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }
}

class $SymptomLogsTable extends SymptomLogs
    with TableInfo<$SymptomLogsTable, SymptomLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SymptomLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _symptomsMeta = const VerificationMeta(
    'symptoms',
  );
  @override
  late final GeneratedColumn<String> symptoms = GeneratedColumn<String>(
    'symptoms',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _severityMeta = const VerificationMeta(
    'severity',
  );
  @override
  late final GeneratedColumn<int> severity = GeneratedColumn<int>(
    'severity',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
    'synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    symptoms,
    severity,
    note,
    synced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'symptom_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<SymptomLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('symptoms')) {
      context.handle(
        _symptomsMeta,
        symptoms.isAcceptableOrUnknown(data['symptoms']!, _symptomsMeta),
      );
    } else if (isInserting) {
      context.missing(_symptomsMeta);
    }
    if (data.containsKey('severity')) {
      context.handle(
        _severityMeta,
        severity.isAcceptableOrUnknown(data['severity']!, _severityMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('synced')) {
      context.handle(
        _syncedMeta,
        synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SymptomLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SymptomLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      symptoms: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}symptoms'],
      )!,
      severity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}severity'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      synced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced'],
      )!,
    );
  }

  @override
  $SymptomLogsTable createAlias(String alias) {
    return $SymptomLogsTable(attachedDatabase, alias);
  }
}

class SymptomLog extends DataClass implements Insertable<SymptomLog> {
  final int id;
  final DateTime date;

  /// 쉼표 구분 증상 태그
  final String symptoms;

  /// 강도 1(약)~3(심)
  final int? severity;
  final String? note;
  final bool synced;
  const SymptomLog({
    required this.id,
    required this.date,
    required this.symptoms,
    this.severity,
    this.note,
    required this.synced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['symptoms'] = Variable<String>(symptoms);
    if (!nullToAbsent || severity != null) {
      map['severity'] = Variable<int>(severity);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  SymptomLogsCompanion toCompanion(bool nullToAbsent) {
    return SymptomLogsCompanion(
      id: Value(id),
      date: Value(date),
      symptoms: Value(symptoms),
      severity: severity == null && nullToAbsent
          ? const Value.absent()
          : Value(severity),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      synced: Value(synced),
    );
  }

  factory SymptomLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SymptomLog(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      symptoms: serializer.fromJson<String>(json['symptoms']),
      severity: serializer.fromJson<int?>(json['severity']),
      note: serializer.fromJson<String?>(json['note']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'symptoms': serializer.toJson<String>(symptoms),
      'severity': serializer.toJson<int?>(severity),
      'note': serializer.toJson<String?>(note),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  SymptomLog copyWith({
    int? id,
    DateTime? date,
    String? symptoms,
    Value<int?> severity = const Value.absent(),
    Value<String?> note = const Value.absent(),
    bool? synced,
  }) => SymptomLog(
    id: id ?? this.id,
    date: date ?? this.date,
    symptoms: symptoms ?? this.symptoms,
    severity: severity.present ? severity.value : this.severity,
    note: note.present ? note.value : this.note,
    synced: synced ?? this.synced,
  );
  SymptomLog copyWithCompanion(SymptomLogsCompanion data) {
    return SymptomLog(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      symptoms: data.symptoms.present ? data.symptoms.value : this.symptoms,
      severity: data.severity.present ? data.severity.value : this.severity,
      note: data.note.present ? data.note.value : this.note,
      synced: data.synced.present ? data.synced.value : this.synced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SymptomLog(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('symptoms: $symptoms, ')
          ..write('severity: $severity, ')
          ..write('note: $note, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, symptoms, severity, note, synced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SymptomLog &&
          other.id == this.id &&
          other.date == this.date &&
          other.symptoms == this.symptoms &&
          other.severity == this.severity &&
          other.note == this.note &&
          other.synced == this.synced);
}

class SymptomLogsCompanion extends UpdateCompanion<SymptomLog> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<String> symptoms;
  final Value<int?> severity;
  final Value<String?> note;
  final Value<bool> synced;
  const SymptomLogsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.symptoms = const Value.absent(),
    this.severity = const Value.absent(),
    this.note = const Value.absent(),
    this.synced = const Value.absent(),
  });
  SymptomLogsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required String symptoms,
    this.severity = const Value.absent(),
    this.note = const Value.absent(),
    this.synced = const Value.absent(),
  }) : date = Value(date),
       symptoms = Value(symptoms);
  static Insertable<SymptomLog> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<String>? symptoms,
    Expression<int>? severity,
    Expression<String>? note,
    Expression<bool>? synced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (symptoms != null) 'symptoms': symptoms,
      if (severity != null) 'severity': severity,
      if (note != null) 'note': note,
      if (synced != null) 'synced': synced,
    });
  }

  SymptomLogsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<String>? symptoms,
    Value<int?>? severity,
    Value<String?>? note,
    Value<bool>? synced,
  }) {
    return SymptomLogsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      symptoms: symptoms ?? this.symptoms,
      severity: severity ?? this.severity,
      note: note ?? this.note,
      synced: synced ?? this.synced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (symptoms.present) {
      map['symptoms'] = Variable<String>(symptoms.value);
    }
    if (severity.present) {
      map['severity'] = Variable<int>(severity.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SymptomLogsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('symptoms: $symptoms, ')
          ..write('severity: $severity, ')
          ..write('note: $note, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }
}

class $DiaryEntriesTable extends DiaryEntries
    with TableInfo<$DiaryEntriesTable, DiaryEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DiaryEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _moodMeta = const VerificationMeta('mood');
  @override
  late final GeneratedColumn<int> mood = GeneratedColumn<int>(
    'mood',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _photoPathsMeta = const VerificationMeta(
    'photoPaths',
  );
  @override
  late final GeneratedColumn<String> photoPaths = GeneratedColumn<String>(
    'photo_paths',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
    'synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    kind,
    title,
    body,
    mood,
    photoPaths,
    synced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'diary_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<DiaryEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('mood')) {
      context.handle(
        _moodMeta,
        mood.isAcceptableOrUnknown(data['mood']!, _moodMeta),
      );
    }
    if (data.containsKey('photo_paths')) {
      context.handle(
        _photoPathsMeta,
        photoPaths.isAcceptableOrUnknown(data['photo_paths']!, _photoPathsMeta),
      );
    }
    if (data.containsKey('synced')) {
      context.handle(
        _syncedMeta,
        synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DiaryEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DiaryEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      mood: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mood'],
      ),
      photoPaths: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_paths'],
      ),
      synced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced'],
      )!,
    );
  }

  @override
  $DiaryEntriesTable createAlias(String alias) {
    return $DiaryEntriesTable(attachedDatabase, alias);
  }
}

class DiaryEntry extends DataClass implements Insertable<DiaryEntry> {
  final int id;
  final DateTime date;

  /// 'pregnancy'(임신일기) | 'parenting'(육아일기)
  final String kind;
  final String? title;
  final String body;

  /// 기분 1(나쁨)~5(좋음)
  final int? mood;

  /// 첨부 사진 경로들 (줄바꿈 구분). 경로엔 줄바꿈이 없어 안전하다.
  final String? photoPaths;
  final bool synced;
  const DiaryEntry({
    required this.id,
    required this.date,
    required this.kind,
    this.title,
    required this.body,
    this.mood,
    this.photoPaths,
    required this.synced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['kind'] = Variable<String>(kind);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    map['body'] = Variable<String>(body);
    if (!nullToAbsent || mood != null) {
      map['mood'] = Variable<int>(mood);
    }
    if (!nullToAbsent || photoPaths != null) {
      map['photo_paths'] = Variable<String>(photoPaths);
    }
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  DiaryEntriesCompanion toCompanion(bool nullToAbsent) {
    return DiaryEntriesCompanion(
      id: Value(id),
      date: Value(date),
      kind: Value(kind),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
      body: Value(body),
      mood: mood == null && nullToAbsent ? const Value.absent() : Value(mood),
      photoPaths: photoPaths == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPaths),
      synced: Value(synced),
    );
  }

  factory DiaryEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DiaryEntry(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      kind: serializer.fromJson<String>(json['kind']),
      title: serializer.fromJson<String?>(json['title']),
      body: serializer.fromJson<String>(json['body']),
      mood: serializer.fromJson<int?>(json['mood']),
      photoPaths: serializer.fromJson<String?>(json['photoPaths']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'kind': serializer.toJson<String>(kind),
      'title': serializer.toJson<String?>(title),
      'body': serializer.toJson<String>(body),
      'mood': serializer.toJson<int?>(mood),
      'photoPaths': serializer.toJson<String?>(photoPaths),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  DiaryEntry copyWith({
    int? id,
    DateTime? date,
    String? kind,
    Value<String?> title = const Value.absent(),
    String? body,
    Value<int?> mood = const Value.absent(),
    Value<String?> photoPaths = const Value.absent(),
    bool? synced,
  }) => DiaryEntry(
    id: id ?? this.id,
    date: date ?? this.date,
    kind: kind ?? this.kind,
    title: title.present ? title.value : this.title,
    body: body ?? this.body,
    mood: mood.present ? mood.value : this.mood,
    photoPaths: photoPaths.present ? photoPaths.value : this.photoPaths,
    synced: synced ?? this.synced,
  );
  DiaryEntry copyWithCompanion(DiaryEntriesCompanion data) {
    return DiaryEntry(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      kind: data.kind.present ? data.kind.value : this.kind,
      title: data.title.present ? data.title.value : this.title,
      body: data.body.present ? data.body.value : this.body,
      mood: data.mood.present ? data.mood.value : this.mood,
      photoPaths: data.photoPaths.present
          ? data.photoPaths.value
          : this.photoPaths,
      synced: data.synced.present ? data.synced.value : this.synced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DiaryEntry(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('kind: $kind, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('mood: $mood, ')
          ..write('photoPaths: $photoPaths, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, date, kind, title, body, mood, photoPaths, synced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DiaryEntry &&
          other.id == this.id &&
          other.date == this.date &&
          other.kind == this.kind &&
          other.title == this.title &&
          other.body == this.body &&
          other.mood == this.mood &&
          other.photoPaths == this.photoPaths &&
          other.synced == this.synced);
}

class DiaryEntriesCompanion extends UpdateCompanion<DiaryEntry> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<String> kind;
  final Value<String?> title;
  final Value<String> body;
  final Value<int?> mood;
  final Value<String?> photoPaths;
  final Value<bool> synced;
  const DiaryEntriesCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.kind = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.mood = const Value.absent(),
    this.photoPaths = const Value.absent(),
    this.synced = const Value.absent(),
  });
  DiaryEntriesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required String kind,
    this.title = const Value.absent(),
    required String body,
    this.mood = const Value.absent(),
    this.photoPaths = const Value.absent(),
    this.synced = const Value.absent(),
  }) : date = Value(date),
       kind = Value(kind),
       body = Value(body);
  static Insertable<DiaryEntry> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<String>? kind,
    Expression<String>? title,
    Expression<String>? body,
    Expression<int>? mood,
    Expression<String>? photoPaths,
    Expression<bool>? synced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (kind != null) 'kind': kind,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (mood != null) 'mood': mood,
      if (photoPaths != null) 'photo_paths': photoPaths,
      if (synced != null) 'synced': synced,
    });
  }

  DiaryEntriesCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<String>? kind,
    Value<String?>? title,
    Value<String>? body,
    Value<int?>? mood,
    Value<String?>? photoPaths,
    Value<bool>? synced,
  }) {
    return DiaryEntriesCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      kind: kind ?? this.kind,
      title: title ?? this.title,
      body: body ?? this.body,
      mood: mood ?? this.mood,
      photoPaths: photoPaths ?? this.photoPaths,
      synced: synced ?? this.synced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (mood.present) {
      map['mood'] = Variable<int>(mood.value);
    }
    if (photoPaths.present) {
      map['photo_paths'] = Variable<String>(photoPaths.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DiaryEntriesCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('kind: $kind, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('mood: $mood, ')
          ..write('photoPaths: $photoPaths, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }
}

class $UltrasoundPhotosTable extends UltrasoundPhotos
    with TableInfo<$UltrasoundPhotosTable, UltrasoundPhoto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UltrasoundPhotosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _takenAtMeta = const VerificationMeta(
    'takenAt',
  );
  @override
  late final GeneratedColumn<DateTime> takenAt = GeneratedColumn<DateTime>(
    'taken_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weekMeta = const VerificationMeta('week');
  @override
  late final GeneratedColumn<int> week = GeneratedColumn<int>(
    'week',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
    'path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
    'synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [id, takenAt, week, path, note, synced];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ultrasound_photos';
  @override
  VerificationContext validateIntegrity(
    Insertable<UltrasoundPhoto> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('taken_at')) {
      context.handle(
        _takenAtMeta,
        takenAt.isAcceptableOrUnknown(data['taken_at']!, _takenAtMeta),
      );
    } else if (isInserting) {
      context.missing(_takenAtMeta);
    }
    if (data.containsKey('week')) {
      context.handle(
        _weekMeta,
        week.isAcceptableOrUnknown(data['week']!, _weekMeta),
      );
    }
    if (data.containsKey('path')) {
      context.handle(
        _pathMeta,
        path.isAcceptableOrUnknown(data['path']!, _pathMeta),
      );
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('synced')) {
      context.handle(
        _syncedMeta,
        synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UltrasoundPhoto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UltrasoundPhoto(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      takenAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}taken_at'],
      )!,
      week: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}week'],
      ),
      path: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}path'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      synced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced'],
      )!,
    );
  }

  @override
  $UltrasoundPhotosTable createAlias(String alias) {
    return $UltrasoundPhotosTable(attachedDatabase, alias);
  }
}

class UltrasoundPhoto extends DataClass implements Insertable<UltrasoundPhoto> {
  final int id;
  final DateTime takenAt;

  /// 촬영 시점 임신 주차
  final int? week;
  final String path;
  final String? note;
  final bool synced;
  const UltrasoundPhoto({
    required this.id,
    required this.takenAt,
    this.week,
    required this.path,
    this.note,
    required this.synced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['taken_at'] = Variable<DateTime>(takenAt);
    if (!nullToAbsent || week != null) {
      map['week'] = Variable<int>(week);
    }
    map['path'] = Variable<String>(path);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  UltrasoundPhotosCompanion toCompanion(bool nullToAbsent) {
    return UltrasoundPhotosCompanion(
      id: Value(id),
      takenAt: Value(takenAt),
      week: week == null && nullToAbsent ? const Value.absent() : Value(week),
      path: Value(path),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      synced: Value(synced),
    );
  }

  factory UltrasoundPhoto.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UltrasoundPhoto(
      id: serializer.fromJson<int>(json['id']),
      takenAt: serializer.fromJson<DateTime>(json['takenAt']),
      week: serializer.fromJson<int?>(json['week']),
      path: serializer.fromJson<String>(json['path']),
      note: serializer.fromJson<String?>(json['note']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'takenAt': serializer.toJson<DateTime>(takenAt),
      'week': serializer.toJson<int?>(week),
      'path': serializer.toJson<String>(path),
      'note': serializer.toJson<String?>(note),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  UltrasoundPhoto copyWith({
    int? id,
    DateTime? takenAt,
    Value<int?> week = const Value.absent(),
    String? path,
    Value<String?> note = const Value.absent(),
    bool? synced,
  }) => UltrasoundPhoto(
    id: id ?? this.id,
    takenAt: takenAt ?? this.takenAt,
    week: week.present ? week.value : this.week,
    path: path ?? this.path,
    note: note.present ? note.value : this.note,
    synced: synced ?? this.synced,
  );
  UltrasoundPhoto copyWithCompanion(UltrasoundPhotosCompanion data) {
    return UltrasoundPhoto(
      id: data.id.present ? data.id.value : this.id,
      takenAt: data.takenAt.present ? data.takenAt.value : this.takenAt,
      week: data.week.present ? data.week.value : this.week,
      path: data.path.present ? data.path.value : this.path,
      note: data.note.present ? data.note.value : this.note,
      synced: data.synced.present ? data.synced.value : this.synced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UltrasoundPhoto(')
          ..write('id: $id, ')
          ..write('takenAt: $takenAt, ')
          ..write('week: $week, ')
          ..write('path: $path, ')
          ..write('note: $note, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, takenAt, week, path, note, synced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UltrasoundPhoto &&
          other.id == this.id &&
          other.takenAt == this.takenAt &&
          other.week == this.week &&
          other.path == this.path &&
          other.note == this.note &&
          other.synced == this.synced);
}

class UltrasoundPhotosCompanion extends UpdateCompanion<UltrasoundPhoto> {
  final Value<int> id;
  final Value<DateTime> takenAt;
  final Value<int?> week;
  final Value<String> path;
  final Value<String?> note;
  final Value<bool> synced;
  const UltrasoundPhotosCompanion({
    this.id = const Value.absent(),
    this.takenAt = const Value.absent(),
    this.week = const Value.absent(),
    this.path = const Value.absent(),
    this.note = const Value.absent(),
    this.synced = const Value.absent(),
  });
  UltrasoundPhotosCompanion.insert({
    this.id = const Value.absent(),
    required DateTime takenAt,
    this.week = const Value.absent(),
    required String path,
    this.note = const Value.absent(),
    this.synced = const Value.absent(),
  }) : takenAt = Value(takenAt),
       path = Value(path);
  static Insertable<UltrasoundPhoto> custom({
    Expression<int>? id,
    Expression<DateTime>? takenAt,
    Expression<int>? week,
    Expression<String>? path,
    Expression<String>? note,
    Expression<bool>? synced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (takenAt != null) 'taken_at': takenAt,
      if (week != null) 'week': week,
      if (path != null) 'path': path,
      if (note != null) 'note': note,
      if (synced != null) 'synced': synced,
    });
  }

  UltrasoundPhotosCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? takenAt,
    Value<int?>? week,
    Value<String>? path,
    Value<String?>? note,
    Value<bool>? synced,
  }) {
    return UltrasoundPhotosCompanion(
      id: id ?? this.id,
      takenAt: takenAt ?? this.takenAt,
      week: week ?? this.week,
      path: path ?? this.path,
      note: note ?? this.note,
      synced: synced ?? this.synced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (takenAt.present) {
      map['taken_at'] = Variable<DateTime>(takenAt.value);
    }
    if (week.present) {
      map['week'] = Variable<int>(week.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UltrasoundPhotosCompanion(')
          ..write('id: $id, ')
          ..write('takenAt: $takenAt, ')
          ..write('week: $week, ')
          ..write('path: $path, ')
          ..write('note: $note, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }
}

class $BabyProfilesTable extends BabyProfiles
    with TableInfo<$BabyProfilesTable, BabyProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BabyProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _birthDateMeta = const VerificationMeta(
    'birthDate',
  );
  @override
  late final GeneratedColumn<DateTime> birthDate = GeneratedColumn<DateTime>(
    'birth_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
    'gender',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _birthWeightKgMeta = const VerificationMeta(
    'birthWeightKg',
  );
  @override
  late final GeneratedColumn<double> birthWeightKg = GeneratedColumn<double>(
    'birth_weight_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _birthNoteMeta = const VerificationMeta(
    'birthNote',
  );
  @override
  late final GeneratedColumn<String> birthNote = GeneratedColumn<String>(
    'birth_note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
    'synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    birthDate,
    gender,
    photoPath,
    birthWeightKg,
    birthNote,
    synced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'baby_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<BabyProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('birth_date')) {
      context.handle(
        _birthDateMeta,
        birthDate.isAcceptableOrUnknown(data['birth_date']!, _birthDateMeta),
      );
    } else if (isInserting) {
      context.missing(_birthDateMeta);
    }
    if (data.containsKey('gender')) {
      context.handle(
        _genderMeta,
        gender.isAcceptableOrUnknown(data['gender']!, _genderMeta),
      );
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    if (data.containsKey('birth_weight_kg')) {
      context.handle(
        _birthWeightKgMeta,
        birthWeightKg.isAcceptableOrUnknown(
          data['birth_weight_kg']!,
          _birthWeightKgMeta,
        ),
      );
    }
    if (data.containsKey('birth_note')) {
      context.handle(
        _birthNoteMeta,
        birthNote.isAcceptableOrUnknown(data['birth_note']!, _birthNoteMeta),
      );
    }
    if (data.containsKey('synced')) {
      context.handle(
        _syncedMeta,
        synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BabyProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BabyProfile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      birthDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}birth_date'],
      )!,
      gender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gender'],
      ),
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      ),
      birthWeightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}birth_weight_kg'],
      ),
      birthNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}birth_note'],
      ),
      synced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced'],
      )!,
    );
  }

  @override
  $BabyProfilesTable createAlias(String alias) {
    return $BabyProfilesTable(attachedDatabase, alias);
  }
}

class BabyProfile extends DataClass implements Insertable<BabyProfile> {
  final int id;
  final String name;
  final DateTime birthDate;

  /// 'male' | 'female' | null
  final String? gender;
  final String? photoPath;

  /// 출생 체중(kg) — 출산 기록 시 입력
  final double? birthWeightKg;

  /// 분만 방법 등 출산 메모
  final String? birthNote;
  final bool synced;
  const BabyProfile({
    required this.id,
    required this.name,
    required this.birthDate,
    this.gender,
    this.photoPath,
    this.birthWeightKg,
    this.birthNote,
    required this.synced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['birth_date'] = Variable<DateTime>(birthDate);
    if (!nullToAbsent || gender != null) {
      map['gender'] = Variable<String>(gender);
    }
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    if (!nullToAbsent || birthWeightKg != null) {
      map['birth_weight_kg'] = Variable<double>(birthWeightKg);
    }
    if (!nullToAbsent || birthNote != null) {
      map['birth_note'] = Variable<String>(birthNote);
    }
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  BabyProfilesCompanion toCompanion(bool nullToAbsent) {
    return BabyProfilesCompanion(
      id: Value(id),
      name: Value(name),
      birthDate: Value(birthDate),
      gender: gender == null && nullToAbsent
          ? const Value.absent()
          : Value(gender),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      birthWeightKg: birthWeightKg == null && nullToAbsent
          ? const Value.absent()
          : Value(birthWeightKg),
      birthNote: birthNote == null && nullToAbsent
          ? const Value.absent()
          : Value(birthNote),
      synced: Value(synced),
    );
  }

  factory BabyProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BabyProfile(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      birthDate: serializer.fromJson<DateTime>(json['birthDate']),
      gender: serializer.fromJson<String?>(json['gender']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      birthWeightKg: serializer.fromJson<double?>(json['birthWeightKg']),
      birthNote: serializer.fromJson<String?>(json['birthNote']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'birthDate': serializer.toJson<DateTime>(birthDate),
      'gender': serializer.toJson<String?>(gender),
      'photoPath': serializer.toJson<String?>(photoPath),
      'birthWeightKg': serializer.toJson<double?>(birthWeightKg),
      'birthNote': serializer.toJson<String?>(birthNote),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  BabyProfile copyWith({
    int? id,
    String? name,
    DateTime? birthDate,
    Value<String?> gender = const Value.absent(),
    Value<String?> photoPath = const Value.absent(),
    Value<double?> birthWeightKg = const Value.absent(),
    Value<String?> birthNote = const Value.absent(),
    bool? synced,
  }) => BabyProfile(
    id: id ?? this.id,
    name: name ?? this.name,
    birthDate: birthDate ?? this.birthDate,
    gender: gender.present ? gender.value : this.gender,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
    birthWeightKg: birthWeightKg.present
        ? birthWeightKg.value
        : this.birthWeightKg,
    birthNote: birthNote.present ? birthNote.value : this.birthNote,
    synced: synced ?? this.synced,
  );
  BabyProfile copyWithCompanion(BabyProfilesCompanion data) {
    return BabyProfile(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      birthDate: data.birthDate.present ? data.birthDate.value : this.birthDate,
      gender: data.gender.present ? data.gender.value : this.gender,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      birthWeightKg: data.birthWeightKg.present
          ? data.birthWeightKg.value
          : this.birthWeightKg,
      birthNote: data.birthNote.present ? data.birthNote.value : this.birthNote,
      synced: data.synced.present ? data.synced.value : this.synced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BabyProfile(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('birthDate: $birthDate, ')
          ..write('gender: $gender, ')
          ..write('photoPath: $photoPath, ')
          ..write('birthWeightKg: $birthWeightKg, ')
          ..write('birthNote: $birthNote, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    birthDate,
    gender,
    photoPath,
    birthWeightKg,
    birthNote,
    synced,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BabyProfile &&
          other.id == this.id &&
          other.name == this.name &&
          other.birthDate == this.birthDate &&
          other.gender == this.gender &&
          other.photoPath == this.photoPath &&
          other.birthWeightKg == this.birthWeightKg &&
          other.birthNote == this.birthNote &&
          other.synced == this.synced);
}

class BabyProfilesCompanion extends UpdateCompanion<BabyProfile> {
  final Value<int> id;
  final Value<String> name;
  final Value<DateTime> birthDate;
  final Value<String?> gender;
  final Value<String?> photoPath;
  final Value<double?> birthWeightKg;
  final Value<String?> birthNote;
  final Value<bool> synced;
  const BabyProfilesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.gender = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.birthWeightKg = const Value.absent(),
    this.birthNote = const Value.absent(),
    this.synced = const Value.absent(),
  });
  BabyProfilesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required DateTime birthDate,
    this.gender = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.birthWeightKg = const Value.absent(),
    this.birthNote = const Value.absent(),
    this.synced = const Value.absent(),
  }) : name = Value(name),
       birthDate = Value(birthDate);
  static Insertable<BabyProfile> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<DateTime>? birthDate,
    Expression<String>? gender,
    Expression<String>? photoPath,
    Expression<double>? birthWeightKg,
    Expression<String>? birthNote,
    Expression<bool>? synced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (birthDate != null) 'birth_date': birthDate,
      if (gender != null) 'gender': gender,
      if (photoPath != null) 'photo_path': photoPath,
      if (birthWeightKg != null) 'birth_weight_kg': birthWeightKg,
      if (birthNote != null) 'birth_note': birthNote,
      if (synced != null) 'synced': synced,
    });
  }

  BabyProfilesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<DateTime>? birthDate,
    Value<String?>? gender,
    Value<String?>? photoPath,
    Value<double?>? birthWeightKg,
    Value<String?>? birthNote,
    Value<bool>? synced,
  }) {
    return BabyProfilesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      photoPath: photoPath ?? this.photoPath,
      birthWeightKg: birthWeightKg ?? this.birthWeightKg,
      birthNote: birthNote ?? this.birthNote,
      synced: synced ?? this.synced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (birthDate.present) {
      map['birth_date'] = Variable<DateTime>(birthDate.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (birthWeightKg.present) {
      map['birth_weight_kg'] = Variable<double>(birthWeightKg.value);
    }
    if (birthNote.present) {
      map['birth_note'] = Variable<String>(birthNote.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BabyProfilesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('birthDate: $birthDate, ')
          ..write('gender: $gender, ')
          ..write('photoPath: $photoPath, ')
          ..write('birthWeightKg: $birthWeightKg, ')
          ..write('birthNote: $birthNote, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }
}

class $FeedingLogsTable extends FeedingLogs
    with TableInfo<$FeedingLogsTable, FeedingLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FeedingLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _babyIdMeta = const VerificationMeta('babyId');
  @override
  late final GeneratedColumn<int> babyId = GeneratedColumn<int>(
    'baby_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timeMeta = const VerificationMeta('time');
  @override
  late final GeneratedColumn<DateTime> time = GeneratedColumn<DateTime>(
    'time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMlMeta = const VerificationMeta(
    'amountMl',
  );
  @override
  late final GeneratedColumn<int> amountMl = GeneratedColumn<int>(
    'amount_ml',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
    'synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    babyId,
    time,
    type,
    amountMl,
    note,
    synced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'feeding_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<FeedingLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('baby_id')) {
      context.handle(
        _babyIdMeta,
        babyId.isAcceptableOrUnknown(data['baby_id']!, _babyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_babyIdMeta);
    }
    if (data.containsKey('time')) {
      context.handle(
        _timeMeta,
        time.isAcceptableOrUnknown(data['time']!, _timeMeta),
      );
    } else if (isInserting) {
      context.missing(_timeMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('amount_ml')) {
      context.handle(
        _amountMlMeta,
        amountMl.isAcceptableOrUnknown(data['amount_ml']!, _amountMlMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('synced')) {
      context.handle(
        _syncedMeta,
        synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FeedingLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FeedingLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      babyId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}baby_id'],
      )!,
      time: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}time'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      amountMl: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_ml'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      synced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced'],
      )!,
    );
  }

  @override
  $FeedingLogsTable createAlias(String alias) {
    return $FeedingLogsTable(attachedDatabase, alias);
  }
}

class FeedingLog extends DataClass implements Insertable<FeedingLog> {
  final int id;
  final int babyId;
  final DateTime time;

  /// 'breast'(모유) | 'bottle'(분유) | 'solid'(이유식)
  final String type;
  final int? amountMl;
  final String? note;
  final bool synced;
  const FeedingLog({
    required this.id,
    required this.babyId,
    required this.time,
    required this.type,
    this.amountMl,
    this.note,
    required this.synced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['baby_id'] = Variable<int>(babyId);
    map['time'] = Variable<DateTime>(time);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || amountMl != null) {
      map['amount_ml'] = Variable<int>(amountMl);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  FeedingLogsCompanion toCompanion(bool nullToAbsent) {
    return FeedingLogsCompanion(
      id: Value(id),
      babyId: Value(babyId),
      time: Value(time),
      type: Value(type),
      amountMl: amountMl == null && nullToAbsent
          ? const Value.absent()
          : Value(amountMl),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      synced: Value(synced),
    );
  }

  factory FeedingLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FeedingLog(
      id: serializer.fromJson<int>(json['id']),
      babyId: serializer.fromJson<int>(json['babyId']),
      time: serializer.fromJson<DateTime>(json['time']),
      type: serializer.fromJson<String>(json['type']),
      amountMl: serializer.fromJson<int?>(json['amountMl']),
      note: serializer.fromJson<String?>(json['note']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'babyId': serializer.toJson<int>(babyId),
      'time': serializer.toJson<DateTime>(time),
      'type': serializer.toJson<String>(type),
      'amountMl': serializer.toJson<int?>(amountMl),
      'note': serializer.toJson<String?>(note),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  FeedingLog copyWith({
    int? id,
    int? babyId,
    DateTime? time,
    String? type,
    Value<int?> amountMl = const Value.absent(),
    Value<String?> note = const Value.absent(),
    bool? synced,
  }) => FeedingLog(
    id: id ?? this.id,
    babyId: babyId ?? this.babyId,
    time: time ?? this.time,
    type: type ?? this.type,
    amountMl: amountMl.present ? amountMl.value : this.amountMl,
    note: note.present ? note.value : this.note,
    synced: synced ?? this.synced,
  );
  FeedingLog copyWithCompanion(FeedingLogsCompanion data) {
    return FeedingLog(
      id: data.id.present ? data.id.value : this.id,
      babyId: data.babyId.present ? data.babyId.value : this.babyId,
      time: data.time.present ? data.time.value : this.time,
      type: data.type.present ? data.type.value : this.type,
      amountMl: data.amountMl.present ? data.amountMl.value : this.amountMl,
      note: data.note.present ? data.note.value : this.note,
      synced: data.synced.present ? data.synced.value : this.synced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FeedingLog(')
          ..write('id: $id, ')
          ..write('babyId: $babyId, ')
          ..write('time: $time, ')
          ..write('type: $type, ')
          ..write('amountMl: $amountMl, ')
          ..write('note: $note, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, babyId, time, type, amountMl, note, synced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FeedingLog &&
          other.id == this.id &&
          other.babyId == this.babyId &&
          other.time == this.time &&
          other.type == this.type &&
          other.amountMl == this.amountMl &&
          other.note == this.note &&
          other.synced == this.synced);
}

class FeedingLogsCompanion extends UpdateCompanion<FeedingLog> {
  final Value<int> id;
  final Value<int> babyId;
  final Value<DateTime> time;
  final Value<String> type;
  final Value<int?> amountMl;
  final Value<String?> note;
  final Value<bool> synced;
  const FeedingLogsCompanion({
    this.id = const Value.absent(),
    this.babyId = const Value.absent(),
    this.time = const Value.absent(),
    this.type = const Value.absent(),
    this.amountMl = const Value.absent(),
    this.note = const Value.absent(),
    this.synced = const Value.absent(),
  });
  FeedingLogsCompanion.insert({
    this.id = const Value.absent(),
    required int babyId,
    required DateTime time,
    required String type,
    this.amountMl = const Value.absent(),
    this.note = const Value.absent(),
    this.synced = const Value.absent(),
  }) : babyId = Value(babyId),
       time = Value(time),
       type = Value(type);
  static Insertable<FeedingLog> custom({
    Expression<int>? id,
    Expression<int>? babyId,
    Expression<DateTime>? time,
    Expression<String>? type,
    Expression<int>? amountMl,
    Expression<String>? note,
    Expression<bool>? synced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (babyId != null) 'baby_id': babyId,
      if (time != null) 'time': time,
      if (type != null) 'type': type,
      if (amountMl != null) 'amount_ml': amountMl,
      if (note != null) 'note': note,
      if (synced != null) 'synced': synced,
    });
  }

  FeedingLogsCompanion copyWith({
    Value<int>? id,
    Value<int>? babyId,
    Value<DateTime>? time,
    Value<String>? type,
    Value<int?>? amountMl,
    Value<String?>? note,
    Value<bool>? synced,
  }) {
    return FeedingLogsCompanion(
      id: id ?? this.id,
      babyId: babyId ?? this.babyId,
      time: time ?? this.time,
      type: type ?? this.type,
      amountMl: amountMl ?? this.amountMl,
      note: note ?? this.note,
      synced: synced ?? this.synced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (babyId.present) {
      map['baby_id'] = Variable<int>(babyId.value);
    }
    if (time.present) {
      map['time'] = Variable<DateTime>(time.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (amountMl.present) {
      map['amount_ml'] = Variable<int>(amountMl.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FeedingLogsCompanion(')
          ..write('id: $id, ')
          ..write('babyId: $babyId, ')
          ..write('time: $time, ')
          ..write('type: $type, ')
          ..write('amountMl: $amountMl, ')
          ..write('note: $note, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }
}

class $DiaperLogsTable extends DiaperLogs
    with TableInfo<$DiaperLogsTable, DiaperLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DiaperLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _babyIdMeta = const VerificationMeta('babyId');
  @override
  late final GeneratedColumn<int> babyId = GeneratedColumn<int>(
    'baby_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timeMeta = const VerificationMeta('time');
  @override
  late final GeneratedColumn<DateTime> time = GeneratedColumn<DateTime>(
    'time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
    'synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [id, babyId, time, type, note, synced];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'diaper_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<DiaperLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('baby_id')) {
      context.handle(
        _babyIdMeta,
        babyId.isAcceptableOrUnknown(data['baby_id']!, _babyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_babyIdMeta);
    }
    if (data.containsKey('time')) {
      context.handle(
        _timeMeta,
        time.isAcceptableOrUnknown(data['time']!, _timeMeta),
      );
    } else if (isInserting) {
      context.missing(_timeMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('synced')) {
      context.handle(
        _syncedMeta,
        synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DiaperLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DiaperLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      babyId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}baby_id'],
      )!,
      time: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}time'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      synced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced'],
      )!,
    );
  }

  @override
  $DiaperLogsTable createAlias(String alias) {
    return $DiaperLogsTable(attachedDatabase, alias);
  }
}

class DiaperLog extends DataClass implements Insertable<DiaperLog> {
  final int id;
  final int babyId;
  final DateTime time;

  /// 'wet'(소변) | 'dirty'(대변) | 'both'
  final String type;
  final String? note;
  final bool synced;
  const DiaperLog({
    required this.id,
    required this.babyId,
    required this.time,
    required this.type,
    this.note,
    required this.synced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['baby_id'] = Variable<int>(babyId);
    map['time'] = Variable<DateTime>(time);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  DiaperLogsCompanion toCompanion(bool nullToAbsent) {
    return DiaperLogsCompanion(
      id: Value(id),
      babyId: Value(babyId),
      time: Value(time),
      type: Value(type),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      synced: Value(synced),
    );
  }

  factory DiaperLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DiaperLog(
      id: serializer.fromJson<int>(json['id']),
      babyId: serializer.fromJson<int>(json['babyId']),
      time: serializer.fromJson<DateTime>(json['time']),
      type: serializer.fromJson<String>(json['type']),
      note: serializer.fromJson<String?>(json['note']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'babyId': serializer.toJson<int>(babyId),
      'time': serializer.toJson<DateTime>(time),
      'type': serializer.toJson<String>(type),
      'note': serializer.toJson<String?>(note),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  DiaperLog copyWith({
    int? id,
    int? babyId,
    DateTime? time,
    String? type,
    Value<String?> note = const Value.absent(),
    bool? synced,
  }) => DiaperLog(
    id: id ?? this.id,
    babyId: babyId ?? this.babyId,
    time: time ?? this.time,
    type: type ?? this.type,
    note: note.present ? note.value : this.note,
    synced: synced ?? this.synced,
  );
  DiaperLog copyWithCompanion(DiaperLogsCompanion data) {
    return DiaperLog(
      id: data.id.present ? data.id.value : this.id,
      babyId: data.babyId.present ? data.babyId.value : this.babyId,
      time: data.time.present ? data.time.value : this.time,
      type: data.type.present ? data.type.value : this.type,
      note: data.note.present ? data.note.value : this.note,
      synced: data.synced.present ? data.synced.value : this.synced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DiaperLog(')
          ..write('id: $id, ')
          ..write('babyId: $babyId, ')
          ..write('time: $time, ')
          ..write('type: $type, ')
          ..write('note: $note, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, babyId, time, type, note, synced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DiaperLog &&
          other.id == this.id &&
          other.babyId == this.babyId &&
          other.time == this.time &&
          other.type == this.type &&
          other.note == this.note &&
          other.synced == this.synced);
}

class DiaperLogsCompanion extends UpdateCompanion<DiaperLog> {
  final Value<int> id;
  final Value<int> babyId;
  final Value<DateTime> time;
  final Value<String> type;
  final Value<String?> note;
  final Value<bool> synced;
  const DiaperLogsCompanion({
    this.id = const Value.absent(),
    this.babyId = const Value.absent(),
    this.time = const Value.absent(),
    this.type = const Value.absent(),
    this.note = const Value.absent(),
    this.synced = const Value.absent(),
  });
  DiaperLogsCompanion.insert({
    this.id = const Value.absent(),
    required int babyId,
    required DateTime time,
    required String type,
    this.note = const Value.absent(),
    this.synced = const Value.absent(),
  }) : babyId = Value(babyId),
       time = Value(time),
       type = Value(type);
  static Insertable<DiaperLog> custom({
    Expression<int>? id,
    Expression<int>? babyId,
    Expression<DateTime>? time,
    Expression<String>? type,
    Expression<String>? note,
    Expression<bool>? synced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (babyId != null) 'baby_id': babyId,
      if (time != null) 'time': time,
      if (type != null) 'type': type,
      if (note != null) 'note': note,
      if (synced != null) 'synced': synced,
    });
  }

  DiaperLogsCompanion copyWith({
    Value<int>? id,
    Value<int>? babyId,
    Value<DateTime>? time,
    Value<String>? type,
    Value<String?>? note,
    Value<bool>? synced,
  }) {
    return DiaperLogsCompanion(
      id: id ?? this.id,
      babyId: babyId ?? this.babyId,
      time: time ?? this.time,
      type: type ?? this.type,
      note: note ?? this.note,
      synced: synced ?? this.synced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (babyId.present) {
      map['baby_id'] = Variable<int>(babyId.value);
    }
    if (time.present) {
      map['time'] = Variable<DateTime>(time.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DiaperLogsCompanion(')
          ..write('id: $id, ')
          ..write('babyId: $babyId, ')
          ..write('time: $time, ')
          ..write('type: $type, ')
          ..write('note: $note, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }
}

class $VaccinationRecordsTable extends VaccinationRecords
    with TableInfo<$VaccinationRecordsTable, VaccinationRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VaccinationRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _babyIdMeta = const VerificationMeta('babyId');
  @override
  late final GeneratedColumn<int> babyId = GeneratedColumn<int>(
    'baby_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _doneDateMeta = const VerificationMeta(
    'doneDate',
  );
  @override
  late final GeneratedColumn<DateTime> doneDate = GeneratedColumn<DateTime>(
    'done_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
    'synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [id, babyId, name, doneDate, synced];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vaccination_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<VaccinationRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('baby_id')) {
      context.handle(
        _babyIdMeta,
        babyId.isAcceptableOrUnknown(data['baby_id']!, _babyIdMeta),
      );
    } else if (isInserting) {
      context.missing(_babyIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('done_date')) {
      context.handle(
        _doneDateMeta,
        doneDate.isAcceptableOrUnknown(data['done_date']!, _doneDateMeta),
      );
    } else if (isInserting) {
      context.missing(_doneDateMeta);
    }
    if (data.containsKey('synced')) {
      context.handle(
        _syncedMeta,
        synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VaccinationRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VaccinationRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      babyId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}baby_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      doneDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}done_date'],
      )!,
      synced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced'],
      )!,
    );
  }

  @override
  $VaccinationRecordsTable createAlias(String alias) {
    return $VaccinationRecordsTable(attachedDatabase, alias);
  }
}

class VaccinationRecord extends DataClass
    implements Insertable<VaccinationRecord> {
  final int id;
  final int babyId;
  final String name;
  final DateTime doneDate;
  final bool synced;
  const VaccinationRecord({
    required this.id,
    required this.babyId,
    required this.name,
    required this.doneDate,
    required this.synced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['baby_id'] = Variable<int>(babyId);
    map['name'] = Variable<String>(name);
    map['done_date'] = Variable<DateTime>(doneDate);
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  VaccinationRecordsCompanion toCompanion(bool nullToAbsent) {
    return VaccinationRecordsCompanion(
      id: Value(id),
      babyId: Value(babyId),
      name: Value(name),
      doneDate: Value(doneDate),
      synced: Value(synced),
    );
  }

  factory VaccinationRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VaccinationRecord(
      id: serializer.fromJson<int>(json['id']),
      babyId: serializer.fromJson<int>(json['babyId']),
      name: serializer.fromJson<String>(json['name']),
      doneDate: serializer.fromJson<DateTime>(json['doneDate']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'babyId': serializer.toJson<int>(babyId),
      'name': serializer.toJson<String>(name),
      'doneDate': serializer.toJson<DateTime>(doneDate),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  VaccinationRecord copyWith({
    int? id,
    int? babyId,
    String? name,
    DateTime? doneDate,
    bool? synced,
  }) => VaccinationRecord(
    id: id ?? this.id,
    babyId: babyId ?? this.babyId,
    name: name ?? this.name,
    doneDate: doneDate ?? this.doneDate,
    synced: synced ?? this.synced,
  );
  VaccinationRecord copyWithCompanion(VaccinationRecordsCompanion data) {
    return VaccinationRecord(
      id: data.id.present ? data.id.value : this.id,
      babyId: data.babyId.present ? data.babyId.value : this.babyId,
      name: data.name.present ? data.name.value : this.name,
      doneDate: data.doneDate.present ? data.doneDate.value : this.doneDate,
      synced: data.synced.present ? data.synced.value : this.synced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VaccinationRecord(')
          ..write('id: $id, ')
          ..write('babyId: $babyId, ')
          ..write('name: $name, ')
          ..write('doneDate: $doneDate, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, babyId, name, doneDate, synced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VaccinationRecord &&
          other.id == this.id &&
          other.babyId == this.babyId &&
          other.name == this.name &&
          other.doneDate == this.doneDate &&
          other.synced == this.synced);
}

class VaccinationRecordsCompanion extends UpdateCompanion<VaccinationRecord> {
  final Value<int> id;
  final Value<int> babyId;
  final Value<String> name;
  final Value<DateTime> doneDate;
  final Value<bool> synced;
  const VaccinationRecordsCompanion({
    this.id = const Value.absent(),
    this.babyId = const Value.absent(),
    this.name = const Value.absent(),
    this.doneDate = const Value.absent(),
    this.synced = const Value.absent(),
  });
  VaccinationRecordsCompanion.insert({
    this.id = const Value.absent(),
    required int babyId,
    required String name,
    required DateTime doneDate,
    this.synced = const Value.absent(),
  }) : babyId = Value(babyId),
       name = Value(name),
       doneDate = Value(doneDate);
  static Insertable<VaccinationRecord> custom({
    Expression<int>? id,
    Expression<int>? babyId,
    Expression<String>? name,
    Expression<DateTime>? doneDate,
    Expression<bool>? synced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (babyId != null) 'baby_id': babyId,
      if (name != null) 'name': name,
      if (doneDate != null) 'done_date': doneDate,
      if (synced != null) 'synced': synced,
    });
  }

  VaccinationRecordsCompanion copyWith({
    Value<int>? id,
    Value<int>? babyId,
    Value<String>? name,
    Value<DateTime>? doneDate,
    Value<bool>? synced,
  }) {
    return VaccinationRecordsCompanion(
      id: id ?? this.id,
      babyId: babyId ?? this.babyId,
      name: name ?? this.name,
      doneDate: doneDate ?? this.doneDate,
      synced: synced ?? this.synced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (babyId.present) {
      map['baby_id'] = Variable<int>(babyId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (doneDate.present) {
      map['done_date'] = Variable<DateTime>(doneDate.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VaccinationRecordsCompanion(')
          ..write('id: $id, ')
          ..write('babyId: $babyId, ')
          ..write('name: $name, ')
          ..write('doneDate: $doneDate, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }
}

class $DayEventsTable extends DayEvents
    with TableInfo<$DayEventsTable, DayEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DayEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
    'synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [id, date, type, title, note, synced];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'day_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<DayEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('synced')) {
      context.handle(
        _syncedMeta,
        synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DayEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DayEvent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      synced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced'],
      )!,
    );
  }

  @override
  $DayEventsTable createAlias(String alias) {
    return $DayEventsTable(attachedDatabase, alias);
  }
}

class DayEvent extends DataClass implements Insertable<DayEvent> {
  final int id;
  final DateTime date;

  /// 'ovulation'(배란) | 'medication'(약) | 'injection'(주사)
  /// | 'hospital'(병원) | 'pregnancy'(임신)
  final String type;
  final String? title;
  final String? note;
  final bool synced;
  const DayEvent({
    required this.id,
    required this.date,
    required this.type,
    this.title,
    this.note,
    required this.synced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  DayEventsCompanion toCompanion(bool nullToAbsent) {
    return DayEventsCompanion(
      id: Value(id),
      date: Value(date),
      type: Value(type),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      synced: Value(synced),
    );
  }

  factory DayEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DayEvent(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      type: serializer.fromJson<String>(json['type']),
      title: serializer.fromJson<String?>(json['title']),
      note: serializer.fromJson<String?>(json['note']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'type': serializer.toJson<String>(type),
      'title': serializer.toJson<String?>(title),
      'note': serializer.toJson<String?>(note),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  DayEvent copyWith({
    int? id,
    DateTime? date,
    String? type,
    Value<String?> title = const Value.absent(),
    Value<String?> note = const Value.absent(),
    bool? synced,
  }) => DayEvent(
    id: id ?? this.id,
    date: date ?? this.date,
    type: type ?? this.type,
    title: title.present ? title.value : this.title,
    note: note.present ? note.value : this.note,
    synced: synced ?? this.synced,
  );
  DayEvent copyWithCompanion(DayEventsCompanion data) {
    return DayEvent(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      type: data.type.present ? data.type.value : this.type,
      title: data.title.present ? data.title.value : this.title,
      note: data.note.present ? data.note.value : this.note,
      synced: data.synced.present ? data.synced.value : this.synced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DayEvent(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('note: $note, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, type, title, note, synced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DayEvent &&
          other.id == this.id &&
          other.date == this.date &&
          other.type == this.type &&
          other.title == this.title &&
          other.note == this.note &&
          other.synced == this.synced);
}

class DayEventsCompanion extends UpdateCompanion<DayEvent> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<String> type;
  final Value<String?> title;
  final Value<String?> note;
  final Value<bool> synced;
  const DayEventsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.type = const Value.absent(),
    this.title = const Value.absent(),
    this.note = const Value.absent(),
    this.synced = const Value.absent(),
  });
  DayEventsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required String type,
    this.title = const Value.absent(),
    this.note = const Value.absent(),
    this.synced = const Value.absent(),
  }) : date = Value(date),
       type = Value(type);
  static Insertable<DayEvent> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<String>? type,
    Expression<String>? title,
    Expression<String>? note,
    Expression<bool>? synced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (type != null) 'type': type,
      if (title != null) 'title': title,
      if (note != null) 'note': note,
      if (synced != null) 'synced': synced,
    });
  }

  DayEventsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<String>? type,
    Value<String?>? title,
    Value<String?>? note,
    Value<bool>? synced,
  }) {
    return DayEventsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      type: type ?? this.type,
      title: title ?? this.title,
      note: note ?? this.note,
      synced: synced ?? this.synced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DayEventsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('note: $note, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CycleLogsTable cycleLogs = $CycleLogsTable(this);
  late final $BbtLogsTable bbtLogs = $BbtLogsTable(this);
  late final $TestLogsTable testLogs = $TestLogsTable(this);
  late final $PregnanciesTable pregnancies = $PregnanciesTable(this);
  late final $RemindersTable reminders = $RemindersTable(this);
  late final $WeightLogsTable weightLogs = $WeightLogsTable(this);
  late final $SymptomLogsTable symptomLogs = $SymptomLogsTable(this);
  late final $DiaryEntriesTable diaryEntries = $DiaryEntriesTable(this);
  late final $UltrasoundPhotosTable ultrasoundPhotos = $UltrasoundPhotosTable(
    this,
  );
  late final $BabyProfilesTable babyProfiles = $BabyProfilesTable(this);
  late final $FeedingLogsTable feedingLogs = $FeedingLogsTable(this);
  late final $DiaperLogsTable diaperLogs = $DiaperLogsTable(this);
  late final $VaccinationRecordsTable vaccinationRecords =
      $VaccinationRecordsTable(this);
  late final $DayEventsTable dayEvents = $DayEventsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    cycleLogs,
    bbtLogs,
    testLogs,
    pregnancies,
    reminders,
    weightLogs,
    symptomLogs,
    diaryEntries,
    ultrasoundPhotos,
    babyProfiles,
    feedingLogs,
    diaperLogs,
    vaccinationRecords,
    dayEvents,
  ];
}

typedef $$CycleLogsTableCreateCompanionBuilder =
    CycleLogsCompanion Function({
      Value<int> id,
      required DateTime startDate,
      Value<DateTime?> endDate,
      Value<int?> flow,
      Value<String?> symptoms,
      Value<String?> note,
      Value<bool> synced,
    });
typedef $$CycleLogsTableUpdateCompanionBuilder =
    CycleLogsCompanion Function({
      Value<int> id,
      Value<DateTime> startDate,
      Value<DateTime?> endDate,
      Value<int?> flow,
      Value<String?> symptoms,
      Value<String?> note,
      Value<bool> synced,
    });

class $$CycleLogsTableFilterComposer
    extends Composer<_$AppDatabase, $CycleLogsTable> {
  $$CycleLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get flow => $composableBuilder(
    column: $table.flow,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get symptoms => $composableBuilder(
    column: $table.symptoms,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CycleLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $CycleLogsTable> {
  $$CycleLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get flow => $composableBuilder(
    column: $table.flow,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get symptoms => $composableBuilder(
    column: $table.symptoms,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CycleLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CycleLogsTable> {
  $$CycleLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<int> get flow =>
      $composableBuilder(column: $table.flow, builder: (column) => column);

  GeneratedColumn<String> get symptoms =>
      $composableBuilder(column: $table.symptoms, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);
}

class $$CycleLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CycleLogsTable,
          CycleLog,
          $$CycleLogsTableFilterComposer,
          $$CycleLogsTableOrderingComposer,
          $$CycleLogsTableAnnotationComposer,
          $$CycleLogsTableCreateCompanionBuilder,
          $$CycleLogsTableUpdateCompanionBuilder,
          (CycleLog, BaseReferences<_$AppDatabase, $CycleLogsTable, CycleLog>),
          CycleLog,
          PrefetchHooks Function()
        > {
  $$CycleLogsTableTableManager(_$AppDatabase db, $CycleLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CycleLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CycleLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CycleLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime?> endDate = const Value.absent(),
                Value<int?> flow = const Value.absent(),
                Value<String?> symptoms = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<bool> synced = const Value.absent(),
              }) => CycleLogsCompanion(
                id: id,
                startDate: startDate,
                endDate: endDate,
                flow: flow,
                symptoms: symptoms,
                note: note,
                synced: synced,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime startDate,
                Value<DateTime?> endDate = const Value.absent(),
                Value<int?> flow = const Value.absent(),
                Value<String?> symptoms = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<bool> synced = const Value.absent(),
              }) => CycleLogsCompanion.insert(
                id: id,
                startDate: startDate,
                endDate: endDate,
                flow: flow,
                symptoms: symptoms,
                note: note,
                synced: synced,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CycleLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CycleLogsTable,
      CycleLog,
      $$CycleLogsTableFilterComposer,
      $$CycleLogsTableOrderingComposer,
      $$CycleLogsTableAnnotationComposer,
      $$CycleLogsTableCreateCompanionBuilder,
      $$CycleLogsTableUpdateCompanionBuilder,
      (CycleLog, BaseReferences<_$AppDatabase, $CycleLogsTable, CycleLog>),
      CycleLog,
      PrefetchHooks Function()
    >;
typedef $$BbtLogsTableCreateCompanionBuilder =
    BbtLogsCompanion Function({
      Value<int> id,
      required DateTime date,
      required double temperature,
      Value<String?> note,
      Value<bool> synced,
    });
typedef $$BbtLogsTableUpdateCompanionBuilder =
    BbtLogsCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<double> temperature,
      Value<String?> note,
      Value<bool> synced,
    });

class $$BbtLogsTableFilterComposer
    extends Composer<_$AppDatabase, $BbtLogsTable> {
  $$BbtLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BbtLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $BbtLogsTable> {
  $$BbtLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BbtLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BbtLogsTable> {
  $$BbtLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);
}

class $$BbtLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BbtLogsTable,
          BbtLog,
          $$BbtLogsTableFilterComposer,
          $$BbtLogsTableOrderingComposer,
          $$BbtLogsTableAnnotationComposer,
          $$BbtLogsTableCreateCompanionBuilder,
          $$BbtLogsTableUpdateCompanionBuilder,
          (BbtLog, BaseReferences<_$AppDatabase, $BbtLogsTable, BbtLog>),
          BbtLog,
          PrefetchHooks Function()
        > {
  $$BbtLogsTableTableManager(_$AppDatabase db, $BbtLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BbtLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BbtLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BbtLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<double> temperature = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<bool> synced = const Value.absent(),
              }) => BbtLogsCompanion(
                id: id,
                date: date,
                temperature: temperature,
                note: note,
                synced: synced,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                required double temperature,
                Value<String?> note = const Value.absent(),
                Value<bool> synced = const Value.absent(),
              }) => BbtLogsCompanion.insert(
                id: id,
                date: date,
                temperature: temperature,
                note: note,
                synced: synced,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BbtLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BbtLogsTable,
      BbtLog,
      $$BbtLogsTableFilterComposer,
      $$BbtLogsTableOrderingComposer,
      $$BbtLogsTableAnnotationComposer,
      $$BbtLogsTableCreateCompanionBuilder,
      $$BbtLogsTableUpdateCompanionBuilder,
      (BbtLog, BaseReferences<_$AppDatabase, $BbtLogsTable, BbtLog>),
      BbtLog,
      PrefetchHooks Function()
    >;
typedef $$TestLogsTableCreateCompanionBuilder =
    TestLogsCompanion Function({
      Value<int> id,
      required DateTime date,
      required String kind,
      required String result,
      Value<String?> photoPath,
      Value<double?> ratio,
      Value<String?> note,
      Value<bool> synced,
    });
typedef $$TestLogsTableUpdateCompanionBuilder =
    TestLogsCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<String> kind,
      Value<String> result,
      Value<String?> photoPath,
      Value<double?> ratio,
      Value<String?> note,
      Value<bool> synced,
    });

class $$TestLogsTableFilterComposer
    extends Composer<_$AppDatabase, $TestLogsTable> {
  $$TestLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get result => $composableBuilder(
    column: $table.result,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get ratio => $composableBuilder(
    column: $table.ratio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TestLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $TestLogsTable> {
  $$TestLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get result => $composableBuilder(
    column: $table.result,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get ratio => $composableBuilder(
    column: $table.ratio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TestLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TestLogsTable> {
  $$TestLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get result =>
      $composableBuilder(column: $table.result, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<double> get ratio =>
      $composableBuilder(column: $table.ratio, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);
}

class $$TestLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TestLogsTable,
          TestLog,
          $$TestLogsTableFilterComposer,
          $$TestLogsTableOrderingComposer,
          $$TestLogsTableAnnotationComposer,
          $$TestLogsTableCreateCompanionBuilder,
          $$TestLogsTableUpdateCompanionBuilder,
          (TestLog, BaseReferences<_$AppDatabase, $TestLogsTable, TestLog>),
          TestLog,
          PrefetchHooks Function()
        > {
  $$TestLogsTableTableManager(_$AppDatabase db, $TestLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TestLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TestLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TestLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> result = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<double?> ratio = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<bool> synced = const Value.absent(),
              }) => TestLogsCompanion(
                id: id,
                date: date,
                kind: kind,
                result: result,
                photoPath: photoPath,
                ratio: ratio,
                note: note,
                synced: synced,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                required String kind,
                required String result,
                Value<String?> photoPath = const Value.absent(),
                Value<double?> ratio = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<bool> synced = const Value.absent(),
              }) => TestLogsCompanion.insert(
                id: id,
                date: date,
                kind: kind,
                result: result,
                photoPath: photoPath,
                ratio: ratio,
                note: note,
                synced: synced,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TestLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TestLogsTable,
      TestLog,
      $$TestLogsTableFilterComposer,
      $$TestLogsTableOrderingComposer,
      $$TestLogsTableAnnotationComposer,
      $$TestLogsTableCreateCompanionBuilder,
      $$TestLogsTableUpdateCompanionBuilder,
      (TestLog, BaseReferences<_$AppDatabase, $TestLogsTable, TestLog>),
      TestLog,
      PrefetchHooks Function()
    >;
typedef $$PregnanciesTableCreateCompanionBuilder =
    PregnanciesCompanion Function({
      Value<int> id,
      required DateTime lastPeriodStart,
      Value<DateTime?> dueDateOverride,
      Value<String> status,
      required DateTime createdAt,
      Value<String?> note,
      Value<bool> synced,
    });
typedef $$PregnanciesTableUpdateCompanionBuilder =
    PregnanciesCompanion Function({
      Value<int> id,
      Value<DateTime> lastPeriodStart,
      Value<DateTime?> dueDateOverride,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<String?> note,
      Value<bool> synced,
    });

class $$PregnanciesTableFilterComposer
    extends Composer<_$AppDatabase, $PregnanciesTable> {
  $$PregnanciesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastPeriodStart => $composableBuilder(
    column: $table.lastPeriodStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDateOverride => $composableBuilder(
    column: $table.dueDateOverride,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PregnanciesTableOrderingComposer
    extends Composer<_$AppDatabase, $PregnanciesTable> {
  $$PregnanciesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastPeriodStart => $composableBuilder(
    column: $table.lastPeriodStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDateOverride => $composableBuilder(
    column: $table.dueDateOverride,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PregnanciesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PregnanciesTable> {
  $$PregnanciesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get lastPeriodStart => $composableBuilder(
    column: $table.lastPeriodStart,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dueDateOverride => $composableBuilder(
    column: $table.dueDateOverride,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);
}

class $$PregnanciesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PregnanciesTable,
          Pregnancy,
          $$PregnanciesTableFilterComposer,
          $$PregnanciesTableOrderingComposer,
          $$PregnanciesTableAnnotationComposer,
          $$PregnanciesTableCreateCompanionBuilder,
          $$PregnanciesTableUpdateCompanionBuilder,
          (
            Pregnancy,
            BaseReferences<_$AppDatabase, $PregnanciesTable, Pregnancy>,
          ),
          Pregnancy,
          PrefetchHooks Function()
        > {
  $$PregnanciesTableTableManager(_$AppDatabase db, $PregnanciesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PregnanciesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PregnanciesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PregnanciesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> lastPeriodStart = const Value.absent(),
                Value<DateTime?> dueDateOverride = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<bool> synced = const Value.absent(),
              }) => PregnanciesCompanion(
                id: id,
                lastPeriodStart: lastPeriodStart,
                dueDateOverride: dueDateOverride,
                status: status,
                createdAt: createdAt,
                note: note,
                synced: synced,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime lastPeriodStart,
                Value<DateTime?> dueDateOverride = const Value.absent(),
                Value<String> status = const Value.absent(),
                required DateTime createdAt,
                Value<String?> note = const Value.absent(),
                Value<bool> synced = const Value.absent(),
              }) => PregnanciesCompanion.insert(
                id: id,
                lastPeriodStart: lastPeriodStart,
                dueDateOverride: dueDateOverride,
                status: status,
                createdAt: createdAt,
                note: note,
                synced: synced,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PregnanciesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PregnanciesTable,
      Pregnancy,
      $$PregnanciesTableFilterComposer,
      $$PregnanciesTableOrderingComposer,
      $$PregnanciesTableAnnotationComposer,
      $$PregnanciesTableCreateCompanionBuilder,
      $$PregnanciesTableUpdateCompanionBuilder,
      (Pregnancy, BaseReferences<_$AppDatabase, $PregnanciesTable, Pregnancy>),
      Pregnancy,
      PrefetchHooks Function()
    >;
typedef $$RemindersTableCreateCompanionBuilder =
    RemindersCompanion Function({
      Value<int> id,
      required String kind,
      required String title,
      Value<String?> body,
      required DateTime nextTrigger,
      Value<String> repeat,
      Value<bool> enabled,
      Value<bool> synced,
    });
typedef $$RemindersTableUpdateCompanionBuilder =
    RemindersCompanion Function({
      Value<int> id,
      Value<String> kind,
      Value<String> title,
      Value<String?> body,
      Value<DateTime> nextTrigger,
      Value<String> repeat,
      Value<bool> enabled,
      Value<bool> synced,
    });

class $$RemindersTableFilterComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextTrigger => $composableBuilder(
    column: $table.nextTrigger,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get repeat => $composableBuilder(
    column: $table.repeat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RemindersTableOrderingComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextTrigger => $composableBuilder(
    column: $table.nextTrigger,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get repeat => $composableBuilder(
    column: $table.repeat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RemindersTableAnnotationComposer
    extends Composer<_$AppDatabase, $RemindersTable> {
  $$RemindersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<DateTime> get nextTrigger => $composableBuilder(
    column: $table.nextTrigger,
    builder: (column) => column,
  );

  GeneratedColumn<String> get repeat =>
      $composableBuilder(column: $table.repeat, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);
}

class $$RemindersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RemindersTable,
          Reminder,
          $$RemindersTableFilterComposer,
          $$RemindersTableOrderingComposer,
          $$RemindersTableAnnotationComposer,
          $$RemindersTableCreateCompanionBuilder,
          $$RemindersTableUpdateCompanionBuilder,
          (Reminder, BaseReferences<_$AppDatabase, $RemindersTable, Reminder>),
          Reminder,
          PrefetchHooks Function()
        > {
  $$RemindersTableTableManager(_$AppDatabase db, $RemindersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RemindersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RemindersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RemindersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> body = const Value.absent(),
                Value<DateTime> nextTrigger = const Value.absent(),
                Value<String> repeat = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<bool> synced = const Value.absent(),
              }) => RemindersCompanion(
                id: id,
                kind: kind,
                title: title,
                body: body,
                nextTrigger: nextTrigger,
                repeat: repeat,
                enabled: enabled,
                synced: synced,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String kind,
                required String title,
                Value<String?> body = const Value.absent(),
                required DateTime nextTrigger,
                Value<String> repeat = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<bool> synced = const Value.absent(),
              }) => RemindersCompanion.insert(
                id: id,
                kind: kind,
                title: title,
                body: body,
                nextTrigger: nextTrigger,
                repeat: repeat,
                enabled: enabled,
                synced: synced,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RemindersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RemindersTable,
      Reminder,
      $$RemindersTableFilterComposer,
      $$RemindersTableOrderingComposer,
      $$RemindersTableAnnotationComposer,
      $$RemindersTableCreateCompanionBuilder,
      $$RemindersTableUpdateCompanionBuilder,
      (Reminder, BaseReferences<_$AppDatabase, $RemindersTable, Reminder>),
      Reminder,
      PrefetchHooks Function()
    >;
typedef $$WeightLogsTableCreateCompanionBuilder =
    WeightLogsCompanion Function({
      Value<int> id,
      required DateTime date,
      required double weightKg,
      Value<String?> note,
      Value<bool> synced,
    });
typedef $$WeightLogsTableUpdateCompanionBuilder =
    WeightLogsCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<double> weightKg,
      Value<String?> note,
      Value<bool> synced,
    });

class $$WeightLogsTableFilterComposer
    extends Composer<_$AppDatabase, $WeightLogsTable> {
  $$WeightLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WeightLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $WeightLogsTable> {
  $$WeightLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WeightLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeightLogsTable> {
  $$WeightLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);
}

class $$WeightLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeightLogsTable,
          WeightLog,
          $$WeightLogsTableFilterComposer,
          $$WeightLogsTableOrderingComposer,
          $$WeightLogsTableAnnotationComposer,
          $$WeightLogsTableCreateCompanionBuilder,
          $$WeightLogsTableUpdateCompanionBuilder,
          (
            WeightLog,
            BaseReferences<_$AppDatabase, $WeightLogsTable, WeightLog>,
          ),
          WeightLog,
          PrefetchHooks Function()
        > {
  $$WeightLogsTableTableManager(_$AppDatabase db, $WeightLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeightLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeightLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeightLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<double> weightKg = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<bool> synced = const Value.absent(),
              }) => WeightLogsCompanion(
                id: id,
                date: date,
                weightKg: weightKg,
                note: note,
                synced: synced,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                required double weightKg,
                Value<String?> note = const Value.absent(),
                Value<bool> synced = const Value.absent(),
              }) => WeightLogsCompanion.insert(
                id: id,
                date: date,
                weightKg: weightKg,
                note: note,
                synced: synced,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WeightLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeightLogsTable,
      WeightLog,
      $$WeightLogsTableFilterComposer,
      $$WeightLogsTableOrderingComposer,
      $$WeightLogsTableAnnotationComposer,
      $$WeightLogsTableCreateCompanionBuilder,
      $$WeightLogsTableUpdateCompanionBuilder,
      (WeightLog, BaseReferences<_$AppDatabase, $WeightLogsTable, WeightLog>),
      WeightLog,
      PrefetchHooks Function()
    >;
typedef $$SymptomLogsTableCreateCompanionBuilder =
    SymptomLogsCompanion Function({
      Value<int> id,
      required DateTime date,
      required String symptoms,
      Value<int?> severity,
      Value<String?> note,
      Value<bool> synced,
    });
typedef $$SymptomLogsTableUpdateCompanionBuilder =
    SymptomLogsCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<String> symptoms,
      Value<int?> severity,
      Value<String?> note,
      Value<bool> synced,
    });

class $$SymptomLogsTableFilterComposer
    extends Composer<_$AppDatabase, $SymptomLogsTable> {
  $$SymptomLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get symptoms => $composableBuilder(
    column: $table.symptoms,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SymptomLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $SymptomLogsTable> {
  $$SymptomLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get symptoms => $composableBuilder(
    column: $table.symptoms,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SymptomLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SymptomLogsTable> {
  $$SymptomLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get symptoms =>
      $composableBuilder(column: $table.symptoms, builder: (column) => column);

  GeneratedColumn<int> get severity =>
      $composableBuilder(column: $table.severity, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);
}

class $$SymptomLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SymptomLogsTable,
          SymptomLog,
          $$SymptomLogsTableFilterComposer,
          $$SymptomLogsTableOrderingComposer,
          $$SymptomLogsTableAnnotationComposer,
          $$SymptomLogsTableCreateCompanionBuilder,
          $$SymptomLogsTableUpdateCompanionBuilder,
          (
            SymptomLog,
            BaseReferences<_$AppDatabase, $SymptomLogsTable, SymptomLog>,
          ),
          SymptomLog,
          PrefetchHooks Function()
        > {
  $$SymptomLogsTableTableManager(_$AppDatabase db, $SymptomLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SymptomLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SymptomLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SymptomLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> symptoms = const Value.absent(),
                Value<int?> severity = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<bool> synced = const Value.absent(),
              }) => SymptomLogsCompanion(
                id: id,
                date: date,
                symptoms: symptoms,
                severity: severity,
                note: note,
                synced: synced,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                required String symptoms,
                Value<int?> severity = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<bool> synced = const Value.absent(),
              }) => SymptomLogsCompanion.insert(
                id: id,
                date: date,
                symptoms: symptoms,
                severity: severity,
                note: note,
                synced: synced,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SymptomLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SymptomLogsTable,
      SymptomLog,
      $$SymptomLogsTableFilterComposer,
      $$SymptomLogsTableOrderingComposer,
      $$SymptomLogsTableAnnotationComposer,
      $$SymptomLogsTableCreateCompanionBuilder,
      $$SymptomLogsTableUpdateCompanionBuilder,
      (
        SymptomLog,
        BaseReferences<_$AppDatabase, $SymptomLogsTable, SymptomLog>,
      ),
      SymptomLog,
      PrefetchHooks Function()
    >;
typedef $$DiaryEntriesTableCreateCompanionBuilder =
    DiaryEntriesCompanion Function({
      Value<int> id,
      required DateTime date,
      required String kind,
      Value<String?> title,
      required String body,
      Value<int?> mood,
      Value<String?> photoPaths,
      Value<bool> synced,
    });
typedef $$DiaryEntriesTableUpdateCompanionBuilder =
    DiaryEntriesCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<String> kind,
      Value<String?> title,
      Value<String> body,
      Value<int?> mood,
      Value<String?> photoPaths,
      Value<bool> synced,
    });

class $$DiaryEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $DiaryEntriesTable> {
  $$DiaryEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get mood => $composableBuilder(
    column: $table.mood,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPaths => $composableBuilder(
    column: $table.photoPaths,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DiaryEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $DiaryEntriesTable> {
  $$DiaryEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mood => $composableBuilder(
    column: $table.mood,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPaths => $composableBuilder(
    column: $table.photoPaths,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DiaryEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DiaryEntriesTable> {
  $$DiaryEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<int> get mood =>
      $composableBuilder(column: $table.mood, builder: (column) => column);

  GeneratedColumn<String> get photoPaths => $composableBuilder(
    column: $table.photoPaths,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);
}

class $$DiaryEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DiaryEntriesTable,
          DiaryEntry,
          $$DiaryEntriesTableFilterComposer,
          $$DiaryEntriesTableOrderingComposer,
          $$DiaryEntriesTableAnnotationComposer,
          $$DiaryEntriesTableCreateCompanionBuilder,
          $$DiaryEntriesTableUpdateCompanionBuilder,
          (
            DiaryEntry,
            BaseReferences<_$AppDatabase, $DiaryEntriesTable, DiaryEntry>,
          ),
          DiaryEntry,
          PrefetchHooks Function()
        > {
  $$DiaryEntriesTableTableManager(_$AppDatabase db, $DiaryEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DiaryEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DiaryEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DiaryEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<int?> mood = const Value.absent(),
                Value<String?> photoPaths = const Value.absent(),
                Value<bool> synced = const Value.absent(),
              }) => DiaryEntriesCompanion(
                id: id,
                date: date,
                kind: kind,
                title: title,
                body: body,
                mood: mood,
                photoPaths: photoPaths,
                synced: synced,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                required String kind,
                Value<String?> title = const Value.absent(),
                required String body,
                Value<int?> mood = const Value.absent(),
                Value<String?> photoPaths = const Value.absent(),
                Value<bool> synced = const Value.absent(),
              }) => DiaryEntriesCompanion.insert(
                id: id,
                date: date,
                kind: kind,
                title: title,
                body: body,
                mood: mood,
                photoPaths: photoPaths,
                synced: synced,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DiaryEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DiaryEntriesTable,
      DiaryEntry,
      $$DiaryEntriesTableFilterComposer,
      $$DiaryEntriesTableOrderingComposer,
      $$DiaryEntriesTableAnnotationComposer,
      $$DiaryEntriesTableCreateCompanionBuilder,
      $$DiaryEntriesTableUpdateCompanionBuilder,
      (
        DiaryEntry,
        BaseReferences<_$AppDatabase, $DiaryEntriesTable, DiaryEntry>,
      ),
      DiaryEntry,
      PrefetchHooks Function()
    >;
typedef $$UltrasoundPhotosTableCreateCompanionBuilder =
    UltrasoundPhotosCompanion Function({
      Value<int> id,
      required DateTime takenAt,
      Value<int?> week,
      required String path,
      Value<String?> note,
      Value<bool> synced,
    });
typedef $$UltrasoundPhotosTableUpdateCompanionBuilder =
    UltrasoundPhotosCompanion Function({
      Value<int> id,
      Value<DateTime> takenAt,
      Value<int?> week,
      Value<String> path,
      Value<String?> note,
      Value<bool> synced,
    });

class $$UltrasoundPhotosTableFilterComposer
    extends Composer<_$AppDatabase, $UltrasoundPhotosTable> {
  $$UltrasoundPhotosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get takenAt => $composableBuilder(
    column: $table.takenAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get week => $composableBuilder(
    column: $table.week,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UltrasoundPhotosTableOrderingComposer
    extends Composer<_$AppDatabase, $UltrasoundPhotosTable> {
  $$UltrasoundPhotosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get takenAt => $composableBuilder(
    column: $table.takenAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get week => $composableBuilder(
    column: $table.week,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UltrasoundPhotosTableAnnotationComposer
    extends Composer<_$AppDatabase, $UltrasoundPhotosTable> {
  $$UltrasoundPhotosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get takenAt =>
      $composableBuilder(column: $table.takenAt, builder: (column) => column);

  GeneratedColumn<int> get week =>
      $composableBuilder(column: $table.week, builder: (column) => column);

  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);
}

class $$UltrasoundPhotosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UltrasoundPhotosTable,
          UltrasoundPhoto,
          $$UltrasoundPhotosTableFilterComposer,
          $$UltrasoundPhotosTableOrderingComposer,
          $$UltrasoundPhotosTableAnnotationComposer,
          $$UltrasoundPhotosTableCreateCompanionBuilder,
          $$UltrasoundPhotosTableUpdateCompanionBuilder,
          (
            UltrasoundPhoto,
            BaseReferences<
              _$AppDatabase,
              $UltrasoundPhotosTable,
              UltrasoundPhoto
            >,
          ),
          UltrasoundPhoto,
          PrefetchHooks Function()
        > {
  $$UltrasoundPhotosTableTableManager(
    _$AppDatabase db,
    $UltrasoundPhotosTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UltrasoundPhotosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UltrasoundPhotosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UltrasoundPhotosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> takenAt = const Value.absent(),
                Value<int?> week = const Value.absent(),
                Value<String> path = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<bool> synced = const Value.absent(),
              }) => UltrasoundPhotosCompanion(
                id: id,
                takenAt: takenAt,
                week: week,
                path: path,
                note: note,
                synced: synced,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime takenAt,
                Value<int?> week = const Value.absent(),
                required String path,
                Value<String?> note = const Value.absent(),
                Value<bool> synced = const Value.absent(),
              }) => UltrasoundPhotosCompanion.insert(
                id: id,
                takenAt: takenAt,
                week: week,
                path: path,
                note: note,
                synced: synced,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UltrasoundPhotosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UltrasoundPhotosTable,
      UltrasoundPhoto,
      $$UltrasoundPhotosTableFilterComposer,
      $$UltrasoundPhotosTableOrderingComposer,
      $$UltrasoundPhotosTableAnnotationComposer,
      $$UltrasoundPhotosTableCreateCompanionBuilder,
      $$UltrasoundPhotosTableUpdateCompanionBuilder,
      (
        UltrasoundPhoto,
        BaseReferences<_$AppDatabase, $UltrasoundPhotosTable, UltrasoundPhoto>,
      ),
      UltrasoundPhoto,
      PrefetchHooks Function()
    >;
typedef $$BabyProfilesTableCreateCompanionBuilder =
    BabyProfilesCompanion Function({
      Value<int> id,
      required String name,
      required DateTime birthDate,
      Value<String?> gender,
      Value<String?> photoPath,
      Value<double?> birthWeightKg,
      Value<String?> birthNote,
      Value<bool> synced,
    });
typedef $$BabyProfilesTableUpdateCompanionBuilder =
    BabyProfilesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<DateTime> birthDate,
      Value<String?> gender,
      Value<String?> photoPath,
      Value<double?> birthWeightKg,
      Value<String?> birthNote,
      Value<bool> synced,
    });

class $$BabyProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $BabyProfilesTable> {
  $$BabyProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get birthWeightKg => $composableBuilder(
    column: $table.birthWeightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get birthNote => $composableBuilder(
    column: $table.birthNote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BabyProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $BabyProfilesTable> {
  $$BabyProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get birthWeightKg => $composableBuilder(
    column: $table.birthWeightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get birthNote => $composableBuilder(
    column: $table.birthNote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BabyProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BabyProfilesTable> {
  $$BabyProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get birthDate =>
      $composableBuilder(column: $table.birthDate, builder: (column) => column);

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<double> get birthWeightKg => $composableBuilder(
    column: $table.birthWeightKg,
    builder: (column) => column,
  );

  GeneratedColumn<String> get birthNote =>
      $composableBuilder(column: $table.birthNote, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);
}

class $$BabyProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BabyProfilesTable,
          BabyProfile,
          $$BabyProfilesTableFilterComposer,
          $$BabyProfilesTableOrderingComposer,
          $$BabyProfilesTableAnnotationComposer,
          $$BabyProfilesTableCreateCompanionBuilder,
          $$BabyProfilesTableUpdateCompanionBuilder,
          (
            BabyProfile,
            BaseReferences<_$AppDatabase, $BabyProfilesTable, BabyProfile>,
          ),
          BabyProfile,
          PrefetchHooks Function()
        > {
  $$BabyProfilesTableTableManager(_$AppDatabase db, $BabyProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BabyProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BabyProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BabyProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> birthDate = const Value.absent(),
                Value<String?> gender = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<double?> birthWeightKg = const Value.absent(),
                Value<String?> birthNote = const Value.absent(),
                Value<bool> synced = const Value.absent(),
              }) => BabyProfilesCompanion(
                id: id,
                name: name,
                birthDate: birthDate,
                gender: gender,
                photoPath: photoPath,
                birthWeightKg: birthWeightKg,
                birthNote: birthNote,
                synced: synced,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required DateTime birthDate,
                Value<String?> gender = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<double?> birthWeightKg = const Value.absent(),
                Value<String?> birthNote = const Value.absent(),
                Value<bool> synced = const Value.absent(),
              }) => BabyProfilesCompanion.insert(
                id: id,
                name: name,
                birthDate: birthDate,
                gender: gender,
                photoPath: photoPath,
                birthWeightKg: birthWeightKg,
                birthNote: birthNote,
                synced: synced,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BabyProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BabyProfilesTable,
      BabyProfile,
      $$BabyProfilesTableFilterComposer,
      $$BabyProfilesTableOrderingComposer,
      $$BabyProfilesTableAnnotationComposer,
      $$BabyProfilesTableCreateCompanionBuilder,
      $$BabyProfilesTableUpdateCompanionBuilder,
      (
        BabyProfile,
        BaseReferences<_$AppDatabase, $BabyProfilesTable, BabyProfile>,
      ),
      BabyProfile,
      PrefetchHooks Function()
    >;
typedef $$FeedingLogsTableCreateCompanionBuilder =
    FeedingLogsCompanion Function({
      Value<int> id,
      required int babyId,
      required DateTime time,
      required String type,
      Value<int?> amountMl,
      Value<String?> note,
      Value<bool> synced,
    });
typedef $$FeedingLogsTableUpdateCompanionBuilder =
    FeedingLogsCompanion Function({
      Value<int> id,
      Value<int> babyId,
      Value<DateTime> time,
      Value<String> type,
      Value<int?> amountMl,
      Value<String?> note,
      Value<bool> synced,
    });

class $$FeedingLogsTableFilterComposer
    extends Composer<_$AppDatabase, $FeedingLogsTable> {
  $$FeedingLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get babyId => $composableBuilder(
    column: $table.babyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountMl => $composableBuilder(
    column: $table.amountMl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FeedingLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $FeedingLogsTable> {
  $$FeedingLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get babyId => $composableBuilder(
    column: $table.babyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountMl => $composableBuilder(
    column: $table.amountMl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FeedingLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FeedingLogsTable> {
  $$FeedingLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get babyId =>
      $composableBuilder(column: $table.babyId, builder: (column) => column);

  GeneratedColumn<DateTime> get time =>
      $composableBuilder(column: $table.time, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get amountMl =>
      $composableBuilder(column: $table.amountMl, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);
}

class $$FeedingLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FeedingLogsTable,
          FeedingLog,
          $$FeedingLogsTableFilterComposer,
          $$FeedingLogsTableOrderingComposer,
          $$FeedingLogsTableAnnotationComposer,
          $$FeedingLogsTableCreateCompanionBuilder,
          $$FeedingLogsTableUpdateCompanionBuilder,
          (
            FeedingLog,
            BaseReferences<_$AppDatabase, $FeedingLogsTable, FeedingLog>,
          ),
          FeedingLog,
          PrefetchHooks Function()
        > {
  $$FeedingLogsTableTableManager(_$AppDatabase db, $FeedingLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FeedingLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FeedingLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FeedingLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> babyId = const Value.absent(),
                Value<DateTime> time = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int?> amountMl = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<bool> synced = const Value.absent(),
              }) => FeedingLogsCompanion(
                id: id,
                babyId: babyId,
                time: time,
                type: type,
                amountMl: amountMl,
                note: note,
                synced: synced,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int babyId,
                required DateTime time,
                required String type,
                Value<int?> amountMl = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<bool> synced = const Value.absent(),
              }) => FeedingLogsCompanion.insert(
                id: id,
                babyId: babyId,
                time: time,
                type: type,
                amountMl: amountMl,
                note: note,
                synced: synced,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FeedingLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FeedingLogsTable,
      FeedingLog,
      $$FeedingLogsTableFilterComposer,
      $$FeedingLogsTableOrderingComposer,
      $$FeedingLogsTableAnnotationComposer,
      $$FeedingLogsTableCreateCompanionBuilder,
      $$FeedingLogsTableUpdateCompanionBuilder,
      (
        FeedingLog,
        BaseReferences<_$AppDatabase, $FeedingLogsTable, FeedingLog>,
      ),
      FeedingLog,
      PrefetchHooks Function()
    >;
typedef $$DiaperLogsTableCreateCompanionBuilder =
    DiaperLogsCompanion Function({
      Value<int> id,
      required int babyId,
      required DateTime time,
      required String type,
      Value<String?> note,
      Value<bool> synced,
    });
typedef $$DiaperLogsTableUpdateCompanionBuilder =
    DiaperLogsCompanion Function({
      Value<int> id,
      Value<int> babyId,
      Value<DateTime> time,
      Value<String> type,
      Value<String?> note,
      Value<bool> synced,
    });

class $$DiaperLogsTableFilterComposer
    extends Composer<_$AppDatabase, $DiaperLogsTable> {
  $$DiaperLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get babyId => $composableBuilder(
    column: $table.babyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DiaperLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $DiaperLogsTable> {
  $$DiaperLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get babyId => $composableBuilder(
    column: $table.babyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get time => $composableBuilder(
    column: $table.time,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DiaperLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DiaperLogsTable> {
  $$DiaperLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get babyId =>
      $composableBuilder(column: $table.babyId, builder: (column) => column);

  GeneratedColumn<DateTime> get time =>
      $composableBuilder(column: $table.time, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);
}

class $$DiaperLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DiaperLogsTable,
          DiaperLog,
          $$DiaperLogsTableFilterComposer,
          $$DiaperLogsTableOrderingComposer,
          $$DiaperLogsTableAnnotationComposer,
          $$DiaperLogsTableCreateCompanionBuilder,
          $$DiaperLogsTableUpdateCompanionBuilder,
          (
            DiaperLog,
            BaseReferences<_$AppDatabase, $DiaperLogsTable, DiaperLog>,
          ),
          DiaperLog,
          PrefetchHooks Function()
        > {
  $$DiaperLogsTableTableManager(_$AppDatabase db, $DiaperLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DiaperLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DiaperLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DiaperLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> babyId = const Value.absent(),
                Value<DateTime> time = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<bool> synced = const Value.absent(),
              }) => DiaperLogsCompanion(
                id: id,
                babyId: babyId,
                time: time,
                type: type,
                note: note,
                synced: synced,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int babyId,
                required DateTime time,
                required String type,
                Value<String?> note = const Value.absent(),
                Value<bool> synced = const Value.absent(),
              }) => DiaperLogsCompanion.insert(
                id: id,
                babyId: babyId,
                time: time,
                type: type,
                note: note,
                synced: synced,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DiaperLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DiaperLogsTable,
      DiaperLog,
      $$DiaperLogsTableFilterComposer,
      $$DiaperLogsTableOrderingComposer,
      $$DiaperLogsTableAnnotationComposer,
      $$DiaperLogsTableCreateCompanionBuilder,
      $$DiaperLogsTableUpdateCompanionBuilder,
      (DiaperLog, BaseReferences<_$AppDatabase, $DiaperLogsTable, DiaperLog>),
      DiaperLog,
      PrefetchHooks Function()
    >;
typedef $$VaccinationRecordsTableCreateCompanionBuilder =
    VaccinationRecordsCompanion Function({
      Value<int> id,
      required int babyId,
      required String name,
      required DateTime doneDate,
      Value<bool> synced,
    });
typedef $$VaccinationRecordsTableUpdateCompanionBuilder =
    VaccinationRecordsCompanion Function({
      Value<int> id,
      Value<int> babyId,
      Value<String> name,
      Value<DateTime> doneDate,
      Value<bool> synced,
    });

class $$VaccinationRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $VaccinationRecordsTable> {
  $$VaccinationRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get babyId => $composableBuilder(
    column: $table.babyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get doneDate => $composableBuilder(
    column: $table.doneDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnFilters(column),
  );
}

class $$VaccinationRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $VaccinationRecordsTable> {
  $$VaccinationRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get babyId => $composableBuilder(
    column: $table.babyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get doneDate => $composableBuilder(
    column: $table.doneDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VaccinationRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $VaccinationRecordsTable> {
  $$VaccinationRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get babyId =>
      $composableBuilder(column: $table.babyId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get doneDate =>
      $composableBuilder(column: $table.doneDate, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);
}

class $$VaccinationRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VaccinationRecordsTable,
          VaccinationRecord,
          $$VaccinationRecordsTableFilterComposer,
          $$VaccinationRecordsTableOrderingComposer,
          $$VaccinationRecordsTableAnnotationComposer,
          $$VaccinationRecordsTableCreateCompanionBuilder,
          $$VaccinationRecordsTableUpdateCompanionBuilder,
          (
            VaccinationRecord,
            BaseReferences<
              _$AppDatabase,
              $VaccinationRecordsTable,
              VaccinationRecord
            >,
          ),
          VaccinationRecord,
          PrefetchHooks Function()
        > {
  $$VaccinationRecordsTableTableManager(
    _$AppDatabase db,
    $VaccinationRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VaccinationRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VaccinationRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VaccinationRecordsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> babyId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> doneDate = const Value.absent(),
                Value<bool> synced = const Value.absent(),
              }) => VaccinationRecordsCompanion(
                id: id,
                babyId: babyId,
                name: name,
                doneDate: doneDate,
                synced: synced,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int babyId,
                required String name,
                required DateTime doneDate,
                Value<bool> synced = const Value.absent(),
              }) => VaccinationRecordsCompanion.insert(
                id: id,
                babyId: babyId,
                name: name,
                doneDate: doneDate,
                synced: synced,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$VaccinationRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VaccinationRecordsTable,
      VaccinationRecord,
      $$VaccinationRecordsTableFilterComposer,
      $$VaccinationRecordsTableOrderingComposer,
      $$VaccinationRecordsTableAnnotationComposer,
      $$VaccinationRecordsTableCreateCompanionBuilder,
      $$VaccinationRecordsTableUpdateCompanionBuilder,
      (
        VaccinationRecord,
        BaseReferences<
          _$AppDatabase,
          $VaccinationRecordsTable,
          VaccinationRecord
        >,
      ),
      VaccinationRecord,
      PrefetchHooks Function()
    >;
typedef $$DayEventsTableCreateCompanionBuilder =
    DayEventsCompanion Function({
      Value<int> id,
      required DateTime date,
      required String type,
      Value<String?> title,
      Value<String?> note,
      Value<bool> synced,
    });
typedef $$DayEventsTableUpdateCompanionBuilder =
    DayEventsCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<String> type,
      Value<String?> title,
      Value<String?> note,
      Value<bool> synced,
    });

class $$DayEventsTableFilterComposer
    extends Composer<_$AppDatabase, $DayEventsTable> {
  $$DayEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DayEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $DayEventsTable> {
  $$DayEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DayEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DayEventsTable> {
  $$DayEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);
}

class $$DayEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DayEventsTable,
          DayEvent,
          $$DayEventsTableFilterComposer,
          $$DayEventsTableOrderingComposer,
          $$DayEventsTableAnnotationComposer,
          $$DayEventsTableCreateCompanionBuilder,
          $$DayEventsTableUpdateCompanionBuilder,
          (DayEvent, BaseReferences<_$AppDatabase, $DayEventsTable, DayEvent>),
          DayEvent,
          PrefetchHooks Function()
        > {
  $$DayEventsTableTableManager(_$AppDatabase db, $DayEventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DayEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DayEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DayEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<bool> synced = const Value.absent(),
              }) => DayEventsCompanion(
                id: id,
                date: date,
                type: type,
                title: title,
                note: note,
                synced: synced,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                required String type,
                Value<String?> title = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<bool> synced = const Value.absent(),
              }) => DayEventsCompanion.insert(
                id: id,
                date: date,
                type: type,
                title: title,
                note: note,
                synced: synced,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DayEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DayEventsTable,
      DayEvent,
      $$DayEventsTableFilterComposer,
      $$DayEventsTableOrderingComposer,
      $$DayEventsTableAnnotationComposer,
      $$DayEventsTableCreateCompanionBuilder,
      $$DayEventsTableUpdateCompanionBuilder,
      (DayEvent, BaseReferences<_$AppDatabase, $DayEventsTable, DayEvent>),
      DayEvent,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CycleLogsTableTableManager get cycleLogs =>
      $$CycleLogsTableTableManager(_db, _db.cycleLogs);
  $$BbtLogsTableTableManager get bbtLogs =>
      $$BbtLogsTableTableManager(_db, _db.bbtLogs);
  $$TestLogsTableTableManager get testLogs =>
      $$TestLogsTableTableManager(_db, _db.testLogs);
  $$PregnanciesTableTableManager get pregnancies =>
      $$PregnanciesTableTableManager(_db, _db.pregnancies);
  $$RemindersTableTableManager get reminders =>
      $$RemindersTableTableManager(_db, _db.reminders);
  $$WeightLogsTableTableManager get weightLogs =>
      $$WeightLogsTableTableManager(_db, _db.weightLogs);
  $$SymptomLogsTableTableManager get symptomLogs =>
      $$SymptomLogsTableTableManager(_db, _db.symptomLogs);
  $$DiaryEntriesTableTableManager get diaryEntries =>
      $$DiaryEntriesTableTableManager(_db, _db.diaryEntries);
  $$UltrasoundPhotosTableTableManager get ultrasoundPhotos =>
      $$UltrasoundPhotosTableTableManager(_db, _db.ultrasoundPhotos);
  $$BabyProfilesTableTableManager get babyProfiles =>
      $$BabyProfilesTableTableManager(_db, _db.babyProfiles);
  $$FeedingLogsTableTableManager get feedingLogs =>
      $$FeedingLogsTableTableManager(_db, _db.feedingLogs);
  $$DiaperLogsTableTableManager get diaperLogs =>
      $$DiaperLogsTableTableManager(_db, _db.diaperLogs);
  $$VaccinationRecordsTableTableManager get vaccinationRecords =>
      $$VaccinationRecordsTableTableManager(_db, _db.vaccinationRecords);
  $$DayEventsTableTableManager get dayEvents =>
      $$DayEventsTableTableManager(_db, _db.dayEvents);
}
