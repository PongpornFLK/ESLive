import 'package:es_live/core/config/dio_config.dart';
import 'package:es_live/core/model/patch_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final patchProvider = FutureProvider<List<PatchData>>((ref) async {
  try{
    final res = await dio.get('/patch');
    final List<dynamic> patchList = res.data;
    
    return patchList.map((json) => PatchData.fromjson(json)).toList();
  }catch(e){
    throw Exception("$e");
  }

});

final patchDetailProvider = FutureProvider.family<PatchData , String>((ref , patchId) async {
  try{
    final res = await dio.get('/patch/$patchId');
    
    return PatchData.fromjson(res.data);
  }catch(e){
    throw Exception("$e");
  }

});