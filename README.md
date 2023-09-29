# ohmyplayer

Its a streaming media player made with :sparkling_heart: in Flutter.

## Getting Started

Clone the project and run:

flutter pub get

To get all the necessary packages and later run the project.

# Where get or read the streaming source?

````json
Just create a json file structure like:
[
  {
    "name": "ES| Stream1",
    "logo": "https://x.x.x.x/1.png",
    "group": "ES | STREAM SD",
    "url": "http://x.x.x.x/stream_source"
  },
  {
    "name": "ES| Stream2",
    "logo": "https://x.x.x.x/2.png",
    "group": "ES | STREAM SD",
    "url": "http://x.x.x.x/stream_source2"
  },
]
````

And later put the url in the app in a file called env.dart:

lib/env.dart

The variable: baseUrl, for example:

````dart

static const String baseUrl = 'https://mylovelydomain/channels.json';

````

You can play almost any streaming video resource: mpegts, avi, ts.