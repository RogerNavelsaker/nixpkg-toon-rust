# nixpkg-toon-rust

Thin Nix packaging repo for [`Dicklesworthstone/toon_rust`](https://github.com/Dicklesworthstone/toon_rust).

## Upstream

- Repo: `Dicklesworthstone/toon_rust`
- Upstream crate version: `0.2.2`
- Pinned commit: `5669b72a7d72ce36e23906a1a1178b6ae4bca28c`

## Usage

```bash
nix build
nix run
```

The package fetches the pinned upstream source directly from GitHub, stages only the crate inputs needed for packaging, and installs both `toon` and a compatibility alias, `tru`, because APR documentation refers to the older `tru` command name.
