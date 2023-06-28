import 'package:flutter/material.dart';
import '../widgets/gridShow.dart';

class AllSongsPage extends StatefulWidget {
  const AllSongsPage({
    super.key,
    required this.user,
  });
  final String user;

  @override
  State<AllSongsPage> createState() => _AllSongsPageState();
}

class _AllSongsPageState extends State<AllSongsPage> {
  bool filter = false;
  bool filterOn = false;
  String? ftrending, fgenre;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue,
                Colors.cyan,
                Colors.cyanAccent,
                Colors.yellow,
              ],
            ),
          ),
        ),
        title: const Text(
          'ALL SONGS',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            letterSpacing: 3,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            const Text(
              'ALL SONGS LIST',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            Container(
              child: filter
                  ? Padding(
                      padding: const EdgeInsets.all(15),
                      child: Flex(
                        direction: Axis.horizontal,
                        children: [
                          Expanded(
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              decoration: BoxDecoration(
                                border: Border.all(width: 1),
                                borderRadius: BorderRadius.circular(5),
                                color: const Color.fromARGB(255, 38, 37, 49),
                              ),
                              child: DropdownButton(
                                borderRadius: BorderRadius.circular(10),
                                value: ftrending,
                                dropdownColor: Colors.grey,
                                icon: const Icon(Icons.arrow_drop_down),
                                iconSize: 30,
                                isExpanded: true,
                                underline: const SizedBox(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                                hint: const Text(
                                  'Trending or Not',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    ftrending = newValue!;
                                  });
                                },
                                items: <String>[
                                  'Yes',
                                  'No',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              decoration: BoxDecoration(
                                border: Border.all(width: 1),
                                borderRadius: BorderRadius.circular(5),
                                color: const Color.fromARGB(255, 38, 37, 49),
                              ),
                              child: DropdownButton(
                                borderRadius: BorderRadius.circular(10),
                                value: fgenre,
                                dropdownColor: Colors.grey,
                                icon: const Icon(Icons.arrow_drop_down),
                                iconSize: 30,
                                isExpanded: true,
                                underline: const SizedBox(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                                hint: const Text(
                                  'Select Genre',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    fgenre = newValue!;
                                  });
                                },
                                items: <String>[
                                  'Hip Hop',
                                  'House',
                                  'Rock',
                                  'Trap',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 18, right: 18),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    filterOn = true;
                                  });
                                },
                                child: Container(
                                  height: 49,
                                  color: Colors.yellowAccent,
                                  child: const Center(
                                    child: Text(
                                      'Apply',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 18),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    filter = !filter;
                                    filterOn = false;
                                    ftrending = null;
                                    fgenre = null;
                                  });
                                },
                                child: Container(
                                  height: 49,
                                  color: Colors.redAccent,
                                  child: const Center(
                                    child: Text(
                                      'Clear',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      filter = !filter;
                    });
                  },
                  child: const Row(
                    children: [
                      Icon(
                        Icons.filter_alt_sharp,
                        size: 27,
                        color: Colors.white,
                      ),
                      Text(
                        'Filter',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            GridDisplay(
              user: widget.user,
              fgenre: fgenre,
              filter: filterOn,
              ftrending: ftrending,
            ),
          ],
        ),
      ),
    );
  }
}
