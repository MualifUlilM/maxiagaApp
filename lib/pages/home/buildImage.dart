import 'package:flutter/material.dart';

class ImageBuild{
  ImageProvider buildImg(String photo){
    if(photo == null){
      return AssetImage('lib/assets/images/avatar.png');
    }else{
      return NetworkImage(photo);
    }
  }
}