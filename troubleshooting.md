---
title: Troubleshooting
---

*Starting advice from <https://nasa-openscapes.github.io/2021-Cloud-Hackathon/logistics/github-workflows.html#git-update-revert-etc>*

## JupyterHub

**Not a git repository** - in your terminal if you see the following, you likely need to `cd` change directory into your GitHub folder.

```{.bash}
fatal: not a git repository (or any parent up to mount point /home)
Stopping at filesystem boundary (GIT_DISCOVERY_ACROSS_FILESYSTEM not set).
```

## Git: update, revert, etc

These are some useful commands to revert/delete your local changes and update your fork with the most recent information from the main branch.

### Delete your local changes

There are several ways to delete your local changes if you were playing around and want to reset. Here are a few: 

#### Undo changes you've maybe saved or committed, but not pushed 

This is less time and internet intensive (no new clone/download). 

If you've got changes saved, but not yet staged, committed, or pushed, you'll delete unstaged changes in the working directory with clean:

You'll need to make sure you're in the github repository (use `pwd` to check your present working directory and `cd` to change directory)

```{.bash}
git clean -df
git checkout -- .
```


#### Burn it all down

You'll delete the whole repo that you have locally, and then reclone. 

You'll need to make sure you're in the github repository (use `pwd` to check your present working directory and `cd` to change directory)

```{.bash}
rm -rf YOUR-REPO
```

Here is a whole blog on how to go back in time (walk back changes), with conceptual diagrams, command line code, and screenshots from RStudio. <https://ohi-science.org/news/github-going-back-in-time>

### Update local branch with remote main branch

If while you're working you would like to update your local
`your-branch` with the most recent updates on the `main` branch on
GitHub.com, there are several ways to do this. Here's one.

```{.bash}
git checkout your-branch
git fetch
git merge origin/main
```

### Update from main
