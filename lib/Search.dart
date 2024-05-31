import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'N.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String _searchTerm = '';
  List<Map<String, dynamic>> _userData = [];

  void _searchUser() async {
    if (_searchTerm.isNotEmpty) {
      var collection = FirebaseFirestore.instance.collection('users');
      var querySnapshot = await collection.where('name', isEqualTo: _searchTerm).get();

      setState(() {
        _userData = querySnapshot.docs.map((doc) => doc.data()).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.27,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16.0),
                bottomRight: Radius.circular(16.0),
              ),
              color: Color(0xff044080),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 45.0,
                left: 30.0,
                right: 25.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              color: Colors.white,
                            ),
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  _searchTerm = value;
                                });
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: IconButton(
                                  onPressed: _searchUser,
                                  icon: const Icon(Icons.search),
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _searchTerm = '';
                                      _userData = [];
                                    });
                                  },
                                  icon: const Icon(Icons.cancel),
                                ),
                                hintText: 'Search by colleges, schools...',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: IconButton(
                            onPressed: () {
                              // Perform mic action
                            },
                            icon: const Icon(
                              Icons.mic,
                              color: Color(0xff044080),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _userData.length,
              itemBuilder: (context, index) {
                var user = _userData[index];
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: Colors.grey.withOpacity(0.25),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Name: ${user['name']}', style: TextStyle(fontSize: 18)),
                          Text('Age: ${user['age']}', style: TextStyle(fontSize: 18)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: ElevatedButton(
          onPressed: () {
            Get.to(() => N());
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Color(0xff044080)),
          ),
          child: Text(
            "Add",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0),
          ),
        ),
      ),
    );
  }
}
