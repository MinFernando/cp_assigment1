import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sign in and login',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(title: 'Welcome to MovieMate!'),
        '/second': (context) => appHomeScreen(),
        '/third': (context) => cinemaListScreen(),
        '/fourth': (context) => tvListScreen(),
        '/fifth': (context) => myWatchlistScreen(),
        '/sixth': (context) => visitProfileScreen(),
      },
    );
  }
}
class AppHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Home Screen'),
      ),
      body: const Center(
        child: Text('Welcome back!'),
      ),
    );
  }
}

class cinemaListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('main page'),
      ),
      body: const Center(
        child: Text('Now showing'),
      ),
    );
  }
}

class tvListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tv lists'),
      ),
      body: const Center(
        child: Text('On TV Today'),
      ),
    );
  }
}

class myWatchlistScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('to watch and watched'),
      ),
      body: const Center(
        child: Text('watched and to watch'),
      ),
    );
  }
}

class visitProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('profile'),
      ),
      body: const Center(
        child: Text('profile details'),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget with ValidationMixin {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formGlobalKey = GlobalKey<FormState>();

     return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.height * 2.0,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('web/assets/cp1.jpg'),
                  fit: BoxFit.cover
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        title,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Form(
              key: formGlobalKey,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 16.0),
                    const Text(
                      'Username',
                      style: TextStyle(fontSize: 20.0, color: Colors.black),
                    ),
                    TextFormField(
                      validator: (email) {
                        if (EmailValidator.validate(email!)) return null;
                        else
                          return 'Email address invalid';
                      },
                      decoration: const InputDecoration(
                        hintText: 'Enter your username',
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'Password',
                      style: TextStyle(fontSize: 20.0, color: Colors.black),
                    ),
                    TextFormField(
                      validator: (password) {
                        if (isPasswordValid(password!)) return null;
                        else
                          return 'Invalid Password.';
                      },
                      maxLength: 6,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: 'Enter your password',
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (formGlobalKey.currentState!.validate()) {
                                formGlobalKey.currentState!.save();
                                Navigator.pushNamed(context, '/second');
                              }
                            },
                            child: const Text('Login'),
                          ),
                          TextButton(
                            onPressed: () {
                              // Add forgot password logic
                            },
                            child: const Text('Forgot Password?'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CreateAccountScreen(),
                                ),
                              );
                            },
                            child: const Text('New User? Create account'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class appHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Home Screen'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('web/assets/cp2.jpg'), // background image path
            fit: BoxFit.cover,
          ),
        ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => cinemaListScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20), 
            ),
              child: const Text(
                'Cinema listing',
                 style: TextStyle(fontSize: 20), 
                 ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => tvListScreen(),
                  ),                  
                );
              },
               style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20), 
            ),
              child: const Text(
                'Whats On TV',
                 style: TextStyle(fontSize: 20), 
              ) 
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => myWatchlistScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20), 
            ),
              child: const Text(
                'MyWatchlist',
                style: TextStyle(fontSize: 20),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => visitProfileScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 61, vertical: 20), 
            ),
              child: const Text(
                'Visit Profile',
                style: TextStyle(fontSize: 20),
                ),
            ),
          ],
        ),
      ),
     )
    );
  }
}
// create account screen
class CreateAccountScreen extends StatelessWidget with ValidationMixin {
  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Account'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              // Username
              const Text(
                'Username',
                style: TextStyle(fontSize: 20.0, color: Colors.black),
              ),
              TextFormField(
                validator: (email) {
                  if (EmailValidator.validate(email!)) return null;
                  else
                    return 'Email address invalid';
                },
                decoration: const InputDecoration(
                  hintText: 'Enter your username',
                ),
              ),
              const SizedBox(height: 16.0),

              // Password
             const Text(
                'Password',
                style: TextStyle(fontSize: 20.0, color: Colors.black),
              ),
              TextFormField(
                validator: (password) {
                  if (isPasswordValid(password!)) return null;
                  else
                    return 'Invalid Password.';
                },
                maxLength: 6,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Enter your password',
                ),
              ),
              const SizedBox(height: 16.0),

              // Create Account Button
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();                    
                    // Show a popup alert
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Account Created'),
                          content: const Text('Your account has been successfully created!'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); 
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: const Text('Create Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

mixin ValidationMixin {
  bool isPasswordValid(String inputpassword) => inputpassword.length == 6;
}
