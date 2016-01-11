# KivaSort.org

[KivaSort.org](http://KivaSort.org) is a simple JavaScript web application which provides a table of Kiva field partners which may be sorted and filtered.

For a full-featured lending app which also provides a way to filter field partners, take a look at [KivaLens.org](http://www.kivalens.org/react/#/search). It is also open source: https://github.com/nuclearspike/kivalensjs

## Building

If you want to insert a KivaSort table into your own HTML document, then you want the [KivaSort jquery plugin](https://github.com/cristoper/jquery-KivaSort). If you actually want to build a local version of KivaSort.org, then clone the repository, install [UglifyJS](http://lisperator.net/uglifyjs/), and run `make`:

```sh
$ git clone git@github.com:cristoper/kivasort.org.git local-kivasort
$ cd local-kivasort
$ npm install uglify-js
$ make
```

The make file will concatenate and minify the JavaScript and copy everything to its proper place in the `./output/` directory. View the generated site by opening `output/index.html` in a browser (no server required). 

### Build Options

The Makefile can also be configured with two options:

- `make DEBUG_MODE=y` will not compress the JavaScript, and it will link to non-minified versions of JavaScript and CSS from the Datatables CDN.

- `make NO_AJAX=y` will include (and generate, if necessary) `js/partners.json` and use that on its initial load instead of making an API call to fetch the JSON. If the site is built with this option, then it should periodically be re-built with up-to-date data (like by running `js/ks/fetchkivajson.js` from a cron job).

### Updating jquery-kivasort

KivaSort.org relies on the jquery-kivasort plugin, which lives as a subtree in `js/ks/`. It can be updated at any time by:

```sh
# Do this once:
$ git remote add kivasort git@github.com:cristoper/jquery-KivaSort.git

# Do this whenever you'd like to update jquery-kivasort
$ git subtree pull -P js/ks kivasort dev
```

### Deploy to gh-pages

To deploy the contents of `output/` to the gh-pages branch, run:

```sh
$ make deploy-pages
```

## Contributing

Feel free to use the [project issues tracker](https://github.com/cristoper/kivasort.org/issues) to submit not only bugs and typos, but any suggestions or feature requests.

If you'd like to contribute to my work

If you'd like to contribute code or documentation you can either open an issue and attach a patch, or if you use Github:

1. Fork this repository
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request

For other ways to contribute to this project, see the [support tab of KivaSort.org](http://www.kivasort.org/#support). Thank you!

## What's to be done

### Optimization

It might be both faster and more reliable if we included local copies of the dependencies (jQuery, jQuery-ui, Datatables) instead of relying on the Datatables CDN for everything.

### More filtering

Range sliders for filtering at least some columns (Portfolio Yield, Profitability, etc) would be nice.

## License

KivaSort.org is licensed under the term of the [WTFPL](http://www.wtfpl.net/about/), version 2. See [LICENSE.txt](LICENSE.txt) as included with this project.
