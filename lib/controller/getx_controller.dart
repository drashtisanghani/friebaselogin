import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';


///-------------------------------------------GetxController---------------------------------------------------------------------------///
class GetController extends GetxController {
  Rx<TextEditingController> name = TextEditingController().obs;
  Rx<TextEditingController> phoneNo = TextEditingController().obs;
  RxString errorEmail = "".obs;
  RxString errorPass = "".obs;
  String nameError = '';
  String phoneNoError = '';
  bool isLoading = false;
}
