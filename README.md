# Spec2-Web-UI
An attempt to use PharoJS as backend for Spec.  
Everything is still in a very experimental state with lots of dead code, ...  
More or less working: TextInput, NumericInput, Button, Table, BoxLayout.  
The tiny table at the bottom left is quite powerfull (it works with https://tabulator.info)  
All info gets transferred via serialized messages over websocket, including the icons in the tiny table.  
Take a look at SpwPresenter1 first to understand the behaviour a littlebit.  
It's really a cascade of random things I've been playing with.  
Let me now what you think and/or feel free to join development.  

```Smalltalk
Metacello new
  baseline: 'Spec2WebUi';
  repository: 'github://ironirc/Spec2-Web-UI:main/';
  onWarningLog;
  load.
```

Open the experimental presenter:
```Smalltalk
SpwApp1 open
```

If for some reason the server didn't start or the app didn't get registered during post load:
```Smalltalk
PhxPjServer startDefaultZnServer.
PhxPjServer registerApplication: SpwClientApp
```

![image](https://github.com/ironirc/Spec-PharoJS/assets/10418880/11344b9f-fede-4046-89a8-7043135ae00b)
