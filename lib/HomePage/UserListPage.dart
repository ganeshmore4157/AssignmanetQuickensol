import 'package:flutter/material.dart';
import 'package:flutter_assignment/Service/Service.dart';

class UserListPage extends StatefulWidget {
  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  final AuthService authService = AuthService();
  List<dynamic> users = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    List<dynamic> fetchedUsers = await authService.getUserList();
    setState(() {
      users = fetchedUsers;
    });
  }

  void _deleteUser(int userId) async {
    bool success = await authService.deleteUser(userId);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User $userId deleted successfully")),
      );
      setState(() {
        users.removeWhere((user) => user['id'] == userId);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete user $userId")),
      );
    }
  }
  void _editUser(int userId, String currentName, String currentPassword) async {
  final TextEditingController nameController = TextEditingController(text: currentName);
  final TextEditingController passwordController = TextEditingController(text: currentPassword);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Edit User'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Map<String, dynamic> updatedData = {
                "id": userId,
                "userName": nameController.text,
                "password": passwordController.text,
              };
              bool success = await authService.updateUser(userId, updatedData);
              Navigator.pop(context);

              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("User $userId updated successfully")),
                );
                _fetchUsers();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Failed to update user $userId")),
                );
              }
            },
            child: Text('Save'),
          ),
        ],
      );
    },
  );
}


 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('User List'),
    ),
    body: users.isEmpty
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return Card(
                child: ListTile(
                  title: Text(user['userName']),
                  subtitle: Text('ID: ${user['id']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _editUser(user['id'], user['userName'], user['password']),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteUser(user['id']),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
  );
}
}
