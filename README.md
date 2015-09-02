# woot

Core library for creating real time collaborative documents without Operational
transformation (WOOT). This package provides the core logic and data types for building a server capable and handling real time editing with WOOT.

[Reference](https://hal.inria.fr/inria-00071240/document)

Install

```
$ cabal install woot
```

Test

```
cabal test
```

Notes:

* Haskell server is a passive peer in the process
* only needs a remote integration function

* https://github.com/kroky/woot/blob/master/src/woot.coffee
* https://bitbucket.org/d6y/woot

TODO:

* ci
* docs
* examples

* Expose data types like `Operation` and `WChar` from core export (and evaluate core exports)
* Have `sendOperation` take the client as the first arg
* Expose a `buildOperation` function to build ops (return `Maybe`)
* Consider ditching `sendLocalOperation` in favor of building ops (easier to tell user if building the operation failed)
