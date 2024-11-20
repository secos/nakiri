# Nakiri

A command-line tool for extracting data from web pages using CSS selectors. Nakiri can fetch content from URLs or read HTML from standard input, making it useful for web scraping and HTML parsing tasks.

## Installation

```bash
shards install
crystal build src/nakiri.cr
```

## Usage

```bash
nakiri -u URL -s SELECTOR [-a ATTRIBUTE]
```

### Options

- `-u, --url=URL`: URL to scrape (optional, reads from stdin if not provided)
- `-s, --selector=SELECTOR`: CSS selector (required)
- `-a, --attribute=ATTR`: Attribute to extract (optional)
- `-h, --help`: Show help message

### Examples

Extract all links from a webpage:
```bash
nakiri -u https://example.com -s "a" -a href
```

Extract all image sources:
```bash
nakiri -u https://example.com -s "img" -a src
```

Extract text content from specific elements:
```bash
nakiri -u https://example.com -s ".article-content p"
```

Process HTML from stdin:
```bash
curl https://example.com | nakiri -s "h1"
```

## Requirements

- Crystal >= 1.0.0

## License

This project is open source and available under the [MIT License](LICENSE).
