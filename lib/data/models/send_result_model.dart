import 'step_model.dart';

class SendResultModel {
  final String id;
  final List<StepModel> steps;
  final String path;

  SendResultModel({required this.id, required this.steps, required this.path});

  Map<String, dynamic> toJson() => {
        'id': id,
        'result': {
          'steps': steps.map((step) => step.toJson()).toList(),
          'path': path,
        },
      };
}
