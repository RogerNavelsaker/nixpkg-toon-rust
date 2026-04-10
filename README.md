# nixpkg-toon-rust

Thin Nix packaging repo for [`Dicklesworthstone/toon_rust`](https://github.com/Dicklesworthstone/toon_rust).

## Upstream

- Repo: `Dicklesworthstone/toon_rust`
- Vendored source: [`upstream/`](/home/rona/Repositories/@nixpkgs/nixpkg-toon-rust/upstream)
- Upstream crate version: `0.2.2`
- Vendored commit: `5669b72a7d72ce36e23906a1a1178b6ae4bca28c`

## Usage

```bash
nix build
nix run
```

The package builds the Rust CLI from vendored source and installs both `toon` and a compatibility alias, `tru`, because APR documentation refers to the older `tru` command name.
