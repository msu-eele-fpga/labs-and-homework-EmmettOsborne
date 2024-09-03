# Lab 2 Submission for EELE367

>Figured I'd write up a quick reminder doc for git- why not.

## Cloning a github repo

```
git clone [url]
```

>Simple enough, make sure you're cd'd to the directory you want though.

## Git pull

```
git pull
```

>Basic, pulls down a copy of whatever is in the repo to your local machine.

## Branch and naming conventions for this class

**Branch names:** lab-<#>
**Tag names:** lab-<#>-submission

>Don't screw that up, that's the easy part.

## Okay this is taking too long to write out so here's a table of it all

>Quick table of the basics incase you're forgot already...

| Git Command | Description |
|---|---|
|'git init'|Initializes a new git repo in your current directory|
|'git clone'|Clones a repo from a non-local source like github to your local machine|
|'git add'|Stages a change|
|'git commit"|Records all the staged changes in the repo with a message|
|'git push"|Uploads local repo content to that non-local source like github|
|'git pull'|Fetches content from that non-local source|
|'git branch'|Lists, creates, or deletes branches|
|'git checkout'|Switch between branches like a code monkey|
|'git merge'|Merges branches by trying its best to smash all the changes into one big branch|
|'git log'|Shows ya the commit history|

>So remember...

1. 'git pull'
2. 'git branch -c [branchname]'
3. 'git checkout [branchname]'
4. Atomic commits:
  1. 'git pull'
  2. Make your funny little changes
  3. 'git add'
  4. 'git commit'
  5. 'git push'
5. 'git push --set-upstream origin [branchname]'
6. 'git checkout main'
7. 'git merge [branchname]'
8. 'git tag -a [branchname]-submission -m "Tag message"'
9. 'git push'
10. 'git push --tags'

>I would do an unordered list but consitering everything important in this is ordered I feel I shouldn't. Order is important. Dock me I dare u

Here's a motivational article about Atomic Commits because trust me, I need the motivation: [Dev Article](https://dev.to/samuelfaure/how-atomic-git-commits-dramatically-increased-my-productivity-and-will-increase-yours-too-4a84 "man I really dislike committing so much but I get it yaknow? hope u see this <3")

And a photo of our repo setup!
<p align="center">
<img src=./images/repository_setup_1repo.png width=25%>
</p>

[Okay now that you've gone over all that, do it again I wasn't listening](#lab-2-submission-for-eele367)

