
class Validators {

   static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

   static final RegExp _phoneRegExp = RegExp(
    r'(^(?:[+0]9)?[0-9]{10,12}$)',
  );
  static isValidEmail(String email) {
    return _emailRegExp.hasMatch(email);
  }
 static isValidPhone(String phone) {
    return _phoneRegExp.hasMatch(phone);
  }

  static isPhoneCodeValid(String code){
    if (code.length == 6){
      return true;
    } 
    return false;
  }
  
}