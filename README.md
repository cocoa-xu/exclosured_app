# exclosured.app

Landing page and demo host for [Exclosured](https://github.com/cocoa-xu/exclosured).

Live at [exclosured.app](https://exclosured.app).

## Setup

```sh
mix deps.get
mix phx.server
```

Visit [http://localhost:4000](http://localhost:4000).

## Deployment

The landing page runs on port 4000. Each example demo runs as a separate
Phoenix app on its own port (4001-4015). nginx routes subdomains to the
corresponding ports.

See `nginx/exclosured.app` for the full nginx configuration.

## License

MIT
