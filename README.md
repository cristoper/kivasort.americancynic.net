# KivaSort.AmericanCynic.net

[KivaSort.AmericanCynic.net](http://KivaSort.AmericanCynic.net) is a simple JavaScript web application which provides a table of Kiva field partners which may be sorted and filtered.

For a full-featured lending app which also provides a way to filter field partners, take a look at [KivaLens.org](http://www.kivalens.org/react/#/search). It is also open source: https://github.com/nuclearspike/kivalensjs

## Building

If you want to insert a KivaSort table into your own HTML document, then you want the [KivaSort jquery plugin](https://github.com/cristoper/jquery-KivaSort). If you actually want to build a local version of the KivaSort website, then clone the repository, install the dependencies, and run `make`:

```sh
$ git clone git@github.com:cristoper/kivasort.org.git local-kivasort
$ cd local-kivasort
$ yarn
$ make
```

The make file will concatenate and minify the JavaScript and CSS and then copy everything to its proper place in the `./output/` directory. View the generated site by opening `output/index.html` in a browser (no server required).

### Build Options

The Makefile can also be configured with three options:

- `make DEBUG_MODE=y` will not compress the JavaScript, and it will link to non-minified versions of JavaScript and CSS from the Datatables CDN.

- `make NO_AJAX=y` will include (and generate, if necessary) `js/partners.json` and use that on its initial load instead of making an API call to fetch the JSON. If the site is built with this option, then it should periodically be re-built with up-to-date data (like by running `js/ks/fetchkivajson.js` from a cron job).

- `make THEME=<name>` will build the site with the named jquery-ui theme. The name must match one of the themes installed in `bower_components/jquery-ui/themes/`.

### Updating Dependencies

KivaSort uses [yarn](https://yarnpkg.com/) to manage its dependencies.

To update all dependencies run `yarn upgrade`.

### Deploy to gh-pages

To deploy the contents of `output/` to the gh-pages branch, run:

```sh
$ make deploy-pages
```

## Contributing

Feel free to use the [project issues tracker](https://github.com/cristoper/kivasort.org/issues) to submit not only bugs and typos, but any suggestions or feature requests.

If you'd like to contribute code or documentation you can either open an issue and attach a patch, or if you use Github then fork this repository and submit a pull request as usual.

For other ways to contribute to this project, see the [support tab of KivaSort](http://kivasort.americancynic.net/#support). Thank you!

## What's to be done

### Better Docs

The 'About' tab could use better instructions for using the site. The HTML is getting a little unwieldy, it might be worth switching to markdown or similar.

## License

The KivaSort website is licensed under the term of the [WTFPL](http://www.wtfpl.net/about/), version 2. See [LICENSE.txt](LICENSE.txt) as included with this project.

Any third-party components distributed with the KivaSort source (everything under `node_modules/`) is distributed under the terms of its own license agreement. In particular, both DataTables is copyrighted and distributed under the terms of the [MIT license](https://tldrlegal.com/license/mit-license).
