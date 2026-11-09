
// ignore: must_be_immutable
import 'package:jdonutscodetest/base_architecture/core/master_object.dart';

// ignore: must_be_immutable
class RewardModel extends MasterObject<RewardModel> {
  String? title;
  int? completed;
  int? target;
  int? points;
  String? kind;

  RewardModel({
     super.id,
    this.title,
    this.completed,
    this.target,
    this.points,
    this.kind,
  });

  @override
  RewardModel fromMap(dynamicData){
    id= dynamicData['id'];
    title= dynamicData['title'];
    completed= dynamicData['completed'];
    target= dynamicData['target'];
    points= dynamicData['points'];
    kind= dynamicData['kind'];
 return this; }
  @override
  List<RewardModel> fromMapList(List list) =>
      list.map((v) => RewardModel().fromMap(v)).toList();

  @override
  Map<String, dynamic>? toMap (RewardModel? object ){ return {};}

  @override
  List<Map<String, dynamic>?> toMapList (List<RewardModel> objectList ){ throw UnimplementedError();}
  @override List<Object?> get props => [id, title, completed, target, points, kind];
}

