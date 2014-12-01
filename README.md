# KivaSort.org

[KivaSort.org](http://KivaSort.org) is a simple JavaScript web application which provides a table of Kiva field partners which may be sorted and filtered.

## Contributing

Feel free to use the [project issues tracker](https://github.com/cristoper/kivasort.org/issues) to submit not only bugs and typos, but any suggestions or feature requests.

If you'd like to contribute code or documentation you can either open an issue and attach a patch, or if you use Github:

1. Fork this repository
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request

## What's to be done

### Optimization

Currently KivaSort.org makes a great many HTTP requests for separate CSS and JavaScript files from CDNs. It also fetches and parses a lot of JavaScript it never executes. We should gather only the required JavaScript and styles into only a few minified files.

### Style

KivaSort.org uses a default JQueryUI theme right now. I'm sure somebody can create a more custom theme that looks better and is less CSS...

### More filtering

Range sliders for filtering at least some columns (Portfolio Yield, Profitability, etc) would be nice.

## License

KivaSort.org is licensed under the term of the [WTFPL](http://www.wtfpl.net/about/), version 2. See [LICENSE.txt](LICENSE.txt) as included with this project.
