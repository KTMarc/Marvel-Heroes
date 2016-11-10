# Marvel Heroes iOS App
This App fetches characters from the Marvel Comics public API.
It also allows to search for more characters remotely via REST calls.
Characters can be selected to see their details and a list of comics where they appear.

# Goal of this project
Explore the possibilities of different App architectures to achieve:
- Clean, maintainable and testable code
- Modularity: Any part of the system can be changed without affecting the rest
- Add new features easily

##Architecture
Using the façade design pattern: provides a single interface to a more complex subsystem.
Instead of exposing the user to a set of classes and their APIs, you only expose one simple unified API
There is central class where all the objects request data. It's an interface that holds:

- [x] Networking
- [x] JSON Parser
- [x] Object serializer
- [x] Persistency manager

In each branch there is a different implementation, from more simple to more advanced.

Branches (from older to newer)
- XCode 731_Haneke+SwiftyJSON: Uses Swift 2.2 + Cocoapods external libraries for image caching and JSON Parsing. MVC Pattern.
- MVC: Swift 3 + no dependencies (custom implementation) + MVC Pattern.
- MVVM: Swift 3 +  without dependencies. MVVM Pattern.

There are 3 Use Cases or Scenes, divided in ViewControllers:

##Browse a list of Characters (Master VC):
- Holds a CollectionView which is compatible with iPhone/iPad
- Contains the suggestions VC
- There is an infinite scroll to load more items (batches of 20)

##Search other characters remotely (Suggestions VC):
- Is created programmatically
- Holds a table view to show results from the remote server API calls
- Sends requests against the REST API for user entered text

##View information about a Hero (Hero Detail VC):
- Holds information about the Characters inside a scroll view
- Has a collection View with comics from that Character

##UI
Sketch file is provided with the assets that were used.
- [x] Custom icon
- [x] Custom fonts
- [x] Custom buttons

#Testing
- There are some unit tests that check the apiClient
- In final product a lot more tests should be tested. But it's out of scope here.

##Documentation
Documentation can be found in Marvel Heroes/Docs
Look for 'Docs' folder for generated HTML files in Apple Documentation style.

To generate docs again, first install jazzy

```bash
sudo gem install jazzy
```

and from the same folder where this README.md file is run:

```bash
$ jazzy --min-acl private
```


##Considerations
Didn't chose CORE DATA as the persistency. The reason is that the Marvel service has less than 1.5k character records and
for simplicity JSON files are enough. The data is unlikely to change, so we save it in a cache using **Haneke** framework. Haneke persists the requests as key value pairs, so it can check in the future if the same network request already exists in the cache before requesting it to the server.

Marvel character API doesn't offer a lot of information. Only name, description (most of them are empty), modification date and Id.
There is a wiki page for each character. This page has more information, but it would require web scrapping, also it is out of the scope of this project. We could add a webView and load the html of the wiki.

In the Hero Detail page we are showing Comics, but we could also show Stories, Events and Series the same way. But would be repeating the same calls to the server requesting different entities.
