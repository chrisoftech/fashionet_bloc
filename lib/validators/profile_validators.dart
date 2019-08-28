import 'dart:async';

class ProfileValidators {
  final validateFirstName = StreamTransformer<String, String>.fromHandlers(
      handleData: (String firstname, EventSink<String> sink) {
    if (firstname.isEmpty) {
      sink.addError('Enter your firstname');
    } else {
      sink.add(firstname);
    }
  });

  final validateLastName = StreamTransformer<String, String>.fromHandlers(
      handleData: (String lastname, EventSink<String> sink) {
    if (lastname.isEmpty) {
      sink.addError('Enter your lastname');
    } else {
      sink.add(lastname);
    }
  });

  final validateBusinessName = StreamTransformer<String, String>.fromHandlers(
      handleData: (String businessName, EventSink<String> sink) {
    if (businessName.isEmpty) {
      sink.addError('Enter your business name');
    } else {
      sink.add(businessName);
    }
  });

  final validateBusinessDescription =
      StreamTransformer<String, String>.fromHandlers(
          handleData: (String businessDescription, EventSink<String> sink) {
    if (businessDescription.isEmpty || businessDescription.length < 20) {
      sink.addError(
          'Your business description should be 20-50 characters long');
    } else {
      sink.add(businessDescription);
    }
  });

  final validatePhoneNumber = StreamTransformer<String, String>.fromHandlers(
      handleData: (String phoneNumber, EventSink<String> sink) async {
    if (phoneNumber.isEmpty) {
      sink.addError('Enter your primary phone number');
    } else {
      sink.add(phoneNumber);
    }
  });

  // final validateOtherPhoneNumber =
  //     StreamTransformer<String, String>.fromHandlers(
  //         handleData: (String otherPhoneNumber, EventSink<String> sink) {
  //   if (otherPhoneNumber.isEmpty) {
  //     sink.addError('Enter your other phone number');
  //   } else {
  //     sink.add(otherPhoneNumber);
  //   }
  // });

  final validateLocation = StreamTransformer<String, String>.fromHandlers(
      handleData: (String location, EventSink<String> sink) {
    if (location.isEmpty) {
      sink.addError('Enter your business location');
    } else {
      sink.add(location);
    }
  });
}
