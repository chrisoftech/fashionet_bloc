import 'dart:async';

class CategoryValidators {
  
  final validateTitle = StreamTransformer<String, String>.fromHandlers(
      handleData: (String title, EventSink<String> sink) {
    if (title.isEmpty) {
      sink.addError('Enter category title');
    } else {
      sink.add(title);
    }
  });

  final validateDescription = StreamTransformer<String, String>.fromHandlers(
      handleData: (String description, EventSink<String> sink) {
    if (description.isEmpty || description.length < 10) {
      sink.addError('Description should more than 10 characters long');
    } else {
      sink.add(description);
    }
  });
}