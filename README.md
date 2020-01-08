# golang-release-action
Build golang code for various architectures and upload to github release page


example workflows yaml: .github/workflows/release.yml
------------------------------------

```yaml
on: release
name: Build release package
jobs:
  linux-amd64:
    name: linux-amd64
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: build,gzip and release
      uses: masahide/golang-release-action@master
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        GOARCH: amd64
        GOOS: linux
  darwin-amd64:
    name: darwin-amd64
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: build,gzip and release
      uses: masahide/golang-release-action@master
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        GOARCH: amd64
        GOOS: darwin
  windows-amd64:
    name: windows-amd64
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: build,gzip and release
      uses: masahide/golang-release-action@master
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        GOARCH: amd64
        GOOS: windows
```

env params
------------

```
$GITHUB_TOKEN       - secrets.GITHUB_TOKEN

$GOOS and $GOARCH   - The name of the target operating system and compilation architecture. 
                      https://golang.org/doc/install/source#environment

$BUILD_DIR          - `go build` execution directory (default: repository root)

$BIN_NAME           - Build target filename
```
