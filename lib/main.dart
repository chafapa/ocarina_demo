// import 'package:flutter/material.dart';
// import 'package:ocarina/ocarina.dart';
// import 'package:flutter_file_downloader/flutter_file_downloader.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Ocarina & File Downloader Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const MyHomePage(title: 'Flutter Ocarina & File Downloader'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
//   late OcarinaPlayer player; // Ocarina player instance
//   double _progress = 0.0; // File download progress
//   String _downloadStatus = "Not started"; // Download status message

//   @override
//   void initState() {
//     super.initState();

//     // Initialize Ocarina player
//     player = OcarinaPlayer(
//       asset:
//           'assets/ocarina.mp3', // Ensure this file exists in your assets folder
//       loop: false, // Set to true if looping is needed
//       volume: 1.0, // Adjust the volume (0.0 to 1.0)
//     );

//     player.load(); // Load the audio file
//   }

//   @override
//   void dispose() {
//     // Dispose of Ocarina player to free memory
//     player.dispose();
//     super.dispose();
//   }

//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values.
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'Test Me 😁',
//               style: TextStyle(
//                 fontSize: 24, // Increase the font size
//                 fontWeight: FontWeight.bold, // Make text bold
//                 color: Colors.black, // Change text color
//               ),
//             ),

//             const SizedBox(height: 20), // Adds space between elements

//             // Ocarina Audio Controls
//             ElevatedButton(
//               onPressed: () => player.play(),
//               child: const Text("Play Audio"),
//             ),
//             ElevatedButton(
//               onPressed: () => player.pause(),
//               child: const Text("Pause Audio"),
//             ),
//             ElevatedButton(
//               onPressed: () => player.stop(),
//               child: const Text("Stop Audio"),
//             ),

//             const SizedBox(height: 40), // Adds more space
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:ocarina/ocarina.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Ocarina & File Downloader Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Ocarina & File Downloader'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  late OcarinaPlayer player; // Ocarina player instance
  double _progress = 0.0; // File download progress
  String _downloadStatus = "Not started"; // Download status message

  @override
  void initState() {
    super.initState();

    // Initialize Ocarina player
    player = OcarinaPlayer(
      asset:
          'assets/ocarina.mp3', // Ensure this file exists in your assets folder
      loop: false, // Set to true if looping is needed
      volume: 1.0, // Adjust the volume (0.0 to 1.0)
    );

    player.load(); // Load the audio file
  }

  @override
  void dispose() {
    // Dispose of Ocarina player to free memory
    player.dispose();
    super.dispose();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

Future<String> _getDownloadDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    final downloadDir = Directory('${directory.path}/Downloads');
    if (!await downloadDir.exists()) {
      await downloadDir.create(recursive: true);
    }
    return downloadDir.path;
  }

  // Future<bool> _requestStoragePermission() async {
  //   var status = await Permission.storage.status;
  //   if (!status.isGranted) {
  //     status = await Permission.storage.request();
  //   }
  //   return status.isGranted;
  // }

  // Simple File Download Function

  // void _downloadFile() async{

  //   // Request permission before downloading
  //   // if (!await _requestStoragePermission()) {
  //   //   setState(() {
  //   //     _downloadStatus = "Storage permission not granted";
  //   //   });
  //   //   return;
  //   // }

  //   setState(() {
  //     _downloadStatus = "Downloading...";
  //   });

  //   final downloadPath = await _getDownloadDirectory();

  //   FileDownloader.downloadFile(
  //     // url: "https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-jpg-image-500kb.jpg",
  //     //      name: "sample_image.jpg",

  //     url: "https://www.google.com/robots.txt",
  //     name: "sample.txt",
  //     subPath: downloadPath,
  //     onProgress: (fileName, progress) {
  //       debugPrint('FILE $fileName HAS PROGRESS $progress');
  //       setState(() {
  //         _progress = progress;
  //       });
  //     },
  //     onDownloadCompleted: (String path) {
  //       debugPrint('FILE DOWNLOADED TO PATH: $path');
  //       setState(() {
  //         _downloadStatus = "Download Complete!";
  //       });
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("File downloaded to: $path")),
  //       );
  //     },
  //     onDownloadError: (String error) {
  //       debugPrint('DOWNLOAD ERROR: $error');
  //       setState(() {
  //         _downloadStatus = "Download Failed!";
  //       });
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("Download error: $error")),
  //       );
  //     },
  //   );
  // }
  void downloadFile() {
  FileDownloader.downloadFile(
    url: "https://www.example.com/sample.pdf",
    name: "SAMPLE.pdf",
    headers: {'User-Agent': 'Mozilla/5.0'},
    onProgress: ( fileName,  progress) {
      debugPrint('Downloading $fileName: $progress% completed');
    },
    onDownloadCompleted: (String path) {
      debugPrint('File downloaded to: $path');
    },
    onDownloadError: (String error) {
      debugPrint('Download error: $error');
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Test Me 😁',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 20),

            // Ocarina Audio Controls
            ElevatedButton(
              onPressed: () => player.play(),
              child: const Text("Play Audio"),
            ),
            ElevatedButton(
              onPressed: () => player.pause(),
              child: const Text("Pause Audio"),
            ),
            ElevatedButton(
              onPressed: () => player.stop(),
              child: const Text("Stop Audio"),
            ),

            const SizedBox(height: 40),

            // File Downloader UI
            const Text(
              "File Downloader",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Download Status
            Text(
              _downloadStatus,
              style: const TextStyle(fontSize: 18, color: Colors.blue),
            ),

            const SizedBox(height: 20),

            // Download Button
            ElevatedButton(
              onPressed: downloadFile,
              child: const Text("Download File"),
            ),

            const SizedBox(height: 20),

            // Progress Bar for File Download
            LinearProgressIndicator(
              value: _progress, // Dynamic progress
              minHeight: 10,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
