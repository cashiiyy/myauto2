import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/auto_model.dart';
import '../services/auto_service.dart';

final autoServiceProvider = Provider((ref) => AutoService());

final autoListProvider = StateProvider<List<AutoModel>>((ref) => []);

final selectedAutoProvider = StateProvider<AutoModel?>((ref) => null);
