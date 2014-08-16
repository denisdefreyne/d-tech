# D Tech

_D Tech_ is the name of my 2D game engine.

The name is a lame pun on [id Tech](http://en.wikipedia.org/wiki/Id_Tech). I apologise.

Documentation is currently non-existent. I apologise.

## Adding to an existing repository

    git remote add -f d-tech git@github.com:ddfreyne/d-tech
    git merge -s ours --no-commit d-tech/master
    git read-tree --prefix=vendor/d-tech -u d-tech/master
    git ci -m 'Use d-tech'

## Updating to the current revision

    # only if you didn't add the remote before
    git remote add d-tech git@github.com:ddfreyne/d-tech
    git fetch d-tech
    git subtree pull --prefix vendor/d-tech d-tech master
