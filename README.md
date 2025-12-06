# Flutter App with Angular Dashboard
# Flutter App & Webpage Repository

This repository contains two separate projects stored in one GitHub repository:

- flutter_app/ — Flutter mobile application
- webpage/ — Web application (Angular or other framework)

## Folder Structure


├── flutter_app/  
│   ├── lib/  
│   ├── android/  
│   ├── ios/  
│   ├── web/  
│   ├── pubspec.yaml  
│   └── other Flutter files  
└── webpage/  
    ├── src/  
    ├── package.json  
    ├── angular.json (if Angular)  
    └── other web files

## Cloning the Repository

git clone https://github.com/wangk141/probable-broccoli.git

## Running the Webpage (Run before Flutter or Webview won't work)

cd webpage  
npm install  
ng serve --host 0.0.0.0 --port 4200 --disable-host-check

## Running the Flutter App

cd flutter_app  
flutter pub get  
flutter run

To see desktop version:
http://localhost:4200

## License

Open-source (MIT or your choice).
