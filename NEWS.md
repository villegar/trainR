# trainR 0.0.2

* Simplified the internal function `request`, which handles all the requests to the server.
* Fixed the generic method `print.GetArrDepBoardWithDetailsRequest`, [trainR#4](https://github.com/villegar/trainR/issues/4).
* Added parameter `show_colours` to the `print` generic, to allow to add colours to the _Expected_ (arrival/departure) time.

See example at https://github.com/villegar/trainR#add-some-colour-terminal-output-only
* Updated the dataset `station_codes`.
* Added to new requests, `GetArrBoardRequest` and `GetDepBoardRequest`. These functions lists arrivals and departures __without__ calling point details.
* Fixed the return object of `GetServiceDetailsRequest`.
* Added Zenodo citation.
* Added support to capture services with multiple locations, [trainR#4](https://github.com/villegar/trainR/issues/19).

# trainR 0.0.1

* Added a `NEWS.md` file to track changes to the package.
* Added requests to obtain public arrivals and departures boards.
* Added data set with station codes and names, `station_codes`.
* Added `print` generic methods to display summarised information.
