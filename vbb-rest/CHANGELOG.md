<!-- https://developers.home-assistant.io/docs/add-ons/presentation#keeping-a-changelog -->

## 1.0.2

- Use alpine's `nodejs-current` package instead of copying the official Node.js binaries. Alpine's regular `nodejs` package still ships 24.17.0, which contains a [regression](https://github.com/nodejs/node/pull/63834) breaking HAFAS requests.

## 1.0.1

- Bump base image to 3.24

## 1.0.0

- Initial release, based on [vbb-rest 6](https://github.com/derhuerst/vbb-rest/tree/6).
