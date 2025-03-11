import 'package:flutter/material.dart';
import 'package:ocarina/ocarina.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';

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
      asset: 'assets/ocarina.mp3', // Ensure this file exists in your assets folder
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
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values.
      _counter++;
    });
  }

  // Function to download a file
  void _downloadFile() {
  setState(() {
    _downloadStatus = "Downloading...";
  });

  FileDownloader.downloadFile(
    // url: "https://sample-videos.com/img/Sample-jpg-image-500kb.jpg", 
        url: "https://www.w3.org/TR/PNG/iso_8859-1.txt", 

    name: "SampleImage.txt",
    onProgress: (String? fileName, double progress) { // Updated function signature
      setState(() {
        _progress = progress; // Update progress bar
        _downloadStatus = "Downloading: ${(progress).toStringAsFixed(0)}%";
      });
    },
    onDownloadCompleted: (String path) {
      setState(() {
        _downloadStatus = "Download Complete!";
      });

      // Show a Snackbar notification when the file is downloaded
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("File downloaded to: $path")),
      );
    },
    onDownloadError: (String error) {
      setState(() {
        _downloadStatus = "Download Failed";
      });

      // Show an error message if download fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Download error: $error")),
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
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
                fontSize: 24, // Increase the font size
                fontWeight: FontWeight.bold, // Make text bold
                color: Colors.black, // Change text color
              ),
            ),

            const SizedBox(height: 20), // Adds space between elements

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

            const SizedBox(height: 40), // Adds more space

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
              onPressed: _downloadFile,
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
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
