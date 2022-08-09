import 'dart:math';

class MyApi{

List<String> createStringArray(String string){
  String resultString = string.substring(1, string.length - 1);
  List<String> list = resultString.split(',');
  int index = 0;
  for (var item in list) {
    list[index] = item.trim();
    index++;
  }
  return list;
}

MyApi();
}

