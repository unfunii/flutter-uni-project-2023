import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'node.dart';


// List<Node> decisionMap = [];
late Box<Node> box;

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(NodeAdapter());
  box = await Hive.openBox<Node>('decisionMap');

  String csv = "cw_data.csv";
  String fileData = await rootBundle.loadString(csv);
  print(fileData);  //test data is loaded.

  List <String> rows = fileData.split("\n");
  for (int i = 0; i < rows.length; i++) {
    String row = rows[i];
    List <String> itemInRow = row.split(",");
    String img = itemInRow[5].trim();

    Node node = Node(
        int.parse(itemInRow[0]),
        int.parse(itemInRow[1]),
        int.parse(itemInRow[2]),
        itemInRow[3],
        itemInRow[4],
        img);

    int key = int.parse(itemInRow[0]);
    box.put(key, node);

    // decisionMap.add(node);
  }


  runApp (
    const MaterialApp(
      home: FirstPage(),
    ),
  );
}

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('school_main.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Align(
          alignment: const Alignment(0.0,0.3),
            child: ElevatedButton(
              onPressed: (){
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => const MyFlutterApp())
                );
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ), backgroundColor: Colors.pink.shade100,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical:10, horizontal:20),
                child: const Text(
                  'Start',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),

                )
              )
            )
        ),
      )
    );

  }
}



class MyFlutterApp extends StatefulWidget {
  const MyFlutterApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MyFlutterState();
  }
}

class MyFlutterState extends State<MyFlutterApp>{

  String image = "";

  //WRITE VARIABLES AND EVENT HANDLERS HERE
  late int iD ;
  late int yesID;
  late int noID;
  String question = "";
  String time = "";



  @override
  void initState() {
    super.initState();
    //PLACE CODE HERE TO INITALISE SERVER OBJECTS

    WidgetsBinding.instance.addPostFrameCallback((_) {

      setState(() {
        // Node current = decisionMap.first;
        //
        Node? current = box.get(1);
        if(current != null) {
          iD = current.iD;
          yesID = current.yesID;
          noID = current.noID;
          question = current.question;
          image = current.image;
          time = current.time;
        }

      } );

    });
  }

  void yesHandler() {
    setState(() {
      Node? nextNode = box.get(yesID);
      if (nextNode?.iD == yesID) {
        iD = nextNode!.iD;
        yesID = nextNode.yesID;
        noID = nextNode.noID;
        question = nextNode.question;
        image = nextNode.image;
        print('New Image after YES: $image');
        time = nextNode.time;
      }
    });
  }

  void noHandler(){
    setState(() {
      Node? nextNode = box.get(noID);
      if (nextNode?.iD == noID) {
        iD = nextNode!.iD;
        yesID = nextNode.yesID;
        noID = nextNode.noID;
        question = nextNode.question;
        image = nextNode.image;
        print('New Image after NO: $image');
        time = nextNode.time;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
        )
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            alignment: Alignment.topLeft,
            children: [
              if (iD != 33 && iD != 36 && iD != 39) //  YES BUTTON
                Align(
                  alignment: const Alignment(-0.5, 0.7),
                  child: MaterialButton(
                    onPressed: () {
                      yesHandler();
                    },
                    color: Colors.pink.shade100,
                    elevation: 0,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    textColor: Colors.black,
                    height: 45,
                    minWidth: 145,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    child: Text(
                      "YES",
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                ),

              if (iD != 33 && iD != 36 && iD != 39) // NO BUTTON
                Align(
                  alignment: const Alignment(0.5, 0.7),
                  child: MaterialButton(
                    onPressed: () {
                      noHandler();
                    },
                    color: Colors.pink.shade100,
                    elevation: 0,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    textColor: Colors.black,
                    height: 45,
                    minWidth: 145,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    child: Text(
                      "NO",
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                ),

              Align( //TIME
                alignment: const Alignment(-0.95,-0.95),
                child: Text(
                  time,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.clip,
                  style: GoogleFonts.playfairDisplay(
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                    fontSize: 40,
                    color: Colors.black,
                    background: Paint()..color = Colors.pink.shade100,
                  )
                )
              ),


              Align( //QUESTION
                alignment: const Alignment(0.0, 0.5),
                child: Text(
                  question,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.clip,
                  style: GoogleFonts.playfairDisplay(
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                    fontSize: 40,
                    color: Colors.black,
                    background: Paint()..color = Colors.pink.shade100,

                  ),
                ),
              ),


            ],
          ),
        ),
      ),
    );  //end of scaffold
  }
}

