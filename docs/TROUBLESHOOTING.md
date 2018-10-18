# Troubleshooting

**Cabal-helper-wrapper can't install cabal**

Drop in to the nix-shell for the project and run `cabal new-update`.

**I'm getting an error in an existing file saying that I need to enable a language pragma**

Drop in to the nix-shell for the project and run `cabal new-udpate`.

**The plugin seems to have stopped working**

Yeah, it currently crashes a bit. It doesn't seem to handle file creation or deletion very well, nor updating the PROJECT_NAME.{nix|cabal} files. Hopefully this improves over time, this is still a very young plugin.

This can sometimes also *seem* to occur if there is a specific problem in another file, such as a non-existant import, thankfully the fix there is to just fix up the issue at the source, but it might not be obvious why the file you're currently looking at isn't getting type-checked.

**'Setup: Encountered missing dependencies' when running `nix-build`**

You've added a dependency to the cabal file, but haven't regenerated the nix experession describing this package. Run the `./bin/update-derivation` script and try again.

**'GHC: Can't find a pacakge database' during `nix-build`**

This can happen if you jump back and forth between `cabal new-*` and `nix-build`. Just delete the `.ghc.environment.*` file and try nix-build again.

```
Loaded package environment from /private/tmp/nix-build-my-awesome-ws-0.0.1.drv-0/my-awesome-ws/.ghc.environment.x86_64-darwin-8.4.3
ghc: can't find a package database at /private/tmp/nix-build-my-awesome-ws-0.0.1.drv-0/my-awesome-ws/dist-newstyle/packagedb/ghc-8.4.3
builder for '/nix/store/v75i0a3p899imjzh9a9x4lig2wk4fi58-my-awesome-ws-0.0.1.drv' failed with exit code 1
```
