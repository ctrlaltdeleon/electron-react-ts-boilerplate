# Instructions to transfer online to offline

Think of your project like a toy box. The code is the toys. The caches are the batteries.
If you move only the toys, the toys will not turn on. So we move the toys AND the batteries.

# Goal

Move your Electron + React + TS project from an online Ubuntu 22 machine to an offline Ubuntu 22 machine and still be able to:

- Install dependencies without internet
- Run the app in dev mode
- Build a distributable app

# What you need to keep the same

- Same OS: Ubuntu 22
- Same CPU arch: usually x86_64
- Same Node major: Node 18
- Same lockfile: package-lock.json

# Quick checklist (what to transfer)

- Your project source (this repo)
- `package.json + package-lock.json`
- `.npm-cache/`
- `.electron-cache/`
- `.electron-builder-cache/`

# One-time project setup (should already be done)

1. Pin Node 18 in the repo
   1. `echo "18" > .nvmrc`

2. Enforce Node 18 in package.json
   1. `"engines": { "node": "18.x" }`

3. Align Node types to Node 18
   1. `"@types/node": "18.19.0"`

This will change if Node changes!

# Online machine (with internet) - Build the bundle

These steps fill your caches with everything the offline machine needs.

1. Make sure Node 18 is installed

```
node -v
npm -v
```

2. Clean install once

```
rm -rf node_modules
npm ci
```

3. Make a project-local npm cache and fill it

```
mkdir -p .npm-cache
npm config set cache "$(pwd)/.npm-cache" --location=project
rm -rf node_modules
npm ci
```

4. Cache Electron + electron-builder downloads

```
mkdir -p .electron-cache .electron-builder-cache
export ELECTRON_CACHE="$(pwd)/.electron-cache"
export ELECTRON_BUILDER_CACHE="$(pwd)/.electron-builder-cache"
npm run build
npm run dist
```

5. Make a transfer bundle (tarball)

```
tar -czf electron-react-ts-offline.tar.gz \
. \
--exclude=node_modules \
--exclude=dist \
--exclude=release
```

6. Now you should have a `electron-react-ts-offline.tar.gz` to import

# Offline machine - Restore and run

1. Extract the bundle to where you'd like

```
mkdir -p ~/some/directory/you/want
cd ~/some/directory/you/want
cp /path/to/electron-react-ts-offline.tar.gz .
tar -xzf electron-react-ts-offline.tar.gz
```

2. Verify Node 18

```
node -v
npm -v
```

3. Use the local npm cache

```
npm config set cache "$(pwd)/.npm-cache" --location=project
```

4. Install dependencies without internet

```
rm -rf node_modules
npm ci --offline --prefer-offline --no-audit
```

5. Make sure Electron caches are used

```
export ELECTRON_CACHE="$(pwd)/.electron-cache"
export ELECTRON_BUILDER_CACHE="$(pwd)/.electron-builder-cache"
```

6. Run it

```
npm run dev
```

# Offline machine going forward

- Run

```
./offline-env.sh
npm run dev
```

# If something fails...

- Wrong Node version?
  - Install Node 18, then try again.
- Missing cache files?
  - Repeat the "Online machine" steps and re-copy the tarball.
- Native build errors?
  - Install build tools on the offline machine via `sudo apt-get install -y build-essential python3 make g++`
