import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class TopDestinationEvent extends Equatable {
   TopDestinationEvent([List props = const []]) : super(props) ;
}

class LoadTopDestinationEvent extends TopDestinationEvent{}
