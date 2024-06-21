class TextValidator {
  String? phone(String text) {
    if (text.length != 11) {
      return 'شماره تماس باید 11 رقم باشد';
    }
    return null;
  }

  String? orderItem(String text) {
    // if (text == "") {
    //   return 'مقدار نمی تواند خالی باشد';
    // } else
    if (double.tryParse(text) == null && text != "") {
      return 'مقدار وارد شده اشتباه است';
    } else if (text.length > 12) {
      return 'مقدار نباید بیشتر از 12 رقم باشد';
    }
    return null;
  }

  String? storeId(String text) {
    if (text == "") {
      return 'مقدار نمی تواند خالی باشد';
    } else if (double.tryParse(text) == null && text != "") {
      return 'مقدار وارد شده اشتباه است';
    } else if (text.length > 1) {
      return 'مقدار نباید بیشتر از 1 رقم باشد';
    }
    return null;
  }
}
