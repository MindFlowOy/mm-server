# MirrorMonkey development environment

**Mapping  auth module for dev time:**

        In "auth"-directory
            npm link

        In "server" dir
            npm link mf-auth-api

**Base node installation:**

        http://nodejs.org/download/ or even better https://github.com/creationix/nvm

        [sudo] npm install nodemon -g

        [sudo] npm install coffee-script -g

        [sudo] npm install -g markdox

**Building, testing etc...**

        make-dev

        make-prod

        make-test

        make deploy

        or just type

        make

        for more commands
