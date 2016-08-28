# qphue - KDB+/Q Philips Hue App
Simple KDB+/Q web application that interacts with Philip's Hue Bridge. It's designed to turn on/off lights, change the scene, and retrieve bridge/light info.

It does not implement all the features available in the Philips Hue API.

## Getting Started
Download the free version of KDB+/Q from [kx.com](http://www.kx.com)

Obtain the APIKEY from your Philips Hue bridge. Instructions available here: http://www.developers.meethue.com/documentation/getting-started

### Create configuration
```
cp config.skeleton.csv config.csv
```

Update the config.csv with your APIKEY and bridge's hostname/ip address. Also change the username and password in the config. You wouldn't want some schmuck to mess with your lights in the middle of the night!

The APIKEY is called *username* in Philips Hue documentation. I make a distinction to not be confused with authentication username.

To start the service, navigate to the root of the project.

### Run
```
q lights.q -p 8090
```
`-p` is port open

Open a web browser and go to:
[http://user:pass@localhost:8090/?.lights.turnOn[]](http://user:pass@localhost:8090/?.lights.turnOn[])

### Files
- `phue.q` - lightweight library that wraps GET, PUT, DELETE commands used to communicate with Hue Bridge.
- `lights.q` - the main application and API.

## API Available
All functions meant for public usage are in the `.lights` namespace. These functions include:

- `.lights.turnOn[]`
- `.lights.turnOff[]`
- `.lights.changeScene["scene name"]` - the function you'll use the most.
- `.lights.getScenes[]` - returns table of scenes registered on bridge


## User Interface
The primary user interface is a [Workflow](https://workflow.is/workflows/6c930f3fc9fb4953ab892005a515d321) "notification widget". A quick swipe down on the iPhone and I have access to my favorite Philip Hue scenes.

![screen shot of workflow](img/workflow.png)

## Raspberry Pi
Although not tested, this is the perfect project for using KDB on a RaspPi.

## License
MIT License

Copyright (c) 2016 J.P. Armstrong

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
