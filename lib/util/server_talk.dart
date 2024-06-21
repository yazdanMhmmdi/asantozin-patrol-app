class ServerTalk {
  String sNew = "S.New", sEdit = "S.Edit", sDelete = "S.Cancel", sControl = "S.Control";

  String newProduct(List<String> args, String storeId) {
    String result = "$sNew$storeId";
    for (int i = 0; i < args.length; i++) {
      // if (args[i] != "") {
      //   args[i] = args[i]; //Convert to double to get float
      // }
      result += args[i].toString(); // Convert each argument to String
      if (i < args.length - 1) {
        result += ","; // Add comma separator except for the last element
      }
    }

    return "$result;"; // Add final touch;
  }

  String editProduct(List args, String storeId) {
    String result = "$sEdit$storeId";
    for (int i = 0; i < args.length; i++) {
      // if (args[i] != "") {
      //   args[i] = args[i]; //Convert to double to get float
      // }
      result += args[i].toString(); // Convert each argument to String
      if (i < args.length - 1) {
        result += ","; // Add comma separator except for the last element
      }
    }

    return "$result;"; // Add final touch;
  }

  String deleteProduct(String storeId) {
    String result = sDelete;

    return "$result$storeId;"; // Add final touch;
  }

  String controlProduct(String storeId) {
    String result = sControl;

    return "$result$storeId;"; // Add final touch;
  }
}
