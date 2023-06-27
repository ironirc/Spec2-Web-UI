# Spec-PharoJS
An attempt to use PharoJS as backend for Spec.  
Everything is still in a very experimental state with lots of dead code, ...  
More or less working: TextInput, NumericInput, Button, Table, BoxLayout.

```Smalltalk
Metacello new
  baseline: 'Spec2PharoJS';
  repository: 'github://ironirc/Spec-PharoJS:main/';
  onWarningLog;
  load.
```

Then start the webserver and register the client app:
```Smalltalk
PhxPjServer startDefaultZnServer.
PhxPjServer registerApplication: SpPharoJsClientSideApp
```

Open webbrowser on:
`http://localhost:8888/spec`

![image](https://github.com/ironirc/Spec-PharoJS/assets/10418880/11344b9f-fede-4046-89a8-7043135ae00b)
