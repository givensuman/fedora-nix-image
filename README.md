![fedora-nix-image logo](./assets/logo.png)

# fedora-nix-image

a fedora image configured with nix

### Usage

This is a `bootc` image, meaning it's meant for live systems (or VMs) rather than container environments.

You can rebase to it from another `bootc` system with:

```bash
sudo bootc switch ghcr.io/givensuman/fedora-nix-image
```

although you probably don't want that as this image does not have a graphical environment configured.

For most uses, this will be a layer in custom images:

```Dockerfile
FROM ghcr.io/givensuman/fedora-nix-image

RUN dnf5 -y install @gnome-desktop

RUN bootc container lint
```

or as a build step, using the following exported overlay:

```Dockerfile
FROM ghcr.io/givensuman/fedora-nix-image AS nix
FROM quay.io/fedora/fedora-silverblue

COPY --from=nix /usr/share/modules/nix /tmp/modules/nix
RUN /tmp/modules/nix/apply.sh && rm -rf /tmp/modules

RUN bootc container lint
```

### Why?

Immutable systems via `bootc` and NixOS sit at an interesting crossroads. The workflows of NixOS have become something I've relied on over my past year or two using it, but the declarative way of defining an entire system can be more work than it's worth, especially when you're just trying to, say, play Minecraft on your dang old computer.

`bootc` systems make this easy and keep elements of reproducibility cherished by NixOS users, at the cost of an imperative build system with... slow builds.

I wanted to define a highly stable system with `bootc` and declare work environments for day-to-day tasks with Nix. Turns out, this is [somewhat controversial](https://github.com/ublue-os/main/issues/765). I also didn't find a working alternative, so here you go.

### License

[MIT](./LICENSE)
