# Marvel Heroes iOS App
This App fetches characters from the Mavel Comics API and shows the comics where they appear.
It also allows to search for more characters remotely via REST calls.


##Instructions
Pods are not inside the repository.
Run pod install and then open the .xcworkspace file to run the project.

##Architecture
There is API Client interface where all the objects request data. 
This interface holds:

- [x] Network connections
- [x] JSON Parser
- [x] Object serializer
- [x] Persistency manager

There are 3 View Controllers:

##Master VC:
- Holds a CollectionView which is compatible with iPhone/iPad
- Contains the suggestions VC
- There is an infinite scroll to load more items (batches of 20)

##Suggestions VC:
- Is created programmatically
- Holds a table view to show results from the remote server API calls
- Sends a new request every time the user writes in the search Bar

##Hero Detail VC:
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
Didn't chose CORE DATA as the persistancy. The reason is that the Marvel service has less than 1.5k character records and 
for simplicity JSON files are enough. The data is unlikely to change, so we save it in a cache using **Haneke** framework. Haneke persists the requests as key value pairs, so it can check in the future if the same network request already exists in the cache before requesting it to the server.

Marvel character API doesn't offer a lot of information. Only name, description (most of them are empty), modification date and Id. 
There is a wiki page for each character. This page has more information, but it would require web scrapping, which I think is out of the scope of this project. We could add a webView and load the html of the wiki.

In the Hero Detail page we are showing Comics, but we could also show Stories, Events and Series the same way. But would be repeating the same calls to the server requesting different entities.

There are two search bars, one is hidden and was providing the "local" search results. I decided to comment that implementation and leave only the one that searches remotely, which is far more complex and interesting. As a future task, we could have both working and showing local and remote results. We could do so by using two scopes, but that would require the user to switch from one to another. A better implementation would be to make it behave like the Safari search bar, which gives google suggestions and at the same time other matches from the currently displayed web.




