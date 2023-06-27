# Spec-PharoJS
An attempt to use PharoJS as backend for Spec ... initial steps not much here yet

```Smalltalk
Metacello new
  baseline: 'Spec2PharoJS';
  repository: 'github://ironirc/Spec-PharoJS:main/';
  load.
```

Then start the webserver and register the client app:
```Smalltalk
PhxPjServer startDefaultZnServer.
PhxPjServer registerApplication: SpPharoJsClientSideApp
```

Open webbrowser on:
`http://localhost:8888/spec`
