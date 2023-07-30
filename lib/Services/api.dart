import 'package:http/http.dart' as http;


class ApiService {
  Future<int> loginUser(String username) async {
    final response = await http.post(
      Uri.parse("http://localhost:3000/api/account/$username"),
    );
    return response.statusCode;
  }

  Future<int> createUser() async {
    final response = await http.put(
      Uri.parse('/api/login/userLightClient'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      //body: jsonEncode(),
    );
    return response.statusCode;
  }
}
