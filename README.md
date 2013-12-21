# MirrorMonkey development environment

**Mapping  auth module for dev time:**

        In "auth"-directory
            npm link

        In "mm" dir
            npm link mf-auth-api
            and later when not needed anymore:
            npm unlink mf-auth-api

**Base node installation:**

        http://nodejs.org/download/ or even better https://github.com/creationix/nvm

        [sudo] npm install nodemon -g

        [sudo] npm install coffee-script -g

        [sudo] npm install -g markdox

**Building, testing etc...**

        Notifications for tests (optional?)
            First test if you have 'watch'-command in your shell, if not then install it from https://github.com/visionmedia/watch
            Then test if you have 'terminal-notifier' installed and if not then run
            >brew install terminal-notifier

        make run-dev

        make run-prod

        make test

        make test-cov-html

            brove to http://localhost:8000/test/coverage.html

        make deploy

        or just type

        make

        to see more commands
