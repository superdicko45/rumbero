import 'dart:async';

class ValidatorProvider{

  final validarEmail = StreamTransformer<String, String>.fromHandlers(
    handleData: (email, sink) {

      Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regExp = new RegExp(pattern);

      if(regExp.hasMatch(email)) sink.add(email);
      else sink.addError('Email no es correcto');
    }
  );

  final validarLenght = StreamTransformer<String, String>.fromHandlers(
    handleData: (input, sink) {
      if(input.length >= 6) sink.add(input);
      else sink.addError('Más de 6 caractéres por favor');
    }
  );

  final validarNombre = StreamTransformer<String, String>.fromHandlers(
    handleData: (input, sink) {

      if(input.length < 6) sink.addError('Más de 6 caractéres por favor');
      else if(input.length > 100) sink.addError('Menos de 100 caractéres por favor'); 
      else sink.add(input);
    }
  );

  final validarDesc = StreamTransformer<String, String>.fromHandlers(
    handleData: (input, sink) {

      if(input.length < 6) sink.addError('Más de 6 caractéres por favor');
      else if(input.length > 500) sink.addError('Menos de 500 caractéres por favor'); 
      else sink.add(input);
    }
  );

}